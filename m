Return-Path: <kvm+bounces-31632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CA6C9C5D21
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 17:26:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCC791F257A8
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 16:26:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79374206055;
	Tue, 12 Nov 2024 16:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qS067/24"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1081120515D;
	Tue, 12 Nov 2024 16:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731428777; cv=none; b=ZmgoRlg8L/VoKhqJa1fNlO0Fi10M9WndXIMRkBPuYaPmZkxfRhy5lomt3sBZ7iFcI+PvORaC+bLhKBvJ3sqQGVMKh+VQ+uQaw3cprdT2gkeo9atvnknS03sli6ImHSBQligCMMkf+RbZKzYYcmJSz6Y7b2l7NEwun9Wj23E6N+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731428777; c=relaxed/simple;
	bh=KXLJUKz9bp4uQdY8VQCGIk7LGfO+vHGdE/OGqh1IvUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1FZFyUFEPeY7Pe8yuMbjHGaNJydQRlDNkALwr+W7DV4xDGsLYI2+74UdfiNnQWsPuzB379bQnuSjWnl69TWcqYaX4a99KfDcz75DvsMLHe9PAkkVnAP5WSmk0Oqd7C/mSbfWVi2liOv7dhGe453cLMFOI5VpVWhTkQmSAx3xC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qS067/24; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACFe5mA002936;
	Tue, 12 Nov 2024 16:26:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=2aFmbDwjhODzHeVVF
	of5YsSsnmfMsSehzyMvlfi7D6c=; b=qS067/24eTHcGaPJReltD6jPrfuikd2fR
	2ko0Gcpdl35GnZ4drSvrYwHMrMPrGMRSjJbZswGy6RoRVHZ58b6oihm7niJO3cA+
	Hg0Tvts/YyGdVPJhf+CJIq7l4TbRgip1jLF3zihk+r2kmdgS7g4yRzqKFy84Etwf
	1z8URnhRcvUsxPZeuurVLEd18EhRfSpl9jis/FgFEyxH2a82+TRIc/RcAhM07R3g
	xDRVU5JRG0kWaYHthJAsauCejLCoWfOoq0M7MN4sOHslr8hLvvyWIg+ed+2Kmwu7
	/cG7e6G0vD+i0vJEQ2/lvfWzWa+F+k1Wg/uei2UREfreZBwjx0u7A==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42v9uy85nm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:13 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACFgVDc029734;
	Tue, 12 Nov 2024 16:26:12 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42tkjktqwc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:12 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4ACGQ8eX33489208
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:26:08 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC97C20040;
	Tue, 12 Nov 2024 16:26:08 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5F4E720049;
	Tue, 12 Nov 2024 16:26:08 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.179.25.251])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 12 Nov 2024 16:26:08 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        Hariharan Mari <hari55@linux.ibm.com>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [GIT PULL 05/14] KVM: s390: selftests: Add regression tests for PLO subfunctions
Date: Tue, 12 Nov 2024 17:23:19 +0100
Message-ID: <20241112162536.144980-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112162536.144980-1-frankja@linux.ibm.com>
References: <20241112162536.144980-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ug2qAmjx7_C4lxfBY7WGPRLcOuYvkDiq
X-Proofpoint-GUID: Ug2qAmjx7_C4lxfBY7WGPRLcOuYvkDiq
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411120128

From: Hariharan Mari <hari55@linux.ibm.com>

Extend the existing regression test framework for s390x CPU subfunctions
to include tests for the Perform Locked Operation (PLO) subfunction
functions.

PLO was introduced in the very first 64-bit machine generation.
Hence it is assumed PLO is always installed in the Z Arch.
The test procedure follows the established pattern.

Suggested-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Hariharan Mari <hari55@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Link: https://lore.kernel.org/r/20240823130947.38323-6-hari55@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20240823130947.38323-6-hari55@linux.ibm.com>
---
 .../kvm/s390x/cpumodel_subfuncs_test.c        | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c b/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c
index fe45fb131583..222ba1cc3cac 100644
--- a/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c
+++ b/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c
@@ -19,6 +19,8 @@
 
 #include "kvm_util.h"
 
+#define PLO_FUNCTION_MAX 256
+
 /* Query available CPU subfunctions */
 struct kvm_s390_vm_cpu_subfunc cpu_subfunc;
 
@@ -33,6 +35,31 @@ static void get_cpu_machine_subfuntions(struct kvm_vm *vm,
 	TEST_ASSERT(!r, "Get cpu subfunctions failed r=%d errno=%d", r, errno);
 }
 
+static inline int plo_test_bit(unsigned char nr)
+{
+	unsigned long function = nr | 0x100;
+	int cc;
+
+	asm volatile("	lgr	0,%[function]\n"
+			/* Parameter registers are ignored for "test bit" */
+			"	plo	0,0,0,0(0)\n"
+			"	ipm	%0\n"
+			"	srl	%0,28\n"
+			: "=d" (cc)
+			: [function] "d" (function)
+			: "cc", "0");
+	return cc == 0;
+}
+
+/* Testing Perform Locked Operation (PLO) CPU subfunction's ASM block */
+static void test_plo_asm_block(u8 (*query)[32])
+{
+	for (int i = 0; i < PLO_FUNCTION_MAX; ++i) {
+		if (plo_test_bit(i))
+			(*query)[i >> 3] |= 0x80 >> (i & 7);
+	}
+}
+
 /* Testing Crypto Compute Message Authentication Code (KMAC) CPU subfunction's ASM block */
 static void test_kmac_asm_block(u8 (*query)[16])
 {
@@ -196,6 +223,11 @@ struct testdef {
 	testfunc_t test;
 	int facility_bit;
 } testlist[] = {
+	/*
+	 * PLO was introduced in the very first 64-bit machine generation.
+	 * Hence it is assumed PLO is always installed in Z Arch.
+	 */
+	{ "PLO", cpu_subfunc.plo, sizeof(cpu_subfunc.plo), test_plo_asm_block, 1 },
 	/* MSA - Facility bit 17 */
 	{ "KMAC", cpu_subfunc.kmac, sizeof(cpu_subfunc.kmac), test_kmac_asm_block, 17 },
 	{ "KMC", cpu_subfunc.kmc, sizeof(cpu_subfunc.kmc), test_kmc_asm_block, 17 },
-- 
2.47.0


