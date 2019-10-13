Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11EACD555C
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2019 10:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbfJMIte (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Oct 2019 04:49:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35748 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728311AbfJMIte (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Oct 2019 04:49:34 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8F7E6C049E12
        for <kvm@vger.kernel.org>; Sun, 13 Oct 2019 08:49:33 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id n18so6990785wro.11
        for <kvm@vger.kernel.org>; Sun, 13 Oct 2019 01:49:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Ja9qbq8pwNINxaby4hLqVgL+JEeU/d+fL6MBhBXvMXU=;
        b=WtYBJkmdQD7U3oy3mw2qn7shjl0IvgVq1dPz7w045lE3Kmf57MU4tevp7grrzwutgs
         jzkGM3uNOH+8YFOLK7RPQDUd2H5vfH/4bStO+C5xsx6TLJKN4HdIG7SaoyAbOx/EwgZ9
         zLMc1IXfFh1HzPPHjPpeESeK78JbZWi0jdEA6pIqXwrtQ+gdUv6spMBE8+Fwoz1oz2//
         KhkRBAB1FU1FiqkPJiFBSIGeAcAavQQIEOBTU2lt1KcDByYOGEg4Hzm7Ak4cTVMWyhBp
         jBjs95sw3NxYPiw8BVwzOBcgZLbAYsoWPo/42+cMbKv/mbDGG1WE0BO12gnG+rIHWBvr
         u1SQ==
X-Gm-Message-State: APjAAAU5c/pWe5AoLIdR99pxs9sNcsVPcbK1Ig7ts9VMPUG3kO5iKnQd
        e7iOTY6iIY70CrkV1kH5xDCxQNIivxU29Utuk9ankvkv8M6jY9d4RfALjnFLbz5u2E/C1VW9jnF
        KSuWuXK83Nllz
X-Received: by 2002:a05:600c:2c2:: with SMTP id 2mr10686818wmn.112.1570956572217;
        Sun, 13 Oct 2019 01:49:32 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxo3H0voKcFIvJsSqXkvXStyxqzlu/VzQtkrGy4RT5JKhephQan3h6hxxgpNm1WZEyY9x3gyQ==
X-Received: by 2002:a05:600c:2c2:: with SMTP id 2mr10686793wmn.112.1570956571896;
        Sun, 13 Oct 2019 01:49:31 -0700 (PDT)
Received: from vitty.brq.redhat.com ([95.82.135.110])
        by smtp.gmail.com with ESMTPSA id u4sm27814969wmg.41.2019.10.13.01.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2019 01:49:31 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     lantianyu1986@gmail.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, mst@redhat.com, cohuck@redhat.com,
        pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        mtosatti@redhat.com, Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH] target/i386/kvm: Add Hyper-V direct tlb flush support
In-Reply-To: <20191012034153.31817-1-Tianyu.Lan@microsoft.com>
References: <20191012034153.31817-1-Tianyu.Lan@microsoft.com>
Date:   Sun, 13 Oct 2019 10:49:30 +0200
Message-ID: <87r23h58th.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

lantianyu1986@gmail.com writes:

> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>

(Please also Cc: Roman on you Hyper-V related submissions to QEMU who's
known to be a great reviewer)

> Hyper-V direct tlb flush targets KVM on Hyper-V guest.
> Enable direct TLB flush for its guests meaning that TLB
> flush hypercalls are handled by Level 0 hypervisor (Hyper-V)
> bypassing KVM in Level 1. Due to the different ABI for hypercall
> parameters between Hyper-V and KVM, KVM capabilities should be
> hidden when enable Hyper-V direct tlb flush otherwise KVM
> hypercalls may be intercepted by Hyper-V. Add new parameter
> "hv-direct-tlbflush". Check expose_kvm and Hyper-V tlb flush
> capability status before enabling the feature.
>
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  docs/hyperv.txt           | 12 ++++++++++++
>  linux-headers/linux/kvm.h |  1 +
>  target/i386/cpu.c         |  2 ++
>  target/i386/cpu.h         |  1 +
>  target/i386/kvm.c         | 21 +++++++++++++++++++++
>  5 files changed, 37 insertions(+)
>
> diff --git a/docs/hyperv.txt b/docs/hyperv.txt
> index 8fdf25c829..ceab8c21fe 100644
> --- a/docs/hyperv.txt
> +++ b/docs/hyperv.txt
> @@ -184,6 +184,18 @@ enabled.
>  
>  Requires: hv-vpindex, hv-synic, hv-time, hv-stimer
>  
> +3.18. hv-direct-tlbflush
> +=======================
> +The enlightenment targets KVM on Hyper-V guest. Enable direct TLB flush for
> +its guests meaning that TLB flush hypercalls are handled by Level 0 hypervisor
> +(Hyper-V) bypassing KVM in Level 1. Due to the different ABI for hypercall
> +parameters between Hyper-V and KVM, enabling this capability effectively
> +disables all hypercall handling by KVM (as some KVM hypercall may be mistakenly
> +treated as TLB flush hypercalls by Hyper-V). So kvm capability should not show
> +to guest when enable this capability. If not, user will fail to enable this
> +capability.
> +
> +Requires: hv-tlbflush, -kvm
>  
>  4. Development features
>  ========================
> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> index 18892d6541..923fb33a01 100644
> --- a/linux-headers/linux/kvm.h
> +++ b/linux-headers/linux/kvm.h
> @@ -995,6 +995,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_ARM_SVE 170
>  #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
>  #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
> +#define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 174

I was once told that scripts/update-linux-headers.sh script is supposed
to be used instead of cherry-picking stuff you need (adn this would be a
separate patch - update linux headers to smth).

>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 44f1bbdcac..7bc7fee512 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -6156,6 +6156,8 @@ static Property x86_cpu_properties[] = {
>                        HYPERV_FEAT_IPI, 0),
>      DEFINE_PROP_BIT64("hv-stimer-direct", X86CPU, hyperv_features,
>                        HYPERV_FEAT_STIMER_DIRECT, 0),
> +    DEFINE_PROP_BIT64("hv-direct-tlbflush", X86CPU, hyperv_features,
> +                      HYPERV_FEAT_DIRECT_TLBFLUSH, 0),
>      DEFINE_PROP_BOOL("hv-passthrough", X86CPU, hyperv_passthrough, false),
>  
>      DEFINE_PROP_BOOL("check", X86CPU, check_cpuid, true),
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index eaa5395aa5..3cb105f7d6 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -907,6 +907,7 @@ typedef uint64_t FeatureWordArray[FEATURE_WORDS];
>  #define HYPERV_FEAT_EVMCS               12
>  #define HYPERV_FEAT_IPI                 13
>  #define HYPERV_FEAT_STIMER_DIRECT       14
> +#define HYPERV_FEAT_DIRECT_TLBFLUSH     15
>  
>  #ifndef HYPERV_SPINLOCK_NEVER_RETRY
>  #define HYPERV_SPINLOCK_NEVER_RETRY             0xFFFFFFFF
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 11b9c854b5..8e999dbcf1 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -1235,6 +1235,27 @@ static int hyperv_handle_properties(CPUState *cs,
>          r |= 1;
>      }
>  
> +    if (hyperv_feat_enabled(cpu, HYPERV_FEAT_DIRECT_TLBFLUSH)) {
> +        if (!kvm_check_extension(cs->kvm_state,
> +            KVM_CAP_HYPERV_DIRECT_TLBFLUSH)) {
> +            fprintf(stderr,
> +                    "Kernel doesn't support Hyper-V direct tlbflush.\n");
> +            r = -ENOSYS;
> +            goto free;
> +        }
> +
> +        if (cpu->expose_kvm ||
> +            !hyperv_feat_enabled(cpu, HYPERV_FEAT_TLBFLUSH)) {
> +            fprintf(stderr, "Hyper-V direct tlbflush requires Hyper-V %s"
> +                    " and not expose KVM.\n",
> +                    kvm_hyperv_properties[HYPERV_FEAT_TLBFLUSH].desc);
> +            r = -ENOSYS;
> +            goto free;
> +        }
> +
> +        kvm_vcpu_enable_cap(cs, KVM_CAP_HYPERV_DIRECT_TLBFLUSH, 0, 0);
> +    }

We also have hv-passthrough mode where all Hyper-V enlightenments are
supposed to be enabled; I'd suggest you do the same we currently do with
HYPERV_FEAT_EVMCS:

    if (hyperv_feat_enabled(cpu, HYPERV_FEAT_DIRECT_TLBFLUSH) ||
        cpu->hyperv_passthrough) {

        r = kvm_vcpu_enable_cap(cs, KVM_CAP_HYPERV_DIRECT_TLBFLUSH, 0, 0);

        if (hyperv_feat_enabled(cpu, HYPERV_FEAT_EVMCS) && r) {
            fprintf(stderr, "Hyper-V %s is not supported by kernel\n",
                    kvm_hyperv_properties[HYPERV_FEAT_DIRECT_TLBFLUSH].desc);
            return -ENOSYS;
        }

No need to check for a capability if you're going to enable it right
away (and btw - this can fail).

You also need to use kvm_hyperv_properties to track dependencies between
features and not do it manually here (like you required
HYPERV_FEAT_TLBFLUSH). This is going to be the first feature without its
own CPUID bits assigned so some tweaks to kvm_hyperv_properties handling
may be required. Or we can use HYPERV_FEAT_TLBFLUSH bits, I'm not sure
here.


> +
>      /* Not exposed by KVM but needed to make CPU hotplug in Windows work */
>      env->features[FEAT_HYPERV_EDX] |= HV_CPU_DYNAMIC_PARTITIONING_AVAILABLE;

-- 
Vitaly
