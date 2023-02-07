Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C438168DD73
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 16:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbjBGP50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 10:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbjBGP5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 10:57:08 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E89744B8;
        Tue,  7 Feb 2023 07:56:50 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 203so11056364pfx.6;
        Tue, 07 Feb 2023 07:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l44WGxeGJgAySirL6qry2zKnKy2AnsVDG7wbNgoTUKk=;
        b=cfna03S4XwiQ7DIvqL9ZM2rlnjXulPlyzfMzN4YRuoSzKSPOMSQEzQ6hKWW+jbQvgF
         puGJNcezJmFBg4MToF2+rqMOaDlPBUULR1MAuiG4zQ9c8j7lWcv+8S3XMjk7pDJxNjaI
         mSURSW08Db40o0AxBT9v/jZB8FLqmFz/41G8F8j42XRoTdlRLV1xz9r0KvK5Ssbu1KhX
         Ji4OsmtF3IUzeshDyyCPsmtMADRPeqvbPm1Dsy3wURXVeFdeOe9XOU9wzoeoUUs6AjUN
         kSEF8aofOVBMg+kYKotbCxsWwnuES8jTvdPJirjKHFR+ilhcKMFXGdJGfnHAF7xkmtR0
         vzxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l44WGxeGJgAySirL6qry2zKnKy2AnsVDG7wbNgoTUKk=;
        b=OWl4MbwrE7RubDqvL5Xq+J999W9shcCiF/CDttEbCqeQ7Ef+uAAFjTI44fbr7nQLI6
         ZeEt166anlkgcpTCOT2Kk6S53HQ92OIXxQUm5Xa5YTrSBcfFO9y9qi5ZxPx9swwLOIq7
         FZle0CCoQ45Jnxuk1QRXHFQdHccvOFc2s/nz6m6S/bMKgA1gF/2fBezJ99Wja01gMlug
         4PiCNU5KUPZ19Ddvxrl0m2OY1wB5uJnKT36AM1A7akAf36w/oBBqXRH54Z4CV1g/i40T
         n7nBVmJwYVPn/z3UeQHfkAzL+E2WyNMZsRIqcM6OUvd4zMft99NGum816TYVCs/1aFvE
         t9og==
X-Gm-Message-State: AO0yUKXd/fBWH0WNW2XhlvVspjCOp+UREunSKmvZyVGN/g3VK7W38Znz
        4K6RYUW3LpKPGUqr5NL23tmKol+CSZA=
X-Google-Smtp-Source: AK7set+EeT0jtMXWyonRDnBGhAPBQpPE3/p/FzUf9gjRLTLIra7oyE0gsGwMAi1pkndK+lnmHAG2sQ==
X-Received: by 2002:a62:79c4:0:b0:593:c648:f836 with SMTP id u187-20020a6279c4000000b00593c648f836mr3719990pfc.3.1675785399661;
        Tue, 07 Feb 2023 07:56:39 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id c8-20020aa78c08000000b0059071156016sm7162573pfd.87.2023.02.07.07.56.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Feb 2023 07:56:39 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V2 5/8] kvm: x86/mmu: Move the code out of FNAME(sync_page)'s loop body into mmu.c
Date:   Tue,  7 Feb 2023 23:57:31 +0800
Message-Id: <20230207155735.2845-6-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230207155735.2845-1-jiangshanlai@gmail.com>
References: <20230207155735.2845-1-jiangshanlai@gmail.com>
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

Rename mmu->sync_page to mmu->sync_spte and move the code out
of FNAME(sync_page)'s loop body into mmu.c.

No functionalities change intended.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/kvm/mmu/mmu.c          |  64 +++++++++++++--
 arch/x86/kvm/mmu/paging_tmpl.h  | 139 +++++++++++---------------------
 3 files changed, 106 insertions(+), 101 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 81429a5640d6..6c64ebfbd778 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -441,8 +441,8 @@ struct kvm_mmu {
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			    gpa_t gva_or_gpa, u64 access,
 			    struct x86_exception *exception);
-	int (*sync_page)(struct kvm_vcpu *vcpu,
-			 struct kvm_mmu_page *sp);
+	int (*sync_spte)(struct kvm_vcpu *vcpu,
+			 struct kvm_mmu_page *sp, int i);
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
 	struct kvm_mmu_root_info root;
 	union kvm_cpu_role cpu_role;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e30ca652f6ff..c271d0a1ed54 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1908,10 +1908,62 @@ static bool sp_has_gptes(struct kvm_mmu_page *sp)
 	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
 		if ((_sp)->gfn != (_gfn) || !sp_has_gptes(_sp)) {} else
 
+static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+{
+	union kvm_mmu_page_role root_role = vcpu->arch.mmu->root_role;
+	bool flush = false;
+	int i;
+
+	/*
+	 * Ignore various flags when verifying that it's safe to sync a shadow
+	 * page using the current MMU context.
+	 *
+	 *  - level: not part of the overall MMU role and will never match as the MMU's
+	 *           level tracks the root level
+	 *  - access: updated based on the new guest PTE
+	 *  - quadrant: not part of the overall MMU role (similar to level)
+	 */
+	const union kvm_mmu_page_role sync_role_ign = {
+		.level = 0xf,
+		.access = 0x7,
+		.quadrant = 0x3,
+		.passthrough = 0x1,
+	};
+
+	/*
+	 * Direct pages can never be unsync, and KVM should never attempt to
+	 * sync a shadow page for a different MMU context, e.g. if the role
+	 * differs then the memslot lookup (SMM vs. non-SMM) will be bogus, the
+	 * reserved bits checks will be wrong, etc...
+	 */
+	if (WARN_ON_ONCE(sp->role.direct ||
+			 (sp->role.word ^ root_role.word) & ~sync_role_ign.word))
+		return -1;
+
+	for (i = 0; i < SPTE_ENT_PER_PAGE; i++) {
+		int ret = vcpu->arch.mmu->sync_spte(vcpu, sp, i);
+
+		if (ret < -1)
+			return -1;
+		flush |= ret;
+	}
+
+	/*
+	 * Note, any flush is purely for KVM's correctness, e.g. when dropping
+	 * an existing SPTE or clearing W/A/D bits to ensure an mmu_notifier
+	 * unmap or dirty logging event doesn't fail to flush.  The guest is
+	 * responsible for flushing the TLB to ensure any changes in protection
+	 * bits are recognized, i.e. until the guest flushes or page faults on
+	 * a relevant address, KVM is architecturally allowed to let vCPUs use
+	 * cached translations with the old protection bits.
+	 */
+	return flush;
+}
+
 static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			 struct list_head *invalid_list)
 {
-	int ret = vcpu->arch.mmu->sync_page(vcpu, sp);
+	int ret = __kvm_sync_page(vcpu, sp);
 
 	if (ret < 0)
 		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
@@ -4463,7 +4515,7 @@ static void nonpaging_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = nonpaging_page_fault;
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
-	context->sync_page = NULL;
+	context->sync_spte = NULL;
 	context->invlpg = NULL;
 }
 
@@ -5054,7 +5106,7 @@ static void paging64_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = paging64_page_fault;
 	context->gva_to_gpa = paging64_gva_to_gpa;
-	context->sync_page = paging64_sync_page;
+	context->sync_spte = paging64_sync_spte;
 	context->invlpg = paging64_invlpg;
 }
 
@@ -5062,7 +5114,7 @@ static void paging32_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = paging32_page_fault;
 	context->gva_to_gpa = paging32_gva_to_gpa;
-	context->sync_page = paging32_sync_page;
+	context->sync_spte = paging32_sync_spte;
 	context->invlpg = paging32_invlpg;
 }
 
@@ -5151,7 +5203,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	context->cpu_role.as_u64 = cpu_role.as_u64;
 	context->root_role.word = root_role.word;
 	context->page_fault = kvm_tdp_page_fault;
-	context->sync_page = NULL;
+	context->sync_spte = NULL;
 	context->invlpg = NULL;
 	context->get_guest_pgd = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
@@ -5283,7 +5335,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 
 		context->page_fault = ept_page_fault;
 		context->gva_to_gpa = ept_gva_to_gpa;
-		context->sync_page = ept_sync_page;
+		context->sync_spte = ept_sync_spte;
 		context->invlpg = ept_invlpg;
 
 		update_permission_bitmask(context, true);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 57f0b75c80f9..5ab9e974fdac 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -977,114 +977,67 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
  *   can't change unless all sptes pointing to it are nuked first.
  *
  * Returns
- * < 0: the sp should be zapped
- *   0: the sp is synced and no tlb flushing is required
- * > 0: the sp is synced and tlb flushing is required
+ * < 0: failed to sync spte
+ *   0: the spte is synced and no tlb flushing is required
+ * > 0: the spte is synced and tlb flushing is required
  */
-static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int i)
 {
-	union kvm_mmu_page_role root_role = vcpu->arch.mmu->root_role;
-	int i;
 	bool host_writable;
 	gpa_t first_pte_gpa;
-	bool flush = false;
-
-	/*
-	 * Ignore various flags when verifying that it's safe to sync a shadow
-	 * page using the current MMU context.
-	 *
-	 *  - level: not part of the overall MMU role and will never match as the MMU's
-	 *           level tracks the root level
-	 *  - access: updated based on the new guest PTE
-	 *  - quadrant: not part of the overall MMU role (similar to level)
-	 */
-	const union kvm_mmu_page_role sync_role_ign = {
-		.level = 0xf,
-		.access = 0x7,
-		.quadrant = 0x3,
-		.passthrough = 0x1,
-	};
+	u64 *sptep, spte;
+	struct kvm_memory_slot *slot;
+	unsigned pte_access;
+	pt_element_t gpte;
+	gpa_t pte_gpa;
+	gfn_t gfn;
 
-	/*
-	 * Direct pages can never be unsync, and KVM should never attempt to
-	 * sync a shadow page for a different MMU context, e.g. if the role
-	 * differs then the memslot lookup (SMM vs. non-SMM) will be bogus, the
-	 * reserved bits checks will be wrong, etc...
-	 */
-	if (WARN_ON_ONCE(sp->role.direct ||
-			 (sp->role.word ^ root_role.word) & ~sync_role_ign.word))
-		return -1;
+	if (!sp->spt[i])
+		return 0;
 
 	first_pte_gpa = FNAME(get_level1_sp_gpa)(sp);
+	pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
 
-	for (i = 0; i < SPTE_ENT_PER_PAGE; i++) {
-		u64 *sptep, spte;
-		struct kvm_memory_slot *slot;
-		unsigned pte_access;
-		pt_element_t gpte;
-		gpa_t pte_gpa;
-		gfn_t gfn;
-
-		if (!sp->spt[i])
-			continue;
-
-		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
-
-		if (kvm_vcpu_read_guest_atomic(vcpu, pte_gpa, &gpte,
-					       sizeof(pt_element_t)))
-			return -1;
-
-		if (FNAME(prefetch_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte)) {
-			flush = true;
-			continue;
-		}
+	if (kvm_vcpu_read_guest_atomic(vcpu, pte_gpa, &gpte,
+				       sizeof(pt_element_t)))
+		return -1;
 
-		gfn = gpte_to_gfn(gpte);
-		pte_access = sp->role.access;
-		pte_access &= FNAME(gpte_access)(gpte);
-		FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
+	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte))
+		return 1;
 
-		if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
-			continue;
+	gfn = gpte_to_gfn(gpte);
+	pte_access = sp->role.access;
+	pte_access &= FNAME(gpte_access)(gpte);
+	FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
 
-		/*
-		 * Drop the SPTE if the new protections would result in a RWX=0
-		 * SPTE or if the gfn is changing.  The RWX=0 case only affects
-		 * EPT with execute-only support, i.e. EPT without an effective
-		 * "present" bit, as all other paging modes will create a
-		 * read-only SPTE if pte_access is zero.
-		 */
-		if ((!pte_access && !shadow_present_mask) ||
-		    gfn != kvm_mmu_page_get_gfn(sp, i)) {
-			drop_spte(vcpu->kvm, &sp->spt[i]);
-			flush = true;
-			continue;
-		}
+	if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
+		return 0;
 
-		/* Update the shadowed access bits in case they changed. */
-		kvm_mmu_page_set_access(sp, i, pte_access);
+	/*
+	 * Drop the SPTE if the new protections would result in a RWX=0
+	 * SPTE or if the gfn is changing.  The RWX=0 case only affects
+	 * EPT with execute-only support, i.e. EPT without an effective
+	 * "present" bit, as all other paging modes will create a
+	 * read-only SPTE if pte_access is zero.
+	 */
+	if ((!pte_access && !shadow_present_mask) ||
+	    gfn != kvm_mmu_page_get_gfn(sp, i)) {
+		drop_spte(vcpu->kvm, &sp->spt[i]);
+		return 1;
+	}
 
-		sptep = &sp->spt[i];
-		spte = *sptep;
-		host_writable = spte & shadow_host_writable_mask;
-		slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-		make_spte(vcpu, sp, slot, pte_access, gfn,
-			  spte_to_pfn(spte), spte, true, false,
-			  host_writable, &spte);
+	/* Update the shadowed access bits in case they changed. */
+	kvm_mmu_page_set_access(sp, i, pte_access);
 
-		flush |= mmu_spte_update(sptep, spte);
-	}
+	sptep = &sp->spt[i];
+	spte = *sptep;
+	host_writable = spte & shadow_host_writable_mask;
+	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	make_spte(vcpu, sp, slot, pte_access, gfn,
+		  spte_to_pfn(spte), spte, true, false,
+		  host_writable, &spte);
 
-	/*
-	 * Note, any flush is purely for KVM's correctness, e.g. when dropping
-	 * an existing SPTE or clearing W/A/D bits to ensure an mmu_notifier
-	 * unmap or dirty logging event doesn't fail to flush.  The guest is
-	 * responsible for flushing the TLB to ensure any changes in protection
-	 * bits are recognized, i.e. until the guest flushes or page faults on
-	 * a relevant address, KVM is architecturally allowed to let vCPUs use
-	 * cached translations with the old protection bits.
-	 */
-	return flush;
+	return mmu_spte_update(sptep, spte);
 }
 
 #undef pt_element_t
-- 
2.19.1.6.gb485710b

