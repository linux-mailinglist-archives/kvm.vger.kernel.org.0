Return-Path: <kvm+bounces-42039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D57ADA71CFA
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 18:20:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6BFE419C0939
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 17:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C37821FDA92;
	Wed, 26 Mar 2025 17:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NE2Ouqek"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B8D1FECDB
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 17:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743009470; cv=none; b=JjLbMMVnPBqAxvJWFkX6NHmJNpqO+yTRKhGcFj/oMit1gYY2mGMKSI3yq8sHtA3pa32TFQi0KXRsrYemCQRD9wcVElnKysygL6pd+OsMoMXSNRtmIZYz95d+3geUywHNdvfcSmNeNTCJT1VpJ4UfFuTZqC4EFon+fGbR6iaaclU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743009470; c=relaxed/simple;
	bh=LMWgUoP8H5hud2jquf3xDSpzfKmXw3BzZ/VDXBFKOC0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XEGfX3yu1McGsGTzk+Oh9oDJDM5rfBay7C0kc0y7K4xk3Ikt+T6LOJOzSOyO6SVABjvVRRci9sswcFvf68NkfmV5sOnK2A6y97p8A15XjeLyN11alhGm09ahArevB3ZW99BwN/aZjcnkOzsW6bTMQubw+0ui5rpA0CNeGoR10xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NE2Ouqek; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff8340d547so20605a91.2
        for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 10:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743009467; x=1743614267; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hluGm6VRaRlKKkj14E5M+udWDJDyW7msOhz4xM53G1w=;
        b=NE2OuqekmtU+8vrT6qtX4HdCRpMAMILxmHf2Mz1ij7rPqhi9aY0eL71xspsUANAoXD
         t8UgJTvn6OXYeK9xLKYlGjj1FnILK4e87T/een0GGFfGyoVVVAUyBBCgsgI8fAVhtEKm
         8FOo1btREtKugQ1YUqDXpXvzLr9qdc8Bu/ty5MBLypS4EbHyBh1NYurP3qoF2HzyNSQR
         8kC24rPCvvqkm3CfeytsBUDkQqhzMED9fae9Yw8pgzNL04XNTRl5HeRAW1rrIRDd0/ni
         vp9+sMgl9Y83rAla6oZhRFFDwszFbZofsJ56Xf1UwOIf6S/WhT95SG+9m8rF1KYNFIGH
         w2mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743009467; x=1743614267;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hluGm6VRaRlKKkj14E5M+udWDJDyW7msOhz4xM53G1w=;
        b=MF1u8Hw9yET7DNr0XEfnH1ZD67fhWmvVI4Pw6/ujfNX54zRCe5IBJI7tAOMiGLVjCZ
         MzQnwm7gdUc3h0bgDdRHxQ/j2cBCNutCO32cCQIpt9pshnTU0NP5DCgGnvKX22s8HTRl
         6XngMzgl7QzDwIhCBHQqjGXZRU2ZcL2prcmTgjsvleR92RJaG0Qvn6f8Q1OJ/gWxpz7q
         NhiTyBogJ49pp9dTZnSKi8lW9w5pGPDAQap71lMABAvjY1HKklwZpBetuRHTz4fft6ai
         FVIV2vigF4ZCXN/v0SH1rOaoDuqN26vRF5Gfe7VXxkw2XyqmGYkhTn8Hshz9D9njXmq2
         EyHw==
X-Gm-Message-State: AOJu0Yyh1+narfNehTlXWqNT1x9kmCEK0vwK5nk887RSmydxGfMt0tcU
	oIjMWDXWXp/imTa5xiPzvnxvvEiZcobiIVvvzH7N3o3XkMlweYBk0tf4NgtK62FElGyk9/iHAr+
	DBA==
X-Google-Smtp-Source: AGHT+IEJBmy0VbIydSttkDIQEZdME5KE7UTUfEYnfDQDlN3EXThMA4yqR2HKH7n59GKJLZV+S/r5RRpuLWY=
X-Received: from pjbof13.prod.google.com ([2002:a17:90b:39cd:b0:2fa:15aa:4d2b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c2cd:b0:301:1bce:c252
 with SMTP id 98e67ed59e1d1-303a8d81d2bmr548198a91.27.1743009467251; Wed, 26
 Mar 2025 10:17:47 -0700 (PDT)
Date: Wed, 26 Mar 2025 10:17:45 -0700
In-Reply-To: <41bfb025-008c-db03-2f6d-33b2d542ae65@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <6053e8eba1456e4c1bf667f38cc20a0ea05bc72c.1742232014.git.thomas.lendacky@amd.com>
 <48899db8-c506-b4d1-06cd-6ba9041437f7@amd.com> <Z9hbwkqwDKlyPsqv@google.com>
 <8c0ed363-9ecc-19b2-b8d7-5b77538bda50@amd.com> <91b5126e-4b3e-bcbf-eb0d-1670a12b5216@amd.com>
 <29b0a4fc-530f-29bf-84d4-7912aba7fecb@amd.com> <aeabbd86-0978-dbd1-a865-328c413aa346@amd.com>
 <Z93zl54pdFJ2wtns@google.com> <9a36b230-bf41-8802-e7ba-397b7feb5073@amd.com> <41bfb025-008c-db03-2f6d-33b2d542ae65@amd.com>
Message-ID: <Z-Q2uQ0perBQiZh-@google.com>
Subject: Re: [PATCH] KVM: SVM: Fix SNP AP destroy race with VMRUN
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Mar 26, 2025, Tom Lendacky wrote:
> On 3/25/25 12:49, Tom Lendacky wrote:
> > On 3/21/25 18:17, Sean Christopherson wrote:
> >> On Fri, Mar 21, 2025, Tom Lendacky wrote:
> >>> On 3/18/25 08:47, Tom Lendacky wrote:
> >>>> On 3/18/25 07:43, Tom Lendacky wrote:
> >>>>>>> Very off-the-cuff, but I assume KVM_REQ_UPDATE_PROTECTED_GUEST_STATE just needs
> >>>>>>> to be annotated with KVM_REQUEST_WAIT.
> >>>>>>
> >>>>>> Ok, nice. I wasn't sure if KVM_REQUEST_WAIT would be appropriate here.
> >>>>>> This is much simpler. Let me test it out and resend if everything goes ok.
> >>>>>
> >>>>> So that doesn't work. I can still get an occasional #VMEXIT_INVALID. Let
> >>>>> me try to track down what is happening with this approach...
> >>>>
> >>>> Looks like I need to use kvm_make_vcpus_request_mask() instead of just a
> >>>> plain kvm_make_request() followed by a kvm_vcpu_kick().
> >>
> >> Ugh, I was going to say "you don't need to do that", but I forgot that
> >> kvm_vcpu_kick() subtly doesn't honor KVM_REQUEST_WAIT.
> >>
> >> Ooof, I'm 99% certain that's causing bugs elsewhere.  E.g. arm64's KVM_REQ_SLEEP
> >> uses the same "broken" pattern (LOL, which means that of course RISC-V does too).
> >> In quotes, because kvm_vcpu_kick() is the one that sucks.
> >>
> >> I would rather fix that a bit more directly and obviously.  IMO, converting to
> >> smp_call_function_single() isntead of bastardizing smp_send_reschedule() is worth
> >> doing regardless of the WAIT mess.  This will allow cleaning up a bunch of
> >> make_request+kick pairs, it'll just take a bit of care to make sure we don't
> >> create a WAIT where one isn't wanted (though those probably should have a big fat
> >> comment anyways).

...

> >> @@ -3764,12 +3764,12 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
> >>         if (kvm_arch_vcpu_should_kick(vcpu)) {
> >>                 cpu = READ_ONCE(vcpu->cpu);
> >>                 if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
> >> -                       smp_send_reschedule(cpu);
> >> +                       smp_call_function_single(cpu, ack_kick, NULL, wait);
> > 
> > In general, this approach works. However, this change triggered
> > 
> >  WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
> > 	      && !oops_in_progress);
> > 
> > in kernel/smp.c.

Drat, I forgot that smp_call_function_xxx() can deadlock even if wait=false due
to needing to take locks to set the callback function.

> Is keeping the old behavior desirable when IRQs are disabled? Something
> like:
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a6fedcadd036..81cbc55eac3a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3754,8 +3754,14 @@ void __kvm_vcpu_kick(struct kvm_vcpu *vcpu, bool wait)
>  	 */
>  	if (kvm_arch_vcpu_should_kick(vcpu)) {
>  		cpu = READ_ONCE(vcpu->cpu);
> -		if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
> -			smp_call_function_single(cpu, ack_kick, NULL, wait);
> +		if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
> +			WARN_ON_ONCE(wait && irqs_disabled());
> +
> +			if (irqs_disabled())
> +				smp_send_reschedule(cpu);
> +			else
> +				smp_call_function_single(cpu, ack_kick, NULL, wait);
> +		}
>  	}
>  out:
>  	put_cpu();

That, or keying off wait, and letting smp_call_function_xxx() yell about trying
to use it with IRQs disabled, i.e.

			if (wait)
				smp_call_function_single(cpu, ack_kick, NULL, wait);
			else
				smp_send_reschedule(cpu);

My vote would be for the checking "wait", so that the behavior is consistent for
a given request.

