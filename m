Return-Path: <kvm+bounces-15972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A64AD8B2A0E
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 22:45:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A7A91F24458
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 20:45:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E93A915573C;
	Thu, 25 Apr 2024 20:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0r38qx1J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40A0153814
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 20:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714077881; cv=none; b=lxcEEkeP8ObQrzHmuZrvZEFdSLeRRZ+lVy53PIjrC88oc9L71drwLnAgI3ewmzzG7Q3Fml7WSZYadeNOgVPvKLU3lAhgR1d/ME2mwzZ5GYGWjV1Qi4CkGNoZEPxKoMfk+6UJPwpTHdg8AeVxA1z9dlQ/SY/+q31yims14X0EcYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714077881; c=relaxed/simple;
	bh=pNAc4xx6x/Pk8Z2YHbQgt41qHlf9rLihZxwdYu91K1A=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=OeKSQ1c4bz5ifg9equpO/e3DDQa4Y6TN9p+THc9Szb46dqOynAhY5wNbwlC+/pyym+84MUhM/69TOn5+296bW0e9i92G83U9EyDlrlZZ7yuSPd30tA508x0OkrPBbrcCnc9D34r11+9IKiG9zBqm+n3WiiRrgVCQd0Ez8t9g4JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0r38qx1J; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbf618042daso2752091276.0
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 13:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714077879; x=1714682679; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7EPo+zEkHEFx1G3/t3IphIU996vlKHE8W7j3UdO+nD0=;
        b=0r38qx1J4EOdXUJ9q7PK2v28aQImNptnjHeuac1bvRHl0J3juashU1Y4sWo1JpAtS1
         349ydjgZiqFk6FsrZvocXrSdhqlcYiBbAru+FpBBwxxrE8emqz1cM7A8AGMb1Gca2gKg
         GW2RUNtHG5XtsqCi/YO2+IyRK74qyU89a9gW7fLhidQ/tbWVR8rIRvDMK7V1Kuad31Af
         spY7GHuqAZFhT6SLC+8xclF3fGd/rvoB8UHStNfS7J0irPuscRFseoaDkYDlmh70tAl8
         b82Py3/R8hkgjf207I2AfhAblB9CtglfbTp+XOEOSR7UKi9uysais/NNyVWFy6nYLV+G
         OYbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714077879; x=1714682679;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7EPo+zEkHEFx1G3/t3IphIU996vlKHE8W7j3UdO+nD0=;
        b=mUG7mad7SMJN4XpezPoxKpu6KI7kiLRe0E6906hykyeYf+NAZHT1YhT8LR6UOYvMT4
         OGeZd352qrmD9Ad9irlLnRWhlhktxZJhejHHDyM6tcsnO+l260jNe/cQWi0AJc0YKdpr
         tPlhRtJ8fRrFR80HuLpAuV4YTK4zvus8mM1oDIW2NPoLWXLAVujqnjutWnaP/wRCOIxv
         tR4rH6/Rzs4/T9x95ynq9liSMcuumhNzRAt6B02Z6QQBRtkowk0Uv/190pabwX41w3/x
         0eIx3qrbP4gEv3VMh/Y/gZxz2//4nfLJVoevEXKixjR++ed7wE0BR8lanPsmrul733Qp
         tYMQ==
X-Gm-Message-State: AOJu0Ywbx/5blevRD6yqGaIli+407I+gvFWwCtBqPqa6MYZwKGSf5FTR
	0TumuJ3py1mezsSKHaX1bgVRoewl2xjGxwkKVNz+qY8lJLG3H9rCZuAZDdSj8dWZFY6OD09h87G
	IbSG5YeRaZXZBTQpkpf2wSg==
X-Google-Smtp-Source: AGHT+IGAB6QOB7oBGzpObLQHA1ClHYJKANOvXwLDW//pW389wqrc02vbLvB6xtOYSun/X1gLD+tgNqvwAvZ/M4BCYw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:10c3:b0:de5:c2b:389b with
 SMTP id w3-20020a05690210c300b00de50c2b389bmr100094ybu.5.1714077878658; Thu,
 25 Apr 2024 13:44:38 -0700 (PDT)
Date: Thu, 25 Apr 2024 20:44:37 +0000
In-Reply-To: <ZibaBKCFMz-dJNM4@linux.dev> (message from Oliver Upton on Mon,
 22 Apr 2024 14:43:32 -0700)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsntedat9npm.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v4] KVM: arm64: Add early_param to control WFx trapping
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, corbet@lwn.net, maz@kernel.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> Hi Colton,

> On Mon, Apr 22, 2024 at 06:17:16PM +0000, Colton Lewis wrote:
>> @@ -2653,6 +2653,27 @@
>>   			[KVM,ARM] Allow use of GICv4 for direct injection of
>>   			LPIs.

>> +	kvm-arm.wfe_trap_policy=
>> +			[KVM,ARM] Control when to set wfe instruction trap.

> nitpick: when referring to the instruction, please capitalize it.

> Also, it doesn't hurt to be verbose here and say this cmdline option
> "Controls the WFE instruction trap behavior for KVM VMs"

> I say this because there is a separate set of trap controls that allow
> WFE or WFI to execute in EL0 (i.e. host userspace).

Will do.

>> +			trap: set wfe instruction trap
>> +
>> +			notrap: clear wfe instruction trap
>> +
>> +			default: set wfe instruction trap only if multiple
>> +				 tasks are running on the CPU

> I would strongly prefer we not make any default behavior user-visible.
> The default KVM behavior can (and will) change in the future.

> Only the absence of an explicit trap / notrap policy should fall back to
> KVM's default heuristics.

Makes sense to me. Will do.

>> -static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
>> +static inline void vcpu_clear_wfe_trap(struct kvm_vcpu *vcpu)
>>   {
>>   	vcpu->arch.hcr_el2 &= ~HCR_TWE;
>> +}
>> +
>> +static inline void vcpu_clear_wfi_trap(struct kvm_vcpu *vcpu)
>> +{
>>   	if (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
>>   	    vcpu->kvm->arch.vgic.nassgireq)
>>   		vcpu->arch.hcr_el2 &= ~HCR_TWI;
>> @@ -119,12 +123,28 @@ static inline void vcpu_clear_wfx_traps(struct  
>> kvm_vcpu *vcpu)
>>   		vcpu->arch.hcr_el2 |= HCR_TWI;
>>   }

> This helper definitely does not do as it says on the tin. It ignores the
> policy requested on the command line and conditionally *sets* TWI. If
> the operator believes they know best and ask for a particular trap policy
> KVM should uphold it unconditionally. Even if they've managed to shoot
> themselves in the foot.

Will do. I was only splitting up what the existing helper did here.

>> @@ -423,6 +425,12 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)

>>   }

>> +static bool kvm_should_clear_wfx_trap(enum kvm_wfx_trap_policy p)
>> +{
>> +	return (p == KVM_WFX_NOTRAP && kvm_vgic_global_state.has_gicv4)
>> +		|| (p == KVM_WFX_NOTRAP_SINGLE_TASK && single_task_running());
>> +}

> style nitpick: operators should always go on the preceding line for a
> multi-line statement.

Will do.

>>   void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>   {
>>   	struct kvm_s2_mmu *mmu;
>> @@ -456,10 +464,15 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int  
>> cpu)
>>   	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
>>   		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);

>> -	if (single_task_running())
>> -		vcpu_clear_wfx_traps(vcpu);
>> +	if (kvm_should_clear_wfx_trap(kvm_wfi_trap_policy))
>> +		vcpu_clear_wfi_trap(vcpu);
>>   	else
>> -		vcpu_set_wfx_traps(vcpu);
>> +		vcpu_set_wfi_trap(vcpu);
>> +
>> +	if (kvm_should_clear_wfx_trap(kvm_wfe_trap_policy))
>> +		vcpu_clear_wfe_trap(vcpu);
>> +	else
>> +		vcpu_set_wfe_trap(vcpu);

>>   	if (vcpu_has_ptrauth(vcpu))
>>   		vcpu_ptrauth_disable(vcpu);

> I find all of the layering rather hard to follow; we don't need
> accessors for doing simple bit manipulation.

> Rough sketch:

> static bool kvm_vcpu_should_clear_twi(struct kvm_vcpu *vcpu)
> {
> 	if (unlikely(kvm_wfi_trap != KVM_WFX_DEFAULT))
> 		return kvm_wfi_trap == KVM_WFX_NOTRAP;

> 	return single_task_running() &&
> 	       (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
> 	        vcpu->kvm->arch.vgic.nassgireq);
> }

> static bool kvm_vcpu_should_clear_twe(struct kvm_vcpu *vcpu)
> {
> 	if (unlikely(kvm_wfe_trap != KVM_WFX_DEFAULT))
> 		return kvm_wfe_trap == KVM_WFX_NOTRAP;

> 	return single_task_running();
> }

> static void kvm_vcpu_load_compute_hcr(struct kvm_vcpu *vcpu)
> {
> 	vcpu->arch.hcr_el2 |= HCR_TWE | HCR_TWI;

> 	if (kvm_vcpu_should_clear_twe(vcpu))
> 		vcpu->arch.hcr_el2 &= ~HCR_TWE;
> 	if (kvm_vcpu_should_clear_twi(vcpu))
> 		vcpu->arch.hcr_el2 &= ~HCR_TWI;
> }

Will do.

> And if we really wanted to, the non-default trap configuration could be
> moved to vcpu_reset_hcr() if we cared.

Might as well.

