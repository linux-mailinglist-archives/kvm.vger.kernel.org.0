Return-Path: <kvm+bounces-29093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 56E0F9A286C
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 18:20:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B5D62B274DB
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 16:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 884B01DF267;
	Thu, 17 Oct 2024 16:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TiFkoobF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B541DEFF6
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 16:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729182017; cv=none; b=Uad0Ilbfc+rLypeu2SFSoj/7oHVXAnZoKZAN9QV6l/64RieDh0qde4qQJU1sucXZqaVBrhSC5i20P9qBiYxtOVQxs1r1pOzEbVudUiBweZjONMy9iWvORdH17drfZABh3nQNszG4hogLnfs9Ou8EEUeJ7fXBu/1IIkmYiitiiwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729182017; c=relaxed/simple;
	bh=Wna39gDDseGpvHU38IFbcJdQbyF2QYRr0Fwo1lzdwvg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DT7DdE5YdfG1u329Ma+fttVggtsyVwuJ2Y58y2qZR+DJekYi9mGbhErn3S7JtDSkHqbccVgn26BsBKq5hLguUyAAGCiD33LJ3ZUsqHgjoQ1OkrrfHh7IPV28o3Y4AqfcXU7etw3ogMtqqtBTszhMBLPPitBpa881Nfnq4eHIGNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TiFkoobF; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e291ac8dcf3so1721034276.3
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 09:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729182015; x=1729786815; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6TNhzPJgm6ahtMirM8FpCRpTy9fAvxEyNvEQkfjArmU=;
        b=TiFkoobFA8gMb3qqTMu090tyFC465XDcAdzjDUnLl5oUvfzkECRTdytJHs5Xsao4Pg
         KbkTEDgJgHkFnh2WdAAkNgMAQ68d2TVQGqTlkIXr9gfOijCFudUfNxhAZXmMxX8yk9aU
         ug/wjkU/Z2Jlj5eXhecI3Tmks78b4LYSTVzo2XR0KpE0kPAUnv51z0joxh1Glls0u8uW
         5UhDPZv/L1iLJAv3DwpW/BeqF88EiHxJNeCeQeIYIBPZFxE9uwH+WnZu/ODvrXUbE6e2
         tRIt8Qr/PAxStNGs1HBXQ64aXpIgiA89/nP9EB7mJ4KMZ/Xour/mvdpjJjajCN69Eugh
         djIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729182015; x=1729786815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6TNhzPJgm6ahtMirM8FpCRpTy9fAvxEyNvEQkfjArmU=;
        b=AkN3Pj+yPHAP7bDDB9BcB7kyjcGJxDVPysNf90OX6MCKkLy/VEpPcbfrT6baZ+ne9f
         gv9fa2zoe2MbqLXZi59b2BSgFIm/quzjO5aCBfwqMVGY5nwsRSaQqoJJ7+Xq49wUfCuc
         gGkHYb00zfLA3JURHTqlwZhvM2urqVus+JS+x18rNaYx2KAxhwQNIMP2xq8kYXfzvYsn
         Zor/cqFAnx3+SW6wCNgTL/OlWdG+6VvQctPid5ApRyP3i7dP0kytyWZ3eJjUU2pVRGza
         4JAZwInzkBm3vyI4DEeXWXXdwPo9jkh6ZRjbKgTGm+Dvnp+XYE/KiEJa3SEmJw2vW6jr
         iwxw==
X-Forwarded-Encrypted: i=1; AJvYcCVSfFXOD95a8yrji5Ssh0S3n4tmdkKVou+tMTlw3kSlaL4+FYcJ//eej3iv2bVQKZxmhBE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbogXZe2osuiBnE8wny8if4GXuPOUcd6JgOa++6Is35uEoiCPW
	eSP2RPJFKMYoDTN8FT5yZ9htNPkqXxvAa+zpRx2fwU84CnO9rGmdtQ9gqlhV/hwYF8EUjxAxB+h
	vxw==
X-Google-Smtp-Source: AGHT+IHsGe4Hv+bg4+MmRWEsVf0uSYOOLHi2t3q7KoObLMA2GYC/g110gqN2qHyL69OnjdL/alOhfUjSF7w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:9bc9:0:b0:e2b:a511:2e51 with SMTP id
 3f1490d57ef6-e2ba5112f27mr2471276.11.1729182014972; Thu, 17 Oct 2024 09:20:14
 -0700 (PDT)
Date: Thu, 17 Oct 2024 09:20:13 -0700
In-Reply-To: <2b954265-9ec0-4ee6-99c8-6ac080687d02@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240927161657.68110-1-iorlov@amazon.com> <20240927161657.68110-3-iorlov@amazon.com>
 <Zwm9TmRpNY6EeGKu@google.com> <2b954265-9ec0-4ee6-99c8-6ac080687d02@gmail.com>
Message-ID: <ZxE5PZ-tY4f8mNBp@google.com>
Subject: Re: [PATCH 2/3] KVM: vmx, svm, mmu: Process MMIO during event delivery
From: Sean Christopherson <seanjc@google.com>
To: Ivan Orlov <ivan.orlov0322@gmail.com>
Cc: Ivan Orlov <iorlov@amazon.com>, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, pbonzini@redhat.com, shuah@kernel.org, tglx@linutronix.de, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, x86@kernel.org, jalliste@amazon.com, 
	nh-open-source@amazon.com, pdurrant@amazon.co.uk
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 16, 2024, Ivan Orlov wrote:
> On 10/12/24 01:05, Sean Christopherson wrote:
> > 
> > > +			 * without VMM intervention, so return a corresponding internal error
> > > +			 * instead (otherwise, vCPU will fall into infinite loop trying to
> > > +			 * deliver the event again and again).
> > > +			 */
> > > +			if (error_code & PFERR_EVT_DELIVERY) {
> > 
> > Hmm, I'm 99% certain handling error in this location is wrong, and I'm also pretty
> > sure it's unnecessary.  Or rather, the synthetic error code is unnecessary.
> > 
> > It's wrong because this path specifically handles "cached" MMIO, i.e. emulated
> > MMIO that is triggered by a special MMIO SPTE.  KVM should punt to userspace on
> > _any_ MMIO emulation.  KVM has gotten away with the flaw because SVM is completely
> > broken, and VMX can always generate reserved EPTEs.  But with SVM, on CPUs with
> > MAXPHYADDR=52, KVM can't generate a reserved #PF, i.e. can't do cached MMIO, and
> > so I'm pretty sure your test would fail on those CPUs since they'll never come
> > down this path.
> > 
> 
> Ah, alright, I see... Probably, I need to test the next version with
> enable_mmio_caching=false as well.
> 
> > Heh, though I bet the introduction of RET_PF_WRITE_PROTECTED has regressed
> > shadow paging on CPUs with PA52.
> 
> Is it because it doesn't process write-protected gfn correctly if it is in
> MMIO range when mmio caching is disabled?

Ignore this, I was thinking lack of cached MMIO SPTEs would result in no
EPT Misconfig, but it's shadow paging, there is no EPT.

> > Anyways, the synthetic PFERR flag is unnecessary because the information is readily
> > available to {vmx,svm}_check_emulate_instruction().  Ha!  And EMULTYPE_WRITE_PF_TO_SP
> > means vendor code can even precisely identify MMIO.
> 
> Hmm, do you mean EMULTYPE_PF? It looks like EMULTYPE_WRITE_PF_TO_SP has
> nothing to do with MMIO...

Nope.  Well, both.  EMULTYPE_PF is set if *any* page fault triggers emulation.
EMULTYPE_WRITE_PF_TO_SP is set if emulation was triggered by a write protection
violation due to write-tracking, and write-tracking requires an underlying memslot.
I.e. if EMULTYPE_WRITE_PF_TO_SP is set, then emulation *can't* be for emulated
MMIO.

> I thought about processing the error in check_emulate_instruction as it
> seems logical, however I hadn't found a way to detect MMIO without page
> walking on SVM. I'll validate that EMULTYPE_PF gets set in all of the MMIO
> cases and move the handling into this function in V2 if it works.
> 
> > I think another X86EMUL_* return type is needed, but that's better than a synthetic
> > #PF error code flag.
> > 
> 
> If I understand correctly, you suggest returning this new
> X86EMUL_<something> code from {svm,vmx}_check_emulate_instruction and
> process it in the common code, right? I agree that it's much better than
> handling the error in MMU code. We are gonna return this return type from
> vendor code and handle it in the common code this way, which is neat!

Yep, exactly.

> > Ugh, and the manual call to vmx_check_emulate_instruction() in handle_ept_misconfig()
> > is similarly flawed, though encountering that is even more contrived as that only
> > affects accesses from SGX enclaves.
> > 
> > Hmm, and looking at all of this, SVM doesn't take advantage of KVM_FAST_MMIO_BUS.
> > Unless I'm forgetting some fundamental incompatibility, SVM can do fast MMIO so
> > long as next_rip is valid.
> > 
> > Anyways, no need to deal with vmx_check_emulate_instruction() or fast MMIO, I'll
> > tackle that in a separate series.  But for this series, please do the EPT misconfig
> > in a separate patch from fixing SVM.  E.g. extract the helper, convert VMX to the
> > new flow, and then teach SVM to do the same.
> > 
> 
> Hmm, implementing KVM_FAST_MMIO_BUS for SVM sounds like an interesting thing
> to do, please let me know if I could help. By the way, why can't we move the
> call to kvm_io_bus_write into the common code (e.g. MMU)? It would remove
> the need of implementing KVM_FAST_MMIO_BUS specifically for each vendor.

That would work too, but vendor code needs to be aware of "fast" MMIO no matter
what, because there are vendor specific conditions that make fast MMIO impossible
(KVM needs the CPU to provide the instruction length, otherwise KVM needs to
emulate the instruction in order to decode it, which makes fast MMIO not-fast).

> > >   		gpa_t gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
> > > -		bool is_mmio = exit_reason.basic == EXIT_REASON_EPT_MISCONFIG;
> > > -
> > 
> > Blank newline after variable declarations.
> > 
> > > -		kvm_prepare_ev_delivery_failure_exit(vcpu, gpa, is_mmio);
> > > +		kvm_prepare_ev_delivery_failure_exit(vcpu, gpa, false);
> > >   		return 0;
> > >   	}
> > 
> > All in all, I think this is the basic gist?  Definitely feel free to propose a
> > better name than X86EMUL_UNHANDLEABLE_VECTORING.
> > 
> 
> It sounds OK, but maybe something more precise would work, like
> X86EMUL_VECTORING_IO_NEEDED (by analogy with X86EMUL_IO_NEEDED)?

Hmm, I definitely want X86EMUL_UNHANDLEABLE_XXX, so that it's super clear that
emulation failed.  Maybe X86EMUL_UNHANDLEABLE_IO_VECTORING?  Sadly, I think we
need VECTORING (or similar) in the name, because it will be morphed to
KVM_INTERNAL_ERROR_DELIVERY_EV.  E.g. simply X86EMUL_UNHANDLEABLE_IO would be
nice, but is wildly misleading as there are other scenarios where KVM can't
handled emulated MMIO during instruction emulation.  :-/

