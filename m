Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6970C4141EE
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 08:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbhIVGeD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 02:34:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53285 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232696AbhIVGeB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 02:34:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632292351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QQ8YzZrVP1svLk3AMq6cxZLez6XFnWefi9KQVDYCfgo=;
        b=Iq5ke2Pjw+g8VO0+JuQRlOxpJXRt92oFeMlAdJ+JzNyhvMG3i08Aa4UMMmvE/iKSjjP9g3
        YIYMuz62jbl4yKlL6lfjrOyQLNbXoYJQ5JYAFrWv+ImUoBurG3vMCgF9qAXtke6l1iW8Lt
        3Aie6U+FdOajeYLkbqZ5/i/oZfayGNU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425--mW3u1IcMCaeH4240yp9JA-1; Wed, 22 Sep 2021 02:32:30 -0400
X-MC-Unique: -mW3u1IcMCaeH4240yp9JA-1
Received: by mail-ed1-f72.google.com with SMTP id d1-20020a50f681000000b003d860fcf4ffso1747804edn.22
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 23:32:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QQ8YzZrVP1svLk3AMq6cxZLez6XFnWefi9KQVDYCfgo=;
        b=yWyejtan/1SQ7/bdtGPLm9WOQ2VjcjsMcAzv8qCb1TF7WPEvxWFHyvzAM6Vdjp6lzH
         2MIR8wVgL15bX7CGhJJ1rV80Wj6boKtdmkKxg5pj61sy6Dd/1c4ddGr4ESuX7O/tMiJC
         //3l1EZi1L+9KqP4fKdgkhlttcb5662rq+eVB40zPlC6t0RBS58jHmvK8vhaYFDp2qQ3
         Hx/HdAYwfCL+ZteotTK4NfH0S2AC4b9ts0RdIxrEgQJGvEmygDBLoUicfJ6neEFleySy
         Crd14rofLHpdrOogCz18JImzFI3B7hlDXff85eiuKnvNJVy213k+vQCzn9gzdmn9P50I
         QT/g==
X-Gm-Message-State: AOAM533S3I0jcvfIPYMGP+/pAMsPKJcM2iwRZ7HISPRknYTpzYcK8ngT
        wVyj0aXzP13SU95l4hYx3fKHuCvOt6d10Av5McxZtqW0X8foyypNH09n0gUX2ISGClWdWMUaQCu
        pxO7Fm6ZXhdbE
X-Received: by 2002:a17:907:11c5:: with SMTP id va5mr38316022ejb.215.1632292349170;
        Tue, 21 Sep 2021 23:32:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYtbJQ8octsTI+p+irGuyf7bBUrwOfK9ScnlhWiK83zRobYLAMfdGjMGdI45oS8miuwF0xKA==
X-Received: by 2002:a17:907:11c5:: with SMTP id va5mr38315988ejb.215.1632292348952;
        Tue, 21 Sep 2021 23:32:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id yd3sm552542ejb.6.2021.09.21.23.32.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 23:32:28 -0700 (PDT)
Subject: Re: [PATCH v3 08/16] perf: Force architectures to opt-in to guest
 callbacks
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-csky@vger.kernel.org,
        linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
References: <20210922000533.713300-1-seanjc@google.com>
 <20210922000533.713300-9-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f2ad98e2-ddfb-c688-65af-7ecbd8bc3b3d@redhat.com>
Date:   Wed, 22 Sep 2021 08:32:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210922000533.713300-9-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/21 02:05, Sean Christopherson wrote:
> Introduce GUEST_PERF_EVENTS and require architectures to select it to
> allow registering and using guest callbacks in perf.  This will hopefully
> make it more difficult for new architectures to add useless "support" for
> guest callbacks, e.g. via copy+paste.
> 
> Stubbing out the helpers has the happy bonus of avoiding a load of
> perf_guest_cbs when GUEST_PERF_EVENTS=n on arm64/x86.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/arm64/kvm/Kconfig     | 1 +
>   arch/x86/kvm/Kconfig       | 1 +
>   arch/x86/xen/Kconfig       | 1 +
>   include/linux/perf_event.h | 6 ++++++
>   init/Kconfig               | 4 ++++
>   kernel/events/core.c       | 2 ++
>   6 files changed, 15 insertions(+)
> 
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index a4eba0908bfa..f2121404c7c6 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -37,6 +37,7 @@ menuconfig KVM
>   	select HAVE_KVM_IRQ_BYPASS
>   	select HAVE_KVM_VCPU_RUN_PID_CHANGE
>   	select SCHED_INFO
> +	select GUEST_PERF_EVENTS if PERF_EVENTS
>   	help
>   	  Support hosting virtualized guest machines.
>   
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index ac69894eab88..699bf786fbce 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -36,6 +36,7 @@ config KVM
>   	select KVM_MMIO
>   	select SCHED_INFO
>   	select PERF_EVENTS
> +	select GUEST_PERF_EVENTS
>   	select HAVE_KVM_MSI
>   	select HAVE_KVM_CPU_RELAX_INTERCEPT
>   	select HAVE_KVM_NO_POLL
> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> index afc1da68b06d..d07595a9552d 100644
> --- a/arch/x86/xen/Kconfig
> +++ b/arch/x86/xen/Kconfig
> @@ -23,6 +23,7 @@ config XEN_PV
>   	select PARAVIRT_XXL
>   	select XEN_HAVE_PVMMU
>   	select XEN_HAVE_VPMU
> +	select GUEST_PERF_EVENTS
>   	help
>   	  Support running as a Xen PV guest.
>   
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index c0a6eaf55fb1..eefa197d5354 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1238,6 +1238,7 @@ extern void perf_event_bpf_event(struct bpf_prog *prog,
>   				 enum perf_bpf_event_type type,
>   				 u16 flags);
>   
> +#ifdef CONFIG_GUEST_PERF_EVENTS
>   extern struct perf_guest_info_callbacks *perf_guest_cbs;
>   static inline struct perf_guest_info_callbacks *perf_get_guest_cbs(void)
>   {
> @@ -1273,6 +1274,11 @@ static inline unsigned int perf_guest_handle_intel_pt_intr(void)
>   }
>   extern void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
>   extern void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
> +#else
> +static inline unsigned int perf_guest_state(void)		 { return 0; }
> +static inline unsigned long perf_guest_get_ip(void)		 { return 0; }
> +static inline unsigned int perf_guest_handle_intel_pt_intr(void) { return 0; }
> +#endif /* CONFIG_GUEST_PERF_EVENTS */

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Having perf_guest_handle_intel_pt_intr in generic code is a bit off.  Of 
course it has to be in the struct, but the wrapper might be placed in 
arch/x86/include/asm/perf_event.h as well (applies to patch 7 as well).

Paolo

