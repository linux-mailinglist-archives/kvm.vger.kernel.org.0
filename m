Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B556E51B340
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381694AbiEDXF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379546AbiEDW6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:58:40 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1C755375
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:52:25 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id t15-20020a17090ae50f00b001d925488489so1318887pjy.3
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=0X4EmOn4v13Ft883CYNx9/ctglmAu5XEQQJoVm+CGAA=;
        b=dmwn3l22LgBQhcrH9K4uMBXbLVxFdAnKO5CPqfcOFb7SNiF5arlfjjEjdmt3pLEaGS
         bCYe3vxdw2xOjgPvomjdmvN8Tnrv3EOvFvwX3burdgLRXvca2EIgFoOrDfO3r0DY+BDQ
         1LRBDOGISJVPdVuRkjSB1pb/jC9jeIx7YXWMOFrtn4kZOirl7dHZHwkbh9Vwhvqpr5KK
         Tq/5inMdgOMVgTaLRNRwnRGkrlv8w7rRO8jb4+I4kolRLLupTEgWXo7sg1sz/0W28QQd
         kJBegDL8ONO8NSA2pbCTMATUMS0c9refpO8ixIoEZaufsSbr/a9pdy8CCh0zi+7stGyG
         3tRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=0X4EmOn4v13Ft883CYNx9/ctglmAu5XEQQJoVm+CGAA=;
        b=HDU5JX0QFIX9hkkzqCFWm8WYnJdzSi/3myMMHb1tKEZKY4bUSka8Hx6k44hM8Mzt5M
         Yf/jtOj5MT2O6jsSrGkBe3vttLaQ8/mvAlE34QzHK9gbLdifmDhbOZQMJ7tX+lCdMCNh
         FuZV5EZYQF1x6RoPE4HO/Sdz9+IbWtQpYEQRmpFA3iLYrxSJss5901s2v+XZ271zT4Rp
         ZIwb5s9sMrbneOdltdtF2+ygGfysFX/ZFoJOsWd7m0SqODD3nkHCc5hTQ3iK8XW/tH2a
         ydaU6xkFVACPm0QNp1gW18qukCvdYBwFXpi+kL9Nh3i2VTGYeNJeAiWyF5BQT55R1vKP
         kt1g==
X-Gm-Message-State: AOAM5307klUhHfnDa40/7LX9Jw29y1xVUalCX7ezin/PSSSzjVXffZw6
        2F1XEKCuxtBjI0dXlxltjTdro/8QaPw=
X-Google-Smtp-Source: ABdhPJxbWXi3sX+oCnyWA6Pab2nD30eh9d+IRlNP6C71457XdRTbPxw4XaZPzP0s5XuH4dKslNZbUf4JY+c=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:2bd4:0:b0:3c5:ecc9:6064 with SMTP id
 r203-20020a632bd4000000b003c5ecc96064mr3519960pgr.397.1651704730505; Wed, 04
 May 2022 15:52:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:39 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-94-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 093/128] KVM: selftests: Return created vcpu from vm_vcpu_add_default()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Return the created 'struct kvm_vcpu' object from vm_vcpu_add_default(),
which cleans up a few tests and will eventually allow removing vcpu_get()
entirely.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h |  5 +++--
 .../selftests/kvm/include/kvm_util_base.h     | 10 ++++++----
 .../selftests/kvm/lib/aarch64/processor.c     | 20 +++++++++++--------
 .../selftests/kvm/lib/riscv/processor.c       | 20 +++++++++++--------
 .../selftests/kvm/lib/s390x/processor.c       | 18 ++++++++++-------
 .../selftests/kvm/lib/x86_64/processor.c      | 20 +++++++++++--------
 .../kvm/x86_64/pmu_event_filter_test.c        |  4 +---
 .../selftests/kvm/x86_64/tsc_scaling_sync.c   |  3 +--
 8 files changed, 58 insertions(+), 42 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 9a430980100e..5999e7ae7b29 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -64,8 +64,9 @@ static inline void set_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t id, uint
 }
 
 void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init *init);
-void aarch64_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid,
-			      struct kvm_vcpu_init *init, void *guest_code);
+struct kvm_vcpu *aarch64_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpu_id,
+					  struct kvm_vcpu_init *init,
+					  void *guest_code);
 
 struct ex_regs {
 	u64 regs[31];
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 5e316f7cd927..de36e7e91796 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -655,12 +655,14 @@ static inline void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid,
  *   vcpuid - The id of the VCPU to add to the VM.
  *   guest_code - The vCPU's entry point
  */
-void vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code);
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
+				  void *guest_code);
 
-static inline void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid,
-				       void *guest_code)
+static inline struct kvm_vcpu *vm_vcpu_add_default(struct kvm_vm *vm,
+						   uint32_t vcpu_id,
+						   void *guest_code)
 {
-	vm_arch_vcpu_add(vm, vcpuid, guest_code);
+	return vm_arch_vcpu_add(vm, vcpu_id, guest_code);
 }
 
 void virt_arch_pgd_alloc(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 653e740c46b1..089e6de2160c 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -314,25 +314,29 @@ void vcpu_arch_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t in
 		indent, "", pstate, pc);
 }
 
-void aarch64_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid,
-			      struct kvm_vcpu_init *init, void *guest_code)
+struct kvm_vcpu *aarch64_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpu_id,
+					  struct kvm_vcpu_init *init,
+					  void *guest_code)
 {
 	size_t stack_size = vm->page_size == 4096 ?
 					DEFAULT_STACK_PGS * vm->page_size :
 					vm->page_size;
 	uint64_t stack_vaddr = vm_vaddr_alloc(vm, stack_size,
 					      DEFAULT_ARM64_GUEST_STACK_VADDR_MIN);
+	struct kvm_vcpu *vcpu = vm_vcpu_add(vm, vcpu_id);
 
-	vm_vcpu_add(vm, vcpuid);
-	aarch64_vcpu_setup(vm, vcpuid, init);
+	aarch64_vcpu_setup(vm, vcpu_id, init);
 
-	set_reg(vm, vcpuid, ARM64_CORE_REG(sp_el1), stack_vaddr + stack_size);
-	set_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
+	set_reg(vm, vcpu_id, ARM64_CORE_REG(sp_el1), stack_vaddr + stack_size);
+	set_reg(vm, vcpu_id, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
+
+	return vcpu;
 }
 
-void vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
+				  void *guest_code)
 {
-	aarch64_vcpu_add_default(vm, vcpuid, NULL, guest_code);
+	return aarch64_vcpu_add_default(vm, vcpu_id, NULL, guest_code);
 }
 
 void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index e43651ad7729..71bd7975d65e 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -273,7 +273,8 @@ static void __aligned(16) guest_hang(void)
 		;
 }
 
-void vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
+				  void *guest_code)
 {
 	int r;
 	size_t stack_size = vm->page_size == 4096 ?
@@ -283,9 +284,10 @@ void vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 					DEFAULT_RISCV_GUEST_STACK_VADDR_MIN);
 	unsigned long current_gp = 0;
 	struct kvm_mp_state mps;
+	struct kvm_vcpu *vcpu;
 
-	vm_vcpu_add(vm, vcpuid);
-	riscv_vcpu_mmu_setup(vm, vcpuid);
+	vcpu = vm_vcpu_add(vm, vcpu_id);
+	riscv_vcpu_mmu_setup(vm, vcpu_id);
 
 	/*
 	 * With SBI HSM support in KVM RISC-V, all secondary VCPUs are
@@ -293,23 +295,25 @@ void vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 	 * are powered-on using KVM_SET_MP_STATE ioctl().
 	 */
 	mps.mp_state = KVM_MP_STATE_RUNNABLE;
-	r = __vcpu_ioctl(vm, vcpuid, KVM_SET_MP_STATE, &mps);
+	r = __vcpu_ioctl(vm, vcpu_id, KVM_SET_MP_STATE, &mps);
 	TEST_ASSERT(!r, "IOCTL KVM_SET_MP_STATE failed (error %d)", r);
 
 	/* Setup global pointer of guest to be same as the host */
 	asm volatile (
 		"add %0, gp, zero" : "=r" (current_gp) : : "memory");
-	set_reg(vm, vcpuid, RISCV_CORE_REG(regs.gp), current_gp);
+	set_reg(vm, vcpu_id, RISCV_CORE_REG(regs.gp), current_gp);
 
 	/* Setup stack pointer and program counter of guest */
-	set_reg(vm, vcpuid, RISCV_CORE_REG(regs.sp),
+	set_reg(vm, vcpu_id, RISCV_CORE_REG(regs.sp),
 		stack_vaddr + stack_size);
-	set_reg(vm, vcpuid, RISCV_CORE_REG(regs.pc),
+	set_reg(vm, vcpu_id, RISCV_CORE_REG(regs.pc),
 		(unsigned long)guest_code);
 
 	/* Setup default exception vector of guest */
-	set_reg(vm, vcpuid, RISCV_CSR_REG(stvec),
+	set_reg(vm, vcpu_id, RISCV_CSR_REG(stvec),
 		(unsigned long)guest_hang);
+
+	return vcpu;
 }
 
 void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index c2fe56a3fb74..cf759844b226 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -154,12 +154,14 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	virt_dump_region(stream, vm, indent, vm->pgd);
 }
 
-void vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
+				  void *guest_code)
 {
 	size_t stack_size =  DEFAULT_STACK_PGS * getpagesize();
 	uint64_t stack_vaddr;
 	struct kvm_regs regs;
 	struct kvm_sregs sregs;
+	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
 
 	TEST_ASSERT(vm->page_size == 4096, "Unsupported page size: 0x%x",
@@ -168,21 +170,23 @@ void vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 	stack_vaddr = vm_vaddr_alloc(vm, stack_size,
 				     DEFAULT_GUEST_STACK_VADDR_MIN);
 
-	vm_vcpu_add(vm, vcpuid);
+	vcpu = vm_vcpu_add(vm, vcpu_id);
 
 	/* Setup guest registers */
-	vcpu_regs_get(vm, vcpuid, &regs);
+	vcpu_regs_get(vm, vcpu_id, &regs);
 	regs.gprs[15] = stack_vaddr + (DEFAULT_STACK_PGS * getpagesize()) - 160;
-	vcpu_regs_set(vm, vcpuid, &regs);
+	vcpu_regs_set(vm, vcpu_id, &regs);
 
-	vcpu_sregs_get(vm, vcpuid, &sregs);
+	vcpu_sregs_get(vm, vcpu_id, &sregs);
 	sregs.crs[0] |= 0x00040000;		/* Enable floating point regs */
 	sregs.crs[1] = vm->pgd | 0xf;		/* Primary region table */
-	vcpu_sregs_set(vm, vcpuid, &sregs);
+	vcpu_sregs_set(vm, vcpu_id, &sregs);
 
-	run = vcpu_state(vm, vcpuid);
+	run = vcpu_state(vm, vcpu_id);
 	run->psw_mask = 0x0400000180000000ULL;  /* DAT enabled + 64 bit mode */
 	run->psw_addr = (uintptr_t)guest_code;
+
+	return vcpu;
 }
 
 void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index c5335345323c..1d0c6d49b8a9 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -633,29 +633,33 @@ void vm_xsave_req_perm(int bit)
 		    bitmask);
 }
 
-void vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
+				  void *guest_code)
 {
 	struct kvm_mp_state mp_state;
 	struct kvm_regs regs;
 	vm_vaddr_t stack_vaddr;
+	struct kvm_vcpu *vcpu;
+
 	stack_vaddr = vm_vaddr_alloc(vm, DEFAULT_STACK_PGS * getpagesize(),
 				     DEFAULT_GUEST_STACK_VADDR_MIN);
 
-	/* Create VCPU */
-	vm_vcpu_add(vm, vcpuid);
-	vcpu_set_cpuid(vm, vcpuid, kvm_get_supported_cpuid());
-	vcpu_setup(vm, vcpuid);
+	vcpu = vm_vcpu_add(vm, vcpu_id);
+	vcpu_set_cpuid(vm, vcpu_id, kvm_get_supported_cpuid());
+	vcpu_setup(vm, vcpu_id);
 
 	/* Setup guest general purpose registers */
-	vcpu_regs_get(vm, vcpuid, &regs);
+	vcpu_regs_get(vm, vcpu_id, &regs);
 	regs.rflags = regs.rflags | 0x2;
 	regs.rsp = stack_vaddr + (DEFAULT_STACK_PGS * getpagesize());
 	regs.rip = (unsigned long) guest_code;
-	vcpu_regs_set(vm, vcpuid, &regs);
+	vcpu_regs_set(vm, vcpu_id, &regs);
 
 	/* Setup the MP state */
 	mp_state.mp_state = 0;
-	vcpu_set_mp_state(vm, vcpuid, &mp_state);
+	vcpu_set_mp_state(vm, vcpu_id, &mp_state);
+
+	return vcpu;
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 535af2d2ad59..38f109ab0fee 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -346,10 +346,8 @@ static void test_pmu_config_disable(void (*guest_code)(void))
 	cap.args[0] = KVM_PMU_CAP_DISABLE;
 	vm_enable_cap(vm, &cap);
 
-	vm_vcpu_add_default(vm, 0, guest_code);
+	vcpu = vm_vcpu_add_default(vm, 0, guest_code);
 	vm_init_descriptor_tables(vm);
-
-	vcpu = vcpu_get(vm, 0);
 	vcpu_init_descriptor_tables(vm, vcpu->id);
 
 	TEST_ASSERT(!sanity_check_pmu(vcpu),
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
index b7cd5c47fc53..ea70ca2e63c3 100644
--- a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
+++ b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
@@ -54,8 +54,7 @@ static void *run_vcpu(void *_cpu_nr)
 	/* The kernel is fine, but vm_vcpu_add_default() needs locking */
 	pthread_spin_lock(&create_lock);
 
-	vm_vcpu_add_default(vm, vcpu_id, guest_code);
-	vcpu = vcpu_get(vm, vcpu_id);
+	vcpu = vm_vcpu_add_default(vm, vcpu_id, guest_code);
 
 	if (!first_cpu_done) {
 		first_cpu_done = true;
-- 
2.36.0.464.gb9c8b46e94-goog

