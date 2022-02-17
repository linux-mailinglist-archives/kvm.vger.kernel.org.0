Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75B74BA7B4
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 19:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244011AbiBQSIy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 13:08:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242914AbiBQSIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 13:08:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2DAB515DDFC
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 10:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645121316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ow4BGaGio5K0ufU/V2NSXmPBwjoLVMLmuDQAAiiPF/c=;
        b=LgD0TnrdzSeZH5+5EgTl+XbpgJsH3GXc9fi8WMnRhvoVggyeUpuLmOx34hRXDit6dF3EEx
        KWpiaMM4r5Z/b2fe7bfP+sOJLUnPjnLJ8wQ0cmTY7c9fwBgsbzDIdEwvClbtGCxlrhHMfs
        XhJr7Ea8q4VG1DFyqkb4Amuw0EDXq3k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-bg4Gg4feOX-apMGMabkXvg-1; Thu, 17 Feb 2022 13:08:34 -0500
X-MC-Unique: bg4Gg4feOX-apMGMabkXvg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C50E92F45;
        Thu, 17 Feb 2022 18:08:33 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 753F98276C;
        Thu, 17 Feb 2022 18:08:33 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v3 3/6] KVM: x86: remove KVM_X86_OP_NULL and mark optional kvm_x86_ops
Date:   Thu, 17 Feb 2022 13:08:28 -0500
Message-Id: <20220217180831.288210-4-pbonzini@redhat.com>
In-Reply-To: <20220217180831.288210-1-pbonzini@redhat.com>
References: <20220217180831.288210-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The original use of KVM_X86_OP_NULL, which was to mark calls
that do not follow a specific naming convention, is not in use
anymore.  Instead, let's mark calls that are optional because
they are always invoked within conditionals or with static_call_cond.
Those that are _not_, i.e. those that are defined with KVM_X86_OP,
must be defined by both vendor modules or some kind of NULL pointer
dereference is bound to happen at runtime.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 86 +++++++++++++++---------------
 arch/x86/include/asm/kvm_host.h    |  4 +-
 arch/x86/kvm/x86.c                 |  2 +-
 3 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 695ed7feef7e..5e3296c07207 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -1,24 +1,24 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#if !defined(KVM_X86_OP) || !defined(KVM_X86_OP_NULL)
+#if !defined(KVM_X86_OP) || !defined(KVM_X86_OP_OPTIONAL)
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
+ * KVM_X86_OP() and KVM_X86_OP_OPTIONAL() are used to help generate
+ * both DECLARE/DEFINE_STATIC_CALL() invocations and
+ * "static_call_update()" calls.
+ *
+ * KVM_X86_OP_OPTIONAL() can be used for those functions that can have
+ * a NULL definition, for example if "static_call_cond()" will be used
+ * at the call sites.
  */
-KVM_X86_OP_NULL(hardware_enable)
-KVM_X86_OP_NULL(hardware_disable)
-KVM_X86_OP_NULL(hardware_unsetup)
+KVM_X86_OP(hardware_enable)
+KVM_X86_OP(hardware_disable)
+KVM_X86_OP(hardware_unsetup)
 KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(vm_init)
-KVM_X86_OP_NULL(vm_destroy)
+KVM_X86_OP_OPTIONAL(vm_destroy)
 KVM_X86_OP(vcpu_create)
 KVM_X86_OP(vcpu_free)
 KVM_X86_OP(vcpu_reset)
@@ -32,9 +32,9 @@ KVM_X86_OP(get_segment_base)
 KVM_X86_OP(get_segment)
 KVM_X86_OP(get_cpl)
 KVM_X86_OP(set_segment)
-KVM_X86_OP_NULL(get_cs_db_l_bits)
+KVM_X86_OP(get_cs_db_l_bits)
 KVM_X86_OP(set_cr0)
-KVM_X86_OP_NULL(post_set_cr3)
+KVM_X86_OP_OPTIONAL(post_set_cr3)
 KVM_X86_OP(is_valid_cr4)
 KVM_X86_OP(set_cr4)
 KVM_X86_OP(set_efer)
@@ -50,15 +50,15 @@ KVM_X86_OP(set_rflags)
 KVM_X86_OP(get_if_flag)
 KVM_X86_OP(flush_tlb_all)
 KVM_X86_OP(flush_tlb_current)
-KVM_X86_OP_NULL(tlb_remote_flush)
-KVM_X86_OP_NULL(tlb_remote_flush_with_range)
+KVM_X86_OP_OPTIONAL(tlb_remote_flush)
+KVM_X86_OP_OPTIONAL(tlb_remote_flush_with_range)
 KVM_X86_OP(flush_tlb_gva)
 KVM_X86_OP(flush_tlb_guest)
 KVM_X86_OP(vcpu_pre_run)
 KVM_X86_OP(vcpu_run)
-KVM_X86_OP_NULL(handle_exit)
-KVM_X86_OP_NULL(skip_emulated_instruction)
-KVM_X86_OP_NULL(update_emulated_instruction)
+KVM_X86_OP(handle_exit)
+KVM_X86_OP(skip_emulated_instruction)
+KVM_X86_OP_OPTIONAL(update_emulated_instruction)
 KVM_X86_OP(set_interrupt_shadow)
 KVM_X86_OP(get_interrupt_shadow)
 KVM_X86_OP(patch_hypercall)
@@ -72,22 +72,22 @@ KVM_X86_OP(get_nmi_mask)
 KVM_X86_OP(set_nmi_mask)
 KVM_X86_OP(enable_nmi_window)
 KVM_X86_OP(enable_irq_window)
-KVM_X86_OP(update_cr8_intercept)
+KVM_X86_OP_OPTIONAL(update_cr8_intercept)
 KVM_X86_OP(check_apicv_inhibit_reasons)
 KVM_X86_OP(refresh_apicv_exec_ctrl)
 KVM_X86_OP(hwapic_irr_update)
 KVM_X86_OP(hwapic_isr_update)
-KVM_X86_OP_NULL(guest_apic_has_interrupt)
+KVM_X86_OP_OPTIONAL(guest_apic_has_interrupt)
 KVM_X86_OP(load_eoi_exitmap)
 KVM_X86_OP(set_virtual_apic_mode)
-KVM_X86_OP_NULL(set_apic_access_page_addr)
+KVM_X86_OP_OPTIONAL(set_apic_access_page_addr)
 KVM_X86_OP(deliver_interrupt)
-KVM_X86_OP_NULL(sync_pir_to_irr)
+KVM_X86_OP_OPTIONAL(sync_pir_to_irr)
 KVM_X86_OP(set_tss_addr)
 KVM_X86_OP(set_identity_map_addr)
 KVM_X86_OP(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
-KVM_X86_OP_NULL(has_wbinvd_exit)
+KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
 KVM_X86_OP(write_tsc_offset)
@@ -95,35 +95,35 @@ KVM_X86_OP(write_tsc_multiplier)
 KVM_X86_OP(get_exit_info)
 KVM_X86_OP(check_intercept)
 KVM_X86_OP(handle_exit_irqoff)
-KVM_X86_OP_NULL(request_immediate_exit)
+KVM_X86_OP(request_immediate_exit)
 KVM_X86_OP(sched_in)
-KVM_X86_OP_NULL(update_cpu_dirty_logging)
-KVM_X86_OP_NULL(vcpu_blocking)
-KVM_X86_OP_NULL(vcpu_unblocking)
-KVM_X86_OP_NULL(pi_update_irte)
-KVM_X86_OP_NULL(pi_start_assignment)
-KVM_X86_OP_NULL(apicv_post_state_restore)
-KVM_X86_OP_NULL(dy_apicv_has_pending_interrupt)
-KVM_X86_OP_NULL(set_hv_timer)
-KVM_X86_OP_NULL(cancel_hv_timer)
+KVM_X86_OP_OPTIONAL(update_cpu_dirty_logging)
+KVM_X86_OP_OPTIONAL(vcpu_blocking)
+KVM_X86_OP_OPTIONAL(vcpu_unblocking)
+KVM_X86_OP_OPTIONAL(pi_update_irte)
+KVM_X86_OP_OPTIONAL(pi_start_assignment)
+KVM_X86_OP(apicv_post_state_restore)
+KVM_X86_OP_OPTIONAL(dy_apicv_has_pending_interrupt)
+KVM_X86_OP_OPTIONAL(set_hv_timer)
+KVM_X86_OP_OPTIONAL(cancel_hv_timer)
 KVM_X86_OP(setup_mce)
 KVM_X86_OP(smi_allowed)
 KVM_X86_OP(enter_smm)
 KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
-KVM_X86_OP_NULL(mem_enc_ioctl)
-KVM_X86_OP_NULL(mem_enc_register_region)
-KVM_X86_OP_NULL(mem_enc_unregister_region)
-KVM_X86_OP_NULL(vm_copy_enc_context_from)
-KVM_X86_OP_NULL(vm_move_enc_context_from)
+KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
+KVM_X86_OP_OPTIONAL(mem_enc_register_region)
+KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
+KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
+KVM_X86_OP_OPTIONAL(vm_move_enc_context_from)
 KVM_X86_OP(get_msr_feature)
 KVM_X86_OP(can_emulate_instruction)
 KVM_X86_OP(apic_init_signal_blocked)
-KVM_X86_OP_NULL(enable_direct_tlbflush)
-KVM_X86_OP_NULL(migrate_timers)
+KVM_X86_OP_OPTIONAL(enable_direct_tlbflush)
+KVM_X86_OP_OPTIONAL(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
-KVM_X86_OP_NULL(complete_emulated_msr)
+KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 
 #undef KVM_X86_OP
-#undef KVM_X86_OP_NULL
+#undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e0d2cdfe54ab..7d733f601106 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1540,14 +1540,14 @@ extern struct kvm_x86_ops kvm_x86_ops;
 
 #define KVM_X86_OP(func) \
 	DECLARE_STATIC_CALL(kvm_x86_##func, *(((struct kvm_x86_ops *)0)->func));
-#define KVM_X86_OP_NULL KVM_X86_OP
+#define KVM_X86_OP_OPTIONAL KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 
 static inline void kvm_ops_static_call_update(void)
 {
 #define KVM_X86_OP(func) \
 	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
-#define KVM_X86_OP_NULL KVM_X86_OP
+#define KVM_X86_OP_OPTIONAL KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8a7f32563590..c3d44e6a3454 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -130,7 +130,7 @@ struct kvm_x86_ops kvm_x86_ops __read_mostly;
 #define KVM_X86_OP(func)					     \
 	DEFINE_STATIC_CALL_NULL(kvm_x86_##func,			     \
 				*(((struct kvm_x86_ops *)0)->func));
-#define KVM_X86_OP_NULL KVM_X86_OP
+#define KVM_X86_OP_OPTIONAL KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
 EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
-- 
2.31.1


