Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32BD76AD1E6
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 23:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjCFWnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 17:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjCFWmo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 17:42:44 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E76374A74
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 14:42:08 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id i6-20020a170902c94600b0019d16e4ac0bso6577854pla.5
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 14:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678142519;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9itEUO5Up+fI8iZk0iLC4qpDns9vSkVb4A516EJM+I0=;
        b=at6TQkK22xH96lnLyAJmubroPcHciUudqTHcykVv1J4vGrW/W+Wm443aAB9k+s4VL6
         QhJ271wtkDKYq+yN0qOuZEsZhFa7kpf1EYRE9YM+4gPWg5IHwL4hklbYs1zbUgsk7Bbk
         3TcmaPFIIgEvnaZO3k4WnSCc9ZFBZvKPoYHHSFBvgDLaqrbu2ks/AokOLJOKlI1j/4HE
         AfdPl8TZkPDz4VBBwPbmvfYoWUHigzQM0524TwkBQBlm8NzIMPuKiJEruvOwxb7pvzzS
         Iuja/F2k+J1CiXNukSTAtlXOklCvIeUEOyDDUU+xou9hV6faTKP4unCqrQIVi3pzdUsT
         qK3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678142519;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9itEUO5Up+fI8iZk0iLC4qpDns9vSkVb4A516EJM+I0=;
        b=t8WYE0JqlFf8AW3YJGiHKzKVdlqH/m9A4ro8kYUfIOBcJ7HY4pPtxe/5YX9dzZ6bIs
         dmdbluR2zdbFXFpCG3SQv95Juvr9adDhxInM9MmWO57ivrMmdfFfmHgC0QKG8CCqAuMI
         sZdPud7a7NKogeUMvhE6+Uzgx5vWv6HXapLeO4UcswBmiS1v8KI/TzX93rdq+rNsQbZ5
         eWPC90HhgZ6fB1JIzqYkDME8SKZHH9eKdsEYGS8VaiQrKpvHs7qQtuUm2vA9Lz7rHQ4y
         C5/9J+pVGZvFnzMP7m7MHJmbsBop+Q/yug0hnTWEX3LUugx8+XU4L7Mk8uWRNIBCFZAz
         ioyA==
X-Gm-Message-State: AO0yUKVwVSLixoKvjbxdlwtSu9t0UY6oKbmbSC//uhxzkTBk2HplzCRP
        ylZis+QpdD8QwG4ruTWIogEKykrUn3/e
X-Google-Smtp-Source: AK7set9LZnkcT+4mc88Pdxib2KGSekMwjKPwN1F6NV9DbxpH+EWfu7Z5xTPOZLDmNsyKAGya/UsFECxhTM3s
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:9a03:b0:19a:afc4:2300 with SMTP id
 v3-20020a1709029a0300b0019aafc42300mr5089548plp.6.1678142518978; Mon, 06 Mar
 2023 14:41:58 -0800 (PST)
Date:   Mon,  6 Mar 2023 14:41:23 -0800
In-Reply-To: <20230306224127.1689967-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230306224127.1689967-15-vipinsh@google.com>
Subject: [Patch v4 14/18] KVM: mmu: Initialize kvm_mmu_memory_cache.gfp_zero
 to __GFP_ZERO by default
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set __GFP_ZERO to gfp_zero in default initizliation of struct
kvm_mmu_memory_cache{}

All of the users of default initialization code of struct
kvm_mmu_memory_cache{} explicitly sets gfp_zero to __GFP_ZERO. This can
be moved to common initialization logic.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/arm64/kvm/arm.c      | 1 -
 arch/arm64/kvm/mmu.c      | 1 -
 arch/riscv/kvm/mmu.c      | 1 -
 arch/riscv/kvm/vcpu.c     | 1 -
 arch/x86/kvm/mmu/mmu.c    | 6 ------
 include/linux/kvm_types.h | 4 +++-
 6 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2b3d88e4ace8..b4243978d962 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -331,7 +331,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
 
 	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache);
-	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
 
 	/*
 	 * Default value for the FP state, will be overloaded at load
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8a56f071ca66..133eba96c41f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -904,7 +904,6 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	if (is_protected_kvm_enabled())
 		return -EPERM;
 
-	cache.gfp_zero = __GFP_ZERO;
 	size += offset_in_page(guest_ipa);
 	guest_ipa &= PAGE_MASK;
 
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index bdd8c17958dd..62550fd91c70 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -353,7 +353,6 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
 	phys_addr_t addr, end;
 	KVM_MMU_MEMORY_CACHE(pcache);
 
-	pcache.gfp_zero = __GFP_ZERO;
 	if (in_atomic)
 		pcache.gfp_custom = GFP_ATOMIC | __GFP_ACCOUNT;
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index bc743e9122d1..f5a96ed1e426 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -164,7 +164,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	/* Mark this VCPU never ran */
 	vcpu->arch.ran_atleast_once = false;
 	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache);
-	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
 	bitmap_zero(vcpu->arch.isa, RISCV_ISA_EXT_MAX);
 
 	/* Setup ISA features available to VCPU */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b706087ef74e..d96afc849ee8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5963,14 +5963,11 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 
 	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_pte_list_desc_cache);
 	vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
-	vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
 
 	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_header_cache);
 	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
-	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
 
 	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_shadow_page_cache);
-	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
 	mutex_init(&vcpu->arch.mmu_shadow_page_cache_lock);
 
 	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_shadowed_info_cache);
@@ -6138,14 +6135,11 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 
 	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_page_header_cache);
 	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
-	kvm->arch.split_page_header_cache.gfp_zero = __GFP_ZERO;
 
 	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_shadow_page_cache);
-	kvm->arch.split_shadow_page_cache.gfp_zero = __GFP_ZERO;
 
 	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_desc_cache);
 	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
-	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
 
 	return 0;
 }
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 192516eeccac..5da7953532ce 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -99,7 +99,9 @@ struct kvm_mmu_memory_cache {
 	void **objects;
 };
 
-#define KVM_MMU_MEMORY_CACHE_INIT() { }
+#define KVM_MMU_MEMORY_CACHE_INIT() {	\
+	.gfp_zero = __GFP_ZERO,		\
+}
 
 #define KVM_MMU_MEMORY_CACHE(_name) \
 		struct kvm_mmu_memory_cache _name = KVM_MMU_MEMORY_CACHE_INIT()
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

