Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF281E9FFA
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 10:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgFAIVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 04:21:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23791 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726142AbgFAIVv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 04:21:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590999710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=59Xri5z2WaS+00aj02VDCABWd90XAuhG4yZyC959x+8=;
        b=SFDKu3m98Ql1gLMzpWZDfRJHDi3Q7npEWEM+oeqiYOREHFdhs4JbH1mYN8/qg4jsgKO9EQ
        VlAPYWss6ptrr9mO5GrNLKIj/Cy0nK5HFyt7PsvBmxQaUGEINelojJPaomzPPzDFvCaNub
        N+9bN8FyNTx3uwbHFx6QJsrvbwxRuAw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-9bZyvJ5BMiGy1PQhamh2Lw-1; Mon, 01 Jun 2020 04:21:48 -0400
X-MC-Unique: 9bZyvJ5BMiGy1PQhamh2Lw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B0048463A1;
        Mon,  1 Jun 2020 08:21:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0709861985;
        Mon,  1 Jun 2020 08:21:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] KVM: check userspace_addr for all memslots
Date:   Mon,  1 Jun 2020 04:21:46 -0400
Message-Id: <20200601082146.18969-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The userspace_addr alignment and range checks are not performed for private
memory slots that are prepared by KVM itself.  This is unnecessary and makes
it questionable to use __*_user functions to access memory later on.  We also
rely on the userspace address being aligned since we have an entire family
of functions to map gfn to pfn.

Fortunately skipping the check is completely unnecessary.  Only x86 uses
private memslots and their userspace_addr is obtained from vm_mmap,
therefore it must be below PAGE_OFFSET.  In fact, any attempt to pass
an address above PAGE_OFFSET would have failed because such an address
would return true for kvm_is_error_hva.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 731c1e517716..08184f571669 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1223,10 +1223,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (mem->guest_phys_addr & (PAGE_SIZE - 1))
 		return -EINVAL;
 	/* We can read the guest memory with __xxx_user() later on. */
-	if ((id < KVM_USER_MEM_SLOTS) &&
-	    ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
+	if ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
 	     !access_ok((void __user *)(unsigned long)mem->userspace_addr,
-			mem->memory_size)))
+			mem->memory_size))
 		return -EINVAL;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_MEM_SLOTS_NUM)
 		return -EINVAL;
-- 
2.26.2

