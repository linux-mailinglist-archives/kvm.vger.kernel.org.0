Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7943BA599
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhGBWIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:08:52 -0400
Received: from mga17.intel.com ([192.55.52.151]:15270 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233551AbhGBWIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:08:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="189168394"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="189168394"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:30 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814869"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:30 -0700
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
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 57/69] KVM: VMX: Move register caching logic to common code
Date:   Fri,  2 Jul 2021 15:05:03 -0700
Message-Id: <088bc637ef2c0f40f33a3f7c6a8ed0ed844ad111.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
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
 arch/x86/kvm/vmx/main.c | 37 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c  | 42 +----------------------------------------
 2 files changed, 37 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 0d8d2a0a2979..b619615f77de 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -341,7 +341,42 @@ static void vt_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 
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
index e315a46d1566..3c3bfc80d2bb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2326,46 +2326,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -3066,7 +3026,7 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
-		vmx_cache_reg(vcpu, VCPU_EXREG_CR3);
+		kvm_x86_ops.cache_reg(vcpu, VCPU_EXREG_CR3);
 	if (!(cr0 & X86_CR0_PG)) {
 		/* From paging/starting to nonpaging */
 		exec_controls_setbit(vmx, CPU_BASED_CR3_LOAD_EXITING |
-- 
2.25.1

