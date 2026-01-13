Return-Path: <kvm+bounces-67883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 68343D160DE
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:36:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AA4CC304F525
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:32:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E59A23D7DE;
	Tue, 13 Jan 2026 00:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="05tRw5EF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F9E258EF3
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 00:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768264321; cv=none; b=JumMViA+X7XToB2W5hhvo5W5b0NGd6/gCfCaJxGPSmCyusCJyii3bhz/OpLCBphzujNUv5hQX4E9M5zr17xHvkzZ4+kWQMCuL01PKHXgtfPEuSZ1xPeS9ew8ylYwDoFzR3PzQdE4UbUddueKTQkErzIIXL0ixiR02LJk/3ayLyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768264321; c=relaxed/simple;
	bh=YI8GKgEWSvy74tTAeJd5OjM9AF8uBnqY649Vn+Aim3A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FTo0Rtj0mqqx3T1xrzdrs9ryTfajhifcUPQqD6Yw+0d7/1iQ4jHvtWM6UiY1FWuqiEcvX+N241QE86BL/eio0e0Y1gvNLJ/hkE8i8JsIUKaLz4mWYpF7SkeWGfuz4Cr3Ie5hiZIbJdG4rGH7ZzVQnrHpqp38Mun9BgiIdfP54bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=05tRw5EF; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0c495fc7aso73891505ad.3
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768264319; x=1768869119; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uKVSseZq191DY2h5cOdzwmHnCWRmfZAKmHrk2bflk/Y=;
        b=05tRw5EF3WnCk9NhXGAQhDvXEhGmSclL7P5Gxj6Lybj8R3KMkdhqbh5IRco/dVUi4d
         EuxzUvzGZq2g1EZ6qhMjMdZiWDw0FPChe2Atlpfv3jHkbImjzjuSKm96JGsxlYnbi/02
         qyjxzA0CW9eIjp+4Y73uTuGfty/s9aSwpn9M0/vtkgcJNT3CcIvasLd/b+JzLxw5NqRh
         z3atCuYulXeOFC5qZj7X33clXsSyA/bP5W41XAjfXvW8pc9+yELOxAXdOVAo02rmF2a7
         clFFXqyD8Y47y1vdiBjChW3BPdeW7NeN7P6WQL+RtuEiuxguWGHrYLKlpmAENceG5AWl
         bOpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768264319; x=1768869119;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uKVSseZq191DY2h5cOdzwmHnCWRmfZAKmHrk2bflk/Y=;
        b=jQPatpFvbADCZBHCl7u8YdpNSYyejysYahOJUDdVg/urOEvTzpy2wlfF2p+Mlak6po
         MiHeUH/hemWAyuiUsvvVGNTJ1nkhbVsQ1G0NewLkHOfcSJJeNHoFvR/G+aGwysko1mYp
         nDvAhmcu5cFtV4YlPQ3HCdh36rqCEcZp7Uhc5nzdzvBAGezH1JSAlAgcrbiGtE/2TKKv
         fXuIcakLRZG9yWgQrsN31ZdimKTuFFQr4RhqKbZqDwSclPx63NQ/hDcjNon21o5k/XEv
         zG5NBdHBqdvYqTwqifA5TwA7T84XuNe7AEOjcjwY3X8qveLij/TgrJI7B5xTE9oWy1f+
         E4sQ==
X-Gm-Message-State: AOJu0YzWm8GXFt/k6CuvUpMECwUqXYm7yO13dlAT6FznMJlw4eX6YXyC
	cET0j4yD+6LHXPAwpXPda1hy0P1j5c1WZpsVntLTyFui/Eg9Q4ZcQZYygdTxPoZMv23WCBITdo9
	XfxzbVbbEUYG7D19Mq0veO5kw2/8bhkeBQ1GYxoz8cJ9aCsp4DIYaDYz20oZmMAgQFVWrMEDSjB
	pfglquZFY1PW5rqV2GlgsC/iDWgtD1QpT9Ke8Klv1RDpM=
X-Google-Smtp-Source: AGHT+IH4fcZzHaSTTVO6zmlVgYoaPNoEg0f684CsiwcI/zF8LdNYr08Riw/SCv29kgKkpJzhInEAF5qq927bJQ==
X-Received: from pjbfy4.prod.google.com ([2002:a17:90b:204:b0:33b:c211:1fa9])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1d01:b0:34c:a35d:de1b with SMTP id 98e67ed59e1d1-34f68c48346mr18156383a91.37.1768264319314;
 Mon, 12 Jan 2026 16:31:59 -0800 (PST)
Date: Tue, 13 Jan 2026 00:31:44 +0000
In-Reply-To: <20260113003153.3344500-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113003153.3344500-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113003153.3344500-3-chengkev@google.com>
Subject: [kvm-unit-tests PATCH V2 02/10] x86/nSVM: Add test for NPT A/D bits
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
 x86/svm_npt.c | 178 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 178 insertions(+)

diff --git a/x86/svm_npt.c b/x86/svm_npt.c
index bd5e8f351e343..7b8f57a8c3f07 100644
--- a/x86/svm_npt.c
+++ b/x86/svm_npt.c
@@ -380,6 +380,183 @@ skip_pte_test:
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
+ * found_bad_npt_ad : Check the NPT A/D bits at each level for GPA being
+ * translated. Note that non-leaf NPT levels encountered during translation
+ * only have the access bit set.
+ *
+ * Returns true if incorrect NPT A/D bits are found. Returns false otherwise.
+ */
+static bool found_bad_npt_ad(u64 *pml4e, void *gpa, int guest_level,
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
+			bad_pt_ad |= found_bad_npt_ad(pml4e, (void *)pte, l, PT_AD_MASK);
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
+	found_bad_npt_ad(pml4e, (void *)gpa, l, expected_gpa_ad);
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
@@ -395,6 +572,7 @@ static struct svm_test npt_tests[] = {
 	NPT_V1_TEST(npt_l1mmio, npt_l1mmio_prepare, npt_l1mmio_test, npt_l1mmio_check),
 	NPT_V1_TEST(npt_rw_l1mmio, npt_rw_l1mmio_prepare, npt_rw_l1mmio_test, npt_rw_l1mmio_check),
 	NPT_V2_TEST(svm_npt_rsvd_bits_test),
+	NPT_V2_TEST(npt_ad_test),
 	{ NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
 
-- 
2.52.0.457.g6b5491de43-goog


