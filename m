Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0F64BBFA2
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 19:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239301AbiBRSiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 13:38:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235989AbiBRSiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 13:38:01 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E03D29C121
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 10:37:44 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id w37so2207180pga.7
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 10:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dXXbdeTStmwuBwtV+/FMa9zMsqjXwHLhEcrr0/z0eXQ=;
        b=ID+Xet37oO0iAb5JEBFOOhaEsrRqHJD6UInxWzn8vO4zMqkegLeLcfyudPZCgeq1bN
         6/iFd7scpnhEWiYWPzKOgpm614dBUtjNm9ak4fKWDGvhmfSvsk8fam6iiYGxcvQ2ctCr
         SII/QWLNjNfQLYjN5c9eJfeCPHEeSl3f36gMoVZcZLk3Kl8S+/TYetOdTvF98jI0MCaP
         pu8cWkDnkfIzpM6UhYtDTOOniRs3P6ZOhTNsB6FxV8hGImKmNvX5NSKOPr8wfpFZZHkf
         y6fes9u9uT02rI41N8Zs91gl1sz+ZaIY2I8BnCFjJinX4556ObOcVjDy90wd3j/+mYgO
         Xsng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dXXbdeTStmwuBwtV+/FMa9zMsqjXwHLhEcrr0/z0eXQ=;
        b=q51FrasZydn2hn+/TgFFq4JLwqdvIetG+HViHPBJIdWfOJdCgKgKfo1Wo6x97I+DSI
         DXU4mVLQT4iiFScogF2uW9GquabpzI1vSPZQkuMbZMyHS3EqJ0+9MV09/SPTqK3kO6Qr
         Y2Huy66WqhObWgkwUdAOIHxpB2FSIwG3k6r950KEdunkb1paJXdjgCBjAml65iO1JQ1a
         zgQZHQ24R3+y2ixHnxqCYx9jA4II8i/UJ8KEonnkL0X33qMuvlLEwp2kWYXJ2ZiWWyhV
         RaX0rcVVzfyBEIVvwxNTFdPzsLBWMolIWOp+lXyrQqIYqwmXoPPZEnRyk/PYVqTf7wVw
         c/JA==
X-Gm-Message-State: AOAM530pirtrpDDqyl++cKCPWuPQJPLfTlUOoWT6hbUGQnnuEfmdl9M4
        GUNPqBNs5f/1JJV9eQB83jv3Kg==
X-Google-Smtp-Source: ABdhPJyuUJDQp3VaZiUtAKB7xa/grZSqZVMVbteE2LIKyk+l7Ok2yOQM8Gp6b519/kha438LVkK0lQ==
X-Received: by 2002:a63:a556:0:b0:364:daad:997c with SMTP id r22-20020a63a556000000b00364daad997cmr7314112pgu.290.1645209463600;
        Fri, 18 Feb 2022 10:37:43 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b16sm3787161pfv.192.2022.02.18.10.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 10:37:42 -0800 (PST)
Date:   Fri, 18 Feb 2022 18:37:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: Re: [PATCH v2 07/18] KVM: x86/mmu: Do not use guest root level in
 audit
Message-ID: <Yg/nc1jjtUD2fhOR@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-8-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217210340.312449-8-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 17, 2022, Paolo Bonzini wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> Walking from the root page of the shadow page table should start with
> the level of the shadow page table: shadow_root_level; do not
> consult the level in order to check whether the root has a single
> root or uses pae_root, either, and use to_shadow_page instead.
> 
> Also tweak audit_mappings(), where the current walking level is more
> valuable to print.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Since I keep bringing it up...

From: Sean Christopherson <seanjc@google.com>
Date: Fri, 18 Feb 2022 09:43:05 -0800
Subject: [PATCH] KVM: x86/mmu: Remove MMU auditing

Remove mmu_audit.c and all its collateral, the auditing code has suffered
severe bitrot, ironically partly due to shadow paging being more stable
and thus not benefiting as much from auditing, but mostly due to TDP
supplanting shadow paging for non-nested guests and shadowing of nested
TDP not heavily stressing the logic that is being audited.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../admin-guide/kernel-parameters.txt         |   4 -
 arch/x86/include/asm/kvm_host.h               |   4 -
 arch/x86/kvm/Kconfig                          |   7 -
 arch/x86/kvm/mmu/mmu.c                        |  25 --
 arch/x86/kvm/mmu/mmu_audit.c                  | 303 ------------------
 arch/x86/kvm/mmu/paging_tmpl.h                |   2 -
 6 files changed, 345 deletions(-)
 delete mode 100644 arch/x86/kvm/mmu/mmu_audit.c

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 2a9746fe6c4a..05161afd7642 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2368,10 +2368,6 @@
 	kvm.enable_vmware_backdoor=[KVM] Support VMware backdoor PV interface.
 				   Default is false (don't support).

-	kvm.mmu_audit=	[KVM] This is a R/W parameter which allows audit
-			KVM MMU at runtime.
-			Default is 0 (off)
-
 	kvm.nx_huge_pages=
 			[KVM] Controls the software workaround for the
 			X86_BUG_ITLB_MULTIHIT bug.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c880254300c2..c2fe020802d1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1127,10 +1127,6 @@ struct kvm_arch {
 	struct kvm_hv hyperv;
 	struct kvm_xen xen;

-	#ifdef CONFIG_KVM_MMU_AUDIT
-	int audit_point;
-	#endif
-
 	bool backwards_tsc_observed;
 	bool boot_vcpu_runs_old_kvmclock;
 	u32 bsp_vcpu_id;
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 2b1548da00eb..e3cbd7706136 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -126,13 +126,6 @@ config KVM_XEN

 	  If in doubt, say "N".

-config KVM_MMU_AUDIT
-	bool "Audit KVM MMU"
-	depends on KVM && TRACEPOINTS
-	help
-	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
-	 auditing of KVM MMU events at runtime.
-
 config KVM_EXTERNAL_WRITE_TRACKING
 	bool

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e1578f71feae..ed11a0383266 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -104,15 +104,6 @@ static int max_huge_page_level __read_mostly;
 static int tdp_root_level __read_mostly;
 static int max_tdp_level __read_mostly;

-enum {
-	AUDIT_PRE_PAGE_FAULT,
-	AUDIT_POST_PAGE_FAULT,
-	AUDIT_PRE_PTE_WRITE,
-	AUDIT_POST_PTE_WRITE,
-	AUDIT_PRE_SYNC,
-	AUDIT_POST_SYNC
-};
-
 #ifdef MMU_DEBUG
 bool dbg = 0;
 module_param(dbg, bool, 0644);
@@ -1904,13 +1895,6 @@ static bool kvm_mmu_remote_flush_or_zap(struct kvm *kvm,
 	return true;
 }

-#ifdef CONFIG_KVM_MMU_AUDIT
-#include "mmu_audit.c"
-#else
-static void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point) { }
-static void mmu_audit_disable(void) { }
-#endif
-
 static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	if (sp->role.invalid)
@@ -3674,17 +3658,12 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 			return;

 		write_lock(&vcpu->kvm->mmu_lock);
-		kvm_mmu_audit(vcpu, AUDIT_PRE_SYNC);
-
 		mmu_sync_children(vcpu, sp, true);
-
-		kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
 		write_unlock(&vcpu->kvm->mmu_lock);
 		return;
 	}

 	write_lock(&vcpu->kvm->mmu_lock);
-	kvm_mmu_audit(vcpu, AUDIT_PRE_SYNC);

 	for (i = 0; i < 4; ++i) {
 		hpa_t root = vcpu->arch.mmu->pae_root[i];
@@ -3696,7 +3675,6 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 		}
 	}

-	kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
 	write_unlock(&vcpu->kvm->mmu_lock);
 }

@@ -5247,7 +5225,6 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	gentry = mmu_pte_write_fetch_gpte(vcpu, &gpa, &bytes);

 	++vcpu->kvm->stat.mmu_pte_write;
-	kvm_mmu_audit(vcpu, AUDIT_PRE_PTE_WRITE);

 	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn) {
 		if (detect_write_misaligned(sp, gpa, bytes) ||
@@ -5272,7 +5249,6 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		}
 	}
 	kvm_mmu_remote_flush_or_zap(vcpu->kvm, &invalid_list, flush);
-	kvm_mmu_audit(vcpu, AUDIT_POST_PTE_WRITE);
 	write_unlock(&vcpu->kvm->mmu_lock);
 }

@@ -6218,7 +6194,6 @@ void kvm_mmu_module_exit(void)
 	mmu_destroy_caches();
 	percpu_counter_destroy(&kvm_total_used_mmu_pages);
 	unregister_shrinker(&mmu_shrinker);
-	mmu_audit_disable();
 }

 /*
diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
deleted file mode 100644
index 3e5d62a25350..000000000000
--- a/arch/x86/kvm/mmu/mmu_audit.c
+++ /dev/null
@@ -1,303 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * mmu_audit.c:
- *
- * Audit code for KVM MMU
- *
- * Copyright (C) 2006 Qumranet, Inc.
- * Copyright 2010 Red Hat, Inc. and/or its affiliates.
- *
- * Authors:
- *   Yaniv Kamay  <yaniv@qumranet.com>
- *   Avi Kivity   <avi@qumranet.com>
- *   Marcelo Tosatti <mtosatti@redhat.com>
- *   Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
- */
-
-#include <linux/ratelimit.h>
-
-static char const *audit_point_name[] = {
-	"pre page fault",
-	"post page fault",
-	"pre pte write",
-	"post pte write",
-	"pre sync",
-	"post sync"
-};
-
-#define audit_printk(kvm, fmt, args...)		\
-	printk(KERN_ERR "audit: (%s) error: "	\
-		fmt, audit_point_name[kvm->arch.audit_point], ##args)
-
-typedef void (*inspect_spte_fn) (struct kvm_vcpu *vcpu, u64 *sptep, int level);
-
-static void __mmu_spte_walk(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			    inspect_spte_fn fn, int level)
-{
-	int i;
-
-	for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
-		u64 *ent = sp->spt;
-
-		fn(vcpu, ent + i, level);
-
-		if (is_shadow_present_pte(ent[i]) &&
-		      !is_last_spte(ent[i], level)) {
-			struct kvm_mmu_page *child;
-
-			child = to_shadow_page(ent[i] & PT64_BASE_ADDR_MASK);
-			__mmu_spte_walk(vcpu, child, fn, level - 1);
-		}
-	}
-}
-
-static void mmu_spte_walk(struct kvm_vcpu *vcpu, inspect_spte_fn fn)
-{
-	int i;
-	struct kvm_mmu_page *sp;
-
-	if (!VALID_PAGE(vcpu->arch.mmu->root.hpa))
-		return;
-
-	if (vcpu->arch.mmu->root_level >= PT64_ROOT_4LEVEL) {
-		hpa_t root = vcpu->arch.mmu->root.hpa;
-
-		sp = to_shadow_page(root);
-		__mmu_spte_walk(vcpu, sp, fn, vcpu->arch.mmu->root_level);
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
-}
-
-typedef void (*sp_handler) (struct kvm *kvm, struct kvm_mmu_page *sp);
-
-static void walk_all_active_sps(struct kvm *kvm, sp_handler fn)
-{
-	struct kvm_mmu_page *sp;
-
-	list_for_each_entry(sp, &kvm->arch.active_mmu_pages, link)
-		fn(kvm, sp);
-}
-
-static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
-{
-	struct kvm_mmu_page *sp;
-	gfn_t gfn;
-	kvm_pfn_t pfn;
-	hpa_t hpa;
-
-	sp = sptep_to_sp(sptep);
-
-	if (sp->unsync) {
-		if (level != PG_LEVEL_4K) {
-			audit_printk(vcpu->kvm, "unsync sp: %p "
-				     "level = %d\n", sp, level);
-			return;
-		}
-	}
-
-	if (!is_shadow_present_pte(*sptep) || !is_last_spte(*sptep, level))
-		return;
-
-	gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
-	pfn = kvm_vcpu_gfn_to_pfn_atomic(vcpu, gfn);
-
-	if (is_error_pfn(pfn))
-		return;
-
-	hpa =  pfn << PAGE_SHIFT;
-	if ((*sptep & PT64_BASE_ADDR_MASK) != hpa)
-		audit_printk(vcpu->kvm, "levels %d pfn %llx hpa %llx "
-			     "ent %llxn", vcpu->arch.mmu->root_level, pfn,
-			     hpa, *sptep);
-}
-
-static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
-{
-	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 10);
-	struct kvm_rmap_head *rmap_head;
-	struct kvm_mmu_page *rev_sp;
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *slot;
-	gfn_t gfn;
-
-	rev_sp = sptep_to_sp(sptep);
-	gfn = kvm_mmu_page_get_gfn(rev_sp, sptep - rev_sp->spt);
-
-	slots = kvm_memslots_for_spte_role(kvm, rev_sp->role);
-	slot = __gfn_to_memslot(slots, gfn);
-	if (!slot) {
-		if (!__ratelimit(&ratelimit_state))
-			return;
-		audit_printk(kvm, "no memslot for gfn %llx\n", gfn);
-		audit_printk(kvm, "index %ld of sp (gfn=%llx)\n",
-		       (long int)(sptep - rev_sp->spt), rev_sp->gfn);
-		dump_stack();
-		return;
-	}
-
-	rmap_head = gfn_to_rmap(gfn, rev_sp->role.level, slot);
-	if (!rmap_head->val) {
-		if (!__ratelimit(&ratelimit_state))
-			return;
-		audit_printk(kvm, "no rmap for writable spte %llx\n",
-			     *sptep);
-		dump_stack();
-	}
-}
-
-static void audit_sptes_have_rmaps(struct kvm_vcpu *vcpu, u64 *sptep, int level)
-{
-	if (is_shadow_present_pte(*sptep) && is_last_spte(*sptep, level))
-		inspect_spte_has_rmap(vcpu->kvm, sptep);
-}
-
-static void audit_spte_after_sync(struct kvm_vcpu *vcpu, u64 *sptep)
-{
-	struct kvm_mmu_page *sp = sptep_to_sp(sptep);
-
-	if (vcpu->kvm->arch.audit_point == AUDIT_POST_SYNC && sp->unsync)
-		audit_printk(vcpu->kvm, "meet unsync sp(%p) after sync "
-			     "root.\n", sp);
-}
-
-static void check_mappings_rmap(struct kvm *kvm, struct kvm_mmu_page *sp)
-{
-	int i;
-
-	if (sp->role.level != PG_LEVEL_4K)
-		return;
-
-	for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
-		if (!is_shadow_present_pte(sp->spt[i]))
-			continue;
-
-		inspect_spte_has_rmap(kvm, sp->spt + i);
-	}
-}
-
-static void audit_write_protection(struct kvm *kvm, struct kvm_mmu_page *sp)
-{
-	struct kvm_rmap_head *rmap_head;
-	u64 *sptep;
-	struct rmap_iterator iter;
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *slot;
-
-	if (sp->role.direct || sp->unsync || sp->role.invalid)
-		return;
-
-	slots = kvm_memslots_for_spte_role(kvm, sp->role);
-	slot = __gfn_to_memslot(slots, sp->gfn);
-	rmap_head = gfn_to_rmap(sp->gfn, PG_LEVEL_4K, slot);
-
-	for_each_rmap_spte(rmap_head, &iter, sptep) {
-		if (is_writable_pte(*sptep))
-			audit_printk(kvm, "shadow page has writable "
-				     "mappings: gfn %llx role %x\n",
-				     sp->gfn, sp->role.word);
-	}
-}
-
-static void audit_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
-{
-	check_mappings_rmap(kvm, sp);
-	audit_write_protection(kvm, sp);
-}
-
-static void audit_all_active_sps(struct kvm *kvm)
-{
-	walk_all_active_sps(kvm, audit_sp);
-}
-
-static void audit_spte(struct kvm_vcpu *vcpu, u64 *sptep, int level)
-{
-	audit_sptes_have_rmaps(vcpu, sptep, level);
-	audit_mappings(vcpu, sptep, level);
-	audit_spte_after_sync(vcpu, sptep);
-}
-
-static void audit_vcpu_spte(struct kvm_vcpu *vcpu)
-{
-	mmu_spte_walk(vcpu, audit_spte);
-}
-
-static bool mmu_audit;
-static DEFINE_STATIC_KEY_FALSE(mmu_audit_key);
-
-static void __kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
-{
-	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 10);
-
-	if (!__ratelimit(&ratelimit_state))
-		return;
-
-	vcpu->kvm->arch.audit_point = point;
-	audit_all_active_sps(vcpu->kvm);
-	audit_vcpu_spte(vcpu);
-}
-
-static inline void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
-{
-	if (static_branch_unlikely((&mmu_audit_key)))
-		__kvm_mmu_audit(vcpu, point);
-}
-
-static void mmu_audit_enable(void)
-{
-	if (mmu_audit)
-		return;
-
-	static_branch_inc(&mmu_audit_key);
-	mmu_audit = true;
-}
-
-static void mmu_audit_disable(void)
-{
-	if (!mmu_audit)
-		return;
-
-	static_branch_dec(&mmu_audit_key);
-	mmu_audit = false;
-}
-
-static int mmu_audit_set(const char *val, const struct kernel_param *kp)
-{
-	int ret;
-	unsigned long enable;
-
-	ret = kstrtoul(val, 10, &enable);
-	if (ret < 0)
-		return -EINVAL;
-
-	switch (enable) {
-	case 0:
-		mmu_audit_disable();
-		break;
-	case 1:
-		mmu_audit_enable();
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static const struct kernel_param_ops audit_param_ops = {
-	.set = mmu_audit_set,
-	.get = param_get_bool,
-};
-
-arch_param_cb(mmu_audit, &audit_param_ops, &mmu_audit, 0644);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 346f3bad3cb9..252c77805eb9 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -904,12 +904,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (is_page_fault_stale(vcpu, fault, mmu_seq))
 		goto out_unlock;

-	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
 	r = FNAME(fetch)(vcpu, fault, &walker);
-	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);

 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);

base-commit: 385d1e4898fb823e0bb25b6c23d000400bf6340e
--

