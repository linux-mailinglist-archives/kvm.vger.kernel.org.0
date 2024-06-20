Return-Path: <kvm+bounces-20085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99C2D9107E3
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:17:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE2B0B21CAE
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 14:17:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEB0A1AE0A9;
	Thu, 20 Jun 2024 14:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jweByJnV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2790E1AD4B4;
	Thu, 20 Jun 2024 14:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718893037; cv=none; b=HOPs6o1MEOyowyVjFpPj97WfRQC0Nb91JRHUEMogz/JFBPGAvc6iUDCoV6PlE3rcBP/qqqWqyDmSkZ8R1d9zayfHJsH2x/IgGqK8gqixxVCKGjpgs7Zposqh9nUaeDhBpcZEG4MVIiFQDz/9sSilaY6wvlnXYkfqiwSaRhT9neQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718893037; c=relaxed/simple;
	bh=Rj9cIfWGWKrmXLJWf4N9A9mRVogrlVD3Iqnr1nXHryE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TS4NXN7KSOcrzZelJrELEulM+mXpxjVGjCHoBrOtWBzEXxQbbeaH6WTUN59m8dQg3ZnhOmemiDvyHg4oHYfFlCdG6sGsiqbfj3R5SJEi2M2M5WtZkiAYlgzqP4h7VOHkgwuusL2cSy2DqqW3J/FbY/VJLZfZGKkOS7Q4XWiFG/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jweByJnV; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KDTRxw026002;
	Thu, 20 Jun 2024 14:17:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=keP6ekziMI+Xf
	yfXggiAG65uXvo+By5A+FVoZBUlWzw=; b=jweByJnV9sRI87x55uyhneIslVvMp
	DQov44W3whHNTIr2IhmojEZ4IkxxVitdrVwohzrXHMmzKmw1i97B0ZAsi6sseFWe
	zk5lHDK9XCJPcTaevQodYmeeLWAHJVupcnd5WLnyMxoq5fzWxfNKHOwsCZcilqmH
	ONUL78bUJvBti6q8ulCx4sRrLUfXk0O5HkjbhYyAVgr/plAbXBl2Eld2X8CIxMrw
	tmm6gDbwwxs/mFetvC5qVOw/VogSKQhwyS+0OtDCXG3A5jsjIMxQYCEcoL77LPgV
	DlwpQh1VsZw/XdFUCnayGXkM2uYBC3VSIFPfAmTxtvK6VB7hpnttMRVBA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvnbhr4ve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:12 +0000 (GMT)
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45KEHBbP011989;
	Thu, 20 Jun 2024 14:17:11 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvnbhr4v8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:11 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45KCkXoA011027;
	Thu, 20 Jun 2024 14:17:10 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yspsnpnqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:10 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45KEH41242598858
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 14:17:06 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B6E92004D;
	Thu, 20 Jun 2024 14:17:04 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5554A20065;
	Thu, 20 Jun 2024 14:17:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Jun 2024 14:17:04 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, Thomas Huth <thuth@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 7/7] s390x: Add test for STFLE interpretive execution (format-0)
Date: Thu, 20 Jun 2024 16:17:00 +0200
Message-Id: <20240620141700.4124157-8-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240620141700.4124157-1-nsg@linux.ibm.com>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZHH-_SUFoWhih_gfKb6dLKNOazJwq-kp
X-Proofpoint-ORIG-GUID: VSmhF2XHD3gNUclOsg48rwraRNWP7yOu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 clxscore=1015
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2405170001 definitions=main-2406200099

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
index 12445fb5..7c38d66a 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -44,6 +44,7 @@ tests += $(TEST_DIR)/exittime.elf
 tests += $(TEST_DIR)/ex.elf
 tests += $(TEST_DIR)/topology.elf
 tests += $(TEST_DIR)/sie-dat.elf
+tests += $(TEST_DIR)/stfle-sie.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 pv-tests += $(TEST_DIR)/pv-icptcode.elf
@@ -129,6 +130,7 @@ snippet_lib = $(snippet_asmlib) lib/auxinfo.o
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
index 3a9decc9..f2203069 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -392,3 +392,6 @@ file = sie-dat.elf
 
 [pv-attest]
 file = pv-attest.elf
+
+[stfle-sie]
+file = stfle-sie.elf
-- 
2.44.0


