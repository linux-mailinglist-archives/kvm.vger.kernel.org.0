Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 855B3DC1D5
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 11:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633165AbfJRJw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Oct 2019 05:52:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:35375 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2633158AbfJRJw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Oct 2019 05:52:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 02:52:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,311,1566889200"; 
   d="scan'208";a="221689678"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.57])
  by fmsmga004.fm.intel.com with ESMTP; 18 Oct 2019 02:52:25 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] KVM: VMX: Move vmcs related resetting out of vmx_vcpu_reset()
Date:   Fri, 18 Oct 2019 17:37:21 +0800
Message-Id: <20191018093723.102471-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20191018093723.102471-1-xiaoyao.li@intel.com>
References: <20191018093723.102471-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move vmcs related codes into a new function vmx_vmcs_reset() from
vmx_vcpu_reset(). So that it's more clearer which data is related with
vmcs and can be held in vmcs.

Suggested-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 65 ++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e660e28e9ae0..ef567df344bf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4271,33 +4271,11 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	}
 }
 
-static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
+static void vmx_vmcs_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct msr_data apic_base_msr;
 	u64 cr0;
 
-	vmx->rmode.vm86_active = 0;
-	vmx->spec_ctrl = 0;
-
-	vmx->msr_ia32_umwait_control = 0;
-
-	vcpu->arch.microcode_version = 0x100000000ULL;
-	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
-	vmx->hv_deadline_tsc = -1;
-	kvm_set_cr8(vcpu, 0);
-
-	if (!init_event) {
-		apic_base_msr.data = APIC_DEFAULT_PHYS_BASE |
-				     MSR_IA32_APICBASE_ENABLE;
-		if (kvm_vcpu_is_reset_bsp(vcpu))
-			apic_base_msr.data |= MSR_IA32_APICBASE_BSP;
-		apic_base_msr.host_initiated = true;
-		kvm_set_apic_base(vcpu, &apic_base_msr);
-	}
-
-	vmx_segment_cache_clear(vmx);
-
 	seg_setup(VCPU_SREG_CS);
 	vmcs_write16(GUEST_CS_SELECTOR, 0xf000);
 	vmcs_writel(GUEST_CS_BASE, 0xffff0000ul);
@@ -4340,8 +4318,6 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (kvm_mpx_supported())
 		vmcs_write64(GUEST_BNDCFGS, 0);
 
-	setup_msrs(vmx);
-
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
 
 	if (cpu_has_vmx_tpr_shadow() && !init_event) {
@@ -4357,19 +4333,52 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (vmx->vpid != 0)
 		vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->vpid);
 
+	vpid_sync_context(vmx->vpid);
+
 	cr0 = X86_CR0_NW | X86_CR0_CD | X86_CR0_ET;
-	vmx->vcpu.arch.cr0 = cr0;
+	vcpu->arch.cr0 = cr0;
 	vmx_set_cr0(vcpu, cr0); /* enter rmode */
 	vmx_set_cr4(vcpu, 0);
-	vmx_set_efer(vcpu, 0);
 
 	update_exception_bitmap(vcpu);
 
-	vpid_sync_context(vmx->vpid);
 	if (init_event)
 		vmx_clear_hlt(vcpu);
 }
 
+static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct msr_data apic_base_msr;
+
+	vmx->rmode.vm86_active = 0;
+	vmx->spec_ctrl = 0;
+
+	vmx->msr_ia32_umwait_control = 0;
+
+	vcpu->arch.microcode_version = 0x100000000ULL;
+	kvm_rdx_write(vcpu, get_rdx_init_val());
+	vmx->hv_deadline_tsc = -1;
+	kvm_set_cr8(vcpu, 0);
+
+	if (!init_event) {
+		apic_base_msr.data = APIC_DEFAULT_PHYS_BASE |
+				     MSR_IA32_APICBASE_ENABLE;
+		if (kvm_vcpu_is_reset_bsp(vcpu))
+			apic_base_msr.data |= MSR_IA32_APICBASE_BSP;
+		apic_base_msr.host_initiated = true;
+		kvm_set_apic_base(vcpu, &apic_base_msr);
+	}
+
+	vmx_segment_cache_clear(vmx);
+
+	setup_msrs(vmx);
+
+	vmx_set_efer(vcpu, 0);
+
+	vmx_vmcs_reset(vcpu, init_event);
+}
+
 static void enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_VIRTUAL_INTR_PENDING);
-- 
2.19.1

