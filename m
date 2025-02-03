Return-Path: <kvm+bounces-37103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 56EC4A25485
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:37:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBE8516284A
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 08:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E675E1FBEBE;
	Mon,  3 Feb 2025 08:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UZOfjoII"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5B91FAC23
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 08:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738571806; cv=none; b=Vx73QPqsFmEFrisCbXz3eAdJ3b1/7EXoYpaS3K2MwyaRd04vNgcnHhDuqH+tccvnZB2o1/jS9RrsyDAqzYxtUzVspty8ptnkWAttN3r8eCkls7Z8sOOsxEV6Ty+NDsH1DbZ7MRcWIzW4yrSkqrv6HKI+CPPzT4GFANq2HXxvhyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738571806; c=relaxed/simple;
	bh=MTg4u83OG5wPCFXg7BvcZmXSPuICbhYcjI/W8yN31Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcEjRF+LzK9XiVrKFoK9dDEN56ILTG29BwDgw62+HISyyXj0JkNyhSBHuQxwzHG2dFCei0sy3cEnK1HGf5Hiq1f8CUQLvYzyBaqTMa1ONkW2JFpfJo6gDAezj9vMXHSmnQ4dSotPFtM03KtvLcOmsYvSfK/TCSiIF41GkeuB8xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UZOfjoII; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 512NOvZP026239;
	Mon, 3 Feb 2025 08:36:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=IiKJPouBhocyFR/Ox
	7gvxOPbLsJqC9Hk84fkUeDq7KA=; b=UZOfjoIIUWhyqdV7DtLSKlr5noC/bTQ9C
	HWeSG71geIL1CIg9JuqgGfU20yLxaQxZAHdHmNBR4OsqnnYAHY7YuIyFRrrKnlhP
	1Ux0tRstE196tPtaWp1u1UvAEdTePHcQ5H3FD8pzDf6hHKkEYhopD51bklZPwTe9
	SpcJw3VyweMMk06ezduUQyIZ2kfc5FASuCB1eXAOAo4AaA2B0dWpOJ4eVs/1x4VU
	0UNT94r6rKily0DNy2rCCxrM5ZE7I8ssPf/He3/SUEIkZ3B5GfzwPozusFbLjXCP
	9KXyPCLTv4Jl8NPWvM2Dc8U3V/v24ms2OBAKmG2/eSjX31krrhWyQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jbht2xb8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:32 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5137H8PE007192;
	Mon, 3 Feb 2025 08:36:31 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44hxaydhha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:31 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5138aSIm46334362
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Feb 2025 08:36:28 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 011652004B;
	Mon,  3 Feb 2025 08:36:28 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 84FF920043;
	Mon,  3 Feb 2025 08:36:27 +0000 (GMT)
Received: from t14-nrb.lan (unknown [9.171.84.16])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Feb 2025 08:36:27 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 07/18] s390x: Add function for checking diagnose intercepts
Date: Mon,  3 Feb 2025 09:35:15 +0100
Message-ID: <20250203083606.22864-8-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250203083606.22864-1-nrb@linux.ibm.com>
References: <20250203083606.22864-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yhXgDRDF8r89jKsA8nS5JyZ6SxHcH-iO
X-Proofpoint-GUID: yhXgDRDF8r89jKsA8nS5JyZ6SxHcH-iO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_03,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 impostorscore=0 phishscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2501170000 definitions=main-2502030068

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

sie_is_diag_icpt() checks if the intercept is due to an expected
diagnose call and is valid.
It subsumes pv_icptdata_check_diag.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20241016180320.686132-4-nsg@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile          |  1 +
 lib/s390x/pv_icptdata.h | 42 -----------------------------
 lib/s390x/sie-icpt.h    | 39 +++++++++++++++++++++++++++
 lib/s390x/sie-icpt.c    | 60 +++++++++++++++++++++++++++++++++++++++++
 s390x/pv-diags.c        |  9 +++----
 s390x/pv-icptcode.c     | 12 ++++-----
 s390x/pv-ipl.c          |  8 +++---
 7 files changed, 114 insertions(+), 57 deletions(-)
 delete mode 100644 lib/s390x/pv_icptdata.h
 create mode 100644 lib/s390x/sie-icpt.h
 create mode 100644 lib/s390x/sie-icpt.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 66d71351..907b3a04 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -112,6 +112,7 @@ cflatobjs += lib/s390x/css_lib.o
 cflatobjs += lib/s390x/malloc_io.o
 cflatobjs += lib/s390x/uv.o
 cflatobjs += lib/s390x/sie.o
+cflatobjs += lib/s390x/sie-icpt.o
 cflatobjs += lib/s390x/fault.o
 
 OBJDIRS += lib/s390x
diff --git a/lib/s390x/pv_icptdata.h b/lib/s390x/pv_icptdata.h
deleted file mode 100644
index 4746117e..00000000
--- a/lib/s390x/pv_icptdata.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Commonly used checks for PV SIE intercept data
- *
- * Copyright IBM Corp. 2023
- * Author: Janosch Frank <frankja@linux.ibm.com>
- */
-
-#ifndef _S390X_PV_ICPTDATA_H_
-#define _S390X_PV_ICPTDATA_H_
-
-#include <sie.h>
-
-/*
- * Checks the diagnose instruction intercept data for consistency with
- * the constants defined by the PV SIE architecture
- *
- * Supports: 0x44, 0x9c, 0x288, 0x308, 0x500
- */
-static bool pv_icptdata_check_diag(struct vm *vm, int diag)
-{
-	int icptcode;
-
-	switch (diag) {
-	case 0x44:
-	case 0x9c:
-	case 0x288:
-	case 0x308:
-		icptcode = ICPT_PV_NOTIFY;
-		break;
-	case 0x500:
-		icptcode = ICPT_PV_INSTR;
-		break;
-	default:
-		/* If a new diag is introduced add it to the cases above! */
-		assert(0);
-	}
-
-	return vm->sblk->icptcode == icptcode && vm->sblk->ipa == 0x8302 &&
-	       vm->sblk->ipb == 0x50000000 && vm->save_area.guest.grs[5] == diag;
-}
-#endif
diff --git a/lib/s390x/sie-icpt.h b/lib/s390x/sie-icpt.h
new file mode 100644
index 00000000..604a7221
--- /dev/null
+++ b/lib/s390x/sie-icpt.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Functionality for SIE interception handling.
+ *
+ * Copyright IBM Corp. 2024
+ */
+
+#ifndef _S390X_SIE_ICPT_H_
+#define _S390X_SIE_ICPT_H_
+
+#include <libcflat.h>
+#include <sie.h>
+
+struct diag_itext {
+	uint64_t opcode   :  8;
+	uint64_t r_1      :  4;
+	uint64_t r_2      :  4;
+	uint64_t r_base   :  4;
+	uint64_t displace : 12;
+	uint64_t zero     : 16;
+	uint64_t          : 16;
+};
+
+struct diag_itext sblk_ip_as_diag(struct kvm_s390_sie_block *sblk);
+
+/**
+ * sie_is_diag_icpt() - Check if intercept is due to diagnose instruction
+ * @vm: the guest
+ * @diag: the expected diagnose code
+ *
+ * Check that the intercept is due to diagnose @diag and valid.
+ * For protected virtualization, check that the intercept data meets additional
+ * constraints.
+ *
+ * Returns: true if intercept is due to a valid and has matching diagnose code
+ */
+bool sie_is_diag_icpt(struct vm *vm, unsigned int diag);
+
+#endif /* _S390X_SIE_ICPT_H_ */
diff --git a/lib/s390x/sie-icpt.c b/lib/s390x/sie-icpt.c
new file mode 100644
index 00000000..17064424
--- /dev/null
+++ b/lib/s390x/sie-icpt.c
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Functionality for SIE interception handling.
+ *
+ * Copyright IBM Corp. 2024
+ */
+
+#include <sie-icpt.h>
+
+struct diag_itext sblk_ip_as_diag(struct kvm_s390_sie_block *sblk)
+{
+	union {
+		struct {
+			uint64_t ipa : 16;
+			uint64_t ipb : 32;
+			uint64_t     : 16;
+		};
+		struct diag_itext diag;
+	} instr = { .ipa = sblk->ipa, .ipb = sblk->ipb };
+
+	return instr.diag;
+}
+
+bool sie_is_diag_icpt(struct vm *vm, unsigned int diag)
+{
+	struct diag_itext instr = sblk_ip_as_diag(vm->sblk);
+	uint8_t icptcode;
+	uint64_t code;
+
+	switch (diag) {
+	case 0x44:
+	case 0x9c:
+	case 0x288:
+	case 0x308:
+		icptcode = ICPT_PV_NOTIFY;
+		break;
+	case 0x500:
+		icptcode = ICPT_PV_INSTR;
+		break;
+	default:
+		/* If a new diag is introduced add it to the cases above! */
+		assert_msg(false, "unknown diag 0x%x", diag);
+	}
+
+	if (sie_is_pv(vm)) {
+		if (instr.r_1 != 0 || instr.r_2 != 2 || instr.r_base != 5)
+			return false;
+		if (instr.displace)
+			return false;
+	} else {
+		icptcode = ICPT_INST;
+	}
+	if (vm->sblk->icptcode != icptcode)
+		return false;
+	if (instr.opcode != 0x83 || instr.zero)
+		return false;
+	code = instr.r_base ? vm->save_area.guest.grs[instr.r_base] : 0;
+	code = (code + instr.displace) & 0xffff;
+	return code == diag;
+}
diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
index 3193ad99..09b83d59 100644
--- a/s390x/pv-diags.c
+++ b/s390x/pv-diags.c
@@ -9,7 +9,7 @@
  */
 #include <libcflat.h>
 #include <snippet.h>
-#include <pv_icptdata.h>
+#include <sie-icpt.h>
 #include <sie.h>
 #include <sclp.h>
 #include <asm/facility.h>
@@ -32,8 +32,7 @@ static void test_diag_500(void)
 			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
 
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x500),
-	       "intercept values");
+	report(sie_is_diag_icpt(&vm, 0x500), "intercept values");
 	report(vm.save_area.guest.grs[1] == 1 &&
 	       vm.save_area.guest.grs[2] == 2 &&
 	       vm.save_area.guest.grs[3] == 3 &&
@@ -45,7 +44,7 @@ static void test_diag_500(void)
 	 */
 	vm.sblk->iictl = IICTL_CODE_OPERAND;
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x9c) &&
+	report(sie_is_diag_icpt(&vm, 0x9c) &&
 	       vm.save_area.guest.grs[0] == PGM_INT_CODE_OPERAND,
 	       "operand exception");
 
@@ -57,7 +56,7 @@ static void test_diag_500(void)
 	vm.sblk->iictl = IICTL_CODE_SPECIFICATION;
 	/* Inject PGM, next exit should be 9c */
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x9c) &&
+	report(sie_is_diag_icpt(&vm, 0x9c) &&
 	       vm.save_area.guest.grs[0] == PGM_INT_CODE_SPECIFICATION,
 	       "specification exception");
 
diff --git a/s390x/pv-icptcode.c b/s390x/pv-icptcode.c
index d7c47d6f..5293306b 100644
--- a/s390x/pv-icptcode.c
+++ b/s390x/pv-icptcode.c
@@ -13,7 +13,7 @@
 #include <smp.h>
 #include <sclp.h>
 #include <snippet.h>
-#include <pv_icptdata.h>
+#include <sie-icpt.h>
 #include <asm/facility.h>
 #include <asm/barrier.h>
 #include <asm/sigp.h>
@@ -47,7 +47,7 @@ static void test_validity_timing(void)
 			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
 
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x44), "spt done");
+	report(sie_is_diag_icpt(&vm, 0x44), "spt done");
 	stck(&time_exit);
 	tmp = vm.sblk->cputm;
 	mb();
@@ -258,7 +258,7 @@ static void test_validity_asce(void)
 
 	/* Try if we can still do an entry with the correct asce */
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x44), "re-entry with valid CR1");
+	report(sie_is_diag_icpt(&vm, 0x44), "re-entry with valid CR1");
 	uv_destroy_guest(&vm);
 	free_pages(pgd_new);
 	report_prefix_pop();
@@ -294,7 +294,7 @@ static void run_icpt_122_tests_prefix(unsigned long prefix)
 
 	sie(&vm);
 	/* Guest indicates that it has been setup via the diag 0x44 */
-	assert(pv_icptdata_check_diag(&vm, 0x44));
+	assert(sie_is_diag_icpt(&vm, 0x44));
 	/* If the pages have not been shared these writes will cause exceptions */
 	ptr = (uint32_t *)prefix;
 	WRITE_ONCE(ptr, 0);
@@ -328,7 +328,7 @@ static void test_icpt_112(void)
 
 	/* Setup of the guest's state for 0x0 prefix */
 	sie(&vm);
-	assert(pv_icptdata_check_diag(&vm, 0x44));
+	assert(sie_is_diag_icpt(&vm, 0x44));
 
 	/* Test on standard 0x0 prefix */
 	run_icpt_122_tests_prefix(0);
@@ -348,7 +348,7 @@ static void test_icpt_112(void)
 
 	/* Try a re-entry after everything has been imported again */
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x9c) &&
+	report(sie_is_diag_icpt(&vm, 0x9c) &&
 	       vm.save_area.guest.grs[0] == 42,
 	       "re-entry successful");
 	report_prefix_pop();
diff --git a/s390x/pv-ipl.c b/s390x/pv-ipl.c
index cc46e7f7..61a1e0c0 100644
--- a/s390x/pv-ipl.c
+++ b/s390x/pv-ipl.c
@@ -11,7 +11,7 @@
 #include <sie.h>
 #include <sclp.h>
 #include <snippet.h>
-#include <pv_icptdata.h>
+#include <sie-icpt.h>
 #include <asm/facility.h>
 #include <asm/uv.h>
 
@@ -35,7 +35,7 @@ static void test_diag_308(int subcode)
 
 	/* First exit is a diag 0x500 */
 	sie(&vm);
-	assert(pv_icptdata_check_diag(&vm, 0x500));
+	assert(sie_is_diag_icpt(&vm, 0x500));
 
 	/*
 	 * The snippet asked us for the subcode and we answer by
@@ -46,7 +46,7 @@ static void test_diag_308(int subcode)
 
 	/* Continue after diag 0x500, next icpt should be the 0x308 */
 	sie(&vm);
-	assert(pv_icptdata_check_diag(&vm, 0x308));
+	assert(sie_is_diag_icpt(&vm, 0x308));
 	assert(vm.save_area.guest.grs[2] == subcode);
 
 	/*
@@ -118,7 +118,7 @@ static void test_diag_308(int subcode)
 	 * see a diagnose 0x9c PV instruction notification.
 	 */
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x9c) &&
+	report(sie_is_diag_icpt(&vm, 0x9c) &&
 	       vm.save_area.guest.grs[0] == 42,
 	       "continue after load");
 
-- 
2.47.1


