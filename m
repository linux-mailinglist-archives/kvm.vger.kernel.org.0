Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7695378D6
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 12:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbiE3JrL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 05:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234893AbiE3JrJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 05:47:09 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2FA38B4
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 02:47:07 -0700 (PDT)
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 10DB03FBEF
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 09:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1653904025;
        bh=0UZymv9RVAChspHI58gTmQkqQr5ViPWxsQqyFUaGwGI=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=MlIRlTGna75DELC952I/iXncR8JeqwoAu4qWNXAQJ6YDkbXA0Mhvq6ltdPJMyJVZ+
         3nSTe444srfuSvqQS6uMpe5GZNsAofXaE67pkdTOeZQyRq/NbmXHRwwXPRcHEqsvn8
         vh8IPUHNLo+1qjKmPn5RAIv2s3NQ57q0UkiZIsW+/JqZOhYiOMFYhLyuY2jWC3sUPl
         W39oSw41A0ZkC06YYvM90LcZUCD0XzUeWgmPhUu7GvfnekCO7fScHcAidA2+bOgcK8
         fNblBrm8nTwlw4qbt5aeiL902gCYhR819eIoRNrjeNlLRrU9kMIXQzMxQm8Yoqu+P5
         4K+WTZzWCDiYQ==
Received: by mail-wr1-f70.google.com with SMTP id t8-20020adff048000000b002102a5877d5so533937wro.21
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 02:47:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0UZymv9RVAChspHI58gTmQkqQr5ViPWxsQqyFUaGwGI=;
        b=4bePjBIgWfUc7v0LDa+P8glzwkkBYiA/WSfpqEEss6YfoAxqEQSugqpqynZaE/UwO5
         i1HCzlrwM/XN07tRq75A7c02CV6hpszAnmZ45W1sbYQfz92yklQAdhGV3anpfUSY8HTH
         xXmm5xLcPejSly9VYWOfoMZGgiF7c1Rc1id+PaEfk499jjFe/y3G8QTiSkiohnlB1//p
         iW8irVaDfm8/38pCCxn/kMSy9iyeljV+wDA4Ad1s2CzIbeI/5tsEHAebD0/Q3nlrhP2A
         JVftkULz9V2urGgDD3omXy717bGUWsWOpYYtFms9GU+zkUeTI3C5bSpXOnvhi+XT9+xe
         o9ow==
X-Gm-Message-State: AOAM5332PfwqMnw9RjPFiT7I5DbMEj6do4eKYUGfYDNtwJCN+Jt+Iu6p
        b9E1q2DRK0YbZpNltS1dAVaOdKRTSeqvUi4ly1WtqvklSBBKbW4XwRYXm01FG+HPkW2VeTP+9dU
        2REo3O6KLdHjnyK15e+gfGSsjbk/KOw==
X-Received: by 2002:a05:600c:501f:b0:397:74e2:caa1 with SMTP id n31-20020a05600c501f00b0039774e2caa1mr18326898wmr.89.1653904023960;
        Mon, 30 May 2022 02:47:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxcIRFrZmFoHMctcwJfjIoXZM+fuLzFmiVCBZ3hBYIMDRUovPi+iGVmBjDvXX5Wh2a1poEgFA==
X-Received: by 2002:a05:600c:501f:b0:397:74e2:caa1 with SMTP id n31-20020a05600c501f00b0039774e2caa1mr18326883wmr.89.1653904023811;
        Mon, 30 May 2022 02:47:03 -0700 (PDT)
Received: from alex.home (lfbn-gre-1-146-29.w90-112.abo.wanadoo.fr. [90.112.113.29])
        by smtp.gmail.com with ESMTPSA id f12-20020a05600c154c00b003942a244f30sm13897640wmg.9.2022.05.30.02.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 02:47:03 -0700 (PDT)
From:   Alexandre Ghiti <alexandre.ghiti@canonical.com>
To:     =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc:     Alexandre Ghiti <alexandre.ghiti@canonical.com>
Subject: [PATCH -for-next] riscv: Fix missing PAGE_PFN_MASK
Date:   Mon, 30 May 2022 11:47:01 +0200
Message-Id: <20220530094701.2891404-1-alexandre.ghiti@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/riscv/include/asm/pgtable-64.h | 4 ++--
 arch/riscv/include/asm/pgtable.h    | 4 ++--
 arch/riscv/kvm/mmu.c                | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable-64.h b/arch/riscv/include/asm/pgtable-64.h
index 6d59e4695200..0e57bf1e25e9 100644
--- a/arch/riscv/include/asm/pgtable-64.h
+++ b/arch/riscv/include/asm/pgtable-64.h
@@ -153,7 +153,7 @@ static inline pud_t pfn_pud(unsigned long pfn, pgprot_t prot)
 
 static inline unsigned long _pud_pfn(pud_t pud)
 {
-	return pud_val(pud) >> _PAGE_PFN_SHIFT;
+	return (pud_val(pud) & _PAGE_PFN_MASK) >> _PAGE_PFN_SHIFT;
 }
 
 static inline pmd_t *pud_pgtable(pud_t pud)
@@ -240,7 +240,7 @@ static inline void p4d_clear(p4d_t *p4d)
 static inline pud_t *p4d_pgtable(p4d_t p4d)
 {
 	if (pgtable_l4_enabled)
-		return (pud_t *)pfn_to_virt(p4d_val(p4d) >> _PAGE_PFN_SHIFT);
+		return (pud_t *)pfn_to_virt((p4d_val(p4d) & _PAGE_PFN_MASK) >> _PAGE_PFN_SHIFT);
 
 	return (pud_t *)pud_pgtable((pud_t) { p4d_val(p4d) });
 }
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index e2658a25f06d..43064025f4b0 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -255,7 +255,7 @@ static inline pgd_t pfn_pgd(unsigned long pfn, pgprot_t prot)
 
 static inline unsigned long _pgd_pfn(pgd_t pgd)
 {
-	return pgd_val(pgd) >> _PAGE_PFN_SHIFT;
+	return (pgd_val(pgd) & _PAGE_PFN_MASK) >> _PAGE_PFN_SHIFT;
 }
 
 static inline struct page *pmd_page(pmd_t pmd)
@@ -568,7 +568,7 @@ static inline pmd_t pmd_mkinvalid(pmd_t pmd)
 	return __pmd(pmd_val(pmd) & ~(_PAGE_PRESENT|_PAGE_PROT_NONE));
 }
 
-#define __pmd_to_phys(pmd)  (pmd_val(pmd) >> _PAGE_PFN_SHIFT << PAGE_SHIFT)
+#define __pmd_to_phys(pmd)  ((pmd_val(pmd) & _PAGE_PFN_MASK) >> _PAGE_PFN_SHIFT << PAGE_SHIFT)
 
 static inline unsigned long pmd_pfn(pmd_t pmd)
 {
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index f80a34fbf102..db03c5a29d4c 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -55,7 +55,7 @@ static inline unsigned long stage2_pte_index(gpa_t addr, u32 level)
 
 static inline unsigned long stage2_pte_page_vaddr(pte_t pte)
 {
-	return (unsigned long)pfn_to_virt(pte_val(pte) >> _PAGE_PFN_SHIFT);
+	return (unsigned long)pfn_to_virt((pte_val(pte) & _PAGE_PFN_MASK) >> _PAGE_PFN_SHIFT);
 }
 
 static int stage2_page_size_to_level(unsigned long page_size, u32 *out_level)
-- 
2.34.1

