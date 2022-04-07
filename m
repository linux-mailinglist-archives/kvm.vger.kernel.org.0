Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9844F71AE
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 03:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiDGBqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 21:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238768AbiDGBpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 21:45:33 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D661946B09;
        Wed,  6 Apr 2022 18:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649295796; x=1680831796;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OrrvVbgQhhyjCQNOwSRQWiJz/QiX7QYhKrIZ0LbfRzA=;
  b=l4MqDp48zz+8TC/53Op4fYyNqGtPqCwElOVznE+1Avbj7L3nEWDfrwfp
   IOjYpZZrUOUoi12nshKilsq7fPrbCEeydm+YTATOf+cS0NYjEkruL8+Qa
   aaK/uKZYMcaYSnSyHPL2v5Nau6oI8u2n8O+Za+lPwsI4a5yGE6YXfcChK
   N69ntDfR+rWblvsjGf67TDpWVooS+uZ9SqJzGVC8aRy/xuKPCuSokHdPB
   A7spkzS6JXzRvUNO78FmCmODQ+e5/XXRrzyTFwijZdAaD6aQTvKGeh6R5
   nyvbeo598tUPXvsK5GQlvbqa5SGDLY/3ZlhFD/8/89euwTbWIG63gUtud
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="286179808"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="286179808"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 18:43:15 -0700
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="621052715"
Received: from mgailhax-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.55.23])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 18:43:13 -0700
Message-ID: <fc935cdeea2547e27eb8a3ce8778e62aa3753b0e.camel@intel.com>
Subject: Re: [RFC PATCH v5 054/104] KVM: x86/tdp_mmu: Keep PRIVATE_PROHIBIT
 bit when zapping
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Thu, 07 Apr 2022 13:43:11 +1200
In-Reply-To: <772b20e270b3451aea9714260f2c40ddcc4afe80.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <772b20e270b3451aea9714260f2c40ddcc4afe80.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:49 -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> SPTE_PRIVATE_PROHIBIT specifies the share or private GPA is allowed or not.
> It needs to be kept over zapping the EPT entry.  Currently the EPT entry is
> initialized shadow_init_value unconditionally to clear
> SPTE_PRIVATE_PROHIBIT bit.  To carry SPTE_PRIVATE_PROHIBIT bit, introduce a
> helper function to get initial value for zapped entry with
> SPTE_PRIVATE_PROHIBIT bit.  Replace shadow_init_value with it.

Isn't it better to merge patch 53-55, especially 54-55 together? 

> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 1949f81027a0..6d750563824d 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -610,6 +610,12 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
>  	return true;
>  }
>  
> +static u64 shadow_init_spte(u64 old_spte)
> +{
> +	return shadow_init_value |
> +		(is_private_prohibit_spte(old_spte) ? SPTE_PRIVATE_PROHIBIT : 0);
> +}
> +
>  static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>  					   struct tdp_iter *iter)
>  {
> @@ -641,7 +647,8 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>  	 * shadow_init_value (which sets "suppress #VE" bit) so it
>  	 * can be set when EPT table entries are zapped.
>  	 */
> -	WRITE_ONCE(*rcu_dereference(iter->sptep), shadow_init_value);
> +	WRITE_ONCE(*rcu_dereference(iter->sptep),
> +		shadow_init_spte(iter->old_spte));
>  
>  	return true;
>  }

In this and next patch (54-55), in all the code path, you already have the iter-
>sptep, from which you can get the sp->private_sp, and check using
is_private_sp().  Why do we need this SPTE_PRIVATE_PRORHIBIT bit?

Are you suggesting we can have mixed private/shared mapping under a private_sp?

> @@ -853,7 +860,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  
>  		if (!shared) {
>  			/* see comments in tdp_mmu_zap_spte_atomic() */
> -			tdp_mmu_set_spte(kvm, &iter, shadow_init_value);
> +			tdp_mmu_set_spte(kvm, &iter,
> +					shadow_init_spte(iter.old_spte));
>  			flush = true;
>  		} else if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
>  			/*
> @@ -1038,11 +1046,14 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>  		new_spte = make_mmio_spte(vcpu,
>  				tdp_iter_gfn_unalias(vcpu->kvm, iter),
>  				pte_access);
> -	else
> +	else {
>  		wrprot = make_spte(vcpu, sp, fault->slot, pte_access,
>  				tdp_iter_gfn_unalias(vcpu->kvm, iter),
>  				fault->pfn, iter->old_spte, fault->prefetch,
>  				true, fault->map_writable, &new_spte);
> +		if (is_private_prohibit_spte(iter->old_spte))
> +			new_spte |= SPTE_PRIVATE_PROHIBIT;
> +	}
>  
>  	if (new_spte == iter->old_spte)
>  		ret = RET_PF_SPURIOUS;
> @@ -1335,7 +1346,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
>  	 * invariant that the PFN of a present * leaf SPTE can never change.
>  	 * See __handle_changed_spte().
>  	 */
> -	tdp_mmu_set_spte(kvm, iter, shadow_init_value);
> +	tdp_mmu_set_spte(kvm, iter, shadow_init_spte(iter->old_spte));
>  
>  	if (!pte_write(range->pte)) {
>  		new_spte = kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,

