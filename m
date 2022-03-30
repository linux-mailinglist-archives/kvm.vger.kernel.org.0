Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8DB4EC583
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 15:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345939AbiC3NX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 09:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345945AbiC3NXX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 09:23:23 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6033849258;
        Wed, 30 Mar 2022 06:21:32 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id t2so18666674pfj.10;
        Wed, 30 Mar 2022 06:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8nw22u+xHMe9fEPa90YlblMBN0qhe5TLiCzKqkUTaPk=;
        b=DGTDb2piuMNSX1ocTvi3AgZ/zh/nZgXbI1NmaBMNFkyNFHFe87oL8m3+25F8Ikpox+
         rSuMgxRb1BqcIavmW45SICWb0Y1by0mxVPKMi0VAvI6KSc6ta3UNl0GnDHICTMVrYKTv
         OREwfevpS0zD9+v3JFN9mmRRldzMXToModiCtR7/W7/Uq4ykBL5dPwFecdRbjMnhl07T
         BTH1qqJvc/E9ZJ2RA3i/ewSADD+hTaSccvnVAJTQZtzaLx5sAodP2YNMWbwYm8iIY0IH
         AXolyffPAd4jxSFZKP5ph9350Z6akdlSZ/JmdVaCrlekOQkffAfeomkCg3zz9/FfSfrf
         sryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8nw22u+xHMe9fEPa90YlblMBN0qhe5TLiCzKqkUTaPk=;
        b=WUjXAMcJydBgBd5fmVMVBUovw+cc3IC4tkmjs/mPZxsQA5J9DJGjnUFlUX/fyNjxDt
         adIEM6byGi3TGY38eZFe1aPS5C6BI4K73uFC1+JyPFwCWDAwWvQATvrAcfvstPC1WUOx
         OVktmaF7Q2VT4nZKuOzI6U1iG79twJaUVQvTnrcU8We8ej2OJP2JiTNwC/9jthtxL3mF
         seYdi7FU1A96Vj5SZstT45AestRg8AryorSAvxIPtJNXhzUHH8zZhzidGyCGGbEvkqs9
         mR7dwjDS4NtokAi/z3K+x7STi9oMwSj3fOQ4IAzXuDKSRGCuotMZg4F5TM0l2X22l7hE
         gjOg==
X-Gm-Message-State: AOAM533GfB/eI0TvWRJcJQqA7lRTzDza6PQHwD6yCHRjNavL1tcES7hW
        NrbeWI1D+KHB/e7mFbzLCNoe6IV7UUo=
X-Google-Smtp-Source: ABdhPJz7oQNtfn+VtdgpdE1iMMIo/rzxa/gB6z+S92MZdUmP63OJ/qYU2hRbag2b+u4RaQm68ZOUgg==
X-Received: by 2002:a05:6a00:2887:b0:4fa:e10c:7ca with SMTP id ch7-20020a056a00288700b004fae10c07camr32963153pfb.9.1648646491590;
        Wed, 30 Mar 2022 06:21:31 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id h6-20020a056a00218600b004f65315bb37sm25254776pfi.13.2022.03.30.06.21.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Mar 2022 06:21:31 -0700 (PDT)
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
Subject: [RFC PATCH V3 4/4] KVM: X86: Use passthrough and pae_root shadow page for 32bit guests
Date:   Wed, 30 Mar 2022 21:21:52 +0800
Message-Id: <20220330132152.4568-5-jiangshanlai@gmail.com>
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

Use role.pae_root = 1 for shadow_root_level == 3 no matter if it is
shadow MMU or not.

When it is shadow MMU, level expansion might occur and use passthrough
sp (0 < role.glevel < role.level) for expanded shadow pagetable.

And remove the unneeded special roots.  Now all the root pages and
pagetable pointed by a present spte in kvm_mmu are backed by struct
kvm_mmu_page, and to_shadow_page() is guaranteed to be not NULL.

shadow_walk() and the intialization of shadow page are much simplified
since there is not special roots.

Affect cases:
direct mmu (nonpaping for 32 bit guest):
	gCR0_PG=0 (pae_root=1)
shadow mmu (shadow paping for 32 bit guest):
	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=0 (pae_root=1,passthrough)
	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=1 (pae_root=1,no passthrough)
direct mmu (NPT for 32bit host):
	hEFER_LMA=0 (pae_root=1)
shadow nested NPT (for 32bit L1 hypervisor):
	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=0,hEFER_LMA=0
		(pae_root=1,passthrough)
	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=1,hEFER_LMA=0
		(pae_root=1,no passthrough)
	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE={0|1},hEFER_LMA=1,hCR4_LA57={0|1}
		(pae_root=0,passthrough)
		(default_pae_pdpte is not used even guest is using PAE paging)

Shadow nested NPT for 64bit L1 hypervisor has been already handled:
	gEFER_LMA=1,gCR4_LA57=0,hEFER_LMA=1,hCR4_LA57=1
		(pae_root=0,passthrough)

FNAME(walk_addr_generic) adds initialization code for shadow nested NPT
for 32bit L1 hypervisor when the level increment might be more than one,
for example, 2->4, 2->5, 3->5.

After this patch, the PAE Page-Directory-Pointer-Table is also write
protected (including NPT's).

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h |   4 -
 arch/x86/kvm/mmu/mmu.c          | 290 +-------------------------------
 arch/x86/kvm/mmu/paging_tmpl.h  |  13 +-
 3 files changed, 20 insertions(+), 287 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 658c493e7617..26aab4418844 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -467,10 +467,6 @@ struct kvm_mmu {
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
index 81ccaa7c1165..27498caa3990 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2196,26 +2196,6 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
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
-		BUG_ON(root != vcpu->arch.mmu->root.hpa);
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
@@ -3328,18 +3308,7 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 					   &invalid_list);
 
 	if (free_active_root) {
-		if (to_shadow_page(mmu->root.hpa)) {
-			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
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
+		mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
 		mmu->root.hpa = INVALID_PAGE;
 		mmu->root.pgd = 0;
 	}
@@ -3404,7 +3373,6 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	u8 shadow_root_level = mmu->shadow_root_level;
 	hpa_t root;
-	unsigned i;
 	int r;
 
 	write_lock(&vcpu->kvm->mmu_lock);
@@ -3415,24 +3383,9 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	if (is_tdp_mmu_enabled(vcpu->kvm)) {
 		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
 		mmu->root.hpa = root;
-	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
+	} else if (shadow_root_level >= PT32E_ROOT_LEVEL) {
 		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
 		mmu->root.hpa = root;
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
-		mmu->root.hpa = __pa(mmu->pae_root);
 	} else {
 		WARN_ONCE(1, "Bad TDP root level = %d\n", shadow_root_level);
 		r = -EIO;
@@ -3510,10 +3463,8 @@ static int mmu_first_shadow_root_alloc(struct kvm *kvm)
 static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	u64 pdptrs[4], pm_mask;
 	gfn_t root_gfn, root_pgd;
 	hpa_t root;
-	unsigned i;
 	int r;
 
 	root_pgd = mmu->get_guest_pgd(vcpu);
@@ -3522,21 +3473,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
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
@@ -3546,70 +3482,9 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	if (r < 0)
 		goto out_unlock;
 
-	/*
-	 * Do we shadow a long mode page table? If so we need to
-	 * write-protect the guests page table root.
-	 */
-	if (mmu->root_level >= PT64_ROOT_4LEVEL) {
-		root = mmu_alloc_root(vcpu, root_gfn, 0,
-				      mmu->shadow_root_level, false);
-		mmu->root.hpa = root;
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
-		mmu->root.hpa = __pa(mmu->pml5_root);
-	else if (mmu->shadow_root_level == PT64_ROOT_4LEVEL)
-		mmu->root.hpa = __pa(mmu->pml4_root);
-	else
-		mmu->root.hpa = __pa(mmu->pae_root);
-
-set_root_pgd:
+	root = mmu_alloc_root(vcpu, root_gfn, 0,
+			      mmu->shadow_root_level, false);
+	mmu->root.hpa = root;
 	mmu->root.pgd = root_pgd;
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
@@ -3617,77 +3492,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	return r;
 }
 
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
-}
-
 static bool is_unsync_root(hpa_t root)
 {
 	struct kvm_mmu_page *sp;
@@ -3725,8 +3529,7 @@ static bool is_unsync_root(hpa_t root)
 
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 {
-	int i;
-	struct kvm_mmu_page *sp;
+	hpa_t root = vcpu->arch.mmu->root.hpa;
 
 	if (vcpu->arch.mmu->direct_map)
 		return;
@@ -3736,31 +3539,11 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 
 	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
 
-	if (vcpu->arch.mmu->root_level >= PT64_ROOT_4LEVEL) {
-		hpa_t root = vcpu->arch.mmu->root.hpa;
-		sp = to_shadow_page(root);
-
-		if (!is_unsync_root(root))
-			return;
-
-		write_lock(&vcpu->kvm->mmu_lock);
-		mmu_sync_children(vcpu, sp, true);
-		write_unlock(&vcpu->kvm->mmu_lock);
+	if (!is_unsync_root(root))
 		return;
-	}
 
 	write_lock(&vcpu->kvm->mmu_lock);
-
-	for (i = 0; i < 4; ++i) {
-		hpa_t root = vcpu->arch.mmu->pae_root[i];
-
-		if (IS_VALID_PAE_ROOT(root)) {
-			root &= PT64_BASE_ADDR_MASK;
-			sp = to_shadow_page(root);
-			mmu_sync_children(vcpu, sp, true);
-		}
-	}
-
+	mmu_sync_children(vcpu, to_shadow_page(root), true);
 	write_unlock(&vcpu->kvm->mmu_lock);
 }
 
@@ -5162,9 +4945,6 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	int r;
 
 	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->direct_map);
-	if (r)
-		goto out;
-	r = mmu_alloc_special_roots(vcpu);
 	if (r)
 		goto out;
 	if (vcpu->arch.mmu->direct_map)
@@ -5635,65 +5415,14 @@ slot_handle_level_4k(struct kvm *kvm, const struct kvm_memory_slot *memslot,
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
 	return 0;
 }
 
@@ -5722,7 +5451,6 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 
 	return ret;
  fail_allocate_root:
-	free_mmu_pages(&vcpu->arch.guest_mmu);
 	return ret;
 }
 
@@ -6363,8 +6091,6 @@ int kvm_mmu_module_init(void)
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);
-	free_mmu_pages(&vcpu->arch.root_mmu);
-	free_mmu_pages(&vcpu->arch.guest_mmu);
 	mmu_free_memory_caches(vcpu);
 }
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 1015f33e0758..62a762bbcf87 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -365,6 +365,16 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	pte           = mmu->get_guest_pgd(vcpu);
 	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
 
+	/* kvm_mmu_get_page() might use this values for allocating passthrough
+	 * shadow page.
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
-- 
2.19.1.6.gb485710b

