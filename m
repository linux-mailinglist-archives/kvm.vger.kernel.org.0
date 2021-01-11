Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF31C2F1C37
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 18:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389455AbhAKRW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 12:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389190AbhAKRW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 12:22:28 -0500
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B25EC061794;
        Mon, 11 Jan 2021 09:21:48 -0800 (PST)
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
        by m0050102.ppops.net-00190b01. (8.16.0.43/8.16.0.43) with SMTP id 10BGxmHx031812;
        Mon, 11 Jan 2021 17:00:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : in-reply-to :
 references; s=jan2016.eng;
 bh=dglWV6e1a4y6WpadEHuansAWTupX/SHWQYswrhyYurY=;
 b=FGkwO1S3tb/Ton5Y1/LvjasxFJQjkWLOATpznce2CGBeZ340pZ+p3YdMkOEAuHRSmkbu
 lZwgf8Z91mgA7tKzGJ2hS9lxz4qbPHLa5wTS1BNdCkq7cE2cWVMvx1sdYybMDW96jNGV
 izA9cYcIZ+QJxftYs/7XP8vMT3v1zRvAqMCZL1QGaYkmD2Vl2vOlZb0K0FbTRVle+40F
 RHzAsoZn6uRA9oY3+VbSFA+Y0DmqX0hLu8gomX94vYDaPXZ5ZEH2k6U01Xd/22IB86v0
 2QSjCMeC+uI5lEZdlGUdKlFhgurv0Im0I4jz3bM3v+aZ8Sqwo40p1OckUnldO8i/XSgR Mw== 
Received: from prod-mail-ppoint4 (a72-247-45-32.deploy.static.akamaitechnologies.com [72.247.45.32] (may be forged))
        by m0050102.ppops.net-00190b01. with ESMTP id 35yq20bute-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 17:00:24 +0000
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
        by prod-mail-ppoint4.akamai.com (8.16.0.43/8.16.0.43) with SMTP id 10BGn2GY017989;
        Mon, 11 Jan 2021 12:00:08 -0500
Received: from prod-mail-relay18.dfw02.corp.akamai.com ([172.27.165.172])
        by prod-mail-ppoint4.akamai.com with ESMTP id 35y8q31r00-1;
        Mon, 11 Jan 2021 12:00:07 -0500
Received: from bos-lpjec.145bw.corp.akamai.com (unknown [172.28.3.71])
        by prod-mail-relay18.dfw02.corp.akamai.com (Postfix) with ESMTP id 58EB2400;
        Mon, 11 Jan 2021 17:00:07 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, aarcange@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86: introduce definitions to support static calls for kvm_x86_ops
Date:   Mon, 11 Jan 2021 11:57:27 -0500
Message-Id: <ce483ce4a1920a3c1c4e5deea11648d75f2a7b80.1610379877.git.jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1610379877.git.jbaron@akamai.com>
References: <cover.1610379877.git.jbaron@akamai.com>
In-Reply-To: <cover.1610379877.git.jbaron@akamai.com>
References: <cover.1610379877.git.jbaron@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_28:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=486
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110098
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_28:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=392 spamscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110099
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.32)
 smtp.mailfrom=jbaron@akamai.com smtp.helo=prod-mail-ppoint4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use static calls to improve kvm_x86_ops performance. Introduce the
definitions that will be used by a subsequent patch to actualize the
savings.

Note that all kvm_x86_ops are covered here except for 'pmu_ops' and
'nested ops'. I think they can be covered by static calls in a simlilar
manner, but were omitted from this series to reduce scope and because
I don't think they have as large of a performance impact.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 arch/x86/include/asm/kvm_host.h | 65 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |  5 ++++
 2 files changed, 70 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3ab7b46..e947522 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1087,6 +1087,65 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 	return dest_mode_logical ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
 }
 
+/*
+ * static calls cover all kvm_x86_ops except for functions under pmu_ops and
+ * nested_ops.
+ */
+#define FOREACH_KVM_X86_OPS(F) \
+	F(hardware_enable); F(hardware_disable); F(hardware_unsetup);	       \
+	F(cpu_has_accelerated_tpr); F(has_emulated_msr);		       \
+	F(vcpu_after_set_cpuid); F(vm_init); F(vm_destroy); F(vcpu_create);    \
+	F(vcpu_free); F(vcpu_reset); F(prepare_guest_switch); F(vcpu_load);    \
+	F(vcpu_put); F(update_exception_bitmap); F(get_msr); F(set_msr);       \
+	F(get_segment_base); F(get_segment); F(get_cpl); F(set_segment);       \
+	F(get_cs_db_l_bits); F(set_cr0); F(is_valid_cr4); F(set_cr4);	       \
+	F(set_efer); F(get_idt); F(set_idt); F(get_gdt); F(set_gdt);	       \
+	F(sync_dirty_debug_regs); F(set_dr7); F(cache_reg); F(get_rflags);     \
+	F(set_rflags); F(tlb_flush_all); F(tlb_flush_current);		       \
+	F(tlb_remote_flush); F(tlb_remote_flush_with_range); F(tlb_flush_gva); \
+	F(tlb_flush_guest); F(run); F(handle_exit);			       \
+	F(skip_emulated_instruction); F(update_emulated_instruction);	       \
+	F(set_interrupt_shadow); F(get_interrupt_shadow); F(patch_hypercall);  \
+	F(set_irq); F(set_nmi); F(queue_exception); F(cancel_injection);       \
+	F(interrupt_allowed); F(nmi_allowed); F(get_nmi_mask); F(set_nmi_mask);\
+	F(enable_nmi_window); F(enable_irq_window); F(update_cr8_intercept);   \
+	F(check_apicv_inhibit_reasons); F(pre_update_apicv_exec_ctrl);	       \
+	F(refresh_apicv_exec_ctrl); F(hwapic_irr_update); F(hwapic_isr_update);\
+	F(guest_apic_has_interrupt); F(load_eoi_exitmap);		       \
+	F(set_virtual_apic_mode); F(set_apic_access_page_addr);		       \
+	F(deliver_posted_interrupt); F(sync_pir_to_irr); F(set_tss_addr);      \
+	F(set_identity_map_addr); F(get_mt_mask); F(load_mmu_pgd);	       \
+	F(has_wbinvd_exit); F(write_l1_tsc_offset); F(get_exit_info);	       \
+	F(check_intercept); F(handle_exit_irqoff); F(request_immediate_exit);  \
+	F(sched_in); F(slot_enable_log_dirty); F(slot_disable_log_dirty);      \
+	F(flush_log_dirty); F(enable_log_dirty_pt_masked);		       \
+	F(cpu_dirty_log_size); F(pre_block); F(post_block); F(vcpu_blocking);  \
+	F(vcpu_unblocking); F(update_pi_irte); F(apicv_post_state_restore);    \
+	F(dy_apicv_has_pending_interrupt); F(set_hv_timer); F(cancel_hv_timer);\
+	F(setup_mce); F(smi_allowed); F(pre_enter_smm); F(pre_leave_smm);      \
+	F(enable_smi_window); F(mem_enc_op); F(mem_enc_reg_region);	       \
+	F(mem_enc_unreg_region); F(get_msr_feature);			       \
+	F(can_emulate_instruction); F(apic_init_signal_blocked);	       \
+	F(enable_direct_tlbflush); F(migrate_timers); F(msr_filter_changed);   \
+	F(complete_emulated_msr)
+
+#define DEFINE_KVM_OPS_STATIC_CALL(func)	\
+	DEFINE_STATIC_CALL_NULL(kvm_x86_##func,	\
+				*(((struct kvm_x86_ops *)0)->func))
+#define DEFINE_KVM_OPS_STATIC_CALLS() \
+	FOREACH_KVM_X86_OPS(DEFINE_KVM_OPS_STATIC_CALL)
+
+#define DECLARE_KVM_OPS_STATIC_CALL(func)	\
+	DECLARE_STATIC_CALL(kvm_x86_##func,	\
+			    *(((struct kvm_x86_ops *)0)->func))
+#define DECLARE_KVM_OPS_STATIC_CALLS()		\
+	FOREACH_KVM_X86_OPS(DECLARE_KVM_OPS_STATIC_CALL)
+
+#define KVM_OPS_STATIC_CALL_UPDATE(func)	\
+	static_call_update(kvm_x86_##func, kvm_x86_ops.func)
+#define KVM_OPS_STATIC_CALL_UPDATES()		\
+	FOREACH_KVM_X86_OPS(KVM_OPS_STATIC_CALL_UPDATE)
+
 struct kvm_x86_ops {
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
@@ -1326,6 +1385,12 @@ extern u64 __read_mostly host_efer;
 extern bool __read_mostly allow_smaller_maxphyaddr;
 extern struct kvm_x86_ops kvm_x86_ops;
 
+DECLARE_KVM_OPS_STATIC_CALLS();
+static inline void kvm_ops_static_call_update(void)
+{
+	KVM_OPS_STATIC_CALL_UPDATES();
+}
+
 #define __KVM_HAVE_ARCH_VM_ALLOC
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3f7c1fc..6ae32ab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -113,6 +113,11 @@ static int sync_regs(struct kvm_vcpu *vcpu);
 struct kvm_x86_ops kvm_x86_ops __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_x86_ops);
 
+DEFINE_KVM_OPS_STATIC_CALLS();
+EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
+EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
+EXPORT_STATIC_CALL_GPL(kvm_x86_tlb_flush_current);
+
 static bool __read_mostly ignore_msrs = 0;
 module_param(ignore_msrs, bool, S_IRUGO | S_IWUSR);
 
-- 
2.7.4

