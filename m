Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE7EA5A8E9B
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 08:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbiIAGs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 02:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiIAGs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 02:48:27 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319C612140F;
        Wed, 31 Aug 2022 23:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662014907; x=1693550907;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=peHiaVdSwJ7TxmlSyI5wXME33FtW6AAZToRTJ8ib9Zk=;
  b=T9ez8zbgUsjCA/kVYPdGUz4sKarrprqAzC7E4NRnudlMDKseisafZF0D
   2uLSfqXbTWefLoOxlxfSD2p8c5BzCL7Z0mwYqv1h5Cgc3diz29zZBMNfS
   CHwByY1RtSraD3o1tdTq/kldAAckpvONMfuZXsJqRrrsJst11pAOfL9To
   dbLcH4m2aIn4iTz3a6ixrY9jAzQT16MO2/q3162ZUY6Z1iS7beAaVFlTb
   ELPutnXIMSNfLVfQIHe4SyDiwxiP0iVwCtrU8mHCZltfQs7S8rjfzr3lz
   Zdj6b9HzoftC5/NxNWzZ94K8GKxWralcywwqWFKFBZFQLBL4H94eZvErv
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="296416412"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="296416412"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 23:48:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="857720767"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga006.fm.intel.com with ESMTP; 31 Aug 2022 23:48:24 -0700
Date:   Thu, 1 Sep 2022 14:48:24 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 038/103] KVM: x86/tdp_mmu: refactor kvm_tdp_mmu_map()
Message-ID: <20220901064824.mpjd3xpgal3d3ynu@yy-desk-7060>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <021cf72b904933f23743d74b2a67341298ae5328.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <021cf72b904933f23743d74b2a67341298ae5328.1659854790.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 07, 2022 at 03:01:23PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Factor out non-leaf SPTE population logic from kvm_tdp_mmu_map().  MapGPA
> hypercall needs to populate non-leaf SPTE to record which GPA, private or
> shared, is allowed in the leaf EPT entry.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 8bc3a8d1803e..90b468a3a1a2 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1145,6 +1145,24 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  	return 0;
>  }
>
> +static int tdp_mmu_populate_nonleaf(
> +	struct kvm_vcpu *vcpu, struct tdp_iter *iter, bool account_nx)
> +{
> +	struct kvm_mmu_page *sp;
> +	int ret;
> +
> +	WARN_ON(is_shadow_present_pte(iter->old_spte));
> +	WARN_ON(is_removed_spte(iter->old_spte));

Why these 2 WARN_ON are necessary here ?

In TPD MMU the changes of PTE with shared lock is not surprised and
should be handle properly (e.g. the page is freed below for this
case), or this function will be called without checking the present
and removed state of the pte ?

> +
> +	sp = tdp_mmu_alloc_sp(vcpu);
> +	tdp_mmu_init_child_sp(sp, iter);
> +
> +	ret = tdp_mmu_link_sp(vcpu->kvm, iter, sp, account_nx, true);
> +	if (ret)
> +		tdp_mmu_free_sp(sp);
> +	return ret;
> +}
> +
>  /*
>   * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
>   * page tables and SPTEs to translate the faulting guest physical address.
> @@ -1153,7 +1171,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
>  	struct tdp_iter iter;
> -	struct kvm_mmu_page *sp;
>  	int ret;
>
>  	kvm_mmu_hugepage_adjust(vcpu, fault);
> @@ -1199,13 +1216,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  			if (is_removed_spte(iter.old_spte))
>  				break;
>
> -			sp = tdp_mmu_alloc_sp(vcpu);
> -			tdp_mmu_init_child_sp(sp, &iter);
> -
> -			if (tdp_mmu_link_sp(vcpu->kvm, &iter, sp, account_nx, true)) {
> -				tdp_mmu_free_sp(sp);
> +			if (tdp_mmu_populate_nonleaf(vcpu, &iter, account_nx))
>  				break;
> -			}
>  		}
>  	}
>
> --
> 2.25.1
>
