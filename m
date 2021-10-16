Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6541F4300A5
	for <lists+kvm@lfdr.de>; Sat, 16 Oct 2021 08:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239982AbhJPGpR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Oct 2021 02:45:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57848 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234161AbhJPGpQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 16 Oct 2021 02:45:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634366588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=H9PD86CwR5nYqF03lqODYpfsY+K3xeFojmjQDbxQ8bg=;
        b=jUa9tBy+7/OoXgMwI5XGuQ9fBigZpOb22ZX+lQJSBZUJ71EsF9CiE77q80WuZ2d6obGcNz
        ivtIsNlzy/xSYnfP742Kbm7Sk2TuNTGjAIvQNDzuv5/vHbTIXj0ak6PCDGo7Fw9+/Ky0KU
        HHDEDf1EGgjJVWkjumX732kdWbpGZn0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-uyRxubjWMUqS6LZC3DClnw-1; Sat, 16 Oct 2021 02:43:05 -0400
X-MC-Unique: uyRxubjWMUqS6LZC3DClnw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6449362F8;
        Sat, 16 Oct 2021 06:43:03 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1ACB5D6D7;
        Sat, 16 Oct 2021 06:43:02 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com,
        Willy Tarreau <w@1wt.eu>, Kees Cook <keescook@chromium.org>,
        syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com
Subject: [PATCH] mm: allow huge kvmalloc() calls if they're accounted to memcg
Date:   Sat, 16 Oct 2021 02:43:02 -0400
Message-Id: <20211016064302.165220-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
restricted memory allocation with 'kvmalloc()' to sizes that fit
in an 'int', to protect against trivial integer conversion issues.

However, the WARN triggers with KVM, when it allocates ancillary page
data whose size essentially depends on whatever userspace has passed to
the KVM_SET_USER_MEMORY_REGION ioctl.  The warnings are easily raised by
syzkaller, but the largest allocation that KVM can do is 8 bytes per page
of guest memory; therefore, a 1 TiB memslot will cause a warning even
outside fuzzing, and those allocations are known to happen in the wild.
Google for example already has VMs that create 1.5tb memslots (12tb of
total guest memory spread across 8 virtual NUMA nodes).

Use memcg accounting as evidence that the crazy large allocations are
expected---in which case, it is indeed a good idea to have them
properly accounted---and exempt them from the warning.

Cc: Willy Tarreau <w@1wt.eu>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	Linus, what do you think of this?  It is a bit of a hack,
	but the reasoning in the commit message does make at least
	some sense.

	The alternative would be to just use __vmalloc in KVM, and add
	__vcalloc too.	The two underscores would suggest that something
	"different" is going on, but I wonder what you prefer between
	this and having a __vcalloc with 2-3 uses in the whole source.

 mm/util.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/util.c b/mm/util.c
index 499b6b5767ed..31fca4a999c6 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -593,8 +593,12 @@ void *kvmalloc_node(size_t size, gfp_t flags, int node)
 	if (ret || size <= PAGE_SIZE)
 		return ret;
 
-	/* Don't even allow crazy sizes */
-	if (WARN_ON_ONCE(size > INT_MAX))
+	/*
+	 * Don't even allow crazy sizes unless memcg accounting is
+	 * request.  We take that as a sign that huge allocations
+	 * are indeed expected.
+	 */
+	if (likely(!(flags & __GFP_ACCOUNT)) && WARN_ON_ONCE(size > INT_MAX))
 		return NULL;
 
 	return __vmalloc_node(size, 1, flags, node,
-- 
2.27.0

