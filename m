Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B79A7A0BE5
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 19:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239182AbjINRlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 13:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjINRlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 13:41:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60171FD6;
        Thu, 14 Sep 2023 10:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694713257; x=1726249257;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LtbuDSsztWnOmxu/fXCyELi3w8i23rVG8Fg+ropBx0Y=;
  b=JSnqHtAPjolcjysd0D4culUZWNXtcFGqgHLPo4YrtB4Kyx+23N9YBvz7
   4ttz6BeUHguDR5pq/jHh3Rjp81XvXa+iu6TZmel3dA77NICYJxO69b6/J
   3j6V5xt6hc6dvr1/Wgly9qNpuc0E2oD+Qlj6Ukvo1xxSaerAMUGlb7rGh
   IcQfbkh5Psa1a069gaJmZ9OjT1BIzIUPXqiuIrV95v7nDzh1ar6ViBAym
   lnR7I6TBfRSi9LhpkzHKlOuXCHszsLHphaLIwxguWfEZY5UCdtH3SCd/u
   V3ZvhtXJ64TkJyjQl3S8Zs1EaXT8l/rWWkDvQzTVHZ6QzffIIpTKXkHx7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="409967360"
X-IronPort-AV: E=Sophos;i="6.02,146,1688454000"; 
   d="scan'208";a="409967360"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 10:40:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="868332473"
X-IronPort-AV: E=Sophos;i="6.02,146,1688454000"; 
   d="scan'208";a="868332473"
Received: from spswartz-mobl.amr.corp.intel.com (HELO [10.209.21.97]) ([10.209.21.97])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 10:40:55 -0700
Message-ID: <e0db6ffd-5d92-2a1a-bdfb-a190fe1ccd25@intel.com>
Date:   Thu, 14 Sep 2023 10:40:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v6 06/25] x86/fpu/xstate: Opt-in kernel dynamic bits when
 calculate guest xstate size
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-7-weijiang.yang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230914063325.85503-7-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/13/23 23:33, Yang Weijiang wrote:
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -1636,9 +1636,17 @@ static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
>  
>  	/* Calculate the resulting kernel state size */
>  	mask = permitted | requested;
> -	/* Take supervisor states into account on the host */
> +	/*
> +	 * Take supervisor states into account on the host. And add
> +	 * kernel dynamic xfeatures to guest since guest kernel may
> +	 * enable corresponding CPU feaures and the xstate registers
> +	 * need to be saved/restored properly.
> +	 */
>  	if (!guest)
>  		mask |= xfeatures_mask_supervisor();
> +	else
> +		mask |= fpu_kernel_dynamic_xfeatures;
> +
>  	ksize = xstate_calculate_size(mask, compacted);

Heh, you changed the "guest" naming in "fpu_kernel_dynamic_xfeatures"
but didn't change the logic.

As it's coded at the moment *ALL* "fpu_kernel_dynamic_xfeatures" are
guest xfeatures.  So, they're different in name only.

If you want to change the rules for guests, we have *ONE* place that's
done: fpstate_reset().  It establishes the permissions and the sizes for
the default guest FPU.  Start there.  If you want to make the guest
defaults include XFEATURE_CET_USER, then you need to put the bit in *there*.

The other option is to have the KVM code actually go and "request" that
the dynamic states get added to 'fpu->guest_perm'.  Would there ever be
any reason for KVM to be on a system which supports a dynamic kernel
feature but where it doesn't get enabled for guest use, or at least
shouldn't have the FPU space allocated?
