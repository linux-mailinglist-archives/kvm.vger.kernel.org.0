Return-Path: <kvm+bounces-10334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2559486BE01
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 02:09:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDB34281D69
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 01:09:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EC2656B73;
	Thu, 29 Feb 2024 01:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="0RCHamw4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D5754FB7
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 01:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709168528; cv=none; b=JdBlGkmfeHI8gN+ojPqpR1m58R4CayR0USJYoLfWD0n1uIOmuOlRPnP4EBoq/y1ctQsTL2Djgw3Q+9utfUG9/DJ3DJ/DJszFd9vlTfre64KlFk7vGuZUfuDp19gmDo1fKY7xGFeQYos2amwwqhOLbClOxne0VX21hVL+b4igFjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709168528; c=relaxed/simple;
	bh=KtPWbrBnsKjr/W0qBTtBL0Kqd+8RDgGNy7aIUZ7Cnns=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i6C2xLWRdc7OP8guVerdCrOBFrwjcZ+dLlt21w3lbPQMOvM/3Nb2899XRxCFyTVdld4OKZ7Htmuvm9I+4EYuCarahSirKS6Itnlf9+GsGabIf54Y1abPRNdngp8+klLMUgeR6jZV858+uzVj/HAPwnfAtEIDV/tnOCNa0qZjkBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=0RCHamw4; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1dca8b86ee7so3833855ad.2
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 17:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1709168526; x=1709773326; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xVfqPs3ghKLhe8cbt8PYIn0Z6sgqULMQlrH1YTKTR2o=;
        b=0RCHamw4UjSWPIG01Gkv7n9a/gvc9xxf3jJMhFKGR1oOwbCt7Hhp3Y2XKkI6WuKUpm
         I/Cp2y9vZUmesovbox5X0RIYNMNPYKCXdKvHquGo1uJTiw5QptY9Kq8azCXwRqFSog0i
         vhUJf8uDvbV1XX30MXly4ovS7GRzwD7zwW/Izgc11tPe024EuJlexN97QmaqoA4V+XzY
         j0l+YaYph7Ul7MGDiz4I/MDYHpTE7aH4AEGffarzblHBCoI5sDuytuFaWF5Ce6a9ziyu
         0UQxM1u422BN1zD7aG6fvOO5EfXjkuholcfjDLK9pD6DM94e8qcmRursze+SC4fLrChd
         11og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709168526; x=1709773326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xVfqPs3ghKLhe8cbt8PYIn0Z6sgqULMQlrH1YTKTR2o=;
        b=S1gcNXxXCWeKbH9X+jLj9HQ/Xmfwwxg5J4jyhGzB8PuRODtg/bC+06OhA30NLrzVJp
         Cs7MxdLBZxdRQVIOGiBytHUBCTroW5OI1DbE2QZZqiFLIEDOnylmooU65zTCwjEcnyrB
         nJlruZtqogqIqhkJvRjzU+zWKQcAkD6Tz3sNzY963hCK4i2Mmm0O/hri0WMGNjHmzY4Z
         JSH4derR7s7I5KZrkphNYuWAXN4VTr5x7hC2hwgC2hx5VI6N5ytN5l/Cg2rN8A+dpj6e
         IYz91HFo4WaEfpCmqW6t3+azy+eJm3/Pl3PKWzrp4gwC3HqjyfZYuPmypJm5qGn4My6S
         JGqw==
X-Forwarded-Encrypted: i=1; AJvYcCVLZL3xscoz32i3WRmXyEWvuGd8vJqWYK88wU4nyVDjHUcUv2rLZM1+2tfb3JeGAFjjRViDipkn6QJYkeBZ/N0yhVWU
X-Gm-Message-State: AOJu0Yz4L2KjZFYnW0EK+uoKFbgvub8W6Ny547jKMA6ed7ZIa5kmTkMz
	ULrzygA4uu+zCtBV3dxeDLUL5mua3HMw7YwGS6mkr53jb38BmlNI9tPwXAwzJVI=
X-Google-Smtp-Source: AGHT+IGV5cmLpBFINfDf9KTe1scgOUYkC99RehMcl2e49+L/s7ApKgt1ITuRxKPq985Tr32R5Y4kTg==
X-Received: by 2002:a17:902:a384:b0:1dc:ad9d:9e7b with SMTP id x4-20020a170902a38400b001dcad9d9e7bmr675766pla.59.1709168525635;
        Wed, 28 Feb 2024 17:02:05 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id j14-20020a170902da8e00b001dc8d6a9d40sm78043plx.144.2024.02.28.17.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 17:02:05 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Guo Ren <guoren@kernel.org>,
	Icenowy Zheng <uwu@icenowy.me>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Shuah Khan <shuah@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v4 14/15] KVM: riscv: selftests: Add a test for PMU snapshot functionality
Date: Wed, 28 Feb 2024 17:01:29 -0800
Message-Id: <20240229010130.1380926-15-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229010130.1380926-1-atishp@rivosinc.com>
References: <20240229010130.1380926-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Verify PMU snapshot functionality by setting up the shared memory
correctly and reading the counter values from the shared memory
instead of the CSR.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 .../selftests/kvm/include/riscv/processor.h   |  25 ++++
 .../selftests/kvm/lib/riscv/processor.c       |  12 ++
 tools/testing/selftests/kvm/riscv/sbi_pmu.c   | 124 ++++++++++++++++++
 3 files changed, 161 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tools/testing/selftests/kvm/include/riscv/processor.h
index a49a39c8e8d4..e114d039e87b 100644
--- a/tools/testing/selftests/kvm/include/riscv/processor.h
+++ b/tools/testing/selftests/kvm/include/riscv/processor.h
@@ -173,6 +173,7 @@ enum sbi_ext_id {
 };
 
 enum sbi_ext_base_fid {
+	SBI_EXT_BASE_GET_IMP_VERSION = 2,
 	SBI_EXT_BASE_PROBE_EXT = 3,
 };
 
@@ -201,6 +202,12 @@ union sbi_pmu_ctr_info {
 	};
 };
 
+struct riscv_pmu_snapshot_data {
+	u64 ctr_overflow_mask;
+	u64 ctr_values[64];
+	u64 reserved[447];
+};
+
 struct sbiret {
 	long error;
 	long value;
@@ -247,6 +254,14 @@ enum sbi_pmu_ctr_type {
 #define SBI_PMU_STOP_FLAG_RESET (1 << 0)
 #define SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT BIT(1)
 
+#define SBI_STA_SHMEM_DISABLE		-1
+
+/* SBI spec version fields */
+#define SBI_SPEC_VERSION_DEFAULT	0x1
+#define SBI_SPEC_VERSION_MAJOR_SHIFT	24
+#define SBI_SPEC_VERSION_MAJOR_MASK	0x7f
+#define SBI_SPEC_VERSION_MINOR_MASK	0xffffff
+
 struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 			unsigned long arg1, unsigned long arg2,
 			unsigned long arg3, unsigned long arg4,
@@ -254,6 +269,16 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 
 bool guest_sbi_probe_extension(int extid, long *out_val);
 
+/* Make SBI version */
+static inline unsigned long sbi_mk_version(unsigned long major,
+					    unsigned long minor)
+{
+	return ((major & SBI_SPEC_VERSION_MAJOR_MASK) <<
+		SBI_SPEC_VERSION_MAJOR_SHIFT) | minor;
+}
+
+unsigned long get_host_sbi_impl_version(void);
+
 static inline void local_irq_enable(void)
 {
 	csr_set(CSR_SSTATUS, SR_SIE);
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index ec66d331a127..b0162d923e38 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -499,3 +499,15 @@ bool guest_sbi_probe_extension(int extid, long *out_val)
 
 	return true;
 }
+
+unsigned long get_host_sbi_impl_version(void)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_VERSION, 0,
+		       0, 0, 0, 0, 0);
+
+	GUEST_ASSERT(!ret.error);
+
+	return ret.value;
+}
diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu.c b/tools/testing/selftests/kvm/riscv/sbi_pmu.c
index fc1fc5eea99e..8ea2a6db6610 100644
--- a/tools/testing/selftests/kvm/riscv/sbi_pmu.c
+++ b/tools/testing/selftests/kvm/riscv/sbi_pmu.c
@@ -21,6 +21,11 @@
 #define RISCV_MAX_PMU_COUNTERS 64
 union sbi_pmu_ctr_info ctrinfo_arr[RISCV_MAX_PMU_COUNTERS];
 
+/* Snapshot shared memory data */
+#define PMU_SNAPSHOT_GPA_BASE		(1 << 30)
+static void *snapshot_gva;
+static vm_paddr_t snapshot_gpa;
+
 /* Cache the available counters in a bitmask */
 static unsigned long counter_mask_available;
 
@@ -173,6 +178,20 @@ static void stop_counter(unsigned long counter, unsigned long stop_flags)
 			       counter, ret.error);
 }
 
+static void snapshot_set_shmem(vm_paddr_t gpa, unsigned long flags)
+{
+	unsigned long lo = (unsigned long)gpa;
+#if __riscv_xlen == 32
+	unsigned long hi = (unsigned long)(gpa >> 32);
+#else
+	unsigned long hi = gpa == -1 ? -1 : 0;
+#endif
+	struct sbiret ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_SNAPSHOT_SET_SHMEM,
+				      lo, hi, flags, 0, 0, 0);
+
+	GUEST_ASSERT(ret.value == 0 && ret.error == 0);
+}
+
 static void test_pmu_event(unsigned long event)
 {
 	unsigned long counter;
@@ -207,6 +226,43 @@ static void test_pmu_event(unsigned long event)
 	stop_counter(counter, SBI_PMU_STOP_FLAG_RESET);
 }
 
+static void test_pmu_event_snapshot(unsigned long event)
+{
+	unsigned long counter;
+	unsigned long counter_value_pre, counter_value_post;
+	unsigned long counter_init_value = 100;
+	struct riscv_pmu_snapshot_data *snapshot_data = snapshot_gva;
+
+	counter = get_counter_index(0, counter_mask_available, 0, event);
+	counter_value_pre = read_counter(counter, ctrinfo_arr[counter]);
+
+	/* Do not set the initial value */
+	start_counter(counter, 0, 0);
+	dummy_func_loop(10000);
+
+	stop_counter(counter, SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT);
+
+	/* The counter value is updated w.r.t relative index of cbase */
+	counter_value_post = READ_ONCE(snapshot_data->ctr_values[0]);
+	__GUEST_ASSERT(counter_value_post > counter_value_pre,
+		       "counter_value_post %lx counter_value_pre %lx\n",
+		       counter_value_post, counter_value_pre);
+
+	/* Now set the initial value and compare */
+	WRITE_ONCE(snapshot_data->ctr_values[0], counter_init_value);
+	start_counter(counter, SBI_PMU_START_FLAG_INIT_FROM_SNAPSHOT, 0);
+	dummy_func_loop(10000);
+
+	stop_counter(counter, SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT);
+
+	counter_value_post = READ_ONCE(snapshot_data->ctr_values[0]);
+	__GUEST_ASSERT(counter_value_post > counter_init_value,
+		       "counter_value_post %lx counter_init_value %lx for counter\n",
+		       counter_value_post, counter_init_value);
+
+	stop_counter(counter, SBI_PMU_STOP_FLAG_RESET);
+}
+
 static void test_invalid_event(void)
 {
 	struct sbiret ret;
@@ -270,6 +326,41 @@ static void test_pmu_basic_sanity(int cpu)
 	GUEST_DONE();
 }
 
+static void test_pmu_events_snaphost(int cpu)
+{
+	long out_val = 0;
+	bool probe;
+	int num_counters = 0;
+	unsigned long sbi_impl_version;
+	struct riscv_pmu_snapshot_data *snapshot_data = snapshot_gva;
+	int i;
+
+	probe = guest_sbi_probe_extension(SBI_EXT_PMU, &out_val);
+	GUEST_ASSERT(probe && out_val == 1);
+
+	sbi_impl_version = get_host_sbi_impl_version();
+	if (sbi_impl_version >= sbi_mk_version(2, 0))
+		__GUEST_ASSERT(0, "SBI implementation version doesn't support PMU Snapshot");
+
+	snapshot_set_shmem(snapshot_gpa, 0);
+
+	/* Get the counter details */
+	num_counters = get_num_counters();
+	update_counter_info(num_counters);
+
+	/* Validate shared memory access */
+	GUEST_ASSERT_EQ(READ_ONCE(snapshot_data->ctr_overflow_mask), 0);
+	for (i = 0; i < num_counters; i++) {
+		if (counter_mask_available & (1UL << i))
+			GUEST_ASSERT_EQ(READ_ONCE(snapshot_data->ctr_values[i]), 0);
+	}
+	/* Only these two events are guranteed to be present */
+	test_pmu_event_snapshot(SBI_PMU_HW_CPU_CYCLES);
+	test_pmu_event_snapshot(SBI_PMU_HW_INSTRUCTIONS);
+
+	GUEST_DONE();
+}
+
 static void run_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct ucall uc;
@@ -328,6 +419,36 @@ static void test_vm_events_test(void *guest_code)
 	test_vm_destroy(vm);
 }
 
+static void test_vm_setup_snapshot_mem(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, PMU_SNAPSHOT_GPA_BASE, 1, 1, 0);
+	/* PMU Snapshot requires single page only */
+	virt_map(vm, PMU_SNAPSHOT_GPA_BASE, PMU_SNAPSHOT_GPA_BASE, 1);
+
+	/* PMU_SNAPSHOT_GPA_BASE is identity mapped */
+	snapshot_gva = (void *)(PMU_SNAPSHOT_GPA_BASE);
+	snapshot_gpa = addr_gva2gpa(vcpu->vm, (vm_vaddr_t)snapshot_gva);
+	sync_global_to_guest(vcpu->vm, snapshot_gva);
+	sync_global_to_guest(vcpu->vm, snapshot_gpa);
+}
+
+static void test_vm_events_snapshot_test(void *guest_code)
+{
+	struct kvm_vm *vm = NULL;
+	struct kvm_vcpu *vcpu = NULL;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	__TEST_REQUIRE(__vcpu_has_ext(vcpu, RISCV_ISA_EXT_REG(KVM_RISCV_SBI_EXT_PMU)),
+				   "SBI PMU not available, skipping test");
+
+	test_vm_setup_snapshot_mem(vm, vcpu);
+
+	vcpu_args_set(vcpu, 1, 0);
+	run_vcpu(vcpu);
+
+	test_vm_destroy(vm);
+}
+
 int main(void)
 {
 	test_vm_basic_test(test_pmu_basic_sanity);
@@ -336,5 +457,8 @@ int main(void)
 	test_vm_events_test(test_pmu_events);
 	pr_info("SBI PMU event verification test : PASS\n");
 
+	test_vm_events_snapshot_test(test_pmu_events_snaphost);
+	pr_info("SBI PMU event verification with snapshot test : PASS\n");
+
 	return 0;
 }
-- 
2.34.1


