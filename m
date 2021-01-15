Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF7C2F7100
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 04:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732573AbhAODbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 22:31:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732533AbhAODbb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 22:31:31 -0500
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51302C0613D6;
        Thu, 14 Jan 2021 19:30:44 -0800 (PST)
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
        by m0050102.ppops.net-00190b01. (8.16.0.43/8.16.0.43) with SMTP id 10F3QHta005349;
        Fri, 15 Jan 2021 03:30:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : in-reply-to :
 references; s=jan2016.eng;
 bh=y8x4y10ECVtbx/PyMPHnnjIxYNDK2d8dVeViV55dh3A=;
 b=YB89oQLuWmJirQ0zKeq1Ouvy4bxdbiTqofL02R2MMplFoKDl6rv50cHC8hvQpbBAYJDq
 8Zi4JkDbtzAA07jj8WUssBr5Wems2RM2sp2IH9cUUTxeYRITTm6RfeZ+w4fsK2x09MNI
 Gx1Szp5NQvYUB/2QsRgOeKK/M3HtzADB9Ku5L56cHA412gL5rcuk3XatgZOsInlbcF3C
 nLZK6Z/Z0UODldb+Y3puOeZK8KbdA+NmKQrKdlFK1wIln3nt58UtScbK8n+lh/mTiqFi
 X9oS79h+jzYhoaqTNe8bTNlsvVSbSsSzheQS7eeffOUu+fhnGrAU7MMk/F9UR+64GDIc GA== 
Received: from prod-mail-ppoint2 (prod-mail-ppoint2.akamai.com [184.51.33.19] (may be forged))
        by m0050102.ppops.net-00190b01. with ESMTP id 35yq24wqen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 03:30:17 +0000
Received: from pps.filterd (prod-mail-ppoint2.akamai.com [127.0.0.1])
        by prod-mail-ppoint2.akamai.com (8.16.0.43/8.16.0.43) with SMTP id 10F3Pr6W014547;
        Thu, 14 Jan 2021 22:30:14 -0500
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint2.akamai.com with ESMTP id 35y8q2cney-1;
        Thu, 14 Jan 2021 22:30:14 -0500
Received: from bos-lpjec.145bw.corp.akamai.com (bos-lpjec.145bw.corp.akamai.com [172.28.3.71])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id B1A0E4069E;
        Fri, 15 Jan 2021 03:30:14 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v2 1/3] KVM: X86: append vmx/svm prefix to additional kvm_x86_ops functions
Date:   Thu, 14 Jan 2021 22:27:54 -0500
Message-Id: <ed594696f8e2c2b2bfc747504cee9bbb2a269300.1610680941.git.jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1610680941.git.jbaron@akamai.com>
References: <cover.1610680941.git.jbaron@akamai.com>
In-Reply-To: <cover.1610680941.git.jbaron@akamai.com>
References: <cover.1610680941.git.jbaron@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_01:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=831
 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150015
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_01:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=786 spamscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150015
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.19)
 smtp.mailfrom=jbaron@akamai.com smtp.helo=prod-mail-ppoint2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A subsequent patch introduces macros in preparation for simplifying the
definition for vmx_x86_ops and svm_x86_ops. Making the naming more uniform
expands the coverage of the macros. Add vmx/svm prefix to the following
functions: update_exception_bitmap(), enable_nmi_window(),
enable_irq_window(), update_cr8_intercept and enable_smi_window().

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 arch/x86/kvm/svm/svm.c    | 20 ++++++++++----------
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 30 +++++++++++++++---------------
 arch/x86/kvm/vmx/vmx.h    |  2 +-
 4 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cce0143..04d3126 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1810,7 +1810,7 @@ static void svm_set_segment(struct kvm_vcpu *vcpu,
 	vmcb_mark_dirty(svm->vmcb, VMCB_SEG);
 }
 
-static void update_exception_bitmap(struct kvm_vcpu *vcpu)
+static void svm_update_exception_bitmap(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3349,7 +3349,7 @@ static void svm_set_irq(struct kvm_vcpu *vcpu)
 		SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR;
 }
 
-static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
+static void svm_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3474,7 +3474,7 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	return !svm_interrupt_blocked(vcpu);
 }
 
-static void enable_irq_window(struct kvm_vcpu *vcpu)
+static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3498,7 +3498,7 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void enable_nmi_window(struct kvm_vcpu *vcpu)
+static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -4280,7 +4280,7 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	return ret;
 }
 
-static void enable_smi_window(struct kvm_vcpu *vcpu)
+static void svm_enable_smi_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -4426,7 +4426,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_blocking = svm_vcpu_blocking,
 	.vcpu_unblocking = svm_vcpu_unblocking,
 
-	.update_exception_bitmap = update_exception_bitmap,
+	.update_exception_bitmap = svm_update_exception_bitmap,
 	.get_msr_feature = svm_get_msr_feature,
 	.get_msr = svm_get_msr,
 	.set_msr = svm_set_msr,
@@ -4469,9 +4469,9 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.nmi_allowed = svm_nmi_allowed,
 	.get_nmi_mask = svm_get_nmi_mask,
 	.set_nmi_mask = svm_set_nmi_mask,
-	.enable_nmi_window = enable_nmi_window,
-	.enable_irq_window = enable_irq_window,
-	.update_cr8_intercept = update_cr8_intercept,
+	.enable_nmi_window = svm_enable_nmi_window,
+	.enable_irq_window = svm_enable_irq_window,
+	.update_cr8_intercept = svm_update_cr8_intercept,
 	.set_virtual_apic_mode = svm_set_virtual_apic_mode,
 	.refresh_apicv_exec_ctrl = svm_refresh_apicv_exec_ctrl,
 	.check_apicv_inhibit_reasons = svm_check_apicv_inhibit_reasons,
@@ -4514,7 +4514,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.smi_allowed = svm_smi_allowed,
 	.pre_enter_smm = svm_pre_enter_smm,
 	.pre_leave_smm = svm_pre_leave_smm,
-	.enable_smi_window = enable_smi_window,
+	.enable_smi_window = svm_enable_smi_window,
 
 	.mem_enc_op = svm_mem_enc_op,
 	.mem_enc_reg_region = svm_register_enc_region,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e2f2656..8a0b817 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2532,7 +2532,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	 * bitwise-or of what L1 wants to trap for L2, and what we want to
 	 * trap. Note that CR0.TS also needs updating - we do this later.
 	 */
-	update_exception_bitmap(vcpu);
+	vmx_update_exception_bitmap(vcpu);
 	vcpu->arch.cr0_guest_owned_bits &= ~vmcs12->cr0_guest_host_mask;
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~vcpu->arch.cr0_guest_owned_bits);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 75c9c6a..3c7ca71 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -806,7 +806,7 @@ static u32 vmx_read_guest_seg_ar(struct vcpu_vmx *vmx, unsigned seg)
 	return *p;
 }
 
-void update_exception_bitmap(struct kvm_vcpu *vcpu)
+void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
 {
 	u32 eb;
 
@@ -2739,7 +2739,7 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
 	vmcs_writel(GUEST_CR4, (vmcs_readl(GUEST_CR4) & ~X86_CR4_VME) |
 			(vmcs_readl(CR4_READ_SHADOW) & X86_CR4_VME));
 
-	update_exception_bitmap(vcpu);
+	vmx_update_exception_bitmap(vcpu);
 
 	fix_pmode_seg(vcpu, VCPU_SREG_CS, &vmx->rmode.segs[VCPU_SREG_CS]);
 	fix_pmode_seg(vcpu, VCPU_SREG_SS, &vmx->rmode.segs[VCPU_SREG_SS]);
@@ -2819,7 +2819,7 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 
 	vmcs_writel(GUEST_RFLAGS, flags);
 	vmcs_writel(GUEST_CR4, vmcs_readl(GUEST_CR4) | X86_CR4_VME);
-	update_exception_bitmap(vcpu);
+	vmx_update_exception_bitmap(vcpu);
 
 	fix_rmode_seg(VCPU_SREG_SS, &vmx->rmode.segs[VCPU_SREG_SS]);
 	fix_rmode_seg(VCPU_SREG_CS, &vmx->rmode.segs[VCPU_SREG_CS]);
@@ -4467,23 +4467,23 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx_set_cr4(vcpu, 0);
 	vmx_set_efer(vcpu, 0);
 
-	update_exception_bitmap(vcpu);
+	vmx_update_exception_bitmap(vcpu);
 
 	vpid_sync_context(vmx->vpid);
 	if (init_event)
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
 
@@ -6129,7 +6129,7 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 		: "eax", "ebx", "ecx", "edx");
 }
 
-static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
+static void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	int tpr_threshold;
@@ -7245,7 +7245,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	set_cr4_guest_host_mask(vmx);
 
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
-	update_exception_bitmap(vcpu);
+	vmx_update_exception_bitmap(vcpu);
 }
 
 static __init void vmx_set_cpu_caps(void)
@@ -7535,7 +7535,7 @@ static int vmx_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	return 0;
 }
 
-static void enable_smi_window(struct kvm_vcpu *vcpu)
+static void vmx_enable_smi_window(struct kvm_vcpu *vcpu)
 {
 	/* RSM will cause a vmexit anyway.  */
 }
@@ -7595,7 +7595,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.vcpu_load = vmx_vcpu_load,
 	.vcpu_put = vmx_vcpu_put,
 
-	.update_exception_bitmap = update_exception_bitmap,
+	.update_exception_bitmap = vmx_update_exception_bitmap,
 	.get_msr_feature = vmx_get_msr_feature,
 	.get_msr = vmx_get_msr,
 	.set_msr = vmx_set_msr,
@@ -7638,9 +7638,9 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.nmi_allowed = vmx_nmi_allowed,
 	.get_nmi_mask = vmx_get_nmi_mask,
 	.set_nmi_mask = vmx_set_nmi_mask,
-	.enable_nmi_window = enable_nmi_window,
-	.enable_irq_window = enable_irq_window,
-	.update_cr8_intercept = update_cr8_intercept,
+	.enable_nmi_window = vmx_enable_nmi_window,
+	.enable_irq_window = vmx_enable_irq_window,
+	.update_cr8_intercept = vmx_update_cr8_intercept,
 	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
 	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
 	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
@@ -7698,7 +7698,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.smi_allowed = vmx_smi_allowed,
 	.pre_enter_smm = vmx_pre_enter_smm,
 	.pre_leave_smm = vmx_pre_leave_smm,
-	.enable_smi_window = enable_smi_window,
+	.enable_smi_window = vmx_enable_smi_window,
 
 	.can_emulate_instruction = vmx_can_emulate_instruction,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9d3a557..8f70c25 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -329,7 +329,7 @@ void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa,
 		   int root_level);
 
-void update_exception_bitmap(struct kvm_vcpu *vcpu);
+void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
 void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu);
 bool vmx_nmi_blocked(struct kvm_vcpu *vcpu);
 bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
-- 
2.7.4

