Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FED175F043
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 11:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbjGXJuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 05:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbjGXJtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 05:49:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C2B30DE;
        Mon, 24 Jul 2023 02:47:53 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36O9fNNa011317;
        Mon, 24 Jul 2023 09:47:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Zh8Dl4j+HbPUG3MkYbWK7FjriCZO5B07RnwSIB5EWE0=;
 b=ip13UA0w1E1EjokU+N+Bop+2yp/aCFhEKohUIdJJZUeI4TATqFg2OkNHUaiKsW7YhQ7A
 OW1yPjfVwdLFlrX3w9Ub2HM7Vr9iAEDAVCxjxrM2BS8SJ/c4Im6XVOFyw1RCLWg8fA8f
 JQXwDV2Lk8ZEsg18imTQgaa6W2LEdHZpnSdgXpFe4WqwKGQH7W5T9sX8gAPtf4Yr40t0
 LZzQgzIce8L/4ie0yZwhI9s1VvZMfZntUdAP00lidJT7Fh2GkA6Yz5Zk+U5rnhoPvLP1
 COvomyn4j6bvxyE6/OQVUgwakq7C7ups+N1Ap6OtXgbZrP32AkvY+cTVc7qdE2cPqkoS 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s1nk32r6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 09:47:37 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36O9ixqB024414;
        Mon, 24 Jul 2023 09:47:37 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s1nk32r5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 09:47:37 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36O9O9ti002639;
        Mon, 24 Jul 2023 09:47:35 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0txjhv9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 09:47:35 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36O9lWpj19202708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 09:47:32 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2997520043;
        Mon, 24 Jul 2023 09:47:32 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DF9B20040;
        Mon, 24 Jul 2023 09:47:31 +0000 (GMT)
Received: from heavy.boeblingen.de.ibm.com (unknown [9.171.11.212])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jul 2023 09:47:31 +0000 (GMT)
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
Subject: [PATCH v3 4/6] KVM: s390: interrupt: Fix single-stepping userspace-emulated instructions
Date:   Mon, 24 Jul 2023 11:44:10 +0200
Message-ID: <20230724094716.91510-5-iii@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230724094716.91510-1-iii@linux.ibm.com>
References: <20230724094716.91510-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: H0eeDrltzCKD0xkcK65x6pvlYQtfQqYP
X-Proofpoint-GUID: C-26tXq4VlpSPsKpAiWeB0N1kb2cUbQs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_07,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 impostorscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307240084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

Fix by clearing this bit in ioctl().

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 0c6333b108ba..e6511608280c 100644
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
@@ -5400,10 +5402,25 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
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
+	/*
+	 * To simplify single stepping of userspace-emulated instructions,
+	 * KVM_EXIT_S390_SIEIC exit sets KVM_GUESTDBG_EXIT_PENDING (see
+	 * should_handle_per_ifetch()). However, if userspace emulation injects
+	 * an interrupt, it needs to be cleared, so that KVM_EXIT_DEBUG happens
+	 * after (and not before) the interrupt delivery.
+	 */
+	if (!rc)
+		vcpu->guest_debug &= ~KVM_GUESTDBG_EXIT_PENDING;
+
+	return rc;
 }
 
 static int kvm_s390_handle_pv_vcpu_dump(struct kvm_vcpu *vcpu,
-- 
2.41.0

