Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182E54465C1
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 16:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbhKEPdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 11:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbhKEPdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 11:33:06 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02DAC061205
        for <kvm@vger.kernel.org>; Fri,  5 Nov 2021 08:30:26 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id t11so11244645plq.11
        for <kvm@vger.kernel.org>; Fri, 05 Nov 2021 08:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2nsbfWUBXQEl1i8aLsjK652VPTDd+dYABfknXwLaoPY=;
        b=rj6ZIxCsiZekHlz4ExnTV6eWkMludpSvjlgA1Cj4SSM0SLZQc5PFpuRcFNQhjJrXzT
         Gh62G+Iv/aQw4uXrNxl0fT5NVKC16zPLFJGZ/o1ID7e+a7MN7RqQEkMXB7XDwn0sE3RJ
         dOdLlaZk5v0q0Bw1PPNcFDIqPWZpkCNEIjgKLut3uh50SCYjqIuDLmQdo8S756AtWSYA
         Gb5eD2kWa2xlOHeWdqMt23wCRJjtrVPPybbm5ynOfekh/79cfM8oFUasSxMy9UR+zPZL
         Su2ojng+T7LEBGxcPqrB+zKTa7QfdT6RwvBpJb0tPQxijNeGsQbCDw5Wag8bfvncHk0f
         XShw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2nsbfWUBXQEl1i8aLsjK652VPTDd+dYABfknXwLaoPY=;
        b=0ewFFCHNI/c2n2MxZHCAbvYvbJfrbk4XUdOlYOqi4chSljky8w4kKNuCM6B5qkTIVA
         qDifBbJEuMOWwqBU8lnfgIa/EPTxQwsgo0KXuX/J4M2t6B6poJBqjDFMwEE5u042yft5
         3V9f8ZakMK3lr18lNiD8qi43929mEgvpuSSC01CznGSKZUIg+U182l/0pL2AgI0WDxvO
         tnVN1MPpJihPEvgme5nFWyeMEl3zjqI7o5zDvJmpYovlREeGPCH/aTnEu2kdViTwrsZk
         9zj38u5f4SKnjsjlIo0BMzECaTaRGpRCUxySbfCh/uCrCn8PPrTHAYf3YNKmGCyzuQSb
         el1w==
X-Gm-Message-State: AOAM530G5y+zecy/zqVzEgbhXV+R/nzvB1c3VJOPh9eopzouh11TAY+e
        q0mBO8sCWDxUs7h5cIqjMDYoIA==
X-Google-Smtp-Source: ABdhPJwbB5QgmG1ZYEIzH3vqvqjDxzDKMNB5fwPXAEJ4neorNMHtzNpwiKp7j1+6vR0jrZgbhCpV4A==
X-Received: by 2002:a17:90a:fec:: with SMTP id 99mr31361569pjz.193.1636126225912;
        Fri, 05 Nov 2021 08:30:25 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m4sm9788773pjl.11.2021.11.05.08.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 08:30:25 -0700 (PDT)
Date:   Fri, 5 Nov 2021 15:30:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: x86: Copy kvm_pmu_ops by value to eliminate
 layer of indirection
Message-ID: <YYVODdVEc/deNP8p@google.com>
References: <20211103070310.43380-1-likexu@tencent.com>
 <20211103070310.43380-2-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103070310.43380-2-likexu@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 03, 2021, Like Xu wrote:
> Replace the kvm_pmu_ops pointer in common x86 with an instance of the
> struct to save one pointer dereference when invoking functions. Copy the
> struct by value to set the ops during kvm_init().
> 
> Using kvm_x86_ops.hardware_enable to track whether or not the
> ops have been initialized, i.e. a vendor KVM module has been loaded.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/pmu.c        | 41 +++++++++++++++++++++------------------
>  arch/x86/kvm/pmu.h        |  4 +++-
>  arch/x86/kvm/vmx/nested.c |  2 +-
>  arch/x86/kvm/x86.c        |  3 +++
>  4 files changed, 29 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 0772bad9165c..0db1887137d9 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -47,6 +47,9 @@
>   *        * AMD:   [0 .. AMD64_NUM_COUNTERS-1] <=> gp counters
>   */
>  
> +struct kvm_pmu_ops kvm_pmu_ops __read_mostly;
> +EXPORT_SYMBOL_GPL(kvm_pmu_ops);
> +

...

> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b4ee5e9f9e20..1e793e44b5ff 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4796,7 +4796,7 @@ void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
>  		return;
>  
>  	vmx = to_vmx(vcpu);
> -	if (kvm_x86_ops.pmu_ops->is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
> +	if (kvm_pmu_ops.is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {

I would much prefer we export kvm_pmu_is_valid_msr() and go through that for nVMX
than export all of kvm_pmu_ops for this one case.

>  		vmx->nested.msrs.entry_ctls_high |=
>  				VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
>  		vmx->nested.msrs.exit_ctls_high |=
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ac83d873d65b..72d286595012 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11317,6 +11317,9 @@ int kvm_arch_hardware_setup(void *opaque)
>  	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
>  	kvm_ops_static_call_update();
>  
> +	if (kvm_x86_ops.hardware_enable)

Huh?  Did you intend this to be?

	if (kvm_x86_ops.pmu_ops)

Either way, I don't see the point, VMX and SVM unconditionally provide the ops.

I would also say land this memcpy() above kvm_ops_static_call_update(), then the
enabling patch can do the static call updates in kvm_ops_static_call_update()
instead of adding another helper.

> +		memcpy(&kvm_pmu_ops, kvm_x86_ops.pmu_ops, sizeof(kvm_pmu_ops));

As part of this change, the pmu_ops should be moved to kvm_x86_init_ops and tagged
as __initdata.  That'll save those precious few bytes, and more importantly make
the original ops unreachable, i.e. make it harder to sneak in post-init modification
bugs.

> +
>  	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>  		supported_xss = 0;
>  
> -- 
> 2.33.0
> 
