Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFC51B61D9
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 19:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbgDWRUd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 13:20:33 -0400
Received: from mga03.intel.com ([134.134.136.65]:61994 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729673AbgDWRUd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 13:20:33 -0400
IronPort-SDR: 2bwoYOm0LsG1M8Irxk0f8XxjU90ucpK9nbMtCzqK1aluy0vDQd0yN5BqA8ST5Nm72JWOaIJ2L5
 g+NGBARfT+YA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 10:20:32 -0700
IronPort-SDR: LWUiK1gN/OvI+iuLB4DyOrg8eobfD24oQh6h9eiO+ieYEsaZAM/aVGYZAG+xN1AHhBPOpa+X9Q
 wFVPLyQe8ADA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="246323687"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 23 Apr 2020 10:20:32 -0700
Date:   Thu, 23 Apr 2020 10:20:32 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 4/9] KVM: VMX: Check CET dependencies on CR settings
Message-ID: <20200423172032.GI17824@linux.intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-5-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326081847.5870-5-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 26, 2020 at 04:18:41PM +0800, Yang Weijiang wrote:
> CR4.CET is master control bit for CET function.
> There're mutual constrains between CR0.WP and CR4.CET, so need
> to check the dependent bit while changing the control registers.
> 
> Note:
> 1)The processor does not allow CR4.CET to be set if CR0.WP = 0,
>   similarly, it does not allow CR0.WP to be cleared while
>   CR4.CET = 1. In either case, KVM would inject #GP to guest.

Nit: the CET vs. WP dependency and #GP belongs in the "main" part of the
changelog, as it's the crux of the patch.  Item (2) below is more along
the lines of "note" material.

> 
> 2)SHSTK and IBT features share one control MSR:
>   MSR_IA32_{U,S}_CET, which means it's difficult to hide
>   one feature from another in the case of SHSTK != IBT,
>   after discussed in community, it's agreed to allow guest
>   control two features independently as it won't introduce
>   security hole.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 4 ++++
>  arch/x86/kvm/x86.c     | 3 +++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bd7cd175fd81..87f101750746 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3089,6 +3089,10 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  			return 1;
>  	}
>  
> +	if ((cr4 & X86_CR4_CET) && (!is_cet_supported(vcpu) ||
> +	    !(kvm_read_cr0(vcpu) & X86_CR0_WP)))
> +		return 1;
> +
>  	if (vmx->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
>  		return 1;
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 830afe5038d1..90acdbbb8a5a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -804,6 +804,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
>  		return 1;
>  
> +	if (!(cr0 & X86_CR0_WP) && kvm_read_cr4_bits(vcpu, X86_CR4_CET))
> +		return 1;
> +
>  	kvm_x86_ops->set_cr0(vcpu, cr0);
>  
>  	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
> -- 
> 2.17.2
> 
