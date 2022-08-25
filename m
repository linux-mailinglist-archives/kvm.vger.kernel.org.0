Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193BC5A1D29
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 01:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244515AbiHYXZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 19:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243968AbiHYXZc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 19:25:32 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFE257549
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 16:25:30 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id lb5-20020a17090b4a4500b001fd605b6e82so6640pjb.3
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 16:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=H5RlvRGSP/ix1mRgXBPUHLL5EWbYRn7MlqjBzDe0lOs=;
        b=p5zMBG8Tl6yM0dOgjpAOgSLAXxySRx12ucay5FwQxsdy43bIy+2T+Du81cKYIL7lYU
         aklm9veBhiecBxEKAYMEUxfs7tPw2Eshfo/CbgPIdy4P+xX52vuFHO50FovhRopbgJ1O
         5e8ihyTOdQZKxeg9btBRexIu53OuVCHtvTy1jX1Wb/paz9FI/nBljha83YA1DvXq1lxS
         rrRXQHWHoLbjTUswU5wSnQzshA0zK2WvZR6UIYVihua4zwlaAHdd1vfMvNKCB81El2r8
         m3s3Ke3i+NE6AIMnwzby47AtNytrH/GdaJLpqRpFmZYVPXz3p3VVW7SE6KJK0k5h5/hA
         yOkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=H5RlvRGSP/ix1mRgXBPUHLL5EWbYRn7MlqjBzDe0lOs=;
        b=ZTgkVJBQJKcwizJhKbH5pw5jo7tC2le9NMy+YAHYs8QlPNlD4OgPsFPLbog2bfipfd
         Ugn3yJC8un9//6g8LM0J/Q5HKzgeG4aSV6XfE7ZPJHBzxclmulNha1TEtDLDDbfaafqc
         NkqCInohth9s2TDjkL3V4kx9uYmdElUeLdqAFoR9pz038C7bZBLJMgy09Yh5iXW33+S1
         P5LtOV32YB9VRZfwOuHugc3zF8ar5vy63yPEaIHM/kFQYNBM2NJxhgChS+/hp2vN3ncR
         XzXJmpTsn+/WpmcZXSkw37xiB3sJUHxhXIsjLMRT6xy+hnqzjijg85N+x7Y47zv23+m6
         w5Ow==
X-Gm-Message-State: ACgBeo07CGDDj1ynbvhtp/9oj/VH9FsGlYDCL13d9GS7heSqNW0eNmyx
        or2wnoSBvL0kG88n4ONRcg1MKZi0110=
X-Google-Smtp-Source: AA6agR477ePEjCjkvxNcSgf/QcY+AgqkmADStXSoR1PXbgsqDI7Hhpajfke1HGLb+RoxO7/Mro4vErfDUh4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7c01:b0:16f:9649:be73 with SMTP id
 x1-20020a1709027c0100b0016f9649be73mr1295781pll.70.1661469929855; Thu, 25 Aug
 2022 16:25:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Aug 2022 23:25:18 +0000
In-Reply-To: <20220825232522.3997340-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220825232522.3997340-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220825232522.3997340-4-seanjc@google.com>
Subject: [PATCH v5 3/7] KVM: selftests: Automatically do init_ucall() for
 non-barebones VMs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Colton Lewis <coltonlewis@google.com>,
        Peter Gonda <pgonda@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do init_ucall() automatically during VM creation to kill two (three?)
birds with one stone.

First, initializing ucall immediately after VM creations allows forcing
aarch64's MMIO ucall address to immediately follow memslot0.  This is
still somewhat fragile as tests could clobber the MMIO address with a
new memslot, but it's safe-ish since tests have to be conversative when
accounting for memslot0.  And this can be hardened in the future by
creating a read-only memslot for the MMIO page (KVM ARM exits with MMIO
if the guest writes to a read-only memslot).  Add a TODO to document that
selftests can and should use a memslot for the ucall MMIO (doing so
requires yet more rework because tests assumes thay can use all memslots
except memslot0).

Second, initializing ucall for all VMs prepares for making ucall
initialization meaningful on all architectures.  aarch64 is currently the
only arch that needs to do any setup, but that will change in the future
by switching to a pool-based implementation (instead of the current
stack-based approach).

Lastly, defining the ucall MMIO address from common code will simplify
switching all architectures (except s390) to a common MMIO-based ucall
implementation (if there's ever sufficient motivation to do so).

Cc: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/arch_timer.c        |  1 -
 .../selftests/kvm/aarch64/debug-exceptions.c  |  1 -
 .../selftests/kvm/aarch64/hypercalls.c        |  1 -
 .../testing/selftests/kvm/aarch64/psci_test.c |  1 -
 .../testing/selftests/kvm/aarch64/vgic_init.c |  2 -
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |  1 -
 tools/testing/selftests/kvm/dirty_log_test.c  |  2 -
 .../selftests/kvm/include/ucall_common.h      |  6 +--
 .../selftests/kvm/kvm_page_table_test.c       |  1 -
 .../testing/selftests/kvm/lib/aarch64/ucall.c | 54 ++-----------------
 tools/testing/selftests/kvm/lib/kvm_util.c    | 11 ++++
 .../selftests/kvm/lib/perf_test_util.c        |  2 -
 tools/testing/selftests/kvm/lib/riscv/ucall.c |  2 +-
 tools/testing/selftests/kvm/lib/s390x/ucall.c |  2 +-
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |  2 +-
 .../testing/selftests/kvm/memslot_perf_test.c |  1 -
 tools/testing/selftests/kvm/rseq_test.c       |  1 -
 tools/testing/selftests/kvm/steal_time.c      |  1 -
 .../kvm/system_counter_offset_test.c          |  1 -
 19 files changed, 20 insertions(+), 73 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 574eb73f0e90..37c0ddebf4db 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -375,7 +375,6 @@ static struct kvm_vm *test_vm_create(void)
 	for (i = 0; i < nr_vcpus; i++)
 		vcpu_init_descriptor_tables(vcpus[i]);
 
-	ucall_init(vm, NULL);
 	test_init_timer_irq(vm);
 	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
 	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3");
diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 2ee35cf9801e..eaf225fd2a4a 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -254,7 +254,6 @@ int main(int argc, char *argv[])
 	int stage;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	ucall_init(vm, NULL);
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
index a39da3fe4952..3dceecfd1f62 100644
--- a/tools/testing/selftests/kvm/aarch64/hypercalls.c
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -236,7 +236,6 @@ static struct kvm_vm *test_vm_create(struct kvm_vcpu **vcpu)
 
 	vm = vm_create_with_one_vcpu(vcpu, guest_code);
 
-	ucall_init(vm, NULL);
 	steal_time_init(*vcpu);
 
 	return vm;
diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index f7621f6e938e..56278f3df891 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -77,7 +77,6 @@ static struct kvm_vm *setup_vm(void *guest_code, struct kvm_vcpu **source,
 	struct kvm_vm *vm;
 
 	vm = vm_create(2);
-	ucall_init(vm, NULL);
 
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
 	init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index e05ecb31823f..cc828fb53d8f 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -68,8 +68,6 @@ static void guest_code(void)
 /* we don't want to assert on run execution, hence that helper */
 static int run_vcpu(struct kvm_vcpu *vcpu)
 {
-	ucall_init(vcpu->vm, NULL);
-
 	return __vcpu_run(vcpu) ? -errno : 0;
 }
 
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 17417220a083..d1817f852daf 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -756,7 +756,6 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 	print_args(&args);
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	ucall_init(vm, NULL);
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 9c883c94d478..583b46250d07 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -754,8 +754,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	/* Cache the HVA pointer of the region */
 	host_test_mem = addr_gpa2hva(vm, (vm_paddr_t)guest_test_phys_mem);
 
-	ucall_init(vm, NULL);
-
 	/* Export the shared variables to the guest */
 	sync_global_to_guest(vm, host_page_size);
 	sync_global_to_guest(vm, guest_page_size);
diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 63bfc60be995..8077a6d8b1ba 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -24,7 +24,7 @@ struct ucall {
 	uint64_t args[UCALL_MAX_ARGS];
 };
 
-void ucall_arch_init(struct kvm_vm *vm, void *arg);
+void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
 void ucall_arch_uninit(struct kvm_vm *vm);
 void ucall_arch_do_ucall(vm_vaddr_t uc);
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
@@ -32,9 +32,9 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 void ucall(uint64_t cmd, int nargs, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 
-static inline void ucall_init(struct kvm_vm *vm, void *arg)
+static inline void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
-	ucall_arch_init(vm, arg);
+	ucall_arch_init(vm, mmio_gpa);
 }
 
 static inline void ucall_uninit(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index f42c6ac6d71d..20533c48ba3d 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -289,7 +289,6 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 	host_test_mem = addr_gpa2hva(vm, (vm_paddr_t)guest_test_phys_mem);
 
 	/* Export shared structure test_args to guest */
-	ucall_init(vm, NULL);
 	sync_global_to_guest(vm, test_args);
 
 	ret = sem_init(&test_stage_updated, 0, 0);
diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index f214f5cc53d3..f02ae27c3e43 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -8,60 +8,12 @@
 
 static vm_vaddr_t *ucall_exit_mmio_addr;
 
-static bool ucall_mmio_init(struct kvm_vm *vm, vm_paddr_t gpa)
+void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
-	if (kvm_userspace_memory_region_find(vm, gpa, gpa + 1))
-		return false;
+	virt_pg_map(vm, mmio_gpa, mmio_gpa);
 
-	virt_pg_map(vm, gpa, gpa);
-
-	ucall_exit_mmio_addr = (vm_vaddr_t *)gpa;
+	ucall_exit_mmio_addr = (vm_vaddr_t *)mmio_gpa;
 	sync_global_to_guest(vm, ucall_exit_mmio_addr);
-
-	return true;
-}
-
-void ucall_arch_init(struct kvm_vm *vm, void *arg)
-{
-	vm_paddr_t gpa, start, end, step, offset;
-	unsigned int bits;
-	bool ret;
-
-	if (arg) {
-		gpa = (vm_paddr_t)arg;
-		ret = ucall_mmio_init(vm, gpa);
-		TEST_ASSERT(ret, "Can't set ucall mmio address to %lx", gpa);
-		return;
-	}
-
-	/*
-	 * Find an address within the allowed physical and virtual address
-	 * spaces, that does _not_ have a KVM memory region associated with
-	 * it. Identity mapping an address like this allows the guest to
-	 * access it, but as KVM doesn't know what to do with it, it
-	 * will assume it's something userspace handles and exit with
-	 * KVM_EXIT_MMIO. Well, at least that's how it works for AArch64.
-	 * Here we start with a guess that the addresses around 5/8th
-	 * of the allowed space are unmapped and then work both down and
-	 * up from there in 1/16th allowed space sized steps.
-	 *
-	 * Note, we need to use VA-bits - 1 when calculating the allowed
-	 * virtual address space for an identity mapping because the upper
-	 * half of the virtual address space is the two's complement of the
-	 * lower and won't match physical addresses.
-	 */
-	bits = vm->va_bits - 1;
-	bits = min(vm->pa_bits, bits);
-	end = 1ul << bits;
-	start = end * 5 / 8;
-	step = end / 16;
-	for (offset = 0; offset < end - start; offset += step) {
-		if (ucall_mmio_init(vm, start - offset))
-			return;
-		if (ucall_mmio_init(vm, start + offset))
-			return;
-	}
-	TEST_FAIL("Can't find a ucall mmio address");
 }
 
 void ucall_arch_uninit(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9889fe0d8919..846f9f6c5a17 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -292,6 +292,7 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
 {
 	uint64_t nr_pages = vm_nr_pages_required(mode, nr_runnable_vcpus,
 						 nr_extra_pages);
+	struct userspace_mem_region *slot0;
 	struct kvm_vm *vm;
 
 	vm = ____vm_create(mode, nr_pages);
@@ -301,6 +302,16 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
 #ifdef __x86_64__
 	vm_create_irqchip(vm);
 #endif
+
+	/*
+	 * TODO: Add proper defines to protect the library's memslots, and then
+	 * carve out memslot1 for the ucall MMIO address.  KVM treats writes to
+	 * read-only memslots as MMIO, and creating a read-only memslot for the
+	 * MMIO region would prevent silently clobbering the MMIO region.
+	 */
+	slot0 = memslot2region(vm, 0);
+	ucall_init(vm, slot0->region.guest_phys_addr + slot0->region.memory_size);
+
 	return vm;
 }
 
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 9618b37c66f7..5161fa68cdf3 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -209,8 +209,6 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 		perf_test_setup_nested(vm, nr_vcpus, vcpus);
 	}
 
-	ucall_init(vm, NULL);
-
 	/* Export the shared variables to the guest. */
 	sync_global_to_guest(vm, perf_test_args);
 
diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
index 37e091d4366e..c58ecb8a0981 100644
--- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
+++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
@@ -10,7 +10,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-void ucall_arch_init(struct kvm_vm *vm, void *arg)
+void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
 }
 
diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
index 0f695a031d35..208f0f04299b 100644
--- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
+++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
@@ -6,7 +6,7 @@
  */
 #include "kvm_util.h"
 
-void ucall_arch_init(struct kvm_vm *vm, void *arg)
+void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
 }
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
index ead9946399ab..016a0487cf72 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
@@ -8,7 +8,7 @@
 
 #define UCALL_PIO_PORT ((uint16_t)0x1000)
 
-void ucall_arch_init(struct kvm_vm *vm, void *arg)
+void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
 }
 
diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 44995446d942..4ed5acd74278 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -277,7 +277,6 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 	TEST_ASSERT(data->hva_slots, "malloc() fail");
 
 	data->vm = __vm_create_with_one_vcpu(&data->vcpu, mempages, guest_code);
-	ucall_init(data->vm, NULL);
 
 	pr_info_v("Adding slots 1..%i, each slot with %"PRIu64" pages + %"PRIu64" extra pages last\n",
 		max_mem_slots - 1, data->pages_per_slot, rempages);
diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index fac248a43666..8dc745effb5e 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -224,7 +224,6 @@ int main(int argc, char *argv[])
 	 * CPU affinity.
 	 */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	ucall_init(vm, NULL);
 
 	pthread_create(&migration_thread, NULL, migration_worker,
 		       (void *)(unsigned long)gettid());
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index db8967f1a17b..c87f38712073 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -266,7 +266,6 @@ int main(int ac, char **av)
 	gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE * NR_VCPUS);
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
 	virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, gpages);
-	ucall_init(vm, NULL);
 
 	TEST_REQUIRE(is_steal_time_supported(vcpus[0]));
 
diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
index 1c274933912b..7f5b330b6a1b 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -121,7 +121,6 @@ int main(void)
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
 	check_preconditions(vcpu);
-	ucall_init(vm, NULL);
 
 	enter_guest(vcpu);
 	kvm_vm_free(vm);
-- 
2.37.2.672.g94769d06f0-goog

