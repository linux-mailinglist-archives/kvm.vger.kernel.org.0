Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6340653663
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 19:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbiLUScP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 13:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiLUScM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 13:32:12 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6102026558
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 10:32:11 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id n65-20020a17090a2cc700b0021bc5ef7a14so2943737pjd.0
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 10:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I2WkNmLx+hF1R4zVC3YBTXtnb5zTPYDu3cQEAVLWjE8=;
        b=oYlbn5Z1bSZULa0hAe+S2a+Va28SOv8ESK8hr+1Hq+zfF2ocBDKm1J5nDfXCKXQePA
         5UUc8BQqLOGQbpicx/T5u6MRhi5YKyqKarh5pOrS8GpYQy7jX/tPi7YwHNVNLKd6ht7Z
         GX/n7rEJQ1yEg5dbXPbz4Bu4RTjf0QcZ0ckNwyE1Kam0KkhKAqpo9sY9W7muCwGAhV4m
         /1wYO1vMxFR1yPKQTAnphRkKrkZihNBO/hZxJLmVnVgS4n3X5I1p5eRGJokRtHAPQYA5
         H9nICFIO62b8dSk9raxuoM4DGKawyisAezOVOpscZRNDHl+ReLzJmQ8PpQgVUDIEYKwN
         zhoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I2WkNmLx+hF1R4zVC3YBTXtnb5zTPYDu3cQEAVLWjE8=;
        b=oeeD/5CQRCpiXsidRs4UJsQVpQJXRF2AjpK4uFEYV0kfnKkhqBsGQWc+z1FR1FhyjK
         8OTs2boCDvbA5iceEFBPUgmBG44SJX7HuSpAIxj572aAjzKryEUAPce2rrF9ydWN2YMO
         cCQwc4oS27Aqzm3pPteSK+AUvX1lxSe2nve2011PehYNAhHIJkrJUDXuXtKCCmQFO4Wx
         jOJ4es6vYSxnwz9+uIT/yiYOeMZ/14yLc+OC1Kw/xY8u5AwF7Lv7/AG/od02vjICN7Aw
         DZu4kJGqO5IA+Y/8a3y1a57rb/qSjhMweGzHgiMsQlfAcYhUSVEwox1jDV0RCtER98Hd
         T9ig==
X-Gm-Message-State: AFqh2kpAGSpgoZleTNL88pTPCh44/+mdq1H8HYM04jHHIxi4OpbNgJbd
        3PyoUtlIUiePcgQfnMU+diIw9A==
X-Google-Smtp-Source: AMrXdXu/FCnfJ0vy2sohzdA3MM+2zleUZA/QCDpP9SllyfAwFIbYfCZtUh5smPmywz9kpM+2DA79OQ==
X-Received: by 2002:a17:902:9049:b0:189:6d32:afeb with SMTP id w9-20020a170902904900b001896d32afebmr756789plz.1.1671647530632;
        Wed, 21 Dec 2022 10:32:10 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id cp12-20020a170902e78c00b00188ea79fae0sm11766353plb.48.2022.12.21.10.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 10:32:09 -0800 (PST)
Date:   Wed, 21 Dec 2022 18:32:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Robert Hoo <robert.hu@linux.intel.com>,
        Greg Thelen <gthelen@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH 5/5] KVM: x86/mmu: Move kvm_tdp_mmu_map()'s prolog and
 epilog to its caller
Message-ID: <Y6NRJTboZnjKbAL7@google.com>
References: <20221213033030.83345-1-seanjc@google.com>
 <20221213033030.83345-6-seanjc@google.com>
 <Y6H2o2ADCALDA2oL@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6H2o2ADCALDA2oL@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 20, 2022, David Matlack wrote:
> On Tue, Dec 13, 2022 at 03:30:30AM +0000, Sean Christopherson wrote:
> > Move the hugepage adjust, tracepoint, and RCU (un)lock logic out of
> > kvm_tdp_mmu_map() and into its sole caller, kvm_tdp_mmu_page_fault(), to
> > eliminate the gotos used to bounce through rcu_read_unlock() when bailing
> > from the walk.
> > 
> > Opportunistically mark kvm_mmu_hugepage_adjust() as static as
> > kvm_tdp_mmu_map() was the only external user.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c          |  9 ++++++++-
> >  arch/x86/kvm/mmu/mmu_internal.h |  1 -
> >  arch/x86/kvm/mmu/tdp_mmu.c      | 22 ++++------------------
> >  3 files changed, 12 insertions(+), 20 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 254bc46234e0..99c40617d325 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3085,7 +3085,8 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
> >  	return min(host_level, max_level);
> >  }
> >  
> > -void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > +static void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu,
> > +				    struct kvm_page_fault *fault)
> >  {
> >  	struct kvm_memory_slot *slot = fault->slot;
> >  	kvm_pfn_t mask;
> > @@ -4405,7 +4406,13 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
> >  	if (is_page_fault_stale(vcpu, fault))
> >  		goto out_unlock;
> >  
> > +	kvm_mmu_hugepage_adjust(vcpu, fault);
> 
> Can you also move the call to kvm_mmu_hugepage_adjust() from
> direct_map() to direct_page_fault()? I do think it's worth the
> maintenence burden to keep those functions consistent.

Sure.

> > +	trace_kvm_mmu_spte_requested(fault);
> > +
> > +	rcu_read_lock();
> >  	r = kvm_tdp_mmu_map(vcpu, fault);
> > +	rcu_read_unlock();
> 
> I would prefer to keep these in tdp_mmu.c, to reduce the amount of TDP
> MMU details that bleed into mmu.c (RCU) and for consistency with other
> TDP MMU APIs that don't require the caller to acquire RCU.  This will
> also be helpful for the Common MMU, as the tracepoint and RCU will be
> common.
> 
> e.g.
> 
> static int __kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> {
> 	...
> }
> 
> int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> {
> 	int r;
> 
> 	trace_kvm_mmu_spte_requested(fault);
> 
> 	rcu_read_lock();
> 	r = __kvm_tdp_mmu_map(vcpu, fault);
> 	rcu_read_unlock();
> 
> 	return r;
> }

I did that originally, but it felt really silly to have the trivial wrapper, especially
because mmu.c already has TDP MMU details, e.g. kvm_tdp_mmu_page_fault() takes mmu_lock
for read and other flows acquire rcu_read_lock() to protected the TDP MMU.

What about the below (split into multiple patches) instead?  kvm_tdp_mmu_page_fault()
really should live in tdp_mmu.c, the only reason it's in mmu.c is to get at various
helpers, e.g. fast_page_fault() and kvm_faultin_pfn().

Or is that doomed to fail because the TDP MMU will want to add code before
kvm_faultin_pfn() (I can't remember what motivated splitting out kvm_tdp_mmu_page_fault()
in the first place).

---
 arch/x86/kvm/mmu/mmu.c          | 132 ++++++++------------------------
 arch/x86/kvm/mmu/mmu_internal.h |  50 ++++++++++++
 arch/x86/kvm/mmu/spte.h         |   7 --
 arch/x86/kvm/mmu/tdp_mmu.c      |  41 ++++++----
 arch/x86/kvm/mmu/tdp_mmu.h      |   8 +-
 5 files changed, 108 insertions(+), 130 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 254bc46234e0..8203b1dd2753 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1927,16 +1927,6 @@ static bool kvm_mmu_remote_flush_or_zap(struct kvm *kvm,
 	return true;
 }
 
-static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
-{
-	if (sp->role.invalid)
-		return true;
-
-	/* TDP MMU pages do not use the MMU generation. */
-	return !is_tdp_mmu_page(sp) &&
-	       unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
-}
-
 struct mmu_page_path {
 	struct kvm_mmu_page *parent[PT64_ROOT_MAX_LEVEL];
 	unsigned int idx[PT64_ROOT_MAX_LEVEL];
@@ -3148,9 +3138,6 @@ static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	int ret;
 	gfn_t base_gfn = fault->gfn;
 
-	kvm_mmu_hugepage_adjust(vcpu, fault);
-
-	trace_kvm_mmu_spte_requested(fault);
 	for_each_shadow_entry(vcpu, fault->addr, it) {
 		/*
 		 * We cannot overwrite existing page tables with an NX
@@ -4270,54 +4257,10 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	return RET_PF_CONTINUE;
 }
 
-/*
- * Returns true if the page fault is stale and needs to be retried, i.e. if the
- * root was invalidated by a memslot update or a relevant mmu_notifier fired.
- */
-static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
-				struct kvm_page_fault *fault)
+static int __direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root.hpa);
+	int r = RET_PF_RETRY;
 
-	/* Special roots, e.g. pae_root, are not backed by shadow pages. */
-	if (sp && is_obsolete_sp(vcpu->kvm, sp))
-		return true;
-
-	/*
-	 * Roots without an associated shadow page are considered invalid if
-	 * there is a pending request to free obsolete roots.  The request is
-	 * only a hint that the current root _may_ be obsolete and needs to be
-	 * reloaded, e.g. if the guest frees a PGD that KVM is tracking as a
-	 * previous root, then __kvm_mmu_prepare_zap_page() signals all vCPUs
-	 * to reload even if no vCPU is actively using the root.
-	 */
-	if (!sp && kvm_test_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
-		return true;
-
-	return fault->slot &&
-	       mmu_invalidate_retry_hva(vcpu->kvm, fault->mmu_seq, fault->hva);
-}
-
-static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
-{
-	int r;
-
-	if (page_fault_handle_page_track(vcpu, fault))
-		return RET_PF_EMULATE;
-
-	r = fast_page_fault(vcpu, fault);
-	if (r != RET_PF_INVALID)
-		return r;
-
-	r = mmu_topup_memory_caches(vcpu, false);
-	if (r)
-		return r;
-
-	r = kvm_faultin_pfn(vcpu, fault, ACC_ALL);
-	if (r != RET_PF_CONTINUE)
-		return r;
-
-	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
 
 	if (is_page_fault_stale(vcpu, fault))
@@ -4327,6 +4270,10 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r)
 		goto out_unlock;
 
+	kvm_mmu_hugepage_adjust(vcpu, fault);
+
+	trace_kvm_mmu_spte_requested(fault);
+
 	r = direct_map(vcpu, fault);
 
 out_unlock:
@@ -4335,6 +4282,32 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	return r;
 }
 
+static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+{
+	int r;
+
+	if (page_fault_handle_page_track(vcpu, fault))
+		return RET_PF_EMULATE;
+
+	r = fast_page_fault(vcpu, fault);
+	if (r != RET_PF_INVALID)
+		return r;
+
+	r = mmu_topup_memory_caches(vcpu, false);
+	if (r)
+		return r;
+
+	r = kvm_faultin_pfn(vcpu, fault, ACC_ALL);
+	if (r != RET_PF_CONTINUE)
+		return r;
+
+#ifdef CONFIG_X86_64
+	if (tdp_mmu_enabled)
+		return kvm_tdp_mmu_page_fault(vcpu, fault);
+#endif
+	return __direct_page_fault(vcpu, fault);
+}
+
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu,
 				struct kvm_page_fault *fault)
 {
@@ -4378,42 +4351,6 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 }
 EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
 
-#ifdef CONFIG_X86_64
-static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
-				  struct kvm_page_fault *fault)
-{
-	int r;
-
-	if (page_fault_handle_page_track(vcpu, fault))
-		return RET_PF_EMULATE;
-
-	r = fast_page_fault(vcpu, fault);
-	if (r != RET_PF_INVALID)
-		return r;
-
-	r = mmu_topup_memory_caches(vcpu, false);
-	if (r)
-		return r;
-
-	r = kvm_faultin_pfn(vcpu, fault, ACC_ALL);
-	if (r != RET_PF_CONTINUE)
-		return r;
-
-	r = RET_PF_RETRY;
-	read_lock(&vcpu->kvm->mmu_lock);
-
-	if (is_page_fault_stale(vcpu, fault))
-		goto out_unlock;
-
-	r = kvm_tdp_mmu_map(vcpu, fault);
-
-out_unlock:
-	read_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
-	return r;
-}
-#endif
-
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	/*
@@ -4438,11 +4375,6 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 	}
 
-#ifdef CONFIG_X86_64
-	if (tdp_mmu_enabled)
-		return kvm_tdp_mmu_page_fault(vcpu, fault);
-#endif
-
 	return direct_page_fault(vcpu, fault);
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index ac00bfbf32f6..2c7c2b49f719 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -133,6 +133,28 @@ struct kvm_mmu_page {
 
 extern struct kmem_cache *mmu_page_header_cache;
 
+static inline struct kvm_mmu_page *to_shadow_page(hpa_t shadow_page)
+{
+	struct page *page = pfn_to_page((shadow_page) >> PAGE_SHIFT);
+
+	return (struct kvm_mmu_page *)page_private(page);
+}
+
+static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp)
+{
+	return IS_ENABLED(CONFIG_X86_64) && sp->tdp_mmu_page;
+}
+
+static inline bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	if (sp->role.invalid)
+		return true;
+
+	/* TDP MMU pages do not use the MMU generation. */
+	return !is_tdp_mmu_page(sp) &&
+	       unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
+}
+
 static inline int kvm_mmu_role_as_id(union kvm_mmu_page_role role)
 {
 	return role.smm ? 1 : 0;
@@ -314,6 +336,34 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	return r;
 }
 
+/*
+ * Returns true if the page fault is stale and needs to be retried, i.e. if the
+ * root was invalidated by a memslot update or a relevant mmu_notifier fired.
+ */
+static inline bool is_page_fault_stale(struct kvm_vcpu *vcpu,
+				       struct kvm_page_fault *fault)
+{
+	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root.hpa);
+
+	/* Special roots, e.g. pae_root, are not backed by shadow pages. */
+	if (sp && is_obsolete_sp(vcpu->kvm, sp))
+		return true;
+
+	/*
+	 * Roots without an associated shadow page are considered invalid if
+	 * there is a pending request to free obsolete roots.  The request is
+	 * only a hint that the current root _may_ be obsolete and needs to be
+	 * reloaded, e.g. if the guest frees a PGD that KVM is tracking as a
+	 * previous root, then __kvm_mmu_prepare_zap_page() signals all vCPUs
+	 * to reload even if no vCPU is actively using the root.
+	 */
+	if (!sp && kvm_test_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
+		return true;
+
+	return fault->slot &&
+	       mmu_invalidate_retry_hva(vcpu->kvm, fault->mmu_seq, fault->hva);
+}
+
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn,
 			      int max_level);
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 1f03701b943a..23e8f8c152b5 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -219,13 +219,6 @@ static inline int spte_index(u64 *sptep)
  */
 extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
 
-static inline struct kvm_mmu_page *to_shadow_page(hpa_t shadow_page)
-{
-	struct page *page = pfn_to_page((shadow_page) >> PAGE_SHIFT);
-
-	return (struct kvm_mmu_page *)page_private(page);
-}
-
 static inline struct kvm_mmu_page *spte_to_child_sp(u64 spte)
 {
 	return to_shadow_page(spte & SPTE_BASE_ADDR_MASK);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index cc1fb9a65620..4bb58c0f465b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1144,19 +1144,12 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
  * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
  * page tables and SPTEs to translate the faulting guest physical address.
  */
-int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct kvm *kvm = vcpu->kvm;
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
-	int ret = RET_PF_RETRY;
-
-	kvm_mmu_hugepage_adjust(vcpu, fault);
-
-	trace_kvm_mmu_spte_requested(fault);
-
-	rcu_read_lock();
 
 	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
 		int r;
@@ -1169,10 +1162,10 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * retry, avoiding unnecessary page table allocation and free.
 		 */
 		if (is_removed_spte(iter.old_spte))
-			goto retry;
+			return RET_PF_RETRY;
 
 		if (iter.level == fault->goal_level)
-			goto map_target_level;
+			return tdp_mmu_map_handle_target_level(vcpu, fault, &iter);
 
 		/* Step down into the lower level page table if it exists. */
 		if (is_shadow_present_pte(iter.old_spte) &&
@@ -1199,7 +1192,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 */
 		if (r) {
 			tdp_mmu_free_sp(sp);
-			goto retry;
+			return RET_PF_RETRY;
 		}
 
 		if (fault->huge_page_disallowed &&
@@ -1216,14 +1209,30 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	 * iterator detected an upper level SPTE was frozen during traversal.
 	 */
 	WARN_ON_ONCE(iter.level == fault->goal_level);
-	goto retry;
+	return RET_PF_RETRY;
+}
 
-map_target_level:
-	ret = tdp_mmu_map_handle_target_level(vcpu, fault, &iter);
+int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+{
+	int r = RET_PF_RETRY;
 
-retry:
+	read_lock(&vcpu->kvm->mmu_lock);
+
+	if (is_page_fault_stale(vcpu, fault))
+		goto out_unlock;
+
+	kvm_mmu_hugepage_adjust(vcpu, fault);
+
+	trace_kvm_mmu_spte_requested(fault);
+
+	rcu_read_lock();
+	r = kvm_tdp_mmu_map(vcpu, fault);
 	rcu_read_unlock();
-	return ret;
+
+out_unlock:
+	read_unlock(&vcpu->kvm->mmu_lock);
+	kvm_release_pfn_clean(fault->pfn);
+	return r;
 }
 
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 0a63b1afabd3..697dca948d0a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -27,7 +27,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
 
-int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
+int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush);
@@ -70,10 +70,4 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
 					u64 *spte);
 
-#ifdef CONFIG_X86_64
-static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }
-#else
-static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
-#endif
-
 #endif /* __KVM_X86_MMU_TDP_MMU_H */

base-commit: ffc4e70d9855921b740aee9bcbc8503cc753aee2
-- 
