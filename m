Return-Path: <kvm+bounces-17049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 174358C04D2
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 21:20:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3ABD71C213F3
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 19:20:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 356A9130A73;
	Wed,  8 May 2024 19:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="I1lNjoCD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2771E507
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 19:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715196039; cv=none; b=GKXp1IOhblc2z4AvCTfhcQWHOfW74sYBcYKQjzDKSYgfdrRpyipY4wbPrCVx8DgzfzuK9Ynlf7B4YJXnTGYi+Hf7OJaj2woM/KJmjsU7vFsffc2JIKRHIXQ0uHhu5H1NDFaVF17JcJ8yu9WY6j6ZgZP8W6JUK6DX9zBrTLLE7Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715196039; c=relaxed/simple;
	bh=FoZejGjVu6xSGrwnf33XbNrHlqZcyAhpfO4l41aIQlo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DTWkJda2t3x8Wo6ysgC1N1C21lrljZePJu2w8hytQu9FI13T/droq3IyTvA7+Cli48yM80K15HzkvI+V0132JcUCk9ZtjfXgEc0swbeMFMWjkQdO8WY9FqcY8Vr8/cA/5DXXvZQ08nUUH5eo7rv2DM513Kn9PkRaJhhm6FndbZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=I1lNjoCD; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a599eedc8eeso24302766b.1
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 12:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1715196035; x=1715800835; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=datyv3e5LLeWOM64wvZ1mfI1WId3P2rVazcirFn2Oxk=;
        b=I1lNjoCD72gBUVObLHs76CJzTPKZc7k5iL1rpuIPV22aJSTdrpDAlX97gZwBGa4qFn
         Cf9GJaIDZrI/DVqjXkVNyIaEgtYHeqid8h7UG8Po2Z8bkM6L38LMYdMVamhrNAU+jjeI
         klvRLaY/sezIdh9yH9iu8WB/chokTJFxOmsxXSjWSfYXr7MKnY8qLZDhBSln2yZ51YWB
         OumeqVwTPnheEG5WiLndO5P9MYe5g+nO1s+4oVx71SXB3WXOrM21yKrtStkpP0rERFPf
         8wXpXlMOvxtZXxdFHPbelpaQEoug4gI9QArE/ve8fOR7Hge6TRdvIPYm6ckJsqq1xdrd
         U7Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715196035; x=1715800835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=datyv3e5LLeWOM64wvZ1mfI1WId3P2rVazcirFn2Oxk=;
        b=AOR/70a4Zplg1i9/xZWmGwVzOFTLjtrHSu9ttDUsZD2gwEJgXExAZBpEmZ6o7wJNhA
         VHRDBuHszXkVeXdc8C9fsgTM5AyiNdCJASCZH/whiB8UDlyixXZfFsdwH4qKV9npCBIh
         4FUlsB7hcmFMzfi3NWwpg0CaagOFZQDABy9xkh0hFdF0cnQ0iNKN/4NL0ltlEMx10D2T
         sVZMctJwsZV5zL/0ZvSztjpNNUFwvR/9HeBRWHLMvSZMvBykCtDNl2HcFirfZXiGh1rq
         5OsWiXzOT4Nk3CCpGhUYrqqbLZsBheMjfqk0R385+6TBWLh99pYHiFrYYQA/az53LgbZ
         eSBw==
X-Forwarded-Encrypted: i=1; AJvYcCUtw/pUjfAeYHeJQ8iIY+I9yD/u5X86RhCMQRqkb5N/JYbpkJJiGQkc/5JpV+F2uWmJWeLwdPu7Vk1bobFHNlbM8wfU
X-Gm-Message-State: AOJu0YxTegMLIGJHg8Pgm0C+fEk5iDlUhQmA6PMcFTHEmPconLFKdNpF
	vMs2GRLRbQ12yjU/wRTuskJfXuUFA2OLb2yAAA1aKkrz8M9b/xqf6HPLLwQrOs4=
X-Google-Smtp-Source: AGHT+IFPtUz+3X9HHx3rOZWYiSnLgxFfxDjotG1sGB7J9SeveUOh2JXAABXt+ni1vfq6RI0lDXdHfA==
X-Received: by 2002:a50:ab59:0:b0:570:3b8:a990 with SMTP id 4fb4d7f45d1cf-5731da6977emr2508293a12.39.1715196034646;
        Wed, 08 May 2024 12:20:34 -0700 (PDT)
Received: from alex-rivos.ba.rivosinc.com (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id g17-20020a056402091100b00571bbaa1c45sm7881992edz.1.2024.05.08.12.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 12:20:34 -0700 (PDT)
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
Subject: [PATCH 01/12] mm, arm64: Rename ARM64_CONTPTE to THP_CONTPTE
Date: Wed,  8 May 2024 21:19:20 +0200
Message-Id: <20240508191931.46060-2-alexghiti@rivosinc.com>
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

The ARM64_CONTPTE config represents the capability to transparently use
contpte mappings for THP userspace mappings, which will be implemented
in the next commits for riscv, so make this config more generic and move
it to mm.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
---
 arch/arm64/Kconfig               | 9 ---------
 arch/arm64/include/asm/pgtable.h | 6 +++---
 arch/arm64/mm/Makefile           | 2 +-
 mm/Kconfig                       | 9 +++++++++
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ac2f6d906cc3..9d823015b4e5 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2227,15 +2227,6 @@ config UNWIND_PATCH_PAC_INTO_SCS
 	select UNWIND_TABLES
 	select DYNAMIC_SCS
 
-config ARM64_CONTPTE
-	bool "Contiguous PTE mappings for user memory" if EXPERT
-	depends on TRANSPARENT_HUGEPAGE
-	default y
-	help
-	  When enabled, user mappings are configured using the PTE contiguous
-	  bit, for any mappings that meet the size and alignment requirements.
-	  This reduces TLB pressure and improves performance.
-
 endmenu # "Kernel Features"
 
 menu "Boot options"
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 7c2938cb70b9..1758ce71fae9 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1369,7 +1369,7 @@ extern void ptep_modify_prot_commit(struct vm_area_struct *vma,
 				    unsigned long addr, pte_t *ptep,
 				    pte_t old_pte, pte_t new_pte);
 
-#ifdef CONFIG_ARM64_CONTPTE
+#ifdef CONFIG_THP_CONTPTE
 
 /*
  * The contpte APIs are used to transparently manage the contiguous bit in ptes
@@ -1622,7 +1622,7 @@ static inline int ptep_set_access_flags(struct vm_area_struct *vma,
 	return contpte_ptep_set_access_flags(vma, addr, ptep, entry, dirty);
 }
 
-#else /* CONFIG_ARM64_CONTPTE */
+#else /* CONFIG_THP_CONTPTE */
 
 #define ptep_get				__ptep_get
 #define set_pte					__set_pte
@@ -1642,7 +1642,7 @@ static inline int ptep_set_access_flags(struct vm_area_struct *vma,
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 #define ptep_set_access_flags			__ptep_set_access_flags
 
-#endif /* CONFIG_ARM64_CONTPTE */
+#endif /* CONFIG_THP_CONTPTE */
 
 int find_num_contig(struct mm_struct *mm, unsigned long addr,
 		    pte_t *ptep, size_t *pgsize);
diff --git a/arch/arm64/mm/Makefile b/arch/arm64/mm/Makefile
index 60454256945b..52a1b2082627 100644
--- a/arch/arm64/mm/Makefile
+++ b/arch/arm64/mm/Makefile
@@ -3,7 +3,7 @@ obj-y				:= dma-mapping.o extable.o fault.o init.o \
 				   cache.o copypage.o flush.o \
 				   ioremap.o mmap.o pgd.o mmu.o \
 				   context.o proc.o pageattr.o fixmap.o
-obj-$(CONFIG_ARM64_CONTPTE)	+= contpte.o
+obj-$(CONFIG_THP_CONTPTE)	+= contpte.o
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
 obj-$(CONFIG_PTDUMP_CORE)	+= ptdump.o
 obj-$(CONFIG_PTDUMP_DEBUGFS)	+= ptdump_debugfs.o
diff --git a/mm/Kconfig b/mm/Kconfig
index c325003d6552..fd4de221a1c6 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -984,6 +984,15 @@ config ARCH_HAS_CACHE_LINE_SIZE
 config ARCH_HAS_CONTPTE
 	bool
 
+config THP_CONTPTE
+	bool "Contiguous PTE mappings for user memory" if EXPERT
+	depends on ARCH_HAS_CONTPTE && TRANSPARENT_HUGEPAGE
+	default y
+	help
+	  When enabled, user mappings are configured using the PTE contiguous
+	  bit, for any mappings that meet the size and alignment requirements.
+	  This reduces TLB pressure and improves performance.
+
 config ARCH_HAS_CURRENT_STACK_POINTER
 	bool
 	help
-- 
2.39.2


