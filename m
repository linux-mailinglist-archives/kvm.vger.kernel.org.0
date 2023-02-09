Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4BAD6904AD
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 11:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjBIKZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 05:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjBIKZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 05:25:14 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984AC5DC35;
        Thu,  9 Feb 2023 02:25:13 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3198hnZj023802;
        Thu, 9 Feb 2023 10:25:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=rZosCB+dWRFsTOHQP/0xsZ+SG33rdpMOV6MnD67qRnY=;
 b=S2PopE115i+LhD6hO7rmFfuf9vVO3eTglD6jy0jneol1KioJ3hP4Pyz0hBxxGp19pV5d
 oUmgQJdP0O/V5H07lZmqJAiwNGcOCsVdwqIyNmOgXyiRObdiSoun0BAeKA6iNSQHdwZ1
 FTl83Q92V/nAeMMHqXLlZ5X5o+7TnbPaX+FIxKBaXrvwq1UW59prHysAquk+sYD6hKym
 uH7bo9XJq+wlZh/mrvJmF6rzd8fE6XuDnSRQWukUMEzfxu61JrkhtC3C+ckOj++VUPlA
 5vLzk7k3x5cajMotv0J+ZgtQtg2t/hKlftOiPG0O9Md5opMHP5sLzrVZs10tH3GBo9Dr ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmwjqjc4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:12 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3198jW9c001040;
        Thu, 9 Feb 2023 10:25:12 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmwjqjc44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:12 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 318JMWTh021016;
        Thu, 9 Feb 2023 10:25:10 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3nhemfp23m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:10 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319AP6Ku46793024
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 10:25:06 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 956762006A;
        Thu,  9 Feb 2023 10:25:06 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71D3320071;
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
Subject: [GIT PULL 10/18] KVM: s390: Move common code of mem_op functions into function
Date:   Thu,  9 Feb 2023 11:22:52 +0100
Message-Id: <20230209102300.12254-11-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230209102300.12254-1-frankja@linux.ibm.com>
References: <20230209102300.12254-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: re2MZ_7-tALr8ZEsY23Epd0jwDjx60-A
X-Proofpoint-ORIG-GUID: QW5BtZsnBQOgLUjb0M_K81jH6cwyihIB
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_07,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=879 priorityscore=1501 clxscore=1015
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

The vcpu and vm mem_op ioctl implementations share some functionality.
Move argument checking into a function and call it from both
implementations. This allows code reuse in case of additional future
mem_op operations.

Suggested-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20230206164602.138068-9-scgl@linux.ibm.com
Message-Id: <20230206164602.138068-9-scgl@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 52 +++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index cb72f9a09fb3..9645015f5921 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2764,24 +2764,32 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 	return r;
 }
 
-static bool access_key_invalid(u8 access_key)
+static int mem_op_validate_common(struct kvm_s390_mem_op *mop, u64 supported_flags)
 {
-	return access_key > 0xf;
+	if (mop->flags & ~supported_flags || !mop->size)
+		return -EINVAL;
+	if (mop->size > MEM_OP_MAX_SIZE)
+		return -E2BIG;
+	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
+		if (mop->key > 0xf)
+			return -EINVAL;
+	} else {
+		mop->key = 0;
+	}
+	return 0;
 }
 
 static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
-	u64 supported_flags;
 	void *tmpbuf = NULL;
 	int r, srcu_idx;
 
-	supported_flags = KVM_S390_MEMOP_F_SKEY_PROTECTION
-			  | KVM_S390_MEMOP_F_CHECK_ONLY;
-	if (mop->flags & ~supported_flags || !mop->size)
-		return -EINVAL;
-	if (mop->size > MEM_OP_MAX_SIZE)
-		return -E2BIG;
+	r = mem_op_validate_common(mop, KVM_S390_MEMOP_F_SKEY_PROTECTION |
+					KVM_S390_MEMOP_F_CHECK_ONLY);
+	if (r)
+		return r;
+
 	/*
 	 * This is technically a heuristic only, if the kvm->lock is not
 	 * taken, it is not guaranteed that the vm is/remains non-protected.
@@ -2793,12 +2801,6 @@ static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 	 */
 	if (kvm_s390_pv_get_handle(kvm))
 		return -EINVAL;
-	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
-		if (access_key_invalid(mop->key))
-			return -EINVAL;
-	} else {
-		mop->key = 0;
-	}
 	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
 		tmpbuf = vmalloc(mop->size);
 		if (!tmpbuf)
@@ -5250,23 +5252,17 @@ static long kvm_s390_vcpu_mem_op(struct kvm_vcpu *vcpu,
 {
 	void __user *uaddr = (void __user *)mop->buf;
 	void *tmpbuf = NULL;
-	int r = 0;
-	const u64 supported_flags = KVM_S390_MEMOP_F_INJECT_EXCEPTION
-				    | KVM_S390_MEMOP_F_CHECK_ONLY
-				    | KVM_S390_MEMOP_F_SKEY_PROTECTION;
+	int r;
 
-	if (mop->flags & ~supported_flags || mop->ar >= NUM_ACRS || !mop->size)
+	r = mem_op_validate_common(mop, KVM_S390_MEMOP_F_INJECT_EXCEPTION |
+					KVM_S390_MEMOP_F_CHECK_ONLY |
+					KVM_S390_MEMOP_F_SKEY_PROTECTION);
+	if (r)
+		return r;
+	if (mop->ar >= NUM_ACRS)
 		return -EINVAL;
-	if (mop->size > MEM_OP_MAX_SIZE)
-		return -E2BIG;
 	if (kvm_s390_pv_cpu_is_protected(vcpu))
 		return -EINVAL;
-	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
-		if (access_key_invalid(mop->key))
-			return -EINVAL;
-	} else {
-		mop->key = 0;
-	}
 	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
 		tmpbuf = vmalloc(mop->size);
 		if (!tmpbuf)
-- 
2.39.1

