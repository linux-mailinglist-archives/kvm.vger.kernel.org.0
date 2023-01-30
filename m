Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1047681FF1
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 00:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjA3Xtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 18:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjA3Xty (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 18:49:54 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD0B2CC42
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 15:49:51 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id be8so13355919plb.7
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 15:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hs3IBrQSokG10ZJHtMLuhAk/1kKCXkUp/Mu762hDWjQ=;
        b=MUH6sx6kAUSdlqeQsrQeAPdSXyNlz2HcTS0x7gQsUZnV+CvOgH08KizKjJahGdZC3R
         NPEkzCsU7VyHPrF4Ye6o1xnnzOBV2gDYbCBw2YBtT0vpQJES0pT95Dome9CznoD5tExT
         qZFb6aBOoiRmx/9r2i5KTi9+ansCn5zMntpeJShUqX3q+rQly0V6U73vmmNjKMC+RvKP
         i6IQbuw/ccAm6W4mednLwZbmm2SqWm9RBGAjOVIzO6wfe/sHR4zEyhM5Mowh4s+g+VNp
         /svbtRUYyxzonpwgY3KI+pW7dPG1/UJBUGBz13JmdUFUsG3R+w4FftphLM8dQDRZ058x
         Wshw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hs3IBrQSokG10ZJHtMLuhAk/1kKCXkUp/Mu762hDWjQ=;
        b=WwsolMhzyVHD/n89wf3/2KU/7a7XX50wxIiJB7A7MvAe9fSvZxgOezAsiBazGxLxFi
         wu36n9kjJOGOIbR8dEoyMgU3yA7t0vNCxpbxyK+HVBTGDxMoRbpYTwmh4Z9NzwvQMVs/
         IDd9/zmlm8j4kQPSiT73dXqFdT3tBcvrS1Ok6BoKqKBxqKDfaOihbSBdiDYjIBuzmz4F
         gf9J/TYFjFqXX3af4wLQAdInLAqNdx12+x7/uG/0UvHQFGHRbtCvhxnD7LIlJGpF0uOJ
         3b9KMyh6xEpSrOPdQ/Wi7X0lk2q4RaGL9UO1lOoR810awWkX50OV6kO80Z2XmL7jdMPa
         WrgA==
X-Gm-Message-State: AO0yUKWgoR78FT4nWvkJ3kYvpeRiY95hVtnjYzMLV1KM0JTuuPtDtjho
        ubbpXv8uJq4tjY/CEvonpyn6xjWZg/hmYbNP1X8=
X-Google-Smtp-Source: AK7set+Gk/rBYxxOctvVgN3Vf3jMBSBX5HDtoesOj1PFtv/BXSWMAPKPXf1fv+OMEkd4PFJtknhf9Q==
X-Received: by 2002:a17:90a:6fa5:b0:22c:952:ab22 with SMTP id e34-20020a17090a6fa500b0022c0952ab22mr993595pjk.1.1675122591155;
        Mon, 30 Jan 2023 15:49:51 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n8-20020a17090a9f0800b0022c503c1897sm5821939pjp.3.2023.01.30.15.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 15:49:50 -0800 (PST)
Date:   Mon, 30 Jan 2023 23:49:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Ben Gardon <bgardon@google.com>, Vipin Sharma <vipinsh@google.com>,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch] KVM: x86/mmu: Make optimized __handle_changed_spte() for
 clear dirty log
Message-ID: <Y9hXmz/nDOr1hQal@google.com>
References: <20230125213857.824959-1-vipinsh@google.com>
 <Y9GmiyRQ6sULCjEG@google.com>
 <CANgfPd9T7jdh1Cjjo4y6DcxC2poTaGhQ7wNLf6OgGtStg-yKJg@mail.gmail.com>
 <Y9HcHRBShQgjxsQb@google.com>
 <CALzav=fkmS0U4tb4trDtbCmDxo27EcJeOWbiwb+meagj9+PFiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=fkmS0U4tb4trDtbCmDxo27EcJeOWbiwb+meagj9+PFiw@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 30, 2023, David Matlack wrote:
> On Wed, Jan 25, 2023 at 5:49 PM Sean Christopherson <seanjc@google.com> wrote:
> [...]
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 92 ++++++++++----------------------------
> >  1 file changed, 24 insertions(+), 68 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index bba33aea0fb0..2f78ca43a276 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> [...]
> > @@ -1289,8 +1244,7 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
> >                 new_spte = mark_spte_for_access_track(new_spte);
> >         }
> >
> > -       tdp_mmu_set_spte_no_acc_track(kvm, iter, new_spte);
> > -
> > +       kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte, new_spte, iter->level);
> 
> This can race with fast_page_fault() setting the W-bit and the CPU
> setting the D-bit. i.e. This call to kvm_tdp_mmu_write_spte() could
> clear the W-bit or D-bit.

Ugh, right.  Hrm.  Duh, I just didn't go far enough.  A straight XCHG is silly.
Except for the access-tracking mess, KVM wants to clear a single bit.  Writing
the entire thing and potentially clobbering bits is wasteful and unnecessarily
dangerous.  And the access-tracking code already needs special handling.

We can just simplify this all by adding a helper to clear a single bit (and
maybe even use clear_bit() and __clear_bit() if we save the bit number for the
W/A/D bits and not just the mask).  And if it weren't for EPT (different A/D
locations), we could even use static asserts to restrict the usage to the W/A/D
bits :-/  Oh well.

E.g. this

static inline void kvm_tdp_mmu_clear_spte_bit(struct tdp_iter *iter, u64 mask)
{
	if (kvm_tdp_mmu_spte_has_volatile_bits(iter->old_spte, iter->level))
		atomic64_and(~mask, (atomic64_t *)rcu_dereference(iter->sptep));
	else
		__kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte & ~mask);
}

yields another untested patch:

---
 arch/x86/kvm/mmu/tdp_iter.h | 24 +++++++++++++++++++-----
 arch/x86/kvm/mmu/tdp_mmu.c  | 33 +++++++++++++--------------------
 2 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index f0af385c56e0..09c8f2640ccc 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -29,11 +29,10 @@ static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
 	WRITE_ONCE(*rcu_dereference(sptep), new_spte);
 }
 
-static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
-					 u64 new_spte, int level)
+static inline bool kvm_tdp_mmu_spte_has_volatile_bits(u64 old_spte, int level)
 {
 	/*
-	 * Atomically write the SPTE if it is a shadow-present, leaf SPTE with
+	 * Atomically write SPTEs if it is a shadow-present, leaf SPTE with
 	 * volatile bits, i.e. has bits that can be set outside of mmu_lock.
 	 * The Writable bit can be set by KVM's fast page fault handler, and
 	 * Accessed and Dirty bits can be set by the CPU.
@@ -44,8 +43,15 @@ static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
 	 * logic needs to be reassessed if KVM were to use non-leaf Accessed
 	 * bits, e.g. to skip stepping down into child SPTEs when aging SPTEs.
 	 */
-	if (is_shadow_present_pte(old_spte) && is_last_spte(old_spte, level) &&
-	    spte_has_volatile_bits(old_spte))
+	return is_shadow_present_pte(old_spte) &&
+	       is_last_spte(old_spte, level) &&
+	       spte_has_volatile_bits(old_spte);
+}
+
+static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
+					 u64 new_spte, int level)
+{
+	if (kvm_tdp_mmu_spte_has_volatile_bits(old_spte, level))
 		return kvm_tdp_mmu_write_spte_atomic(sptep, new_spte);
 
 	__kvm_tdp_mmu_write_spte(sptep, new_spte);
@@ -115,4 +121,12 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
 
+static inline void kvm_tdp_mmu_clear_spte_bit(struct tdp_iter *iter, u64 mask)
+{
+	if (kvm_tdp_mmu_spte_has_volatile_bits(iter->old_spte, iter->level))
+		atomic64_and(~mask, (atomic64_t *)rcu_dereference(iter->sptep));
+	else
+		__kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte & ~mask);
+}
+
 #endif /* __KVM_X86_MMU_TDP_ITER_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 2f78ca43a276..32a7209a522d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1223,28 +1223,26 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 			  struct kvm_gfn_range *range)
 {
-	u64 new_spte = 0;
+	u64 new_spte;
 
 	/* If we have a non-accessed entry we don't need to change the pte. */
 	if (!is_accessed_spte(iter->old_spte))
 		return false;
 
-	new_spte = iter->old_spte;
-
-	if (spte_ad_enabled(new_spte)) {
-		new_spte &= ~shadow_accessed_mask;
+	if (spte_ad_enabled(iter->old_spte)) {
+		kvm_tdp_mmu_clear_spte_bit(iter, shadow_accessed_mask);
 	} else {
+		new_spte = mark_spte_for_access_track(iter->old_spte);
+		iter->old_spte = kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte,
+							new_spte, iter->level);
 		/*
 		 * Capture the dirty status of the page, so that it doesn't get
 		 * lost when the SPTE is marked for access tracking.
 		 */
-		if (is_writable_pte(new_spte))
-			kvm_set_pfn_dirty(spte_to_pfn(new_spte));
-
-		new_spte = mark_spte_for_access_track(new_spte);
+		if (is_writable_pte(iter->old_spte))
+			kvm_set_pfn_dirty(spte_to_pfn(iter->old_spte));
 	}
 
-	kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte, new_spte, iter->level);
 	return true;
 }
 
@@ -1632,7 +1630,6 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 				  gfn_t gfn, unsigned long mask, bool wrprot)
 {
 	struct tdp_iter iter;
-	u64 new_spte;
 
 	rcu_read_lock();
 
@@ -1648,20 +1645,16 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 		mask &= ~(1UL << (iter.gfn - gfn));
 
 		if (wrprot || spte_ad_need_write_protect(iter.old_spte)) {
-			if (is_writable_pte(iter.old_spte))
-				new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
-			else
+			if (!is_writable_pte(iter.old_spte))
 				continue;
+
+			kvm_tdp_mmu_clear_spte_bit(&iter, PT_WRITABLE_MASK);
 		} else {
-			if (iter.old_spte & shadow_dirty_mask)
-				new_spte = iter.old_spte & ~shadow_dirty_mask;
-			else
+			if (!(iter.old_spte & shadow_dirty_mask))
 				continue;
 
-			kvm_set_pfn_dirty(spte_to_pfn(iter.old_spte));
+			kvm_tdp_mmu_clear_spte_bit(&iter, shadow_dirty_mask);
 		}
-
-		kvm_tdp_mmu_write_spte(iter.sptep, iter.old_spte, new_spte, iter.level);
 	}
 
 	rcu_read_unlock();

base-commit: 7bb67c88a2d77cc95524912f3b1ca51daf5c0224
-- 


