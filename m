Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED2A9A3DA9
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 20:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbfH3S0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Aug 2019 14:26:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:19154 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbfH3S0f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Aug 2019 14:26:35 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Aug 2019 11:26:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,447,1559545200"; 
   d="scan'208";a="265399032"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 30 Aug 2019 11:26:34 -0700
Date:   Fri, 30 Aug 2019 11:26:34 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 3/7] KVM: VMX: Add helper to check reserved bits in
 MSR_CORE_PERF_GLOBAL_CTRL
Message-ID: <20190830182634.GF15405@linux.intel.com>
References: <20190828234134.132704-1-oupton@google.com>
 <20190828234134.132704-4-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828234134.132704-4-oupton@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 04:41:30PM -0700, Oliver Upton wrote:
> Creating a helper function to check the validity of the

Changelogs should use imperative mood, e.g.:

  Create a helper function to check...

> {HOST,GUEST}_IA32_PERF_GLOBAL_CTRL wrt the PMU's global_ctrl_mask.

As is, this needs the SDM quote from patch 4/7 as it's not clear what
global_ctrl_mask contains, e.g. the check looks inverted to the
uninitiated.   Adding a helper without a user is also discouraged,
e.g. if the helper is broken then bisection would point at the next
patch, so this should really be folded in to patch 4/7 anyways.

That being said, if you tweak the prototype (see below) then you can
use it intel_pmu_set_msr(), in which case a standalone patch does make
sense.
 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/kvm/pmu.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 58265f761c3b..b7d9efff208d 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -79,6 +79,17 @@ static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
>  	return kvm_x86_ops->pmu_ops->pmc_is_enabled(pmc);
>  }
>  
> +static inline bool kvm_is_valid_perf_global_ctrl(struct kvm_vcpu *vcpu,

If this takes 'struct kvm_pmu *pmu' instead of a vcpu then it can also
be used in intel_pmu_set_msr().

> +						 u64 global_ctrl)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +
> +	if (pmu->global_ctrl_mask & global_ctrl)

intel_pmu_set_msr() allows 'global_ctrl == data' regardless of the mask,
do we need simliar code here?

> +		return false;
> +
> +	return true;

Or simply

	return !(pmu->global_ctrl_mask & global_ctrl);

> +}
> +
>  /* returns general purpose PMC with the specified MSR. Note that it can be
>   * used for both PERFCTRn and EVNTSELn; that is why it accepts base as a
>   * paramenter to tell them apart.
> -- 
> 2.23.0.187.g17f5b7556c-goog
> 
