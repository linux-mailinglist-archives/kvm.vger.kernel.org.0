Return-Path: <kvm+bounces-37938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8831AA31B7D
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 02:48:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AC2A165AC6
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 01:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCDD570809;
	Wed, 12 Feb 2025 01:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r/l/Q03y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EE5A50
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 01:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739324879; cv=none; b=eS/ccaSSAf0TkWpba2W4od2vXuJtXtaI6YFgYVw0toX81O740G6kn1LvOu0VMK7zGVCVQldNNqom0U8dPiKhoZpoazeny3/9jOJRxC0AEvt5Vcgyb2GGTosLoMCQl5GAal6eSVYXlzdiIazFHwFv52brNrP9PoeQFh2auD/pKpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739324879; c=relaxed/simple;
	bh=xOc1PVLA6VdEtTgkyb1mBcPkdmKrAiMHwEUuc1ezmYQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sFy9XTfmmprQTYuHiUQjKYY7TYU+K/f/E8WVPQDzpDmVi+Pz1b7X5ccJfXohLKRow7eJFLZU6Sb9IP25j7ee0S7nWsr6YaKRyYN2UWpjzUHM+XMBax+20ZKCiwyJqkCq3b1hyQ7KSbpq4I+CgkgpQI+KLS5/O9vDX9nXSpEfH58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r/l/Q03y; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fa668c0d35so6086569a91.1
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 17:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739324876; x=1739929676; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6nVKiMGCDXXZOuVqVxQDPcADaNnzL5uaH4VUbsw1tcc=;
        b=r/l/Q03yE6fDj2R8dK78HM8uyRdPpxPaGQLHlFFz5eH7fqfzTynNVFqcf2juJe1r2w
         PBXa7H0PdU37Q5ihzo/2+Sgud0Fv7F7erU/lkWOnobUSdfTxkaSSOMm+aqmLtATEkcNp
         JtXKfgjI2x1/ucVfCuc5mOtRwo3OeAd8odd58KOTNqbYo+YVvRWP6fxFe38NGhZmIASJ
         +9bswFVT/VRHsWPBRBhZ3C/PpzYJTVL5rG28gnoEP7Q/9Y0D7znL2oOH49WRNP5KorPB
         4RmYBK5tmouvuNUfCdNCdYh8Ae16YQG9e9m+XwlRjCTu0yjoY2u2LbCJ+u5QF1TJTUDW
         FbOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739324876; x=1739929676;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6nVKiMGCDXXZOuVqVxQDPcADaNnzL5uaH4VUbsw1tcc=;
        b=dL8c4hPoIs/821xjWG/hDDnX1dUeY+6DHwM9xWY1OybeINNwA4+IuLGtYwOeoVd67O
         ccvdE4KFnq3Aqsi4Go2sYUwL4rwe/zt4Fuywb1gb4zKvQgPNRvhGKuYlvYkdE5uXxO5S
         jbUp2PqcITAy/QZdRCxXR32aPkBig1+6y6djRgnbWaSHeD4MPybELpGsgq0L/6zFdrqs
         SB8F+Z8Zw3mGlfLLPMq/dl8RjpuQIyeFREJKQViyqB90q6NHG9NhuGqv+6+lMhp3Riud
         AKazPB/HXvA5eTb0Adku/rxLJsnR7zeBLwx0euypEnJtVwaMGi28i2wLEpu6BCd4jOYx
         dEoA==
X-Forwarded-Encrypted: i=1; AJvYcCUzQ6Txa6WECOjGDC6OgYAs4kmGiEySaT/0i3fd4rE/Q8jH0OImExwWEgMUIA+QlsW68JA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXQSjH2wtHe74viPDBbDxt+0tEd4d/YaCiiT2bQ+MsyBsxQCGH
	v68AExu/MOGF94E6wlzkfG80F3lO9933gsm0sl++IrO8yf8aVNmVOn2WmY5U1YC3aMGMsbLHIbU
	rmQ==
X-Google-Smtp-Source: AGHT+IHhva2WxIhkzcAgghf1XGYv5Wh4P42yFeN6Qyd6bmu4raTXjQptMHUEzLZs72jCAKPPQQFCRX4YWZw=
X-Received: from pjtd15.prod.google.com ([2002:a17:90b:4f:b0:2fa:1771:e276])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f8b:b0:2ee:d7d3:3008
 with SMTP id 98e67ed59e1d1-2fbf5bf76d7mr2635380a91.12.1739324876321; Tue, 11
 Feb 2025 17:47:56 -0800 (PST)
Date: Tue, 11 Feb 2025 17:47:54 -0800
In-Reply-To: <20250211025828.3072076-10-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com> <20250211025828.3072076-10-binbin.wu@linux.intel.com>
Message-ID: <Z6v9yjWLNTU6X90d@google.com>
Subject: Re: [PATCH v2 09/17] KVM: TDX: Handle SMI request as !CONFIG_KVM_SMM
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@intel.com, isaku.yamahata@intel.com, 
	yan.y.zhao@intel.com, chao.gao@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 11, 2025, Binbin Wu wrote:
> +#ifdef CONFIG_KVM_SMM
> +static int vt_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
> +{
> +	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
> +		return false;

Nit, while the name suggests a boolean return, the actual return in -errno/0/1,
i.e. this should be '0', not "false".

A bit late to be asking this, but has anyone verified all the KVM_BUG_ON() calls
are fully optimized out when CONFIG_KVM_INTEL_TDX=n?

/me rummages around

Sort of.  The KVM_BUG_ON()s are all gone, but sadly a stub gets left behind.  Not
the end of the world since they're all tail calls, but it's still quite useless,
especially when using frame pointers.

Aha!  Finally!  An excuse to macrofy some of this!

Rather than have a metric ton of stubs for all of the TDX variants, simply omit
the wrappers when CONFIG_KVM_INTEL_TDX=n.  Quite nearly all of vmx/main.c can go
under a single #ifdef.  That eliminates all the silly trampolines in the generated
code, and almost all of the stubs.

Compile tested only, and needs to be chunked up. E.g. switching to the
right CONFIG_xxx needs to be done elsewhere, ditto for moving the "pre restore"
function to posted_intr.c.

---
 arch/x86/kvm/vmx/main.c        | 212 +++++++++++++++++----------------
 arch/x86/kvm/vmx/posted_intr.c |   8 ++
 arch/x86/kvm/vmx/posted_intr.h |   1 +
 arch/x86/kvm/vmx/tdx.h         |   2 +-
 arch/x86/kvm/vmx/x86_ops.h     |  69 +----------
 5 files changed, 121 insertions(+), 171 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index cfffa529c831..fc087fcabd7d 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -10,9 +10,8 @@
 #include "tdx.h"
 #include "tdx_arch.h"
 
-#ifdef CONFIG_INTEL_TDX_HOST
+#ifdef CONFIG_INTEL_KVM_TDX
 static_assert(offsetof(struct vcpu_vmx, vt) == offsetof(struct vcpu_tdx, vt));
-#endif
 
 static void vt_disable_virtualization_cpu(void)
 {
@@ -241,7 +240,7 @@ static int vt_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 	if (is_td_vcpu(vcpu))
 		return tdx_complete_emulated_msr(vcpu, err);
 
-	return kvm_complete_insn_gp(vcpu, err);
+	return vmx_complete_emulated_msr(vcpu, err);
 }
 
 #ifdef CONFIG_KVM_SMM
@@ -316,14 +315,6 @@ static void vt_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 	return vmx_set_virtual_apic_mode(vcpu);
 }
 
-static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
-{
-	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
-
-	pi_clear_on(pi);
-	memset(pi->pir, 0, sizeof(pi->pir));
-}
-
 static void vt_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
 {
 	if (is_td_vcpu(vcpu))
@@ -352,6 +343,15 @@ static void vt_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 	vmx_deliver_interrupt(apic, delivery_mode, trig_mode, vector);
 }
 
+static bool vt_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
+{
+	if (WARN_ON_ONCE(!is_td_vcpu(vcpu)))
+		return false;
+
+	return tdx_protected_apic_has_interrupt(vcpu);
+}
+
+
 static void vt_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -880,6 +880,12 @@ static int vt_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 
 	return 0;
 }
+#define vt_op(name) vt_##name
+#define vt_op_tdx_only(name) vt_##name
+#else /* CONFIG_INTEL_KVM_TDX */
+#define vt_op(name) vmx_##name
+#define vt_op_tdx_only(name) NULL
+#endif
 
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
@@ -898,113 +904,113 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.hardware_unsetup = vmx_hardware_unsetup,
 
 	.enable_virtualization_cpu = vmx_enable_virtualization_cpu,
-	.disable_virtualization_cpu = vt_disable_virtualization_cpu,
+	.disable_virtualization_cpu = vt_op(disable_virtualization_cpu),
 	.emergency_disable_virtualization_cpu = vmx_emergency_disable_virtualization_cpu,
 
-	.has_emulated_msr = vt_has_emulated_msr,
+	.has_emulated_msr = vt_op(has_emulated_msr),
 
 	.vm_size = sizeof(struct kvm_vmx),
 
-	.vm_init = vt_vm_init,
-	.vm_destroy = vt_vm_destroy,
-	.vm_free = vt_vm_free,
+	.vm_init = vt_op(vm_init),
+	.vm_destroy = vt_op(vm_destroy),
+	.vm_free = vt_op_tdx_only(vm_free),
 
-	.vcpu_precreate = vt_vcpu_precreate,
-	.vcpu_create = vt_vcpu_create,
-	.vcpu_free = vt_vcpu_free,
-	.vcpu_reset = vt_vcpu_reset,
+	.vcpu_precreate = vt_op(vcpu_precreate),
+	.vcpu_create = vt_op(vcpu_create),
+	.vcpu_free = vt_op(vcpu_free),
+	.vcpu_reset = vt_op(vcpu_reset),
 
-	.prepare_switch_to_guest = vt_prepare_switch_to_guest,
-	.vcpu_load = vt_vcpu_load,
-	.vcpu_put = vt_vcpu_put,
+	.prepare_switch_to_guest = vt_op(prepare_switch_to_guest),
+	.vcpu_load = vt_op(vcpu_load),
+	.vcpu_put = vt_op(vcpu_put),
 
-	.update_exception_bitmap = vt_update_exception_bitmap,
+	.update_exception_bitmap = vt_op(update_exception_bitmap),
 	.get_feature_msr = vmx_get_feature_msr,
-	.get_msr = vt_get_msr,
-	.set_msr = vt_set_msr,
+	.get_msr = vt_op(get_msr),
+	.set_msr = vt_op(set_msr),
 
-	.get_segment_base = vt_get_segment_base,
-	.get_segment = vt_get_segment,
-	.set_segment = vt_set_segment,
-	.get_cpl = vt_get_cpl,
-	.get_cpl_no_cache = vt_get_cpl_no_cache,
-	.get_cs_db_l_bits = vt_get_cs_db_l_bits,
-	.is_valid_cr0 = vt_is_valid_cr0,
-	.set_cr0 = vt_set_cr0,
-	.is_valid_cr4 = vt_is_valid_cr4,
-	.set_cr4 = vt_set_cr4,
-	.set_efer = vt_set_efer,
-	.get_idt = vt_get_idt,
-	.set_idt = vt_set_idt,
-	.get_gdt = vt_get_gdt,
-	.set_gdt = vt_set_gdt,
-	.set_dr7 = vt_set_dr7,
-	.sync_dirty_debug_regs = vt_sync_dirty_debug_regs,
-	.cache_reg = vt_cache_reg,
-	.get_rflags = vt_get_rflags,
-	.set_rflags = vt_set_rflags,
-	.get_if_flag = vt_get_if_flag,
+	.get_segment_base = vt_op(get_segment_base),
+	.get_segment = vt_op(get_segment),
+	.set_segment = vt_op(set_segment),
+	.get_cpl = vt_op(get_cpl),
+	.get_cpl_no_cache = vt_op(get_cpl_no_cache),
+	.get_cs_db_l_bits = vt_op(get_cs_db_l_bits),
+	.is_valid_cr0 = vt_op(is_valid_cr0),
+	.set_cr0 = vt_op(set_cr0),
+	.is_valid_cr4 = vt_op(is_valid_cr4),
+	.set_cr4 = vt_op(set_cr4),
+	.set_efer = vt_op(set_efer),
+	.get_idt = vt_op(get_idt),
+	.set_idt = vt_op(set_idt),
+	.get_gdt = vt_op(get_gdt),
+	.set_gdt = vt_op(set_gdt),
+	.set_dr7 = vt_op(set_dr7),
+	.sync_dirty_debug_regs = vt_op(sync_dirty_debug_regs),
+	.cache_reg = vt_op(cache_reg),
+	.get_rflags = vt_op(get_rflags),
+	.set_rflags = vt_op(set_rflags),
+	.get_if_flag = vt_op(get_if_flag),
 
-	.flush_tlb_all = vt_flush_tlb_all,
-	.flush_tlb_current = vt_flush_tlb_current,
-	.flush_tlb_gva = vt_flush_tlb_gva,
-	.flush_tlb_guest = vt_flush_tlb_guest,
+	.flush_tlb_all = vt_op(flush_tlb_all),
+	.flush_tlb_current = vt_op(flush_tlb_current),
+	.flush_tlb_gva = vt_op(flush_tlb_gva),
+	.flush_tlb_guest = vt_op(flush_tlb_guest),
 
-	.vcpu_pre_run = vt_vcpu_pre_run,
-	.vcpu_run = vt_vcpu_run,
-	.handle_exit = vt_handle_exit,
+	.vcpu_pre_run = vt_op(vcpu_pre_run),
+	.vcpu_run = vt_op(vcpu_run),
+	.handle_exit = vt_op(handle_exit),
 	.skip_emulated_instruction = vmx_skip_emulated_instruction,
 	.update_emulated_instruction = vmx_update_emulated_instruction,
-	.set_interrupt_shadow = vt_set_interrupt_shadow,
-	.get_interrupt_shadow = vt_get_interrupt_shadow,
-	.patch_hypercall = vt_patch_hypercall,
-	.inject_irq = vt_inject_irq,
-	.inject_nmi = vt_inject_nmi,
-	.inject_exception = vt_inject_exception,
-	.cancel_injection = vt_cancel_injection,
-	.interrupt_allowed = vt_interrupt_allowed,
-	.nmi_allowed = vt_nmi_allowed,
-	.get_nmi_mask = vt_get_nmi_mask,
-	.set_nmi_mask = vt_set_nmi_mask,
-	.enable_nmi_window = vt_enable_nmi_window,
-	.enable_irq_window = vt_enable_irq_window,
-	.update_cr8_intercept = vt_update_cr8_intercept,
+	.set_interrupt_shadow = vt_op(set_interrupt_shadow),
+	.get_interrupt_shadow = vt_op(get_interrupt_shadow),
+	.patch_hypercall = vt_op(patch_hypercall),
+	.inject_irq = vt_op(inject_irq),
+	.inject_nmi = vt_op(inject_nmi),
+	.inject_exception = vt_op(inject_exception),
+	.cancel_injection = vt_op(cancel_injection),
+	.interrupt_allowed = vt_op(interrupt_allowed),
+	.nmi_allowed = vt_op(nmi_allowed),
+	.get_nmi_mask = vt_op(get_nmi_mask),
+	.set_nmi_mask = vt_op(set_nmi_mask),
+	.enable_nmi_window = vt_op(enable_nmi_window),
+	.enable_irq_window = vt_op(enable_irq_window),
+	.update_cr8_intercept = vt_op(update_cr8_intercept),
 
 	.x2apic_icr_is_split = false,
-	.set_virtual_apic_mode = vt_set_virtual_apic_mode,
-	.set_apic_access_page_addr = vt_set_apic_access_page_addr,
-	.refresh_apicv_exec_ctrl = vt_refresh_apicv_exec_ctrl,
-	.load_eoi_exitmap = vt_load_eoi_exitmap,
-	.apicv_pre_state_restore = vt_apicv_pre_state_restore,
+	.set_virtual_apic_mode = vt_op(set_virtual_apic_mode),
+	.set_apic_access_page_addr = vt_op(set_apic_access_page_addr),
+	.refresh_apicv_exec_ctrl = vt_op(refresh_apicv_exec_ctrl),
+	.load_eoi_exitmap = vt_op(load_eoi_exitmap),
+	.apicv_pre_state_restore = pi_apicv_pre_state_restore,
 	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
-	.hwapic_isr_update = vt_hwapic_isr_update,
-	.sync_pir_to_irr = vt_sync_pir_to_irr,
-	.deliver_interrupt = vt_deliver_interrupt,
+	.hwapic_isr_update = vt_op(hwapic_isr_update),
+	.sync_pir_to_irr = vt_op(sync_pir_to_irr),
+	.deliver_interrupt = vt_op(deliver_interrupt),
 	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
-	.protected_apic_has_interrupt = tdx_protected_apic_has_interrupt,
+	.protected_apic_has_interrupt = vt_op_tdx_only(protected_apic_has_interrupt),
 
-	.set_tss_addr = vt_set_tss_addr,
-	.set_identity_map_addr = vt_set_identity_map_addr,
+	.set_tss_addr = vt_op(set_tss_addr),
+	.set_identity_map_addr = vt_op(set_identity_map_addr),
 	.get_mt_mask = vmx_get_mt_mask,
 
-	.get_exit_info = vt_get_exit_info,
-	.get_entry_info = vt_get_entry_info,
+	.get_exit_info = vt_op(get_exit_info),
+	.get_entry_info = vt_op(get_entry_info),
 
-	.vcpu_after_set_cpuid = vt_vcpu_after_set_cpuid,
+	.vcpu_after_set_cpuid = vt_op(vcpu_after_set_cpuid),
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
 
-	.get_l2_tsc_offset = vt_get_l2_tsc_offset,
-	.get_l2_tsc_multiplier = vt_get_l2_tsc_multiplier,
-	.write_tsc_offset = vt_write_tsc_offset,
-	.write_tsc_multiplier = vt_write_tsc_multiplier,
+	.get_l2_tsc_offset = vt_op(get_l2_tsc_offset),
+	.get_l2_tsc_multiplier = vt_op(get_l2_tsc_multiplier),
+	.write_tsc_offset = vt_op(write_tsc_offset),
+	.write_tsc_multiplier = vt_op(write_tsc_multiplier),
 
-	.load_mmu_pgd = vt_load_mmu_pgd,
+	.load_mmu_pgd = vt_op(load_mmu_pgd),
 
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
 
-	.update_cpu_dirty_logging = vt_update_cpu_dirty_logging,
+	.update_cpu_dirty_logging = vt_op(update_cpu_dirty_logging),
 
 	.nested_ops = &vmx_nested_ops,
 
@@ -1012,38 +1018,38 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.pi_start_assignment = vmx_pi_start_assignment,
 
 #ifdef CONFIG_X86_64
-	.set_hv_timer = vt_set_hv_timer,
-	.cancel_hv_timer = vt_cancel_hv_timer,
+	.set_hv_timer = vt_op(set_hv_timer),
+	.cancel_hv_timer = vt_op(cancel_hv_timer),
 #endif
 
-	.setup_mce = vt_setup_mce,
+	.setup_mce = vt_op(setup_mce),
 
 #ifdef CONFIG_KVM_SMM
-	.smi_allowed = vt_smi_allowed,
-	.enter_smm = vt_enter_smm,
-	.leave_smm = vt_leave_smm,
-	.enable_smi_window = vt_enable_smi_window,
+	.smi_allowed = vt_op(smi_allowed),
+	.enter_smm = vt_op(enter_smm),
+	.leave_smm = vt_op(leave_smm),
+	.enable_smi_window = vt_op(enable_smi_window),
 #endif
 
-	.check_emulate_instruction = vt_check_emulate_instruction,
-	.apic_init_signal_blocked = vt_apic_init_signal_blocked,
+	.check_emulate_instruction = vt_op(check_emulate_instruction),
+	.apic_init_signal_blocked = vt_op(apic_init_signal_blocked),
 	.migrate_timers = vmx_migrate_timers,
 
-	.msr_filter_changed = vt_msr_filter_changed,
-	.complete_emulated_msr = vt_complete_emulated_msr,
+	.msr_filter_changed = vt_op(msr_filter_changed),
+	.complete_emulated_msr = vt_op(complete_emulated_msr),
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 
 	.get_untagged_addr = vmx_get_untagged_addr,
 
-	.mem_enc_ioctl = vt_mem_enc_ioctl,
-	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
+	.mem_enc_ioctl = vt_op_tdx_only(mem_enc_ioctl),
+	.vcpu_mem_enc_ioctl = vt_op_tdx_only(vcpu_mem_enc_ioctl),
 
-	.private_max_mapping_level = vt_gmem_private_max_mapping_level
+	.private_max_mapping_level = vt_op_tdx_only(gmem_private_max_mapping_level)
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
-	.hardware_setup = vt_hardware_setup,
+	.hardware_setup = vt_op(hardware_setup),
 	.handle_intel_pt_intr = NULL,
 
 	.runtime_ops = &vt_x86_ops,
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index f2ca37b3f606..a140af060bb8 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -241,6 +241,14 @@ void __init pi_init_cpu(int cpu)
 	raw_spin_lock_init(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
 }
 
+void pi_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
+{
+	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
+
+	pi_clear_on(pi);
+	memset(pi->pir, 0, sizeof(pi->pir));
+}
+
 bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 68605ca7ef68..9d0677a2ba0e 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -11,6 +11,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu);
 void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu);
 void pi_wakeup_handler(void);
 void __init pi_init_cpu(int cpu);
+void pi_apicv_pre_state_restore(struct kvm_vcpu *vcpu);
 bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 		       uint32_t guest_irq, bool set);
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 196bf360a368..4e7336925059 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -5,7 +5,7 @@
 #include "tdx_arch.h"
 #include "tdx_errno.h"
 
-#ifdef CONFIG_INTEL_TDX_HOST
+#ifdef CONFIG_INTEL_KVM_TDX
 #include "common.h"
 
 int tdx_bringup(void);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 9f286602b205..95f97f9c1b60 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -58,6 +58,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
 int vmx_get_feature_msr(u32 msr, u64 *data);
 int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
+#define vmx_complete_emulated_msr kvm_complete_insn_gp
 u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg);
 void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
@@ -120,7 +121,7 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 #endif
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
-#ifdef CONFIG_INTEL_TDX_HOST
+#ifdef CONFIG_KVM_INTEL_TDX
 void tdx_disable_virtualization_cpu(void);
 int tdx_vm_init(struct kvm *kvm);
 void tdx_mmu_release_hkid(struct kvm *kvm);
@@ -164,72 +165,6 @@ void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
-#else
-static inline void tdx_disable_virtualization_cpu(void) {}
-static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
-static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
-static inline void tdx_vm_free(struct kvm *kvm) {}
-
-static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
-
-static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
-static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
-static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
-static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
-static inline int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
-static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
-{
-	return EXIT_FASTPATH_NONE;
-}
-static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
-static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
-static inline bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu) { return false; }
-static inline int tdx_handle_exit(struct kvm_vcpu *vcpu,
-		enum exit_fastpath_completion fastpath) { return 0; }
-
-static inline void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
-					 int trig_mode, int vector) {}
-static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
-static inline void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
-				     u64 *info2, u32 *intr_info, u32 *error_code) {}
-static inline bool tdx_has_emulated_msr(u32 index) { return false; }
-static inline int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
-static inline int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
-
-static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
-
-static inline int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
-					    enum pg_level level,
-					    void *private_spt)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
-					    enum pg_level level,
-					    void *private_spt)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
-					    enum pg_level level,
-					    kvm_pfn_t pfn)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
-					       enum pg_level level,
-					       kvm_pfn_t pfn)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline void tdx_flush_tlb_current(struct kvm_vcpu *vcpu) {}
-static inline void tdx_flush_tlb_all(struct kvm_vcpu *vcpu) {}
-static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
-static inline int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn) { return 0; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */

base-commit: 50b7294b916de2d855549c179498ba4b7c3ecf37
-- 


