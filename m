Return-Path: <kvm+bounces-24263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3F53953090
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:44:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 692B2287E86
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 13:44:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ADD219FA9D;
	Thu, 15 Aug 2024 13:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zlWjmqXg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB40F19F49B
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 13:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729452; cv=none; b=iWwkAIRGPy1ZXXf8yVshSSRmeWLc4Ls1PnslSjJ9KJ7vuFTRW+aLpqvgKqAGVczNfWl4KHq3qI0ndKchHGMnNw7shFRhL9keegXNOS+WV41rKGqGKFFBEaml0R+Qes4RT81iyW/FwjTH7XTax+Xwg1/ghwdZCUpKH8H69FzzLCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729452; c=relaxed/simple;
	bh=9AGELrkuV7EZRikIMXBDlNIHEDvCKbJikKbwKsHwsv4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gCA90QQCOqgieWW6qV2sCAtV/HpwLicw4TFWoIN+cGpJzP7rRHU86vkXGFBu0gA0rUCdUhCoLOuAAenDIG+TBqj9QOa+QF/Utm/XBtxFtL48Mxygge07Nahp61qPF8uClRGeRcW/kCX+gb6G0Geaytz/NZUQeVSuOZaAfrmGBbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zlWjmqXg; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-690404fd34eso19338057b3.1
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 06:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723729450; x=1724334250; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XPX484PwSJ0KtNfnOFVCkU6UyyOJERQv814+10anCE0=;
        b=zlWjmqXgu7ZI7yiWh4lZlj/LPHkFQ92UZhA0QLww3rePfrlIcAgHVsXbXq2bz1DYMV
         IM3s/VLLokKueOjzMoAUjuGauO43FPqC57f06Vke122IGQt9cpmDjl23FLiMTMhAu6Yk
         Qwffh0TndhPTKK6GGsmiDLRPAp0Jov9//9fbuw0i+k0LXP7B9w0Aw2JR55yQlvb4qP3e
         6N1zFoYAQo/x9mvaBa8yGliWbUunSNr6TgDMx1oraaQKZhdH0CfMojzdYNttaPRLZJpb
         ZmbxVaImKwptDKID8V7B68Dtia/WhmH7N+QRt5aGWgetyxRLlLRe4jRdiQQ8hWnK9b/g
         prKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723729450; x=1724334250;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XPX484PwSJ0KtNfnOFVCkU6UyyOJERQv814+10anCE0=;
        b=VHmsMZDAdSO92v3FL4ks7JSX2sTia94Xso9/qYJxOj4E/6Kh3x8x6pd1H7HNxxxpZ3
         gBz9mVGQjQDseTwIVpUDXCwnnGLznLtLh7joSiyqxWB3Cwq+UwMGeex6igFYVdFL5nxV
         XkvCf1VFSgOTfvo9/tQbF9B0dd45PQh4bNZkEiZivTV5WEJzBPM2eq/juxAfINHfNr68
         B/H+d8SuSLNDfXet0g/qFhiWcZL8wJ61SsOWHZWWeaUsVK4oZ3Zpi5m/J2Rx+DGluCtH
         gzG0IhRaitL/tib9Ff/Lsm2eQP4KjZ3Ey53AX/2pFFuLzQahphHzBl6N6p2XSIF82X1Y
         tR8g==
X-Forwarded-Encrypted: i=1; AJvYcCWdJpipgKef/wl9ygzF6nyY8VYnqLpg/cld+tHm+BP71ecv7/dK61xQ6iALFaG0IqvpIw1+NU5gAQ0NRgRReL4x4Lab
X-Gm-Message-State: AOJu0Yz3SVXeQ6NEBfg6sXVehZrbRfIJtprcCjCoYW6xP5LmCcTtUgyc
	lqNnaai7sTHEP7d6PpKMYSBUeozsh9TxRfLrHGvQ/bvbyQTX2z24QwmAZ60n1C/leQIW28eZ8qC
	xgA==
X-Google-Smtp-Source: AGHT+IGSgylacpA/2U2pcu8PcEw6cZjfuj/ASwhZ1QB063VQnq4fE/QQFvRwasAXHSOpiMB5bZZ2pZbZXxU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e4c4:0:b0:e03:6556:9fb5 with SMTP id
 3f1490d57ef6-e1155ba2c78mr102561276.11.1723729449919; Thu, 15 Aug 2024
 06:44:09 -0700 (PDT)
Date: Thu, 15 Aug 2024 06:44:08 -0700
In-Reply-To: <87h6bmfbgm.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <b44227c5-5af6-4243-8ed9-2b8cdc0e5325@gmail.com>
 <Zpq2Lqd5nFnA0VO-@google.com> <207a5c75-b6ad-4bfb-b436-07d4a3353003@gmail.com>
 <87a5i05nqj.fsf@redhat.com> <b20eded4-0663-49fb-ba88-5ff002a38a7f@gmail.com>
 <87plqbfq7o.fsf@redhat.com> <ZrzIVnkLqcbUKVDZ@google.com> <87mslff728.fsf@redhat.com>
 <Zr0rEy0bO1ju_f1C@google.com> <87h6bmfbgm.fsf@redhat.com>
Message-ID: <Zr4GKEzp8eQDDH1d@google.com>
Subject: Re: [BUG] =?utf-8?Q?arch=2Fx86=2Fkvm=2Fvmx?= =?utf-8?Q?=2Fvmx=5Fonhyperv=2Eh=3A109=3A36=3A_error=3A_dereference_of_NUL?=
 =?utf-8?B?TCDigJgw4oCZ?=
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Mirsad Todorovac <mtodorovac69@gmail.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 15, 2024, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Wed, Aug 14, 2024, Vitaly Kuznetsov wrote:
> >> Sean Christopherson <seanjc@google.com> writes:
> >> 
> >> > On Wed, Aug 14, 2024, Vitaly Kuznetsov wrote:
> >> >> What I meant is something along these lines (untested):
> >> >> 
> >> >> diff --git a/arch/x86/kvm/vmx/vmx_onhyperv.h b/arch/x86/kvm/vmx/vmx_onhyperv.h
> >> >> index eb48153bfd73..e2d8c67d0cad 100644
> >> >> --- a/arch/x86/kvm/vmx/vmx_onhyperv.h
> >> >> +++ b/arch/x86/kvm/vmx/vmx_onhyperv.h
> >> >> @@ -104,6 +104,14 @@ static inline void evmcs_load(u64 phys_addr)
> >> >>         struct hv_vp_assist_page *vp_ap =
> >> >>                 hv_get_vp_assist_page(smp_processor_id());
> >> >>  
> >> >> +       /*
> >> >> +        * When enabling eVMCS, KVM verifies that every CPU has a valid hv_vp_assist_page()
> >> >> +        * and aborts enabling the feature otherwise. CPU onlining path is also checked in
> >> >> +        * vmx_hardware_enable(). With this, it is impossible to reach here with vp_ap == NULL
> >> >> +        * but compilers may still complain.
> >> >> +        */
> >> >> +       BUG_ON(!vp_ap);
> >> >
> >> > A full BUG_ON() is overkill, and easily avoided.  If we want to add a sanity
> >> > check here and do more than just WARN, then it's easy enough to plumb in @vcpu
> >> > and make this a KVM_BUG_ON() so that the VM dies, i.e. so that KVM doesn't risk
> >> > corrupting the guest somehow.
> >> >
> >> 
> >> I'm still acting under the impression this is an absolutely impossible
> >> situation :-)
> >> 
> >> AFAICS, we only call evmcs_load() from vmcs_load() but this one doesn't
> >> have @vcpu/@kvm either and I wasn't sure it's worth the effort to do the
> >> plumbing (or am I missing an easy way to go back from @vmcs to
> >> @vcpu?). On the other hand, vmcs_load() should not be called that ofter
> >> so if we prefer to have @vcpu there for some other reason -- why not.
> >
> > kvm_get_running_vcpu(), though I honestly purposely didn't suggest it earlier
> > because I am not a fan of using kvm_get_running_vcpu() unless it's absolutely
> > necessary.  But for this situation, I'd be fine with using it.
> 
> Ah, nice, so we don't even need the plumbing then I guess? Compile-tested only:
> 
> diff --git a/arch/x86/kvm/vmx/vmx_onhyperv.h b/arch/x86/kvm/vmx/vmx_onhyperv.h
> index eb48153bfd73..318f5f95f211 100644
> --- a/arch/x86/kvm/vmx/vmx_onhyperv.h
> +++ b/arch/x86/kvm/vmx/vmx_onhyperv.h
> @@ -104,6 +104,19 @@ static inline void evmcs_load(u64 phys_addr)
>         struct hv_vp_assist_page *vp_ap =
>                 hv_get_vp_assist_page(smp_processor_id());
>  
> +       /*
> +        * When enabling eVMCS, KVM verifies that every CPU has a valid hv_vp_assist_page()
> +        * and aborts enabling the feature otherwise. CPU onlining path is also checked in
> +        * vmx_hardware_enable(). With this, it is impossible to reach here with vp_ap == NULL
> +        * but compilers may still complain.
> +        */
> +       if (!vp_ap) {
> +               struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> +
> +               KVM_BUG_ON(1, vcpu->kvm);
> +               return;

Eh, I would just do:

	if (KVM_BUG_ON(!vp_ap, kvm_get_running_vcpu()->kvm))
		return

> +       }
> +
>         if (current_evmcs->hv_enlightenments_control.nested_flush_hypercall)
>                 vp_ap->nested_control.features.directhypercall = 1;
>         vp_ap->current_nested_vmcs = phys_addr;
> 
> (I hope we can't reach here with kvm_running_vcpu unset, can we?)

Yes?  kvm_running_vcpu is set before kvm_arch_vcpu_load() and cleared after
kvm_arch_vcpu_put(), and I can't think of a scenario where it would be legal/sane
to invoke vmcs_load() without a running/loaded vCPU.  VMX needs the current VMCS
to be loaded to ensure guest state can be accessed, so any ioctl() that can touch
guest state needs to do vcpu_load().

x86's kvm_arch_vcpu_ioctl() unconditionally does vcpu_load(), and the only ioctls
I see in kvm_vcpu_ioctl() that _don't_ do vcpu_load() are KVM_SET_SIGNAL_MASK and
KVM_GET_STATS_FD, so I think we're good.

And if I'm wrong and the impossible happens twice, so be it, we die on #GP :-)

