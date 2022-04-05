Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D864F4988
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442317AbiDEWTN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447668AbiDEPq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 11:46:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 486451544B8
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 07:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649168559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XMbvbeiD1L3MEhxT1Z/BTw7iMCN1U7yAyW5/VFrntsE=;
        b=aREiV7sF48S5y4n8DOAZw2pz9Xf8zAtNY6Evs7X8FOfLVcYHg0CA2NbBtVtBYz5vtg5hTx
        dD9xTwFI7B/2WqKoDQAfkl3jQb1wbIRYrVlHzfd0jf3sKFQh5BhZUYSvvalhD1DIkFKIfg
        fS4E3zdYxLLFIhJnfr+EGJM0YH+GRBs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-BgBdML9TMgmusU2sXRrWeg-1; Tue, 05 Apr 2022 10:22:38 -0400
X-MC-Unique: BgBdML9TMgmusU2sXRrWeg-1
Received: by mail-wm1-f69.google.com with SMTP id l7-20020a05600c1d0700b0038c9c48f1e7so1420127wms.2
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 07:22:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XMbvbeiD1L3MEhxT1Z/BTw7iMCN1U7yAyW5/VFrntsE=;
        b=HZXQf4VUwOUdV4TevOE7AHnhOhtvZCgWH8Z5zjnWhcJHQQSoF8ZIzNC3Mzezrch8uL
         PnAtjI83yZMxmdOrShaYGRbv1wTWLws7d1+xqfZjQBVvkA2BJhNUbJbjFjB1vn2XvBOy
         Rvz5Jd/boeWz6b8FDS2Tuf64HtT4DO3M6WXm45AO1dL4ORNCGmnIKkoUso03KrAIDnhN
         +sFCJ3lWrHcFOgDR1C/v51lF7s4Rp0V/ywWfGFGGyj+IUaEFLG7t15H69NXLLxE6S5Qb
         rlEZrx1q6HFnkvB2Z5XRrF1tKBhWbSTzG1NxbHlbYq3TIbvpVXZA305lkiVRz+QPjruE
         euJA==
X-Gm-Message-State: AOAM531EhT8oha4anR+syrFb8gwGqscHGnIYbyNpMlRffof+PovQDZXO
        kV6NC2fPlhQyqfwR8upzMkM9DeJ5jU7sXtuKVyDsVd5km+FiVIcXoj1KqMkEIYruiaxucfeZ3u9
        QRd94Jk7b7BcZ
X-Received: by 2002:a05:600c:1d18:b0:38e:7e49:d51 with SMTP id l24-20020a05600c1d1800b0038e7e490d51mr3384765wms.70.1649168557190;
        Tue, 05 Apr 2022 07:22:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyY4bq7mOXPyzbhkPa+iw7PbU/g5JT8ZG+IDBMc1VtCFmTrdKRAtQGVs6WH1zh3nAxpTd0CHg==
X-Received: by 2002:a05:600c:1d18:b0:38e:7e49:d51 with SMTP id l24-20020a05600c1d1800b0038e7e490d51mr3384755wms.70.1649168556956;
        Tue, 05 Apr 2022 07:22:36 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id q66-20020a1c4345000000b0038e69dd940esm2243745wma.29.2022.04.05.07.22.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 07:22:36 -0700 (PDT)
Message-ID: <3f93de19-0685-3045-22db-7e05492bb5a4@redhat.com>
Date:   Tue, 5 Apr 2022 16:22:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 045/104] KVM: x86/tdp_mmu: make REMOVED_SPTE
 include shadow_initial value
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <6614d2a2bc34441ed598830392b425fdf8e5ca52.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <6614d2a2bc34441ed598830392b425fdf8e5ca52.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDP MMU uses REMOVED_SPTE = 0x5a0ULL as special constant to indicate the
> intermediate value to indicate one thread is operating on it and the value
> should be semi-arbitrary value.  For TDX (more correctly to use #VE), the
> value should include suppress #VE value which is shadow_init_value.
> 
> Define SHADOW_REMOVED_SPTE as shadow_init_value | REMOVED_SPTE, and replace
> REMOVED_SPTE with SHADOW_REMOVED_SPTE to use suppress #VE bit properly for
> TDX.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/mmu/spte.h    | 14 ++++++++++++--
>   arch/x86/kvm/mmu/tdp_mmu.c | 23 ++++++++++++++++-------
>   2 files changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index bde843bce878..e88f796724b4 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -194,7 +194,9 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
>    * If a thread running without exclusive control of the MMU lock must perform a
>    * multi-part operation on an SPTE, it can set the SPTE to REMOVED_SPTE as a
>    * non-present intermediate value. Other threads which encounter this value
> - * should not modify the SPTE.
> + * should not modify the SPTE.  When TDX is enabled, shadow_init_value, which
> + * is "suppress #VE" bit set, is also set to removed SPTE, because TDX module
> + * always enables "EPT violation #VE".
>    *
>    * Use a semi-arbitrary value that doesn't set RWX bits, i.e. is not-present on
>    * bot AMD and Intel CPUs, and doesn't set PFN bits, i.e. doesn't create a L1TF
> @@ -207,9 +209,17 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
>   /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
>   static_assert(!(REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
>   
> +/*
> + * See above comment around REMOVED_SPTE.  SHADOW_REMOVED_SPTE is the actual
> + * intermediate value set to the removed SPET.  When TDX is enabled, it sets
> + * the "suppress #VE" bit, otherwise it's REMOVED_SPTE.
> + */
> +extern u64 __read_mostly shadow_init_value;
> +#define SHADOW_REMOVED_SPTE	(shadow_init_value | REMOVED_SPTE)

Please rename the existing REMOVED_SPTE to REMOVED_SPTE_MASK, and call 
this simply REMOVED_SPTE.  This also makes the patch smaller.

Paolo

>   }
>   
>   /*
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index ebd0a02620e8..b6ec2f112c26 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -338,7 +338,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
>   			 * value to the removed SPTE value.
>   			 */
>   			for (;;) {
> -				old_child_spte = xchg(sptep, REMOVED_SPTE);
> +				old_child_spte = xchg(sptep, SHADOW_REMOVED_SPTE);
>   				if (!is_removed_spte(old_child_spte))
>   					break;
>   				cpu_relax();
> @@ -365,10 +365,10 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
>   			 * the two branches consistent and simplifies
>   			 * the function.
>   			 */
> -			WRITE_ONCE(*sptep, REMOVED_SPTE);
> +			WRITE_ONCE(*sptep, SHADOW_REMOVED_SPTE);
>   		}
>   		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
> -				    old_child_spte, REMOVED_SPTE, level,
> +				    old_child_spte, SHADOW_REMOVED_SPTE, level,
>   				    shared);
>   	}
>   
> @@ -537,7 +537,7 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>   	 * immediately installing a present entry in its place
>   	 * before the TLBs are flushed.
>   	 */
> -	if (!tdp_mmu_set_spte_atomic(kvm, iter, REMOVED_SPTE))
> +	if (!tdp_mmu_set_spte_atomic(kvm, iter, SHADOW_REMOVED_SPTE))
>   		return false;
>   
>   	kvm_flush_remote_tlbs_with_address(kvm, iter->gfn,
> @@ -550,8 +550,16 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>   	 * special removed SPTE value. No bookkeeping is needed
>   	 * here since the SPTE is going from non-present
>   	 * to non-present.
> +	 *
> +	 * Set non-present value to shadow_init_value, rather than 0.
> +	 * It is because when TDX is enabled, TDX module always
> +	 * enables "EPT-violation #VE", so KVM needs to set
> +	 * "suppress #VE" bit in EPT table entries, in order to get
> +	 * real EPT violation, rather than TDVMCALL.  KVM sets
> +	 * shadow_init_value (which sets "suppress #VE" bit) so it
> +	 * can be set when EPT table entries are zapped.
>   	 */
> -	WRITE_ONCE(*rcu_dereference(iter->sptep), 0);
> +	WRITE_ONCE(*rcu_dereference(iter->sptep), shadow_init_value);
>   
>   	return true;
>   }
> @@ -748,7 +756,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>   			continue;
>   
>   		if (!shared) {
> -			tdp_mmu_set_spte(kvm, &iter, 0);
> +			/* see comments in tdp_mmu_zap_spte_atomic() */
> +			tdp_mmu_set_spte(kvm, &iter, shadow_init_value);
>   			flush = true;
>   		} else if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
>   			/*
> @@ -1135,7 +1144,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
>   	 * invariant that the PFN of a present * leaf SPTE can never change.
>   	 * See __handle_changed_spte().
>   	 */
> -	tdp_mmu_set_spte(kvm, iter, 0);
> +	tdp_mmu_set_spte(kvm, iter, shadow_init_value);
>   
>   	if (!pte_write(range->pte)) {
>   		new_spte = kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,

