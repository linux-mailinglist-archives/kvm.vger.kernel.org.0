Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383F947B2A6
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 19:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240391AbhLTSLV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 13:11:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4508 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240332AbhLTSLO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Dec 2021 13:11:14 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BKHeCK1005451;
        Mon, 20 Dec 2021 18:11:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=t72i+Dq83P6W1gV3t4uMZkELP7j3o4ceSic8RDozuEg=;
 b=Wt8wqOohTThFCnvxpRyDlM8mSTILaVqal76QYDTJ1wptB6bfk1jq3nGlXFg98p98I+25
 htU4nT7P9f8t1gqAVUkjWX1CS2mznbQiIFtciFp/Ai2pDKQjTdOGrwS5ELrKyiVZ3Qj4
 fQHrM/tv2lwH3ASzhwrGLZsIdTov8ggKfgqVFtRP4eWD+87MJXHcXNlbEBEIXyxGd5U7
 g1zEeqvHg+bjEOg+fjojmr7YFWbHA+uiNMgUXHk88QAvd379iI0ijzIdoauXbITtvCes
 iq42aH7rLHflvW87Kv/hTwqA8TLXS6c5++diEMh4Q9sB+3AGhrchvPfEFnBi7U2G27cD uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d2q0jtgtw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 18:11:13 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BKHO757014616;
        Mon, 20 Dec 2021 18:11:13 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d2q0jtgt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 18:11:13 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BKI4WHE006870;
        Mon, 20 Dec 2021 18:11:10 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3d16wjfbnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 18:11:10 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BKIB7P143516404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Dec 2021 18:11:07 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2AA4BAE051;
        Mon, 20 Dec 2021 18:11:07 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 124D0AE057;
        Mon, 20 Dec 2021 18:11:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 20 Dec 2021 18:11:07 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id BBD63E63A4; Mon, 20 Dec 2021 19:11:06 +0100 (CET)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [GIT PULL 6/6] KVM: s390: Clarify SIGP orders versus STOP/RESTART
Date:   Mon, 20 Dec 2021 19:11:04 +0100
Message-Id: <20211220181104.595009-7-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211220181104.595009-1-borntraeger@linux.ibm.com>
References: <20211220181104.595009-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3NeCVFPWu8SziFQehV5KyMj_OvWGmxQn
X-Proofpoint-ORIG-GUID: 7BXltx974cbVFvObvrNgvjDwtSpp366T
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-20_08,2021-12-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999 phishscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112200101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

With KVM_CAP_S390_USER_SIGP, there are only five Signal Processor
orders (CONDITIONAL EMERGENCY SIGNAL, EMERGENCY SIGNAL, EXTERNAL CALL,
SENSE, and SENSE RUNNING STATUS) which are intended for frequent use
and thus are processed in-kernel. The remainder are sent to userspace
with the KVM_CAP_S390_USER_SIGP capability. Of those, three orders
(RESTART, STOP, and STOP AND STORE STATUS) have the potential to
inject work back into the kernel, and thus are asynchronous.

Let's look for those pending IRQs when processing one of the in-kernel
SIGP orders, and return BUSY (CC2) if one is in process. This is in
agreement with the Principles of Operation, which states that only one
order can be "active" on a CPU at a time.

Cc: stable@vger.kernel.org
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20211213210550.856213-2-farman@linux.ibm.com
[borntraeger@linux.ibm.com: add stable tag]
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c |  7 +++++++
 arch/s390/kvm/kvm-s390.c  |  9 +++++++--
 arch/s390/kvm/kvm-s390.h  |  1 +
 arch/s390/kvm/sigp.c      | 28 ++++++++++++++++++++++++++++
 4 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index c3bd993fdd0c..0576d5c99138 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2115,6 +2115,13 @@ int kvm_s390_is_stop_irq_pending(struct kvm_vcpu *vcpu)
 	return test_bit(IRQ_PEND_SIGP_STOP, &li->pending_irqs);
 }
 
+int kvm_s390_is_restart_irq_pending(struct kvm_vcpu *vcpu)
+{
+	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
+
+	return test_bit(IRQ_PEND_RESTART, &li->pending_irqs);
+}
+
 void kvm_s390_clear_stop_irq(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 14a18ba5ff2c..ef299aad4009 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4645,10 +4645,15 @@ int kvm_s390_vcpu_stop(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	/* SIGP STOP and SIGP STOP AND STORE STATUS has been fully processed */
+	/*
+	 * Set the VCPU to STOPPED and THEN clear the interrupt flag,
+	 * now that the SIGP STOP and SIGP STOP AND STORE STATUS orders
+	 * have been fully processed. This will ensure that the VCPU
+	 * is kept BUSY if another VCPU is inquiring with SIGP SENSE.
+	 */
+	kvm_s390_set_cpuflags(vcpu, CPUSTAT_STOPPED);
 	kvm_s390_clear_stop_irq(vcpu);
 
-	kvm_s390_set_cpuflags(vcpu, CPUSTAT_STOPPED);
 	__disable_ibs_on_vcpu(vcpu);
 
 	for (i = 0; i < online_vcpus; i++) {
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index c07a050d757d..1876ab0c293f 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -427,6 +427,7 @@ void kvm_s390_destroy_adapters(struct kvm *kvm);
 int kvm_s390_ext_call_pending(struct kvm_vcpu *vcpu);
 extern struct kvm_device_ops kvm_flic_ops;
 int kvm_s390_is_stop_irq_pending(struct kvm_vcpu *vcpu);
+int kvm_s390_is_restart_irq_pending(struct kvm_vcpu *vcpu);
 void kvm_s390_clear_stop_irq(struct kvm_vcpu *vcpu);
 int kvm_s390_set_irq_state(struct kvm_vcpu *vcpu,
 			   void __user *buf, int len);
diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index cf4de80bd541..8aaee2892ec3 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -276,6 +276,34 @@ static int handle_sigp_dst(struct kvm_vcpu *vcpu, u8 order_code,
 	if (!dst_vcpu)
 		return SIGP_CC_NOT_OPERATIONAL;
 
+	/*
+	 * SIGP RESTART, SIGP STOP, and SIGP STOP AND STORE STATUS orders
+	 * are processed asynchronously. Until the affected VCPU finishes
+	 * its work and calls back into KVM to clear the (RESTART or STOP)
+	 * interrupt, we need to return any new non-reset orders "busy".
+	 *
+	 * This is important because a single VCPU could issue:
+	 *  1) SIGP STOP $DESTINATION
+	 *  2) SIGP SENSE $DESTINATION
+	 *
+	 * If the SIGP SENSE would not be rejected as "busy", it could
+	 * return an incorrect answer as to whether the VCPU is STOPPED
+	 * or OPERATING.
+	 */
+	if (order_code != SIGP_INITIAL_CPU_RESET &&
+	    order_code != SIGP_CPU_RESET) {
+		/*
+		 * Lockless check. Both SIGP STOP and SIGP (RE)START
+		 * properly synchronize everything while processing
+		 * their orders, while the guest cannot observe a
+		 * difference when issuing other orders from two
+		 * different VCPUs.
+		 */
+		if (kvm_s390_is_stop_irq_pending(dst_vcpu) ||
+		    kvm_s390_is_restart_irq_pending(dst_vcpu))
+			return SIGP_CC_BUSY;
+	}
+
 	switch (order_code) {
 	case SIGP_SENSE:
 		vcpu->stat.instruction_sigp_sense++;
-- 
2.33.1

