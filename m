Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4D5653AB0
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 03:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbiLVCfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 21:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234988AbiLVCfQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 21:35:16 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C0C248C9
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 18:35:10 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id a1-20020a056a001d0100b0057a6f74d7bcso311151pfx.1
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 18:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=poiDBxCXZuaSeZicG2qgYYUccKGMhjWu3dn9FbyWbdI=;
        b=TH1iUYrFfRpDWtVxW3+pgFlRAZdRswEo031A+JoBSFw8+0LAdMFXq8dZa92oOrcqew
         zYK5KnaC50bemT2vcH3I6ljHX1zk29hcYKiDZBNLKVzfySyuRHuu18d89jK8PIfT1R5h
         LcbSU39GflE5evKZtr1uNxzcziFGWAUPdRR3Mx/UUTStoxEpMFjqdxAwTrADnkgxrxfR
         MoqyQVpxe61yOYHtHbVvl+2zwqIlTaQOZOu2yejduA1CKn6/fjkWxKF51oEKMyBQO64B
         G5UcwCIQeSaC9FL/TdKjgMmQqju1POsZRD1JXmJmsK1WsMnE1GTwbAqHf7k7VSLWZPyK
         ZOlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=poiDBxCXZuaSeZicG2qgYYUccKGMhjWu3dn9FbyWbdI=;
        b=62Po8o7KZ5sIUwxmwpaI00ccVCkzw+7IpBdSF8ZEO5LbBRY6uJ0pM0DrsVchgEcq0O
         Ek6bqOus6KOOukU1BAEImH33d/SIy+ySNjB2swqCPrEfAMoWAJuvQWmbLFiIJpF8tyFj
         2JwuUh/zAZuJzubH7PI4fYlz7m7HAoN5CIFLWMoQs2o3NaYnMbEl5oEn1jwqtGJkdMI3
         6vUS7+57RYCvltag3Slqf71VAz+LQViCKAz9rPXaMbM2Ah6ign/cDHikNuB9XJf6UzHG
         IYVDRxfD8PwjVOQ4+99qXHTJvo9+eCUT3k/JKqWerIVXOlshBtbXdC9FyxKWtjCyeWQT
         Nvqg==
X-Gm-Message-State: AFqh2komgxw6BYnRbPQft2lTDJ5QJAcu/aFdcSwzzd8jRildU7P6pnNC
        imQuN7v0Azl2s8EMhRt8htPGHxH1BhfX
X-Google-Smtp-Source: AMrXdXtcmKHWHo1AhNx9UQ0Z/sHm4RIiqsiHuv78kXo5tk+ZPsGbtCKvNa6VwqFR7MArdGz/SkeKXbSRg1zN
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:4c83:b0:219:ac7f:27d8 with SMTP id
 k3-20020a17090a4c8300b00219ac7f27d8mr366228pjh.192.1671676510249; Wed, 21 Dec
 2022 18:35:10 -0800 (PST)
Date:   Wed, 21 Dec 2022 18:34:54 -0800
In-Reply-To: <20221222023457.1764-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221222023457.1764-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221222023457.1764-7-vipinsh@google.com>
Subject: [Patch v3 6/9] KVM: Provide NUMA node support to kvm_mmu_memory_cache{}
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
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

Add 'node' variable in kvm_mmu_memory_cache{} to denote which NUMA node
this cache should allocate memory from. Default initialize to
NUMA_NO_NODE in all architectures.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/arm64/kvm/arm.c      |  2 +-
 arch/arm64/kvm/mmu.c      |  4 +++-
 arch/mips/kvm/mips.c      |  2 ++
 arch/riscv/kvm/mmu.c      |  2 +-
 arch/riscv/kvm/vcpu.c     |  2 +-
 arch/x86/kvm/mmu/mmu.c    | 22 ++++++++++++----------
 include/linux/kvm_host.h  |  6 ++++++
 include/linux/kvm_types.h |  2 ++
 8 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9c5573bc4614..52a41f4532e2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -340,7 +340,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.target = -1;
 	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
 
-	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
+	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache, NULL, NUMA_NO_NODE);
 
 	/*
 	 * Default value for the FP state, will be overloaded at load
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 31d7fa4c7c14..bd07155e17fa 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -894,12 +894,14 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 {
 	phys_addr_t addr;
 	int ret = 0;
-	struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
+	struct kvm_mmu_memory_cache cache;
 	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
 				     KVM_PGTABLE_PROT_R |
 				     (writable ? KVM_PGTABLE_PROT_W : 0);
 
+	INIT_KVM_MMU_MEMORY_CACHE(&cache, NULL, NUMA_NO_NODE);
+
 	if (is_protected_kvm_enabled())
 		return -EPERM;
 
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index a25e0b73ee70..b017c29a9340 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -304,6 +304,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		     HRTIMER_MODE_REL);
 	vcpu->arch.comparecount_timer.function = kvm_mips_comparecount_wakeup;
 
+	vcpu->arch.mmu_page_cache.node = NUMA_NO_NODE;
+
 	/*
 	 * Allocate space for host mode exception handlers that handle
 	 * guest mode exits
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 34b57e0be2ef..119de4520cc6 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -353,9 +353,9 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
 	phys_addr_t addr, end;
 	struct kvm_mmu_memory_cache pcache = {
 		.gfp_custom = (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT : 0,
-		.gfp_zero = __GFP_ZERO,
 	};
 
+	INIT_KVM_MMU_MEMORY_CACHE(&pcache, NULL, NUMA_NO_NODE);
 	end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
 	pfn = __phys_to_pfn(hpa);
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 7c08567097f0..189b14feb365 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -161,7 +161,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	/* Mark this VCPU never ran */
 	vcpu->arch.ran_atleast_once = false;
-	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
+	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache, NULL, NUMA_NO_NODE);
 	bitmap_zero(vcpu->arch.isa, RISCV_ISA_EXT_MAX);
 
 	/* Setup ISA features available to VCPU */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f6a10d7a871..23a3b82b2384 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5954,13 +5954,14 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
-	vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
-	vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
+	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_pte_list_desc_cache,
+				  pte_list_desc_cache, NUMA_NO_NODE);
 
-	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
-	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
+	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_header_cache,
+				  mmu_page_header_cache, NUMA_NO_NODE);
 
-	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
+	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_shadow_page_cache,
+				  NULL, NUMA_NO_NODE);
 	spin_lock_init(&vcpu->arch.mmu_shadow_page_cache_lock);
 
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
@@ -6124,14 +6125,15 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
 
-	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
-	kvm->arch.split_page_header_cache.gfp_zero = __GFP_ZERO;
+	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_page_header_cache,
+				  mmu_page_header_cache, NUMA_NO_NODE);
 
-	kvm->arch.split_shadow_page_cache.gfp_zero = __GFP_ZERO;
+	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_shadow_page_cache,
+				  NULL, NUMA_NO_NODE);
 	spin_lock_init(&kvm->arch.split_shadow_page_cache_lock);
 
-	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
-	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
+	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_desc_cache,
+				  pte_list_desc_cache, NUMA_NO_NODE);
 
 	return 0;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a262e15ebd19..719687a37ef7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2302,4 +2302,10 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
 /* Max number of entries allowed for each kvm dirty ring */
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
+#define INIT_KVM_MMU_MEMORY_CACHE(_cache, _kmem_cache, _node) ({	\
+	(_cache)->kmem_cache = _kmem_cache;				\
+	(_cache)->gfp_zero = __GFP_ZERO;				\
+	(_cache)->node = _node;						\
+})
+
 #endif
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 76de36e56cdf..9c70ce95e51f 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -97,6 +97,8 @@ struct kvm_mmu_memory_cache {
 	struct kmem_cache *kmem_cache;
 	int capacity;
 	void **objects;
+	/* Node on which memory should be allocated by default */
+	int node;
 };
 #endif
 
-- 
2.39.0.314.g84b9a713c41-goog

