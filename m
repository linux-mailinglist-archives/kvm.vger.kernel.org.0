Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832B849F01C
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345033AbiA1AyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344880AbiA1Axm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 19:53:42 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6183AC06176F
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:34 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id bd15-20020a056a00278f00b004c7617c47dbso2504379pfb.0
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=JgW9MKcGIQjIHi99tqvfeFUZw8kv5Qh9J0/QV1SIB0I=;
        b=Xf8M2HCj214PlyvAKWtn6cw2QMhNw1MZulRM3NvGFSnbF+QTRwKel/uYGe9qidQvw8
         81Aa/76ztI3Ij8WUX4EG9SDYS3wat+bBFhzt04IlgfoQnRoKbRhidgTKELm6donSmr2y
         pir9YKUOaEs3EFqFIAVxSYo+oj1NC1+HoLAINJBNVYV8mqFrtm+2y0UTusAgPk5w90ZC
         E9CvqEaQYDh0cgLT3ONUoN1Pj6wXWM4m6prk/x7avtv1T2H8sDbIzjfPDuZ54UI7sb0M
         aeUXNg+e8bBci7ZmJz2UFlti91xRXyIwoVHtN2IEKcmpCqzV+mVD6RbWyQELhlXtFod+
         1k8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=JgW9MKcGIQjIHi99tqvfeFUZw8kv5Qh9J0/QV1SIB0I=;
        b=pnDTMfQnpYo0TjoqhEOAR9EBThDMfvUlphAAYYQW2qK6iUH13lvLPdSopOq2wsh2L4
         RTENQbt6WXZCPi7i9j4+lFxU1nKeUbY+lMLOH2Hc1dMB/7GUFssz0rX655snSiUHE0wy
         h25e4AzNzWIcu7yDsDF0ohWAlru9GweEzue5Cu4JPQlVdnmHy8waFvVHm4FndMUQKJ/E
         KXCpEnTb5YdTmTRB1lDmQ4oA9xd8nAQnrjUWLVfkAVg7QSccRR4sGmbunshtiTzvSegC
         qyl25q01sqLBW6qEes46xFXv0gPgat488bCN65l8mA06ZsTJxzOIqKwg4HHbdCPNu6hx
         S0Kg==
X-Gm-Message-State: AOAM530nJW9KOR3Hz3vdgQFq0TrPUe/Wv3m4kF50MfpokH7AEa/eKHqR
        X81CI+HMq7r7bZJUUFqgcO3Z99x16HQ=
X-Google-Smtp-Source: ABdhPJznlzPCYb9PPVlSs01EBkBxvfgOIlYdAeaD8HA+E5wkfz4Alwy9eGFxzc7Q5mWuEGglBvOR3t1r1dc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a50:: with SMTP id
 h16mr3291030pfv.74.1643331213878; Thu, 27 Jan 2022 16:53:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jan 2022 00:51:58 +0000
In-Reply-To: <20220128005208.4008533-1-seanjc@google.com>
Message-Id: <20220128005208.4008533-13-seanjc@google.com>
Mime-Version: 1.0
References: <20220128005208.4008533-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 12/22] KVM: x86: Allow different macros for APICv, CVM, and
 Hyper-V kvm_x86_ops
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

Introduce optional macros for defining APICv, Confidental VM (a.k.a. so
called memory encryption), and Hyper-V kvm_x86_ops.  Specialized macros
will allow vendor code to easily apply a single pattern when wiring up
implementations, e.g. SVM using "sev" for Confidential VMs and AVIC for
APICv, and VMX currently doesn't support any Condifential VM hooks.

Bundling also adds a small amount of self-documentation to the various
hooks in kvm-x86-ops.h.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 74 +++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 4ee046e60c34..cb3af3a55317 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -4,8 +4,24 @@ BUILD_BUG_ON(1)
 #endif
 
 /*
- * Invoke KVM_X86_OP() on all functions in struct kvm_x86_ops, e.g. to generate
- * static_call declarations, definitions and updates.
+ * APICv, Hyper-V, and Confidential VM macros are optional, redirect to the
+ * standard ops macro if the caller didn't define a type-specific variant.
+ */
+#ifndef KVM_X86_APICV_OP
+#define KVM_X86_APICV_OP KVM_X86_OP
+#endif
+
+#ifndef KVM_X86_HYPERV_OP
+#define KVM_X86_HYPERV_OP KVM_X86_OP
+#endif
+
+#ifndef KVM_X86_CVM_OP
+#define KVM_X86_CVM_OP KVM_X86_OP
+#endif
+
+/*
+ * Invoke the appropriate macro on all functions in struct kvm_x86_ops, e.g. to
+ * generate static_call declarations, definitions and updates.
  */
 KVM_X86_OP(hardware_enable)
 KVM_X86_OP(hardware_disable)
@@ -30,7 +46,6 @@ KVM_X86_OP(get_cpl)
 KVM_X86_OP(set_segment)
 KVM_X86_OP(get_cs_db_l_bits)
 KVM_X86_OP(set_cr0)
-KVM_X86_OP(post_set_cr3)
 KVM_X86_OP(is_valid_cr4)
 KVM_X86_OP(set_cr4)
 KVM_X86_OP(set_efer)
@@ -46,8 +61,6 @@ KVM_X86_OP(set_rflags)
 KVM_X86_OP(get_if_flag)
 KVM_X86_OP(flush_tlb_all)
 KVM_X86_OP(flush_tlb_current)
-KVM_X86_OP(tlb_remote_flush)
-KVM_X86_OP(tlb_remote_flush_with_range)
 KVM_X86_OP(flush_tlb_gva)
 KVM_X86_OP(flush_tlb_guest)
 KVM_X86_OP(vcpu_pre_run)
@@ -69,16 +82,7 @@ KVM_X86_OP(set_nmi_mask)
 KVM_X86_OP(enable_nmi_window)
 KVM_X86_OP(enable_irq_window)
 KVM_X86_OP(update_cr8_intercept)
-KVM_X86_OP(check_apicv_inhibit_reasons)
-KVM_X86_OP(refresh_apicv_exec_ctrl)
-KVM_X86_OP(hwapic_irr_update)
-KVM_X86_OP(hwapic_isr_update)
-KVM_X86_OP(guest_apic_has_interrupt)
-KVM_X86_OP(load_eoi_exitmap)
-KVM_X86_OP(set_virtual_apic_mode)
-KVM_X86_OP(set_apic_access_page_addr)
 KVM_X86_OP(deliver_interrupt)
-KVM_X86_OP(sync_pir_to_irr)
 KVM_X86_OP(set_tss_addr)
 KVM_X86_OP(set_identity_map_addr)
 KVM_X86_OP(get_mt_mask)
@@ -94,12 +98,6 @@ KVM_X86_OP(handle_exit_irqoff)
 KVM_X86_OP(request_immediate_exit)
 KVM_X86_OP(sched_in)
 KVM_X86_OP(update_cpu_dirty_logging)
-KVM_X86_OP(vcpu_blocking)
-KVM_X86_OP(vcpu_unblocking)
-KVM_X86_OP(pi_update_irte)
-KVM_X86_OP(pi_start_assignment)
-KVM_X86_OP(apicv_post_state_restore)
-KVM_X86_OP(dy_apicv_has_pending_interrupt)
 KVM_X86_OP(set_hv_timer)
 KVM_X86_OP(cancel_hv_timer)
 KVM_X86_OP(setup_mce)
@@ -107,18 +105,42 @@ KVM_X86_OP(smi_allowed)
 KVM_X86_OP(enter_smm)
 KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
-KVM_X86_OP(mem_enc_op)
-KVM_X86_OP(mem_enc_reg_region)
-KVM_X86_OP(mem_enc_unreg_region)
-KVM_X86_OP(vm_copy_enc_context_from)
-KVM_X86_OP(vm_move_enc_context_from)
 KVM_X86_OP(get_msr_feature)
 KVM_X86_OP(can_emulate_instruction)
 KVM_X86_OP(apic_init_signal_blocked)
-KVM_X86_OP(enable_direct_tlbflush)
 KVM_X86_OP(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 
+KVM_X86_APICV_OP(check_apicv_inhibit_reasons)
+KVM_X86_APICV_OP(refresh_apicv_exec_ctrl)
+KVM_X86_APICV_OP(load_eoi_exitmap)
+KVM_X86_APICV_OP(set_virtual_apic_mode)
+KVM_X86_APICV_OP(set_apic_access_page_addr)
+KVM_X86_APICV_OP(sync_pir_to_irr)
+KVM_X86_APICV_OP(hwapic_irr_update)
+KVM_X86_APICV_OP(hwapic_isr_update)
+KVM_X86_APICV_OP(guest_apic_has_interrupt)
+KVM_X86_APICV_OP(vcpu_blocking)
+KVM_X86_APICV_OP(vcpu_unblocking)
+KVM_X86_APICV_OP(pi_update_irte)
+KVM_X86_APICV_OP(pi_start_assignment)
+KVM_X86_APICV_OP(apicv_post_state_restore)
+KVM_X86_APICV_OP(dy_apicv_has_pending_interrupt)
+
+KVM_X86_HYPERV_OP(tlb_remote_flush)
+KVM_X86_HYPERV_OP(tlb_remote_flush_with_range)
+KVM_X86_HYPERV_OP(enable_direct_tlbflush)
+
+KVM_X86_CVM_OP(mem_enc_op)
+KVM_X86_CVM_OP(mem_enc_reg_region)
+KVM_X86_CVM_OP(mem_enc_unreg_region)
+KVM_X86_CVM_OP(vm_copy_enc_context_from)
+KVM_X86_CVM_OP(vm_move_enc_context_from)
+KVM_X86_CVM_OP(post_set_cr3)
+
+#undef KVM_X86_APICV_OP
+#undef KVM_X86_HYPERV_OP
+#undef KVM_X86_CVM_OP
 #undef KVM_X86_OP
-- 
2.35.0.rc0.227.g00780c9af4-goog

