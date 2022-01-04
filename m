Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56776484A85
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 23:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235303AbiADWNU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 17:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235324AbiADWNQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 17:13:16 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC93C061799
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 14:13:16 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id r5so33856051pgi.6
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 14:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ovrXI3FHH8WxRR1JjMgNJLENzgzeWUp2fUk8RCSkJZk=;
        b=TtcgiwOxTLT01IGRoN2kjib64zxKEExBmmAM3IUFF5Bk3fqSSUxtnjMu4XsY2NLXlr
         mvlrxQ1NGky/kqfpgLvILSbuMQllCFtaMg20yHNi/JPY3tRYiPZOKp0Q9ro6XnhVUCBm
         BIfI/QjUis2jwxcAt0iv04Qap7OHolYvGh2QwIwfpjkoEntLRz9eMosbHyFFTXP8eSdP
         m3oh4UmXm+i4xR9twA3whV0/K1zJh8+5Pq0Lsd/cK7Ls9KJEJ6iy5Q3txaNN8dueGuJn
         4354HjkhsZpQOA7qzc6GYFQ6tUam08Dj6hYXiGtFTTwlFsPIUHuhXIT1nOqC9gPaKg1h
         Drjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ovrXI3FHH8WxRR1JjMgNJLENzgzeWUp2fUk8RCSkJZk=;
        b=77k6EbCjyVsy76fYSEL0Rt5T6jg+0vzcNGSLDZWIsB7zvKws/FGuMgxMlm4JbOqYzG
         FSyIYVrqEaba6stjbHEKj+qaukx9MUNAIZlc3AJgFJp+aEHtmnIireumAEIwPF8zFN2L
         Q3CW85L9luhakd3gkkAhFFpkdlNtiwhEz6o5TACd7qHmJkgT/u+/jru7Vj6VC4SRi7Zd
         EKztkZTyRZ0EwCqT5ReU3yCpgk3NZha+/uJ8DzUHBWEmTFQ7u87dhFFXJ9lKp4sAUfJc
         rpKBlayPcdEz/vcsqarxio6OPf/c8Aole7Dnl1PYGJooXnEnd9DDHbGOlcAPEj4at3OO
         5j3A==
X-Gm-Message-State: AOAM5332TUUcyLwZtCUZMgGufRXvwzY6dF5KjfjVzm9CriFk99dfDuYs
        ISGqNFcfowtjqF6bhFuqzeXGxg==
X-Google-Smtp-Source: ABdhPJzf30m7UK3edfjLt5i56vYJs8Aou+OX0mj1BOWzXJD5GI5EJdFqDdB5RUCHyVAuC74DXQ4INQ==
X-Received: by 2002:aa7:9681:0:b0:4ba:98c6:8fc3 with SMTP id f1-20020aa79681000000b004ba98c68fc3mr53429603pfk.78.1641334395702;
        Tue, 04 Jan 2022 14:13:15 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id f15sm286209pjt.18.2022.01.04.14.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 14:13:14 -0800 (PST)
Date:   Tue, 4 Jan 2022 22:13:11 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v2 04/30] KVM: x86/mmu: Use common iterator for walking
 invalid TDP MMU roots
Message-ID: <YdTGd3Anx2jrACRx@google.com>
References: <20211223222318.1039223-1-seanjc@google.com>
 <20211223222318.1039223-5-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211223222318.1039223-5-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 23, 2021 at 10:22:52PM +0000, Sean Christopherson wrote:
> Now that tdp_mmu_next_root() can process both valid and invalid roots,
> extend it to be able to process _only_ invalid roots, add yet another
> iterator macro for walking invalid roots, and use the new macro in
> kvm_tdp_mmu_zap_invalidated_roots().
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Nice cleanup, it's great to see next_invalidated_root() go.

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 74 ++++++++++++++------------------------
>  1 file changed, 26 insertions(+), 48 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 577985fa001d..41e975841ea6 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -98,6 +98,12 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
>  }
>  
> +enum tdp_mmu_roots_iter_type {
> +	ALL_ROOTS = -1,
> +	VALID_ROOTS = 0,
> +	INVALID_ROOTS = 1,
> +};
> +
>  /*
>   * Returns the next root after @prev_root (or the first root if @prev_root is
>   * NULL).  A reference to the returned root is acquired, and the reference to
> @@ -110,10 +116,16 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>   */
>  static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>  					      struct kvm_mmu_page *prev_root,
> -					      bool shared, bool only_valid)
> +					      bool shared,
> +					      enum tdp_mmu_roots_iter_type type)
>  {
>  	struct kvm_mmu_page *next_root;
>  
> +	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
> +
> +	/* Ensure correctness for the below comparison against role.invalid. */
> +	BUILD_BUG_ON(!!VALID_ROOTS || !INVALID_ROOTS);
> +
>  	rcu_read_lock();
>  
>  	if (prev_root)
> @@ -125,7 +137,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>  						   typeof(*next_root), link);
>  
>  	while (next_root) {
> -		if ((!only_valid || !next_root->role.invalid) &&
> +		if ((type == ALL_ROOTS || (type == !!next_root->role.invalid)) &&
>  		    kvm_tdp_mmu_get_root(kvm, next_root))
>  			break;
>  
> @@ -151,18 +163,21 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>   * mode. In the unlikely event that this thread must free a root, the lock
>   * will be temporarily dropped and reacquired in write mode.
>   */
> -#define __for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, _only_valid)\
> -	for (_root = tdp_mmu_next_root(_kvm, NULL, _shared, _only_valid);	\
> +#define __for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, _type) \
> +	for (_root = tdp_mmu_next_root(_kvm, NULL, _shared, _type);		\
>  	     _root;								\
> -	     _root = tdp_mmu_next_root(_kvm, _root, _shared, _only_valid))	\
> -		if (kvm_mmu_page_as_id(_root) != _as_id) {			\
> +	     _root = tdp_mmu_next_root(_kvm, _root, _shared, _type))		\
> +		if (_as_id > 0 && kvm_mmu_page_as_id(_root) != _as_id) {	\
>  		} else
>  
> +#define for_each_invalid_tdp_mmu_root_yield_safe(_kvm, _root)			\
> +	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, -1, true, INVALID_ROOTS)
> +
>  #define for_each_valid_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)	\
> -	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, true)
> +	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, VALID_ROOTS)
>  
>  #define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)		\
> -	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, false)
> +	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, ALL_ROOTS)
>  
>  #define for_each_tdp_mmu_root(_kvm, _root, _as_id)				\
>  	list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link,		\
> @@ -811,28 +826,6 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>  		kvm_flush_remote_tlbs(kvm);
>  }
>  
> -static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
> -						  struct kvm_mmu_page *prev_root)
> -{
> -	struct kvm_mmu_page *next_root;
> -
> -	if (prev_root)
> -		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
> -						  &prev_root->link,
> -						  typeof(*prev_root), link);
> -	else
> -		next_root = list_first_or_null_rcu(&kvm->arch.tdp_mmu_roots,
> -						   typeof(*next_root), link);
> -
> -	while (next_root && !(next_root->role.invalid &&
> -			      refcount_read(&next_root->tdp_mmu_root_count)))
> -		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
> -						  &next_root->link,
> -						  typeof(*next_root), link);
> -
> -	return next_root;
> -}
> -
>  /*
>   * Since kvm_tdp_mmu_zap_all_fast has acquired a reference to each
>   * invalidated root, they will not be freed until this function drops the
> @@ -843,36 +836,21 @@ static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
>   */
>  void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>  {
> -	struct kvm_mmu_page *next_root;
>  	struct kvm_mmu_page *root;
>  	bool flush = false;
>  
>  	lockdep_assert_held_read(&kvm->mmu_lock);
>  
> -	rcu_read_lock();
> -
> -	root = next_invalidated_root(kvm, NULL);
> -
> -	while (root) {
> -		next_root = next_invalidated_root(kvm, root);
> -
> -		rcu_read_unlock();
> -
> +	for_each_invalid_tdp_mmu_root_yield_safe(kvm, root) {
>  		flush = zap_gfn_range(kvm, root, 0, -1ull, true, flush, true);
>  
>  		/*
> -		 * Put the reference acquired in
> -		 * kvm_tdp_mmu_invalidate_roots
> +		 * Put the reference acquired in kvm_tdp_mmu_invalidate_roots().
> +		 * Note, the iterator holds its own reference.
>  		 */
>  		kvm_tdp_mmu_put_root(kvm, root, true);
> -
> -		root = next_root;
> -
> -		rcu_read_lock();
>  	}
>  
> -	rcu_read_unlock();
> -
>  	if (flush)
>  		kvm_flush_remote_tlbs(kvm);
>  }
> -- 
> 2.34.1.448.ga2b2bfdf31-goog
> 
