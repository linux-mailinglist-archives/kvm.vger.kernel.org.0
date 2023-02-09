Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3F16904B2
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 11:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjBIKZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 05:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjBIKZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 05:25:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01C45DC3D;
        Thu,  9 Feb 2023 02:25:13 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3199qTqh003810;
        Thu, 9 Feb 2023 10:25:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=yQ25vObh36sPzadjdfpwpVcCKZLDz691Dwu2dc4VMOM=;
 b=tcd4Gnpo35RXHTvqKSt2UOXEWnzXv5F6nYDjakXsNQuTHXCSl0H7TF1WxK/7vM16uf9X
 HlrHD1ylWy1+8xRhK6aW3meuYF6v9Za4Juh2bYinAgvlT+Z0wMHCxW4bWIHrlHMjIrxF
 sjHHzR4TG8hkq66eWlKWb4yKoWbY6IpWHzIMIMIXasl2greZTyAfl6Q1v8joSh96AtqU
 Wb2FtrDTUYxrLfgkW/I64xLu6SnSmH8WtFpjBS+MWXTACjbq/+j70cHVCkQrIQU7MaZW
 eAHowbutbhpgw8ieiKt6bBOnmKz9lKFJHLeOFDxlG73XDABfMjQHbCb0Qey+97ds9w6S Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmxk60qtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:12 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3199vLWF020498;
        Thu, 9 Feb 2023 10:25:12 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmxk60qsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:12 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 318Irc0a002355;
        Thu, 9 Feb 2023 10:25:10 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3nhf06p0vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:10 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319AP6V646793026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 10:25:06 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD2B82006E;
        Thu,  9 Feb 2023 10:25:06 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A1812006C;
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
Subject: [GIT PULL 11/18] KVM: s390: Dispatch to implementing function at top level of vm mem_op
Date:   Thu,  9 Feb 2023 11:22:53 +0100
Message-Id: <20230209102300.12254-12-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230209102300.12254-1-frankja@linux.ibm.com>
References: <20230209102300.12254-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OIyKlZBmwiQymLf1PLiq0QPihRm0f2aN
X-Proofpoint-ORIG-GUID: jVhLSviudviSELu5uWTX2ItDoK0lV9c_
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_07,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0 spamscore=0
 suspectscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999
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

Instead of having one function covering all mem_op operations,
have a function implementing absolute access and dispatch to that
function in its caller, based on the operation code.
This way additional future operations can be implemented by adding an
implementing function without changing existing operations.

Suggested-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20230206164602.138068-10-scgl@linux.ibm.com
Message-Id: <20230206164602.138068-10-scgl@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 9645015f5921..0053b1fbfc76 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2779,7 +2779,7 @@ static int mem_op_validate_common(struct kvm_s390_mem_op *mop, u64 supported_fla
 	return 0;
 }
 
-static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
+static int kvm_s390_vm_mem_op_abs(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
 	void *tmpbuf = NULL;
@@ -2790,17 +2790,6 @@ static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 	if (r)
 		return r;
 
-	/*
-	 * This is technically a heuristic only, if the kvm->lock is not
-	 * taken, it is not guaranteed that the vm is/remains non-protected.
-	 * This is ok from a kernel perspective, wrongdoing is detected
-	 * on the access, -EFAULT is returned and the vm may crash the
-	 * next time it accesses the memory in question.
-	 * There is no sane usecase to do switching and a memop on two
-	 * different CPUs at the same time.
-	 */
-	if (kvm_s390_pv_get_handle(kvm))
-		return -EINVAL;
 	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
 		tmpbuf = vmalloc(mop->size);
 		if (!tmpbuf)
@@ -2841,8 +2830,6 @@ static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 		}
 		break;
 	}
-	default:
-		r = -EINVAL;
 	}
 
 out_unlock:
@@ -2852,6 +2839,29 @@ static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 	return r;
 }
 
+static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
+{
+	/*
+	 * This is technically a heuristic only, if the kvm->lock is not
+	 * taken, it is not guaranteed that the vm is/remains non-protected.
+	 * This is ok from a kernel perspective, wrongdoing is detected
+	 * on the access, -EFAULT is returned and the vm may crash the
+	 * next time it accesses the memory in question.
+	 * There is no sane usecase to do switching and a memop on two
+	 * different CPUs at the same time.
+	 */
+	if (kvm_s390_pv_get_handle(kvm))
+		return -EINVAL;
+
+	switch (mop->op) {
+	case KVM_S390_MEMOP_ABSOLUTE_READ:
+	case KVM_S390_MEMOP_ABSOLUTE_WRITE:
+		return kvm_s390_vm_mem_op_abs(kvm, mop);
+	default:
+		return -EINVAL;
+	}
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
-- 
2.39.1

