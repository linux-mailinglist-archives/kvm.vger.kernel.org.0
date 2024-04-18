Return-Path: <kvm+bounces-15110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F8A28A9D29
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 16:33:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A7501C2221D
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 14:33:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D897116F845;
	Thu, 18 Apr 2024 14:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BHgossB0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF2D16E884
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 14:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713450650; cv=none; b=tcXfR4hlWgejNxr7w0eMVoRPi0exl5k0BDLXtYW79UxIRh9c8yQyRL6MSDBOjwqwnfIfIMzOuLM02LoI9E1KYf3jrvK8HXSowhawdyf1fyame6FZQMYN0Ls/PcWVfUbyySvwNXgfpTHq5PRu95dIlI3F/w2BGItDI2OILQgAv4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713450650; c=relaxed/simple;
	bh=0jYTSiNDE7rntMLZRaKgllkSrdP5zJHr2wB570HXbWg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NdbeRSui8aDWbxsT/2cwvhme4yjgIxdMRo86nFvfAHlEEjHPPXZB+lr8OpB+TD32eLwoQ/E/7kKDDu3qpJhUpSTC9mAngZFsnZjNC8lZxjLOlluI9KytqHbi+zKhIeuQCbgu3IZJntyyTu0z5Hvf4/8IrNVJF0nubCMgbbbhbBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BHgossB0; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6ed4203cafdso976466b3a.0
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 07:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713450648; x=1714055448; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mIiualmkO79Mu2uuDr7CR5o8frviPRmrtfPEIGsaY7c=;
        b=BHgossB0F0dLhbPcLWdlWYMgInKWcradahpX7fjHN5QDm2ZpN+wEyqDqYzwtwiAri2
         pEqcX9RKyI1i+VSD6sTZJB5cU4U3F77Uw9T6/90bbUYNuyvWEut4+u8cIqgOALnLvF3Y
         RzIa4OnPgBOT/ATB0m0oMOJCtv46ooH4I5lTVjhvl9Knp1Wg/zaxcVAgugKB4KvHboXV
         IZq+wQmUcgq6fM9OTCW2eErmvglTfrXVGSsAvRJ0wUxdtDu+notrx1kao4hDB5oo7qc0
         irAABr6TSPvN5NWtvcjLuxaJxbouIX2Zs9lu3cUW1a9mPhfeSYpvtiMEFECn+QoqRjeb
         ct+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713450648; x=1714055448;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mIiualmkO79Mu2uuDr7CR5o8frviPRmrtfPEIGsaY7c=;
        b=K/KpnqWhBN5NgwZZtZFI8CMrHS7Mh+yEvtVRk2JLdxbo/si266jreaVhiZXYmxql3J
         hqkCnq+XzzFiyhPrbXusWD+Hc/McQQhErWfRPJCxVLkVha0307NHgBl46ilbtOyhp6hX
         u/TnpU43wFV0Bm1yFox56BxqYfS3J94p5nnFJGBHKqyLwCeCZLFWtKJ+fVFoKQDxoK2D
         9K8Td5156LE7UqHT6IzCK+2kFbOA+XzgM422+E+Xqc6x8huzl8N4eZN/W36EDKgxDp8l
         eR229lEHzYlv0ST2uX7QXafmjUoC0JahqAG54y2mfxDmgn4KcOau4OE8C/saLt+awP4v
         KchQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtU72FznyxyCjlHZNRy7wHgH2njSUyCpWQpnLj8ZS3dglrlzL4+FxoklPonCqwNMzQOl+OQPb8mH4wxoisdP+W2/4O
X-Gm-Message-State: AOJu0YwsqxrIjNqRgcuysDpaER6CAVq5QcFQsguv9b1cnxNz3L+Ljo5L
	8q6r1b5zVLM+SxmWAOzBeKU2pBzPMWx9PhBhgFxg9fHU9La+yhq/mtaBjGDfmIbSwJZlZIvvebS
	9Fg==
X-Google-Smtp-Source: AGHT+IELJKuc3Z8vlV67n9/UosCX/fx0o9qJQH3Bsnf0ov4npThO257WDfWaP0+JmAClWPKcDBA+rziXjlI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a02:b0:6ec:f406:ab4b with SMTP id
 p2-20020a056a000a0200b006ecf406ab4bmr237004pfh.4.1713450647938; Thu, 18 Apr
 2024 07:30:47 -0700 (PDT)
Date: Thu, 18 Apr 2024 07:30:46 -0700
In-Reply-To: <5ffd4052-4735-449a-9bee-f42563add778@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZhawUG0BduPVvVhN@google.com> <8afbb648-b105-4e04-bf90-0572f589f58c@intel.com>
 <Zhftbqo-0lW-uGGg@google.com> <6cd2a9ce-f46a-44d0-9f76-8e493b940dc4@intel.com>
 <Zh7KrSwJXu-odQpN@google.com> <900fc6f75b3704780ac16c90ace23b2f465bb689.camel@intel.com>
 <Zh_exbWc90khzmYm@google.com> <2383a1e9-ba2b-470f-8807-5f5f2528c7ad@intel.com>
 <ZiBc13qU6P3OBn7w@google.com> <5ffd4052-4735-449a-9bee-f42563add778@intel.com>
Message-ID: <ZiEulnEr4TiYQxsB@google.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Tina Zhang <tina.zhang@intel.com>, Hang Yuan <hang.yuan@intel.com>, 
	Bo2 Chen <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 18, 2024, Kai Huang wrote:
> On 18/04/2024 11:35 am, Sean Christopherson wrote:
> > Ah, yeah.  Oh, duh.  I think the reason I didn't initially suggest late_hardware_setup()
> > is that I was assuming/hoping TDX setup could be done after kvm_x86_vendor_exit().
> > E.g. in vt_init() or whatever it gets called:
> > 
> > 	r = kvm_x86_vendor_exit(...);
> > 	if (r)
> > 		return r;
> > 
> > 	if (enable_tdx) {
> > 		r = tdx_blah_blah_blah();
> > 		if (r)
> > 			goto vendor_exit;
> > 	}
> 
> 
> I assume the reason you introduced the late_hardware_setup() is purely
> because you want to do:
> 
>   cpu_emergency_register_virt_callback(kvm_x86_ops.emergency_enable);
> 
> after
> 
>   kvm_ops_update()?

No, kvm_ops_update() needs to come before kvm_x86_enable_virtualization(), as the
static_call() to hardware_enable() needs to be patched in.

Oh, and my adjust patch is broken, the code to do the compat checks should NOT
be removed; it could be removed if KVM unconditionally enabled VMX during setup,
but it needs to stay in the !TDX case.

-       for_each_online_cpu(cpu) {
-               smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &r, 1);
-               if (r < 0)
-                       goto out_unwind_ops;
-       }

Which is another reason to defer kvm_x86_enable_virtualization(), though to be
honest not a particularly compelling reason on its own.

> Anyway, we can also do 'enable_tdx' outside of kvm_x86_vendor_init() as
> above, given it cannot be done in hardware_setup() anyway.
> 
> If we do 'enable_tdx' in late_hardware_setup(), we will need a
> kvm_x86_enable_virtualization_nolock(), but that's also not a problem to me.
> 
> So which way do you prefer?
> 
> Btw, with kvm_x86_virtualization_enable(), it seems the compatibility check
> is lost, which I assume is OK?

Heh, and I obviously wasn't reading ahead :-)

> Btw2, currently tdx_enable() requires cpus_read_lock() must be called prior.
> If we do unconditional tdx_cpu_enable() in vt_hardware_enable(), then with
> your proposal IIUC there's no such requirement anymore, because no task will
> be scheduled to the new CPU before it reaches CPUHP_AP_ACTIVE.

Correct.

> But now calling cpus_read_lock()/unlock() around tdx_enable() also acceptable
> to me.

No, that will deadlock as cpuhp_setup_state() does cpus_read_lock().

> > > > +int kvm_enable_virtualization(void)
> > > >    {
> > > > +	int r;
> > > > +
> > > > +	r = cpuhp_setup_state(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
> > > > +			      kvm_online_cpu, kvm_offline_cpu);
> > > > +	if (r)
> > > > +		return r;
> > > > +
> > > > +	register_syscore_ops(&kvm_syscore_ops);
> > > > +
> > > > +	/*
> > > > +	 * Manually undo virtualization enabling if the system is going down.
> > > > +	 * If userspace initiated a forced reboot, e.g. reboot -f, then it's
> > > > +	 * possible for an in-flight module load to enable virtualization
> > > > +	 * after syscore_shutdown() is called, i.e. without kvm_shutdown()
> > > > +	 * being invoked.  Note, this relies on system_state being set _before_
> > > > +	 * kvm_shutdown(), e.g. to ensure either kvm_shutdown() is invoked
> > > > +	 * or this CPU observes the impedning shutdown.  Which is why KVM uses
> > > > +	 * a syscore ops hook instead of registering a dedicated reboot
> > > > +	 * notifier (the latter runs before system_state is updated).
> > > > +	 */
> > > > +	if (system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF ||
> > > > +	    system_state == SYSTEM_RESTART) {
> > > > +		unregister_syscore_ops(&kvm_syscore_ops);
> > > > +		cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
> > > > +		return -EBUSY;
> > > > +	}
> > > > +
> > > 
> > > Aren't we also supposed to do:
> > > 
> > > 	on_each_cpu(__kvm_enable_virtualization, NULL, 1);
> > > 
> > > here?
> > 
> > No, cpuhp_setup_state() invokes the callback, kvm_online_cpu(), on each CPU.
> > I.e. KVM has been doing things the hard way by using cpuhp_setup_state_nocalls().
> > That's part of the complexity I would like to get rid of.
> 
> Ah, right :-)
> 
> Btw, why couldn't we do the 'system_state' check at the very beginning of
> this function?

We could, but we'd still need to check after, and adding a small bit of extra
complexity just to try to catch a very rare situation isn't worth it.

To prevent races, system_state needs to be check after register_syscore_ops(),
because only once kvm_syscore_ops is registered is KVM guaranteed to get notified
of a shutdown.

And because the kvm_syscore_ops hooks disable virtualization, they should be called
after cpuhp_setup_state().  That's not strictly required, as the per-CPU
hardware_enabled flag will prevent true problems if the system enter shutdown
state before KVM reaches cpuhp_setup_state().

Hmm, but the same edge cases exists in the above flow.  If the system enters
shutdown _just_ after register_syscore_ops(), KVM would see that in system_state
and do cpuhp_remove_state(), i.e. invoke kvm_offline_cpu() and thus do a double
disable (which again is benign because of hardware_enabled).

Ah, but registering syscore ops before doing cpuhp_setup_state() has another race,
and one that could be fatal.  If the system does suspend+resume before the cpuhup
hooks are registered, kvm_resume() would enable virtualization.  And then if
cpuhp_setup_state() failed, virtualization would be left enabled.

So cpuhp_setup_state() *must* come before register_syscore_ops(), and
register_syscore_ops() *must* come before the system_state check.

