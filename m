Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E51322A15E
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 23:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732511AbgGVV3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 17:29:09 -0400
Received: from mga12.intel.com ([192.55.52.136]:46331 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbgGVV3I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 17:29:08 -0400
IronPort-SDR: rdw+wh68tI1dl//h80bhPqAlHuv3yolTHqAtjco/DvublBIGTUaDcbQPtwNQ0yKZDGMGp6q3Zs
 pO1oKqAcljFA==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="129988817"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="129988817"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 14:29:08 -0700
IronPort-SDR: j+zAPLK7naFif5g1YPnLGXKI8v34030cxaNh+Y6FFylHvKgQLpcFsuhYCwiphwP/QTwpqtUrv0
 /MyJkfIX5Onw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="270863354"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 22 Jul 2020 14:29:08 -0700
Date:   Wed, 22 Jul 2020 14:29:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [RESEND v13 09/11] KVM: VMX: Add VMCS dump and sanity check for
 CET states
Message-ID: <20200722212907.GJ9114@linux.intel.com>
References: <20200716031627.11492-1-weijiang.yang@intel.com>
 <20200716031627.11492-10-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716031627.11492-10-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 16, 2020 at 11:16:25AM +0800, Yang Weijiang wrote:
> Dump CET VMCS states for debug purpose. Since CET kernel protection is
> not enabled, if related MSRs in host are filled by mistake, warn once on
> detecting it.

This all can be thrown into the enabling patch.  This isn't so much code that
it bloats the enabling patch, and the host MSRs being lost thing is confusing
without the context that KVM doesn't stuff them into the VMCS.

> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d465ff990094..5d4250b9dec8 100644

...

> @@ -8205,6 +8217,7 @@ static __init int hardware_setup(void)
>  	unsigned long host_bndcfgs;
>  	struct desc_ptr dt;
>  	int r, i, ept_lpage_level;
> +	u64 cet_msr;
>  
>  	store_idt(&dt);
>  	host_idt_base = dt.address;
> @@ -8365,6 +8378,16 @@ static __init int hardware_setup(void)
>  			return r;
>  	}
>  
> +	if (boot_cpu_has(X86_FEATURE_IBT) || boot_cpu_has(X86_FEATURE_SHSTK)) {
> +		rdmsrl(MSR_IA32_S_CET, cet_msr);
> +		WARN_ONCE(cet_msr, "KVM: CET S_CET in host will be lost!\n");
> +	}
> +
> +	if (boot_cpu_has(X86_FEATURE_SHSTK)) {
> +		rdmsrl(MSR_IA32_PL0_SSP, cet_msr);
> +		WARN_ONCE(cet_msr, "KVM: CET PL0_SSP in host will be lost!\n");
> +	}

Largely arbitrary, but I'd prefer to do these checks up near the BNDCFG check,
just so that all of these sorts of warnings are clustered together.

> +
>  	vmx_set_cpu_caps();
>  
>  	r = alloc_kvm_area();
> -- 
> 2.17.2
> 
