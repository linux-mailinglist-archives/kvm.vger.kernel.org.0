Return-Path: <kvm+bounces-45438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97DA5AA9B2E
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 20:04:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 737601A80C07
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC77026F450;
	Mon,  5 May 2025 18:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PvX9/lJE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9405426D4E9
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 18:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746468240; cv=none; b=EFjWcQu2lU0GpTE7OD6JeBRCVyBmeK7kkJaGQ91zbnSAWk8QwozTExipdDUdF3KgmBXA1aWoiOYFekxbxSqFiVnYjboldWJUyFs2Jcz/IVLLgsbV1hJTwqGJROym4GDfFz6FVl9aCoiuw2IGom4U3E3CuR1w6EhOt8zRmcDS/6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746468240; c=relaxed/simple;
	bh=XQ5QQ2gsp33F/Q3s8Zxw7h5dOE4iqeEcSVQ8cTlpjiM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qPStn4oZrNXjdWnYpbhmFtpKGuwk/jPBeOKRafS8IxskYjpZbxt5Az306g8urjwq2YAJqKOgqsFKcta4vtYlmr/NJbA0mjq90L/GXGix3q3TzpA1Q40TAlKhaOpt7D+lDAIsmE84OaiiwpyylWHX00sRDkh6bKpb6+bxwOXP0AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PvX9/lJE; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736b431ee0dso3545027b3a.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 11:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746468238; x=1747073038; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zw9V/AiRZvQIXS4Ub71pY6jY5U175MA0ipiGr8py2to=;
        b=PvX9/lJE06y3IzKV16CAacEH0PEyZqRb/4ok5H1A3iGi+459B9ndiydb3pO/9u9MI6
         VnLspSb2ryUZlRJh3loxCnGRyYHJaKSXF2T6zfB5wL1HJqI4dGeht22AIVGGK0BU9T4k
         PIzl9yeqOlJ/n3Nkd6EUUcWXR3LYdfKLiG6Can6rsTI8HXvaEyC3C0D2b31Lr/s/dT4G
         NFfIIY7nvtIuiFsbBzgx1tmiNpuZwOsStpRT/3enLVRB30vxnRuszbscCkrKDpfo+YJb
         L68dlohXn0WXYx9GYXHn+55VftaebaLivbqkgjYPbbd+GgAP5h2RPf8olVnp+end6GAb
         j/VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746468238; x=1747073038;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zw9V/AiRZvQIXS4Ub71pY6jY5U175MA0ipiGr8py2to=;
        b=DolgxeGHMJ/UyCGLvpZ7ghdPymmo5UcnmzNUXXb3l0+FFimYkuk7bhr/3L8cT+PjOi
         UBxOeRK37+qWYD0mT+At5srIdBiLQ3dxaTlrtbFeL3B/72BYwmfVq//0CLe7JiXZwy70
         UvekHRwgmpj+0W4kn9aQPcEaFhQbL7RS0MlvdGohkjH257RfZE2034omTrtA4vx+M5qM
         rX7Mj1yuJOWp5zVGdhEjlo+mcET1MMo9uofpkmX3CUBP2B12/8BG60AzCYRIzbHmDQdH
         SlshVJXLcE5PqWYG0pMaRIHxDEGMr8TH5nicsGW3kZBPg0MKUnYkiUWkXbp1yg3g86Sn
         Hlfg==
X-Forwarded-Encrypted: i=1; AJvYcCXnkuB5yZ4Hqh9bTWUdBKNuOyJ01Qzm84EGy8THBhCjtfwYV5QDXR5dAErr9Q+TK79aMTg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgUBShQIRXPBzYoYWltsl0eludhL4Th2h0p2b/hXvkFmkoykNR
	/gb4dM8Z+nQbe1AJoHzkp/U2YjGrg8yEjGmoqSEdiYanMeDDCv0EMnFAAIQ237B3x1yrhOyR0zo
	ORg==
X-Google-Smtp-Source: AGHT+IHY62i2z6OoDFL8xYzLCVNQsXoClCRLU+DD54Snmess+AsdkxC/gajrRsOYSjODh9z8VZuKOF/iPO0=
X-Received: from pfmu13.prod.google.com ([2002:aa7:838d:0:b0:736:a320:25bd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:6ca1:b0:736:5753:12f7
 with SMTP id d2e1a72fcca58-740589050bdmr22056587b3a.3.1746468237876; Mon, 05
 May 2025 11:03:57 -0700 (PDT)
Date: Mon, 5 May 2025 11:03:56 -0700
In-Reply-To: <LV3PR12MB9265029582484A4BC7B6FA7B948E2@LV3PR12MB9265.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <f16941c6a33969a373a0a92733631dc578585c93@linux.dev>
 <20250218111306.GFZ7RrQh3RD4JKj1lu@fat_crate.local> <20250429132546.GAaBDTWqOsWX8alox2@fat_crate.local>
 <aBKzPyqNTwogNLln@google.com> <20250501081918.GAaBMuhq6Qaa0C_xk_@fat_crate.local>
 <aBOnzNCngyS_pQIW@google.com> <20250505152533.GHaBjYbcQCKqxh-Hzt@fat_crate.local>
 <LV3PR12MB9265E790428699931E58BE8D948E2@LV3PR12MB9265.namprd12.prod.outlook.com>
 <aBjnjaK0wqnQBz8M@google.com> <LV3PR12MB9265029582484A4BC7B6FA7B948E2@LV3PR12MB9265.namprd12.prod.outlook.com>
Message-ID: <aBj9jKhvqB9ZNoP6@google.com>
Subject: Re: x86/bugs: KVM: Add support for SRSO_MSR_FIX, back for moar
From: Sean Christopherson <seanjc@google.com>
To: David Kaplan <David.Kaplan@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Patrick Bellasi <derkling@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Patrick Bellasi <derkling@matbug.net>, 
	Brendan Jackman <jackmanb@google.com>, Michael Larabel <Michael@michaellarabel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, May 05, 2025, David Kaplan wrote:
> > > Almost.  My thought was that kvm_run could do something like:
> > >
> > > If (!this_cpu_read(bp_spec_reduce_is_set)) {
> > >    wrmsrl to set BP_SEC_REDUCE
> > >    this_cpu_write(bp_spec_reduce_is_set, 1) }
> > >
> > > That ensures the bit is set for your core before VMRUN.  And as noted
> > > below, you can clear the bit when the count drops to 0 but that one is
> > > safe from race conditions.
> >
> > /facepalm
> >
> > I keep inverting the scenario in my head.  I'm so used to KVM needing to ensure it
> > doesn't run with guest state that I keep forgetting that running with
> > BP_SPEC_REDUCE=1 is fine, just a bit slower.
> >
> > With that in mind, the best blend of simplicity and performance is likely to hook
> > svm_prepare_switch_to_guest() and svm_prepare_host_switch().
> > switch_to_guest() is called when KVM is about to do VMRUN, and host_switch() is
> > called when the vCPU is put, i.e. when the task is scheduled out or when KVM_RUN
> > exits to userspace.
> >
> > The existing svm->guest_state_loaded guard avoids toggling the bit when KVM
> > handles a VM-Exit and re-enters the guest.  The kernel may run a non-trivial
> > amount of code with BP_SPEC_REDUCE, e.g. if #NPF triggers swap-in, an IRQ
> > arrives while handling the exit, etc., but that's all fine from a security perspective.
> >
> > IIUC, per Boris[*] an IBPB is needed when toggling BP_SPEC_REDUCE on-
> > demand:
> >
> >  : You want to IBPB before clearing the MSR as otherwise host kernel will be
> >  : running with the mistrained gunk from the guest.
> >
> > [*]
> > https://lore.kernel.org/all/20250217160728.GFZ7NewJHpMaWdiX2M@fat_crate.loc
> > al
> >
> > Assuming that's the case...
> >
> > Compile-tested only.  If this looks/sounds sane, I'll test the mechanics and write a
> > changelog.
> 
> I'm having trouble following the patch...where do you clear the MSR bit?

Gah, the rdmsrl() in svm_prepare_host_switch() should be a wrmsrl().

> I thought a per-cpu "cache" of the MSR bit might be good to avoid having to
> issue slow RDMSRs, if these paths are 'hot'.  I don't know if that's the case
> or not.

Oh, you were only proposing deferring setting BP_SPEC_REDUCE.  I like it.  That
avoids setting BP_SPEC_REDUCE on CPUs that aren't running VMs, e.g. housekeeping
CPUs, and makes it a heck of a lot easier to elide the lock on 1<=>N transitions.

I posted v2 using that approach (when lore catches up):

https://lore.kernel.org/all/20250505180300.973137-1-seanjc@google.com

> Also keep in mind this is a shared (per-core) MSR bit.  You can't just clear
> it when you exit one guest because the sibling thread might be running
> another guest.

Heh, well then never mind.  I'm not touching SMT coordination. 

> >  static void svm_prepare_host_switch(struct kvm_vcpu *vcpu)  {
> > -       to_svm(vcpu)->guest_state_loaded = false;
> > +       struct vcpu_svm *svm = to_svm(vcpu);
> > +
> > +       if (!svm->guest_state_loaded)
> > +               return;
> > +
> > +       if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
> > +               indirect_branch_prediction_barrier();
> > +               rdmsrl(MSR_ZEN4_BP_CFG, kvm_host.zen4_bp_cfg);

As above, this is supposed to be wrmsrl().

> > +       }
> > +       svm->guest_state_loaded = false;
> >  }

