Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E7C4EC57C
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 15:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345922AbiC3NXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 09:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345873AbiC3NXM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 09:23:12 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E28848E6C;
        Wed, 30 Mar 2022 06:21:26 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id g9-20020a17090ace8900b001c7cce3c0aeso2087025pju.2;
        Wed, 30 Mar 2022 06:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pDMDEFNEn7HVY/Qsj+Lf/FLfZqskxaYIp4y/ijMrqEY=;
        b=QbEH5L1tWKkSjfeM1+BIBle22GbgK8duSpZvdLvHwmAXU5lip66cJ07vXIftjO9K1Y
         8NeM/0egdKbmJtYC3Nh9JDBs8M33Fv+T3DTLZGPw9G4ZrvS884JEgvZ34K8Lh4Cv4Y84
         QRITD3LlZ5XW2O11yG3/YhDaesW8vLVqUZpu6NmlfobMlBzXzfk5ZGwlKSlQHUsKWNpR
         Vhyh6eT8CWg9jo1MbHx87k4QAX1Kmb4V3idXTTu601nVOzIV/Ns5VUBB+pDrzo5SnDpA
         FZALzFurRyFVYeVGmSQXYxMzspLKNjBGqccFsOHQ4JuZiIyx0WmZWR1x3NJmSyF33IMN
         67vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pDMDEFNEn7HVY/Qsj+Lf/FLfZqskxaYIp4y/ijMrqEY=;
        b=llsfgFgj+r3zswQRnFNz6snOahSFnrA4DJc90aTrer02D5SGpl/RluIRJiSJL2az21
         dvS8G4kRogv5qpG4H/r5U1LeJHjMzn48tuLWnVIJEjcVYb9gSv8cnFcCPTUFPssXMVNT
         60R/8I2GCNWuD30YKQCoM9QHgz+9HBV/SjOq7I5x5gsY9TEMcQuTMG9UUoSIiaaS7drq
         d7lEAwjKopF+rT6B+PcIfXbCJZNXBTz3Jvlpxg/8lAWZ637QFoTZMg1kfTUN2h/GhxAV
         /Z4egCB8KWeYlyr6mg4jpe6O9aIvk0UYWuXzC4syrK+J4dIbxCtwiiYZkkjm/Y75fnug
         3oyg==
X-Gm-Message-State: AOAM530AfKs5ls3tQ2ji3MDHHoJCdMosLgdXZ++ClwmQqvgCQP9vMPu2
        VJlBC+fOGj7PQq/0eqkk3uc8ZaDjc28=
X-Google-Smtp-Source: ABdhPJxQjrVBYb/kYTyNsNGKulkpYWM/GX76kZE9EShtlSwMtwmnuWW+HtAiBX4Apdri2/J1W5uqMg==
X-Received: by 2002:a17:902:c745:b0:153:b0e:8586 with SMTP id q5-20020a170902c74500b001530b0e8586mr34828057plq.9.1648646485418;
        Wed, 30 Mar 2022 06:21:25 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id l6-20020a17090a660600b001c985b0cb53sm6406221pjj.26.2022.03.30.06.21.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Mar 2022 06:21:25 -0700 (PDT)
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
Subject: [RFC PATCH V3 3/4] KVM: X86: Alloc role.pae_root shadow page
Date:   Wed, 30 Mar 2022 21:21:51 +0800
Message-Id: <20220330132152.4568-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220330132152.4568-1-jiangshanlai@gmail.com>
References: <20220330132152.4568-1-jiangshanlai@gmail.com>
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
index dee0e96d694a..800f1eba55b3 100644
--- a/Documentation/virt/kvm/mmu.rst
+++ b/Documentation/virt/kvm/mmu.rst
@@ -209,6 +209,8 @@ Shadow pages contain the following information:
     top with role.glevel = guest paging level and acks as passthrough sp
     and its contents are specially installed rather than the translations
     of the corresponding guest pagetable.
+  role.pae_root:
+    Is 1 if it is a PAE root.
   gfn:
     Either the guest page table containing the translations shadowed by this
     page, or the base page frame for linear translations.  See role.direct.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 67e1bccaf472..658c493e7617 100644
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
  * single gfn is a bit less than 2^15.
  */
@@ -332,7 +337,8 @@ union kvm_mmu_page_role {
 		unsigned ad_disabled:1;
 		unsigned guest_mode:1;
 		unsigned glevel:4;
-		unsigned :2;
+		unsigned pae_root:1;
+		unsigned :1;
 
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
index d53037df8177..81ccaa7c1165 100644
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
@@ -1682,7 +1725,10 @@ static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
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
@@ -1720,7 +1766,12 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 	struct kvm_mmu_page *sp;
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	if (!role.pae_root) {
+		sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	} else {
+		sp->spt = vcpu->arch.mmu_pae_root_cache;
+		vcpu->arch.mmu_pae_root_cache = NULL;
+	}
 	if (role.glevel == role.level)
 		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
@@ -2064,6 +2115,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	}
 	if (level < role.glevel)
 		role.glevel = level;
+	if (level != PT32E_ROOT_LEVEL)
+		role.pae_root = 0;
 
 	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
@@ -2199,14 +2252,26 @@ static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
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
 
@@ -4782,6 +4847,8 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
 	role.base.direct = true;
 	role.base.has_4_byte_gpte = false;
+	if (role.base.level == PT32E_ROOT_LEVEL)
+		role.base.pae_root = 1;
 
 	return role;
 }
@@ -4848,6 +4915,9 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	else
 		role.base.level = PT64_ROOT_4LEVEL;
 
+	if (role.base.level == PT32E_ROOT_LEVEL)
+		role.base.pae_root = 1;
+
 	return role;
 }
 
@@ -4893,6 +4963,8 @@ kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
 
 	role.base.direct = false;
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
+	if (role.base.level == PT32E_ROOT_LEVEL)
+		role.base.pae_root = 1;
 
 	return role;
 }
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 67489a060eba..1015f33e0758 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1043,6 +1043,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		.access = 0x7,
 		.quadrant = 0x3,
 		.glevel = 0xf,
+		.pae_root = 0x1,
 	};
 
 	/*
-- 
2.19.1.6.gb485710b

