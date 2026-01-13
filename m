Return-Path: <kvm+bounces-67889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CE9FD160CB
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:36:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5F226302ADCB
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A031279798;
	Tue, 13 Jan 2026 00:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B+GsRaUk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B984F262808
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 00:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768264336; cv=none; b=ld1ppkyjyGXnsB5AGQgH3p4ntvEb9/Al5B8o/lTcyP8F8Zt8h2fAvW7SS2MyKOqfrBknY4JAZCq+PtiMX+cJATKNN/t4jHpMs4SSdFG+OMREOLbc8a3wTzX/XDvOGjHsxj6SRZ6jxOwkZVQwZTxrOL5GLtxvN+PvyvuaRMS0lpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768264336; c=relaxed/simple;
	bh=Y7xDGnrQw8X1IC2uGAEyOHkgX6n1Bu0jXAwXxBoxl64=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qavQmjJoT8eGKWtYNr/2rzMOFSK83xpGmQx1iR0QX5fxueiS0k2MGxcM3OOo+xeWABObClqOT5/IzqFQXr3NRoI71pb76qa9BX44syHNnHT+f3xEVdL7ERBQjzDrs08wUpmYMZA3Wp8S7OTK4XBqOMVA2pWhyVqaiEL1oH2lbXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B+GsRaUk; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34cc8bf226cso7909744a91.3
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768264331; x=1768869131; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vx8IbF6waxvT078eUcaNLcxctazNYIqS+jwtsNKv30M=;
        b=B+GsRaUkhMCaJsy4O8dui6D///tZ1k0ulLBAymukoQfn7cn1BYnnRSjSPyrvMvdIau
         iiMXvxrT20S4Gkhkp7ywARD5vDCaYvTHHR4XTnR30RMiYk4Nzq3rXPJoMpZgNcvFQYCZ
         6StffujPiZpXfnKbtDX9w4DAX5kdwLFwNMDfXzlwrQYBr8t6ln4wcH7cb0t8Hoa7/+gn
         eEJ9OPDGWY07emFGrWCNetcPSYJnO7ADSkKcARtPfNqXqUHcbjfxWF3GFpdakBaHOGMs
         r7iEbQBz39amAokUBmihxzQr6FoAexTfZ6g5jNjxqxRUG3j1zEEKOMbxYuUQZnTNYODY
         ptAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768264331; x=1768869131;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vx8IbF6waxvT078eUcaNLcxctazNYIqS+jwtsNKv30M=;
        b=AmUvh1NLPVb6qgwBtlA2rEOtSAiv6xx2O7505HFpYYj/GZnNO538jLjqdzn1ssXzQD
         /CpK49TFU8oM1O3nROXYzDpulHd/e7RthNRXag1B0G61Cl1uSbf5asGUvnzktRB17LPm
         m18Ab7ld6xX74bEXT2TOf+8tlEBhXnu+xcIqsTQ8uVM64cVWKFO0d8XD4F7f+FRgm/Ih
         UDpJOSEaCBpHkpAoK7tS08IqZF5WmdXRqmYEx1/+sj2U/Vov6l3nJZ0nXINsQK71m/FQ
         qoGTdXRJ+JzdpyCSJuWo8pNu3OfyDQY8xjG+4vBo9osSj7UomoqbXleJOMYkM1WqDir1
         k97A==
X-Gm-Message-State: AOJu0YwLCFeaa+6pEmnRO7mm6ILzQo3xJVUChuJMy/9e1lz043a1ZQGo
	8ab7415bTspgPD/p6No2G4AmyyhTK+8C8aXpCYgWRMVBQfpd6R8SSpy/YIIIz7h8WS70B5dB5Do
	/vaCIMZLT/C6ajNUGnfgrdACUSZbY3cQJ1uqJge2nJg06NNL0KcnHhY5glDH0R0hz6wZbsQkq5m
	oDzrYmJ6OVVFjk2Uq0XWFoQja2YqHKrEe5N7N+OrPaLv8=
X-Google-Smtp-Source: AGHT+IEz8BynoNDaRdTIWqfQHBcxzY5etNeSSad4Hxg0FO1jg5QoW3FBEcbyd/3AFp4Aeir3e83P2n8po+I//w==
X-Received: from pjboo9.prod.google.com ([2002:a17:90b:1c89:b0:34c:2f52:23aa])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3e43:b0:34a:b4a2:f0bf with SMTP id 98e67ed59e1d1-34f68c28716mr18975578a91.16.1768264330968;
 Mon, 12 Jan 2026 16:32:10 -0800 (PST)
Date: Tue, 13 Jan 2026 00:31:50 +0000
In-Reply-To: <20260113003153.3344500-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113003153.3344500-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113003153.3344500-9-chengkev@google.com>
Subject: [kvm-unit-tests PATCH V2 08/10] x86/svm: Add testing for NPT
 permissions on guest page tables
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

Modify permissions for NPT entries that contain guest page table
structures. Verify that NPF VM exit correctly reports fault occurred
during the guest page table walk and correctly reports the right
violation.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 x86/svm_npt.c | 223 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 221 insertions(+), 2 deletions(-)

diff --git a/x86/svm_npt.c b/x86/svm_npt.c
index 39e8b01965f25..410c17c7b7cbc 100644
--- a/x86/svm_npt.c
+++ b/x86/svm_npt.c
@@ -51,6 +51,12 @@ static void *get_1g_page(void)
 	return alloc;
 }
 
+static void do_npt_access_op(enum npt_access_op op)
+{
+	npt_access_test_data.op = op;
+	svm_vmrun();
+}
+
 static void
 diagnose_npt_violation_exit_code(u64 expected, u64 actual)
 {
@@ -115,9 +121,8 @@ static void do_npt_access(enum npt_access_op op, u64 expected_fault,
 	u64 exit_info_2;
 
 	/* Try the access and observe the violation. */
-	npt_access_test_data.op = op;
 	vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
-	svm_vmrun();
+	do_npt_access_op(op);
 
 	exit_code = vmcb->control.exit_code;
 	exit_info_1 = vmcb->control.exit_info_1;
@@ -422,6 +427,215 @@ static bool npt_rw_pfwalk_check(struct svm_test *test)
 	    && (vmcb->control.exit_info_2 == read_cr3());
 }
 
+/*
+ * This function modifies the NPT entry that maps the GPA that the guest page
+ * table entry mapping npt_access_test_data.gva resides on.
+ */
+static void npt_access_paddr(unsigned long npt_clear, unsigned long npt_set,
+			     unsigned long pte_set, enum npt_access_op op,
+			     bool expect_violation, u64 expected_fault)
+{
+	struct npt_access_test_data *data = &npt_access_test_data;
+	unsigned long *ptep;
+	unsigned long gpa;
+	unsigned long orig_npte;
+	unsigned long pte;
+	u64 orig_opt_mask = pte_opt_mask;
+	int level;
+
+	/* Modify the guest PTE mapping data->gva according to @pte_set.  */
+	ptep = get_pte_level(current_page_table(), data->gva, 1);
+	report(ptep, "Get pte for gva 0x%lx", (unsigned long)data->gva);
+	report((*ptep & PT_ADDR_MASK) == data->gpa, "gva is correctly mapped");
+	*ptep = (*ptep & ~PT_AD_MASK) | pte_set;
+	do_npt_access_op(OP_FLUSH_TLB);
+
+	/*
+	 * Now modify the access bits on the NPT entry for the GPA that the
+	 * guest PTE resides on. Note that by modifying a single NPT entry,
+	 * we're potentially affecting 512 guest PTEs. However, we've carefully
+	 * constructed our test such that those other 511 PTEs aren't used by
+	 * the guest: data->gva is at the beginning of a 1G huge page, thus the
+	 * PTE we're modifying is at the beginning of a 4K page and the
+	 * following 511 entries are also under our control (and not touched by
+	 * the guest).
+	 */
+	gpa = virt_to_phys(ptep);
+	assert((gpa & ~PAGE_MASK) == 0);
+
+	/*
+	 * Make sure the guest page table page is mapped with a 4K NPT entry,
+	 * otherwise our level=1 twiddling below will fail. We use the
+	 * identity map (gpa = gpa) since page tables are shared with the host.
+	 */
+	pte_opt_mask |= PT_USER_MASK;
+	install_pte(npt_get_pml4e(), /*level=*/1, (void *)(ulong)gpa,
+		    gpa | PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK, 0);
+	pte_opt_mask = orig_opt_mask;
+
+	orig_npte = npt_twiddle(gpa, /*mkhuge=*/0, /*level=1*/1, npt_clear, npt_set);
+
+	if (expect_violation) {
+		do_npt_access(op, expected_fault, gpa);
+		npt_untwiddle(gpa, /*level=*/1, orig_npte);
+		do_npt_access_op(op);
+		TEST_EXPECT_EQ(vmcb->control.exit_code, SVM_EXIT_VMMCALL);
+	} else {
+		do_npt_access(op, 0, gpa);
+		for (level = PAGE_LEVEL; level > 0; level--) {
+			pte = *find_pte_level(npt_get_pml4e(), (void *)gpa, level).pte;
+			report(pte & PT_ACCESSED_MASK,
+			       "Access flag set. PTE val: 0x%lx",
+			       pte);
+
+			if (level == 1)
+				report(pte & PT_DIRTY_MASK,
+				       "Dirty flag set. PTE val: 0x%lx",
+				       pte);
+			else
+				report(!(pte & PT_DIRTY_MASK),
+				       "Dirty flag not set. PTE val: 0x%lx level: %d",
+				       pte, level);
+		}
+
+		npt_untwiddle(gpa, /*level=*/1, orig_npte);
+	}
+
+	report(*ptep & PT_ACCESSED_MASK, "Access flag set");
+	if ((pte_set & PT_DIRTY_MASK) || op == OP_WRITE)
+		report(*ptep & PT_DIRTY_MASK, "Dirty flag set");
+}
+
+static void npt_access_allowed_paddr(unsigned long npt_clear, unsigned long npt_set,
+				     unsigned long pte_set, enum npt_access_op op)
+{
+	npt_access_paddr(npt_clear, npt_set, pte_set, op, false, 0);
+}
+
+static void npt_access_npf_paddr(unsigned long npt_clear, unsigned long npt_set,
+				 unsigned long pte_set, enum npt_access_op op,
+				 u64 expected_fault)
+{
+	npt_access_paddr(npt_clear, npt_set, pte_set, op, true, expected_fault);
+}
+
+/*
+ * All accesses to guest paging structures are considered as writes as far as
+ * NPT translation is concerned.
+ */
+static void npt_access_paddr_not_present_test(void)
+{
+	u32 pte_set_combinations[3] = {0, PT_ACCESSED_MASK, PT_DIRTY_MASK};
+
+	npt_access_test_setup();
+
+	for (int i = 0; i < ARRAY_SIZE(pte_set_combinations); i++) {
+		npt_access_npf_paddr(PT_PRESENT_MASK, 0,
+				     pte_set_combinations[i], OP_READ,
+				     PFERR_GUEST_PAGE_MASK | PFERR_USER_MASK |
+					     PFERR_WRITE_MASK);
+		npt_access_npf_paddr(PT_PRESENT_MASK, 0,
+				     pte_set_combinations[i], OP_WRITE,
+				     PFERR_GUEST_PAGE_MASK | PFERR_USER_MASK |
+					     PFERR_WRITE_MASK);
+		npt_access_npf_paddr(PT_PRESENT_MASK, 0,
+				     pte_set_combinations[i], OP_EXEC,
+				     PFERR_GUEST_PAGE_MASK | PFERR_USER_MASK |
+					     PFERR_WRITE_MASK);
+	}
+
+	npt_access_test_cleanup();
+}
+
+static void npt_access_paddr_read_only_test(void)
+{
+	u32 pte_set_combinations[3] = {0, PT_ACCESSED_MASK, PT_DIRTY_MASK};
+
+	npt_access_test_setup();
+
+	for (int i = 0; i < ARRAY_SIZE(pte_set_combinations); i++) {
+		npt_access_npf_paddr(PT_WRITABLE_MASK, PT64_NX_MASK,
+				     pte_set_combinations[i], OP_READ,
+				     PFERR_GUEST_PAGE_MASK | PFERR_USER_MASK |
+					     PFERR_WRITE_MASK |
+					     PFERR_PRESENT_MASK);
+		npt_access_npf_paddr(PT_WRITABLE_MASK, PT64_NX_MASK,
+				     pte_set_combinations[i], OP_WRITE,
+				     PFERR_GUEST_PAGE_MASK | PFERR_USER_MASK |
+					     PFERR_WRITE_MASK |
+					     PFERR_PRESENT_MASK);
+		npt_access_npf_paddr(PT_WRITABLE_MASK, PT64_NX_MASK,
+				     pte_set_combinations[i], OP_EXEC,
+				     PFERR_GUEST_PAGE_MASK | PFERR_USER_MASK |
+					     PFERR_WRITE_MASK |
+					     PFERR_PRESENT_MASK);
+	}
+
+	npt_access_test_cleanup();
+}
+
+static void npt_access_paddr_read_execute_test(void)
+{
+	u32 pte_set_combinations[3] = {0, PT_ACCESSED_MASK, PT_DIRTY_MASK};
+
+	npt_access_test_setup();
+
+	for (int i = 0; i < ARRAY_SIZE(pte_set_combinations); i++) {
+		npt_access_npf_paddr(
+			PT_WRITABLE_MASK, 0, pte_set_combinations[i], OP_READ,
+			PFERR_GUEST_PAGE_MASK | PFERR_USER_MASK |
+				PFERR_WRITE_MASK | PFERR_PRESENT_MASK);
+		npt_access_npf_paddr(
+			PT_WRITABLE_MASK, 0, pte_set_combinations[i], OP_WRITE,
+			PFERR_GUEST_PAGE_MASK | PFERR_USER_MASK |
+				PFERR_WRITE_MASK | PFERR_PRESENT_MASK);
+		npt_access_npf_paddr(
+			PT_WRITABLE_MASK, 0, pte_set_combinations[i], OP_EXEC,
+			PFERR_GUEST_PAGE_MASK | PFERR_USER_MASK |
+				PFERR_WRITE_MASK | PFERR_PRESENT_MASK);
+	}
+
+	npt_access_test_cleanup();
+}
+
+static void npt_access_paddr_read_write_test(void)
+{
+	u32 pte_set_combinations[3] = {0, PT_ACCESSED_MASK, PT_DIRTY_MASK};
+
+	npt_access_test_setup();
+
+	/* Read-write access to paging structure. */
+	for (int i = 0; i < ARRAY_SIZE(pte_set_combinations); i++) {
+		npt_access_allowed_paddr(0, PT_WRITABLE_MASK | PT64_NX_MASK,
+					 pte_set_combinations[i], OP_READ);
+		npt_access_allowed_paddr(0, PT_WRITABLE_MASK | PT64_NX_MASK,
+					 pte_set_combinations[i], OP_WRITE);
+		npt_access_allowed_paddr(0, PT_WRITABLE_MASK | PT64_NX_MASK,
+					 pte_set_combinations[i], OP_EXEC);
+	}
+
+	npt_access_test_cleanup();
+}
+
+static void npt_access_paddr_read_write_execute_test(void)
+{
+	u32 pte_set_combinations[3] = {0, PT_ACCESSED_MASK, PT_DIRTY_MASK};
+
+	npt_access_test_setup();
+
+	/* RWX access to paging structure. */
+	for (int i = 0; i < ARRAY_SIZE(pte_set_combinations); i++) {
+		npt_access_allowed_paddr(0, PT_WRITABLE_MASK, pte_set_combinations[i],
+					 OP_READ);
+		npt_access_allowed_paddr(0, PT_WRITABLE_MASK, pte_set_combinations[i],
+					 OP_WRITE);
+		npt_access_allowed_paddr(0, PT_WRITABLE_MASK, pte_set_combinations[i],
+					 OP_EXEC);
+	}
+
+	npt_access_test_cleanup();
+}
+
 static bool was_x2apic;
 
 static void npt_apic_prepare(void)
@@ -863,6 +1077,11 @@ static struct svm_test npt_tests[] = {
 	NPT_V2_TEST(npt_rw_test),
 	NPT_V2_TEST(npt_rwx_test),
 	NPT_V2_TEST(npt_ignored_bits_test),
+	NPT_V2_TEST(npt_access_paddr_not_present_test),
+	NPT_V2_TEST(npt_access_paddr_read_only_test),
+	NPT_V2_TEST(npt_access_paddr_read_write_test),
+	NPT_V2_TEST(npt_access_paddr_read_write_execute_test),
+	NPT_V2_TEST(npt_access_paddr_read_execute_test),
 	{ NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
 
-- 
2.52.0.457.g6b5491de43-goog


