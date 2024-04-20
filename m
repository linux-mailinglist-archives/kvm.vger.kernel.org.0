Return-Path: <kvm+bounces-15402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D94E68AB7E4
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 01:54:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09CAD1C20920
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 23:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 115AD152539;
	Fri, 19 Apr 2024 23:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="V5BSCgK0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C28014F9E5
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 23:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713570506; cv=none; b=QCltPpvSpvOYS+UPp0SNlyj318O6XZhehYeUqre9aMaem2fsPL4jbGVJEGQsMQbjqxtEC0SrMf2KhO7XZTMdd45G84kFE1KtNqq3zHEICDOkHszE4/D21uyaP3+2FgIrtrCc13nZKFMHl4L90MThX+UlXqnFvoCNw9ESO1ShzMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713570506; c=relaxed/simple;
	bh=CDNvwVDvGBWT+u8SvxT/JwIFcLRYFszHT9KKdmrrLd8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZWdpvMakbSCVbYhwo44C5WzCJjQgHjtQq8cLo5OCiNbQSAV1lJnT4adB2liT7Hdm4PqVWpclC+6pE+C0XqftyDjTREuPCfSBsENEnohHivRsF211pNvPDS2KUk1UrduH2uY6aTs0ORRqSmhN6qzIXZKq3N5UKfgcHlfk3fFEoJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=V5BSCgK0; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1e2b137d666so20996815ad.2
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713570503; x=1714175303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tJAThzhHQGnWs81W5HgHaocJpD0YqpVCwOX9M1CBRIE=;
        b=V5BSCgK0xvuQJveql96ksmfbg23DYbGh3r+UkAVxf3Hr6elkgIEwYL/9x2WxmEcxgD
         TOVGKo2KNRc8ATDZ8wbkLtqxidZCLi5/Enj88nyuIzWvgi+wwvGoNQ9/LjWmZMlBAPh9
         HwJECRZCEllD3upXOu6IGZtVKOTgKvQYzEK32Lz2Z8q5xgatyKKdsqje422JQLNHOqUt
         g/jC4bmJz0cYkwowk2E5rO7bkrFpAFx2s/0b/Tu6vRT6s2qRppay6fZ4aAdcMVGOhTjJ
         tm2STp2gzYmr6gGnX6wl5VVdQAD1FnhmORtYPlQ9aZxH3UNgzQh1uZS6REkM3V54OipM
         FOMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713570503; x=1714175303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tJAThzhHQGnWs81W5HgHaocJpD0YqpVCwOX9M1CBRIE=;
        b=Yn5UXx4xj766rXIW3K4RfqCFvbFfd4aQUQu5o9VFELIwePhYe0R8LmLP0kROt8nEEy
         /tpI45Pn0eo3c174Rlzg6JDi227xfopw7gYKXSVx3cKnZ7DwGsWH1PBnG2FhgRwRqu1C
         Bdsueap3SlCBBsA0nrhUQdVoG2r8B2GC4V9ubWXb1lkxcE3Vl+9hd8a/vesbpHpGCooI
         /PTOTYbKe/n4VKn8tIllTuMZOqSVpvIaZZdr/C5MLAHFdMmkuePeYOHDUuf60bgDY4EZ
         V+sUCCFKgSPcWSSAHTdyc4hgZKPINvqSUs6avguVQeM4EK+mRz31zH+bcJanIi8RabiJ
         gktg==
X-Forwarded-Encrypted: i=1; AJvYcCVRd3R72LfkjQei63EkVxVDeM7EYpkEkIP7LiG7yE7w0PBSl+GglHba3kGwMCu46Dj5hj4Aewj4CIb0fkwKlQqujhnM
X-Gm-Message-State: AOJu0Yyl80fnJGlgKNWMe3ofWrIuJN3PGye/I+vc6R6gLJyZyNDtotzP
	atllVUYo6usvxOckKU0mjF1jXrIQ43N05Ha8t8QI7D7H4YFRFzXiWv6t3AoN/Kc=
X-Google-Smtp-Source: AGHT+IFSCL5mTOxqdZaJGqzw9aMjrWiyf/vlsVUCbJjSHePTYIju0T2Gim+ribYSlJ2p22rgiQtObg==
X-Received: by 2002:a17:902:8a92:b0:1e5:378d:2f69 with SMTP id p18-20020a1709028a9200b001e5378d2f69mr3509749plo.56.1713570502940;
        Fri, 19 Apr 2024 16:48:22 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id w17-20020a170902d11100b001e42f215f33sm3924017plw.85.2024.04.19.16.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 16:48:22 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
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
Subject: [PATCH v8 21/24] KVM: riscv: selftests: Add SBI PMU selftest
Date: Sat, 20 Apr 2024 08:17:37 -0700
Message-Id: <20240420151741.962500-22-atishp@rivosinc.com>
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

This test implements basic sanity test and cycle/instret event
counting tests.

Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/riscv/sbi_pmu_test.c        | 369 ++++++++++++++++++
 2 files changed, 370 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 741c7dc16afc..1cfcd2797ee4 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -189,6 +189,7 @@ TEST_GEN_PROGS_s390x += rseq_test
 TEST_GEN_PROGS_s390x += set_memory_region_test
 TEST_GEN_PROGS_s390x += kvm_binary_stats_test
 
+TEST_GEN_PROGS_riscv += riscv/sbi_pmu_test
 TEST_GEN_PROGS_riscv += arch_timer
 TEST_GEN_PROGS_riscv += demand_paging_test
 TEST_GEN_PROGS_riscv += dirty_log_test
diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
new file mode 100644
index 000000000000..7c81691e39c5
--- /dev/null
+++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
@@ -0,0 +1,369 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * sbi_pmu_test.c - Tests the riscv64 SBI PMU functionality.
+ *
+ * Copyright (c) 2024, Rivos Inc.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include "kvm_util.h"
+#include "test_util.h"
+#include "processor.h"
+#include "sbi.h"
+
+/* Maximum counters(firmware + hardware) */
+#define RISCV_MAX_PMU_COUNTERS 64
+union sbi_pmu_ctr_info ctrinfo_arr[RISCV_MAX_PMU_COUNTERS];
+
+/* Cache the available counters in a bitmask */
+static unsigned long counter_mask_available;
+
+static bool illegal_handler_invoked;
+
+unsigned long pmu_csr_read_num(int csr_num)
+{
+#define switchcase_csr_read(__csr_num, __val)		{\
+	case __csr_num:					\
+		__val = csr_read(__csr_num);		\
+		break; }
+#define switchcase_csr_read_2(__csr_num, __val)		{\
+	switchcase_csr_read(__csr_num + 0, __val)	 \
+	switchcase_csr_read(__csr_num + 1, __val)}
+#define switchcase_csr_read_4(__csr_num, __val)		{\
+	switchcase_csr_read_2(__csr_num + 0, __val)	 \
+	switchcase_csr_read_2(__csr_num + 2, __val)}
+#define switchcase_csr_read_8(__csr_num, __val)		{\
+	switchcase_csr_read_4(__csr_num + 0, __val)	 \
+	switchcase_csr_read_4(__csr_num + 4, __val)}
+#define switchcase_csr_read_16(__csr_num, __val)	{\
+	switchcase_csr_read_8(__csr_num + 0, __val)	 \
+	switchcase_csr_read_8(__csr_num + 8, __val)}
+#define switchcase_csr_read_32(__csr_num, __val)	{\
+	switchcase_csr_read_16(__csr_num + 0, __val)	 \
+	switchcase_csr_read_16(__csr_num + 16, __val)}
+
+	unsigned long ret = 0;
+
+	switch (csr_num) {
+	switchcase_csr_read_32(CSR_CYCLE, ret)
+	switchcase_csr_read_32(CSR_CYCLEH, ret)
+	default :
+		break;
+	}
+
+	return ret;
+#undef switchcase_csr_read_32
+#undef switchcase_csr_read_16
+#undef switchcase_csr_read_8
+#undef switchcase_csr_read_4
+#undef switchcase_csr_read_2
+#undef switchcase_csr_read
+}
+
+static inline void dummy_func_loop(uint64_t iter)
+{
+	int i = 0;
+
+	while (i < iter) {
+		asm volatile("nop");
+		i++;
+	}
+}
+
+static void start_counter(unsigned long counter, unsigned long start_flags,
+			  unsigned long ival)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, counter, 1, start_flags,
+			ival, 0, 0);
+	__GUEST_ASSERT(ret.error == 0, "Unable to start counter %ld\n", counter);
+}
+
+/* This should be invoked only for reset counter use case */
+static void stop_reset_counter(unsigned long counter, unsigned long stop_flags)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP, counter, 1,
+					stop_flags | SBI_PMU_STOP_FLAG_RESET, 0, 0, 0);
+	__GUEST_ASSERT(ret.error == SBI_ERR_ALREADY_STOPPED,
+			       "Unable to stop counter %ld\n", counter);
+}
+
+static void stop_counter(unsigned long counter, unsigned long stop_flags)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP, counter, 1, stop_flags,
+			0, 0, 0);
+	__GUEST_ASSERT(ret.error == 0, "Unable to stop counter %ld error %ld\n",
+			       counter, ret.error);
+}
+
+static void guest_illegal_exception_handler(struct ex_regs *regs)
+{
+	__GUEST_ASSERT(regs->cause == EXC_INST_ILLEGAL,
+		       "Unexpected exception handler %lx\n", regs->cause);
+
+	illegal_handler_invoked = true;
+	/* skip the trapping instruction */
+	regs->epc += 4;
+}
+
+static unsigned long get_counter_index(unsigned long cbase, unsigned long cmask,
+				       unsigned long cflags,
+				       unsigned long event)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH, cbase, cmask,
+			cflags, event, 0, 0);
+	__GUEST_ASSERT(ret.error == 0, "config matching failed %ld\n", ret.error);
+	GUEST_ASSERT(ret.value < RISCV_MAX_PMU_COUNTERS);
+	GUEST_ASSERT(BIT(ret.value) & counter_mask_available);
+
+	return ret.value;
+}
+
+static unsigned long get_num_counters(void)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_NUM_COUNTERS, 0, 0, 0, 0, 0, 0);
+
+	__GUEST_ASSERT(ret.error == 0, "Unable to retrieve number of counters from SBI PMU");
+	__GUEST_ASSERT(ret.value < RISCV_MAX_PMU_COUNTERS,
+		       "Invalid number of counters %ld\n", ret.value);
+
+	return ret.value;
+}
+
+static void update_counter_info(int num_counters)
+{
+	int i = 0;
+	struct sbiret ret;
+
+	for (i = 0; i < num_counters; i++) {
+		ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_GET_INFO, i, 0, 0, 0, 0, 0);
+
+		/* There can be gaps in logical counter indicies*/
+		if (ret.error)
+			continue;
+		GUEST_ASSERT_NE(ret.value, 0);
+
+		ctrinfo_arr[i].value = ret.value;
+		counter_mask_available |= BIT(i);
+	}
+
+	GUEST_ASSERT(counter_mask_available > 0);
+}
+
+static unsigned long read_fw_counter(int idx, union sbi_pmu_ctr_info ctrinfo)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_READ, idx, 0, 0, 0, 0, 0);
+	GUEST_ASSERT(ret.error == 0);
+	return ret.value;
+}
+
+static unsigned long read_counter(int idx, union sbi_pmu_ctr_info ctrinfo)
+{
+	unsigned long counter_val = 0;
+
+	__GUEST_ASSERT(ctrinfo.type < 2, "Invalid counter type %d", ctrinfo.type);
+
+	if (ctrinfo.type == SBI_PMU_CTR_TYPE_HW)
+		counter_val = pmu_csr_read_num(ctrinfo.csr);
+	else if (ctrinfo.type == SBI_PMU_CTR_TYPE_FW)
+		counter_val = read_fw_counter(idx, ctrinfo);
+
+	return counter_val;
+}
+
+static void test_pmu_event(unsigned long event)
+{
+	unsigned long counter;
+	unsigned long counter_value_pre, counter_value_post;
+	unsigned long counter_init_value = 100;
+
+	counter = get_counter_index(0, counter_mask_available, 0, event);
+	counter_value_pre = read_counter(counter, ctrinfo_arr[counter]);
+
+	/* Do not set the initial value */
+	start_counter(counter, 0, 0);
+	dummy_func_loop(10000);
+	stop_counter(counter, 0);
+
+	counter_value_post = read_counter(counter, ctrinfo_arr[counter]);
+	__GUEST_ASSERT(counter_value_post > counter_value_pre,
+		       "Event update verification failed: post [%lx] pre [%lx]\n",
+		       counter_value_post, counter_value_pre);
+
+	/*
+	 * We can't just update the counter without starting it.
+	 * Do start/stop twice to simulate that by first initializing to a very
+	 * high value and a low value after that.
+	 */
+	start_counter(counter, SBI_PMU_START_FLAG_SET_INIT_VALUE, ULONG_MAX/2);
+	stop_counter(counter, 0);
+	counter_value_pre = read_counter(counter, ctrinfo_arr[counter]);
+
+	start_counter(counter, SBI_PMU_START_FLAG_SET_INIT_VALUE, counter_init_value);
+	stop_counter(counter, 0);
+	counter_value_post = read_counter(counter, ctrinfo_arr[counter]);
+	__GUEST_ASSERT(counter_value_pre > counter_value_post,
+		       "Counter reinitialization verification failed : post [%lx] pre [%lx]\n",
+		       counter_value_post, counter_value_pre);
+
+	/* Now set the initial value and compare */
+	start_counter(counter, SBI_PMU_START_FLAG_SET_INIT_VALUE, counter_init_value);
+	dummy_func_loop(10000);
+	stop_counter(counter, 0);
+
+	counter_value_post = read_counter(counter, ctrinfo_arr[counter]);
+	__GUEST_ASSERT(counter_value_post > counter_init_value,
+		       "Event update verification failed: post [%lx] pre [%lx]\n",
+		       counter_value_post, counter_init_value);
+
+	stop_reset_counter(counter, 0);
+}
+
+static void test_invalid_event(void)
+{
+	struct sbiret ret;
+	unsigned long event = 0x1234; /* A random event */
+
+	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH, 0,
+			counter_mask_available, 0, event, 0, 0);
+	GUEST_ASSERT_EQ(ret.error, SBI_ERR_NOT_SUPPORTED);
+}
+
+static void test_pmu_events(void)
+{
+	int num_counters = 0;
+
+	/* Get the counter details */
+	num_counters = get_num_counters();
+	update_counter_info(num_counters);
+
+	/* Sanity testing for any random invalid event */
+	test_invalid_event();
+
+	/* Only these two events are guaranteed to be present */
+	test_pmu_event(SBI_PMU_HW_CPU_CYCLES);
+	test_pmu_event(SBI_PMU_HW_INSTRUCTIONS);
+
+	GUEST_DONE();
+}
+
+static void test_pmu_basic_sanity(void)
+{
+	long out_val = 0;
+	bool probe;
+	struct sbiret ret;
+	int num_counters = 0, i;
+	union sbi_pmu_ctr_info ctrinfo;
+
+	probe = guest_sbi_probe_extension(SBI_EXT_PMU, &out_val);
+	GUEST_ASSERT(probe && out_val == 1);
+
+	num_counters = get_num_counters();
+
+	for (i = 0; i < num_counters; i++) {
+		ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_GET_INFO, i,
+				0, 0, 0, 0, 0);
+
+		/* There can be gaps in logical counter indicies*/
+		if (ret.error)
+			continue;
+		GUEST_ASSERT_NE(ret.value, 0);
+
+		ctrinfo.value = ret.value;
+
+		/**
+		 * Accessibility check of hardware and read capability of firmware counters.
+		 * The spec doesn't mandate any initial value. No need to check any value.
+		 */
+		if (ctrinfo.type == SBI_PMU_CTR_TYPE_HW) {
+			pmu_csr_read_num(ctrinfo.csr);
+			GUEST_ASSERT(illegal_handler_invoked);
+		} else if (ctrinfo.type == SBI_PMU_CTR_TYPE_FW) {
+			read_fw_counter(i, ctrinfo);
+		}
+	}
+
+	GUEST_DONE();
+}
+
+static void run_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	vcpu_run(vcpu);
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	case UCALL_DONE:
+	case UCALL_SYNC:
+		break;
+	default:
+		TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		break;
+	}
+}
+
+void test_vm_destroy(struct kvm_vm *vm)
+{
+	memset(ctrinfo_arr, 0, sizeof(union sbi_pmu_ctr_info) * RISCV_MAX_PMU_COUNTERS);
+	counter_mask_available = 0;
+	kvm_vm_free(vm);
+}
+
+static void test_vm_basic_test(void *guest_code)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	__TEST_REQUIRE(__vcpu_has_sbi_ext(vcpu, KVM_RISCV_SBI_EXT_PMU),
+				   "SBI PMU not available, skipping test");
+	vm_init_vector_tables(vm);
+	/* Illegal instruction handler is required to verify read access without configuration */
+	vm_install_exception_handler(vm, EXC_INST_ILLEGAL, guest_illegal_exception_handler);
+
+	vcpu_init_vector_tables(vcpu);
+	run_vcpu(vcpu);
+
+	test_vm_destroy(vm);
+}
+
+static void test_vm_events_test(void *guest_code)
+{
+	struct kvm_vm *vm = NULL;
+	struct kvm_vcpu *vcpu = NULL;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	__TEST_REQUIRE(__vcpu_has_sbi_ext(vcpu, KVM_RISCV_SBI_EXT_PMU),
+				   "SBI PMU not available, skipping test");
+	run_vcpu(vcpu);
+
+	test_vm_destroy(vm);
+}
+
+int main(void)
+{
+	test_vm_basic_test(test_pmu_basic_sanity);
+	pr_info("SBI PMU basic test : PASS\n");
+
+	test_vm_events_test(test_pmu_events);
+	pr_info("SBI PMU event verification test : PASS\n");
+
+	return 0;
+}
-- 
2.34.1


