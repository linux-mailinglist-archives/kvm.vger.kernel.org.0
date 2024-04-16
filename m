Return-Path: <kvm+bounces-14844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 048CE8A73C2
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 20:52:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 281451C20AB6
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 18:52:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 073311448C9;
	Tue, 16 Apr 2024 18:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="zSBjUZBD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9B41419BA
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 18:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293114; cv=none; b=m4kL6li1kyfr3syeY36OT/Z5Qj6MR+qXpXVWxQfRKeDuRFxpcSNYeN7btobNYviqGwJ7APlN+9tztIOFr+nkFy/HT6BcvhtpKlu8j4BRHqF1eIePi0V1DAfy0opnaZwUfjPTRaQCQtDsVVqtnbfVJ9wgqNnLMCdIqy5Z3rWFHUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293114; c=relaxed/simple;
	bh=CDNvwVDvGBWT+u8SvxT/JwIFcLRYFszHT9KKdmrrLd8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JnX+QnNsPlsIFFkHKB6rA7qXm5GL4qamhDn/ThPtCQCHfc4AiwAdqBK6iHbPQnnA6D5FB9xt7qV6jR1S8EnvxuwSGSZX73mlm/Lr0W2wKZkuVMFPmeZJmUwDeIEtvrSiW9/450NbngH8xjfJ3RDppm48dsQ+AKEQNP2KcCI3mi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=zSBjUZBD; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5e152c757a5so2681994a12.2
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 11:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713293111; x=1713897911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tJAThzhHQGnWs81W5HgHaocJpD0YqpVCwOX9M1CBRIE=;
        b=zSBjUZBDjvB9E/RTx/pECKMKHR/MTaKD5mOmyeyAObtkkGDOckOH1p6DcJ2bqTTC/k
         gtp0aaq6EktlMU9SwlU5vpWm4ldlWTED1NHgN2C5TDwfYHyQ0toP3udK+F1MspE5oL5u
         rVWh7F5tZYTwEY1/F2J3xqw7APuvO9vwEK4NnFQgQAZ8ZPhIhyJViRjAB3VOQ+q9anmP
         T0lNRw0+lEMDKo+aQ3a6MQac2u2XVsfum9vdZg9HKxiEnXBi1t6W1HD7iUv2ZUS79K2/
         u+WU7OYf07ka5NMqTi+FP5CGNZkeEjw/T7TVY0G2sUHrZc6HoCy9qRf6JzoMwG5G9RHg
         hC2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713293111; x=1713897911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tJAThzhHQGnWs81W5HgHaocJpD0YqpVCwOX9M1CBRIE=;
        b=c7xuWfZdF5dxLpIAcDPOgIvhxhmIhmZO+qEQg9bDSSWUTohOxO0RbupJ/FRD5VWjRm
         /Gr3oou1piyjJOfhvuYvjzMe1QYKgwF/ljGM8OmME2/lomJY1tuLFRcUHIfrQjHBhvYQ
         /brJv/OBlIF53RQErhIi5/DnKUU1lQCyRzAbRE4xiwjj5FW46XVIXilkwADepjKRIVTb
         sLhTSRRCKlXEtIR6hWKwdPLRekhXHtl8x7epvev6ukmF3Vz0H2NCmHxGiayW9wHss+bu
         pZXNPzWngsl5VdRZQowHxApetmP3S721gMo4jXazv+JyGukGR0oj4CWKA1fwhGySa4/3
         38HQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAqBL9rWR2w4k8yW3Vx2YHJQbn0TlqUJB6GgZZGLkjHSmEqBAUDwaW7ikOrLltAF1khMOGRNjBhJGkE1ETaRqpgtJk
X-Gm-Message-State: AOJu0Yx44FvY6AuRCuGJuY9t23mCZJb04Cvu68HZqnbQEwGu7pPit2eX
	PFsDFw586JPlrnOHGAa+7B1HVuvrFjzC2A90AxKxuh2rKt5n6u5EzUsWdDnaMYM=
X-Google-Smtp-Source: AGHT+IEpYA3MBqPo4T/V3elCaTLuJwccl4FHxVclOvEBheHidvf3GAI2pVJKIKSZdqo2B/RMKcXe3g==
X-Received: by 2002:a17:90a:c205:b0:2a5:2177:9b41 with SMTP id e5-20020a17090ac20500b002a521779b41mr11033889pjt.22.1713293111177;
        Tue, 16 Apr 2024 11:45:11 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id o19-20020a17090aac1300b002a269828bb8sm8883645pjq.40.2024.04.16.11.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 11:45:10 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
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
Subject: [PATCH v7 21/24] KVM: riscv: selftests: Add SBI PMU selftest
Date: Tue, 16 Apr 2024 11:44:18 -0700
Message-Id: <20240416184421.3693802-22-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240416184421.3693802-1-atishp@rivosinc.com>
References: <20240416184421.3693802-1-atishp@rivosinc.com>
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


