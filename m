Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 978F616B28E
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 22:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgBXVdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 16:33:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53069 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726980AbgBXVdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 16:33:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582580019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c8+XmMTcQu9NRSgMktjQy1xQLejdPrZ1ttEMyUDWp7M=;
        b=UYKvzaCa8066Drs2LbR8nopYGQUdmI983Yd541jbzPS3MH+Ls2jcCnxrwThNICA4qFCxzp
        KagtaqMH0F63lZF7dY9rWNBkM8T7O9x9tVs9QI0XGXbv+eF+/q3+2H0tVM8Q9s+hRxkYTo
        9T457KU5S0Mfkjor9V01G4fzlTKxczo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-V-TQwYAIOCaYncEzXOaLXg-1; Mon, 24 Feb 2020 16:33:38 -0500
X-MC-Unique: V-TQwYAIOCaYncEzXOaLXg-1
Received: by mail-wr1-f71.google.com with SMTP id m15so6172018wrs.22
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 13:33:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=c8+XmMTcQu9NRSgMktjQy1xQLejdPrZ1ttEMyUDWp7M=;
        b=nF+XHWdy3ETLafUeBTDqfK2CPdTeZm52+PN+t7R7Sgs4+n6EFKBcHvVd/w3rwZ8xmb
         /nDpgZNg4jfoqxHIUvz5Z0Pb4ahfmA/ZWKPswC8r1oQ0YmBjiis/5pfyijvqwUZqvmOR
         9prPvKDU+om5fVeXNw5yWlCYSly2yct4MP5cw4elIoYQQ7uIb76I++wrgtxEOxnZbckU
         SOwV5C6FFH1yK6Wee4YnlvHrmVTwL1yjooyguWP+lLm9kCM4xvAHQvihU1U7yvyuSSWb
         /LAdUUu+lQDj6eUXa/l5GfRj+E+xkFgGru7FpiYVHx8ZWsb2LW+nf5BfWD3JJV1qQ935
         9ZJw==
X-Gm-Message-State: APjAAAXHU/lReGxm1fLHDlR2slfXWLie0FEvC1s1WegWjTF+Wk+D94FK
        rIsqfuJHpE9JfyXputGgh+UXvqJsF7tnmi3tLsxekUmwwpiTFRSnhYHvonYtCsX/idTOoTzVWtN
        IlS7NsIsVbdir
X-Received: by 2002:a1c:2b44:: with SMTP id r65mr963811wmr.72.1582580016824;
        Mon, 24 Feb 2020 13:33:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqwhJwlnq6aBlscqWEwyDJc0FvxuLMx0zkO0HNxZHKJdkV1VLwBYu8uFo3PsO3iYz3LrtvhQ6Q==
X-Received: by 2002:a1c:2b44:: with SMTP id r65mr963789wmr.72.1582580016516;
        Mon, 24 Feb 2020 13:33:36 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y8sm1002966wma.10.2020.02.24.13.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 13:33:35 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 39/61] KVM: SVM: Convert feature updates from CPUID to KVM cpu caps
In-Reply-To: <20200201185218.24473-40-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-40-sean.j.christopherson@intel.com>
Date:   Mon, 24 Feb 2020 22:33:34 +0100
Message-ID: <87eeujoekx.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Use the recently introduced KVM CPU caps to propagate SVM-only (kernel)
> settings to supported CPUID flags.
>
> Note, setting a flag based on a *different* feature is effectively
> emulation, and so must be done at runtime via ->set_supported_cpuid().
>
> Opportunistically add a technically unnecessary break and fix an
> indentation issue in svm_set_supported_cpuid().
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/svm.c | 40 +++++++++++++++++++++++-----------------
>  1 file changed, 23 insertions(+), 17 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 630520f8adfa..f98a192459f7 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1350,6 +1350,25 @@ static __init void svm_adjust_mmio_mask(void)
>  	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
>  }
>  

Can we probably add the comment about what can be done here and what
needs to go to svm_set_supported_cpuid()? (The one about 'emulation'
from your commit message would do).

> +static __init void svm_set_cpu_caps(void)
> +{
> +	/* CPUID 0x1 */
> +	if (avic)
> +		kvm_cpu_cap_clear(X86_FEATURE_X2APIC);
> +
> +	/* CPUID 0x80000001 */
> +	if (nested)
> +		kvm_cpu_cap_set(X86_FEATURE_SVM);
> +
> +	/* CPUID 0x8000000A */
> +	/* Support next_rip if host supports it */
> +	if (boot_cpu_has(X86_FEATURE_NRIPS))
> +		kvm_cpu_cap_set(X86_FEATURE_NRIPS);

Unrelated to your patch but the way we handle 'nrips' is a bit weird: we
can disable it with 'nrips' module parameter but L1 hypervisor will get
it unconditionally.

Also, what about all the rest of 0x8000000A.EDX features? Nested SVM
would appreciate some love... 

> +
> +	if (npt_enabled)
> +		kvm_cpu_cap_set(X86_FEATURE_NPT);
> +}
> +
>  static __init int svm_hardware_setup(void)
>  {
>  	int cpu;
> @@ -1462,6 +1481,8 @@ static __init int svm_hardware_setup(void)
>  			pr_info("Virtual GIF supported\n");
>  	}
>  
> +	svm_set_cpu_caps();
> +
>  	return 0;
>  
>  err:
> @@ -6033,17 +6054,9 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
>  static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
>  {
>  	switch (entry->function) {
> -	case 0x1:
> -		if (avic)
> -			cpuid_entry_clear(entry, X86_FEATURE_X2APIC);
> -		break;
> -	case 0x80000001:
> -		if (nested)
> -			cpuid_entry_set(entry, X86_FEATURE_SVM);
> -		break;
>  	case 0x80000008:
>  		if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
> -		     boot_cpu_has(X86_FEATURE_AMD_SSBD))
> +		    boot_cpu_has(X86_FEATURE_AMD_SSBD))
>  			cpuid_entry_set(entry, X86_FEATURE_VIRT_SSBD);
>  		break;
>  	case 0x8000000A:
> @@ -6053,14 +6066,7 @@ static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
>  		entry->ecx = 0; /* Reserved */
>  		entry->edx = 0; /* Per default do not support any
>  				   additional features */
> -
> -		/* Support next_rip if host supports it */
> -		if (boot_cpu_has(X86_FEATURE_NRIPS))
> -			cpuid_entry_set(entry, X86_FEATURE_NRIPS);
> -
> -		/* Support NPT for the guest if enabled */
> -		if (npt_enabled)
> -			cpuid_entry_set(entry, X86_FEATURE_NPT);
> +		break;
>  	}
>  }

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

