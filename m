Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213BD33931C
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 17:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbhCLQXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 11:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbhCLQWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 11:22:54 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41AEC061574
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 08:22:53 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id ha17so4627032pjb.2
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 08:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gdt4oP23fLZJMao8nf8iaIGeaxyRTbglZKhBhqtNziU=;
        b=UH4ilBl+yBoJ2gK+BXrOmkC1VdCOqm0R544RBE76MbcyO6L5/eWKX1QjnQMccrnm46
         yNSrxWmPNw0eN7t0JZjuYc+K+EsWDwDN6FP3/AWpNQn3sj2lQGCzbFndKEsOBX0+neSQ
         SB/6OkjYVXRtGa9dl9bqjzBRrCj1KTrTXoNWTW38MVyGvZ1m+t4Egt2nvcwYh2vsNj08
         JfU0x4YoJ/ijH5EHY9V7ddcnAx1C+r9wVsUOhLD3AsYxddMYLF5+PX4qqIIBoIFyqBAi
         ffMdEcm+Wf8Jb2kd+NPjZzWZ97TOPtPk/Yi4eoYNdAPhel0gluIcpBFC601W4INHm1mW
         055w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gdt4oP23fLZJMao8nf8iaIGeaxyRTbglZKhBhqtNziU=;
        b=j4OhNn1rBk/wsymO6OErDcw6iAnGDWokqhV0PmwXH4pC3/hvEjEx+omo6Xg45U/nLC
         hjgKEz+ghcML2F8jOK55hkDBS+jK0IijxwMEGzpjdKHfxiDsipacsCrhvoeQompfjzJh
         wdT8MCoMpabE7LL+DkgKAohYMlG8veiSkKt8WJl2P8ixHP7RPjBWonxJtGf/7CTacERC
         K03UQ7xEuDT4Hq4NpNUWFp5pP9AYlqnXqYC9dH73x3hqhQu0UQMI7oLRdIMYR9x8sCBq
         EcCu13Z58yzr4XZCU3KMmg8Mz61NsSJX1M/cvwmzJusdCvSReaEbTEmQu9RMtthcubuZ
         jALg==
X-Gm-Message-State: AOAM531t8AHayx8hQavcue7ertXTBKi7JFXeL6S/IQua+00GpOcKgV4y
        833ld2CRIQDeMK/w5LQqwbSDDQ==
X-Google-Smtp-Source: ABdhPJzZOOTSkX9b98eQfbfQiryyvJdwolzGBc58vaqxltYF0+1KrhFa8JUEfzGAYphETIl3kf0a5Q==
X-Received: by 2002:a17:90a:67cf:: with SMTP id g15mr14826672pjm.208.1615566173313;
        Fri, 12 Mar 2021 08:22:53 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1a6:2eeb:4e45:756])
        by smtp.gmail.com with ESMTPSA id 192sm6003877pfa.122.2021.03.12.08.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 08:22:52 -0800 (PST)
Date:   Fri, 12 Mar 2021 08:22:46 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Fix RCU usage for tdp_iter_root_pt
Message-ID: <YEuVVpySnR4Fg6bh@google.com>
References: <20210311231658.1243953-1-bgardon@google.com>
 <20210311231658.1243953-3-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311231658.1243953-3-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021, Ben Gardon wrote:
> The root page table in the TDP MMU paging structure is not protected
> with RCU, but rather by the root_count in the associated SP. As a result
> it is safe for tdp_iter_root_pt to simply return a u64 *. This sidesteps
> the complexities assoicated with propagating the __rcu annotation
> around.
> 
> Reported-by: kernel test robot <lkp@xxxxxxxxx>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_iter.c | 10 ++++++++--
>  arch/x86/kvm/mmu/tdp_iter.h |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c  |  4 ++--
>  3 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> index e5f148106e20..8e2c053533b6 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.c
> +++ b/arch/x86/kvm/mmu/tdp_iter.c
> @@ -159,8 +159,14 @@ void tdp_iter_next(struct tdp_iter *iter)
>  	iter->valid = false;
>  }
>  
> -tdp_ptep_t tdp_iter_root_pt(struct tdp_iter *iter)
> +u64 *tdp_iter_root_pt(struct tdp_iter *iter)
>  {
> -	return iter->pt_path[iter->root_level - 1];
> +	/*
> +	 * Though it is stored in an array of tdp_ptep_t for convenience,
> +	 * the root PT is not actually protected by RCU, but by the root
> +	 * count on the associated struct kvm_mmu_page. As a result it's
> +	 * safe to rcu_dereference and return the value here.

I'm not a big fan of this comment.  It implies that calling tdp_iter_root_pt()
without RCU protection is completely ok, but that's not true, as rcu_dereferecne()
will complain when CONFIG_PROVE_RCU=1.

There's also a good opportunity to streamline the the helper here, since both
callers use the root only to get to the associated shadow page, and that's only
done to get the as_id.  If we provide tdp_iter_as_id() then the need for a
comment goes away and we shave a few lines of code.

That being said, an even better option would be to store as_id in the TDP iter.
The cost on the stack is negligible, and while the early sptep->as_id lookup
will be unnecessary in some cases, it will be a net win when setting multiple
sptes, e.g. in mmu_notifier callbacks.

Compile tested only...

From 02fb9cd2aa52d0afd318e93661d0212ccdb54218 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Mar 2021 08:12:21 -0800
Subject: [PATCH] KVM: x86/mmu: Store the address space ID in the TDP iterator

Store the address space ID in the TDP iterator so that it can be
retrieved without having to bounce through the root shadow page.  This
streamlines the code and fixes a Sparse warning about not properly using
rcu_dereference() when grabbing the ID from the root on the fly.

Reported-by: kernel test robot <lkp@intel.com>
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h |  5 +++++
 arch/x86/kvm/mmu/tdp_iter.c     |  7 +------
 arch/x86/kvm/mmu/tdp_iter.h     |  3 ++-
 arch/x86/kvm/mmu/tdp_mmu.c      | 23 +++++------------------
 4 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index ec4fc28b325a..e844078d2374 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -119,6 +119,11 @@ static inline bool kvm_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *sp)
 	return !sp->root_count;
 }

+static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
+{
+	return sp->role.smm ? 1 : 0;
+}
+
 /*
  * Return values of handle_mmio_page_fault, mmu.page_fault, and fast_page_fault().
  *
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index e5f148106e20..55d0ce2185a5 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -40,6 +40,7 @@ void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
 	iter->gfn = round_gfn_for_level(iter->next_last_level_gfn, iter->level);
 	tdp_iter_refresh_sptep(iter);

+	iter->as_id = kvm_mmu_page_as_id(sptep_to_sp(root_pt));
 	iter->valid = true;
 }

@@ -158,9 +159,3 @@ void tdp_iter_next(struct tdp_iter *iter)
 	} while (try_step_up(iter));
 	iter->valid = false;
 }
-
-tdp_ptep_t tdp_iter_root_pt(struct tdp_iter *iter)
-{
-	return iter->pt_path[iter->root_level - 1];
-}
-
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 4cc177d75c4a..df9c84713f5b 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -36,6 +36,8 @@ struct tdp_iter {
 	int min_level;
 	/* The iterator's current level within the paging structure */
 	int level;
+	/* The address space ID, i.e. SMM vs. regular. */
+	int as_id;
 	/* A snapshot of the value at sptep */
 	u64 old_spte;
 	/*
@@ -62,6 +64,5 @@ tdp_ptep_t spte_to_child_pt(u64 pte, int level);
 void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
 		    int min_level, gfn_t next_last_level_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
-tdp_ptep_t tdp_iter_root_pt(struct tdp_iter *iter);

 #endif /* __KVM_X86_MMU_TDP_ITER_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 21cbbef0ee57..9f436aa14663 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -190,11 +190,6 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				u64 old_spte, u64 new_spte, int level,
 				bool shared);

-static int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
-{
-	return sp->role.smm ? 1 : 0;
-}
-
 static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
 {
 	if (!is_shadow_present_pte(old_spte) || !is_last_spte(old_spte, level))
@@ -472,10 +467,6 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 					   struct tdp_iter *iter,
 					   u64 new_spte)
 {
-	u64 *root_pt = tdp_iter_root_pt(iter);
-	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
-	int as_id = kvm_mmu_page_as_id(root);
-
 	lockdep_assert_held_read(&kvm->mmu_lock);

 	/*
@@ -489,8 +480,8 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 		      new_spte) != iter->old_spte)
 		return false;

-	handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
-			    iter->level, true);
+	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
+			    new_spte, iter->level, true);

 	return true;
 }
@@ -544,10 +535,6 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 				      u64 new_spte, bool record_acc_track,
 				      bool record_dirty_log)
 {
-	tdp_ptep_t root_pt = tdp_iter_root_pt(iter);
-	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
-	int as_id = kvm_mmu_page_as_id(root);
-
 	lockdep_assert_held_write(&kvm->mmu_lock);

 	/*
@@ -561,13 +548,13 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,

 	WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);

-	__handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
-			      iter->level, false);
+	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
+			      new_spte, iter->level, false);
 	if (record_acc_track)
 		handle_changed_spte_acc_track(iter->old_spte, new_spte,
 					      iter->level);
 	if (record_dirty_log)
-		handle_changed_spte_dirty_log(kvm, as_id, iter->gfn,
+		handle_changed_spte_dirty_log(kvm, iter->as_id, iter->gfn,
 					      iter->old_spte, new_spte,
 					      iter->level);
 }
--
