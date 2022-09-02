Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418AC5AA8B1
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 09:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbiIBHXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 03:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbiIBHXh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 03:23:37 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CC5B3B3B;
        Fri,  2 Sep 2022 00:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662103416; x=1693639416;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wZLQ2iSOhVUnOj3UfwaOf+/iZIGe4r2AZ6Zr30yTZJE=;
  b=Qx/2iA+Uw70R3TKNse3DyqL0GE3oWvxKTJ+QF69qJG+BPJfD507s3kgH
   uT0q5/uiwF3jxw9fy+XGpWU9XQk6TVP7Ig5j9dmK13entODHdf1zGeLED
   RDXAqEygddF119wjzqZiD0J3GEzkUJ/4mS+ZNmf7CPsODUZDm0jlNYMcP
   HfXQA9jflY5HVwiUA15OvkuYE9uLWGtxG2iI34dgAlyHXYdHssl0ezzvG
   l9kFTQ9Es1M1bZX146mhyWM1t0TLXwI2Dap76Hdfo3heXhachzd3LF91d
   cZPfRgf9zffMDu9glcj9L0Vn9Z3RMoGJdevQ6qhPJqrUPdEaHuO6K6T0B
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="296699235"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="296699235"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 00:23:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="674242310"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 02 Sep 2022 00:23:33 -0700
Date:   Fri, 2 Sep 2022 15:23:33 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 049/103] KVM: VMX: Move setting of EPT MMU masks to
 common VT-x code
Message-ID: <20220902072333.mz2wk76isdnenqph@yy-desk-7060>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <9ddd48b7a5458d3e0612af8265f36ca7f3255dc4.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ddd48b7a5458d3e0612af8265f36ca7f3255dc4.1659854790.git.isaku.yamahata@intel.com>
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

On Sun, Aug 07, 2022 at 03:01:34PM -0700, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> EPT MMU masks are used commonly for VMX and TDX.  The value needs to be
> initialized in common code before both VMX/TDX-specific initialization
> code.

The "VMX/TDX-specific initialization code" is not clear enough, the
patch moves the EPT MMU masks initialization AFTER
vmx_hardware_setup() and tdx_hardware_setup(), and these 2
hardware_setup functions are ahead of other VMX/TDX initializtion
code. I guess we can drop this patch ?

>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/main.c | 5 +++++
>  arch/x86/kvm/vmx/vmx.c  | 4 ----
>  2 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index ce12cc8276ef..9f4c3a0bcc12 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -4,6 +4,7 @@
>  #include "x86_ops.h"
>  #include "vmx.h"
>  #include "nested.h"
> +#include "mmu.h"
>  #include "pmu.h"
>  #include "tdx.h"
>
> @@ -26,6 +27,10 @@ static __init int vt_hardware_setup(void)
>
>  	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
>
> +	if (enable_ept)
> +		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
> +				      cpu_has_vmx_ept_execute_only());
> +
>  	return 0;
>  }
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3af8cd164274..db33c2808e0e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8209,10 +8209,6 @@ __init int vmx_hardware_setup(void)
>
>  	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
>
> -	if (enable_ept)
> -		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
> -				      cpu_has_vmx_ept_execute_only());
> -
>  	/*
>  	 * Setup shadow_me_value/shadow_me_mask to include MKTME KeyID
>  	 * bits to shadow_zero_check.
> --
> 2.25.1
>
