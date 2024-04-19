Return-Path: <kvm+bounces-15289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE13B8AAFC0
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:52:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6BA0D1F2231C
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE5E212C53D;
	Fri, 19 Apr 2024 13:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JqhLbwga"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A147E12BEBB
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 13:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713534766; cv=none; b=d20DuZEvtiyi7UygGaXnYXMhQ2FaJUhYF5QK7vqOJjLX6p0zK2p45Ztozn+Q96OlYyiDOoAz6EVlVEo6PvIEP2jhKMndD1+V811+4Joc+cvVNMGAE/oSZuSTkkB4uN0EPu2u65uc3naqNb1GWJ/pXcjkm9Jt2XLYi5xCHqO9oXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713534766; c=relaxed/simple;
	bh=0bMqhizXXBRsHgH7B8q96FVF9b/L6f85+o0VoS7OMWs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UtXfjpTgYf+ewmx6sLQ3+5lDjBm/W2BDsPoCSFgSUZTGcVQ/AeGSiaZJyxa+01/VbUu6Hvzf80lRPCQ2ts6ZdxO3yuR+zHx2VYLs4JS903Spb4sh9L/Dab1SaJ2SyvBtJYbl69mqpl0PTX4VKyI3+XW+csfz3iSdNsQhNx2Nzj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JqhLbwga; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5e5022b34faso3039445a12.0
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 06:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713534764; x=1714139564; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gHnn4b/aF0vLLT3VFQPmMbPoN7WtL6sG78+6CFhfUU0=;
        b=JqhLbwgaCHJykhghjgEVhqE7Xtvo9O50qeZTNWc77MBxI/BxRpo66JP3OY4k41Q+OW
         rIQ+pbtm+5Gd/QgKha17SFH+4QaGeAEXSnNzeo5gLwYKa3YQWozzBgtJYrzZPNzgvSln
         VI4LID5//WzaeEwSaKHdz0fIODL1boGHITbkFwSkw2mchhOw09KDo5/nMx0IBbj3WXEY
         aWHXK8XB+oxfNCiNkGUyqXyNR+oomrIQB6i4A4vvkzgg00cgIEDqPQbufF8sGqEURlBA
         8tEBuS/vs99SJBGrIn+u7bfmQFjKcrbSoZS3yW0/1YtzsGLYYtvbsmcuwoI4WXIcFyCX
         DF2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713534764; x=1714139564;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gHnn4b/aF0vLLT3VFQPmMbPoN7WtL6sG78+6CFhfUU0=;
        b=OKI9HKGmx78w3ROTUIHvqXNztHe2IGPom1yVEV20bsJDUaH8rzJgh7+pK2u1wXXs9k
         MTcTlkXk4LKPoSHnrAH8bH1r34kp5S/Vaoabt8Lo8FMQOyiOUW33ogWFOGHOHvvp6cwt
         MA3kw3AvBgYsgDXfwHxE54ISa4qQgZxj+wFqdIBw6RTiqgzfYcB8gpWRxN6wcfHt2DSs
         Q89Z4yrlgpGnxn+NcKcfI5eTC5mr/qO5aqk92kG7Ghj1g2RN+dLidhucEyqcmTFQDS/V
         BVtq7SXnAJvljJ92/ocqfhMRn0FFZWOlD5hW8qQoHVP/tw0wroMizlS6wFtlsBiUD82a
         s1WQ==
X-Gm-Message-State: AOJu0YxwkG/2hE5dwLdD/7/7rTNsHq2mnNJrTPwtl7BN8KjGYICRbfp3
	qd8Szy/AiBVNSBV0jQ+MdPX/9n6ijcBZY6lKY9sz6ZZsjpQe0euwu8akI4Kk3zbDwyh2iAcgNZu
	iWQ==
X-Google-Smtp-Source: AGHT+IHMaFLJaIHnJp+yayT00gxYtI6WKpnrTGbbpd/oLNHLKcimeJFzp727fGJB27ck/U1xPqmyiYTVDMc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:fca:b0:5dc:af76:660 with SMTP id
 dr10-20020a056a020fca00b005dcaf760660mr75766pgb.10.1713534763747; Fri, 19 Apr
 2024 06:52:43 -0700 (PDT)
Date: Fri, 19 Apr 2024 06:52:42 -0700
In-Reply-To: <9c4547ea234a2ba09ebe05219f180f08ac6fc2e3.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com> <9c4547ea234a2ba09ebe05219f180f08ac6fc2e3.1708933498.git.isaku.yamahata@intel.com>
Message-ID: <ZiJ3Krs_HoqdfyWN@google.com>
Subject: Re: [PATCH v19 116/130] KVM: TDX: Silently discard SMI request
From: Sean Christopherson <seanjc@google.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, 
	hang.yuan@intel.com, tina.zhang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 26, 2024, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX doesn't support system-management mode (SMM) and system-management
> interrupt (SMI) in guest TDs.  Because guest state (vcpu state, memory
> state) is protected, it must go through the TDX module APIs to change guest
> state, injecting SMI and changing vcpu mode into SMM.  The TDX module
> doesn't provide a way for VMM to inject SMI into guest TD and a way for VMM
> to switch guest vcpu mode into SMM.
> 
> We have two options in KVM when handling SMM or SMI in the guest TD or the
> device model (e.g. QEMU): 1) silently ignore the request or 2) return a
> meaningful error.
> 
> For simplicity, we implemented the option 1).
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/smm.h         |  7 +++++-
>  arch/x86/kvm/vmx/main.c    | 45 ++++++++++++++++++++++++++++++++++----
>  arch/x86/kvm/vmx/tdx.c     | 29 ++++++++++++++++++++++++
>  arch/x86/kvm/vmx/x86_ops.h | 12 ++++++++++
>  4 files changed, 88 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
> index a1cf2ac5bd78..bc77902f5c18 100644
> --- a/arch/x86/kvm/smm.h
> +++ b/arch/x86/kvm/smm.h
> @@ -142,7 +142,12 @@ union kvm_smram {
>  
>  static inline int kvm_inject_smi(struct kvm_vcpu *vcpu)
>  {
> -	kvm_make_request(KVM_REQ_SMI, vcpu);
> +	/*
> +	 * If SMM isn't supported (e.g. TDX), silently discard SMI request.
> +	 * Assume that SMM supported = MSR_IA32_SMBASE supported.
> +	 */
> +	if (static_call(kvm_x86_has_emulated_msr)(vcpu->kvm, MSR_IA32_SMBASE))
> +		kvm_make_request(KVM_REQ_SMI, vcpu);
>  	return 0;

No, just do what KVM already does for CONFIG_KVM_SMM=n, and return -ENOTTY.  The
*entire* point of have a return code is to handle setups that don't support SMM.

	if (!static_call(kvm_x86_has_emulated_msr)(vcpu->kvm, MSR_IA32_SMBASE)))
		return -ENOTTY;

And with that, I would drop the comment, it's pretty darn clear what "assumption"
is being made.  In quotes because it's not an assumption, it's literally KVM's
implementation.

And then the changelog can say "do what KVM does for CONFIG_KVM_SMM=n" without
having to explain why we decided to do something completely arbitrary for TDX.

>  }
>  
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index ed46e7e57c18..4f3b872cd401 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -283,6 +283,43 @@ static void vt_msr_filter_changed(struct kvm_vcpu *vcpu)
>  	vmx_msr_filter_changed(vcpu);
>  }
>  
> +#ifdef CONFIG_KVM_SMM
> +static int vt_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_smi_allowed(vcpu, for_injection);

Adding stubs for something that TDX will never support is silly.  Bug the VM and
return an error.

	if (KVM_BUG_ON(is_td_vcpu(vcpu)))
		return -EIO;

And I wouldn't even bother with vt_* wrappers, just put that right in vmx_*().
Same thing for everything below.

