Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA17165BEB
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 11:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgBTKlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 05:41:07 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59780 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727576AbgBTKka (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 05:40:30 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01KAYnoR058277;
        Thu, 20 Feb 2020 05:40:28 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y8ubpkr6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 05:40:28 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01KAa2Ef061595;
        Thu, 20 Feb 2020 05:40:27 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y8ubpkr5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 05:40:27 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01KAVa7M021658;
        Thu, 20 Feb 2020 10:40:26 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03dal.us.ibm.com with ESMTP id 2y6897ex8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 10:40:26 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01KAeO2b53739920
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 10:40:24 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1991511206E;
        Thu, 20 Feb 2020 10:40:24 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C25E112072;
        Thu, 20 Feb 2020 10:40:24 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 20 Feb 2020 10:40:24 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v3 15/37] KVM: s390: protvirt: Implement interrupt injection
Date:   Thu, 20 Feb 2020 05:39:58 -0500
Message-Id: <20200220104020.5343-16-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200220104020.5343-1-borntraeger@de.ibm.com>
References: <20200220104020.5343-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_02:2020-02-19,2020-02-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Mueller <mimu@linux.ibm.com>

This defines the necessary data structures in the SIE control block to
inject machine checks,external and I/O interrupts. We first define the
the interrupt injection control, which defines the next interrupt to
inject. Then we define the fields that contain the payload for machine
checks,external and I/O interrupts.
This is then used to implement interruption injection for the following
list of interruption types:

   - I/O (uses inject io interruption)
     __deliver_io

   - External (uses inject external interruption)
     __deliver_cpu_timer
     __deliver_ckc
     __deliver_emergency_signal
     __deliver_external_call

   - cpu restart (uses inject restart interruption)
     __deliver_restart

   - machine checks (uses mcic, failing address and external damage)
     __write_machine_check

Please note that posted interrupts (GISA) are not used for protected
guests as of today.

The service interrupt is handled in a followup patch.

Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  62 +++++++++++++----
 arch/s390/kvm/interrupt.c        | 115 +++++++++++++++++++++++--------
 2 files changed, 138 insertions(+), 39 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index c6694f47b73b..a13dc77f8b07 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -222,7 +222,15 @@ struct kvm_s390_sie_block {
 	__u8	icptcode;		/* 0x0050 */
 	__u8	icptstatus;		/* 0x0051 */
 	__u16	ihcpu;			/* 0x0052 */
-	__u8	reserved54[2];		/* 0x0054 */
+	__u8	reserved54;		/* 0x0054 */
+#define IICTL_CODE_NONE		 0x00
+#define IICTL_CODE_MCHK		 0x01
+#define IICTL_CODE_EXT		 0x02
+#define IICTL_CODE_IO		 0x03
+#define IICTL_CODE_RESTART	 0x04
+#define IICTL_CODE_SPECIFICATION 0x10
+#define IICTL_CODE_OPERAND	 0x11
+	__u8	iictl;			/* 0x0055 */
 	__u16	ipa;			/* 0x0056 */
 	__u32	ipb;			/* 0x0058 */
 	__u32	scaoh;			/* 0x005c */
@@ -259,24 +267,48 @@ struct kvm_s390_sie_block {
 #define HPID_KVM	0x4
 #define HPID_VSIE	0x5
 	__u8	hpid;			/* 0x00b8 */
-	__u8	reservedb9[11];		/* 0x00b9 */
-	__u16	extcpuaddr;		/* 0x00c4 */
-	__u16	eic;			/* 0x00c6 */
+	__u8	reservedb9[7];		/* 0x00b9 */
+	union {
+		struct {
+			__u32	eiparams;	/* 0x00c0 */
+			__u16	extcpuaddr;	/* 0x00c4 */
+			__u16	eic;		/* 0x00c6 */
+		};
+		__u64	mcic;			/* 0x00c0 */
+	} __packed;
 	__u32	reservedc8;		/* 0x00c8 */
-	__u16	pgmilc;			/* 0x00cc */
-	__u16	iprcc;			/* 0x00ce */
-	__u32	dxc;			/* 0x00d0 */
-	__u16	mcn;			/* 0x00d4 */
-	__u8	perc;			/* 0x00d6 */
-	__u8	peratmid;		/* 0x00d7 */
+	union {
+		struct {
+			__u16	pgmilc;		/* 0x00cc */
+			__u16	iprcc;		/* 0x00ce */
+		};
+		__u32	edc;			/* 0x00cc */
+	} __packed;
+	union {
+		struct {
+			__u32	dxc;		/* 0x00d0 */
+			__u16	mcn;		/* 0x00d4 */
+			__u8	perc;		/* 0x00d6 */
+			__u8	peratmid;	/* 0x00d7 */
+		};
+		__u64	faddr;			/* 0x00d0 */
+	} __packed;
 	__u64	peraddr;		/* 0x00d8 */
 	__u8	eai;			/* 0x00e0 */
 	__u8	peraid;			/* 0x00e1 */
 	__u8	oai;			/* 0x00e2 */
 	__u8	armid;			/* 0x00e3 */
 	__u8	reservede4[4];		/* 0x00e4 */
-	__u64	tecmc;			/* 0x00e8 */
-	__u8	reservedf0[12];		/* 0x00f0 */
+	union {
+		__u64	tecmc;		/* 0x00e8 */
+		struct {
+			__u16	subchannel_id;	/* 0x00e8 */
+			__u16	subchannel_nr;	/* 0x00ea */
+			__u32	io_int_parm;	/* 0x00ec */
+			__u32	io_int_word;	/* 0x00f0 */
+		};
+	} __packed;
+	__u8	reservedf4[8];		/* 0x00f4 */
 #define CRYCB_FORMAT_MASK 0x00000003
 #define CRYCB_FORMAT0 0x00000000
 #define CRYCB_FORMAT1 0x00000001
@@ -546,6 +578,12 @@ enum irq_types {
 #define IRQ_PEND_MCHK_MASK ((1UL << IRQ_PEND_MCHK_REP) | \
 			    (1UL << IRQ_PEND_MCHK_EX))
 
+#define IRQ_PEND_EXT_II_MASK ((1UL << IRQ_PEND_EXT_CPU_TIMER)  | \
+			      (1UL << IRQ_PEND_EXT_CLOCK_COMP) | \
+			      (1UL << IRQ_PEND_EXT_EMERGENCY)  | \
+			      (1UL << IRQ_PEND_EXT_EXTERNAL)   | \
+			      (1UL << IRQ_PEND_EXT_SERVICE))
+
 struct kvm_s390_interrupt_info {
 	struct list_head list;
 	u64	type;
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 0cebebf56515..61310b1f5b62 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -387,6 +387,12 @@ static unsigned long deliverable_irqs(struct kvm_vcpu *vcpu)
 		__clear_bit(IRQ_PEND_EXT_SERVICE, &active_mask);
 	if (psw_mchk_disabled(vcpu))
 		active_mask &= ~IRQ_PEND_MCHK_MASK;
+	/* PV guest cpus can have a single interruption injected at a time. */
+	if (kvm_s390_pv_cpu_is_protected(vcpu) &&
+	    vcpu->arch.sie_block->iictl != IICTL_CODE_NONE)
+		active_mask &= ~(IRQ_PEND_EXT_II_MASK |
+				 IRQ_PEND_IO_MASK |
+				 IRQ_PEND_MCHK_MASK);
 	/*
 	 * Check both floating and local interrupt's cr14 because
 	 * bit IRQ_PEND_MCHK_REP could be set in both cases.
@@ -479,19 +485,23 @@ static void set_intercept_indicators(struct kvm_vcpu *vcpu)
 static int __must_check __deliver_cpu_timer(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
-	int rc;
+	int rc = 0;
 
 	vcpu->stat.deliver_cputm++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_CPU_TIMER,
 					 0, 0);
-
-	rc  = put_guest_lc(vcpu, EXT_IRQ_CPU_TIMER,
-			   (u16 *)__LC_EXT_INT_CODE);
-	rc |= put_guest_lc(vcpu, 0, (u16 *)__LC_EXT_CPU_ADDR);
-	rc |= write_guest_lc(vcpu, __LC_EXT_OLD_PSW,
-			     &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
-	rc |= read_guest_lc(vcpu, __LC_EXT_NEW_PSW,
-			    &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
+		vcpu->arch.sie_block->iictl = IICTL_CODE_EXT;
+		vcpu->arch.sie_block->eic = EXT_IRQ_CPU_TIMER;
+	} else {
+		rc  = put_guest_lc(vcpu, EXT_IRQ_CPU_TIMER,
+				   (u16 *)__LC_EXT_INT_CODE);
+		rc |= put_guest_lc(vcpu, 0, (u16 *)__LC_EXT_CPU_ADDR);
+		rc |= write_guest_lc(vcpu, __LC_EXT_OLD_PSW,
+				     &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
+		rc |= read_guest_lc(vcpu, __LC_EXT_NEW_PSW,
+				    &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
+	}
 	clear_bit(IRQ_PEND_EXT_CPU_TIMER, &li->pending_irqs);
 	return rc ? -EFAULT : 0;
 }
@@ -499,19 +509,23 @@ static int __must_check __deliver_cpu_timer(struct kvm_vcpu *vcpu)
 static int __must_check __deliver_ckc(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
-	int rc;
+	int rc = 0;
 
 	vcpu->stat.deliver_ckc++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_CLOCK_COMP,
 					 0, 0);
-
-	rc  = put_guest_lc(vcpu, EXT_IRQ_CLK_COMP,
-			   (u16 __user *)__LC_EXT_INT_CODE);
-	rc |= put_guest_lc(vcpu, 0, (u16 *)__LC_EXT_CPU_ADDR);
-	rc |= write_guest_lc(vcpu, __LC_EXT_OLD_PSW,
-			     &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
-	rc |= read_guest_lc(vcpu, __LC_EXT_NEW_PSW,
-			    &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
+		vcpu->arch.sie_block->iictl = IICTL_CODE_EXT;
+		vcpu->arch.sie_block->eic = EXT_IRQ_CLK_COMP;
+	} else {
+		rc  = put_guest_lc(vcpu, EXT_IRQ_CLK_COMP,
+				   (u16 __user *)__LC_EXT_INT_CODE);
+		rc |= put_guest_lc(vcpu, 0, (u16 *)__LC_EXT_CPU_ADDR);
+		rc |= write_guest_lc(vcpu, __LC_EXT_OLD_PSW,
+				     &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
+		rc |= read_guest_lc(vcpu, __LC_EXT_NEW_PSW,
+				    &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
+	}
 	clear_bit(IRQ_PEND_EXT_CLOCK_COMP, &li->pending_irqs);
 	return rc ? -EFAULT : 0;
 }
@@ -553,6 +567,20 @@ static int __write_machine_check(struct kvm_vcpu *vcpu,
 	union mci mci;
 	int rc;
 
+	/*
+	 * All other possible payload for a machine check (e.g. the register
+	 * contents in the save area) will be handled by the ultravisor, as
+	 * the hypervisor does not not have the needed information for
+	 * protected guests.
+	 */
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
+		vcpu->arch.sie_block->iictl = IICTL_CODE_MCHK;
+		vcpu->arch.sie_block->mcic = mchk->mcic;
+		vcpu->arch.sie_block->faddr = mchk->failing_storage_address;
+		vcpu->arch.sie_block->edc = mchk->ext_damage_code;
+		return 0;
+	}
+
 	mci.val = mchk->mcic;
 	/* take care of lazy register loading */
 	save_fpu_regs();
@@ -696,17 +724,21 @@ static int __must_check __deliver_machine_check(struct kvm_vcpu *vcpu)
 static int __must_check __deliver_restart(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
-	int rc;
+	int rc = 0;
 
 	VCPU_EVENT(vcpu, 3, "%s", "deliver: cpu restart");
 	vcpu->stat.deliver_restart_signal++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_RESTART, 0, 0);
 
-	rc  = write_guest_lc(vcpu,
-			     offsetof(struct lowcore, restart_old_psw),
-			     &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
-	rc |= read_guest_lc(vcpu, offsetof(struct lowcore, restart_psw),
-			    &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
+		vcpu->arch.sie_block->iictl = IICTL_CODE_RESTART;
+	} else {
+		rc  = write_guest_lc(vcpu,
+				     offsetof(struct lowcore, restart_old_psw),
+				     &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
+		rc |= read_guest_lc(vcpu, offsetof(struct lowcore, restart_psw),
+				    &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
+	}
 	clear_bit(IRQ_PEND_RESTART, &li->pending_irqs);
 	return rc ? -EFAULT : 0;
 }
@@ -748,6 +780,12 @@ static int __must_check __deliver_emergency_signal(struct kvm_vcpu *vcpu)
 	vcpu->stat.deliver_emergency_signal++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_EMERGENCY,
 					 cpu_addr, 0);
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
+		vcpu->arch.sie_block->iictl = IICTL_CODE_EXT;
+		vcpu->arch.sie_block->eic = EXT_IRQ_EMERGENCY_SIG;
+		vcpu->arch.sie_block->extcpuaddr = cpu_addr;
+		return 0;
+	}
 
 	rc  = put_guest_lc(vcpu, EXT_IRQ_EMERGENCY_SIG,
 			   (u16 *)__LC_EXT_INT_CODE);
@@ -776,6 +814,12 @@ static int __must_check __deliver_external_call(struct kvm_vcpu *vcpu)
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id,
 					 KVM_S390_INT_EXTERNAL_CALL,
 					 extcall.code, 0);
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
+		vcpu->arch.sie_block->iictl = IICTL_CODE_EXT;
+		vcpu->arch.sie_block->eic = EXT_IRQ_EXTERNAL_CALL;
+		vcpu->arch.sie_block->extcpuaddr = extcall.code;
+		return 0;
+	}
 
 	rc  = put_guest_lc(vcpu, EXT_IRQ_EXTERNAL_CALL,
 			   (u16 *)__LC_EXT_INT_CODE);
@@ -1028,6 +1072,15 @@ static int __do_deliver_io(struct kvm_vcpu *vcpu, struct kvm_s390_io_info *io)
 {
 	int rc;
 
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
+		vcpu->arch.sie_block->iictl = IICTL_CODE_IO;
+		vcpu->arch.sie_block->subchannel_id = io->subchannel_id;
+		vcpu->arch.sie_block->subchannel_nr = io->subchannel_nr;
+		vcpu->arch.sie_block->io_int_parm = io->io_int_parm;
+		vcpu->arch.sie_block->io_int_word = io->io_int_word;
+		return 0;
+	}
+
 	rc  = put_guest_lc(vcpu, io->subchannel_id, (u16 *)__LC_SUBCHANNEL_ID);
 	rc |= put_guest_lc(vcpu, io->subchannel_nr, (u16 *)__LC_SUBCHANNEL_NR);
 	rc |= put_guest_lc(vcpu, io->io_int_parm, (u32 *)__LC_IO_INT_PARM);
@@ -1421,7 +1474,7 @@ static int __inject_extcall(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 	if (kvm_get_vcpu_by_id(vcpu->kvm, src_id) == NULL)
 		return -EINVAL;
 
-	if (sclp.has_sigpif)
+	if (sclp.has_sigpif && !kvm_s390_pv_cpu_get_handle(vcpu))
 		return sca_inject_ext_call(vcpu, src_id);
 
 	if (test_and_set_bit(IRQ_PEND_EXT_EXTERNAL, &li->pending_irqs))
@@ -1773,7 +1826,14 @@ static int __inject_io(struct kvm *kvm, struct kvm_s390_interrupt_info *inti)
 	kvm->stat.inject_io++;
 	isc = int_word_to_isc(inti->io.io_int_word);
 
-	if (gi->origin && inti->type & KVM_S390_INT_IO_AI_MASK) {
+	/*
+	 * Do not make use of gisa in protected mode. We do not use the lock
+	 * checking variant as this is just a performance optimization and we
+	 * do not hold the lock here. This is ok as the code will pick
+	 * interrupts from both "lists" for delivery.
+	 */
+	if (!kvm_s390_pv_get_handle(kvm) &&
+	    gi->origin && inti->type & KVM_S390_INT_IO_AI_MASK) {
 		VM_EVENT(kvm, 4, "%s isc %1u", "inject: I/O (AI/gisa)", isc);
 		gisa_set_ipm_gisc(gi->origin, isc);
 		kfree(inti);
@@ -1834,7 +1894,8 @@ static void __floating_irq_kick(struct kvm *kvm, u64 type)
 		break;
 	case KVM_S390_INT_IO_MIN...KVM_S390_INT_IO_MAX:
 		if (!(type & KVM_S390_INT_IO_AI_MASK &&
-		      kvm->arch.gisa_int.origin))
+		      kvm->arch.gisa_int.origin) ||
+		      kvm_s390_pv_cpu_get_handle(dst_vcpu))
 			kvm_s390_set_cpuflags(dst_vcpu, CPUSTAT_IO_INT);
 		break;
 	default:
-- 
2.25.0

