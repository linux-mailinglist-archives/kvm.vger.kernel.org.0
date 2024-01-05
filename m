Return-Path: <kvm+bounces-5755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B9690825CA3
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 23:54:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2C741C215FF
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 22:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF960360B5;
	Fri,  5 Jan 2024 22:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gW8RtWGa"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA8936091;
	Fri,  5 Jan 2024 22:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 405Mocsw016553;
	Fri, 5 Jan 2024 22:54:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4mD4K6/ZEfsYcFJZ3vk36ZAlJn9QyKmj6VZHAlPNFJY=;
 b=gW8RtWGazVcmAVr8O5OY1A44bpZ1uRsAicAXi4Gt5VmzXXhrtB98jdaCEzoJMpQAjpC/
 NE2S9xBYiQ1EzKxnwZVzrFwNenECUqCQJC7Ia+LCZ05WH02xdHKUuOeWx2nqGP1qMwng
 Nuroy8EAJVYfh/I/vtdAOPJJdbVbYmuBNRiECfTtQQNmNK9T8rjgsghoblh6ZZbq/6mO
 FLyzDKjoH1Arh0yGiLCeKau85FqzdA8YWKVxuQMMqmwAgUBSAHO8yVItKTLdsiOE2maw
 k0bszxW4JhqT4NzILrGcGmBdZ12lL81ATxYM4QnH4aVMQDvF0qKFMImTxCJF8gA+czHc wA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3veqgvmfsy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Jan 2024 22:54:28 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 405MrItN022459;
	Fri, 5 Jan 2024 22:54:27 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3veqgvmfsp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Jan 2024 22:54:27 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 405KCZNp017991;
	Fri, 5 Jan 2024 22:54:27 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vayrm21hf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Jan 2024 22:54:27 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 405MsOUb13894312
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 5 Jan 2024 22:54:24 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 430F220043;
	Fri,  5 Jan 2024 22:54:24 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0368520040;
	Fri,  5 Jan 2024 22:54:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  5 Jan 2024 22:54:23 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>, Nico Boehr <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 5/5] s390x: Add test for STFLE interpretive execution (format-0)
Date: Fri,  5 Jan 2024 23:54:19 +0100
Message-Id: <20240105225419.2841310-6-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240105225419.2841310-1-nsg@linux.ibm.com>
References: <20240105225419.2841310-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eXLLXSUNIj0SLdHmHt8TzuX5JwIacJ8Q
X-Proofpoint-ORIG-GUID: p59mMyEPj-sTS9QvnNznLH8N8-rJrfxu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-05_08,2024-01-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 spamscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401050176

The STFLE instruction indicates installed facilities.
SIE can interpretively execute STFLE.
Use a snippet guest executing STFLE to get the result of
interpretive execution and check the result.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/Makefile           |   2 +
 lib/s390x/asm/facility.h |  10 ++-
 s390x/snippets/c/stfle.c |  26 ++++++++
 s390x/stfle-sie.c        | 134 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg      |   3 +
 5 files changed, 174 insertions(+), 1 deletion(-)
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
index 00000000..a3e7f1c9
--- /dev/null
+++ b/s390x/stfle-sie.c
@@ -0,0 +1,134 @@
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
+	assert(snippet_is_force_exit_value(&vm));
+	guest_stfle_addr = snippet_get_force_exit_value(&vm);
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
+
+	if (!sclp_facilities.has_sief2) {
+		report_skip("SIEF2 facility unavailable");
+		goto out;
+	}
+
+	report_info("PRNG seed: 0x%lx", args.seed);
+	prng_s = prng_init(args.seed);
+	setup_guest();
+	if (test_facility(7))
+		test_stfle_format_0();
+out:
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index f5024b6e..118ffa3c 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -383,3 +383,6 @@ extra_params = """-cpu max,ctop=on -smp cpus=1,drawers=2,books=2,sockets=2,cores
 
 [sie-dat]
 file = sie-dat.elf
+
+[stfle-sie]
+file = stfle-sie.elf
-- 
2.43.0


