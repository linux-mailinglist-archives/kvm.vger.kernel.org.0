Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7C045D1C3
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353782AbhKYAZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:25:35 -0500
Received: from mga12.intel.com ([192.55.52.136]:16264 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353037AbhKYAYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:33 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="215432245"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="215432245"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:23 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042358"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:23 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v3 46/59] KVM: VMX: Move register caching logic to common code
Date:   Wed, 24 Nov 2021 16:20:29 -0800
Message-Id: <2f3c1207f66f44fdd2f3eb0809d552f5632e4b41.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Move the guts of vmx_cache_reg() to vt_cache_reg() in preparation for
reusing the bulk of the code for TDX, which can access guest state for
debug TDs.

Use kvm_x86_ops.cache_reg() in ept_update_paging_mode_cr0() rather than
trying to expose vt_cache_reg() to vmx.c, even though it means taking a
retpoline.  The code runs if and only if EPT is enabled but unrestricted
guest.  Only one generation of CPU, Nehalem, supports EPT but not
unrestricted guest, and disabling unrestricted guest without also
disabling EPT is, to put it bluntly, dumb.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    | 44 ++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.c     | 45 +-------------------------------------
 arch/x86/kvm/vmx/x86_ops.h |  1 +
 3 files changed, 43 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index ef89ed0457d5..a0a8cc2fd600 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -339,9 +339,47 @@ static void vt_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 	vmx_sync_dirty_debug_regs(vcpu);
 }
 
-static void vt_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
-{
-	vmx_cache_reg(vcpu, reg);
+void vt_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
+{
+	unsigned long guest_owned_bits;
+
+	kvm_register_mark_available(vcpu, reg);
+
+	switch (reg) {
+	case VCPU_REGS_RSP:
+		vcpu->arch.regs[VCPU_REGS_RSP] = vmcs_readl(GUEST_RSP);
+		break;
+	case VCPU_REGS_RIP:
+		vcpu->arch.regs[VCPU_REGS_RIP] = vmcs_readl(GUEST_RIP);
+		break;
+	case VCPU_EXREG_PDPTR:
+		if (enable_ept)
+			ept_save_pdptrs(vcpu);
+		break;
+	case VCPU_EXREG_CR0:
+		guest_owned_bits = vcpu->arch.cr0_guest_owned_bits;
+
+		vcpu->arch.cr0 &= ~guest_owned_bits;
+		vcpu->arch.cr0 |= vmcs_readl(GUEST_CR0) & guest_owned_bits;
+		break;
+	case VCPU_EXREG_CR3:
+		/*
+		 * When intercepting CR3 loads, e.g. for shadowing paging, KVM's
+		 * CR3 is loaded into hardware, not the guest's CR3.
+		 */
+		if (!(exec_controls_get(to_vmx(vcpu)) & CPU_BASED_CR3_LOAD_EXITING))
+			vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
+		break;
+	case VCPU_EXREG_CR4:
+		guest_owned_bits = vcpu->arch.cr4_guest_owned_bits;
+
+		vcpu->arch.cr4 &= ~guest_owned_bits;
+		vcpu->arch.cr4 |= vmcs_readl(GUEST_CR4) & guest_owned_bits;
+		break;
+	default:
+		KVM_BUG_ON(1, vcpu->kvm);
+		break;
+	}
 }
 
 static unsigned long vt_get_rflags(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8b2e57de6627..98710b578b28 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2230,49 +2230,6 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return ret;
 }
 
-void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
-{
-	unsigned long guest_owned_bits;
-
-	kvm_register_mark_available(vcpu, reg);
-
-	switch (reg) {
-	case VCPU_REGS_RSP:
-		vcpu->arch.regs[VCPU_REGS_RSP] = vmcs_readl(GUEST_RSP);
-		break;
-	case VCPU_REGS_RIP:
-		vcpu->arch.regs[VCPU_REGS_RIP] = vmcs_readl(GUEST_RIP);
-		break;
-	case VCPU_EXREG_PDPTR:
-		if (enable_ept)
-			ept_save_pdptrs(vcpu);
-		break;
-	case VCPU_EXREG_CR0:
-		guest_owned_bits = vcpu->arch.cr0_guest_owned_bits;
-
-		vcpu->arch.cr0 &= ~guest_owned_bits;
-		vcpu->arch.cr0 |= vmcs_readl(GUEST_CR0) & guest_owned_bits;
-		break;
-	case VCPU_EXREG_CR3:
-		/*
-		 * When intercepting CR3 loads, e.g. for shadowing paging, KVM's
-		 * CR3 is loaded into hardware, not the guest's CR3.
-		 */
-		if (!(exec_controls_get(to_vmx(vcpu)) & CPU_BASED_CR3_LOAD_EXITING))
-			vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
-		break;
-	case VCPU_EXREG_CR4:
-		guest_owned_bits = vcpu->arch.cr4_guest_owned_bits;
-
-		vcpu->arch.cr4 &= ~guest_owned_bits;
-		vcpu->arch.cr4 |= vmcs_readl(GUEST_CR4) & guest_owned_bits;
-		break;
-	default:
-		KVM_BUG_ON(1, vcpu->kvm);
-		break;
-	}
-}
-
 __init int vmx_disabled_by_bios(void)
 {
 	return !boot_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
@@ -3012,7 +2969,7 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 		 * KVM's CR3 is installed.
 		 */
 		if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
-			vmx_cache_reg(vcpu, VCPU_EXREG_CR3);
+			vt_cache_reg(vcpu, VCPU_EXREG_CR3);
 
 		/*
 		 * When running with EPT but not unrestricted guest, KVM must
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index f04b30f1b72d..c49d6f9f36fd 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -9,6 +9,7 @@
 #include "x86.h"
 
 extern struct kvm_x86_ops vt_x86_ops __initdata;
+void vt_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 
 __init int vmx_disabled_by_bios(void);
 int __init vmx_check_processor_compat(void);
-- 
2.25.1

