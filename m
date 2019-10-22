Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C320E0A09
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 19:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732311AbfJVREP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 13:04:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730727AbfJVREP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 13:04:15 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 75B2B58
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 17:04:14 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id 92so4123810wro.14
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 10:04:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0NEhBoFQokh3U/F7hNVxe9sOLNn7d5EW0/bTrybnHeQ=;
        b=A25h2gGZJNYE5am9lATvrKr6XJWPQlco4TLHdvXcg+5ia7jfC1+7e23ahdHlS6LnL5
         T1tdzZ6KSS8pmRaWDPlkKtA2FkD6zK5pTjjWjgw0mSmTgS74R9h0vh0jTlAR7JfdXwa/
         a1Ub+9a5sYDV53zA+lHObYhB3TwDc/4S8BQe2DoFLxw8s9NKNgT0ilZ5Z70j+TJKqHNw
         SOl1+R694Cg1NJ2u2UISc/GllC/9zT6lVAJKJ95cjHmFnpAw1wa7O8aYHBURaYnjexPW
         GztdOEzkGQMWw1yZ3R0009dKGbF1x/M6r7rnDbwhkbzBmvedyX691ANhVRQ+Ohg8PZGU
         Le4Q==
X-Gm-Message-State: APjAAAWXExT9m9GCnOOVEryvKUK+gC7MWNP8HMA71m1WWDZIDS2GkNwb
        e754ET46VO29l1V9b4ZYzKT/tDR5xq4+htg6ukGNmF/pCJZcWlF9U7KU2LXXIeqkiSZcY1fGpzy
        ubKENHjGm6Gz+
X-Received: by 2002:adf:ef83:: with SMTP id d3mr4006626wro.299.1571763852787;
        Tue, 22 Oct 2019 10:04:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzMBmpDaHqVcBvasZq/rspcGCZmV3reipzfYXuv+HEgy3YzczYUN9Jn864xlfc7aFDK1y8p8A==
X-Received: by 2002:adf:ef83:: with SMTP id d3mr4006598wro.299.1571763852380;
        Tue, 22 Oct 2019 10:04:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c0e4:dcf4:b543:ce19? ([2001:b07:6468:f312:c0e4:dcf4:b543:ce19])
        by smtp.gmail.com with ESMTPSA id t16sm18962170wrq.52.2019.10.22.10.04.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 10:04:11 -0700 (PDT)
Subject: Re: [PATCH V3 2/2] target/i386/kvm: Add Hyper-V direct tlb flush
 support
To:     lantianyu1986@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
        mtosatti@redhat.com, vkuznets@redhat.com,
        Roman Kagan <rkagan@virtuozzo.com>
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
References: <20191016130725.5045-1-Tianyu.Lan@microsoft.com>
 <20191016130725.5045-3-Tianyu.Lan@microsoft.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7de12770-271e-d386-a105-d53b50aa731f@redhat.com>
Date:   Tue, 22 Oct 2019 19:04:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191016130725.5045-3-Tianyu.Lan@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/19 15:07, lantianyu1986@gmail.com wrote:
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
> Change sicne v2:
>        - Update new feature description and name.
>        - Change failure print log.
> 
> Change since v1:
>        - Add direct tlb flush's Hyper-V property and use
>        hv_cpuid_check_and_set() to check the dependency of tlbflush
>        feature.
>        - Make new feature work with Hyper-V passthrough mode.
> ---
>  docs/hyperv.txt   | 10 ++++++++++
>  target/i386/cpu.c |  2 ++
>  target/i386/cpu.h |  1 +
>  target/i386/kvm.c | 24 ++++++++++++++++++++++++
>  4 files changed, 37 insertions(+)
> 
> diff --git a/docs/hyperv.txt b/docs/hyperv.txt
> index 8fdf25c829..140a5c7e44 100644
> --- a/docs/hyperv.txt
> +++ b/docs/hyperv.txt
> @@ -184,6 +184,16 @@ enabled.
>  
>  Requires: hv-vpindex, hv-synic, hv-time, hv-stimer
>  
> +3.18. hv-direct-tlbflush
> +=======================
> +Enable direct TLB flush for KVM when it is running as a nested
> +hypervisor on top Hyper-V. When enabled, TLB flush hypercalls from L2
> +guests are being passed through to L0 (Hyper-V) for handling. Due to ABI
> +differences between Hyper-V and KVM hypercalls, L2 guests will not be
> +able to issue KVM hypercalls (as those could be mishanled by L0
> +Hyper-V), this requires KVM hypervisor signature to be hidden.
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
> index 11b9c854b5..043b66ab22 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -900,6 +900,10 @@ static struct {
>          },
>          .dependencies = BIT(HYPERV_FEAT_STIMER)
>      },
> +    [HYPERV_FEAT_DIRECT_TLBFLUSH] = {
> +        .desc = "direct paravirtualized TLB flush (hv-direct-tlbflush)",
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
> @@ -1243,6 +1248,25 @@ static int hyperv_handle_properties(CPUState *cs,
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
> +                "Hyper-V %s requires KVM hypervisor signature "
> +                "to be hidden (-kvm).\n",
> +                kvm_hyperv_properties[HYPERV_FEAT_DIRECT_TLBFLUSH].desc);
> +            return -ENOSYS;
> +        }
> +    }
> +
>      if (cpu->hyperv_passthrough) {
>          /* We already copied all feature words from KVM as is */
>          r = cpuid->nent;
> 

Queued, thanks.  Patch 1 is not needed anymore.

Paolo
