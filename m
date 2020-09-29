Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040D127BB4F
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 05:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgI2DNo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 23:13:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:48888 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgI2DNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 23:13:43 -0400
IronPort-SDR: ZAXWmCA/aiYj1IZQlVLtBznq5qO3dKxtbtpMpOGfq4uS5qsrsxCyO1vnlNhED+2RqrApHVX23e
 cv5u6l40nRdw==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="180260932"
X-IronPort-AV: E=Sophos;i="5.77,316,1596524400"; 
   d="scan'208";a="180260932"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 20:13:43 -0700
IronPort-SDR: oqJKntNQQ7OsFrbWSvU0KKwvEI/MzZEgbi7ox6mn0kQs960dmSYL8CFbzDgm0jBfAGVcgX0ZYs
 /hPV2Dy1X9gA==
X-IronPort-AV: E=Sophos;i="5.77,316,1596524400"; 
   d="scan'208";a="488869172"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 20:13:43 -0700
Date:   Mon, 28 Sep 2020 20:13:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 02/10] KVM: x86/vmx: Make vmx_set_intercept_for_msr()
 non-static and expose it
Message-ID: <20200929031342.GD31514@linux.intel.com>
References: <20200726153229.27149-1-like.xu@linux.intel.com>
 <20200726153229.27149-4-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200726153229.27149-4-like.xu@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jul 26, 2020 at 11:32:21PM +0800, Like Xu wrote:
> It's reasonable to call vmx_set_intercept_for_msr() in other vmx-specific
> files (e.g. pmu_intel.c), so expose it without semantic changes hopefully.

I suppose it's reasonable, but you still need to state what is actually
going to use it.

> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 4 ++--
>  arch/x86/kvm/vmx/vmx.h | 2 ++
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index dcde73a230c6..162c668d58f5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3772,8 +3772,8 @@ static __always_inline void vmx_enable_intercept_for_msr(unsigned long *msr_bitm
>  	}
>  }
>  
> -static __always_inline void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
> -			     			      u32 msr, int type, bool value)
> +__always_inline void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
> +					 u32 msr, int type, bool value)
>  {
>  	if (value)
>  		vmx_enable_intercept_for_msr(msr_bitmap, msr, type);
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 0d06951e607c..08c850596cfc 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -356,6 +356,8 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
>  int vmx_find_msr_index(struct vmx_msrs *m, u32 msr);
>  int vmx_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
>  			      struct x86_exception *e);
> +void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
> +			      u32 msr, int type, bool value);

This completely defeats the purpose of __always_inline.

>  
>  #define POSTED_INTR_ON  0
>  #define POSTED_INTR_SN  1
> -- 
> 2.21.3
> 
