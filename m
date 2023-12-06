Return-Path: <kvm+bounces-3727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FF198075FF
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 18:03:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C54BB1F2167F
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B46D60B97;
	Wed,  6 Dec 2023 17:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="m++nBPRq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A03E10D4
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 09:02:48 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-50bce78f145so8730018e87.0
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 09:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701882166; x=1702486966; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KkgxuqNlxhqN0z3U5cEtMFu2Vm9X9+0ZWrXBDZnnsDk=;
        b=m++nBPRqPz3Xmqe9psSAbw5h9uPUHqhx6qsUi7zJHotXzm+b1IPFDzPhhunaJVbJF/
         Gs9UZfpPHebvuCaK+cQX/stodw8MyVfVg/MmGSjSLxD6+daNPq3P+QmqY9h8ECGJE8Vv
         dLKSActKgerK6EOC511B/Kq3J3RDCl+UrqJ5gWfKAxZN2gSRlvFjRsRKNnNBACoWvJL4
         oZZtFIoWU/0V5G/+e+z262MIGtSbmkKrC0wa8QAVjm6/kgZXphYo6MbIZBktyYZoAnKY
         sOtecPuWUub1W8/DOfdKk9yy5wkGkKy+hD92a23W07FHirBr/3oEXT9zVhER996IuNUh
         WhDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701882166; x=1702486966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KkgxuqNlxhqN0z3U5cEtMFu2Vm9X9+0ZWrXBDZnnsDk=;
        b=rXmcuX46L7xAeaa9qS++795FOkW7r5wf1P4jkgcROiia4IBxBgM+1NrONPeMma/isL
         u+FMZR0oTo8AEemlVSyF40DfBcwjM6XeIAC+D+pt0rFfRZHe7I8iu8ETDU2Rz4gvzx/Q
         falR4y1i8uZXNlLjZoQ9Wj+2QDvpmviOGfaDTl+HOaoGJLvJwbpPevc0swUr4ty16wSO
         jXisrQdGLdfg/aM3XIISEhQU2yW8mDMxxee9qbgZOarPa9jQK5sIRfswzbyWsYmAUNDj
         kkKFCnOG8szPUMzJlZCRbpGKEvG2OC7xnHuQZMeyiXCGANGGMaSBR+6HtE8pXFhTQbbJ
         Yv1w==
X-Gm-Message-State: AOJu0Yyo3eVrrWc9prlDb6y5hLZStt9XoZ2yf7NXuPxZKaw8g30nGMWs
	IuDtMLXNWvEhJr6o+4lQqPf8fiIh1FF8biLJ9MM=
X-Google-Smtp-Source: AGHT+IHplCiBnq7bawy7qq8iUw18EBbhOZLo1tbWseWv2F98TNRMUHiaSJ4zDdMgFuAcTdwqpd+7eA==
X-Received: by 2002:ac2:5e7c:0:b0:50c:a3a:45bd with SMTP id a28-20020ac25e7c000000b0050c0a3a45bdmr403679lfr.160.1701882165877;
        Wed, 06 Dec 2023 09:02:45 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id y14-20020aa7c24e000000b0054ce9ef93fbsm193045edo.4.2023.12.06.09.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 09:02:45 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	anup@brainfault.org,
	borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com
Subject: [PATCH 2/5] KVM: selftests: aarch64: Remove redundant newlines
Date: Wed,  6 Dec 2023 18:02:44 +0100
Message-ID: <20231206170241.82801-9-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231206170241.82801-7-ajones@ventanamicro.com>
References: <20231206170241.82801-7-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit

TEST_* functions append their own newline. Remove newlines from
TEST_* callsites to avoid extra newlines in output.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 tools/testing/selftests/kvm/aarch64/arch_timer.c | 12 ++++++------
 tools/testing/selftests/kvm/aarch64/hypercalls.c | 16 ++++++++--------
 .../selftests/kvm/aarch64/page_fault_test.c      |  6 +++---
 .../testing/selftests/kvm/aarch64/smccc_filter.c |  2 +-
 .../selftests/kvm/aarch64/vpmu_counter_access.c  | 12 ++++++------
 .../selftests/kvm/lib/aarch64/processor.c        |  2 +-
 tools/testing/selftests/kvm/lib/aarch64/vgic.c   |  4 ++--
 7 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 274b8465b42a..2cb8dd1f8275 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -248,7 +248,7 @@ static void *test_vcpu_run(void *arg)
 		REPORT_GUEST_ASSERT(uc);
 		break;
 	default:
-		TEST_FAIL("Unexpected guest exit\n");
+		TEST_FAIL("Unexpected guest exit");
 	}
 
 	return NULL;
@@ -287,7 +287,7 @@ static int test_migrate_vcpu(unsigned int vcpu_idx)
 
 	/* Allow the error where the vCPU thread is already finished */
 	TEST_ASSERT(ret == 0 || ret == ESRCH,
-		    "Failed to migrate the vCPU:%u to pCPU: %u; ret: %d\n",
+		    "Failed to migrate the vCPU:%u to pCPU: %u; ret: %d",
 		    vcpu_idx, new_pcpu, ret);
 
 	return ret;
@@ -326,12 +326,12 @@ static void test_run(struct kvm_vm *vm)
 
 	pthread_mutex_init(&vcpu_done_map_lock, NULL);
 	vcpu_done_map = bitmap_zalloc(test_args.nr_vcpus);
-	TEST_ASSERT(vcpu_done_map, "Failed to allocate vcpu done bitmap\n");
+	TEST_ASSERT(vcpu_done_map, "Failed to allocate vcpu done bitmap");
 
 	for (i = 0; i < (unsigned long)test_args.nr_vcpus; i++) {
 		ret = pthread_create(&pt_vcpu_run[i], NULL, test_vcpu_run,
 				     (void *)(unsigned long)i);
-		TEST_ASSERT(!ret, "Failed to create vCPU-%d pthread\n", i);
+		TEST_ASSERT(!ret, "Failed to create vCPU-%d pthread", i);
 	}
 
 	/* Spawn a thread to control the vCPU migrations */
@@ -340,7 +340,7 @@ static void test_run(struct kvm_vm *vm)
 
 		ret = pthread_create(&pt_vcpu_migration, NULL,
 					test_vcpu_migration, NULL);
-		TEST_ASSERT(!ret, "Failed to create the migration pthread\n");
+		TEST_ASSERT(!ret, "Failed to create the migration pthread");
 	}
 
 
@@ -384,7 +384,7 @@ static struct kvm_vm *test_vm_create(void)
 		if (kvm_has_cap(KVM_CAP_COUNTER_OFFSET))
 			vm_ioctl(vm, KVM_ARM_SET_COUNTER_OFFSET, &test_args.offset);
 		else
-			TEST_FAIL("no support for global offset\n");
+			TEST_FAIL("no support for global offset");
 	}
 
 	for (i = 0; i < nr_vcpus; i++)
diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
index 31f66ba97228..27c10e7a7e01 100644
--- a/tools/testing/selftests/kvm/aarch64/hypercalls.c
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -175,18 +175,18 @@ static void test_fw_regs_before_vm_start(struct kvm_vcpu *vcpu)
 		/* First 'read' should be an upper limit of the features supported */
 		vcpu_get_reg(vcpu, reg_info->reg, &val);
 		TEST_ASSERT(val == FW_REG_ULIMIT_VAL(reg_info->max_feat_bit),
-			"Expected all the features to be set for reg: 0x%lx; expected: 0x%lx; read: 0x%lx\n",
+			"Expected all the features to be set for reg: 0x%lx; expected: 0x%lx; read: 0x%lx",
 			reg_info->reg, FW_REG_ULIMIT_VAL(reg_info->max_feat_bit), val);
 
 		/* Test a 'write' by disabling all the features of the register map */
 		ret = __vcpu_set_reg(vcpu, reg_info->reg, 0);
 		TEST_ASSERT(ret == 0,
-			"Failed to clear all the features of reg: 0x%lx; ret: %d\n",
+			"Failed to clear all the features of reg: 0x%lx; ret: %d",
 			reg_info->reg, errno);
 
 		vcpu_get_reg(vcpu, reg_info->reg, &val);
 		TEST_ASSERT(val == 0,
-			"Expected all the features to be cleared for reg: 0x%lx\n", reg_info->reg);
+			"Expected all the features to be cleared for reg: 0x%lx", reg_info->reg);
 
 		/*
 		 * Test enabling a feature that's not supported.
@@ -195,7 +195,7 @@ static void test_fw_regs_before_vm_start(struct kvm_vcpu *vcpu)
 		if (reg_info->max_feat_bit < 63) {
 			ret = __vcpu_set_reg(vcpu, reg_info->reg, BIT(reg_info->max_feat_bit + 1));
 			TEST_ASSERT(ret != 0 && errno == EINVAL,
-			"Unexpected behavior or return value (%d) while setting an unsupported feature for reg: 0x%lx\n",
+			"Unexpected behavior or return value (%d) while setting an unsupported feature for reg: 0x%lx",
 			errno, reg_info->reg);
 		}
 	}
@@ -216,7 +216,7 @@ static void test_fw_regs_after_vm_start(struct kvm_vcpu *vcpu)
 		 */
 		vcpu_get_reg(vcpu, reg_info->reg, &val);
 		TEST_ASSERT(val == 0,
-			"Expected all the features to be cleared for reg: 0x%lx\n",
+			"Expected all the features to be cleared for reg: 0x%lx",
 			reg_info->reg);
 
 		/*
@@ -226,7 +226,7 @@ static void test_fw_regs_after_vm_start(struct kvm_vcpu *vcpu)
 		 */
 		ret = __vcpu_set_reg(vcpu, reg_info->reg, FW_REG_ULIMIT_VAL(reg_info->max_feat_bit));
 		TEST_ASSERT(ret != 0 && errno == EBUSY,
-		"Unexpected behavior or return value (%d) while setting a feature while VM is running for reg: 0x%lx\n",
+		"Unexpected behavior or return value (%d) while setting a feature while VM is running for reg: 0x%lx",
 		errno, reg_info->reg);
 	}
 }
@@ -265,7 +265,7 @@ static void test_guest_stage(struct kvm_vm **vm, struct kvm_vcpu **vcpu)
 	case TEST_STAGE_HVC_IFACE_FALSE_INFO:
 		break;
 	default:
-		TEST_FAIL("Unknown test stage: %d\n", prev_stage);
+		TEST_FAIL("Unknown test stage: %d", prev_stage);
 	}
 }
 
@@ -294,7 +294,7 @@ static void test_run(void)
 			REPORT_GUEST_ASSERT(uc);
 			break;
 		default:
-			TEST_FAIL("Unexpected guest exit\n");
+			TEST_FAIL("Unexpected guest exit");
 		}
 	}
 
diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 08a5ca5bed56..53fddad57cbb 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -414,10 +414,10 @@ static bool punch_hole_in_backing_store(struct kvm_vm *vm,
 	if (fd != -1) {
 		ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
 				0, paging_size);
-		TEST_ASSERT(ret == 0, "fallocate failed\n");
+		TEST_ASSERT(ret == 0, "fallocate failed");
 	} else {
 		ret = madvise(hva, paging_size, MADV_DONTNEED);
-		TEST_ASSERT(ret == 0, "madvise failed\n");
+		TEST_ASSERT(ret == 0, "madvise failed");
 	}
 
 	return true;
@@ -501,7 +501,7 @@ static bool handle_cmd(struct kvm_vm *vm, int cmd)
 
 void fail_vcpu_run_no_handler(int ret)
 {
-	TEST_FAIL("Unexpected vcpu run failure\n");
+	TEST_FAIL("Unexpected vcpu run failure");
 }
 
 void fail_vcpu_run_mmio_no_syndrome_handler(int ret)
diff --git a/tools/testing/selftests/kvm/aarch64/smccc_filter.c b/tools/testing/selftests/kvm/aarch64/smccc_filter.c
index f4ceae9c8925..2d189f3da228 100644
--- a/tools/testing/selftests/kvm/aarch64/smccc_filter.c
+++ b/tools/testing/selftests/kvm/aarch64/smccc_filter.c
@@ -178,7 +178,7 @@ static void expect_call_denied(struct kvm_vcpu *vcpu)
 	struct ucall uc;
 
 	if (get_ucall(vcpu, &uc) != UCALL_SYNC)
-		TEST_FAIL("Unexpected ucall: %lu\n", uc.cmd);
+		TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
 
 	TEST_ASSERT(uc.args[1] == SMCCC_RET_NOT_SUPPORTED,
 		    "Unexpected SMCCC return code: %lu", uc.args[1]);
diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index 5ea78986e665..42e552926904 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -518,11 +518,11 @@ static void test_create_vpmu_vm_with_pmcr_n(uint64_t pmcr_n, bool expect_fail)
 
 	if (expect_fail)
 		TEST_ASSERT(pmcr_orig == pmcr,
-			    "PMCR.N modified by KVM to a larger value (PMCR: 0x%lx) for pmcr_n: 0x%lx\n",
+			    "PMCR.N modified by KVM to a larger value (PMCR: 0x%lx) for pmcr_n: 0x%lx",
 			    pmcr, pmcr_n);
 	else
 		TEST_ASSERT(pmcr_n == get_pmcr_n(pmcr),
-			    "Failed to update PMCR.N to %lu (received: %lu)\n",
+			    "Failed to update PMCR.N to %lu (received: %lu)",
 			    pmcr_n, get_pmcr_n(pmcr));
 }
 
@@ -595,12 +595,12 @@ static void run_pmregs_validity_test(uint64_t pmcr_n)
 		 */
 		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(set_reg_id), &reg_val);
 		TEST_ASSERT((reg_val & (~valid_counters_mask)) == 0,
-			    "Initial read of set_reg: 0x%llx has unimplemented counters enabled: 0x%lx\n",
+			    "Initial read of set_reg: 0x%llx has unimplemented counters enabled: 0x%lx",
 			    KVM_ARM64_SYS_REG(set_reg_id), reg_val);
 
 		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(clr_reg_id), &reg_val);
 		TEST_ASSERT((reg_val & (~valid_counters_mask)) == 0,
-			    "Initial read of clr_reg: 0x%llx has unimplemented counters enabled: 0x%lx\n",
+			    "Initial read of clr_reg: 0x%llx has unimplemented counters enabled: 0x%lx",
 			    KVM_ARM64_SYS_REG(clr_reg_id), reg_val);
 
 		/*
@@ -612,12 +612,12 @@ static void run_pmregs_validity_test(uint64_t pmcr_n)
 
 		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(set_reg_id), &reg_val);
 		TEST_ASSERT((reg_val & (~valid_counters_mask)) == 0,
-			    "Read of set_reg: 0x%llx has unimplemented counters enabled: 0x%lx\n",
+			    "Read of set_reg: 0x%llx has unimplemented counters enabled: 0x%lx",
 			    KVM_ARM64_SYS_REG(set_reg_id), reg_val);
 
 		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(clr_reg_id), &reg_val);
 		TEST_ASSERT((reg_val & (~valid_counters_mask)) == 0,
-			    "Read of clr_reg: 0x%llx has unimplemented counters enabled: 0x%lx\n",
+			    "Read of clr_reg: 0x%llx has unimplemented counters enabled: 0x%lx",
 			    KVM_ARM64_SYS_REG(clr_reg_id), reg_val);
 	}
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 6fe12e985ba5..12087b5416af 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -377,7 +377,7 @@ void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...)
 	int i;
 
 	TEST_ASSERT(num >= 1 && num <= 8, "Unsupported number of args,\n"
-		    "  num: %u\n", num);
+		    "  num: %u", num);
 
 	va_start(ap, num);
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index b5f28d21a947..184378d593e9 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -38,7 +38,7 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
 	struct list_head *iter;
 	unsigned int nr_gic_pages, nr_vcpus_created = 0;
 
-	TEST_ASSERT(nr_vcpus, "Number of vCPUs cannot be empty\n");
+	TEST_ASSERT(nr_vcpus, "Number of vCPUs cannot be empty");
 
 	/*
 	 * Make sure that the caller is infact calling this
@@ -47,7 +47,7 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
 	list_for_each(iter, &vm->vcpus)
 		nr_vcpus_created++;
 	TEST_ASSERT(nr_vcpus == nr_vcpus_created,
-			"Number of vCPUs requested (%u) doesn't match with the ones created for the VM (%u)\n",
+			"Number of vCPUs requested (%u) doesn't match with the ones created for the VM (%u)",
 			nr_vcpus, nr_vcpus_created);
 
 	/* Distributor setup */
-- 
2.43.0


