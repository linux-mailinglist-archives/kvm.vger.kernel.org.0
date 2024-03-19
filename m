Return-Path: <kvm+bounces-12166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3A6D8802A4
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 17:45:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 010F5B21481
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 16:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FDD61119F;
	Tue, 19 Mar 2024 16:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="n5/tiXiJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142DF20335;
	Tue, 19 Mar 2024 16:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710866684; cv=none; b=ABy8lY5fI9hrAwtD51o9SaehcEhcGOv+mC6NyaGQv8vClAzzeT58fJ8KDz5wcrsGAvZYDOiu4jw2H03yH+7bl81RXdLhBYtl772fDy6cbdNR2RT+M/bM5krahxtIHPJhosuUVsr/IN4ZmuWLgKtH2XVZOv9nzTseBJ9mH6o6Xy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710866684; c=relaxed/simple;
	bh=ejcM0ObSToPI7WLk0jkl4FVWAg5m042EZfW6vUVW8D4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p8ARgOMRGfzDaRlg0iUrNsK+RY4vuIhIWzHNmHDYLlmrH6XHvJ5dQtdbaRay1gO7GFu58ubjd2aMgvdnmNzeJ3xXPK4Armcnd5Y1jeD5QXkg1S7mNAgpq4r8V66IH2nOn6ehhbuEsMfwSLciBZVq/Juucw4z5crFlf7iHPCySRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=n5/tiXiJ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42JGKU49025849;
	Tue, 19 Mar 2024 16:44:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WMAPBLZy08rXmUup1BZw0W8tC+s2U+i1xs9vAkTYDko=;
 b=n5/tiXiJLRAKThedAZwJaMNQqQzzLr3LJt+XjLmLKRBFcX36Qj1aeF9VumePiY0/kbxy
 bv94dlYX8PrSaIkqFqB9h+plqpv9/bF3qTtG15HEsKUNMITjmmJTCnaP4f4Kl0zWvnrn
 RzAMqDizPUE6/1FcsBioiNv2KHgKjA6zqzWZWKweCnzP2e5FmuFt3s1HZgwglPqLu5XP
 9Dl2Z5iAtdxtKt0RkpRuKf40I0OphXitlrmO60krWFsn1btdvK+SgnQghAnfu/7S5l5N
 aYvZDWLitvY9ERZj2yOSSnaoFvNvLvcRNv1CbiJZYrOI/GXqBscgf6ZVoxbiQJ06DplV JA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wyd2kr7c7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Mar 2024 16:44:39 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42JGeJq0030172;
	Tue, 19 Mar 2024 16:44:39 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wyd2kr7c4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Mar 2024 16:44:39 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42JFd2Bd017190;
	Tue, 19 Mar 2024 16:44:38 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wwnrt92qm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Mar 2024 16:44:38 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42JGiWgs45154782
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Mar 2024 16:44:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD80420043;
	Tue, 19 Mar 2024 16:44:32 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 95E4720040;
	Tue, 19 Mar 2024 16:44:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 Mar 2024 16:44:32 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH RESEND 1/2] KVM: s390: Minor refactor of base/ext facility lists
Date: Tue, 19 Mar 2024 17:44:19 +0100
Message-Id: <20240319164420.4053380-2-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240319164420.4053380-1-nsg@linux.ibm.com>
References: <20240319164420.4053380-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: C0oxsBW0_3WChy9qSf9HW5hxwuEhiX54
X-Proofpoint-ORIG-GUID: -gUm1WhTRhNXIe4Mp7NyODoJlKKnwtlf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-19_06,2024-03-18_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 priorityscore=1501
 clxscore=1011 spamscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403140000 definitions=main-2403190126

Directly use the size of the arrays instead of going through the
indirection of kvm_s390_fac_size().
Don't use magic number for the number of entries in the non hypervisor
managed facility bit mask list.
Make the constraint of that number on kvm_s390_fac_base obvious.
Get rid of implicit double anding of stfle_fac_list.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---

Notes:
    I think it's nicer this way but it might be needless churn.

 arch/s390/kvm/kvm-s390.c | 44 +++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index ea63ac769889..0882e0f02cde 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -224,33 +224,25 @@ static int async_destroy = 1;
 module_param(async_destroy, int, 0444);
 MODULE_PARM_DESC(async_destroy, "Asynchronous destroy for protected guests");
 
-/*
- * For now we handle at most 16 double words as this is what the s390 base
- * kernel handles and stores in the prefix page. If we ever need to go beyond
- * this, this requires changes to code, but the external uapi can stay.
- */
-#define SIZE_INTERNAL 16
-
+#define HMFAI_DWORDS 16
 /*
  * Base feature mask that defines default mask for facilities. Consists of the
  * defines in FACILITIES_KVM and the non-hypervisor managed bits.
  */
-static unsigned long kvm_s390_fac_base[SIZE_INTERNAL] = { FACILITIES_KVM };
+static unsigned long kvm_s390_fac_base[HMFAI_DWORDS] = { FACILITIES_KVM };
+static_assert(ARRAY_SIZE(((long[]){ FACILITIES_KVM })) <= HMFAI_DWORDS);
+static_assert(ARRAY_SIZE(kvm_s390_fac_base) <= S390_ARCH_FAC_MASK_SIZE_U64);
+static_assert(ARRAY_SIZE(kvm_s390_fac_base) <= S390_ARCH_FAC_LIST_SIZE_U64);
+static_assert(ARRAY_SIZE(kvm_s390_fac_base) <= ARRAY_SIZE(stfle_fac_list));
+
 /*
  * Extended feature mask. Consists of the defines in FACILITIES_KVM_CPUMODEL
  * and defines the facilities that can be enabled via a cpu model.
  */
-static unsigned long kvm_s390_fac_ext[SIZE_INTERNAL] = { FACILITIES_KVM_CPUMODEL };
-
-static unsigned long kvm_s390_fac_size(void)
-{
-	BUILD_BUG_ON(SIZE_INTERNAL > S390_ARCH_FAC_MASK_SIZE_U64);
-	BUILD_BUG_ON(SIZE_INTERNAL > S390_ARCH_FAC_LIST_SIZE_U64);
-	BUILD_BUG_ON(SIZE_INTERNAL * sizeof(unsigned long) >
-		sizeof(stfle_fac_list));
-
-	return SIZE_INTERNAL;
-}
+static const unsigned long kvm_s390_fac_ext[] = { FACILITIES_KVM_CPUMODEL };
+static_assert(ARRAY_SIZE(kvm_s390_fac_ext) <= S390_ARCH_FAC_MASK_SIZE_U64);
+static_assert(ARRAY_SIZE(kvm_s390_fac_ext) <= S390_ARCH_FAC_LIST_SIZE_U64);
+static_assert(ARRAY_SIZE(kvm_s390_fac_ext) <= ARRAY_SIZE(stfle_fac_list));
 
 /* available cpu features supported by kvm */
 static DECLARE_BITMAP(kvm_s390_available_cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
@@ -3347,13 +3339,16 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.sie_page2->kvm = kvm;
 	kvm->arch.model.fac_list = kvm->arch.sie_page2->fac_list;
 
-	for (i = 0; i < kvm_s390_fac_size(); i++) {
+	for (i = 0; i < ARRAY_SIZE(kvm_s390_fac_base); i++) {
 		kvm->arch.model.fac_mask[i] = stfle_fac_list[i] &
-					      (kvm_s390_fac_base[i] |
-					       kvm_s390_fac_ext[i]);
+					      kvm_s390_fac_base[i];
 		kvm->arch.model.fac_list[i] = stfle_fac_list[i] &
 					      kvm_s390_fac_base[i];
 	}
+	for (i = 0; i < ARRAY_SIZE(kvm_s390_fac_ext); i++) {
+		kvm->arch.model.fac_mask[i] |= stfle_fac_list[i] &
+					       kvm_s390_fac_ext[i];
+	}
 	kvm->arch.model.subfuncs = kvm_s390_available_subfunc;
 
 	/* we are always in czam mode - even on pre z14 machines */
@@ -5857,9 +5852,8 @@ static int __init kvm_s390_init(void)
 		return -EINVAL;
 	}
 
-	for (i = 0; i < 16; i++)
-		kvm_s390_fac_base[i] |=
-			stfle_fac_list[i] & nonhyp_mask(i);
+	for (i = 0; i < HMFAI_DWORDS; i++)
+		kvm_s390_fac_base[i] |= nonhyp_mask(i);
 
 	r = __kvm_s390_init();
 	if (r)
-- 
2.40.1


