Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D49D53C1F0
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240764AbiFCA5v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240695AbiFCAse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:48:34 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A537A15FDF
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:58 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id g3-20020a170902868300b00163cd75c014so3477159plo.14
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uWmmsqYxu6/ueHuoReSWP73uILq6OVFxgE0YUr23g0U=;
        b=GGEaMVJ6Tmfio5hqRQ9fZ/BvyOxl+jCRXFIGGGtRPW2DAKekUCbzCeBb0hcNM5bXZW
         IjHIdFUsc2+PF9ASWA/UpEqxS8M26Nr4J83J99zWU59ArqTO80YHj+QBJ5PK3VE00/Dj
         STTc+alQvn1prgxVvJr8ThgGxSrt9sf+Zhs3a8C0B9pUQ10VCSEqog6FOxIvm44vH6DS
         h8dSQ/PkjJ9utw6erLKdE2U3TN4yWdwiEFBXxgBdlyJ5dpR82Ds8+Zrcy+DL4IXAouJ+
         ZIUBbih08XHXI2aFOmcw6U+IZPKP4nSsPz9eUhMkCg5FtoRrR+Y32cE2q5L1HzcusnC1
         SkKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uWmmsqYxu6/ueHuoReSWP73uILq6OVFxgE0YUr23g0U=;
        b=ecT+sX87hZ7zS+ouxo8IYULXGeDFvtrXsUISYQlPyI2UFYqSnlADQcesEGC2e/Mfgk
         IJIbutIcg3bSrEYS+OA3Bz/i6sfysTOok0aBs+896grTaxE4MA6P+oHl6ouGM7/R0h5i
         hIzuXLdD4lodlnWz0qa+G1JPoKJM+2lLuYdEBU3H9bN16JqE4DMpdLBxA46HWWy0X7FF
         49SXr/pdDotiqxLF8qF4DPi0+DOtsKl9GLiXBS25rRP4bghGvi+fTt4vzIwCfagxTxfM
         XpuRCrWnoZ7fCJjF9p7EQ3G+ngrUk0XM1+GNoDsXZ1No9zbS55en8UdBQzE5MgWtSriE
         wlQA==
X-Gm-Message-State: AOAM5304O/E1MzdBYNwO77ChB5jTVomKYbIaU8r9pECeqVhzMe5BS7+/
        DO2QgJroyDw/DqCL+sLaSzj6hoFtlMo=
X-Google-Smtp-Source: ABdhPJyigUwc8u8FgN4mBn0LVHhvJohksv1PMuX0djqYoRJP9WL3ZKnsJ6RaTqxsrQPYNp122ZLglPNyUfM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:84c:b0:519:1f69:2224 with SMTP id
 q12-20020a056a00084c00b005191f692224mr7660579pfk.13.1654217218392; Thu, 02
 Jun 2022 17:46:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:59 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-113-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 112/144] KVM: selftests: Consolidate KVM_{G,S}ET_ONE_REG helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework vcpu_{g,s}et_reg() to provide the APIs that tests actually want to
use, and drop the three "one-off" implementations that cropped up due to
the poor API.

Ignore the handful of direct KVM_{G,S}ET_ONE_REG calls that don't fit the
APIs for one reason or another.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  |  2 +-
 .../selftests/kvm/aarch64/get-reg-list.c      |  2 +-
 .../selftests/kvm/aarch64/hypercalls.c        | 32 ++-----
 .../testing/selftests/kvm/aarch64/psci_test.c |  6 +-
 .../selftests/kvm/include/aarch64/processor.h | 18 +---
 .../selftests/kvm/include/kvm_util_base.h     | 28 ++++++-
 .../selftests/kvm/include/riscv/processor.h   | 20 -----
 .../selftests/kvm/lib/aarch64/processor.c     | 28 +++----
 .../selftests/kvm/lib/riscv/processor.c       | 84 +++++++++----------
 tools/testing/selftests/kvm/s390x/resets.c    |  5 +-
 10 files changed, 93 insertions(+), 132 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index b69db0942169..2fe13e117dba 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -242,7 +242,7 @@ static int debug_version(struct kvm_vcpu *vcpu)
 {
 	uint64_t id_aa64dfr0;
 
-	get_reg(vcpu->vm, vcpu->id, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
+	vcpu_get_reg(vcpu->vm, vcpu->id, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
 	return id_aa64dfr0 & 0xf;
 }
 
diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index a8558e462efb..e004afc29387 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -457,7 +457,7 @@ static void run_test(struct vcpu_config *c)
 		bool reject_reg = false;
 		int ret;
 
-		ret = __vcpu_ioctl(vm, 0, KVM_GET_ONE_REG, &reg);
+		ret = __vcpu_get_reg(vm, 0, reg_list->reg[i], &addr);
 		if (ret) {
 			printf("%s: Failed to get ", config_name(c));
 			print_reg(c, reg.id);
diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
index 1eb9738453b4..b1f99e786d05 100644
--- a/tools/testing/selftests/kvm/aarch64/hypercalls.c
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -141,26 +141,6 @@ static void guest_code(void)
 	GUEST_DONE();
 }
 
-static int set_fw_reg(struct kvm_vm *vm, uint64_t id, uint64_t val)
-{
-	struct kvm_one_reg reg = {
-		.id = id,
-		.addr = (uint64_t)&val,
-	};
-
-	return __vcpu_ioctl(vm, 0, KVM_SET_ONE_REG, &reg);
-}
-
-static void get_fw_reg(struct kvm_vm *vm, uint64_t id, uint64_t *addr)
-{
-	struct kvm_one_reg reg = {
-		.id = id,
-		.addr = (uint64_t)addr,
-	};
-
-	vcpu_ioctl(vm, 0, KVM_GET_ONE_REG, &reg);
-}
-
 struct st_time {
 	uint32_t rev;
 	uint32_t attr;
@@ -196,18 +176,18 @@ static void test_fw_regs_before_vm_start(struct kvm_vm *vm)
 		const struct kvm_fw_reg_info *reg_info = &fw_reg_info[i];
 
 		/* First 'read' should be an upper limit of the features supported */
-		get_fw_reg(vm, reg_info->reg, &val);
+		vcpu_get_reg(vm, 0, reg_info->reg, &val);
 		TEST_ASSERT(val == FW_REG_ULIMIT_VAL(reg_info->max_feat_bit),
 			"Expected all the features to be set for reg: 0x%lx; expected: 0x%lx; read: 0x%lx\n",
 			reg_info->reg, FW_REG_ULIMIT_VAL(reg_info->max_feat_bit), val);
 
 		/* Test a 'write' by disabling all the features of the register map */
-		ret = set_fw_reg(vm, reg_info->reg, 0);
+		ret = __vcpu_set_reg(vm, 0, reg_info->reg, 0);
 		TEST_ASSERT(ret == 0,
 			"Failed to clear all the features of reg: 0x%lx; ret: %d\n",
 			reg_info->reg, errno);
 
-		get_fw_reg(vm, reg_info->reg, &val);
+		vcpu_get_reg(vm, 0, reg_info->reg, &val);
 		TEST_ASSERT(val == 0,
 			"Expected all the features to be cleared for reg: 0x%lx\n", reg_info->reg);
 
@@ -216,7 +196,7 @@ static void test_fw_regs_before_vm_start(struct kvm_vm *vm)
 		 * Avoid this check if all the bits are occupied.
 		 */
 		if (reg_info->max_feat_bit < 63) {
-			ret = set_fw_reg(vm, reg_info->reg, BIT(reg_info->max_feat_bit + 1));
+			ret = __vcpu_set_reg(vm, 0, reg_info->reg, BIT(reg_info->max_feat_bit + 1));
 			TEST_ASSERT(ret != 0 && errno == EINVAL,
 			"Unexpected behavior or return value (%d) while setting an unsupported feature for reg: 0x%lx\n",
 			errno, reg_info->reg);
@@ -237,7 +217,7 @@ static void test_fw_regs_after_vm_start(struct kvm_vm *vm)
 		 * Before starting the VM, the test clears all the bits.
 		 * Check if that's still the case.
 		 */
-		get_fw_reg(vm, reg_info->reg, &val);
+		vcpu_get_reg(vm, 0, reg_info->reg, &val);
 		TEST_ASSERT(val == 0,
 			"Expected all the features to be cleared for reg: 0x%lx\n",
 			reg_info->reg);
@@ -247,7 +227,7 @@ static void test_fw_regs_after_vm_start(struct kvm_vm *vm)
 		 * the registers and should return EBUSY. Set the registers and check for
 		 * the expected errno.
 		 */
-		ret = set_fw_reg(vm, reg_info->reg, FW_REG_ULIMIT_VAL(reg_info->max_feat_bit));
+		ret = __vcpu_set_reg(vm, 0, reg_info->reg, FW_REG_ULIMIT_VAL(reg_info->max_feat_bit));
 		TEST_ASSERT(ret != 0 && errno == EBUSY,
 		"Unexpected behavior or return value (%d) while setting a feature while VM is running for reg: 0x%lx\n",
 		errno, reg_info->reg);
diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index d9695a939cc9..f4f73934351f 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -102,8 +102,8 @@ static void assert_vcpu_reset(struct kvm_vcpu *vcpu)
 {
 	uint64_t obs_pc, obs_x0;
 
-	get_reg(vcpu->vm, vcpu->id, ARM64_CORE_REG(regs.pc), &obs_pc);
-	get_reg(vcpu->vm, vcpu->id, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
+	vcpu_get_reg(vcpu->vm, vcpu->id, ARM64_CORE_REG(regs.pc), &obs_pc);
+	vcpu_get_reg(vcpu->vm, vcpu->id, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
 
 	TEST_ASSERT(obs_pc == CPU_ON_ENTRY_ADDR,
 		    "unexpected target cpu pc: %lx (expected: %lx)",
@@ -143,7 +143,7 @@ static void host_test_cpu_on(void)
 	 */
 	vcpu_power_off(target);
 
-	get_reg(vm, target->id, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &target_mpidr);
+	vcpu_get_reg(vm, target->id, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &target_mpidr);
 	vcpu_args_set(vm, source->id, 1, target_mpidr & MPIDR_HWID_BITMASK);
 	enter_guest(source);
 
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index f774609f7848..ba3e9066d990 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -19,7 +19,7 @@
 /*
  * KVM_ARM64_SYS_REG(sys_reg_id): Helper macro to convert
  * SYS_* register definitions in asm/sysreg.h to use in KVM
- * calls such as get_reg() and set_reg().
+ * calls such as vcpu_get_reg() and vcpu_set_reg().
  */
 #define KVM_ARM64_SYS_REG(sys_reg_id)			\
 	ARM64_SYS_REG(sys_reg_Op0(sys_reg_id),		\
@@ -47,22 +47,6 @@
 
 #define MPIDR_HWID_BITMASK (0xff00fffffful)
 
-static inline void get_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t id, uint64_t *addr)
-{
-	struct kvm_one_reg reg;
-	reg.id = id;
-	reg.addr = (uint64_t)addr;
-	vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &reg);
-}
-
-static inline void set_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t id, uint64_t val)
-{
-	struct kvm_one_reg reg;
-	reg.id = id;
-	reg.addr = (uint64_t)&val;
-	vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &reg);
-}
-
 void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init *init);
 struct kvm_vcpu *aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 				  struct kvm_vcpu_init *init, void *guest_code);
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index c0b2158a53d5..9c29b6797ce8 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -374,16 +374,36 @@ static inline void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid,
 {
 	vcpu_ioctl(vm, vcpuid, KVM_SET_FPU, fpu);
 }
+
+static inline int __vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid,
+				 uint64_t reg_id, void *addr)
+{
+	struct kvm_one_reg reg = { .id = reg_id, .addr = (uint64_t)addr };
+
+	return __vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &reg);
+}
+static inline int __vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid,
+				 uint64_t reg_id, uint64_t val)
+{
+	struct kvm_one_reg reg = { .id = reg_id, .addr = (uint64_t)&val };
+
+	return __vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &reg);
+}
 static inline void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid,
-				struct kvm_one_reg *reg)
+				uint64_t reg_id, void *addr)
 {
-	vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, reg);
+	struct kvm_one_reg reg = { .id = reg_id, .addr = (uint64_t)addr };
+
+	vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &reg);
 }
 static inline void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid,
-				struct kvm_one_reg *reg)
+				uint64_t reg_id, uint64_t val)
 {
-	vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, reg);
+	struct kvm_one_reg reg = { .id = reg_id, .addr = (uint64_t)&val };
+
+	vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &reg);
 }
+
 #ifdef __KVM_HAVE_VCPU_EVENTS
 static inline void vcpu_events_get(struct kvm_vm *vm, uint32_t vcpuid,
 				   struct kvm_vcpu_events *events)
diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tools/testing/selftests/kvm/include/riscv/processor.h
index 4fcfd1c0389d..d00d213c3805 100644
--- a/tools/testing/selftests/kvm/include/riscv/processor.h
+++ b/tools/testing/selftests/kvm/include/riscv/processor.h
@@ -38,26 +38,6 @@ static inline uint64_t __kvm_reg_id(uint64_t type, uint64_t idx,
 					     KVM_REG_RISCV_TIMER_REG(name), \
 					     KVM_REG_SIZE_U64)
 
-static inline void get_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t id,
-			   unsigned long *addr)
-{
-	struct kvm_one_reg reg;
-
-	reg.id = id;
-	reg.addr = (unsigned long)addr;
-	vcpu_get_reg(vm, vcpuid, &reg);
-}
-
-static inline void set_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t id,
-			   unsigned long val)
-{
-	struct kvm_one_reg reg;
-
-	reg.id = id;
-	reg.addr = (unsigned long)&val;
-	vcpu_set_reg(vm, vcpuid, &reg);
-}
-
 /* L3 index Bit[47:39] */
 #define PGTBL_L3_INDEX_MASK			0x0000FF8000000000ULL
 #define PGTBL_L3_INDEX_SHIFT			39
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 5b95fa2cce18..d158d5aa26e6 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -232,10 +232,10 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init
 	 * Enable FP/ASIMD to avoid trapping when accessing Q0-Q15
 	 * registers, which the variable argument list macros do.
 	 */
-	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_CPACR_EL1), 3 << 20);
+	vcpu_set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_CPACR_EL1), 3 << 20);
 
-	get_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), &sctlr_el1);
-	get_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TCR_EL1), &tcr_el1);
+	vcpu_get_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), &sctlr_el1);
+	vcpu_get_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TCR_EL1), &tcr_el1);
 
 	/* Configure base granule size */
 	switch (vm->mode) {
@@ -296,19 +296,19 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init
 	tcr_el1 |= (1 << 8) | (1 << 10) | (3 << 12);
 	tcr_el1 |= (64 - vm->va_bits) /* T0SZ */;
 
-	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), sctlr_el1);
-	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TCR_EL1), tcr_el1);
-	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_MAIR_EL1), DEFAULT_MAIR_EL1);
-	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TTBR0_EL1), vm->pgd);
-	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TPIDR_EL1), vcpuid);
+	vcpu_set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), sctlr_el1);
+	vcpu_set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TCR_EL1), tcr_el1);
+	vcpu_set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_MAIR_EL1), DEFAULT_MAIR_EL1);
+	vcpu_set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TTBR0_EL1), vm->pgd);
+	vcpu_set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TPIDR_EL1), vcpuid);
 }
 
 void vcpu_arch_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
 {
 	uint64_t pstate, pc;
 
-	get_reg(vm, vcpuid, ARM64_CORE_REG(regs.pstate), &pstate);
-	get_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), &pc);
+	vcpu_get_reg(vm, vcpuid, ARM64_CORE_REG(regs.pstate), &pstate);
+	vcpu_get_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), &pc);
 
 	fprintf(stream, "%*spstate: 0x%.16lx pc: 0x%.16lx\n",
 		indent, "", pstate, pc);
@@ -326,8 +326,8 @@ struct kvm_vcpu *aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 
 	aarch64_vcpu_setup(vm, vcpu_id, init);
 
-	set_reg(vm, vcpu_id, ARM64_CORE_REG(sp_el1), stack_vaddr + stack_size);
-	set_reg(vm, vcpu_id, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
+	vcpu_set_reg(vm, vcpu_id, ARM64_CORE_REG(sp_el1), stack_vaddr + stack_size);
+	vcpu_set_reg(vm, vcpu_id, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
 
 	return vcpu;
 }
@@ -349,7 +349,7 @@ void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
 	va_start(ap, num);
 
 	for (i = 0; i < num; i++) {
-		set_reg(vm, vcpuid, ARM64_CORE_REG(regs.regs[i]),
+		vcpu_set_reg(vm, vcpuid, ARM64_CORE_REG(regs.regs[i]),
 			va_arg(ap, uint64_t));
 	}
 
@@ -389,7 +389,7 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	extern char vectors;
 
-	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_VBAR_EL1), (uint64_t)&vectors);
+	vcpu_set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_VBAR_EL1), (uint64_t)&vectors);
 }
 
 void route_exception(struct ex_regs *regs, int vector)
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index ba5761843c76..edbdc7bef05b 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -198,46 +198,46 @@ void riscv_vcpu_mmu_setup(struct kvm_vm *vm, int vcpuid)
 	satp = (vm->pgd >> PGTBL_PAGE_SIZE_SHIFT) & SATP_PPN;
 	satp |= SATP_MODE_48;
 
-	set_reg(vm, vcpuid, RISCV_CSR_REG(satp), satp);
+	vcpu_set_reg(vm, vcpuid, RISCV_CSR_REG(satp), satp);
 }
 
 void vcpu_arch_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
 {
 	struct kvm_riscv_core core;
 
-	get_reg(vm, vcpuid, RISCV_CORE_REG(mode), &core.mode);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.pc), &core.regs.pc);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.ra), &core.regs.ra);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.sp), &core.regs.sp);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.gp), &core.regs.gp);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.tp), &core.regs.tp);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.t0), &core.regs.t0);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.t1), &core.regs.t1);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.t2), &core.regs.t2);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s0), &core.regs.s0);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s1), &core.regs.s1);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.a0), &core.regs.a0);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.a1), &core.regs.a1);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.a2), &core.regs.a2);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.a3), &core.regs.a3);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.a4), &core.regs.a4);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.a5), &core.regs.a5);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.a6), &core.regs.a6);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.a7), &core.regs.a7);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s2), &core.regs.s2);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s3), &core.regs.s3);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s4), &core.regs.s4);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s5), &core.regs.s5);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s6), &core.regs.s6);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s7), &core.regs.s7);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s8), &core.regs.s8);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s9), &core.regs.s9);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s10), &core.regs.s10);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s11), &core.regs.s11);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.t3), &core.regs.t3);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.t4), &core.regs.t4);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.t5), &core.regs.t5);
-	get_reg(vm, vcpuid, RISCV_CORE_REG(regs.t6), &core.regs.t6);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(mode), &core.mode);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.pc), &core.regs.pc);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.ra), &core.regs.ra);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.sp), &core.regs.sp);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.gp), &core.regs.gp);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.tp), &core.regs.tp);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.t0), &core.regs.t0);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.t1), &core.regs.t1);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.t2), &core.regs.t2);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s0), &core.regs.s0);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s1), &core.regs.s1);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.a0), &core.regs.a0);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.a1), &core.regs.a1);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.a2), &core.regs.a2);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.a3), &core.regs.a3);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.a4), &core.regs.a4);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.a5), &core.regs.a5);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.a6), &core.regs.a6);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.a7), &core.regs.a7);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s2), &core.regs.s2);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s3), &core.regs.s3);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s4), &core.regs.s4);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s5), &core.regs.s5);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s6), &core.regs.s6);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s7), &core.regs.s7);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s8), &core.regs.s8);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s9), &core.regs.s9);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s10), &core.regs.s10);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.s11), &core.regs.s11);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.t3), &core.regs.t3);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.t4), &core.regs.t4);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.t5), &core.regs.t5);
+	vcpu_get_reg(vm, vcpuid, RISCV_CORE_REG(regs.t6), &core.regs.t6);
 
 	fprintf(stream,
 		" MODE:  0x%lx\n", core.mode);
@@ -302,17 +302,17 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 	/* Setup global pointer of guest to be same as the host */
 	asm volatile (
 		"add %0, gp, zero" : "=r" (current_gp) : : "memory");
-	set_reg(vm, vcpu_id, RISCV_CORE_REG(regs.gp), current_gp);
+	vcpu_set_reg(vm, vcpu_id, RISCV_CORE_REG(regs.gp), current_gp);
 
 	/* Setup stack pointer and program counter of guest */
-	set_reg(vm, vcpu_id, RISCV_CORE_REG(regs.sp),
-		stack_vaddr + stack_size);
-	set_reg(vm, vcpu_id, RISCV_CORE_REG(regs.pc),
-		(unsigned long)guest_code);
+	vcpu_set_reg(vm, vcpu_id, RISCV_CORE_REG(regs.sp),
+		     stack_vaddr + stack_size);
+	vcpu_set_reg(vm, vcpu_id, RISCV_CORE_REG(regs.pc),
+		     (unsigned long)guest_code);
 
 	/* Setup default exception vector of guest */
-	set_reg(vm, vcpu_id, RISCV_CSR_REG(stvec),
-		(unsigned long)guest_unexp_trap);
+	vcpu_set_reg(vm, vcpu_id, RISCV_CSR_REG(stvec),
+		     (unsigned long)guest_unexp_trap);
 
 	return vcpu;
 }
@@ -355,7 +355,7 @@ void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
 			id = RISCV_CORE_REG(regs.a7);
 			break;
 		}
-		set_reg(vm, vcpuid, id, va_arg(ap, uint64_t));
+		vcpu_set_reg(vm, vcpuid, id, va_arg(ap, uint64_t));
 	}
 
 	va_end(ap);
diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
index cc4b7c86d69f..a62de5351d7b 100644
--- a/tools/testing/selftests/kvm/s390x/resets.c
+++ b/tools/testing/selftests/kvm/s390x/resets.c
@@ -60,12 +60,9 @@ static void guest_code_initial(void)
 
 static void test_one_reg(uint64_t id, uint64_t value)
 {
-	struct kvm_one_reg reg;
 	uint64_t eval_reg;
 
-	reg.addr = (uintptr_t)&eval_reg;
-	reg.id = id;
-	vcpu_get_reg(vm, VCPU_ID, &reg);
+	vcpu_get_reg(vm, VCPU_ID, id, &eval_reg);
 	TEST_ASSERT(eval_reg == value, "value == 0x%lx", value);
 }
 
-- 
2.36.1.255.ge46751e96f-goog

