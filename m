Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5BF74B2CBC
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 19:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352666AbiBKSWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 13:22:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352609AbiBKSW3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 13:22:29 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E2F196;
        Fri, 11 Feb 2022 10:22:28 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BHvJMG001836;
        Fri, 11 Feb 2022 18:22:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=OWnK9tzmWdhK2TZFn9Xq30TFdbZWOX+ioANPcoD0StA=;
 b=Wwn4ZlrY2UBXUIPLEbghqSjndTQQxJdWgPyI5ecRvbrG/8DDWGP2bDAfm86Tw320U3mS
 oUbP7omPI0PbLnf4w9e43VJCFEQKxzHXh+cJ9FXL4LMDbd5jq8qBIyzRxHyuP+WN0eFt
 rIGlXGri5R7rChHdRYEurpvHfIypvGek6x2sAfUplKIV0FrX4ZL9GPTKZEja6ZFjRUfU
 fucOb6juXPjYOJgwehYGx8o7zzXrUexRp89/yLG1O0zBsLBIVhfANXTylsSQjHmuWckS
 JzEVeV61p8UQ6irCZrCLgkTy/v1aB7he2L6Z3ULnYDUkD5DGn9nETgNUsnBy/TZR0vKR sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e5tf63g1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 18:22:26 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21BIEHWt028519;
        Fri, 11 Feb 2022 18:22:25 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e5tf63g18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 18:22:25 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21BICMKB015232;
        Fri, 11 Feb 2022 18:22:24 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3e1gva9kf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 18:22:24 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21BIC8DN47579594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 18:12:08 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CE545204E;
        Fri, 11 Feb 2022 18:22:20 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 23E9452051;
        Fri, 11 Feb 2022 18:22:20 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v4 07/10] KVM: s390: Rename existing vcpu memop functions
Date:   Fri, 11 Feb 2022 19:22:12 +0100
Message-Id: <20220211182215.2730017-8-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220211182215.2730017-1-scgl@linux.ibm.com>
References: <20220211182215.2730017-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OYgMrVQch2YcM3fwwDlI_rBzNp6VWrwj
X-Proofpoint-ORIG-GUID: V29AmG4DhWyQUo3Uh7Qa4Tx1LRf-SiVw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_05,2022-02-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 impostorscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 36bc73b5f5de..773bccdd446c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4741,8 +4741,8 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	return r;
 }
 
-static long kvm_s390_guest_sida_op(struct kvm_vcpu *vcpu,
-				   struct kvm_s390_mem_op *mop)
+static long kvm_s390_vcpu_sida_op(struct kvm_vcpu *vcpu,
+				  struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
 	int r = 0;
@@ -4771,8 +4771,9 @@ static long kvm_s390_guest_sida_op(struct kvm_vcpu *vcpu,
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
@@ -4835,8 +4836,8 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 	return r;
 }
 
-static long kvm_s390_guest_memsida_op(struct kvm_vcpu *vcpu,
-				      struct kvm_s390_mem_op *mop)
+static long kvm_s390_vcpu_memsida_op(struct kvm_vcpu *vcpu,
+				     struct kvm_s390_mem_op *mop)
 {
 	int r, srcu_idx;
 
@@ -4845,12 +4846,12 @@ static long kvm_s390_guest_memsida_op(struct kvm_vcpu *vcpu,
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
@@ -5013,7 +5014,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		struct kvm_s390_mem_op mem_op;
 
 		if (copy_from_user(&mem_op, argp, sizeof(mem_op)) == 0)
-			r = kvm_s390_guest_memsida_op(vcpu, &mem_op);
+			r = kvm_s390_vcpu_memsida_op(vcpu, &mem_op);
 		else
 			r = -EFAULT;
 		break;
-- 
2.32.0

