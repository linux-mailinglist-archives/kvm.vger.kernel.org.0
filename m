Return-Path: <kvm+bounces-66421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CA06CD227B
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 23:59:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 283093040AF0
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 22:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFC2B218821;
	Fri, 19 Dec 2025 22:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QTbPpN0X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01AB2E975E
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 22:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766185171; cv=none; b=dVwUEq+aKetzXX1TQ3ZnFpzVENpbrl7T7HepOfs+qPgyVDG18UIF1uVEkDm9hzvAWGWJ3scw/xtdNjovbbzHExZFpIQXOd7+zhKy0TXPoWvZoZCl61wWGOtt09PqPxRQgNzytWj8K+iVLW49R3WCMVwAxn3Ewm2oPt5KmwXBt2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766185171; c=relaxed/simple;
	bh=JfdDNNWIG/uREmYzkXf9jx54V+NLyeVuBCzlqqa+EGk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SI2sf/Y9kDpIu9DSUwyuRMFCqBNXexd/QLbAi2+xQ3Uvqb5cEP8jB8sU1VkFw4VSQWtdsCXzBcoSrhmtPYrKc2eKRJix7UiU/mPF9/b0Bi3Iq755soDxA8/vAJ/ncXijJH54Nkzl4mreiw7l1P0+v8aDS4kxxQBcgq+VEH+GHO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QTbPpN0X; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7dd05696910so3416821b3a.2
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 14:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766185166; x=1766789966; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kcoTbEQR814lo3lOtaMwH8lhPmJpJHw0LyxAyNIx0FU=;
        b=QTbPpN0X/xX2JaADNq4/cbkapGDq6bQBXKR49VYu3rcmVSVL/pnyiVOKmfLQ1Lgbjg
         YhR14i4WtwSYyd1kW7WIAxu1bjL8ui6LGDAEy15qCU7Ui5BgLpps+txl5TP5SWIXHitX
         G6ShAEaryI2kIhglsl/dq2SAeLNSrjK9XAXnpGiRMoWK5klGAY9AIoKkqaBxOB9PApNf
         gFW3TrLXAkp+5u+aXb0Wl2FUCG+dTQY2gLlduvWRO0lejGj5Cl1d75mASNvpkQ9R3DmM
         9vzY4uTbO3fqOBlo8MKUB8XaoZpve4+Gglth9A3pX6QFrdwFEsHXI/w9sLJe6qyqM37z
         nRpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766185166; x=1766789966;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kcoTbEQR814lo3lOtaMwH8lhPmJpJHw0LyxAyNIx0FU=;
        b=K16m76jkB9UZp8PEiQQkK7BHKKDfeQMy7Wv7qGIuzKPQ0iTOoOiAy7HfFswO9BO48l
         rXgRNlZ33FFiwejrrWSDFYdfkBcix/jw4Ycj/OQ2yBrnhEUTXO866XXBrzpaWXUc98TU
         /mKgRJNNLiEdQ8idFUb5k1Zj8Ku6wGHwYYoE1HaHfRgmsCe+j+PyKUoE7SddE0HgQGof
         juSMTMUxV7FyAuwnooh/c08EcnbqSeOmhcisCR2DReKFbYRH533yB9uf6ZctPppgKiW0
         JQt8B0oNPNSoam2iGkucEVA9gjDDaZdOKm3vP8MKQACbjSjIJGrX53VK1HAtspm9vbrE
         ArYQ==
X-Gm-Message-State: AOJu0Yw/QtvGEuupSebh3anYbEpptuTR1wieuTjjADhtevq8cuNeSltI
	7dLLWinh6ODSFGv+oHzo3vIxJ46aYDR7DGxEd+iE4er7ihVRQPfOH0KxCjj70o5XVfDTDUP6rgI
	PyrkrQwsDvaHSsU1rSnxq8WDNM9nxgU+IuD/VeuampCF3OyroTXInNyu/JCtfqfwPNUDueCM4h6
	wlNGewFnD1RNw5ynjPt9JZ0r3AiUFsn2ln3hlq9RctqZc=
X-Google-Smtp-Source: AGHT+IFRuzX8OZcvEXTgspaiJ8Khf29VVKRNrD37oZrWP4gpaurgh8fKgvHAW/EcbEJjtdd1ncxHcuXEoESdtQ==
X-Received: from pjbne21.prod.google.com ([2002:a17:90b:3755:b0:341:3e7:538f])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:a11d:b0:366:1955:e965 with SMTP id adf61e73a8af0-376a7fe2ac7mr4174532637.5.1766185165905;
 Fri, 19 Dec 2025 14:59:25 -0800 (PST)
Date: Fri, 19 Dec 2025 22:59:05 +0000
In-Reply-To: <20251219225908.334766-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251219225908.334766-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219225908.334766-7-chengkev@google.com>
Subject: [kvm-unit-tests PATCH 6/9] x86/svm: Extend NPT test coverage for
 different page table levels
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

Currently the npt access tests only modify permission bits on the leaf
npt pte. Increase npt testing coverage by modifying permission bits for
all levels of the npt. Also add coverage for all different types of
accesses for every permission bit. Add this coverage to improve test
parity between nSVM and nVMX.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 lib/x86/vm.c  |   2 +-
 lib/x86/vm.h  |   2 +
 x86/access.c  |   7 -
 x86/access.h  |  11 ++
 x86/svm.c     |   2 +-
 x86/svm.h     |   1 +
 x86/svm_npt.c | 374 ++++++++++++++++++++++++++++++++++++++++++--------
 7 files changed, 333 insertions(+), 66 deletions(-)

diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 27e7bb4004ef9..b8e6657030af2 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -4,7 +4,7 @@
 #include "alloc_page.h"
 #include "smp.h"
 
-static pteval_t pte_opt_mask;
+pteval_t pte_opt_mask;
 
 pteval_t *install_pte(pgd_t *cr3,
 		      int pte_level,
diff --git a/lib/x86/vm.h b/lib/x86/vm.h
index cf39787aa8b02..ed0e77597e298 100644
--- a/lib/x86/vm.h
+++ b/lib/x86/vm.h
@@ -9,6 +9,8 @@
 
 void setup_5level_page_table(void);
 
+extern pteval_t pte_opt_mask;
+
 struct pte_search {
 	int level;
 	pteval_t *pte;
diff --git a/x86/access.c b/x86/access.c
index d94910bf54052..142c1d9282f83 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -17,13 +17,6 @@ static int invalid_mask;
 #define PT_BASE_ADDR_MASK ((pt_element_t)((((pt_element_t)1 << 36) - 1) & PAGE_MASK))
 #define PT_PSE_BASE_ADDR_MASK (PT_BASE_ADDR_MASK & ~(1ull << 21))
 
-#define PFERR_PRESENT_MASK (1U << 0)
-#define PFERR_WRITE_MASK (1U << 1)
-#define PFERR_USER_MASK (1U << 2)
-#define PFERR_RESERVED_MASK (1U << 3)
-#define PFERR_FETCH_MASK (1U << 4)
-#define PFERR_PK_MASK (1U << 5)
-
 #define MSR_EFER 0xc0000080
 #define EFER_NX_MASK            (1ull << 11)
 
diff --git a/x86/access.h b/x86/access.h
index 206a1c86fa0eb..9410085668eae 100644
--- a/x86/access.h
+++ b/x86/access.h
@@ -4,6 +4,17 @@
 #define PT_LEVEL_PML4 4
 #define PT_LEVEL_PML5 5
 
+#define PFERR_PRESENT_MASK (1U << 0)
+#define PFERR_WRITE_MASK (1U << 1)
+#define PFERR_USER_MASK (1U << 2)
+#define PFERR_RESERVED_MASK (1U << 3)
+#define PFERR_FETCH_MASK (1U << 4)
+#define PFERR_PK_MASK (1U << 5)
+#define PFERR_SGX_MASK (1U << 15)
+#define PFERR_GUEST_RMP_MASK (1ULL << 31)
+#define PFERR_GUEST_FINAL_MASK (1ULL << 32)
+#define PFERR_GUEST_PAGE_MASK (1ULL << 33)
+
 void ac_test_run(int page_table_levels, bool force_emulation);
 
 #endif // X86_ACCESS_H
\ No newline at end of file
diff --git a/x86/svm.c b/x86/svm.c
index 014feae3b48cc..d65616d063bcc 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -317,7 +317,7 @@ static void set_additional_vcpu_msr(void *msr_efer)
 	wrmsr(MSR_EFER, (ulong)msr_efer | EFER_SVME);
 }
 
-static void setup_npt(void)
+void setup_npt(void)
 {
 	u64 size = fwcfg_get_u64(FW_CFG_RAM_SIZE);
 
diff --git a/x86/svm.h b/x86/svm.h
index 66733570f0e37..c90759670e08f 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -446,6 +446,7 @@ void svm_setup_vmrun(u64 rip);
 int __svm_vmrun(u64 rip);
 int svm_vmrun(void);
 void test_set_guest(test_guest_func func);
+void setup_npt(void);
 
 extern struct vmcb *vmcb;
 
diff --git a/x86/svm_npt.c b/x86/svm_npt.c
index e436c43fb1c4c..5d70fd69a0c35 100644
--- a/x86/svm_npt.c
+++ b/x86/svm_npt.c
@@ -3,115 +3,373 @@
 #include "vm.h"
 #include "alloc_page.h"
 #include "vmalloc.h"
+#include "processor.h"
+#include "access.h"
+
+#include <asm/page.h>
 
 static void *scratch_page;
 
-static void null_test(struct svm_test *test)
+enum npt_access_op {
+	OP_READ,
+	OP_WRITE,
+	OP_EXEC,
+	OP_FLUSH_TLB,
+	OP_EXIT,
+};
+static struct npt_access_test_data {
+	unsigned long gpa;
+	unsigned long *gva;
+	unsigned long hpa;
+	unsigned long *hva;
+	enum npt_access_op op;
+} npt_access_test_data;
+
+extern unsigned char ret42_start;
+extern unsigned char ret42_end;
+
+/* Returns 42. */
+asm(
+	".align 64\n"
+	"ret42_start:\n"
+	"mov $42, %eax\n"
+	"ret\n"
+	"ret42_end:\n"
+);
+
+#define MAGIC_VAL_1		0x12345678ul
+#define MAGIC_VAL_2		0x87654321ul
+
+#define PAGE_1G_ORDER 18
+
+static void *get_1g_page(void)
 {
+	static void *alloc;
+
+	if (!alloc)
+		alloc = alloc_pages(PAGE_1G_ORDER);
+	return alloc;
 }
 
-static void npt_np_prepare(struct svm_test *test)
+static void
+diagnose_npt_violation_exit_code(u64 expected, u64 actual)
 {
-	u64 *pte;
 
-	scratch_page = alloc_page();
-	pte = npt_get_pte((u64) scratch_page);
+#define DIAGNOSE(flag)							\
+do {									\
+	if ((expected & flag) != (actual & flag))			\
+		printf(#flag " %sexpected\n",				\
+		       (expected & flag) ? "" : "un");			\
+} while (0)
 
-	*pte &= ~1ULL;
-}
+	DIAGNOSE(PFERR_PRESENT_MASK);
+	DIAGNOSE(PFERR_WRITE_MASK);
+	DIAGNOSE(PFERR_USER_MASK);
+	DIAGNOSE(PFERR_RESERVED_MASK);
+	DIAGNOSE(PFERR_FETCH_MASK);
+	DIAGNOSE(PFERR_PK_MASK);
+	DIAGNOSE(PFERR_SGX_MASK);
+	DIAGNOSE(PFERR_GUEST_RMP_MASK);
+	DIAGNOSE(PFERR_GUEST_FINAL_MASK);
 
-static void npt_np_test(struct svm_test *test)
-{
-	(void)*(volatile u64 *)scratch_page;
+#undef DIAGNOSE
 }
 
-static bool npt_np_check(struct svm_test *test)
+static unsigned long npt_twiddle(unsigned long gpa, bool mkhuge, int level,
+				 unsigned long clear, unsigned long set)
 {
-	u64 *pte = npt_get_pte((u64) scratch_page);
+	struct npt_access_test_data *data = &npt_access_test_data;
+	unsigned long orig_pte;
+	unsigned long *pte;
 
-	*pte |= 1ULL;
+	pte = find_pte_level(npt_get_pml4e(), (void *)gpa, level).pte;
+	orig_pte = *pte;
+	report(orig_pte, "Get npt pte for gpa 0x%lx at level %d", gpa, level);
 
-	return (vmcb->control.exit_code == SVM_EXIT_NPF)
-	    && (vmcb->control.exit_info_1 == 0x100000004ULL);
+	if (mkhuge) {
+		assert(IS_ALIGNED(data->hpa, 1ul << PGDIR_BITS(level)));
+		*pte = (*pte & ~PT_ADDR_MASK) | data->hpa | PT_PAGE_SIZE_MASK;
+	}
+
+	/*
+	 * No need for a TLB invalidation here since we always flush the TLB
+	 * via TLB_CONTROL before entering the nested guest in do_npt_access().
+	 */
+	*pte = (*pte & ~clear) | set;
+
+	return orig_pte;
 }
 
-static void npt_nx_prepare(struct svm_test *test)
+static void npt_untwiddle(unsigned long gpa, int level, unsigned long orig_pte)
 {
-	u64 *pte;
+	unsigned long *pte = find_pte_level(npt_get_pml4e(),
+					    (void *)gpa, level).pte;
+	*pte = orig_pte;
+}
 
-	test->scratch = rdmsr(MSR_EFER);
-	wrmsr(MSR_EFER, test->scratch | EFER_NX);
+static void do_npt_access(enum npt_access_op op, u64 expected_fault,
+			  u64 expected_paddr)
+{
+	u32 exit_code;
+	u64 exit_info_1;
+	u64 exit_info_2;
 
-	/* Clear the guest's EFER.NX, it should not affect NPT behavior. */
-	vmcb->save.efer &= ~EFER_NX;
+	/* Try the access and observe the violation. */
+	npt_access_test_data.op = op;
+	vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
+	svm_vmrun();
+
+	exit_code = vmcb->control.exit_code;
+	exit_info_1 = vmcb->control.exit_info_1;
+	exit_info_2 = vmcb->control.exit_info_2;
 
-	pte = npt_get_pte((u64) null_test);
+	if (!expected_fault) {
+		report(exit_code == SVM_EXIT_VMMCALL,
+		       "NPT access exit code: Expected VMMCALL, received exit "
+		       "code 0x%x with exit_info_1 0x%lx and exit_info_2 "
+		       "0x%lx",
+		       exit_code, exit_info_1, exit_info_2);
+		return;
+	}
 
-	*pte |= PT64_NX_MASK;
+	TEST_EXPECT_EQ(exit_code, SVM_EXIT_NPF);
+	TEST_EXPECT_EQ(exit_info_1, expected_fault);
+	diagnose_npt_violation_exit_code(expected_fault, exit_info_1);
+	TEST_EXPECT_EQ(exit_info_2, expected_paddr);
 }
 
-static bool npt_nx_check(struct svm_test *test)
+static void npt_access_at_level_mkhuge(bool mkhuge, int level,
+				       unsigned long clear, unsigned long set,
+				       enum npt_access_op op,
+				       u64 expected_fault)
 {
-	u64 *pte = npt_get_pte((u64) null_test);
+	struct npt_access_test_data *data = &npt_access_test_data;
+	unsigned long orig_pte;
 
-	wrmsr(MSR_EFER, test->scratch);
+	orig_pte = npt_twiddle(data->gpa, mkhuge, level, clear, set);
 
-	*pte &= ~PT64_NX_MASK;
+	do_npt_access(op, expected_fault, data->gpa);
 
-	return (vmcb->control.exit_code == SVM_EXIT_NPF)
-	    && (vmcb->control.exit_info_1 == 0x100000015ULL);
+	npt_untwiddle(data->gpa, level, orig_pte);
 }
 
-static void npt_us_prepare(struct svm_test *test)
+static void npt_access_at_level(int level, unsigned long clear, unsigned long set,
+				       enum npt_access_op op, u64 expected_fault)
 {
-	u64 *pte;
+	npt_access_at_level_mkhuge(false, level, clear, set, op, expected_fault);
 
-	scratch_page = alloc_page();
-	pte = npt_get_pte((u64) scratch_page);
+	if (level == 2 || level == 3)
+		npt_access_at_level_mkhuge(true, level, clear, set, op, expected_fault);
+}
 
-	*pte &= ~(1ULL << 2);
+static void npt_access_npf(unsigned long clear, unsigned long set,
+			  enum npt_access_op op, u64 expected_fault)
+{
+	for (int i = 1; i <= PAGE_LEVEL; i++)
+		npt_access_at_level(i, clear, set, op, expected_fault);
 }
 
-static void npt_us_test(struct svm_test *test)
+static void npt_access_allowed(unsigned long clear, unsigned long set,
+			       enum npt_access_op op)
 {
-	(void)*(volatile u64 *)scratch_page;
+	for (int i = 1; i <= PAGE_LEVEL; i++)
+		npt_access_at_level(i, clear, set, op, 0);
 }
 
-static bool npt_us_check(struct svm_test *test)
+static void npt_access_test_guest(struct svm_test *test)
 {
-	u64 *pte = npt_get_pte((u64) scratch_page);
+	struct npt_access_test_data *data = &npt_access_test_data;
+	int (*code)(void) = (int (*)(void)) &data->gva[1];
 
-	*pte |= (1ULL << 2);
+	while (true) {
+		switch (data->op) {
+		case OP_READ:
+			TEST_EXPECT_EQ(*data->gva, MAGIC_VAL_1);
+			break;
+		case OP_WRITE:
+			*data->gva = MAGIC_VAL_2;
+			TEST_EXPECT_EQ(*data->gva, MAGIC_VAL_2);
+			*data->gva = MAGIC_VAL_1;
+			break;
+		case OP_EXEC:
+			TEST_EXPECT_EQ(code(), 42);
+			break;
+		case OP_FLUSH_TLB:
+			write_cr3(read_cr3());
+			break;
+		case OP_EXIT:
+			return;
+		default:
+			report_fail("Unknown op %d", data->op);
+		}
+		vmmcall();
+	}
+}
 
-	return (vmcb->control.exit_code == SVM_EXIT_NPF)
-	    && (vmcb->control.exit_info_1 == 0x100000005ULL);
+static ulong orig_efer;
+static ulong orig_cr4;
+
+/*
+ * npt_access_test_setup() must be called before modifying cr4 or efer to
+ * ensure proper restoration on cleanup.
+ */
+static void npt_access_test_setup(void)
+{
+	struct npt_access_test_data *data = &npt_access_test_data;
+	unsigned long npages = 1ul << PAGE_1G_ORDER;
+	unsigned long size = npages * PAGE_SIZE;
+	unsigned long *page_table = current_page_table();
+	u64 orig_opt_mask = pte_opt_mask;
+
+	if (!npt_supported()) {
+		report_skip("NPT not supported");
+		return;
+	}
+
+	assert(npt_get_pml4e());
+
+	test_set_guest(npt_access_test_guest);
+
+	orig_efer = rdmsr(MSR_EFER);
+	wrmsr(MSR_EFER, orig_efer | EFER_NX | EFER_LMA);
+
+	orig_cr4 = read_cr4();
+	write_cr4(orig_cr4 | X86_CR4_PAE);
+
+	/* Clear the guest's EFER.NX, it should not affect NPT behavior. */
+	vmcb->save.efer &= ~EFER_NX;
+
+	/*
+	 * We use data->gpa = 1 << 39 so that test data has a separate pml4
+	 * entry.
+	 */
+	if (cpuid_maxphyaddr() < 40) {
+		report_skip("Test needs MAXPHYADDR >= 40");
+		return;
+	}
+
+	data->hva = get_1g_page();
+	report(data->hva, "Allocate 1g page");
+	data->hpa = virt_to_phys(data->hva);
+
+	data->gpa = 1ul << 39;
+	data->gva = (void *) ALIGN((unsigned long) alloc_vpages(npages * 2),
+				   size);
+	/* install_pages() creates 4K PTEs by default */
+	install_pages(page_table, data->gpa, size, data->gva);
+
+	/*
+	 * Make sure nothing's mapped here so the tests that screw with the
+	 * pml4 entry don't inadvertently break something.
+	 */
+	report(!npt_get_pte(data->gpa), "Nothing mapped to gpa 0x%lx",
+	       data->gpa);
+	report(!npt_get_pte(data->gpa + size - 1),
+	       "Nothing mapped to gpa + %lx",
+	       data->gpa + size - 1);
+
+	/*
+	 * pte_opt_mask is used when installing PTEs and its permission bits.
+	 * Since NPT walks are user accesses, ensure that PT_USER_MASK is set
+	 * for NPT entries as it is not set by default.
+	 */
+	pte_opt_mask |= PT_USER_MASK;
+	/* install_pages() creates 4K PTEs by default */
+	install_pages(npt_get_pml4e(), data->hpa, size,
+		      (void *)(ulong)data->gpa);
+	pte_opt_mask = orig_opt_mask;
+
+	data->hva[0] = MAGIC_VAL_1;
+	memcpy(&data->hva[1], &ret42_start, &ret42_end - &ret42_start);
 }
 
-static void npt_rw_prepare(struct svm_test *test)
+static void npt_access_test_cleanup(void)
 {
+	wrmsr(MSR_EFER, orig_efer);
+	write_cr4(orig_cr4);
 
-	u64 *pte;
+	/* Reset the npt after each test. */
+	setup_npt();
+}
 
-	pte = npt_get_pte(0x80000);
 
-	*pte &= ~(1ULL << 1);
+static void null_test(struct svm_test *test)
+{
 }
 
-static void npt_rw_test(struct svm_test *test)
+static void npt_np_test(void)
 {
-	u64 *data = (void *)(0x80000);
+	npt_access_test_setup();
+	npt_access_npf(PT_PRESENT_MASK, 0, OP_READ,
+		       PFERR_GUEST_FINAL_MASK | PFERR_USER_MASK);
+	npt_access_npf(PT_PRESENT_MASK, 0, OP_WRITE,
+		       PFERR_GUEST_FINAL_MASK | PFERR_WRITE_MASK |
+			       PFERR_USER_MASK);
+	npt_access_npf(PT_PRESENT_MASK, 0, OP_EXEC,
+		       PFERR_GUEST_FINAL_MASK | PFERR_FETCH_MASK |
+			       PFERR_USER_MASK);
+	npt_access_test_cleanup();
+}
 
-	*data = 0;
+static void npt_nx_test(void)
+{
+	npt_access_test_setup();
+	npt_access_allowed(PT_WRITABLE_MASK, PT64_NX_MASK, OP_READ);
+	npt_access_npf(PT_WRITABLE_MASK, PT64_NX_MASK, OP_WRITE,
+		       PFERR_GUEST_FINAL_MASK | PFERR_WRITE_MASK |
+			       PFERR_USER_MASK | PFERR_PRESENT_MASK);
+	npt_access_npf(PT_WRITABLE_MASK, PT64_NX_MASK, OP_EXEC,
+		       PFERR_GUEST_FINAL_MASK | PFERR_FETCH_MASK |
+			       PFERR_USER_MASK | PFERR_PRESENT_MASK);
+	npt_access_test_cleanup();
 }
 
-static bool npt_rw_check(struct svm_test *test)
+static void npt_us_test(void)
 {
-	u64 *pte = npt_get_pte(0x80000);
+	npt_access_test_setup();
+	npt_access_npf(PT_USER_MASK, 0, OP_READ,
+		       PFERR_GUEST_FINAL_MASK | PFERR_USER_MASK |
+			       PFERR_PRESENT_MASK);
+	npt_access_npf(PT_USER_MASK, 0, OP_WRITE,
+		       PFERR_GUEST_FINAL_MASK | PFERR_WRITE_MASK |
+			       PFERR_USER_MASK | PFERR_PRESENT_MASK);
+	npt_access_npf(PT_USER_MASK, 0, OP_EXEC,
+		       PFERR_GUEST_FINAL_MASK | PFERR_FETCH_MASK |
+			       PFERR_USER_MASK | PFERR_PRESENT_MASK);
+	npt_access_test_cleanup();
+}
 
-	*pte |= (1ULL << 1);
+static void npt_ro_test(void)
+{
+	npt_access_test_setup();
+	npt_access_allowed(PT_WRITABLE_MASK, PT64_NX_MASK, OP_READ);
+	npt_access_npf(PT_WRITABLE_MASK, PT64_NX_MASK, OP_WRITE,
+		       PFERR_GUEST_FINAL_MASK | PFERR_WRITE_MASK |
+			       PFERR_USER_MASK | PFERR_PRESENT_MASK);
+	npt_access_npf(PT_WRITABLE_MASK, PT64_NX_MASK, OP_EXEC,
+		       PFERR_GUEST_FINAL_MASK | PFERR_FETCH_MASK |
+			       PFERR_USER_MASK | PFERR_PRESENT_MASK);
+	npt_access_test_cleanup();
+}
 
-	return (vmcb->control.exit_code == SVM_EXIT_NPF)
-	    && (vmcb->control.exit_info_1 == 0x100000007ULL);
+static void npt_rw_test(void)
+{
+	npt_access_test_setup();
+	npt_access_allowed(0, PT64_NX_MASK, OP_READ);
+	npt_access_allowed(0, PT64_NX_MASK, OP_WRITE);
+	npt_access_npf(0, PT64_NX_MASK, OP_EXEC,
+		       PFERR_GUEST_FINAL_MASK | PFERR_FETCH_MASK |
+			       PFERR_USER_MASK | PFERR_PRESENT_MASK);
+	npt_access_test_cleanup();
+}
+
+static void npt_rwx_test(void)
+{
+	npt_access_test_setup();
+	npt_access_allowed(0, 0, OP_READ);
+	npt_access_allowed(0, 0, OP_WRITE);
+	npt_access_allowed(0, 0, OP_WRITE);
+	npt_access_test_cleanup();
 }
 
 static void npt_rw_pfwalk_prepare(struct svm_test *test)
@@ -562,15 +820,17 @@ static void npt_ad_test(void)
 #define NPT_V2_TEST(name) { #name, .v2 = name }
 
 static struct svm_test npt_tests[] = {
-	NPT_V1_TEST(npt_nx, npt_nx_prepare, null_test, npt_nx_check),
-	NPT_V1_TEST(npt_np, npt_np_prepare, npt_np_test, npt_np_check),
-	NPT_V1_TEST(npt_us, npt_us_prepare, npt_us_test, npt_us_check),
-	NPT_V1_TEST(npt_rw, npt_rw_prepare, npt_rw_test, npt_rw_check),
 	NPT_V1_TEST(npt_rw_pfwalk, npt_rw_pfwalk_prepare, null_test, npt_rw_pfwalk_check),
 	NPT_V1_TEST(npt_l1mmio, npt_l1mmio_prepare, npt_l1mmio_test, npt_l1mmio_check),
 	NPT_V1_TEST(npt_rw_l1mmio, npt_rw_l1mmio_prepare, npt_rw_l1mmio_test, npt_rw_l1mmio_check),
 	NPT_V2_TEST(svm_npt_rsvd_bits_test),
 	NPT_V2_TEST(npt_ad_test),
+	NPT_V2_TEST(npt_nx_test),
+	NPT_V2_TEST(npt_np_test),
+	NPT_V2_TEST(npt_us_test),
+	NPT_V2_TEST(npt_ro_test),
+	NPT_V2_TEST(npt_rw_test),
+	NPT_V2_TEST(npt_rwx_test),
 	{ NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
 
-- 
2.52.0.322.g1dd061c0dc-goog


