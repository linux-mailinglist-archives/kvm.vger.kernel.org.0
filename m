Return-Path: <kvm+bounces-10317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A48C386BC2F
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 00:27:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEDEE1C22F9D
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 23:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B50177293B;
	Wed, 28 Feb 2024 23:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lu+cD1rS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF8013D317
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 23:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709162854; cv=none; b=MY8w5iclCH3LELwR7z4cdkdDCZIoTJWOylry0nSrc8fx8RTFTBK1qyNekfKrwLU2BII9tgEfzVWg539ej6VerX9BAOlveDugeKnMZtaHIJcq59EvyisrWaeUMNodJkqQ+VC/r0oppOaDOvMtUQb4ABpjLon3iOTiDf5N3tTbNkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709162854; c=relaxed/simple;
	bh=8/y9rMVJc6FKo802Bf8iqSWhmEGQ3RsdEPGMoRIzFZI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KFRYHjwxzGJ8Ioi4wji4C58/BFQ16wdBHVDoMA4JkXEYYZY+0GizwhZTQcSoOMPAW4NFlWFZ5zg8HPea2ldlgh7n+vzXcw+RyyZYPXSQy+aGp1/nBsLILFT49juDudwv4fuOFtcJomunNYEsMS3jRn3ZKOBVYdRqCAo4aATF29s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lu+cD1rS; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e58ad52f50so99490b3a.0
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 15:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709162853; x=1709767653; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=01TmfEs4eoDCMPOPtyVbWEsG5WuK7DAMeVgGLDDBeKQ=;
        b=lu+cD1rSyqW/JW8arfG/icZvYr8R1Vc+5oX1UgKS2TordLHQxtJV9K4A19eicK69jj
         DWIRDW0QWBaERFiVKnom/+Gro+L+uh2Rhqaq8FYVGXdYtA74+43Qm1LwhprB1o/gxKDo
         DsxplVR20LDkgMUMOpRn/ywwdtlInB8jPmYRdo6Myr46jCz48RV4w2ZCWk/GVpvzUdmz
         X8of1ZFsexgYKyS6zOOfH8F/4GrhI1OBo5ty08KaTCbGu4+llAjg/3RJXIjCx6EGZUgP
         BW6i/dt4Y2tBT94tvpyPFHU6+xjtE93JAee1AVg4zViDsEhfIZ1org9G68oIGkcqhwRN
         OMXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709162853; x=1709767653;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=01TmfEs4eoDCMPOPtyVbWEsG5WuK7DAMeVgGLDDBeKQ=;
        b=h8g9o78me8da3+D4vjOLGoi0kAtnsefXfpJo460UPBoLAK4czbQuGvS5/0FbrBZ/r5
         8bXwLJrmTHBMt0DselxTwbnwJvxNhWQhdskie7B/yxMxQkLhSBvpQsJgALWGwnnh0SBz
         zrEIFRKAHA+4z4gik+Ak1r0nZWn3n8CJfGAc18V50cn5gwtWZHPgUA+Niszoilywt95V
         OxRd1qOXpaQSRSzct4PoRHbP9dhc1lE7ckv+6xdaXHrvolyopDMJ/D7CCPdMSnrVWLsu
         dhdGdin2tN1/old/GJ07VaJNoadCq0Ozh722fkBxoKGSiIoW5shL9FgPEJCfRVerbPCA
         UuNA==
X-Gm-Message-State: AOJu0YxIxpCQ/7UYlwHe6kTkorvG0V3n6CuY/fYhKruOvwk5sjWD8a4z
	oEs9P+JAR7elWoZMew0ImOSoQ2CDUAtypqNmNKO4v+Fcf4RzHLYI4B0t+NtZ9kvTjej50OCghw5
	sWA==
X-Google-Smtp-Source: AGHT+IHYyT6j7K3OgI3pVaGDE+oLuuCp65PkcNkK1WEZTU5RIK39yT4H5wc2LVJjthM3kMWR8/Le7z8W6aY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d0d:b0:6e5:3cc2:61d0 with SMTP id
 fa13-20020a056a002d0d00b006e53cc261d0mr51723pfb.2.1709162852671; Wed, 28 Feb
 2024 15:27:32 -0800 (PST)
Date: Wed, 28 Feb 2024 15:27:31 -0800
In-Reply-To: <20240228101837.93642-3-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228101837.93642-1-vkuznets@redhat.com> <20240228101837.93642-3-vkuznets@redhat.com>
Message-ID: <Zd_BY8Us6TYNBueI@google.com>
Subject: Re: [PATCH 2/3] KVM: x86: Use actual kvm_cpuid.base for clearing KVM_FEATURE_PV_UNHALT
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Li RongQing <lirongqing@baidu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 28, 2024, Vitaly Kuznetsov wrote:
> @@ -273,6 +273,7 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>  				       int nent)
>  {
>  	struct kvm_cpuid_entry2 *best;
> +	struct kvm_hypervisor_cpuid kvm_cpuid;
>  
>  	best = cpuid_entry2_find(entries, nent, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
>  	if (best) {
> @@ -299,10 +300,12 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>  		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>  		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>  
> -	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
> -	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> -		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
> -		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
> +	kvm_cpuid = __kvm_get_hypervisor_cpuid(entries, nent, KVM_SIGNATURE);
> +	if (kvm_cpuid.base) {
> +		best = __kvm_find_kvm_cpuid_features(entries, nent, kvm_cpuid.base);
> +		if (kvm_hlt_in_guest(vcpu->kvm) && best)
> +			best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
> +	}
>  
>  	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
>  		best = cpuid_entry2_find(entries, nent, 0x1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);

Not now, as we need a minimal fix, but we need to fix the root problem, this is
way to brittle.  Multiple helpers take @vcpu, including __kvm_update_cpuid_runtime(),
before the incoming CPUID is set.  That's just asking for new bugs to crop up.

Am I missing something, or can we just swap() the new and old, update the new
in the context of the vCPU, and then undo the swap() if there's an issue?
vcpu->mutex is held, and accessing this state from a different task is wildly
unsafe, so I don't see any problem with temporarily having an in-flux state.

If we want to be paranoid, we can probably get away with killing the VM if the
vCPU has run and the incoming CPUID is "bad", e.g. to guard against something
in kvm_set_cpuid() consuming soon-to-be-stale state.  And that's actually a
feature of sorts, because _if_ something in kvm_set_cpuid() consumes the vCPU's
CPUID, then we have a bug _now_ that affects the happy path.

Completely untested (I haven't updated the myriad helpers), but this would allow
us to revert/remove all of the changes that allow peeking at a CPUID array that
lives outside of the vCPU.

static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
                        int nent)
{
	int r, i;

	swap(vcpu->arch.cpuid_entries, e2);
	swap(vcpu->arch.cpuid_nent, nent);

#ifdef CONFIG_KVM_HYPERV
	if (kvm_cpuid_has_hyperv(vcpu)) {
		r = kvm_hv_vcpu_init(vcpu);
		if (r)
			goto err;
	}
#endif

	r = kvm_check_cpuid(vcpu);
	if (r)
		goto err;

	kvm_update_cpuid_runtime(vcpu);

	/*
	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
	 * faults due to reusing SPs/SPTEs. In practice no sane VMM mucks with
	 * the core vCPU model on the fly. It would've been better to forbid any
	 * KVM_SET_CPUID{,2} calls after KVM_RUN altogether but unfortunately
	 * some VMMs (e.g. QEMU) reuse vCPU fds for CPU hotplug/unplug and do
	 * KVM_SET_CPUID{,2} again. To support this legacy behavior, check
	 * whether the supplied CPUID data is equal to what's already set.
	 */
	if (kvm_vcpu_has_run(vcpu)) {
		r = kvm_cpuid_check_equal(vcpu, e2, nent);
		if (r)
			goto err;
	}

	vcpu->arch.kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
#ifdef CONFIG_KVM_XEN
	vcpu->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
#endif
	kvm_vcpu_after_set_cpuid(vcpu);

	kvfree(e2);
	return 0;

err:
	swap(vcpu->arch.cpuid_entries, e2);
	swap(vcpu->arch.cpuid_nent, nent);
	return r;
}

