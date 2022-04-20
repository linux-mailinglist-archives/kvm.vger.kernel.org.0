Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D320508942
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 15:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379054AbiDTN2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 09:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379039AbiDTN2m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 09:28:42 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F5D3A187;
        Wed, 20 Apr 2022 06:25:56 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id p8so1914724pfh.8;
        Wed, 20 Apr 2022 06:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jjSP1EY6GE15ryex7YKFqGxc3rcSfRHmQrniXn4FjUc=;
        b=oxqxZbWgxFnLN2naCgMlw72VN2dZ8fNFqgDsgoz14rgp5AkETywM4CqumR97t1lY+D
         3wPmWxKvPumh1YOlTnyDWTsaYfhW4YHTwhAmiOW2sWz5ni3FWvlnte1dgQv0efKYroyB
         D575woexiYfgqBhNLg+MHL+1TC9HsAmTzyo+TMGjjlaO0DKwSdh/Y1XMA3tVAisCcIZo
         k8tIkemMiE6euldW9QGnAv1tCL0OFCmYDBszr0Q6BVIvckw7nbaavngx8dC+wpynCMlU
         oI2Qt4A5css2nzXBjLC/XTwd+PPYgYxI79oJQzac+Ni+zGeqP4QOI8UHjckSLk7KqVhQ
         CbtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jjSP1EY6GE15ryex7YKFqGxc3rcSfRHmQrniXn4FjUc=;
        b=GsJCpuFNgQGvmHKQsGmr6HuNpDq8ehSNg2lfZKqZnxC+gizF/6TLsRkBAc6Wr3XA/6
         1qlsgLGwCVl8yp7vhzrA9mwwmsMqwuhaXVOADeffOc1vBshzPpvRY7FMYUl2A/6y5QCM
         2SxVWqyi15pqEHLOR7b8AVtCcrHCA5L6L7p3/h1dfI41ApDRcs3K6d4bjDyhR0k1ACjT
         PmdeLbmsoy/xJM55UhWJENqkun3UoWqATJ65uUlaDQ8ctJR+QQdb2pUHZxsK5a1/0Nus
         O+OMZN+bADNdTCLu10GHVLuQx8e5z6drlL7PDxhLqZ/AmjVq0LTTtviHaZfFvwNIfSg0
         OnMg==
X-Gm-Message-State: AOAM531T65rbMG8DstiP5/R+Nv4NtpkFbnVzh9utRQdBfrqtQJYinYMI
        jd5YE2IgEJhXO/VkE9LchBT+gWqbouQ=
X-Google-Smtp-Source: ABdhPJwhFmtlDYofvkK6rrlWWHpnRtw4Vxe368lehSgXLDlKKHkTlAn5aqSevVHHFdMs5fRn1UKE3g==
X-Received: by 2002:a05:6a00:1893:b0:50a:9b07:20bd with SMTP id x19-20020a056a00189300b0050a9b0720bdmr7228985pfh.66.1650461155230;
        Wed, 20 Apr 2022 06:25:55 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id r8-20020a17090a0ac800b001c9e35d3a3asm19297925pje.24.2022.04.20.06.25.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 06:25:55 -0700 (PDT)
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
Subject: [PATCH 6/7] KVM: X86/MMU: Allocate mmu->pae_root for PAE paging on-demand
Date:   Wed, 20 Apr 2022 21:26:04 +0800
Message-Id: <20220420132605.3813-7-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220420132605.3813-1-jiangshanlai@gmail.com>
References: <20220420132605.3813-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 72a1af35e331..2f590779ee39 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -694,6 +694,41 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	}
 }
 
+static int mmu_alloc_pae_root(struct kvm_vcpu *vcpu)
+{
+	struct page *page;
+
+	if (vcpu->arch.mmu->shadow_root_level != PT32E_ROOT_LEVEL)
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
+		WARN_ON_ONCE(shadow_me_mask);
+	return 0;
+}
+
 static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 {
 	int r;
@@ -5036,6 +5071,9 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->direct_map);
 	if (r)
 		goto out;
+	r = mmu_alloc_pae_root(vcpu);
+	if (r)
+		return r;
 	r = mmu_alloc_special_roots(vcpu);
 	if (r)
 		goto out;
@@ -5500,63 +5538,18 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
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
-		WARN_ON_ONCE(shadow_me_mask);
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
 
@@ -5568,18 +5561,10 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
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

