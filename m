Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E716548252
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 10:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240320AbiFMIyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 04:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240546AbiFMIxQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 04:53:16 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEB65FF6
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 01:53:13 -0700 (PDT)
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 2A7B03F223
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 08:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1655110390;
        bh=fhdPlI5rmS+APeBJNR4lTD/VgT4RAcbvyvwt5HUOiAU=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=QZppZfZQC9zfTlLFsdKR0nR4BzrR1pk4aSQuV2X8ILjYJiwsNMnkwaDhobT0lGKon
         /JuuXVmbnqb4gfruYvhWMWdXPHpPutDflTJDJ3LukehvWxI7FXJJHm/bJhx+8vdrC9
         8MPZT9Ow+zwo6NLN9hj2Vbi4nr/zxdI0+1ISB+xRydnb5wTXzZ+Uvy2MipdsyIsZNm
         DOtaPZgqJEH2u/VP1siOD3Q6BQV47Usdi13KiwHXklpNUn4c5osl+psRp1GNmAbWGZ
         qO5GRnKpoL45sUh29OexeffsFOqvboi7EP2HBwT035CRzzrJTfD/A+4XMj+KY8avLD
         V7BOfQzjC0Zcw==
Received: by mail-wr1-f72.google.com with SMTP id p8-20020a5d4588000000b0021033f1f79aso609407wrq.5
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 01:53:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fhdPlI5rmS+APeBJNR4lTD/VgT4RAcbvyvwt5HUOiAU=;
        b=P9EPsvPHPq1r/slb4wfUQpvMyEll/zil+eBnbuo1Uqv/8UpGmW2U7CE1xyjDt+ot2q
         r5DYByRiJIVmKn9Yx+7RwdPOLDhEgMdC/sAq348/2NlDvql/X20DVHT66YbFN12oRimt
         esqJbr0g4uvk0yTn0C86+I6Hx33Shq5wOXnhJehXmQkhNoc71UkXXATzXgprlglL9enB
         7e14Q7kUN3Hxjgsyhl1DoK1CJge4l9MdYp4IFx0mz/TA8jNQ0Vsq5FUsv6qr+UoDETlV
         8m6oME35gFXGF7nJ+9x9wrAf0VdfCpUAsLIHU76VwRqEB/cBYjiGFrvpvwajSNGvend0
         ufng==
X-Gm-Message-State: AOAM531+VzBp7h3Au8tUi7TB5KCSy5CqDhOGDeTyH5M/iTkZ1D0ffYJS
        WOjxJX3+YEbs46brPGfmT0RBLfTjdw40PpTpi/fM7K0wEIBV5l/2KlRdiUI7OrE69hH3Pe3krGk
        MI/WualONzGwRKDM64H2q4b6dLDIvdg==
X-Received: by 2002:a05:600c:3d98:b0:39c:5cad:ab58 with SMTP id bi24-20020a05600c3d9800b0039c5cadab58mr13009693wmb.100.1655110389699;
        Mon, 13 Jun 2022 01:53:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4t5KV7LAtTb4dE0wLpkTfSRrdGgNSzReoTM8ZcUo1rFG7gBn3Z6s34yNb3QgrtEjmt4i1Jg==
X-Received: by 2002:a05:600c:3d98:b0:39c:5cad:ab58 with SMTP id bi24-20020a05600c3d9800b0039c5cadab58mr13009667wmb.100.1655110389455;
        Mon, 13 Jun 2022 01:53:09 -0700 (PDT)
Received: from alex.home (lfbn-gre-1-146-29.w90-112.abo.wanadoo.fr. [90.112.113.29])
        by smtp.gmail.com with ESMTPSA id z16-20020adfec90000000b0020cff559b1dsm7957794wrn.47.2022.06.13.01.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 01:53:09 -0700 (PDT)
From:   Alexandre Ghiti <alexandre.ghiti@canonical.com>
To:     =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Guo Ren <guoren@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc:     Alexandre Ghiti <alexandre.ghiti@canonical.com>
Subject: [PATCH -fixes v2] riscv: Fix missing PAGE_PFN_MASK
Date:   Mon, 13 Jun 2022 10:53:07 +0200
Message-Id: <20220613085307.260256-1-alexandre.ghiti@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are a bunch of functions that use the PFN from a page table entry
that end up with the svpbmt upper-bits because they are missing the newly
introduced PAGE_PFN_MASK which leads to wrong addresses conversions and
then crash: fix this by adding this mask.

Fixes: 100631b48ded ("riscv: Fix accessing pfn bits in PTEs for non-32bit variants")
Signed-off-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>
---
 arch/riscv/include/asm/pgtable-64.h | 12 ++++++------
 arch/riscv/include/asm/pgtable.h    |  6 +++---
 arch/riscv/kvm/mmu.c                |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable-64.h b/arch/riscv/include/asm/pgtable-64.h
index 5c2aba5efbd0..dc42375c2357 100644
--- a/arch/riscv/include/asm/pgtable-64.h
+++ b/arch/riscv/include/asm/pgtable-64.h
@@ -175,7 +175,7 @@ static inline pud_t pfn_pud(unsigned long pfn, pgprot_t prot)
 
 static inline unsigned long _pud_pfn(pud_t pud)
 {
-	return pud_val(pud) >> _PAGE_PFN_SHIFT;
+	return __page_val_to_pfn(pud_val(pud));
 }
 
 static inline pmd_t *pud_pgtable(pud_t pud)
@@ -278,13 +278,13 @@ static inline p4d_t pfn_p4d(unsigned long pfn, pgprot_t prot)
 
 static inline unsigned long _p4d_pfn(p4d_t p4d)
 {
-	return p4d_val(p4d) >> _PAGE_PFN_SHIFT;
+	return __page_val_to_pfn(p4d_val(p4d));
 }
 
 static inline pud_t *p4d_pgtable(p4d_t p4d)
 {
 	if (pgtable_l4_enabled)
-		return (pud_t *)pfn_to_virt(p4d_val(p4d) >> _PAGE_PFN_SHIFT);
+		return (pud_t *)pfn_to_virt(__page_val_to_pfn(p4d_val(p4d)));
 
 	return (pud_t *)pud_pgtable((pud_t) { p4d_val(p4d) });
 }
@@ -292,7 +292,7 @@ static inline pud_t *p4d_pgtable(p4d_t p4d)
 
 static inline struct page *p4d_page(p4d_t p4d)
 {
-	return pfn_to_page(p4d_val(p4d) >> _PAGE_PFN_SHIFT);
+	return pfn_to_page(__page_val_to_pfn(p4d_val(p4d)));
 }
 
 #define pud_index(addr) (((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
@@ -347,7 +347,7 @@ static inline void pgd_clear(pgd_t *pgd)
 static inline p4d_t *pgd_pgtable(pgd_t pgd)
 {
 	if (pgtable_l5_enabled)
-		return (p4d_t *)pfn_to_virt(pgd_val(pgd) >> _PAGE_PFN_SHIFT);
+		return (p4d_t *)pfn_to_virt(__page_val_to_pfn(pgd_val(pgd)));
 
 	return (p4d_t *)p4d_pgtable((p4d_t) { pgd_val(pgd) });
 }
@@ -355,7 +355,7 @@ static inline p4d_t *pgd_pgtable(pgd_t pgd)
 
 static inline struct page *pgd_page(pgd_t pgd)
 {
-	return pfn_to_page(pgd_val(pgd) >> _PAGE_PFN_SHIFT);
+	return pfn_to_page(__page_val_to_pfn(pgd_val(pgd)));
 }
 #define pgd_page(pgd)	pgd_page(pgd)
 
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 1d1be9d9419c..5dbd6610729b 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -261,7 +261,7 @@ static inline pgd_t pfn_pgd(unsigned long pfn, pgprot_t prot)
 
 static inline unsigned long _pgd_pfn(pgd_t pgd)
 {
-	return pgd_val(pgd) >> _PAGE_PFN_SHIFT;
+	return __page_val_to_pfn(pgd_val(pgd));
 }
 
 static inline struct page *pmd_page(pmd_t pmd)
@@ -590,14 +590,14 @@ static inline pmd_t pmd_mkinvalid(pmd_t pmd)
 	return __pmd(pmd_val(pmd) & ~(_PAGE_PRESENT|_PAGE_PROT_NONE));
 }
 
-#define __pmd_to_phys(pmd)  (pmd_val(pmd) >> _PAGE_PFN_SHIFT << PAGE_SHIFT)
+#define __pmd_to_phys(pmd)  (__page_val_to_pfn(pmd_val(pmd)) << PAGE_SHIFT)
 
 static inline unsigned long pmd_pfn(pmd_t pmd)
 {
 	return ((__pmd_to_phys(pmd) & PMD_MASK) >> PAGE_SHIFT);
 }
 
-#define __pud_to_phys(pud)  (pud_val(pud) >> _PAGE_PFN_SHIFT << PAGE_SHIFT)
+#define __pud_to_phys(pud)  (__page_val_to_pfn(pud_val(pud)) << PAGE_SHIFT)
 
 static inline unsigned long pud_pfn(pud_t pud)
 {
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 1c00695ebee7..9826073fbc67 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -54,7 +54,7 @@ static inline unsigned long gstage_pte_index(gpa_t addr, u32 level)
 
 static inline unsigned long gstage_pte_page_vaddr(pte_t pte)
 {
-	return (unsigned long)pfn_to_virt(pte_val(pte) >> _PAGE_PFN_SHIFT);
+	return (unsigned long)pfn_to_virt(__page_val_to_pfn(pte_val(pte)));
 }
 
 static int gstage_page_size_to_level(unsigned long page_size, u32 *out_level)
-- 
2.34.1

