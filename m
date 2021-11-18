Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03AFD455ACF
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343986AbhKRLo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:44:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44677 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344157AbhKRLnp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 06:43:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637235644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ilkLwQyWVzoTxezBXpsOqx5haL4+cCYbCvehJdiBMCs=;
        b=SgAvAbPj3mMvVl9p1TtMx0QOkZJeyIUAQRsNNezAub7vKLIZt3hVvwr2hRbDyJcnAF+cxX
        5KEh1fx0z0j7qFSjozMojrqo1rmqMOfPQdzHY3mGW6VKZ0xxzIn0my8BleB2l//sS/0xfU
        U/owFns7ORXPmsveYz1m2u3TndGILgs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-216-_Z8H5PfvMBKlKzrbB1aG3Q-1; Thu, 18 Nov 2021 06:40:41 -0500
X-MC-Unique: _Z8H5PfvMBKlKzrbB1aG3Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DE9D1572B;
        Thu, 18 Nov 2021 11:40:40 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3A93179B3;
        Thu, 18 Nov 2021 11:40:39 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, mlevitsk@redhat.com
Subject: [PATCH v3] KVM: MMU: update comment on the number of page role combinations
Date:   Thu, 18 Nov 2021 06:40:39 -0500
Message-Id: <20211118114039.1733976-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the number of bits in the role, and simplify the explanation of
why several bits or combinations of bits are redundant.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6ac61f85e07b..55f280e96b59 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -291,19 +291,27 @@ struct kvm_kernel_irq_routing_entry;
  * the number of unique SPs that can theoretically be created is 2^n, where n
  * is the number of bits that are used to compute the role.
  *
- * But, even though there are 18 bits in the mask below, not all combinations
- * of modes and flags are possible.  The maximum number of possible upper-level
- * shadow pages for a single gfn is in the neighborhood of 2^13.
+ * There are 19 bits in the mask below, and the page tracking code only uses
+ * 16 bits per gfn in kvm_arch_memory_slot to count whether a page is tracked.
+ * However, not all combinations of modes and flags are possible.  First
+ * of all, invalid shadow pages pages are not accounted, and "smm" is constant
+ * in a given memslot (because memslots are per address space, and SMM uses
+ * a separate address space).  Of the remaining 2^17 possibilities:
  *
- *   - invalid shadow pages are not accounted.
- *   - level is effectively limited to four combinations, not 16 as the number
- *     bits would imply, as 4k SPs are not tracked (allowed to go unsync).
- *   - level is effectively unused for non-PAE paging because there is exactly
- *     one upper level (see 4k SP exception above).
- *   - quadrant is used only for non-PAE paging and is exclusive with
- *     gpte_is_8_bytes.
- *   - execonly and ad_disabled are used only for nested EPT, which makes it
- *     exclusive with quadrant.
+ *   - quadrant will only be used if gpte_is_8_bytes=0 (non-PAE paging);
+ *     execonly and ad_disabled are only used for nested EPT which has
+ *     gpte_is_8_bytes=1.  Therefore, 2 bits are always unused.
+ *
+ *   - the 4 bits of level are effectively limited to the values 2/3/4/5,
+ *     as 4k SPs are not tracked (allowed to go unsync).  In addition non-PAE
+ *     paging has exactly one upper level, making level completely redundant
+ *     when gpte_is_8_bytes=0.
+ *
+ *   - on top of this, smep_andnot_wp and smap_andnot_wp are only set if
+ *     cr0_wp=0, therefore these three bits only give rise to 5 possibilities.
+ *
+ * Therefore, the maximum number of possible upper-level shadow pages for a
+ * given (as_id, gfn) pair is a bit less than 2^12.
  */
 union kvm_mmu_page_role {
 	u32 word;
-- 
2.27.0

