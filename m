Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3717849EFFA
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344808AbiA1AxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344749AbiA1AxQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 19:53:16 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A61C06173B
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:16 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id o9-20020a170903210900b0014b36bee5b9so2339259ple.0
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DiMuq2Bil4+pHQEcZ/O668QC6BBPA3hB3Y9QWnY+qA4=;
        b=cwog0v0MWjJXvH7HzpkNIMx19BpXimiXFYSwqSWPvTgF7KcYoLDfP9famQQsVAw1pK
         7jrURWWD9scbGodLmwR6XEA90MUBFC4+58qFLfdkBW0CWLf6e1h2k3PsyGrB6kdJaip6
         CXv27tMDqn9bvNv6FnI6sgMVcK+6y4Pr0q13x+7EdvaQV8qtVZ9E1u2MVuIx748qS2nR
         oXao7AQK2X+nfTn9Js4d+6tV+3uOrsYH4k2MwwyVsI38irMQ3rqYT7Bm6tuWwYPBlTvd
         yS+b6/PrCIgXV5AZhNPg5SQ5HUIhdZQ91kq16ibQ+bP09We9l2OHZ0GPbgBLhwocgzDv
         /DfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DiMuq2Bil4+pHQEcZ/O668QC6BBPA3hB3Y9QWnY+qA4=;
        b=0p3rGAam8Do+cM5Gu+SqCVbIXUuNvT03nN6CK/7zv1BEacR6QEJTUFVeoYTKdW48QP
         qjCDZpv98PfrLFA0VM6Xp16HWPl3ANBFANiq0ztf4QtQYFgltmJ9hA34SbcYpPfvjYp5
         a+y5yD3lL3VIqRaMFB9Ji0S7/QDSpeH9HuRR9PQtfV4AZoQSp50bpU+tptTiz12A4m7I
         p/0RNB0iv17j+KNHsZHrKqI2UZHosem5+RRtiWHPji4De1oM06O5gmDwJBrkhdz/tdvD
         2dAjU5E5dNqZvTNMoepVga/tOqdNbQsBgxZilj979dw3gSBBz6NzIsjHzWAy2a/C8C6M
         cwcg==
X-Gm-Message-State: AOAM530WJYrhyZBwrkzZt8z+i7F5mgDJG/yzlYm8VLEefcm4er+RwMNm
        hLjF9UBt/v2NIB8ARKjXhe9giXWRJGI=
X-Google-Smtp-Source: ABdhPJzPYJHaWhZ33ihP4QCmQQPFItRzz3C8yWoefe+67z0NWQRDJ5/bLXQ9LOemoceygPB6gbDKujku70I=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:888b:: with SMTP id z11mr88139pfe.76.1643331195691;
 Thu, 27 Jan 2022 16:53:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jan 2022 00:51:47 +0000
In-Reply-To: <20220128005208.4008533-1-seanjc@google.com>
Message-Id: <20220128005208.4008533-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220128005208.4008533-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 01/22] KVM: x86: Drop unnecessary and confusing
 KVM_X86_OP_NULL macro
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

Drop KVM_X86_OP_NULL, which is superfluous and confusing.  The macro is
just a "pass-through" to KVM_X86_OP; it was added with the intent of
actually using it in the future, but that obviously never happened.  The
name is confusing because its intended use was to provide a way for
vendor implementations to specify a NULL pointer, and even if it were
used, wouldn't necessarily be synonymous with declaring a kvm_x86_op as
DEFINE_STATIC_CALL_NULL.

Lastly, actually using KVM_X86_OP_NULL as intended isn't a maintanable
approach, e.g. bleeds vendor details into common x86 code, and would
either be prone to bit rot or would require modifying common x86 code
when modifying a vendor implementation.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 76 ++++++++++++++----------------
 arch/x86/include/asm/kvm_host.h    |  2 -
 arch/x86/kvm/x86.c                 |  1 -
 3 files changed, 35 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 631d5040b31e..e07151b2d1f6 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -1,25 +1,20 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#if !defined(KVM_X86_OP) || !defined(KVM_X86_OP_NULL)
+#ifndef KVM_X86_OP
 BUILD_BUG_ON(1)
 #endif
 
 /*
- * KVM_X86_OP() and KVM_X86_OP_NULL() are used to help generate
- * "static_call()"s. They are also intended for use when defining
- * the vmx/svm kvm_x86_ops. KVM_X86_OP() can be used for those
- * functions that follow the [svm|vmx]_func_name convention.
- * KVM_X86_OP_NULL() can leave a NULL definition for the
- * case where there is no definition or a function name that
- * doesn't match the typical naming convention is supplied.
+ * Invoke KVM_X86_OP() on all functions in struct kvm_x86_ops, e.g. to generate
+ * static_call declarations, definitions and updates.
  */
-KVM_X86_OP_NULL(hardware_enable)
-KVM_X86_OP_NULL(hardware_disable)
-KVM_X86_OP_NULL(hardware_unsetup)
-KVM_X86_OP_NULL(cpu_has_accelerated_tpr)
+KVM_X86_OP(hardware_enable)
+KVM_X86_OP(hardware_disable)
+KVM_X86_OP(hardware_unsetup)
+KVM_X86_OP(cpu_has_accelerated_tpr)
 KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(vm_init)
-KVM_X86_OP_NULL(vm_destroy)
+KVM_X86_OP(vm_destroy)
 KVM_X86_OP(vcpu_create)
 KVM_X86_OP(vcpu_free)
 KVM_X86_OP(vcpu_reset)
@@ -33,9 +28,9 @@ KVM_X86_OP(get_segment_base)
 KVM_X86_OP(get_segment)
 KVM_X86_OP(get_cpl)
 KVM_X86_OP(set_segment)
-KVM_X86_OP_NULL(get_cs_db_l_bits)
+KVM_X86_OP(get_cs_db_l_bits)
 KVM_X86_OP(set_cr0)
-KVM_X86_OP_NULL(post_set_cr3)
+KVM_X86_OP(post_set_cr3)
 KVM_X86_OP(is_valid_cr4)
 KVM_X86_OP(set_cr4)
 KVM_X86_OP(set_efer)
@@ -51,15 +46,15 @@ KVM_X86_OP(set_rflags)
 KVM_X86_OP(get_if_flag)
 KVM_X86_OP(tlb_flush_all)
 KVM_X86_OP(tlb_flush_current)
-KVM_X86_OP_NULL(tlb_remote_flush)
-KVM_X86_OP_NULL(tlb_remote_flush_with_range)
+KVM_X86_OP(tlb_remote_flush)
+KVM_X86_OP(tlb_remote_flush_with_range)
 KVM_X86_OP(tlb_flush_gva)
 KVM_X86_OP(tlb_flush_guest)
 KVM_X86_OP(vcpu_pre_run)
 KVM_X86_OP(run)
-KVM_X86_OP_NULL(handle_exit)
-KVM_X86_OP_NULL(skip_emulated_instruction)
-KVM_X86_OP_NULL(update_emulated_instruction)
+KVM_X86_OP(handle_exit)
+KVM_X86_OP(skip_emulated_instruction)
+KVM_X86_OP(update_emulated_instruction)
 KVM_X86_OP(set_interrupt_shadow)
 KVM_X86_OP(get_interrupt_shadow)
 KVM_X86_OP(patch_hypercall)
@@ -78,17 +73,17 @@ KVM_X86_OP(check_apicv_inhibit_reasons)
 KVM_X86_OP(refresh_apicv_exec_ctrl)
 KVM_X86_OP(hwapic_irr_update)
 KVM_X86_OP(hwapic_isr_update)
-KVM_X86_OP_NULL(guest_apic_has_interrupt)
+KVM_X86_OP(guest_apic_has_interrupt)
 KVM_X86_OP(load_eoi_exitmap)
 KVM_X86_OP(set_virtual_apic_mode)
-KVM_X86_OP_NULL(set_apic_access_page_addr)
+KVM_X86_OP(set_apic_access_page_addr)
 KVM_X86_OP(deliver_posted_interrupt)
-KVM_X86_OP_NULL(sync_pir_to_irr)
+KVM_X86_OP(sync_pir_to_irr)
 KVM_X86_OP(set_tss_addr)
 KVM_X86_OP(set_identity_map_addr)
 KVM_X86_OP(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
-KVM_X86_OP_NULL(has_wbinvd_exit)
+KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
 KVM_X86_OP(write_tsc_offset)
@@ -96,32 +91,31 @@ KVM_X86_OP(write_tsc_multiplier)
 KVM_X86_OP(get_exit_info)
 KVM_X86_OP(check_intercept)
 KVM_X86_OP(handle_exit_irqoff)
-KVM_X86_OP_NULL(request_immediate_exit)
+KVM_X86_OP(request_immediate_exit)
 KVM_X86_OP(sched_in)
-KVM_X86_OP_NULL(update_cpu_dirty_logging)
-KVM_X86_OP_NULL(vcpu_blocking)
-KVM_X86_OP_NULL(vcpu_unblocking)
-KVM_X86_OP_NULL(update_pi_irte)
-KVM_X86_OP_NULL(start_assignment)
-KVM_X86_OP_NULL(apicv_post_state_restore)
-KVM_X86_OP_NULL(dy_apicv_has_pending_interrupt)
-KVM_X86_OP_NULL(set_hv_timer)
-KVM_X86_OP_NULL(cancel_hv_timer)
+KVM_X86_OP(update_cpu_dirty_logging)
+KVM_X86_OP(vcpu_blocking)
+KVM_X86_OP(vcpu_unblocking)
+KVM_X86_OP(update_pi_irte)
+KVM_X86_OP(start_assignment)
+KVM_X86_OP(apicv_post_state_restore)
+KVM_X86_OP(dy_apicv_has_pending_interrupt)
+KVM_X86_OP(set_hv_timer)
+KVM_X86_OP(cancel_hv_timer)
 KVM_X86_OP(setup_mce)
 KVM_X86_OP(smi_allowed)
 KVM_X86_OP(enter_smm)
 KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
-KVM_X86_OP_NULL(mem_enc_op)
-KVM_X86_OP_NULL(mem_enc_reg_region)
-KVM_X86_OP_NULL(mem_enc_unreg_region)
+KVM_X86_OP(mem_enc_op)
+KVM_X86_OP(mem_enc_reg_region)
+KVM_X86_OP(mem_enc_unreg_region)
 KVM_X86_OP(get_msr_feature)
 KVM_X86_OP(can_emulate_instruction)
 KVM_X86_OP(apic_init_signal_blocked)
-KVM_X86_OP_NULL(enable_direct_tlbflush)
-KVM_X86_OP_NULL(migrate_timers)
+KVM_X86_OP(enable_direct_tlbflush)
+KVM_X86_OP(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
-KVM_X86_OP_NULL(complete_emulated_msr)
+KVM_X86_OP(complete_emulated_msr)
 
 #undef KVM_X86_OP
-#undef KVM_X86_OP_NULL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b2c3721b1c98..756806d2e801 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1538,14 +1538,12 @@ extern struct kvm_x86_ops kvm_x86_ops;
 
 #define KVM_X86_OP(func) \
 	DECLARE_STATIC_CALL(kvm_x86_##func, *(((struct kvm_x86_ops *)0)->func));
-#define KVM_X86_OP_NULL KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 
 static inline void kvm_ops_static_call_update(void)
 {
 #define KVM_X86_OP(func) \
 	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
-#define KVM_X86_OP_NULL KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8033eca6f3a1..ebab514ec82a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -129,7 +129,6 @@ EXPORT_SYMBOL_GPL(kvm_x86_ops);
 #define KVM_X86_OP(func)					     \
 	DEFINE_STATIC_CALL_NULL(kvm_x86_##func,			     \
 				*(((struct kvm_x86_ops *)0)->func));
-#define KVM_X86_OP_NULL KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
 EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
-- 
2.35.0.rc0.227.g00780c9af4-goog

