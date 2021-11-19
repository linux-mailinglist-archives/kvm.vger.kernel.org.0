Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C9B457833
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 22:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235615AbhKSVkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 16:40:19 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38948 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235475AbhKSVkR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 16:40:17 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJLIBsq027325;
        Fri, 19 Nov 2021 21:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+tO7K28mnq66T55XkeDpqwJ1uhbc9+UMlo78ODPC0r4=;
 b=RXAdCfpDjrlubQstvC71BrkmATqewHIs31JAWuLjheL87ZPW76+UmcsADKRU/b+UN9QQ
 M1zEYtVVn+QxFE0wgydDAjxc0Md4zmC3yspOrOBimoIqldbTVjHep9+dsrLP+FhEwjEE
 9KLKELeIDHz+P5hShRChaVIIcWs0skPoNcJ5tTYjuZH1E0/EWH4wkgHB+MZ/LMAXem5+
 0QlLkjRPgyFuEcwdWLaXHCnKoH6DD4DyhSPsV/DtLsHkk++3mZoQliAXkTrKu5jVtjtO
 zqFDRZFppK7pbqu4SfdPBUXrL5voC4I0KAGm6Rz5+Qo9pgHPpHA+NsD92YjJVBtqTfzq Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cekqh09jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 21:37:15 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AJLZoBN032374;
        Fri, 19 Nov 2021 21:37:15 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cekqh09j0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 21:37:14 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AJLHoVN019661;
        Fri, 19 Nov 2021 21:37:12 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3ca4mm23fn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 21:37:12 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AJLU8V562849468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 21:30:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F7DF11C058;
        Fri, 19 Nov 2021 21:37:09 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 387AD11C050;
        Fri, 19 Nov 2021 21:37:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 19 Nov 2021 21:37:09 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id E117AE153A; Fri, 19 Nov 2021 22:37:08 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v4 2/2] KVM: s390: Introduce a USER_BUSY capability and IOCTL
Date:   Fri, 19 Nov 2021 22:37:07 +0100
Message-Id: <20211119213707.2363945-3-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211119213707.2363945-1-farman@linux.ibm.com>
References: <20211119213707.2363945-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OCqCgogrihkCYWaYam_wT59f2tUqi907
X-Proofpoint-ORIG-GUID: vLPtwawY3Kz6YXyNoYy8Ofgv2oBMy-w4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_15,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111190114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With commit 2444b352c3ac ("KVM: s390: forward most SIGP orders to user
space") we have a capability that allows the "fast" SIGP orders (as
defined by the Programming Notes for the SIGNAL PROCESSOR instruction in
the Principles of Operation) to be handled in-kernel, while all others are
sent to userspace for processing.

This works fine but it creates a situation when, for example, a SIGP SENSE
might return CC1 (STATUS STORED, and status bits indicating the vcpu is
stopped), when in actuality userspace is still processing a SIGP STOP AND
STORE STATUS order, and the vcpu is not yet actually stopped. Thus, the
SIGP SENSE should actually be returning CC2 (busy) instead of CC1.

To fix this, add another CPU capability and an associated IOCTL.
The IOCTL can be used by userspace to mark a vcpu "busy" processing a
SIGP order, and cause concurrent orders handled in-kernel to be returned
with CC2 (busy). Another invocation of the IOCTL with a different payload
can be used to mark the SIGP completed, and thus the vcpu is free to
process additional orders.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  2 ++
 arch/s390/kvm/kvm-s390.c         | 40 ++++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h         | 15 ++++++++++++
 arch/s390/kvm/sigp.c             |  3 +++
 4 files changed, 60 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index a604d51acfc8..d05cb4d2e1d5 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -748,6 +748,7 @@ struct kvm_vcpu_arch {
 	bool skey_enabled;
 	struct kvm_s390_pv_vcpu pv;
 	union diag318_info diag318_info;
+	atomic_t busy;
 };
 
 struct kvm_vm_stat {
@@ -941,6 +942,7 @@ struct kvm_arch{
 	int user_sigp;
 	int user_stsi;
 	int user_instr0;
+	int user_busy;
 	struct s390_io_adapter *adapters[MAX_S390_IO_ADAPTERS];
 	wait_queue_head_t ipte_wq;
 	int ipte_lock_count;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 5f52e7eec02f..c9f61777abea 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -564,6 +564,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_VCPU_RESETS:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_S390_DIAG318:
+	case KVM_CAP_S390_USER_BUSY:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
@@ -706,6 +707,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 		kvm->arch.user_sigp = 1;
 		r = 0;
 		break;
+	case KVM_CAP_S390_USER_BUSY:
+		VM_EVENT(kvm, 3, "%s", "ENABLE: CAP_S390_USER_BUSY");
+		kvm->arch.user_busy = 1;
+		r = 0;
+		break;
 	case KVM_CAP_S390_VECTOR_REGISTERS:
 		mutex_lock(&kvm->lock);
 		if (kvm->created_vcpus) {
@@ -4825,6 +4831,40 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
 			return -EINVAL;
 		return kvm_s390_inject_vcpu(vcpu, &s390irq);
 	}
+	case KVM_S390_USER_BUSY: {
+		struct kvm_s390_user_busy_info busy;
+
+		if (!vcpu->kvm->arch.user_busy)
+			return -EINVAL;
+
+		if (copy_from_user(&busy, argp, sizeof(busy)))
+			return -EFAULT;
+
+		switch (busy.reason) {
+		case KVM_S390_USER_BUSY_REASON_SIGP:
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		switch (busy.function) {
+		case KVM_S390_USER_BUSY_FUNCTION_RESET:
+			kvm_s390_vcpu_clear_busy(vcpu);
+			break;
+		case KVM_S390_USER_BUSY_FUNCTION_SET:
+			if (!kvm_s390_vcpu_set_busy(vcpu))
+				return -EBUSY;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		VCPU_EVENT(vcpu, 3, "BUSY: CPU %x %x reason %x payload %x",
+			   vcpu->vcpu_id,
+			   busy.function, busy.reason, busy.payload);
+
+		return 0;
+	}
 	}
 	return -ENOIOCTLCMD;
 }
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index c07a050d757d..92497c23e5a4 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -82,6 +82,21 @@ static inline int is_vcpu_idle(struct kvm_vcpu *vcpu)
 	return test_bit(vcpu->vcpu_idx, vcpu->kvm->arch.idle_mask);
 }
 
+static inline bool kvm_s390_vcpu_is_busy(struct kvm_vcpu *vcpu)
+{
+	return atomic_read(&vcpu->arch.busy) == 1;
+}
+
+static inline bool kvm_s390_vcpu_set_busy(struct kvm_vcpu *vcpu)
+{
+	return atomic_cmpxchg(&vcpu->arch.busy, 0, 1) == 0;
+}
+
+static inline void kvm_s390_vcpu_clear_busy(struct kvm_vcpu *vcpu)
+{
+	atomic_set(&vcpu->arch.busy, 0);
+}
+
 static inline int kvm_is_ucontrol(struct kvm *kvm)
 {
 #ifdef CONFIG_KVM_S390_UCONTROL
diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index 5ad3fb4619f1..c3066b134e50 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -276,6 +276,9 @@ static int handle_sigp_dst(struct kvm_vcpu *vcpu, u8 order_code,
 	if (!dst_vcpu)
 		return SIGP_CC_NOT_OPERATIONAL;
 
+	if (kvm_s390_vcpu_is_busy(dst_vcpu))
+		return SIGP_CC_BUSY;
+
 	switch (order_code) {
 	case SIGP_SENSE:
 		vcpu->stat.instruction_sigp_sense++;
-- 
2.25.1

