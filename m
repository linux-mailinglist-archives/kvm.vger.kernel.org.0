Return-Path: <kvm+bounces-10492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21FBE86CA18
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 14:20:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C424A284890
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 13:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4128786257;
	Thu, 29 Feb 2024 13:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oa0GGqSL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE2A7E119
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 13:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709212838; cv=none; b=njsHkedGLMfptWj6UJjHOh/eAA89R7q+V5mRgcG4jRF6neM4yPF4ROiEGa+XmpW17wbF8gQteMh9d0xeL3obf5schWDNpWLGB3/BI0+y59g0pXVQKyJtz61rrRCjsyNOjTjnVJb6xLp6zKHeJ4frM/te38s2f0CPk8cFOhsaLkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709212838; c=relaxed/simple;
	bh=2mDKZoNhqA6KwiIyJMf1WwliOgLL4LslKSfwI69kzRI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=c+RKUJ6EerFh3fptzupAwOiCCiqsv26+LdTpDegX/RAPssZikdDzaeZL5SD8ZcbErOgXMwTLkl7Lzfr8VSCQPMS2U+O02E9lUIO0E38arEUZ7aXLzkAWcmgdgoZiNySEkkX+bXY/IO/rf+a6Tq6aDFOVJRGG7nHPfdARPobBMJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oa0GGqSL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709212835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D8FPvNCThAzMGWf/6aelSKyJOfzZ8ye0pmRD0bMhP8w=;
	b=Oa0GGqSLUrGx7242d7RStPKaqW4W4hKFCaR2W6ijoG0M/S46oWM6k2hZfRmlN3mRRfgYWp
	XFLz2r3geD8vUAP3JmNTpq0dGi16MpVqHFkyv1L7SL09A4fTDPSlFShbctOQXtCZ8KqMPD
	MU/du6/hQvemjBR1Cbd9bB+UFm793vY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-SCHvmY73M0axRijCGM40zA-1; Thu, 29 Feb 2024 08:20:33 -0500
X-MC-Unique: SCHvmY73M0axRijCGM40zA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33d51bb9353so360442f8f.2
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 05:20:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709212832; x=1709817632;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D8FPvNCThAzMGWf/6aelSKyJOfzZ8ye0pmRD0bMhP8w=;
        b=BYkA6weWfQlI3bAUSlbUA1IvIdk69v2NTqok2R4lGTL+VDw2+Hw1apsgH4XdbgdxFB
         UaTatbjkE6cjavtaiauNMD2SHgy3DkwFuGjQdi7DrJhnmckTIGJT/sLQY9aaobG87Lyl
         qhuMoRBzx+5U/TNOr4B0yXM8yPzbfR0uT2EnCBIsOSOjF/Q+v4cVmlI99WODOI8T3OH6
         0ywSTAnQ0epuxRnZDZQZtNv2mixX6CqRjWZbwh3UdyX7u9V4E+jIfaQ7Lp2PLpEK5pzK
         YjWsK+zPJrAqhvyQ9r7TkC9lG2nA+C2zm2WWmb6MhU95iufYf+pMwYz7JrFlUTyEwQNm
         pLxQ==
X-Gm-Message-State: AOJu0YxClALG7kIn8J8OO+kBroV2qZogvGWuCGz7XisNdMKTX+Mauzvj
	84/3mo6XERQ/j+mUuOwxCANQe1DgYFkY54zUjkXh9YAfnQo6B2mNlz4F9pBok/RmYv0VpRG+rY/
	JSv9Eyvm1a4vSgjrguaYvOFXq0NZOHg7eWUQ7ptV7JLXyzORTmwRTxY/DCQ==
X-Received: by 2002:adf:9c8d:0:b0:33e:90f:4f6f with SMTP id d13-20020adf9c8d000000b0033e090f4f6fmr1646313wre.14.1709212832649;
        Thu, 29 Feb 2024 05:20:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEiuVF8842wUv3u08GXziRB44OGXBOBvG0f/dEr/pahBbe2rNRTTSWeFPE8Np93pekFUHFT4A==
X-Received: by 2002:adf:9c8d:0:b0:33e:90f:4f6f with SMTP id d13-20020adf9c8d000000b0033e090f4f6fmr1646293wre.14.1709212832208;
        Thu, 29 Feb 2024 05:20:32 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id g25-20020adfa499000000b0033d6c928a95sm1771693wrb.63.2024.02.29.05.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 05:20:31 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Li RongQing
 <lirongqing@baidu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: x86: Use actual kvm_cpuid.base for clearing
 KVM_FEATURE_PV_UNHALT
In-Reply-To: <Zd_BY8Us6TYNBueI@google.com>
References: <20240228101837.93642-1-vkuznets@redhat.com>
 <20240228101837.93642-3-vkuznets@redhat.com> <Zd_BY8Us6TYNBueI@google.com>
Date: Thu, 29 Feb 2024 14:20:30 +0100
Message-ID: <87h6hrmmox.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Feb 28, 2024, Vitaly Kuznetsov wrote:
>> @@ -273,6 +273,7 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>>  				       int nent)
>>  {
>>  	struct kvm_cpuid_entry2 *best;
>> +	struct kvm_hypervisor_cpuid kvm_cpuid;
>>  
>>  	best = cpuid_entry2_find(entries, nent, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
>>  	if (best) {
>> @@ -299,10 +300,12 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>>  		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>>  		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>>  
>> -	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
>> -	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
>> -		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
>> -		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
>> +	kvm_cpuid = __kvm_get_hypervisor_cpuid(entries, nent, KVM_SIGNATURE);
>> +	if (kvm_cpuid.base) {
>> +		best = __kvm_find_kvm_cpuid_features(entries, nent, kvm_cpuid.base);
>> +		if (kvm_hlt_in_guest(vcpu->kvm) && best)
>> +			best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
>> +	}
>>  
>>  	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
>>  		best = cpuid_entry2_find(entries, nent, 0x1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
>
> Not now, as we need a minimal fix, but we need to fix the root problem, this is
> way to brittle.  Multiple helpers take @vcpu, including __kvm_update_cpuid_runtime(),
> before the incoming CPUID is set.  That's just asking for new bugs to
> crop up.

Yes, I'm all for making this all more robust but I think it would be
nice to have a smaller, backportable fix for the real, observed issue first.

>
> Am I missing something, or can we just swap() the new and old, update the new
> in the context of the vCPU, and then undo the swap() if there's an issue?
> vcpu->mutex is held, and accessing this state from a different task is wildly
> unsafe, so I don't see any problem with temporarily having an in-flux state.
>

I don't see why this approach shouldn't work and I agree it looks like
it would make things better but I can't say that I'm in love with
it. Ideally, I would want to see the following "atomic" workflow for all
updates:

- Check that the supplied data is correct, return an error if not. No
changes to the state on this step.
- Tweak the data if needed.
- Update the state and apply the side-effects of the update. Ideally,
there should be no errors on this step as rollback can be
problemmatic. In the real world we will have to handle e.g. failed
memory allocations here but in most cases the best course of action is
to kill the VM.

Well, kvm_set_cpuid() is not like that. At least:
- kvm_hv_vcpu_init() is a side-effect but we apply it before all checks
are complete. There's no way back.
- kvm_check_cpuid() sounds like a pure checker but in reallity we end up
mangling guest FPU state in fpstate_realloc()

Both are probably "no big deal" but certainly break the atomicity.

> If we want to be paranoid, we can probably get away with killing the VM if the
> vCPU has run and the incoming CPUID is "bad", e.g. to guard against something
> in kvm_set_cpuid() consuming soon-to-be-stale state.  And that's actually a
> feature of sorts, because _if_ something in kvm_set_cpuid() consumes the vCPU's
> CPUID, then we have a bug _now_ that affects the happy path.
>
> Completely untested (I haven't updated the myriad helpers), but this would allow
> us to revert/remove all of the changes that allow peeking at a CPUID array that
> lives outside of the vCPU.

Thanks, assuming there's no urgency, let me take a look at this in the
course of the next week or so.

>
> static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
>                         int nent)
> {
> 	int r, i;
>
> 	swap(vcpu->arch.cpuid_entries, e2);
> 	swap(vcpu->arch.cpuid_nent, nent);
>
> #ifdef CONFIG_KVM_HYPERV
> 	if (kvm_cpuid_has_hyperv(vcpu)) {
> 		r = kvm_hv_vcpu_init(vcpu);
> 		if (r)
> 			goto err;
> 	}
> #endif
>
> 	r = kvm_check_cpuid(vcpu);
> 	if (r)
> 		goto err;
>
> 	kvm_update_cpuid_runtime(vcpu);
>
> 	/*
> 	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
> 	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
> 	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
> 	 * faults due to reusing SPs/SPTEs. In practice no sane VMM mucks with
> 	 * the core vCPU model on the fly. It would've been better to forbid any
> 	 * KVM_SET_CPUID{,2} calls after KVM_RUN altogether but unfortunately
> 	 * some VMMs (e.g. QEMU) reuse vCPU fds for CPU hotplug/unplug and do
> 	 * KVM_SET_CPUID{,2} again. To support this legacy behavior, check
> 	 * whether the supplied CPUID data is equal to what's already set.
> 	 */
> 	if (kvm_vcpu_has_run(vcpu)) {
> 		r = kvm_cpuid_check_equal(vcpu, e2, nent);
> 		if (r)
> 			goto err;
> 	}
>
> 	vcpu->arch.kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
> #ifdef CONFIG_KVM_XEN
> 	vcpu->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
> #endif
> 	kvm_vcpu_after_set_cpuid(vcpu);
>
> 	kvfree(e2);
> 	return 0;
>
> err:
> 	swap(vcpu->arch.cpuid_entries, e2);
> 	swap(vcpu->arch.cpuid_nent, nent);
> 	return r;
> }
>

-- 
Vitaly


