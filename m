Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BFF2B4F4D
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388309AbgKPS2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:28:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:48445 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388288AbgKPS2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:17 -0500
IronPort-SDR: Bd/d/zA8HEltzwF3/gwdHvQ1M89TiZ5gNiZ+HooTzRF7/Viw1W+nH61ldtXoYaAsh8Verlkwpt
 IWqNyL58ozPA==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="157819182"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="157819182"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:16 -0800
IronPort-SDR: CQUW8HacZbxTSsGpxKVPH/IccyLvj2IEb1u1dKSnjmwAF/uppcw7UKZzOu6uZICDCyTHdyk/cU
 PcXYCZHY+fhQ==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528262"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:16 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 51/67] KVM: VMX: Move register caching logic to common code
Date:   Mon, 16 Nov 2020 10:26:36 -0800
Message-Id: <df0336877136fb9c82728e1c6e2b65124bfdf7c9.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
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
---
 arch/x86/kvm/vmx/main.c | 37 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c  | 42 +----------------------------------------
 2 files changed, 37 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 52e7a9d25e9c..30b1815fd5a7 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -347,7 +347,42 @@ static void vt_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 
 static void vt_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 {
-	vmx_cache_reg(vcpu, reg);
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
+		if (is_unrestricted_guest(vcpu) ||
+		    (enable_ept && is_paging(vcpu)))
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
index f6b2ddff58e1..85401a7eef9a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2211,46 +2211,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return ret;
 }
 
-static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
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
-		if (is_unrestricted_guest(vcpu) ||
-		    (enable_ept && is_paging(vcpu)))
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
 static __init int vmx_disabled_by_bios(void)
 {
 	return !boot_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
@@ -2976,7 +2936,7 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
-		vmx_cache_reg(vcpu, VCPU_EXREG_CR3);
+		kvm_x86_ops.cache_reg(vcpu, VCPU_EXREG_CR3);
 	if (!(cr0 & X86_CR0_PG)) {
 		/* From paging/starting to nonpaging */
 		exec_controls_setbit(vmx, CPU_BASED_CR3_LOAD_EXITING |
-- 
2.17.1

