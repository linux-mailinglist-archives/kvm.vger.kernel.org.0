Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2FD67BD236
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 04:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345055AbjJICzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 22:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344903AbjJICzQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 22:55:16 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF73EB3;
        Sun,  8 Oct 2023 19:55:12 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8AxueqOayNlCS4wAA--.16944S3;
        Mon, 09 Oct 2023 10:55:10 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cx7y+NayNlRvEbAA--.58139S4;
        Mon, 09 Oct 2023 10:55:10 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Cc:     Vishal Annapurve <vannapurve@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        Peter Xu <peterx@redhat.com>,
        Vipin Sharma <vipinsh@google.com>, maobibo@loongson.cn,
        zhaotianrui@loongson.cn
Subject: [PATCH v3 2/4] KVM: selftests: Add core KVM selftests support for LoongArch
Date:   Mon,  9 Oct 2023 10:55:08 +0800
Message-Id: <20231009025510.342681-3-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231009025510.342681-1-zhaotianrui@loongson.cn>
References: <20231009025510.342681-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cx7y+NayNlRvEbAA--.58139S4
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add core KVM selftests support for LoongArch.

Based-on: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 .../selftests/kvm/lib/loongarch/exception.S   |  59 ++++
 .../selftests/kvm/lib/loongarch/processor.c   | 333 ++++++++++++++++++
 2 files changed, 392 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/lib/loongarch/exception.S
 create mode 100644 tools/testing/selftests/kvm/lib/loongarch/processor.c

diff --git a/tools/testing/selftests/kvm/lib/loongarch/exception.S b/tools/testing/selftests/kvm/lib/loongarch/exception.S
new file mode 100644
index 0000000000..88bfa505c6
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/loongarch/exception.S
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include "processor.h"
+
+/* address of refill exception should be 4K aligned */
+.balign	4096
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
+	/*
+	 * save and restore all gprs except base register,
+	 * and default value of base register is sp ($r3).
+	 */
+.macro save_gprs base
+	.irp n,1,2,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
+	st.d    $r\n, \base, 8 * \n
+	.endr
+.endm
+
+.macro restore_gprs base
+	.irp n,1,2,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
+	ld.d    $r\n, \base, 8 * \n
+	.endr
+.endm
+
+/* address of general exception should be 4K aligned */
+.balign	4096
+.global handle_exception
+handle_exception:
+	csrwr  sp, LOONGARCH_CSR_KS0
+	csrrd  sp, LOONGARCH_CSR_KS1
+	addi.d sp, sp, -EXREGS_SIZE
+
+	save_gprs sp
+	/* save sp register to stack */
+	csrrd  t0, LOONGARCH_CSR_KS0
+	st.d   t0, sp, 3 * 8
+
+	csrrd  t0, LOONGARCH_CSR_ERA
+	st.d   t0, sp, PC_OFFSET_EXREGS
+	csrrd  t0, LOONGARCH_CSR_ESTAT
+	st.d   t0, sp, ESTAT_OFFSET_EXREGS
+	csrrd  t0, LOONGARCH_CSR_BADV
+	st.d   t0, sp, BADV_OFFSET_EXREGS
+
+	or     a0, sp, zero
+	bl route_exception
+	restore_gprs sp
+	csrrd  sp, LOONGARCH_CSR_KS0
+	ertn
diff --git a/tools/testing/selftests/kvm/lib/loongarch/processor.c b/tools/testing/selftests/kvm/lib/loongarch/processor.c
new file mode 100644
index 0000000000..82d8c1ec71
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/loongarch/processor.c
@@ -0,0 +1,333 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <assert.h>
+#include <linux/compiler.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+
+static vm_paddr_t invalid_pgtable[4];
+static uint64_t virt_pte_index(struct kvm_vm *vm, vm_vaddr_t gva, int level)
+{
+	unsigned int shift;
+	uint64_t mask;
+
+	shift = level * (vm->page_shift - 3) + vm->page_shift;
+	mask = (1UL << (vm->page_shift - 3)) - 1;
+	return (gva >> shift) & mask;
+}
+
+static uint64_t pte_addr(struct kvm_vm *vm, uint64_t entry)
+{
+	return entry &  ~((0x1UL << vm->page_shift) - 1);
+}
+
+static uint64_t ptrs_per_pte(struct kvm_vm *vm)
+{
+	return 1 << (vm->page_shift - 3);
+}
+
+static void virt_set_pgtable(struct kvm_vm *vm, vm_paddr_t table, vm_paddr_t child)
+{
+	uint64_t *ptep;
+	int i, ptrs_per_pte;
+
+	ptep = addr_gpa2hva(vm, table);
+	ptrs_per_pte = 1 << (vm->page_shift - 3);
+	for (i = 0; i < ptrs_per_pte; i++)
+		*(ptep + i) = child;
+}
+
+void virt_arch_pgd_alloc(struct kvm_vm *vm)
+{
+	int i;
+	vm_paddr_t child, table;
+
+	if (vm->pgd_created)
+		return;
+	child = table = 0;
+	for (i = 0; i < vm->pgtable_levels; i++) {
+		invalid_pgtable[i] = child;
+		table = vm_phy_page_alloc(vm, DEFAULT_LOONARCH64_PAGE_TABLE_MIN,
+				vm->memslots[MEM_REGION_PT]);
+		TEST_ASSERT(table, "Fail to allocate page tale at level %d\n", i);
+		virt_set_pgtable(vm, table, child);
+		child = table;
+	}
+	vm->pgd = table;
+	vm->pgd_created = true;
+}
+
+static int virt_pte_none(uint64_t *ptep, int level)
+{
+	return *ptep == invalid_pgtable[level];
+}
+
+static uint64_t *virt_populate_pte(struct kvm_vm *vm, vm_vaddr_t gva, int alloc)
+{
+	uint64_t *ptep;
+	vm_paddr_t child;
+	int level;
+
+	if (!vm->pgd_created)
+		goto unmapped_gva;
+
+	level = vm->pgtable_levels - 1;
+	child = vm->pgd;
+	while (level > 0) {
+		ptep = addr_gpa2hva(vm, child) + virt_pte_index(vm, gva, level) * 8;
+		if (virt_pte_none(ptep, level)) {
+			if (alloc) {
+				child = vm_alloc_page_table(vm);
+				virt_set_pgtable(vm, child, invalid_pgtable[level - 1]);
+				*ptep = child;
+			} else
+				goto unmapped_gva;
+
+		} else
+			child = pte_addr(vm, *ptep);
+		level--;
+	}
+
+	ptep = addr_gpa2hva(vm, child) + virt_pte_index(vm, gva, level) * 8;
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
+	ptep = virt_populate_pte(vm, gva, 0);
+	TEST_ASSERT(*ptep != 0, "Virtual address vaddr: 0x%lx not mapped\n", gva);
+
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
+	ptep = virt_populate_pte(vm, vaddr, 1);
+	prot_bits = _PAGE_PRESENT | __READABLE | __WRITEABLE | _CACHE_CC;
+	prot_bits |= _PAGE_USER;
+	*ptep = paddr | prot_bits;
+}
+
+static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent, uint64_t page, int level)
+{
+	static const char * const type[] = { "pte", "pmd", "pud", "pgd"};
+	uint64_t pte, *ptep;
+
+	if (level < 0)
+		return;
+
+	for (pte = page; pte < page + ptrs_per_pte(vm) * 8; pte += 8) {
+		ptep = addr_gpa2hva(vm, pte);
+		if (virt_pte_none(ptep, level))
+			continue;
+		fprintf(stream, "%*s%s: %lx: %lx at %p\n",
+				indent, "", type[level], pte, *ptep, ptep);
+		pte_dump(stream, vm, indent + 1, pte_addr(vm, *ptep), level--);
+	}
+}
+
+void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
+{
+	int level;
+
+	if (!vm->pgd_created)
+		return;
+
+	level = vm->pgtable_levels - 1;
+	pte_dump(stream, vm, indent, vm->pgd, level);
+}
+
+void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
+{
+}
+
+void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	if (get_ucall(vcpu, &uc) != UCALL_UNHANDLED)
+		return;
+
+	TEST_FAIL("Unexpected exception (pc:0x%lx, estat:0x%lx, badv:0x%lx)",
+			uc.args[0], uc.args[1], uc.args[2]);
+}
+
+void route_exception(struct ex_regs *regs)
+{
+	unsigned long pc, estat, badv;
+
+	pc = regs->pc;
+	estat = regs->estat;
+	badv  = regs->badv;
+	ucall(UCALL_UNHANDLED, 3, pc, estat, badv);
+	while (1)
+		;
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
+		/* fall throuth */
+	case 3:
+		/* pmd page shift and width */
+		val |= (vm->page_shift + width) << 10 | (width << 15);
+		/* pte page shift and width */
+		val |= vm->page_shift | width << 5;
+		break;
+	default:
+		TEST_FAIL("Got %u page table levels, expected 3 or 4", vm->pgtable_levels);
+	}
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_PWCTL0, val);
+
+	/* pgd page shift and width */
+	val = (vm->page_shift + width * (vm->pgtable_levels - 1)) | width << 6;
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_PWCTL1, val);
+
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_PGDL, vm->pgd);
+
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
+	/* LOONGARCH_CSR_KS1 is used for exception stack */
+	val = __vm_vaddr_alloc(vm, vm->page_size,
+			DEFAULT_LOONARCH64_STACK_MIN, MEM_REGION_DATA);
+	TEST_ASSERT(val != 0,  "No memory for exception stack");
+	val = val + vm->page_size;
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_KS1, val);
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
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
+				  void *guest_code)
+{
+	size_t stack_size;
+	uint64_t stack_vaddr;
+	struct kvm_regs regs;
+	struct kvm_vcpu *vcpu;
+
+	vcpu = __vm_vcpu_add(vm, vcpu_id);
+	stack_size = vm->page_size;
+	stack_vaddr = __vm_vaddr_alloc(vm, stack_size,
+			DEFAULT_LOONARCH64_STACK_MIN, MEM_REGION_DATA);
+	TEST_ASSERT(stack_vaddr != 0,  "No memory for vm stack");
+
+	loongarch_vcpu_setup(vcpu);
+	/* Setup guest general purpose registers */
+	vcpu_regs_get(vcpu, &regs);
+	regs.gpr[3] = stack_vaddr + stack_size;
+	regs.pc = (uint64_t)guest_code;
+	vcpu_regs_set(vcpu, &regs);
+
+	return vcpu;
+}
-- 
2.39.1

