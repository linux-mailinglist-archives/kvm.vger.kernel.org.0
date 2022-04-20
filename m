Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6CD508945
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 15:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379023AbiDTN2d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 09:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379021AbiDTN23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 09:28:29 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B073A5D0;
        Wed, 20 Apr 2022 06:25:43 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id mp16-20020a17090b191000b001cb5efbcab6so4937297pjb.4;
        Wed, 20 Apr 2022 06:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0isWlJxIzUtALUF2/VnBGm4wzlo8yeoKRaWXLxTXRxA=;
        b=bwNHlQ3In26IQuqJzrt18tp+VHTyO9poaxqAqFIVIsrVq8oHqq3uDA+Bx6AfQWUpr/
         U/8EqNXBUseVcl5EV5Ovx0iBPYj02mfgP3ezgc0yVuUhb/3YBRvbD8/gTU4COYVi5art
         jlp+tPEMEhIdcpgU5SX2uZFJNsbKaN49SAia6WDRJDeMqW8v0DaoiAV0g1oE3/7y8Zn+
         QaB20iTI8dA9NtJhhDBlKKmO6ruiFuwsqm7PFxN68jGuceLYVqVEYjMKA9FaWFdcMklx
         0RB+SxhVnQiC0XvVyULqWzDJINEkXUH+GoFP53fc/Vnb+Y6zeMi3mmJK/j+AgPvr6DO5
         xskQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0isWlJxIzUtALUF2/VnBGm4wzlo8yeoKRaWXLxTXRxA=;
        b=3Z1R5kWlR6MQodXkcyjURoq49lV3MQu7X7JI/ua/e8jxJFL4LtVAFU8OAqyqnxMlL/
         wCoeri+alFDtDlC0rFtuag+8/YPargHdhb79VIs3A1iaVEcoBDiSXhg0LHmFaUCpIyWV
         KS8rVob4HC9D+Fj/x0K2VPdQZ1ZJHTo9+CeOM5P7/jrSewhUqKa5SThAnhhTuMPLSeu4
         vqOOGFMqTkuELTLS61oG7vQUriXN8ixZKKv3ZcjWuOZ28oVLi5sloehJkhwTcXraIji+
         NniP6+ChJsjojB+hRZKR9Hku7IJ1HYQ0x6U2WTv8j37TfEHMb0wi0vmYsoOnCdX3WpC9
         sPgg==
X-Gm-Message-State: AOAM5319yfl1TS181y+paeAu5kZ+fZmensifAu1z0vOgRcy8h7UmqLdA
        brZdgCgee/S7LQb0JZv6Mi493zX5oC8=
X-Google-Smtp-Source: ABdhPJy+uKO2vZF5E0w1dV8B+mKvYtNfMnjpc61sMHR5+UASUUVdda8I4hvFGV24M4IA1qweRquIlw==
X-Received: by 2002:a17:903:4c:b0:158:8e21:213d with SMTP id l12-20020a170903004c00b001588e21213dmr20732355pla.108.1650461142566;
        Wed, 20 Apr 2022 06:25:42 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004cdccd3da08sm21859421pfl.44.2022.04.20.06.25.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 06:25:42 -0700 (PDT)
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
Subject: [PATCH 4/7] KVM: X86/MMU: Activate special shadow pages and remove old logic
Date:   Wed, 20 Apr 2022 21:26:02 +0800
Message-Id: <20220420132605.3813-5-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220420132605.3813-1-jiangshanlai@gmail.com>
References: <20220420132605.3813-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/mmu/paging_tmpl.h |  15 ++-
 2 files changed, 25 insertions(+), 158 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index eefe1528f91e..3b34a6912081 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2217,26 +2217,6 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
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
@@ -3372,21 +3352,10 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
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
@@ -3451,7 +3420,6 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	u8 shadow_root_level = mmu->shadow_root_level;
 	hpa_t root;
-	unsigned i;
 	int r;
 
 	write_lock(&vcpu->kvm->mmu_lock);
@@ -3462,24 +3430,9 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
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
@@ -3557,10 +3510,8 @@ static int mmu_first_shadow_root_alloc(struct kvm *kvm)
 static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	u64 pdptrs[4], pm_mask;
 	gfn_t root_gfn, root_pgd;
 	hpa_t root;
-	unsigned i;
 	int r;
 
 	root_pgd = mmu->get_guest_pgd(vcpu);
@@ -3569,21 +3520,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
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
@@ -3593,70 +3529,9 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
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
@@ -3772,8 +3647,7 @@ static bool is_unsync_root(hpa_t root)
 
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 {
-	int i;
-	struct kvm_mmu_page *sp;
+	hpa_t root = vcpu->arch.mmu->root.hpa;
 
 	if (vcpu->arch.mmu->direct_map)
 		return;
@@ -3783,31 +3657,11 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 
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
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index c1b975fb85a2..677029b15709 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -365,6 +365,18 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	pte           = mmu->get_guest_pgd(vcpu);
 	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
 
+	/*
+	 * FNAME(fetch) might pass these values to allocate special shadow
+	 * page.  Although the gfn is not used at the end, it is better not
+	 * to pass an uninitialized value to kvm_mmu_get_page().
+	 */
+	walker->table_gfn[4] = 0;
+	walker->pt_access[4] = ACC_ALL;
+	walker->table_gfn[3] = 0;
+	walker->pt_access[3] = ACC_ALL;
+	walker->table_gfn[2] = 0;
+	walker->pt_access[2] = ACC_ALL;
+
 #if PTTYPE == 64
 	walk_nx_mask = 1ULL << PT64_NX_SHIFT;
 	if (walker->level == PT32E_ROOT_LEVEL) {
@@ -710,7 +722,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
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

