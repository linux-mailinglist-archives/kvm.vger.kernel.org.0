Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4C55A90FB
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 09:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbiIAHpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 03:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233322AbiIAHoP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 03:44:15 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3BD126DC3;
        Thu,  1 Sep 2022 00:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662018252; x=1693554252;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ejI/izm9+TYQ0O7NVLS4b04vZ6yIXtzj2hWSThsqVrQ=;
  b=X+TQ4sSoUwqscFzt0ZQGW7bLk9Bv3+W6V87bmxtKEZ6AUT2dFCQsFilO
   QoC8yIfMGDEPFVKF+YVJw5abGCoyp2ex2sPo7/lffe3rkN+ZNyE1zInP6
   3yetuAWW+9YByri742mJk2SOVJuFhztQtOzw5yEddp8NcdHNsnnY45XKO
   MXWCrK1qTG4BF2YGJfkB2fKj2Aow4t7yey4tu4QIMyyVe6eE4o+sIWAho
   XiGsaynTPXDuL3gF68n24N2IIoE2p/3/YFjws+EQq8tRNPhMrSCz7ivfi
   RZN6Jr+DeYo+O9HWf7dHhR65V8hn4e5oAEwfH5v/f2G4aIje6YakCyivn
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="276046328"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="276046328"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 00:44:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="673731452"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 01 Sep 2022 00:44:09 -0700
Date:   Thu, 1 Sep 2022 15:44:09 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 041/103] KVM: x86/mmu: Add a new is_private member for
 union kvm_mmu_page_role
Message-ID: <20220901074408.lnmyrc5fmsd3kqdf@yy-desk-7060>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <621bbca9e03f1350e393657da3f27f295b57a490.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <621bbca9e03f1350e393657da3f27f295b57a490.1659854790.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 07, 2022 at 03:01:26PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Because TDX support introduces private mapping, add a new member in union
> kvm_mmu_page_role with access functions to check the member.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

> ---
>  arch/x86/include/asm/kvm_host.h | 27 +++++++++++++++++++++++++++
>  arch/x86/kvm/mmu/mmu_internal.h | 11 +++++++++++
>  2 files changed, 38 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e07294fc2219..25835b8c4c12 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -334,7 +334,12 @@ union kvm_mmu_page_role {
>  		unsigned ad_disabled:1;
>  		unsigned guest_mode:1;
>  		unsigned passthrough:1;
> +#ifdef CONFIG_KVM_MMU_PRIVATE
> +		unsigned is_private:1;
> +		unsigned :4;
> +#else
>  		unsigned :5;
> +#endif
>
>  		/*
>  		 * This is left at the top of the word so that
> @@ -346,6 +351,28 @@ union kvm_mmu_page_role {
>  	};
>  };
>
> +#ifdef CONFIG_KVM_MMU_PRIVATE
> +static inline bool kvm_mmu_page_role_is_private(union kvm_mmu_page_role role)
> +{
> +	return !!role.is_private;
> +}
> +
> +static inline void kvm_mmu_page_role_set_private(union kvm_mmu_page_role *role)
> +{
> +	role->is_private = 1;
> +}
> +#else
> +static inline bool kvm_mmu_page_role_is_private(union kvm_mmu_page_role role)
> +{
> +	return false;
> +}
> +
> +static inline void kvm_mmu_page_role_set_private(union kvm_mmu_page_role *role)
> +{
> +	WARN_ON(1);
> +}
> +#endif
> +
>  /*
>   * kvm_mmu_extended_role complements kvm_mmu_page_role, tracking properties
>   * relevant to the current MMU configuration.   When loading CR0, CR4, or EFER,
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index e1b2e84c16b5..c9446e4e16e3 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -142,6 +142,17 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
>  	return kvm_mmu_role_as_id(sp->role);
>  }
>
> +static inline bool is_private_sp(const struct kvm_mmu_page *sp)
> +{
> +	return kvm_mmu_page_role_is_private(sp->role);
> +}
> +
> +static inline bool is_private_sptep(u64 *sptep)
> +{
> +	WARN_ON(!sptep);
> +	return is_private_sp(sptep_to_sp(sptep));
> +}
> +
>  static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
>  {
>  	/*
> --
> 2.25.1
>
