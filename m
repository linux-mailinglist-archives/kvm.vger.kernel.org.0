Return-Path: <kvm+bounces-31134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 071E09C0A06
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 16:24:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A889B22A04
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 15:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A0FA213152;
	Thu,  7 Nov 2024 15:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UK/xibtM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266C22139D3;
	Thu,  7 Nov 2024 15:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730993023; cv=none; b=Q5aduwriBjZ/qqy42FdBAWFWw2ZHRvomQTnEcnZYHq6/YYapZ1RgrYiDZekNKu+ngKeO0AiTjn1bhtOF7wPwDKzKKEVxXvHF7Dicn5fekntP/MJoY5uqKuUsrj4zVnlRrSe8YlONa8iAvMf7F3Xccnlr56nglpetNnnb+UYylOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730993023; c=relaxed/simple;
	bh=kpFZRJEAe8iAGoQAb7BnMMqtjyylyhgY5ibqYfw3JwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acnljIjWKkdkRq4WgNBNQKHYHdbe06XtiS17NTW9ylMwc2EDoVb6kqq2kahSE5DJvvi4UnxB6/ZLj2HKE9PLxbQDgZe/qnjGNVVOa2s+JzbybfQEJ+QysK7qd3+cDOkopMANrcPcVJNFryPnhGc4qKC8OcR7t9hW8YDQ0XyY9y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UK/xibtM; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A7EeIR1027775;
	Thu, 7 Nov 2024 15:23:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=mCGvaOKuIYvTaUIfJ
	3g+A8nj3e4nN0QlTM2wtE0B17s=; b=UK/xibtMRXSgbzLkyYAnuRisVqED2po7P
	qFUrlYHg7Co15A3zOLZR2mgsnEJ8XtmC/66xXgd33X9FFPT3WSY6V6nVMAsfX2Uy
	qTUmY2za4+Es9dt8F7JObZYGpUJiAQFxmMTtrEbw7MbEiItsIfAXUM4uMbTZooSM
	VflYQFHC4aqfZwWbxhUweu4faKpOn9aKEjb8EnnlDiSTJhJ3lSTC7a5HcBbatcHd
	eN3bUh2abtrMnBPnzV+H/zkcpkr0KE0Ophfi7ErDD45cRoYhLEyNzyREI14VKryT
	3AKXyMkWo2lW/BO62xNptSDsKz/cWHU+lylVVG2K2H2RA6D4mhRow==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42rygs883h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Nov 2024 15:23:38 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4A7BxNlV031966;
	Thu, 7 Nov 2024 15:23:37 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42nydmree7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Nov 2024 15:23:37 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4A7FNXpX45089252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 Nov 2024 15:23:33 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 35F4C20040;
	Thu,  7 Nov 2024 15:23:33 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 06BAA2004B;
	Thu,  7 Nov 2024 15:23:33 +0000 (GMT)
Received: from vela.boeblingen.de.ibm.com (unknown [9.155.210.79])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 Nov 2024 15:23:32 +0000 (GMT)
From: Hendrik Brueckner <brueckner@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH 1/4] KVM: s390: add concurrent-function facility to cpu model
Date: Thu,  7 Nov 2024 16:23:16 +0100
Message-ID: <20241107152319.77816-2-brueckner@linux.ibm.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241107152319.77816-1-brueckner@linux.ibm.com>
References: <20241107152319.77816-1-brueckner@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PVSScK_8VEVTA8cDCrvdzoq02bFtGPAC
X-Proofpoint-GUID: PVSScK_8VEVTA8cDCrvdzoq02bFtGPAC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=555 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2409260000 definitions=main-2411070114

Adding support for concurrent-functions facility which provides
additional subfunctions.

Signed-off-by: Hendrik Brueckner <brueckner@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/include/uapi/asm/kvm.h |  3 ++-
 arch/s390/kvm/kvm-s390.c         | 22 ++++++++++++++++++++++
 arch/s390/tools/gen_facilities.c |  1 +
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
index 05eaf6db3ad4..60345dd2cba2 100644
--- a/arch/s390/include/uapi/asm/kvm.h
+++ b/arch/s390/include/uapi/asm/kvm.h
@@ -469,7 +469,8 @@ struct kvm_s390_vm_cpu_subfunc {
 	__u8 kdsa[16];		/* with MSA9 */
 	__u8 sortl[32];		/* with STFLE.150 */
 	__u8 dfltcc[32];	/* with STFLE.151 */
-	__u8 reserved[1728];
+	__u8 pfcr[16];		/* with STFLE.201 */
+	__u8 reserved[1712];
 };
 
 #define KVM_S390_VM_CPU_PROCESSOR_UV_FEAT_GUEST	6
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 06e55f681a39..f9cc1c92a79d 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -348,6 +348,16 @@ static inline int plo_test_bit(unsigned char nr)
 	return cc == 0;
 }
 
+static __always_inline void pfcr_query(u8 (*query)[16])
+{
+	asm volatile(
+		"	lghi	0,0\n"
+		"	.insn   rsy,0xeb0000000016,0,0,%[query]\n"
+		: [query] "=QS" (*query)
+		:
+		: "cc", "0");
+}
+
 static __always_inline void __sortl_query(u8 (*query)[32])
 {
 	asm volatile(
@@ -429,6 +439,9 @@ static void __init kvm_s390_cpu_feat_init(void)
 	if (test_facility(151)) /* DFLTCC */
 		__dfltcc_query(&kvm_s390_available_subfunc.dfltcc);
 
+	if (test_facility(201))	/* PFCR */
+		pfcr_query(&kvm_s390_available_subfunc.pfcr);
+
 	if (MACHINE_HAS_ESOP)
 		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_ESOP);
 	/*
@@ -1543,6 +1556,9 @@ static int kvm_s390_set_processor_subfunc(struct kvm *kvm,
 		 ((unsigned long *) &kvm->arch.model.subfuncs.dfltcc)[1],
 		 ((unsigned long *) &kvm->arch.model.subfuncs.dfltcc)[2],
 		 ((unsigned long *) &kvm->arch.model.subfuncs.dfltcc)[3]);
+	VM_EVENT(kvm, 3, "GET: guest PFCR   subfunc 0x%16.16lx.%16.16lx",
+		 ((unsigned long *) &kvm_s390_available_subfunc.pfcr)[0],
+		 ((unsigned long *) &kvm_s390_available_subfunc.pfcr)[1]);
 
 	return 0;
 }
@@ -1757,6 +1773,9 @@ static int kvm_s390_get_processor_subfunc(struct kvm *kvm,
 		 ((unsigned long *) &kvm->arch.model.subfuncs.dfltcc)[1],
 		 ((unsigned long *) &kvm->arch.model.subfuncs.dfltcc)[2],
 		 ((unsigned long *) &kvm->arch.model.subfuncs.dfltcc)[3]);
+	VM_EVENT(kvm, 3, "GET: guest PFCR   subfunc 0x%16.16lx.%16.16lx",
+		 ((unsigned long *) &kvm_s390_available_subfunc.pfcr)[0],
+		 ((unsigned long *) &kvm_s390_available_subfunc.pfcr)[1]);
 
 	return 0;
 }
@@ -1825,6 +1844,9 @@ static int kvm_s390_get_machine_subfunc(struct kvm *kvm,
 		 ((unsigned long *) &kvm_s390_available_subfunc.dfltcc)[1],
 		 ((unsigned long *) &kvm_s390_available_subfunc.dfltcc)[2],
 		 ((unsigned long *) &kvm_s390_available_subfunc.dfltcc)[3]);
+	VM_EVENT(kvm, 3, "GET: host  PFCR   subfunc 0x%16.16lx.%16.16lx",
+		 ((unsigned long *) &kvm_s390_available_subfunc.pfcr)[0],
+		 ((unsigned long *) &kvm_s390_available_subfunc.pfcr)[1]);
 
 	return 0;
 }
diff --git a/arch/s390/tools/gen_facilities.c b/arch/s390/tools/gen_facilities.c
index c3d5214c8442..e97b4faaf222 100644
--- a/arch/s390/tools/gen_facilities.c
+++ b/arch/s390/tools/gen_facilities.c
@@ -116,6 +116,7 @@ static struct facility_def facility_defs[] = {
 			194, /* rdp enhancement facility */
 			196, /* processor activity instrumentation facility */
 			197, /* processor activity instrumentation extension 1 */
+			201, /* concurrent-functions facility */
 			-1  /* END */
 		}
 	},
-- 
2.43.5


