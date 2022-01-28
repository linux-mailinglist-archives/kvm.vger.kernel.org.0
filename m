Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C019B49F020
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345366AbiA1AyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345076AbiA1Axz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 19:53:55 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7B8C061747
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:51 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id p29-20020a634f5d000000b003624b087f05so2391276pgl.7
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=cvygIoGiSQi3oTt0w5ZXf8sI2CTAC6vrqi+OOTHPRDE=;
        b=FVi96naPKGiz/aF8Eh+slKp5cJeQJ6po/1hq26mKVP/XUrxRfayPckK10ADhIvj3hI
         i6+e5NIccsNi5PDn0+PxRt/33GHxddNO0Ne34QQopnoj+FDYcH65XRq7iGHIPEyvA2/9
         iP3EZF0F13nryrttQEIQmptEdrFzblKIulKPzwhnxjnkIkqhEoom40mHGIVAXCG7LY7L
         Prn8DXm3yKx5BQl7bBagSIkmAmX3q2PX/9+GyeOJec2+HzI5iJRp220XcVWN6tp4pMdo
         +xjl65qgtOzI5iooEsKb0MpGDXnsfF9ZaGON1CIvLpJUyXGs2J8qZ83smaU5PEydAgbx
         NrqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=cvygIoGiSQi3oTt0w5ZXf8sI2CTAC6vrqi+OOTHPRDE=;
        b=OosHiyHuIVBnik1/Ps6dEibtZnhkifYe7kEr2udQtOj9W5o2EbSlSg0s0aEQfAlKH/
         NqR5rcIE2qEtiIofdhS4WdUkP7H6jfAtZNHqKlzRKAiwOtR5A0nKvdG5xZHrU9EZUFqa
         ciMZ8hW2hQlF7EoTczcN7kJLK7XeNeOQJaX5C/1dy5vSSVwllJ5ZWQiWrmNYsfEH+1/h
         qmMlywUhCbmpUdQV+7jOrzDsgw50QnDnzytvnejb2qO0Hb+cE5iRiKEe+gsMDUkqE/Wx
         AqcUWSmF4A3IjYycfU8sYgOP6Y1DYmpm5WilHQDWHWi2CpnrkMfCC6GObmR8gJMeGEgS
         sLUQ==
X-Gm-Message-State: AOAM532zKmUfigXKLY9JfRvitpquhoAmTHDfahbZW1l60qeed/a1oN+F
        NoJN92pUphd68JnMK/S729fYPaokC0o=
X-Google-Smtp-Source: ABdhPJyb8tZJAL5p8BS/mQylHLPkXgqhV/ICfjkoJuopLsQFkNASSP9NS2yeeF9/K0Wc++PRvjolQ9+5vtQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:9a4b:: with SMTP id
 x11mr5995083plv.56.1643331230528; Thu, 27 Jan 2022 16:53:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jan 2022 00:52:08 +0000
In-Reply-To: <20220128005208.4008533-1-seanjc@google.com>
Message-Id: <20220128005208.4008533-23-seanjc@google.com>
Mime-Version: 1.0
References: <20220128005208.4008533-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 22/22] KVM: SVM: Use kvm-x86-ops.h to fill svm_x86_ops
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

Fill svm_x86_ops by including kvm-x86-ops.h and defining the appropriate
macros.  Document the handful of exceptions where svm_x86_ops deviates
from the "default" (mostly due to lack of hardware support for a related
feature).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 156 +++++++++--------------------------------
 1 file changed, 32 insertions(+), 124 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7f70f456a5a5..b3761073fa81 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4464,138 +4464,46 @@ static int svm_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+/*
+ * SVM unconditionally flushes between nested transition and so doesn't provide
+ * a "flush all" variant, and a guest's ASID is tied to both guest and NPT
+ * translations, thus there's no "flush guest" variant.
+ */
+#define svm_flush_tlb_all svm_flush_tlb_current
+#define svm_flush_tlb_guest svm_flush_tlb_current
+
+/* APICv hooks not needed/implemented for AVIC. */
+#define avic_guest_apic_has_interrupt NULL
+#define avic_set_apic_access_page_addr NULL
+#define avic_sync_pir_to_irr NULL
+#define avic_pi_start_assignment NULL
+
+/* SVM has no hyperversior debug trap (VMX's Monitor Trap Flag). */
+#define svm_update_emulated_instruction NULL
+
+/* SVM has no CPU assisted dirty logging (VMX's Page Modification Logging). */
+#define svm_update_cpu_dirty_logging NULL
+
+/* SVM has no hypervisor timer (VMX's preemption timer). */
+#define svm_set_hv_timer NULL
+#define svm_cancel_hv_timer NULL
+#define svm_migrate_timers NULL
+#define svm_request_immediate_exit __kvm_request_immediate_exit
+
 static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.name = "kvm_amd",
-
-	.hardware_unsetup = svm_hardware_unsetup,
-	.hardware_enable = svm_hardware_enable,
-	.hardware_disable = svm_hardware_disable,
-	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
-	.has_emulated_msr = svm_has_emulated_msr,
-
-	.vcpu_create = svm_vcpu_create,
-	.vcpu_free = svm_vcpu_free,
-	.vcpu_reset = svm_vcpu_reset,
-
 	.vm_size = sizeof(struct kvm_svm),
-	.vm_init = svm_vm_init,
-	.vm_destroy = svm_vm_destroy,
-
-	.prepare_switch_to_guest = svm_prepare_switch_to_guest,
-	.vcpu_load = svm_vcpu_load,
-	.vcpu_put = svm_vcpu_put,
-	.vcpu_blocking = avic_vcpu_blocking,
-	.vcpu_unblocking = avic_vcpu_unblocking,
-
-	.update_exception_bitmap = svm_update_exception_bitmap,
-	.get_msr_feature = svm_get_msr_feature,
-	.get_msr = svm_get_msr,
-	.set_msr = svm_set_msr,
-	.get_segment_base = svm_get_segment_base,
-	.get_segment = svm_get_segment,
-	.set_segment = svm_set_segment,
-	.get_cpl = svm_get_cpl,
-	.get_cs_db_l_bits = svm_get_cs_db_l_bits,
-	.set_cr0 = svm_set_cr0,
-	.post_set_cr3 = sev_post_set_cr3,
-	.is_valid_cr4 = svm_is_valid_cr4,
-	.set_cr4 = svm_set_cr4,
-	.set_efer = svm_set_efer,
-	.get_idt = svm_get_idt,
-	.set_idt = svm_set_idt,
-	.get_gdt = svm_get_gdt,
-	.set_gdt = svm_set_gdt,
-	.set_dr7 = svm_set_dr7,
-	.sync_dirty_debug_regs = svm_sync_dirty_debug_regs,
-	.cache_reg = svm_cache_reg,
-	.get_rflags = svm_get_rflags,
-	.set_rflags = svm_set_rflags,
-	.get_if_flag = svm_get_if_flag,
-
-	.flush_tlb_all = svm_flush_tlb_current,
-	.flush_tlb_current = svm_flush_tlb_current,
-	.flush_tlb_gva = svm_flush_tlb_gva,
-	.flush_tlb_guest = svm_flush_tlb_current,
-
-	.vcpu_pre_run = svm_vcpu_pre_run,
-	.vcpu_run = svm_vcpu_run,
-	.handle_exit = svm_handle_exit,
-	.skip_emulated_instruction = svm_skip_emulated_instruction,
-	.update_emulated_instruction = NULL,
-	.set_interrupt_shadow = svm_set_interrupt_shadow,
-	.get_interrupt_shadow = svm_get_interrupt_shadow,
-	.patch_hypercall = svm_patch_hypercall,
-	.inject_irq = svm_inject_irq,
-	.inject_nmi = svm_inject_nmi,
-	.queue_exception = svm_queue_exception,
-	.cancel_injection = svm_cancel_injection,
-	.interrupt_allowed = svm_interrupt_allowed,
-	.nmi_allowed = svm_nmi_allowed,
-	.get_nmi_mask = svm_get_nmi_mask,
-	.set_nmi_mask = svm_set_nmi_mask,
-	.enable_nmi_window = svm_enable_nmi_window,
-	.enable_irq_window = svm_enable_irq_window,
-	.update_cr8_intercept = svm_update_cr8_intercept,
-	.set_virtual_apic_mode = avic_set_virtual_apic_mode,
-	.refresh_apicv_exec_ctrl = avic_refresh_apicv_exec_ctrl,
-	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
-	.load_eoi_exitmap = avic_load_eoi_exitmap,
-	.hwapic_irr_update = avic_hwapic_irr_update,
-	.hwapic_isr_update = avic_hwapic_isr_update,
-	.apicv_post_state_restore = avic_apicv_post_state_restore,
-
-	.set_tss_addr = svm_set_tss_addr,
-	.set_identity_map_addr = svm_set_identity_map_addr,
-	.get_mt_mask = svm_get_mt_mask,
-
-	.get_exit_info = svm_get_exit_info,
-
-	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
-
-	.has_wbinvd_exit = svm_has_wbinvd_exit,
-
-	.get_l2_tsc_offset = svm_get_l2_tsc_offset,
-	.get_l2_tsc_multiplier = svm_get_l2_tsc_multiplier,
-	.write_tsc_offset = svm_write_tsc_offset,
-	.write_tsc_multiplier = svm_write_tsc_multiplier,
-
-	.load_mmu_pgd = svm_load_mmu_pgd,
-
-	.check_intercept = svm_check_intercept,
-	.handle_exit_irqoff = svm_handle_exit_irqoff,
-
-	.request_immediate_exit = __kvm_request_immediate_exit,
-
-	.sched_in = svm_sched_in,
 
 	.pmu_ops = &amd_pmu_ops,
 	.nested_ops = &svm_nested_ops,
 
-	.deliver_interrupt = svm_deliver_interrupt,
-	.dy_apicv_has_pending_interrupt = avic_dy_apicv_has_pending_interrupt,
-	.pi_update_irte = avic_pi_update_irte,
-	.setup_mce = svm_setup_mce,
+#define KVM_X86_OP(func) .func = svm_##func,
+#define KVM_X86_APICV_OP(func) .func = avic_##func,
+#define KVM_X86_CVM_OP(func) .func = sev_##func,
 
-	.smi_allowed = svm_smi_allowed,
-	.enter_smm = svm_enter_smm,
-	.leave_smm = svm_leave_smm,
-	.enable_smi_window = svm_enable_smi_window,
-
-	.mem_enc_ioctl = sev_mem_enc_ioctl,
-	.mem_enc_register_region = sev_mem_enc_register_region,
-	.mem_enc_unregister_region = sev_mem_enc_unregister_region,
-
-	.vm_copy_enc_context_from = sev_vm_copy_enc_context_from,
-	.vm_move_enc_context_from = sev_vm_move_enc_context_from,
-
-	.can_emulate_instruction = svm_can_emulate_instruction,
-
-	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
-
-	.msr_filter_changed = svm_msr_filter_changed,
-	.complete_emulated_msr = svm_complete_emulated_msr,
-
-	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
+/* Hyper-V hooks are filled at runtime. */
+#define KVM_X86_HYPERV_OP(func) .func = NULL,
+#include <asm/kvm-x86-ops.h>
 };
 
 /*
-- 
2.35.0.rc0.227.g00780c9af4-goog

