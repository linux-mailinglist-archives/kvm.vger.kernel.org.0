Return-Path: <kvm+bounces-31630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 10C7C9C5D1F
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 17:26:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC4CA1F2574E
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 16:26:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00518205ADB;
	Tue, 12 Nov 2024 16:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZZf+hXhV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B852205AA3;
	Tue, 12 Nov 2024 16:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731428776; cv=none; b=P7FgxJEDpgPKSSi4CmaaOKONAcu4LJUuNL/1hAEMfrLF0j1PWvdIBcy/x3K5NXR4NLahYZuhkvmijoyZjBN1IG6esiWIY/k13MRrqxjlyjsAGdMCdhkBUmbj4ADkKev0+QXNHY89in+4CaA3OiktREqQ60dhV/KZgI3+H7yjWy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731428776; c=relaxed/simple;
	bh=5JsXBf7Vz2wI/bTAjubtLJeTnYSTop/4LZPAXzjf9YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npGzxsgcn9B0fooc4qImfDtixZKrfOx5FjIk4IEd7nJ5o+AkdTF9aMWwboM9CSISz87HDCSywlOrQU+Qw28+R7cXcQX/XbyFE9+H+caOuALHfrKOBD7vdEXVROyI0tvqjWbX2+MphlB2tga2pFZQWQlBREx1OJ9SqgkdTdQcNxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZZf+hXhV; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACEf42a008556;
	Tue, 12 Nov 2024 16:26:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Mq9uGMq7UyhvHwtIu
	sYhuzwlK8ftq52DbUMaJtSq1O8=; b=ZZf+hXhVO7BPHxi+Nrh2EKiColVeP7uBc
	hGPaR8Cfux+l0ZbNAeCYsuDHxRzzQXflrN6Hi3Zd2+/f5ATiN7/Mg1PeSI+86Q3H
	o0SjplrAHHWD6YpRX3Uh0gGDatrPjPftytukao/oZT0ONzA19SPlXPjNtY1/BTsl
	+QbrCTJQxCrm6rBWzpZJp2c4DE5scOHB+6llLun5Ac+K6QIJhODCxtrCt4U4eBug
	iWGGHjDiy1yRaUaErXNg4+AZEBnAhC3UDD7GsAq28pjk2wtw91SGb7/776fB8mqu
	7PdEc8sWVYDXJqicURS8y3OlpiU87wqLNfP+Uy4+s3FNyFLBVn68A==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42v9020g1t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:11 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AC7B4TY006674;
	Tue, 12 Nov 2024 16:26:11 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42tm9jcen8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:10 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4ACGQ7TW33161742
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:26:07 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 43A3F20040;
	Tue, 12 Nov 2024 16:26:07 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C422C2004B;
	Tue, 12 Nov 2024 16:26:06 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.179.25.251])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 12 Nov 2024 16:26:06 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        Hariharan Mari <hari55@linux.ibm.com>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [GIT PULL 02/14] KVM: s390: selftests: Add regression tests for PRNO, KDSA and KMA crypto subfunctions
Date: Tue, 12 Nov 2024 17:23:16 +0100
Message-ID: <20241112162536.144980-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112162536.144980-1-frankja@linux.ibm.com>
References: <20241112162536.144980-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lOpLtQe-7H5Hm_ma_ZJPsVCaDJIYt3Ph
X-Proofpoint-GUID: lOpLtQe-7H5Hm_ma_ZJPsVCaDJIYt3Ph
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
to include tests for the PRNO (Perform Random Number Operation), KDSA
(Compute Digital Signature Authentication) and KMA (Cipher Message with
Authentication) crypto functions.

The test procedure follows the established pattern:

1. Obtain KVM_S390_VM_CPU_MACHINE_SUBFUNC attribute for the VM.
2. Execute PRNO, KDSA and KMA instructions.
3. Compare KVM-reported results with direct instruction execution results.

Suggested-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Hariharan Mari <hari55@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Link: https://lore.kernel.org/r/20240823130947.38323-3-hari55@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20240823130947.38323-3-hari55@linux.ibm.com>
---
 .../kvm/s390x/cpumodel_subfuncs_test.c        | 39 +++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c b/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c
index ee525c841767..96e7ca07220f 100644
--- a/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c
+++ b/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c
@@ -33,6 +33,39 @@ static void get_cpu_machine_subfuntions(struct kvm_vm *vm,
 	TEST_ASSERT(!r, "Get cpu subfunctions failed r=%d errno=%d", r, errno);
 }
 
+/* Testing Crypto Perform Random Number Operation (PRNO) CPU subfunction's ASM block */
+static void test_prno_asm_block(u8 (*query)[16])
+{
+	asm volatile("	la	%%r1,%[query]\n"
+			"	xgr	%%r0,%%r0\n"
+			"	.insn	rre,0xb93c0000,2,4\n"
+			: [query] "=R" (*query)
+			:
+			: "cc", "r0", "r1");
+}
+
+/* Testing Crypto Cipher Message with Authentication (KMA) CPU subfunction's ASM block */
+static void test_kma_asm_block(u8 (*query)[16])
+{
+	asm volatile("	la	%%r1,%[query]\n"
+			"	xgr	%%r0,%%r0\n"
+			"	.insn	rrf,0xb9290000,2,4,6,0\n"
+			: [query] "=R" (*query)
+			:
+			: "cc", "r0", "r1");
+}
+
+/* Testing Crypto Compute Digital Signature Authentication (KDSA) CPU subfunction's ASM block */
+static void test_kdsa_asm_block(u8 (*query)[16])
+{
+	asm volatile("	la	%%r1,%[query]\n"
+			"	xgr	%%r0,%%r0\n"
+			"	.insn	rre,0xb93a0000,0,2\n"
+			: [query] "=R" (*query)
+			:
+			: "cc", "r0", "r1");
+}
+
 /* Testing Sort Lists (SORTL) CPU subfunction's ASM block */
 static void test_sortl_asm_block(u8 (*query)[32])
 {
@@ -64,6 +97,12 @@ struct testdef {
 	testfunc_t test;
 	int facility_bit;
 } testlist[] = {
+	/* MSA5 - Facility bit 57 */
+	{ "PPNO", cpu_subfunc.ppno, sizeof(cpu_subfunc.ppno), test_prno_asm_block, 57 },
+	/* MSA8 - Facility bit 146 */
+	{ "KMA", cpu_subfunc.kma, sizeof(cpu_subfunc.kma), test_kma_asm_block, 146 },
+	/* MSA9 - Facility bit 155 */
+	{ "KDSA", cpu_subfunc.kdsa, sizeof(cpu_subfunc.kdsa), test_kdsa_asm_block, 155 },
 	/* SORTL - Facility bit 150 */
 	{ "SORTL", cpu_subfunc.sortl, sizeof(cpu_subfunc.sortl), test_sortl_asm_block, 150 },
 	/* DFLTCC - Facility bit 151 */
-- 
2.47.0


