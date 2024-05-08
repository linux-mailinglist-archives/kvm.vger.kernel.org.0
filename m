Return-Path: <kvm+bounces-17052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B799B8C04E1
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 21:23:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2AB23B2706C
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 19:23:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BAE3130A5D;
	Wed,  8 May 2024 19:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="i8tVVjgb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE4E1E532
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 19:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715196223; cv=none; b=jVyas/BT2L0+5p6QYhFJS19+kgFSSzzA+6PJr9kjr8pIssybyDww98uyzO/RVs3TaptQJWKKXPWklKfr18RWkFJBpwboLT555JNiscqbVstje32tKMkTmxwdlMXFPOsCVDc3spKvjqddrapBYchiaPndaWfk9pJQEEDzN7vPHQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715196223; c=relaxed/simple;
	bh=wcKEBEj6dA1hAzvJNMwh9ijgprqdrbza0ZtmU7EQbks=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h0sju/0kvDJxwdU8+WJ0+HyNpPkTUc7Mta0jhRa8KS8Tcj+U641OJB/JidpOCordAa6NPEMs+Kpved/ZHxTUCP5spO3YFd7jlHaUtXVK0YsDfINQB0o6xoJsFoh5S60NBXukFGKwaP+giVMhQQuklR33TAV20BBPgZMAxylD2eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=i8tVVjgb; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-41dc9c83e57so7066605e9.0
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 12:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1715196220; x=1715801020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=99tlcIPBJBGOnw31Oe30kKMBjt8TwvO6BCavKhZeDaw=;
        b=i8tVVjgbb4BHCJhh2V9BNiljur2N2+rOZPCL2I+8/IRPZ2LXD8F7xCJOpYaVjxnh9J
         uF1ouooaYmOUzy6hPz0C0r6HOZWCdIXeW1Bp8uOK3TMVb0jV0PsGHXN27GKmr0Ud9vth
         TLlVGxuk5gGFB26oRneBKgz+QSI/jxNbfRvOvICil6LnW48F7HgQgdS3d94McXxD39cb
         VUOjdxmi8eC5b1ArnT6ogXEKnghhX2x59ItyUPSwggN3hBcTryGXqU6TjRm6yH1TlFfY
         bfm1zJV8Y31fpdKyGoh4pHJuCAIH/2Pbp6iKz/tnG+baVUhHfXJ7kY99u1uZSP99rZQl
         Slmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715196220; x=1715801020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=99tlcIPBJBGOnw31Oe30kKMBjt8TwvO6BCavKhZeDaw=;
        b=Bt3goDkrPpbxNUu8V4hMZWi2iwSYkZqFnw51cDqEK9VA1FWiW6buFRBeidTsgI3lcM
         AMCE5Gz2nw54d3l868+pxICIUVBAWK+0GWBaR1HlGucGmsRIEMnSV4kBskEE16Sf3rWu
         e2jJpgsSZb0bxY0zmtFADWzTMVht2PPrAP9+unLZOEmRZyC0Zh9FJW9UiD3qQtj3gWIv
         0g98+a5IqWazdr9M6HSZKrJIY7tZ2u0yA/sl0XoktXNJlPXB3Of1LEmG84yfM0FRX/A8
         g3jBR7q8kJ5eVg2TY3Cn8jVIHcO8K06T3qehUiUuMv9msuNGBP6u8P/6o35s+0K2Ea3o
         QyuA==
X-Forwarded-Encrypted: i=1; AJvYcCXjPTyL7R2et+fJhmmrLs2sr4dHyj0Nz9q0s7JEynH5YsFIiVXZi9GwouCUBoZXNF1l7serv0tP2r0x8UofMe5ZG1KR
X-Gm-Message-State: AOJu0YwvAz0mxYqxZ+REEd+Um+7qmzVvFqPwxvwHgGhcqE6dkhahEvIr
	szWwpRN3L7iecR0Wy6LchppHY2X0INj9v3iFJsMKB5c0U69dHUGP6S2LvNeknO0=
X-Google-Smtp-Source: AGHT+IFuqFkdx1GrRMX9VnSrFsQl595h33hB5u187da/mHSb1Bien42UkrHvFd9ITnGVH1r4SnsHfw==
X-Received: by 2002:a05:600c:3ca9:b0:41b:ed36:e055 with SMTP id 5b1f17b1804b1-41fbcb4b4fbmr4761445e9.7.1715196220131;
        Wed, 08 May 2024 12:23:40 -0700 (PDT)
Received: from alex-rivos.ba.rivosinc.com (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-41f42e74625sm47255965e9.0.2024.05.08.12.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 12:23:39 -0700 (PDT)
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
Subject: [PATCH 04/12] mm, riscv, arm64: Use common ptep_get_lockless() function
Date: Wed,  8 May 2024 21:19:23 +0200
Message-Id: <20240508191931.46060-5-alexghiti@rivosinc.com>
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

Make riscv use the contpte aware ptep_get_lockless() function from arm64.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
---
 arch/arm64/include/asm/pgtable.h | 11 +----
 arch/arm64/mm/contpte.c          | 57 --------------------------
 arch/riscv/include/asm/pgtable.h |  2 +
 include/linux/contpte.h          |  1 +
 mm/contpte.c                     | 69 ++++++++++++++++++++++++++++++++
 5 files changed, 73 insertions(+), 67 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index e85b3a052a02..8a0603257436 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1384,7 +1384,6 @@ extern void ptep_modify_prot_commit(struct vm_area_struct *vma,
  * where it is possible and makes sense to do so. The PTE_CONT bit is considered
  * a private implementation detail of the public ptep API (see below).
  */
-extern pte_t contpte_ptep_get_lockless(pte_t *orig_ptep);
 extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, unsigned int nr, int full);
 extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
@@ -1430,16 +1429,8 @@ static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
 extern pte_t ptep_get(pte_t *ptep);
 #define ptep_get ptep_get
 
+extern pte_t ptep_get_lockless(pte_t *ptep);
 #define ptep_get_lockless ptep_get_lockless
-static inline pte_t ptep_get_lockless(pte_t *ptep)
-{
-	pte_t pte = __ptep_get(ptep);
-
-	if (likely(!pte_valid_cont(pte)))
-		return pte;
-
-	return contpte_ptep_get_lockless(ptep);
-}
 
 static inline void set_pte(pte_t *ptep, pte_t pte)
 {
diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index e225e458856e..5e9e40145085 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -28,63 +28,6 @@ static void contpte_try_unfold_partial(struct mm_struct *mm, unsigned long addr,
 	}
 }
 
-pte_t contpte_ptep_get_lockless(pte_t *orig_ptep)
-{
-	/*
-	 * The ptep_get_lockless() API requires us to read and return *orig_ptep
-	 * so that it is self-consistent, without the PTL held, so we may be
-	 * racing with other threads modifying the pte. Usually a READ_ONCE()
-	 * would suffice, but for the contpte case, we also need to gather the
-	 * access and dirty bits from across all ptes in the contiguous block,
-	 * and we can't read all of those neighbouring ptes atomically, so any
-	 * contiguous range may be unfolded/modified/refolded under our feet.
-	 * Therefore we ensure we read a _consistent_ contpte range by checking
-	 * that all ptes in the range are valid and have CONT_PTE set, that all
-	 * pfns are contiguous and that all pgprots are the same (ignoring
-	 * access/dirty). If we find a pte that is not consistent, then we must
-	 * be racing with an update so start again. If the target pte does not
-	 * have CONT_PTE set then that is considered consistent on its own
-	 * because it is not part of a contpte range.
-	 */
-
-	pgprot_t orig_prot;
-	unsigned long pfn;
-	pte_t orig_pte;
-	pgprot_t prot;
-	pte_t *ptep;
-	pte_t pte;
-	int i;
-
-retry:
-	orig_pte = __ptep_get(orig_ptep);
-
-	if (!pte_valid_cont(orig_pte))
-		return orig_pte;
-
-	orig_prot = pte_pgprot(pte_mkold(pte_mkclean(orig_pte)));
-	ptep = arch_contpte_align_down(orig_ptep);
-	pfn = pte_pfn(orig_pte) - (orig_ptep - ptep);
-
-	for (i = 0; i < CONT_PTES; i++, ptep++, pfn++) {
-		pte = __ptep_get(ptep);
-		prot = pte_pgprot(pte_mkold(pte_mkclean(pte)));
-
-		if (!pte_valid_cont(pte) ||
-		   pte_pfn(pte) != pfn ||
-		   pgprot_val(prot) != pgprot_val(orig_prot))
-			goto retry;
-
-		if (pte_dirty(pte))
-			orig_pte = pte_mkdirty(orig_pte);
-
-		if (pte_young(pte))
-			orig_pte = pte_mkyoung(orig_pte);
-	}
-
-	return orig_pte;
-}
-EXPORT_SYMBOL_GPL(contpte_ptep_get_lockless);
-
 void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, unsigned int nr, int full)
 {
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index ebfe6b16529e..62cad1b974f1 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -785,6 +785,8 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
 
 extern pte_t ptep_get(pte_t *ptep);
 #define ptep_get ptep_get
+extern pte_t ptep_get_lockless(pte_t *ptep);
+#define ptep_get_lockless ptep_get_lockless
 extern void set_ptes(struct mm_struct *mm, unsigned long addr,
 		     pte_t *ptep, pte_t pteval, unsigned int nr);
 #define set_ptes set_ptes
diff --git a/include/linux/contpte.h b/include/linux/contpte.h
index 54d10204e9af..01da4bfc3af6 100644
--- a/include/linux/contpte.h
+++ b/include/linux/contpte.h
@@ -8,6 +8,7 @@
  * a private implementation detail of the public ptep API (see below).
  */
 pte_t contpte_ptep_get(pte_t *ptep, pte_t orig_pte);
+pte_t contpte_ptep_get_lockless(pte_t *orig_ptep);
 void __contpte_try_fold(struct mm_struct *mm, unsigned long addr,
 			pte_t *ptep, pte_t pte);
 void contpte_try_fold(struct mm_struct *mm, unsigned long addr,
diff --git a/mm/contpte.c b/mm/contpte.c
index 566745d7842f..060e0bc1a2a3 100644
--- a/mm/contpte.c
+++ b/mm/contpte.c
@@ -42,6 +42,7 @@
  *   - huge_ptep_clear_flush()
  *   - ptep_get()
  *   - set_ptes()
+ *   - ptep_get_lockless()
  */
 
 pte_t huge_ptep_get(pte_t *ptep)
@@ -589,4 +590,72 @@ __always_inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 		contpte_set_ptes(mm, addr, ptep, pte, nr);
 	}
 }
+
+pte_t contpte_ptep_get_lockless(pte_t *orig_ptep)
+{
+	/*
+	 * The ptep_get_lockless() API requires us to read and return *orig_ptep
+	 * so that it is self-consistent, without the PTL held, so we may be
+	 * racing with other threads modifying the pte. Usually a READ_ONCE()
+	 * would suffice, but for the contpte case, we also need to gather the
+	 * access and dirty bits from across all ptes in the contiguous block,
+	 * and we can't read all of those neighbouring ptes atomically, so any
+	 * contiguous range may be unfolded/modified/refolded under our feet.
+	 * Therefore we ensure we read a _consistent_ contpte range by checking
+	 * that all ptes in the range are valid and have CONT_PTE set, that all
+	 * pfns are contiguous and that all pgprots are the same (ignoring
+	 * access/dirty). If we find a pte that is not consistent, then we must
+	 * be racing with an update so start again. If the target pte does not
+	 * have CONT_PTE set then that is considered consistent on its own
+	 * because it is not part of a contpte range.
+	 */
+
+	pgprot_t orig_prot;
+	unsigned long pfn;
+	pte_t orig_pte;
+	pgprot_t prot;
+	pte_t *ptep;
+	pte_t pte;
+	int i, ncontig;
+
+retry:
+	orig_pte = __ptep_get(orig_ptep);
+
+	if (!pte_valid_cont(orig_pte))
+		return orig_pte;
+
+	orig_prot = pte_pgprot(pte_mkold(pte_mkclean(orig_pte)));
+	ptep = arch_contpte_align_down(orig_ptep);
+	ncontig = arch_contpte_get_num_contig(NULL, 0, ptep, 0, NULL);
+	pfn = pte_pfn(orig_pte) - (orig_ptep - ptep);
+
+	for (i = 0; i < ncontig; i++, ptep++, pfn++) {
+		pte = __ptep_get(ptep);
+		prot = pte_pgprot(pte_mkold(pte_mkclean(pte)));
+
+		if (!pte_valid_cont(pte) ||
+				pte_pfn(pte) != pfn ||
+				pgprot_val(prot) != pgprot_val(orig_prot))
+			goto retry;
+
+		if (pte_dirty(pte))
+			orig_pte = pte_mkdirty(orig_pte);
+
+		if (pte_young(pte))
+			orig_pte = pte_mkyoung(orig_pte);
+	}
+
+	return orig_pte;
+}
+EXPORT_SYMBOL_GPL(contpte_ptep_get_lockless);
+
+__always_inline pte_t ptep_get_lockless(pte_t *ptep)
+{
+	pte_t pte = __ptep_get(ptep);
+
+	if (likely(!pte_valid_cont(pte)))
+		return pte;
+
+	return contpte_ptep_get_lockless(ptep);
+}
 #endif /* CONFIG_THP_CONTPTE */
-- 
2.39.2


