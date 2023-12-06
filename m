Return-Path: <kvm+bounces-3730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52A1B807604
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 18:03:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1335B281995
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01CBA67E93;
	Wed,  6 Dec 2023 17:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="o3ikoF4v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8581BD4E
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 09:02:51 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-a1ca24776c3so216780566b.0
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 09:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701882170; x=1702486970; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AcBIMhww9wb3bxDDHF38JEgvvCtddJAUjdEzDPF+NGI=;
        b=o3ikoF4vuoHF1/uuZ6oawRREnp4LQ1KmY98uJ6dLhg5wfYHW/Zu1pFW3ROsVKN0QdW
         qZefDzuznMO7J7V0pAc8CgIHa23zeFpKIk7pJPfOFCETjgkbMV9IT+cZ4o1Z9VzJro9X
         OyCMTLrR11G3npKvedBwT7fVqY0ypzh5yHx047EgqJCYS5FAq/qvldbV00zTpEuSAbTu
         GSkXxtvdjFf7MZ+Y1b0AgoOkkyPPUizzBbbKJR1gk0GbhwJYO+tZ6BcAuiC7SvBvt2D7
         Y8LUS9623yunAbJYdBT30iz6BMuS3JPZZqoZo2KIWNPyc7GZuzq14HD12ZSJsQAbBARE
         eX7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701882170; x=1702486970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AcBIMhww9wb3bxDDHF38JEgvvCtddJAUjdEzDPF+NGI=;
        b=xQCg3BqA0VKWcy8EHA+eN3ZZIs/WQ4TQ3muUse9D8uPXqp/mtocSjthfLoROOwcs0x
         HgUUKJjyIO8ZIveCPSegt8fj+gWs1p6U6FZT3SW3EUSDRQ80h5x3ktffMaKLv9mYcoUe
         Sm+Hb9u1nEQbWBNeUidz0WNnZ8GT127GcFBCznEWkGBb2PWAW64bdSw15c1ZgfF/9oJs
         A2QxCPpPceZlULA8XoHX88s9da+Nlh67qKuJ7bt0dUcA05QHBFNstGpZ39zfNn0NBkvS
         puNOzfvoGbn9nkhEjSY5p1i/JCOQwaOEAq0zKF28VkZke4sYHou5J0re81aEudy+fC/Y
         U/qg==
X-Gm-Message-State: AOJu0YzWNOLaRDz+trE2cd0mVdZBXOKJatLXLESZ9NYd8rdwePkWcVcC
	IEc+VR4H9IanSnMzEJP73hnudXjaFG7OKkurAG4=
X-Google-Smtp-Source: AGHT+IEhs0WHTsbrQ44rgMcfR04T2x/4fr+syKDtwXg3IvrYKqs148NbgsH5ldSFqS/9wdx6qZi2sg==
X-Received: by 2002:a17:906:110b:b0:a1e:11ea:ee15 with SMTP id h11-20020a170906110b00b00a1e11eaee15mr594228eja.77.1701882169932;
        Wed, 06 Dec 2023 09:02:49 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id dt16-20020a170906b79000b00a1e377ea78asm176802ejb.50.2023.12.06.09.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 09:02:49 -0800 (PST)
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
Subject: [PATCH 5/5] KVM: selftests: x86_64: Remove redundant newlines
Date: Wed,  6 Dec 2023 18:02:47 +0100
Message-ID: <20231206170241.82801-12-ajones@ventanamicro.com>
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
 .../selftests/kvm/lib/x86_64/processor.c      | 10 +++----
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  6 ++--
 tools/testing/selftests/kvm/x86_64/amx_test.c |  2 +-
 .../testing/selftests/kvm/x86_64/cpuid_test.c |  4 +--
 .../selftests/kvm/x86_64/flds_emulation.h     |  2 +-
 .../selftests/kvm/x86_64/hyperv_clock.c       |  4 +--
 .../testing/selftests/kvm/x86_64/hyperv_ipi.c |  2 +-
 .../selftests/kvm/x86_64/hyperv_tlb_flush.c   |  2 +-
 .../selftests/kvm/x86_64/kvm_clock_test.c     |  8 +++---
 .../selftests/kvm/x86_64/platform_info_test.c |  2 +-
 .../kvm/x86_64/pmu_event_filter_test.c        |  2 +-
 .../selftests/kvm/x86_64/sev_migrate_tests.c  | 28 +++++++++----------
 .../smaller_maxphyaddr_emulation_test.c       |  4 +--
 .../selftests/kvm/x86_64/sync_regs_test.c     | 10 +++----
 .../kvm/x86_64/ucna_injection_test.c          |  8 +++---
 .../selftests/kvm/x86_64/userspace_io_test.c  |  2 +-
 .../kvm/x86_64/vmx_apic_access_test.c         |  2 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c | 16 +++++------
 .../vmx_exception_with_invalid_guest_state.c  |  2 +-
 .../selftests/kvm/x86_64/xapic_ipi_test.c     |  8 +++---
 .../selftests/kvm/x86_64/xcr0_cpuid_test.c    |  2 +-
 .../selftests/kvm/x86_64/xss_msr_test.c       |  2 +-
 22 files changed, 64 insertions(+), 64 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index d8288374078e..4bc52948447d 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -170,10 +170,10 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 		 * this level.
 		 */
 		TEST_ASSERT(current_level != target_level,
-			    "Cannot create hugepage at level: %u, vaddr: 0x%lx\n",
+			    "Cannot create hugepage at level: %u, vaddr: 0x%lx",
 			    current_level, vaddr);
 		TEST_ASSERT(!(*pte & PTE_LARGE_MASK),
-			    "Cannot create page table at level: %u, vaddr: 0x%lx\n",
+			    "Cannot create page table at level: %u, vaddr: 0x%lx",
 			    current_level, vaddr);
 	}
 	return pte;
@@ -220,7 +220,7 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 	/* Fill in page table entry. */
 	pte = virt_get_pte(vm, pde, vaddr, PG_LEVEL_4K);
 	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
-		    "PTE already present for 4k page at vaddr: 0x%lx\n", vaddr);
+		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
 	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
 }
 
@@ -253,7 +253,7 @@ static bool vm_is_target_pte(uint64_t *pte, int *level, int current_level)
 	if (*pte & PTE_LARGE_MASK) {
 		TEST_ASSERT(*level == PG_LEVEL_NONE ||
 			    *level == current_level,
-			    "Unexpected hugepage at level %d\n", current_level);
+			    "Unexpected hugepage at level %d", current_level);
 		*level = current_level;
 	}
 
@@ -825,7 +825,7 @@ void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...)
 	struct kvm_regs regs;
 
 	TEST_ASSERT(num >= 1 && num <= 6, "Unsupported number of args,\n"
-		    "  num: %u\n",
+		    "  num: %u",
 		    num);
 
 	va_start(ap, num);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 59d97531c9b1..089b8925b6b2 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -54,7 +54,7 @@ int vcpu_enable_evmcs(struct kvm_vcpu *vcpu)
 	/* KVM should return supported EVMCS version range */
 	TEST_ASSERT(((evmcs_ver >> 8) >= (evmcs_ver & 0xff)) &&
 		    (evmcs_ver & 0xff) > 0,
-		    "Incorrect EVMCS version range: %x:%x\n",
+		    "Incorrect EVMCS version range: %x:%x",
 		    evmcs_ver & 0xff, evmcs_ver >> 8);
 
 	return evmcs_ver;
@@ -387,10 +387,10 @@ static void nested_create_pte(struct kvm_vm *vm,
 		 * this level.
 		 */
 		TEST_ASSERT(current_level != target_level,
-			    "Cannot create hugepage at level: %u, nested_paddr: 0x%lx\n",
+			    "Cannot create hugepage at level: %u, nested_paddr: 0x%lx",
 			    current_level, nested_paddr);
 		TEST_ASSERT(!pte->page_size,
-			    "Cannot create page table at level: %u, nested_paddr: 0x%lx\n",
+			    "Cannot create page table at level: %u, nested_paddr: 0x%lx",
 			    current_level, nested_paddr);
 	}
 }
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 11329e5ff945..f7da543570ad 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -296,7 +296,7 @@ int main(int argc, char *argv[])
 				void *tiles_data = (void *)addr_gva2hva(vm, tiledata);
 				/* Only check TMM0 register, 1 tile */
 				ret = memcmp(amx_start, tiles_data, TILE_SIZE);
-				TEST_ASSERT(ret == 0, "memcmp failed, ret=%d\n", ret);
+				TEST_ASSERT(ret == 0, "memcmp failed, ret=%d", ret);
 				kvm_x86_state_cleanup(state);
 				break;
 			case 9:
diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index 3b34d8156d1c..8c579ce714e9 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -84,7 +84,7 @@ static void compare_cpuids(const struct kvm_cpuid2 *cpuid1,
 
 		TEST_ASSERT(e1->function == e2->function &&
 			    e1->index == e2->index && e1->flags == e2->flags,
-			    "CPUID entries[%d] mismtach: 0x%x.%d.%x vs. 0x%x.%d.%x\n",
+			    "CPUID entries[%d] mismtach: 0x%x.%d.%x vs. 0x%x.%d.%x",
 			    i, e1->function, e1->index, e1->flags,
 			    e2->function, e2->index, e2->flags);
 
@@ -170,7 +170,7 @@ static void test_get_cpuid2(struct kvm_vcpu *vcpu)
 
 	vcpu_ioctl(vcpu, KVM_GET_CPUID2, cpuid);
 	TEST_ASSERT(cpuid->nent == vcpu->cpuid->nent,
-		    "KVM didn't update nent on success, wanted %u, got %u\n",
+		    "KVM didn't update nent on success, wanted %u, got %u",
 		    vcpu->cpuid->nent, cpuid->nent);
 
 	for (i = 0; i < vcpu->cpuid->nent; i++) {
diff --git a/tools/testing/selftests/kvm/x86_64/flds_emulation.h b/tools/testing/selftests/kvm/x86_64/flds_emulation.h
index 0a1573d52882..37b1a9f52864 100644
--- a/tools/testing/selftests/kvm/x86_64/flds_emulation.h
+++ b/tools/testing/selftests/kvm/x86_64/flds_emulation.h
@@ -41,7 +41,7 @@ static inline void handle_flds_emulation_failure_exit(struct kvm_vcpu *vcpu)
 
 	insn_bytes = run->emulation_failure.insn_bytes;
 	TEST_ASSERT(insn_bytes[0] == 0xd9 && insn_bytes[1] == 0,
-		    "Expected 'flds [eax]', opcode '0xd9 0x00', got opcode 0x%02x 0x%02x\n",
+		    "Expected 'flds [eax]', opcode '0xd9 0x00', got opcode 0x%02x 0x%02x",
 		    insn_bytes[0], insn_bytes[1]);
 
 	vcpu_regs_get(vcpu, &regs);
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
index f25749eaa6a8..12518fee5534 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
@@ -218,7 +218,7 @@ int main(void)
 	tsc_page_gva = vm_vaddr_alloc_page(vm);
 	memset(addr_gva2hva(vm, tsc_page_gva), 0x0, getpagesize());
 	TEST_ASSERT((addr_gva2gpa(vm, tsc_page_gva) & (getpagesize() - 1)) == 0,
-		"TSC page has to be page aligned\n");
+		"TSC page has to be page aligned");
 	vcpu_args_set(vcpu, 2, tsc_page_gva, addr_gva2gpa(vm, tsc_page_gva));
 
 	host_check_tsc_msr_rdtsc(vcpu);
@@ -235,7 +235,7 @@ int main(void)
 			break;
 		case UCALL_DONE:
 			/* Keep in sync with guest_main() */
-			TEST_ASSERT(stage == 11, "Testing ended prematurely, stage %d\n",
+			TEST_ASSERT(stage == 11, "Testing ended prematurely, stage %d",
 				    stage);
 			goto out;
 		default:
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c b/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
index 6feb5ddb031d..606c138a935d 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
@@ -287,7 +287,7 @@ int main(int argc, char *argv[])
 		switch (get_ucall(vcpu[0], &uc)) {
 		case UCALL_SYNC:
 			TEST_ASSERT(uc.args[1] == stage,
-				    "Unexpected stage: %ld (%d expected)\n",
+				    "Unexpected stage: %ld (%d expected)",
 				    uc.args[1], stage);
 			break;
 		case UCALL_DONE:
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
index 4758b6ef5618..c32aa1ab02e5 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
@@ -656,7 +656,7 @@ int main(int argc, char *argv[])
 		switch (get_ucall(vcpu[0], &uc)) {
 		case UCALL_SYNC:
 			TEST_ASSERT(uc.args[1] == stage,
-				    "Unexpected stage: %ld (%d expected)\n",
+				    "Unexpected stage: %ld (%d expected)",
 				    uc.args[1], stage);
 			break;
 		case UCALL_ABORT:
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
index 1778704360a6..bbceba0c59fb 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
@@ -92,7 +92,7 @@ static void setup_clock(struct kvm_vm *vm, struct test_case *test_case)
 				break;
 		} while (errno == EINTR);
 
-		TEST_ASSERT(!r, "clock_gettime() failed: %d\n", r);
+		TEST_ASSERT(!r, "clock_gettime() failed: %d", r);
 
 		data.realtime = ts.tv_sec * NSEC_PER_SEC;
 		data.realtime += ts.tv_nsec;
@@ -127,7 +127,7 @@ static void enter_guest(struct kvm_vcpu *vcpu)
 			handle_abort(&uc);
 			return;
 		default:
-			TEST_ASSERT(0, "unhandled ucall: %ld\n", uc.cmd);
+			TEST_ASSERT(0, "unhandled ucall: %ld", uc.cmd);
 		}
 	}
 }
@@ -154,7 +154,7 @@ static void check_clocksource(void)
 	}
 
 	clk_name = malloc(st.st_size);
-	TEST_ASSERT(clk_name, "failed to allocate buffer to read file\n");
+	TEST_ASSERT(clk_name, "failed to allocate buffer to read file");
 
 	if (!fgets(clk_name, st.st_size, fp)) {
 		pr_info("failed to read clocksource file: %d; assuming TSC.\n",
@@ -162,7 +162,7 @@ static void check_clocksource(void)
 		goto out;
 	}
 
-	TEST_ASSERT(!strncmp(clk_name, "tsc\n", st.st_size),
+	TEST_ASSERT(!strncmp(clk_name, "tsc", st.st_size),
 		    "clocksource not supported: %s", clk_name);
 out:
 	fclose(fp);
diff --git a/tools/testing/selftests/kvm/x86_64/platform_info_test.c b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
index c9a07963d68a..87011965dc41 100644
--- a/tools/testing/selftests/kvm/x86_64/platform_info_test.c
+++ b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
@@ -44,7 +44,7 @@ static void test_msr_platform_info_enabled(struct kvm_vcpu *vcpu)
 
 	get_ucall(vcpu, &uc);
 	TEST_ASSERT(uc.cmd == UCALL_SYNC,
-			"Received ucall other than UCALL_SYNC: %lu\n", uc.cmd);
+			"Received ucall other than UCALL_SYNC: %lu", uc.cmd);
 	TEST_ASSERT((uc.args[1] & MSR_PLATFORM_INFO_MAX_TURBO_RATIO) ==
 		MSR_PLATFORM_INFO_MAX_TURBO_RATIO,
 		"Expected MSR_PLATFORM_INFO to have max turbo ratio mask: %i.",
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 283cc55597a4..a3bd54b925ab 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -866,7 +866,7 @@ static void __test_fixed_counter_bitmap(struct kvm_vcpu *vcpu, uint8_t idx,
 	 * userspace doesn't set any pmu filter.
 	 */
 	count = run_vcpu_to_sync(vcpu);
-	TEST_ASSERT(count, "Unexpected count value: %ld\n", count);
+	TEST_ASSERT(count, "Unexpected count value: %ld", count);
 
 	for (i = 0; i < BIT(nr_fixed_counters); i++) {
 		bitmap = BIT(i);
diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index c7ef97561038..a49828adf294 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -91,7 +91,7 @@ static void sev_migrate_from(struct kvm_vm *dst, struct kvm_vm *src)
 	int ret;
 
 	ret = __sev_migrate_from(dst, src);
-	TEST_ASSERT(!ret, "Migration failed, ret: %d, errno: %d\n", ret, errno);
+	TEST_ASSERT(!ret, "Migration failed, ret: %d, errno: %d", ret, errno);
 }
 
 static void test_sev_migrate_from(bool es)
@@ -113,7 +113,7 @@ static void test_sev_migrate_from(bool es)
 	/* Migrate the guest back to the original VM. */
 	ret = __sev_migrate_from(src_vm, dst_vms[NR_MIGRATE_TEST_VMS - 1]);
 	TEST_ASSERT(ret == -1 && errno == EIO,
-		    "VM that was migrated from should be dead. ret %d, errno: %d\n", ret,
+		    "VM that was migrated from should be dead. ret %d, errno: %d", ret,
 		    errno);
 
 	kvm_vm_free(src_vm);
@@ -172,7 +172,7 @@ static void test_sev_migrate_parameters(void)
 	vm_no_sev = aux_vm_create(true);
 	ret = __sev_migrate_from(vm_no_vcpu, vm_no_sev);
 	TEST_ASSERT(ret == -1 && errno == EINVAL,
-		    "Migrations require SEV enabled. ret %d, errno: %d\n", ret,
+		    "Migrations require SEV enabled. ret %d, errno: %d", ret,
 		    errno);
 
 	if (!have_sev_es)
@@ -187,25 +187,25 @@ static void test_sev_migrate_parameters(void)
 	ret = __sev_migrate_from(sev_vm, sev_es_vm);
 	TEST_ASSERT(
 		ret == -1 && errno == EINVAL,
-		"Should not be able migrate to SEV enabled VM. ret: %d, errno: %d\n",
+		"Should not be able migrate to SEV enabled VM. ret: %d, errno: %d",
 		ret, errno);
 
 	ret = __sev_migrate_from(sev_es_vm, sev_vm);
 	TEST_ASSERT(
 		ret == -1 && errno == EINVAL,
-		"Should not be able migrate to SEV-ES enabled VM. ret: %d, errno: %d\n",
+		"Should not be able migrate to SEV-ES enabled VM. ret: %d, errno: %d",
 		ret, errno);
 
 	ret = __sev_migrate_from(vm_no_vcpu, sev_es_vm);
 	TEST_ASSERT(
 		ret == -1 && errno == EINVAL,
-		"SEV-ES migrations require same number of vCPUS. ret: %d, errno: %d\n",
+		"SEV-ES migrations require same number of vCPUS. ret: %d, errno: %d",
 		ret, errno);
 
 	ret = __sev_migrate_from(vm_no_vcpu, sev_es_vm_no_vmsa);
 	TEST_ASSERT(
 		ret == -1 && errno == EINVAL,
-		"SEV-ES migrations require UPDATE_VMSA. ret %d, errno: %d\n",
+		"SEV-ES migrations require UPDATE_VMSA. ret %d, errno: %d",
 		ret, errno);
 
 	kvm_vm_free(sev_vm);
@@ -227,7 +227,7 @@ static void sev_mirror_create(struct kvm_vm *dst, struct kvm_vm *src)
 	int ret;
 
 	ret = __sev_mirror_create(dst, src);
-	TEST_ASSERT(!ret, "Copying context failed, ret: %d, errno: %d\n", ret, errno);
+	TEST_ASSERT(!ret, "Copying context failed, ret: %d, errno: %d", ret, errno);
 }
 
 static void verify_mirror_allowed_cmds(int vm_fd)
@@ -259,7 +259,7 @@ static void verify_mirror_allowed_cmds(int vm_fd)
 		ret = __sev_ioctl(vm_fd, cmd_id, NULL, &fw_error);
 		TEST_ASSERT(
 			ret == -1 && errno == EINVAL,
-			"Should not be able call command: %d. ret: %d, errno: %d\n",
+			"Should not be able call command: %d. ret: %d, errno: %d",
 			cmd_id, ret, errno);
 	}
 
@@ -301,18 +301,18 @@ static void test_sev_mirror_parameters(void)
 	ret = __sev_mirror_create(sev_vm, sev_vm);
 	TEST_ASSERT(
 		ret == -1 && errno == EINVAL,
-		"Should not be able copy context to self. ret: %d, errno: %d\n",
+		"Should not be able copy context to self. ret: %d, errno: %d",
 		ret, errno);
 
 	ret = __sev_mirror_create(vm_no_vcpu, vm_with_vcpu);
 	TEST_ASSERT(ret == -1 && errno == EINVAL,
-		    "Copy context requires SEV enabled. ret %d, errno: %d\n", ret,
+		    "Copy context requires SEV enabled. ret %d, errno: %d", ret,
 		    errno);
 
 	ret = __sev_mirror_create(vm_with_vcpu, sev_vm);
 	TEST_ASSERT(
 		ret == -1 && errno == EINVAL,
-		"SEV copy context requires no vCPUS on the destination. ret: %d, errno: %d\n",
+		"SEV copy context requires no vCPUS on the destination. ret: %d, errno: %d",
 		ret, errno);
 
 	if (!have_sev_es)
@@ -322,13 +322,13 @@ static void test_sev_mirror_parameters(void)
 	ret = __sev_mirror_create(sev_vm, sev_es_vm);
 	TEST_ASSERT(
 		ret == -1 && errno == EINVAL,
-		"Should not be able copy context to SEV enabled VM. ret: %d, errno: %d\n",
+		"Should not be able copy context to SEV enabled VM. ret: %d, errno: %d",
 		ret, errno);
 
 	ret = __sev_mirror_create(sev_es_vm, sev_vm);
 	TEST_ASSERT(
 		ret == -1 && errno == EINVAL,
-		"Should not be able copy context to SEV-ES enabled VM. ret: %d, errno: %d\n",
+		"Should not be able copy context to SEV-ES enabled VM. ret: %d, errno: %d",
 		ret, errno);
 
 	kvm_vm_free(sev_es_vm);
diff --git a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
index 06edf00a97d6..1a46dd7bb391 100644
--- a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
@@ -74,7 +74,7 @@ int main(int argc, char *argv[])
 				    MEM_REGION_SIZE / PAGE_SIZE, 0);
 	gpa = vm_phy_pages_alloc(vm, MEM_REGION_SIZE / PAGE_SIZE,
 				 MEM_REGION_GPA, MEM_REGION_SLOT);
-	TEST_ASSERT(gpa == MEM_REGION_GPA, "Failed vm_phy_pages_alloc\n");
+	TEST_ASSERT(gpa == MEM_REGION_GPA, "Failed vm_phy_pages_alloc");
 	virt_map(vm, MEM_REGION_GVA, MEM_REGION_GPA, 1);
 	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
 	memset(hva, 0, PAGE_SIZE);
@@ -102,7 +102,7 @@ int main(int argc, char *argv[])
 	case UCALL_DONE:
 		break;
 	default:
-		TEST_FAIL("Unrecognized ucall: %lu\n", uc.cmd);
+		TEST_FAIL("Unrecognized ucall: %lu", uc.cmd);
 	}
 
 	kvm_vm_free(vm);
diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
index 00965ba33f73..a91b5b145fa3 100644
--- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
@@ -46,7 +46,7 @@ static void compare_regs(struct kvm_regs *left, struct kvm_regs *right)
 #define REG_COMPARE(reg) \
 	TEST_ASSERT(left->reg == right->reg, \
 		    "Register " #reg \
-		    " values did not match: 0x%llx, 0x%llx\n", \
+		    " values did not match: 0x%llx, 0x%llx", \
 		    left->reg, right->reg)
 	REG_COMPARE(rax);
 	REG_COMPARE(rbx);
@@ -230,14 +230,14 @@ int main(int argc, char *argv[])
 	run->kvm_valid_regs = INVALID_SYNC_FIELD;
 	rv = _vcpu_run(vcpu);
 	TEST_ASSERT(rv < 0 && errno == EINVAL,
-		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d\n",
+		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d",
 		    rv);
 	run->kvm_valid_regs = 0;
 
 	run->kvm_valid_regs = INVALID_SYNC_FIELD | TEST_SYNC_FIELDS;
 	rv = _vcpu_run(vcpu);
 	TEST_ASSERT(rv < 0 && errno == EINVAL,
-		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d\n",
+		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d",
 		    rv);
 	run->kvm_valid_regs = 0;
 
@@ -245,14 +245,14 @@ int main(int argc, char *argv[])
 	run->kvm_dirty_regs = INVALID_SYNC_FIELD;
 	rv = _vcpu_run(vcpu);
 	TEST_ASSERT(rv < 0 && errno == EINVAL,
-		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d\n",
+		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d",
 		    rv);
 	run->kvm_dirty_regs = 0;
 
 	run->kvm_dirty_regs = INVALID_SYNC_FIELD | TEST_SYNC_FIELDS;
 	rv = _vcpu_run(vcpu);
 	TEST_ASSERT(rv < 0 && errno == EINVAL,
-		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d\n",
+		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d",
 		    rv);
 	run->kvm_dirty_regs = 0;
 
diff --git a/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c b/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
index 0ed32ec903d0..dcbb3c29fb8e 100644
--- a/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
+++ b/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
@@ -143,7 +143,7 @@ static void run_vcpu_expect_gp(struct kvm_vcpu *vcpu)
 
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_SYNC,
-		    "Expect UCALL_SYNC\n");
+		    "Expect UCALL_SYNC");
 	TEST_ASSERT(uc.args[1] == SYNC_GP, "#GP is expected.");
 	printf("vCPU received GP in guest.\n");
 }
@@ -188,7 +188,7 @@ static void *run_ucna_injection(void *arg)
 
 	TEST_ASSERT_KVM_EXIT_REASON(params->vcpu, KVM_EXIT_IO);
 	TEST_ASSERT(get_ucall(params->vcpu, &uc) == UCALL_SYNC,
-		    "Expect UCALL_SYNC\n");
+		    "Expect UCALL_SYNC");
 	TEST_ASSERT(uc.args[1] == SYNC_FIRST_UCNA, "Injecting first UCNA.");
 
 	printf("Injecting first UCNA at %#x.\n", FIRST_UCNA_ADDR);
@@ -198,7 +198,7 @@ static void *run_ucna_injection(void *arg)
 
 	TEST_ASSERT_KVM_EXIT_REASON(params->vcpu, KVM_EXIT_IO);
 	TEST_ASSERT(get_ucall(params->vcpu, &uc) == UCALL_SYNC,
-		    "Expect UCALL_SYNC\n");
+		    "Expect UCALL_SYNC");
 	TEST_ASSERT(uc.args[1] == SYNC_SECOND_UCNA, "Injecting second UCNA.");
 
 	printf("Injecting second UCNA at %#x.\n", SECOND_UCNA_ADDR);
@@ -208,7 +208,7 @@ static void *run_ucna_injection(void *arg)
 
 	TEST_ASSERT_KVM_EXIT_REASON(params->vcpu, KVM_EXIT_IO);
 	if (get_ucall(params->vcpu, &uc) == UCALL_ABORT) {
-		TEST_ASSERT(false, "vCPU assertion failure: %s.\n",
+		TEST_ASSERT(false, "vCPU assertion failure: %s.",
 			    (const char *)uc.args[0]);
 	}
 
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_io_test.c b/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
index 255c50b0dc32..9481cbcf284f 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
@@ -71,7 +71,7 @@ int main(int argc, char *argv[])
 			break;
 
 		TEST_ASSERT(run->io.port == 0x80,
-			    "Expected I/O at port 0x80, got port 0x%x\n", run->io.port);
+			    "Expected I/O at port 0x80, got port 0x%x", run->io.port);
 
 		/*
 		 * Modify the rep string count in RCX: 2 => 1 and 3 => 8192.
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c b/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
index 2bed5fb3a0d6..a81a24761aac 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
@@ -99,7 +99,7 @@ int main(int argc, char *argv[])
 			TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_INTERNAL_ERROR);
 			TEST_ASSERT(run->internal.suberror ==
 				    KVM_INTERNAL_ERROR_EMULATION,
-				    "Got internal suberror other than KVM_INTERNAL_ERROR_EMULATION: %u\n",
+				    "Got internal suberror other than KVM_INTERNAL_ERROR_EMULATION: %u",
 				    run->internal.suberror);
 			break;
 		}
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
index e4ad5fef52ff..7f6f5f23fb9b 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
@@ -128,17 +128,17 @@ int main(int argc, char *argv[])
 			 */
 			kvm_vm_get_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap);
 			if (uc.args[1]) {
-				TEST_ASSERT(test_bit(0, bmap), "Page 0 incorrectly reported clean\n");
-				TEST_ASSERT(host_test_mem[0] == 1, "Page 0 not written by guest\n");
+				TEST_ASSERT(test_bit(0, bmap), "Page 0 incorrectly reported clean");
+				TEST_ASSERT(host_test_mem[0] == 1, "Page 0 not written by guest");
 			} else {
-				TEST_ASSERT(!test_bit(0, bmap), "Page 0 incorrectly reported dirty\n");
-				TEST_ASSERT(host_test_mem[0] == 0xaaaaaaaaaaaaaaaaULL, "Page 0 written by guest\n");
+				TEST_ASSERT(!test_bit(0, bmap), "Page 0 incorrectly reported dirty");
+				TEST_ASSERT(host_test_mem[0] == 0xaaaaaaaaaaaaaaaaULL, "Page 0 written by guest");
 			}
 
-			TEST_ASSERT(!test_bit(1, bmap), "Page 1 incorrectly reported dirty\n");
-			TEST_ASSERT(host_test_mem[4096 / 8] == 0xaaaaaaaaaaaaaaaaULL, "Page 1 written by guest\n");
-			TEST_ASSERT(!test_bit(2, bmap), "Page 2 incorrectly reported dirty\n");
-			TEST_ASSERT(host_test_mem[8192 / 8] == 0xaaaaaaaaaaaaaaaaULL, "Page 2 written by guest\n");
+			TEST_ASSERT(!test_bit(1, bmap), "Page 1 incorrectly reported dirty");
+			TEST_ASSERT(host_test_mem[4096 / 8] == 0xaaaaaaaaaaaaaaaaULL, "Page 1 written by guest");
+			TEST_ASSERT(!test_bit(2, bmap), "Page 2 incorrectly reported dirty");
+			TEST_ASSERT(host_test_mem[8192 / 8] == 0xaaaaaaaaaaaaaaaaULL, "Page 2 written by guest");
 			break;
 		case UCALL_DONE:
 			done = true;
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c b/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c
index a9b827c69f32..fad3634fd9eb 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c
@@ -28,7 +28,7 @@ static void __run_vcpu_with_invalid_state(struct kvm_vcpu *vcpu)
 
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_INTERNAL_ERROR);
 	TEST_ASSERT(run->emulation_failure.suberror == KVM_INTERNAL_ERROR_EMULATION,
-		    "Expected emulation failure, got %d\n",
+		    "Expected emulation failure, got %d",
 		    run->emulation_failure.suberror);
 }
 
diff --git a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
index 67ac2a3292ef..725c206ba0b9 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
@@ -216,7 +216,7 @@ static void *vcpu_thread(void *arg)
 			    "Halting vCPU halted %lu times, woke %lu times, received %lu IPIs.\n"
 			    "Halter TPR=%#x PPR=%#x LVR=%#x\n"
 			    "Migrations attempted: %lu\n"
-			    "Migrations completed: %lu\n",
+			    "Migrations completed: %lu",
 			    vcpu->id, (const char *)uc.args[0],
 			    params->data->ipis_sent, params->data->hlt_count,
 			    params->data->wake_count,
@@ -288,7 +288,7 @@ void do_migrations(struct test_data_page *data, int run_secs, int delay_usecs,
 	}
 
 	TEST_ASSERT(nodes > 1,
-		    "Did not find at least 2 numa nodes. Can't do migration\n");
+		    "Did not find at least 2 numa nodes. Can't do migration");
 
 	fprintf(stderr, "Migrating amongst %d nodes found\n", nodes);
 
@@ -347,7 +347,7 @@ void do_migrations(struct test_data_page *data, int run_secs, int delay_usecs,
 				    wake_count != data->wake_count,
 				    "IPI, HLT and wake count have not increased "
 				    "in the last %lu seconds. "
-				    "HLTer is likely hung.\n", interval_secs);
+				    "HLTer is likely hung.", interval_secs);
 
 			ipis_sent = data->ipis_sent;
 			hlt_count = data->hlt_count;
@@ -381,7 +381,7 @@ void get_cmdline_args(int argc, char *argv[], int *run_secs,
 				    "-m adds calls to migrate_pages while vCPUs are running."
 				    " Default is no migrations.\n"
 				    "-d <delay microseconds> - delay between migrate_pages() calls."
-				    " Default is %d microseconds.\n",
+				    " Default is %d microseconds.",
 				    DEFAULT_RUN_SECS, DEFAULT_DELAY_USECS);
 		}
 	}
diff --git a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
index dc6217440db3..25a0b0db5c3c 100644
--- a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
@@ -116,7 +116,7 @@ int main(int argc, char *argv[])
 		vcpu_run(vcpu);
 
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "Unexpected exit reason: %u (%s),\n",
+			    "Unexpected exit reason: %u (%s),",
 			    run->exit_reason,
 			    exit_reason_str(run->exit_reason));
 
diff --git a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
index e0ddf47362e7..167c97abff1b 100644
--- a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
@@ -29,7 +29,7 @@ int main(int argc, char *argv[])
 
 	xss_val = vcpu_get_msr(vcpu, MSR_IA32_XSS);
 	TEST_ASSERT(xss_val == 0,
-		    "MSR_IA32_XSS should be initialized to zero\n");
+		    "MSR_IA32_XSS should be initialized to zero");
 
 	vcpu_set_msr(vcpu, MSR_IA32_XSS, xss_val);
 
-- 
2.43.0


