Return-Path: <kvm+bounces-66423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E8D3CD2297
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 00:00:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AC9FD30996C2
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 22:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2ACA28CF5D;
	Fri, 19 Dec 2025 22:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WijJbJYQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3A22E7645
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 22:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766185173; cv=none; b=Azfz4ZQFKrfKSvOFkFdvD7tEKrW1d7Z6dhXsy0HW7o/ss0SDuWLfhtSMupu3YIWN+u+7xTSXUwmGER9GKqZlUIvrf26/K5jtsEN4ylgvpo8fbtm69eV1BaIa3qDaikewM9WQLuHiYWM4dzSRFWh9xnt3X2kSRSROibKxSWfUAQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766185173; c=relaxed/simple;
	bh=1cV59nC3n4IP5jhSK3abCkqEE5ikuxWT6FqcbYeFD3c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dfGDlNDPJ87B2sN4YcgmdnxIVeo6EqPWsdeAeN+m1RuZCT39x6Tg8kuBsHaUbzqZGpUHlsZZREmSLrD7V3dDxeR/LBH6o5FLTK9iZTTa8SpWqZKLAB0g8eOPeeHNqqZ9LD6ixvp1124SFv+MvaUjNDgs/peoApVJxGLetpjmF8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WijJbJYQ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34aa1d06456so5058255a91.0
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 14:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766185170; x=1766789970; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WDZepPUf0v64VexhywNmuX7lrSkguqoB99ih31ZqqgQ=;
        b=WijJbJYQY/XqglLsiebt6xvUfqha9hcexX69PdXc+dPqpXlrh6gom53iO670j5tE8Y
         70PcLIs5/qWLeljqMI0T+yPwKhMbgrONfz2UFi5OFwldn3tEruiT6oq93vIRFdwezyuS
         zAm0JKmYbLJ17aRR6dEIyw8E8QEgo9nDb0zx1lP7pnISNkYvOdQhApLl00RnGI3z2r3a
         D3hkp4IoZo2C3Y2y+iyTLtBx4RvaFerfNJLky8vUTVaVE7LoSrsXvXQC5llOCZi8+Vb3
         8k9L86j8yY1UNlimIHrad7q5UaiTWt22ncn/yw2Wki/mBEMikJBW7CBqP3lymlcyiEfh
         hCBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766185170; x=1766789970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WDZepPUf0v64VexhywNmuX7lrSkguqoB99ih31ZqqgQ=;
        b=hqHzJ7g27CjzejTcY51IGQFECe9XWkaPAF0aDTsTYPy3oOCtWjVSY78+6daCzLDHoK
         O0hFDYd+UnbtvAuBgZWhw8ai15SOu69E82nLeOHyH27LA4T0qEQDbm4h1TVIOZUfyCLd
         XcMPLAnWtN06bJzhOYr8FP3PMkbaZasmmb8fs0qKp66WXmylEBgFSFQrcjJWAJwPRKLI
         OQEKOOTlTkjmlY2vyYuhaWZszcKpy/pqlBc/3T8k5jPf4hHlnC5QeIATk6nfVws+UfLR
         1OVrxMxNLqJzmQ57hZVpEWiRr8mBF+VnutGf22uqiiuGP9dD6NItdXmk5iQjd+y0meAE
         LtYg==
X-Gm-Message-State: AOJu0Yx5I+24Zc78ho8/47gfXD2w0zJ9p0uXXvmaB3nz36ZOJA70JjsC
	slC3Eydl94P3tGO+T8ewJObvXNxdRbG0MFeSfpGfRVAAjdL/cORnaiB6V1uHaV77lWPkrSpB8BG
	CEbl4+vMAIjLYcfOPdce4XUeJ6shzFMNeIUJoMJsYeR8lMfOIaZb+aG17gKodl1TgYeSMEb1YnQ
	oFUqwv0rmtbV8kM628hfyk/77e3IaKhEsquxCdlviXr1g=
X-Google-Smtp-Source: AGHT+IH6WBOFKjEV8pCN2IFDSzqlsSikAIzFTZvxVHGFL4/ynm/92Z8CFuEDEIgmmvjKL1eOxFKwQ4FLikK8Kg==
X-Received: from pjbdj6.prod.google.com ([2002:a17:90a:d2c6:b0:340:631a:67fb])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2585:b0:340:bb51:17eb with SMTP id 98e67ed59e1d1-34e92131db5mr3869621a91.15.1766185169810;
 Fri, 19 Dec 2025 14:59:29 -0800 (PST)
Date: Fri, 19 Dec 2025 22:59:07 +0000
In-Reply-To: <20251219225908.334766-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251219225908.334766-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219225908.334766-9-chengkev@google.com>
Subject: [kvm-unit-tests PATCH 8/9] x86/svm: Add testing for NPT permissions
 on guest page tables
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
index ab744d41824f8..9380697f36ce9 100644
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
@@ -861,6 +1075,11 @@ static struct svm_test npt_tests[] = {
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
2.52.0.322.g1dd061c0dc-goog


