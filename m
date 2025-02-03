Return-Path: <kvm+bounces-37102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EDCDA25484
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:37:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 117861627F6
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 08:37:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B2D22046AD;
	Mon,  3 Feb 2025 08:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MOF71mnL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91C11FBEB9
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 08:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738571805; cv=none; b=clAs7otkZD0+/GqujRL2/Hat44YUHKr6YtM4A48tTXa7wws2cqABBjjte92ubQFEUsKxyi8nFjRIaVNBTMRrEkissc1q6tFmbOUSm/fb0P2PX6KIx8fsaJYdnwZPSOZ3ieiC7dmVEFL7fIH8w2D414MIMJYJ5Wl/ItBIyrdAymE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738571805; c=relaxed/simple;
	bh=2cB7qri0j8Oj3glnvt/A09nFbQf++I3P/RZMQC5MURY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koow0xAHXLPfmqu9ZzBDtP6wl6+wm9JfRPxpcNUJsGJuw6uuhsITDRcTvNujAHpmtWafOX1FHGU+vlyJz4Hup7vr1gDGl60zUUEwh84IF2ixB6sO0NVq1vJCx46j6jQgjQnC9pkogXC81F3YxeReYHgY4aTjLeVCSIGs9NYI4o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MOF71mnL; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51320jUv006210;
	Mon, 3 Feb 2025 08:36:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Y9OrjRuC5VqLymhs2
	eUN753itGdMJOLUGEzng7OlUYQ=; b=MOF71mnLI5EjiCCEau9uPkBCClwe5OBWl
	3G2lIrXllFGHnFnWECrzOPi6S80MHAJuEwANYDNY2vTHmMhsoPoRyvKRIQeuZkQ2
	3nA7dQTGlp2IbBHXslU1lRf7ghNAVIMsoBnwzuGuu2mMWVXofw6S/XzRPYsry/z+
	xj6ved7qD1C+R9FJKY7GvPwYHVBPhOC34gKig3S5P4/pEKXxjrpKXRdF84NfCUwn
	RU2eQfFR/yaHz+AypDc5mhLEOzLE9NRQ7GtSuK9lO/VaUJfpwsxYwTPgJydiPBp6
	DfXBAwM95o9jwPOka2ahZu+7trbsi5vNCC/zCTHsVq1Y/+RU/L7yw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jmmy9cdc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:33 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5136tp9s016288;
	Mon, 3 Feb 2025 08:36:33 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44hwxs5kt2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:33 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5138aTF848169338
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Feb 2025 08:36:29 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B5F520040;
	Mon,  3 Feb 2025 08:36:29 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2BDD920043;
	Mon,  3 Feb 2025 08:36:29 +0000 (GMT)
Received: from t14-nrb.lan (unknown [9.171.84.16])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Feb 2025 08:36:29 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 10/18] s390x: Add test for STFLE interpretive execution (format-0)
Date: Mon,  3 Feb 2025 09:35:18 +0100
Message-ID: <20250203083606.22864-11-nrb@linux.ibm.com>
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
X-Proofpoint-GUID: LpDSyQYCpAPVVqFiOGgauY67G1Kmb-5F
X-Proofpoint-ORIG-GUID: LpDSyQYCpAPVVqFiOGgauY67G1Kmb-5F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_03,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 phishscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502030068

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

The STFLE instruction indicates installed facilities.
SIE can interpretively execute STFLE.
Use a snippet guest executing STFLE to get the result of
interpretive execution and check the result.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Link: https://lore.kernel.org/r/20241016180320.686132-7-nsg@linux.ibm.com
[ nrb: fixup minor checkpatch issues ]
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile           |   2 +
 lib/s390x/asm/facility.h |  10 ++-
 s390x/snippets/c/stfle.c |  29 ++++++++
 s390x/stfle-sie.c        | 138 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg      |   3 +
 5 files changed, 181 insertions(+), 1 deletion(-)
 create mode 100644 s390x/snippets/c/stfle.c
 create mode 100644 s390x/stfle-sie.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 9eeff198..4424877e 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -45,6 +45,7 @@ tests += $(TEST_DIR)/ex.elf
 tests += $(TEST_DIR)/topology.elf
 tests += $(TEST_DIR)/sie-dat.elf
 tests += $(TEST_DIR)/diag258.elf
+tests += $(TEST_DIR)/stfle-sie.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 pv-tests += $(TEST_DIR)/pv-icptcode.elf
@@ -132,6 +133,7 @@ snippet_lib = $(snippet_asmlib) lib/auxinfo.o
 $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
 $(TEST_DIR)/sie-dat.elf: snippets = $(SNIPPET_DIR)/c/sie-dat.gbin
 $(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
+$(TEST_DIR)/stfle-sie.elf: snippets = $(SNIPPET_DIR)/c/stfle.gbin
 
 $(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-yield.gbin
 $(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-288.gbin
diff --git a/lib/s390x/asm/facility.h b/lib/s390x/asm/facility.h
index a66fe56a..2bad05c5 100644
--- a/lib/s390x/asm/facility.h
+++ b/lib/s390x/asm/facility.h
@@ -27,12 +27,20 @@ static inline void stfl(void)
 	asm volatile("	stfl	0(0)\n" : : : "memory");
 }
 
-static inline void stfle(uint64_t *fac, unsigned int nb_doublewords)
+static inline unsigned int stfle(uint64_t *fac, unsigned int nb_doublewords)
 {
 	register unsigned long r0 asm("0") = nb_doublewords - 1;
 
 	asm volatile("	.insn	s,0xb2b00000,0(%1)\n"
 		     : "+d" (r0) : "a" (fac) : "memory", "cc");
+	return r0 + 1;
+}
+
+static inline unsigned long stfle_size(void)
+{
+	uint64_t dummy;
+
+	return stfle(&dummy, 1);
 }
 
 static inline void setup_facilities(void)
diff --git a/s390x/snippets/c/stfle.c b/s390x/snippets/c/stfle.c
new file mode 100644
index 00000000..5fb6f948
--- /dev/null
+++ b/s390x/snippets/c/stfle.c
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright IBM Corp. 2023
+ *
+ * Snippet used by the STLFE interpretive execution facilities test.
+ */
+#include <libcflat.h>
+#include <snippet-exit.h>
+
+int main(void)
+{
+	const unsigned int max_fac_len = 8;
+	uint64_t len_arg = max_fac_len - 1;
+	uint64_t res[max_fac_len + 1];
+	uint64_t fac[max_fac_len];
+
+	asm volatile (" lgr	0,%[len]\n"
+		"	stfle	%[fac]\n"
+		"	lgr	%[len],0\n"
+		: [fac] "=Q"(fac),
+		  [len] "+d"(len_arg)
+		:
+		: "%r0", "cc"
+	);
+	res[0] = len_arg;
+	memcpy(&res[1], fac, sizeof(fac));
+	force_exit_value((uint64_t)&res);
+	return 0;
+}
diff --git a/s390x/stfle-sie.c b/s390x/stfle-sie.c
new file mode 100644
index 00000000..21cf8ff8
--- /dev/null
+++ b/s390x/stfle-sie.c
@@ -0,0 +1,138 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright IBM Corp. 2023
+ *
+ * SIE with STLFE interpretive execution facilities test.
+ */
+#include <libcflat.h>
+#include <stdlib.h>
+#include <asm/facility.h>
+#include <asm/time.h>
+#include <snippet.h>
+#include <snippet-exit.h>
+#include <alloc_page.h>
+#include <sclp.h>
+#include <rand.h>
+
+static struct vm vm;
+static uint64_t (*fac)[PAGE_SIZE / sizeof(uint64_t)];
+static prng_state prng_s;
+
+static void setup_guest(void)
+{
+	extern const char SNIPPET_NAME_START(c, stfle)[];
+	extern const char SNIPPET_NAME_END(c, stfle)[];
+
+	setup_vm();
+	fac = alloc_pages_flags(0, AREA_DMA31);
+
+	snippet_setup_guest(&vm, false);
+	snippet_init(&vm, SNIPPET_NAME_START(c, stfle),
+		     SNIPPET_LEN(c, stfle), SNIPPET_UNPACK_OFF);
+}
+
+struct guest_stfle_res {
+	uint16_t len;
+	unsigned char *mem;
+};
+
+static struct guest_stfle_res run_guest(void)
+{
+	struct guest_stfle_res res;
+	uint64_t guest_stfle_addr;
+	uint64_t reg;
+
+	sie(&vm);
+	assert(snippet_is_force_exit_value(&vm));
+	guest_stfle_addr = snippet_get_force_exit_value(&vm);
+	res.mem = &vm.guest_mem[guest_stfle_addr];
+	memcpy(&reg, res.mem, sizeof(reg));
+	res.len = (reg & 0xff) + 1;
+	res.mem += sizeof(reg);
+	return res;
+}
+
+static void test_stfle_format_0(void)
+{
+	struct guest_stfle_res res;
+
+	report_prefix_push("format-0");
+	for (int j = 0; j < stfle_size(); j++)
+		WRITE_ONCE((*fac)[j], prng64(&prng_s));
+	vm.sblk->fac = (uint32_t)(uint64_t)fac;
+	res = run_guest();
+	report(res.len == stfle_size(), "stfle len correct");
+	report(!memcmp(*fac, res.mem, res.len * sizeof(uint64_t)),
+	       "Guest facility list as specified");
+	report_prefix_pop();
+}
+
+struct args {
+	uint64_t seed;
+};
+
+static bool parse_uint64_t(const char *arg, uint64_t *out)
+{
+	char *end;
+	uint64_t num;
+
+	if (arg[0] == '\0')
+		return false;
+	num = strtoul(arg, &end, 0);
+	if (end[0] != '\0')
+		return false;
+	*out = num;
+	return true;
+}
+
+static struct args parse_args(int argc, char **argv)
+{
+	struct args args;
+	const char *flag;
+	unsigned int i;
+	uint64_t arg;
+	bool has_arg;
+
+	stck(&args.seed);
+
+	for (i = 1; i < argc; i++) {
+		if (i + 1 < argc)
+			has_arg = parse_uint64_t(argv[i + 1], &arg);
+		else
+			has_arg = false;
+
+		flag = "--seed";
+		if (!strcmp(flag, argv[i])) {
+			if (!has_arg)
+				report_abort("%s needs an uint64_t parameter", flag);
+			args.seed = arg;
+			++i;
+			continue;
+		}
+		report_abort("Unsupported parameter '%s'",
+			     argv[i]);
+	}
+
+	return args;
+}
+
+int main(int argc, char **argv)
+{
+	struct args args = parse_args(argc, argv);
+	bool run_format_0 = test_facility(7);
+
+	if (!sclp_facilities.has_sief2) {
+		report_skip("SIEF2 facility unavailable");
+		goto out;
+	}
+	if (!run_format_0)
+		report_skip("STFLE facility not available");
+
+	report_info("PRNG seed: 0x%lx", args.seed);
+	prng_s = prng_init(args.seed);
+	setup_guest();
+	if (run_format_0)
+		test_stfle_format_0();
+out:
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 8131ba10..a9af6680 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -395,3 +395,6 @@ file = pv-attest.elf
 
 [diag258]
 file = diag258.elf
+
+[stfle-sie]
+file = stfle-sie.elf
-- 
2.47.1


