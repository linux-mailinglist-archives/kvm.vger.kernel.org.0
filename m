Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9914026E067
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 18:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgIQQO2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 12:14:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:20191 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728325AbgIQQNV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 12:13:21 -0400
IronPort-SDR: UtgzDv6uhSynXL1KJBrA75X0OfX4RZZvwbhFS6hYk0+E45c9w808362+Xqecq38TV3s5mgdqTz
 cYeokyTNcABA==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="147424427"
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="147424427"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 09:11:40 -0700
IronPort-SDR: 2IvSOp2DGDUp0NJPU/N1ucVV6d2TAuY3TScq5Xr8NAcaY6qiLx+dq52cUFwWYxJI3UaNdsdLmb
 5OMhNHAa0afA==
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="287636163"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 09:11:38 -0700
Date:   Thu, 17 Sep 2020 09:11:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/1] KVM: x86: fix MSR_IA32_TSC read for nested migration
Message-ID: <20200917161135.GC13522@sjchrist-ice>
References: <20200917110723.820666-1-mlevitsk@redhat.com>
 <20200917110723.820666-2-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917110723.820666-2-mlevitsk@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 17, 2020 at 02:07:23PM +0300, Maxim Levitsky wrote:
> MSR reads/writes should always access the L1 state, since the (nested)
> hypervisor should intercept all the msrs it wants to adjust, and these
> that it doesn't should be read by the guest as if the host had read it.
> 
> However IA32_TSC is an exception.Even when not intercepted, guest still

Missing a space after the period.

> reads the value + TSC offset.
> The write however does not take any TSC offset in the account.

s/in the/into

> This is documented in Intel's PRM and seems also to happen on AMD as well.

Ideally we'd get confirmation from AMD that this is the correct behavior.

> This creates a problem when userspace wants to read the IA32_TSC value and then
> write it. (e.g for migration)
> 
> In this case it reads L2 value but write is interpreted as an L1 value.

It _may_ read the L2 value, e.g. it's not going to read the L2 value if L1
is active.

> To fix this make the userspace initiated reads of IA32_TSC return L1 value
> as well.
> 
> Huge thanks to Dave Gilbert for helping me understand this very confusing
> semantic of MSR writes.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 17f4995e80a7e..d10d5c6add359 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2025,6 +2025,11 @@ u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
>  }
>  EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
>  
> +static u64 kvm_read_l2_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)

This is definitely not L2 specific.  I would vote to just omit the helper so
that we don't need to come up with a name that is correct across the board,
e.g. "raw" is also not quite correct.

An alternative would be to do:

	u64 tsc_offset = msr_info->host_initiated ? vcpu->arch.l1_tsc_offset :
						    vcpu->arch.tsc_offset;

	msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + tsc_offset;

Which I kind of like because the behavioral difference is a bit more obvious.

> +{
> +	return vcpu->arch.tsc_offset + kvm_scale_tsc(vcpu, host_tsc);
> +}
> +
>  static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
>  {
>  	vcpu->arch.l1_tsc_offset = offset;
> @@ -3220,7 +3225,19 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		msr_info->data = vcpu->arch.msr_ia32_power_ctl;
>  		break;
>  	case MSR_IA32_TSC:
> -		msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + vcpu->arch.tsc_offset;
> +		/*
> +		 * Intel PRM states that MSR_IA32_TSC read adds the TSC offset
> +		 * even when not intercepted. AMD manual doesn't define this
> +		 * but appears to behave the same
> +		 *
> +		 * However when userspace wants to read this MSR, return its
> +		 * real L1 value so that its restore will be correct
> +		 *

Extra line is unnecessary.

> +		 */
> +		if (msr_info->host_initiated)
> +			msr_info->data = kvm_read_l1_tsc(vcpu, rdtsc());
> +		else
> +			msr_info->data = kvm_read_l2_tsc(vcpu, rdtsc());
>  		break;
>  	case MSR_MTRRcap:
>  	case 0x200 ... 0x2ff:
> -- 
> 2.26.2
> 
