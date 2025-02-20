Return-Path: <kvm+bounces-38622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3EF8A3CE6C
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 02:08:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3AA23B5542
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 01:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB7961420DD;
	Thu, 20 Feb 2025 01:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ONW2FNuB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B0F23A0
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 01:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740013681; cv=none; b=g35Qk4Kin6rihEk+yqKnOLwxanvzIsCW6iGDpjPmbrEjU0NcvmtrpQWgQ+magOD484F/80CcKRl6hmTzxPNVNmzDysvAvrq0gXHN40auSGISmWExTCpTYNwt1xZyq24xz7l3BdxeWmkzdt53JzatGRSg2GJLNbygKYRY8BVMc7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740013681; c=relaxed/simple;
	bh=/lGakXVZCQx0lc7hrdwMSme41IJ7zwDg4c/s5KFisuE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=TpxWyOLSJ7Qm6VkS3uNS3XsWO2re6tuAbkY8iBWfdyRJMwQH/6KI4kpuaRlbxQ1t9C6XdDRMBXxvzDpY4aZPL0QJlcgPgr7oOhhbQGFlVzdc01+67E/kE/jD32ySL4UBlJgRx4lMkQsALWeVb9Y2sOkPGfZ5bk7ZWv8aDXCvtvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ONW2FNuB; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-220cd43c75aso10828425ad.3
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 17:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740013679; x=1740618479; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3V15TKwqZAC8dpBd3zv+ePQ+zbQqk14dXCyWdHzdLQE=;
        b=ONW2FNuBoUMpZHvR6P1JiHRGrfNz5oKpcuEoTiC+KVc7yz/BLZJqFsJPY9b140ea2S
         QyUJyeNGAHlWPvoPGPPXjpMrNsiKs47j1TtM/uyJdQkC+7l5y/aNqAy7wL7H0qanUI2P
         i5VWE8ml6IamonGn6ZyzKuPTLr+S9wvi8JNoqaBPFsJOGxHEv6OSxr/ldQrTeqJVM6ym
         gN/mSlstgHGYL03mHreeq96HKvKy136hexEvB9Ir6guAWxv9TPNY7pNoywCZD/yEHsVB
         6UepwPpasx8Zux9H18GOvvJaYeW/Lx4geQeg7J392eNbQCll8ygEgYHg35SM78N78wTK
         F8cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740013679; x=1740618479;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3V15TKwqZAC8dpBd3zv+ePQ+zbQqk14dXCyWdHzdLQE=;
        b=i9rFlsDVVsNX5nbkj18Y9sXxb+ilD02oywzYS0Dro1lSga6/z0ruXkpbqZkEN6r403
         FbBuKs0DplR05NXF3zkWAGPHsLEqD7o9i/9GE68AbpQ3YdvFxOe14CUcVKankMaD0VCl
         bqoeD/SLRPuOR1TyrMrLUhbq2dqreqjp0miWn4CIxqgW/kf0LgtVSQIuO+BbS+EM4mz5
         t9UUFfTgqsckHO7cdRPixrvRk7/CR5Ghx5WZKXBIQBNrFv5JJAVCSKXhih8QoFzM9pHp
         EioYXOdDvUxGO0aBWVSQifFgVgth6evXwMcZvmSQAVXXivixhKSPsUIDcs6oO7v5uhuL
         EEnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqAuUjKvI+LPUYNrjG9rKiGTkTuJbbGCuI7Ws2GhqU5aw1OHnDAnc4Y1wSFb6tAbh/i6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeRzi2B7WFWh/82L057YZWbnDA1TPz4igedodO1lOZHeBY3PI3
	00uC49TOw9yK38HGrWcMAOQV3t61sWEkE5TX25K49mjjDiGbH8hJmQ6HdyLKNh6lZ57ND8ClH78
	mVQ==
X-Google-Smtp-Source: AGHT+IFzBoJ9kkSVMGki9J8KCMzSJQurVwvUMLJQI9kOhy2xogXJenm8QqJIis7na1Vzj2miDdjT16wwdLc=
X-Received: from pjbcz12.prod.google.com ([2002:a17:90a:d44c:b0:2fa:15aa:4d1e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ccc6:b0:220:ff3f:6cc9
 with SMTP id d9443c01a7336-221711b98bbmr97110875ad.48.1740013679107; Wed, 19
 Feb 2025 17:07:59 -0800 (PST)
Date: Wed, 19 Feb 2025 17:07:57 -0800
In-Reply-To: <20250215010946.1201353-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215010946.1201353-1-seanjc@google.com> <20250215010946.1201353-2-seanjc@google.com>
Message-ID: <Z7aAbSQTjS4MBK7z@google.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Set RFLAGS.IF=1 in C code, to get VMRUN out
 of the STI shadow
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Doug Covelli <doug.covelli@broadcom.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 14, 2025, Sean Christopherson wrote:
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7640a84e554a..fa0687711c48 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4189,6 +4189,18 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
>  
>  	guest_state_enter_irqoff();
>  
> +	/*
> +	 * Set RFLAGS.IF prior to VMRUN, as the host's RFLAGS.IF at the time of
> +	 * VMRUN controls whether or not physical IRQs are masked (KVM always
> +	 * runs with V_INTR_MASKING_MASK).  Toggle RFLAGS.IF here to avoid the
> +	 * temptation to do STI+VMRUN+CLI, as AMD CPUs bleed the STI shadow
> +	 * into guest state if delivery of an event during VMRUN triggers a
> +	 * #VMEXIT, and the guest_state transitions already tell lockdep that
> +	 * IRQs are being enabled/disabled.  Note!  GIF=0 for the entirety of
> +	 * this path, so IRQs aren't actually unmasked while running host code.
> +	 */
> +	local_irq_enable();

Courtesy of the kernel test bot[*], these need to use the raw_ variants to avoid
tracing.  guest_state_{enter,exit}_irqoff() does all of the necessary tracing
updates, so we should be good on that front.

  svm_vcpu_enter_exit+0x39: call to trace_hardirqs_on() leaves .noinstr.text section

[*] https://lore.kernel.org/all/202502170739.2WX98OXk-lkp@intel.com

> +
>  	amd_clear_divider();
>  
>  	if (sev_es_guest(vcpu->kvm))
> @@ -4197,6 +4209,8 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
>  	else
>  		__svm_vcpu_run(svm, spec_ctrl_intercepted);
>  
> +	local_irq_disable();
> +
>  	guest_state_exit_irqoff();
>  }

