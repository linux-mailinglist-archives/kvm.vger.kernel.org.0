Return-Path: <kvm+bounces-31639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD81C9C5D30
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 17:27:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A62B1F2572B
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 16:27:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EEEE206E76;
	Tue, 12 Nov 2024 16:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RPk94e/h"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5F820695B;
	Tue, 12 Nov 2024 16:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731428782; cv=none; b=VNMBPl4hPmd7nCx3PMbnHFe3rlehv0K4xuqbLBJhBeh3/hF2e51CrnEXJI5F1myiFWH7gux6adtzrno0OEOj8wyPGknpuq2sTwEt7ny1cGuJcfJ9/rWOXZVaXMBplKkyCMnETgDag0tQG4+9oZkJlVOULu0UpjfHfy997HphWVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731428782; c=relaxed/simple;
	bh=klC6CgZUvC72M9K9UTHccsNZuPgdrJwij7ZHSE6D2kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZAiQUFjVR+bLTHJueLs52Dse8PN8yTl+3oDus8uVN0tnoDT4v2dOHsH6w1gCDV/nvrRWr7nYTxbvSPUinz3gjpnc6ner9VhnwgdccH3dTt7+Nz6sznADATLO89ax/EZ1Uch8ft+ibGSHtUInqfwYjpGqzPrvqTh2BycKZsk4Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RPk94e/h; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACEfEQX008736;
	Tue, 12 Nov 2024 16:26:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=2CMys+O6bsSvd+EjS
	fgirWq6P5mEKjyezKFMbMb9B6A=; b=RPk94e/hH6eBSIIpvNWj/WUH+got/0bVe
	PLwv2kQgjVXW5XERX02A5kDMMPyXd5Z01oMTicQEGrapivbOv5F+8fPLrfoexokY
	iTfCC5jFhLPdeC+MKpV9qSB5u2jt0UdSd9zlDubHsw++nXGAyx9elncYEw3S2c+M
	T51TYUlnhMYRcWWZrIYtyOn+7wl8X+bKxVnLysQ0GPdO7pOy8ym0M4EyJc9ba6Gm
	NVRuddW/csN10fzAx5QPyTWN1E9K3ZYgOtszGHuGvLLP0/At4EoL3Yqhp7pFzwY/
	Wip4UBKxkBXgfcJuDK79uvScMCpY3Es1BcLWAbaCYkrgRAe/+Odew==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42v9020g1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:14 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AC63bku007703;
	Tue, 12 Nov 2024 16:26:13 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42tm9jcena-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:11 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4ACGQ8xW33489206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:26:08 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4F59620040;
	Tue, 12 Nov 2024 16:26:08 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D47D32004B;
	Tue, 12 Nov 2024 16:26:07 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.179.25.251])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 12 Nov 2024 16:26:07 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        Hariharan Mari <hari55@linux.ibm.com>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [GIT PULL 04/14] KVM: s390: selftests: Add regression tests for KMAC, KMC, KM, KIMD and KLMD crypto subfunctions
Date: Tue, 12 Nov 2024 17:23:18 +0100
Message-ID: <20241112162536.144980-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112162536.144980-1-frankja@linux.ibm.com>
References: <20241112162536.144980-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wZBhVrJt4enyJB13HCo0MPwxuM1wuAeg
X-Proofpoint-GUID: wZBhVrJt4enyJB13HCo0MPwxuM1wuAeg
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411120128

From: Hariharan Mari <hari55@linux.ibm.com>

Extend the existing regression test framework for s390x CPU subfunctions
to include tests for the KMAC (Compute Message Authentication Code),
KMC (Cipher Message with Chaining), KM (Cipher Message) KIMD (Compute
Intermediate Message Digest) and KLMD (Compute Last Message Digest)
crypto functions.

The test procedure follows the established pattern.

Suggested-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Hariharan Mari <hari55@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Link: https://lore.kernel.org/r/20240823130947.38323-5-hari55@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20240823130947.38323-5-hari55@linux.ibm.com>
---
 .../kvm/s390x/cpumodel_subfuncs_test.c        | 61 +++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c b/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c
index 28faceeaf089..fe45fb131583 100644
--- a/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c
+++ b/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c
@@ -33,6 +33,61 @@ static void get_cpu_machine_subfuntions(struct kvm_vm *vm,
 	TEST_ASSERT(!r, "Get cpu subfunctions failed r=%d errno=%d", r, errno);
 }
 
+/* Testing Crypto Compute Message Authentication Code (KMAC) CPU subfunction's ASM block */
+static void test_kmac_asm_block(u8 (*query)[16])
+{
+	asm volatile("	la	%%r1,%[query]\n"
+			"	xgr	%%r0,%%r0\n"
+			"	.insn	rre,0xb91e0000,0,2\n"
+			: [query] "=R" (*query)
+			:
+			: "cc", "r0", "r1");
+}
+
+/* Testing Crypto Cipher Message with Chaining (KMC) CPU subfunction's ASM block */
+static void test_kmc_asm_block(u8 (*query)[16])
+{
+	asm volatile("	la	%%r1,%[query]\n"
+			"	xgr	%%r0,%%r0\n"
+			"	.insn	rre,0xb92f0000,2,4\n"
+			: [query] "=R" (*query)
+			:
+			: "cc", "r0", "r1");
+}
+
+/* Testing Crypto Cipher Message (KM) CPU subfunction's ASM block */
+static void test_km_asm_block(u8 (*query)[16])
+{
+	asm volatile("	la	%%r1,%[query]\n"
+			"	xgr	%%r0,%%r0\n"
+			"	.insn	rre,0xb92e0000,2,4\n"
+			: [query] "=R" (*query)
+			:
+			: "cc", "r0", "r1");
+}
+
+/* Testing Crypto Compute Intermediate Message Digest (KIMD) CPU subfunction's ASM block */
+static void test_kimd_asm_block(u8 (*query)[16])
+{
+	asm volatile("	la	%%r1,%[query]\n"
+			"	xgr	%%r0,%%r0\n"
+			"	.insn	rre,0xb93e0000,0,2\n"
+			: [query] "=R" (*query)
+			:
+			: "cc", "r0", "r1");
+}
+
+/* Testing Crypto Compute Last Message Digest (KLMD) CPU subfunction's ASM block */
+static void test_klmd_asm_block(u8 (*query)[16])
+{
+	asm volatile("	la	%%r1,%[query]\n"
+			"	xgr	%%r0,%%r0\n"
+			"	.insn	rre,0xb93f0000,0,2\n"
+			: [query] "=R" (*query)
+			:
+			: "cc", "r0", "r1");
+}
+
 /* Testing Crypto Cipher Message with Counter (KMCTR) CPU subfunction's ASM block */
 static void test_kmctr_asm_block(u8 (*query)[16])
 {
@@ -141,6 +196,12 @@ struct testdef {
 	testfunc_t test;
 	int facility_bit;
 } testlist[] = {
+	/* MSA - Facility bit 17 */
+	{ "KMAC", cpu_subfunc.kmac, sizeof(cpu_subfunc.kmac), test_kmac_asm_block, 17 },
+	{ "KMC", cpu_subfunc.kmc, sizeof(cpu_subfunc.kmc), test_kmc_asm_block, 17 },
+	{ "KM", cpu_subfunc.km, sizeof(cpu_subfunc.km), test_km_asm_block, 17 },
+	{ "KIMD", cpu_subfunc.kimd, sizeof(cpu_subfunc.kimd), test_kimd_asm_block, 17 },
+	{ "KLMD", cpu_subfunc.klmd, sizeof(cpu_subfunc.klmd), test_klmd_asm_block, 17 },
 	/* MSA - Facility bit 77 */
 	{ "KMCTR", cpu_subfunc.kmctr, sizeof(cpu_subfunc.kmctr), test_kmctr_asm_block, 77 },
 	{ "KMF", cpu_subfunc.kmf, sizeof(cpu_subfunc.kmf), test_kmf_asm_block, 77 },
-- 
2.47.0


