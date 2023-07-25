Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553E4761115
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 12:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbjGYKkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 06:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbjGYKkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 06:40:10 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78708194;
        Tue, 25 Jul 2023 03:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690281609; x=1721817609;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Jyr/C0uXdLTqSt8o11IlypH7yijyNPTn5qF6VHkHyus=;
  b=DPa+kMGng0tg+AHH8bKL35qpQlBHWUzmy3JWisZeMHLINiPdFvyRJ9XU
   fddPuQQc4vdp5/4XmwCHRxdsaXxgdN3XLRl+Mz67yewakXaxwlULSfKx3
   lvDUG4K+YbTyUiAMmNsbrf9yqtFmnPj540mVese/CqIZPx+Wix/3TERI7
   Nzpx6QqhAC7gGJfX2/nN42ESGjG7SetGuQ/Wp8NqwNCeLflp3dIflB29h
   L/PyHnBB92t0bEg6ak+iHtNs2ywpC70NTPw/XVxgcRiS1gz1HH4nMZosM
   AWOdn15yoQP38E01Ff+0aB5DOKK0BRwi955bew9ez1AfQuMQmLeee/ZiC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="352583079"
X-IronPort-AV: E=Sophos;i="6.01,230,1684825200"; 
   d="scan'208";a="352583079"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 03:39:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="791330038"
X-IronPort-AV: E=Sophos;i="6.01,230,1684825200"; 
   d="scan'208";a="791330038"
Received: from hegang-mobl.ccr.corp.intel.com (HELO localhost) ([10.254.212.56])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 03:39:48 -0700
Date:   Tue, 25 Jul 2023 18:39:45 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
Subject: Re: [PATCH 3/5] KVM: x86/mmu: Harden TDP MMU iteration against root
 w/o shadow page
Message-ID: <20230725103945.wfa5zdupen3oo6xl@linux.intel.com>
References: <20230722012350.2371049-1-seanjc@google.com>
 <20230722012350.2371049-4-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230722012350.2371049-4-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 21, 2023 at 06:23:48PM -0700, Sean Christopherson wrote:
> Explicitly check that tdp_iter_start() is handed a valid shadow page
> to harden KVM against bugs where

Sorry, where? 

It's not about guest using an invisible GFN, it's about a KVM bug, right?

> 
> Opportunistically stop the TDP MMU iteration instead of continuing on
> with garbage if the incoming root is bogus.  Attempting to walk a garbage
> root is more likely to caused major problems than doing nothing.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_iter.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> index d2eb0d4f8710..bd30ebfb2f2c 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.c
> +++ b/arch/x86/kvm/mmu/tdp_iter.c
> @@ -39,13 +39,14 @@ void tdp_iter_restart(struct tdp_iter *iter)
>  void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
>  		    int min_level, gfn_t next_last_level_gfn)
>  {
> -	int root_level = root->role.level;
> -
> -	WARN_ON(root_level < 1);
> -	WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
> +	if (WARN_ON_ONCE(!root || (root->role.level < 1) ||
> +			 (root->role.level > PT64_ROOT_MAX_LEVEL))) {
> +		iter->valid = false;
> +		return;
> +	}
>  

I saw many usages of WARN_ON_ONCE() and WARN_ON() in KVM. And just wonder,
is there any criteria for KVM when to use which?

B.R.
Yu
