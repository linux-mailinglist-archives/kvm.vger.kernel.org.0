Return-Path: <kvm+bounces-31629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFCAA9C5D1D
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 17:26:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB3F7283041
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 16:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4C5B205AD3;
	Tue, 12 Nov 2024 16:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="If8fgt8c"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24253205140;
	Tue, 12 Nov 2024 16:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731428775; cv=none; b=SHQco7tnBJfYWUyCu1BNfglC3vdPl7TCOx0xGyhk2pHGe137vqkccoWWiOKgNOZilryxEt7l55RKpkSaC8WrgTyJaKtelp8Lky3KOyqm0QDehUMSUhZPJ9GXFd1TVrYc9Ch57m/hE+zrMPrsTCItNNUQufEkBWW2SQnrdv/eMqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731428775; c=relaxed/simple;
	bh=3vOmKw/0dJa7AwCR7+0D51E+C2bc1mLqGHrWq2BRx5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZdoTPEpgHbSioeMaqCbqqjL5K8MN9QaGJfXnNl9aN7/tHJaCv6UxiVRmD5UWyImHrO8TZKrinsgIGykp8/99r2zCsojUNJgLjkw9vtoi49uIwU8Y3+VtyxYzjzKzh37l+a/CEpDtIsmFqc/RKeMm7xdMNAPT7ydCiPa/WO5QWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=If8fgt8c; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACFe5m9002936;
	Tue, 12 Nov 2024 16:26:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=4TlaEfctv6wh8XHTb
	v8AMkmccQfYMwk+k5T85zpNEBI=; b=If8fgt8cDam5un6e6a013+WVGu3G2viZF
	qQIqCng9lwHw9GD7AZcsp63YbNnL0mOfnj04yMDNib7IQD05gjctnggni+V27+Ro
	murnxYH+4zlAg3NHRfwGI87QfecIyV7gQ+J1GUy4zmefwBiCbm56sSB8imL4W1to
	jxZX+KjxMbQuOAuK7ofcDPCb6J/rdsDcS8FFyayQgnhX49mKZuuj/HdtdPslRjUE
	Bo6mTCexoSMgiYUkIZIa1wiDy+7wyGfG2me2aXewgyveLSACjQuXDgBZ7Qr9qrJU
	/eZg56Rhe5bYlzs//Ditwo5P1OsyETODiHbuRkCCobTuJUnyo/qiw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42v9uy85nf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:11 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AC5aLxj017815;
	Tue, 12 Nov 2024 16:26:10 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42tk2mvj3q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:10 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4ACGQ6qG57999756
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:26:06 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B2B7320049;
	Tue, 12 Nov 2024 16:26:06 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 409E020040;
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
Subject: [GIT PULL 01/14] KVM: s390: selftests: Add regression tests for SORTL and DFLTCC CPU subfunctions
Date: Tue, 12 Nov 2024 17:23:15 +0100
Message-ID: <20241112162536.144980-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112162536.144980-1-frankja@linux.ibm.com>
References: <20241112162536.144980-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bCHv8HkeertunLrH4k2YM-WTCYKHxXZB
X-Proofpoint-GUID: bCHv8HkeertunLrH4k2YM-WTCYKHxXZB
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

Introduce new regression tests to verify the ASM inline block in the SORTL
and DFLTCC CPU subfunctions for the s390x architecture. These tests ensure
that future changes to the ASM code are properly validated.

The test procedure:

1. Create a VM and request the KVM_S390_VM_CPU_MACHINE_SUBFUNC attribute
   from the KVM_S390_VM_CPU_MODEL group for this VM. This SUBFUNC attribute
   contains the results of all CPU subfunction instructions.
2. For each tested subfunction (SORTL and DFLTCC), execute the
   corresponding ASM instruction and capture the result array.
3. Perform a memory comparison between the results stored in the SUBFUNC
   attribute (obtained in step 1) and the ASM instruction results (obtained
   in step 2) for each tested subfunction.

This process ensures that the KVM implementation accurately reflects the
behavior of the actual CPU instructions for the tested subfunctions.

Suggested-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Hariharan Mari <hari55@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Link: https://lore.kernel.org/r/20240823130947.38323-2-hari55@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20240823130947.38323-2-hari55@linux.ibm.com>
---
 tools/testing/selftests/kvm/Makefile          |   2 +
 .../selftests/kvm/include/s390x/facility.h    |  50 +++++++++
 .../selftests/kvm/lib/s390x/facility.c        |  14 +++
 .../kvm/s390x/cpumodel_subfuncs_test.c        | 105 ++++++++++++++++++
 4 files changed, 171 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/s390x/facility.h
 create mode 100644 tools/testing/selftests/kvm/lib/s390x/facility.c
 create mode 100644 tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 960cf6a77198..46b647b6b976 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -55,6 +55,7 @@ LIBKVM_aarch64 += lib/aarch64/vgic.c
 LIBKVM_s390x += lib/s390x/diag318_test_handler.c
 LIBKVM_s390x += lib/s390x/processor.c
 LIBKVM_s390x += lib/s390x/ucall.c
+LIBKVM_s390x += lib/s390x/facility.c
 
 LIBKVM_riscv += lib/riscv/handlers.S
 LIBKVM_riscv += lib/riscv/processor.c
@@ -189,6 +190,7 @@ TEST_GEN_PROGS_s390x += s390x/sync_regs_test
 TEST_GEN_PROGS_s390x += s390x/tprot
 TEST_GEN_PROGS_s390x += s390x/cmma_test
 TEST_GEN_PROGS_s390x += s390x/debug_test
+TEST_GEN_PROGS_s390x += s390x/cpumodel_subfuncs_test
 TEST_GEN_PROGS_s390x += s390x/shared_zeropage_test
 TEST_GEN_PROGS_s390x += s390x/ucontrol_test
 TEST_GEN_PROGS_s390x += demand_paging_test
diff --git a/tools/testing/selftests/kvm/include/s390x/facility.h b/tools/testing/selftests/kvm/include/s390x/facility.h
new file mode 100644
index 000000000000..00a1ced6538b
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/s390x/facility.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright IBM Corp. 2024
+ *
+ * Authors:
+ *  Hariharan Mari <hari55@linux.ibm.com>
+ *
+ * Get the facility bits with the STFLE instruction
+ */
+
+#ifndef SELFTEST_KVM_FACILITY_H
+#define SELFTEST_KVM_FACILITY_H
+
+#include <linux/bitops.h>
+
+/* alt_stfle_fac_list[16] + stfle_fac_list[16] */
+#define NB_STFL_DOUBLEWORDS 32
+
+extern uint64_t stfl_doublewords[NB_STFL_DOUBLEWORDS];
+extern bool stfle_flag;
+
+static inline bool test_bit_inv(unsigned long nr, const unsigned long *ptr)
+{
+	return test_bit(nr ^ (BITS_PER_LONG - 1), ptr);
+}
+
+static inline void stfle(uint64_t *fac, unsigned int nb_doublewords)
+{
+	register unsigned long r0 asm("0") = nb_doublewords - 1;
+
+	asm volatile("	.insn	s,0xb2b00000,0(%1)\n"
+			: "+d" (r0)
+			: "a" (fac)
+			: "memory", "cc");
+}
+
+static inline void setup_facilities(void)
+{
+	stfle(stfl_doublewords, NB_STFL_DOUBLEWORDS);
+	stfle_flag = true;
+}
+
+static inline bool test_facility(int nr)
+{
+	if (!stfle_flag)
+		setup_facilities();
+	return test_bit_inv(nr, stfl_doublewords);
+}
+
+#endif
diff --git a/tools/testing/selftests/kvm/lib/s390x/facility.c b/tools/testing/selftests/kvm/lib/s390x/facility.c
new file mode 100644
index 000000000000..d540812d911a
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/s390x/facility.c
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright IBM Corp. 2024
+ *
+ * Authors:
+ *  Hariharan Mari <hari55@linux.ibm.com>
+ *
+ * Contains the definition for the global variables to have the test facitlity feature.
+ */
+
+#include "facility.h"
+
+uint64_t stfl_doublewords[NB_STFL_DOUBLEWORDS];
+bool stfle_flag;
diff --git a/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c b/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c
new file mode 100644
index 000000000000..ee525c841767
--- /dev/null
+++ b/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright IBM Corp. 2024
+ *
+ * Authors:
+ *  Hariharan Mari <hari55@linux.ibm.com>
+ *
+ * The tests compare the result of the KVM ioctl for obtaining CPU subfunction data with those
+ * from an ASM block performing the same CPU subfunction. Currently KVM doesn't mask instruction
+ * query data reported via the CPU Model, allowing us to directly compare it with the data
+ * acquired through executing the queries in the test.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include "facility.h"
+
+#include "kvm_util.h"
+
+/* Query available CPU subfunctions */
+struct kvm_s390_vm_cpu_subfunc cpu_subfunc;
+
+static void get_cpu_machine_subfuntions(struct kvm_vm *vm,
+					struct kvm_s390_vm_cpu_subfunc *cpu_subfunc)
+{
+	int r;
+
+	r = __kvm_device_attr_get(vm->fd, KVM_S390_VM_CPU_MODEL,
+				  KVM_S390_VM_CPU_MACHINE_SUBFUNC, cpu_subfunc);
+
+	TEST_ASSERT(!r, "Get cpu subfunctions failed r=%d errno=%d", r, errno);
+}
+
+/* Testing Sort Lists (SORTL) CPU subfunction's ASM block */
+static void test_sortl_asm_block(u8 (*query)[32])
+{
+	asm volatile("	lghi	0,0\n"
+			"	la	1,%[query]\n"
+			"	.insn	rre,0xb9380000,2,4\n"
+			: [query] "=R" (*query)
+			:
+			: "cc", "0", "1");
+}
+
+/* Testing Deflate Conversion Call (DFLTCC) CPU subfunction's ASM block */
+static void test_dfltcc_asm_block(u8 (*query)[32])
+{
+	asm volatile("	lghi	0,0\n"
+			"	la	1,%[query]\n"
+			"	.insn	rrf,0xb9390000,2,4,6,0\n"
+			: [query] "=R" (*query)
+			:
+			: "cc", "0", "1");
+}
+
+typedef void (*testfunc_t)(u8 (*array)[]);
+
+struct testdef {
+	const char *subfunc_name;
+	u8 *subfunc_array;
+	size_t array_size;
+	testfunc_t test;
+	int facility_bit;
+} testlist[] = {
+	/* SORTL - Facility bit 150 */
+	{ "SORTL", cpu_subfunc.sortl, sizeof(cpu_subfunc.sortl), test_sortl_asm_block, 150 },
+	/* DFLTCC - Facility bit 151 */
+	{ "DFLTCC", cpu_subfunc.dfltcc, sizeof(cpu_subfunc.dfltcc), test_dfltcc_asm_block, 151 },
+};
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+	int idx;
+
+	ksft_print_header();
+
+	vm = vm_create(1);
+
+	memset(&cpu_subfunc, 0, sizeof(cpu_subfunc));
+	get_cpu_machine_subfuntions(vm, &cpu_subfunc);
+
+	ksft_set_plan(ARRAY_SIZE(testlist));
+	for (idx = 0; idx < ARRAY_SIZE(testlist); idx++) {
+		if (test_facility(testlist[idx].facility_bit)) {
+			u8 *array = malloc(testlist[idx].array_size);
+
+			testlist[idx].test((u8 (*)[testlist[idx].array_size])array);
+
+			TEST_ASSERT_EQ(memcmp(testlist[idx].subfunc_array,
+					      array, testlist[idx].array_size), 0);
+
+			ksft_test_result_pass("%s\n", testlist[idx].subfunc_name);
+			free(array);
+		} else {
+			ksft_test_result_skip("%s feature is not avaialable\n",
+					      testlist[idx].subfunc_name);
+		}
+	}
+
+	kvm_vm_free(vm);
+	ksft_finished();
+}
-- 
2.47.0


