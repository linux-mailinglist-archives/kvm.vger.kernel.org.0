Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65D1365BF1
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 17:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhDTPPy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 11:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbhDTPPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 11:15:51 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74087C06138B
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 08:15:19 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id h11so8119834pfn.0
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 08:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bNKIqnXkyL+JfbeWwfxjgd5azutsQnp8ujJlCwSaCHo=;
        b=H9F+EblcGz+9H76S+arhhkkcMnKceI8+aSVxwg7QtiFwoOx0JMb/gxbE7dSgQWsq9j
         mUjdwunF1mIqshiNP6mQW5YwNXxvRrBMysX/Db+li1z6i3OAchDKY5EkdgX5NXzyEg/0
         LOobFv0GGDgOHtUUWtRiNqxgfBydecLWb7g/X7XtR5Wm+CmZeqkP9iEci1GkfKV/QNlk
         riXNd4yg1EbNcIb8RTuWp3vPjk2Y64p88jThd7KMJYW7px4Ypisa+cVq44Vi4EWVux3/
         P9n77R+Tli6AnASbT/lPkdydy8ZbOtOQIBvgipZnmD1QQdxezvKZX29Gm0dR5o2rSu3c
         qcpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bNKIqnXkyL+JfbeWwfxjgd5azutsQnp8ujJlCwSaCHo=;
        b=cw6drieFZ0/j0pvn7KboGg4FcTt7SkJJPAY06aG5P9XlXxduK85vKF42bzUNroPQVY
         vmJuf8k43CJF1vHEf1begEk0mGrww+UCSrXKhbS/L5Dp2olktGW13c/x6Y1hu/Rp9cod
         ni4f9GQpxzMvVvCVJkbvPtF2pwpRhUtCub97Y1ZtfEvQvnoh98AqXEX4yVKW0lHtjh0H
         OBIeCazWVNdLWC2Xd2oX8v2jK6guBi1s6hz9iegb76fj2QYSNstkYxcPlXpxW00W2wq+
         cUp+w0n/LwrwwG1kLJrynDLvxcfL0jx76hnaV9Ixa+lLQX1CsRP183lv/ZMKDuAGfF+Q
         UJ9Q==
X-Gm-Message-State: AOAM533mwo0gLJxKsNvQJG/vIIvfgdazjmTcy92qNW2JpAs5HUKNgPCU
        N2CLtuWBLci9Ebzl6F6o6QByi5OecVgudg==
X-Google-Smtp-Source: ABdhPJyPheSzXmcXK6A30hh4eYXQ1mTgRGNBXHytx9xlHLYb4BHlhPSq6Fd2Es52Wj5pAJ+xIy2axw==
X-Received: by 2002:a63:789:: with SMTP id 131mr1392167pgh.297.1618931718810;
        Tue, 20 Apr 2021 08:15:18 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id z17sm2834735pjn.47.2021.04.20.08.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 08:15:18 -0700 (PDT)
Date:   Tue, 20 Apr 2021 15:15:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        srutherford@google.com, joro@8bytes.org, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, venu.busireddy@oracle.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        x86@kernel.org, Ashish Kalra <ashish.kalra@amd.com>
Subject: Re: [PATCH 0/3] KVM: x86: guest interface for SEV live migration
Message-ID: <YH7wAh0t+eQ5n1M2@google.com>
References: <20210420112006.741541-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420112006.741541-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021, Paolo Bonzini wrote:
> From 547d4d4edcd05fdfac6ce650d65db1d42bcd2807 Mon Sep 17 00:00:00 2001
> From: Paolo Bonzini <pbonzini@redhat.com>
> Date: Tue, 20 Apr 2021 05:49:11 -0400
> Subject: [PATCH 1/3] KVM: SEV: mask CPUID[0x8000001F].eax according to
>  supported features

Your mailer is obviously a bit wonky, took me a while to find this patch :-)
 
> Do not return the SEV-ES bit from KVM_GET_SUPPORTED_CPUID unless
> the corresponding module parameter is 1, and clear the memory encryption
> leaf completely if SEV is disabled.

Impeccable timing, I was planning on refreshing my SEV cleanup series[*] today.
There's going to be an annoying conflict with the svm_set_cpu_caps() change
(see below), any objecting to folding your unintentional feedback into my series?

[*] https://lkml.kernel.org/r/20210306015905.186698-1-seanjc@google.com

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/cpuid.c   | 5 ++++-
>  arch/x86/kvm/cpuid.h   | 1 +
>  arch/x86/kvm/svm/svm.c | 7 +++++++
>  3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 2ae061586677..d791d1f093ab 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -944,8 +944,11 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		break;
>  	/* Support memory encryption cpuid if host supports it */
>  	case 0x8000001F:
> -		if (!boot_cpu_has(X86_FEATURE_SEV))
> +		if (!kvm_cpu_cap_has(X86_FEATURE_SEV)) {
>  			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> +			break;
> +		}
> +		cpuid_entry_override(entry, CPUID_8000_001F_EAX);

I find this easier to read:

		if (!kvm_cpu_cap_has(X86_FEATURE_SEV))
			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
		else
			cpuid_entry_override(entry, CPUID_8000_001F_EAX);

>  		break;
>  	/*Add support for Centaur's CPUID instruction*/
>  	case 0xC0000000:
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 888e88b42e8d..e873a60a4830 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -99,6 +99,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
>  	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
>  	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
>  	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
> +	[CPUID_8000_001F_EAX] = {0x8000001F, 0, CPUID_EAX},
>  };
>  
>  /*
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cd8c333ed2dc..acdb8457289e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -923,6 +923,13 @@ static __init void svm_set_cpu_caps(void)
>  	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
>  	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
>  		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
> +
> +	/* CPUID 0x8000001F */
> +	if (sev) {
> +		kvm_cpu_cap_set(X86_FEATURE_SEV);
> +		if (sev_es)
> +			kvm_cpu_cap_set(X86_FEATURE_SEV_ES);

Gah, I completely spaced on the module params in my series, which is more
problematic than normal because it also moves "sev" and "sev_es" to sev.c.  The
easy solution is to add sev_set_cpu_caps().

On the other, this misses SME_COHERENT.  I also think it makes sense to call
kvm_cpu_cap_mask() for the leaf, even if it's just to crush KVM's caps to zero.
However, because of SME_COHERENT and other potential bits in the future, I think
I prefer starting with the bits carried over from boot_cpu_data.  E.g.

	kvm_cpu_cap_mask(CPUID_8000_001F_EAX,
		0 /* SME */ | F(SEV) | 0 /* VM_PAGE_FLUSH */ | F(SEV_ES) |
		F(SME_COHERENT));

and (with renamed module params):

	if (sev_enabled)
		kvm_cpu_cap_clear(X86_FEATURE_SEV);
	if (sev_es_enabled)
		kvm_cpu_cap_clear(X86_FEATURE_SEV_ES);

> +	}
>  }
>  
>  static __init int svm_hardware_setup(void)
