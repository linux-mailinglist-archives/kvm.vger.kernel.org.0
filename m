Return-Path: <kvm+bounces-24437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B99709551A8
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 21:54:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF7941C21DC2
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 19:54:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8FDD1C460F;
	Fri, 16 Aug 2024 19:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m4h0pkfT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904001C3787
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 19:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723838064; cv=none; b=fNUB9odyvr06V4S1wV1HCskvahhFhuSO9Z4whIs6ReWl2rWisstxXmmupjfKttqn6lUvtDi5aYHmBWE5oIL/DUQ6u65AgR4RCpW9VhJCcc0wxAt+v9nrhjUcoKLCoZROcS7H195zVsH3svJiRKbt0dPPGzsm5PMeL6c3PT7UbBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723838064; c=relaxed/simple;
	bh=MC11rIHxRP65wlhTEEOiWv/hqOPLAQagFiEuecxcXj8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nyhDCC9zNe+AP/onELQpMaBvyFSZO65FwOGEBH+SoxABUVNJIA83o1ncr6ZCgQv5fZoFcVYrWOcozOZ0yTJ+bQfNxSPj7iAghyoZDKDPiAcL9k+nlVr+I0Y3+7I8MXhkNN9YXJFyA5X70/QaV1Vu9Ux7ZNJa9+eAA10YySD8JWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m4h0pkfT; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc5b60f416so21016925ad.3
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 12:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723838062; x=1724442862; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pQ7oSln0jdOMw2qgunQeCEhEVpfgXzjd8HECSK+kraU=;
        b=m4h0pkfT3JyCpx2LNULWrQd8Q6F7kXioRORHWrL+6uO9tRo4ncBsJGHMqLDcFmNfOH
         P/uCBsH88X6i6GYZyHTCttssYfoeaO9svXEvRj8zPQM5ZTqVMKFsF5HrvjI65AFN3aBB
         FLWk0n8e7fPlkLbM26IUKAw8j0VbRtqQTZKBQ2HE7gpHIAWVZ9LZ4fYwFO/wMarndBkt
         9mybvcXVwPHHAeELUfhgJ4U86mPfdPAtBk9gwWhh5j/X2Xn4yU0QolW/oNeGXkBX9XaQ
         f+s/zwUvBkIuZGB3OnaOC9xJ1oiLoJsDyXyNzhfOleXxZ1kcLB53rPMDCLz7iZlBwvJh
         1Pyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723838062; x=1724442862;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pQ7oSln0jdOMw2qgunQeCEhEVpfgXzjd8HECSK+kraU=;
        b=MSw5Q495abE5enQAWZ2KykU6dp9nihgOyysx9hnkVdeNOU6AgNAjjVCWKTNj+4UeHv
         Rg6Dn3Kt6fygIB+ZMgeMuJKzNlDyNQHhK5tsUcV34FzSqs2YjSoXhremVQBQTsYE0c7o
         7PnEh5sqR3oJqsBkjUhDEuTeA29l84CdvYgkiYsztpVwL3rJofR8a03zON1fq8NEKo9p
         ZsqraKqWbm+w1MIoptbnv4wdzv4J6wF6AfltG+/jMQZqtDeV4szqjnZrVz8MHBaIlc2Q
         qUdwxlOA0+vBF5X6QQCnCnuf0LvuS5SK4SdyXhNBfJYeBLutU2VuYMXtUs8peajwMb0/
         OCjg==
X-Gm-Message-State: AOJu0Yxw24FXLj1c1k7wTwqh7aIh90I1n1WAMdkbNuQuU71xgdkwuatB
	oqhI0nMoEfB8YyZbPlidQs1kbu9QnvaY54on24T3jcuN+86EhYoaooZoHF0HfvAzTcBrz/GOUYy
	ntQ==
X-Google-Smtp-Source: AGHT+IHdpyTikhzLRFze4pXFcqlBvhdYWxa2V88RGh/oScmbcsxfoQHuHbXuYrSVY5GPya+1asntbczke9c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:da81:b0:1fa:fc15:c50d with SMTP id
 d9443c01a7336-20203f25a63mr1890325ad.11.1723838061618; Fri, 16 Aug 2024
 12:54:21 -0700 (PDT)
Date: Fri, 16 Aug 2024 12:54:20 -0700
In-Reply-To: <20240709175145.9986-3-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240709175145.9986-1-manali.shukla@amd.com> <20240709175145.9986-3-manali.shukla@amd.com>
Message-ID: <Zr-ubK_e4lAxyt_7@google.com>
Subject: Re: [RFC PATCH v1 2/4] KVM: SVM: Enable Bus lock threshold exit
From: Sean Christopherson <seanjc@google.com>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, pbonzini@redhat.com, 
	shuah@kernel.org, nikunj@amd.com, thomas.lendacky@amd.com, 
	vkuznets@redhat.com, bp@alien8.de, babu.moger@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 09, 2024, Manali Shukla wrote:
> From: Nikunj A Dadhania <nikunj@amd.com>
> 
> Malicious guests can cause bus locks to degrade the performance of
> system. Non-WB(write-back) and misaligned locked RMW(read-modify-write)
> instructions are referred to as "bus locks" and require system wide
> synchronization among all processors to guarantee atomicity.  Bus locks
> may incur significant performance penalties for all processors in the
> system.

Copy+pasting the background into every changelog isn't helpful.  Instead, focus
on what the feature actually does, and simply mention what bus locks are in
passing.  If someone really doesn't know, it shouldn't be had for them to find
the previous changelog.

> The Bus Lock Threshold feature proves beneficial for hypervisors seeking
> to restrict guests' ability to initiate numerous bus locks, thereby
> preventing system slowdowns that affect all tenants.
> 
> Support for the buslock threshold is indicated via CPUID function
> 0x8000000A_EDX[29].
> 
> VMCB intercept bit
> VMCB Offset	Bits	Function
> 14h	        5	Intercept bus lock operations
>                         (occurs after guest instruction finishes)
> 
> Bus lock threshold
> VMCB Offset	Bits	Function
> 120h	        15:0	Bus lock counter

I can make a pretty educated guess as to how this works, but this is a pretty
simple feature, i.e. there's no reason not to document how it works in the
changelog.
 
> Use the KVM capability KVM_CAP_X86_BUS_LOCK_EXIT to enable the feature.
> 
> When the bus lock threshold counter reaches to zero, KVM will exit to
> user space by setting KVM_RUN_BUS_LOCK in vcpu->run->flags in
> bus_lock_exit handler, indicating that a bus lock has been detected in
> the guest.
> 
> More details about the Bus Lock Threshold feature can be found in AMD
> APM [1].
> 
> [1]: AMD64 Architecture Programmer's Manual Pub. 24593, April 2024,
>      Vol 2, 15.14.5 Bus Lock Threshold.
>      https://bugzilla.kernel.org/attachment.cgi?id=306250
> 
> [Manali:
>   - Added exit reason string for SVM_EXIT_BUS_LOCK.
>   - Moved enablement and disablement of bus lock intercept support.
>     to svm_vcpu_after_set_cpuid().
>   - Massage commit message.
>   - misc cleanups.
> ]

No need for this since you are listed as co-author.

> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Co-developed-by: Manali Shukla <manali.shukla@amd.com>
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7d396f5fa010..9f1d51384eac 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -191,6 +191,9 @@ module_param(pause_filter_count_shrink, ushort, 0444);
>  static unsigned short pause_filter_count_max = KVM_SVM_DEFAULT_PLE_WINDOW_MAX;
>  module_param(pause_filter_count_max, ushort, 0444);
>  
> +static unsigned short bus_lock_counter = KVM_SVM_DEFAULT_BUS_LOCK_COUNTER;
> +module_param(bus_lock_counter, ushort, 0644);

This should be read-only, otherwise the behavior is non-deterministic, e.g. as
proposed, awon't take effect until a vCPU happens to trigger a bus lock exit.

If we really want it to be writable, then a per-VM capability is likely a better
solution.

Actually, we already have a capability, which means there's zero reason for this
module param to exist.  Userspace already has to opt-in to turning on bus lock
detection, i.e. userspace already has the opportunity to provide a different
threshold.

That said, unless someone specifically needs a threshold other than '0', I vote
to keep the uAPI as-is and simply exit on every bus lock.
 
>  /*
>   * Use nested page tables by default.  Note, NPT may get forced off by
>   * svm_hardware_setup() if it's unsupported by hardware or the host kernel.
> @@ -3231,6 +3234,19 @@ static int invpcid_interception(struct kvm_vcpu *vcpu)
>  	return kvm_handle_invpcid(vcpu, type, gva);
>  }
>  
> +static int bus_lock_exit(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
> +	vcpu->run->flags |= KVM_RUN_X86_BUS_LOCK;
> +
> +	/* Reload the counter again */
> +	svm->vmcb->control.bus_lock_counter = bus_lock_counter;
> +
> +	return 0;
> +}
> +
>  static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[SVM_EXIT_READ_CR0]			= cr_interception,
>  	[SVM_EXIT_READ_CR3]			= cr_interception,
> @@ -3298,6 +3314,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[SVM_EXIT_CR4_WRITE_TRAP]		= cr_trap,
>  	[SVM_EXIT_CR8_WRITE_TRAP]		= cr_trap,
>  	[SVM_EXIT_INVPCID]                      = invpcid_interception,
> +	[SVM_EXIT_BUS_LOCK]			= bus_lock_exit,
>  	[SVM_EXIT_NPF]				= npf_interception,
>  	[SVM_EXIT_RSM]                          = rsm_interception,
>  	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
> @@ -4356,6 +4373,27 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)

Why on earth is this in svm_vcpu_after_set_cpuid()?  This has nothing to do with
guest CPUID.

>  		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_FLUSH_CMD, 0,
>  				     !!guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D));
>  
> +	if (cpu_feature_enabled(X86_FEATURE_BUS_LOCK_THRESHOLD) &&

This should be a slow path, there's zero reason to check for host support as
bus_lock_detection_enabled should be allowed if and only if it's supported.

> +	    vcpu->kvm->arch.bus_lock_detection_enabled) {
> +		svm_set_intercept(svm, INTERCEPT_BUSLOCK);
> +
> +		/*
> +		 * The CPU decrements the bus lock counter every time a bus lock
> +		 * is detected. Once the counter reaches zero a VMEXIT_BUSLOCK
> +		 * is generated. A value of zero for bus lock counter means a
> +		 * VMEXIT_BUSLOCK at every bus lock detection.
> +		 *
> +		 * Currently, default value for bus_lock_counter is set to 10.

Please don't document the default _here_.  Because inevitably this will become
stale when the default changes.

> +		 * So, the VMEXIT_BUSLOCK is generated after every 10 bus locks
> +		 * detected.
> +		 */
> +		svm->vmcb->control.bus_lock_counter = bus_lock_counter;
> +		pr_debug("Setting buslock counter to %u\n", bus_lock_counter);
> +	} else {
> +		svm_clr_intercept(svm, INTERCEPT_BUSLOCK);
> +		svm->vmcb->control.bus_lock_counter = 0;
> +	}
> +
>  	if (sev_guest(vcpu->kvm))
>  		sev_vcpu_after_set_cpuid(svm);
>  
> @@ -5149,6 +5187,11 @@ static __init void svm_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
>  	}
>  
> +	if (cpu_feature_enabled(X86_FEATURE_BUS_LOCK_THRESHOLD)) {
> +		pr_info("Bus Lock Threashold supported\n");
> +		kvm_caps.has_bus_lock_exit = true;
> +	}
> +
>  	/* CPUID 0x80000008 */
>  	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
>  	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index d80a4c6b5a38..2a77232105da 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -58,6 +58,7 @@ void kvm_spurious_fault(void);
>  #define KVM_VMX_DEFAULT_PLE_WINDOW_MAX	UINT_MAX
>  #define KVM_SVM_DEFAULT_PLE_WINDOW_MAX	USHRT_MAX
>  #define KVM_SVM_DEFAULT_PLE_WINDOW	3000
> +#define KVM_SVM_DEFAULT_BUS_LOCK_COUNTER	10

There's zero reason this needs to be in x86.h.  I don't even see a reason to
have a #define, there's literally one user.

