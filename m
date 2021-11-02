Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5AA4436AB
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 20:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhKBTtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 15:49:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36722 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230366AbhKBTtk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 15:49:40 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A2HfJiM025063;
        Tue, 2 Nov 2021 19:47:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Ftkko0CDIocjzrQBOj6NBPCSwPm1C9blkpuXxUgjDDo=;
 b=s3w0Qd4b2PywWybyjbRgoxCzQziw+OTLB9+i4DznRMNRxtYj/x34W3iURXC0zl69ur/v
 96LdpSJJUhhnLbcNcvqfz6g4gUpjL4bUfQTQGB0iVacdVpB97fLR81FvV4wBd44TTVhK
 +TlY4JPCKv7kcKW60eOAnreulwx9InFrv/okUC03L0nmY8ludyBf65pdXKYkezDiz+U6
 m500j60u5PK7gXUXkMSGzikh2oO7Pw3cssRewmMQUKWs52boWNbfo4JdTTmX+QqqmIAJ
 i4jzsEcPiNiRrZJkbqnPEyKw3T0KGu9sL0+/eniBNtm3R5exw1pbB34NdPSQyW9NgVG2 OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c37ugnyjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 19:47:03 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A2JhYZ5009505;
        Tue, 2 Nov 2021 19:47:03 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c37ugnyj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 19:47:03 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A2JSmnZ005610;
        Tue, 2 Nov 2021 19:47:00 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3c0wpaq15t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 19:47:00 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A2JeXY559769146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Nov 2021 19:40:33 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DD544203F;
        Tue,  2 Nov 2021 19:46:57 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3220E42045;
        Tue,  2 Nov 2021 19:46:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  2 Nov 2021 19:46:57 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id CF80DE213C; Tue,  2 Nov 2021 20:46:56 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v2 2/2] KVM: s390: Extend the USER_SIGP capability
Date:   Tue,  2 Nov 2021 20:46:52 +0100
Message-Id: <20211102194652.2685098-3-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211102194652.2685098-1-farman@linux.ibm.com>
References: <20211102194652.2685098-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fEv8iWQy1I5PsYVSxSEWhdrv31qbLwUA
X-Proofpoint-ORIG-GUID: sLcKB4wRK6cI7zSN5oH3JKpKgBxyc-Kj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-02_08,2021-11-02_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 bulkscore=0 priorityscore=1501 phishscore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111020104
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

To fix this, add another CPU capability, dependent on the USER_SIGP one,
that will mark a vcpu as "busy" processing a SIGP order, and a
corresponding IOCTL that userspace can call to indicate it has finished
its work and the SIGP operation is completed.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  2 ++
 arch/s390/kvm/kvm-s390.c         | 18 ++++++++++++++
 arch/s390/kvm/kvm-s390.h         | 10 ++++++++
 arch/s390/kvm/sigp.c             | 40 ++++++++++++++++++++++++++++++++
 4 files changed, 70 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index a604d51acfc8..bd202bb3acb5 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -746,6 +746,7 @@ struct kvm_vcpu_arch {
 	__u64 cputm_start;
 	bool gs_enabled;
 	bool skey_enabled;
+	atomic_t sigp_busy;
 	struct kvm_s390_pv_vcpu pv;
 	union diag318_info diag318_info;
 };
@@ -941,6 +942,7 @@ struct kvm_arch{
 	int user_sigp;
 	int user_stsi;
 	int user_instr0;
+	int user_sigp_busy;
 	struct s390_io_adapter *adapters[MAX_S390_IO_ADAPTERS];
 	wait_queue_head_t ipte_wq;
 	int ipte_lock_count;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 5f52e7eec02f..ff23a46288cc 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -564,6 +564,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_VCPU_RESETS:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_S390_DIAG318:
+	case KVM_CAP_S390_USER_SIGP_BUSY:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
@@ -706,6 +707,15 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 		kvm->arch.user_sigp = 1;
 		r = 0;
 		break;
+	case KVM_CAP_S390_USER_SIGP_BUSY:
+		r = -EINVAL;
+		if (kvm->arch.user_sigp) {
+			kvm->arch.user_sigp_busy = 1;
+			r = 0;
+		}
+		VM_EVENT(kvm, 3, "ENABLE: CAP_S390_USER_SIGP_BUSY %s",
+			 r ? "(not available)" : "(success)");
+		break;
 	case KVM_CAP_S390_VECTOR_REGISTERS:
 		mutex_lock(&kvm->lock);
 		if (kvm->created_vcpus) {
@@ -4825,6 +4835,14 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
 			return -EINVAL;
 		return kvm_s390_inject_vcpu(vcpu, &s390irq);
 	}
+	case KVM_S390_VCPU_RESET_SIGP_BUSY: {
+		if (!vcpu->kvm->arch.user_sigp_busy)
+			return -EFAULT;
+
+		VCPU_EVENT(vcpu, 3, "SIGP: CPU %x reset busy", vcpu->vcpu_id);
+		kvm_s390_vcpu_clear_sigp_busy(vcpu);
+		return 0;
+	}
 	}
 	return -ENOIOCTLCMD;
 }
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index c07a050d757d..9ce97832224b 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -82,6 +82,16 @@ static inline int is_vcpu_idle(struct kvm_vcpu *vcpu)
 	return test_bit(vcpu->vcpu_idx, vcpu->kvm->arch.idle_mask);
 }
 
+static inline bool kvm_s390_vcpu_set_sigp_busy(struct kvm_vcpu *vcpu)
+{
+	return (atomic_cmpxchg(&vcpu->arch.sigp_busy, 0, 1) == 0);
+}
+
+static inline void kvm_s390_vcpu_clear_sigp_busy(struct kvm_vcpu *vcpu)
+{
+	atomic_set(&vcpu->arch.sigp_busy, 0);
+}
+
 static inline int kvm_is_ucontrol(struct kvm *kvm)
 {
 #ifdef CONFIG_KVM_S390_UCONTROL
diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index 5ad3fb4619f1..034ea72e098a 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -341,9 +341,42 @@ static int handle_sigp_dst(struct kvm_vcpu *vcpu, u8 order_code,
 			   "sigp order %u -> cpu %x: handled in user space",
 			   order_code, dst_vcpu->vcpu_id);
 
+	kvm_s390_vcpu_clear_sigp_busy(dst_vcpu);
+
 	return rc;
 }
 
+static int handle_sigp_order_busy(struct kvm_vcpu *vcpu, u8 order_code,
+				  u16 cpu_addr)
+{
+	struct kvm_vcpu *dst_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, cpu_addr);
+
+	if (!vcpu->kvm->arch.user_sigp_busy)
+		return 0;
+
+	/*
+	 * Just see if the target vcpu exists; the CC3 will be set wherever
+	 * the SIGP order is processed directly.
+	 */
+	if (!dst_vcpu)
+		return 0;
+
+	/* Reset orders will be accepted, regardless if target vcpu is busy */
+	if (order_code == SIGP_INITIAL_CPU_RESET ||
+	    order_code == SIGP_CPU_RESET)
+		return 0;
+
+	/* Orders that affect multiple vcpus should not flag one vcpu busy */
+	if (order_code == SIGP_SET_ARCHITECTURE)
+		return 0;
+
+	/* If this fails, the vcpu is already busy processing another SIGP */
+	if (!kvm_s390_vcpu_set_sigp_busy(dst_vcpu))
+		return -EBUSY;
+
+	return 0;
+}
+
 static int handle_sigp_order_in_user_space(struct kvm_vcpu *vcpu, u8 order_code,
 					   u16 cpu_addr)
 {
@@ -408,6 +441,13 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
 
 	order_code = kvm_s390_get_base_disp_rs(vcpu, NULL);
+
+	rc = handle_sigp_order_busy(vcpu, order_code, cpu_addr);
+	if (rc) {
+		kvm_s390_set_psw_cc(vcpu, SIGP_CC_BUSY);
+		return 0;
+	}
+
 	if (handle_sigp_order_in_user_space(vcpu, order_code, cpu_addr))
 		return -EOPNOTSUPP;
 
-- 
2.25.1

