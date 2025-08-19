Return-Path: <kvm+bounces-55009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8195AB2C937
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 18:13:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B20D5C0BDC
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 16:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06E952C11DB;
	Tue, 19 Aug 2025 16:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vpu2VOfu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60BC2BE7BB
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755619898; cv=none; b=cYgJ6jNVLQdHaNaksl60T4tMXuW3Ai/5KjFwLqbQJVTexFCICxn5gKcR3noeONs9x5TKE//8cm98NZNLiEDYXwrmC/n2K6yXjQ1vILNZN1Yww660Lm1zm9MdBvkhd1pMJav2vqDRKZWlLFU/5IzLvTTX/RuvaCNaIbcj2UkEPKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755619898; c=relaxed/simple;
	bh=K00k9jP1rmkhFnerXyuXTP85GYilasWn6Y+lLUScbk4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tu2Ci90yKnIywpFuAxJoEYnUZTOztkKUCq4rTlATmzggGue08PXI02UJwKtJbHxinwvHKnsY3kLyXPsE2gLoJx4Ui5jIBhNwo0LJG9Gyeh9xNnBguDLgMERLLyafy2fz7sxZaDAXj1xu1AM0coh+bQGwPYkl83dU+Gl+/s6t+iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vpu2VOfu; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3232677ad11so5145589a91.1
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 09:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755619896; x=1756224696; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yoRaD8Gomv9clJ6mv1ZK4ODoSCNwAZH3p37Fh5RxQUI=;
        b=vpu2VOfuRvl/1xJd+L4ITn4yKqX1Ob5BMfRh17H9tjlnoDT6NlR26ejQ48p1HE8Ne7
         Szhk0+8xdGsJ5eKHOYais/O8ASPC2+YyhASwRc31MWXKVRswABQCtGCx9QYxpajCchcr
         gMqoTaN4ko4KhiWtnQiHYkZcGoRSqd+ZuNFv5VPcEjgLT3ELaP69rMMcsAltQjTDusLR
         bvTySR+i/dUHDeJFXnXUv9T1aB+Kb7IZAdN7UZOxyBAcekaCgLy4LljMm7BeEeTXcRep
         NSsiid1crvZjMwD8N8SRyOZSKUWpcJrRL/Uv/czIHi/2X+9iTOkLde6dWexNLc0hszAB
         3xXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755619896; x=1756224696;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yoRaD8Gomv9clJ6mv1ZK4ODoSCNwAZH3p37Fh5RxQUI=;
        b=BnHH3yRjpQHucV7gRt4d9QjEwU+EhrqByVPY6HnSOR1iuC3U/EPSHwWtJ/Tw/Xq2OD
         cr09ebX3Cc8d4ryK/wXx2tlNnt4NwA8PFOZxI8X8fbCCnpwu49qkbYNi7eSC0wdnSjmc
         vGpP26QbBD8+lckbQPLshB6icepy2VHiC/vH6tDgSq7o0UcokgQeNkuCvCtTLdbPzJ/u
         063HOFvPmUxP9KnfZWBcpDiBOWDQK8zdR5H38ld8HqvPo86FTWDKJxGJKYZEyaxhr1Qc
         8mlE5kpqKdRV6HgePAKORXoaFyTZyUmNjLNGU0MFyMTEdYHITJ0fvLiVLN0zCfSDCjCa
         33Uw==
X-Gm-Message-State: AOJu0Yw2wQygad5o6+5ldEtkPAjlLyPUH0j9KQWAQL6Bzrl20Cd/5gCu
	BFSATWIGy5tXSs1CZAHE6/b/9HMWj8qUPt3aoBJYlEekjww4UzLJ/ZrTPUugO4SWZtUjXvO/iVv
	ysolDaw==
X-Google-Smtp-Source: AGHT+IGRQCHPlseQFQy2RQEQqc/RDi+2d8w5n9q/GaOtDKBfpp3/RQxvTpdDXLYJw8zgg4ryEqD6oKRdH+c=
X-Received: from pjwx11.prod.google.com ([2002:a17:90a:c2cb:b0:31e:998f:7b79])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5346:b0:321:8a3b:93c
 with SMTP id 98e67ed59e1d1-3249711e758mr4315963a91.33.1755619895992; Tue, 19
 Aug 2025 09:11:35 -0700 (PDT)
Date: Tue, 19 Aug 2025 09:11:34 -0700
In-Reply-To: <20250812025606.74625-18-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250812025606.74625-1-chao.gao@intel.com> <20250812025606.74625-18-chao.gao@intel.com>
Message-ID: <aKSiNh43UCosGIVh@google.com>
Subject: Re: [PATCH v12 17/24] KVM: VMX: Set up interception for CET MSRs
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mlevitsk@redhat.com, 
	rick.p.edgecombe@intel.com, weijiang.yang@intel.com, xin@zytor.com, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 11, 2025, Chao Gao wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Enable/disable CET MSRs interception per associated feature configuration.
> 
> Shadow Stack feature requires all CET MSRs passed through to guest to make
> it supported in user and supervisor mode 

I doubt that SS _requires_ CET MSRs to be passed through.  IIRC, the actual
reason for passing through most of the MSRs is that they are managed via XSAVE,
i.e. _can't_ be intercepted without also intercepting XRSTOR.

> while IBT feature only depends on
> MSR_IA32_{U,S}_CETS_CET to enable user and supervisor IBT.
> 
> Note, this MSR design introduced an architectural limitation of SHSTK and
> IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
> to guest from architectural perspective since IBT relies on subset of SHSTK
> relevant MSRs.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bd572c8c7bc3..130ffbe7dc1a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4088,6 +4088,8 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
>  
>  void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>  {
> +	bool set;

s/set/intercept

> +
>  	if (!cpu_has_vmx_msr_bitmap())
>  		return;
>  
> @@ -4133,6 +4135,24 @@ void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>  		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
>  					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
>  
> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
> +		set = !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
> +
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, set);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP, MSR_TYPE_RW, set);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP, MSR_TYPE_RW, set);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, set);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW, set);

MSR_IA32_INT_SSP_TAB isn't managed via XSAVE, so why is it being passed through?

> +	}
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) || kvm_cpu_cap_has(X86_FEATURE_IBT)) {
> +		set = !guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) &&
> +		      !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
> +
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET, MSR_TYPE_RW, set);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, set);
> +	}
> +
>  	/*
>  	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
>  	 * filtered by userspace.
> -- 
> 2.47.1
> 

