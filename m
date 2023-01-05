Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F7365E86C
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 10:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbjAEJ6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 04:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbjAEJ56 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 04:57:58 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A504D551D8;
        Thu,  5 Jan 2023 01:57:57 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id fz16-20020a17090b025000b002269d6c2d83so3272653pjb.0;
        Thu, 05 Jan 2023 01:57:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1FxfyRYzq+eJDXF+P17kPC8+b8A7MrnUUAaDfTct5VU=;
        b=c5GcwudmhpoazZWztrEH2AEr39+EQS2yTtDETqUSp5YBTOO8Xv9YcBkcdlxpYn//XH
         gZNt7GRQusRmr+8p+XVo317JhbR9YfumYrISabC2oMQ3Hx9FQ9/CFGYmnWK1vildiHjh
         OMJM592J6ns0GQ3K1OdqYKfTuCK/6PGIc2h19S0L7ZT74cMLraKJyhLZNFCYd8V7A9/K
         G1b+ycOzcnv+TO6BmbxzKX39tvPrngrq2DYUU3+j5WgySbJQIhufLVPedCF9WEkTEPPJ
         zjYm/n/qR7f22KzND2SQC5Fgk+9s551QqVBoa+h1qpjwSad55uS+A2o4DDmzbPeYfO2v
         v20A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1FxfyRYzq+eJDXF+P17kPC8+b8A7MrnUUAaDfTct5VU=;
        b=33yDQsg8iwrmYX8ChV93rOXogx1CGrBiBEvyizeDntYwG7L+PRO0kYmeQZX+0rrOi3
         +QgzOHZKxMxcfpfej3lF77ae+DMJ9ncWJLZ8e8A425LWjmIlbyNcw0crd5x2eUeHelsr
         uHc6tSeyl1RlCaGWvdvK9bKj05IjnzAni90+Gdek6s0II51o0KjHTp540I+0Ss5TGPDQ
         DPYmnhgOoJ27y8h314EqLaMqWtR2bJonYc2HGy6JFi+Jvh+S3VSRa4/DacFAe/Dyxbwr
         E0w6nADCiNmippudBU7za4LCqqeleFaC8kPyIwKD7tu0+CVYYK4zLoaSDK57y03oF4vI
         +iuA==
X-Gm-Message-State: AFqh2kqPxj3Vp67zCCGhvwr4dlYC/8b6X9LX9FbmjhWfu6Y+mO+aCZny
        QeDrbisdjSlkDR9z+7IiBtqJJXYikls=
X-Google-Smtp-Source: AMrXdXtjczeH3ed9iss5bkxv5zBVFXbHfAPc+fXsYPfxoSFcHtAAi5GDivuZrEGi1kSBqn37IIq+EQ==
X-Received: by 2002:a05:6a21:e385:b0:b3:4044:1503 with SMTP id cc5-20020a056a21e38500b000b340441503mr45652790pzc.52.1672912676725;
        Thu, 05 Jan 2023 01:57:56 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id o11-20020a17090a678b00b0022698aa22d9sm995245pjj.31.2023.01.05.01.57.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Jan 2023 01:57:56 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH 5/7] kvm: x86/mmu: Move the code out of FNAME(sync_page)'s loop body into mmu.c
Date:   Thu,  5 Jan 2023 17:58:46 +0800
Message-Id: <20230105095848.6061-6-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230105095848.6061-1-jiangshanlai@gmail.com>
References: <20230105095848.6061-1-jiangshanlai@gmail.com>
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

Also initialize mmu->sync_spte as NULL for direct paging.

No functionalities change intended.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/kvm/mmu/mmu.c          |  70 ++++++++++++---
 arch/x86/kvm/mmu/paging_tmpl.h  | 147 +++++++++++---------------------
 3 files changed, 110 insertions(+), 111 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dbea616bccce..69b7967cd743 100644
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
index ffef9fe0c853..f39bee1542d8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1779,12 +1779,6 @@ static void mark_unsync(u64 *spte)
 	kvm_mmu_mark_parents_unsync(sp);
 }
 
-static int nonpaging_sync_page(struct kvm_vcpu *vcpu,
-			       struct kvm_mmu_page *sp)
-{
-	return -1;
-}
-
 #define KVM_PAGE_ARRAY_NR 16
 
 struct kvm_mmu_pages {
@@ -1904,10 +1898,62 @@ static bool sp_has_gptes(struct kvm_mmu_page *sp)
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
@@ -4458,7 +4504,7 @@ static void nonpaging_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = nonpaging_page_fault;
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
-	context->sync_page = nonpaging_sync_page;
+	context->sync_spte = NULL;
 	context->invlpg = NULL;
 }
 
@@ -5047,7 +5093,7 @@ static void paging64_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = paging64_page_fault;
 	context->gva_to_gpa = paging64_gva_to_gpa;
-	context->sync_page = paging64_sync_page;
+	context->sync_spte = paging64_sync_spte;
 	context->invlpg = paging64_invlpg;
 }
 
@@ -5055,7 +5101,7 @@ static void paging32_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = paging32_page_fault;
 	context->gva_to_gpa = paging32_gva_to_gpa;
-	context->sync_page = paging32_sync_page;
+	context->sync_spte = paging32_sync_spte;
 	context->invlpg = paging32_invlpg;
 }
 
@@ -5144,7 +5190,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	context->cpu_role.as_u64 = cpu_role.as_u64;
 	context->root_role.word = root_role.word;
 	context->page_fault = kvm_tdp_page_fault;
-	context->sync_page = nonpaging_sync_page;
+	context->sync_spte = NULL;
 	context->invlpg = NULL;
 	context->get_guest_pgd = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
@@ -5276,7 +5322,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 
 		context->page_fault = ept_page_fault;
 		context->gva_to_gpa = ept_gva_to_gpa;
-		context->sync_page = ept_sync_page;
+		context->sync_spte = ept_sync_spte;
 		context->invlpg = ept_invlpg;
 
 		update_permission_bitmask(context, true);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index ab0b031d4825..3bc13b9b61d1 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -942,120 +942,73 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
  *   can't change unless all sptes pointing to it are nuked first.
  *
  * Returns
- * < 0: the sp should be zapped
+ * < 0: failed to sync
  *   0: the sp is synced and no tlb flushing is required
  * > 0: the sp is synced and tlb flushing is required
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
+	unsigned old_pte_access, pte_access;
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
-		unsigned old_pte_access, pte_access;
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
-
-		gfn = gpte_to_gfn(gpte);
-		pte_access = sp->role.access;
-		pte_access &= FNAME(gpte_access)(gpte);
-		FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
-
-		if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
-			continue;
+	if (kvm_vcpu_read_guest_atomic(vcpu, pte_gpa, &gpte,
+				       sizeof(pt_element_t)))
+		return -1;
 
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
-		/*
-		 * Do nothing if the permissions are unchanged.
-		 */
-		old_pte_access = kvm_mmu_page_get_access(sp, i);
-		if (old_pte_access == pte_access)
-			continue;
+	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte))
+		return 1;
 
-		/* Update the shadowed access bits in case they changed. */
-		kvm_mmu_page_set_access(sp, i, pte_access);
+	gfn = gpte_to_gfn(gpte);
+	pte_access = sp->role.access;
+	pte_access &= FNAME(gpte_access)(gpte);
+	FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
 
-		sptep = &sp->spt[i];
-		spte = *sptep;
-		host_writable = spte & shadow_host_writable_mask;
-		slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-		make_spte(vcpu, sp, slot, pte_access, gfn,
-			  spte_to_pfn(spte), spte, true, false,
-			  host_writable, &spte);
+	if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
+		return 0;
 
-		flush |= mmu_spte_update(sptep, spte);
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
 	}
-
 	/*
-	 * Note, any flush is purely for KVM's correctness, e.g. when dropping
-	 * an existing SPTE or clearing W/A/D bits to ensure an mmu_notifier
-	 * unmap or dirty logging event doesn't fail to flush.  The guest is
-	 * responsible for flushing the TLB to ensure any changes in protection
-	 * bits are recognized, i.e. until the guest flushes or page faults on
-	 * a relevant address, KVM is architecturally allowed to let vCPUs use
-	 * cached translations with the old protection bits.
+	 * Do nothing if the permissions are unchanged.
 	 */
-	return flush;
+	old_pte_access = kvm_mmu_page_get_access(sp, i);
+	if (old_pte_access == pte_access)
+		return 0;
+
+	/* Update the shadowed access bits in case they changed. */
+	kvm_mmu_page_set_access(sp, i, pte_access);
+
+	sptep = &sp->spt[i];
+	spte = *sptep;
+	host_writable = spte & shadow_host_writable_mask;
+	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	make_spte(vcpu, sp, slot, pte_access, gfn,
+		  spte_to_pfn(spte), spte, true, false,
+		  host_writable, &spte);
+
+	return mmu_spte_update(sptep, spte);
 }
 
 #undef pt_element_t
-- 
2.19.1.6.gb485710b

