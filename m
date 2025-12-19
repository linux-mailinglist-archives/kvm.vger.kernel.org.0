Return-Path: <kvm+bounces-66417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A7112CD2280
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 23:59:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DDE8E3064E5B
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 22:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1B272E8B67;
	Fri, 19 Dec 2025 22:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hu+sUFxN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A352BE7AB
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 22:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766185160; cv=none; b=u8DYFrpfD/gs5JhmYIaOaJdrrwAvt2SaFv6IRo8FOMS9ACyv5/+quzNo0UVt5l9s6Q58e+oTCbwk5WqBWBaqnQuIK0NADbiI5TJ9hOpcImoE9YFmgbli7Hqmug2AhmwDgHI6rnNN4tyXh8q3y9THV04eRtZYvxxwPy8bCPwTboE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766185160; c=relaxed/simple;
	bh=6ihFjH17jRBu7a0IQ1EKWlSNJsgtJEcLUoML1uWlDKg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k8LK44nPrVwPxX8012ODf8BGlpCL2dP8DDL/pKyJXCaxfJA+C/D7GizDaR19a5V7AiBOcE98B6YKWFphqLz61OT1+A8cDuFL678O7+2T7DUTKl3nR8X3coqJDXxo4CujjgojnAecSv5OKEZ9iP6ek8VvRL3+FQmPKfhu+zWiXTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hu+sUFxN; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7ba92341f38so2601807b3a.0
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 14:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766185158; x=1766789958; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rIfnMzRVeRLUz9C6RS9gH2VEEemp8uRaA4e/ljZQJWo=;
        b=Hu+sUFxNIlJkixk0NyiXeN/VQd65s6fDXwcXAzUhzY++/P5R6WW87RSWkmyHtvNk9w
         a46lRaGNuDBTaup6KEIbcKP7+S//kyfKs8jbW7ZLCW4xvKEtK1OZo/g24CFl3xhyQyOg
         PWDadMvspsH0UvakVpHuuEhPuOm63HQci+qfTDIYtFUywngwKpRuWsemJ0Zlu8cYnoyu
         QZl7jd74MR7hNqmKxwGZJD0pRnj5VJaybt0n+ovvz/d2Jf4MNjErRjRMvnuA1MWohddl
         TZ4xM62Wv2r9rOhbyQ8VfTx9nDz3TxPph27tq95ksuR8FW8F7NYmQEaqKGrx/5nR085b
         6yqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766185158; x=1766789958;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rIfnMzRVeRLUz9C6RS9gH2VEEemp8uRaA4e/ljZQJWo=;
        b=ahTmxn5Y6YiGdr24Qt8fRJswNPNxodZK+pfwUJ3brnsAQIKzMGlkBTZnRitBUXxgAL
         mXXNXNz2XVXKEGl+/vGCKfd3HfXAidg3V7qosRDlbW6yj523K46mtFzBqpUKCwfbSMsH
         gW32rJIudvFz3+7ay5P6G99kEFzCkhx9zhxaU4lymU87wS5+fFetwWjAar3JBbpuX0NF
         AvLkcOKAoROBBto8vywK4sXcdbC+2J8IXgvSMsr/NalAzZdAC3fZjy8uXeGjEtv3nsaG
         HZFPYzxnINcbF0Mis6rVcZK0Ak3uPZHoTj1YmSMre1TIIsIj0smESyn+yIzDGY+rxtHU
         a66g==
X-Gm-Message-State: AOJu0Yzr9W8zVXhtkbxFWQYU3tj5SPVvxzXFTWv+SRTl8DKiAUd5ZPc8
	G9zTHNGA9LQ9EybKlnYHNoDMorTt6tBKKo9LTEYErdR8auN0v5qwTXfQ94ZO5PhLzk8ZsU22I3C
	v6QQWXWj8TCKw1YN0YNOUtn573P3T9vsxXZVpIUWil5i0weQLLmj6NSsgunbq8wAOrUXBqgUZXP
	kbXlYP0pFSHiXWI5R3IvEqGDfr4ImutZZA+v4HVRyENZg=
X-Google-Smtp-Source: AGHT+IEjg2RPs9Qfijoi9JBb4Vmj2+8QliSkICM1yRaRXpXFiG2QtsXOKDbD5lJwBIQyff2YUpEdtCghVRo68A==
X-Received: from pfkh15.prod.google.com ([2002:a05:6a00:f:b0:7b8:565a:73bd])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:e13:b0:781:2291:1045 with SMTP id d2e1a72fcca58-7ff64fc5fd4mr3727298b3a.8.1766185157450;
 Fri, 19 Dec 2025 14:59:17 -0800 (PST)
Date: Fri, 19 Dec 2025 22:59:01 +0000
In-Reply-To: <20251219225908.334766-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251219225908.334766-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219225908.334766-3-chengkev@google.com>
Subject: [kvm-unit-tests PATCH 2/9] x86/nSVM: Add test for NPT A/D bits
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

Nested page table entries that were touched during nested page table
walks for guest PTEs always have their dirty and accessed bits set.
Write a test that verifies this behavior for guest read and writes. Note
that non-leaf NPT levels encountered during the GPA to HPA translation
for guest PTEs only have their accessed bits set.

The nVMX tests already have coverage for TDP A/D bits. Add a
similar test for nSVM to improve test parity between nSVM and nVMX.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 x86/svm_npt.c | 176 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 176 insertions(+)

diff --git a/x86/svm_npt.c b/x86/svm_npt.c
index bd5e8f351e343..e436c43fb1c4c 100644
--- a/x86/svm_npt.c
+++ b/x86/svm_npt.c
@@ -380,6 +380,181 @@ skip_pte_test:
 	vmcb->save.cr4 = sg_cr4;
 }
 
+
+static void clear_npt_ad_pte(unsigned long *pml4e, void *gpa)
+{
+	unsigned long *pte;
+	int l;
+
+	for (l = PAGE_LEVEL; l > 0; --l) {
+		pte = get_pte_level(pml4e, gpa, l);
+		*pte &= ~(PT_AD_MASK);
+		if (*pte & PT_PAGE_SIZE_MASK)
+			break;
+	}
+}
+
+/*
+ * clear_npt_ad : Clear NPT A/D bits for the page table walk and the final
+ * GPA of a guest address.
+ */
+static void clear_npt_ad(u64 *pml4e, unsigned long *guest_cr3,
+			 void *gva)
+{
+	unsigned long *pte = guest_cr3, gpa;
+	u64 offset_in_page;
+	int l;
+
+	for (l = PAGE_LEVEL; l > 0; --l) {
+		pte = get_pte_level(guest_cr3, gva, l);
+
+		clear_npt_ad_pte(pml4e, (void *)pte);
+
+		assert(*pte & PT_PRESENT_MASK);
+		if (*pte & PT_PAGE_SIZE_MASK)
+			break;
+	}
+
+	pte = get_pte_level(guest_cr3, gva, l);
+	offset_in_page = (u64)gva &  ((1 << PGDIR_BITS(l)) - 1);
+	gpa = (*pte & PT_ADDR_MASK) | ((u64)gva & offset_in_page);
+	clear_npt_ad_pte(pml4e, (void *)gpa);
+}
+
+/*
+ * check_npt_ad_pte : Check the NPT A/D bits at each level for GPA being
+ * translated. Note that non-leaf NPT levels encountered during translation
+ * only have the access bit set.
+ */
+static bool check_npt_ad_pte(u64 *pml4e, void *gpa, int guest_level,
+			     int expected_ad)
+{
+	int l, expected_ad_level;
+	unsigned long *pte;
+	bool leaf;
+
+	for (l = PAGE_LEVEL; l > 0; --l) {
+		pte = get_pte_level(pml4e, gpa, l);
+		leaf = (l == 1) || (*pte & PT_PAGE_SIZE_MASK);
+		expected_ad_level = expected_ad;
+
+		/* The dirty bit is only set on leaf PTEs */
+		if (!leaf)
+			expected_ad_level = expected_ad & ~PT_DIRTY_MASK;
+
+		if ((*pte & PT_AD_MASK) != expected_ad_level) {
+			report_fail("NPT - guest level %d npt level %d page table received: A=%d/D=%d, expected A=%d/D=%d",
+				    guest_level,
+				    l,
+				    !!(*pte & PT_ACCESSED_MASK),
+				    !!(*pte & PT_DIRTY_MASK),
+				    !!(expected_ad & PT_ACCESSED_MASK),
+				    !!(expected_ad & PT_DIRTY_MASK));
+			return true;
+		}
+
+		if (leaf)
+			break;
+	}
+
+	return false;
+}
+
+/*
+ * check_npt_ad : Check the content of NPT A/D bits for the page table walk
+ * and the final GPA of a guest address.
+ */
+static void check_npt_ad(u64 *pml4e, unsigned long *guest_cr3,
+			 void *gva, int expected_gpa_ad)
+{
+	unsigned long *pte = guest_cr3, gpa;
+	u64 *npt_pte, offset_in_page;
+	bool bad_pt_ad = false;
+	int l;
+
+	for (l = PAGE_LEVEL; l > 0; --l) {
+		pte = get_pte_level(guest_cr3, gva, l);
+		npt_pte = npt_get_pte((u64) pte);
+
+		if (!npt_pte) {
+			report_fail("NPT - guest level %d page table is not mapped.\n", l);
+			return;
+		}
+
+		if (!bad_pt_ad)
+			bad_pt_ad |= check_npt_ad_pte(pml4e, (void *)pte, l, PT_AD_MASK);
+
+		assert(*pte & PT_PRESENT_MASK);
+		if (*pte & PT_PAGE_SIZE_MASK)
+			break;
+	}
+
+	pte = get_pte_level(guest_cr3, gva, l);
+	offset_in_page = (u64)gva &  ((1 << PGDIR_BITS(l)) - 1);
+	gpa = (*pte & PT_ADDR_MASK) | ((u64)gva & offset_in_page);
+
+	npt_pte = npt_get_pte(gpa);
+
+	if (!npt_pte) {
+		report_fail("NPT - guest physical address is not mapped");
+		return;
+	}
+
+	check_npt_ad_pte(pml4e, (void *)gpa, l, expected_gpa_ad);
+	report((*npt_pte & PT_AD_MASK) == expected_gpa_ad,
+	       "NPT - guest physical address received: A=%d/D=%d, expected A=%d/D=%d",
+	       !!(*npt_pte & PT_ACCESSED_MASK),
+	       !!(*npt_pte & PT_DIRTY_MASK),
+	       !!(expected_gpa_ad & PT_ACCESSED_MASK),
+	       !!(expected_gpa_ad & PT_DIRTY_MASK));
+}
+
+static void npt_ad_read_guest(struct svm_test *test)
+{
+	(void)*(volatile u64 *)scratch_page;
+}
+
+static void npt_ad_write_guest(struct svm_test *test)
+{
+	*((u64 *)scratch_page) = 42;
+}
+
+static void npt_ad_test(void)
+{
+	unsigned long *guest_cr3 = (unsigned long *) vmcb->save.cr3;
+
+	if (!npt_supported()) {
+		report_skip("NPT not supported");
+		return;
+	}
+
+	scratch_page = alloc_page();
+
+	clear_npt_ad(npt_get_pml4e(), guest_cr3, scratch_page);
+
+	test_set_guest(npt_ad_read_guest);
+	svm_vmrun();
+
+	/*
+	 * NPT walks for guest page tables are write accesses by default unless
+	 * read-only guest page tables are used. As a result, we expect the
+	 * dirty bit to be set on NPT mappings of guest page tables. Since the
+	 * access itself is a read, we expect the final translation to not have
+	 * the dirty bit set.
+	 */
+	check_npt_ad(npt_get_pml4e(), guest_cr3, scratch_page, PT_ACCESSED_MASK);
+
+	test_set_guest(npt_ad_write_guest);
+	svm_vmrun();
+
+	check_npt_ad(npt_get_pml4e(), guest_cr3, scratch_page, PT_AD_MASK);
+
+	report(*((u64 *)scratch_page) == 42, "Expected: 42, received: %ld",
+	       *((u64 *)scratch_page));
+
+	clear_npt_ad(npt_get_pml4e(), guest_cr3, scratch_page);
+}
+
 #define NPT_V1_TEST(name, prepare, guest_code, check)				\
 	{ #name, npt_supported, prepare, default_prepare_gif_clear, guest_code,	\
 	  default_finished, check }
@@ -395,6 +570,7 @@ static struct svm_test npt_tests[] = {
 	NPT_V1_TEST(npt_l1mmio, npt_l1mmio_prepare, npt_l1mmio_test, npt_l1mmio_check),
 	NPT_V1_TEST(npt_rw_l1mmio, npt_rw_l1mmio_prepare, npt_rw_l1mmio_test, npt_rw_l1mmio_check),
 	NPT_V2_TEST(svm_npt_rsvd_bits_test),
+	NPT_V2_TEST(npt_ad_test),
 	{ NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
 
-- 
2.52.0.322.g1dd061c0dc-goog


