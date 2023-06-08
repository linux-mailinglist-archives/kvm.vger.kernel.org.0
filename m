Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262727275B1
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 05:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbjFHDZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 23:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234117AbjFHDZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 23:25:01 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5474926A2
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 20:24:56 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-25669acf1b0so123722a91.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 20:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686194695; x=1688786695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mtkn8MG1l6d0rnDrKg50x+C49aCaIkLucrOXa80nT/k=;
        b=V3stYaLM6PVapxKi5aRX9P/lJi1xylmQzw3KYmDO7XEzUlPyt1stDvmmVOh/a5fNFQ
         z/vRjEJ/P+q+jOYfp2z7FVumostFaXImY8n9qisiuTSpXyGkarykZtwzHjSpsErE3lUL
         5FfLwaKjztr8oLBJxbbE0in/s8pQm+0nx3UehpRJSIwnQChrrBeZdIgCtEQrQzx9UBuy
         T4neAPWs0Q+mBauXMQHi82s8HUaqNp3LTSEWetsXt7PPQea/R7sMQ+rjj+ZW9jnuFZeD
         4vkTyinNiNgDSLjTjkCpri+rBhKPuL2pEFUMWuURiXB+yAQ8jn4zjRNrwL0MEID2CzDq
         JNcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686194695; x=1688786695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mtkn8MG1l6d0rnDrKg50x+C49aCaIkLucrOXa80nT/k=;
        b=Wz3GP7U2g/pmbmOXrGi9l/A0+s3ZPHa5Tw6HBkpgNFYnOEQFUGJk0UChFUGZTVQlq5
         3T/4D4ptuMlA/c+MK0hQsQWbXbhyLkQIBoF1GpvjHgfKovd2kWOMXD6HX/8MEcLU+b92
         R/wwP49tbCN9KvO5ew1+G0NJ0KXAY99jjDcjdFljN+nrpOApp33FoPcuAmRM+dNrSEir
         PxKoU0UWKe4oIRE7gXk6BfcsdpAFiHQmj5CK9M9mAYCgRcuKf+g574zcW4aYq2ZLLA+x
         R70Pd/AjANI5dgmHQ8LDIeTw9a6Xw1sWF7TPw5VURQK39s3d+AOigOaOgf8sSUaG5TWW
         uMPQ==
X-Gm-Message-State: AC+VfDytdtINPhZOxc5qXeFlkxVOO/NYuvtEooIlMX9ir056KwuTY+ZJ
        cT/VTTntA0Qo8MD/vXF4osnUgTnZgE4=
X-Google-Smtp-Source: ACHHUZ6Ux01aJrb26kNNuYZTHJe9RtcE09reTQxW8rVOcqTYksMpZ22HkHCycmfnzX2MS6V2yty44w==
X-Received: by 2002:a17:90a:a42:b0:259:224a:9cf9 with SMTP id o60-20020a17090a0a4200b00259224a9cf9mr6677604pjo.36.1686194695062;
        Wed, 07 Jun 2023 20:24:55 -0700 (PDT)
Received: from wheely.local0.net (58-6-224-112.tpgi.com.au. [58.6.224.112])
        by smtp.gmail.com with ESMTPSA id s12-20020a17090a5d0c00b0025930e50e28sm2015629pji.41.2023.06.07.20.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 20:24:54 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 5/6] KVM: PPC: selftests: Add a TLBIEL virtualisation tester
Date:   Thu,  8 Jun 2023 13:24:24 +1000
Message-Id: <20230608032425.59796-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608032425.59796-1-npiggin@gmail.com>
References: <20230608032425.59796-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TLBIEL virtualisation has been a source of difficulty. The TLBIEL
instruction operates on the TLB of the hardware thread which
executes it, but the behaviour expected by the guest environment

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/powerpc/processor.h |   7 +
 .../selftests/kvm/lib/powerpc/processor.c     | 108 +++-
 .../selftests/kvm/powerpc/tlbiel_test.c       | 508 ++++++++++++++++++
 4 files changed, 621 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/powerpc/tlbiel_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index efb8700b9752..aa3a8ca676c2 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -186,6 +186,7 @@ TEST_GEN_PROGS_riscv += kvm_binary_stats_test
 
 TEST_GEN_PROGS_powerpc += powerpc/null_test
 TEST_GEN_PROGS_powerpc += powerpc/rtas_hcall
+TEST_GEN_PROGS_powerpc += powerpc/tlbiel_test
 TEST_GEN_PROGS_powerpc += access_tracking_perf_test
 TEST_GEN_PROGS_powerpc += demand_paging_test
 TEST_GEN_PROGS_powerpc += dirty_log_test
diff --git a/tools/testing/selftests/kvm/include/powerpc/processor.h b/tools/testing/selftests/kvm/include/powerpc/processor.h
index ce5a23525dbd..92ef6476a9ef 100644
--- a/tools/testing/selftests/kvm/include/powerpc/processor.h
+++ b/tools/testing/selftests/kvm/include/powerpc/processor.h
@@ -7,6 +7,7 @@
 
 #include <linux/compiler.h>
 #include "ppc_asm.h"
+#include "kvm_util_base.h"
 
 extern unsigned char __interrupts_start[];
 extern unsigned char __interrupts_end[];
@@ -31,6 +32,12 @@ struct ex_regs {
 void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 			void (*handler)(struct ex_regs *));
 
+vm_paddr_t virt_pt_duplicate(struct kvm_vm *vm);
+void set_radix_proc_table(struct kvm_vm *vm, int pid, vm_paddr_t pgd);
+bool virt_wrprotect_pte(struct kvm_vm *vm, uint64_t gva);
+bool virt_wrenable_pte(struct kvm_vm *vm, uint64_t gva);
+bool virt_remap_pte(struct kvm_vm *vm, uint64_t gva, vm_paddr_t gpa);
+
 static inline void cpu_relax(void)
 {
 	asm volatile("" ::: "memory");
diff --git a/tools/testing/selftests/kvm/lib/powerpc/processor.c b/tools/testing/selftests/kvm/lib/powerpc/processor.c
index 02db2ff86da8..17ea440f9026 100644
--- a/tools/testing/selftests/kvm/lib/powerpc/processor.c
+++ b/tools/testing/selftests/kvm/lib/powerpc/processor.c
@@ -23,7 +23,7 @@ static void set_proc_table(struct kvm_vm *vm, int pid, uint64_t dw0, uint64_t dw
 	proc_table[pid * 2 + 1] = cpu_to_be64(dw1);
 }
 
-static void set_radix_proc_table(struct kvm_vm *vm, int pid, vm_paddr_t pgd)
+void set_radix_proc_table(struct kvm_vm *vm, int pid, vm_paddr_t pgd)
 {
 	set_proc_table(vm, pid, pgd | RADIX_TREE_SIZE | RADIX_PGD_INDEX_SIZE, 0);
 }
@@ -146,9 +146,69 @@ static uint64_t *virt_get_pte(struct kvm_vm *vm, vm_paddr_t pt,
 #define PDE_NLS		0x0000000000000011ull
 #define PDE_PT_MASK	0x0fffffffffffff00ull
 
-void virt_arch_pg_map(struct kvm_vm *vm, uint64_t gva, uint64_t gpa)
+static uint64_t *virt_lookup_pte(struct kvm_vm *vm, uint64_t gva)
 {
 	vm_paddr_t pt = vm->pgd;
+	uint64_t *ptep;
+	int level;
+
+	for (level = 1; level <= 3; level++) {
+		uint64_t nls;
+		uint64_t *pdep = virt_get_pte(vm, pt, gva, level, &nls);
+		uint64_t pde = be64_to_cpu(*pdep);
+
+		if (pde) {
+			TEST_ASSERT((pde & PDE_VALID) && !(pde & PTE_LEAF),
+				"Invalid PDE at level: %u gva: 0x%lx pde:0x%lx\n",
+				level, gva, pde);
+			pt = pde & PDE_PT_MASK;
+			continue;
+		}
+
+		return NULL;
+	}
+
+	ptep = virt_get_pte(vm, pt, gva, level, NULL);
+
+	return ptep;
+}
+
+static bool virt_modify_pte(struct kvm_vm *vm, uint64_t gva, uint64_t clr, uint64_t set)
+{
+	uint64_t *ptep, pte;
+
+	ptep = virt_lookup_pte(vm, gva);
+	if (!ptep)
+		return false;
+
+	pte = be64_to_cpu(*ptep);
+	if (!(pte & PTE_VALID))
+		return false;
+
+	pte = (pte & ~clr) | set;
+	*ptep = cpu_to_be64(pte);
+
+	return true;
+}
+
+bool virt_remap_pte(struct kvm_vm *vm, uint64_t gva, vm_paddr_t gpa)
+{
+	return virt_modify_pte(vm, gva, PTE_PAGE_MASK, (gpa & PTE_PAGE_MASK));
+}
+
+bool virt_wrprotect_pte(struct kvm_vm *vm, uint64_t gva)
+{
+	return virt_modify_pte(vm, gva, PTE_RW, 0);
+}
+
+bool virt_wrenable_pte(struct kvm_vm *vm, uint64_t gva)
+{
+	return virt_modify_pte(vm, gva, 0, PTE_RW);
+}
+
+static void __virt_arch_pg_map(struct kvm_vm *vm, vm_paddr_t pgd, uint64_t gva, uint64_t gpa)
+{
+	vm_paddr_t pt = pgd;
 	uint64_t *ptep, pte;
 	int level;
 
@@ -187,6 +247,49 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t gva, uint64_t gpa)
 	*ptep = cpu_to_be64(pte);
 }
 
+void virt_arch_pg_map(struct kvm_vm *vm, uint64_t gva, uint64_t gpa)
+{
+	__virt_arch_pg_map(vm, vm->pgd, gva, gpa);
+}
+
+static void __virt_pt_duplicate(struct kvm_vm *vm, vm_paddr_t pgd, vm_paddr_t pt, vm_vaddr_t va, int level)
+{
+	uint64_t *page_table;
+	int size, idx;
+
+	page_table = addr_gpa2hva(vm, pt);
+	size = 1U << pt_shift(vm, level);
+	for (idx = 0; idx < size; idx++) {
+		uint64_t pte = be64_to_cpu(page_table[idx]);
+		if (pte & PTE_VALID) {
+			if (pte & PTE_LEAF) {
+				__virt_arch_pg_map(vm, pgd, va, pte & PTE_PAGE_MASK);
+			} else {
+				__virt_pt_duplicate(vm, pgd, pte & PDE_PT_MASK, va, level + 1);
+			}
+		}
+		va += pt_entry_coverage(vm, level);
+	}
+}
+
+vm_paddr_t virt_pt_duplicate(struct kvm_vm *vm)
+{
+	vm_paddr_t pgtb;
+	uint64_t *page_table;
+	size_t pgd_pages;
+
+	pgd_pages = 1UL << ((RADIX_PGD_INDEX_SIZE + 3) >> vm->page_shift);
+	TEST_ASSERT(pgd_pages == 1, "PGD allocation must be single page");
+	pgtb = vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+				 vm->memslots[MEM_REGION_PT]);
+	page_table = addr_gpa2hva(vm, pgtb);
+	memset(page_table, 0, vm->page_size * pgd_pages);
+
+	__virt_pt_duplicate(vm, pgtb, vm->pgd, 0, 1);
+
+	return pgtb;
+}
+
 vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	vm_paddr_t pt = vm->pgd;
@@ -244,7 +347,6 @@ static void virt_dump_pt(FILE *stream, struct kvm_vm *vm, vm_paddr_t pt,
 				     level + 1, indent + 2);
 		}
 	}
-
 }
 
 void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
diff --git a/tools/testing/selftests/kvm/powerpc/tlbiel_test.c b/tools/testing/selftests/kvm/powerpc/tlbiel_test.c
new file mode 100644
index 000000000000..63ffcff15617
--- /dev/null
+++ b/tools/testing/selftests/kvm/powerpc/tlbiel_test.c
@@ -0,0 +1,508 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test TLBIEL virtualisation. The TLBIEL instruction operates on cached
+ * translations of the hardware thread and/or core which executes it, but the
+ * behaviour required of the guest is that it should invalidate cached
+ * translations visible to the vCPU that executed it. The instruction can
+ * not be trapped by the hypervisor.
+ *
+ * This requires that when a vCPU is migrated to a different hardware thread,
+ * KVM must ensure that no potentially stale translations be visible on
+ * the new hardware thread. Implementing this has been a source of
+ * difficulty.
+ *
+ * This test tries to create and invalidate different kinds oftranslations
+ * while moving vCPUs between CPUs, and checking for stale translations.
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sched.h>
+#include <sys/ioctl.h>
+#include <sys/time.h>
+#include <sys/sysinfo.h>
+#include <signal.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "kselftest.h"
+#include "processor.h"
+#include "helpers.h"
+
+static int nr_cpus;
+static int *cpu_array;
+
+static void set_cpu(int cpu)
+{
+	cpu_set_t set;
+
+	CPU_ZERO(&set);
+	CPU_SET(cpu, &set);
+
+	if (sched_setaffinity(0, sizeof(set), &set) == -1) {
+		perror("sched_setaffinity");
+		exit(1);
+	}
+}
+
+static void set_random_cpu(void)
+{
+	set_cpu(cpu_array[random() % nr_cpus]);
+}
+
+static void init_sched_cpu(void)
+{
+	cpu_set_t possible_mask;
+	int i, cnt, nproc;
+
+	nproc = get_nprocs_conf();
+
+	TEST_ASSERT(!sched_getaffinity(0, sizeof(possible_mask), &possible_mask),
+		"sched_getaffinity failed, errno = %d (%s)", errno, strerror(errno));
+
+	nr_cpus = CPU_COUNT(&possible_mask);
+	cpu_array = malloc(nr_cpus * sizeof(int));
+
+	cnt = 0;
+	for (i = 0; i < nproc; i++) {
+		if (CPU_ISSET(i, &possible_mask)) {
+			cpu_array[cnt] = i;
+			cnt++;
+		}
+	}
+}
+
+static volatile bool timeout;
+
+static void set_timer(int sec)
+{
+	struct itimerval timer;
+
+	timeout = false;
+
+	timer.it_value.tv_sec  = sec;
+	timer.it_value.tv_usec = 0;
+	timer.it_interval = timer.it_value;
+	TEST_ASSERT(setitimer(ITIMER_REAL, &timer, NULL) == 0,
+			"setitimer failed %s", strerror(errno));
+}
+
+static void sigalrm_handler(int sig)
+{
+	timeout = true;
+}
+
+static void init_timers(void)
+{
+	TEST_ASSERT(signal(SIGALRM, sigalrm_handler) != SIG_ERR,
+		    "Failed to register SIGALRM handler, errno = %d (%s)",
+		    errno, strerror(errno));
+}
+
+static inline void virt_invalidate_tlb(uint64_t gva)
+{
+	unsigned long rb, rs;
+	unsigned long is = 2, ric = 0, prs = 1, r = 1;
+
+	rb = is << 10;
+	rs = 0;
+
+	asm volatile("ptesync ; .machine push ; .machine power9 ; tlbiel %0,%1,%2,%3,%4 ; .machine pop ; ptesync"
+			:: "r"(rb), "r"(rs), "i"(ric), "i"(prs), "i"(r)
+			: "memory");
+}
+
+static inline void virt_invalidate_pwc(uint64_t gva)
+{
+	unsigned long rb, rs;
+	unsigned long is = 2, ric = 1, prs = 1, r = 1;
+
+	rb = is << 10;
+	rs = 0;
+
+	asm volatile("ptesync ; .machine push ; .machine power9 ; tlbiel %0,%1,%2,%3,%4 ; .machine pop ; ptesync"
+			:: "r"(rb), "r"(rs), "i"(ric), "i"(prs), "i"(r)
+			: "memory");
+}
+
+static inline void virt_invalidate_all(uint64_t gva)
+{
+	unsigned long rb, rs;
+	unsigned long is = 2, ric = 2, prs = 1, r = 1;
+
+	rb = is << 10;
+	rs = 0;
+
+	asm volatile("ptesync ; .machine push ; .machine power9 ; tlbiel %0,%1,%2,%3,%4 ; .machine pop ; ptesync"
+			:: "r"(rb), "r"(rs), "i"(ric), "i"(prs), "i"(r)
+			: "memory");
+}
+
+static inline void virt_invalidate_page(uint64_t gva)
+{
+	unsigned long rb, rs;
+	unsigned long is = 0, ric = 0, prs = 1, r = 1;
+	unsigned long ap = 0x5;
+	unsigned long epn = gva & ~0xffffUL;
+	unsigned long pid = 0;
+
+	rb = epn | (is << 10) | (ap << 5);
+	rs = pid << 32;
+
+	asm volatile("ptesync ; .machine push ; .machine power9 ; tlbiel %0,%1,%2,%3,%4 ; .machine pop ; ptesync"
+			:: "r"(rb), "r"(rs), "i"(ric), "i"(prs), "i"(r)
+			: "memory");
+}
+
+enum {
+	SYNC_BEFORE_LOAD1,
+	SYNC_BEFORE_LOAD2,
+	SYNC_BEFORE_STORE,
+	SYNC_BEFORE_INVALIDATE,
+	SYNC_DSI,
+};
+
+static void remap_dsi_handler(struct ex_regs *regs)
+{
+	GUEST_ASSERT(0);
+}
+
+#define PAGE1_VAL 0x1234567890abcdef
+#define PAGE2_VAL 0x5c5c5c5c5c5c5c5c
+
+static void remap_guest_code(vm_vaddr_t page)
+{
+	unsigned long *mem = (void *)page;
+
+	for (;;) {
+		unsigned long tmp;
+
+		GUEST_SYNC(SYNC_BEFORE_LOAD1);
+		asm volatile("ld %0,%1" : "=r"(tmp) : "m"(*mem));
+		GUEST_ASSERT(tmp == PAGE1_VAL);
+		GUEST_SYNC(SYNC_BEFORE_INVALIDATE);
+		virt_invalidate_page(page);
+		GUEST_SYNC(SYNC_BEFORE_LOAD2);
+		asm volatile("ld %0,%1" : "=r"(tmp) : "m"(*mem));
+		GUEST_ASSERT(tmp == PAGE2_VAL);
+		GUEST_SYNC(SYNC_BEFORE_INVALIDATE);
+		virt_invalidate_page(page);
+	}
+}
+
+static void remap_test(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	vm_vaddr_t vaddr;
+	vm_paddr_t pages[2];
+	uint64_t *hostptr;
+
+	/* Create VM */
+	vm = vm_create_with_one_vcpu(&vcpu, remap_guest_code);
+	vm_install_exception_handler(vm, 0x300, remap_dsi_handler);
+
+	vaddr = vm_vaddr_alloc_page(vm);
+	pages[0] = addr_gva2gpa(vm, vaddr);
+	pages[1] = vm_phy_page_alloc(vm, 0, vm->memslots[MEM_REGION_DATA]);
+
+	hostptr = addr_gpa2hva(vm, pages[0]);
+	*hostptr = PAGE1_VAL;
+
+	hostptr = addr_gpa2hva(vm, pages[1]);
+	*hostptr = PAGE2_VAL;
+
+	vcpu_args_set(vcpu, 1, vaddr);
+
+	set_random_cpu();
+	set_timer(10);
+
+	while (!timeout) {
+		vcpu_run(vcpu);
+
+		host_sync(vcpu, SYNC_BEFORE_LOAD1);
+		set_random_cpu();
+		vcpu_run(vcpu);
+
+		host_sync(vcpu, SYNC_BEFORE_INVALIDATE);
+		set_random_cpu();
+		TEST_ASSERT(virt_remap_pte(vm, vaddr, pages[1]), "Remap page1 failed");
+		vcpu_run(vcpu);
+
+		host_sync(vcpu, SYNC_BEFORE_LOAD2);
+		set_random_cpu();
+		vcpu_run(vcpu);
+
+		host_sync(vcpu, SYNC_BEFORE_INVALIDATE);
+		TEST_ASSERT(virt_remap_pte(vm, vaddr, pages[0]), "Remap page0 failed");
+		set_random_cpu();
+	}
+
+	vm_install_exception_handler(vm, 0x300, NULL);
+
+	kvm_vm_free(vm);
+}
+
+static void wrprotect_dsi_handler(struct ex_regs *regs)
+{
+	GUEST_SYNC(SYNC_DSI);
+	regs->nia += 4;
+}
+
+static void wrprotect_guest_code(vm_vaddr_t page)
+{
+	volatile char *mem = (void *)page;
+
+	for (;;) {
+		GUEST_SYNC(SYNC_BEFORE_STORE);
+		asm volatile("stb %1,%0" : "=m"(*mem) : "r"(1));
+		GUEST_SYNC(SYNC_BEFORE_INVALIDATE);
+		virt_invalidate_page(page);
+	}
+}
+
+static void wrprotect_test(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	vm_vaddr_t page;
+	void *hostptr;
+
+	/* Create VM */
+	vm = vm_create_with_one_vcpu(&vcpu, wrprotect_guest_code);
+	vm_install_exception_handler(vm, 0x300, wrprotect_dsi_handler);
+
+	page = vm_vaddr_alloc_page(vm);
+	hostptr = addr_gva2hva(vm, page);
+	memset(hostptr, 0, vm->page_size);
+
+	vcpu_args_set(vcpu, 1, page);
+
+	set_random_cpu();
+	set_timer(10);
+
+	while (!timeout) {
+		vcpu_run(vcpu);
+		host_sync(vcpu, SYNC_BEFORE_STORE);
+
+		vcpu_run(vcpu);
+		host_sync(vcpu, SYNC_BEFORE_INVALIDATE);
+
+		TEST_ASSERT(virt_wrprotect_pte(vm, page), "Wrprotect page failed");
+		/* Invalidate on different CPU */
+		set_random_cpu();
+		vcpu_run(vcpu);
+		host_sync(vcpu, SYNC_BEFORE_STORE);
+
+		/* Store on different CPU */
+		set_random_cpu();
+		vcpu_run(vcpu);
+		host_sync(vcpu, SYNC_DSI);
+		vcpu_run(vcpu);
+		host_sync(vcpu, SYNC_BEFORE_INVALIDATE);
+
+		TEST_ASSERT(virt_wrenable_pte(vm, page), "Wrenable page failed");
+
+		/* Invalidate on different CPU when we go around */
+		set_random_cpu();
+	}
+
+	vm_install_exception_handler(vm, 0x300, NULL);
+
+	kvm_vm_free(vm);
+}
+
+static void wrp_mt_dsi_handler(struct ex_regs *regs)
+{
+	GUEST_SYNC(SYNC_DSI);
+	regs->nia += 4;
+}
+
+static void wrp_mt_guest_code(vm_vaddr_t page, bool invalidates)
+{
+	volatile char *mem = (void *)page;
+
+	for (;;) {
+		GUEST_SYNC(SYNC_BEFORE_STORE);
+		asm volatile("stb %1,%0" : "=m"(*mem) : "r"(1));
+		if (invalidates) {
+			GUEST_SYNC(SYNC_BEFORE_INVALIDATE);
+			virt_invalidate_page(page);
+		}
+	}
+}
+
+static void wrp_mt_test(void)
+{
+	struct kvm_vcpu *vcpu[2];
+	struct kvm_vm *vm;
+	vm_vaddr_t page;
+	void *hostptr;
+
+	/* Create VM */
+	vm = vm_create_with_vcpus(2, wrp_mt_guest_code, vcpu);
+	vm_install_exception_handler(vm, 0x300, wrp_mt_dsi_handler);
+
+	page = vm_vaddr_alloc_page(vm);
+	hostptr = addr_gva2hva(vm, page);
+	memset(hostptr, 0, vm->page_size);
+
+	vcpu_args_set(vcpu[0], 2, page, 1);
+	vcpu_args_set(vcpu[1], 2, page, 0);
+
+	set_random_cpu();
+	set_timer(10);
+
+	while (!timeout) {
+		/* Run vcpu[1] only when page is writable, should never fault */
+		vcpu_run(vcpu[1]);
+		host_sync(vcpu[1], SYNC_BEFORE_STORE);
+
+		vcpu_run(vcpu[0]);
+		host_sync(vcpu[0], SYNC_BEFORE_STORE);
+
+		vcpu_run(vcpu[0]);
+		host_sync(vcpu[0], SYNC_BEFORE_INVALIDATE);
+
+		TEST_ASSERT(virt_wrprotect_pte(vm, page), "Wrprotect page failed");
+		/* Invalidate on different CPU */
+		set_random_cpu();
+		vcpu_run(vcpu[0]);
+		host_sync(vcpu[0], SYNC_BEFORE_STORE);
+
+		/* Store on different CPU */
+		set_random_cpu();
+		vcpu_run(vcpu[0]);
+		host_sync(vcpu[0], SYNC_DSI);
+		vcpu_run(vcpu[0]);
+		host_sync(vcpu[0], SYNC_BEFORE_INVALIDATE);
+
+		TEST_ASSERT(virt_wrenable_pte(vm, page), "Wrenable page failed");
+		/* Invalidate on different CPU when we go around */
+		set_random_cpu();
+	}
+
+	vm_install_exception_handler(vm, 0x300, NULL);
+
+	kvm_vm_free(vm);
+}
+
+static void proctbl_dsi_handler(struct ex_regs *regs)
+{
+	GUEST_SYNC(SYNC_DSI);
+	regs->nia += 4;
+}
+
+static void proctbl_guest_code(vm_vaddr_t page)
+{
+	volatile char *mem = (void *)page;
+
+	for (;;) {
+		GUEST_SYNC(SYNC_BEFORE_STORE);
+		asm volatile("stb %1,%0" : "=m"(*mem) : "r"(1));
+		GUEST_SYNC(SYNC_BEFORE_INVALIDATE);
+		virt_invalidate_all(page);
+	}
+}
+
+static void proctbl_test(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	vm_vaddr_t page;
+	vm_paddr_t orig_pgd;
+	vm_paddr_t alternate_pgd;
+	void *hostptr;
+
+	/* Create VM */
+	vm = vm_create_with_one_vcpu(&vcpu, proctbl_guest_code);
+	vm_install_exception_handler(vm, 0x300, proctbl_dsi_handler);
+
+	page = vm_vaddr_alloc_page(vm);
+	hostptr = addr_gva2hva(vm, page);
+	memset(hostptr, 0, vm->page_size);
+
+	orig_pgd = vm->pgd;
+	alternate_pgd = virt_pt_duplicate(vm);
+
+	/* Write protect the original PTE */
+	TEST_ASSERT(virt_wrprotect_pte(vm, page), "Wrprotect page failed");
+
+	vm->pgd = alternate_pgd;
+	set_radix_proc_table(vm, 0, vm->pgd);
+
+	vcpu_args_set(vcpu, 1, page);
+
+	set_random_cpu();
+	set_timer(10);
+
+	while (!timeout) {
+		vcpu_run(vcpu);
+		host_sync(vcpu, SYNC_BEFORE_STORE);
+
+		vcpu_run(vcpu);
+		host_sync(vcpu, SYNC_BEFORE_INVALIDATE);
+		/* Writeable store succeeds */
+
+		/* Swap page tables to write protected one */
+		vm->pgd = orig_pgd;
+		set_radix_proc_table(vm, 0, vm->pgd);
+
+		/* Invalidate on different CPU */
+		set_random_cpu();
+		vcpu_run(vcpu);
+		host_sync(vcpu, SYNC_BEFORE_STORE);
+
+		/* Store on different CPU */
+		set_random_cpu();
+		vcpu_run(vcpu);
+		host_sync(vcpu, SYNC_DSI);
+		vcpu_run(vcpu);
+		host_sync(vcpu, SYNC_BEFORE_INVALIDATE);
+
+		/* Swap page tables to write enabled one */
+		vm->pgd = alternate_pgd;
+		set_radix_proc_table(vm, 0, vm->pgd);
+
+		/* Invalidate on different CPU when we go around */
+		set_random_cpu();
+	}
+	vm->pgd = orig_pgd;
+	set_radix_proc_table(vm, 0, vm->pgd);
+
+	vm_install_exception_handler(vm, 0x300, NULL);
+
+	kvm_vm_free(vm);
+}
+
+struct testdef {
+	const char *name;
+	void (*test)(void);
+} testlist[] = {
+	{ "tlbiel wrprotect test", wrprotect_test},
+	{ "tlbiel wrprotect 2-vCPU test", wrp_mt_test},
+	{ "tlbiel process table update test", proctbl_test},
+	{ "tlbiel remap test", remap_test},
+};
+
+int main(int argc, char *argv[])
+{
+	int idx;
+
+	ksft_print_header();
+
+	ksft_set_plan(ARRAY_SIZE(testlist));
+
+	init_sched_cpu();
+	init_timers();
+
+	for (idx = 0; idx < ARRAY_SIZE(testlist); idx++) {
+		testlist[idx].test();
+		ksft_test_result_pass("%s\n", testlist[idx].name);
+	}
+
+	ksft_finished();	/* Print results and exit() accordingly */
+}
-- 
2.40.1

