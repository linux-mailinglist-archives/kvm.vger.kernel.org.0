Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B88E8AA4A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 00:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfHLWSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 18:18:12 -0400
Received: from mga12.intel.com ([192.55.52.136]:56539 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbfHLWSM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 18:18:12 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Aug 2019 15:18:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,379,1559545200"; 
   d="scan'208";a="327494056"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 12 Aug 2019 15:18:11 -0700
Date:   Mon, 12 Aug 2019 15:18:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mst@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com
Subject: Re: [PATCH v6 2/8] KVM: x86: Add a helper function for
 CPUID(0xD,n>=1) enumeration
Message-ID: <20190812221811.GB4996@linux.intel.com>
References: <20190725031246.8296-1-weijiang.yang@intel.com>
 <20190725031246.8296-3-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725031246.8296-3-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 25, 2019 at 11:12:40AM +0800, Yang Weijiang wrote:
> To make the code look clean, wrap CPUID(0xD,n>=1) enumeration
> code in a helper function now.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 4992e7c99588..29cbde7538a3 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -313,6 +313,50 @@ static int __do_cpuid_ent_emulated(struct kvm_cpuid_entry2 *entry,
>  	return 0;
>  }
>  
> +static inline int __do_cpuid_dx_leaf(struct kvm_cpuid_entry2 *entry, int *nent,

'dx' makes me think of the generic reference to RDX vs EDX.  Maybe
__do_cpuid_0xd_leaf()?

> +				     int maxnent, u64 xss_mask, u64 xcr0_mask,
> +				     u32 eax_mask)
> +{
> +	int idx, i;
> +	u64 mask;
> +	u64 supported;
> +
> +	for (idx = 1, i = 1; idx < 64; ++idx) {

Rather than loop here, I think it makes sense to loop in the caller to
make the code consistent with do_cpuid_7_mask() added by commit

  54d360d41211 ("KVM: cpuid: extract do_cpuid_7_mask and support multiple subleafs")

> +		mask = ((u64)1 << idx);
> +		if (*nent >= maxnent)
> +			return -EINVAL;
> +
> +		do_cpuid_1_ent(&entry[i], 0xD, idx);
> +		if (idx == 1) {
> +			entry[i].eax &= eax_mask;
> +			cpuid_mask(&entry[i].eax, CPUID_D_1_EAX);
> +			supported = xcr0_mask | xss_mask;
> +			entry[i].ebx = 0;
> +			entry[i].edx = 0;
> +			entry[i].ecx &= xss_mask;
> +			if (entry[i].eax & (F(XSAVES) | F(XSAVEC))) {
> +				entry[i].ebx =
> +					xstate_required_size(supported,
> +							     true);
> +			}
> +		} else {
> +			supported = (entry[i].ecx & 1) ? xss_mask :
> +				     xcr0_mask;
> +			if (entry[i].eax == 0 || !(supported & mask))
> +				continue;
> +			entry[i].ecx &= 1;
> +			entry[i].edx = 0;
> +			if (entry[i].ecx)
> +				entry[i].ebx = 0;
> +		}
> +		entry[i].flags |=
> +			KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> +		++*nent;
> +		++i;
> +	}
> +	return 0;
> +}
> +

Extracting code into a helper should be done in the same patch that the
existing code is replaced with a call to the helper, i.e. the chunk of the
next patch that invokes the helper should be squashed with this patch.

>  static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  				 u32 index, int *nent, int maxnent)
>  {
> -- 
> 2.17.2
> 
