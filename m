Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19E4079ED60
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 17:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjIMPkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 11:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjIMPkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 11:40:04 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A631BD2;
        Wed, 13 Sep 2023 08:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694619598; x=1726155598;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0cTlr1mKrGrpxp1CAfvA2cpfcdMbNRRwGEwG+LbmU24=;
  b=CFwOsHjiNKJO/wzXG/NTkqxsBnqLmMWxEbOKUkA3wGxhmzZWpjht3Rph
   qItzwOw3eAdemjiCqGGCT3wSBXv+u/081YCgp4AF0yi7E2Rk1hDfwypM/
   Dl7C3e0h35U39qMkuxrR+ZVKzXPnN30netc6QRffEpsqjVH209t7UFJat
   yf5L9suJKk8OHhjt9s36BUA813zooZlX3hkFO3gvtCVgQ8pFhYqD6hIVU
   VqV8MvDSOZm/A/2GFjDWbTDZcTiCtfPsTPzUZWAQcz4wGbVcHHR544vTS
   VOKG8+aW1pJh6Ic+etn+tPbqiPQ5w+FmE0jeFXbHWuFk95ebYRfmx8ys0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="376030190"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="376030190"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:39:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="867852095"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="867852095"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.93.2.44])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:39:55 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v11 06/16] KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to check CR3's legality
Date:   Wed, 13 Sep 2023 20:42:17 +0800
Message-Id: <20230913124227.12574-7-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230913124227.12574-1-binbin.wu@linux.intel.com>
References: <20230913124227.12574-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add and use kvm_vcpu_is_legal_cr3() to check CR3's legality to provide
a clear distinction b/t CR3 and GPA checks. So that kvm_vcpu_is_legal_cr3()
can be adjusted according to new features.

No functional change intended.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/cpuid.h      | 5 +++++
 arch/x86/kvm/svm/nested.c | 4 ++--
 arch/x86/kvm/vmx/nested.c | 4 ++--
 arch/x86/kvm/x86.c        | 4 ++--
 4 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 284fa4704553..ca1fdab31d1e 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -278,4 +278,9 @@ static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
 			vcpu->arch.governed_features.enabled);
 }
 
+static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
+{
+	return kvm_vcpu_is_legal_gpa(vcpu, cr3);
+}
+
 #endif
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index dd496c9e5f91..c63aa6624e7f 100644
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
index c5ec0ef51ff7..db61cf8e3128 100644
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
index 6c9c81e82e65..ea48ba87dacf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1284,7 +1284,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
 	 * the current vCPU mode is accurate.
 	 */
-	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
+	if (!kvm_vcpu_is_legal_cr3(vcpu, cr3))
 		return 1;
 
 	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
@@ -11468,7 +11468,7 @@ static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
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

