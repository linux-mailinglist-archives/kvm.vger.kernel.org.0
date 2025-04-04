Return-Path: <kvm+bounces-42766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 41C4BA7C62E
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 00:07:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A24C2189B275
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 22:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9939A4689;
	Fri,  4 Apr 2025 22:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PMjXEFan"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B591EF368
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 22:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743804426; cv=none; b=QtonZc3XMVwyLKNZjt/21zfXEW2ILuOFQPL5hcV1LxXBcDvoVSLbL2Z7RcEe0Jure0XWlyR1x7vbDQeU96mGfBPh2eBc8huwXPIH3PLrXgJfsvqG/aAOfmQG5x+MJXW1lP+18ikMKAMpcOlK1k7N5sASuLjrMPlvy7cw0PmJOEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743804426; c=relaxed/simple;
	bh=gc3hJSkNqfRzGU3+OK2nkkH4ykmU6ujkP1HITztMmO0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=luTT/AdX46nE892TWB+jSKufJPJGtJxKagXLLhCxGp4IcXZIWn0wivJayfRJVRTrdR1fEn+3cTnf81zXovK4XS69Zt0crlrj2i3Lp7UnYUPpfqlMz5ml8FsCUGY/av41W3Snv74rCNL/d1uxeeT8i5fzj6ftyX7I+8mLockxkBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PMjXEFan; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-84cdae60616so306001539f.3
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 15:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743804424; x=1744409224; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QUdQNgm1PjoMdW2TBxOIubuTGYAmn66YIz4Y+WzKU0s=;
        b=PMjXEFanw8pnxjaPupo0nvtX+DEqrn5ZFwVBS9YfpHghD9Um1ApYZUFJHubMZqzh0R
         UY0UWGxbb0G1rw3o0K8b4I8MXBizzc2nuVIoHvV8W9Boj4ED0OYCVI7LZH/5GKts+m6D
         rN0wl5AapvQjstZ4/ITrSaqXLYLVforabjbpTHT3GaPhRdZ2r1SetSlkl4pwtmBW83t5
         fO+ql3jbuDXCKD69Ts8pHwuesoH7Ygo3UrhZ/DaYt4hJ5WDhO9L9lC1mIPWDnV9jp1yF
         PJQ9/Li0bgMN7oKNj7JIh+P6wSOxK/SSuYawE0Nsl72tMrGBSNZVTYgm8foJ+PxO0w95
         j+XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743804424; x=1744409224;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QUdQNgm1PjoMdW2TBxOIubuTGYAmn66YIz4Y+WzKU0s=;
        b=niY3culreq6NZ0unOvBzJnMRbr5JpJCMbXznVx8kbx02f3FIzXUmEHbilLpBzEIxrb
         1nzwpSrjIr1CWHMQUVkqFnvdEhT0QnCW1l/rwJVjPf2UVa+LfzMMoNgMAq/mMNJmzFZT
         qnJMJqXJqeC9gwm5cEGpZTpotxWnZJ3g1OotZIIBCX+jVQPPDtIZfIGzFGjuUbQf2D88
         TcJ4yBrjT9lKHWgXG18AmYBxsCuMV//kZphoeEK0TirsPxKGzr52nrsjneNp4Vd8hXU2
         qejDM2DaSETVl04LtEBouhdYxnvaFxTtBAvdt4e6ug6qiYGNmhgDuDeEX0U02VRTkT4Q
         +nuA==
X-Forwarded-Encrypted: i=1; AJvYcCV1L9K0KxnRynndFwx1Px1WwVsukazmrHDMY/FugOzIjwkc4ph55DJrC68Fr6JARSlzL6s=@vger.kernel.org
X-Gm-Message-State: AOJu0YynszaKi1/CmT4NJcxoo2+ZNgIeo8GnWhsyZoNfCf0FzX3GuOik
	ntrQgP5qCwolmQoPcbNeu964nha2X2i2W03onAWd2yZCZiB7hlVoKwxopZGr7p0rUmKeRrPAzO+
	BoPoYmQ==
X-Google-Smtp-Source: AGHT+IGOdeMrfiLJfq9ZriSmpSUM8BhfxN7qLU3it4pdLOmmgkoBBwAPIiSYahaLWW4f6O8ymMw2bOWrpRGH
X-Received: from iobeu3.prod.google.com ([2002:a05:6602:4c83:b0:85b:4941:3fec])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:4805:b0:85b:3f8e:f186
 with SMTP id ca18e2360f4ac-8612aa75520mr118475839f.6.1743804424251; Fri, 04
 Apr 2025 15:07:04 -0700 (PDT)
Date: Fri,  4 Apr 2025 22:06:58 +0000
In-Reply-To: <20250404220659.1312465-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404220659.1312465-1-rananta@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404220659.1312465-2-rananta@google.com>
Subject: [PATCH 1/2] KVM: selftests: arm64: Introduce and use
 hardware-definition macros
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"

The kvm selftest library for arm64 currently configures the hardware
fields, such as shift and mask in the page-table entries and registers,
directly with numbers. While it add comments at places, it's better to
rewrite them with appropriate macros to improve the readability and
reduce the risk of errors. Hence, introduce macros to define the
hardware fields and use them in the arm64 processor library.

Most of the definitions are primary copied from the Linux's header,
arch/arm64/include/asm/pgtable-hwdef.h.

No functional change intended.

Suggested-by: Oliver Upton <oupton@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/arch/arm64/include/asm/sysreg.h         | 38 +++++++++++++
 .../selftests/kvm/arm64/page_fault_test.c     |  2 +-
 .../selftests/kvm/include/arm64/processor.h   | 28 +++++++--
 .../selftests/kvm/lib/arm64/processor.c       | 57 ++++++++++---------
 4 files changed, 92 insertions(+), 33 deletions(-)

diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/include/asm/sysreg.h
index 150416682e2c..6fcde168f3a6 100644
--- a/tools/arch/arm64/include/asm/sysreg.h
+++ b/tools/arch/arm64/include/asm/sysreg.h
@@ -884,6 +884,44 @@
 	 SCTLR_EL1_LSMAOE | SCTLR_EL1_nTLSMD | SCTLR_EL1_EIS   | \
 	 SCTLR_EL1_TSCXT  | SCTLR_EL1_EOS)
 
+/* TCR_EL1 specific flags */
+#define TCR_T0SZ_OFFSET	0
+#define TCR_T0SZ(x)		((UL(64) - (x)) << TCR_T0SZ_OFFSET)
+
+#define TCR_IRGN0_SHIFT	8
+#define TCR_IRGN0_MASK		(UL(3) << TCR_IRGN0_SHIFT)
+#define TCR_IRGN0_NC		(UL(0) << TCR_IRGN0_SHIFT)
+#define TCR_IRGN0_WBWA		(UL(1) << TCR_IRGN0_SHIFT)
+#define TCR_IRGN0_WT		(UL(2) << TCR_IRGN0_SHIFT)
+#define TCR_IRGN0_WBnWA	(UL(3) << TCR_IRGN0_SHIFT)
+
+#define TCR_ORGN0_SHIFT	10
+#define TCR_ORGN0_MASK		(UL(3) << TCR_ORGN0_SHIFT)
+#define TCR_ORGN0_NC		(UL(0) << TCR_ORGN0_SHIFT)
+#define TCR_ORGN0_WBWA		(UL(1) << TCR_ORGN0_SHIFT)
+#define TCR_ORGN0_WT		(UL(2) << TCR_ORGN0_SHIFT)
+#define TCR_ORGN0_WBnWA	(UL(3) << TCR_ORGN0_SHIFT)
+
+#define TCR_SH0_SHIFT		12
+#define TCR_SH0_MASK		(UL(3) << TCR_SH0_SHIFT)
+#define TCR_SH0_INNER		(UL(3) << TCR_SH0_SHIFT)
+
+#define TCR_TG0_SHIFT		14
+#define TCR_TG0_MASK		(UL(3) << TCR_TG0_SHIFT)
+#define TCR_TG0_4K		(UL(0) << TCR_TG0_SHIFT)
+#define TCR_TG0_64K		(UL(1) << TCR_TG0_SHIFT)
+#define TCR_TG0_16K		(UL(2) << TCR_TG0_SHIFT)
+
+#define TCR_IPS_SHIFT		32
+#define TCR_IPS_MASK		(UL(7) << TCR_IPS_SHIFT)
+#define TCR_IPS_52_BITS	(UL(6) << TCR_IPS_SHIFT)
+#define TCR_IPS_48_BITS	(UL(5) << TCR_IPS_SHIFT)
+#define TCR_IPS_40_BITS	(UL(2) << TCR_IPS_SHIFT)
+#define TCR_IPS_36_BITS	(UL(1) << TCR_IPS_SHIFT)
+
+#define TCR_HA			(UL(1) << 39)
+#define TCR_DS			(UL(1) << 59)
+
 /* MAIR_ELx memory attributes (used by Linux) */
 #define MAIR_ATTR_DEVICE_nGnRnE		UL(0x00)
 #define MAIR_ATTR_DEVICE_nGnRE		UL(0x04)
diff --git a/tools/testing/selftests/kvm/arm64/page_fault_test.c b/tools/testing/selftests/kvm/arm64/page_fault_test.c
index ec33a8f9c908..dc6559dad9d8 100644
--- a/tools/testing/selftests/kvm/arm64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/arm64/page_fault_test.c
@@ -199,7 +199,7 @@ static bool guest_set_ha(void)
 	if (hadbs == 0)
 		return false;
 
-	tcr = read_sysreg(tcr_el1) | TCR_EL1_HA;
+	tcr = read_sysreg(tcr_el1) | TCR_HA;
 	write_sysreg(tcr, tcr_el1);
 	isb();
 
diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index 1e8d0d531fbd..691670bbe226 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -62,6 +62,28 @@
 	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |				\
 	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_WT, MT_NORMAL_WT))
 
+/*
+ * AttrIndx[2:0] encoding (mapping attributes defined in the MAIR* registers).
+ */
+#define PTE_ATTRINDX(t)	((t) << 2)
+#define PTE_ATTRINDX_MASK	GENMASK(4, 2)
+#define PTE_ATTRINDX_SHIFT	2
+
+#define PTE_VALID		BIT(0)
+#define PGD_TYPE_TABLE		BIT(1)
+#define PUD_TYPE_TABLE		BIT(1)
+#define PMD_TYPE_TABLE		BIT(1)
+#define PTE_TYPE_PAGE		BIT(1)
+
+#define PTE_AF			BIT(10)
+
+#define PTE_ADDR_MASK(page_shift)	GENMASK(47, (page_shift))
+#define PTE_ADDR_51_48			GENMASK(15, 12)
+#define PTE_ADDR_51_48_SHIFT		12
+#define PTE_ADDR_MASK_LPA2(page_shift)	GENMASK(49, (page_shift))
+#define PTE_ADDR_51_50_LPA2		GENMASK(9, 8)
+#define PTE_ADDR_51_50_LPA2_SHIFT	8
+
 void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init);
 struct kvm_vcpu *aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 				  struct kvm_vcpu_init *init, void *guest_code);
@@ -102,12 +124,6 @@ enum {
 			   (v) == VECTOR_SYNC_LOWER_64    || \
 			   (v) == VECTOR_SYNC_LOWER_32)
 
-/* Access flag */
-#define PTE_AF			(1ULL << 10)
-
-/* Access flag update enable/disable */
-#define TCR_EL1_HA		(1ULL << 39)
-
 void aarch64_get_supported_page_sizes(uint32_t ipa, uint32_t *ipa4k,
 					uint32_t *ipa16k, uint32_t *ipa64k);
 
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 7ba3aa3755f3..da5802c8a59c 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -72,13 +72,13 @@ static uint64_t addr_pte(struct kvm_vm *vm, uint64_t pa, uint64_t attrs)
 	uint64_t pte;
 
 	if (use_lpa2_pte_format(vm)) {
-		pte = pa & GENMASK(49, vm->page_shift);
-		pte |= FIELD_GET(GENMASK(51, 50), pa) << 8;
-		attrs &= ~GENMASK(9, 8);
+		pte = pa & PTE_ADDR_MASK_LPA2(vm->page_shift);
+		pte |= FIELD_GET(GENMASK(51, 50), pa) << PTE_ADDR_51_50_LPA2_SHIFT;
+		attrs &= ~PTE_ADDR_51_50_LPA2;
 	} else {
-		pte = pa & GENMASK(47, vm->page_shift);
+		pte = pa & PTE_ADDR_MASK(vm->page_shift);
 		if (vm->page_shift == 16)
-			pte |= FIELD_GET(GENMASK(51, 48), pa) << 12;
+			pte |= FIELD_GET(GENMASK(51, 48), pa) << PTE_ADDR_51_48_SHIFT;
 	}
 	pte |= attrs;
 
@@ -90,12 +90,12 @@ static uint64_t pte_addr(struct kvm_vm *vm, uint64_t pte)
 	uint64_t pa;
 
 	if (use_lpa2_pte_format(vm)) {
-		pa = pte & GENMASK(49, vm->page_shift);
-		pa |= FIELD_GET(GENMASK(9, 8), pte) << 50;
+		pa = pte & PTE_ADDR_MASK_LPA2(vm->page_shift);
+		pa |= FIELD_GET(PTE_ADDR_51_50_LPA2, pte) << 50;
 	} else {
-		pa = pte & GENMASK(47, vm->page_shift);
+		pa = pte & PTE_ADDR_MASK(vm->page_shift);
 		if (vm->page_shift == 16)
-			pa |= FIELD_GET(GENMASK(15, 12), pte) << 48;
+			pa |= FIELD_GET(PTE_ADDR_51_48, pte) << 48;
 	}
 
 	return pa;
@@ -128,7 +128,8 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 			 uint64_t flags)
 {
-	uint8_t attr_idx = flags & 7;
+	uint8_t attr_idx = flags & (PTE_ATTRINDX_MASK >> PTE_ATTRINDX_SHIFT);
+	uint64_t pg_attr;
 	uint64_t *ptep;
 
 	TEST_ASSERT((vaddr % vm->page_size) == 0,
@@ -147,18 +148,21 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 	ptep = addr_gpa2hva(vm, vm->pgd) + pgd_index(vm, vaddr) * 8;
 	if (!*ptep)
-		*ptep = addr_pte(vm, vm_alloc_page_table(vm), 3);
+		*ptep = addr_pte(vm, vm_alloc_page_table(vm),
+				 PGD_TYPE_TABLE | PTE_VALID);
 
 	switch (vm->pgtable_levels) {
 	case 4:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pud_index(vm, vaddr) * 8;
 		if (!*ptep)
-			*ptep = addr_pte(vm, vm_alloc_page_table(vm), 3);
+			*ptep = addr_pte(vm, vm_alloc_page_table(vm),
+					 PUD_TYPE_TABLE | PTE_VALID);
 		/* fall through */
 	case 3:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pmd_index(vm, vaddr) * 8;
 		if (!*ptep)
-			*ptep = addr_pte(vm, vm_alloc_page_table(vm), 3);
+			*ptep = addr_pte(vm, vm_alloc_page_table(vm),
+					 PMD_TYPE_TABLE | PTE_VALID);
 		/* fall through */
 	case 2:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pte_index(vm, vaddr) * 8;
@@ -167,7 +171,8 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		TEST_FAIL("Page table levels must be 2, 3, or 4");
 	}
 
-	*ptep = addr_pte(vm, paddr, (attr_idx << 2) | (1 << 10) | 3);  /* AF */
+	pg_attr = PTE_AF | PTE_ATTRINDX(attr_idx) | PTE_TYPE_PAGE | PTE_VALID;
+	*ptep = addr_pte(vm, paddr, pg_attr);
 }
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
@@ -293,20 +298,20 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 	case VM_MODE_P48V48_64K:
 	case VM_MODE_P40V48_64K:
 	case VM_MODE_P36V48_64K:
-		tcr_el1 |= 1ul << 14; /* TG0 = 64KB */
+		tcr_el1 |= TCR_TG0_64K;
 		break;
 	case VM_MODE_P52V48_16K:
 	case VM_MODE_P48V48_16K:
 	case VM_MODE_P40V48_16K:
 	case VM_MODE_P36V48_16K:
 	case VM_MODE_P36V47_16K:
-		tcr_el1 |= 2ul << 14; /* TG0 = 16KB */
+		tcr_el1 |= TCR_TG0_16K;
 		break;
 	case VM_MODE_P52V48_4K:
 	case VM_MODE_P48V48_4K:
 	case VM_MODE_P40V48_4K:
 	case VM_MODE_P36V48_4K:
-		tcr_el1 |= 0ul << 14; /* TG0 = 4KB */
+		tcr_el1 |= TCR_TG0_4K;
 		break;
 	default:
 		TEST_FAIL("Unknown guest mode, mode: 0x%x", vm->mode);
@@ -319,35 +324,35 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 	case VM_MODE_P52V48_4K:
 	case VM_MODE_P52V48_16K:
 	case VM_MODE_P52V48_64K:
-		tcr_el1 |= 6ul << 32; /* IPS = 52 bits */
+		tcr_el1 |= TCR_IPS_52_BITS;
 		ttbr0_el1 |= FIELD_GET(GENMASK(51, 48), vm->pgd) << 2;
 		break;
 	case VM_MODE_P48V48_4K:
 	case VM_MODE_P48V48_16K:
 	case VM_MODE_P48V48_64K:
-		tcr_el1 |= 5ul << 32; /* IPS = 48 bits */
+		tcr_el1 |= TCR_IPS_48_BITS;
 		break;
 	case VM_MODE_P40V48_4K:
 	case VM_MODE_P40V48_16K:
 	case VM_MODE_P40V48_64K:
-		tcr_el1 |= 2ul << 32; /* IPS = 40 bits */
+		tcr_el1 |= TCR_IPS_40_BITS;
 		break;
 	case VM_MODE_P36V48_4K:
 	case VM_MODE_P36V48_16K:
 	case VM_MODE_P36V48_64K:
 	case VM_MODE_P36V47_16K:
-		tcr_el1 |= 1ul << 32; /* IPS = 36 bits */
+		tcr_el1 |= TCR_IPS_36_BITS;
 		break;
 	default:
 		TEST_FAIL("Unknown guest mode, mode: 0x%x", vm->mode);
 	}
 
-	sctlr_el1 |= (1 << 0) | (1 << 2) | (1 << 12) /* M | C | I */;
-	/* TCR_EL1 |= IRGN0:WBWA | ORGN0:WBWA | SH0:Inner-Shareable */;
-	tcr_el1 |= (1 << 8) | (1 << 10) | (3 << 12);
-	tcr_el1 |= (64 - vm->va_bits) /* T0SZ */;
+	sctlr_el1 |= SCTLR_ELx_M | SCTLR_ELx_C | SCTLR_ELx_I;
+
+	tcr_el1 |= TCR_IRGN0_WBWA | TCR_ORGN0_WBWA | TCR_SH0_INNER;
+	tcr_el1 |= TCR_T0SZ(vm->va_bits);
 	if (use_lpa2_pte_format(vm))
-		tcr_el1 |= (1ul << 59) /* DS */;
+		tcr_el1 |= TCR_DS;
 
 	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), sctlr_el1);
 	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TCR_EL1), tcr_el1);
-- 
2.49.0.504.g3bcea36a83-goog


