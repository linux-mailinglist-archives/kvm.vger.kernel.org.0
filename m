Return-Path: <kvm+bounces-15405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F04F8AB7EE
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 01:55:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9DCC2817E4
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 23:55:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61CEA1420B3;
	Fri, 19 Apr 2024 23:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="S9lTXw39"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A48152E15
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 23:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713570510; cv=none; b=E9PGxOdBP412mu0D3MNwvbCFyoSyd+hNO2BMNXTGCXJ8MgoIe1zYxX6uJCcfYEji+S5PBR0Lrsrkj2gJ1/j37y+34gjvvu9yPnnURpHi3dQJgvQerGskct3/vBOuBhT9b8BVUrYVlrMKgUIvuYqkXDUu0KSfLOPvqYWqE60/s4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713570510; c=relaxed/simple;
	bh=4h0IzOtLBFbHmqIztYQtJnRQ5i+JxAIa21rlgcy6DFI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nkrjnh7yeYQAkJ5XC+oVmCu6zZaSQKXsUeih7Pcj6hJ7HdOsJpVmNAvDpaEeinS6DOn8mdX6CqU9x7Xl5w/bmTLy3jNTBLzZKCBs1NT5T5ItUO6WvqoGzItJxLywFPSTCfc48XPq7luQeDgGCUg/HgrkM3PbAKNkhOUBqFPh8gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=S9lTXw39; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1e5aa82d1f6so23016595ad.0
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713570508; x=1714175308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k8dppvgVnh54sEjPJluz+VPGn0XVIgbI5aDFYcuHKMk=;
        b=S9lTXw39LqEF6q16IzNx8R7TGXeFz2KodnuHcBXAzMzZclaSiFVpNmZT0akpKoNXOd
         pbiLhQEzyY91u+DP/AMKmVuC5DyOD6HAN7SJK0wQ0KeyBbPNqz6VvSO2MN5FUDgc8RNS
         kUsqyPq4EPqk+HrE84H5P7xY41dYb886gi7i3yXYZ2CrRyfQqNJWul+faTz1aaLsmce0
         dnexzjx2xZVqrHA+FnFXwr2ldWm8iEgEILEFrCNmTabkVEvVd3SX8Sf5RTp4S/vtpzUh
         c1oVy+/gZ+AmxhYZcc/u+y4YtmROB9JPB4jeBOENbJA5lEAJV2rcxSU309TcvCvj3Sq2
         2aIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713570508; x=1714175308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k8dppvgVnh54sEjPJluz+VPGn0XVIgbI5aDFYcuHKMk=;
        b=AMqYVKj0fFkFC2WTCFAWJypkdylpMgePN9NtfoWdouhpQtQ3ElWc0VtXnsKJ/tUbRI
         rO5NFEKWfSWgRwHb2XilI9y0bsyXrYcYgfEXujkw/BMUckyhzMq3c4JYoB2Rdr6P3qTF
         TgYtX6s0E6A0GRZbBZLviPQIaYNgWVcuOtAGACyTHWwpnU14cxFjrDuauotbbqAFk5SH
         icCvsDEmwT2Vp2fdQ++IG0ONSx16Il7Amq0AVvH5TjrEapQPZ0gaqKeYB3h2Ctr0LHKj
         Lg2XwUW0u6v++KFUHT2Z6F0fSFevIiezVJPwm5uPKlAtxd6MOO4QKyO/gP8lGICL8bG+
         DXcg==
X-Forwarded-Encrypted: i=1; AJvYcCW1uiwyI822w34UrHJ3kHkjcQZbSpcSCs11szaGNnqAslPeHfWUCqF8QE+aGSYZL6LTZVcec4J+P0WfQmSHJdqYKk7Z
X-Gm-Message-State: AOJu0YwMpQQ3GXV0k8DpskByQoEegjB4HB0PxMEJ873lb4S0wK2737hh
	5jv8IEkIJxrAP0BgCVu3mBPBrOOuseIpAUnsUZdWQee/13eV9kJSs7T05ikIPjg=
X-Google-Smtp-Source: AGHT+IHbjuIAogidEThPU7h7cHQTwDfEmDJ2h82WDXmnVpxSpsttceYeTWH4EZKWjzfHpnNFMkjLQg==
X-Received: by 2002:a17:903:41ca:b0:1e0:9964:76f4 with SMTP id u10-20020a17090341ca00b001e0996476f4mr5588251ple.14.1713570508238;
        Fri, 19 Apr 2024 16:48:28 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id w17-20020a170902d11100b001e42f215f33sm3924017plw.85.2024.04.19.16.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 16:48:27 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	samuel.holland@sifive.com,
	Conor Dooley <conor.dooley@microchip.com>,
	Juergen Gross <jgross@suse.com>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Shuah Khan <shuah@kernel.org>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	x86@kernel.org
Subject: [PATCH v8 24/24] KVM: riscv: selftests: Add commandline option for SBI PMU test
Date: Sat, 20 Apr 2024 08:17:40 -0700
Message-Id: <20240420151741.962500-25-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240420151741.962500-1-atishp@rivosinc.com>
References: <20240420151741.962500-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SBI PMU test comprises of multiple tests and user may want to run
only a subset depending on the platform. The most common case would
be to run all to validate all the tests. However, some platform may
not support all events or all ISA extensions.

The commandline option allows user to disable any set of tests if
they want to.

Suggested-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 .../selftests/kvm/riscv/sbi_pmu_test.c        | 73 ++++++++++++++++---
 1 file changed, 64 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
index 0fd9b76ae838..69bb94e6b227 100644
--- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
+++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
@@ -33,6 +33,13 @@ static unsigned long counter_mask_available;
 
 static bool illegal_handler_invoked;
 
+#define SBI_PMU_TEST_BASIC	BIT(0)
+#define SBI_PMU_TEST_EVENTS	BIT(1)
+#define SBI_PMU_TEST_SNAPSHOT	BIT(2)
+#define SBI_PMU_TEST_OVERFLOW	BIT(3)
+
+static int disabled_tests;
+
 unsigned long pmu_csr_read_num(int csr_num)
 {
 #define switchcase_csr_read(__csr_num, __val)		{\
@@ -608,19 +615,67 @@ static void test_vm_events_overflow(void *guest_code)
 	test_vm_destroy(vm);
 }
 
-int main(void)
+static void test_print_help(char *name)
+{
+	pr_info("Usage: %s [-h] [-d <test name>]\n", name);
+	pr_info("\t-d: Test to disable. Available tests are 'basic', 'events', 'snapshot', 'overflow'\n");
+	pr_info("\t-h: print this help screen\n");
+}
+
+static bool parse_args(int argc, char *argv[])
+{
+	int opt;
+
+	while ((opt = getopt(argc, argv, "hd:")) != -1) {
+		switch (opt) {
+		case 'd':
+			if (!strncmp("basic", optarg, 5))
+				disabled_tests |= SBI_PMU_TEST_BASIC;
+			else if (!strncmp("events", optarg, 6))
+				disabled_tests |= SBI_PMU_TEST_EVENTS;
+			else if (!strncmp("snapshot", optarg, 8))
+				disabled_tests |= SBI_PMU_TEST_SNAPSHOT;
+			else if (!strncmp("overflow", optarg, 8))
+				disabled_tests |= SBI_PMU_TEST_OVERFLOW;
+			else
+				goto done;
+			break;
+		case 'h':
+		default:
+			goto done;
+		}
+	}
+
+	return true;
+done:
+	test_print_help(argv[0]);
+	return false;
+}
+
+int main(int argc, char *argv[])
 {
-	test_vm_basic_test(test_pmu_basic_sanity);
-	pr_info("SBI PMU basic test : PASS\n");
+	if (!parse_args(argc, argv))
+		exit(KSFT_SKIP);
+
+	if (!(disabled_tests & SBI_PMU_TEST_BASIC)) {
+		test_vm_basic_test(test_pmu_basic_sanity);
+		pr_info("SBI PMU basic test : PASS\n");
+	}
 
-	test_vm_events_test(test_pmu_events);
-	pr_info("SBI PMU event verification test : PASS\n");
+	if (!(disabled_tests & SBI_PMU_TEST_EVENTS)) {
+		test_vm_events_test(test_pmu_events);
+		pr_info("SBI PMU event verification test : PASS\n");
+	}
 
-	test_vm_events_snapshot_test(test_pmu_events_snaphost);
-	pr_info("SBI PMU event verification with snapshot test : PASS\n");
+	if (!(disabled_tests & SBI_PMU_TEST_SNAPSHOT)) {
+		test_vm_events_snapshot_test(test_pmu_events_snaphost);
+		pr_info("SBI PMU event verification with snapshot test : PASS\n");
+	}
 
-	test_vm_events_overflow(test_pmu_events_overflow);
-	pr_info("SBI PMU event verification with overflow test : PASS\n");
+	if (!(disabled_tests & SBI_PMU_TEST_OVERFLOW)) {
+		test_vm_events_overflow(test_pmu_events_overflow);
+		pr_info("SBI PMU event verification with overflow test : PASS\n");
+	}
 
 	return 0;
 }
-- 
2.34.1


