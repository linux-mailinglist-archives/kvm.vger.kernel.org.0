Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB13346FDAE
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 10:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239366AbhLJJ3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 04:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239443AbhLJJ27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 04:28:59 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610B8C061A72;
        Fri, 10 Dec 2021 01:25:24 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so8986985pjc.4;
        Fri, 10 Dec 2021 01:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=98Xa5oxPztPAdRgg+uk6YCzCFqchhpbQCP+3VdeBe9I=;
        b=WCOVXXH7oLBD0jeSZXl8oo5ptQmWQoitpR/wNTpVsrcX8VStdPPEH3y+WSkwhggkEP
         XKWs5817qHxdZPWJ4XEiO09DEhf8xTF21G0rZPi4km1/EUxwHw72PSvFmGb43OCKckWK
         uDyf36Oka1iu+BaVhNnNsKlJxuGvDugkIXk502tAzeYfnu9+BsFAlA54B7BhwZFQS2us
         ZZKfPoYRbQbR9PkTuU+UK+Wu7vXTKEOx1Dj07LnjJCgWrsxna2QdNxMos5JQpbkY48Zk
         1YyS38MRNZ0e2vi34FzkdLxyiu6b38I3kIHbbkWf1NqkQN2yG0ZYpQTkbYTiVjlzGc+B
         5d5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=98Xa5oxPztPAdRgg+uk6YCzCFqchhpbQCP+3VdeBe9I=;
        b=ToI8l0Y1pRKyS/IYKgWJJbCRuST5+62/KMwBctJXd2eJP83sF8hySFtVdBsBP7fowj
         5ugxTJH1tmZXtOrrg8BkzH6DH7Gm65IhKHPixbM0MQedg9/2F+nrddgR8LaFwfxjt2Dc
         WtoPcOdf6AmoboS9JLbGEPLc+/+GDN2Aj5xMrGIsRPmv7+NSyL7TQlapwrsYLKP1+UkQ
         Wdmm4r4JdwrA0E3DvluytjUzg5YEaNeimTX8VypiHdPeC2yYP3TxOJm3oh7TyvbJBkgI
         dX+fMaqBy7HIbLcCisxbioxFS+L/96toyJBaZkQ2kM0DBsXPqwWCbQOmbJNW36M1GxoA
         Gt7Q==
X-Gm-Message-State: AOAM530RlD14I2jIy4Zf7QLSlx5XNNRnBzawoxY0okmDXIlluN9sT/xv
        RF/VtlvG4XpZE9Efyg9kj6LAyrBpPk4=
X-Google-Smtp-Source: ABdhPJwk0MJyqjcItNTRfHPItPKJ/MVYQQH1Nu2atSju50dvGCiSnLmkp6wpX6U4sqs0+baRUPI9/w==
X-Received: by 2002:a17:90a:bf8a:: with SMTP id d10mr22194685pjs.67.1639128323718;
        Fri, 10 Dec 2021 01:25:23 -0800 (PST)
Received: from localhost ([47.251.3.230])
        by smtp.gmail.com with ESMTPSA id g13sm2113784pjc.39.2021.12.10.01.25.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 01:25:23 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 5/6] KVM: X86: Alloc pae_root shadow page
Date:   Fri, 10 Dec 2021 17:25:07 +0800
Message-Id: <20211210092508.7185-6-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211210092508.7185-1-jiangshanlai@gmail.com>
References: <20211210092508.7185-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Currently pae_root is special root page, this patch adds facility to
allow using kvm_mmu_get_page() to allocate pae_root shadow page.

When kvm_mmu_get_page() is called for level == PT32E_ROOT_LEVEL and
vcpu->arch.mmu->shadow_root_level == PT32E_ROOT_LEVEL, it will get a
DMA32 root page with default PAE pdptes installed.

The pae_root bit is needed in the page role because:
	it is required to be DMA32 page.
	its first 4 sptes are initialized with default_pae_pdpte.

default_pae_pdpte is needed because the cpu expect PAE pdptes are
present when VMenter.  default_pae_pdpte is designed to have no
SPTE_MMU_PRESENT_MASK so that it is present in the view of CPU but not
present in the view of shadow papging, and the page fault handler will
replace it with real present shadow page.

When changing from default_pae_pdpte to a present spte, no tlb flushing
is requested, although both are present in the view of CPU.  The reason
is that default_pae_pdpte points to zero page, no pte is present if the
paging structure is cached.

No functionality changed since this code is not activated because when
vcpu->arch.mmu->shadow_root_level == PT32E_ROOT_LEVEL, kvm_mmu_get_page()
is only called for level == 1 or 2 now.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/kvm/mmu/mmu.c          | 113 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/mmu/paging_tmpl.h  |   1 +
 3 files changed, 114 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6465c83794fc..82a8844f80ac 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -335,7 +335,8 @@ union kvm_mmu_page_role {
 		unsigned ad_disabled:1;
 		unsigned guest_mode:1;
 		unsigned level_promoted:1;
-		unsigned :5;
+		unsigned pae_root:1;
+		unsigned :4;
 
 		/*
 		 * This is left at the top of the word so that
@@ -695,6 +696,7 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
 	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
+	unsigned long mmu_pae_root_cache;
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4769253e9024..0d2976dad863 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -724,6 +724,67 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	}
 }
 
+static u64 default_pae_pdpte;
+
+static void free_default_pae_pdpte(void)
+{
+	free_page((unsigned long)__va(default_pae_pdpte & PAGE_MASK));
+	default_pae_pdpte = 0;
+}
+
+static int alloc_default_pae_pdpte(void)
+{
+	unsigned long p = __get_free_page(GFP_KERNEL | __GFP_ZERO);
+
+	if (!p)
+		return -ENOMEM;
+	default_pae_pdpte = __pa(p) | PT_PRESENT_MASK | shadow_me_mask;
+	if (WARN_ON(is_shadow_present_pte(default_pae_pdpte) ||
+		    is_mmio_spte(default_pae_pdpte))) {
+		free_default_pae_pdpte();
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int alloc_pae_root(struct kvm_vcpu *vcpu)
+{
+	struct page *page;
+	unsigned long pae_root;
+	u64* pdpte;
+
+	if (vcpu->arch.mmu->shadow_root_level != PT32E_ROOT_LEVEL)
+		return 0;
+	if (vcpu->arch.mmu_pae_root_cache)
+		return 0;
+
+	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_DMA32);
+	if (!page)
+		return -ENOMEM;
+
+	pae_root = (unsigned long)page_address(page);
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
+		set_memory_decrypted(pae_root, 1);
+	else
+		WARN_ON_ONCE(shadow_me_mask);
+	vcpu->arch.mmu_pae_root_cache = pae_root;
+	pdpte = (void *)pae_root;
+	pdpte[0] = default_pae_pdpte;
+	pdpte[1] = default_pae_pdpte;
+	pdpte[2] = default_pae_pdpte;
+	pdpte[3] = default_pae_pdpte;
+	return 0;
+}
+
 static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 {
 	int r;
@@ -735,6 +796,9 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 		return r;
 	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
 				       PT64_ROOT_MAX_LEVEL);
+	if (r)
+		return r;
+	r = alloc_pae_root(vcpu);
 	if (r)
 		return r;
 	if (maybe_indirect) {
@@ -753,6 +817,10 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
+	if (!tdp_enabled && vcpu->arch.mmu_pae_root_cache)
+		set_memory_encrypted(vcpu->arch.mmu_pae_root_cache, 1);
+	free_page(vcpu->arch.mmu_pae_root_cache);
+	vcpu->arch.mmu_pae_root_cache = 0;
 }
 
 static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
@@ -1706,6 +1774,8 @@ static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
 	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
 	list_del(&sp->link);
+	if (!tdp_enabled && sp->role.pae_root)
+		set_memory_encrypted((unsigned long)sp->spt, 1);
 	free_page((unsigned long)sp->spt);
 	if (!sp->role.direct && !sp->role.level_promoted)
 		free_page((unsigned long)sp->gfns);
@@ -1735,8 +1805,13 @@ static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
 static void drop_parent_pte(struct kvm_mmu_page *sp,
 			    u64 *parent_pte)
 {
+	struct kvm_mmu_page *parent_sp = sptep_to_sp(parent_pte);
+
 	mmu_page_remove_parent_pte(sp, parent_pte);
-	mmu_spte_clear_no_track(parent_pte);
+	if (!parent_sp->role.pae_root)
+		mmu_spte_clear_no_track(parent_pte);
+	else
+		__update_clear_spte_fast(parent_pte, default_pae_pdpte);
 }
 
 static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, gfn_t gfn, union kvm_mmu_page_role role)
@@ -1744,7 +1819,12 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 	struct kvm_mmu_page *sp;
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	if (!role.pae_root) {
+		sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	} else {
+		sp->spt = (void *)vcpu->arch.mmu_pae_root_cache;
+		vcpu->arch.mmu_pae_root_cache = 0;
+	}
 	if (!(role.direct || role.level_promoted))
 		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
@@ -2091,6 +2171,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	}
 	if (role.level_promoted && (level <= vcpu->arch.mmu->root_level))
 		role.level_promoted = 0;
+	if (role.pae_root && (level < PT32E_ROOT_LEVEL))
+		role.pae_root = 0;
 
 	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
@@ -2226,14 +2308,27 @@ static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
 	__shadow_walk_next(iterator, *iterator->sptep);
 }
 
+static u64 make_pae_pdpte(u64 *child_pt)
+{
+	u64 spte = __pa(child_pt) | PT_PRESENT_MASK;
+
+	/* The only ignore bits in PDPTE are 11:9. */
+	BUILD_BUG_ON(!(GENMASK(11,9) & SPTE_MMU_PRESENT_MASK));
+	return spte | SPTE_MMU_PRESENT_MASK | shadow_me_mask;
+}
+
 static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
 			     struct kvm_mmu_page *sp)
 {
+	struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
 	u64 spte;
 
 	BUILD_BUG_ON(VMX_EPT_WRITABLE_MASK != PT_WRITABLE_MASK);
 
-	spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
+	if (!parent_sp->role.pae_root)
+		spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
+	else
+		spte = make_pae_pdpte(sp->spt);
 
 	mmu_spte_set(sptep, spte);
 
@@ -4733,6 +4828,8 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
 	role.base.direct = true;
 	role.base.has_4_byte_gpte = false;
+	if (role.base.level == PT32E_ROOT_LEVEL)
+		role.base.pae_root = 1;
 
 	return role;
 }
@@ -4798,6 +4895,9 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	else
 		role.base.level = PT64_ROOT_4LEVEL;
 
+	if (!____is_cr0_pg(regs) || !____is_efer_lma(regs))
+		role.base.pae_root = 1;
+
 	return role;
 }
 
@@ -4845,6 +4945,8 @@ kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
 	if (role.base.level > role_regs_to_root_level(regs))
 		role.base.level_promoted = 1;
+	if (role.base.level == PT32E_ROOT_LEVEL)
+		role.base.pae_root = 1;
 
 	return role;
 }
@@ -6133,6 +6235,10 @@ int kvm_mmu_module_init(void)
 	if (ret)
 		goto out;
 
+	ret = alloc_default_pae_pdpte();
+	if (ret)
+		goto out;
+
 	return 0;
 
 out:
@@ -6174,6 +6280,7 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 
 void kvm_mmu_module_exit(void)
 {
+	free_default_pae_pdpte();
 	mmu_destroy_caches();
 	percpu_counter_destroy(&kvm_total_used_mmu_pages);
 	unregister_shrinker(&mmu_shrinker);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 16ac276d342a..014136e15b26 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1044,6 +1044,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		.access = 0x7,
 		.quadrant = 0x3,
 		.level_promoted = 0x1,
+		.pae_root = 0x1,
 	};
 
 	/*
-- 
2.19.1.6.gb485710b

