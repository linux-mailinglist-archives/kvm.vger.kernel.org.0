Return-Path: <kvm+bounces-35679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A0995A1400A
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 17:59:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 176973A1E58
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 16:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51D6C23243D;
	Thu, 16 Jan 2025 16:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yCZiWQ/P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D183622D4E0
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 16:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737046589; cv=none; b=EPkWx4goDgPagGcnPtiQkdqn2f2PqCRtkmm/sw9p7v95vvbZ61tW7V1UGZo0JYi34IbG8fHuciSDoeImXrAsR/XN7vzepZmvCVHMWyJVDQLbF92/CTB9NjZE7FRbSiPaIz+jF407jqzM3Pq0dr3o1XnUjERvfNO/IIGcf9E+uiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737046589; c=relaxed/simple;
	bh=X/OOqmQvnqEja0m1VWly6lfnUqGtptI/v2n0gLba+gE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bsORgmwTyKZLeTyPYlzkCHZYgGDNgrcVEVPhLMz3rFuu4zYiv/HtZdrSDYH/42swwSrPdiZzYQRhAXvGX7M96WrLZAc7S+SvWK7SxGOF0xUx5jEtPkJZ7j/QOlyGueXHrk6o1i/guoSa6iuhJpB2qGaUyPxjNOxyYAijA4zTxQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yCZiWQ/P; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f2a9743093so2338275a91.3
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 08:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737046587; x=1737651387; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H58Ez4Z8nz/I0BfpOMpCpBNBR2Nn1ADeoJi+O2wMRGI=;
        b=yCZiWQ/PsQG8sedAMCx/mToNtd0xYIyc+ZseLjKrnCTq9HrXK7FSBKt37vKvfiybmG
         fTgoD8mp98cPkRqhUqUUvN0j5Uh1TUjTFDTByF7SlTCtdc58HV3HMeaeU8MFnxIv/deV
         ndrUL1NwAto9pPt/ROSOleSwD2MLIVWVz9agyiX8+ZTwQbzqKsUwNAYcyXxeCexqGPuM
         I8cjIbYT5HSigu1X/h9q7eSfLIow5DvOdi3Rk0SVpAGxjpwsaQeFtFzlM90kmEuVmpdL
         uM2CdFt7Njlt/zsRb+g3X69VH881KcxBrlOfmV7B/Mfyxy2wg2M3oqYdQogl4xoR/PAD
         cHiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737046587; x=1737651387;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H58Ez4Z8nz/I0BfpOMpCpBNBR2Nn1ADeoJi+O2wMRGI=;
        b=WiTZ89PxXrKbVhpG5pXWyTUY1arsYWDOk1UdSn45SFJz3e2iXV3F3VKYIRnOFBYOeR
         jxKYV+hrwwemGSL36QdyN2n4Kp5SZGagzSAap3QU7DJCzNBkm0LxZhsMA6bIsGNjh6xe
         sJCCpcu+fuTf/5Bdukxc+n5342l0Dar0WQtxPbFf/PzBxmmXPuj/WcR7c9+H1opql6ob
         7/nhJi9ptAOneBp+1kK8etW7Uwc76gm+KdWaRKuB/EhBl781Ek2QW1p9eLSIrvXWBHLs
         VSUmHfQNU8LYmCyPiQz8Bva1PdlTYSdLArCUrLonsPmTZUwa8ziFuPWsGWT2nYynlU25
         7+0w==
X-Forwarded-Encrypted: i=1; AJvYcCXcJWeGG5lt+u/4MoSFyxQrgWUqlkK7NOH2galVbO9CYn5tXGFL/0DbpbFsh1dRm3x7qjw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzX40DYZB+zEVeqK49wwZbBHTDZ5JDRSMHvqR9xTFSYFJo4FCYe
	nBz7Ly3rcuHAXv6dlDCXVRMuSI1jcdjQsX04TErIGiwMRuhISXUzryREZXOqLcCuLpLh26g0RZY
	lCA==
X-Google-Smtp-Source: AGHT+IEp63QwXk/+kbItMFqQLqyMWFGeMYyxK8RiI/mCB5mVqcmmuPx7zxejaR+r2KGLU+OLJ1XWO2BpZHY=
X-Received: from pjbqn7.prod.google.com ([2002:a17:90b:3d47:b0:2ea:5c73:542c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:540e:b0:2ee:a76a:830
 with SMTP id 98e67ed59e1d1-2f548f1b2bfmr52474138a91.24.1737046587129; Thu, 16
 Jan 2025 08:56:27 -0800 (PST)
Date: Thu, 16 Jan 2025 08:56:25 -0800
In-Reply-To: <20250116162525.GFZ4ky9TdSn7jltgw7@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <3acfbef7-8786-4033-ab99-a97e971f5bd9@amd.com> <20250108082221.GBZ341vUyxrBPHgTg3@fat_crate.local>
 <4b68ee6e-a6b2-4d41-b58f-edcceae3c689@amd.com> <cd6c18f3-538a-494e-9e60-2caedb1f53c2@amd.com>
 <Z36FG1nfiT5kKsBr@google.com> <20250108153420.GEZ36a_IqnzlHpmh6K@fat_crate.local>
 <Z36vqqTgrZp5Y3ab@google.com> <4ab9dc76-4556-4a96-be0d-2c8ee942b113@amd.com>
 <Z4gqlbumOFPF_rxd@google.com> <20250116162525.GFZ4ky9TdSn7jltgw7@fat_crate.local>
Message-ID: <Z4k6OcbLqMxvvmb-@google.com>
Subject: Re: [PATCH v16 12/13] x86/tsc: Switch to native sched clock
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, 
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, pgonda@google.com, pbonzini@redhat.com, 
	francescolavra.fl@gmail.com, Alexey Makhalov <alexey.makhalov@broadcom.com>, 
	Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 16, 2025, Borislav Petkov wrote:
> On Wed, Jan 15, 2025 at 01:37:25PM -0800, Sean Christopherson wrote:
> > My strong vote is prefer TSC over kvmclock for sched_clock if the TSC is constant,
> > nonstop, and not marked stable via command line.
> 
> So how do we deal with the case here where a malicious HV could set those bits
> and still tweak the TSC?

You don't.  If the hypervisor is malicious, it's game over for non-CoCo guests.
The clocksource being untrusted is completely unintersting because the host has
full access to VM state.

It's probably game over for SEV and SEV-ES too, e.g. thanks to remapping attacks,
lack of robust attestation, and a variety of other avenues a truly malicious
hypervisor can exploit to attack the guest.

It's only with SNP and TDX that the clocksource becomes at all interesting.

> IOW, I think Secure TSC and TDX should be the only ones who trust the TSC when
> in a guest.
> 
> If anything, trusting the TSC in a normal guest should at least issue
> a warning saying that we do use the TSC but there's no 100% guarantee that it
> is trustworthy...

Why?  For non-TDX/SecureTSC guests, *all* clocksources are host controlled.

> > But wait, there's more!  Because TDX doesn't override .calibrate_tsc() or
> > .calibrate_cpu(), even though TDX provides a trusted TSC *and* enumerates the
> > frequency of the TSC, unless I'm missing something, tsc_early_init() will compute
> > the TSC frequency using the information provided by KVM, i.e. the untrusted host.
> 
> Yeah, I guess we don't want that. Or at least we should warn about it.

CPUID 0x15 (and 0x16?) is guaranteed to be available under TDX, and Secure TSC
would ideally assert that the kernel doesn't switch to some other calibration
method too.  Not sure where to hook into that though, without bleeding TDX and
SNP details everywhere.

> > +	/*
> > +	 * If the TSC counts at a constant frequency across P/T states, counts
> > +	 * in deep C-states, and the TSC hasn't been marked unstable, prefer
> > +	 * the TSC over kvmclock for sched_clock and drop kvmclock's rating so
> > +	 * that TSC is chosen as the clocksource.  Note, the TSC unstable check
> > +	 * exists purely to honor the TSC being marked unstable via command
> > +	 * line, any runtime detection of an unstable will happen after this.
> > +	 */
> > +	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
> > +	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
> > +	    !check_tsc_unstable()) {
> > +		kvm_clock.rating = 299;
> > +		pr_warn("kvm-clock: Using native sched_clock\n");
> 
> The warn is in the right direction but probably should say TSC still cannot be
> trusted 100%.

Heh, I didn't mean to include the printks, they were purely for my own debugging.

> > diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> > index 0864b314c26a..9baffb425386 100644
> > --- a/arch/x86/kernel/tsc.c
> > +++ b/arch/x86/kernel/tsc.c
> > @@ -663,7 +663,12 @@ unsigned long native_calibrate_tsc(void)
> >  	unsigned int eax_denominator, ebx_numerator, ecx_hz, edx;
> >  	unsigned int crystal_khz;
> >  
> > -	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> > +	/*
> > +	 * Ignore the vendor when running as a VM, if the hypervisor provides
> > +	 * garbage CPUID information then the vendor is also suspect.
> > +	 */
> > +	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL &&
> > +	    !boot_cpu_has(X86_FEATURE_HYPERVISOR))
> >  		return 0;
> >  
> >  	if (boot_cpu_data.cpuid_level < 0x15)
> > @@ -713,10 +718,13 @@ unsigned long native_calibrate_tsc(void)
> >  		return 0;
> >  
> >  	/*
> > -	 * For Atom SoCs TSC is the only reliable clocksource.
> > -	 * Mark TSC reliable so no watchdog on it.
> > +	 * For Atom SoCs TSC is the only reliable clocksource.  Similarly, in a
> > +	 * VM, any watchdog is going to be less reliable than the TSC as the
> > +	 * watchdog source will be emulated in software.  In both cases, mark
> > +	 * the TSC reliable so that no watchdog runs on it.
> >  	 */
> > -	if (boot_cpu_data.x86_vfm == INTEL_ATOM_GOLDMONT)
> > +	if (boot_cpu_has(X86_FEATURE_HYPERVISOR) ||
> > +	    boot_cpu_data.x86_vfm == INTEL_ATOM_GOLDMONT)
> >  		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
> >  
> >  #ifdef CONFIG_X86_LOCAL_APIC
> 
> It looks all wrong if a function called native_* sprinkles a bunch of "am
> I a guest" checks. I guess we should split it into VM and native variants.

I agree the naming is weird, but outside of the vendor checks, the VM code is
identical to the "native" code, so I don't know that it's worth splitting into
multiple functions.

What if we simply rename it to calibrate_tsc_from_cpuid()?

> But yeah, the general direction is ok once we agree on what we do when
> exactly.

