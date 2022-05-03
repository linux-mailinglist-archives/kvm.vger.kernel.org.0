Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B478B5187EB
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 17:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237841AbiECPLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 11:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237915AbiECPLK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 11:11:10 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E013A700;
        Tue,  3 May 2022 08:07:37 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id p6so15590033pjm.1;
        Tue, 03 May 2022 08:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xwVTyVgnXnu4Ng50PBO2fNGmlJLTIN2sccv/61Ac7bU=;
        b=OYyIr8ml/X85o20eU+jYm1ZcnAwTpeA2LshdlS8+PbHv2m/lFkFRgWVv8qM9Khqy/O
         P/J4nWKf5YtEkqIoVt4iie00eyl9GuLm9Xh4fHwdi++JAk1V5opU53S2UUIlBPZc2Ar+
         FEvSiSvf3/JICD0kTqy5RNTph4iycSLJaGyCiTn22g1r1diKk5RSQFx9c1QunL7H9kMh
         qahNzZH281yFpMEdkScgElx4ywOqTGiR/2jd+fGyX0FkbzSDWcFiqQCDWDFAkP9kN+3Z
         hIOOhR4+ceIKq2ULdBChnN6ZwLEDcO6MRg9gfkLgZiNGTZZN/r+rO7KYUqgZo0SDMP+m
         dLMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xwVTyVgnXnu4Ng50PBO2fNGmlJLTIN2sccv/61Ac7bU=;
        b=bW3R54vMlo8es+2UjUYYSm9bPy5xj0GDatlZg2KJp08FDvrEYIXWKFFXItxC7AI7vQ
         Lp1R/2HQElrnkkmKlZJ4HzxM7u8dRB+tlCDfImaIk7MEBmpqHDlEnFcFTBGYiCxW9ake
         SRGPB149GIRj+tktxPSFRYUShdFH1SSYd7cLBBPX23eoqlQRwP242Jx9jzMTUyJSGIB6
         vXBJmOAckH73+HFrjM4J6bSZr+IKJCEdk0Qgoq0iFywEmX7YHlTlyG1DP0cW5B/H1IJc
         Bf5iwsh0Z+QtqMKv778qt3WqyaKSWonjFiXhuybHrKA5tqNzgybH09cEiVkjeF8lsQ7X
         1t2Q==
X-Gm-Message-State: AOAM533oh+mdjACkX2BzXm3mYIYa2djM980Psy7Jv6efjIX4hMimQ1h0
        WktLKcTaVlfPCWG6UxzDgCG8aSDNKPs=
X-Google-Smtp-Source: ABdhPJwUn5SwgHiT9/HU2hAMX++I80ioYKGjyW0UsWK3Rj1czzakSYoATJBCXnwF2la2J6/yo4f5Eg==
X-Received: by 2002:a17:903:2d0:b0:14d:8a8d:cb1 with SMTP id s16-20020a17090302d000b0014d8a8d0cb1mr17023132plk.50.1651590456930;
        Tue, 03 May 2022 08:07:36 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id y17-20020aa78051000000b0050dc76281b2sm6612639pfm.140.2022.05.03.08.07.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 May 2022 08:07:36 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH V2 6/7] KVM: X86/MMU: Allocate mmu->pae_root for PAE paging on-demand
Date:   Tue,  3 May 2022 23:07:34 +0800
Message-Id: <20220503150735.32723-7-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220503150735.32723-1-jiangshanlai@gmail.com>
References: <20220503150735.32723-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

mmu->pae_root for non-PAE paging is allocated on-demand, but
mmu->pae_root for PAE paging is allocated early when struct kvm_mmu is
being created.

Simplify the code to allocate mmu->pae_root for PAE paging and make
it on-demand.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c          | 99 ++++++++++++++-------------------
 arch/x86/kvm/mmu/mmu_internal.h | 10 ----
 2 files changed, 42 insertions(+), 67 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bcb3e2730277..c97f830c5f8c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -691,6 +691,41 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	}
 }
 
+static int mmu_alloc_pae_root(struct kvm_vcpu *vcpu)
+{
+	struct page *page;
+
+	if (vcpu->arch.mmu->root_role.level != PT32E_ROOT_LEVEL)
+		return 0;
+	if (vcpu->arch.mmu->pae_root)
+		return 0;
+
+	/*
+	 * Allocate a page to hold the four PDPTEs for PAE paging when emulating
+	 * 32-bit mode.  CR3 is only 32 bits even on x86_64 in this case.
+	 * Therefore we need to allocate the PDP table in the first 4GB of
+	 * memory, which happens to fit the DMA32 zone.
+	 */
+	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_DMA32);
+	if (!page)
+		return -ENOMEM;
+	vcpu->arch.mmu->pae_root = page_address(page);
+
+	/*
+	 * CR3 is only 32 bits when PAE paging is used, thus it's impossible to
+	 * get the CPU to treat the PDPTEs as encrypted.  Decrypt the page so
+	 * that KVM's writes and the CPU's reads get along.  Note, this is
+	 * only necessary when using shadow paging, as 64-bit NPT can get at
+	 * the C-bit even when shadowing 32-bit NPT, and SME isn't supported
+	 * by 32-bit kernels (when KVM itself uses 32-bit NPT).
+	 */
+	if (!tdp_enabled)
+		set_memory_decrypted((unsigned long)vcpu->arch.mmu->pae_root, 1);
+	else
+		WARN_ON_ONCE(shadow_me_value);
+	return 0;
+}
+
 static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 {
 	int r;
@@ -5031,6 +5066,9 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->root_role.direct);
 	if (r)
 		goto out;
+	r = mmu_alloc_pae_root(vcpu);
+	if (r)
+		return r;
 	r = mmu_alloc_special_roots(vcpu);
 	if (r)
 		goto out;
@@ -5495,63 +5533,18 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
 	free_page((unsigned long)mmu->pml5_root);
 }
 
-static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
+static void __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 {
-	struct page *page;
 	int i;
 
 	mmu->root.hpa = INVALID_PAGE;
 	mmu->root.pgd = 0;
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
-
-	/* vcpu->arch.guest_mmu isn't used when !tdp_enabled. */
-	if (!tdp_enabled && mmu == &vcpu->arch.guest_mmu)
-		return 0;
-
-	/*
-	 * When using PAE paging, the four PDPTEs are treated as 'root' pages,
-	 * while the PDP table is a per-vCPU construct that's allocated at MMU
-	 * creation.  When emulating 32-bit mode, cr3 is only 32 bits even on
-	 * x86_64.  Therefore we need to allocate the PDP table in the first
-	 * 4GB of memory, which happens to fit the DMA32 zone.  TDP paging
-	 * generally doesn't use PAE paging and can skip allocating the PDP
-	 * table.  The main exception, handled here, is SVM's 32-bit NPT.  The
-	 * other exception is for shadowing L1's 32-bit or PAE NPT on 64-bit
-	 * KVM; that horror is handled on-demand by mmu_alloc_special_roots().
-	 */
-	if (tdp_enabled && kvm_mmu_get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
-		return 0;
-
-	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_DMA32);
-	if (!page)
-		return -ENOMEM;
-
-	mmu->pae_root = page_address(page);
-
-	/*
-	 * CR3 is only 32 bits when PAE paging is used, thus it's impossible to
-	 * get the CPU to treat the PDPTEs as encrypted.  Decrypt the page so
-	 * that KVM's writes and the CPU's reads get along.  Note, this is
-	 * only necessary when using shadow paging, as 64-bit NPT can get at
-	 * the C-bit even when shadowing 32-bit NPT, and SME isn't supported
-	 * by 32-bit kernels (when KVM itself uses 32-bit NPT).
-	 */
-	if (!tdp_enabled)
-		set_memory_decrypted((unsigned long)mmu->pae_root, 1);
-	else
-		WARN_ON_ONCE(shadow_me_value);
-
-	for (i = 0; i < 4; ++i)
-		mmu->pae_root[i] = INVALID_PAE_ROOT;
-
-	return 0;
 }
 
 int kvm_mmu_create(struct kvm_vcpu *vcpu)
 {
-	int ret;
-
 	vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
 	vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
 
@@ -5563,18 +5556,10 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
 
-	ret = __kvm_mmu_create(vcpu, &vcpu->arch.guest_mmu);
-	if (ret)
-		return ret;
-
-	ret = __kvm_mmu_create(vcpu, &vcpu->arch.root_mmu);
-	if (ret)
-		goto fail_allocate_root;
+	__kvm_mmu_create(vcpu, &vcpu->arch.guest_mmu);
+	__kvm_mmu_create(vcpu, &vcpu->arch.root_mmu);
 
-	return ret;
- fail_allocate_root:
-	free_mmu_pages(&vcpu->arch.guest_mmu);
-	return ret;
+	return 0;
 }
 
 #define BATCH_ZAP_PAGES	10
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1bff453f7cbe..d5673a42680f 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -20,16 +20,6 @@ extern bool dbg;
 #define MMU_WARN_ON(x) do { } while (0)
 #endif
 
-/*
- * Unlike regular MMU roots, PAE "roots", a.k.a. PDPTEs/PDPTRs, have a PRESENT
- * bit, and thus are guaranteed to be non-zero when valid.  And, when a guest
- * PDPTR is !PRESENT, its corresponding PAE root cannot be set to INVALID_PAGE,
- * as the CPU would treat that as PRESENT PDPTR with reserved bits set.  Use
- * '0' instead of INVALID_PAGE to indicate an invalid PAE root.
- */
-#define INVALID_PAE_ROOT	0
-#define IS_VALID_PAE_ROOT(x)	(!!(x))
-
 typedef u64 __rcu *tdp_ptep_t;
 
 struct kvm_mmu_page {
-- 
2.19.1.6.gb485710b

