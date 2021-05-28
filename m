Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4A7394772
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 21:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhE1TNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 May 2021 15:13:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55340 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229481AbhE1TNN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 May 2021 15:13:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622229097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/Ld9bryrSXUxnusgU5zvRKQObiYeibTpKJlbut+Dqgg=;
        b=QOQf8huKr+A6FBB9EEQeA4utv7VN0VU+ThQex0TRjUifabvUk94J8mZz2t7HkaPVxNGSk+
        DqSh/iS0ulVcGUVaYAdosESXtELHFRfs9x993OsX3VkdoQZRDjbg3E41zJjv6iOXe4CLmm
        lSn8+rMqMGJ0GdGrtRb2MuDRex4Ye0o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-usi2BBTiPGuneXgvWYGeCA-1; Fri, 28 May 2021 15:11:36 -0400
X-MC-Unique: usi2BBTiPGuneXgvWYGeCA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D55FC180FD6D;
        Fri, 28 May 2021 19:11:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8317F60CD0;
        Fri, 28 May 2021 19:11:34 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [PATCH] selftests: kvm: fix overlapping addresses in memslot_perf_test
Date:   Fri, 28 May 2021 15:11:34 -0400
Message-Id: <20210528191134.3740950-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The memory that is allocated in vm_create is already mapped close to
GPA 0, because test_execute passes the requested memory to
prepare_vm.  This causes overlapping memory regions and the
test crashes.  For simplicity just move MEM_GPA higher.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/memslot_perf_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 11239652d805..6d28e920b1e3 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -29,7 +29,7 @@
 
 #define MEM_SIZE		((512U << 20) + 4096)
 #define MEM_SIZE_PAGES		(MEM_SIZE / 4096)
-#define MEM_GPA		0x10000000UL
+#define MEM_GPA			(MEM_SIZE + 0x10000000UL)
 #define MEM_AUX_GPA		MEM_GPA
 #define MEM_SYNC_GPA		MEM_AUX_GPA
 #define MEM_TEST_GPA		(MEM_AUX_GPA + 4096)
-- 
2.27.0

