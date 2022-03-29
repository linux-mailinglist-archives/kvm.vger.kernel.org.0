Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5574EB0C4
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 17:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238269AbiC2Phe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 11:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238851AbiC2Ph0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 11:37:26 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF6225667B;
        Tue, 29 Mar 2022 08:35:42 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id h19so15227441pfv.1;
        Tue, 29 Mar 2022 08:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7J0hAZ+76i4t5nkDrXP5ltSgXTZne12nv3FBQdb+CYA=;
        b=Y9kPkFicdNqYgPSzkGxTsuZkhUm78b0EuoKZbKn8GrNG0X9SOgUmiJP9NoTjeRvXxd
         WySF8g2dMUfo1l0Jszg+pMzbPNFnkzUb5YLeHVa1t34Y0Ddm7U67Lziw9U3eIZTJWJNr
         YYcCwy0+RJHnKLaUKK8UqCMtYw6lJ0aONPXEG3PBahblpnH2Blb1opbd6XWS8w4okbws
         V9/NhfvXztKGUhllynD6YtKY3OV1KMC7hua/VrLjutDyvgqUTgWoP/lq9nxYAumh7uF/
         hf3Dg6Ony/0fQK8Vji1Rdw2LP3WQ5fI0o9J/9N/VrCkYnL05PxLlSWtmbl/PBVAKdhma
         ky6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7J0hAZ+76i4t5nkDrXP5ltSgXTZne12nv3FBQdb+CYA=;
        b=LPEycr0u342Egknm3jwe2cqynWYGCYdwa45y3IcVDljL3F3ntf6XE3gjo9+H+7YQna
         I3PSgFhaI5wrQnQ73D6Bfayl0BLyMGerczll6S8ch965ZnpwwNiJDFK8FeUFiijWhYtK
         fGJC7wp5J72CTc/7Sm5YICtK05h5pcxQ94ZBAZ8lp2Yt+65iglDt8m7ixg5yEvR36ffq
         a9qqBkiuJJl2e7RvNtSLqC2OqHyciztbODEfkCWSdHU44Mk7NfOseQP9689yXaIEWrwA
         Nx7v/+jbZ/fK9qCWuJqDHHuAsaskjKIFynx0kBhkiLTfVTrCoTxHb65cHSboyWtKYwl5
         ZdFQ==
X-Gm-Message-State: AOAM532TaYj+h8SfnFBdwzTTFjwwEckzREK1AmjTT7+yw5c4DqkQ8BYv
        0A/MCaxaBgTssTJ/e0Id2vjP4CFPVRE=
X-Google-Smtp-Source: ABdhPJxFtsGrhjQEKYK1Ov8/M2YQa+kPtM/4I6Xx3o5I/eIrx3co/l6pPxF8SkqFe6QERN3rDcPbnw==
X-Received: by 2002:a63:43c4:0:b0:381:10:45b8 with SMTP id q187-20020a6343c4000000b00381001045b8mr2387667pga.588.1648568142011;
        Tue, 29 Mar 2022 08:35:42 -0700 (PDT)
Received: from localhost ([47.251.3.230])
        by smtp.gmail.com with ESMTPSA id f16-20020a056a001ad000b004fb358ffe86sm12047553pfv.137.2022.03.29.08.35.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Mar 2022 08:35:41 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
Subject: [RFC PATCH V2 3/4] KVM: X86: Alloc role.pae_root shadow page
Date:   Tue, 29 Mar 2022 23:36:03 +0800
Message-Id: <20220329153604.507475-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220329153604.507475-1-jiangshanlai@gmail.com>
References: <20220329153604.507475-1-jiangshanlai@gmail.com>
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

Currently pae_root is special root page, this patch adds facility to
allow using kvm_mmu_get_page() to allocate pae_root shadow page.

When kvm_mmu_get_page() is called for role.level == PT32E_ROOT_LEVEL and
vcpu->arch.mmu->shadow_root_level == PT32E_ROOT_LEVEL, it will get a
PAE root pagetable and set role.pae_root=1 for freeing.

The role.pae_root bit is needed in the page role because:
  o PAE roots must be allocated below 4gb (for kvm_mmu_get_page())
  o PAE roots can not be encrypted (for kvm_mmu_get_page())
  o Must be re-encrypted when freeing (for kvm_mmu_free_page())
  o PAE root's PDPTE is special (for link_shadow_page())
  o Not share the decrypted low-address pagetable with non-PAE-root
    ones or vice verse. (for kvm_mmu_get_page(), the crucial reason)

Both role.pae_root in link_shadow_page() and in kvm_mmu_get_page() can
be possible changed to use shadow_root_level and role.level instead.

But in kvm_mmu_free_page(), it can't use vcpu->arch.mmu->shadow_root_level.

PAE roots must be allocated below 4gb (CR3 has only 32 bits).  So a
cache is introduced (mmu_pae_root_cache).

No functionality changed since this code is not activated because when
vcpu->arch.mmu->shadow_root_level == PT32E_ROOT_LEVEL, kvm_mmu_get_page()
is only called for level == 1 or 2 now.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 Documentation/virt/kvm/mmu.rst  |  2 +
 arch/x86/include/asm/kvm_host.h |  9 +++-
 arch/x86/kvm/mmu/mmu.c          | 78 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/paging_tmpl.h  |  1 +
 4 files changed, 86 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/mmu.rst b/Documentation/virt/kvm/mmu.rst
index 60c4057ef625..dbeb6462c6b0 100644
--- a/Documentation/virt/kvm/mmu.rst
+++ b/Documentation/virt/kvm/mmu.rst
@@ -207,6 +207,8 @@ Shadow pages contain the following information:
     larger than guest paging level; passthrough shadow page tables must
     be created on the top. Like when role.has_4_byte_gpte or shadow NPT
     for 32 bit L1 or 5-level shadow NPT for 4-level NPT L1.
+  role.pae_root:
+    Is 1 if it is a PAE root.
   gfn:
     Either the guest page table containing the translations shadowed by this
     page, or the base page frame for linear translations.  See role.direct.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1e6bf563b939..bc31c0104eca 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -313,6 +313,11 @@ struct kvm_kernel_irq_routing_entry;
  *   - on top of this, smep_andnot_wp and smap_andnot_wp are only set if
  *     cr0_wp=0, therefore these three bits only give rise to 5 possibilities.
  *
+ *   - pae_root can only be set when level=3, so combinations for level and
+ *     pae_root can be seen as 2/3/3-page_root/4/5, a.k.a 5 possibilities.
+ *     Combined with cr0_wp, smep_andnot_wp and smap_andnot_wp, it will be
+ *     5X5 = 25 < 2^5.
+ *
  * Therefore, the maximum number of possible upper-level shadow pages for a
  * single gfn is a bit less than 2^14.
  */
@@ -332,7 +337,8 @@ union kvm_mmu_page_role {
 		unsigned ad_disabled:1;
 		unsigned guest_mode:1;
 		unsigned passthrough:1;
-		unsigned :5;
+		unsigned pae_root:1;
+		unsigned :4;
 
 		/*
 		 * This is left at the top of the word so that
@@ -699,6 +705,7 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
 	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
+	void *mmu_pae_root_cache;
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 54c7db7c9608..42046bff3c49 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -694,6 +694,35 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	}
 }
 
+static int mmu_topup_pae_root_cache(struct kvm_vcpu *vcpu)
+{
+	struct page *page;
+
+	if (vcpu->arch.mmu->shadow_root_level != PT32E_ROOT_LEVEL)
+		return 0;
+	if (vcpu->arch.mmu_pae_root_cache)
+		return 0;
+
+	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_DMA32);
+	if (!page)
+		return -ENOMEM;
+	vcpu->arch.mmu_pae_root_cache = page_address(page);
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
+		set_memory_decrypted((unsigned long)vcpu->arch.mmu_pae_root_cache, 1);
+	else
+		WARN_ON_ONCE(shadow_me_mask);
+	return 0;
+}
+
 static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 {
 	int r;
@@ -705,6 +734,9 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 		return r;
 	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
 				       PT64_ROOT_MAX_LEVEL);
+	if (r)
+		return r;
+	r = mmu_topup_pae_root_cache(vcpu);
 	if (r)
 		return r;
 	if (maybe_indirect) {
@@ -717,12 +749,23 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 					  PT64_ROOT_MAX_LEVEL);
 }
 
+static void mmu_free_pae_root(void *root_pt)
+{
+	if (!tdp_enabled)
+		set_memory_encrypted((unsigned long)root_pt, 1);
+	free_page((unsigned long)root_pt);
+}
+
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
+	if (vcpu->arch.mmu_pae_root_cache) {
+		mmu_free_pae_root(vcpu->arch.mmu_pae_root_cache);
+		vcpu->arch.mmu_pae_root_cache = NULL;
+	}
 }
 
 static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
@@ -1681,7 +1724,10 @@ static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
 	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
 	list_del(&sp->link);
-	free_page((unsigned long)sp->spt);
+	if (sp->role.pae_root)
+		mmu_free_pae_root(sp->spt);
+	else
+		free_page((unsigned long)sp->spt);
 	free_page((unsigned long)sp->gfns);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
@@ -1719,7 +1765,12 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 	struct kvm_mmu_page *sp;
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	if (!role.pae_root) {
+		sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	} else {
+		sp->spt = vcpu->arch.mmu_pae_root_cache;
+		vcpu->arch.mmu_pae_root_cache = NULL;
+	}
 	if (!role.direct && !role.passthrough)
 		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
@@ -2063,6 +2114,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	}
 	if (level <= vcpu->arch.mmu->root_level)
 		role.passthrough = 0;
+	if (level != PT32E_ROOT_LEVEL)
+		role.pae_root = 0;
 
 	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
@@ -2198,14 +2251,26 @@ static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
 	__shadow_walk_next(iterator, *iterator->sptep);
 }
 
+static u64 make_pae_pdpte(u64 *child_pt)
+{
+	/* The only ignore bits in PDPTE are 11:9. */
+	BUILD_BUG_ON(!(GENMASK(11,9) & SPTE_MMU_PRESENT_MASK));
+	return __pa(child_pt) | PT_PRESENT_MASK | SPTE_MMU_PRESENT_MASK |
+		shadow_me_mask;
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
 
@@ -4781,6 +4846,8 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
 	role.base.direct = true;
 	role.base.has_4_byte_gpte = false;
+	if (role.base.level == PT32E_ROOT_LEVEL)
+		role.base.pae_root = 1;
 
 	return role;
 }
@@ -4846,6 +4913,9 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	else
 		role.base.level = PT64_ROOT_4LEVEL;
 
+	if (role.base.level == PT32E_ROOT_LEVEL)
+		role.base.pae_root = 1;
+
 	return role;
 }
 
@@ -4893,6 +4963,8 @@ kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
 	if (role.base.level > role_regs_to_root_level(regs))
 		role.base.passthrough = 1;
+	if (role.base.level == PT32E_ROOT_LEVEL)
+		role.base.pae_root = 1;
 
 	return role;
 }
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index c1b975fb85a2..2062ac25b7e5 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1043,6 +1043,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		.access = 0x7,
 		.quadrant = 0x3,
 		.passthrough = 0x1,
+		.pae_root = 0x1,
 	};
 
 	/*
-- 
2.19.1.6.gb485710b

