Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12EB752FCC5
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 15:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355165AbiEUNQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 09:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355128AbiEUNQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 09:16:35 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721D238BD8;
        Sat, 21 May 2022 06:16:28 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id bh5so9419394plb.6;
        Sat, 21 May 2022 06:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0z0tRb7fboYayLeEmCjTFMrxW3XxALefbwdIJM3o4iA=;
        b=j7tNbojTr/+MF/Mk5laDX+qJN8vHKJ1gbw6wSm+c+0u1Phj4fu17V2w6MEq4+PSYeL
         MbQe7/63rzzoL8vQseiLIZ99fsNUfI4KycxMMpc52Gq1Ly2jRxNG7L+aqymkNpdbv7z+
         OXaTNOg67t4S8aWHT4PyoG7etHN9LR1AcknA32HYuNwuV8CgoxebqEF2+nK2mQ0/+QKf
         3Efd+OOmlX3f80JGMxx1LJFJRT6UOOgF8sW1ZaMQNw4fj1g//CmyTOVATWLiNh84pS9E
         7wH0Zx0NnolEDWLaU2ziyJWsSWKVV32zcJoJes8wHr+pe/JXJWBrdY/QtUIemiJinMUM
         4EtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0z0tRb7fboYayLeEmCjTFMrxW3XxALefbwdIJM3o4iA=;
        b=XexNAuJ8qatZrQQfwAsi10bpAPv7bhJ8dxYjAR3L5Vdajcz4PvERyG0KP5aozjtJKN
         2G5gqFDBeQbUPrJN0OEhtPUaXc63bZDhpIdYj8t4TVEHp8r33Ybh7TGsfqqDmO31dobM
         P7Z+n0b4+tJsNTSCb3WU+Cqvw/gIF8Vl8V2BFOTGhQ3kQYVkRfvNydzMIW+Tp9rdl/g7
         X+665smZzL9u5pe2/Aij/9PPlqzGWlC+HA9E+J5WfKuQDA1sgCeOXv+ptW4G/9oZBpT4
         gGsSyBhRmri5YTwAb4yfL0PJekRFZ4/BnwPBOxC5x5WravUbXzwQG/qAVQIvuKSM64le
         n50Q==
X-Gm-Message-State: AOAM5339zKTu4WiyYWaUUzjxUb0js/UfcuxAgRMJhz9vuc+z45TMveMZ
        faKq111IUzqSC2yCdOoGJbh9kRbVOpU=
X-Google-Smtp-Source: ABdhPJx1SROWfEALAt6sG6SUmqwnN+gIzU9RM0hQoUdJtYdlwVTYj6kRl4USTkGsGeaodNHAKnfbfA==
X-Received: by 2002:a17:90b:380d:b0:1dc:8dc2:bb2c with SMTP id mq13-20020a17090b380d00b001dc8dc2bb2cmr16791741pjb.236.1653138987236;
        Sat, 21 May 2022 06:16:27 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id u5-20020a170902b28500b00161d28d62f8sm1546107plr.84.2022.05.21.06.16.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 May 2022 06:16:27 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH V3 06/12] KVM: X86/MMU: Activate local shadow pages and remove old logic
Date:   Sat, 21 May 2022 21:16:54 +0800
Message-Id: <20220521131700.3661-7-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220521131700.3661-1-jiangshanlai@gmail.com>
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
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

Activate local shadow pages by allocate local shadow pages in
mmu_alloc_direct_roots() and mmu_alloc_shadow_roots().

Make shadow walkings walk from the topmost shadow page even it is
local shadow page so that they can be walked like normal root
and shadowed PDPTEs can be made and installed on-demand.

Walking from the topmost causes FNAME(fetch) needs to visit high level
local shadow pages and allocate local shadow pages when shadowing
NPT for 32bit L1 in 64bit host, so change FNAME(fetch) and
FNAME(walk_addr_generic) to handle it for affected code.

Do sync from the topmost in kvm_mmu_sync_roots() and simplifies
the code.

Now all the root pages and pagetable pointed by a present spte in
struct kvm_mmu are associated by struct kvm_mmu_page, and
to_shadow_page() is guaranteed to be not NULL.

Affect cases are those that using_local_root_page() return true.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c         | 174 +++------------------------------
 arch/x86/kvm/mmu/paging_tmpl.h |  18 +++-
 2 files changed, 31 insertions(+), 161 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e1a059dd9621..684a0221aa4c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1691,9 +1691,9 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 }
 
 /*
- * KVM uses the VCPU's local root page (vcpu->mmu->pae_root) when either the
- * shadow pagetable is using PAE paging or the host is shadowing nested NPT for
- * 32bit L1 hypervisor.
+ * KVM uses the VCPU's local root page (kvm_mmu_alloc_local_shadow_page()) when
+ * either the shadow pagetable is using PAE paging or the host is shadowing
+ * nested NPT for 32bit L1 hypervisor.
  *
  * It includes cases:
  *	nonpaging when !tdp_enabled				(direct paging)
@@ -2277,26 +2277,6 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 	iterator->addr = addr;
 	iterator->shadow_addr = root;
 	iterator->level = vcpu->arch.mmu->root_role.level;
-
-	if (iterator->level >= PT64_ROOT_4LEVEL &&
-	    vcpu->arch.mmu->cpu_role.base.level < PT64_ROOT_4LEVEL &&
-	    !vcpu->arch.mmu->root_role.direct)
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
@@ -3491,21 +3471,10 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 					   &invalid_list);
 
 	if (free_active_root) {
-		if (to_shadow_page(mmu->root.hpa)) {
-			if (using_local_root_page(mmu))
-				mmu_free_local_root_page(kvm, mmu);
-			else
-				mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
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
+		if (using_local_root_page(mmu))
+			mmu_free_local_root_page(kvm, mmu);
+		else
+			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
 		mmu->root.hpa = INVALID_PAGE;
 		mmu->root.pgd = 0;
 	}
@@ -3570,7 +3539,6 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	u8 shadow_root_level = mmu->root_role.level;
 	hpa_t root;
-	unsigned i;
 	int r;
 
 	write_lock(&vcpu->kvm->mmu_lock);
@@ -3581,24 +3549,9 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
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
@@ -3676,10 +3629,8 @@ static int mmu_first_shadow_root_alloc(struct kvm *kvm)
 static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	u64 pdptrs[4], pm_mask;
 	gfn_t root_gfn, root_pgd;
 	hpa_t root;
-	unsigned i;
 	int r;
 
 	root_pgd = mmu->get_guest_pgd(vcpu);
@@ -3688,21 +3639,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	if (mmu_check_root(vcpu, root_gfn))
 		return 1;
 
-	/*
-	 * On SVM, reading PDPTRs might access guest memory, which might fault
-	 * and thus might sleep.  Grab the PDPTRs before acquiring mmu_lock.
-	 */
-	if (mmu->cpu_role.base.level == PT32E_ROOT_LEVEL) {
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
@@ -3712,70 +3648,9 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	if (r < 0)
 		goto out_unlock;
 
-	/*
-	 * Do we shadow a long mode page table? If so we need to
-	 * write-protect the guests page table root.
-	 */
-	if (mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
-		root = mmu_alloc_root(vcpu, root_gfn, 0,
-				      mmu->root_role.level, false);
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
-	pm_mask = PT_PRESENT_MASK | shadow_me_value;
-	if (mmu->root_role.level >= PT64_ROOT_4LEVEL) {
-		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
-
-		if (WARN_ON_ONCE(!mmu->pml4_root)) {
-			r = -EIO;
-			goto out_unlock;
-		}
-		mmu->pml4_root[0] = __pa(mmu->pae_root) | pm_mask;
-
-		if (mmu->root_role.level == PT64_ROOT_5LEVEL) {
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
-		if (mmu->cpu_role.base.level == PT32E_ROOT_LEVEL) {
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
-	if (mmu->root_role.level == PT64_ROOT_5LEVEL)
-		mmu->root.hpa = __pa(mmu->pml5_root);
-	else if (mmu->root_role.level == PT64_ROOT_4LEVEL)
-		mmu->root.hpa = __pa(mmu->pml4_root);
-	else
-		mmu->root.hpa = __pa(mmu->pae_root);
-
-set_root_pgd:
+	root = mmu_alloc_root(vcpu, root_gfn, 0,
+			      mmu->root_role.level, false);
+	mmu->root.hpa = root;
 	mmu->root.pgd = root_pgd;
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
@@ -3892,8 +3767,7 @@ static bool is_unsync_root(hpa_t root)
 
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 {
-	int i;
-	struct kvm_mmu_page *sp;
+	hpa_t root = vcpu->arch.mmu->root.hpa;
 
 	if (vcpu->arch.mmu->root_role.direct)
 		return;
@@ -3903,31 +3777,11 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 
 	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
 
-	if (vcpu->arch.mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
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
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 6e3df84e8455..cd6032e1947c 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -316,6 +316,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	u16 errcode = 0;
 	gpa_t real_gpa;
 	gfn_t gfn;
+	int i;
 
 	trace_kvm_mmu_pagetable_walk(addr, access);
 retry_walk:
@@ -323,6 +324,20 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	pte           = mmu->get_guest_pgd(vcpu);
 	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
 
+	/*
+	 * Initialize the guest walker with default values.  These values will
+	 * be used in cases where KVM shadows a guest page table structure
+	 * with more levels than what the guest.  For example, KVM shadows
+	 * 3-level nested NPT for 32 bit L1 with 5-level NPT paging.
+	 *
+	 * Note, the gfn is technically ignored for these local shadow pages,
+	 * but it's more consistent to always pass 0 to kvm_mmu_get_page().
+	 */
+	for (i = PT32_ROOT_LEVEL; i < PT_MAX_FULL_LEVELS; i++) {
+		walker->table_gfn[i] = 0;
+		walker->pt_access[i] = ACC_ALL;
+	}
+
 #if PTTYPE == 64
 	walk_nx_mask = 1ULL << PT64_NX_SHIFT;
 	if (walker->level == PT32E_ROOT_LEVEL) {
@@ -675,7 +690,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
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

