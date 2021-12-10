Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895AE46FDB0
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 10:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239422AbhLJJ3W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 04:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239483AbhLJJ3R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 04:29:17 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E90C0698C8;
        Fri, 10 Dec 2021 01:25:30 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so7817621pjj.0;
        Fri, 10 Dec 2021 01:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uR+UlOcOA3baKsq2NGn/fMmHPthil1kGOJ2nua40D1c=;
        b=MZCMYsTEwldk7+vBNcxl6MEFkD6zhpb5d4zZzc0bI0EhuHaAZfsk46ZPbA6H0jrCHN
         Ok0xTGckFLlNDVE9iqpQAIfwl7KpwQrwMAPL3/mCvRJbTvYHNIfZz51p4lGwAijerpne
         ZBq7lSuycpp6LCl9yJNvLCadk+XqoTWRmNzaCm4sf3AUiaVnjTFRAms6W8F9HFURGaSh
         NL7JElVvIuBCka0xRMuy7GO2XcOLg0bDmRlUXQw/73hL1cj6ML4LiORFwqRL1CcmLH+K
         LuEAyb0gpWIu6/kORAmZL7N49D6wKzr+Sg2maP6mvINIFUbDD1HBcBHJPdJhkIlUE2e6
         NGaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uR+UlOcOA3baKsq2NGn/fMmHPthil1kGOJ2nua40D1c=;
        b=bABAw984U7jwrzjI5o53qNz8X/6Mza/jb5uMinTb1qUWnaDmvD7BDknEjKeyizysRl
         DmrR+rqjvzXAc5TtjFQYP85FZHlGOCM/5LtQfblpVBNl6YMhgnA4vrg56i8LO+YLKF8q
         TRwg/aV/3st85OyYOwUJmsgUKFzUUGRFYtryCDa/ZKx+Y7pLcjnkGn/UKC2azwK0IT2W
         o4tKiHBan6oBNCfqBIM9ffqsbUCYOihakYDKWcPU6CW10q6YljGE6vPwkZEQRBoq4cqR
         u4LbwyIvM620GbXuEQ7Tght2a/R/bZ52tVE2bBq50vpBj66kGE+pDGCv6Oxlgkbv8vwK
         GQlw==
X-Gm-Message-State: AOAM530556JrJ/ft1R3A6hOBPT5+VeLxB20MdcHRV9RxfWVlg+LqnZWk
        Rpzr1w/0/emH32Fw6xOOEo4dRiu9IcI=
X-Google-Smtp-Source: ABdhPJzhtPT+TjuUC+A7APLQnBGShZk+g83JalckmljTosDxATmLQ1PI4XOx4H1fGsimiCLWYseEBg==
X-Received: by 2002:a17:90b:1b06:: with SMTP id nu6mr22287238pjb.155.1639128329977;
        Fri, 10 Dec 2021 01:25:29 -0800 (PST)
Received: from localhost ([47.251.3.230])
        by smtp.gmail.com with ESMTPSA id c137sm2451000pfb.49.2021.12.10.01.25.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 01:25:29 -0800 (PST)
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
Subject: [RFC PATCH 6/6] KVM: X86: Use level_promoted and pae_root shadow page for 32bit guests
Date:   Fri, 10 Dec 2021 17:25:08 +0800
Message-Id: <20211210092508.7185-7-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211210092508.7185-1-jiangshanlai@gmail.com>
References: <20211210092508.7185-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Use role.pae_root = 1 for shadow_root_level == 3 no matter if it is
shadow MMU or if the level is promoted.

Use role.level_promoted = 1 for promoted shadow page if it is shadow
MMU and the level is promoted.

And remove the unneeded special roots.  Now all the root pages and
pagetable pointed by a present spte in kvm_mmu are backed by struct
kvm_mmu_page, and to_shadow_page() is guaranteed to be not NULL.

shadow_walk() and the intialization of shadow page are much simplied
since there is not special roots.

Affect cases:
direct mmu (nonpaping for 32 bit guest):
	gCR0_PG=0 (pae_root=1)
shadow mmu (shadow paping for 32 bit guest):
	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=0 (pae_root=1,level_promoted=1)
	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=1 (pae_root=1,level_promoted=0)
direct mmu (NPT for 32bit host):
	hEFER_LMA=0 (pae_root=1)
shadow nested NPT (for 32bit L1 hypervisor):
	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=0,hEFER_LMA=0
		(pae_root=1,level_promoted=1)
	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=1,hEFER_LMA=0
		(pae_root=1,level_promoted=0)
	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE={0|1},hEFER_LMA=1,hCR4_LA57={0|1}
		(pae_root=0,level_promoted=1)
		(default_pae_pdpte is not used even guest is using PAE paging)

Shadow nested NPT for 64bit L1 hypervisor has been already handled:
	gEFER_LMA=1,gCR4_LA57=0,hEFER_LMA=1,hCR4_LA57=1
		(pae_root=0,level_promoted=1)

FNAME(walk_addr_generic) adds initialization code for shadow nested NPT
for 32bit L1 hypervisor when the level increment might be more than one,
for example, 2->4, 2->5, 3->5.

After this patch, the PAE Page-Directory-Pointer-Table is also write
protected (including NPT's).

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/include/asm/kvm_host.h |   4 -
 arch/x86/kvm/mmu/mmu.c          | 302 ++------------------------------
 arch/x86/kvm/mmu/mmu_audit.c    |  23 +--
 arch/x86/kvm/mmu/paging_tmpl.h  |  13 +-
 arch/x86/kvm/mmu/tdp_mmu.h      |   7 +-
 5 files changed, 30 insertions(+), 319 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 82a8844f80ac..d4ab6f53ab00 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -466,10 +466,6 @@ struct kvm_mmu {
 	*/
 	u32 pkru_mask;
 
-	u64 *pae_root;
-	u64 *pml4_root;
-	u64 *pml5_root;
-
 	/*
 	 * check zero bits on shadow page table entries, these
 	 * bits include not only hardware reserved bits but also
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0d2976dad863..fd2bc851b700 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2252,26 +2252,6 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 	iterator->addr = addr;
 	iterator->shadow_addr = root;
 	iterator->level = vcpu->arch.mmu->shadow_root_level;
-
-	if (iterator->level >= PT64_ROOT_4LEVEL &&
-	    vcpu->arch.mmu->root_level < PT64_ROOT_4LEVEL &&
-	    !vcpu->arch.mmu->direct_map)
-		iterator->level = PT32E_ROOT_LEVEL;
-
-	if (iterator->level == PT32E_ROOT_LEVEL) {
-		/*
-		 * prev_root is currently only used for 64-bit hosts. So only
-		 * the active root_hpa is valid here.
-		 */
-		BUG_ON(root != vcpu->arch.mmu->root_hpa);
-
-		iterator->shadow_addr
-			= vcpu->arch.mmu->pae_root[(addr >> 30) & 3];
-		iterator->shadow_addr &= PT64_BASE_ADDR_MASK;
-		--iterator->level;
-		if (!iterator->shadow_addr)
-			iterator->level = 0;
-	}
 }
 
 static void shadow_walk_init(struct kvm_shadow_walk_iterator *iterator,
@@ -3375,19 +3355,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 					   &invalid_list);
 
 	if (free_active_root) {
-		if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
-		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
-			mmu_free_root_page(kvm, &mmu->root_hpa, &invalid_list);
-		} else if (mmu->pae_root) {
-			for (i = 0; i < 4; ++i) {
-				if (!IS_VALID_PAE_ROOT(mmu->pae_root[i]))
-					continue;
-
-				mmu_free_root_page(kvm, &mmu->pae_root[i],
-						   &invalid_list);
-				mmu->pae_root[i] = INVALID_PAE_ROOT;
-			}
-		}
+		mmu_free_root_page(kvm, &mmu->root_hpa, &invalid_list);
 		mmu->root_hpa = INVALID_PAGE;
 		mmu->root_pgd = 0;
 	}
@@ -3452,7 +3420,6 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	u8 shadow_root_level = mmu->shadow_root_level;
 	hpa_t root;
-	unsigned i;
 	int r;
 
 	write_lock(&vcpu->kvm->mmu_lock);
@@ -3463,24 +3430,9 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	if (is_tdp_mmu_enabled(vcpu->kvm)) {
 		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
 		mmu->root_hpa = root;
-	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
+	} else if (shadow_root_level >= PT32E_ROOT_LEVEL) {
 		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
 		mmu->root_hpa = root;
-	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
-		if (WARN_ON_ONCE(!mmu->pae_root)) {
-			r = -EIO;
-			goto out_unlock;
-		}
-
-		for (i = 0; i < 4; ++i) {
-			WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
-
-			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
-					      i << 30, PT32_ROOT_LEVEL, true);
-			mmu->pae_root[i] = root | PT_PRESENT_MASK |
-					   shadow_me_mask;
-		}
-		mmu->root_hpa = __pa(mmu->pae_root);
 	} else {
 		WARN_ONCE(1, "Bad TDP root level = %d\n", shadow_root_level);
 		r = -EIO;
@@ -3558,10 +3510,8 @@ static int mmu_first_shadow_root_alloc(struct kvm *kvm)
 static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	u64 pdptrs[4], pm_mask;
 	gfn_t root_gfn, root_pgd;
 	hpa_t root;
-	unsigned i;
 	int r;
 
 	root_pgd = mmu->get_guest_pgd(vcpu);
@@ -3570,21 +3520,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	if (mmu_check_root(vcpu, root_gfn))
 		return 1;
 
-	/*
-	 * On SVM, reading PDPTRs might access guest memory, which might fault
-	 * and thus might sleep.  Grab the PDPTRs before acquiring mmu_lock.
-	 */
-	if (mmu->root_level == PT32E_ROOT_LEVEL) {
-		for (i = 0; i < 4; ++i) {
-			pdptrs[i] = mmu->get_pdptr(vcpu, i);
-			if (!(pdptrs[i] & PT_PRESENT_MASK))
-				continue;
-
-			if (mmu_check_root(vcpu, pdptrs[i] >> PAGE_SHIFT))
-				return 1;
-		}
-	}
-
 	r = mmu_first_shadow_root_alloc(vcpu->kvm);
 	if (r)
 		return r;
@@ -3594,146 +3529,14 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	if (r < 0)
 		goto out_unlock;
 
-	/*
-	 * Do we shadow a long mode page table? If so we need to
-	 * write-protect the guests page table root.
-	 */
-	if (mmu->root_level >= PT64_ROOT_4LEVEL) {
-		root = mmu_alloc_root(vcpu, root_gfn, 0,
-				      mmu->shadow_root_level, false);
-		mmu->root_hpa = root;
-		goto set_root_pgd;
-	}
-
-	if (WARN_ON_ONCE(!mmu->pae_root)) {
-		r = -EIO;
-		goto out_unlock;
-	}
-
-	/*
-	 * We shadow a 32 bit page table. This may be a legacy 2-level
-	 * or a PAE 3-level page table. In either case we need to be aware that
-	 * the shadow page table may be a PAE or a long mode page table.
-	 */
-	pm_mask = PT_PRESENT_MASK | shadow_me_mask;
-	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
-		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
-
-		if (WARN_ON_ONCE(!mmu->pml4_root)) {
-			r = -EIO;
-			goto out_unlock;
-		}
-		mmu->pml4_root[0] = __pa(mmu->pae_root) | pm_mask;
-
-		if (mmu->shadow_root_level == PT64_ROOT_5LEVEL) {
-			if (WARN_ON_ONCE(!mmu->pml5_root)) {
-				r = -EIO;
-				goto out_unlock;
-			}
-			mmu->pml5_root[0] = __pa(mmu->pml4_root) | pm_mask;
-		}
-	}
-
-	for (i = 0; i < 4; ++i) {
-		WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
-
-		if (mmu->root_level == PT32E_ROOT_LEVEL) {
-			if (!(pdptrs[i] & PT_PRESENT_MASK)) {
-				mmu->pae_root[i] = INVALID_PAE_ROOT;
-				continue;
-			}
-			root_gfn = pdptrs[i] >> PAGE_SHIFT;
-		}
-
-		root = mmu_alloc_root(vcpu, root_gfn, i << 30,
-				      PT32_ROOT_LEVEL, false);
-		mmu->pae_root[i] = root | pm_mask;
-	}
-
-	if (mmu->shadow_root_level == PT64_ROOT_5LEVEL)
-		mmu->root_hpa = __pa(mmu->pml5_root);
-	else if (mmu->shadow_root_level == PT64_ROOT_4LEVEL)
-		mmu->root_hpa = __pa(mmu->pml4_root);
-	else
-		mmu->root_hpa = __pa(mmu->pae_root);
-
-set_root_pgd:
+	root = mmu_alloc_root(vcpu, root_gfn, 0,
+			      mmu->shadow_root_level, false);
+	mmu->root_hpa = root;
 	mmu->root_pgd = root_pgd;
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
 
-	return 0;
-}
-
-static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
-{
-	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	bool need_pml5 = mmu->shadow_root_level > PT64_ROOT_4LEVEL;
-	u64 *pml5_root = NULL;
-	u64 *pml4_root = NULL;
-	u64 *pae_root;
-
-	/*
-	 * When shadowing 32-bit or PAE NPT with 64-bit NPT, the PML4 and PDP
-	 * tables are allocated and initialized at root creation as there is no
-	 * equivalent level in the guest's NPT to shadow.  Allocate the tables
-	 * on demand, as running a 32-bit L1 VMM on 64-bit KVM is very rare.
-	 */
-	if (mmu->direct_map || mmu->root_level >= PT64_ROOT_4LEVEL ||
-	    mmu->shadow_root_level < PT64_ROOT_4LEVEL)
-		return 0;
-
-	/*
-	 * NPT, the only paging mode that uses this horror, uses a fixed number
-	 * of levels for the shadow page tables, e.g. all MMUs are 4-level or
-	 * all MMus are 5-level.  Thus, this can safely require that pml5_root
-	 * is allocated if the other roots are valid and pml5 is needed, as any
-	 * prior MMU would also have required pml5.
-	 */
-	if (mmu->pae_root && mmu->pml4_root && (!need_pml5 || mmu->pml5_root))
-		return 0;
-
-	/*
-	 * The special roots should always be allocated in concert.  Yell and
-	 * bail if KVM ends up in a state where only one of the roots is valid.
-	 */
-	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->pml4_root ||
-			 (need_pml5 && mmu->pml5_root)))
-		return -EIO;
-
-	/*
-	 * Unlike 32-bit NPT, the PDP table doesn't need to be in low mem, and
-	 * doesn't need to be decrypted.
-	 */
-	pae_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
-	if (!pae_root)
-		return -ENOMEM;
-
-#ifdef CONFIG_X86_64
-	pml4_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
-	if (!pml4_root)
-		goto err_pml4;
-
-	if (need_pml5) {
-		pml5_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
-		if (!pml5_root)
-			goto err_pml5;
-	}
-#endif
-
-	mmu->pae_root = pae_root;
-	mmu->pml4_root = pml4_root;
-	mmu->pml5_root = pml5_root;
-
-	return 0;
-
-#ifdef CONFIG_X86_64
-err_pml5:
-	free_page((unsigned long)pml4_root);
-err_pml4:
-	free_page((unsigned long)pae_root);
-	return -ENOMEM;
-#endif
+	return r;
 }
 
 static bool is_unsync_root(hpa_t root)
@@ -3765,46 +3568,23 @@ static bool is_unsync_root(hpa_t root)
 
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 {
-	int i;
-	struct kvm_mmu_page *sp;
+	hpa_t root = vcpu->arch.mmu->root_hpa;
 
 	if (vcpu->arch.mmu->direct_map)
 		return;
 
-	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
+	if (!VALID_PAGE(root))
 		return;
 
 	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
 
-	if (vcpu->arch.mmu->root_level >= PT64_ROOT_4LEVEL) {
-		hpa_t root = vcpu->arch.mmu->root_hpa;
-		sp = to_shadow_page(root);
-
-		if (!is_unsync_root(root))
-			return;
-
-		write_lock(&vcpu->kvm->mmu_lock);
-		kvm_mmu_audit(vcpu, AUDIT_PRE_SYNC);
-
-		mmu_sync_children(vcpu, sp, true);
-
-		kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
-		write_unlock(&vcpu->kvm->mmu_lock);
+	if (!is_unsync_root(root))
 		return;
-	}
 
 	write_lock(&vcpu->kvm->mmu_lock);
 	kvm_mmu_audit(vcpu, AUDIT_PRE_SYNC);
 
-	for (i = 0; i < 4; ++i) {
-		hpa_t root = vcpu->arch.mmu->pae_root[i];
-
-		if (IS_VALID_PAE_ROOT(root)) {
-			root &= PT64_BASE_ADDR_MASK;
-			sp = to_shadow_page(root);
-			mmu_sync_children(vcpu, sp, true);
-		}
-	}
+	mmu_sync_children(vcpu, to_shadow_page(root), true);
 
 	kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
 	write_unlock(&vcpu->kvm->mmu_lock);
@@ -4895,8 +4675,11 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	else
 		role.base.level = PT64_ROOT_4LEVEL;
 
-	if (!____is_cr0_pg(regs) || !____is_efer_lma(regs))
+	if (!____is_cr0_pg(regs) || !____is_efer_lma(regs)) {
 		role.base.pae_root = 1;
+		if (____is_cr0_pg(regs) && !____is_cr4_pse(regs))
+			role.base.level_promoted = 1;
+	}
 
 	return role;
 }
@@ -5161,9 +4944,6 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	int r;
 
 	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->direct_map);
-	if (r)
-		goto out;
-	r = mmu_alloc_special_roots(vcpu);
 	if (r)
 		goto out;
 	if (vcpu->arch.mmu->direct_map)
@@ -5580,65 +5360,14 @@ slot_handle_level_4k(struct kvm *kvm, const struct kvm_memory_slot *memslot,
 				 PG_LEVEL_4K, flush_on_yield);
 }
 
-static void free_mmu_pages(struct kvm_mmu *mmu)
-{
-	if (!tdp_enabled && mmu->pae_root)
-		set_memory_encrypted((unsigned long)mmu->pae_root, 1);
-	free_page((unsigned long)mmu->pae_root);
-	free_page((unsigned long)mmu->pml4_root);
-	free_page((unsigned long)mmu->pml5_root);
-}
-
 static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 {
-	struct page *page;
 	int i;
 
 	mmu->root_hpa = INVALID_PAGE;
 	mmu->root_pgd = 0;
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
 	return 0;
 }
 
@@ -5667,7 +5396,6 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 
 	return ret;
  fail_allocate_root:
-	free_mmu_pages(&vcpu->arch.guest_mmu);
 	return ret;
 }
 
@@ -6273,8 +6001,6 @@ unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm)
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);
-	free_mmu_pages(&vcpu->arch.root_mmu);
-	free_mmu_pages(&vcpu->arch.guest_mmu);
 	mmu_free_memory_caches(vcpu);
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
index 6bbbf85b3e46..f5e8dabe13bf 100644
--- a/arch/x86/kvm/mmu/mmu_audit.c
+++ b/arch/x86/kvm/mmu/mmu_audit.c
@@ -53,31 +53,14 @@ static void __mmu_spte_walk(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 
 static void mmu_spte_walk(struct kvm_vcpu *vcpu, inspect_spte_fn fn)
 {
-	int i;
+	hpa_t root = vcpu->arch.mmu->root_hpa;
 	struct kvm_mmu_page *sp;
 
 	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
 		return;
 
-	if (vcpu->arch.mmu->root_level >= PT64_ROOT_4LEVEL) {
-		hpa_t root = vcpu->arch.mmu->root_hpa;
-
-		sp = to_shadow_page(root);
-		__mmu_spte_walk(vcpu, sp, fn, vcpu->arch.mmu->shadow_root_level);
-		return;
-	}
-
-	for (i = 0; i < 4; ++i) {
-		hpa_t root = vcpu->arch.mmu->pae_root[i];
-
-		if (IS_VALID_PAE_ROOT(root)) {
-			root &= PT64_BASE_ADDR_MASK;
-			sp = to_shadow_page(root);
-			__mmu_spte_walk(vcpu, sp, fn, 2);
-		}
-	}
-
-	return;
+	sp = to_shadow_page(root);
+	__mmu_spte_walk(vcpu, sp, fn, vcpu->arch.mmu->shadow_root_level);
 }
 
 typedef void (*sp_handler) (struct kvm *kvm, struct kvm_mmu_page *sp);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 014136e15b26..d71b562bf8f0 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -365,6 +365,16 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	pte           = mmu->get_guest_pgd(vcpu);
 	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
 
+	/* kvm_mmu_get_page() will uses this values for allocating level
+	 * promoted shadow page.
+	 */
+	walker->table_gfn[4] = gpte_to_gfn(pte);
+	walker->pt_access[4] = ACC_ALL;
+	walker->table_gfn[3] = gpte_to_gfn(pte);
+	walker->pt_access[3] = ACC_ALL;
+	walker->table_gfn[2] = gpte_to_gfn(pte);
+	walker->pt_access[2] = ACC_ALL;
+
 #if PTTYPE == 64
 	walk_nx_mask = 1ULL << PT64_NX_SHIFT;
 	if (walker->level == PT32E_ROOT_LEVEL) {
@@ -710,7 +720,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		 * Verify that the gpte in the page we've just write
 		 * protected is still there.
 		 */
-		if (FNAME(gpte_changed)(vcpu, gw, it.level - 1))
+		if (it.level - 1 < top_level &&
+		    FNAME(gpte_changed)(vcpu, gw, it.level - 1))
 			goto out_gpte_changed;
 
 		if (sp)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 476b133544dd..822ff5d76b91 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -100,13 +100,8 @@ static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
 	if (WARN_ON(!VALID_PAGE(hpa)))
 		return false;
 
-	/*
-	 * A NULL shadow page is legal when shadowing a non-paging guest with
-	 * PAE paging, as the MMU will be direct with root_hpa pointing at the
-	 * pae_root page, not a shadow page.
-	 */
 	sp = to_shadow_page(hpa);
-	return sp && is_tdp_mmu_page(sp) && sp->root_count;
+	return is_tdp_mmu_page(sp) && sp->root_count;
 }
 #else
 static inline bool kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return false; }
-- 
2.19.1.6.gb485710b

