Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5737C55A398
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 23:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiFXVdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 17:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbiFXVdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 17:33:19 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85046252A4
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:33:17 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id g129-20020a636b87000000b00401b8392ac8so1560053pgc.4
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=0nmZ9/x13YxPcUldzYHWoGjnnXz6ntspV0mhcJDjleg=;
        b=NFfOw/y3CyRb8neaOyJQaOUzUnqspOKOuBAp99uJFn0XgOrnZF4H7xi2WdpwpIfgN/
         pot3dPo9saUOLSG/4DXETYCsWJ9YDJRJw2upFipPHRSXhXvmT4vXQ2kr/dhVnEg5Cues
         6SklbjKfHnmBnNVvE3UegHadZacrQSzF3uNorQY7U65C8tWnGXO/3UNt2uEIncdlJREk
         z0eTruV8m6qG/mseNLgEm/RzxwGiZ2jEsB9L5JDx20kL8BnvXYwwGLl1kFjTE9XytbnN
         j0qlUoNG7XwsmnOQlEp7Gd7cPfWSmCdLKiR5f9oysPUHGHkeWuqBhnNPtNZyv5QmyIYk
         sS6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=0nmZ9/x13YxPcUldzYHWoGjnnXz6ntspV0mhcJDjleg=;
        b=rk56EV6Msj9VQkqhf0+N/fCZW548Wyircv7du//BbRM1vQy+OvhsxCOUnx2ugUgnFH
         2pzMiGGrrmIh0jtCYvmzTsmkJAG6O/7jfhWfxyAyc0Zy67DY+cOBNVuNLROF8md1FULo
         VJ1Z0AFFGRTlg703SDQ+Jk51UsA3axft+OQX/LbIc6ZX62/4B+NNseek2FaYe7Ryqx7V
         kfZJvRT2FcQXFT4toi24OYvsahXeWMKDlHUFP7hDgx4TwD5CyAUc55YO7Hz4uyFTZCfG
         1ejZvKlJr5aRVOYdOtCYdAWi/Zoe/omdCJK7t3KYDJnUpWGyAmwvchTZWNSr86+clCW7
         TXBA==
X-Gm-Message-State: AJIora/fqEBvEMLNRDzrGH9qYHKjnKR2EtzX8svsXJ+G1wpcRrs9+MWB
        /Qgi5s7Ff6YFDdlxOuxRWfuau8rTqMHmzlz7XIfTByjUKYGX0C1Z7/irgGyJv3IEvDWrRZR13UI
        fRylOwOgbGn90CJDnHWrXfmp9YxUIA1BMuc7lBFaZKl08l03amHp5JFecd7UsRJ0=
X-Google-Smtp-Source: AGRyM1vEDRGDqtrf67MHbkAS8XH0D7Lz+P1efIrUV+xClFB2Hi2cCJQigyNtYd42X7sjDgXurxqJET6QdA9MTg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:4a97:b0:1ea:fa24:467c with SMTP
 id f23-20020a17090a4a9700b001eafa24467cmr389471pjh.1.1656106396323; Fri, 24
 Jun 2022 14:33:16 -0700 (PDT)
Date:   Fri, 24 Jun 2022 14:32:53 -0700
In-Reply-To: <20220624213257.1504783-1-ricarkol@google.com>
Message-Id: <20220624213257.1504783-10-ricarkol@google.com>
Mime-Version: 1.0
References: <20220624213257.1504783-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v4 09/13] KVM: selftests: aarch64: Add aarch64/page_fault_test
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, dmatlack@google.com,
        axelrasmussen@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new test for stage 2 faults when using different combinations of
guest accesses (e.g., write, S1PTW), backing source type (e.g., anon)
and types of faults (e.g., read on hugetlbfs with a hole). The next
commits will add different handling methods and more faults (e.g., uffd
and dirty logging). This first commit starts by adding two sanity checks
for all types of accesses: AF setting by the hw, and accessing memslots
with holes.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/page_fault_test.c   | 695 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |   6 +
 3 files changed, 702 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests=
/kvm/Makefile
index e4497a3a27d4..13b913225ae7 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -139,6 +139,7 @@ TEST_GEN_PROGS_aarch64 +=3D aarch64/arch_timer
 TEST_GEN_PROGS_aarch64 +=3D aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 +=3D aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 +=3D aarch64/hypercalls
+TEST_GEN_PROGS_aarch64 +=3D aarch64/page_fault_test
 TEST_GEN_PROGS_aarch64 +=3D aarch64/psci_test
 TEST_GEN_PROGS_aarch64 +=3D aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 +=3D aarch64/vgic_init
diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/=
testing/selftests/kvm/aarch64/page_fault_test.c
new file mode 100644
index 000000000000..bdda4e3fcdaa
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -0,0 +1,695 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * page_fault_test.c - Test stage 2 faults.
+ *
+ * This test tries different combinations of guest accesses (e.g., write,
+ * S1PTW), backing source type (e.g., anon) and types of faults (e.g., rea=
d on
+ * hugetlbfs with a hole). It checks that the expected handling method is
+ * called (e.g., uffd faults with the right address and write/read flag).
+ */
+
+#define _GNU_SOURCE
+#include <linux/bitmap.h>
+#include <fcntl.h>
+#include <test_util.h>
+#include <kvm_util.h>
+#include <processor.h>
+#include <asm/sysreg.h>
+#include <linux/bitfield.h>
+#include "guest_modes.h"
+#include "userfaultfd_util.h"
+
+#define TEST_MEM_SLOT_INDEX			1
+#define TEST_PT_SLOT_INDEX			2
+
+/* Guest virtual addresses that point to the test page and its PTE. */
+#define TEST_GVA				0xc0000000
+#define TEST_EXEC_GVA				0xc0000008
+#define TEST_PTE_GVA				0xb0000000
+#define TEST_DATA				0x0123456789ABCDEF
+
+static uint64_t *guest_test_memory =3D (uint64_t *)TEST_GVA;
+
+#define CMD_NONE				(0)
+#define CMD_SKIP_TEST				(1ULL << 1)
+#define CMD_HOLE_PT				(1ULL << 2)
+#define CMD_HOLE_TEST				(1ULL << 3)
+
+#define PREPARE_FN_NR				10
+#define CHECK_FN_NR				10
+
+uint64_t pte_gpa;
+
+enum {
+	PT,
+	TEST,
+	NR_MEMSLOTS
+};
+
+struct memslot_desc {
+	void *hva;
+	uint64_t gpa;
+	uint64_t size;
+	uint64_t guest_pages;
+	enum vm_mem_backing_src_type src_type;
+	uint32_t idx;
+} memslot[NR_MEMSLOTS] =3D {
+	{
+		.idx =3D TEST_PT_SLOT_INDEX,
+	},
+	{
+		.idx =3D TEST_MEM_SLOT_INDEX,
+	},
+};
+
+static struct event_cnt {
+	int aborts;
+	int fail_vcpu_runs;
+} events;
+
+struct test_desc {
+	const char *name;
+	uint64_t mem_mark_cmd;
+	/* Skip the test if any prepare function returns false */
+	bool (*guest_prepare[PREPARE_FN_NR])(void);
+	void (*guest_test)(void);
+	void (*guest_test_check[CHECK_FN_NR])(void);
+	void (*dabt_handler)(struct ex_regs *regs);
+	void (*iabt_handler)(struct ex_regs *regs);
+	uint32_t pt_memslot_flags;
+	uint32_t test_memslot_flags;
+	bool skip;
+	struct event_cnt expected_events;
+};
+
+struct test_params {
+	enum vm_mem_backing_src_type src_type;
+	struct test_desc *test_desc;
+};
+
+static inline void flush_tlb_page(uint64_t vaddr)
+{
+	uint64_t page =3D vaddr >> 12;
+
+	dsb(ishst);
+	asm volatile("tlbi vaae1is, %0" :: "r" (page));
+	dsb(ish);
+	isb();
+}
+
+static void guest_write64(void)
+{
+	uint64_t val;
+
+	WRITE_ONCE(*guest_test_memory, TEST_DATA);
+	val =3D READ_ONCE(*guest_test_memory);
+	GUEST_ASSERT_EQ(val, TEST_DATA);
+}
+
+/* Check the system for atomic instructions. */
+static bool guest_check_lse(void)
+{
+	uint64_t isar0 =3D read_sysreg(id_aa64isar0_el1);
+	uint64_t atomic;
+
+	atomic =3D FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR0_ATOMICS), isar0);
+	return atomic >=3D 2;
+}
+
+static bool guest_check_dc_zva(void)
+{
+	uint64_t dczid =3D read_sysreg(dczid_el0);
+	uint64_t dzp =3D FIELD_GET(ARM64_FEATURE_MASK(DCZID_DZP), dczid);
+
+	return dzp =3D=3D 0;
+}
+
+/* Compare and swap instruction. */
+static void guest_cas(void)
+{
+	uint64_t val;
+
+	GUEST_ASSERT_EQ(guest_check_lse(), 1);
+	asm volatile(".arch_extension lse\n"
+		     "casal %0, %1, [%2]\n"
+			:: "r" (0), "r" (TEST_DATA), "r" (guest_test_memory));
+	val =3D READ_ONCE(*guest_test_memory);
+	GUEST_ASSERT_EQ(val, TEST_DATA);
+}
+
+static void guest_read64(void)
+{
+	uint64_t val;
+
+	val =3D READ_ONCE(*guest_test_memory);
+	GUEST_ASSERT_EQ(val, 0);
+}
+
+/* Address translation instruction */
+static void guest_at(void)
+{
+	uint64_t par;
+	uint64_t paddr;
+
+	asm volatile("at s1e1r, %0" :: "r" (guest_test_memory));
+	par =3D read_sysreg(par_el1);
+
+	/* Bit 1 indicates whether the AT was successful */
+	GUEST_ASSERT_EQ(par & 1, 0);
+	/* The PA in bits [51:12] */
+	paddr =3D par & (((1ULL << 40) - 1) << 12);
+	GUEST_ASSERT_EQ(paddr, memslot[TEST].gpa);
+}
+
+/*
+ * The size of the block written by "dc zva" is guaranteed to be between (=
2 <<
+ * 0) and (2 << 9), which is safe in our case as we need the write to happ=
en
+ * for at least a word, and not more than a page.
+ */
+static void guest_dc_zva(void)
+{
+	uint16_t val;
+
+	asm volatile("dc zva, %0\n"
+			"dsb ish\n"
+			:: "r" (guest_test_memory));
+	val =3D READ_ONCE(*guest_test_memory);
+	GUEST_ASSERT_EQ(val, 0);
+}
+
+/*
+ * Pre-indexing loads and stores don't have a valid syndrome (ESR_EL2.ISV=
=3D=3D0).
+ * And that's special because KVM must take special care with those: they
+ * should still count as accesses for dirty logging or user-faulting, but
+ * should be handled differently on mmio.
+ */
+static void guest_ld_preidx(void)
+{
+	uint64_t val;
+	uint64_t addr =3D TEST_GVA - 8;
+
+	/*
+	 * This ends up accessing "TEST_GVA + 8 - 8", where "TEST_GVA - 8" is
+	 * in a gap between memslots not backing by anything.
+	 */
+	asm volatile("ldr %0, [%1, #8]!"
+			: "=3Dr" (val), "+r" (addr));
+	GUEST_ASSERT_EQ(val, 0);
+	GUEST_ASSERT_EQ(addr, TEST_GVA);
+}
+
+static void guest_st_preidx(void)
+{
+	uint64_t val =3D TEST_DATA;
+	uint64_t addr =3D TEST_GVA - 8;
+
+	asm volatile("str %0, [%1, #8]!"
+			: "+r" (val), "+r" (addr));
+
+	GUEST_ASSERT_EQ(addr, TEST_GVA);
+	val =3D READ_ONCE(*guest_test_memory);
+}
+
+static bool guest_set_ha(void)
+{
+	uint64_t mmfr1 =3D read_sysreg(id_aa64mmfr1_el1);
+	uint64_t hadbs, tcr;
+
+	/* Skip if HA is not supported. */
+	hadbs =3D FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR1_HADBS), mmfr1);
+	if (hadbs =3D=3D 0)
+		return false;
+
+	tcr =3D read_sysreg(tcr_el1) | TCR_EL1_HA;
+	write_sysreg(tcr, tcr_el1);
+	isb();
+
+	return true;
+}
+
+static bool guest_clear_pte_af(void)
+{
+	*((uint64_t *)TEST_PTE_GVA) &=3D ~PTE_AF;
+	flush_tlb_page(TEST_PTE_GVA);
+
+	return true;
+}
+
+static void guest_check_pte_af(void)
+{
+	flush_tlb_page(TEST_PTE_GVA);
+	GUEST_ASSERT_EQ(*((uint64_t *)TEST_PTE_GVA) & PTE_AF, PTE_AF);
+}
+
+static void guest_exec(void)
+{
+	int (*code)(void) =3D (int (*)(void))TEST_EXEC_GVA;
+	int ret;
+
+	ret =3D code();
+	GUEST_ASSERT_EQ(ret, 0x77);
+}
+
+static bool guest_prepare(struct test_desc *test)
+{
+	bool (*prepare_fn)(void);
+	int i;
+
+	for (i =3D 0; i < PREPARE_FN_NR; i++) {
+		prepare_fn =3D test->guest_prepare[i];
+		if (prepare_fn && !prepare_fn())
+			return false;
+	}
+
+	return true;
+}
+
+static void guest_test_check(struct test_desc *test)
+{
+	void (*check_fn)(void);
+	int i;
+
+	for (i =3D 0; i < CHECK_FN_NR; i++) {
+		check_fn =3D test->guest_test_check[i];
+		if (check_fn)
+			check_fn();
+	}
+}
+
+static void guest_code(struct test_desc *test)
+{
+	if (!guest_prepare(test))
+		GUEST_SYNC(CMD_SKIP_TEST);
+
+	GUEST_SYNC(test->mem_mark_cmd);
+
+	if (test->guest_test)
+		test->guest_test();
+
+	guest_test_check(test);
+	GUEST_DONE();
+}
+
+static void no_dabt_handler(struct ex_regs *regs)
+{
+	GUEST_ASSERT_1(false, read_sysreg(far_el1));
+}
+
+static void no_iabt_handler(struct ex_regs *regs)
+{
+	GUEST_ASSERT_1(false, regs->pc);
+}
+
+/* Returns true to continue the test, and false if it should be skipped. *=
/
+static bool punch_hole_in_memslot(struct kvm_vm *vm,
+		struct memslot_desc *memslot)
+{
+	int ret, fd;
+	void *hva;
+
+	fd =3D vm_mem_region_get_src_fd(vm, memslot->idx);
+	if (fd !=3D -1) {
+		ret =3D fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+				0, memslot->size);
+		TEST_ASSERT(ret =3D=3D 0, "fallocate failed, errno: %d\n", errno);
+	} else {
+		if (is_backing_src_hugetlb(memslot->src_type))
+			return false;
+
+		hva =3D addr_gpa2hva(vm, memslot->gpa);
+		ret =3D madvise(hva, memslot->size, MADV_DONTNEED);
+		TEST_ASSERT(ret =3D=3D 0, "madvise failed, errno: %d\n", errno);
+	}
+
+	return true;
+}
+
+/* Returns true to continue the test, and false if it should be skipped. *=
/
+static bool handle_cmd(struct kvm_vm *vm, int cmd)
+{
+	bool continue_test =3D true;
+
+	if (cmd =3D=3D CMD_SKIP_TEST)
+		continue_test =3D false;
+
+	if (cmd & CMD_HOLE_PT)
+		continue_test =3D punch_hole_in_memslot(vm, &memslot[PT]);
+	if (cmd & CMD_HOLE_TEST)
+		continue_test =3D punch_hole_in_memslot(vm, &memslot[TEST]);
+
+	return continue_test;
+}
+
+static void sync_stats_from_guest(struct kvm_vm *vm)
+{
+	struct event_cnt *ec =3D addr_gva2hva(vm, (uint64_t)&events);
+
+	events.aborts +=3D ec->aborts;
+}
+
+void fail_vcpu_run_no_handler(int ret)
+{
+	TEST_FAIL("Unexpected vcpu run failure\n");
+}
+
+extern unsigned char __exec_test;
+
+void noinline __return_0x77(void)
+{
+	asm volatile("__exec_test: mov x0, #0x77\n"
+			"ret\n");
+}
+
+static void load_exec_code_for_test(void)
+{
+	uint64_t *code, *c;
+
+	assert(TEST_EXEC_GVA - TEST_GVA);
+	code =3D memslot[TEST].hva + 8;
+
+	/*
+	 * We need the cast to be separate in order for the compiler to not
+	 * complain with: "=E2=80=98memcpy=E2=80=99 forming offset [1, 7] is out =
of the bounds
+	 * [0, 1] of object =E2=80=98__exec_test=E2=80=99 with type =E2=80=98unsi=
gned char=E2=80=99"
+	 */
+	c =3D (uint64_t *)&__exec_test;
+	memcpy(code, c, 8);
+}
+
+static void setup_abort_handlers(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
+		struct test_desc *test)
+{
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+	if (!test->dabt_handler)
+		test->dabt_handler =3D no_dabt_handler;
+	if (!test->iabt_handler)
+		test->iabt_handler =3D no_iabt_handler;
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+			0x25, test->dabt_handler);
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+			0x21, test->iabt_handler);
+}
+
+/*
+ * Create a memslot for test data (memslot[TEST]) and another one for PT
+ * tables (memslot[PT]). This diagram show the resulting guest virtual and
+ * physical address space when using 4K backing pages for the memslots, an=
d
+ * 4K guest pages.
+ *
+ *                   Guest physical            Guest virtual
+ *
+ *                  |              |          |             |
+ *                  |              |          |             |
+ *                  +--------------+          +-------------+
+ * max_gfn - 0x1000 | TEST memslot |<---------+  test data  | 0xc0000000
+ *                  +--------------+          +-------------+
+ * max_gfn - 0x2000 |     gap      |<---------+     gap     | 0xbffff000
+ *                  +--------------+          +-------------+
+ *                  |              |          |             |
+ *                  |              |          |             |
+ *                  |  PT memslot  |          |             |
+ *                  |              |          +-------------+
+ * max_gfn - 0x6000 |              |<----+    |             |
+ *                  +--------------+     |    |             |
+ *                  |              |     |    | PTE for the |
+ *                  |              |     |    | test data   |
+ *                  |              |     +----+ page        | 0xb0000000
+ *                  |              |          +-------------+
+ *                  |              |          |             |
+ *                  |              |          |             |
+ *
+ * Using different guest page sizes or backing pages will result in the
+ * same layout but at different addresses. In particular, the memslot
+ * sizes need to be multiple of the backing page sizes (e.g., 2MB).
+ */
+static void setup_memslots(struct kvm_vm *vm, enum vm_guest_mode mode,
+		struct test_params *p)
+{
+	uint64_t backing_page_size =3D get_backing_src_pagesz(p->src_type);
+	uint64_t guest_page_size =3D vm_guest_mode_params[mode].page_size;
+	struct test_desc *test =3D p->test_desc;
+	uint64_t gap_gpa;
+	uint64_t alignment;
+	int i;
+
+	memslot[TEST].size =3D align_up(guest_page_size, backing_page_size);
+	/*
+	 * We need one guest page for the PT table containing the PTE (for
+	 * TEST_GVA), but might need more in case the higher level PT tables
+	 * were not allocated yet.
+	 */
+	memslot[PT].size =3D align_up(4 * guest_page_size, backing_page_size);
+
+	for (i =3D 0; i < NR_MEMSLOTS; i++) {
+		memslot[i].guest_pages =3D memslot[i].size / guest_page_size;
+		memslot[i].src_type =3D p->src_type;
+	}
+
+	/* Place the memslots GPAs at the end of physical memory */
+	alignment =3D max(backing_page_size, guest_page_size);
+	memslot[TEST].gpa =3D (vm->max_gfn - memslot[TEST].guest_pages) *
+		guest_page_size;
+	memslot[TEST].gpa =3D align_down(memslot[TEST].gpa, alignment);
+
+	/* Add a 1-guest_page gap between the two memslots */
+	gap_gpa =3D memslot[TEST].gpa - guest_page_size;
+	/* Map the gap so it's still adressable from the guest.  */
+	virt_pg_map(vm, TEST_GVA - guest_page_size, gap_gpa);
+
+	memslot[PT].gpa =3D gap_gpa - memslot[PT].size;
+	memslot[PT].gpa =3D align_down(memslot[PT].gpa, alignment);
+
+	vm_userspace_mem_region_add(vm, p->src_type, memslot[PT].gpa,
+			memslot[PT].idx, memslot[PT].guest_pages,
+			test->pt_memslot_flags);
+	vm_userspace_mem_region_add(vm, p->src_type, memslot[TEST].gpa,
+			memslot[TEST].idx, memslot[TEST].guest_pages,
+			test->test_memslot_flags);
+
+	for (i =3D 0; i < NR_MEMSLOTS; i++)
+		memslot[i].hva =3D addr_gpa2hva(vm, memslot[i].gpa);
+
+	/* Map the test TEST_GVA using the PT memslot. */
+	_virt_pg_map(vm, TEST_GVA, memslot[TEST].gpa, MT_NORMAL,
+			TEST_PT_SLOT_INDEX);
+
+	/*
+	 * Find the PTE of the test page and map it in the guest so it can
+	 * clear the AF.
+	 */
+	pte_gpa =3D addr_hva2gpa(vm, virt_get_pte_hva(vm, TEST_GVA));
+	TEST_ASSERT(memslot[PT].gpa <=3D pte_gpa &&
+			pte_gpa < (memslot[PT].gpa + memslot[PT].size),
+			"The EPT should be in the PT memslot.");
+	/* This is an artibrary requirement just to make things simpler. */
+	TEST_ASSERT(pte_gpa % guest_page_size =3D=3D 0,
+			"The pte_gpa (%p) should be aligned to the guest page (%lx).",
+			(void *)pte_gpa, guest_page_size);
+	virt_pg_map(vm, TEST_PTE_GVA, pte_gpa);
+}
+
+static void check_event_counts(struct test_desc *test)
+{
+	ASSERT_EQ(test->expected_events.aborts,	events.aborts);
+}
+
+static void print_test_banner(enum vm_guest_mode mode, struct test_params =
*p)
+{
+	struct test_desc *test =3D p->test_desc;
+
+	pr_debug("Test: %s\n", test->name);
+	pr_debug("Testing guest mode: %s\n", vm_guest_mode_string(mode));
+	pr_debug("Testing memory backing src type: %s\n",
+			vm_mem_backing_src_alias(p->src_type)->name);
+}
+
+static void reset_event_counts(void)
+{
+	memset(&events, 0, sizeof(events));
+}
+
+static bool vcpu_run_loop(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
+		struct test_desc *test)
+{
+	bool skip_test =3D false;
+	struct ucall uc;
+	int stage;
+
+	for (stage =3D 0; ; stage++) {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			if (!handle_cmd(vm, uc.args[1])) {
+				pr_debug("Skipped.\n");
+				skip_test =3D true;
+				goto done;
+			}
+			break;
+		case UCALL_ABORT:
+			TEST_FAIL("%s at %s:%ld\n\tvalues: %#lx, %#lx",
+				(const char *)uc.args[0],
+				__FILE__, uc.args[1], uc.args[2], uc.args[3]);
+			break;
+		case UCALL_DONE:
+			pr_debug("Done.\n");
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	return skip_test;
+}
+
+static void run_test(enum vm_guest_mode mode, void *arg)
+{
+	struct test_params *p =3D (struct test_params *)arg;
+	struct test_desc *test =3D p->test_desc;
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpus[1], *vcpu;
+	bool skip_test =3D false;
+
+	print_test_banner(mode, p);
+
+	vm =3D __vm_create_with_vcpus(mode, 1, 6, guest_code, vcpus);
+	vcpu =3D vcpus[0];
+	ucall_init(vm, NULL);
+
+	reset_event_counts();
+	setup_memslots(vm, mode, p);
+
+	load_exec_code_for_test();
+	setup_abort_handlers(vm, vcpu, test);
+	vcpu_args_set(vcpu, 1, test);
+
+	sync_global_to_guest(vm, memslot);
+
+	skip_test =3D vcpu_run_loop(vm, vcpu, test);
+
+	sync_stats_from_guest(vm);
+	ucall_uninit(vm);
+	kvm_vm_free(vm);
+
+	if (!skip_test)
+		check_event_counts(test);
+}
+
+static void help(char *name)
+{
+	puts("");
+	printf("usage: %s [-h] [-s mem-type]\n", name);
+	puts("");
+	guest_modes_help();
+	backing_src_help("-s");
+	puts("");
+}
+
+#define SNAME(s)			#s
+#define SCAT2(a, b)			SNAME(a ## _ ## b)
+#define SCAT3(a, b, c)			SCAT2(a, SCAT2(b, c))
+
+#define _CHECK(_test)			_CHECK_##_test
+#define _PREPARE(_test)			_PREPARE_##_test
+#define _PREPARE_guest_read64		NULL
+#define _PREPARE_guest_ld_preidx	NULL
+#define _PREPARE_guest_write64		NULL
+#define _PREPARE_guest_st_preidx	NULL
+#define _PREPARE_guest_exec		NULL
+#define _PREPARE_guest_at		NULL
+#define _PREPARE_guest_dc_zva		guest_check_dc_zva
+#define _PREPARE_guest_cas		guest_check_lse
+
+/* With or without access flag checks */
+#define _PREPARE_with_af		guest_set_ha, guest_clear_pte_af
+#define _PREPARE_no_af			NULL
+#define _CHECK_with_af			guest_check_pte_af
+#define _CHECK_no_af			NULL
+
+/* Performs an access and checks that no faults (no events) were triggered=
. */
+#define TEST_ACCESS(_access, _with_af, _mark_cmd)				\
+{										\
+	.name			=3D SCAT3(_access, _with_af, #_mark_cmd),		\
+	.guest_prepare		=3D { _PREPARE(_with_af),				\
+				    _PREPARE(_access) },			\
+	.mem_mark_cmd		=3D _mark_cmd,					\
+	.guest_test		=3D _access,					\
+	.guest_test_check	=3D { _CHECK(_with_af) },				\
+	.expected_events	=3D { 0 },					\
+}
+
+static struct test_desc tests[] =3D {
+	/* Check that HW is setting the Access Flag (AF) (sanity checks). */
+	TEST_ACCESS(guest_read64, with_af, CMD_NONE),
+	TEST_ACCESS(guest_ld_preidx, with_af, CMD_NONE),
+	TEST_ACCESS(guest_cas, with_af, CMD_NONE),
+	TEST_ACCESS(guest_write64, with_af, CMD_NONE),
+	TEST_ACCESS(guest_st_preidx, with_af, CMD_NONE),
+	TEST_ACCESS(guest_dc_zva, with_af, CMD_NONE),
+	TEST_ACCESS(guest_exec, with_af, CMD_NONE),
+
+	/*
+	 * Accessing a hole in the test memslot (punched with fallocate or
+	 * madvise) shouldn't fault (more sanity checks).
+	 */
+	TEST_ACCESS(guest_read64, no_af, CMD_HOLE_TEST),
+	TEST_ACCESS(guest_cas, no_af, CMD_HOLE_TEST),
+	TEST_ACCESS(guest_ld_preidx, no_af, CMD_HOLE_TEST),
+	TEST_ACCESS(guest_write64, no_af, CMD_HOLE_TEST),
+	TEST_ACCESS(guest_st_preidx, no_af, CMD_HOLE_TEST),
+	TEST_ACCESS(guest_at, no_af, CMD_HOLE_TEST),
+	TEST_ACCESS(guest_dc_zva, no_af, CMD_HOLE_TEST),
+
+	{ 0 }
+};
+
+static void for_each_test_and_guest_mode(
+		void (*func)(enum vm_guest_mode m, void *a),
+		enum vm_mem_backing_src_type src_type)
+{
+	struct test_desc *t;
+
+	for (t =3D &tests[0]; t->name; t++) {
+		if (t->skip)
+			continue;
+
+		struct test_params p =3D {
+			.src_type =3D src_type,
+			.test_desc =3D t,
+		};
+
+		for_each_guest_mode(run_test, &p);
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	enum vm_mem_backing_src_type src_type;
+	int opt;
+
+	setbuf(stdout, NULL);
+
+	src_type =3D DEFAULT_VM_MEM_SRC;
+
+	guest_modes_append_default();
+
+	while ((opt =3D getopt(argc, argv, "hm:s:")) !=3D -1) {
+		switch (opt) {
+		case 'm':
+			guest_modes_cmdline(optarg);
+			break;
+		case 's':
+			src_type =3D parse_backing_src_type(optarg);
+			break;
+		case 'h':
+		default:
+			help(argv[0]);
+			exit(0);
+		}
+	}
+
+	for_each_test_and_guest_mode(run_test, src_type);
+	return 0;
+}
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tool=
s/testing/selftests/kvm/include/aarch64/processor.h
index 74f10d006e15..818665e86f32 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -110,6 +110,12 @@ enum {
 #define ESR_EC_WP_CURRENT	0x35
 #define ESR_EC_BRK_INS		0x3c
=20
+/* Access flag */
+#define PTE_AF			(1ULL << 10)
+
+/* Access flag update enable/disable */
+#define TCR_EL1_HA		(1ULL << 39)
+
 void aarch64_get_supported_page_sizes(uint32_t ipa,
 				      bool *ps4k, bool *ps16k, bool *ps64k);
=20
--=20
2.37.0.rc0.161.g10f37bed90-goog

