Return-Path: <kvm+bounces-17058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ECF18C0508
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 21:30:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A180B1C218AD
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 19:30:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C985130AC1;
	Wed,  8 May 2024 19:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="aNY+A7nq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C3112D75D
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 19:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715196592; cv=none; b=WoxSOksB5Wzgzqp7nornmYHylcyL5sQ4CofXRsepLjqcFhv1X9umPzeYukqTZazywxWiwYJoYWJTnW3LogaCbtJBCnM+fn9R96iFPUi3wMJUqQjtjo7hIu1Ms1vbbVar39f29pCQ+ISeTZ5tkJ+LRIqNYnrk07SBgpEs1/tznFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715196592; c=relaxed/simple;
	bh=gHarnxk3+TQDW2Of9KtkFTyUbjl3FMDQzz2bLlhHcjo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r598z6XVHKvO1QCzAz5+1ko6DtFbVM8ghA2XRRgB+RPyEJ5ij4ORvcIEVTOa0NZnMx77w4udzaDnVJ5BJJZuntN8krxiYaIRwxXwEvv79gXgWtJYZNVjfiYQNkuH0Jg3KtxHeG/nTCGhNYWO29/9aL2DZiSdegiv2TJLcpE+jSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=aNY+A7nq; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-41ecffed96cso662185e9.1
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 12:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1715196587; x=1715801387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uckq1a6OF7H/9ROfgD12E/DRrLJPxYkFYbl5+hSyETI=;
        b=aNY+A7nqvoGdE8Zq3WOfOfLYZWlHlLYK88ZlsUU+DYmX5vtL4glONYUnD46AZSoiVH
         UYMHQ/PgKZzxXQ990RbM2HyNfpIo57AyYpbusjBLUKJE3ozks+TK0b6YEGUTn6fy7gzR
         1q2vzmh93+FH3H2RqnQfPgjOm0DAZS3qJrLr+rh/F+/bh/zKPR3WjPFxo9Fcaf1DTvzl
         AkCLymgFRQ0JTl4D6g0YnMxEq5Tqgu6g83U+3kxuYgey83bz8DLoKHmbgW2J2OM1Hsqy
         IJEIguqyYO4qU9iu4I4uJnFDlAJvYUVl11FCBPBv67ittsZ9i5zDadcnB6hJfZkSEObo
         p1HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715196587; x=1715801387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uckq1a6OF7H/9ROfgD12E/DRrLJPxYkFYbl5+hSyETI=;
        b=p0ErVex3kso25d2VCR632L6NiiIfiQLLmsxO2f/dnXBWMBWPSUbx696G/KFOHe6E5X
         5zMb1ZbbOozMPYkxH9BXIDM4S9qEdLjBM6sZxEoASXy+OcUhZ0MDmbPJBQ+N0iaqwIWk
         kTy48qXTUW2cEXDHIcVaRf6Oi25yblOGDdu0kCFJaSim1mzgku9g0M1TAFHIWQ3O07eo
         tWhT/OR9D8fJkvXXbvo56iRf0mr5fjZeWoR2VEzdARqXgwYz7Ii7C9bQg9O9OA1VNaHc
         a/DpFt6Hxfh64c3UFQgx2sts11Pjzm8jUsBmeNv5vuEQX3DYsMoxHCebTkUg+CuuRwVk
         U2+A==
X-Forwarded-Encrypted: i=1; AJvYcCWBJbM8t2+daqTktoGwtyiy29TPuCR0J5XpDxXAjAd8uUAOO66yi1VhSgdJr/41G4MWDU/O5H/KSBW7eAmyXcrq2O4F
X-Gm-Message-State: AOJu0YxJNSt99mB/FQ/R9R6+GdWRKefOKKKQUiBLvURbysB+mp7qZANO
	QW9XaeEzfOsBiiyBKNwX3IEK+Ynxm29b69vmZi+u3dZ5D9fV3p8kPFdGU41hboQ=
X-Google-Smtp-Source: AGHT+IGQ61Vb4NuwkawA/0/DWqDCfOJMo7+D5f/tM30tLGXtIG6xkHE311QLb6FnYOpUeATe3M4jpQ==
X-Received: by 2002:a05:600c:4e93:b0:41b:fc3a:f1ef with SMTP id 5b1f17b1804b1-41f71acca18mr25217385e9.33.1715196587426;
        Wed, 08 May 2024 12:29:47 -0700 (PDT)
Received: from alex-rivos.ba.rivosinc.com (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id d16-20020a05600c34d000b00419f572671dsm3314921wmq.20.2024.05.08.12.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 12:29:47 -0700 (PDT)
From: Alexandre Ghiti <alexghiti@rivosinc.com>
To: Ryan Roberts <ryan.roberts@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-riscv@lists.infradead.org,
	linux-efi@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-mm@kvack.org
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 10/12] mm, riscv, arm64: Use common ptep_set_access_flags() function
Date: Wed,  8 May 2024 21:19:29 +0200
Message-Id: <20240508191931.46060-11-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240508191931.46060-1-alexghiti@rivosinc.com>
References: <20240508191931.46060-1-alexghiti@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make riscv use the contpte aware ptep_set_access_flags() function from
arm64.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
---
 arch/arm64/include/asm/pgtable.h | 19 ++--------
 arch/arm64/mm/contpte.c          | 46 -----------------------
 arch/riscv/include/asm/pgtable.h | 10 +++--
 include/linux/contpte.h          |  3 ++
 mm/contpte.c                     | 63 ++++++++++++++++++++++++++++++++
 5 files changed, 76 insertions(+), 65 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 92c12fb85cb4..6591aab11c67 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1391,9 +1391,6 @@ extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
 				unsigned int nr, int full);
 extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, unsigned int nr);
-extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep,
-				pte_t entry, int dirty);
 
 #define pte_batch_hint pte_batch_hint
 static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
@@ -1512,19 +1509,9 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm,
 }
 
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
-static inline int ptep_set_access_flags(struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep,
-				pte_t entry, int dirty)
-{
-	pte_t orig_pte = __ptep_get(ptep);
-
-	entry = pte_mknoncont(entry);
-
-	if (likely(!pte_valid_cont(orig_pte)))
-		return __ptep_set_access_flags(vma, addr, ptep, entry, dirty);
-
-	return contpte_ptep_set_access_flags(vma, addr, ptep, entry, dirty);
-}
+extern int ptep_set_access_flags(struct vm_area_struct *vma,
+				 unsigned long addr, pte_t *ptep,
+				 pte_t entry, int dirty);
 
 #else /* CONFIG_THP_CONTPTE */
 
diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index 16940511943c..5675a61452ac 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -62,49 +62,3 @@ void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
 	__wrprotect_ptes(mm, addr, ptep, nr);
 }
 EXPORT_SYMBOL_GPL(contpte_wrprotect_ptes);
-
-int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
-					unsigned long addr, pte_t *ptep,
-					pte_t entry, int dirty)
-{
-	unsigned long start_addr;
-	pte_t orig_pte;
-	int i;
-
-	/*
-	 * Gather the access/dirty bits for the contiguous range. If nothing has
-	 * changed, its a noop.
-	 */
-	orig_pte = pte_mknoncont(ptep_get(ptep));
-	if (pte_val(orig_pte) == pte_val(entry))
-		return 0;
-
-	/*
-	 * We can fix up access/dirty bits without having to unfold the contig
-	 * range. But if the write bit is changing, we must unfold.
-	 */
-	if (pte_write(orig_pte) == pte_write(entry)) {
-		/*
-		 * For HW access management, we technically only need to update
-		 * the flag on a single pte in the range. But for SW access
-		 * management, we need to update all the ptes to prevent extra
-		 * faults. Avoid per-page tlb flush in __ptep_set_access_flags()
-		 * and instead flush the whole range at the end.
-		 */
-		ptep = arch_contpte_align_down(ptep);
-		start_addr = addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
-
-		for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
-			__ptep_set_access_flags(vma, addr, ptep, entry, 0);
-
-		if (dirty)
-			__flush_tlb_range(vma, start_addr, addr,
-							PAGE_SIZE, true, 3);
-	} else {
-		__contpte_try_unfold(vma->vm_mm, addr, ptep, orig_pte);
-		__ptep_set_access_flags(vma, addr, ptep, entry, dirty);
-	}
-
-	return 1;
-}
-EXPORT_SYMBOL_GPL(contpte_ptep_set_access_flags);
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 42c7884b8d2e..b151a5aa4de8 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -803,6 +803,10 @@ extern int ptep_test_and_clear_young(struct vm_area_struct *vma,
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
 extern int ptep_clear_flush_young(struct vm_area_struct *vma,
 				  unsigned long addr, pte_t *ptep);
+#define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
+extern int ptep_set_access_flags(struct vm_area_struct *vma,
+				 unsigned long address, pte_t *ptep,
+				 pte_t entry, int dirty);
 
 #else /* CONFIG_THP_CONTPTE */
 
@@ -816,11 +820,11 @@ extern int ptep_clear_flush_young(struct vm_area_struct *vma,
 #define ptep_test_and_clear_young	__ptep_test_and_clear_young
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
 #define ptep_clear_flush_young	__ptep_clear_flush_young
+#define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
+#define ptep_set_access_flags	__ptep_set_access_flags
 
 #endif /* CONFIG_THP_CONTPTE */
 
-#define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
-#define ptep_set_access_flags	__ptep_set_access_flags
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 #define ptep_set_wrprotect	__ptep_set_wrprotect
 
@@ -990,7 +994,7 @@ static inline int pmdp_set_access_flags(struct vm_area_struct *vma,
 					unsigned long address, pmd_t *pmdp,
 					pmd_t entry, int dirty)
 {
-	return ptep_set_access_flags(vma, address, (pte_t *)pmdp, pmd_pte(entry), dirty);
+	return __ptep_set_access_flags(vma, address, (pte_t *)pmdp, pmd_pte(entry), dirty);
 }
 
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
diff --git a/include/linux/contpte.h b/include/linux/contpte.h
index 76a49ac8b6f5..76244b0c678a 100644
--- a/include/linux/contpte.h
+++ b/include/linux/contpte.h
@@ -23,5 +23,8 @@ int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
 				      unsigned long addr, pte_t *ptep);
 int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
 				   unsigned long addr, pte_t *ptep);
+int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
+				  unsigned long addr, pte_t *ptep,
+				  pte_t entry, int dirty);
 
 #endif /* _LINUX_CONTPTE_H */
diff --git a/mm/contpte.c b/mm/contpte.c
index 600277b1196c..9cbbff1f67ad 100644
--- a/mm/contpte.c
+++ b/mm/contpte.c
@@ -769,4 +769,67 @@ __always_inline int ptep_clear_flush_young(struct vm_area_struct *vma,
 
 	return contpte_ptep_clear_flush_young(vma, addr, ptep);
 }
+
+int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
+				  unsigned long addr, pte_t *ptep,
+				  pte_t entry, int dirty)
+{
+	unsigned long start_addr;
+	pte_t orig_pte;
+	int i;
+
+	/*
+	 * Gather the access/dirty bits for the contiguous range. If nothing has
+	 * changed, its a noop.
+	 */
+	orig_pte = pte_mknoncont(ptep_get(ptep));
+	if (pte_val(orig_pte) == pte_val(entry))
+		return 0;
+
+	/*
+	 * We can fix up access/dirty bits without having to unfold the contig
+	 * range. But if the write bit is changing, we must unfold.
+	 */
+	if (pte_write(orig_pte) == pte_write(entry)) {
+		/*
+		 * For HW access management, we technically only need to update
+		 * the flag on a single pte in the range. But for SW access
+		 * management, we need to update all the ptes to prevent extra
+		 * faults. Avoid per-page tlb flush in __ptep_set_access_flags()
+		 * and instead flush the whole range at the end.
+		 */
+		size_t pgsize;
+		int ncontig;
+
+		ptep = arch_contpte_align_down(ptep);
+		ncontig = arch_contpte_get_num_contig(vma->vm_mm, addr, ptep, 0, &pgsize);
+		start_addr = addr = ALIGN_DOWN(addr, ncontig * pgsize);
+
+		for (i = 0; i < ncontig; i++, ptep++, addr += pgsize)
+			__ptep_set_access_flags(vma, addr, ptep, entry, 0);
+
+		if (dirty)
+			arch_contpte_flush_tlb_range(vma, start_addr, addr, pgsize);
+	} else {
+		__contpte_try_unfold(vma->vm_mm, addr, ptep, orig_pte);
+		__ptep_set_access_flags(vma, addr, ptep, entry, dirty);
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(contpte_ptep_set_access_flags);
+
+__always_inline int ptep_set_access_flags(struct vm_area_struct *vma,
+					  unsigned long addr, pte_t *ptep,
+					  pte_t entry, int dirty)
+{
+	pte_t orig_pte = __ptep_get(ptep);
+
+	entry = pte_mknoncont(entry);
+
+	if (likely(!pte_valid_cont(orig_pte)))
+		return __ptep_set_access_flags(vma, addr, ptep, entry, dirty);
+
+	return contpte_ptep_set_access_flags(vma, addr, ptep, entry, dirty);
+}
 #endif /* CONFIG_THP_CONTPTE */
-- 
2.39.2


