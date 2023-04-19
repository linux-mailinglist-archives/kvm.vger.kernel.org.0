Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74E56E848E
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbjDSWSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjDSWSS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:18:18 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1895D49CB
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:17:58 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-63b7588005fso395553b3a.0
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942678; x=1684534678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LUld/G/1WeH25lUdXRYxnjPYZXeYYgEcmI7A3/bRIcw=;
        b=3BXkkvcr1OqHpZ/1lavYXP7tve2GxDnWf4O2fWPOiSdbOWRF8chSO/YIyqpEuxWDXh
         BJ7QFDeoj+Jn0Arzj7+Z5YjQU574gbvT6cAETsRRSqDeVkx/Ylx7RmGaHK6RFXNh6Eit
         fV0M97Hugr5QTbW1u6+18YRRaKIRIagsziaBLExN4bCT6bnocXCkvHc2Ew+80dXvoOZo
         BF8+iOJKnVBNIx5dtVYx6vnMu5+ZMBbkouCan/31RqRplh6dabd1rARUBLlSsQGaKiSb
         4trlbYIIc+EnwzxQuThX6PKBOpT5C2rO+n2a+7R9hS1L0V6qAuL49rS0jBoNV5zJv4h3
         Joww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942678; x=1684534678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LUld/G/1WeH25lUdXRYxnjPYZXeYYgEcmI7A3/bRIcw=;
        b=ERt4U0YsXfU2eO4PoEHbYXJeHP+RXDzneMm4Sag/rZks/APQu3oAtiTx4dl2LGs8YL
         yygd0ImYfVzzPsFvoQSN1L6vTV5gs3eY2FC7AqZG0i9dW/bH7XrWEjwWQboGpw0GkDr6
         ybYJWZhsV7msW/WIMQEJM84k/xoLwkAeXPW7IMwLfGh9j2m5E5Y5+0RZQvef6LNtgF0E
         rm694yllTzrPNlSfSKp1oS6A3U3cMiUAplDvqiCp0RkrmDKCGjFmlfwTcfYleTDVe/iK
         D3IfCP6bbeIqpZOO8kOWe+qHdhRSvpjzFKIuwKsFRc4Pz2FsGgmSP8j7ZGnoRewDKTBb
         cH6w==
X-Gm-Message-State: AAQBX9d6h6yv8Oqhk0oBjugBnPMTL5NXQh4k36W9R9zY4gmnr5xSwldV
        9BfOkHInrAyrxASQvtaTrELeAA==
X-Google-Smtp-Source: AKy350bb7O7vRNJqV0slEkpJiEEitj66qfL0H4rvbzo6EDHZOM2g1chblrb/iCkgTowCPCRsrQSCkw==
X-Received: by 2002:a17:902:eb8d:b0:19c:f476:4793 with SMTP id q13-20020a170902eb8d00b0019cf4764793mr5940941plg.51.1681942678346;
        Wed, 19 Apr 2023 15:17:58 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:17:58 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC 13/48] RISC-V: KVM: Return early for gstage modifications
Date:   Wed, 19 Apr 2023 15:16:41 -0700
Message-Id: <20230419221716.3603068-14-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419221716.3603068-1-atishp@rivosinc.com>
References: <20230419221716.3603068-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The gstage entries for CoVE VM is managed by the TSM. Return
early for any gstage pte modification operations.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/mmu.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 6b037f7..9693897 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -16,6 +16,9 @@
 #include <linux/kvm_host.h>
 #include <linux/sched/signal.h>
 #include <asm/kvm_nacl.h>
+#include <asm/csr.h>
+#include <asm/kvm_host.h>
+#include <asm/kvm_cove.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 
@@ -356,6 +359,11 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
 		.gfp_zero = __GFP_ZERO,
 	};
 
+	if (is_cove_vm(kvm)) {
+		kvm_debug("%s: KVM doesn't support ioremap for TVM io regions\n", __func__);
+		return -EPERM;
+	}
+
 	end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
 	pfn = __phys_to_pfn(hpa);
 
@@ -385,6 +393,10 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
 
 void kvm_riscv_gstage_iounmap(struct kvm *kvm, gpa_t gpa, unsigned long size)
 {
+	/* KVM doesn't map any IO region in gstage for TVM */
+	if (is_cove_vm(kvm))
+		return;
+
 	spin_lock(&kvm->mmu_lock);
 	gstage_unmap_range(kvm, gpa, size, false);
 	spin_unlock(&kvm->mmu_lock);
@@ -431,6 +443,10 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	gpa_t gpa = slot->base_gfn << PAGE_SHIFT;
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 
+	/* No need to unmap gstage as it is managed by TSM */
+	if (is_cove_vm(kvm))
+		return;
+
 	spin_lock(&kvm->mmu_lock);
 	gstage_unmap_range(kvm, gpa, size, false);
 	spin_unlock(&kvm->mmu_lock);
@@ -547,7 +563,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	if (!kvm->arch.pgd)
+	if (!kvm->arch.pgd || is_cove_vm(kvm))
 		return false;
 
 	gstage_unmap_range(kvm, range->start << PAGE_SHIFT,
@@ -561,7 +577,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	int ret;
 	kvm_pfn_t pfn = pte_pfn(range->pte);
 
-	if (!kvm->arch.pgd)
+	if (!kvm->arch.pgd || is_cove_vm(kvm))
 		return false;
 
 	WARN_ON(range->end - range->start != 1);
@@ -582,7 +598,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	u32 ptep_level = 0;
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
-	if (!kvm->arch.pgd)
+	if (!kvm->arch.pgd || is_cove_vm(kvm))
 		return false;
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
@@ -600,7 +616,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	u32 ptep_level = 0;
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
-	if (!kvm->arch.pgd)
+	if (!kvm->arch.pgd || is_cove_vm(kvm))
 		return false;
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
@@ -737,6 +753,10 @@ void kvm_riscv_gstage_free_pgd(struct kvm *kvm)
 {
 	void *pgd = NULL;
 
+	/* PGD is mapped in TSM */
+	if (is_cove_vm(kvm))
+		return;
+
 	spin_lock(&kvm->mmu_lock);
 	if (kvm->arch.pgd) {
 		gstage_unmap_range(kvm, 0UL, gstage_gpa_size, false);
-- 
2.25.1

