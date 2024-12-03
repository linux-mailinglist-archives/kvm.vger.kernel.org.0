Return-Path: <kvm+bounces-32947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 672869E2BAA
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 20:08:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1E962840B6
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 19:08:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25363204F62;
	Tue,  3 Dec 2024 19:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pWv0hY6H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFA01FF7CF
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 19:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733252871; cv=none; b=fwMnMnqGIUtVxe8vdfQQOPW21mlhxtRQ6M1swsA7ZeDYexz44kZAR8jGBO1TiipxwXP1G4b4QMQwIJaJ8bixhiXWQwwBJ3YRYMeQ8uv5kOEISpDAKFNBbALl9mbz4wQCKG56/t/xHvTzh/GPughwgyUduryZ6NEZYyyDKFWeobg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733252871; c=relaxed/simple;
	bh=MJR7wMKmDqS5aFmAfPznb4O85+40BOjFkprVenAI+OE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fw1IOuNzMrtw4vfNLBC09dN2VAb3+uUHw4wCTSHZZ8+A5YQ3aw+FhCa0S/fOPi5cs+dX68rmAiqgQ4rweH8K/CgN6kmt8Bi6ZdvVtNUGK1VoHPTSY5zzaNwqRjHpJVCGqDAbKD0FFgDjqkVo3HkBVd+hcXNWpZwVBQavmRaMmio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pWv0hY6H; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee3aa6daaaso4907554a91.3
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 11:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733252869; x=1733857669; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PaCdFtyuZCc6AtbaS5uMRjDy7Mq8Hk8zYjV/jOWuGVc=;
        b=pWv0hY6H1ZbDJXZq8K56SPd9d/5CdYLTRtI5I8rRnhH8VXQWtc6OIeTsO5lYUQeUhk
         ToQDUxS5JHRFw5tsmgB8GozyH7+ddc2Mmx2UnFLZ+TsaJf4hIAxPHq9LscBjb2ij7ll6
         z3HO3YY/IEHQcn5q1sCOfe4/LU0RTQmAa00CUrZ6QcT0aUZBVx0xpVNGcYMs9/nhROPW
         E6u9Uq/2zA4epZaKnYpPT7HUbQZkyIVtKcyWJPyIfO1imtEW0KwKwmdqOQZHSI3sZvta
         WZOcq9Jq/7Q+LWj0f1tA3heaiJsy2sghzmTfUCWOwL8RAJp2q+Nlna2TzDUkssngaovM
         Fteg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733252869; x=1733857669;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PaCdFtyuZCc6AtbaS5uMRjDy7Mq8Hk8zYjV/jOWuGVc=;
        b=kYlhuFB3wGGfW2Mwe0k+C9mCpvZfdwGcNUuve8gl8sjwTVjdC6/JfTmkW+KzMkyE7Q
         0ePwNWIvxykNPkWY81Qbt+LhMX/8ebozXC0Br3ne7slO/v1HwqESEZqG7+EvsyXrSCi3
         Vh2HPJGCVYg+NSH1Rfjn8zbNiLeMQmsiIcIEDQWbQfM83DBMwHGZt93N4NscfmmF1LoS
         Q/VJcoztTQKeAtwqepfG9z7GDmB5uv7lUoBi0oZSo4LDex9Xa+f7fb0svUBhhXRecKlQ
         DmBPzfLbjCUq7PXiuPJ2l7/QTqdlI8kME6987Qpbbgyd8GlgROXRWrC4+6ZBheP/unY9
         0d5w==
X-Forwarded-Encrypted: i=1; AJvYcCWA5xIUrtFZGvE8QKBaWd62g6eoPjdrhw3lMrBi+/QLkDgDxkq08R0mowxCFvifm1Q1Q3g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRH4b7bhJnyiEEaJ8VdKPGfpn4MEsYaw+3cIh0GcPO1ORqhD4V
	uKrVOjq/IpZ1iDb7WkHzCr8YyMkjL4jQtkH5Z4Ds9SPyV0dhLVjDLwk8fjARiwYJAOBV7qacAKa
	y5Q==
X-Google-Smtp-Source: AGHT+IHjoirwBfWtmi9PaYx/CFYut1Vj6FLcEXqUtE33259R8PXsBNLecTER6HtXRPmwtYfrA0AIIAqHdZ4=
X-Received: from pjbsb14.prod.google.com ([2002:a17:90b:50ce:b0:2ee:3882:175b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c4a:b0:2ee:e18b:c1fa
 with SMTP id 98e67ed59e1d1-2ef0125b2e5mr4090519a91.28.1733252869223; Tue, 03
 Dec 2024 11:07:49 -0800 (PST)
Date: Tue, 3 Dec 2024 11:07:47 -0800
In-Reply-To: <20241121185315.3416855-7-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com> <20241121185315.3416855-7-mizhang@google.com>
Message-ID: <Z09XA-2ao5CbXhV5@google.com>
Subject: Re: [RFC PATCH 06/22] KVM: x86: INIT may transition from HALTED to RUNNABLE
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Huang Rui <ray.huang@amd.com>, 
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>, Mario Limonciello <mario.limonciello@amd.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Perry Yuan <perry.yuan@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

The shortlog is an observation, not a proper summary of the change.

  KVM: x86: Handle side effects of receiving INIT while vCPU is HALTED

On Thu, Nov 21, 2024, Mingwei Zhang wrote:
> From: Jim Mattson <jmattson@google.com>
> 
> When a halted vCPU is awakened by an INIT signal, it might have been
> the target of a previous KVM_HC_KICK_CPU hypercall, in which case
> pv_unhalted would be set. This flag should be cleared before the next
> HLT instruction, as kvm_vcpu_has_events() would otherwise return true
> and prevent the vCPU from entering the halt state.
> 
> Use kvm_vcpu_make_runnable() to ensure consistent handling of the
> HALTED to RUNNABLE state transition.
> 
> Fixes: 6aef266c6e17 ("kvm hypervisor : Add a hypercall to KVM hypervisor to support pv-ticketlocks")
> Signed-off-by: Jim Mattson <jmattson@google.com>

Mingwei's SoB is missing.

> ---
>  arch/x86/kvm/lapic.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 95c6beb8ce279..97aa634505306 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -3372,9 +3372,8 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
>  
>  	if (test_and_clear_bit(KVM_APIC_INIT, &apic->pending_events)) {
>  		kvm_vcpu_reset(vcpu, true);
> -		if (kvm_vcpu_is_bsp(apic->vcpu))
> -			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> -		else
> +		kvm_vcpu_make_runnable(vcpu);

This is arguably wrong.  APs are never runnable after receiving.  Nothing should
ever be able to observe the "bad" state, but that doesn't make it any less
confusing.

This series also fails to address the majority cases where KVM transitions to RUNNABLE:

  __set_sregs_common()
  __sev_snp_update_protected_guest_state()
  kvm_arch_vcpu_ioctl_set_mpstate()
  kvm_xen_schedop_poll()
  kvm_arch_async_page_present()
  kvm_arch_vcpu_ioctl_get_mpstate()
  kvm_apic_accept_events() (SIPI path)

Yeah, some of those don't _need_ to be converted, and the existing behavior of
pv_unhalted is all kinds of sketchy, but fixing a few select paths just so that
APERF/MPERF virtualization does what y'all want it to do does not leave KVM in a
better place.

I also think we should add a generic setter, e.g. kvm_set_mp_state(), and take
this opportunity to sanitize pv_unhalted.  Specifically, I think pv_unhalted
should be clear on _any_ state transition, and unconditionally cleared when KVM
enters the guest.  The PV kick should only wake a vCPU that is currently halted.
Unfortunately, the cross-vCPU nature means KVM can't easily handle that when
delivering APIC_DM_REMRD.

Please also send these fixes as a separate series.  My crystal ball says APERF/MPERF
virtualization isn't going to land in the near future, and I would like to get
the mp_state handling cleaned up soonish.

> +		if (!kvm_vcpu_is_bsp(apic->vcpu))
>  			vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
>  	}
>  	if (test_and_clear_bit(KVM_APIC_SIPI, &apic->pending_events)) {
> -- 
> 2.47.0.371.ga323438b13-goog
> 

