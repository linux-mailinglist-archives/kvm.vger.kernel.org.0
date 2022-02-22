Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D774E4BF518
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 10:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbiBVJt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 04:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbiBVJts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 04:49:48 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17156C3352;
        Tue, 22 Feb 2022 01:49:23 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21M7PCH0004471;
        Tue, 22 Feb 2022 09:49:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=UxixEPHJeGnI9d97Bv+PkX9iOHOW7962i7uokKCK9KA=;
 b=NhB4s5TdomgnHxdIrlp884LpUtzp+uFtmQgTfmPcWFu387rWWprZi8uGST1xilIAap/K
 XA7q0+lLHcVuPIQZQrS02lCu+jU8usvZo158fTqJyuIB52qqT7loG9n28p1vJ1i6II6f
 y/YDlMwZZLkc0fzR0/DWhYc/q3RDp0wErtzskELOnUYpJt6Im7+reBSUqcPZmcWCU/27
 1fKz3G3bno+yvZ2gfan+htSPE1RpvRCdjw3jCrE7DVn3JRWmSFwzxRqrZf9tIdHGrb/1
 AruDCLN+zrQG+tR+RPZRrSdfwQ2UcBnFvpHcDBMdqd0jhHFtVpIkhly7S6MK47kRgRAI 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecue4k0vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:22 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21M9nMC0022202;
        Tue, 22 Feb 2022 09:49:22 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecue4k0up-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:22 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21M9lRus000699;
        Tue, 22 Feb 2022 09:49:19 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3eaqtj1kbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:19 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21M9nEvY51839414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 09:49:14 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4421652052;
        Tue, 22 Feb 2022 09:49:14 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 32B1352054;
        Tue, 22 Feb 2022 09:49:14 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id F3169E04EB; Tue, 22 Feb 2022 10:49:13 +0100 (CET)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 08/13] KVM: s390: Rename existing vcpu memop functions
Date:   Tue, 22 Feb 2022 10:49:05 +0100
Message-Id: <20220222094910.18331-9-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220222094910.18331-1-borntraeger@linux.ibm.com>
References: <20220222094910.18331-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uVcte5f5cjQjzUPUlerwteaXI6e16YJq
X-Proofpoint-GUID: OFHWOAzhyvtfNWc1zIpNA7NPyzfvavXo
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_02,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 impostorscore=0 bulkscore=0 spamscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 mlxscore=0 mlxlogscore=955 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202220054
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Makes the naming consistent, now that we also have a vm ioctl.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20220211182215.2730017-8-scgl@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
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
2.35.1

