Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B158D6476AA
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiLHTkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiLHTkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:40:10 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E5B1AA07
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:39:55 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id f11-20020a5b01cb000000b0070374b66537so2542025ybp.14
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 11:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dgqMnMt1QIlmBLa3o//o520F4RUXcCCtqFrzTbNkpWk=;
        b=f4QHeg61IzowzK+7yuPHF1TXnPTFwNskqnQKjcsu0WxAKIY1McB7wZRn+VuSfBM9b8
         ylyyA9kcFWxQm6+GX+bMJZFHcWTGXb7YNV/fpxz2TqMv2QX/5/VLhbXkWs5BZNCv8lvE
         iAqaka88+2+N5tw21tP1s0c6lUAdukNFngVoXini/VGsGOpfrraDUlE9nKTf3FFTHm9y
         KUTGqSOH2A4NquRC0hECU12i0F9wQKuKP4xBOjtC4vxLFMrVdTK8VzxOC9xjDjBZVdgu
         7TIFyQpSoyu3BW883wqt4S03Vt2JnLjwrIPiyoLIXLGjApjxjBQRjkRdpzCFxXjOiqSy
         115A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dgqMnMt1QIlmBLa3o//o520F4RUXcCCtqFrzTbNkpWk=;
        b=QeNYdhvrWTxkejmqfs3lUiyyaaEYUPvo2QHAtiJ7nC+Bkbe4Cxj+EWWr2ifgfCNl4Y
         MmuhK5lzzjIuwpDY3lw7gwnhxvmCWUfRuPPyRHBo/F1kas+4ykUAN5ipGzSXfNh4Qf5j
         T4k52B9aXkuKEEmyCHiqlro80wai5UoKsAPpzAiSSpgfPBUxze1CcxFl0hlbxkgAqRB2
         kavF9pmROpHDESkHH2VI02kuWLoyUAQcwRsh99AHIePT3O1qpmrKF4wefvOSaVyQAdMA
         aJkbKySq5MveXZ5X+4Uy/6twKEyQCrL8zPxIoSXHHzsqiLaQYwjkjc28pDCBAx+UBn5A
         Hr9g==
X-Gm-Message-State: ANoB5pkv17FQWGIAXn8oK3hi2WB3kh3ETcz2kvtBz4gxKcCQExQGHK2C
        XjpC55rRmh9N4jXKF6Tms90yNmoFenQHXg==
X-Google-Smtp-Source: AA0mqf5mi9mDJ9tYVtakRomun512INrgKlNeUrlvHGHQBPGnddPX6ZC9IDNboVvCBGP15bWz6s6DsMaL8j57qA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:b885:0:b0:701:49ca:8ae8 with SMTP id
 w5-20020a25b885000000b0070149ca8ae8mr16438842ybj.553.1670528392392; Thu, 08
 Dec 2022 11:39:52 -0800 (PST)
Date:   Thu,  8 Dec 2022 11:38:47 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-28-dmatlack@google.com>
Subject: [RFC PATCH 27/37] KVM: MMU: Move mmu_page_header_cache to common code
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move vcpu->arch.mmu_page_header_cache and its backing kmem_cache to common code
in preparation for moving the TDP MMU to common code in a future commit.

The kmem_cache is still only initialized and used on x86 for the time being to
avoid affecting other architectures. A future commit can move the code to
manage this cache to common code.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 11 +++++------
 arch/x86/kvm/mmu/mmu_internal.h |  2 --
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 include/kvm/mmu.h               |  2 ++
 include/linux/kvm_host.h        |  3 +++
 virt/kvm/kvm_main.c             |  1 +
 6 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a845e9141ad4..f01ee01f3509 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -163,7 +163,6 @@ struct kvm_shadow_walk_iterator {
 	     __shadow_walk_next(&(_walker), spte))
 
 static struct kmem_cache *pte_list_desc_cache;
-struct kmem_cache *mmu_page_header_cache;
 static struct percpu_counter kvm_total_used_mmu_pages;
 
 static void mmu_spte_set(u64 *sptep, u64 spte);
@@ -674,7 +673,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 		if (r)
 			return r;
 	}
-	return kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
+	return kvm_mmu_topup_memory_cache(&vcpu->mmu_page_header_cache,
 					  PT64_ROOT_MAX_LEVEL);
 }
 
@@ -683,7 +682,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->mmu_page_table_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
+	kvm_mmu_free_memory_cache(&vcpu->mmu_page_header_cache);
 }
 
 static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
@@ -2217,7 +2216,7 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 						    union kvm_mmu_page_role role)
 {
 	struct shadow_page_caches caches = {
-		.page_header_cache = &vcpu->arch.mmu_page_header_cache,
+		.page_header_cache = &vcpu->mmu_page_header_cache,
 		.shadow_page_cache = &vcpu->mmu_page_table_cache,
 		.shadowed_info_cache = &vcpu->arch.mmu_shadowed_info_cache,
 	};
@@ -5917,8 +5916,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
 	vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
 
-	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
-	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
+	vcpu->mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
+	vcpu->mmu_page_header_cache.gfp_zero = __GFP_ZERO;
 
 	vcpu->mmu_page_table_cache.gfp_zero = __GFP_ZERO;
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d3c1d08002af..4aa60d5d87b0 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -44,8 +44,6 @@ extern bool dbg;
 #define INVALID_PAE_ROOT	0
 #define IS_VALID_PAE_ROOT(x)	(!!(x))
 
-extern struct kmem_cache *mmu_page_header_cache;
-
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 922815407b7e..891877a6fb78 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -263,7 +263,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_page *sp;
 
-	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
+	sp = kvm_mmu_memory_cache_alloc(&vcpu->mmu_page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->mmu_page_table_cache);
 
 	return sp;
diff --git a/include/kvm/mmu.h b/include/kvm/mmu.h
index 425db8e4f8e9..f1416828f8fe 100644
--- a/include/kvm/mmu.h
+++ b/include/kvm/mmu.h
@@ -4,6 +4,8 @@
 
 #include <kvm/mmu_types.h>
 
+extern struct kmem_cache *mmu_page_header_cache;
+
 static inline struct kvm_mmu_page *to_shadow_page(hpa_t shadow_page)
 {
 	struct page *page = pfn_to_page((shadow_page) >> PAGE_SHIFT);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0a9baa493760..ec3a6de6d54e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -391,6 +391,9 @@ struct kvm_vcpu {
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 	/* Cache used to allocate pages for use as page tables. */
 	struct kvm_mmu_memory_cache mmu_page_table_cache;
+
+	/* Cache used to allocate kvm_mmu_page structs. */
+	struct kvm_mmu_memory_cache mmu_page_header_cache;
 #endif
 };
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 954ab969f55e..0f1d48ed7d57 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -108,6 +108,7 @@ static int kvm_usage_count;
 static atomic_t hardware_enable_failed;
 
 static struct kmem_cache *kvm_vcpu_cache;
+struct kmem_cache *mmu_page_header_cache;
 
 static __read_mostly struct preempt_ops kvm_preempt_ops;
 static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_running_vcpu);
-- 
2.39.0.rc1.256.g54fd8350bd-goog

