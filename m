Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F2775C659
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 14:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjGUMBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 08:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbjGUMBH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 08:01:07 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2133D1727;
        Fri, 21 Jul 2023 05:01:03 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36LB84fI011007;
        Fri, 21 Jul 2023 12:01:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=SJYlPmmm2+7kte8/PfUFdG2KQPM+6C9UlsjmbCRuOlc=;
 b=dXBlwxGgs3A0vqk9+bwOU0s0tkDWzBGenXrJ5dSpcDOtX8Cdrt7LFCvohE8Iw19X6Skp
 7RtUaLi2ifawBLKT8H+EBGLrAKNo2TJLZGJ9Zyy9z5+TzcnPY/UI+Sb7r1Er5w5U663E
 WAHP3XIysVK9Dmq9UDg6FTQZO8aB8PYOsgH8DnCXh7SN5RmnZhn65BDziJRhAkObla89
 DeYfrZm6BZzKWtG2fY6fpRtwKSGYbm1WMrV6sIdZrrh3nVB9PliZWuqtixZBJi6+TUbv
 G0uYKyqmSTwlSmhFi1hy7E8k94gD9V+EUZyFD7fNncfuIFu0D6eyYFugpOIpUT0Rd3gY 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rykd889at-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jul 2023 12:01:01 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36LBcIog002312;
        Fri, 21 Jul 2023 12:01:01 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rykd8899x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jul 2023 12:01:01 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36LAUIZU007106;
        Fri, 21 Jul 2023 12:01:00 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rv80jkxh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jul 2023 12:00:59 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36LC0vXO43057628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 12:00:57 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0547F2004D;
        Fri, 21 Jul 2023 12:00:57 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCB8F2004B;
        Fri, 21 Jul 2023 12:00:56 +0000 (GMT)
Received: from heavy.boeblingen.de.ibm.com (unknown [9.155.200.166])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jul 2023 12:00:56 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Freimann <jfreimann@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v2 4/6] KVM: s390: interrupt: Fix single-stepping userspace-emulated instructions
Date:   Fri, 21 Jul 2023 13:57:57 +0200
Message-ID: <20230721120046.2262291-5-iii@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721120046.2262291-1-iii@linux.ibm.com>
References: <20230721120046.2262291-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: G9KPcIYV4q0vMtC9EQCpyJ6DjOv-MGgy
X-Proofpoint-ORIG-GUID: 2dWP8KWxUOnGCQppfzvDUeRVrHhbnXD-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_07,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 clxscore=1015 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=977
 lowpriorityscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307210104
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Single-stepping a userspace-emulated instruction that generates an
interrupt causes GDB to land on the instruction following it instead of
the respective interrupt handler.

The reason is that after arranging a KVM_EXIT_S390_SIEIC exit,
kvm_handle_sie_intercept() calls kvm_s390_handle_per_ifetch_icpt(),
which sets KVM_GUESTDBG_EXIT_PENDING. This bit, however, is not
processed immediately, but rather persists until the next ioctl(),
causing a spurious single-step exit.

Fix by clearing this bit before KVM_EXIT_S390_SIEIC.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 0c6333b108ba..b717fb8cffed 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5383,6 +5383,7 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
 {
 	struct kvm_vcpu *vcpu = filp->private_data;
 	void __user *argp = (void __user *)arg;
+	int rc;
 
 	switch (ioctl) {
 	case KVM_S390_IRQ: {
@@ -5390,7 +5391,8 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
 
 		if (copy_from_user(&s390irq, argp, sizeof(s390irq)))
 			return -EFAULT;
-		return kvm_s390_inject_vcpu(vcpu, &s390irq);
+		rc = kvm_s390_inject_vcpu(vcpu, &s390irq);
+		break;
 	}
 	case KVM_S390_INTERRUPT: {
 		struct kvm_s390_interrupt s390int;
@@ -5400,10 +5402,18 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
 			return -EFAULT;
 		if (s390int_to_s390irq(&s390int, &s390irq))
 			return -EINVAL;
-		return kvm_s390_inject_vcpu(vcpu, &s390irq);
+		rc = kvm_s390_inject_vcpu(vcpu, &s390irq);
+		break;
 	}
+	default:
+		rc = -ENOIOCTLCMD;
+		break;
 	}
-	return -ENOIOCTLCMD;
+
+	if (!rc)
+		vcpu->guest_debug &= ~KVM_GUESTDBG_EXIT_PENDING;
+
+	return rc;
 }
 
 static int kvm_s390_handle_pv_vcpu_dump(struct kvm_vcpu *vcpu,
-- 
2.41.0

