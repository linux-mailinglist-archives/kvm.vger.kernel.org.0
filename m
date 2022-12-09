Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB33647D07
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 05:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiLIEqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 23:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiLIEqT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 23:46:19 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9985E7D061
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 20:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670561178; x=1702097178;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4xUO3zSqKlDiMlx0H9cA+3d/VE4hWH0/ryELl87I14E=;
  b=B5WDxtgKebtjRaAb+PzZ5HQtCE9Ad4GITbzabhOFtg5nf4R0/hkr5jsh
   Yz2CWxKsk4tVP4P8FbnEvyHAJTonpznpFyC3HaGnNn5ki6Hx1J3It8oZj
   vnk+08AggCXfKhuW6Hie7R8AWsv51s7+c3levLnoluX/h03+v52ww6MNp
   u6s+msPOs9E+VWjLL6m6vn+3P3uRyRPxdaL/fpj5GvHDFqbtzQuLBwf4g
   tdLiD9QnQ0szJWeKfSFUD2ANp2Kf4DTQspzuGUAQvYZGr4sBrXLzRHaf/
   08rSKnnlL11wgmyxAaL9xJwFEr/J7Qpvjpu+eDjZHxil9hC35YQr8KYpR
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318530868"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="318530868"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 20:46:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="892524470"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="892524470"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 08 Dec 2022 20:46:16 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Cc:     Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v3 8/9] KVM: x86: When guest set CR3, handle LAM bits semantics
Date:   Fri,  9 Dec 2022 12:45:56 +0800
Message-Id: <20221209044557.1496580-9-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221209044557.1496580-1-robert.hu@linux.intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 48a2ad1e4cd6..6fbe8dd36b1e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1248,9 +1248,9 @@ static bool kvm_is_valid_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
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
@@ -1263,6 +1263,10 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	if (cr3 == kvm_read_cr3(vcpu) && !is_pae_paging(vcpu))
 		goto handle_tlb_flush;
 
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_LAM) &&
+	    (cr3 & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57)))
+		return	1;
+
 	/*
 	 * Do not condition the GPA check on long mode, this helper is used to
 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
@@ -1274,8 +1278,20 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
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

