Return-Path: <kvm+bounces-29904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B23E9B3D9E
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 23:19:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8487C1F22EB7
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 22:19:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEAD51EE034;
	Mon, 28 Oct 2024 22:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="yC2551cE";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ryxFZrJ2"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F21618B463;
	Mon, 28 Oct 2024 22:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730153951; cv=none; b=QGw3p/KkT3d3oI63RjSd1arrzOijCm6vLiOLS5ApsJp1MKtAH6SHuiuP8IPr+HNnfDLTIiWcV20/oBK4Q//4gMBBlCBSZDyhG+ypvW5WT85ZrtJX3YtZuy65KW+3hmaEJECMeZ831iBdm/Ekqnf1NtJKnbk8IMdfNMC4kTaTSrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730153951; c=relaxed/simple;
	bh=wZfiElJNgPMRASOkba3UW66Fo6QlAO22vURGpbsr03Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=MINT3RmEXVZyamSTrWbub9thToZZNPo03Yl/FGCYUg0s3vriT/U+PtQgYVhJz/ApU99+P0TaKLnCcs0ucNwTpw+cCHoSCpYx1y2+e6p55+O2ieMq9HIG4mWiEY9unB+YKLaLYkH1UI7KYyLo0R3ZZENGp+6QGdasghzgiDSRCV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=yC2551cE; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ryxFZrJ2; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1730153947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6/8ZwS0TR8XAVxV2M68+qMmgs76NcpDeIWs2g7rJgyo=;
	b=yC2551cEJYkJtfMRbOj1kffpoi7/l9RNimEzkBQrnjDdmdCorPDdTPzr697XVUL5NnUjSt
	D+BqoUbxDF+W4jTHnKL5PsAlQSF+lZJpvX18L86ikGocRLmcjyPAZvjLUZlfWQRB4fv0tR
	WQ5shepPb7hlG0t3IAyKVCkolpeFqbZjOA7X/jqOTgEJQ7z6sIcjF5G5CkF8H3qSMhVLj4
	J/6qRqRjpAtB4P7j2Tv6OQ+mVQV/oPUEvytaNuYHYNLrAf/GElcTxedXA1xuXYFhQXAoLP
	rvawHxm5BGyEjegaTbCMUMRocCG5PLxVTr60iuA0aQwIr/PjJTNkHigTgiB0jA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1730153947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6/8ZwS0TR8XAVxV2M68+qMmgs76NcpDeIWs2g7rJgyo=;
	b=ryxFZrJ2WWWO6djBxRfHy+5bW7t78WCJo2spCNxMVeImOdFYXx6cRiUEASCaYjqZGFu5uj
	tjf+99bepO4jgMCw==
To: Sean Christopherson <seanjc@google.com>, Nam Cao <namcao@linutronix.de>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker
 <frederic@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, Alice
 Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, Kees Cook
 <kees@kernel.org>, linux-kernel@vger.kernel.org, Paolo Bonzini
 <pbonzini@redhat.com>, x86@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 04/21] KVM: x86/xen: Initialize hrtimer in
 kvm_xen_init_vcpu()
In-Reply-To: <Zx-1ahdKLH3o2MHj@google.com>
References: <cover.1729864615.git.namcao@linutronix.de>
 <c8e184b7acf1e073c0d6cf489031bc7d2b6304b0.1729864615.git.namcao@linutronix.de>
 <Zx-1ahdKLH3o2MHj@google.com>
Date: Mon, 28 Oct 2024 23:19:07 +0100
Message-ID: <87iktb27ms.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Oct 28 2024 at 09:01, Sean Christopherson wrote:
> On Mon, Oct 28, 2024, Nam Cao wrote:
>> The hrtimer is initialized in the KVM_XEN_VCPU_SET_ATTR ioctl. That caused
>> problem in the past, because the hrtimer can be initialized multiple times,
>> which was fixed by commit af735db31285 ("KVM: x86/xen: Initialize Xen timer
>> only once"). This commit avoids initializing the timer multiple times by
>> checking the field 'function' of struct hrtimer to determine if it has
>> already been initialized.
>> 
>> Instead of "abusing" the 'function' field, move the hrtimer initialization
>> into kvm_xen_init_vcpu() so that it will only be initialized once.
>> 
>> Signed-off-by: Nam Cao <namcao@linutronix.de>
>> ---
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: x86@kernel.org
>> Cc: kvm@vger.kernel.org
>> ---
>>  arch/x86/kvm/xen.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
>> index 622fe24da910..c386fbe6b58d 100644
>> --- a/arch/x86/kvm/xen.c
>> +++ b/arch/x86/kvm/xen.c
>> @@ -1070,9 +1070,6 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
>>  			break;
>>  		}
>>  
>> -		if (!vcpu->arch.xen.timer.function)
>> -			kvm_xen_init_timer(vcpu);
>> -
>>  		/* Stop the timer (if it's running) before changing the vector */
>>  		kvm_xen_stop_timer(vcpu);
>>  		vcpu->arch.xen.timer_virq = data->u.timer.port;
>> @@ -2235,6 +2232,7 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
>>  	vcpu->arch.xen.poll_evtchn = 0;
>>  
>>  	timer_setup(&vcpu->arch.xen.poll_timer, cancel_evtchn_poll, 0);
>> +	kvm_xen_init_timer(vcpu);
>
> I vote for opportunistically dropping kvm_xen_init_timer() and open coding its
> contents here.

Makes sense.

> If the intent is for subsystems to grab their relevant patches, I can fixup when
> applying.

Ideally I can route it through my tree to avoid a full release delay as
the subsequent changes depend on this and the core hrtimer API changes.

Thanks,

        tglx


