Return-Path: <kvm+bounces-14201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64BD48A04B8
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 02:16:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF76B1F24A72
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 00:16:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39A714AEE0;
	Thu, 11 Apr 2024 00:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="TBjUQA70"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B457A47A40
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 00:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712794154; cv=none; b=IHYJQoJKm6G5pCat0lELcBhmExrsqkd4hlpOPAC+xSzPJagtKrY+WWufI3bB82N+yXhnDa47wiLapWbvLo+6F4OvVX/HANiwIGN8ly8VZqMbnaMwB27DvySxSXIC2X+jP2U4awxyKVh1JnAhtQwOv+RhChb2Peh0U59Dt8Hhvf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712794154; c=relaxed/simple;
	bh=FfM/sSt5pOIT+SFPpfrQ5W4Ri7Uq0XA+YsWN/Asw1ro=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UvWBADwVb0DDRnse9OCgOqQ2Pu6UTP/n9fZjQeYq4G08SH74VBYTtuCrRFg86tArOiBgCn51VDovZRLYs2f9j1M3jyitqRg+h6/wfDrpp+TlBKc+X+H0ZjGe/jshiXXNd7DUazfAu+YFtud0qjQbq7ujc67rndYLfyg3qVFIHNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=TBjUQA70; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1e4266673bbso34130505ad.2
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 17:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712794152; x=1713398952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tLia834y+X9tlrjVFjCEV4aQslhHW6gNjSHeO9Lbrys=;
        b=TBjUQA70mwDw0vXwlIW1zTAH6wGuKf/aTmWR7uOtf49GfERAOPdkrya+yz1GnqVcsC
         Ou5tFh72f2wSX0+f7Fr07KDiyeizacH0EApUq+5IZJQ5eRCxrvAUpPJ1zVipcb35VCGm
         VE/n+7rEojiHcBd6/pdIieyTOE4+EoGj8uyo6MsPt6gFqVNfP9FMYiYae5uV/8CdifD9
         f/Xn4Ofa/UTqPwWGN0f8ra/6hTAJC1guQ1cUwZJU9FuQ9hhb8WhwBUGQ6O0dXTeEq2sk
         4X0WKHZ2dlOuSO4rR4uwyB1/45biDzDybLwLbompsmXjOeatAee1Fx0B7RtSA6NQ61Jg
         Hlaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712794152; x=1713398952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tLia834y+X9tlrjVFjCEV4aQslhHW6gNjSHeO9Lbrys=;
        b=X8LsyhK2RsbVnwBwKTfwGNW56Cqjmipn4GCzOl1rADdmc/NmBQGIkESDraVBBAu0Lo
         jKd6GJiRuTtbZ+fr0lxNzw44hy8RBfzDepebZO4+bsujyQ0PW4biqMJqdaqylJJu9+hT
         xVfbdF/MN0pV+x2TiG5FS4vpz4U7IANxF+QMBuDtfa0VZqAUtTDmK58cKlhpdIqQNrA3
         DcWLjbt6v3pzecVxF6IBuOO77LMAbzwg11/uYI4tguUQO+PculozKUVOMchRFjCuf/N/
         smi7MsoW4Y6OJJ/DxQh/3GkZVL7j+W4HSfj/zO6fsMDnbyWnzPBC00EGOA0nx6hDQCKz
         Eegg==
X-Forwarded-Encrypted: i=1; AJvYcCUlqKXWODnCFwxBBEhz9+wu9/aZXMzsEtPsn6OxLkqhv0IawMJQxqTdwfZ/G/pG14hnb5k1FQ/bCHjUR/NgkH3IUmsr
X-Gm-Message-State: AOJu0Yz2rR3VNGTJyywojvQgVXiJNcd9D37+I6JzwjU1ccHyeoz4n1tH
	RlftAa3dAb4fboaL4A3NVRb/azBN7IVzr07/cB5JxTVexDwkF3cBYgRbbn0MlLc=
X-Google-Smtp-Source: AGHT+IEBm3O3QxbfldIjrwscHpX7a8J2zp8FjCH5WuQpHu2gdn7/EG4AoSaaS2YDQBteQAhuqRWwog==
X-Received: by 2002:a17:902:eb88:b0:1e5:5559:c4a7 with SMTP id q8-20020a170902eb8800b001e55559c4a7mr85239plg.51.1712794152327;
        Wed, 10 Apr 2024 17:09:12 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id f7-20020a170902684700b001e3d8a70780sm130351pln.171.2024.04.10.17.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 17:09:11 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Alexey Makhalov <alexey.amakhalov@broadcom.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
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
Subject: [PATCH v6 24/24] KVM: riscv: selftests: Add commandline option for SBI PMU test
Date: Wed, 10 Apr 2024 17:07:52 -0700
Message-Id: <20240411000752.955910-25-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240411000752.955910-1-atishp@rivosinc.com>
References: <20240411000752.955910-1-atishp@rivosinc.com>
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

The commandline option allows user to disable particular test if they
want to.

Suggested-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 .../selftests/kvm/riscv/sbi_pmu_test.c        | 77 ++++++++++++++++---
 1 file changed, 68 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
index 0fd9b76ae838..57025b07a403 100644
--- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
+++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
@@ -33,6 +33,16 @@ static unsigned long counter_mask_available;
 
 static bool illegal_handler_invoked;
 
+enum sbi_pmu_test_id {
+	SBI_PMU_TEST_BASIC = 0,
+	SBI_PMU_TEST_EVENTS,
+	SBI_PMU_TEST_SNAPSHOT,
+	SBI_PMU_TEST_OVERFLOW,
+	SBI_PMU_TEST_MAX,
+};
+
+static int disabled_test_id = SBI_PMU_TEST_MAX;
+
 unsigned long pmu_csr_read_num(int csr_num)
 {
 #define switchcase_csr_read(__csr_num, __val)		{\
@@ -608,19 +618,68 @@ static void test_vm_events_overflow(void *guest_code)
 	test_vm_destroy(vm);
 }
 
-int main(void)
+static void test_print_help(char *name)
 {
-	test_vm_basic_test(test_pmu_basic_sanity);
-	pr_info("SBI PMU basic test : PASS\n");
+	pr_info("Usage: %s [-h] [-d <test name>]\n", name);
+	pr_info("\t-d: Test to disable. Available tests are 'basic', 'events', 'snapshot', 'overflow'\n");
+	pr_info("\t-h: print this help screen\n");
+}
 
-	test_vm_events_test(test_pmu_events);
-	pr_info("SBI PMU event verification test : PASS\n");
+static bool parse_args(int argc, char *argv[])
+{
+	int opt;
+
+	while ((opt = getopt(argc, argv, "hd:")) != -1) {
+		switch (opt) {
+		case 'd':
+			if (!strncmp("basic", optarg, 5))
+				disabled_test_id = SBI_PMU_TEST_BASIC;
+			else if (!strncmp("events", optarg, 6))
+				disabled_test_id = SBI_PMU_TEST_EVENTS;
+			else if (!strncmp("snapshot", optarg, 8))
+				disabled_test_id = SBI_PMU_TEST_SNAPSHOT;
+			else if (!strncmp("overflow", optarg, 8))
+				disabled_test_id = SBI_PMU_TEST_OVERFLOW;
+			else
+				goto done;
+			break;
+		break;
+		case 'h':
+		default:
+			goto done;
+		}
+	}
 
-	test_vm_events_snapshot_test(test_pmu_events_snaphost);
-	pr_info("SBI PMU event verification with snapshot test : PASS\n");
+	return true;
+done:
+	test_print_help(argv[0]);
+	return false;
+}
 
-	test_vm_events_overflow(test_pmu_events_overflow);
-	pr_info("SBI PMU event verification with overflow test : PASS\n");
+int main(int argc, char *argv[])
+{
+	if (!parse_args(argc, argv))
+		exit(KSFT_SKIP);
+
+	if (disabled_test_id != SBI_PMU_TEST_BASIC) {
+		test_vm_basic_test(test_pmu_basic_sanity);
+		pr_info("SBI PMU basic test : PASS\n");
+	}
+
+	if (disabled_test_id != SBI_PMU_TEST_EVENTS) {
+		test_vm_events_test(test_pmu_events);
+		pr_info("SBI PMU event verification test : PASS\n");
+	}
+
+	if (disabled_test_id != SBI_PMU_TEST_SNAPSHOT) {
+		test_vm_events_snapshot_test(test_pmu_events_snaphost);
+		pr_info("SBI PMU event verification with snapshot test : PASS\n");
+	}
+
+	if (disabled_test_id != SBI_PMU_TEST_OVERFLOW) {
+		test_vm_events_overflow(test_pmu_events_overflow);
+		pr_info("SBI PMU event verification with overflow test : PASS\n");
+	}
 
 	return 0;
 }
-- 
2.34.1


