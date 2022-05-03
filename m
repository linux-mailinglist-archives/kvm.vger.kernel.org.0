Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230035187E9
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 17:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237883AbiECPLG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 11:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237838AbiECPLD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 11:11:03 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD893A711;
        Tue,  3 May 2022 08:07:24 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d17so2213162plg.0;
        Tue, 03 May 2022 08:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AFjKf7LIIV9bqkSfkyb0Gk99B+UCSeheppRzUjzdwAs=;
        b=K0xJzzo4KtnKlnx+vjzZ81BqWzcL5nAJjuYugJQaIqP9NIvvTSR2vNAWVJjqW+04F3
         scr+EEsLAIm7zi5r8yBcw2ZybdPAEqOu46RrH+HJXQYMWXe1ieoPOa7xTcEvSxQ5EwuL
         LK+wz5PqtDZZKRucXU3VVOkTa9naWU+h9CL/nXd54cuOdyLD0IVuam2A0HIyGyeXuKZE
         PXfmnJhmsCElXphvbfJpSFWGNkWW6J25z54PntDORmcAgSimKVWmhLVqE7Pq9GDn5Chr
         S1lTzNgyZlT41SmxxZkaAhbn52hu5PqvlL1An3bdozIL/QoYYoN5vidOkDZVS+THuKAs
         O5pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AFjKf7LIIV9bqkSfkyb0Gk99B+UCSeheppRzUjzdwAs=;
        b=8JZZTK6SAfDbU/Cyrhl7+DpIf74QL/KXIqZdIX9yEgyJeCu1I5U7VT2ADvfADJG1kM
         y6UNG9QBQW32Hv3oW2lAy4aXWrln7vaqCO+7boPoZOm1DrWO9qFf95cihZKLLT72w8PQ
         wyR79Y7CiVAZUXcrYGdZZRE2bgHs1fu4ywxGp44rakOJUd7Vao4uYlZwCsVkLAeAs0uT
         807QzBf/Qn8TbQWReCQbhBI90b95pu4esgwJGVjuJzIeZ+3gMBgmv6zIDW7rBb7gUg9W
         tFxjd4VnAWIzA7AcKHC/OJ9AoI5mUUq4M0+EO6fyKVCFXKDGBF1L4E2KegVfha4KJJYK
         D0Gg==
X-Gm-Message-State: AOAM5324AO2Nbf145snBenCrYbcUsNKr7j6GZ/ERWb7oOV3gKzMmgMTj
        rBCVkjqRMip49ZP7/YUHcC/rInV3Na4=
X-Google-Smtp-Source: ABdhPJzoJV9SGSC8eyz9eKiMFuDNF/NsGOVk20jcw7EUUKVxnv7qg2FJYOpzJYqBcXUOJniJiIx1nA==
X-Received: by 2002:a17:902:ec83:b0:15e:b5d2:a81b with SMTP id x3-20020a170902ec8300b0015eb5d2a81bmr3970886plg.64.1651590443899;
        Tue, 03 May 2022 08:07:23 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id k15-20020a170902ce0f00b0015e8d4eb286sm6466299plg.208.2022.05.03.08.07.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 May 2022 08:07:23 -0700 (PDT)
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
Subject: [PATCH V2 4/7] KVM: X86/MMU: Activate special shadow pages and remove old logic
Date:   Tue,  3 May 2022 23:07:32 +0800
Message-Id: <20220503150735.32723-5-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220503150735.32723-1-jiangshanlai@gmail.com>
References: <20220503150735.32723-1-jiangshanlai@gmail.com>
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

Activate special shadow pages by allocate special shadow pages in
mmu_alloc_direct_roots() and mmu_alloc_shadow_roots().

Make shadow walkings walk from the topmost shadow page even it is
special shadow page so that they can be walked like normal root
and shadowed PDPTEs can be made and installed on-demand.

Walking from the topmost causes FNAME(fetch) needs to visit high level
special shadow pages and allocate special shadow pages when shadowing
NPT for 32bit L1 in 64bit host, so change FNAME(fetch) and
FNAME(walk_addr_generic) to handle it for affected code.

Do sync from the topmost in kvm_mmu_sync_roots() and simplifies
the code.

Now all the root pages and pagetable pointed by a present spte in
struct kvm_mmu are associated by struct kvm_mmu_page, and
to_shadow_page() is guaranteed to be not NULL.

Affect cases are those that using_special_root_page() return true.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c         | 168 +++------------------------------
 arch/x86/kvm/mmu/paging_tmpl.h |  14 ++-
 2 files changed, 24 insertions(+), 158 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3fe70ad3bda2..6f626d7e8ebb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2214,26 +2214,6 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
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
@@ -3412,21 +3392,10 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 					   &invalid_list);
 
 	if (free_active_root) {
-		if (to_shadow_page(mmu->root.hpa)) {
-			if (using_special_root_page(mmu))
-				mmu_free_special_root_page(kvm, mmu);
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
+		if (using_special_root_page(mmu))
+			mmu_free_special_root_page(kvm, mmu);
+		else
+			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
 		mmu->root.hpa = INVALID_PAGE;
 		mmu->root.pgd = 0;
 	}
@@ -3491,7 +3460,6 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	u8 shadow_root_level = mmu->root_role.level;
 	hpa_t root;
-	unsigned i;
 	int r;
 
 	write_lock(&vcpu->kvm->mmu_lock);
@@ -3502,24 +3470,9 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
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
@@ -3597,10 +3550,8 @@ static int mmu_first_shadow_root_alloc(struct kvm *kvm)
 static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	u64 pdptrs[4], pm_mask;
 	gfn_t root_gfn, root_pgd;
 	hpa_t root;
-	unsigned i;
 	int r;
 
 	root_pgd = mmu->get_guest_pgd(vcpu);
@@ -3609,21 +3560,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
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
@@ -3633,70 +3569,9 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
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
@@ -3813,8 +3688,7 @@ static bool is_unsync_root(hpa_t root)
 
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 {
-	int i;
-	struct kvm_mmu_page *sp;
+	hpa_t root = vcpu->arch.mmu->root.hpa;
 
 	if (vcpu->arch.mmu->root_role.direct)
 		return;
@@ -3824,31 +3698,11 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 
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
index b025decf610d..19ef31a078fa 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -316,6 +316,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	u16 errcode = 0;
 	gpa_t real_gpa;
 	gfn_t gfn;
+	int i;
 
 	trace_kvm_mmu_pagetable_walk(addr, access);
 retry_walk:
@@ -323,6 +324,16 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	pte           = mmu->get_guest_pgd(vcpu);
 	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
 
+	/*
+	 * FNAME(fetch) might pass these values to allocate special shadow
+	 * page.  Although the gfn is not used at the end, it is better not
+	 * to pass an uninitialized value to kvm_mmu_get_page().
+	 */
+	for (i = 2; i < PT_MAX_FULL_LEVELS; i++) {
+		walker->table_gfn[i] = 0;
+		walker->pt_access[i] = ACC_ALL;
+	}
+
 #if PTTYPE == 64
 	walk_nx_mask = 1ULL << PT64_NX_SHIFT;
 	if (walker->level == PT32E_ROOT_LEVEL) {
@@ -675,7 +686,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
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

