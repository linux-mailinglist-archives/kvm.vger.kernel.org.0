Return-Path: <kvm+bounces-35872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F2B3A158C2
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 21:59:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C040A168E7B
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 20:59:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 819F71AA792;
	Fri, 17 Jan 2025 20:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j572DQgE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BA21A9B5A
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 20:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737147580; cv=none; b=a0Lac9ZvPAC7KBWlDa2PmHAeBAJCGmUefnWzuvnxS783NG39QO8HRKVQgHBYzfp2QkbQq9lPtM2Gbs4ff5KUgCfME1Oqt7S2qt7BGudKf+vOtgKQZobpOUsndJr9sHYS7RHIl2VAg4inqNaamn40HTC3w0bQbBi0QrRqV1TiD8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737147580; c=relaxed/simple;
	bh=LjyodIw75JAK2JBpoeQznteJOteiW6JjjDQgd03B8p4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NQTZkhDV11ImNQFYRu+NmODvuY+SO9r0jHwVAxyH2eoJNQwDFo7LL8UdBHlcjjUj5s2dj6vph1HqQxhSjh9UybGUQgCPxS9XUV5M7KKJBWXKcVH/KQ5SS6c+rWQReN7JWB5N77Y2qtcOwIataOJxG+ukya7AzH1GWqY7yDZu7U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j572DQgE; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef79403c5eso7024271a91.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 12:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737147578; x=1737752378; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=m55WVL2tiyVlPfiBYrotwMw+LuFS5qgq+xG3s32wtFg=;
        b=j572DQgE6teJzLcXZko+pubXFaA0aa+ttmWKahJSaJ0+5au4+9xwKj2nEGLPDLdr/1
         RuZ4+tobJdz7c3bz75KUfYWwUudrFhedwX+9bftmGc7EVwIL7bVVB2hlK+KvlDht01wa
         bYQIBNoH7KZPYNoIgvrZVq9HYAFTwnPl2vB85m4jcH8OY9RWbrACKrolhLn0kfA+vPD0
         fwdTVL9J2yv6yaQEHuiBzD4nHlBjRd/QjFeFG1gGmUxgdQEsVt15pTq8G9aD69c0IAPT
         ci8UUsiPUQye7AAA71Z0G9LAeqB8ZyYjy09zI2NPNvmrY+v3wHx47aF1CsWTdv//N2I2
         aoEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737147578; x=1737752378;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m55WVL2tiyVlPfiBYrotwMw+LuFS5qgq+xG3s32wtFg=;
        b=Y4p+N6wuATeGQMh7GYWLdklj48Id1y6/4kwduo2tl+OQ5A8UnGAJgRR3aCPbAZ4uIQ
         fyfcpYCkNbDKpqokNA4XwtOjcqDTH9c4AdUjCPaEB6d6tmiA3BcWC6/zbZ/Ip8skXwvQ
         /zOnaqoDypfvifWmYi/x/2ec3HyhQOoP/g9pr182a/L/keidNlneWxlFbICn6I+hqXLO
         uDuWwvYA3nMMzA8ExABY4vRBLaWbBnOPU9V4loCSqTlOm0CMMW4vQHJyKb8yJgZCCChL
         O9AodwtBbUUgyb/TwUh70zfrv0gS9GKFeSuDX05l9FOt/4/aP1C2wek0s+QA9U2rb8EA
         7dlQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJFFy5J+uvKYaPVj/B5mJot0NBfbupPn6bdFfiYZmSnfeb4nxgWmjToEBb6uQtWscAO5I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzrm7r87zYkf9/B9WNUgLJ9kz3maZ99I2AaedwYEQb3AWFEvrlb
	BukaULRt0v+4rTggEsl0BZMHzPHkrFvA2U8LwOpyka4J/pSdOLFUldPEvbjA2kFFl9vQQqBTApb
	prw==
X-Google-Smtp-Source: AGHT+IFn6nYqWbXoAEVF+j7d6mZ5Xr32YJpFkRRa96zlpYnwOdQDnr6kr6etqstec0O+JSrjQddMOTJX2Po=
X-Received: from pjbnw13.prod.google.com ([2002:a17:90b:254d:b0:2ef:a732:f48d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:258c:b0:2ee:c9b6:c266
 with SMTP id 98e67ed59e1d1-2f782c71d97mr5825944a91.13.1737147578588; Fri, 17
 Jan 2025 12:59:38 -0800 (PST)
Date: Fri, 17 Jan 2025 12:59:37 -0800
In-Reply-To: <20250117202848.GAZ4q9gMHorhVMfvM0@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <4b68ee6e-a6b2-4d41-b58f-edcceae3c689@amd.com> <cd6c18f3-538a-494e-9e60-2caedb1f53c2@amd.com>
 <Z36FG1nfiT5kKsBr@google.com> <20250108153420.GEZ36a_IqnzlHpmh6K@fat_crate.local>
 <Z36vqqTgrZp5Y3ab@google.com> <4ab9dc76-4556-4a96-be0d-2c8ee942b113@amd.com>
 <Z4gqlbumOFPF_rxd@google.com> <20250116162525.GFZ4ky9TdSn7jltgw7@fat_crate.local>
 <Z4k6OcbLqMxvvmb-@google.com> <20250117202848.GAZ4q9gMHorhVMfvM0@fat_crate.local>
Message-ID: <Z4rEuTonLal7Li1O@google.com>
Subject: Re: [PATCH v16 12/13] x86/tsc: Switch to native sched clock
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, 
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, pgonda@google.com, pbonzini@redhat.com, 
	francescolavra.fl@gmail.com, Alexey Makhalov <alexey.makhalov@broadcom.com>, 
	Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 17, 2025, Borislav Petkov wrote:
> On Thu, Jan 16, 2025 at 08:56:25AM -0800, Sean Christopherson wrote:
> > It's only with SNP and TDX that the clocksource becomes at all interesting.
> 
> So basically you're saying, let's just go ahead and trust the TSC when the HV
> sets a bunch of CPUID bits.

Sort of.  It's not a trust thing though.  The Xen, KVM, and VMware PV clocks are
all based on TSC, i.e. we already "trust" the hypervisor to not muck with TSC.

The purpose of such PV clocks is to account for things in software, that aren't
handled in hardware.  E.g. to provide a constant counter on hardware without a
constant TSC.

The proposal here, and what kvmclock already does for clocksource, is to use the
raw TSC when the hypervisor sets bits that effectively say that the massaging of
TSC done by the PV clock isn't needed.

> But we really really trust it when the guest type is SNP+STSC or TDX since
> there the HV is out of the picture and the only one who can flub it there is
> the OEM.

Yep.  This one _is_ about trust.  Specifically, we trust the raw TSC more than
any clock that is provided by the HV.

> > CPUID 0x15 (and 0x16?) is guaranteed to be available under TDX, and Secure TSC
> > would ideally assert that the kernel doesn't switch to some other calibration
> > method too.  Not sure where to hook into that though, without bleeding TDX and
> > SNP details everywhere.
> 
> We could use the platform calibrate* function pointers and assign TDX- or
> SNP-specific ones and perhaps even define new such function ptrs. That's what
> the platform stuff is for... needs staring, ofc.
> 
> > I agree the naming is weird, but outside of the vendor checks, the VM code is
> > identical to the "native" code, so I don't know that it's worth splitting into
> > multiple functions.
> > 
> > What if we simply rename it to calibrate_tsc_from_cpuid()?
> 
> This is all wrong layering with all those different guest types having their
> own ->calibrate_tsc:
> 
> arch/x86/kernel/cpu/acrn.c:32:  x86_platform.calibrate_tsc = acrn_get_tsc_khz;
> arch/x86/kernel/cpu/mshyperv.c:424:             x86_platform.calibrate_tsc = hv_get_tsc_khz;
> arch/x86/kernel/cpu/vmware.c:419:               x86_platform.calibrate_tsc = vmware_get_tsc_khz;
> arch/x86/kernel/jailhouse.c:213:        x86_platform.calibrate_tsc              = jailhouse_get_tsc;
> arch/x86/kernel/kvmclock.c:323: x86_platform.calibrate_tsc = kvm_get_tsc_khz;
> arch/x86/kernel/tsc.c:944:      tsc_khz = x86_platform.calibrate_tsc();
> arch/x86/kernel/tsc.c:1458:                     tsc_khz = x86_platform.calibrate_tsc();
> arch/x86/kernel/x86_init.c:148: .calibrate_tsc                  = native_calibrate_tsc,
> arch/x86/xen/time.c:569:        x86_platform.calibrate_tsc = xen_tsc_khz;
> 
> What you want sounds like a redesign to me considering how you want to keep
> the KVM guest code and baremetal pretty close... Hmmm, needs staring...

It's not KVM guest code though.  The CPUID stuff is Intel's architecturally
defined behavior.  There are oodles and oodles of features that are transparently
emulated by the hypervisor according to hardware specifications.  Generally
speaking, the kernel treats those as "native", e.g. native_wrmsrl(), native_cpuid(),
etc.

What I am proposing is that, for TDX especially, instead of relying on the hypervisor
to use a paravirtual channel for communicating the TSC frequency, we rely on the
hardware-defined way of getting the frequency, because CPUID is emulated by the
trusted entity, i.e. the OEM.

Hmm, though I suppose I'm arguing against myself in that case.  If the hypervisor
provides the frequency and there are no trust issues, why would we care if the
kernel gets the frequency via CPUID or the PV channel.  It's really only TDX that
matters.  And we could handle TDX by overriding .calibrate_tsc() in tsc_init(),
same as Secure TSC.

That said, I do think it makes sense to either override the vendor and F/M/S
checks native_calibrate_tsc().  Or even better drop the initial vendor check
entirely, because both Intel and AMD have a rich history of implementing each
other's CPUID leaves.  I.e. I see no reason to ignore CPUID 0x15 just because
the CPU isn't Intel.

As for the Goldmost F/M/S check, that one is a virtualization specific thing.
The argument is that when running as a guest, any non-TSC clocksource is going
to be emulated by the hypervisor, and therefore is going to be less reliable than
TSC.  I.e. putting a watchdog on TSC does more harm than good, because what ends
up happening is the TSC gets marked unreliable because the *watchdog* is unreliable.

