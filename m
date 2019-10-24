Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2ECCE30C8
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 13:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436520AbfJXLmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 07:42:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58976 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439135AbfJXLmR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 07:42:17 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9OBb9RI088853
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:15 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vuapnhffa-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:15 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 24 Oct 2019 12:42:13 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 24 Oct 2019 12:42:10 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9OBg8Z644761326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 11:42:08 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F18A5205F;
        Thu, 24 Oct 2019 11:42:08 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 13A6952054;
        Thu, 24 Oct 2019 11:42:06 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com, frankja@linux.ibm.com
Subject: [RFC 14/37] KVM: s390: protvirt: Implement interruption injection
Date:   Thu, 24 Oct 2019 07:40:36 -0400
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024114059.102802-1-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102411-0008-0000-0000-00000326C820
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102411-0009-0000-0000-00004A45FB2A
Message-Id: <20191024114059.102802-15-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910240115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Mueller <mimu@linux.ibm.com>

The patch implements interruption injection for the following
list of interruption types:

  - I/O
    __deliver_io (III)

  - External
    __deliver_cpu_timer (IEI)
    __deliver_ckc (IEI)
    __deliver_emergency_signal (IEI)
    __deliver_external_call (IEI)
    __deliver_service (IEI)

  - cpu restart
    __deliver_restart (IRI)

Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com> [interrupt masking]
---
 arch/s390/include/asm/kvm_host.h |  10 ++
 arch/s390/kvm/interrupt.c        | 182 +++++++++++++++++++++++--------
 2 files changed, 149 insertions(+), 43 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 82443236d4cc..63fc32d38aa9 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -496,6 +496,7 @@ enum irq_types {
 	IRQ_PEND_PFAULT_INIT,
 	IRQ_PEND_EXT_HOST,
 	IRQ_PEND_EXT_SERVICE,
+	IRQ_PEND_EXT_SERVICE_EV,
 	IRQ_PEND_EXT_TIMING,
 	IRQ_PEND_EXT_CPU_TIMER,
 	IRQ_PEND_EXT_CLOCK_COMP,
@@ -540,6 +541,7 @@ enum irq_types {
 			   (1UL << IRQ_PEND_EXT_TIMING)     | \
 			   (1UL << IRQ_PEND_EXT_HOST)       | \
 			   (1UL << IRQ_PEND_EXT_SERVICE)    | \
+			   (1UL << IRQ_PEND_EXT_SERVICE_EV) | \
 			   (1UL << IRQ_PEND_VIRTIO)         | \
 			   (1UL << IRQ_PEND_PFAULT_INIT)    | \
 			   (1UL << IRQ_PEND_PFAULT_DONE))
@@ -556,6 +558,13 @@ enum irq_types {
 #define IRQ_PEND_MCHK_MASK ((1UL << IRQ_PEND_MCHK_REP) | \
 			    (1UL << IRQ_PEND_MCHK_EX))
 
+#define IRQ_PEND_EXT_II_MASK ((1UL << IRQ_PEND_EXT_CPU_TIMER)  | \
+			      (1UL << IRQ_PEND_EXT_CLOCK_COMP) | \
+			      (1UL << IRQ_PEND_EXT_EMERGENCY)  | \
+			      (1UL << IRQ_PEND_EXT_EXTERNAL)   | \
+			      (1UL << IRQ_PEND_EXT_SERVICE)    | \
+			      (1UL << IRQ_PEND_EXT_SERVICE_EV))
+
 struct kvm_s390_interrupt_info {
 	struct list_head list;
 	u64	type;
@@ -614,6 +623,7 @@ struct kvm_s390_local_interrupt {
 
 struct kvm_s390_float_interrupt {
 	unsigned long pending_irqs;
+	unsigned long masked_irqs;
 	spinlock_t lock;
 	struct list_head lists[FIRQ_LIST_COUNT];
 	int counters[FIRQ_MAX_COUNT];
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 165dea4c7f19..c919dfe4dfd3 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -324,8 +324,10 @@ static inline int gisa_tac_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
 
 static inline unsigned long pending_irqs_no_gisa(struct kvm_vcpu *vcpu)
 {
-	return vcpu->kvm->arch.float_int.pending_irqs |
-		vcpu->arch.local_int.pending_irqs;
+	unsigned long pending = vcpu->kvm->arch.float_int.pending_irqs | vcpu->arch.local_int.pending_irqs;
+
+	pending &= ~vcpu->kvm->arch.float_int.masked_irqs;
+	return pending;
 }
 
 static inline unsigned long pending_irqs(struct kvm_vcpu *vcpu)
@@ -383,10 +385,16 @@ static unsigned long deliverable_irqs(struct kvm_vcpu *vcpu)
 		__clear_bit(IRQ_PEND_EXT_CLOCK_COMP, &active_mask);
 	if (!(vcpu->arch.sie_block->gcr[0] & CR0_CPU_TIMER_SUBMASK))
 		__clear_bit(IRQ_PEND_EXT_CPU_TIMER, &active_mask);
-	if (!(vcpu->arch.sie_block->gcr[0] & CR0_SERVICE_SIGNAL_SUBMASK))
+	if (!(vcpu->arch.sie_block->gcr[0] & CR0_SERVICE_SIGNAL_SUBMASK)) {
 		__clear_bit(IRQ_PEND_EXT_SERVICE, &active_mask);
+		__clear_bit(IRQ_PEND_EXT_SERVICE_EV, &active_mask);
+	}
 	if (psw_mchk_disabled(vcpu))
 		active_mask &= ~IRQ_PEND_MCHK_MASK;
+	/* PV guest cpus can have a single interruption injected at a time. */
+	if (kvm_s390_pv_is_protected(vcpu->kvm) &&
+	    vcpu->arch.sie_block->iictl != IICTL_CODE_NONE)
+		active_mask &= ~(IRQ_PEND_EXT_II_MASK | IRQ_PEND_IO_MASK);
 	/*
 	 * Check both floating and local interrupt's cr14 because
 	 * bit IRQ_PEND_MCHK_REP could be set in both cases.
@@ -479,19 +487,23 @@ static void set_intercept_indicators(struct kvm_vcpu *vcpu)
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
+	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
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
@@ -499,19 +511,23 @@ static int __must_check __deliver_cpu_timer(struct kvm_vcpu *vcpu)
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
+	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
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
@@ -533,7 +549,6 @@ static int __must_check __deliver_pfault_init(struct kvm_vcpu *vcpu)
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id,
 					 KVM_S390_INT_PFAULT_INIT,
 					 0, ext.ext_params2);
-
 	rc  = put_guest_lc(vcpu, EXT_IRQ_CP_SERVICE, (u16 *) __LC_EXT_INT_CODE);
 	rc |= put_guest_lc(vcpu, PFAULT_INIT, (u16 *) __LC_EXT_CPU_ADDR);
 	rc |= write_guest_lc(vcpu, __LC_EXT_OLD_PSW,
@@ -696,17 +711,21 @@ static int __must_check __deliver_machine_check(struct kvm_vcpu *vcpu)
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
+	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
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
@@ -748,6 +767,12 @@ static int __must_check __deliver_emergency_signal(struct kvm_vcpu *vcpu)
 	vcpu->stat.deliver_emergency_signal++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_EMERGENCY,
 					 cpu_addr, 0);
+	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+		vcpu->arch.sie_block->iictl = IICTL_CODE_EXT;
+		vcpu->arch.sie_block->eic = EXT_IRQ_EMERGENCY_SIG;
+		vcpu->arch.sie_block->extcpuaddr = cpu_addr;
+		return 0;
+	}
 
 	rc  = put_guest_lc(vcpu, EXT_IRQ_EMERGENCY_SIG,
 			   (u16 *)__LC_EXT_INT_CODE);
@@ -776,6 +801,12 @@ static int __must_check __deliver_external_call(struct kvm_vcpu *vcpu)
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id,
 					 KVM_S390_INT_EXTERNAL_CALL,
 					 extcall.code, 0);
+	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+		vcpu->arch.sie_block->iictl = IICTL_CODE_EXT;
+		vcpu->arch.sie_block->eic = EXT_IRQ_EXTERNAL_CALL;
+		vcpu->arch.sie_block->extcpuaddr = extcall.code;
+		return 0;
+	}
 
 	rc  = put_guest_lc(vcpu, EXT_IRQ_EXTERNAL_CALL,
 			   (u16 *)__LC_EXT_INT_CODE);
@@ -902,6 +933,31 @@ static int __must_check __deliver_prog(struct kvm_vcpu *vcpu)
 	return rc ? -EFAULT : 0;
 }
 
+#define SCCB_MASK 0xFFFFFFF8
+#define SCCB_EVENT_PENDING 0x3
+
+static int write_sclp(struct kvm_vcpu *vcpu, u32 parm)
+{
+	int rc;
+
+	if (kvm_s390_pv_handle_cpu(vcpu)) {
+		vcpu->arch.sie_block->iictl = IICTL_CODE_EXT;
+		vcpu->arch.sie_block->eic = EXT_IRQ_SERVICE_SIG;
+		vcpu->arch.sie_block->eiparams = parm;
+		return 0;
+	}
+
+	rc  = put_guest_lc(vcpu, EXT_IRQ_SERVICE_SIG, (u16 *)__LC_EXT_INT_CODE);
+	rc |= put_guest_lc(vcpu, 0, (u16 *)__LC_EXT_CPU_ADDR);
+	rc |= write_guest_lc(vcpu, __LC_EXT_OLD_PSW,
+			     &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
+	rc |= read_guest_lc(vcpu, __LC_EXT_NEW_PSW,
+			    &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
+	rc |= put_guest_lc(vcpu, parm,
+			   (u32 *)__LC_EXT_PARAMS);
+	return rc;
+}
+
 static int __must_check __deliver_service(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_float_interrupt *fi = &vcpu->kvm->arch.float_int;
@@ -909,13 +965,17 @@ static int __must_check __deliver_service(struct kvm_vcpu *vcpu)
 	int rc = 0;
 
 	spin_lock(&fi->lock);
-	if (!(test_bit(IRQ_PEND_EXT_SERVICE, &fi->pending_irqs))) {
+	if (test_bit(IRQ_PEND_EXT_SERVICE, &fi->masked_irqs) ||
+	    !(test_bit(IRQ_PEND_EXT_SERVICE, &fi->pending_irqs))) {
 		spin_unlock(&fi->lock);
 		return 0;
 	}
 	ext = fi->srv_signal;
 	memset(&fi->srv_signal, 0, sizeof(ext));
 	clear_bit(IRQ_PEND_EXT_SERVICE, &fi->pending_irqs);
+	clear_bit(IRQ_PEND_EXT_SERVICE_EV, &fi->pending_irqs);
+	if (kvm_s390_pv_is_protected(vcpu->kvm))
+		set_bit(IRQ_PEND_EXT_SERVICE, &fi->masked_irqs);
 	spin_unlock(&fi->lock);
 
 	VCPU_EVENT(vcpu, 4, "deliver: sclp parameter 0x%x",
@@ -924,15 +984,33 @@ static int __must_check __deliver_service(struct kvm_vcpu *vcpu)
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_SERVICE,
 					 ext.ext_params, 0);
 
-	rc  = put_guest_lc(vcpu, EXT_IRQ_SERVICE_SIG, (u16 *)__LC_EXT_INT_CODE);
-	rc |= put_guest_lc(vcpu, 0, (u16 *)__LC_EXT_CPU_ADDR);
-	rc |= write_guest_lc(vcpu, __LC_EXT_OLD_PSW,
-			     &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
-	rc |= read_guest_lc(vcpu, __LC_EXT_NEW_PSW,
-			    &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
-	rc |= put_guest_lc(vcpu, ext.ext_params,
-			   (u32 *)__LC_EXT_PARAMS);
+	rc = write_sclp(vcpu, ext.ext_params);
+	return rc ? -EFAULT : 0;
+}
 
+static int __must_check __deliver_service_ev(struct kvm_vcpu *vcpu)
+{
+	struct kvm_s390_float_interrupt *fi = &vcpu->kvm->arch.float_int;
+	struct kvm_s390_ext_info ext;
+	int rc = 0;
+
+	spin_lock(&fi->lock);
+	if (!(test_bit(IRQ_PEND_EXT_SERVICE_EV, &fi->pending_irqs))) {
+		spin_unlock(&fi->lock);
+		return 0;
+	}
+	ext = fi->srv_signal;
+	/* only clear the event bit */
+	fi->srv_signal.ext_params &= ~SCCB_EVENT_PENDING;
+	clear_bit(IRQ_PEND_EXT_SERVICE_EV, &fi->pending_irqs);
+	spin_unlock(&fi->lock);
+
+	VCPU_EVENT(vcpu, 4, "%s", "deliver: sclp parameter event");
+	vcpu->stat.deliver_service_signal++;
+	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_SERVICE,
+					 ext.ext_params, 0);
+
+	rc = write_sclp(vcpu, SCCB_EVENT_PENDING);
 	return rc ? -EFAULT : 0;
 }
 
@@ -1028,6 +1106,15 @@ static int __do_deliver_io(struct kvm_vcpu *vcpu, struct kvm_s390_io_info *io)
 {
 	int rc;
 
+	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
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
@@ -1329,6 +1416,9 @@ int __must_check kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu)
 		case IRQ_PEND_EXT_SERVICE:
 			rc = __deliver_service(vcpu);
 			break;
+		case IRQ_PEND_EXT_SERVICE_EV:
+			rc = __deliver_service_ev(vcpu);
+			break;
 		case IRQ_PEND_PFAULT_DONE:
 			rc = __deliver_pfault_done(vcpu);
 			break;
@@ -1421,7 +1511,7 @@ static int __inject_extcall(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 	if (kvm_get_vcpu_by_id(vcpu->kvm, src_id) == NULL)
 		return -EINVAL;
 
-	if (sclp.has_sigpif)
+	if (sclp.has_sigpif && !kvm_s390_pv_handle_cpu(vcpu))
 		return sca_inject_ext_call(vcpu, src_id);
 
 	if (test_and_set_bit(IRQ_PEND_EXT_EXTERNAL, &li->pending_irqs))
@@ -1681,9 +1771,6 @@ struct kvm_s390_interrupt_info *kvm_s390_get_io_int(struct kvm *kvm,
 	return inti;
 }
 
-#define SCCB_MASK 0xFFFFFFF8
-#define SCCB_EVENT_PENDING 0x3
-
 static int __inject_service(struct kvm *kvm,
 			     struct kvm_s390_interrupt_info *inti)
 {
@@ -1692,6 +1779,11 @@ static int __inject_service(struct kvm *kvm,
 	kvm->stat.inject_service_signal++;
 	spin_lock(&fi->lock);
 	fi->srv_signal.ext_params |= inti->ext.ext_params & SCCB_EVENT_PENDING;
+
+	/* We always allow events, track them separately from the sccb ints */
+	if (fi->srv_signal.ext_params & SCCB_EVENT_PENDING)
+		set_bit(IRQ_PEND_EXT_SERVICE_EV, &fi->pending_irqs);
+
 	/*
 	 * Early versions of the QEMU s390 bios will inject several
 	 * service interrupts after another without handling a
@@ -1834,7 +1926,8 @@ static void __floating_irq_kick(struct kvm *kvm, u64 type)
 		break;
 	case KVM_S390_INT_IO_MIN...KVM_S390_INT_IO_MAX:
 		if (!(type & KVM_S390_INT_IO_AI_MASK &&
-		      kvm->arch.gisa_int.origin))
+		      kvm->arch.gisa_int.origin) ||
+		      kvm_s390_pv_handle_cpu(dst_vcpu))
 			kvm_s390_set_cpuflags(dst_vcpu, CPUSTAT_IO_INT);
 		break;
 	default:
@@ -2082,6 +2175,8 @@ void kvm_s390_clear_float_irqs(struct kvm *kvm)
 
 	spin_lock(&fi->lock);
 	fi->pending_irqs = 0;
+	if (!kvm_s390_pv_is_protected(kvm))
+		fi->masked_irqs = 0;
 	memset(&fi->srv_signal, 0, sizeof(fi->srv_signal));
 	memset(&fi->mchk, 0, sizeof(fi->mchk));
 	for (i = 0; i < FIRQ_LIST_COUNT; i++)
@@ -2146,7 +2241,8 @@ static int get_all_floating_irqs(struct kvm *kvm, u8 __user *usrbuf, u64 len)
 			n++;
 		}
 	}
-	if (test_bit(IRQ_PEND_EXT_SERVICE, &fi->pending_irqs)) {
+	if (test_bit(IRQ_PEND_EXT_SERVICE, &fi->pending_irqs) ||
+	    test_bit(IRQ_PEND_EXT_SERVICE_EV, &fi->pending_irqs)) {
 		if (n == max_irqs) {
 			/* signal userspace to try again */
 			ret = -ENOMEM;
-- 
2.20.1

