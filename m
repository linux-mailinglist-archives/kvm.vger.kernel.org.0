Return-Path: <kvm+bounces-31133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24C789C0A03
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 16:24:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCFDD28132B
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 15:24:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48163214431;
	Thu,  7 Nov 2024 15:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XcndR4Wh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15729212F08;
	Thu,  7 Nov 2024 15:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730993022; cv=none; b=nKwTbcVyHSfIiDUqgA9Qe2oC5vebn41gED7/2Uf1csZG9mAxZ79qaDDkYJJ5xpBUk0ESr1IZpEuuIytueafWYnb3IMSmi1sAjPllASjI4Op/+JG2zG2RALQkEwm9mZZKbuz2p1EiMsBjh/QKCkxSiBua+3chiIZtCc6RHG5jTe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730993022; c=relaxed/simple;
	bh=q7r113h8V27m9wIjZYJBUSQrGnWgrXFlDKCfyRLutmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzqKxRATCw9AC85RBhsWoYZLy+A58w9dRRhK2IBo2dpKGGfSuSiQq9lItojiKqq49GsunhKoKviSfHEq3NcJM0c3RUaoSzoiLCU1rsG7aJT8u6cN0N398tF9qTzCfDRbmh8HJlROf8MwTfPezOWB13BgOGrCw+3p6WloRNLFqXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XcndR4Wh; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A7EeB54027536;
	Thu, 7 Nov 2024 15:23:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=xJomWUTv1MPMrre1/
	tUDz0SI3tdQkeweYB39erzEUSg=; b=XcndR4Whh0z4ikgTRlOH/DefBrVtEfKHg
	Hq3OiV7/Ex2aRO232otCXzOntGUBCn8um/SYxGFk5nlf3QMYmVj49EKJuv5vYY1n
	91Zy4GZmk3QiytjoCY/Z902e89fhdCHbzbXZ7eljrthyKAi0tFH4MjL9vOWrQePS
	yGUMI4/YDWygOAOd0PvE6IVzojdnx+rqtTVHJozQK+A5tVkzQTwEmbt6iT+0JLkn
	00KOXboXrlvTjBhHzB/HlO6pVDXg9fVbEaZI4eQ09PinX6YVqmEM0mDkAjHX+UpW
	74PGOOHs+PcGKh9qLKmyG2cBBWVvrcVDLASOdV8o9rMq/FtsG7ilQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42rygs883j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Nov 2024 15:23:38 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4A76q8IM024314;
	Thu, 7 Nov 2024 15:23:37 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42p0mj8b48-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Nov 2024 15:23:37 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4A7FNX8E45089258
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 Nov 2024 15:23:34 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D80C020040;
	Thu,  7 Nov 2024 15:23:33 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AA7A120049;
	Thu,  7 Nov 2024 15:23:33 +0000 (GMT)
Received: from vela.boeblingen.de.ibm.com (unknown [9.155.210.79])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 Nov 2024 15:23:33 +0000 (GMT)
From: Hendrik Brueckner <brueckner@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH 4/4] KVM: s390: selftests: Add regression tests for PFCR subfunctions
Date: Thu,  7 Nov 2024 16:23:19 +0100
Message-ID: <20241107152319.77816-5-brueckner@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 7iskTDdG9lmVnW-WWL2xJynXihGDjpnP
X-Proofpoint-GUID: 7iskTDdG9lmVnW-WWL2xJynXihGDjpnP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=892 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2409260000 definitions=main-2411070114

Signed-off-by: Hendrik Brueckner <brueckner@linux.ibm.com>
Reviewed-by: Hariharan Mari <hari55@linux.ibm.com>
---
 tools/arch/s390/include/uapi/asm/kvm.h            |  3 ++-
 .../selftests/kvm/s390x/cpumodel_subfuncs_test.c  | 15 +++++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/arch/s390/include/uapi/asm/kvm.h b/tools/arch/s390/include/uapi/asm/kvm.h
index 05eaf6db3ad4..60345dd2cba2 100644
--- a/tools/arch/s390/include/uapi/asm/kvm.h
+++ b/tools/arch/s390/include/uapi/asm/kvm.h
@@ -469,7 +469,8 @@ struct kvm_s390_vm_cpu_subfunc {
 	__u8 kdsa[16];		/* with MSA9 */
 	__u8 sortl[32];		/* with STFLE.150 */
 	__u8 dfltcc[32];	/* with STFLE.151 */
-	__u8 reserved[1728];
+	__u8 pfcr[16];		/* with STFLE.201 */
+	__u8 reserved[1712];
 };
 
 #define KVM_S390_VM_CPU_PROCESSOR_UV_FEAT_GUEST	6
diff --git a/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c b/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c
index 222ba1cc3cac..27255880dabd 100644
--- a/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c
+++ b/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c
@@ -214,6 +214,19 @@ static void test_dfltcc_asm_block(u8 (*query)[32])
 			: "cc", "0", "1");
 }
 
+/*
+ * Testing Perform Function with Concurrent Results (PFCR)
+ * CPU subfunctions's ASM block
+ */
+static void test_pfcr_asm_block(u8 (*query)[16])
+{
+	asm volatile("	lghi	0,0\n"
+			"	.insn   rsy,0xeb0000000016,0,0,%[query]\n"
+			: [query] "=QS" (*query)
+			:
+			: "cc", "0");
+}
+
 typedef void (*testfunc_t)(u8 (*array)[]);
 
 struct testdef {
@@ -249,6 +262,8 @@ struct testdef {
 	{ "SORTL", cpu_subfunc.sortl, sizeof(cpu_subfunc.sortl), test_sortl_asm_block, 150 },
 	/* DFLTCC - Facility bit 151 */
 	{ "DFLTCC", cpu_subfunc.dfltcc, sizeof(cpu_subfunc.dfltcc), test_dfltcc_asm_block, 151 },
+	/* Concurrent-function facility - Facility bit 201 */
+	{ "PFCR", cpu_subfunc.pfcr, sizeof(cpu_subfunc.pfcr), test_pfcr_asm_block, 201 },
 };
 
 int main(int argc, char *argv[])
-- 
2.43.5


