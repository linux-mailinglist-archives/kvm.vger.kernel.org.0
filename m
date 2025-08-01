Return-Path: <kvm+bounces-53820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A5BB3B17AA5
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 02:47:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F31C81C2647D
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 00:47:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C3253596D;
	Fri,  1 Aug 2025 00:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qRKo60MQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030C42E370E
	for <kvm@vger.kernel.org>; Fri,  1 Aug 2025 00:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754009244; cv=none; b=g2+iZsL+i++mobZ/Yyx+YL/I1hGh3H/LLQjOtgsFUICvjZCHfGPE5i8oWrBh+2ca3sFFxuFk+eo+P3Ck5tXz5oDHd3+YfOWzVs7tcc/2FZPLyfdqQF/WoQxuK4LfA8Nh5QXZC8RtbI2v8SjYEEP8obghZLbMiALoOPD5LKC7qEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754009244; c=relaxed/simple;
	bh=gR5Al1D4+reUnTE7Wgb+7b9ojBWrqnfN4+NskzNJwcI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kcl1otyuuz92hS4LHEEXqvfpcVX3pSUTIMq1xCmSEqDp69o4E5DeDC1QWN1J9Dx6FXrCA2Bz+VFYC6fJZgf74kG6kVhxSO6Ti+2rmzjhdc2fIljjEQzyVt/+3Zdx9/jbF/4MkOr/pDbzaD0H7R+MYpSAYCiGLP1ii2cAdpx1nBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qRKo60MQ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3132c1942a1so512815a91.2
        for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 17:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754009242; x=1754614042; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hRXNszbxlUTyYnGSQYO+PKslDvhns5dMJJ1svuzzpJM=;
        b=qRKo60MQIHwcbKWWwNc9DpzS1++nsKIJald+RTSmN4G3ExQTAHt/u5oAtFbnVGdJ8D
         KPbbU0TcAULsT1WSrjZIrTsdoNBFUKAxTrm/5mydd/3yuOSIcMRmqMYpts+t5mS8FBvr
         L3IPc4c7/510dzzd1O+2Fl4F90Sroz5T4kNKQUBzP3LRkphkcFAPHBbZa3bZgNxuigab
         RKSNH4OmAI0H3PYCT/npB4FWKpC13QZv0S+RQ7kCflHad/AMQnoymJ5WfMneogUWQvws
         NVfhpkrr92M9DNDJ/aMmfsRKGeAaVS3cZb16U8IVjDZ1V8JzZr7L2v8a69JtRAFSqEAY
         8brQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754009242; x=1754614042;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hRXNszbxlUTyYnGSQYO+PKslDvhns5dMJJ1svuzzpJM=;
        b=fLLele2KAiLNCbjJggXs3vdzIKadkB4eSVPkbsRahSPV+lYTjTITEW5fg8ngIJ4qYC
         9HgiPnw4s2pPjnCiWtLu6CQ9nfitYwWnShcPDSQywuxsqKFGFANaRQ6pTp1Vhb+95jP7
         E+c0nj0a5CodeveZ+S5QeFWJtyijFLhWO31JKeIuzdQos8HwBTWhvw3rSI3upH7ulnZu
         C20LuULeEftOi1i8ystpgActZtVYAvN0czHe8bDtnYGPr6ZBCeCc1TZztwd9AGmFuURv
         ++oJVhFbaNw9kolJ0nfv7nH6Tq4oHkzjNShGM/hQaIwdb8WhLoWoseFlsrQnjRU2ibUf
         auGg==
X-Forwarded-Encrypted: i=1; AJvYcCX2qPjcqkcKIxDNCo6V9ksznUe7VW/+vUWddPEn87npHib4NbiNHTJIBYbtNtpMOk/CU6c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxd+AitnLsiWbNhaapASAzLuHEwnamu9rzSXodbI9FxZ63koqix
	sIjpBp8AFRNozEEF7O7VaPF7ydpDXDU2WknTJUIn2tTRGG32r3yPqchRSPYVgDBgyBjWMood0wP
	yTqQojw==
X-Google-Smtp-Source: AGHT+IHab78F9llFKocoU6Zco0XzsmHDLGvQFwwdKJOwxALK9bUIf6goRjRbc/mZgc6P3+1lXC9qojGXeOI=
X-Received: from pjbpd2.prod.google.com ([2002:a17:90b:1dc2:b0:312:187d:382d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d0a:b0:31f:42e8:a896
 with SMTP id 98e67ed59e1d1-31f5ea4ca0bmr11613681a91.34.1754009242279; Thu, 31
 Jul 2025 17:47:22 -0700 (PDT)
Date: Thu, 31 Jul 2025 17:47:20 -0700
In-Reply-To: <7af6dcf5-fbcd-4173-a588-38cf6c536282@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250730174605.1614792-1-xin@zytor.com> <20250730174605.1614792-3-xin@zytor.com>
 <aItGzjhpfzIbG+Op@intel.com> <7af6dcf5-fbcd-4173-a588-38cf6c536282@zytor.com>
Message-ID: <aIwOmEzLgkP-9ZDE@google.com>
Subject: Re: [PATCH v1 2/4] KVM: x86: Introduce MSR read/write emulation helpers
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: Chao Gao <chao.gao@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 31, 2025, Xin Li wrote:
> On 7/31/2025 3:34 AM, Chao Gao wrote:
> > > -fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
> > > +static fastpath_t handle_set_msr_irqoff(struct kvm_vcpu *vcpu, u32 msr, int reg)
> > 
> > How about __handle_fastpath_set_msr_irqoff()? It's better to keep
> > "fastpath" in the function name to convey that this function is for
> > fastpath only.
> 
> This is now a static function with return type fastpath_t, so I guess
> it's okay to remove fastpath from its name (It looks that Sean prefers
> shorter function names if they contains enough information).
> 
> But if the protocol is to have "fastpath" in all fast path function
> names, I can change it.

I'm also greedy and want it both ways :-)

Spoiler alert, this is what I ended up with (completely untested at this point):

static fastpath_t __handle_fastpath_wrmsr(struct kvm_vcpu *vcpu, u32 msr,
					  u64 data)

	switch (msr) {
	case APIC_BASE_MSR + (APIC_ICR >> 4):
		if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(vcpu->arch.apic) ||
		    kvm_x2apic_icr_write_fast(vcpu->arch.apic, data))
			return EXIT_FASTPATH_NONE;
		break;
	case MSR_IA32_TSC_DEADLINE:
		if (!kvm_can_use_hv_timer(vcpu))
			return EXIT_FASTPATH_NONE;

		kvm_set_lapic_tscdeadline_msr(vcpu, data);
		break;
	default:
		return EXIT_FASTPATH_NONE;
	}

	trace_kvm_msr_write(msr, data);

	if (!kvm_skip_emulated_instruction(vcpu))
		return EXIT_FASTPATH_EXIT_USERSPACE;

	return EXIT_FASTPATH_REENTER_GUEST;
}

fastpath_t handle_fastpath_wrmsr(struct kvm_vcpu *vcpu)
{
	return __handle_fastpath_wrmsr(vcpu, kvm_rcx_read(vcpu),
				       kvm_read_edx_eax(vcpu));
}
EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_irqoff);

fastpath_t handle_fastpath_wrmsr_imm(struct kvm_vcpu *vcpu, u32 msr, int reg)
{
	return __handle_fastpath_wrmsr(vcpu, msr, kvm_register_read(vcpu, reg));
}
EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_imm_irqoff);


> > > {
> > > -	u32 msr = kvm_rcx_read(vcpu);
> > > 	u64 data;
> > > 	fastpath_t ret;
> > > 	bool handled;
> > > @@ -2174,11 +2190,19 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
> > > 
> > > 	switch (msr) {
> > > 	case APIC_BASE_MSR + (APIC_ICR >> 4):
> > > -		data = kvm_read_edx_eax(vcpu);
> > > +		if (reg == VCPU_EXREG_EDX_EAX)
> > > +			data = kvm_read_edx_eax(vcpu);
> > > +		else
> > > +			data = kvm_register_read(vcpu, reg);
> > 
> > ...
> > 
> > > +
> > > 		handled = !handle_fastpath_set_x2apic_icr_irqoff(vcpu, data);
> > > 		break;
> > > 	case MSR_IA32_TSC_DEADLINE:
> > > -		data = kvm_read_edx_eax(vcpu);
> > > +		if (reg == VCPU_EXREG_EDX_EAX)
> > > +			data = kvm_read_edx_eax(vcpu);
> > > +		else
> > > +			data = kvm_register_read(vcpu, reg);
> > > +
> > 
> > Hoist this chunk out of the switch clause to avoid duplication.
> 
> I thought about it, but didn't do so because the original code doesn't read
> the MSR data from registers when a MSR is not being handled in the
> fast path, which saves some cycles in most cases.

Can you hold off on doing anything with this series?  Mostly to save your time.

Long story short, I unexpectedly dove into the fastpath code this week while sorting
out an issue with the mediated PMU series, and I ended up with a series of patches
to clean things up for both the mediated PMU series and for this series.

With luck, I'll get the cleanups, the mediated PMU series, and a v2 of this series
posted tomorrow (I also have some feedback on VCPU_EXREG_EDX_EAX; we can avoid it
entirely without much fuss).


