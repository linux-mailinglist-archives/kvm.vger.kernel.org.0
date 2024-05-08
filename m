Return-Path: <kvm+bounces-17057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E44168C0504
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 21:29:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 214481C21978
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 19:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 209D9130A7B;
	Wed,  8 May 2024 19:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="nPDZtc91"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9341272B2
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 19:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715196530; cv=none; b=e9iubjwWvHudoRJE+KK2SVkE5ZF/atSHlXNs/gGq5ywMU+2l/LL2X29c3wQvOvsbWvFWBQ4/8ewcYWK4Uf4YePTJZxaQf0kc0jsB9JHlsNMJIkF6ok50R6Zgv036wricp+QC/VHqiok98wJl1IhnAwzWa849jsj3kPBe8jp0f8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715196530; c=relaxed/simple;
	bh=TYfogGEpvYLo9FvoSXQ4G7D2WqrEHWAkzIesY+MP6n0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IwO1Hv/u62FClE4RFlSIhErh9QHb7YHYVWmV8J9FU09LepttPnilGtvmHfaLrPfseqODTyD8r4pu49Gi3gGh5bdcYnNEwgTxTCL5DH5fqY/TbRdLE1H6DQYS57hQ1Qy/umCeOvnvgdbwUBknTY0mDYvzU8/NQQ9I1/SAQW9mk4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=nPDZtc91; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-41b5dd5af48so728365e9.0
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 12:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1715196526; x=1715801326; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SrlnOIvJhP/2Gfg4T9gM6ETbApI/dif7rW/ZR+x6Q9w=;
        b=nPDZtc91k03d1sIRtL/4MPKjPHaCMAvuOLonKNlnrn+UMPirxfqY4pEvBizGvUyyoZ
         5cSg244hh97o998KX/sCPfQCLyGqdOF5x/laxYxkrtRd0xpCdZCIXJnNwDqtCLW6Vg/F
         T3wCBhXAQIlgu2tObQYLIEm3LFfPks/noVKmhPHzefKYxJjZDQt8ofiJqcDG/vqvKuQL
         1EUglA0h11ovonTg29aYfHT4lhT1Zggy28J50o7gjwsTgXqqIs0bldd65My02u/82+tc
         ET6QSg+EKMUNYV0ymCfeLKDeu/6Ck0VfIwXMRm23G73V4OCwT6Ae3JleVoXTMZjhtZFc
         wBhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715196526; x=1715801326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SrlnOIvJhP/2Gfg4T9gM6ETbApI/dif7rW/ZR+x6Q9w=;
        b=sBwUqh5tMmAjiuyWxPfihLFzdAjT6nm/AzQecUYXCHxF3FMmj1l7UEcA8l5jBi0MgH
         k6fSyCPNEVLJK4J0FxXk0fBotKUd1Bg/Y6JxKAQ6q8ify4U82I7HbHEefU9PJMkkge3a
         0ywondIsH6zcloR+yx3aHaLBAz9DpnMoX7i8cpqHq1ZqwonpSbRBXmXwqbwnRcnmrv0e
         LC7jaYzEe9n/VylSjHoKniWJMSCM1eOj2sDWhsZv+EOUtTK6VpRlAoKeYeqnk0arYUz4
         CKFyfyk03EYy19EqRzMVcxVSexk2j/Qx8jKejEFrpZrYuWWQIPGKVAyF2uwZ9qn0aRlY
         ca5w==
X-Forwarded-Encrypted: i=1; AJvYcCXGx52aJN511oB1zwfyMwbOvqBeirvzmFmRd+DzX8Uzf0agwe4/NJcFzRbq9gmVMN5zJPHHKzIVCKQfb3MGIkNLfonL
X-Gm-Message-State: AOJu0Yx8fHYjgxmmtyyeeF/XHlPK5dSNfB4HMBiNWuDOIzoXuoTWTEDF
	mXTx7BegDDD945Rvcvluara0e2S0ZVOHyNUyOrk2kJqt7wO+bFRJy0cjGtR6/FE=
X-Google-Smtp-Source: AGHT+IEyIjL1IsEMqXGLkJGiy2tkR0X5tVHC2TKSU1+3Y1r/Xzm4QA5qwQ487USNifryKvOLnO9vbQ==
X-Received: by 2002:a5d:6350:0:b0:34c:65ba:5d43 with SMTP id ffacd0b85a97d-34fca621699mr2523239f8f.46.1715196526270;
        Wed, 08 May 2024 12:28:46 -0700 (PDT)
Received: from alex-rivos.ba.rivosinc.com (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id cx8-20020a056000092800b0034e01a80176sm16002694wrb.114.2024.05.08.12.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 12:28:45 -0700 (PDT)
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
Subject: [PATCH 09/12] mm, riscv, arm64: Use common ptep_clear_flush_young() function
Date: Wed,  8 May 2024 21:19:28 +0200
Message-Id: <20240508191931.46060-10-alexghiti@rivosinc.com>
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

Make riscv use the contpte aware ptep_clear_flush_young() function from
arm64.

Note that riscv used to not flush the tlb after clearing the accessed
bit, which it does now: this will be improved when we implement svinval
support.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
---
 arch/arm64/include/asm/pgtable.h | 22 ++++++++----------
 arch/arm64/mm/contpte.c          | 21 -----------------
 arch/riscv/include/asm/pgtable.h | 12 +++++++---
 include/linux/contpte.h          |  2 ++
 mm/contpte.c                     | 40 ++++++++++++++++++++++++++++++++
 5 files changed, 61 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 9a8702d1ad00..92c12fb85cb4 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1389,8 +1389,6 @@ extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
 extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
 				unsigned long addr, pte_t *ptep,
 				unsigned int nr, int full);
-extern int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep);
 extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, unsigned int nr);
 extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
@@ -1479,16 +1477,8 @@ extern int ptep_test_and_clear_young(struct vm_area_struct *vma,
 				unsigned long addr, pte_t *ptep);
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
-static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep)
-{
-	pte_t orig_pte = __ptep_get(ptep);
-
-	if (likely(!pte_valid_cont(orig_pte)))
-		return __ptep_clear_flush_young(vma, addr, ptep);
-
-	return contpte_ptep_clear_flush_young(vma, addr, ptep);
-}
+extern int ptep_clear_flush_young(struct vm_area_struct *vma,
+				  unsigned long addr, pte_t *ptep);
 
 #define wrprotect_ptes wrprotect_ptes
 static __always_inline void wrprotect_ptes(struct mm_struct *mm,
@@ -1616,6 +1606,14 @@ static inline void arch_contpte_flush_tlb_range(struct vm_area_struct *vma,
 	__flush_tlb_range(vma, start, end, stride, true, 3);
 }
 
+static inline void arch_contpte_flush_tlb_range_nosync(struct vm_area_struct *vma,
+						       unsigned long start,
+						       unsigned long end,
+						       unsigned long stride)
+{
+	__flush_tlb_range_nosync(vma, start, end, stride, true, 3);
+}
+
 static inline int arch_contpte_get_first_ncontig(size_t *pgsize)
 {
 	if (pgsize)
diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index 9bf471633ca4..16940511943c 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -45,27 +45,6 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
 }
 EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
 
-int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
-					unsigned long addr, pte_t *ptep)
-{
-	int young;
-
-	young = contpte_ptep_test_and_clear_young(vma, addr, ptep);
-
-	if (young) {
-		/*
-		 * See comment in __ptep_clear_flush_young(); same rationale for
-		 * eliding the trailing DSB applies here.
-		 */
-		addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
-		__flush_tlb_range_nosync(vma, addr, addr + CONT_PTE_SIZE,
-					 PAGE_SIZE, true, 3);
-	}
-
-	return young;
-}
-EXPORT_SYMBOL_GPL(contpte_ptep_clear_flush_young);
-
 void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
 					pte_t *ptep, unsigned int nr)
 {
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index d39cb24c6c4a..42c7884b8d2e 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -615,6 +615,8 @@ static inline void arch_contpte_flush_tlb_range(struct vm_area_struct *vma,
 	flush_tlb_mm_range(vma->vm_mm, start, end, stride);
 }
 
+#define arch_contpte_flush_tlb_range_nosync	arch_contpte_flush_tlb_range
+
 static inline int arch_contpte_get_first_ncontig(size_t *pgsize)
 {
 	if (pgsize)
@@ -758,9 +760,8 @@ static inline void __ptep_set_wrprotect(struct mm_struct *mm,
 	atomic_long_and(~(unsigned long)_PAGE_WRITE, (atomic_long_t *)ptep);
 }
 
-#define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
-static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
-					 unsigned long address, pte_t *ptep)
+static inline int __ptep_clear_flush_young(struct vm_area_struct *vma,
+					   unsigned long address, pte_t *ptep)
 {
 	/*
 	 * This comment is borrowed from x86, but applies equally to RISC-V:
@@ -799,6 +800,9 @@ extern pte_t ptep_get_and_clear(struct mm_struct *mm,
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 extern int ptep_test_and_clear_young(struct vm_area_struct *vma,
 				     unsigned long addr, pte_t *ptep);
+#define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
+extern int ptep_clear_flush_young(struct vm_area_struct *vma,
+				  unsigned long addr, pte_t *ptep);
 
 #else /* CONFIG_THP_CONTPTE */
 
@@ -810,6 +814,8 @@ extern int ptep_test_and_clear_young(struct vm_area_struct *vma,
 #define ptep_get_and_clear	__ptep_get_and_clear
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 #define ptep_test_and_clear_young	__ptep_test_and_clear_young
+#define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
+#define ptep_clear_flush_young	__ptep_clear_flush_young
 
 #endif /* CONFIG_THP_CONTPTE */
 
diff --git a/include/linux/contpte.h b/include/linux/contpte.h
index 38092adbe0d4..76a49ac8b6f5 100644
--- a/include/linux/contpte.h
+++ b/include/linux/contpte.h
@@ -21,5 +21,7 @@ void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
 		      pte_t *ptep, pte_t pte, unsigned int nr);
 int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
 				      unsigned long addr, pte_t *ptep);
+int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
+				   unsigned long addr, pte_t *ptep);
 
 #endif /* _LINUX_CONTPTE_H */
diff --git a/mm/contpte.c b/mm/contpte.c
index 220e9d81f401..600277b1196c 100644
--- a/mm/contpte.c
+++ b/mm/contpte.c
@@ -48,6 +48,7 @@
  *   - pte_clear()
  *   - ptep_get_and_clear()
  *   - ptep_test_and_clear_young()
+ *   - ptep_clear_flush_young()
  */
 
 pte_t huge_ptep_get(pte_t *ptep)
@@ -729,4 +730,43 @@ __always_inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 
 	return contpte_ptep_test_and_clear_young(vma, addr, ptep);
 }
+
+int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
+				   unsigned long addr, pte_t *ptep)
+{
+	int young;
+
+	young = contpte_ptep_test_and_clear_young(vma, addr, ptep);
+
+	if (young) {
+		/*
+		 * See comment in __ptep_clear_flush_young(); same rationale for
+		 * eliding the trailing DSB applies here.
+		 */
+		size_t pgsize;
+		int ncontig;
+
+		ncontig = arch_contpte_get_num_contig(vma->vm_mm, addr, ptep,
+						      0, &pgsize);
+
+		addr = ALIGN_DOWN(addr, ncontig * pgsize);
+		arch_contpte_flush_tlb_range_nosync(vma, addr,
+						    addr + ncontig * pgsize,
+						    pgsize);
+	}
+
+	return young;
+}
+EXPORT_SYMBOL_GPL(contpte_ptep_clear_flush_young);
+
+__always_inline int ptep_clear_flush_young(struct vm_area_struct *vma,
+					   unsigned long addr, pte_t *ptep)
+{
+	pte_t orig_pte = __ptep_get(ptep);
+
+	if (likely(!pte_valid_cont(orig_pte)))
+		return __ptep_clear_flush_young(vma, addr, ptep);
+
+	return contpte_ptep_clear_flush_young(vma, addr, ptep);
+}
 #endif /* CONFIG_THP_CONTPTE */
-- 
2.39.2


