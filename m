Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19F14CAE42
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 20:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241547AbiCBTI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 14:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiCBTI5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 14:08:57 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84334993B
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 11:08:12 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id z11so2393194pla.7
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 11:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ikC7Wxp/jzr+tnNZpmEM/sGB+lmtBh1UpNvi+15LDck=;
        b=qU4M+Z712jujMdXR5jH2f1PCoN8a/EMK3uEKMf8fbrbKbzYop+gQ0b5jhDhSKlfPNg
         uqc6viy3rsO7PSbikjaW6Q0yVyKAoOqZaEM8vCoj03wd505NGOMN5lauAfiQoDB8FDy4
         aly8qy9uoAM4s88ix5I5P/Ul7Dyl+lq0yKyt2oX9VeCxbJLfteMkzB8d2y9hNVoXJ8dv
         UCmHXxWly2YPQwwrS7xh5hCNIA25FuPF48Npcch9e78sPZmBMVNPf6pmClVPqy2tCHnf
         aveLuE/U5M3Dn6BVy60R8IppxpS9wIBWwXzhn9TMvKVNH25TrLwiCEJnIu8ph4S1YjbA
         ETDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ikC7Wxp/jzr+tnNZpmEM/sGB+lmtBh1UpNvi+15LDck=;
        b=79C1phSTKt7wAmzQra4hBgOSMeC0EZClgITwb07uRttMahzOZnIW2/sPezdXaViutv
         JJ04hnB6KuwfqU9hkuvsCpf/glRpcTk26eKUj0r54fbHXsdMLIGHwUUMYoVlMmrKOLl0
         JllpTWKW30ttlmkTffp/1xToYBdTxUx8VWgYT5u/P8sxEQdbM9TE71nngQvM4fe6hMFp
         NDtCFLVtCq1XwNm0aKO2Gi13w1tH8hEgPAhxOt5qK2CSzl0rcgwmOVmXc0EqXnDoCu5r
         1rb40tdst2XICU1V4NjOAS5ffFjMjWRwX0yVqI26JBaYA06E2jaM1UcNyBro532XDyee
         GyOQ==
X-Gm-Message-State: AOAM533ET0Zvq55SU26sbUYfBfMs4938MaHZ/6QexSWxhCzcofirHT3D
        6j9YeK0bXUvQOo4RODE2h3lsRw==
X-Google-Smtp-Source: ABdhPJy8CUCKikx/f0XhYoybR5nFYh8pJqzASQyRNVzKgG0Wb5idwm6ZkbkM0N3YowWyAUh9qz87zg==
X-Received: by 2002:a17:902:d484:b0:151:6964:2bd with SMTP id c4-20020a170902d48400b00151696402bdmr16870438plg.108.1646248092136;
        Wed, 02 Mar 2022 11:08:12 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id 124-20020a620582000000b004dee0e77128sm20357580pff.166.2022.03.02.11.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 11:08:11 -0800 (PST)
Date:   Wed, 2 Mar 2022 19:08:07 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 01/28] KVM: x86/mmu: Use common iterator for walking
 invalid TDP MMU roots
Message-ID: <Yh/Al8wGUOEgRmih@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-2-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220226001546.360188-2-seanjc@google.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 26, 2022, Sean Christopherson wrote:
> Now that tdp_mmu_next_root() can process both valid and invalid roots,
> extend it to be able to process _only_ invalid roots, add yet another
> iterator macro for walking invalid roots, and use the new macro in
> kvm_tdp_mmu_zap_invalidated_roots().
> 
> No functional change intended.
> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 74 ++++++++++++++------------------------
>  1 file changed, 26 insertions(+), 48 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index debf08212f12..25148e8b711d 100644
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

I am wondering what the trick is to start from -1?
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
>  		    kvm_tdp_mmu_get_root(next_root))
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
> @@ -810,28 +825,6 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
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
> @@ -842,36 +835,21 @@ static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
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
> 2.35.1.574.g5d30c73bfb-goog
> 
