Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17CDD17DB94
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 09:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgCIIvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 04:51:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60962 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726495AbgCIIvj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 04:51:39 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0298pHJN005163
        for <kvm@vger.kernel.org>; Mon, 9 Mar 2020 04:51:38 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym7t6dsad-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 04:51:38 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 9 Mar 2020 08:51:36 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 9 Mar 2020 08:51:34 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0298pWKI46137650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Mar 2020 08:51:32 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4C124C046;
        Mon,  9 Mar 2020 08:51:32 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 990E64C044;
        Mon,  9 Mar 2020 08:51:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  9 Mar 2020 08:51:32 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 5B436E0251; Mon,  9 Mar 2020 09:51:32 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Ulrich Weigand <uweigand@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL 15/36] KVM: s390: protvirt: Add SCLP interrupt handling
Date:   Mon,  9 Mar 2020 09:51:05 +0100
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309085126.3334302-1-borntraeger@de.ibm.com>
References: <20200309085126.3334302-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20030908-0012-0000-0000-0000038E7E98
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030908-0013-0000-0000-000021CB45AC
Message-Id: <20200309085126.3334302-16-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_02:2020-03-06,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 bulkscore=0 mlxscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The sclp interrupt is kind of special. The ultravisor polices that we
do not inject an sclp interrupt with payload if no sccb is outstanding.
On the other hand we have "asynchronous" event interrupts, e.g. for
console input.
We separate both variants into sclp interrupt and sclp event interrupt.
The sclp interrupt is masked until a previous servc instruction has
finished (sie exit 108).

[frankja@linux.ibm.com: factoring out write_sclp]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  6 +-
 arch/s390/kvm/intercept.c        | 27 +++++++++
 arch/s390/kvm/interrupt.c        | 95 ++++++++++++++++++++++++++------
 arch/s390/kvm/kvm-s390.c         |  6 ++
 4 files changed, 115 insertions(+), 19 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index a13dc77f8b07..ba3364b37159 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -518,6 +518,7 @@ enum irq_types {
 	IRQ_PEND_PFAULT_INIT,
 	IRQ_PEND_EXT_HOST,
 	IRQ_PEND_EXT_SERVICE,
+	IRQ_PEND_EXT_SERVICE_EV,
 	IRQ_PEND_EXT_TIMING,
 	IRQ_PEND_EXT_CPU_TIMER,
 	IRQ_PEND_EXT_CLOCK_COMP,
@@ -562,6 +563,7 @@ enum irq_types {
 			   (1UL << IRQ_PEND_EXT_TIMING)     | \
 			   (1UL << IRQ_PEND_EXT_HOST)       | \
 			   (1UL << IRQ_PEND_EXT_SERVICE)    | \
+			   (1UL << IRQ_PEND_EXT_SERVICE_EV) | \
 			   (1UL << IRQ_PEND_VIRTIO)         | \
 			   (1UL << IRQ_PEND_PFAULT_INIT)    | \
 			   (1UL << IRQ_PEND_PFAULT_DONE))
@@ -582,7 +584,8 @@ enum irq_types {
 			      (1UL << IRQ_PEND_EXT_CLOCK_COMP) | \
 			      (1UL << IRQ_PEND_EXT_EMERGENCY)  | \
 			      (1UL << IRQ_PEND_EXT_EXTERNAL)   | \
-			      (1UL << IRQ_PEND_EXT_SERVICE))
+			      (1UL << IRQ_PEND_EXT_SERVICE)    | \
+			      (1UL << IRQ_PEND_EXT_SERVICE_EV))
 
 struct kvm_s390_interrupt_info {
 	struct list_head list;
@@ -642,6 +645,7 @@ struct kvm_s390_local_interrupt {
 
 struct kvm_s390_float_interrupt {
 	unsigned long pending_irqs;
+	unsigned long masked_irqs;
 	spinlock_t lock;
 	struct list_head lists[FIRQ_LIST_COUNT];
 	int counters[FIRQ_MAX_COUNT];
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 9966c43c6035..00a79442a428 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -444,8 +444,35 @@ static int handle_operexc(struct kvm_vcpu *vcpu)
 	return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
 }
 
+static int handle_pv_sclp(struct kvm_vcpu *vcpu)
+{
+	struct kvm_s390_float_interrupt *fi = &vcpu->kvm->arch.float_int;
+
+	spin_lock(&fi->lock);
+	/*
+	 * 2 cases:
+	 * a: an sccb answering interrupt was already pending or in flight.
+	 *    As the sccb value is not known we can simply set some value to
+	 *    trigger delivery of a saved SCCB. UV will then use its saved
+	 *    copy of the SCCB value.
+	 * b: an error SCCB interrupt needs to be injected so we also inject
+	 *    a fake SCCB address. Firmware will use the proper one.
+	 * This makes sure, that both errors and real sccb returns will only
+	 * be delivered after a notification intercept (instruction has
+	 * finished) but not after others.
+	 */
+	fi->srv_signal.ext_params |= 0x43000;
+	set_bit(IRQ_PEND_EXT_SERVICE, &fi->pending_irqs);
+	clear_bit(IRQ_PEND_EXT_SERVICE, &fi->masked_irqs);
+	spin_unlock(&fi->lock);
+	return 0;
+}
+
 static int handle_pv_notification(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->arch.sie_block->ipa == 0xb220)
+		return handle_pv_sclp(vcpu);
+
 	return handle_instruction(vcpu);
 }
 
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index fc55f09938eb..145cccd498d7 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -324,8 +324,11 @@ static inline int gisa_tac_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
 
 static inline unsigned long pending_irqs_no_gisa(struct kvm_vcpu *vcpu)
 {
-	return vcpu->kvm->arch.float_int.pending_irqs |
-		vcpu->arch.local_int.pending_irqs;
+	unsigned long pending = vcpu->kvm->arch.float_int.pending_irqs |
+				vcpu->arch.local_int.pending_irqs;
+
+	pending &= ~vcpu->kvm->arch.float_int.masked_irqs;
+	return pending;
 }
 
 static inline unsigned long pending_irqs(struct kvm_vcpu *vcpu)
@@ -383,8 +386,10 @@ static unsigned long deliverable_irqs(struct kvm_vcpu *vcpu)
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
 	/* PV guest cpus can have a single interruption injected at a time. */
@@ -946,20 +951,49 @@ static int __must_check __deliver_prog(struct kvm_vcpu *vcpu)
 	return rc ? -EFAULT : 0;
 }
 
+#define SCCB_MASK 0xFFFFFFF8
+#define SCCB_EVENT_PENDING 0x3
+
+static int write_sclp(struct kvm_vcpu *vcpu, u32 parm)
+{
+	int rc;
+
+	if (kvm_s390_pv_cpu_get_handle(vcpu)) {
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
+
+	return rc ? -EFAULT : 0;
+}
+
 static int __must_check __deliver_service(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_float_interrupt *fi = &vcpu->kvm->arch.float_int;
 	struct kvm_s390_ext_info ext;
-	int rc = 0;
 
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
+	if (kvm_s390_pv_cpu_is_protected(vcpu))
+		set_bit(IRQ_PEND_EXT_SERVICE, &fi->masked_irqs);
 	spin_unlock(&fi->lock);
 
 	VCPU_EVENT(vcpu, 4, "deliver: sclp parameter 0x%x",
@@ -968,16 +1002,31 @@ static int __must_check __deliver_service(struct kvm_vcpu *vcpu)
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
+	return write_sclp(vcpu, ext.ext_params);
+}
 
-	return rc ? -EFAULT : 0;
+static int __must_check __deliver_service_ev(struct kvm_vcpu *vcpu)
+{
+	struct kvm_s390_float_interrupt *fi = &vcpu->kvm->arch.float_int;
+	struct kvm_s390_ext_info ext;
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
+	return write_sclp(vcpu, SCCB_EVENT_PENDING);
 }
 
 static int __must_check __deliver_pfault_done(struct kvm_vcpu *vcpu)
@@ -1382,6 +1431,9 @@ int __must_check kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu)
 		case IRQ_PEND_EXT_SERVICE:
 			rc = __deliver_service(vcpu);
 			break;
+		case IRQ_PEND_EXT_SERVICE_EV:
+			rc = __deliver_service_ev(vcpu);
+			break;
 		case IRQ_PEND_PFAULT_DONE:
 			rc = __deliver_pfault_done(vcpu);
 			break;
@@ -1734,9 +1786,6 @@ struct kvm_s390_interrupt_info *kvm_s390_get_io_int(struct kvm *kvm,
 	return inti;
 }
 
-#define SCCB_MASK 0xFFFFFFF8
-#define SCCB_EVENT_PENDING 0x3
-
 static int __inject_service(struct kvm *kvm,
 			     struct kvm_s390_interrupt_info *inti)
 {
@@ -1745,6 +1794,11 @@ static int __inject_service(struct kvm *kvm,
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
@@ -2141,6 +2195,10 @@ void kvm_s390_clear_float_irqs(struct kvm *kvm)
 	struct kvm_s390_float_interrupt *fi = &kvm->arch.float_int;
 	int i;
 
+	mutex_lock(&kvm->lock);
+	if (!kvm_s390_pv_is_protected(kvm))
+		fi->masked_irqs = 0;
+	mutex_unlock(&kvm->lock);
 	spin_lock(&fi->lock);
 	fi->pending_irqs = 0;
 	memset(&fi->srv_signal, 0, sizeof(fi->srv_signal));
@@ -2207,7 +2265,8 @@ static int get_all_floating_irqs(struct kvm *kvm, u8 __user *usrbuf, u64 len)
 			n++;
 		}
 	}
-	if (test_bit(IRQ_PEND_EXT_SERVICE, &fi->pending_irqs)) {
+	if (test_bit(IRQ_PEND_EXT_SERVICE, &fi->pending_irqs) ||
+	    test_bit(IRQ_PEND_EXT_SERVICE_EV, &fi->pending_irqs)) {
 		if (n == max_irqs) {
 			/* signal userspace to try again */
 			ret = -ENOMEM;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index bf61f48e9a3d..2881151fd773 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2247,6 +2247,9 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		r = kvm_s390_cpus_to_pv(kvm, &cmd->rc, &cmd->rrc);
 		if (r)
 			kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
+
+		/* we need to block service interrupts from now on */
+		set_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
 		break;
 	}
 	case KVM_PV_DISABLE: {
@@ -2263,6 +2266,9 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		if (r)
 			break;
 		r = kvm_s390_pv_deinit_vm(kvm, &cmd->rc, &cmd->rrc);
+
+		/* no need to block service interrupts any more */
+		clear_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
 		break;
 	}
 	case KVM_PV_SET_SEC_PARMS: {
-- 
2.24.1

