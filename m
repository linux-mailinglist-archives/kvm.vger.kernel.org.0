Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E50B62433B
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 14:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbiKJN30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 08:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbiKJN3V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 08:29:21 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0A371F08
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 05:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668086957; x=1699622957;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OwNb7EWZ/D4O23AtKTyi4Vi9E7GSZioQI5bewLzybCk=;
  b=fJnSsbrmUGKMJg75XdqR4guuF27HbmHmXWnXx7t+iIC45C/jFLMybvym
   DQfVtOH6BxGwzllkLGvcfJoYo8/bT2ZLC2ACik3/ooH/+mgfsIDcR+MBw
   5CybNQ+L2yR4D5K9bICDYK7H9vaICn/0SjHHnDrgahMTMv3OusliBAIaO
   mdqv2wGQPZpYzEVlzlUybFdfS2kDiL26VT4bc2eBQ72BIQtQmb4CVospW
   mkBP/0RYg9lQSqifVq+iN39Io3YtG1simdhRBRLZlkwE6OvcMkdDTJ4RA
   exRBKRjF2f9fm33I78rJ+N20uXTvfUgYruNXGeHhQS4Ekj4huOwizCIQg
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="311306363"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="311306363"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 05:29:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="812038349"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="812038349"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga005.jf.intel.com with ESMTP; 10 Nov 2022 05:29:15 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com
Cc:     kvm@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v2 8/9] KVM: x86: When guest set CR3, handle LAM bits semantics
Date:   Thu, 10 Nov 2022 21:28:47 +0800
Message-Id: <20221110132848.330793-9-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221110132848.330793-1-robert.hu@linux.intel.com>
References: <20221110132848.330793-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When only changes LAM bits, ask next vcpu run to load mmu pgd, so that it
will build new CR3 with LAM bits updates. No TLB flush needed on this case.
When changes on effective addresses, no matter LAM bits changes or not, go
through normal pgd update process.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/x86.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5130142fd66d..98890c5506da 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1242,9 +1242,9 @@ static bool kvm_is_valid_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	bool skip_tlb_flush = false;
-	unsigned long pcid = 0;
+	unsigned long pcid = 0, old_cr3;
 #ifdef CONFIG_X86_64
-	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
+	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
 
 	if (pcid_enabled) {
 		skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;
@@ -1257,6 +1257,10 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	if (cr3 == kvm_read_cr3(vcpu) && !is_pae_paging(vcpu))
 		goto handle_tlb_flush;
 
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_LAM) &&
+	    (cr3 & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57)))
+		return	1;
+
 	/*
 	 * Do not condition the GPA check on long mode, this helper is used to
 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
@@ -1268,8 +1272,20 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
 		return 1;
 
-	if (cr3 != kvm_read_cr3(vcpu))
-		kvm_mmu_new_pgd(vcpu, cr3);
+	old_cr3 = kvm_read_cr3(vcpu);
+	if (cr3 != old_cr3) {
+		if ((cr3 ^ old_cr3) & CR3_ADDR_MASK) {
+			kvm_mmu_new_pgd(vcpu, cr3 & ~(X86_CR3_LAM_U48 |
+					X86_CR3_LAM_U57));
+		} else {
+			/*
+			 * Though effective addr no change, mark the
+			 * request so that LAM bits will take effect
+			 * when enter guest.
+			 */
+			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
+		}
+	}
 
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
-- 
2.31.1

