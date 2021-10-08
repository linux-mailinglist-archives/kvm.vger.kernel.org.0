Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A3142724D
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 22:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242602AbhJHUdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 16:33:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34336 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231684AbhJHUd1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Oct 2021 16:33:27 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 198KRTLT019995;
        Fri, 8 Oct 2021 16:31:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=UA6q3jUaNN7g2IM6Ia2YJ9iu6qE7Ksg5WFSf4U8H6eo=;
 b=gTnko5evMKG4WAL7PiensrABoec1sJ2YOcjytmgPB+28UPGig9wVGbdR1JXn/81NN3L+
 +oa8EKxUQ9qhOQou4OJThPfzBgPNiC+kAAW4wWfZfLscE4k4NbCoZijiuu4uqVNKDnyn
 E0Cs76DxTwuAr2RxPNOebKb+eyd02YVZ5SIPPIg0kXytFtMIX+rqz0RB4PIApGSUstHm
 Yf1H3RHJQjArRzaH3+qdHbYuZuKDQBxo8IpL4WBrSZiGnYuwQtvbHzgLGieRF3WhjegL
 XFUIQvAgMm2bqKbEaRE0zrSYvMBPMnyM6i2r0PNJtTMCfjAybHnQhPVDbcnzvlMQbXFg 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bjueat6xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 16:31:31 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 198KTxS4000869;
        Fri, 8 Oct 2021 16:31:31 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bjueat6wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 16:31:30 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 198KMZRk014291;
        Fri, 8 Oct 2021 20:31:29 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3bef2b5j13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 20:31:29 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 198KVPiJ28639504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Oct 2021 20:31:25 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3559C4C052;
        Fri,  8 Oct 2021 20:31:25 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E4574C040;
        Fri,  8 Oct 2021 20:31:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  8 Oct 2021 20:31:25 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 466A6E03A2; Fri,  8 Oct 2021 22:31:24 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v1 6/6] KVM: s390: Add a routine for setting userspace CPU state
Date:   Fri,  8 Oct 2021 22:31:12 +0200
Message-Id: <20211008203112.1979843-7-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211008203112.1979843-1-farman@linux.ibm.com>
References: <20211008203112.1979843-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Uchr0fwuZmDTZDLpefSf0seXm2BBWvMA
X-Proofpoint-ORIG-GUID: QHRRlztsJ1iFFasi_pL--QSZp1WwomxH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-08_06,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxlogscore=990 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 impostorscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110080112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This capability exists, but we don't record anything when userspace
enables it. Let's refactor that code so that a note can be made in
the debug logs that it was enabled.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 6 +++---
 arch/s390/kvm/kvm-s390.h | 9 +++++++++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 33d71fa42d68..48ac0bd05bee 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2487,8 +2487,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_S390_PV_COMMAND: {
 		struct kvm_pv_cmd args;
 
-		/* protvirt means user sigp */
-		kvm->arch.user_cpu_state_ctrl = 1;
+		/* protvirt means user cpu state */
+		kvm_s390_set_user_cpu_state_ctrl(kvm);
 		r = 0;
 		if (!is_prot_virt_host()) {
 			r = -EINVAL;
@@ -3801,7 +3801,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 	vcpu_load(vcpu);
 
 	/* user space knows about this interface - let it control the state */
-	vcpu->kvm->arch.user_cpu_state_ctrl = 1;
+	kvm_s390_set_user_cpu_state_ctrl(vcpu->kvm);
 
 	switch (mp_state->mp_state) {
 	case KVM_MP_STATE_STOPPED:
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 57c5e9369d65..36f4d585513c 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -208,6 +208,15 @@ static inline int kvm_s390_user_cpu_state_ctrl(struct kvm *kvm)
 	return kvm->arch.user_cpu_state_ctrl != 0;
 }
 
+static inline void kvm_s390_set_user_cpu_state_ctrl(struct kvm *kvm)
+{
+	if (kvm->arch.user_cpu_state_ctrl)
+		return;
+
+	VM_EVENT(kvm, 3, "%s", "ENABLE: Userspace CPU state control");
+	kvm->arch.user_cpu_state_ctrl = 1;
+}
+
 /* implemented in pv.c */
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
 int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
-- 
2.25.1

