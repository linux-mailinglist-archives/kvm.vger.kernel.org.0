Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFE22F70FC
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 04:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732539AbhAODb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 22:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729964AbhAODbY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 22:31:24 -0500
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1630CC0613CF;
        Thu, 14 Jan 2021 19:30:44 -0800 (PST)
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
        by m0050102.ppops.net-00190b01. (8.16.0.43/8.16.0.43) with SMTP id 10F3QGgS005334;
        Fri, 15 Jan 2021 03:30:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : in-reply-to :
 references; s=jan2016.eng;
 bh=Sie+75CDyg+5V+WNE5OGf67vTJtnUQrS1frTPXNku/Y=;
 b=POWW2Vr604R6uDO6FVFZyZFikHaL8tskilxB5WYuYDd/iTw9PNLguVadnNCIgkMQzoWo
 lJLkIPiwDmLUCv85d6r12/QevevBr5atLQnD0DSuXo5QqBifNADF8YRxgxY0Og/I7B+P
 pj2/Q5t+Pkifw99AinsCoWFIeOaOb8NjxtmzN8Dgdh3TSTTU9oUNDHvpK+3DWrD9JuVY
 e4JUDViSpgqZwC8lPffsqX6mmRQAGyElPHuWlaVsm6LH/g3dR22LLjGajsxsvYf98dIZ
 nMu1BfOjySWg9Nobg1EDSJ0u4+dYW3DBPH/+dS5OiwYfKxNtqT0gzHUnBs2/QOxOFt79 aA== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by m0050102.ppops.net-00190b01. with ESMTP id 35yq24wqfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 03:30:18 +0000
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.16.0.43/8.16.0.43) with SMTP id 10F3Puj4007105;
        Thu, 14 Jan 2021 19:30:18 -0800
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint5.akamai.com with ESMTP id 35ybbec9sy-1;
        Thu, 14 Jan 2021 19:30:18 -0800
Received: from bos-lpjec.145bw.corp.akamai.com (bos-lpjec.145bw.corp.akamai.com [172.28.3.71])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id 145FD406A3;
        Fri, 15 Jan 2021 03:30:18 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v2 2/3] KVM: x86: introduce definitions to support static calls for kvm_x86_ops
Date:   Thu, 14 Jan 2021 22:27:55 -0500
Message-Id: <e5cc82ead7ab37b2dceb0837a514f3f8bea4f8d1.1610680941.git.jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1610680941.git.jbaron@akamai.com>
References: <cover.1610680941.git.jbaron@akamai.com>
In-Reply-To: <cover.1610680941.git.jbaron@akamai.com>
References: <cover.1610680941.git.jbaron@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_01:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=624 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150015
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_01:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=579 spamscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150015
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.60)
 smtp.mailfrom=jbaron@akamai.com smtp.helo=prod-mail-ppoint5
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use static calls to improve kvm_x86_ops performance. Introduce the
definitions that will be used by a subsequent patch to actualize the
savings. Add a new kvm-x86-ops.h header that can be used for the
definition of static calls. This header is also intended to be
used to simplify the defition of svm_kvm_ops and vmx_x86_ops.

Note that all functions in kvm_x86_ops are covered here except for
'pmu_ops' and 'nested ops'. I think they can be covered by static
calls in a simlilar manner, but were omitted from this series to
reduce scope and because I don't think they have as large of a
performance impact.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 127 +++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h    |  13 ++++
 arch/x86/kvm/x86.c                 |   9 +++
 3 files changed, 149 insertions(+)
 create mode 100644 arch/x86/include/asm/kvm-x86-ops.h

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
new file mode 100644
index 0000000..355a2ab
--- /dev/null
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -0,0 +1,127 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#if !defined(KVM_X86_OP) || !defined(KVM_X86_OP_NULL)
+BUILD_BUG_ON(1)
+#endif
+
+/*
+ * KVM_X86_OP() and KVM_X86_OP_NULL() are used to help generate
+ * "static_call()"s. They are also intended for use when defining
+ * the vmx/svm kvm_x86_ops. KVM_X86_OP() can be used for those
+ * functions that follow the [svm|vmx]_func_name convention.
+ * KVM_X86_OP_NULL() can leave a NULL definition for the
+ * case where there is no definition or a function name that
+ * doesn't match the typical naming convention is supplied.
+ */
+KVM_X86_OP_NULL(hardware_enable)
+KVM_X86_OP_NULL(hardware_disable)
+KVM_X86_OP_NULL(hardware_unsetup)
+KVM_X86_OP_NULL(cpu_has_accelerated_tpr)
+KVM_X86_OP(has_emulated_msr)
+KVM_X86_OP(vcpu_after_set_cpuid)
+KVM_X86_OP(vm_init)
+KVM_X86_OP_NULL(vm_destroy)
+KVM_X86_OP(vcpu_create)
+KVM_X86_OP(vcpu_free)
+KVM_X86_OP(vcpu_reset)
+KVM_X86_OP(prepare_guest_switch)
+KVM_X86_OP(vcpu_load)
+KVM_X86_OP(vcpu_put)
+KVM_X86_OP(update_exception_bitmap)
+KVM_X86_OP(get_msr)
+KVM_X86_OP(set_msr)
+KVM_X86_OP(get_segment_base)
+KVM_X86_OP(get_segment)
+KVM_X86_OP(get_cpl)
+KVM_X86_OP(set_segment)
+KVM_X86_OP_NULL(get_cs_db_l_bits)
+KVM_X86_OP(set_cr0)
+KVM_X86_OP(is_valid_cr4)
+KVM_X86_OP(set_cr4)
+KVM_X86_OP(set_efer)
+KVM_X86_OP(get_idt)
+KVM_X86_OP(set_idt)
+KVM_X86_OP(get_gdt)
+KVM_X86_OP(set_gdt)
+KVM_X86_OP(sync_dirty_debug_regs)
+KVM_X86_OP(set_dr7)
+KVM_X86_OP(cache_reg)
+KVM_X86_OP(get_rflags)
+KVM_X86_OP(set_rflags)
+KVM_X86_OP(tlb_flush_all)
+KVM_X86_OP(tlb_flush_current)
+KVM_X86_OP_NULL(tlb_remote_flush)
+KVM_X86_OP_NULL(tlb_remote_flush_with_range)
+KVM_X86_OP(tlb_flush_gva)
+KVM_X86_OP(tlb_flush_guest)
+KVM_X86_OP(run)
+KVM_X86_OP_NULL(handle_exit)
+KVM_X86_OP_NULL(skip_emulated_instruction)
+KVM_X86_OP_NULL(update_emulated_instruction)
+KVM_X86_OP(set_interrupt_shadow)
+KVM_X86_OP(get_interrupt_shadow)
+KVM_X86_OP(patch_hypercall)
+KVM_X86_OP(set_irq)
+KVM_X86_OP(set_nmi)
+KVM_X86_OP(queue_exception)
+KVM_X86_OP(cancel_injection)
+KVM_X86_OP(interrupt_allowed)
+KVM_X86_OP(nmi_allowed)
+KVM_X86_OP(get_nmi_mask)
+KVM_X86_OP(set_nmi_mask)
+KVM_X86_OP(enable_nmi_window)
+KVM_X86_OP(enable_irq_window)
+KVM_X86_OP(update_cr8_intercept)
+KVM_X86_OP(check_apicv_inhibit_reasons)
+KVM_X86_OP_NULL(pre_update_apicv_exec_ctrl)
+KVM_X86_OP(refresh_apicv_exec_ctrl)
+KVM_X86_OP(hwapic_irr_update)
+KVM_X86_OP(hwapic_isr_update)
+KVM_X86_OP_NULL(guest_apic_has_interrupt)
+KVM_X86_OP(load_eoi_exitmap)
+KVM_X86_OP(set_virtual_apic_mode)
+KVM_X86_OP_NULL(set_apic_access_page_addr)
+KVM_X86_OP(deliver_posted_interrupt)
+KVM_X86_OP_NULL(sync_pir_to_irr)
+KVM_X86_OP(set_tss_addr)
+KVM_X86_OP(set_identity_map_addr)
+KVM_X86_OP(get_mt_mask)
+KVM_X86_OP(load_mmu_pgd)
+KVM_X86_OP_NULL(has_wbinvd_exit)
+KVM_X86_OP(write_l1_tsc_offset)
+KVM_X86_OP(get_exit_info)
+KVM_X86_OP(check_intercept)
+KVM_X86_OP(handle_exit_irqoff)
+KVM_X86_OP_NULL(request_immediate_exit)
+KVM_X86_OP(sched_in)
+KVM_X86_OP_NULL(slot_enable_log_dirty)
+KVM_X86_OP_NULL(slot_disable_log_dirty)
+KVM_X86_OP_NULL(flush_log_dirty)
+KVM_X86_OP_NULL(enable_log_dirty_pt_masked)
+KVM_X86_OP_NULL(cpu_dirty_log_size)
+KVM_X86_OP_NULL(pre_block)
+KVM_X86_OP_NULL(post_block)
+KVM_X86_OP_NULL(vcpu_blocking)
+KVM_X86_OP_NULL(vcpu_unblocking)
+KVM_X86_OP_NULL(update_pi_irte)
+KVM_X86_OP_NULL(apicv_post_state_restore)
+KVM_X86_OP_NULL(dy_apicv_has_pending_interrupt)
+KVM_X86_OP_NULL(set_hv_timer)
+KVM_X86_OP_NULL(cancel_hv_timer)
+KVM_X86_OP(setup_mce)
+KVM_X86_OP(smi_allowed)
+KVM_X86_OP(pre_enter_smm)
+KVM_X86_OP(pre_leave_smm)
+KVM_X86_OP(enable_smi_window)
+KVM_X86_OP_NULL(mem_enc_op)
+KVM_X86_OP_NULL(mem_enc_reg_region)
+KVM_X86_OP_NULL(mem_enc_unreg_region)
+KVM_X86_OP(get_msr_feature)
+KVM_X86_OP(can_emulate_instruction)
+KVM_X86_OP(apic_init_signal_blocked)
+KVM_X86_OP_NULL(enable_direct_tlbflush)
+KVM_X86_OP_NULL(migrate_timers)
+KVM_X86_OP(msr_filter_changed)
+KVM_X86_OP_NULL(complete_emulated_msr)
+
+#undef KVM_X86_OP
+#undef KVM_X86_OP_NULL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3ab7b46..5060922 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1326,6 +1326,19 @@ extern u64 __read_mostly host_efer;
 extern bool __read_mostly allow_smaller_maxphyaddr;
 extern struct kvm_x86_ops kvm_x86_ops;
 
+#define KVM_X86_OP(func) \
+	DECLARE_STATIC_CALL(kvm_x86_##func, *(((struct kvm_x86_ops *)0)->func));
+#define KVM_X86_OP_NULL KVM_X86_OP
+#include <asm/kvm-x86-ops.h>
+
+static inline void kvm_ops_static_call_update(void)
+{
+#define KVM_X86_OP(func) \
+	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
+#define KVM_X86_OP_NULL KVM_X86_OP
+#include <asm/kvm-x86-ops.h>
+}
+
 #define __KVM_HAVE_ARCH_VM_ALLOC
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3f7c1fc..c21927f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -113,6 +113,15 @@ static int sync_regs(struct kvm_vcpu *vcpu);
 struct kvm_x86_ops kvm_x86_ops __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_x86_ops);
 
+#define KVM_X86_OP(func)					     \
+	DEFINE_STATIC_CALL_NULL(kvm_x86_##func,			     \
+				*(((struct kvm_x86_ops *)0)->func));
+#define KVM_X86_OP_NULL KVM_X86_OP
+#include <asm/kvm-x86-ops.h>
+EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
+EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
+EXPORT_STATIC_CALL_GPL(kvm_x86_tlb_flush_current);
+
 static bool __read_mostly ignore_msrs = 0;
 module_param(ignore_msrs, bool, S_IRUGO | S_IWUSR);
 
-- 
2.7.4

