Return-Path: <kvm+bounces-4816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EDCF81896C
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 15:10:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77EAE1F24DA3
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 14:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FC5C1D53C;
	Tue, 19 Dec 2023 14:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kKJeB3Ht"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16901CAAE;
	Tue, 19 Dec 2023 14:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJCRSSp028082;
	Tue, 19 Dec 2023 14:09:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6QFhjOxADw8oxhqs1NGsWposBeC0e3ZC1JVOPpN+qPY=;
 b=kKJeB3Ht3GW7UJ+U+kAq+GhXuDAymWJDzpxf0ARjA1EbjfPRIB/a2qpgDLLzTZf6LBo5
 e5gK/HHlmodsXWxxe8wKatOkkBZCZMMHf0dqEvAlG6PZSZSTN4/AmDyw2M2SJxZjxCOz
 pYPEdCGEEe2nV7r3L8BTFx+B6XMxFZZUItMSjq1zlClZNySFVRXtw4DmsEOtcEFJFi+4
 waOz/a+GDUgjPEIaPSbxe/Rk8XI79vcs+yI5T9y8vtXsMhj183KRucJRhCeybOQPyfzR
 772RZXVI6Xa7rjnv8FQSS6+gfqM6STvA4O1vkU8U0Xug1/vQdZeDtkI6re5HsC9SldF+ 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v3b6r2kvg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 14:09:01 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BJDqGdj019960;
	Tue, 19 Dec 2023 14:09:01 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v3b6r2kuv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 14:09:01 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJCtZYx004797;
	Tue, 19 Dec 2023 14:08:59 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3v1pkyr9cx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 14:08:59 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BJE8uim59113970
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 14:08:56 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C14512004B;
	Tue, 19 Dec 2023 14:08:56 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8600720040;
	Tue, 19 Dec 2023 14:08:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 Dec 2023 14:08:56 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>, linux-s390@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v4 4/4] KVM: s390: Minor refactor of base/ext facility lists
Date: Tue, 19 Dec 2023 15:08:53 +0100
Message-Id: <20231219140854.1042599-5-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231219140854.1042599-1-nsg@linux.ibm.com>
References: <20231219140854.1042599-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Y94m9_wMZ9ZeChafezNsbSD1z0tpkSGM
X-Proofpoint-ORIG-GUID: yiqJi11fctYRkMgNX-CyM_AVhav685l9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-19_08,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 clxscore=1015 malwarescore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312190105

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
index 7aa0e668488f..ac8d551f8b32 100644
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
@@ -3348,13 +3340,16 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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
@@ -5868,9 +5863,8 @@ static int __init kvm_s390_init(void)
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


