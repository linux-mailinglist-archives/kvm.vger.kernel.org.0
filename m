Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258E8492337
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 10:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236317AbiARJxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 04:53:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62888 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234286AbiARJwf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 04:52:35 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20I9Se4D007812;
        Tue, 18 Jan 2022 09:52:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fToiBeFyk7X2qv0GhgQKJmC13Y7eRHJ2EBXvbcgupII=;
 b=OK+ZV2pZIALSp5t17IPaD4wuyRIbjY3wu9CxAC2GakQhay6oQxizWscf+2XtJ0x01tSc
 B/eQUdTsOtpOeehL8b0XgCRbj+EQvIs8geksyUTm/RrzjXyHDpqsqJKKnq9tg6uG6LB7
 hYJpsb24Y8HjRS0Io/GFZUCRyc7j9UgyurH5Ht9TMFj9Hs9YdkcT8r5T6u8KTbCv7KFg
 GhSJD9CPoNTMytyr1b0IDbtStirbg4aKdaIaoKAyix3btjNL7JfLpjbSZ9OGHB5YmF7M
 0QXM9SSSMUjxnEf5mOeuptg+Fc4q9en0p0DDODyKkUQFLt85yz7oyucPXufW7YPW6YDM BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dntxy8cjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:35 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20I9fY7M019460;
        Tue, 18 Jan 2022 09:52:34 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dntxy8cje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:34 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20I9ldq6017710;
        Tue, 18 Jan 2022 09:52:32 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3dknhjapka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:32 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20I9qPk736700606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 09:52:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9764EA4040;
        Tue, 18 Jan 2022 09:52:25 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F110A405B;
        Tue, 18 Jan 2022 09:52:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 09:52:25 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 07/10] KVM: s390: Rename existing vcpu memop functions
Date:   Tue, 18 Jan 2022 10:52:07 +0100
Message-Id: <20220118095210.1651483-8-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220118095210.1651483-1-scgl@linux.ibm.com>
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: V6n9UDZF6BYdDTmsWrjFyJ3fQ2yp7WZZ
X-Proofpoint-ORIG-GUID: c001IxH3Gvw7bnH-Tt9L6R_xZvdhKJCq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_02,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 spamscore=0 phishscore=0 clxscore=1015 bulkscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Makes the naming consistent, now that we also have a vm ioctl.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8dab956f84a6..ab07389fb4d9 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4776,8 +4776,8 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	return r;
 }
 
-static long kvm_s390_guest_sida_op(struct kvm_vcpu *vcpu,
-				   struct kvm_s390_mem_op *mop)
+static long kvm_s390_vcpu_sida_op(struct kvm_vcpu *vcpu,
+				  struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
 	int r = 0;
@@ -4804,8 +4804,9 @@ static long kvm_s390_guest_sida_op(struct kvm_vcpu *vcpu,
 	}
 	return r;
 }
-static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
-				  struct kvm_s390_mem_op *mop)
+
+static long kvm_s390_vcpu_mem_op(struct kvm_vcpu *vcpu,
+				 struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
 	void *tmpbuf = NULL;
@@ -4868,8 +4869,8 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 	return r;
 }
 
-static long kvm_s390_guest_memsida_op(struct kvm_vcpu *vcpu,
-				      struct kvm_s390_mem_op *mop)
+static long kvm_s390_vcpu_memsida_op(struct kvm_vcpu *vcpu,
+				     struct kvm_s390_mem_op *mop)
 {
 	int r, srcu_idx;
 
@@ -4878,12 +4879,12 @@ static long kvm_s390_guest_memsida_op(struct kvm_vcpu *vcpu,
 	switch (mop->op) {
 	case KVM_S390_MEMOP_LOGICAL_READ:
 	case KVM_S390_MEMOP_LOGICAL_WRITE:
-		r = kvm_s390_guest_mem_op(vcpu, mop);
+		r = kvm_s390_vcpu_mem_op(vcpu, mop);
 		break;
 	case KVM_S390_MEMOP_SIDA_READ:
 	case KVM_S390_MEMOP_SIDA_WRITE:
 		/* we are locked against sida going away by the vcpu->mutex */
-		r = kvm_s390_guest_sida_op(vcpu, mop);
+		r = kvm_s390_vcpu_sida_op(vcpu, mop);
 		break;
 	default:
 		r = -EINVAL;
@@ -5046,7 +5047,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		struct kvm_s390_mem_op mem_op;
 
 		if (copy_from_user(&mem_op, argp, sizeof(mem_op)) == 0)
-			r = kvm_s390_guest_memsida_op(vcpu, &mem_op);
+			r = kvm_s390_vcpu_memsida_op(vcpu, &mem_op);
 		else
 			r = -EFAULT;
 		break;
-- 
2.32.0

