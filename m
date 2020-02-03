Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92BD61506EF
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 14:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgBCNUn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 08:20:43 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13038 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727916AbgBCNUJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 08:20:09 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013DFTUD059380
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:08 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxbx5yker-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 08:20:07 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 013DFjeO060408
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:07 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxbx5yke7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 08:20:07 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 013DJ95j008188;
        Mon, 3 Feb 2020 13:20:06 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04dal.us.ibm.com with ESMTP id 2xw0y6n928-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 13:20:06 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 013DK40a45351236
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Feb 2020 13:20:04 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2E4328067;
        Mon,  3 Feb 2020 13:20:04 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 958F828083;
        Mon,  3 Feb 2020 13:20:04 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Feb 2020 13:20:04 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFCv2 16/37] KVM: s390: protvirt: Add SCLP interrupt handling
Date:   Mon,  3 Feb 2020 08:19:36 -0500
Message-Id: <20200203131957.383915-17-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200203131957.383915-1-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_04:2020-02-02,2020-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 adultscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002030099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The sclp interrupt is kind of special. The ultravisor polices that we
do not inject and sclp interrupt with payload if no sccb is outstanding.
On the other hand we have "asynchronous" event interrupts, e.g. for
console input.
We separate both variants into sclp interrupt and sclp event interrupt.
The sclp interrupt is masked until a previous servc instruction has
finished (sie exit 108).

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  6 ++-
 arch/s390/kvm/intercept.c        | 25 +++++++++
 arch/s390/kvm/interrupt.c        | 92 ++++++++++++++++++++++++++------
 arch/s390/kvm/kvm-s390.c         |  2 +
 4 files changed, 108 insertions(+), 17 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 989cea7a5591..5e85358d9090 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -503,6 +503,7 @@ enum irq_types {
 	IRQ_PEND_PFAULT_INIT,
 	IRQ_PEND_EXT_HOST,
 	IRQ_PEND_EXT_SERVICE,
+	IRQ_PEND_EXT_SERVICE_EV,
 	IRQ_PEND_EXT_TIMING,
 	IRQ_PEND_EXT_CPU_TIMER,
 	IRQ_PEND_EXT_CLOCK_COMP,
@@ -547,6 +548,7 @@ enum irq_types {
 			   (1UL << IRQ_PEND_EXT_TIMING)     | \
 			   (1UL << IRQ_PEND_EXT_HOST)       | \
 			   (1UL << IRQ_PEND_EXT_SERVICE)    | \
+			   (1UL << IRQ_PEND_EXT_SERVICE_EV) | \
 			   (1UL << IRQ_PEND_VIRTIO)         | \
 			   (1UL << IRQ_PEND_PFAULT_INIT)    | \
 			   (1UL << IRQ_PEND_PFAULT_DONE))
@@ -569,7 +571,8 @@ enum irq_types {
 			      (1UL << IRQ_PEND_EXT_CLOCK_COMP) | \
 			      (1UL << IRQ_PEND_EXT_EMERGENCY)  | \
 			      (1UL << IRQ_PEND_EXT_EXTERNAL)   | \
-			      (1UL << IRQ_PEND_EXT_SERVICE))
+			      (1UL << IRQ_PEND_EXT_SERVICE)    | \
+			      (1UL << IRQ_PEND_EXT_SERVICE_EV))
 
 struct kvm_s390_interrupt_info {
 	struct list_head list;
@@ -629,6 +632,7 @@ struct kvm_s390_local_interrupt {
 
 struct kvm_s390_float_interrupt {
 	unsigned long pending_irqs;
+	unsigned long masked_irqs;
 	spinlock_t lock;
 	struct list_head lists[FIRQ_LIST_COUNT];
 	int counters[FIRQ_MAX_COUNT];
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 4b3fbbde1674..c22214967214 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -444,8 +444,33 @@ static int handle_operexc(struct kvm_vcpu *vcpu)
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
+	 *    As the sccb value is not used we can simply set some more bits
+	 *    and make sure that we deliver something
+	 * b: an error sccb interrupt needs to be injected so we also inject
+	 *    something and let firmware do the right thing.
+	 * This makes sure, that both errors and real sccb returns will only
+	 * be delivered when we are unmasked.
+	 */
+	fi->srv_signal.ext_params |= 0x43000;
+	set_bit(IRQ_PEND_EXT_SERVICE, &fi->pending_irqs);
+	clear_bit(IRQ_PEND_EXT_SERVICE, &fi->masked_irqs);
+	spin_unlock(&fi->lock);
+	return 0;
+}
+
 static int handle_pv_not(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->arch.sie_block->ipa == 0xb220)
+		return handle_pv_sclp(vcpu);
+
 	return handle_instruction(vcpu);
 }
 
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index ecdec6960a60..c707725e618b 100644
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
@@ -931,6 +936,31 @@ static int __must_check __deliver_prog(struct kvm_vcpu *vcpu)
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
@@ -938,13 +968,17 @@ static int __must_check __deliver_service(struct kvm_vcpu *vcpu)
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
@@ -953,15 +987,33 @@ static int __must_check __deliver_service(struct kvm_vcpu *vcpu)
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
+
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
 
+	rc = write_sclp(vcpu, SCCB_EVENT_PENDING);
 	return rc ? -EFAULT : 0;
 }
 
@@ -1367,6 +1419,9 @@ int __must_check kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu)
 		case IRQ_PEND_EXT_SERVICE:
 			rc = __deliver_service(vcpu);
 			break;
+		case IRQ_PEND_EXT_SERVICE_EV:
+			rc = __deliver_service_ev(vcpu);
+			break;
 		case IRQ_PEND_PFAULT_DONE:
 			rc = __deliver_pfault_done(vcpu);
 			break;
@@ -1719,9 +1774,6 @@ struct kvm_s390_interrupt_info *kvm_s390_get_io_int(struct kvm *kvm,
 	return inti;
 }
 
-#define SCCB_MASK 0xFFFFFFF8
-#define SCCB_EVENT_PENDING 0x3
-
 static int __inject_service(struct kvm *kvm,
 			     struct kvm_s390_interrupt_info *inti)
 {
@@ -1730,6 +1782,11 @@ static int __inject_service(struct kvm *kvm,
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
@@ -2121,6 +2178,8 @@ void kvm_s390_clear_float_irqs(struct kvm *kvm)
 
 	spin_lock(&fi->lock);
 	fi->pending_irqs = 0;
+	if (!kvm_s390_pv_is_protected(kvm))
+		fi->masked_irqs = 0;
 	memset(&fi->srv_signal, 0, sizeof(fi->srv_signal));
 	memset(&fi->mchk, 0, sizeof(fi->mchk));
 	for (i = 0; i < FIRQ_LIST_COUNT; i++)
@@ -2185,7 +2244,8 @@ static int get_all_floating_irqs(struct kvm *kvm, u8 __user *usrbuf, u64 len)
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
index 741d81f57c3c..39bf39a10cf2 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2194,6 +2194,8 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		if (!r)
 			r = kvm_s390_pv_create_vm(kvm);
 		kvm_s390_vcpu_unblock_all(kvm);
+		/* we need to block service interrupts from now on */
+		set_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
 		mutex_unlock(&kvm->lock);
 		break;
 	}
-- 
2.24.0

