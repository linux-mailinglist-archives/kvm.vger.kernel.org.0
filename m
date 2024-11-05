Return-Path: <kvm+bounces-30734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D3909BCCD7
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 13:34:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A90DCB218B9
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 12:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C51B71D5AB2;
	Tue,  5 Nov 2024 12:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ergJIKcb"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AECF1E485;
	Tue,  5 Nov 2024 12:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730810085; cv=none; b=L5aI8cs4SMqPJmSnzW5Iwi96kpWecqQ+oBfrVTUQJEW+oBwVC8aHuCDAo/53HLqzKJJ0ikI65++SaIQXYVccgkiAig1HFZNPRikCtJQY1SOjw38/O1HNVhIo47pqIaPUyyPZws483YQvBUcbd9wnek6jzVCYbnCMesmRN6J5mCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730810085; c=relaxed/simple;
	bh=6ab9A01Fg8dPT+qGLjlSuPeA/zf+1hft8BB4Pq9R68Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qd5APPkjQdNvEgCtG0VehUJ5eXqln8eJB5pPKMzE0Om6yZP+Os0z0KdUOeP4kJdAca/u9A8MQBav8OA00lPNKBDYHLECykMpHUo7fkn2DOMtwuFk6SyiiKEIqwFp4v+rL3m9IupRQZy7gJ+UT/sskN2ps2Wa8bfSVmWFmnLAp3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ergJIKcb; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6F70840E0028;
	Tue,  5 Nov 2024 12:34:33 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id EsCHnnPfGnqn; Tue,  5 Nov 2024 12:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730810069; bh=JXfaLIhH5QD5lDtFbiYdHHjo04xpl0JyGhMdeRWp1+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ergJIKcbw8gGoxtFQNfmfd2FWAeWIElCWPi3a3UwjzPgaMLGQoiOxMN/Qfd0MN6MN
	 mpRXkHUsLnSa55XLs4Ont4IOcC3X2M/0fyX3sWbZYh+uNEgVz04XLUVOkmMpPpSp37
	 j8+BjSusrm3fm+tpaAD5fy+wkmi2SX0OFYEc9olCh1gU69J3ip13/TeGtdnXPQjBIC
	 I7eZ7lZdgjuw1FTWRbVZWnN6ZSa6PAZbPVhBXleYZKcIGU+fFGzkHm7aiehfNiW0Y+
	 l+MR6YFiWnWQSttE1bVMMdFG6iVhOWJXnXDHtaIMQiFTVN95eVVe0UCouAGvVAGrNi
	 jXFysfYSclJbLEVOyFHfgk2FpH++tX85PqIW7ccMpd32K9xUrFnohcI3evH2Ar8ygc
	 0Ssy1E0Hyl4VpivB8qkAAIxLERFHHfxaxp5MbH5XhTXIbVBMhPASBXGSWFu0/9BPC1
	 BqTzhrdwSyQhmwEOzkPScwtBhQHGTSdWV69PZt4Kzd+VIASmMeU/tXFvu5YI8IB9CE
	 JR8eUqP4w++VThA6k3iaIkbDWvuQi1kbw9qyDgrhCTC8eGPCWX5S5bwjr5hgGsRobx
	 Y040wIRQPiErF6mBInwai6dvoSBCF/YFwim6WwP8g8xSk6jBFEEyfnXMLPfQ4mpUyk
	 tQzee+vyiAp04bFMyzCy7roQ=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E69B140E0191;
	Tue,  5 Nov 2024 12:34:21 +0000 (UTC)
Date: Tue, 5 Nov 2024 13:34:16 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/bugs: Adjust SRSO mitigation to new features
Message-ID: <20241105123416.GBZyoQyAoUmZi9eMkk@fat_crate.local>
References: <20241104101543.31885-1-bp@kernel.org>
 <ZyltcHfyCiIXTsHu@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZyltcHfyCiIXTsHu@google.com>

On Mon, Nov 04, 2024 at 04:57:20PM -0800, Sean Christopherson wrote:
> scripts/get_maintainer.pl :-)

That's what I used but I pruned the list.

Why, did I miss anyone?
 
> It's not strictly KVM module load, it's when KVM enables virtualization.

Yeah, the KVM CPU hotplug callback.

> E.g. if userspace clears enable_virt_at_load,

/me reads the documentation on that...

Intersting :-)

Put all the work possible in the module load so that VM startup is minimal.

> the MSR will be toggled every time the number of VMs goes from 0=>1 and
> 1=>0.

I guess that's fine. 

> But why do this in KVM?  E.g. why not set-and-forget in init_amd_zen4()?

Because there's no need to impose an unnecessary - albeit small - perf impact
on users who don't do virt.

I'm currently gravitating towards the MSR toggling thing, i.e., only when the
VMs number goes 0=>1 but I'm not sure. If udev rules *always* load kvm.ko then
yes, the toggling thing sounds better. I.e., set it only when really needed.

> Shouldn't these be two separate patches?  AFAICT, while the two are related,
> there are no strict dependencies between SRSO_USER_KERNEL_NO and
> SRSO_MSR_FIX.

Meh, I can split them if you really want me to.

> If the expectation is that X86_FEATURE_SRSO_USER_KERNEL_NO will only ever come
> from hardware, i.e. won't be force-set by the kernel, then I would prefer to set
> the bit in the "standard" way
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 41786b834b16..eb65336c2168 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -794,7 +794,7 @@ void kvm_set_cpu_caps(void)
>         kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
>                 F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
>                 F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */ |
> -               F(WRMSR_XX_BASE_NS)
> +               F(WRMSR_XX_BASE_NS) | F(SRSO_USER_KERNEL_NO)

Ok, sure, ofc.

>         );
>  
>         kvm_cpu_cap_check_and_set(X86_FEATURE_SBPB);
> 
> The kvm_cpu_cap_check_and_set() trickery is necessary only for features that are
> force-set by the kernel, in order to avoid kvm_cpu_cap_mask()'s masking of the
> features by actual CPUID.  I'm trying to clean things up to make that more obvious;
> hopefully that'll land in 6.14[*].

Oh please. It took me a while to figure out what each *cap* function is for so
yeah, cleanup would be nice theere.

> And advertising X86_FEATURE_SRSO_USER_KERNEL_NO should also be a separate patch,
> no?  I.e. 
> 
>  1. Use SRSO_USER_KERNEL_NO in the host
>  2. Update KVM to advertise SRSO_USER_KERNEL_NO to userspace, i.e. let userspace
>     know that it can be enumerate to the guest.
>  3. Add support for SRSO_MSR_FIX.

Sure, I can split. I'm lazy and all but ok... :-P

> [*] https://lore.kernel.org/all/20240517173926.965351-49-seanjc@google.com

Cool.

> 
> >  	kvm_cpu_cap_check_and_set(X86_FEATURE_SRSO_NO);
> >  
> >  	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0022_EAX,
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 9df3e1e5ae81..03f29912a638 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -608,6 +608,9 @@ static void svm_disable_virtualization_cpu(void)
> >  	kvm_cpu_svm_disable();
> >  
> >  	amd_pmu_disable_virt();
> > +
> > +	if (cpu_feature_enabled(X86_FEATURE_SRSO_MSR_FIX))
> > +		msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
> 
> I don't like assuming the state of hardware.  E.g. if MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT
> was already set, then KVM shouldn't clear it.

Right, I don't see that happening tho. If we have to sync the toggling of this
bit between different places, we'll have to do some dance but so far its only
user is KVM.

> KVM's usual method of restoring host MSRs is to snapshot the MSR into
> "struct kvm_host_values" on module load, and then restore from there as
> needed.  But that assumes all CPUs have the same value, which might not be
> the case here?

Yes, the default value is 0 out of reset and it should be set on each logical
CPU whenever we run VMs on it. I'd love to make it part of the VMRUN microcode
but... :-)

> All that said, I'd still prefer that MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT is set
> during boot, unless there's a good reason not to do so.

Yeah, unnecessary penalty on machines not running virt.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

