Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F73F161520
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 15:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbgBQOxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 09:53:09 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6204 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729043AbgBQOxI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 09:53:08 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01HEoCG6166657;
        Mon, 17 Feb 2020 09:53:07 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y6cu1thvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Feb 2020 09:53:07 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01HEr7gR196140;
        Mon, 17 Feb 2020 09:53:07 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y6cu1thve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Feb 2020 09:53:07 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01HEph07028422;
        Mon, 17 Feb 2020 14:53:06 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01dal.us.ibm.com with ESMTP id 2y6896730j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Feb 2020 14:53:06 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01HEr36G34537888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 14:53:03 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7B2FAE063;
        Mon, 17 Feb 2020 14:53:03 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 948BDAE064;
        Mon, 17 Feb 2020 14:53:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 17 Feb 2020 14:53:03 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     david@redhat.com
Cc:     Ulrich.Weigand@de.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, frankja@linux.ibm.com,
        frankja@linux.vnet.ibm.com, gor@linux.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com, thuth@redhat.com
Subject: [PATCH 1/2] lock changes
Date:   Mon, 17 Feb 2020 09:53:01 -0500
Message-Id: <20200217145302.19085-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200217145302.19085-1-borntraeger@de.ibm.com>
References: <c77dbb1b-0f4b-e40a-52a4-7110aec75e32@redhat.com>
 <20200217145302.19085-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_08:2020-02-17,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxscore=0 suspectscore=3 bulkscore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 mlxlogscore=913 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002170123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/intercept.c |  6 +++---
 arch/s390/kvm/interrupt.c | 35 +++++++++++++++++++++--------------
 arch/s390/kvm/kvm-s390.c  | 28 +++++++++++++---------------
 arch/s390/kvm/kvm-s390.h  | 18 +++++++++++++-----
 arch/s390/kvm/priv.c      |  4 ++--
 5 files changed, 52 insertions(+), 39 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index cfabeecbb777..a5ae12c4c139 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -236,7 +236,7 @@ static int handle_prog(struct kvm_vcpu *vcpu)
 	 * Intercept 8 indicates a loop of specification exceptions
 	 * for protected guests.
 	 */
-	if (kvm_s390_pv_is_protected(vcpu->kvm))
+	if (kvm_s390_pv_cpu_is_protected(vcpu))
 		return -EOPNOTSUPP;
 
 	if (guestdbg_enabled(vcpu) && per_event(vcpu)) {
@@ -392,7 +392,7 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
 		goto out;
 	}
 
-	if (!kvm_s390_pv_is_protected(vcpu->kvm) && (addr & ~PAGE_MASK))
+	if (!kvm_s390_pv_cpu_is_protected(vcpu) && (addr & ~PAGE_MASK))
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 
 	sctns = (void *)get_zeroed_page(GFP_KERNEL);
@@ -403,7 +403,7 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
 
 out:
 	if (!cc) {
-		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 			memcpy((void *)(sida_origin(vcpu->arch.sie_block)),
 			       sctns, PAGE_SIZE);
 		} else {
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 7a10096fa204..140f04a2b547 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -393,7 +393,7 @@ static unsigned long deliverable_irqs(struct kvm_vcpu *vcpu)
 	if (psw_mchk_disabled(vcpu))
 		active_mask &= ~IRQ_PEND_MCHK_MASK;
 	/* PV guest cpus can have a single interruption injected at a time. */
-	if (kvm_s390_pv_is_protected(vcpu->kvm) &&
+	if (kvm_s390_pv_cpu_is_protected(vcpu) &&
 	    vcpu->arch.sie_block->iictl != IICTL_CODE_NONE)
 		active_mask &= ~(IRQ_PEND_EXT_II_MASK |
 				 IRQ_PEND_IO_MASK |
@@ -495,7 +495,7 @@ static int __must_check __deliver_cpu_timer(struct kvm_vcpu *vcpu)
 	vcpu->stat.deliver_cputm++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_CPU_TIMER,
 					 0, 0);
-	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 		vcpu->arch.sie_block->iictl = IICTL_CODE_EXT;
 		vcpu->arch.sie_block->eic = EXT_IRQ_CPU_TIMER;
 	} else {
@@ -519,7 +519,7 @@ static int __must_check __deliver_ckc(struct kvm_vcpu *vcpu)
 	vcpu->stat.deliver_ckc++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_CLOCK_COMP,
 					 0, 0);
-	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 		vcpu->arch.sie_block->iictl = IICTL_CODE_EXT;
 		vcpu->arch.sie_block->eic = EXT_IRQ_CLK_COMP;
 	} else {
@@ -578,7 +578,7 @@ static int __write_machine_check(struct kvm_vcpu *vcpu,
 	 * the hypervisor does not not have the needed information for
 	 * protected guests.
 	 */
-	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 		vcpu->arch.sie_block->iictl = IICTL_CODE_MCHK;
 		vcpu->arch.sie_block->mcic = mchk->mcic;
 		vcpu->arch.sie_block->faddr = mchk->failing_storage_address;
@@ -735,7 +735,7 @@ static int __must_check __deliver_restart(struct kvm_vcpu *vcpu)
 	vcpu->stat.deliver_restart_signal++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_RESTART, 0, 0);
 
-	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 		vcpu->arch.sie_block->iictl = IICTL_CODE_RESTART;
 	} else {
 		rc  = write_guest_lc(vcpu,
@@ -785,7 +785,7 @@ static int __must_check __deliver_emergency_signal(struct kvm_vcpu *vcpu)
 	vcpu->stat.deliver_emergency_signal++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_EMERGENCY,
 					 cpu_addr, 0);
-	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 		vcpu->arch.sie_block->iictl = IICTL_CODE_EXT;
 		vcpu->arch.sie_block->eic = EXT_IRQ_EMERGENCY_SIG;
 		vcpu->arch.sie_block->extcpuaddr = cpu_addr;
@@ -819,7 +819,7 @@ static int __must_check __deliver_external_call(struct kvm_vcpu *vcpu)
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id,
 					 KVM_S390_INT_EXTERNAL_CALL,
 					 extcall.code, 0);
-	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 		vcpu->arch.sie_block->iictl = IICTL_CODE_EXT;
 		vcpu->arch.sie_block->eic = EXT_IRQ_EXTERNAL_CALL;
 		vcpu->arch.sie_block->extcpuaddr = extcall.code;
@@ -871,7 +871,7 @@ static int __must_check __deliver_prog(struct kvm_vcpu *vcpu)
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_PROGRAM_INT,
 					 pgm_info.code, 0);
 
-	if (kvm_s390_pv_is_protected(vcpu->kvm))
+	if (kvm_s390_pv_cpu_is_protected(vcpu))
 		return __deliver_prog_pv(vcpu, pgm_info.code & ~PGM_PER);
 
 	switch (pgm_info.code & ~PGM_PER) {
@@ -1010,7 +1010,7 @@ static int __must_check __deliver_service(struct kvm_vcpu *vcpu)
 	memset(&fi->srv_signal, 0, sizeof(ext));
 	clear_bit(IRQ_PEND_EXT_SERVICE, &fi->pending_irqs);
 	clear_bit(IRQ_PEND_EXT_SERVICE_EV, &fi->pending_irqs);
-	if (kvm_s390_pv_is_protected(vcpu->kvm))
+	if (kvm_s390_pv_cpu_is_protected(vcpu))
 		set_bit(IRQ_PEND_EXT_SERVICE, &fi->masked_irqs);
 	spin_unlock(&fi->lock);
 
@@ -1139,7 +1139,7 @@ static int __do_deliver_io(struct kvm_vcpu *vcpu, struct kvm_s390_io_info *io)
 {
 	int rc;
 
-	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 		vcpu->arch.sie_block->iictl = IICTL_CODE_IO;
 		vcpu->arch.sie_block->subchannel_id = io->subchannel_id;
 		vcpu->arch.sie_block->subchannel_nr = io->subchannel_nr;
@@ -1898,8 +1898,13 @@ static int __inject_io(struct kvm *kvm, struct kvm_s390_interrupt_info *inti)
 	kvm->stat.inject_io++;
 	isc = int_word_to_isc(inti->io.io_int_word);
 
-	/* do not make use of gisa in protected mode */
-	if (!kvm_s390_pv_is_protected(kvm) &&
+	/*
+	 * Do not make use of gisa in protected mode. We do not use the lock
+	 * checking variant as this is just a performance optimization and we
+	 * do not hold the lock here. This is ok as the code will pick
+	 * interrupts from both "lists" for delivery.
+	 */
+	if (!kvm_s390_pv_handle(kvm) &&
 	    gi->origin && inti->type & KVM_S390_INT_IO_AI_MASK) {
 		VM_EVENT(kvm, 4, "%s isc %1u", "inject: I/O (AI/gisa)", isc);
 		gisa_set_ipm_gisc(gi->origin, isc);
@@ -2208,10 +2213,12 @@ void kvm_s390_clear_float_irqs(struct kvm *kvm)
 	struct kvm_s390_float_interrupt *fi = &kvm->arch.float_int;
 	int i;
 
-	spin_lock(&fi->lock);
-	fi->pending_irqs = 0;
+	mutex_lock(&kvm->lock);
 	if (!kvm_s390_pv_is_protected(kvm))
 		fi->masked_irqs = 0;
+	mutex_unlock(&kvm->lock);
+	spin_lock(&fi->lock);
+	fi->pending_irqs = 0;
 	memset(&fi->srv_signal, 0, sizeof(fi->srv_signal));
 	memset(&fi->mchk, 0, sizeof(fi->mchk));
 	for (i = 0; i < FIRQ_LIST_COUNT; i++)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 87dc6caa2181..a095d9695f18 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2194,7 +2194,6 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 			break;
 		}
 
-		mutex_lock(&kvm->lock);
 		kvm_s390_vcpu_block_all(kvm);
 		/* FMT 4 SIE needs esca */
 		r = sca_switch_to_extended(kvm);
@@ -2208,7 +2207,6 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		kvm_s390_vcpu_unblock_all(kvm);
 		/* we need to block service interrupts from now on */
 		set_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
-		mutex_unlock(&kvm->lock);
 		break;
 	}
 	case KVM_PV_VM_DESTROY: {
@@ -2216,8 +2214,6 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		if (!kvm_s390_pv_is_protected(kvm))
 			break;
 
-		/* All VCPUs have to be destroyed before this call. */
-		mutex_lock(&kvm->lock);
 		kvm_s390_vcpu_block_all(kvm);
 		r = kvm_s390_pv_destroy_vm(kvm, &cmd->rc, &cmd->rrc);
 		if (!r)
@@ -2225,7 +2221,6 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		kvm_s390_vcpu_unblock_all(kvm);
 		/* no need to block service interrupts any more */
 		clear_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
-		mutex_unlock(&kvm->lock);
 		break;
 	}
 	case KVM_PV_VM_SET_SEC_PARMS: {
@@ -2740,7 +2735,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_free_vcpus(kvm);
 	sca_dispose(kvm);
 	kvm_s390_gisa_destroy(kvm);
-	if (kvm_s390_pv_is_protected(kvm)) {
+	/* do not use the lock checking variant at tear-down */
+	if (kvm_s390_pv_handle(kvm)) {
 		kvm_s390_pv_destroy_vm(kvm, &rc, &rrc);
 		kvm_s390_pv_dealloc_vm(kvm);
 	}
@@ -3162,8 +3158,10 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 
 	kvm_s390_vcpu_crypto_setup(vcpu);
 
+	mutex_lock(&vcpu->kvm->lock);
 	if (kvm_s390_pv_is_protected(vcpu->kvm))
 		rc = kvm_s390_pv_create_cpu(vcpu, &uvrc, &uvrrc);
+	mutex_unlock(&vcpu->kvm->lock);
 
 	return rc;
 }
@@ -4053,14 +4051,14 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 		guest_enter_irqoff();
 		__disable_cpu_timer_accounting(vcpu);
 		local_irq_enable();
-		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 			memcpy(sie_page->pv_grregs,
 			       vcpu->run->s.regs.gprs,
 			       sizeof(sie_page->pv_grregs));
 		}
 		exit_reason = sie64a(vcpu->arch.sie_block,
 				     vcpu->run->s.regs.gprs);
-		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 			memcpy(vcpu->run->s.regs.gprs,
 			       sie_page->pv_grregs,
 			       sizeof(sie_page->pv_grregs));
@@ -4184,7 +4182,7 @@ static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		current->thread.fpu.fpc = 0;
 
 	/* Sync fmt2 only data */
-	if (likely(!kvm_s390_pv_is_protected(vcpu->kvm))) {
+	if (likely(!kvm_s390_pv_cpu_is_protected(vcpu))) {
 		sync_regs_fmt2(vcpu, kvm_run);
 	} else {
 		/*
@@ -4244,7 +4242,7 @@ static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	/* Restore will be done lazily at return */
 	current->thread.fpu.fpc = vcpu->arch.host_fpregs.fpc;
 	current->thread.fpu.regs = vcpu->arch.host_fpregs.regs;
-	if (likely(!kvm_s390_pv_is_protected(vcpu->kvm)))
+	if (likely(!kvm_s390_pv_cpu_is_protected(vcpu)))
 		store_regs_fmt2(vcpu, kvm_run);
 }
 
@@ -4443,7 +4441,7 @@ void kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
 	 * ultravisor. We block all interrupts and let the next sie exit
 	 * refresh our view.
 	 */
-	if (kvm_s390_pv_is_protected(vcpu->kvm))
+	if (kvm_s390_pv_cpu_is_protected(vcpu))
 		vcpu->arch.sie_block->gpsw.mask &= ~PSW_INT_MASK;
 	/*
 	 * Another VCPU might have used IBS while we were offline.
@@ -4573,7 +4571,7 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 
 	switch (mop->op) {
 	case KVM_S390_MEMOP_LOGICAL_READ:
-		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 			r = -EINVAL;
 			break;
 		}
@@ -4589,7 +4587,7 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 		}
 		break;
 	case KVM_S390_MEMOP_LOGICAL_WRITE:
-		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 			r = -EINVAL;
 			break;
 		}
@@ -4655,7 +4653,7 @@ static int kvm_s390_handle_pv_vcpu(struct kvm_vcpu *vcpu,
 {
 	int r = 0;
 
-	if (!kvm_s390_pv_is_protected(vcpu->kvm))
+	if (!kvm_s390_pv_cpu_is_protected(vcpu))
 		return -EINVAL;
 
 	if (cmd->flags)
@@ -4751,7 +4749,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_GET_ONE_REG: {
 		struct kvm_one_reg reg;
 		r = -EINVAL;
-		if (kvm_s390_pv_is_protected(vcpu->kvm))
+		if (kvm_s390_pv_cpu_is_protected(vcpu))
 			break;
 		r = -EFAULT;
 		if (copy_from_user(&reg, argp, sizeof(reg)))
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 1af1e30beead..f00a99957f79 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -15,6 +15,7 @@
 #include <linux/hrtimer.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/lockdep.h>
 #include <asm/facility.h>
 #include <asm/processor.h>
 #include <asm/sclp.h>
@@ -221,11 +222,6 @@ int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
 int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state, u16 *rc,
 			      u16 *rrc);
 
-static inline bool kvm_s390_pv_is_protected(struct kvm *kvm)
-{
-	return !!kvm->arch.pv.handle;
-}
-
 static inline u64 kvm_s390_pv_handle(struct kvm *kvm)
 {
 	return kvm->arch.pv.handle;
@@ -236,6 +232,18 @@ static inline u64 kvm_s390_pv_handle_cpu(struct kvm_vcpu *vcpu)
 	return vcpu->arch.pv.handle;
 }
 
+static inline bool kvm_s390_pv_is_protected(struct kvm *kvm)
+{
+	lockdep_assert_held(&kvm->lock);
+	return !!kvm_s390_pv_handle(kvm);
+}
+
+static inline bool kvm_s390_pv_cpu_is_protected(struct kvm_vcpu *vcpu)
+{
+	lockdep_assert_held(&vcpu->mutex);
+	return !!kvm_s390_pv_handle_cpu(vcpu);
+}
+
 /* implemented in interrupt.c */
 int kvm_s390_handle_wait(struct kvm_vcpu *vcpu);
 void kvm_s390_vcpu_wakeup(struct kvm_vcpu *vcpu);
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index b2de7dc5f58d..394b57090ff6 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -872,7 +872,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 
 	operand2 = kvm_s390_get_base_disp_s(vcpu, &ar);
 
-	if (!kvm_s390_pv_is_protected(vcpu->kvm) && (operand2 & 0xfff))
+	if (!kvm_s390_pv_cpu_is_protected(vcpu) && (operand2 & 0xfff))
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 
 	switch (fc) {
@@ -893,7 +893,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 		handle_stsi_3_2_2(vcpu, (void *) mem);
 		break;
 	}
-	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 		memcpy((void *)sida_origin(vcpu->arch.sie_block), (void *)mem,
 		       PAGE_SIZE);
 		rc = 0;
-- 
2.25.0

