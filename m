Return-Path: <kvm+bounces-29023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 779A49A1129
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 20:04:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 848081C20BB2
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 18:04:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B16ED2144B5;
	Wed, 16 Oct 2024 18:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="A25CpTNX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D263210C30;
	Wed, 16 Oct 2024 18:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729101813; cv=none; b=YF5dAYyeNLPK/eXpxkSs3VPU6MhNJl9EH+JnKN97mriNyKERiCL1U2OhCbuadl3KN5D4NEKObg1TGv1iO8lA6Gk4gbtzTC0W/4PjcMjN1riydeNihFnTcvP/yB+FnOGVPqlr3e8mkvR0rKR2vyxA9QxQWjQttDDMxFsLqHe//oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729101813; c=relaxed/simple;
	bh=w4k0yWe7V7MTju/3jNu0jY0wss1H5W0yQS13TrCYdqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfCQyF0e2G6NJMmeYt4yw1esrdMt4RDCKg4gJYtQO0xpNp2XqbMzNGfbkKBX9sspN65gZGUGIGjvA9I31hqSIe5fErMoPQK9A0/TAni6ap21EuMI2pD9yVf3QJXYcvjM4STSdbG0Z1Q0Ur7o9mBT14CXSa300Kbsm2m8rzoExOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=A25CpTNX; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49GHngfK005839;
	Wed, 16 Oct 2024 18:03:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Fti7f+V710xPWUL9A
	+ltbzZfTlcPLhAHdT95sItFBAI=; b=A25CpTNXZcIhCc19h/W94EmPQh6xbcPJU
	EpHp1KKANin4wBxLegQTPmYYUCTkDbMTTsSQbKQxFOcUGfJsZdjl8oYUSoj52CTT
	rvsRc/fr1Lo/duIIdbtyb+gCDV2r7RXP5B+hqhWfwpRAu0EyjfiIGdRUdlBL42wx
	/20EpvaVLFdRItDFEUC9MT3H/Aior3eSWFp/NizMwV9F2bQOrYj25dn4xOv1GE9A
	vRCvBieeORgzjMrARYtcPzjwDeXSnpPIMwQgeXTPvF2SAS0HpR5UwRMwDpAJMTmj
	V3UdwHcppAukdiI0XVjBU3lB3msfrFnIjyvmCvxBkImZntUgkp+iA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42aj7v81tf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:30 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49GI3Unx001677;
	Wed, 16 Oct 2024 18:03:30 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42aj7v81te-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:30 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49GGFktR002426;
	Wed, 16 Oct 2024 18:03:29 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284emtt53-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:29 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49GI3QR854395380
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 18:03:26 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0520E20049;
	Wed, 16 Oct 2024 18:03:26 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AFE0020040;
	Wed, 16 Oct 2024 18:03:25 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Oct 2024 18:03:25 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>
Subject: [kvm-unit-tests PATCH v4 6/6] s390x: Add test for STFLE interpretive execution (format-0)
Date: Wed, 16 Oct 2024 20:03:17 +0200
Message-ID: <20241016180320.686132-7-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241016180320.686132-1-nsg@linux.ibm.com>
References: <20241016180320.686132-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fjbibJousXS8QqTqtv_4WTN8VAbJnOBH
X-Proofpoint-ORIG-GUID: dUnCZ-93Sy7Yhcf-qD7M2jjq6ll6HEZR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 malwarescore=0 spamscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2409260000 definitions=main-2410160115

The STFLE instruction indicates installed facilities.
SIE can interpretively execute STFLE.
Use a snippet guest executing STFLE to get the result of
interpretive execution and check the result.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
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
index 1caf221d..a5ef3a8e 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -44,6 +44,7 @@ tests += $(TEST_DIR)/exittime.elf
 tests += $(TEST_DIR)/ex.elf
 tests += $(TEST_DIR)/topology.elf
 tests += $(TEST_DIR)/sie-dat.elf
+tests += $(TEST_DIR)/stfle-sie.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 pv-tests += $(TEST_DIR)/pv-icptcode.elf
@@ -130,6 +131,7 @@ snippet_lib = $(snippet_asmlib) lib/auxinfo.o
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
index 00000000..42d3d7fe
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
+	asm volatile ( "lgr	0,%[len]\n"
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


