Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4296904B7
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 11:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjBIKZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 05:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjBIKZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 05:25:15 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2238B193D6;
        Thu,  9 Feb 2023 02:25:13 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3198heOU023609;
        Thu, 9 Feb 2023 10:25:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=XtkIl19XWpHucLnDuN5IlM6y7eQ2kiQwIJXf3lEh+H4=;
 b=aota4m/ZUuw3xS2QQSbdFQjUzXyEGBkdXEx++JlkpTkTGsOQxzKMG6kN+Fn3SkK/KjqT
 6/iBORnpIvkns3mvlVRJmYVmKzJ1kDOh3gByiT1Oq3BaCM/u4uNcQoS3EDdwAfxJqJ19
 j6/iOMp/bsLB1r/qIJKLB5MsD0VViE3VPAMN8a7z5RPCh4kXIFGQLWf3Ex/cHka+ZKZA
 41fvZU83gxh+QERuHul8IzN+js6xKOWHkRpD210Vo5YEUhDY0uFtDVRIERE5PBrePwkQ
 phahNLC35VeCFwVmQzcX9vfSfpS8WhOzLrIlX1CtcaBPk3wCRGY2IiQMCx3aTGhMhMlN CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmwjqjc52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:12 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 319A12lA028990;
        Thu, 9 Feb 2023 10:25:12 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmwjqjc49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:12 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 318DiMHu005648;
        Thu, 9 Feb 2023 10:25:10 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3nhf06m8tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:10 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319AP7Yo46137644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 10:25:07 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5EEB2006C;
        Thu,  9 Feb 2023 10:25:06 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C299B20071;
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
Subject: [GIT PULL 12/18] KVM: s390: Refactor absolute vm mem_op function
Date:   Thu,  9 Feb 2023 11:22:54 +0100
Message-Id: <20230209102300.12254-13-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230209102300.12254-1-frankja@linux.ibm.com>
References: <20230209102300.12254-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NRkxCgZEtTk-6gUAE3k2mSnozA57WqeL
X-Proofpoint-ORIG-GUID: UDtkqXUst5ayxKq9-MS3zHM9-P8xWcec
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_07,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=685 priorityscore=1501 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20230206164602.138068-11-scgl@linux.ibm.com
Message-Id: <20230206164602.138068-11-scgl@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 43 +++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 25 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 0053b1fbfc76..23f50437a328 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2782,6 +2782,7 @@ static int mem_op_validate_common(struct kvm_s390_mem_op *mop, u64 supported_fla
 static int kvm_s390_vm_mem_op_abs(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
+	enum gacc_mode acc_mode;
 	void *tmpbuf = NULL;
 	int r, srcu_idx;
 
@@ -2803,33 +2804,25 @@ static int kvm_s390_vm_mem_op_abs(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 		goto out_unlock;
 	}
 
-	switch (mop->op) {
-	case KVM_S390_MEMOP_ABSOLUTE_READ: {
-		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
-			r = check_gpa_range(kvm, mop->gaddr, mop->size, GACC_FETCH, mop->key);
-		} else {
-			r = access_guest_abs_with_key(kvm, mop->gaddr, tmpbuf,
-						      mop->size, GACC_FETCH, mop->key);
-			if (r == 0) {
-				if (copy_to_user(uaddr, tmpbuf, mop->size))
-					r = -EFAULT;
-			}
-		}
-		break;
+	acc_mode = mop->op == KVM_S390_MEMOP_ABSOLUTE_READ ? GACC_FETCH : GACC_STORE;
+	if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
+		r = check_gpa_range(kvm, mop->gaddr, mop->size, acc_mode, mop->key);
+		goto out_unlock;
 	}
-	case KVM_S390_MEMOP_ABSOLUTE_WRITE: {
-		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
-			r = check_gpa_range(kvm, mop->gaddr, mop->size, GACC_STORE, mop->key);
-		} else {
-			if (copy_from_user(tmpbuf, uaddr, mop->size)) {
-				r = -EFAULT;
-				break;
-			}
-			r = access_guest_abs_with_key(kvm, mop->gaddr, tmpbuf,
-						      mop->size, GACC_STORE, mop->key);
+	if (acc_mode == GACC_FETCH) {
+		r = access_guest_abs_with_key(kvm, mop->gaddr, tmpbuf,
+					      mop->size, GACC_FETCH, mop->key);
+		if (r)
+			goto out_unlock;
+		if (copy_to_user(uaddr, tmpbuf, mop->size))
+			r = -EFAULT;
+	} else {
+		if (copy_from_user(tmpbuf, uaddr, mop->size)) {
+			r = -EFAULT;
+			goto out_unlock;
 		}
-		break;
-	}
+		r = access_guest_abs_with_key(kvm, mop->gaddr, tmpbuf,
+					      mop->size, GACC_STORE, mop->key);
 	}
 
 out_unlock:
-- 
2.39.1

