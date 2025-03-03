Return-Path: <kvm+bounces-39940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8947CA4CED2
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 23:55:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 538487A400E
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 22:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC3BB23F400;
	Mon,  3 Mar 2025 22:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="CxnXxHYZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE5F23F28D
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 22:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741042397; cv=none; b=d67Y6fzIN+a5w1celnh7CBu+BVMlwZdEEhbZSbV5lScjjtVlFV8un8u4XTjM+3MvYChMnU4aeQ/TwFq2XSwoTnFVwlBHD3cxubh2KtkOYhnzB5re4OnYAf+sM5hkbTEUrxzJT8aJUxNSG3emvRbIXUum4MCbEHlMSQfn0Cf+NwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741042397; c=relaxed/simple;
	bh=oMiBPDZwgZr5dhcoZQIs4/IJPi1MUwF4a7itoyTuCso=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NOfFOgVytHTDE2DJWEWMMDQajBTUja83X3nM7vSh5MBscqWfaYWrmk6ZBx1PKkNfzsDDKO/HBK9vdxZPVZfLyjVhf2klsB7NFVk1/kHlCL+ZVQEfB/uyH/jtqI+Ezm7VjvJFRahkc53tdrGCaO0374VUo2Oj6vyRF8F0XM9br0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=CxnXxHYZ; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22359001f1aso111368085ad.3
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 14:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741042395; x=1741647195; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SSJ9VliM2a+aTryqldG0CH+Q28sfdpKDs8cwc/DPQU0=;
        b=CxnXxHYZW+6+02UjXEd/W0U3wCrXSGBHe5FKWLIm7dbBruAZmKN6C9dcX/tu1NQY1q
         BprpyoGcQRYAEtF1KCEIJEt4EwqZ1Uyl06fgk03q1ZyLs4Jlyu4iwKwEwtlyjoHLFupM
         tr82bZmHNAJdXI2LQM+XN5S0pvMSJ9ALGN9YmyJr2nNjaC823i5J6eu3cWm4T6bNCy2q
         RVMEiEabtG4vcf/MjHC2zkscNo57KM0H47wL39B27hvQ2YJ2TUOfvx2SNXuNVT4W763J
         2GsHMK4iZ04DL+69CXkaDHcGReLSyRKfeYGNplNSrSeG3u0GXR2vATY+w/GlDVFZ4I9Y
         BauQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741042395; x=1741647195;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SSJ9VliM2a+aTryqldG0CH+Q28sfdpKDs8cwc/DPQU0=;
        b=luSSMMbchsHHH98JfM/rwtHVXq3bjDsRSKxzyBmuYkH7uVc2GxDKpr8/j6GwTqHPVK
         YU5/DixepPiDog4PxiqTQijdnNnak4+tG99ws0ACbkmuHOMxYCbl6eAkX/8KeE1qAkcV
         m8q33otjyeWucHJWuC/RDF7TN8nZxD8dQBDoXliMMuoOxy+g/H+V464AHlz/09DsVI2O
         FzDjjtgctqpX3tg4ISFIYBCH4bn0RCECOltZifrkjExjPTf5f8tAixmLPtLP4k3CONnl
         OxkHrvt3k8frWbHhdQx6wJGktp52MAkeOVnnrHJV3pwyXQUB9/HLgyJzi4LImfmb2PVM
         b4iA==
X-Gm-Message-State: AOJu0YzOQqzMl4GITRhtSDRL3TSFDpCJOhj8HqUYpeuvMdCvXSwMrwAm
	odBDtz/ryXvMwUzR68QARp0P8Cts7ie5s/G5mbst+U6zzbUoT19YlU3a5z2kfhA=
X-Gm-Gg: ASbGnctns7a+ysJUBOPQ0flOJ9LpqvJ5JQFfK/8rFOfhNGbgbXeSz7g2d53jreP+e61
	ogbu5Zs8HOti6sE3VQVi14X2WVz3u1N79sGqafXtUZTEndRkotvBblEx/oR35/b5KLisQq3rYVT
	S5aU38pYeMiHMeY9ZTIzb+EFKahdDcjmaJSMaa8X+uVATppl+7I9VWZF337+kZAVVIEss1pQ+oF
	LS12oi50NOmd/0eQ7MCEhauChy/3cV0Ypm3l4ZL/tvfZJIcd2LuJO2YCBkooojJk7iXOshMeXsN
	etzE1S1dfkIAlNB8NT1SkiZ+XCdpA5DAPy7oPxQkN+3bi9Sw8lVhVQUSNA==
X-Google-Smtp-Source: AGHT+IFgJxk7LwSBEIbBrY7Dr1CLOJZk/TMcnbzG8visvcRF+/r9iXWzrvGMz6kqm+x+c1jOver7mQ==
X-Received: by 2002:a05:6a00:244d:b0:736:5504:e8af with SMTP id d2e1a72fcca58-7365504e9edmr9350148b3a.24.1741042395376;
        Mon, 03 Mar 2025 14:53:15 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-734a003eb4fsm9440601b3a.129.2025.03.03.14.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 14:53:15 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 03 Mar 2025 14:53:08 -0800
Subject: [PATCH v2 3/4] KVM: riscv: selftests: Change command line option
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250303-kvm_pmu_improve-v2-3-41d177e45929@rivosinc.com>
References: <20250303-kvm_pmu_improve-v2-0-41d177e45929@rivosinc.com>
In-Reply-To: <20250303-kvm_pmu_improve-v2-0-41d177e45929@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

The PMU test commandline option takes an argument to disable a
certain test. The initial assumption behind this was a common use case
is just to run all the test most of the time. However, running a single
test seems more useful instead. Especially, the overflow test has been
helpful to validate PMU virtualizaiton interrupt changes.

Switching the command line option to run a single test instead
of disabling a single test also allows to provide additional
test specific arguments to the test. The default without any options
remains unchanged which continues to run all the tests.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c | 40 +++++++++++++++---------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
index 284bc80193bd..de66099235d9 100644
--- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
+++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
@@ -39,7 +39,11 @@ static bool illegal_handler_invoked;
 #define SBI_PMU_TEST_SNAPSHOT	BIT(2)
 #define SBI_PMU_TEST_OVERFLOW	BIT(3)
 
-static int disabled_tests;
+struct test_args {
+	int disabled_tests;
+};
+
+static struct test_args targs;
 
 unsigned long pmu_csr_read_num(int csr_num)
 {
@@ -604,7 +608,11 @@ static void test_vm_events_overflow(void *guest_code)
 	vcpu_init_vector_tables(vcpu);
 	/* Initialize guest timer frequency. */
 	timer_freq = vcpu_get_reg(vcpu, RISCV_TIMER_REG(frequency));
+
+	/* Export the shared variables to the guest */
 	sync_global_to_guest(vm, timer_freq);
+	sync_global_to_guest(vm, vcpu_shared_irq_count);
+	sync_global_to_guest(vm, targs);
 
 	run_vcpu(vcpu);
 
@@ -613,28 +621,30 @@ static void test_vm_events_overflow(void *guest_code)
 
 static void test_print_help(char *name)
 {
-	pr_info("Usage: %s [-h] [-d <test name>]\n", name);
-	pr_info("\t-d: Test to disable. Available tests are 'basic', 'events', 'snapshot', 'overflow'\n");
+	pr_info("Usage: %s [-h] [-t <test name>]\n", name);
+	pr_info("\t-t: Test to run (default all). Available tests are 'basic', 'events', 'snapshot', 'overflow'\n");
 	pr_info("\t-h: print this help screen\n");
 }
 
 static bool parse_args(int argc, char *argv[])
 {
 	int opt;
-
-	while ((opt = getopt(argc, argv, "hd:")) != -1) {
+	int temp_disabled_tests = SBI_PMU_TEST_BASIC | SBI_PMU_TEST_EVENTS | SBI_PMU_TEST_SNAPSHOT |
+				  SBI_PMU_TEST_OVERFLOW;
+	while ((opt = getopt(argc, argv, "ht:")) != -1) {
 		switch (opt) {
-		case 'd':
+		case 't':
 			if (!strncmp("basic", optarg, 5))
-				disabled_tests |= SBI_PMU_TEST_BASIC;
+				temp_disabled_tests &= ~SBI_PMU_TEST_BASIC;
 			else if (!strncmp("events", optarg, 6))
-				disabled_tests |= SBI_PMU_TEST_EVENTS;
+				temp_disabled_tests &= ~SBI_PMU_TEST_EVENTS;
 			else if (!strncmp("snapshot", optarg, 8))
-				disabled_tests |= SBI_PMU_TEST_SNAPSHOT;
+				temp_disabled_tests &= ~SBI_PMU_TEST_SNAPSHOT;
 			else if (!strncmp("overflow", optarg, 8))
-				disabled_tests |= SBI_PMU_TEST_OVERFLOW;
+				temp_disabled_tests &= ~SBI_PMU_TEST_OVERFLOW;
 			else
 				goto done;
+			targs.disabled_tests = temp_disabled_tests;
 			break;
 		case 'h':
 		default:
@@ -650,25 +660,27 @@ static bool parse_args(int argc, char *argv[])
 
 int main(int argc, char *argv[])
 {
+	targs.disabled_tests = 0;
+
 	if (!parse_args(argc, argv))
 		exit(KSFT_SKIP);
 
-	if (!(disabled_tests & SBI_PMU_TEST_BASIC)) {
+	if (!(targs.disabled_tests & SBI_PMU_TEST_BASIC)) {
 		test_vm_basic_test(test_pmu_basic_sanity);
 		pr_info("SBI PMU basic test : PASS\n");
 	}
 
-	if (!(disabled_tests & SBI_PMU_TEST_EVENTS)) {
+	if (!(targs.disabled_tests & SBI_PMU_TEST_EVENTS)) {
 		test_vm_events_test(test_pmu_events);
 		pr_info("SBI PMU event verification test : PASS\n");
 	}
 
-	if (!(disabled_tests & SBI_PMU_TEST_SNAPSHOT)) {
+	if (!(targs.disabled_tests & SBI_PMU_TEST_SNAPSHOT)) {
 		test_vm_events_snapshot_test(test_pmu_events_snaphost);
 		pr_info("SBI PMU event verification with snapshot test : PASS\n");
 	}
 
-	if (!(disabled_tests & SBI_PMU_TEST_OVERFLOW)) {
+	if (!(targs.disabled_tests & SBI_PMU_TEST_OVERFLOW)) {
 		test_vm_events_overflow(test_pmu_events_overflow);
 		pr_info("SBI PMU event verification with overflow test : PASS\n");
 	}

-- 
2.43.0


