Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28657A0EF1
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 22:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjINU2h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 16:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjINU2g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 16:28:36 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4692700
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 13:28:32 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-56c556b5aceso1173261a12.1
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 13:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694723312; x=1695328112; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nzJvstdCVNLuwr9+zSVIDyjCzM8g0GZ73rr7XEH2PE0=;
        b=VM5gsZe/AgVse75tZYcyCKOyRqXe9vZ5DPrqFkVSglfXiscr1hxp93GyX99Kgi+JTS
         7V8UdmOrHrZdtgUMOkItvaGUqeuSQsZPV49z5U4UQ3OZnQi/QeNp5anv2ebFd7zlUtAY
         eF94rc+l4cRHjGkWQyxaTKtOK5BoaDuOkOGwN1jcxFguCcPhrqOa1J9zaunV1hreJX7+
         6O4abtxrL+Ms6E3o6U+Mq6tsQsVePvpRDlSRmySTauwAczqRYORzqoZFdnrtGofJ09k6
         PAIdN/Fnhd3QhAl9G3A1BUE+KgDdsXB4ooR33utIsBCiG4QB+rtdLHc2tlhw26ZUooQ+
         CPJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694723312; x=1695328112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nzJvstdCVNLuwr9+zSVIDyjCzM8g0GZ73rr7XEH2PE0=;
        b=ZBuonMbAWFgUWcBsrIs0MWJWBobXsXsFxqnJRGnq+VfzyZajeBnWkp0buUZCDWEfpU
         hAf7H0S4QcvZd9fsKWljKRMZJawPDx1F9GMIw/0mlsiRojfI6jOTJjOjsAex7ztcANTI
         Ny6hF25h2AwOzkKZLBWHH3pm7evIedLkIenRHHaNM9BTS6P/nDmLs945vtqdaXzjdSAf
         hroZPh4DRui/E+aY5LqM7cy4ysHOfVrVHVj3OowP67rzkcjgAV7nytMY9oEn00ftRfJA
         TyLm4nYszxerBHKzO3rkKZWBX/ONiNwKmP2tlhpDWyCHwb/XOcUKL58xawHAFf7MdoAC
         hikw==
X-Gm-Message-State: AOJu0YyN1ECtZRlCBnuC+vEn+BrRBHAiF0568Zzn7x25ImZeOWOK6T/S
        AdStN19167m7czTvD+VEfA0GdzckQu0=
X-Google-Smtp-Source: AGHT+IFCmNWCdoQYSXPoJjA3buhXhkVNpWdxwRvg7GxXKJMBpOx11hjkfaPx69BGHLo24zE4QfsBBmjyGNI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:77c6:0:b0:563:962e:e912 with SMTP id
 s189-20020a6377c6000000b00563962ee912mr162430pgc.0.1694723312190; Thu, 14 Sep
 2023 13:28:32 -0700 (PDT)
Date:   Thu, 14 Sep 2023 13:28:30 -0700
In-Reply-To: <8a5c1d2637475c7fb9657cdd6cb0e86f2bb3bab6.1694721045.git.thomas.lendacky@amd.com>
Mime-Version: 1.0
References: <cover.1694721045.git.thomas.lendacky@amd.com> <8a5c1d2637475c7fb9657cdd6cb0e86f2bb3bab6.1694721045.git.thomas.lendacky@amd.com>
Message-ID: <ZQNs7uo8F62XQawJ@google.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Fix TSC_AUX virtualization setup
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Babu Moger <babu.moger@amd.com>
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 14, 2023, Tom Lendacky wrote:
> The checks for virtualizing TSC_AUX occur during the vCPU reset processing
> path. However, at the time of initial vCPU reset processing, when the vCPU
> is first created, not all of the guest CPUID information has been set. In
> this case the RDTSCP and RDPID feature support for the guest is not in
> place and so TSC_AUX virtualization is not established.
> 
> This continues for each vCPU created for the guest. On the first boot of
> an AP, vCPU reset processing is executed as a result of an APIC INIT
> event, this time with all of the guest CPUID information set, resulting
> in TSC_AUX virtualization being enabled, but only for the APs. The BSP
> always sees a TSC_AUX value of 0 which probably went unnoticed because,
> at least for Linux, the BSP TSC_AUX value is 0.
> 
> Move the TSC_AUX virtualization enablement into the vcpu_after_set_cpuid()
> path to allow for proper initialization of the support after the guest
> CPUID information has been set.
> 
> Fixes: 296d5a17e793 ("KVM: SEV-ES: Use V_TSC_AUX if available instead of RDTSC/MSR_TSC_AUX intercepts")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 27 +++++++++++++++++++--------
>  arch/x86/kvm/svm/svm.c |  3 +++
>  arch/x86/kvm/svm/svm.h |  1 +
>  3 files changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b9a0a939d59f..565c9de87c6d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2962,6 +2962,25 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
>  				    count, in);
>  }
>  
> +static void sev_es_init_vmcb_after_set_cpuid(struct vcpu_svm *svm)

I would rather name this sev_es_after_set_cpuid() and call it directly from
svm_vcpu_after_set_cpuid().  Or I suppose bounce through sev_after_set_cpuid(),
but that seems gratuitous.

AFAICT, there's no point in calling this from init_vmcb(); guest_cpuid_has() is
guaranteed to be false when called during vCPU creation and so the intercept
behavior will be correct, and even if SEV-ES called init_vmcb() from
shutdown_interception(), which it doesn't, guest_cpuid_has() wouldn't change,
i.e. the intercepts wouldn't need to be changed.

init_vmcb_after_set_cpuid() is a special snowflake because it handles both SVM's
true defaults *and* guest CPUID updates.

> +{
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +
> +	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) &&
> +	    (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
> +	     guest_cpuid_has(vcpu, X86_FEATURE_RDPID))) {
> +		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, 1, 1);

This needs to toggled interception back on if RDTSCP and RDPID are hidden from
the guest.  KVM's wonderful ABI doesn't disallow multiple calls to KVM_SET_CPUID2
before KVM_RUN.

> +		if (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> +			svm_clr_intercept(svm, INTERCEPT_RDTSCP);

Same thing here.

> +	}
> +}
