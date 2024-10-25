Return-Path: <kvm+bounces-29686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AC299AF894
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 05:56:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE65A281632
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 03:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37D6518E050;
	Fri, 25 Oct 2024 03:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="ghWgbpbQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E1518C002;
	Fri, 25 Oct 2024 03:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729828572; cv=none; b=mdp37DZl1AdQmEJs2RC+oT9CmFFDQLYjODicK4kI8mDw3p27j/bu9Zmc3tYSCz5P9AM1EITgGloT9cPttKYBbXdKaQOHSQ98M3MpYnySkaOE8qafz8puN8na30/XeokaxPTq2Rn4LQZSE8K77pEEERe+A3Bg6AU83REWWldUU+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729828572; c=relaxed/simple;
	bh=nFfAqX1nuEjPAzz8vWo8La/0AzColIlWjX443+G9qwY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KLbxf6mIkqEnvr2XXPSwnFU5AEiLZxa3aEi0cF7vVylSsJbwxgeW8xpX6Lk5v0ebXy80nIy+aI7w85EgmDMclI+xADWzz3O4q32s34stTWeon3XRAm6cFJo/i2Sxcjtvgd35ci8B+J9xyhPIJI7lMotFdayvC/CRWeTtNJ+BZ7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=ghWgbpbQ; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1729828564;
	bh=zhqxaFdelNULJR0EVgv2G8QYzzTg5epKTyLS+XXXoa0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ghWgbpbQ6Ssp0Ya8t/2aTa4zdB6SP0T8GbEZQzex5ddeyDYOJkLpD26nX42ZVWgMw
	 mbPeOXfF8MELMRShXm17Jk2H9nszVq1HUL4NZKaWkm9m2Ay3nfbEe4aiVFxHOOT1RA
	 yhP0nLJxqZ985HnQMFIjcF4JwrstDc4f1QKEPypYh997qpSim6EKtD4zne6KElIaar
	 0g4NitpCjZ0sJh+PalJO2mCjmt1b2uTyGHgmqF5BzdCs996XIxBuZS/Bt35vu9Ii4b
	 2M3tAe7dq0Lm9jOtVs9/x8DslW0z9/d0vqJ9BY0Ht8Ie4s88CA0EowQJR1XIU2HfPs
	 JcXvo8Jq6LeuQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4XZTTw2Pjsz4w2N;
	Fri, 25 Oct 2024 14:56:04 +1100 (AEDT)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Gautam Menghani <gautam@linux.ibm.com>, npiggin@gmail.com,
 christophe.leroy@csgroup.eu, naveen@kernel.org
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: PPC: Book3S HV: Mask off LPCR_MER for a vCPU
 before running it to avoid spurious interrupts
In-Reply-To: <20241024173417.95395-1-gautam@linux.ibm.com>
References: <20241024173417.95395-1-gautam@linux.ibm.com>
Date: Fri, 25 Oct 2024 14:56:05 +1100
Message-ID: <877c9wkf8q.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi Gautam,

A few comments below ...

Gautam Menghani <gautam@linux.ibm.com> writes:
> Mask off the LPCR_MER bit before running a vCPU to ensure that it is not
> set if there are no pending interrupts.

I would typically leave this until the end of the change log. ie.
describe the bug and how it happens first, then the fix at the end.

But it's not a hard rule, so up to you.

> Running a vCPU with LPCR_MER bit
            ^
        "an L2 vCPU"

In general if you can qualify L0 vs L1 vs L2 everywhere it would help
folks follow the description.

> set and no pending interrupts results in L2 vCPU getting an infinite flood
> of spurious interrupts. The 'if check' in kvmhv_run_single_vcpu() sets
> the LPCR_MER bit if there are pending interrupts.
>
> The spurious flood problem can be observed in 2 cases:
> 1. Crashing the guest while interrupt heavy workload is running
>   a. Start a L2 guest and run an interrupt heavy workload (eg: ipistorm)
>   b. While the workload is running, crash the guest (make sure kdump
>      is configured)
>   c. Any one of the vCPUs of the guest will start getting an infinite
>      flood of spurious interrupts.
>
> 2. Running LTP stress tests in multiple guests at the same time
>    a. Start 4 L2 guests.
>    b. Start running LTP stress tests on all 4 guests at same time.
>    c. In some time, any one/more of the vCPUs of any of the guests will
>       start getting an infinite flood of spurious interrupts.
>
> The root cause of both the above issues is the same:
> 1. A NMI is sent to a running vCPU that has LPCR_MER bit set.
> 2. In the NMI path, all registers are refreshed, i.e, H_GUEST_GET_STATE
>    is called for all the registers.
> 3. When H_GUEST_GET_STATE is called for lpcr, the vcpu->arch.vcore->lpcr
>    of that vCPU at L1 level gets updated with LPCR_MER set to 1, and this
>    new value is always used whenever that vCPU runs, regardless of whether
>    there was a pending interrupt.
> 4. Since LPCR_MER is set, the vCPU in L2 always jumps to the external
>    interrupt handler, and this cycle never ends.
>
> Fix the spurious flood by making sure a vCPU's LPCR_MER is always masked
> before running a vCPU.

I think your original sentence at the top of the change log is actually more
accurate. ie. it's not that LPCR_MER is always cleared, it's cleared
*unless there's a pending interrupt*.

> Fixes: ec0f6639fa88 ("KVM: PPC: Book3S HV nestedv2: Ensure LPCR_MER bit is passed to the L0")
> Cc: stable@vger.kernel.org # v6.8+
> Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> ---
> V1 -> V2:
> 1. Mask off the LPCR_MER in vcpu->arch.vcore->lpcr instead of resetting
> it so that we avoid grabbing vcpu->arch.vcore->lock. (Suggested by
> Ritesh in an internal review)

Did v1 take the vcore->lock? I don't remember it.

> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 8f7d7e37bc8c..b8701b5dde50 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -5089,9 +5089,19 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
>  
>  	do {
>  		accumulate_time(vcpu, &vcpu->arch.guest_entry);
> +		/*
> +		 * L1's copy of L2's lpcr (vcpu->arch.vcore->lpcr) can get its MER bit
                                     ^
                                     LPCR
> +		 * unexpectedly set - for e.g. during NMI handling when all register
> +		 * states are synchronized from L0 to L1. L1 needs to inform L0 about
> +		 * MER=1 only when there are pending external interrupts.
> +		 * kvmhv_run_single_vcpu() anyway sets MER bit if there are pending
> +		 * external interrupts. Hence, mask off MER bit when passing vcore->lpcr
> +		 * here as otherwise it may generate spurious interrupts in L2 KVM
> +		 * causing an endless loop, which results in L2 guest getting hung.
> +		 */
>  		if (cpu_has_feature(CPU_FTR_ARCH_300))
>  			r = kvmhv_run_single_vcpu(vcpu, ~(u64)0,
> -						  vcpu->arch.vcore->lpcr);
> +						  vcpu->arch.vcore->lpcr & ~LPCR_MER);
 
This is much better than v1 which hid the clearing of LPCR_MER in a macro.

But I still wonder if it would be better to clear it in
kvmhv_run_single_vcpu() itself.

The logic to set LPCR_MER is already in there, so why not ensure
LPCR_MER is cleared as part of that some block?

I realise there's another caller of kvmhv_run_single_vcpu() from the
nested code, but that's OK because there's already a nested check in
kvmhv_run_single_vcpu(), so you can still isolate this change to just
the non-nested case.

cheers

