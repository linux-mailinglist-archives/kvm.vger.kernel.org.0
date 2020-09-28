Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC52A27B1C6
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 18:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgI1QYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 12:24:21 -0400
Received: from mga06.intel.com ([134.134.136.31]:39065 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgI1QYV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 12:24:21 -0400
IronPort-SDR: tsYigJ/F0UdptpI9nXmnkp652Sx6/furKMmeTq6+4GdZhIf4O289BHlQtqEb+v2QyjRqCCxTBQ
 YPI/TVb0adLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="223616540"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="223616540"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 09:24:19 -0700
IronPort-SDR: 1B3FE5vxGxHDeo79fUzTdH701ulI1W71N0yQ7ZH2M/l8Jtp3tvjTy0+zzrcY/tULOJ84elq+9I
 8cig0uxH6gsQ==
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="350781290"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 09:24:18 -0700
Date:   Mon, 28 Sep 2020 09:24:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH 1/2] kvm/x86: intercept guest changes to X86_CR4_LA57
Message-ID: <20200928162417.GA28825@linux.intel.com>
References: <20200928083047.3349-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928083047.3349-1-jiangshanlai@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 28, 2020 at 04:30:46PM +0800, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> When shadowpaping is enabled, guest should not be allowed
> to toggle X86_CR4_LA57. And X86_CR4_LA57 is a rarely changed
> bit, so we can just intercept all the attempts to toggle it
> no matter shadowpaping is in used or not.
> 
> Fixes: fd8cb433734ee ("KVM: MMU: Expose the LA57 feature to VM.")
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>   No test to toggle X86_CR4_LA57 in guest since I can't access to
>   any CPU supports it. Maybe it is not a real problem.

LA57 doesn't need to be intercepted.  It can't be toggled in 64-bit mode
(causes a #GP), and it's ignored in 32-bit mode.  That means LA57 can only
take effect when 64-bit mode is enabled, at which time KVM will update its
MMU context accordingly.

>  arch/x86/kvm/kvm_cache_regs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index cfe83d4ae625..ca0781b41df9 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -7,7 +7,7 @@
>  #define KVM_POSSIBLE_CR0_GUEST_BITS X86_CR0_TS
>  #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
>  	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
> -	 | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_PGE | X86_CR4_TSD)
> +	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD)
>  
>  #define BUILD_KVM_GPR_ACCESSORS(lname, uname)				      \
>  static __always_inline unsigned long kvm_##lname##_read(struct kvm_vcpu *vcpu)\
> -- 
> 2.19.1.6.gb485710b
> 
