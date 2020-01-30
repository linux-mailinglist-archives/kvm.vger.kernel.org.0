Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF66714D4BA
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 01:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgA3AjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 19:39:06 -0500
Received: from mga06.intel.com ([134.134.136.31]:50326 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbgA3AjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 19:39:05 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 16:38:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="229788654"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 29 Jan 2020 16:38:40 -0800
Date:   Wed, 29 Jan 2020 16:38:40 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/26] KVM: x86: Handle main Intel PT CPUID leaf in
 vendor code
Message-ID: <20200130003840.GA24606@linux.intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com>
 <20200129234640.8147-26-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200129234640.8147-26-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 29, 2020 at 03:46:39PM -0800, Sean Christopherson wrote:
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index d06fb54c9c0d..ca766c460318 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -409,7 +409,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  	unsigned f_gbpages = 0;
>  	unsigned f_lm = 0;
>  #endif
> -	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
>  
>  	/* cpuid 1.edx */
>  	const u32 kvm_cpuid_1_edx_x86_features =
> @@ -648,22 +647,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  		break;
>  	}
>  	/* Intel PT */
> -	case 0x14: {
> -		int t, times = entry->eax;
> -
> -		if (!f_intel_pt) {
> -			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> -			break;
> -		}
> -
> -		for (t = 1; t <= times; ++t) {
> -			if (*nent >= maxnent)
> -				goto out;
> -			do_host_cpuid(&entry[t], function, t);
> -			++*nent;
> -		}
> +	case 0x14:
>  		break;
> -	}
>  	case KVM_CPUID_SIGNATURE: {
>  		static const char signature[12] = "KVMKVMKVM\0\0";
>  		const u32 *sigptr = (const u32 *)signature;
> @@ -778,6 +763,21 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  
>  	kvm_x86_ops->set_supported_cpuid(entry);
>  
> +	/*
> +	 * Add feature-dependent sub-leafs after ->set_supported_cpuid() to
> +	 * properly handle the feature being disabled by SVM/VMX.
> +	 */
> +	if (function == 0x14) {
> +		int t, times = entry->eax;
> +
> +		for (t = 1; t <= times; ++t) {
> +			if (*nent >= maxnent)
> +				goto out;
> +			do_host_cpuid(&entry[t], function, t);
> +			++*nent;
> +		}
> +	}
> +
>  	r = 0;

I belatedly thought of an alternative that I think I like better.  Instead
of adding the sub-leafs in common code, introduce a new kvm_x86_ops hook to
add vendor specific sub-leafs, e.g.:

        kvm_x86_ops->set_supported_cpuid(entry);

        r = kvm_x86_ops->add_cpuid_sub_leafs(entry, nent, maxent,
					     do_host_cpuid);

That gets Intel PT (and SGX if/when it gets merged) sub-leafs out of the
common x86 code without polluting ->set_supported_cpuid with the extra
params and return value.  The other hiccup is that SGX will want access to
cpuid_mask(), but I don't see an issue with moving that to cpuid.h.
