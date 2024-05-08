Return-Path: <kvm+bounces-17054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 249228C04EF
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 21:26:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11634B27C69
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 19:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9897A130A6F;
	Wed,  8 May 2024 19:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="BDz8rVKH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2761272B2
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 19:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715196345; cv=none; b=QVrtD1DqZefkebT65QNkPAAsuZgQVDXgws7SALHsiULYoJGIlkm15YPmfgrT1X6d5F8FRz9n1Q9mdN5PcE7fDK/k/aKJ9rLImq5vpE4gLGKCr+FZ6PPkf3fSKNik0JGpEkq3Zjf8tN4PedzpdbKOG5Lz0qpakbWPr1X8BV5qAvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715196345; c=relaxed/simple;
	bh=PQE6gIAzIEyjZtZOWR0stsukrYzPYSrIuauq4EQ2VFQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GdsFo1bK4luPulxwes/TRaQtqdfHolZSNZSaz/+3LQdRQbjKa0VMYmctRI3NV84mIKE6C+Y65SyLdI7JZYqhDvOBtdubHAOJNmXfu4sqanvpMNzlmK8DY89cOhi9QSkWPaNOWpcjltcewVcgbEDhQgbd/Sfw9WxMDhN6VfVN7sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=BDz8rVKH; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-34dc129accaso43520f8f.0
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 12:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1715196343; x=1715801143; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nb289X82Pwy2psbtYSkuOYlUdcLMn+kmFJiTkQU5Z+c=;
        b=BDz8rVKHvv2T6cuL9LzQj1msbZjcTb3MNkw5SwsN7Hcw0+JvthaSzouNtn8Ns9St3v
         Fy6GS+r4aVoilkxByBvAKvgesKEf1NSNaiO8XgBCX/cKNHRMEMRVKAp29YZGIJ2vi3m6
         VRg5IC6FTse8M0QkDhXZBrCYZU4RqT5L5H7knhB2qWpde7GAgHLGHdNysPMJUTMMBCNY
         1PWmqzM4q2S7R1+VU/InT/klu88wt7eDIsIx7ekMErUjMiaj2SsKklo0w7e66CydSKAp
         Mm09pBcog64MsXDkIn98odxXhnHGjFW0GFE7s2hf1Z1hKKi/ge/rZncRBGoVc0ypTy+k
         Cm2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715196343; x=1715801143;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nb289X82Pwy2psbtYSkuOYlUdcLMn+kmFJiTkQU5Z+c=;
        b=N6KElPafXTBDqMFUPkdtLOYh05jpFzlAou8ogTpyj2mUW/l69K09aom76WIwVyvxOP
         ag9mYartHxmvSxQgEq9vUW4E6DvQ6j5Z1AiX6Wcx/+aKMD4LnD0cVM7pfKQGLCLVKAAQ
         kC1arcLVcIf01cRH3j3tsF1Mo5hUso63oc5PtRX7nZwvrXYHYRO1nvhif7H2/xi2Tg39
         PaH+FDv2j/d7ycwI9id2g7Uw+ulNjmhXyx+0NjLKQmWhrvPeiq+zA8r3itafJ6/GQ5Un
         i4WCF4WiNzSXCtJplXQiPi8TKcmkFwQtHTt3tuCZoBjYvE6o1tedbxzRZswDK1+SPPb/
         JbBg==
X-Forwarded-Encrypted: i=1; AJvYcCVB+VGWd1xLpttdAJYg2WZTxvlqDbAo3TzEbG9I60z068mFYJJ0o2mdGikI0PY/q+ZJG3C4nHIqUMvo9/T4ZaysKNeA
X-Gm-Message-State: AOJu0YyP3SDdNEvIMxfX6ejgTnieslNA2+iCbOroubSSooXkWSeYXGSN
	jkgdxLmix0uQYfZGj+b2fgkUz7Xc3izlEEfZF3cd4XjCIje7YrTbh1/q5TAhKXeRMwJ379rDXvb
	q
X-Google-Smtp-Source: AGHT+IFUGL9dDH2gwgI9tPWACeaOFPW71lxlPF9m81I7+sLroC1dBTrL+wbzR1KIUMB3+0Tz7vFgZA==
X-Received: by 2002:adf:a492:0:b0:343:a368:f792 with SMTP id ffacd0b85a97d-34fca621315mr2849241f8f.52.1715196342717;
        Wed, 08 May 2024 12:25:42 -0700 (PDT)
Received: from alex-rivos.ba.rivosinc.com (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id b12-20020a5d4d8c000000b0034e65b8b43fsm14038517wru.8.2024.05.08.12.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 12:25:42 -0700 (PDT)
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
Subject: [PATCH 06/12] mm, riscv, arm64: Use common pte_clear() function
Date: Wed,  8 May 2024 21:19:25 +0200
Message-Id: <20240508191931.46060-7-alexghiti@rivosinc.com>
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

Make riscv use the contpte aware pte_clear() function from arm64.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
---
 arch/arm64/include/asm/pgtable.h | 9 +++------
 arch/riscv/include/asm/pgtable.h | 4 +++-
 arch/riscv/mm/init.c             | 2 +-
 mm/contpte.c                     | 6 ++++++
 4 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index bb6210fb72c8..74e582f2884f 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1439,12 +1439,9 @@ extern void set_ptes(struct mm_struct *mm, unsigned long addr,
 		     pte_t *ptep, pte_t pte, unsigned int nr);
 #define set_ptes set_ptes
 
-static inline void pte_clear(struct mm_struct *mm,
-				unsigned long addr, pte_t *ptep)
-{
-	contpte_try_unfold(mm, addr, ptep, __ptep_get(ptep));
-	__pte_clear(mm, addr, ptep);
-}
+extern void pte_clear(struct mm_struct *mm,
+		      unsigned long addr, pte_t *ptep);
+#define pte_clear pte_clear
 
 #define clear_full_ptes clear_full_ptes
 static inline void clear_full_ptes(struct mm_struct *mm, unsigned long addr,
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 4f8f673787e7..41534f4b8a6d 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -792,18 +792,20 @@ extern void set_ptes(struct mm_struct *mm, unsigned long addr,
 #define set_ptes set_ptes
 extern void set_pte(pte_t *ptep, pte_t pte);
 #define set_pte set_pte
+extern void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+#define pte_clear pte_clear
 
 #else /* CONFIG_THP_CONTPTE */
 
 #define ptep_get		__ptep_get
 #define set_ptes		__set_ptes
 #define set_pte			__set_pte
+#define pte_clear		__pte_clear
 
 #endif /* CONFIG_THP_CONTPTE */
 
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 #define ptep_get_and_clear	__ptep_get_and_clear
-#define pte_clear		__pte_clear
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 #define ptep_set_access_flags	__ptep_set_access_flags
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index bb5c6578204c..c82f17b3060b 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -327,7 +327,7 @@ void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot)
 	if (pgprot_val(prot))
 		__set_pte(ptep, pfn_pte(phys >> PAGE_SHIFT, prot));
 	else
-		pte_clear(&init_mm, addr, ptep);
+		__pte_clear(&init_mm, addr, ptep);
 	local_flush_tlb_page(addr);
 }
 
diff --git a/mm/contpte.c b/mm/contpte.c
index 543ae5b5a863..c9eff6426ca0 100644
--- a/mm/contpte.c
+++ b/mm/contpte.c
@@ -45,6 +45,7 @@
  *   - set_ptes()
  *   - ptep_get_lockless()
  *   - set_pte()
+ *   - pte_clear()
  */
 
 pte_t huge_ptep_get(pte_t *ptep)
@@ -676,4 +677,9 @@ void set_pte(pte_t *ptep, pte_t pte)
 	__set_pte(ptep, pte_mknoncont(pte));
 }
 
+void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+	contpte_try_unfold(mm, addr, ptep, __ptep_get(ptep));
+	__pte_clear(mm, addr, ptep);
+}
 #endif /* CONFIG_THP_CONTPTE */
-- 
2.39.2


