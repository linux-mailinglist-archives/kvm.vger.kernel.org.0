Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBCB3C8386
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 13:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239045AbhGNLSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 07:18:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22885 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239035AbhGNLSL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Jul 2021 07:18:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626261319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z981OS1uXu1xWcE4bmmWH5UA+7i0ZIyGX9+WawOYgZo=;
        b=fPAEgyLwXPgYpdJOc4jqXnQVSdHHi5Fd5FOzfKjbzyJtuHJ2i1VGJ/7TKaMBlTps9lfS6R
        vS/oiySyQLkcf4e0l25rBoxVP+kZd9a54Dkt18zRYYT5YczAJc17bf1hc1+iFhwBpm1VxI
        7zjQWhLKbCZYoT9l8fOKvril9RoVowI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-pLFIFBwOOQ-wwaUX8KIv9A-1; Wed, 14 Jul 2021 07:15:18 -0400
X-MC-Unique: pLFIFBwOOQ-wwaUX8KIv9A-1
Received: by mail-ed1-f71.google.com with SMTP id z13-20020a05640235cdb02903aa750a46efso1075784edc.8
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 04:15:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Z981OS1uXu1xWcE4bmmWH5UA+7i0ZIyGX9+WawOYgZo=;
        b=bVQZtlmH736+TNIm8PdOhNr2o9LIaf76PprW36gbH0ukrOSK9apx19LJZV1X4oP5ku
         ywrdCFLSgOWSZxDVVci2JsfjQ+9qvykj+1m5Wm6PgXOpeIttOhKK6tePENuAWSmET9FA
         imhQP0NNrvrYMClMVa6FcCOHhh0vBGEpcju11RQ667XqSFMpjN8ycln7eR16VOCxXv84
         LiqZqwndDoSdOY+F88cEzU3dQ0p+G9zN/qC7sMKQTvEiCM3f/KhfLOGZGCtwO63ikMRr
         j5qwnXuG93DCDXJPpat7VqmFFHPdpQlVb+tnnzP+zVeIwRTd6W7AbT29RiSHp0YRuztR
         OPWw==
X-Gm-Message-State: AOAM5334TwlsAZMpPDurOYcGLdTB3Cm6vKVcJNMqhha0uHGeHLFSWhbB
        +tUHBKO/JnTPs4Cmg0wStx1NPdZ6IzWvsM3RLnLuKTQwRZzVgg6p2v6DTvK4+P6R5J4JHZoPQl+
        As6kb9JzORA15bYufp/9HXT2vYDOSaldiRVkHgT+qfTlr2lfWSFU4yYX9na5k++4K
X-Received: by 2002:a17:906:69b:: with SMTP id u27mr11926794ejb.338.1626261316890;
        Wed, 14 Jul 2021 04:15:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5zumagCRkCslZ2/AUY9GUUlZ8EfDeo1zQ/HZbuzDOyv8xHdWXLhu2I/TDon6OVtivEdWwjg==
X-Received: by 2002:a17:906:69b:: with SMTP id u27mr11926750ejb.338.1626261316611;
        Wed, 14 Jul 2021 04:15:16 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n11sm676315ejg.111.2021.07.14.04.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 04:15:16 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 6/6] x86/kvm: add boot parameter for setting max number
 of vcpus per guest
In-Reply-To: <20210701154105.23215-7-jgross@suse.com>
References: <20210701154105.23215-1-jgross@suse.com>
 <20210701154105.23215-7-jgross@suse.com>
Date:   Wed, 14 Jul 2021 13:15:14 +0200
Message-ID: <87h7gx2lkt.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Juergen Gross <jgross@suse.com> writes:

> Today the maximum number of vcpus of a kvm guest is set via a #define
> in a header file.
>
> In order to support higher vcpu numbers for guests without generally
> increasing the memory consumption of guests on the host especially on
> very large systems add a boot parameter for specifying the number of
> allowed vcpus for guests.
>
> The default will still be the current setting of 288. The value 0 has
> the special meaning to limit the number of possible vcpus to the
> number of possible cpus of the host.
>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt | 10 ++++++++++
>  arch/x86/include/asm/kvm_host.h                 |  5 ++++-
>  arch/x86/kvm/x86.c                              |  7 +++++++
>  3 files changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 99bfa53a2bbd..8eb856396ffa 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2373,6 +2373,16 @@
>  			guest can't have more vcpus than the set value + 1.
>  			Default: 1023
>  
> +	kvm.max_vcpus=	[KVM,X86] Set the maximum allowed numbers of vcpus per
> +			guest. The special value 0 sets the limit to the number
> +			of physical cpus possible on the host (including not
> +			yet hotplugged cpus). Higher values will result in
> +			slightly higher memory consumption per guest. Depending
> +			on the value and the virtual topology the maximum
> +			allowed vcpu-id might need to be raised, too (see
> +			kvm.max_vcpu_id parameter).

I'd suggest to at least add a sanity check: 'max_vcpu_id' should always
be >= 'max_vcpus'. Alternatively, we can replace 'max_vcpu_id' with say
'vcpu_id_to_vcpus_ratio' and set it to e.g. '4' by default.

> +			Default: 288
> +
>  	l1tf=           [X86] Control mitigation of the L1TF vulnerability on
>  			      affected CPUs
>  
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 39cbc4b6bffb..65ae82a5d444 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -37,7 +37,8 @@
>  
>  #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
>  
> -#define KVM_MAX_VCPUS 288
> +#define KVM_DEFAULT_MAX_VCPUS 288
> +#define KVM_MAX_VCPUS max_vcpus
>  #define KVM_SOFT_MAX_VCPUS 240
>  #define KVM_DEFAULT_MAX_VCPU_ID 1023
>  #define KVM_MAX_VCPU_ID max_vcpu_id
> @@ -1509,6 +1510,8 @@ extern u64  kvm_max_tsc_scaling_ratio;
>  extern u64  kvm_default_tsc_scaling_ratio;
>  /* bus lock detection supported? */
>  extern bool kvm_has_bus_lock_exit;
> +/* maximum number of vcpus per guest */
> +extern unsigned int max_vcpus;
>  /* maximum vcpu-id */
>  extern unsigned int max_vcpu_id;
>  /* per cpu vcpu bitmasks (disable preemption during usage) */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a9b0bb2221ea..888c4507504d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -177,6 +177,10 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
>  int __read_mostly pi_inject_timer = -1;
>  module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
>  
> +unsigned int __read_mostly max_vcpus = KVM_DEFAULT_MAX_VCPUS;
> +module_param(max_vcpus, uint, S_IRUGO);
> +EXPORT_SYMBOL_GPL(max_vcpus);
> +
>  unsigned int __read_mostly max_vcpu_id = KVM_DEFAULT_MAX_VCPU_ID;
>  module_param(max_vcpu_id, uint, S_IRUGO);
>  
> @@ -10648,6 +10652,9 @@ int kvm_arch_hardware_setup(void *opaque)
>  	if (boot_cpu_has(X86_FEATURE_XSAVES))
>  		rdmsrl(MSR_IA32_XSS, host_xss);
>  
> +	if (max_vcpus == 0)
> +		max_vcpus = num_possible_cpus();

Is this special case really needed? I mean 'max_vcpus' is not '0' by
default so whoever sets it manually probably knows how big his guests
are going to be anyway and it is not always obvious how many CPUs are
reported by 'num_possible_cpus()' (ACPI tables can be weird for example).

> +
>  	kvm_pcpu_vcpu_mask = __alloc_percpu(KVM_VCPU_MASK_SZ,
>  					    sizeof(unsigned long));
>  	kvm_hv_vp_bitmap = __alloc_percpu(KVM_HV_VPMAP_SZ, sizeof(u64));

-- 
Vitaly

