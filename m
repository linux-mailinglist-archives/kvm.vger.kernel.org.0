Return-Path: <kvm+bounces-65521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C441FCAE979
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 02:14:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DE60630345AE
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 01:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D919F27464F;
	Tue,  9 Dec 2025 01:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tMiNyH77"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5471226529A
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 01:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765242750; cv=none; b=onX8XMonXUoZV60xrFJuW6qbTXsRC1LoWCJxvcAaKSlnpBwzGLA0ku3SCIOsSnPeGI8jQ5MWSqLqQVNh/i/U/WFlEVzDl+Hdj64x8lttDudhqMwynRbDC/en3ANxHxc0M2hDStndAMMGFnCVeUHibFmc72IaiMmcsyaAOHru4IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765242750; c=relaxed/simple;
	bh=uxzxSh6XqqIsyFkEYWO9Wk6W+z2pNBZTbUCzcYNve+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=axjXewVXnekAnL8aoyAHaCCEzlkMEht5dubt8zHnny1iOYiuIG8/8dGaHG7DWC4xf/YREIN2Ulbh/tyJDO7qyXRZx07OugjBx2qQBwC/Ei+TIinNJTJJXLP200nplEy0VXszLsuR+WVbw2KMDr7SaibCDS5z1vfLYSkyNUo66Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tMiNyH77; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 9 Dec 2025 01:12:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765242746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j+yk7GYYARc+z1aHYLAKaaIC27BnMabXFcj4H+AZ2f8=;
	b=tMiNyH77s7Jn6Wm5/kWjGHx9mjE2mOgGimcJ1Ukg0JMtV0TTvpckbzuVnPeSzwbvUPZdJg
	wxjmnc7KqIuPKMaUBGse2roL2ObeyehkC25ERQNTfq8jbEsznTGsss6UxZ8Vs8xOQglU5t
	rczM6Gkeg+usub5lx3DeqYlokZNsl+E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kevin Cheng <chengkev@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, jmattson@google.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: Don't allow L1 intercepts for instructions not
 advertised
Message-ID: <fe445lu6g3x5tq2dhz43apvy5tw66nt53kbbprg5t74josbtm5@rp5iogfmylnv>
References: <20251205070630.4013452-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205070630.4013452-1-chengkev@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Dec 05, 2025 at 07:06:30AM +0000, Kevin Cheng wrote:
> If a feature is not advertised in the guest's CPUID, prevent L1 from
> intercepting the unsupported instructions by clearing the corresponding
> intercept in KVM's cached vmcb12.
> 
> When an L2 guest executes an instruction that is not advertised to L1,
> we expect a #UD exception to be injected by L0. However, the nested svm
> exit handler first checks if the instruction intercept is set in vmcb12,
> and if so, synthesizes an exit from L2 to L1 instead of a #UD exception.
> If a feature is not advertised, the L1 intercept should be ignored.
> 
> Calculate the nested intercept mask by checking all instructions that
> can be intercepted and are controlled by a CPUID bit. Use this mask when
> copying from the vmcb12 to KVM's cached vmcb12 to effectively ignore the
> intercept on nested vm exit handling.
> 
> Another option is to handle ignoring the L1 intercepts in the nested vm
> exit code path, but I've gone with modifying the cached vmcb12 to keep
> it simpler.

Basically instead of masking the intercept bits in
__nested_copy_vmcb_control_to_cache(), we'd need to do it in both:
- recalc_intercepts() (on copying from g->intercepts to c->intercepts).
- vmcb12_is_intercept().

The current approach has the advantage of applying to any future uses of
the intercepts bits in the VMCB12 as well. The alternative approach has
the advantage of not modifying the intercept bits in the cached VMCB12,
which avoids any potential bugs in the future if we ever directly copy
from the cached VMCB12 to L1's VMCB12.

I think the latter is easier to test for, the new test case in KUTs [*]
could just verify that the ignored intercept bits are not cleared in the
VMCB.

So I prefer the current approach (with the added testing).

[*]https://lore.kernel.org/kvm/20251205081448.4062096-3-chengkev@google.com/

> 
> Signed-off-by: Kevin Cheng <chengkev@google.com>
> ---
>  arch/x86/kvm/svm/nested.c | 30 +++++++++++++++++++++++++++++-
>  arch/x86/kvm/svm/svm.c    |  2 ++
>  arch/x86/kvm/svm/svm.h    | 14 ++++++++++++++
>  3 files changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index c81005b245222..f2ade24908b39 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -184,6 +184,33 @@ void recalc_intercepts(struct vcpu_svm *svm)
>  	}
>  }
> 
> +/*
> + * If a feature is not advertised to L1, set the mask bit for the corresponding
> + * vmcb12 intercept.
> + */
> +void svm_recalc_nested_intercepts_mask(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	memset(svm->nested.nested_intercept_mask, 0,
> +	       sizeof(svm->nested.nested_intercept_mask));
> +
> +	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP))
> +		set_nested_intercept_mask(&svm->nested, INTERCEPT_RDTSCP);
> +
> +	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SKINIT))
> +		set_nested_intercept_mask(&svm->nested, INTERCEPT_SKINIT);
> +
> +	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE))
> +		set_nested_intercept_mask(&svm->nested, INTERCEPT_XSETBV);
> +
> +	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_RDPRU))
> +		set_nested_intercept_mask(&svm->nested, INTERCEPT_RDPRU);
> +
> +	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_INVPCID))
> +		set_nested_intercept_mask(&svm->nested, INTERCEPT_INVPCID);
> +}
> +

set_nested_intercept_mask() is only used here AFAICT, so maybe just
define it as a static function above
svm_recalc_nested_intercepts_mask()?

>  /*
>   * This array (and its actual size) holds the set of offsets (indexing by chunk
>   * size) to process when merging vmcb12's MSRPM with vmcb01's MSRPM.  Note, the
> @@ -408,10 +435,11 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
>  					 struct vmcb_ctrl_area_cached *to,
>  					 struct vmcb_control_area *from)
>  {
> +	struct vcpu_svm *svm = to_svm(vcpu);
>  	unsigned int i;
> 
>  	for (i = 0; i < MAX_INTERCEPT; i++)
> -		to->intercepts[i] = from->intercepts[i];
> +		to->intercepts[i] = from->intercepts[i] & ~(svm->nested.nested_intercept_mask[i]);
> 
>  	to->iopm_base_pa        = from->iopm_base_pa;
>  	to->msrpm_base_pa       = from->msrpm_base_pa;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f56c2d895011c..dd02a076077d8 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1011,6 +1011,8 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
>  			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
>  		}
>  	}
> +
> +	svm_recalc_nested_intercepts_mask(vcpu);

svm_recalc_nested_intercepts_mask() is also only used here, but I think
there's a general preference to keep nested helpers defined in nested.c,
even if not used there (e.g. nested_svm_check_permissions(),
nested_svm_vmrun()). So I think leave that one as-is.

>  }
> 
>  static void svm_recalc_intercepts(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 9e151dbdef25d..08779d78c0c27 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -217,6 +217,12 @@ struct svm_nested_state {
>  	 * on its side.
>  	 */
>  	bool force_msr_bitmap_recalc;
> +
> +	/*
> +	 * Reserved bitmask for instruction intercepts that should not be set
> +	 * by L1 if the feature is not advertised to L1 in guest CPUID.
> +	 */
> +	u32 nested_intercept_mask[MAX_INTERCEPT];

I think the naming of this member (and all the helper functions) should
change to make it clear this is a bitmask of ignored intercepts. So
maybe call this 'ignored_intercepts' (nested is implied by the struct)?

Then we can do:

s/set_nested_intercept_mask/set_nested_ignored_intercept/g
s/svm_recalc_nested_intercepts_mask/svm_recalc_nested_ignored_intercepts/g

..and any needed commentary updates.

Otherwise, the code looks good to me.

>  };
> 
>  struct vcpu_sev_es_state {
> @@ -478,6 +484,12 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, u32 bit)
>  	recalc_intercepts(svm);
>  }
> 
> +static inline void set_nested_intercept_mask(struct svm_nested_state *nested, u32 bit)
> +{
> +	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
> +	__set_bit(bit, (unsigned long *)&nested->nested_intercept_mask);
> +}
> +
>  static inline void svm_set_intercept(struct vcpu_svm *svm, int bit)
>  {
>  	struct vmcb *vmcb = svm->vmcb01.ptr;
> @@ -746,6 +758,8 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
>  	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
>  }
> 
> +void svm_recalc_nested_intercepts_mask(struct kvm_vcpu *vcpu);
> +
>  int __init nested_svm_init_msrpm_merge_offsets(void);
> 
>  int enter_svm_guest_mode(struct kvm_vcpu *vcpu,
> --
> 2.52.0.223.gf5cc29aaa4-goog
> 

