Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359EF485DBA
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344208AbiAFAzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344427AbiAFAzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 19:55:09 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0924EC033271
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 16:54:36 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id r16-20020a17090a0ad000b001b276aa3aabso6614809pje.0
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 16:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KEKtpJkquZnIvrwW9A8uGIEGbvXixucppmb8Yo0U2IE=;
        b=qYZMbpeuOM2+gDDlJY9+mJhbBo1bAX8OizTNBKwyk7yzEu4h1hlP4nNLMwjWPH9WVR
         xiv3ye4MaFFK5lJ7/TYUXwKNmmNcBdmc7ol9HreKnBdJDBVmAhXmu0I35D5S69SjWFGy
         JA1tp9PBAOjIN5XHj77VjDQndCNXUf3hnHqFsvOZtFqAc69IhiaxWPSPw7Y98hPBDO2r
         nFXq6iBw7W/EFM6zY+rKvNEaTyblZpfgoLqgoDS+daQJOcrn562eirsDjr3tzCzqyQUR
         UHXmpeJeqiiszCTbOlrd9U3XFCIXUvlDOOf7ZSyZ00odbLg4F6Yodv4cJrTRfeU657na
         IKmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KEKtpJkquZnIvrwW9A8uGIEGbvXixucppmb8Yo0U2IE=;
        b=KO90d0gfRvanD0fi7UJlCqwn5vgZMpQD07Epva9ptOo3R3fRl829uv5lhRWt8Rp9B7
         T64deOCQsFOv1A1floqO00a15rCelY/5xGO+LuD5YvvXUs+aOMxdE09l7ZPdjUiC0IXc
         qSsa8sKdzvkF1fv3lxRtB+icaoxhWO8aDPb0go4VX1vv3nsT9UJGyjOC9/VuKC9UR7iy
         3hcxk1IfdnFUHmhb0OVavUs5QVjh1+ht8RUfGEzPEm4nwJIOvmODx7wjGOHuI5QRxZI2
         sgdGoRpcyt7W1PcXx77kle+9FEqEAgXibBa6vNWf2oMjpy317Rwo5v4wikb6tuqqhS5U
         97qg==
X-Gm-Message-State: AOAM532K7QHjt7xnzcHcwAT6m+dZJ5UNUIXDoONIrGQKOTOKYYYKcwUD
        u4GhZBrR6st6TQ7t+MQZO0Q2Ug==
X-Google-Smtp-Source: ABdhPJyzy3aRlgNNuYGB19mv1QS952RpOvhJBXswUYJmXA2ncS1Q7w60/B5ZknjYp8p6FcpNaPnuOQ==
X-Received: by 2002:a17:90b:298:: with SMTP id az24mr7112718pjb.219.1641430475368;
        Wed, 05 Jan 2022 16:54:35 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k8sm167500pjs.53.2022.01.05.16.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 16:54:34 -0800 (PST)
Date:   Thu, 6 Jan 2022 00:54:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 03/13] KVM: x86/mmu: Automatically update
 iter->old_spte if cmpxchg fails
Message-ID: <YdY9x7nNtMs0kyvm@google.com>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-4-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021, David Matlack wrote:
> Consolidate a bunch of code that was manually re-reading the spte if the
> cmpxchg fails. There is no extra cost of doing this because we already
> have the spte value as a result of the cmpxchg (and in fact this
> eliminates re-reading the spte), and none of the call sites depend on
> iter->old_spte retaining the stale spte value.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 50 ++++++++++++++++----------------------
>  1 file changed, 21 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index b69e47e68307..656ebf5b20dc 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -492,16 +492,22 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>   * and handle the associated bookkeeping.  Do not mark the page dirty
>   * in KVM's dirty bitmaps.
>   *
> + * If setting the SPTE fails because it has changed, iter->old_spte will be
> + * updated with the updated value of the spte.

First updated=>refreshed, second updated=>current?  More below.

> + *
>   * @kvm: kvm instance
>   * @iter: a tdp_iter instance currently on the SPTE that should be set
>   * @new_spte: The value the SPTE should be set to
>   * Returns: true if the SPTE was set, false if it was not. If false is returned,
> - *	    this function will have no side-effects.
> + *          this function will have no side-effects other than updating

s/updating/setting

> + *          iter->old_spte to the latest value of spte.

Strictly speaking, "latest" may not be true if yet another thread modifies the
SPTE.  Maybe this?

		iter->old_spte to the last known value of the SPTE.

>   */
>  static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
>  					   struct tdp_iter *iter,
>  					   u64 new_spte)
>  {
> +	u64 old_spte;
> +
>  	lockdep_assert_held_read(&kvm->mmu_lock);
>  
>  	/*
> @@ -515,9 +521,15 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
>  	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
>  	 * does not hold the mmu_lock.
>  	 */
> -	if (cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte,
> -		      new_spte) != iter->old_spte)
> +	old_spte = cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte, new_spte);

To make this a bit easier to read, and to stay under 80 chars, how about
opportunistically doing this as well?

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 656ebf5b20dc..64f1369f8638 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -506,6 +506,7 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
                                           struct tdp_iter *iter,
                                           u64 new_spte)
 {
+       u64 *sptep = rcu_dereference(iter->sptep);
        u64 old_spte;
 
        lockdep_assert_held_read(&kvm->mmu_lock);
@@ -521,7 +522,7 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
         * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
         * does not hold the mmu_lock.
         */
-       old_spte = cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte, new_spte);
+       old_spte = cmpxchg64(sptep, iter->old_spte, new_spte);
        if (old_spte != iter->old_spte) {
                /*
                 * The cmpxchg failed because the spte was updated by another

> +	if (old_spte != iter->old_spte) {
> +		/*
> +		 * The cmpxchg failed because the spte was updated by another
> +		 * thread so record the updated spte in old_spte.
> +		 */

Hmm, this is a bit awkward.  I think it's the double use of "updated" and the
somewhat ambiguous reference to "old_spte".  I'd also avoid "thread", as this
requires interference from not only a different task, but a different logical CPU
since iter->old_spte is refreshed if mmu_lock is dropped and reacquired.  And
"record" is an odd choice of word since it sounds like storing the current value
is only for logging/debugging.

Something like this?

		/*
		 * The entry was modified by a different logical CPU, refresh
		 * iter->old_spte with the current value so the caller operates
		 * on fresh data, e.g. if it retries tdp_mmu_set_spte_atomic().
		 */

Nits aside,

Reviewed-by: Sean Christopherson <seanjc@google.com>

> +		iter->old_spte = old_spte;
>  		return false;
> +	}
>  
>  	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
>  			      new_spte, iter->level, true);
