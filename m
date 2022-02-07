Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABBF04AC715
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 18:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382747AbiBGROv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 12:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358094AbiBGRAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 12:00:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3536C0401D3;
        Mon,  7 Feb 2022 09:00:13 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217GxKCg011938;
        Mon, 7 Feb 2022 17:00:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pcWmQo0q0FyBfonh7gvGQPT5hdRyaZwmFhTUu5etUGg=;
 b=HMH+I761bK3WwG8ni8oC30aLZedWM9YOl0nkTgQwfJ640aiI6mhdn14O+tlONYXAbBgy
 fEuz0h7weLfSllYoaATWtInkl4TGSiSQY1UayeuJRK/XmVXmdW4sU+xVE5emkfeEF8xx
 Lc3NWmuaz2gCpt3Lx+2vQk+NYU5WADJhX9Kcd10e7+bFUA0/t2eAetNxxakOkLjIvKn9
 eWIIOl/N0vYXPQS9zpsibVkd2IH7Xg9ZseS+ZNGBZ0RT+xNvZ5SmX7X0w6DU25J3FuEe
 /tyEhnsVwJsFcs/EFO0zuTBIkqJBDjggpN0tYEC3q2uvxnfe48FMYfg6i5Z7coOKlxLI cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e22nk9x65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:00:11 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217H0B98019974;
        Mon, 7 Feb 2022 17:00:11 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e22nk9x50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:00:11 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217Gs8ub001177;
        Mon, 7 Feb 2022 17:00:09 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3e1ggjpvkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:00:09 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217H03UT30278136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 17:00:03 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2571FA405F;
        Mon,  7 Feb 2022 17:00:03 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC7C3A4053;
        Mon,  7 Feb 2022 17:00:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 17:00:02 +0000 (GMT)
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
Subject: [PATCH v2 07/11] KVM: s390: Rename existing vcpu memop functions
Date:   Mon,  7 Feb 2022 17:59:26 +0100
Message-Id: <20220207165930.1608621-8-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220207165930.1608621-1-scgl@linux.ibm.com>
References: <20220207165930.1608621-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9ewhXaf29fmT3tHYaeFig3y6tPlEK03O
X-Proofpoint-ORIG-GUID: _pQGnTh7S_-TAibQZDj0ri88dFblmrGp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 mlxlogscore=999 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070103
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
index be9092295d3f..befb30923c0e 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4745,8 +4745,8 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	return r;
 }
 
-static long kvm_s390_guest_sida_op(struct kvm_vcpu *vcpu,
-				   struct kvm_s390_mem_op *mop)
+static long kvm_s390_vcpu_sida_op(struct kvm_vcpu *vcpu,
+				  struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
 	int r = 0;
@@ -4773,8 +4773,9 @@ static long kvm_s390_guest_sida_op(struct kvm_vcpu *vcpu,
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
 	u8 access_key = 0, ar = 0;
@@ -4852,8 +4853,8 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 	return r;
 }
 
-static long kvm_s390_guest_memsida_op(struct kvm_vcpu *vcpu,
-				      struct kvm_s390_mem_op *mop)
+static long kvm_s390_vcpu_memsida_op(struct kvm_vcpu *vcpu,
+				     struct kvm_s390_mem_op *mop)
 {
 	int r, srcu_idx;
 
@@ -4862,12 +4863,12 @@ static long kvm_s390_guest_memsida_op(struct kvm_vcpu *vcpu,
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
@@ -5030,7 +5031,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		struct kvm_s390_mem_op mem_op;
 
 		if (copy_from_user(&mem_op, argp, sizeof(mem_op)) == 0)
-			r = kvm_s390_guest_memsida_op(vcpu, &mem_op);
+			r = kvm_s390_vcpu_memsida_op(vcpu, &mem_op);
 		else
 			r = -EFAULT;
 		break;
-- 
2.32.0

