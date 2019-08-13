Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF0E8AEE1
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 07:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfHMFkJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 01:40:09 -0400
Received: from mga18.intel.com ([134.134.136.126]:19822 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbfHMFkJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 01:40:09 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Aug 2019 22:39:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,380,1559545200"; 
   d="scan'208";a="187670758"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga002.jf.intel.com with ESMTP; 12 Aug 2019 22:39:41 -0700
Date:   Tue, 13 Aug 2019 13:41:24 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, mst@redhat.com,
        rkrcmar@redhat.com, jmattson@google.com
Subject: Re: [PATCH v6 8/8] KVM: x86: Add user-space access interface for CET
 MSRs
Message-ID: <20190813054124.GB2432@local-michael-cet-test>
References: <20190725031246.8296-1-weijiang.yang@intel.com>
 <20190725031246.8296-9-weijiang.yang@intel.com>
 <20190812234336.GF4996@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812234336.GF4996@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 12, 2019 at 04:43:36PM -0700, Sean Christopherson wrote:
> On Thu, Jul 25, 2019 at 11:12:46AM +0800, Yang Weijiang wrote:
> > There're two different places storing Guest CET states, the states
> > managed with XSAVES/XRSTORS, as restored/saved
> > in previous patch, can be read/write directly from/to the MSRs.
> > For those stored in VMCS fields, they're access via vmcs_read/
> > vmcs_write.
> > 
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 43 ++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 43 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 123285177c6b..e5eacd01e984 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -1774,6 +1774,27 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  		else
> >  			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
> >  		break;
> > +	case MSR_IA32_S_CET:
> > +		msr_info->data = vmcs_readl(GUEST_S_CET);
> > +		break;
> > +	case MSR_IA32_U_CET:
> > +		rdmsrl(MSR_IA32_U_CET, msr_info->data);
> > +		break;
> > +	case MSR_IA32_INT_SSP_TAB:
> > +		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
> > +		break;
> > +	case MSR_IA32_PL0_SSP:
> > +		rdmsrl(MSR_IA32_PL0_SSP, msr_info->data);
> > +		break;
> > +	case MSR_IA32_PL1_SSP:
> > +		rdmsrl(MSR_IA32_PL1_SSP, msr_info->data);
> > +		break;
> > +	case MSR_IA32_PL2_SSP:
> > +		rdmsrl(MSR_IA32_PL2_SSP, msr_info->data);
> > +		break;
> > +	case MSR_IA32_PL3_SSP:
> > +		rdmsrl(MSR_IA32_PL3_SSP, msr_info->data);
> > +		break;
> 
> These all need appropriate checks on guest and host support.  The guest
> checks won't come into play very often, if ever, for the MSRs that exist
> if IBT *or* SHSTK is supported due to passing the MSRs through to the
> guest, but I don't think we want this code reliant on the interception
> logic.  E.g.:
> 
> case MSR_IA32_S_CET:
> 	if (!(host_xss & XFEATURE_MASK_CET_KERNEL))
> 		return 1;
> 
> 	if (!msr_info->host_initiated &&
> 	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
> 	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
> 		return 1;
> 
> MSR_IA32_U_CET is same as above, s/KERNEL/USER.
> 
> case MSR_IA32_INT_SSP_TAB:
> 	if (!(host_xss & (XFEATURE_MASK_CET_KERNEL |
> 			  XFEATURE_MASK_CET_USER)))
> 		return 1;
> 
> 	if (!msr_info->host_initiated &&
> 	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
> 		return 1;
> 
> MSR_IA32_PL[0-3]_SSP are same as above, but only check the appropriate
> KERNEL or USER bit.
> 
> Note, the PL[0-2]_SSP MSRs can be collapsed into a single case, e.g.:
> 
> 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL2_SSP:
> 		<error handling code>;
> 
> 		rdmsrl(msr_index, msr_info->data);
> 		break;
> 
> 
> Rinse and repeat for vmx_set_msr().
>
Thanks you, will modify this part of code.

> >  	case MSR_TSC_AUX:
> >  		if (!msr_info->host_initiated &&
> >  		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> > @@ -2007,6 +2028,28 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  		else
> >  			vmx->pt_desc.guest.addr_a[index / 2] = data;
> >  		break;
> > +	case MSR_IA32_S_CET:
> > +		vmcs_writel(GUEST_S_CET, data);
> > +		break;
> > +	case MSR_IA32_U_CET:
> > +		wrmsrl(MSR_IA32_U_CET, data);
> > +		break;
> > +	case MSR_IA32_INT_SSP_TAB:
> > +		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
> > +		break;
> > +	case MSR_IA32_PL0_SSP:
> > +		wrmsrl(MSR_IA32_PL0_SSP, data);
> > +		break;
> > +	case MSR_IA32_PL1_SSP:
> > +		wrmsrl(MSR_IA32_PL1_SSP, data);
> > +		break;
> > +	case MSR_IA32_PL2_SSP:
> > +		wrmsrl(MSR_IA32_PL2_SSP, data);
> > +		break;
> > +	case MSR_IA32_PL3_SSP:
> > +		wrmsrl(MSR_IA32_PL3_SSP, data);
> > +		break;
> > +
> >  	case MSR_TSC_AUX:
> >  		if (!msr_info->host_initiated &&
> >  		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> > -- 
> > 2.17.2
> > 
