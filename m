Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9AAD7C9C
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 19:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbfJORB3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 13:01:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38580 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726824AbfJORB2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 13:01:28 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 85F413C928
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 17:01:27 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id c6so4130933wrp.3
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 10:01:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VGRbvJF6E2IH8bfXxTorreLtbiW/Eu+4508lD8RUR04=;
        b=ftfXDrLs6kwUDlvXANQjEM2cwnxj4o+lGmganYuHxiBS+JnV7sXvHqIgNYuZxi++Zk
         lMMc1eYKapkKxI09quYHHQif7Sfo+XF16pAUT/l2G3X8Ei+BrV4eQzf6M8ikGPIendUD
         LpuqPNjmivwAOr8sQBz5C50b/BWi6kVSoZeykUJakhOZX2U6zzrqz7fYlyOPjzl2zeWb
         BmJ018F6USmk4G9a8v7+gkRISp3SDojPkUMoyVSUhBGpUkjVW8KkQ7TNA9DF2Pm6xR+6
         ep+cIgI9LWa5+2051RrUC0/cObFDYoap/SPRfX4ILJVjvopYSJFghPvgvWBPCIgxUwkJ
         jc7Q==
X-Gm-Message-State: APjAAAXYCeJjICAcInRUarodUHcUhn7R+Yy+bcE5j2RgKGc6+B7yqaao
        MQyBojIZ7YYO/gwZEAPWQ9oLc2kuTSQkkxX4/xYGpvITHg4rIi5n9ae1K6eWkQd8Vpo+lpouEaz
        kr9EbCSN6nCCW
X-Received: by 2002:adf:8385:: with SMTP id 5mr32475999wre.267.1571158886061;
        Tue, 15 Oct 2019 10:01:26 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwky/GpobUXGsD/uJTzHRcZEX/xS3dGc+FuZhJ8nPAtP/NTMOLP9KwDXPdxfmX63NsDSbp5AA==
X-Received: by 2002:adf:8385:: with SMTP id 5mr32475968wre.267.1571158885676;
        Tue, 15 Oct 2019 10:01:25 -0700 (PDT)
Received: from vitty.brq.redhat.com ([95.82.135.254])
        by smtp.gmail.com with ESMTPSA id r3sm13296316wre.29.2019.10.15.10.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 10:01:24 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     lantianyu1986@gmail.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, mst@redhat.com, cohuck@redhat.com,
        pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        mtosatti@redhat.com, rkagan@virtuozzo.com
Subject: Re: [PATCH V2 2/2] target/i386/kvm: Add Hyper-V direct tlb flush support
In-Reply-To: <20191015143610.31857-3-Tianyu.Lan@microsoft.com>
References: <20191015143610.31857-1-Tianyu.Lan@microsoft.com> <20191015143610.31857-3-Tianyu.Lan@microsoft.com>
Date:   Tue, 15 Oct 2019 19:01:23 +0200
Message-ID: <87ftju3puk.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

lantianyu1986@gmail.com writes:

> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>
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
> Change since V1:
>        - Add direct tlb flush's Hyper-V property and use
>        hv_cpuid_check_and_set() to check the dependency of tlbflush
>        feature.
>        - Make new feature work with Hyper-V passthrough mode.
> ---
>  docs/hyperv.txt   | 12 ++++++++++++
>  target/i386/cpu.c |  2 ++
>  target/i386/cpu.h |  1 +
>  target/i386/kvm.c | 23 +++++++++++++++++++++++
>  4 files changed, 38 insertions(+)
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


My take:

"Enable direct TLB flush for KVM when it is running as a nested
hypervisor on top Hyper-V. When enabled, TLB flush hypercalls from L2
guests are being passed through to L0 (Hyper-V) for handling. Due to ABI
differences between Hyper-V and KVM hypercalls, L2 guests will not be
able to issue KVM hypercalls (as those could be mishanled by L0
Hyper-V), this requires KVM hypervisor signature to be hidden."

It would be great if someone who doesn't know that the feature is would
read these two paragraphs and tell us how they sound :-)

> +
> +Requires: hv-tlbflush, -kvm
>  
>  4. Development features
>  ========================
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
> index 11b9c854b5..7e0fbc730e 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -900,6 +900,10 @@ static struct {
>          },
>          .dependencies = BIT(HYPERV_FEAT_STIMER)
>      },
> +    [HYPERV_FEAT_DIRECT_TLBFLUSH] = {
> +        .desc = "direct tlbflush (hv-direct-tlbflush)",

"direct TLB flush" (to be consistent with "paravirtualized TLB flush" above

> +        .dependencies = BIT(HYPERV_FEAT_TLBFLUSH)
> +    },
>  };
>  
>  static struct kvm_cpuid2 *try_get_hv_cpuid(CPUState *cs, int max)
> @@ -1224,6 +1228,7 @@ static int hyperv_handle_properties(CPUState *cs,
>      r |= hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_EVMCS);
>      r |= hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_IPI);
>      r |= hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_STIMER_DIRECT);
> +    r |= hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_DIRECT_TLBFLUSH);
>  
>      /* Additional dependencies not covered by kvm_hyperv_properties[] */
>      if (hyperv_feat_enabled(cpu, HYPERV_FEAT_SYNIC) &&
> @@ -1243,6 +1248,24 @@ static int hyperv_handle_properties(CPUState *cs,
>          goto free;
>      }
>  
> +    if (hyperv_feat_enabled(cpu, HYPERV_FEAT_DIRECT_TLBFLUSH) ||
> +        cpu->hyperv_passthrough) {
> +        if (!cpu->expose_kvm) {
> +            r = kvm_vcpu_enable_cap(cs, KVM_CAP_HYPERV_DIRECT_TLBFLUSH, 0, 0);
> +            if (hyperv_feat_enabled(cpu, HYPERV_FEAT_DIRECT_TLBFLUSH) && r) {
> +                fprintf(stderr,
> +                    "Hyper-V %s is not supported by kernel\n",
> +                    kvm_hyperv_properties[HYPERV_FEAT_DIRECT_TLBFLUSH].desc);
> +                return -ENOSYS;
> +            }
> +        } else if (!cpu->hyperv_passthrough) {
> +            fprintf(stderr,
> +                "Hyper-V %s requires not to expose KVM capabilities.\n",

My take:
"... requires KVM hypervisor signature to be hidden (-kvm)."

> +                kvm_hyperv_properties[HYPERV_FEAT_DIRECT_TLBFLUSH].desc);
> +            return -ENOSYS;
> +        }
> +    }

Thanks, the check looks correct to me now.

> +
>      if (cpu->hyperv_passthrough) {
>          /* We already copied all feature words from KVM as is */
>          r = cpuid->nent;

-- 
Vitaly
