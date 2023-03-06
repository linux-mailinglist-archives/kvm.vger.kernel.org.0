Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CE66AD1E3
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 23:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbjCFWmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 17:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjCFWm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 17:42:26 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3D680E30
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 14:41:57 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id n1-20020a170902968100b0019cf3c5728fso6614766plp.19
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 14:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678142517;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wxg15xdE/bH7bhI4zmFRH7O/lZGJ/2R6ueAvOgk8JGw=;
        b=kd5ycUoFKU+axxo+AJDPdY5gK23AltHJWQ9PllQmiKCr/9wWHIlr51VYjyPnjMbIB3
         FXWYI9fGg+ZzUIWcjccLPYyucKzNdEUyOya/oP/cbH+iyIrK32foylhJTbkbD2qPJisu
         ivHY/JoeYd3ThHTDf00nDXN/B1QztwsfcfAXwSkxReVyCx4teZGfdwRKj/hYU5XG+JpV
         1QmhVrO7NFFOo4qDizBBQ+fliilDtPjyQU/4k7Wmo2jdcwZOAHfCoXo6IuwN71WBBOlE
         /1BSTLosLDYihhcNdVXIY8IwL/iqX+Nb4Xyc2xmcy1/jK8dBxK4LC/l4EflCSu/zh1/3
         Sc1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678142517;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wxg15xdE/bH7bhI4zmFRH7O/lZGJ/2R6ueAvOgk8JGw=;
        b=XrgJr4/Pknt5Ojdl4W70uoeC+6iF87N81vcbgFuIhCFugFo4lZn7Tu6CplZGqBndhz
         9sb5zAzuR/sfkydppp1SyWeayEdOOPLgPi3mIsE9OBylv6gumXBFmHYlk9vfIcIGc4XT
         LO6PIG9NXhCbqn/3rE2LIyEqtMKYg5Njp7caK1xii6nfn7UabDNOlmWBeiudtbxNKRL7
         WOWvytMlFYqI5sIR1fbd+Sll+68XxAJv3AOkspjlYXQnQR4NW0hyssO+ffefyKUJFuxB
         qxG6fUXZjL2LLoSB66ctTVkcouBFYk+gIJLIkn9/Ag6Ha6Kr1TH6TC3tZX6lBhZFaeFx
         mpgQ==
X-Gm-Message-State: AO0yUKVIexCgAJuqk/9Ye/WU2IGIVRTFxHFgNrrsbwlLNvo8OJhEZAB0
        5pTEK1t8pW/mAzEfKW9qiox/d27y2KZu
X-Google-Smtp-Source: AK7set8zyLRGjCJT715lEA2X1BTzblUJpfiGrVMGO6a2tbRTxhr7dXOJw/2D/EY+UNBggv7NLNT+hSuz8LTV
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:2253:b0:603:51de:c0dd with SMTP
 id i19-20020a056a00225300b0060351dec0ddmr5311084pfu.6.1678142517261; Mon, 06
 Mar 2023 14:41:57 -0800 (PST)
Date:   Mon,  6 Mar 2023 14:41:22 -0800
In-Reply-To: <20230306224127.1689967-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230306224127.1689967-14-vipinsh@google.com>
Subject: [Patch v4 13/18] KVM: mmu: Add common initialization logic for struct kvm_mmu_memory_cache{}
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
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

Add macros and function to make common logic for struct
kvm_mmu_memory_cache{} declaration and initialization.

Any user which wants different values in struct kvm_mmu_memory_cache{}
will overwrite the default values explicitly after the initialization.

Suggested-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/arm64/kvm/arm.c      |  1 +
 arch/arm64/kvm/mmu.c      |  3 ++-
 arch/riscv/kvm/mmu.c      |  9 +++++----
 arch/riscv/kvm/vcpu.c     |  1 +
 arch/x86/kvm/mmu/mmu.c    |  8 ++++++++
 include/linux/kvm_types.h | 10 ++++++++++
 6 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf087..2b3d88e4ace8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -330,6 +330,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.target = -1;
 	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
 
+	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache);
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
 
 	/*
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7113587222ff..8a56f071ca66 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -895,7 +895,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 {
 	phys_addr_t addr;
 	int ret = 0;
-	struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
+	KVM_MMU_MEMORY_CACHE(cache);
 	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
 				     KVM_PGTABLE_PROT_R |
@@ -904,6 +904,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	if (is_protected_kvm_enabled())
 		return -EPERM;
 
+	cache.gfp_zero = __GFP_ZERO;
 	size += offset_in_page(guest_ipa);
 	guest_ipa &= PAGE_MASK;
 
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 78211aed36fa..bdd8c17958dd 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -351,10 +351,11 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
 	int ret = 0;
 	unsigned long pfn;
 	phys_addr_t addr, end;
-	struct kvm_mmu_memory_cache pcache = {
-		.gfp_custom = (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT : 0,
-		.gfp_zero = __GFP_ZERO,
-	};
+	KVM_MMU_MEMORY_CACHE(pcache);
+
+	pcache.gfp_zero = __GFP_ZERO;
+	if (in_atomic)
+		pcache.gfp_custom = GFP_ATOMIC | __GFP_ACCOUNT;
 
 	end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
 	pfn = __phys_to_pfn(hpa);
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 7d010b0be54e..bc743e9122d1 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -163,6 +163,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	/* Mark this VCPU never ran */
 	vcpu->arch.ran_atleast_once = false;
+	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache);
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
 	bitmap_zero(vcpu->arch.isa, RISCV_ISA_EXT_MAX);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a4bf2e433030..b706087ef74e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5961,15 +5961,20 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
+	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_pte_list_desc_cache);
 	vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
 	vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
 
+	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_header_cache);
 	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
 	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
 
+	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_shadow_page_cache);
 	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
 	mutex_init(&vcpu->arch.mmu_shadow_page_cache_lock);
 
+	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_shadowed_info_cache);
+
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
 
@@ -6131,11 +6136,14 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
 
+	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_page_header_cache);
 	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
 	kvm->arch.split_page_header_cache.gfp_zero = __GFP_ZERO;
 
+	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_shadow_page_cache);
 	kvm->arch.split_shadow_page_cache.gfp_zero = __GFP_ZERO;
 
+	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_desc_cache);
 	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
 	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
 
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 2728d49bbdf6..192516eeccac 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -98,6 +98,16 @@ struct kvm_mmu_memory_cache {
 	int capacity;
 	void **objects;
 };
+
+#define KVM_MMU_MEMORY_CACHE_INIT() { }
+
+#define KVM_MMU_MEMORY_CACHE(_name) \
+		struct kvm_mmu_memory_cache _name = KVM_MMU_MEMORY_CACHE_INIT()
+
+static inline void INIT_KVM_MMU_MEMORY_CACHE(struct kvm_mmu_memory_cache *cache)
+{
+	*cache = (struct kvm_mmu_memory_cache)KVM_MMU_MEMORY_CACHE_INIT();
+}
 #endif
 
 #define HALT_POLL_HIST_COUNT			32
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

