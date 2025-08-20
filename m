Return-Path: <kvm+bounces-55198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A090B2E264
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 18:34:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C4173B25C4
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 16:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1632732BF4D;
	Wed, 20 Aug 2025 16:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ruTRC1Mt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EBE221269
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 16:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755707396; cv=none; b=W1Xp/Yuiz2B3A4qQWZJO5/CL94Edu7jeWnOTMzKcgG4CwETtnIRg3vFQB6t0stWNVj4iOxj4kuBNym7nzmXXixRzBNQ2mSuqMBm97mX2odWhgoDLLMLyrKSCHZvHe6Hxx6pKm9rB8etwdUkuiQrchvWrX4UJlPgNb9xhiU2TR+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755707396; c=relaxed/simple;
	bh=RggOQ1wVkSXYYlx6cMF666Uagf/tzr5k88Ik2NMWlOs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IhBHpyk2ov9PugPwEsUSEM0E5bu3bg5I64CTGFAi5tsUBhqRZlPF5ovGUSl6Y6/647S/1HS5gkpwBfa8umhfxqi0cYD07HvegedQRDxmG7h3DLywgIaxfhZijBbaM9zcU7N6sXz0j5EHmznjeyx/9czCE5jZVISDafk1B8+J5Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ruTRC1Mt; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-323766e64d5so1166682a91.0
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 09:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755707394; x=1756312194; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NtnNxKWu3fwpR0YNRlW4f8X9k4L5hSKnPUJE/kO69ZU=;
        b=ruTRC1Mtgm9yV4ZpiML0UQM+f7XBMNHZWH1i1uHnnsf0lub8eiPkXo7sMddjjVL/as
         wSqOA15aJ8YQRqcrHTr8qT8tM+Db1kkVi9/m1UXxULZxtDZHq42VIugkEGOK7lrRS6Os
         mD0xMFhzGGCnT/BSk3+NHJlMg82++Y+bQ6OJTIrUQei2SUBBx0/XW/186lOnj21oXOTA
         uhTUJC5hAWu+ujn4hLafC+SYnE9LV1QvhqPLzazutD4UJDBvXMyiokni2WUbkrftfpG+
         TlRL/nwAuWmxjzItZYMNNQ1eyzr7jlDnXxQ20BCr5IUSTZCWFxBLNWqOpAKcNGoMGJLE
         +KdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755707394; x=1756312194;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NtnNxKWu3fwpR0YNRlW4f8X9k4L5hSKnPUJE/kO69ZU=;
        b=mdN1nAs6ARrrcb9aKQKWaQfjrSuZxGsYuQJNphRuiOg8yBUwt6vNBjPo0dkbO5vlmo
         6Xi6nKP+74v01wmRVXrwJcYqX14y1ezNRUAIPvls6yriIE5yft9GlBzX3ruirpSlqF+B
         NTEnQBjKaNsXgXZmBdRQe4LhxZWRQ6O8FEGqCYrprW0wzcBjsduujQEGCmV9AtukUmgv
         Zl7i0vzQSiGPIf4W8rPWtxoPFd11U+7j+8wKWGCjE+RQWX/9b/sY+9frq24Zb+tToNJF
         ORzkwQ0jwbH2d5FNp7rrdePzUK40U0Q161Oxs4oOqT/6PriA3zDuNiG/SDNIBg25erGU
         XoOA==
X-Gm-Message-State: AOJu0YwqnHtbPEobpDmgqqhX/NX5kE7PgvcyR6J3vBrWrCFKIBv8cDTp
	ItjI55GPvK9ncNiiGzvNAFF+10qVAMrww79Ysay+zGfleC6t8iGDRLJRXMr1GiXDjM2em/839jw
	G71Vxp1n3GGl5nKHeVk15woXXFrU96AFyuLqRe0zNrIoJWi4u61M5q4bhrrFXsD6FL2VxDhaQlG
	6VYOL5Crt+QNnXqavVN1uia2NYVU9Pyiuao/Gh/m5iVrw=
X-Google-Smtp-Source: AGHT+IHU9TPlfuswJqcau/avi0if7tV5JOeVdlbO5FpSB4RDx3aNiRZgZeOOmAlcH0kx8cHh+Kp+i53GrxaRow==
X-Received: from pjur7.prod.google.com ([2002:a17:90a:d407:b0:312:e914:4548])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4e8c:b0:31f:ecf:36f with SMTP id 98e67ed59e1d1-324eb931756mr266320a91.1.1755707393883;
 Wed, 20 Aug 2025 09:29:53 -0700 (PDT)
Date: Wed, 20 Aug 2025 16:29:51 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250820162951.3499017-1-chengkev@google.com>
Subject: [kvm-unit-tests PATCH] x86: nSVM: Add test for EPT A/D bits
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: jmattson@google.com, pbonzini@redhat.com, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

The nVMX tests already have coverage for TDP A/D bits. Add a
similar test for nSVM to improve test parity between nSVM and nVMX.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 x86/svm.c     | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++
 x86/svm.h     |  5 +++
 x86/svm_npt.c | 46 +++++++++++++++++++++++++
 3 files changed, 144 insertions(+)

diff --git a/x86/svm.c b/x86/svm.c
index e715e270..53b78d16 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -14,6 +14,8 @@
 #include "isr.h"
 #include "apic.h"
 
+#include <asm/page.h>
+
 /* for the nested page table*/
 u64 *pml4e;
 
@@ -43,6 +45,97 @@ u64 *npt_get_pml4e(void)
 	return pml4e;
 }
 
+void clear_npt_ad(unsigned long *pml4e, u64 guest_cr3,
+		  unsigned long guest_addr)
+{
+	int l;
+	unsigned long *pt = (unsigned long *)guest_cr3, gpa;
+	u64 *npt_pte, pte, offset_in_page;
+	unsigned offset;
+
+	for (l = PAGE_LEVEL; ; --l) {
+		offset = PGDIR_OFFSET(guest_addr, l);
+		npt_pte = npt_get_pte((u64) &pt[offset]);
+
+		if(!npt_pte) {
+			printf("NPT - guest level %d page table is not mapped.\n", l);
+			return;
+		}
+
+		*npt_pte &= ~(PT_AD_MASK);
+
+		pte = pt[offset];
+		if (l == 1 || (l < 4 && (pte & PT_PAGE_SIZE_MASK)))
+			break;
+		if (!(pte & PT_PRESENT_MASK))
+			return;
+		pt = (unsigned long *)(pte & PT_ADDR_MASK);
+	}
+
+	offset = PGDIR_OFFSET(guest_addr, l);
+	offset_in_page = guest_addr &  ((1 << PGDIR_BITS(l)) - 1);
+	gpa = (pt[offset] & PT_ADDR_MASK) | (guest_addr & offset_in_page);
+	npt_pte = npt_get_pte(gpa);
+	*npt_pte &= ~(PT_AD_MASK);
+}
+
+void check_npt_ad(unsigned long *pml4e, u64 guest_cr3,
+	unsigned long guest_addr, int expected_gpa_ad,
+	int expected_pt_ad)
+{
+	int l;
+	unsigned long *pt = (unsigned long *)guest_cr3, gpa;
+	u64 *npt_pte, pte, offset_in_page;
+	unsigned offset;
+	bool bad_pt_ad = false;
+
+	for (l = PAGE_LEVEL; ; --l) {
+		offset = PGDIR_OFFSET(guest_addr, l);
+		npt_pte = npt_get_pte((u64) &pt[offset]);
+
+		if(!npt_pte) {
+			printf("NPT - guest level %d page table is not mapped.\n", l);
+			return;
+		}
+
+		if (!bad_pt_ad) {
+			bad_pt_ad |= (*npt_pte & PT_AD_MASK) != expected_pt_ad;
+			if(bad_pt_ad)
+				report_fail("NPT - received guest level %d page table A=%d/D=%d",
+					    l,
+					    !!(expected_pt_ad & PT_ACCESSED_MASK),
+					    !!(expected_pt_ad & PT_DIRTY_MASK));
+		}
+
+		pte = pt[offset];
+		if (l == 1 || (l < 4 && (pte & PT_PAGE_SIZE_MASK)))
+			break;
+		if (!(pte & PT_PRESENT_MASK))
+			return;
+		pt = (unsigned long *)(pte & PT_ADDR_MASK);
+	}
+
+	if (!bad_pt_ad)
+		report_pass("NPT - guest page table structures A=%d/D=%d",
+			    !!(expected_pt_ad & PT_ACCESSED_MASK),
+			    !!(expected_pt_ad & PT_DIRTY_MASK));
+
+	offset = PGDIR_OFFSET(guest_addr, l);
+	offset_in_page = guest_addr &  ((1 << PGDIR_BITS(l)) - 1);
+	gpa = (pt[offset] & PT_ADDR_MASK) | (guest_addr & offset_in_page);
+
+	npt_pte = npt_get_pte(gpa);
+
+	if (!npt_pte) {
+		report_fail("NPT - guest physical address is not mapped");
+		return;
+	}
+	report((*npt_pte & PT_AD_MASK) == expected_gpa_ad,
+	       "NPT - guest physical address A=%d/D=%d",
+	       !!(expected_gpa_ad & PT_ACCESSED_MASK),
+	       !!(expected_gpa_ad & PT_DIRTY_MASK));
+}
+
 bool smp_supported(void)
 {
 	return cpu_count() > 1;
diff --git a/x86/svm.h b/x86/svm.h
index c1dd84af..1a83d778 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -415,6 +415,11 @@ u64 *npt_get_pte(u64 address);
 u64 *npt_get_pde(u64 address);
 u64 *npt_get_pdpe(u64 address);
 u64 *npt_get_pml4e(void);
+void clear_npt_ad(unsigned long *pml4e, u64 guest_cr3,
+		  unsigned long guest_addr);
+void check_npt_ad(unsigned long *pml4e, u64 guest_cr3,
+		  unsigned long guest_addr, int expected_gpa_ad,
+		  int expected_pt_ad);
 bool smp_supported(void);
 bool default_supported(void);
 bool vgif_supported(void);
diff --git a/x86/svm_npt.c b/x86/svm_npt.c
index bd5e8f35..abf44eb0 100644
--- a/x86/svm_npt.c
+++ b/x86/svm_npt.c
@@ -380,6 +380,51 @@ skip_pte_test:
 	vmcb->save.cr4 = sg_cr4;
 }
 
+static void npt_ad_read_guest(struct svm_test *test)
+{
+	u64 *data = (void *)(0x80000);
+	(void)*(volatile u64 *)data;
+}
+
+static void npt_ad_write_guest(struct svm_test *test)
+{
+	u64 *data = (void *)(0x80000);
+	*data = 0;
+}
+
+static void npt_ad_test(void)
+{
+	u64 *data = (void *)(0x80000);
+	u64 guest_cr3 = vmcb->save.cr3;
+
+	if (!npt_supported()) {
+		report_skip("NPT not supported");
+		return;
+	}
+
+	clear_npt_ad(npt_get_pml4e(), guest_cr3, (unsigned long)data);
+
+	check_npt_ad(npt_get_pml4e(), guest_cr3, (unsigned long)data, 0, 0);
+
+	test_set_guest(npt_ad_read_guest);
+	svm_vmrun();
+
+	check_npt_ad(npt_get_pml4e(), guest_cr3,
+		     (unsigned long)data,
+		     PT_ACCESSED_MASK,
+		     PT_AD_MASK);
+
+	test_set_guest(npt_ad_write_guest);
+	svm_vmrun();
+
+	check_npt_ad(npt_get_pml4e(), guest_cr3,
+		     (unsigned long)data,
+		     PT_AD_MASK,
+		     PT_AD_MASK);
+
+	clear_npt_ad(npt_get_pml4e(), guest_cr3, (unsigned long)data);
+}
+
 #define NPT_V1_TEST(name, prepare, guest_code, check)				\
 	{ #name, npt_supported, prepare, default_prepare_gif_clear, guest_code,	\
 	  default_finished, check }
@@ -395,6 +440,7 @@ static struct svm_test npt_tests[] = {
 	NPT_V1_TEST(npt_l1mmio, npt_l1mmio_prepare, npt_l1mmio_test, npt_l1mmio_check),
 	NPT_V1_TEST(npt_rw_l1mmio, npt_rw_l1mmio_prepare, npt_rw_l1mmio_test, npt_rw_l1mmio_check),
 	NPT_V2_TEST(svm_npt_rsvd_bits_test),
+	NPT_V2_TEST(npt_ad_test),
 	{ NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
 
-- 
2.51.0.261.g7ce5a0a67e-goog


