Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8C66904B3
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 11:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjBIKZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 05:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjBIKZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 05:25:15 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2244566EE6;
        Thu,  9 Feb 2023 02:25:13 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3199qSZM003778;
        Thu, 9 Feb 2023 10:25:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=ipaXqSaI/RJCfJMfCRlZ+K4CW137wiCw6DyZJhcH8w0=;
 b=AMBiF/4r9C9Ck2bUEr1elj0EuUwqGKyI8frVSQJnQmc0xfDaUL1XMCGjZAW6nzUNPgq7
 LYulwmuQHATm/XmGi6mx/QJxAUrMKsjmSflYC2kWQKUGdkJoXTqsIIjfiAmt1t0b+o6n
 aYyyp3AIemOgP7xEdIseNtS1B59Ue1XqlEo7xvwwhTO+cRs5n8gr4CkuFqEMexAxGw3Q
 dFFkSZa1V7ItkYgqaZOLbQEcxS7MoiksbZV+IzI6gB5SUc3PMJI5XUPulsatB+mdIoNQ
 pbZQfyv0PHmgyZhBWNjK4AFIGmbvJiTspF/9uQCbUyvqUdQ7ABfdrIn2mze/pFpw/fZh dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmxk60qu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:13 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3199sn6M010575;
        Thu, 9 Feb 2023 10:25:12 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmxk60qt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:12 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 318L1KFp016027;
        Thu, 9 Feb 2023 10:25:10 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3nhf06v9d0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:10 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319AP7a641353632
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 10:25:07 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CFAC2006E;
        Thu,  9 Feb 2023 10:25:07 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED3B620074;
        Thu,  9 Feb 2023 10:25:06 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com (unknown [9.152.224.253])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  9 Feb 2023 10:25:06 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com
Subject: [GIT PULL 13/18] KVM: s390: Refactor vcpu mem_op function
Date:   Thu,  9 Feb 2023 11:22:55 +0100
Message-Id: <20230209102300.12254-14-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230209102300.12254-1-frankja@linux.ibm.com>
References: <20230209102300.12254-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rWhb5k5xsQ3loAUjFPnSx7WiIk8CSpJ6
X-Proofpoint-ORIG-GUID: Mv4zS_wnGapZXN_5poYy2gF4Kz2bxDI6
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_07,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0 spamscore=0
 suspectscore=0 malwarescore=0 impostorscore=0 mlxlogscore=466
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Remove code duplication with regards to the CHECK_ONLY flag.
Decrease the number of indents.
No functional change indented.

Suggested-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Link: https://lore.kernel.org/r/20230206164602.138068-12-scgl@linux.ibm.com
Message-Id: <20230206164602.138068-12-scgl@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 23f50437a328..17368d118653 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5254,6 +5254,7 @@ static long kvm_s390_vcpu_mem_op(struct kvm_vcpu *vcpu,
 				 struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
+	enum gacc_mode acc_mode;
 	void *tmpbuf = NULL;
 	int r;
 
@@ -5272,38 +5273,35 @@ static long kvm_s390_vcpu_mem_op(struct kvm_vcpu *vcpu,
 			return -ENOMEM;
 	}
 
-	switch (mop->op) {
-	case KVM_S390_MEMOP_LOGICAL_READ:
-		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
-			r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
-					    GACC_FETCH, mop->key);
-			break;
-		}
+	acc_mode = mop->op == KVM_S390_MEMOP_LOGICAL_READ ? GACC_FETCH : GACC_STORE;
+	if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
+		r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
+				    acc_mode, mop->key);
+		goto out_inject;
+	}
+	if (acc_mode == GACC_FETCH) {
 		r = read_guest_with_key(vcpu, mop->gaddr, mop->ar, tmpbuf,
 					mop->size, mop->key);
-		if (r == 0) {
-			if (copy_to_user(uaddr, tmpbuf, mop->size))
-				r = -EFAULT;
-		}
-		break;
-	case KVM_S390_MEMOP_LOGICAL_WRITE:
-		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
-			r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
-					    GACC_STORE, mop->key);
-			break;
+		if (r)
+			goto out_inject;
+		if (copy_to_user(uaddr, tmpbuf, mop->size)) {
+			r = -EFAULT;
+			goto out_free;
 		}
+	} else {
 		if (copy_from_user(tmpbuf, uaddr, mop->size)) {
 			r = -EFAULT;
-			break;
+			goto out_free;
 		}
 		r = write_guest_with_key(vcpu, mop->gaddr, mop->ar, tmpbuf,
 					 mop->size, mop->key);
-		break;
 	}
 
+out_inject:
 	if (r > 0 && (mop->flags & KVM_S390_MEMOP_F_INJECT_EXCEPTION) != 0)
 		kvm_s390_inject_prog_irq(vcpu, &vcpu->arch.pgm);
 
+out_free:
 	vfree(tmpbuf);
 	return r;
 }
-- 
2.39.1

