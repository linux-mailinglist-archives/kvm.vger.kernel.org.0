Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61F867776A
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 10:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbjAWJ3h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 04:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbjAWJ3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 04:29:35 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C063F1F91F
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 01:29:31 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id e19-20020a05600c439300b003db1cac0c1fso8618957wmn.5
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 01:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6i4/DPc3clho1bRJuBJWVhY/2WISVnxE9xJwLHy63OI=;
        b=hO5aZpDY4ENl9IWdTW3woDPtDZ4dsUEyVjT464rX2BSA25tYl0Oi1VJ4FSeOmHgjxS
         HUo0c5O7+8+DoPmnWxRxAwrc3eO4d/agpWf+Iy2RJh5hoA0IUzV7q1SnI4SBpOyYlJ5z
         qkCQE7AYvU5Yn8u6N133gPHBTeJl8aq4e56R1ntNvn/vY8mSmLO7g3rUG/nrSrShV0GU
         2Tis7CmieX9Da1GhuUzPk3Vl9qgBVK9yznTibbAPKNCFQaj8/e53NUYniODGAWsaY98w
         wqIeAMBmvcU8VKSrtDQYxJ4DT3RkNJsROatznlCCKtxbghJtehjz13fFUrF3gkuLVLS0
         NPiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6i4/DPc3clho1bRJuBJWVhY/2WISVnxE9xJwLHy63OI=;
        b=OP3O/PuXCmcr++uTe2jDZoc3cURsLvZ3OD1JSCDSRL7EjMOWv4j3vwyBJdVZRGcvHO
         qXgveBtqqWcGFnqfrNvbeUvem32AOzAGa9cfi0z7pxiU9MoFyHeW6pj+4syoaZfHn/jk
         lCKJQ9ea7mRwEdAvZHf1GijMiKNtv5WjeB6Bpxsr6JWKLb7wGn0uaE3hZRkmaBlHlFiC
         /x9rSVgsczcHAfrUzUG5fNZVKrExv8JglFsypHkQn+SDTJA03eiga71Njt6zPbo0Jesc
         mQUzcmWLw16aAMh6+6dH8/lUtKZzORfCusdiXIP6/CWYh7oMFKNZ7XITSv1uiDD4mAxb
         7B/Q==
X-Gm-Message-State: AFqh2krEe9tE5dDjmQeKbnlVZzcboU5/S3bgXsv+PqxBAE5tseeO45Bq
        nYhrTPKrEeTSGkGlDsaz6Kdbvw==
X-Google-Smtp-Source: AMrXdXtqCE84xtsh9SqffI9Nun8+wVvG/L434n5lc/pRyKhwZ048Rt50MZxTPhaP7Rllg8LqItz9Ug==
X-Received: by 2002:a05:600c:1695:b0:3d3:4ae6:a71b with SMTP id k21-20020a05600c169500b003d34ae6a71bmr22314548wmn.2.1674466170281;
        Mon, 23 Jan 2023 01:29:30 -0800 (PST)
Received: from alex-rivos.ba.rivosinc.com (lfbn-lyo-1-450-160.w2-7.abo.wanadoo.fr. [2.7.42.160])
        by smtp.gmail.com with ESMTPSA id n42-20020a05600c3baa00b003d96efd09b7sm11619340wms.19.2023.01.23.01.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 01:29:29 -0800 (PST)
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
To:     Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH] KVM: RISC-V: Fix wrong usage of PGDIR_SIZE to check page sizes
Date:   Mon, 23 Jan 2023 10:29:28 +0100
Message-Id: <20230123092928.808014-1-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment, riscv only supports PMD and PUD hugepages. For sv39,
PGDIR_SIZE == PUD_SIZE but not for sv48 and sv57. So fix this by changing
PGDIR_SIZE into PUD_SIZE.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
---
 arch/riscv/kvm/mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 34b57e0be2ef..dbc4ca060174 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -585,7 +585,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (!kvm->arch.pgd)
 		return false;
 
-	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
+	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
 
 	if (!gstage_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
 				   &ptep, &ptep_level))
@@ -603,7 +603,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (!kvm->arch.pgd)
 		return false;
 
-	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
+	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
 
 	if (!gstage_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
 				   &ptep, &ptep_level))
@@ -645,12 +645,12 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 	if (logging || (vma->vm_flags & VM_PFNMAP))
 		vma_pagesize = PAGE_SIZE;
 
-	if (vma_pagesize == PMD_SIZE || vma_pagesize == PGDIR_SIZE)
+	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
 		gfn = (gpa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
 
 	mmap_read_unlock(current->mm);
 
-	if (vma_pagesize != PGDIR_SIZE &&
+	if (vma_pagesize != PUD_SIZE &&
 	    vma_pagesize != PMD_SIZE &&
 	    vma_pagesize != PAGE_SIZE) {
 		kvm_err("Invalid VMA page size 0x%lx\n", vma_pagesize);
-- 
2.37.2

