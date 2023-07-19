Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D1E7598AB
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 16:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbjGSOlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 10:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjGSOlo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 10:41:44 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3F81711;
        Wed, 19 Jul 2023 07:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689777703; x=1721313703;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iMZGhSC0LO8GBASW3qwjUMlP+viiOicX8QiNc1Cw2iw=;
  b=CIgkPWZ3Z4y0pHAHE1RNoa87i+43iCkS/KdrMjksAyhrPuNHUPm26Ghh
   NmEa/CIEV7RJtEw0ACDt6nRAimznka5q1J+rBx8040wWioNvFwm48VDZE
   DWjLYI0fIVE1J5uy82hzn6R73BSTkeqPKhho1Qqlhf3mjU79fs4hIzdIC
   Y5TeRL2xSUbgQ0GTwYoeUVtmFSc73aapcSqm4OyVzEILVx73U6qe18O05
   QkgmXAzNFZu1Xp8DB9JAhYw5DAJiKxMJEqNCGEz5uNmJ2G12Dm3e+pUrx
   R1rd7/bZ8a50bseAwlbmeiO1Xj4kiQq+iehYI/ys/RMX+W3vYWalIGgCF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="346788140"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="346788140"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 07:41:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="867503254"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.249.173.69])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 07:41:40 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v10 2/9] KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to check CR3's legality
Date:   Wed, 19 Jul 2023 22:41:24 +0800
Message-Id: <20230719144131.29052-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230719144131.29052-1-binbin.wu@linux.intel.com>
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add and use kvm_vcpu_is_legal_cr3() to check CR3's legality to provide
a clear distinction b/t CR3 and GPA checks. So that kvm_vcpu_is_legal_cr3()
can be adjusted according to new feature(s).

No functional change intended.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/kvm/cpuid.h      | 5 +++++
 arch/x86/kvm/svm/nested.c | 4 ++--
 arch/x86/kvm/vmx/nested.c | 4 ++--
 arch/x86/kvm/x86.c        | 4 ++--
 4 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index f61a2106ba90..8b26d946f3e3 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -283,4 +283,9 @@ static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
 	return vcpu->arch.governed_features.enabled & kvm_governed_feature_bit(x86_feature);
 }
 
+static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
+{
+	return kvm_vcpu_is_legal_gpa(vcpu, cr3);
+}
+
 #endif
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 96936ddf1b3c..1df801a48451 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -311,7 +311,7 @@ static bool __nested_vmcb_check_save(struct kvm_vcpu *vcpu,
 	if ((save->efer & EFER_LME) && (save->cr0 & X86_CR0_PG)) {
 		if (CC(!(save->cr4 & X86_CR4_PAE)) ||
 		    CC(!(save->cr0 & X86_CR0_PE)) ||
-		    CC(kvm_vcpu_is_illegal_gpa(vcpu, save->cr3)))
+		    CC(!kvm_vcpu_is_legal_cr3(vcpu, save->cr3)))
 			return false;
 	}
 
@@ -520,7 +520,7 @@ static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
 static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 			       bool nested_npt, bool reload_pdptrs)
 {
-	if (CC(kvm_vcpu_is_illegal_gpa(vcpu, cr3)))
+	if (CC(!kvm_vcpu_is_legal_cr3(vcpu, cr3)))
 		return -EINVAL;
 
 	if (reload_pdptrs && !nested_npt && is_pae_paging(vcpu) &&
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 516391cc0d64..76c9904c6625 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1085,7 +1085,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 			       bool nested_ept, bool reload_pdptrs,
 			       enum vm_entry_failure_code *entry_failure_code)
 {
-	if (CC(kvm_vcpu_is_illegal_gpa(vcpu, cr3))) {
+	if (CC(!kvm_vcpu_is_legal_cr3(vcpu, cr3))) {
 		*entry_failure_code = ENTRY_FAIL_DEFAULT;
 		return -EINVAL;
 	}
@@ -2912,7 +2912,7 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 
 	if (CC(!nested_host_cr0_valid(vcpu, vmcs12->host_cr0)) ||
 	    CC(!nested_host_cr4_valid(vcpu, vmcs12->host_cr4)) ||
-	    CC(kvm_vcpu_is_illegal_gpa(vcpu, vmcs12->host_cr3)))
+	    CC(!kvm_vcpu_is_legal_cr3(vcpu, vmcs12->host_cr3)))
 		return -EINVAL;
 
 	if (CC(is_noncanonical_address(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6b9bea62fb8..6a6d08238e8d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1271,7 +1271,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
 	 * the current vCPU mode is accurate.
 	 */
-	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
+	if (!kvm_vcpu_is_legal_cr3(vcpu, cr3))
 		return 1;
 
 	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
@@ -11449,7 +11449,7 @@ static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 		 */
 		if (!(sregs->cr4 & X86_CR4_PAE) || !(sregs->efer & EFER_LMA))
 			return false;
-		if (kvm_vcpu_is_illegal_gpa(vcpu, sregs->cr3))
+		if (!kvm_vcpu_is_legal_cr3(vcpu, sregs->cr3))
 			return false;
 	} else {
 		/*
-- 
2.25.1

