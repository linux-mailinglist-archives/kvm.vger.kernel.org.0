Return-Path: <kvm+bounces-39404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 008C7A46C60
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:26:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0905F3AD34A
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 665B125E451;
	Wed, 26 Feb 2025 20:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="jQh2RCUk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2FA25D521
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 20:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740601518; cv=none; b=iKl+NoEGaTMRMNcXQ+L2DyvstrdTAHlFB5oUXaOVh8ys5FCiAzTu34LTYGQK0kifLHqUwzN26/jjxgOjfkK3H0UVkbyQwVg2wf6X75+R9GCVwasmGZVsF78ZPWKVnKS9Y31nsn5A9UejmeNHSwRi8UKT/C6cyEXcr+wzQ0uUk5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740601518; c=relaxed/simple;
	bh=60wxU0lkF9ES7Q2Y1xRG0c1Mze/bj/KB7bV531P/zP8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=k7BRgs4S7DjPqb/upDRmGDFz/JY5Zy799bhiR2Vdr8CfJnRWHtgoaaSNaddxqGpV5JlTNKHIzWe67x5bYYIyXgmRQOqHkGydGCamFLHCANHZAlbBlHebnK9FVwBhyevP97YDVRULnH6SltLOaQDcHq2oaRYwXs9E1JgZQN8CAL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=jQh2RCUk; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22328dca22fso2348305ad.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 12:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1740601514; x=1741206314; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K+xf5rb3O3ZrwcS1pmKysmwXefhXbLuGjQJfAu9gHOI=;
        b=jQh2RCUkMktFEZfucqbsRKlUqXy3ySCsKrij1MvceFCF9AKTip/2M8+Z/TrZhGc5xV
         OI8V/eSdPtEgZP1jaz8FI1+4mGffnWv0yJesWBHnNQl3y7M2z7BwrqiUtXoG0Zz/+y7D
         Eb2U2yIjPFmt/Y9df93LdHK/ixYNHQjjT2tddfvqP9vgRLFehQ+yFfjBGwcODwZuF/nB
         urD5L0jjR8JVJ3GeP1KStQxy+8iP6zsU4uDw9vRXmQCFnDUPxZ59ba73PUKmD4bwcfLf
         YLjGUMssmv/JChM1rnL2v3LxXqiOhXH0SEF9RNL0OBfN4qLqfT+UCShgDylR7+fWc2ui
         vtvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740601514; x=1741206314;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K+xf5rb3O3ZrwcS1pmKysmwXefhXbLuGjQJfAu9gHOI=;
        b=AX2dr+GN3mQeUeK94rHjf2gDxgYNkc47oNsBpkGIPSb9Q52TL0GYE5qrGfGooriSTk
         Wo4CEac1Rx3OtqlU7eM4v5sWs22KlQfLcFpYloL7c7IfZn60q4b32qet9f24fNJP5UwM
         /7UqFKTmIFFfcAt3oRjIpF3D4UrjJbAfkLZHaIlYtPzfr5Glx2HCG07c4TGWi4x9YxLs
         yw+SE2QN+vmvAn4ODb9h5ORYPsjB7i7Q35XlEWvb27Ko+sz6nQbnenF/I8HsffO/qZ8E
         qzbG/xcnybItgHLpp4SGIipVy81aXWW0oLbASG6ovsWgUNxzViZTc2fvSRXO3aOZnjbt
         H80g==
X-Gm-Message-State: AOJu0Yyb9GWABQrbfZT7UD0NQFexPCGy8kPcjNs377bxAcXlc1x3ew+n
	2KvWVc0yTBG37PiS+/yIesPg2fdcGlJuQhxRmWQl5xBWGtDwDtcRbhSYSohK0YU=
X-Gm-Gg: ASbGncvqpeQ1QxZ6LAG2nhawc8ZMlgKv0bZCGV3RRPxKKsss0gI+rYjMckKrhT8uzeF
	rw8EDE0qQSCXIFjghWkKHr+DNOJ1XtTltYF7OOUhDCyrBTOIO8gQBDkutUl43qYSZGIoi3xvYn5
	th0LJmyoVE5FPZqWpUsN+SAEwHb2z8tld41x9g6awpz7ohCne6vd5P9IZ4TsWtaKuIVGirwdVYf
	+1iuiopsvgay9vEDcEITtbXmFKyZ/cwb6jYcWD11naS+lvj4Vokodu6101eQ/d1MZzpZmy9MOKk
	bnOHX7e48V8uYd8jxxTEfheZ3bzKb2WFpH10sCA=
X-Google-Smtp-Source: AGHT+IHw0vBB+PSny2qMliUf6DTVa+ZvGcPh/rPnK0tt+c9UR1fNAKJeSn8VDRagyarmbZCnK8Ejgg==
X-Received: by 2002:a05:6a00:a26:b0:72d:3b2e:fef9 with SMTP id d2e1a72fcca58-734791aa184mr14536500b3a.20.1740601514558;
        Wed, 26 Feb 2025 12:25:14 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7347a7f7de2sm4100963b3a.106.2025.02.26.12.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 12:25:14 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 26 Feb 2025 12:25:06 -0800
Subject: [PATCH 4/4] KVM: riscv: selftests: Allow number of interrupts to
 be configurable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250226-kvm_pmu_improve-v1-4-74c058c2bf6d@rivosinc.com>
References: <20250226-kvm_pmu_improve-v1-0-74c058c2bf6d@rivosinc.com>
In-Reply-To: <20250226-kvm_pmu_improve-v1-0-74c058c2bf6d@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

It is helpful to vary the number of the LCOFI interrupts generated
by the overflow test. Allow additional argument for overflow test
to accommodate that. It can be easily cross-validated with
/proc/interrupts output in the host.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c | 36 ++++++++++++++++++++----
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
index 533b76d0de82..7c273a1adb17 100644
--- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
+++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
@@ -39,8 +39,10 @@ static bool illegal_handler_invoked;
 #define SBI_PMU_TEST_SNAPSHOT	BIT(2)
 #define SBI_PMU_TEST_OVERFLOW	BIT(3)
 
+#define SBI_PMU_OVERFLOW_IRQNUM_DEFAULT 5
 struct test_args {
 	int disabled_tests;
+	int overflow_irqnum;
 };
 
 static struct test_args targs;
@@ -478,7 +480,7 @@ static void test_pmu_events_snaphost(void)
 
 static void test_pmu_events_overflow(void)
 {
-	int num_counters = 0;
+	int num_counters = 0, i = 0;
 
 	/* Verify presence of SBI PMU and minimum requrired SBI version */
 	verify_sbi_requirement_assert();
@@ -495,11 +497,15 @@ static void test_pmu_events_overflow(void)
 	 * Qemu supports overflow for cycle/instruction.
 	 * This test may fail on any platform that do not support overflow for these two events.
 	 */
-	test_pmu_event_overflow(SBI_PMU_HW_CPU_CYCLES);
-	GUEST_ASSERT_EQ(vcpu_shared_irq_count, 1);
+	for (i = 0; i < targs.overflow_irqnum; i++)
+		test_pmu_event_overflow(SBI_PMU_HW_CPU_CYCLES);
+	GUEST_ASSERT_EQ(vcpu_shared_irq_count, targs.overflow_irqnum);
+
+	vcpu_shared_irq_count = 0;
 
-	test_pmu_event_overflow(SBI_PMU_HW_INSTRUCTIONS);
-	GUEST_ASSERT_EQ(vcpu_shared_irq_count, 2);
+	for (i = 0; i < targs.overflow_irqnum; i++)
+		test_pmu_event_overflow(SBI_PMU_HW_INSTRUCTIONS);
+	GUEST_ASSERT_EQ(vcpu_shared_irq_count, targs.overflow_irqnum);
 
 	GUEST_DONE();
 }
@@ -621,8 +627,11 @@ static void test_vm_events_overflow(void *guest_code)
 
 static void test_print_help(char *name)
 {
-	pr_info("Usage: %s [-h] [-t <test name>]\n", name);
+	pr_info("Usage: %s [-h] [-t <test name>] [-n <number of LCOFI interrupt for overflow test>]\n",
+		name);
 	pr_info("\t-t: Test to run (default all). Available tests are 'basic', 'events', 'snapshot', 'overflow'\n");
+	pr_info("\t-n: Number of LCOFI interrupt to trigger for each event in overflow test (default: %d)\n",
+		SBI_PMU_OVERFLOW_IRQNUM_DEFAULT);
 	pr_info("\t-h: print this help screen\n");
 }
 
@@ -631,6 +640,8 @@ static bool parse_args(int argc, char *argv[])
 	int opt;
 	int temp_disabled_tests = SBI_PMU_TEST_BASIC | SBI_PMU_TEST_EVENTS | SBI_PMU_TEST_SNAPSHOT |
 				  SBI_PMU_TEST_OVERFLOW;
+	int overflow_interrupts = -1;
+
 	while ((opt = getopt(argc, argv, "h:t:n:")) != -1) {
 		switch (opt) {
 		case 't':
@@ -646,12 +657,24 @@ static bool parse_args(int argc, char *argv[])
 				goto done;
 			targs.disabled_tests = temp_disabled_tests;
 			break;
+		case 'n':
+			overflow_interrupts = atoi_positive("Number of LCOFI", optarg);
+			break;
 		case 'h':
 		default:
 			goto done;
 		}
 	}
 
+	if (overflow_interrupts > 0) {
+		if (targs.disabled_tests & SBI_PMU_TEST_OVERFLOW) {
+			pr_info("-n option is only available for overflow test\n");
+			goto done;
+		} else {
+			targs.overflow_irqnum = overflow_interrupts;
+		}
+	}
+
 	return true;
 done:
 	test_print_help(argv[0]);
@@ -661,6 +684,7 @@ static bool parse_args(int argc, char *argv[])
 int main(int argc, char *argv[])
 {
 	targs.disabled_tests = 0;
+	targs.overflow_irqnum = SBI_PMU_OVERFLOW_IRQNUM_DEFAULT;
 
 	if (!parse_args(argc, argv))
 		exit(KSFT_SKIP);

-- 
2.43.0


