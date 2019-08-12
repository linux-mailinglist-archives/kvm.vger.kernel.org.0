Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7AF8AB5B
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 01:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfHLXnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 19:43:37 -0400
Received: from mga17.intel.com ([192.55.52.151]:60892 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726453AbfHLXnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 19:43:37 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Aug 2019 16:43:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,379,1559545200"; 
   d="scan'208";a="181016662"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 12 Aug 2019 16:43:36 -0700
Date:   Mon, 12 Aug 2019 16:43:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mst@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com
Subject: Re: [PATCH v6 8/8] KVM: x86: Add user-space access interface for CET
 MSRs
Message-ID: <20190812234336.GF4996@linux.intel.com>
References: <20190725031246.8296-1-weijiang.yang@intel.com>
 <20190725031246.8296-9-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725031246.8296-9-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 25, 2019 at 11:12:46AM +0800, Yang Weijiang wrote:
> There're two different places storing Guest CET states, the states
> managed with XSAVES/XRSTORS, as restored/saved
> in previous patch, can be read/write directly from/to the MSRs.
> For those stored in VMCS fields, they're access via vmcs_read/
> vmcs_write.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 43 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 123285177c6b..e5eacd01e984 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1774,6 +1774,27 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		else
>  			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
>  		break;
> +	case MSR_IA32_S_CET:
> +		msr_info->data = vmcs_readl(GUEST_S_CET);
> +		break;
> +	case MSR_IA32_U_CET:
> +		rdmsrl(MSR_IA32_U_CET, msr_info->data);
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
> +		break;
> +	case MSR_IA32_PL0_SSP:
> +		rdmsrl(MSR_IA32_PL0_SSP, msr_info->data);
> +		break;
> +	case MSR_IA32_PL1_SSP:
> +		rdmsrl(MSR_IA32_PL1_SSP, msr_info->data);
> +		break;
> +	case MSR_IA32_PL2_SSP:
> +		rdmsrl(MSR_IA32_PL2_SSP, msr_info->data);
> +		break;
> +	case MSR_IA32_PL3_SSP:
> +		rdmsrl(MSR_IA32_PL3_SSP, msr_info->data);
> +		break;

These all need appropriate checks on guest and host support.  The guest
checks won't come into play very often, if ever, for the MSRs that exist
if IBT *or* SHSTK is supported due to passing the MSRs through to the
guest, but I don't think we want this code reliant on the interception
logic.  E.g.:

case MSR_IA32_S_CET:
	if (!(host_xss & XFEATURE_MASK_CET_KERNEL))
		return 1;

	if (!msr_info->host_initiated &&
	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
		return 1;

MSR_IA32_U_CET is same as above, s/KERNEL/USER.

case MSR_IA32_INT_SSP_TAB:
	if (!(host_xss & (XFEATURE_MASK_CET_KERNEL |
			  XFEATURE_MASK_CET_USER)))
		return 1;

	if (!msr_info->host_initiated &&
	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
		return 1;

MSR_IA32_PL[0-3]_SSP are same as above, but only check the appropriate
KERNEL or USER bit.

Note, the PL[0-2]_SSP MSRs can be collapsed into a single case, e.g.:

	case MSR_IA32_PL0_SSP ... MSR_IA32_PL2_SSP:
		<error handling code>;

		rdmsrl(msr_index, msr_info->data);
		break;


Rinse and repeat for vmx_set_msr().

>  	case MSR_TSC_AUX:
>  		if (!msr_info->host_initiated &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> @@ -2007,6 +2028,28 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		else
>  			vmx->pt_desc.guest.addr_a[index / 2] = data;
>  		break;
> +	case MSR_IA32_S_CET:
> +		vmcs_writel(GUEST_S_CET, data);
> +		break;
> +	case MSR_IA32_U_CET:
> +		wrmsrl(MSR_IA32_U_CET, data);
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
> +		break;
> +	case MSR_IA32_PL0_SSP:
> +		wrmsrl(MSR_IA32_PL0_SSP, data);
> +		break;
> +	case MSR_IA32_PL1_SSP:
> +		wrmsrl(MSR_IA32_PL1_SSP, data);
> +		break;
> +	case MSR_IA32_PL2_SSP:
> +		wrmsrl(MSR_IA32_PL2_SSP, data);
> +		break;
> +	case MSR_IA32_PL3_SSP:
> +		wrmsrl(MSR_IA32_PL3_SSP, data);
> +		break;
> +
>  	case MSR_TSC_AUX:
>  		if (!msr_info->host_initiated &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> -- 
> 2.17.2
> 
