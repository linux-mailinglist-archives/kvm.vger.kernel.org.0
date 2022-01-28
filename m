Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B3649F011
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345183AbiA1AyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345030AbiA1Axw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 19:53:52 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93904C06177B
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:37 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id a4-20020a17090a70c400b001b21d9c8bc8so5216487pjm.7
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=C7P7Lo+MHz+aDeG8aypZh7++gwohNrhZtfXpoo4GhRc=;
        b=rxSvNbj1FPQawP+4EDxY3c4o9aokF7v2F1cuEwoZQI6ZwxmGhMNnKNUl3AKSik1LoT
         68Yx/T3rAHD8goqU8NgEiDyVIA2pk2MWrs7zwkvhD8PODG16pidsfl4PdJQHsIRKCHjf
         gY4yc7HNHj+09o18BT1SI0QpYHmK58R0tE4WsaLCBGKBdzbuosUbTsFBoJ/oNpyTlxUB
         tBCYCHBF1mvPqO+CODrqHax6AuqGW1nVDjzaM/cNx5EkNZYRN8RCg/Z5Bu00VhvG754M
         /PyzRHpCItV3Ff2G+zvd8fuxcuADJ29DvH07hharTXi2iTb5WZFbZCoiZ5QRsiMrsCkn
         SkSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=C7P7Lo+MHz+aDeG8aypZh7++gwohNrhZtfXpoo4GhRc=;
        b=n0dt3pkUtBBGQ+jAB2iZcoM0Qj1adEyG2NfHELI66yqJkUDLkcUYTpjlLKIDGt//V0
         uI6XMdZn4OvVmsgQMKW1Pd5z5PtJRCowssHUHrgvdVRqkC54XZy2rVlEK/ylKOx36KgB
         tq9Iid7mZvV2Tz0t3fL2pOeeWZ9u2R6JsyOXFuPHEIcRrzP1CAQLRZP3ERlNRrkJvjhS
         YuIMekaAY+TihS1EeSDxN5FHy47Athtncb2wcOCSGCyp6GS84GaPO8juP+e9EM2GiupK
         6AP5+MBdpkLywJoCk/pMeSNsJXabICRL5kxZEveIWIOsr5qyRlF1fBTbyfmzAPnhNHhl
         VNmQ==
X-Gm-Message-State: AOAM531Hmzgm7n7UmmMytk+SacB+JQv7i1qRkLXZSeLsXBAGmFTo38B7
        bPuO4DP0wfdMijHdk90yFIsb0Ot4XZk=
X-Google-Smtp-Source: ABdhPJwOGArX1csvPGQcF2VcKjeSM8bSH+X5XS5zlS9c//QcVjM14dW1/bvwcrq84RCXuYqYNjiguoij8Jw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:10d2:: with SMTP id
 d18mr5562615pfu.2.1643331217063; Thu, 27 Jan 2022 16:53:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jan 2022 00:52:00 +0000
In-Reply-To: <20220128005208.4008533-1-seanjc@google.com>
Message-Id: <20220128005208.4008533-15-seanjc@google.com>
Mime-Version: 1.0
References: <20220128005208.4008533-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 14/22] KVM: VMX: Use kvm-x86-ops.h to fill vmx_x86_ops
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fill vmx_x86_ops by including kvm-x86-ops.h and defining the appropriate
macros.  Use the default for KVM_X86_APICV_OP as VMX doesn't have a
single prefix for all APICv ops, and the majority of APICv ops that do
conform to the kvm_x86_ops names do so with the standard vmx_ prefix.

Document the handful of exceptions where vmx_x86_ops deviates from the
"default".

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 149 +++++++----------------------------------
 1 file changed, 25 insertions(+), 124 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2138f7439a19..f22d02fe4df3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7702,141 +7702,42 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
+/* Not currently implemented for VMX. */
+#define vmx_vm_destroy NULL
+#define vmx_vcpu_blocking NULL
+#define vmx_vcpu_unblocking NULL
+
+/* Redirects to common KVM helpers (hooks provided for SEV-ES). */
+#define vmx_complete_emulated_msr kvm_complete_insn_gp
+#define vmx_vcpu_deliver_sipi_vector kvm_vcpu_deliver_sipi_vector
+
+/* Redirects to preserve VMX's preferred nomenclature. */
+#define vmx_has_wbinvd_exit cpu_has_vmx_wbinvd_exit
+#define vmx_dy_apicv_has_pending_interrupt pi_has_pending_interrupt
+
+/* VMX preemption timer support is 64-bit only as it uses 64-bit division. */
+#ifndef CONFIG_X86_64
+#define vmx_set_hv_timer NULL
+#define vmx_cancel_hv_timer NULL
+#endif
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.name = "kvm_intel",
-
-	.hardware_unsetup = vmx_hardware_unsetup,
-
-	.hardware_enable = vmx_hardware_enable,
-	.hardware_disable = vmx_hardware_disable,
-	.cpu_has_accelerated_tpr = vmx_cpu_has_accelerated_tpr,
-	.has_emulated_msr = vmx_has_emulated_msr,
-
 	.vm_size = sizeof(struct kvm_vmx),
-	.vm_init = vmx_vm_init,
-
-	.vcpu_create = vmx_vcpu_create,
-	.vcpu_free = vmx_vcpu_free,
-	.vcpu_reset = vmx_vcpu_reset,
-
-	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
-	.vcpu_load = vmx_vcpu_load,
-	.vcpu_put = vmx_vcpu_put,
-
-	.update_exception_bitmap = vmx_update_exception_bitmap,
-	.get_msr_feature = vmx_get_msr_feature,
-	.get_msr = vmx_get_msr,
-	.set_msr = vmx_set_msr,
-	.get_segment_base = vmx_get_segment_base,
-	.get_segment = vmx_get_segment,
-	.set_segment = vmx_set_segment,
-	.get_cpl = vmx_get_cpl,
-	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
-	.set_cr0 = vmx_set_cr0,
-	.is_valid_cr4 = vmx_is_valid_cr4,
-	.set_cr4 = vmx_set_cr4,
-	.set_efer = vmx_set_efer,
-	.get_idt = vmx_get_idt,
-	.set_idt = vmx_set_idt,
-	.get_gdt = vmx_get_gdt,
-	.set_gdt = vmx_set_gdt,
-	.set_dr7 = vmx_set_dr7,
-	.sync_dirty_debug_regs = vmx_sync_dirty_debug_regs,
-	.cache_reg = vmx_cache_reg,
-	.get_rflags = vmx_get_rflags,
-	.set_rflags = vmx_set_rflags,
-	.get_if_flag = vmx_get_if_flag,
-
-	.flush_tlb_all = vmx_flush_tlb_all,
-	.flush_tlb_current = vmx_flush_tlb_current,
-	.flush_tlb_gva = vmx_flush_tlb_gva,
-	.flush_tlb_guest = vmx_flush_tlb_guest,
-
-	.vcpu_pre_run = vmx_vcpu_pre_run,
-	.vcpu_run = vmx_vcpu_run,
-	.handle_exit = vmx_handle_exit,
-	.skip_emulated_instruction = vmx_skip_emulated_instruction,
-	.update_emulated_instruction = vmx_update_emulated_instruction,
-	.set_interrupt_shadow = vmx_set_interrupt_shadow,
-	.get_interrupt_shadow = vmx_get_interrupt_shadow,
-	.patch_hypercall = vmx_patch_hypercall,
-	.inject_irq = vmx_inject_irq,
-	.inject_nmi = vmx_inject_nmi,
-	.queue_exception = vmx_queue_exception,
-	.cancel_injection = vmx_cancel_injection,
-	.interrupt_allowed = vmx_interrupt_allowed,
-	.nmi_allowed = vmx_nmi_allowed,
-	.get_nmi_mask = vmx_get_nmi_mask,
-	.set_nmi_mask = vmx_set_nmi_mask,
-	.enable_nmi_window = vmx_enable_nmi_window,
-	.enable_irq_window = vmx_enable_irq_window,
-	.update_cr8_intercept = vmx_update_cr8_intercept,
-	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
-	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
-	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
-	.load_eoi_exitmap = vmx_load_eoi_exitmap,
-	.apicv_post_state_restore = vmx_apicv_post_state_restore,
-	.check_apicv_inhibit_reasons = vmx_check_apicv_inhibit_reasons,
-	.hwapic_irr_update = vmx_hwapic_irr_update,
-	.hwapic_isr_update = vmx_hwapic_isr_update,
-	.guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
-	.sync_pir_to_irr = vmx_sync_pir_to_irr,
-	.deliver_interrupt = vmx_deliver_interrupt,
-	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
-
-	.set_tss_addr = vmx_set_tss_addr,
-	.set_identity_map_addr = vmx_set_identity_map_addr,
-	.get_mt_mask = vmx_get_mt_mask,
-
-	.get_exit_info = vmx_get_exit_info,
-
-	.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
-
-	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
-
-	.get_l2_tsc_offset = vmx_get_l2_tsc_offset,
-	.get_l2_tsc_multiplier = vmx_get_l2_tsc_multiplier,
-	.write_tsc_offset = vmx_write_tsc_offset,
-	.write_tsc_multiplier = vmx_write_tsc_multiplier,
-
-	.load_mmu_pgd = vmx_load_mmu_pgd,
-
-	.check_intercept = vmx_check_intercept,
-	.handle_exit_irqoff = vmx_handle_exit_irqoff,
-
-	.request_immediate_exit = vmx_request_immediate_exit,
-
-	.sched_in = vmx_sched_in,
-
 	.cpu_dirty_log_size = PML_ENTITY_NUM,
-	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
 
 	.pmu_ops = &intel_pmu_ops,
 	.nested_ops = &vmx_nested_ops,
 
-	.pi_update_irte = vmx_pi_update_irte,
-	.pi_start_assignment = vmx_pi_start_assignment,
+#define KVM_X86_OP(func) .func = vmx_##func,
 
-#ifdef CONFIG_X86_64
-	.set_hv_timer = vmx_set_hv_timer,
-	.cancel_hv_timer = vmx_cancel_hv_timer,
-#endif
+/* VMX doesn't yet support confidential VMs. */
+#define KVM_X86_CVM_OP(func) .func = NULL,
 
-	.setup_mce = vmx_setup_mce,
+/* Hyper-V hooks are filled at runtime. */
+#define KVM_X86_HYPERV_OP(func) .func = NULL,
 
-	.smi_allowed = vmx_smi_allowed,
-	.enter_smm = vmx_enter_smm,
-	.leave_smm = vmx_leave_smm,
-	.enable_smi_window = vmx_enable_smi_window,
-
-	.can_emulate_instruction = vmx_can_emulate_instruction,
-	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
-	.migrate_timers = vmx_migrate_timers,
-
-	.msr_filter_changed = vmx_msr_filter_changed,
-	.complete_emulated_msr = kvm_complete_insn_gp,
-
-	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+#include <asm/kvm-x86-ops.h>
 };
 
 static __init void vmx_setup_user_return_msrs(void)
-- 
2.35.0.rc0.227.g00780c9af4-goog

