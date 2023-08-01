Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4839A76A6B0
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 04:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbjHACCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 22:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbjHACCO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 22:02:14 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 631D019B4;
        Mon, 31 Jul 2023 19:02:12 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8CxbeuiZ8hkKcgNAA--.29989S3;
        Tue, 01 Aug 2023 10:02:10 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8BxHCOeZ8hkPHJDAA--.25753S4;
        Tue, 01 Aug 2023 10:02:07 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vishal Annapurve <vannapurve@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        Peter Xu <peterx@redhat.com>,
        Vipin Sharma <vipinsh@google.com>, maobibo@loongson.cn,
        zhaotianrui@loongson.cn
Subject: [PATCH v1 2/4] selftests: kvm: Add processor tests for LoongArch KVM
Date:   Tue,  1 Aug 2023 10:02:04 +0800
Message-Id: <20230801020206.1957986-3-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230801020206.1957986-1-zhaotianrui@loongson.cn>
References: <20230801020206.1957986-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8BxHCOeZ8hkPHJDAA--.25753S4
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add processor tests for LoongArch KVM, including vcpu initialize
and tlb refill exception handler.

Based-on: <20230720062813.4126751-1-zhaotianrui@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 .../selftests/kvm/lib/loongarch/exception.S   |  27 ++
 .../selftests/kvm/lib/loongarch/processor.c   | 367 ++++++++++++++++++
 2 files changed, 394 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/lib/loongarch/exception.S
 create mode 100644 tools/testing/selftests/kvm/lib/loongarch/processor.c

diff --git a/tools/testing/selftests/kvm/lib/loongarch/exception.S b/tools/testing/selftests/kvm/lib/loongarch/exception.S
new file mode 100644
index 000000000000..19dc50993da4
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/loongarch/exception.S
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include "sysreg.h"
+
+/* address of refill exception should be 4K aligned */
+.align  12
+.global handle_tlb_refill
+handle_tlb_refill:
+	csrwr	t0, LOONGARCH_CSR_TLBRSAVE
+	csrrd	t0, LOONGARCH_CSR_PGD
+	lddir	t0, t0, 3
+	lddir	t0, t0, 1
+	ldpte	t0, 0
+	ldpte	t0, 1
+	tlbfill
+	csrrd	t0, LOONGARCH_CSR_TLBRSAVE
+	ertn
+
+/* address of general exception should be 4K aligned */
+.align  12
+.global handle_exception
+handle_exception:
+1:
+	nop
+	b	1b
+	nop
+	ertn
diff --git a/tools/testing/selftests/kvm/lib/loongarch/processor.c b/tools/testing/selftests/kvm/lib/loongarch/processor.c
new file mode 100644
index 000000000000..2e50b6e2c556
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/loongarch/processor.c
@@ -0,0 +1,367 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM selftest LoongArch library code, including CPU-related functions.
+ *
+ */
+
+#include <assert.h>
+#include <linux/bitfield.h>
+#include <linux/compiler.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "sysreg.h"
+
+#define DEFAULT_LOONGARCH_GUEST_STACK_VADDR_MIN		0xac0000
+
+static uint64_t pgd_index(struct kvm_vm *vm, vm_vaddr_t gva)
+{
+	unsigned int shift;
+	uint64_t mask;
+
+	shift = (vm->pgtable_levels - 1) * (vm->page_shift - 3) + vm->page_shift;
+	mask = (1UL << (vm->va_bits - shift)) - 1;
+	return (gva >> shift) & mask;
+}
+
+static uint64_t pud_index(struct kvm_vm *vm, vm_vaddr_t gva)
+{
+	unsigned int shift;
+	uint64_t mask;
+
+	shift = 2 * (vm->page_shift - 3) + vm->page_shift;
+	mask = (1UL << (vm->page_shift - 3)) - 1;
+	TEST_ASSERT(vm->pgtable_levels == 4,
+		    "Mode %d does not have 4 page table levels", vm->mode);
+
+	return (gva >> shift) & mask;
+}
+
+static uint64_t pmd_index(struct kvm_vm *vm, vm_vaddr_t gva)
+{
+	unsigned int shift;
+	uint64_t mask;
+
+	shift = (vm->page_shift - 3) + vm->page_shift;
+	mask = (1UL << (vm->page_shift - 3)) - 1;
+	TEST_ASSERT(vm->pgtable_levels >= 3,
+		    "Mode %d does not have >= 3 page table levels", vm->mode);
+
+	return (gva >> shift) & mask;
+}
+
+static uint64_t pte_index(struct kvm_vm *vm, vm_vaddr_t gva)
+{
+	uint64_t mask;
+
+	mask = (1UL << (vm->page_shift - 3)) - 1;
+	return (gva >> vm->page_shift) & mask;
+}
+
+static uint64_t pte_addr(struct kvm_vm *vm, uint64_t entry)
+{
+	uint64_t mask;
+
+	mask = ((1UL << (vm->va_bits - vm->page_shift)) - 1) << vm->page_shift;
+	return entry & mask;
+}
+
+static uint64_t ptrs_per_pgd(struct kvm_vm *vm)
+{
+	unsigned int shift;
+
+	shift = (vm->pgtable_levels - 1) * (vm->page_shift - 3) + vm->page_shift;
+	return 1 << (vm->va_bits - shift);
+}
+
+static uint64_t __maybe_unused ptrs_per_pte(struct kvm_vm *vm)
+{
+	return 1 << (vm->page_shift - 3);
+}
+
+void virt_arch_pgd_alloc(struct kvm_vm *vm)
+{
+	if (vm->pgd_created)
+		return;
+
+	vm->pgd = vm_alloc_page_table(vm);
+	vm->pgd_created = true;
+}
+
+uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva)
+{
+	uint64_t *ptep;
+
+	if (!vm->pgd_created)
+		goto unmapped_gva;
+
+	ptep = addr_gpa2hva(vm, vm->pgd) + pgd_index(vm, gva) * 8;
+	if (!ptep)
+		goto unmapped_gva;
+
+	switch (vm->pgtable_levels) {
+	case 4:
+		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pud_index(vm, gva) * 8;
+		if (!ptep)
+			goto unmapped_gva;
+	case 3:
+		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pmd_index(vm, gva) * 8;
+		if (!ptep)
+			goto unmapped_gva;
+	case 2:
+		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pte_index(vm, gva) * 8;
+		if (!ptep)
+			goto unmapped_gva;
+		break;
+	default:
+		TEST_FAIL("Page table levels must be 2, 3, or 4");
+	}
+
+	return ptep;
+
+unmapped_gva:
+	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);
+	exit(EXIT_FAILURE);
+}
+
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+{
+	uint64_t *ptep;
+
+	ptep = virt_get_pte_hva(vm, gva);
+	return pte_addr(vm, *ptep) + (gva & (vm->page_size - 1));
+}
+
+void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
+{
+	uint32_t prot_bits;
+	uint64_t *ptep;
+
+	TEST_ASSERT((vaddr % vm->page_size) == 0,
+			"Virtual address not on page boundary,\n"
+			"vaddr: 0x%lx vm->page_size: 0x%x", vaddr, vm->page_size);
+	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid,
+			(vaddr >> vm->page_shift)),
+			"Invalid virtual address, vaddr: 0x%lx", vaddr);
+	TEST_ASSERT((paddr % vm->page_size) == 0,
+			"Physical address not on page boundary,\n"
+			"paddr: 0x%lx vm->page_size: 0x%x", paddr, vm->page_size);
+	TEST_ASSERT((paddr >> vm->page_shift) <= vm->max_gfn,
+			"Physical address beyond maximum supported,\n"
+			"paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
+			paddr, vm->max_gfn, vm->page_size);
+
+	ptep = addr_gpa2hva(vm, vm->pgd) + pgd_index(vm, vaddr) * 8;
+	if (!*ptep)
+		*ptep = vm_alloc_page_table(vm);
+
+	switch (vm->pgtable_levels) {
+	case 4:
+		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pud_index(vm, vaddr) * 8;
+		if (!*ptep)
+			*ptep = vm_alloc_page_table(vm);
+	case 3:
+		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pmd_index(vm, vaddr) * 8;
+		if (!*ptep)
+			*ptep = vm_alloc_page_table(vm);
+	case 2:
+		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pte_index(vm, vaddr) * 8;
+		break;
+	default:
+		TEST_FAIL("Page table levels must be 2, 3, or 4");
+	}
+
+	prot_bits = _PAGE_PRESENT | __READABLE | __WRITEABLE | _CACHE_CC;
+	prot_bits |= _PAGE_USER;
+	*ptep = paddr | prot_bits;
+}
+
+static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent, uint64_t page, int level)
+{
+#ifdef DEBUG
+	static const char * const type[] = { "", "pud", "pmd", "pte" };
+	uint64_t pte, *ptep;
+
+	if (level == 4)
+		return;
+
+	for (pte = page; pte < page + ptrs_per_pte(vm) * 8; pte += 8) {
+		ptep = addr_gpa2hva(vm, pte);
+		if (!*ptep)
+			continue;
+		fprintf(stream, "%*s%s: %lx: %lx at %p\n",
+			indent, "", type[level], pte, *ptep, ptep);
+		pte_dump(stream, vm, indent + 1, pte_addr(vm, *ptep), level + 1);
+	}
+#endif
+}
+
+void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
+{
+	int level;
+	uint64_t pgd, *ptep;
+
+	level = 4 - (vm->pgtable_levels - 1);
+	if (!vm->pgd_created)
+		return;
+
+	for (pgd = vm->pgd; pgd < vm->pgd + ptrs_per_pgd(vm) * 8; pgd += 8) {
+		ptep = addr_gpa2hva(vm, pgd);
+		if (!*ptep)
+			continue;
+		fprintf(stream, "%*spgd: %lx: %lx at %p\n", indent, "", pgd, *ptep, ptep);
+		pte_dump(stream, vm, indent + 1, pte_addr(vm, *ptep), level);
+	}
+}
+
+void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
+{
+}
+
+void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
+{
+}
+
+void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...)
+{
+	va_list ap;
+	struct kvm_regs regs;
+	int i;
+
+	TEST_ASSERT(num >= 1 && num <= 8, "Unsupported number of args,\n"
+		    "num: %u\n", num);
+
+	vcpu_regs_get(vcpu, &regs);
+	va_start(ap, num);
+	for (i = 0; i < num; i++)
+		regs.gpr[i + 4] = va_arg(ap, uint64_t);
+	va_end(ap);
+	vcpu_regs_set(vcpu, &regs);
+}
+
+static void loongarch_get_csr(struct kvm_vcpu *vcpu, uint64_t id, void *addr)
+{
+	uint64_t csrid;
+
+	csrid = KVM_REG_LOONGARCH_CSR | KVM_REG_SIZE_U64 | 8 * id;
+	vcpu_get_reg(vcpu, csrid, addr);
+}
+
+static void loongarch_set_csr(struct kvm_vcpu *vcpu, uint64_t id, uint64_t val)
+{
+	uint64_t csrid;
+
+	csrid = KVM_REG_LOONGARCH_CSR | KVM_REG_SIZE_U64 | 8 * id;
+	vcpu_set_reg(vcpu, csrid, val);
+}
+
+static void loongarch_vcpu_setup(struct kvm_vcpu *vcpu)
+{
+	unsigned long val;
+	int width;
+	struct kvm_vm *vm = vcpu->vm;
+
+	switch (vm->mode) {
+	case VM_MODE_P48V48_16K:
+	case VM_MODE_P40V48_16K:
+	case VM_MODE_P36V48_16K:
+	case VM_MODE_P36V47_16K:
+		break;
+
+	default:
+		TEST_FAIL("Unknown guest mode, mode: 0x%x", vm->mode);
+	}
+
+	/* user mode and page enable mode */
+	val = PLV_USER | CSR_CRMD_PG;
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_CRMD, val);
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_PRMD, val);
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_EUEN, 1);
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_ECFG, 0);
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_TCFG, 0);
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_ASID, 1);
+
+	width = vm->page_shift - 3;
+	val = 0;
+	switch (vm->pgtable_levels) {
+	case 4:
+		/* pud page shift and width */
+		val = (vm->page_shift + width * 2) << 20 | (width << 25);
+	case 3:
+		/* pmd page shift and width */
+		val |= (vm->page_shift + width) << 10 | (width << 15);
+	case 2:
+		/* pte page shift and width */
+		val |= vm->page_shift | width << 5;
+		break;
+	default:
+		TEST_FAIL("Page table levels must be 2, 3, or 4");
+	}
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_PWCTL0, val);
+
+	/* pgd page shift and width */
+	val = (vm->page_shift + width * (vm->pgtable_levels - 1)) | width << 6;
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_PWCTL1, val);
+
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_PGDL, vm->pgd);
+
+	extern void handle_tlb_refill(void);
+	extern void handle_exception(void);
+	/*
+	 * refill exception runs on real mode, entry address should
+	 * be physical address
+	 */
+	val = addr_gva2gpa(vm, (unsigned long)handle_tlb_refill);
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_TLBRENTRY, val);
+
+	/*
+	 * general exception runs on page-enabled mode, entry address should
+	 * be virtual address
+	 */
+	val = (unsigned long)handle_exception;
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_EENTRY, val);
+
+	loongarch_get_csr(vcpu, LOONGARCH_CSR_TLBIDX, &val);
+	val &= ~CSR_TLBIDX_SIZEM;
+	val |= PS_DEFAULT_SIZE << CSR_TLBIDX_SIZE;
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_TLBIDX, val);
+
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_STLBPGSIZE, PS_DEFAULT_SIZE);
+
+	loongarch_get_csr(vcpu, LOONGARCH_CSR_TLBREHI, &val);
+	val &= ~CSR_TLBREHI_PS;
+	val |= PS_DEFAULT_SIZE << CSR_TLBREHI_PS_SHIFT;
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_TLBREHI, val);
+
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_CPUID, vcpu->id);
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_TMID,  vcpu->id);
+}
+
+static struct kvm_vcpu *loongarch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id, void *guest_code)
+{
+	size_t stack_size;
+	uint64_t stack_vaddr;
+	struct kvm_regs regs;
+	struct kvm_vcpu *vcpu;
+
+	vcpu = __vm_vcpu_add(vm, vcpu_id);
+	stack_size = vm->page_size;
+	stack_vaddr = __vm_vaddr_alloc(vm, stack_size,
+			DEFAULT_LOONGARCH_GUEST_STACK_VADDR_MIN,
+			MEM_REGION_DATA);
+
+	loongarch_vcpu_setup(vcpu);
+	/* Setup guest general purpose registers */
+	vcpu_regs_get(vcpu, &regs);
+	regs.gpr[3] = stack_vaddr + stack_size - 8;
+	regs.pc = (uint64_t)guest_code;
+	vcpu_regs_set(vcpu, &regs);
+
+	return vcpu;
+}
+
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
+				  void *guest_code)
+{
+	return loongarch_vcpu_add(vm, vcpu_id, guest_code);
+}
-- 
2.39.1

