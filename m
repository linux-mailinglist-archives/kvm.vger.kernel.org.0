Return-Path: <kvm+bounces-4326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6ADA8111AE
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 13:50:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC2971C203A9
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 12:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EA302C862;
	Wed, 13 Dec 2023 12:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Tx2H/gWK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DCF115;
	Wed, 13 Dec 2023 04:49:55 -0800 (PST)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDBlnMe028165;
	Wed, 13 Dec 2023 12:49:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=81nH/wKMgJCeQ0T288t6HejOyQaPoSux1S5n1WNd59A=;
 b=Tx2H/gWKB/G5d1M3FFsiXGH2LLQ0gFLsFJjdGRpNHa4B2J7Mvvb5z3ADcYO7LaMay2/Y
 q7nnPyeO5TkT24rO1b73YUwXF08KcQ7xrmX0q4G3vB5rC3RtlWUMgI2SaSX9ZJZD8/xk
 V0Jq9gtrruhD1zvOE9r3BzZSbLbC8sZwfWjcU9Ci96CStH10cDC1v7/wHxZ4o5AlvgQY
 UrK6jukK2r0PQjHJJrKEoFdfzeFqY/pYcmvfOTSF2O+B3YfCeU6YrrGFaJK3CIty8OsS
 /YL8zHWRwKT1SgjjugijDXKKtKGJVgA5x4zfVVij+c0GGvaCyZ6gOIJISAt2Uih1fOrj mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uybamaw22-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:49:52 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BDCPPod007825;
	Wed, 13 Dec 2023 12:49:51 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uybamaw1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:49:51 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDCDo4u028217;
	Wed, 13 Dec 2023 12:49:51 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uw2xyrw6u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:49:51 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BDCnjRo17302220
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Dec 2023 12:49:45 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D1B520040;
	Wed, 13 Dec 2023 12:49:45 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B7442004D;
	Wed, 13 Dec 2023 12:49:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Dec 2023 12:49:45 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH 5/5] s390x: Add test for STFLE interpretive execution (format-0)
Date: Wed, 13 Dec 2023 13:49:42 +0100
Message-Id: <20231213124942.604109-6-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231213124942.604109-1-nsg@linux.ibm.com>
References: <20231213124942.604109-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: okUhs5d13wrFaUgpCYyjyumrfrxP4jJD
X-Proofpoint-ORIG-GUID: Ce9shyUvWiGtOLMvTf2li6IStnb7c7lT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-13_05,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312130093

The STFLE instruction indicates installed facilities.
SIE can interpretively execute STFLE.
Use a snippet guest executing STFLE to get the result of
interpretive execution and check the result.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/Makefile           |   2 +
 lib/s390x/asm/facility.h |  10 ++-
 s390x/snippets/c/stfle.c |  26 ++++++++
 s390x/stfle-sie.c        | 132 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 169 insertions(+), 1 deletion(-)
 create mode 100644 s390x/snippets/c/stfle.c
 create mode 100644 s390x/stfle-sie.c

diff --git a/s390x/Makefile b/s390x/Makefile
index a10695a2..12eb3053 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -42,6 +42,7 @@ tests += $(TEST_DIR)/exittime.elf
 tests += $(TEST_DIR)/ex.elf
 tests += $(TEST_DIR)/topology.elf
 tests += $(TEST_DIR)/sie-dat.elf
+tests += $(TEST_DIR)/stfle-sie.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 pv-tests += $(TEST_DIR)/pv-icptcode.elf
@@ -127,6 +128,7 @@ snippet_lib = $(snippet_asmlib) lib/auxinfo.o
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
index 00000000..eb024a6a
--- /dev/null
+++ b/s390x/snippets/c/stfle.c
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright IBM Corp. 2023
+ *
+ * Snippet used by the STLFE interpretive execution facilities test.
+ */
+#include <libcflat.h>
+#include <snippet-guest.h>
+
+int main(void)
+{
+	const unsigned int max_fac_len = 8;
+	uint64_t res[max_fac_len + 1];
+
+	res[0] = max_fac_len - 1;
+	asm volatile ( "lg	0,%[len]\n"
+		"	stfle	%[fac]\n"
+		"	stg	0,%[len]\n"
+		: [fac] "=QS"(*(uint64_t(*)[max_fac_len])&res[1]),
+		  [len] "+RT"(res[0])
+		:
+		: "%r0", "cc"
+	);
+	force_exit_value((uint64_t)&res);
+	return 0;
+}
diff --git a/s390x/stfle-sie.c b/s390x/stfle-sie.c
new file mode 100644
index 00000000..574319ed
--- /dev/null
+++ b/s390x/stfle-sie.c
@@ -0,0 +1,132 @@
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
+#include <snippet-host.h>
+#include <alloc_page.h>
+#include <sclp.h>
+
+static struct vm vm;
+static uint64_t (*fac)[PAGE_SIZE / sizeof(uint64_t)];
+static rand_state rand_s;
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
+	uint64_t reg;
+	unsigned char *mem;
+};
+
+static struct guest_stfle_res run_guest(void)
+{
+	struct guest_stfle_res res;
+	uint64_t guest_stfle_addr;
+
+	sie(&vm);
+	assert(snippet_get_force_exit_value(&vm, &guest_stfle_addr));
+	res.mem = &vm.guest_mem[guest_stfle_addr];
+	memcpy(&res.reg, res.mem, sizeof(res.reg));
+	res.len = (res.reg & 0xff) + 1;
+	res.mem += sizeof(res.reg);
+	return res;
+}
+
+static void test_stfle_format_0(void)
+{
+	struct guest_stfle_res res;
+
+	report_prefix_push("format-0");
+	for (int j = 0; j < stfle_size(); j++)
+		WRITE_ONCE((*fac)[j], rand64(&rand_s));
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
+
+	if (!sclp_facilities.has_sief2) {
+		report_skip("SIEF2 facility unavailable");
+		goto out;
+	}
+
+	report_info("pseudo rand seed: 0x%lx", args.seed);
+	rand_s = RAND_STATE_INIT(args.seed);
+	setup_guest();
+	if (test_facility(7))
+		test_stfle_format_0();
+out:
+	return report_summary();
+}
-- 
2.41.0


