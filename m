Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8A922B98C
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 00:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgGWWdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 18:33:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60848 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgGWWdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 18:33:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06NMLOkG081949;
        Thu, 23 Jul 2020 22:32:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=92kUA74Ian40HlxMnm3Y3R2uvKyQcBqSZ1k45VxFz94=;
 b=GpU9rin1B32XuNiRU3NdAoal8HG4qBdQHiHFn5KyJ9Om9PLqWkWO+7pdruAdmAPMv5Tf
 dSdSdrsp+IAlMoXxhPrtQ5vMgh7+i7lsxqrUlZ9CSn5zSBep9EROIAOGZEgyoEJKX5y5
 B0NoHZiMARXImDVR90RFzdShxFix4PpnkdYzWZc12i4/EXsw2BAjdL5WgtGNBTYMkpte
 k60o5a+Rxcwle5HTFeDKSOFu/i9kRc72eT07eSpRSON2MBiADeqKf/jXi9hfQP4BRLY9
 nK0HG0VsvF9EKSTFdnfo7rYcqpnwvRkVNUoiaBOahlfX66ZqGc4y+RHyLpnTkvh7rUlQ yg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32bs1mv6nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 Jul 2020 22:32:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06NMWgON023993;
        Thu, 23 Jul 2020 22:32:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 32ffm7xcmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jul 2020 22:32:51 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06NMW82a009000;
        Thu, 23 Jul 2020 22:32:08 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.231.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jul 2020 15:32:07 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com
Subject: [PATCH] KVM: x86: Fill in conforming {vmx|svm}_x86_ops and {vmx|svm}_nested_ops via macro
Date:   Thu, 23 Jul 2020 22:31:58 +0000
Message-Id: <1595543518-72310-2-git-send-email-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595543518-72310-1-git-send-email-krish.sadhukhan@oracle.com>
References: <1595543518-72310-1-git-send-email-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9691 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=4
 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9691 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007230156
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The names of some of the implemented kvm_x86_ops do not have a corresponding
'vmx_' or 'svm_' prefix. Also, the order of the words in some of the names
do not conform to that in the kvm_x86_ops structure. Fixing the naming will
help in better readability and maintenance of the code.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/include/asm/kvm_host.h |  12 +-
 arch/x86/kvm/svm/avic.c         |   4 +-
 arch/x86/kvm/svm/nested.c       |  16 +--
 arch/x86/kvm/svm/sev.c          |   4 +-
 arch/x86/kvm/svm/svm.c          | 218 ++++++++++++++++++------------------
 arch/x86/kvm/svm/svm.h          |   8 +-
 arch/x86/kvm/vmx/nested.c       |  26 +++--
 arch/x86/kvm/vmx/nested.h       |   2 +-
 arch/x86/kvm/vmx/vmx.c          | 238 ++++++++++++++++++++--------------------
 arch/x86/kvm/vmx/vmx.h          |   2 +-
 arch/x86/kvm/x86.c              |  20 ++--
 11 files changed, 279 insertions(+), 271 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index be5363b..ccad66d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1080,7 +1080,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 struct kvm_x86_ops {
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
-	void (*hardware_unsetup)(void);
+	void (*hardware_teardown)(void);
 	bool (*cpu_has_accelerated_tpr)(void);
 	bool (*has_emulated_msr)(u32 index);
 	void (*cpuid_update)(struct kvm_vcpu *vcpu);
@@ -1141,7 +1141,7 @@ struct kvm_x86_ops {
 	 */
 	void (*tlb_flush_guest)(struct kvm_vcpu *vcpu);
 
-	enum exit_fastpath_completion (*run)(struct kvm_vcpu *vcpu);
+	enum exit_fastpath_completion (*vcpu_run)(struct kvm_vcpu *vcpu);
 	int (*handle_exit)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion exit_fastpath);
 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
@@ -1150,8 +1150,8 @@ struct kvm_x86_ops {
 	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
 	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
 				unsigned char *hypercall_addr);
-	void (*set_irq)(struct kvm_vcpu *vcpu);
-	void (*set_nmi)(struct kvm_vcpu *vcpu);
+	void (*inject_irq)(struct kvm_vcpu *vcpu);
+	void (*inject_nmi)(struct kvm_vcpu *vcpu);
 	void (*queue_exception)(struct kvm_vcpu *vcpu);
 	void (*cancel_injection)(struct kvm_vcpu *vcpu);
 	int (*interrupt_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
@@ -1258,8 +1258,8 @@ struct kvm_x86_ops {
 	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
 
 	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
-	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
-	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
+	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
+	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 
 	int (*get_msr_feature)(struct kvm_msr_entry *entry);
 
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index e80daa9..619391e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -579,7 +579,7 @@ int avic_init_vcpu(struct vcpu_svm *svm)
 	return ret;
 }
 
-void avic_post_state_restore(struct kvm_vcpu *vcpu)
+void svm_avic_post_state_restore(struct kvm_vcpu *vcpu)
 {
 	if (avic_handle_apic_id_update(vcpu) != 0)
 		return;
@@ -660,7 +660,7 @@ void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 		 * we need to check and update the AVIC logical APIC ID table
 		 * accordingly before re-activating.
 		 */
-		avic_post_state_restore(vcpu);
+		svm_avic_post_state_restore(vcpu);
 		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
 	} else {
 		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6bceafb..58bc6a9 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -348,7 +348,7 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 	/* Guest paging mode is active - reset mmu */
 	kvm_mmu_reset_context(&svm->vcpu);
 
-	svm_flush_tlb(&svm->vcpu);
+	svm_tlb_flush(&svm->vcpu);
 
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
 		svm->vcpu.arch.l1_tsc_offset + svm->nested.ctl.tsc_offset;
@@ -850,7 +850,7 @@ static void nested_svm_init(struct vcpu_svm *svm)
 }
 
 
-static int svm_check_nested_events(struct kvm_vcpu *vcpu)
+static int nested_svm_check_events(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool block_nested_events =
@@ -933,7 +933,7 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 	return NESTED_EXIT_CONTINUE;
 }
 
-static int svm_get_nested_state(struct kvm_vcpu *vcpu,
+static int nested_svm_get_state(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state __user *user_kvm_nested_state,
 				u32 user_data_size)
 {
@@ -990,7 +990,7 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 	return kvm_state.size;
 }
 
-static int svm_set_nested_state(struct kvm_vcpu *vcpu,
+static int nested_svm_set_state(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state __user *user_kvm_nested_state,
 				struct kvm_nested_state *kvm_state)
 {
@@ -1075,8 +1075,10 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+#define KVM_X86_NESTED_OP(name) .name = nested_svm_##name
+
 struct kvm_x86_nested_ops svm_nested_ops = {
-	.check_events = svm_check_nested_events,
-	.get_state = svm_get_nested_state,
-	.set_state = svm_set_nested_state,
+	KVM_X86_NESTED_OP(check_events),
+	KVM_X86_NESTED_OP(get_state),
+	KVM_X86_NESTED_OP(set_state),
 };
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5573a97..2af8f37 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -969,7 +969,7 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	return r;
 }
 
-int svm_register_enc_region(struct kvm *kvm,
+int svm_mem_enc_register_region(struct kvm *kvm,
 			    struct kvm_enc_region *range)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -1038,7 +1038,7 @@ static void __unregister_enc_region_locked(struct kvm *kvm,
 	kfree(region);
 }
 
-int svm_unregister_enc_region(struct kvm *kvm,
+int svm_mem_enc_unregister_region(struct kvm *kvm,
 			      struct kvm_enc_region *range)
 {
 	struct enc_region *region;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c0da4dd..d63181e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -254,7 +254,7 @@ static inline void invlpga(unsigned long addr, u32 asid)
 	asm volatile (__ex("invlpga %1, %0") : : "c"(asid), "a"(addr));
 }
 
-static int get_npt_level(struct kvm_vcpu *vcpu)
+static int svm_get_tdp_level(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
 	return PT64_ROOT_4LEVEL;
@@ -312,7 +312,7 @@ static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 
 }
 
-static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
+static int svm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -351,7 +351,7 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
 		 * raises a fault that is not intercepted. Still better than
 		 * failing in all cases.
 		 */
-		(void)skip_emulated_instruction(&svm->vcpu);
+		(void)svm_skip_emulated_instruction(&svm->vcpu);
 		rip = kvm_rip_read(&svm->vcpu);
 		svm->int3_rip = rip + svm->vmcb->save.cs.base;
 		svm->int3_injected = rip - old_rip;
@@ -1153,7 +1153,7 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		avic_update_vapic_bar(svm, APIC_DEFAULT_PHYS_BASE);
 }
 
-static int svm_create_vcpu(struct kvm_vcpu *vcpu)
+static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm;
 	struct page *page;
@@ -1232,7 +1232,7 @@ static void svm_clear_current_vmcb(struct vmcb *vmcb)
 		cmpxchg(&per_cpu(svm_data, i)->current_vmcb, vmcb, NULL);
 }
 
-static void svm_free_vcpu(struct kvm_vcpu *vcpu)
+static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -1585,7 +1585,7 @@ int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		return 1;
 
 	if (npt_enabled && ((old_cr4 ^ cr4) & X86_CR4_PGE))
-		svm_flush_tlb(vcpu);
+		svm_tlb_flush(vcpu);
 
 	vcpu->arch.cr4 = cr4;
 	if (!npt_enabled)
@@ -1627,7 +1627,7 @@ static void svm_set_segment(struct kvm_vcpu *vcpu,
 	mark_dirty(svm->vmcb, VMCB_SEG);
 }
 
-static void update_bp_intercept(struct kvm_vcpu *vcpu)
+static void svm_update_bp_intercept(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -2143,7 +2143,7 @@ static int task_switch_interception(struct vcpu_svm *svm)
 	    int_type == SVM_EXITINTINFO_TYPE_SOFT ||
 	    (int_type == SVM_EXITINTINFO_TYPE_EXEPT &&
 	     (int_vec == OF_VECTOR || int_vec == BP_VECTOR))) {
-		if (!skip_emulated_instruction(&svm->vcpu))
+		if (!svm_skip_emulated_instruction(&svm->vcpu))
 			return 0;
 	}
 
@@ -2909,7 +2909,7 @@ static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2)
 	*info2 = control->exit_info_2;
 }
 
-static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
+static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_run *kvm_run = vcpu->run;
@@ -3023,7 +3023,7 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 	++vcpu->stat.nmi_injections;
 }
 
-static void svm_set_irq(struct kvm_vcpu *vcpu)
+static void svm_inject_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3036,7 +3036,7 @@ static void svm_set_irq(struct kvm_vcpu *vcpu)
 		SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR;
 }
 
-static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
+static void svm_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3145,7 +3145,7 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	return !svm_interrupt_blocked(vcpu);
 }
 
-static void enable_irq_window(struct kvm_vcpu *vcpu)
+static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3169,7 +3169,7 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void enable_nmi_window(struct kvm_vcpu *vcpu)
+static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3202,7 +3202,7 @@ static int svm_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
 	return 0;
 }
 
-void svm_flush_tlb(struct kvm_vcpu *vcpu)
+void svm_tlb_flush(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3219,7 +3219,7 @@ void svm_flush_tlb(struct kvm_vcpu *vcpu)
 		svm->asid_generation--;
 }
 
-static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
+static void svm_tlb_flush_gva(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3857,7 +3857,7 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	return 0;
 }
 
-static void enable_smi_window(struct kvm_vcpu *vcpu)
+static void svm_enable_smi_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3968,124 +3968,126 @@ static int svm_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+#define KVM_X86_OP(name) .name = svm_##name
+
 static struct kvm_x86_ops svm_x86_ops __initdata = {
-	.hardware_unsetup = svm_hardware_teardown,
-	.hardware_enable = svm_hardware_enable,
-	.hardware_disable = svm_hardware_disable,
-	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
-	.has_emulated_msr = svm_has_emulated_msr,
+	KVM_X86_OP(hardware_teardown),
+	KVM_X86_OP(hardware_enable),
+	KVM_X86_OP(hardware_disable),
+	KVM_X86_OP(cpu_has_accelerated_tpr),
+	KVM_X86_OP(has_emulated_msr),
 
-	.vcpu_create = svm_create_vcpu,
-	.vcpu_free = svm_free_vcpu,
-	.vcpu_reset = svm_vcpu_reset,
+	KVM_X86_OP(vcpu_create),
+	KVM_X86_OP(vcpu_free),
+	KVM_X86_OP(vcpu_reset),
 
 	.vm_size = sizeof(struct kvm_svm),
-	.vm_init = svm_vm_init,
-	.vm_destroy = svm_vm_destroy,
-
-	.prepare_guest_switch = svm_prepare_guest_switch,
-	.vcpu_load = svm_vcpu_load,
-	.vcpu_put = svm_vcpu_put,
-	.vcpu_blocking = svm_vcpu_blocking,
-	.vcpu_unblocking = svm_vcpu_unblocking,
-
-	.update_bp_intercept = update_bp_intercept,
-	.get_msr_feature = svm_get_msr_feature,
-	.get_msr = svm_get_msr,
-	.set_msr = svm_set_msr,
-	.get_segment_base = svm_get_segment_base,
-	.get_segment = svm_get_segment,
-	.set_segment = svm_set_segment,
-	.get_cpl = svm_get_cpl,
+	KVM_X86_OP(vm_init),
+	KVM_X86_OP(vm_destroy),
+
+	KVM_X86_OP(prepare_guest_switch),
+	KVM_X86_OP(vcpu_load),
+	KVM_X86_OP(vcpu_put),
+	KVM_X86_OP(vcpu_blocking),
+	KVM_X86_OP(vcpu_unblocking),
+
+	KVM_X86_OP(update_bp_intercept),
+	KVM_X86_OP(get_msr_feature),
+	KVM_X86_OP(get_msr),
+	KVM_X86_OP(set_msr),
+	KVM_X86_OP(get_segment_base),
+	KVM_X86_OP(get_segment),
+	KVM_X86_OP(set_segment),
+	KVM_X86_OP(get_cpl),
 	.get_cs_db_l_bits = kvm_get_cs_db_l_bits,
-	.set_cr0 = svm_set_cr0,
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
-
-	.tlb_flush_all = svm_flush_tlb,
-	.tlb_flush_current = svm_flush_tlb,
-	.tlb_flush_gva = svm_flush_tlb_gva,
-	.tlb_flush_guest = svm_flush_tlb,
-
-	.run = svm_vcpu_run,
-	.handle_exit = handle_exit,
-	.skip_emulated_instruction = skip_emulated_instruction,
+	KVM_X86_OP(set_cr0),
+	KVM_X86_OP(set_cr4),
+	KVM_X86_OP(set_efer),
+	KVM_X86_OP(get_idt),
+	KVM_X86_OP(set_idt),
+	KVM_X86_OP(get_gdt),
+	KVM_X86_OP(set_gdt),
+	KVM_X86_OP(set_dr7),
+	KVM_X86_OP(sync_dirty_debug_regs),
+	KVM_X86_OP(cache_reg),
+	KVM_X86_OP(get_rflags),
+	KVM_X86_OP(set_rflags),
+
+	.tlb_flush_all = svm_tlb_flush,
+	.tlb_flush_current = svm_tlb_flush,
+	KVM_X86_OP(tlb_flush_gva),
+	.tlb_flush_guest = svm_tlb_flush,
+
+	KVM_X86_OP(vcpu_run),
+	KVM_X86_OP(handle_exit),
+	KVM_X86_OP(skip_emulated_instruction),
 	.update_emulated_instruction = NULL,
-	.set_interrupt_shadow = svm_set_interrupt_shadow,
-	.get_interrupt_shadow = svm_get_interrupt_shadow,
-	.patch_hypercall = svm_patch_hypercall,
-	.set_irq = svm_set_irq,
-	.set_nmi = svm_inject_nmi,
-	.queue_exception = svm_queue_exception,
-	.cancel_injection = svm_cancel_injection,
-	.interrupt_allowed = svm_interrupt_allowed,
-	.nmi_allowed = svm_nmi_allowed,
-	.get_nmi_mask = svm_get_nmi_mask,
-	.set_nmi_mask = svm_set_nmi_mask,
-	.enable_nmi_window = enable_nmi_window,
-	.enable_irq_window = enable_irq_window,
-	.update_cr8_intercept = update_cr8_intercept,
-	.set_virtual_apic_mode = svm_set_virtual_apic_mode,
-	.refresh_apicv_exec_ctrl = svm_refresh_apicv_exec_ctrl,
-	.check_apicv_inhibit_reasons = svm_check_apicv_inhibit_reasons,
-	.pre_update_apicv_exec_ctrl = svm_pre_update_apicv_exec_ctrl,
-	.load_eoi_exitmap = svm_load_eoi_exitmap,
-	.hwapic_irr_update = svm_hwapic_irr_update,
-	.hwapic_isr_update = svm_hwapic_isr_update,
+	KVM_X86_OP(set_interrupt_shadow),
+	KVM_X86_OP(get_interrupt_shadow),
+	KVM_X86_OP(patch_hypercall),
+	KVM_X86_OP(inject_irq),
+	KVM_X86_OP(inject_nmi),
+	KVM_X86_OP(queue_exception),
+	KVM_X86_OP(cancel_injection),
+	KVM_X86_OP(interrupt_allowed),
+	KVM_X86_OP(nmi_allowed),
+	KVM_X86_OP(get_nmi_mask),
+	KVM_X86_OP(set_nmi_mask),
+	KVM_X86_OP(enable_nmi_window),
+	KVM_X86_OP(enable_irq_window),
+	KVM_X86_OP(update_cr8_intercept),
+	KVM_X86_OP(set_virtual_apic_mode),
+	KVM_X86_OP(refresh_apicv_exec_ctrl),
+	KVM_X86_OP(check_apicv_inhibit_reasons),
+	KVM_X86_OP(pre_update_apicv_exec_ctrl),
+	KVM_X86_OP(load_eoi_exitmap),
+	KVM_X86_OP(hwapic_irr_update),
+	KVM_X86_OP(hwapic_isr_update),
 	.sync_pir_to_irr = kvm_lapic_find_highest_irr,
-	.apicv_post_state_restore = avic_post_state_restore,
+	.apicv_post_state_restore = svm_avic_post_state_restore,
 
-	.set_tss_addr = svm_set_tss_addr,
-	.set_identity_map_addr = svm_set_identity_map_addr,
-	.get_tdp_level = get_npt_level,
-	.get_mt_mask = svm_get_mt_mask,
+	KVM_X86_OP(set_tss_addr),
+	KVM_X86_OP(set_identity_map_addr),
+	KVM_X86_OP(get_tdp_level),
+	KVM_X86_OP(get_mt_mask),
 
-	.get_exit_info = svm_get_exit_info,
+	KVM_X86_OP(get_exit_info),
 
-	.cpuid_update = svm_cpuid_update,
+	KVM_X86_OP(cpuid_update),
 
-	.has_wbinvd_exit = svm_has_wbinvd_exit,
+	KVM_X86_OP(has_wbinvd_exit),
 
-	.write_l1_tsc_offset = svm_write_l1_tsc_offset,
+	KVM_X86_OP(write_l1_tsc_offset),
 
-	.load_mmu_pgd = svm_load_mmu_pgd,
+	KVM_X86_OP(load_mmu_pgd),
 
-	.check_intercept = svm_check_intercept,
-	.handle_exit_irqoff = svm_handle_exit_irqoff,
+	KVM_X86_OP(check_intercept),
+	KVM_X86_OP(handle_exit_irqoff),
 
 	.request_immediate_exit = __kvm_request_immediate_exit,
 
-	.sched_in = svm_sched_in,
+	KVM_X86_OP(sched_in),
 
 	.pmu_ops = &amd_pmu_ops,
 	.nested_ops = &svm_nested_ops,
 
 	.deliver_posted_interrupt = svm_deliver_avic_intr,
-	.dy_apicv_has_pending_interrupt = svm_dy_apicv_has_pending_interrupt,
-	.update_pi_irte = svm_update_pi_irte,
-	.setup_mce = svm_setup_mce,
+	KVM_X86_OP(dy_apicv_has_pending_interrupt),
+	KVM_X86_OP(update_pi_irte),
+	KVM_X86_OP(setup_mce),
 
-	.smi_allowed = svm_smi_allowed,
-	.pre_enter_smm = svm_pre_enter_smm,
-	.pre_leave_smm = svm_pre_leave_smm,
-	.enable_smi_window = enable_smi_window,
+	KVM_X86_OP(smi_allowed),
+	KVM_X86_OP(pre_enter_smm),
+	KVM_X86_OP(pre_leave_smm),
+	KVM_X86_OP(enable_smi_window),
 
-	.mem_enc_op = svm_mem_enc_op,
-	.mem_enc_reg_region = svm_register_enc_region,
-	.mem_enc_unreg_region = svm_unregister_enc_region,
+	KVM_X86_OP(mem_enc_op),
+	KVM_X86_OP(mem_enc_register_region),
+	KVM_X86_OP(mem_enc_unregister_region),
 
-	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
+	KVM_X86_OP(need_emulation_on_page_fault),
 
-	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
+	KVM_X86_OP(apic_init_signal_blocked),
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6ac4c00..e2d5029 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -352,7 +352,7 @@ static inline bool gif_set(struct vcpu_svm *svm)
 void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
-void svm_flush_tlb(struct kvm_vcpu *vcpu);
+void svm_tlb_flush(struct kvm_vcpu *vcpu);
 void disable_nmi_singlestep(struct vcpu_svm *svm);
 bool svm_smi_blocked(struct kvm_vcpu *vcpu);
 bool svm_nmi_blocked(struct kvm_vcpu *vcpu);
@@ -444,7 +444,7 @@ static inline bool avic_vcpu_is_running(struct kvm_vcpu *vcpu)
 int avic_init_vcpu(struct vcpu_svm *svm);
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void avic_vcpu_put(struct kvm_vcpu *vcpu);
-void avic_post_state_restore(struct kvm_vcpu *vcpu);
+void svm_avic_post_state_restore(struct kvm_vcpu *vcpu);
 void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
 bool svm_check_apicv_inhibit_reasons(ulong bit);
@@ -481,9 +481,9 @@ static inline bool svm_sev_enabled(void)
 
 void sev_vm_destroy(struct kvm *kvm);
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp);
-int svm_register_enc_region(struct kvm *kvm,
+int svm_mem_enc_register_region(struct kvm *kvm,
 			    struct kvm_enc_region *range);
-int svm_unregister_enc_region(struct kvm *kvm,
+int svm_mem_enc_unregister_region(struct kvm *kvm,
 			      struct kvm_enc_region *range);
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 int __init sev_hardware_setup(void);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d1af20b..fc09bb0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3016,7 +3016,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 
 	preempt_disable();
 
-	vmx_prepare_switch_to_guest(vcpu);
+	vmx_prepare_guest_switch(vcpu);
 
 	/*
 	 * Induce a consistency check VMExit by clearing bit 1 in GUEST_RFLAGS,
@@ -3105,7 +3105,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
+static bool nested_vmx_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -3295,7 +3295,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	prepare_vmcs02_early(vmx, vmcs12);
 
 	if (from_vmentry) {
-		if (unlikely(!nested_get_vmcs12_pages(vcpu)))
+		if (unlikely(!nested_vmx_get_vmcs12_pages(vcpu)))
 			return NVMX_VMENTRY_KVM_INTERNAL_ERROR;
 
 		if (nested_vmx_check_vmentry_hw(vcpu)) {
@@ -3711,7 +3711,7 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
 	       to_vmx(vcpu)->nested.preemption_timer_expired;
 }
 
-static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
+static int nested_vmx_check_events(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long exit_qual;
@@ -5907,7 +5907,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
+static int nested_vmx_get_state(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state __user *user_kvm_nested_state,
 				u32 user_data_size)
 {
@@ -6031,7 +6031,7 @@ void vmx_leave_nested(struct kvm_vcpu *vcpu)
 	free_nested(vcpu);
 }
 
-static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
+static int nested_vmx_set_state(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state __user *user_kvm_nested_state,
 				struct kvm_nested_state *kvm_state)
 {
@@ -6448,7 +6448,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	msrs->vmcs_enum = VMCS12_MAX_FIELD_INDEX << 1;
 }
 
-void nested_vmx_hardware_unsetup(void)
+void nested_vmx_hardware_teardown(void)
 {
 	int i;
 
@@ -6473,7 +6473,7 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 			vmx_bitmap[i] = (unsigned long *)
 				__get_free_page(GFP_KERNEL);
 			if (!vmx_bitmap[i]) {
-				nested_vmx_hardware_unsetup();
+				nested_vmx_hardware_teardown();
 				return -ENOMEM;
 			}
 		}
@@ -6497,12 +6497,14 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 	return 0;
 }
 
+#define KVM_X86_NESTED_OP(name) .name = nested_vmx_##name
+
 struct kvm_x86_nested_ops vmx_nested_ops = {
-	.check_events = vmx_check_nested_events,
+	KVM_X86_NESTED_OP(check_events),
 	.hv_timer_pending = nested_vmx_preemption_timer_pending,
-	.get_state = vmx_get_nested_state,
-	.set_state = vmx_set_nested_state,
-	.get_vmcs12_pages = nested_get_vmcs12_pages,
+	KVM_X86_NESTED_OP(get_state),
+	KVM_X86_NESTED_OP(set_state),
+	KVM_X86_NESTED_OP(get_vmcs12_pages),
 	.enable_evmcs = nested_enable_evmcs,
 	.get_evmcs_version = nested_get_evmcs_version,
 };
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 758bccc..ac6b561 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -18,7 +18,7 @@ enum nvmx_vmentry_status {
 
 void vmx_leave_nested(struct kvm_vcpu *vcpu);
 void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps);
-void nested_vmx_hardware_unsetup(void);
+void nested_vmx_hardware_teardown(void);
 __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *));
 void nested_vmx_set_vmcs_shadowing_bitmap(void);
 void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cb22f33..6512e6e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1125,7 +1125,7 @@ void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
 	}
 }
 
-void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
+void vmx_prepare_guest_switch(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs_host_state *host_state;
@@ -2317,7 +2317,7 @@ static int kvm_cpu_vmxon(u64 vmxon_pointer)
 	return -EFAULT;
 }
 
-static int hardware_enable(void)
+static int vmx_hardware_enable(void)
 {
 	int cpu = raw_smp_processor_id();
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
@@ -2366,7 +2366,7 @@ static void kvm_cpu_vmxoff(void)
 	cr4_clear_bits(X86_CR4_VMXE);
 }
 
-static void hardware_disable(void)
+static void vmx_hardware_disable(void)
 {
 	vmclear_local_loaded_vmcss();
 	kvm_cpu_vmxoff();
@@ -2911,7 +2911,7 @@ static void exit_lmode(struct kvm_vcpu *vcpu)
 
 #endif
 
-static void vmx_flush_tlb_all(struct kvm_vcpu *vcpu)
+static void vmx_tlb_flush_all(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -2934,7 +2934,7 @@ static void vmx_flush_tlb_all(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
+static void vmx_tlb_flush_current(struct kvm_vcpu *vcpu)
 {
 	u64 root_hpa = vcpu->arch.mmu->root_hpa;
 
@@ -2950,16 +2950,16 @@ static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 		vpid_sync_context(nested_get_vpid02(vcpu));
 }
 
-static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
+static void vmx_tlb_flush_gva(struct kvm_vcpu *vcpu, gva_t addr)
 {
 	/*
 	 * vpid_sync_vcpu_addr() is a nop if vmx->vpid==0, see the comment in
-	 * vmx_flush_tlb_guest() for an explanation of why this is ok.
+	 * vmx_tlb_flush_guest() for an explanation of why this is ok.
 	 */
 	vpid_sync_vcpu_addr(to_vmx(vcpu)->vpid, addr);
 }
 
-static void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
+static void vmx_tlb_flush_guest(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * vpid_sync_context() is a nop if vmx->vpid==0, e.g. if enable_vpid==0
@@ -4455,16 +4455,16 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		vmx_clear_hlt(vcpu);
 }
 
-static void enable_irq_window(struct kvm_vcpu *vcpu)
+static void vmx_enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_INTR_WINDOW_EXITING);
 }
 
-static void enable_nmi_window(struct kvm_vcpu *vcpu)
+static void vmx_enable_nmi_window(struct kvm_vcpu *vcpu)
 {
 	if (!enable_vnmi ||
 	    vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & GUEST_INTR_STATE_STI) {
-		enable_irq_window(vcpu);
+		vmx_enable_irq_window(vcpu);
 		return;
 	}
 
@@ -6173,7 +6173,7 @@ static void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 		: "eax", "ebx", "ecx", "edx");
 }
 
-static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
+static void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	int tpr_threshold;
@@ -6261,7 +6261,7 @@ static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 		return;
 
 	vmcs_write64(APIC_ACCESS_ADDR, page_to_phys(page));
-	vmx_flush_tlb_current(vcpu);
+	vmx_tlb_flush_current(vcpu);
 
 	/*
 	 * Do not pin apic access page in memory, the MMU notifier
@@ -6837,7 +6837,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	return exit_fastpath;
 }
 
-static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
+static void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -6848,7 +6848,7 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	free_loaded_vmcs(vmx->loaded_vmcs);
 }
 
-static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
+static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx;
 	unsigned long *msr_bitmap;
@@ -7802,7 +7802,7 @@ static int vmx_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	return 0;
 }
 
-static void enable_smi_window(struct kvm_vcpu *vcpu)
+static void vmx_enable_smi_window(struct kvm_vcpu *vcpu)
 {
 	/* RSM will cause a vmexit anyway.  */
 }
@@ -7827,10 +7827,10 @@ static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void hardware_unsetup(void)
+static void vmx_hardware_teardown(void)
 {
 	if (nested)
-		nested_vmx_hardware_unsetup();
+		nested_vmx_hardware_teardown();
 
 	free_kvm_area();
 }
@@ -7843,134 +7843,136 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
+#define KVM_X86_OP(name) .name = vmx_##name
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
-	.hardware_unsetup = hardware_unsetup,
+	KVM_X86_OP(hardware_teardown),
 
-	.hardware_enable = hardware_enable,
-	.hardware_disable = hardware_disable,
+	KVM_X86_OP(hardware_enable),
+	KVM_X86_OP(hardware_disable),
 	.cpu_has_accelerated_tpr = report_flexpriority,
-	.has_emulated_msr = vmx_has_emulated_msr,
+	KVM_X86_OP(has_emulated_msr),
 
 	.vm_size = sizeof(struct kvm_vmx),
-	.vm_init = vmx_vm_init,
+	KVM_X86_OP(vm_init),
 
-	.vcpu_create = vmx_create_vcpu,
-	.vcpu_free = vmx_free_vcpu,
-	.vcpu_reset = vmx_vcpu_reset,
+	KVM_X86_OP(vcpu_create),
+	KVM_X86_OP(vcpu_free),
+	KVM_X86_OP(vcpu_reset),
 
-	.prepare_guest_switch = vmx_prepare_switch_to_guest,
-	.vcpu_load = vmx_vcpu_load,
-	.vcpu_put = vmx_vcpu_put,
+	KVM_X86_OP(prepare_guest_switch),
+	KVM_X86_OP(vcpu_load),
+	KVM_X86_OP(vcpu_put),
 
 	.update_bp_intercept = update_exception_bitmap,
-	.get_msr_feature = vmx_get_msr_feature,
-	.get_msr = vmx_get_msr,
-	.set_msr = vmx_set_msr,
-	.get_segment_base = vmx_get_segment_base,
-	.get_segment = vmx_get_segment,
-	.set_segment = vmx_set_segment,
-	.get_cpl = vmx_get_cpl,
-	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
-	.set_cr0 = vmx_set_cr0,
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
-
-	.tlb_flush_all = vmx_flush_tlb_all,
-	.tlb_flush_current = vmx_flush_tlb_current,
-	.tlb_flush_gva = vmx_flush_tlb_gva,
-	.tlb_flush_guest = vmx_flush_tlb_guest,
-
-	.run = vmx_vcpu_run,
-	.handle_exit = vmx_handle_exit,
-	.skip_emulated_instruction = vmx_skip_emulated_instruction,
-	.update_emulated_instruction = vmx_update_emulated_instruction,
-	.set_interrupt_shadow = vmx_set_interrupt_shadow,
-	.get_interrupt_shadow = vmx_get_interrupt_shadow,
-	.patch_hypercall = vmx_patch_hypercall,
-	.set_irq = vmx_inject_irq,
-	.set_nmi = vmx_inject_nmi,
-	.queue_exception = vmx_queue_exception,
-	.cancel_injection = vmx_cancel_injection,
-	.interrupt_allowed = vmx_interrupt_allowed,
-	.nmi_allowed = vmx_nmi_allowed,
-	.get_nmi_mask = vmx_get_nmi_mask,
-	.set_nmi_mask = vmx_set_nmi_mask,
-	.enable_nmi_window = enable_nmi_window,
-	.enable_irq_window = enable_irq_window,
-	.update_cr8_intercept = update_cr8_intercept,
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
-	.deliver_posted_interrupt = vmx_deliver_posted_interrupt,
-	.dy_apicv_has_pending_interrupt = vmx_dy_apicv_has_pending_interrupt,
-
-	.set_tss_addr = vmx_set_tss_addr,
-	.set_identity_map_addr = vmx_set_identity_map_addr,
-	.get_tdp_level = vmx_get_tdp_level,
-	.get_mt_mask = vmx_get_mt_mask,
-
-	.get_exit_info = vmx_get_exit_info,
-
-	.cpuid_update = vmx_cpuid_update,
+	KVM_X86_OP(get_msr_feature),
+	KVM_X86_OP(get_msr),
+	KVM_X86_OP(set_msr),
+	KVM_X86_OP(get_segment_base),
+	KVM_X86_OP(get_segment),
+	KVM_X86_OP(set_segment),
+	KVM_X86_OP(get_cpl),
+	KVM_X86_OP(get_cs_db_l_bits),
+	KVM_X86_OP(set_cr0),
+	KVM_X86_OP(set_cr4),
+	KVM_X86_OP(set_efer),
+	KVM_X86_OP(get_idt),
+	KVM_X86_OP(set_idt),
+	KVM_X86_OP(get_gdt),
+	KVM_X86_OP(set_gdt),
+	KVM_X86_OP(set_dr7),
+	KVM_X86_OP(sync_dirty_debug_regs),
+	KVM_X86_OP(cache_reg),
+	KVM_X86_OP(get_rflags),
+	KVM_X86_OP(set_rflags),
+
+	KVM_X86_OP(tlb_flush_all),
+	KVM_X86_OP(tlb_flush_current),
+	KVM_X86_OP(tlb_flush_gva),
+	KVM_X86_OP(tlb_flush_guest),
+
+	KVM_X86_OP(vcpu_run),
+	KVM_X86_OP(handle_exit),
+	KVM_X86_OP(skip_emulated_instruction),
+	KVM_X86_OP(update_emulated_instruction),
+	KVM_X86_OP(set_interrupt_shadow),
+	KVM_X86_OP(get_interrupt_shadow),
+	KVM_X86_OP(patch_hypercall),
+	KVM_X86_OP(inject_irq),
+	KVM_X86_OP(inject_nmi),
+	KVM_X86_OP(queue_exception),
+	KVM_X86_OP(cancel_injection),
+	KVM_X86_OP(interrupt_allowed),
+	KVM_X86_OP(nmi_allowed),
+	KVM_X86_OP(get_nmi_mask),
+	KVM_X86_OP(set_nmi_mask),
+	KVM_X86_OP(enable_nmi_window),
+	KVM_X86_OP(enable_irq_window),
+	KVM_X86_OP(update_cr8_intercept),
+	KVM_X86_OP(set_virtual_apic_mode),
+	KVM_X86_OP(set_apic_access_page_addr),
+	KVM_X86_OP(refresh_apicv_exec_ctrl),
+	KVM_X86_OP(load_eoi_exitmap),
+	KVM_X86_OP(apicv_post_state_restore),
+	KVM_X86_OP(check_apicv_inhibit_reasons),
+	KVM_X86_OP(hwapic_irr_update),
+	KVM_X86_OP(hwapic_isr_update),
+	KVM_X86_OP(guest_apic_has_interrupt),
+	KVM_X86_OP(sync_pir_to_irr),
+	KVM_X86_OP(deliver_posted_interrupt),
+	KVM_X86_OP(dy_apicv_has_pending_interrupt),
+
+	KVM_X86_OP(set_tss_addr),
+	KVM_X86_OP(set_identity_map_addr),
+	KVM_X86_OP(get_tdp_level),
+	KVM_X86_OP(get_mt_mask),
+
+	KVM_X86_OP(get_exit_info),
+
+	KVM_X86_OP(cpuid_update),
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
 
-	.write_l1_tsc_offset = vmx_write_l1_tsc_offset,
+	KVM_X86_OP(write_l1_tsc_offset),
 
-	.load_mmu_pgd = vmx_load_mmu_pgd,
+	KVM_X86_OP(load_mmu_pgd),
 
-	.check_intercept = vmx_check_intercept,
-	.handle_exit_irqoff = vmx_handle_exit_irqoff,
+	KVM_X86_OP(check_intercept),
+	KVM_X86_OP(handle_exit_irqoff),
 
-	.request_immediate_exit = vmx_request_immediate_exit,
+	KVM_X86_OP(request_immediate_exit),
 
-	.sched_in = vmx_sched_in,
+	KVM_X86_OP(sched_in),
 
-	.slot_enable_log_dirty = vmx_slot_enable_log_dirty,
-	.slot_disable_log_dirty = vmx_slot_disable_log_dirty,
-	.flush_log_dirty = vmx_flush_log_dirty,
-	.enable_log_dirty_pt_masked = vmx_enable_log_dirty_pt_masked,
+	KVM_X86_OP(slot_enable_log_dirty),
+	KVM_X86_OP(slot_disable_log_dirty),
+	KVM_X86_OP(flush_log_dirty),
+	KVM_X86_OP(enable_log_dirty_pt_masked),
 	.write_log_dirty = vmx_write_pml_buffer,
 
-	.pre_block = vmx_pre_block,
-	.post_block = vmx_post_block,
+	KVM_X86_OP(pre_block),
+	KVM_X86_OP(post_block),
 
 	.pmu_ops = &intel_pmu_ops,
 	.nested_ops = &vmx_nested_ops,
 
-	.update_pi_irte = vmx_update_pi_irte,
+	KVM_X86_OP(update_pi_irte),
 
 #ifdef CONFIG_X86_64
-	.set_hv_timer = vmx_set_hv_timer,
-	.cancel_hv_timer = vmx_cancel_hv_timer,
+	KVM_X86_OP(set_hv_timer),
+	KVM_X86_OP(cancel_hv_timer),
 #endif
 
-	.setup_mce = vmx_setup_mce,
+	KVM_X86_OP(setup_mce),
 
-	.smi_allowed = vmx_smi_allowed,
-	.pre_enter_smm = vmx_pre_enter_smm,
-	.pre_leave_smm = vmx_pre_leave_smm,
-	.enable_smi_window = enable_smi_window,
+	KVM_X86_OP(smi_allowed),
+	KVM_X86_OP(pre_enter_smm),
+	KVM_X86_OP(pre_leave_smm),
+	KVM_X86_OP(enable_smi_window),
 
-	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
-	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
-	.migrate_timers = vmx_migrate_timers,
+	KVM_X86_OP(need_emulation_on_page_fault),
+	KVM_X86_OP(apic_init_signal_blocked),
+	KVM_X86_OP(migrate_timers),
 };
 
 static __init int hardware_setup(void)
@@ -8142,7 +8144,7 @@ static __init int hardware_setup(void)
 
 	r = alloc_kvm_area();
 	if (r)
-		nested_vmx_hardware_unsetup();
+		nested_vmx_hardware_teardown();
 	return r;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 639798e..8084ce0 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -325,7 +325,7 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 int allocate_vpid(void);
 void free_vpid(int vpid);
 void vmx_set_constant_host_state(struct vcpu_vmx *vmx);
-void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
+void vmx_prepare_guest_switch(struct kvm_vcpu *vcpu);
 void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
 			unsigned long fs_base, unsigned long gs_base);
 int vmx_get_cpl(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3b92db4..4dc4e1c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5270,8 +5270,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto out;
 
 		r = -ENOTTY;
-		if (kvm_x86_ops.mem_enc_reg_region)
-			r = kvm_x86_ops.mem_enc_reg_region(kvm, &region);
+		if (kvm_x86_ops.mem_enc_register_region)
+			r = kvm_x86_ops.mem_enc_register_region(kvm, &region);
 		break;
 	}
 	case KVM_MEMORY_ENCRYPT_UNREG_REGION: {
@@ -5282,8 +5282,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto out;
 
 		r = -ENOTTY;
-		if (kvm_x86_ops.mem_enc_unreg_region)
-			r = kvm_x86_ops.mem_enc_unreg_region(kvm, &region);
+		if (kvm_x86_ops.mem_enc_unregister_region)
+			r = kvm_x86_ops.mem_enc_unregister_region(kvm, &region);
 		break;
 	}
 	case KVM_HYPERV_EVENTFD: {
@@ -7788,10 +7788,10 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	 */
 	else if (!vcpu->arch.exception.pending) {
 		if (vcpu->arch.nmi_injected) {
-			kvm_x86_ops.set_nmi(vcpu);
+			kvm_x86_ops.inject_nmi(vcpu);
 			can_inject = false;
 		} else if (vcpu->arch.interrupt.injected) {
-			kvm_x86_ops.set_irq(vcpu);
+			kvm_x86_ops.inject_irq(vcpu);
 			can_inject = false;
 		}
 	}
@@ -7867,7 +7867,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 		if (r) {
 			--vcpu->arch.nmi_pending;
 			vcpu->arch.nmi_injected = true;
-			kvm_x86_ops.set_nmi(vcpu);
+			kvm_x86_ops.inject_nmi(vcpu);
 			can_inject = false;
 			WARN_ON(kvm_x86_ops.nmi_allowed(vcpu, true) < 0);
 		}
@@ -7881,7 +7881,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 			goto busy;
 		if (r) {
 			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu), false);
-			kvm_x86_ops.set_irq(vcpu);
+			kvm_x86_ops.inject_irq(vcpu);
 			WARN_ON(kvm_x86_ops.interrupt_allowed(vcpu, true) < 0);
 		}
 		if (kvm_cpu_has_injectable_intr(vcpu))
@@ -8517,7 +8517,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
 	}
 
-	exit_fastpath = kvm_x86_ops.run(vcpu);
+	exit_fastpath = kvm_x86_ops.vcpu_run(vcpu);
 
 	/*
 	 * Do this here before restoring debug registers on the host.  And
@@ -9795,7 +9795,7 @@ int kvm_arch_hardware_setup(void *opaque)
 
 void kvm_arch_hardware_unsetup(void)
 {
-	kvm_x86_ops.hardware_unsetup();
+	kvm_x86_ops.hardware_teardown();
 }
 
 int kvm_arch_check_processor_compat(void *opaque)
-- 
1.8.3.1

