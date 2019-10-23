Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB4B9E12EE
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 09:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389090AbfJWHQo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 03:16:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59692 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727574AbfJWHQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 03:16:44 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 06A87C057F20
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2019 07:16:43 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id a6so7598579wru.1
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2019 00:16:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jwOtyVgHh4fXErSSQOuM/kzsF9twK281dOW0D19R2iQ=;
        b=QorrND6Leo9zqnsaCDJNG2XWu8BAYDRWIbhRygpZ3mYiCzNxE6EXdMYZAZivcEN2RS
         0q61GVY2LrNc7TuE/d233Awezhs00V45ndRWgcL48Xj/eM+8NofgUdEDq/awGOEC5PlO
         dbASy2LfGPC27aeo21r8Vsz8jKbKx1CMgp0/0TtEIwIHJipRa9lp98AiEBR/I97rHdea
         FOoJho2Tjbk6PdCQVsGkq9qCm7RKZ32TB7F6eaEmUz3nr/EBf1hnCJxwB6Gz/sHN5G7e
         wI8yK+r6oYGrVf+dFpCRNhId+YadYYN04rLmSirqivhYxu5yF745r2ozFJ/Kr7TSeGXZ
         1haA==
X-Gm-Message-State: APjAAAXWn9W88h+OmWJp0kmeBRKdGMzek2nQ70aLTLkOSQ/Hjj96hZgG
        vMssAM3UGHkgqs6AgE3n25vu+rJIuTTY9VpItu9cdflQPGT2k1ojxjCACuNSwnIHDaNVWnF2LPH
        E9+NmMPbQ1xza
X-Received: by 2002:a1c:f714:: with SMTP id v20mr6567462wmh.55.1571815001363;
        Wed, 23 Oct 2019 00:16:41 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxEL40+6DQtzEWcUPXQXJhcsOA/uesoowP/wdVrCFut/Org2lg1krqm2IDjGjwbNA1POOLjvA==
X-Received: by 2002:a1c:f714:: with SMTP id v20mr6567426wmh.55.1571815000912;
        Wed, 23 Oct 2019 00:16:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:45c:4f58:5841:71b2? ([2001:b07:6468:f312:45c:4f58:5841:71b2])
        by smtp.gmail.com with ESMTPSA id d4sm28058276wrc.54.2019.10.23.00.16.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2019 00:16:40 -0700 (PDT)
Subject: Re: [PATCH V3 2/2] target/i386/kvm: Add Hyper-V direct tlb flush
 support
To:     Roman Kagan <rkagan@virtuozzo.com>, lantianyu1986@gmail.com,
        rth@twiddle.net, ehabkost@redhat.com, mtosatti@redhat.com,
        vkuznets@redhat.com, Tianyu Lan <Tianyu.Lan@microsoft.com>,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20191016130725.5045-1-Tianyu.Lan@microsoft.com>
 <20191016130725.5045-3-Tianyu.Lan@microsoft.com>
 <7de12770-271e-d386-a105-d53b50aa731f@redhat.com>
 <20191022201418.GA22898@rkaganb.lan>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <76c02274-a68f-65a8-aca9-963076db1557@redhat.com>
Date:   Wed, 23 Oct 2019 09:16:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191022201418.GA22898@rkaganb.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/10/19 22:14, Roman Kagan wrote:
> On Tue, Oct 22, 2019 at 07:04:11PM +0200, Paolo Bonzini wrote:
>> On 16/10/19 15:07, lantianyu1986@gmail.com wrote:
> 
> Somehow this patch never got through to me so I'll reply here.
> 
>>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>>
>>> Hyper-V direct tlb flush targets KVM on Hyper-V guest.
>>> Enable direct TLB flush for its guests meaning that TLB
>>> flush hypercalls are handled by Level 0 hypervisor (Hyper-V)
>>> bypassing KVM in Level 1. Due to the different ABI for hypercall
>>> parameters between Hyper-V and KVM, KVM capabilities should be
>>> hidden when enable Hyper-V direct tlb flush otherwise KVM
>>> hypercalls may be intercepted by Hyper-V. Add new parameter
>>> "hv-direct-tlbflush". Check expose_kvm and Hyper-V tlb flush
>>> capability status before enabling the feature.
>>>
>>> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>> ---
>>> Change sicne v2:
>>>        - Update new feature description and name.
>>>        - Change failure print log.
>>>
>>> Change since v1:
>>>        - Add direct tlb flush's Hyper-V property and use
>>>        hv_cpuid_check_and_set() to check the dependency of tlbflush
>>>        feature.
>>>        - Make new feature work with Hyper-V passthrough mode.
>>> ---
>>>  docs/hyperv.txt   | 10 ++++++++++
>>>  target/i386/cpu.c |  2 ++
>>>  target/i386/cpu.h |  1 +
>>>  target/i386/kvm.c | 24 ++++++++++++++++++++++++
>>>  4 files changed, 37 insertions(+)
>>>
>>> diff --git a/docs/hyperv.txt b/docs/hyperv.txt
>>> index 8fdf25c829..140a5c7e44 100644
>>> --- a/docs/hyperv.txt
>>> +++ b/docs/hyperv.txt
>>> @@ -184,6 +184,16 @@ enabled.
>>>  
>>>  Requires: hv-vpindex, hv-synic, hv-time, hv-stimer
>>>  
>>> +3.18. hv-direct-tlbflush
>>> +=======================
>>> +Enable direct TLB flush for KVM when it is running as a nested
>>> +hypervisor on top Hyper-V. When enabled, TLB flush hypercalls from L2
>>> +guests are being passed through to L0 (Hyper-V) for handling. Due to ABI
>>> +differences between Hyper-V and KVM hypercalls, L2 guests will not be
>>> +able to issue KVM hypercalls (as those could be mishanled by L0
>>> +Hyper-V), this requires KVM hypervisor signature to be hidden.
>>> +
>>> +Requires: hv-tlbflush, -kvm
>>>  
>>>  4. Development features
>>>  ========================
>>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>>> index 44f1bbdcac..7bc7fee512 100644
>>> --- a/target/i386/cpu.c
>>> +++ b/target/i386/cpu.c
>>> @@ -6156,6 +6156,8 @@ static Property x86_cpu_properties[] = {
>>>                        HYPERV_FEAT_IPI, 0),
>>>      DEFINE_PROP_BIT64("hv-stimer-direct", X86CPU, hyperv_features,
>>>                        HYPERV_FEAT_STIMER_DIRECT, 0),
>>> +    DEFINE_PROP_BIT64("hv-direct-tlbflush", X86CPU, hyperv_features,
>>> +                      HYPERV_FEAT_DIRECT_TLBFLUSH, 0),
>>>      DEFINE_PROP_BOOL("hv-passthrough", X86CPU, hyperv_passthrough, false),
>>>  
>>>      DEFINE_PROP_BOOL("check", X86CPU, check_cpuid, true),
>>> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
>>> index eaa5395aa5..3cb105f7d6 100644
>>> --- a/target/i386/cpu.h
>>> +++ b/target/i386/cpu.h
>>> @@ -907,6 +907,7 @@ typedef uint64_t FeatureWordArray[FEATURE_WORDS];
>>>  #define HYPERV_FEAT_EVMCS               12
>>>  #define HYPERV_FEAT_IPI                 13
>>>  #define HYPERV_FEAT_STIMER_DIRECT       14
>>> +#define HYPERV_FEAT_DIRECT_TLBFLUSH     15
>>>  
>>>  #ifndef HYPERV_SPINLOCK_NEVER_RETRY
>>>  #define HYPERV_SPINLOCK_NEVER_RETRY             0xFFFFFFFF
>>> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
>>> index 11b9c854b5..043b66ab22 100644
>>> --- a/target/i386/kvm.c
>>> +++ b/target/i386/kvm.c
>>> @@ -900,6 +900,10 @@ static struct {
>>>          },
>>>          .dependencies = BIT(HYPERV_FEAT_STIMER)
>>>      },
>>> +    [HYPERV_FEAT_DIRECT_TLBFLUSH] = {
>>> +        .desc = "direct paravirtualized TLB flush (hv-direct-tlbflush)",
>>> +        .dependencies = BIT(HYPERV_FEAT_TLBFLUSH)
>>> +    },
>>>  };
>>>  
>>>  static struct kvm_cpuid2 *try_get_hv_cpuid(CPUState *cs, int max)
>>> @@ -1224,6 +1228,7 @@ static int hyperv_handle_properties(CPUState *cs,
>>>      r |= hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_EVMCS);
>>>      r |= hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_IPI);
>>>      r |= hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_STIMER_DIRECT);
>>> +    r |= hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_DIRECT_TLBFLUSH);
> 
> AFAICS this will turn HYPERV_FEAT_DIRECT_TLBFLUSH on if
> hyperv_passthrough is on, so ...
> 
>>>  
>>>      /* Additional dependencies not covered by kvm_hyperv_properties[] */
>>>      if (hyperv_feat_enabled(cpu, HYPERV_FEAT_SYNIC) &&
>>> @@ -1243,6 +1248,25 @@ static int hyperv_handle_properties(CPUState *cs,
>>>          goto free;
>>>      }
>>>  
>>> +    if (hyperv_feat_enabled(cpu, HYPERV_FEAT_DIRECT_TLBFLUSH) ||
>>> +        cpu->hyperv_passthrough) {
> 
> ... the test for ->hyperv_passthrough is redundant, and ...
> 
>>> +        if (!cpu->expose_kvm) {
>>> +            r = kvm_vcpu_enable_cap(cs, KVM_CAP_HYPERV_DIRECT_TLBFLUSH, 0, 0);
>>> +            if (hyperv_feat_enabled(cpu, HYPERV_FEAT_DIRECT_TLBFLUSH) && r) {
> 
> ... , more importantly, this will abort QEMU if
> HYPERV_FEAT_DIRECT_TLBFLUSH wasn't requested explicitly, but was
> activated by ->hyperv_passthrough, and setting the capability failed.  I
> think the meaning of hyperv_passthrough is "enable all hyperv features
> supported by the KVM", so in this case it looks more correct to just
> clear the feature bit and go ahead.
> 
>>> +                fprintf(stderr,
>>> +                    "Hyper-V %s is not supported by kernel\n",
>>> +                    kvm_hyperv_properties[HYPERV_FEAT_DIRECT_TLBFLUSH].desc);
>>> +                return -ENOSYS;
>>> +            }
>>> +        } else if (!cpu->hyperv_passthrough) {
>>> +            fprintf(stderr,
>>> +                "Hyper-V %s requires KVM hypervisor signature "
>>> +                "to be hidden (-kvm).\n",
>>> +                kvm_hyperv_properties[HYPERV_FEAT_DIRECT_TLBFLUSH].desc);
>>> +            return -ENOSYS;
>>> +        }
> 
> You reach here if ->expose_kvm && ->hyperv_passthrough, and no
> capability is activated, and you go ahead with the feature bit set.
> This doesn't look right either.
> 
> So in general it should probably look like
> 
>     if (hyperv_feat_enabled(HYPERV_FEAT_DIRECT_TLBFLUSH)) {
>         if (kvm_vcpu_enable_cap(KVM_CAP_HYPERV_DIRECT_TLBFLUSH)) {
>             if (!cpu->hyperv_passthrough) {
>                 ... report feature unsupported by kernel ...
>                 return -ENOSYS;
>             }
>             cpu->hyperv_features &= ~BIT(HYPERV_FEAT_DIRECT_TLBFLUSH);
>         } else if (cpu->expose_kvm) {
>             ... report conflict ...
>             return -ENOSYS;
>         }
>     }
> 
> [Yes, hyperv_passthrough hurts, but you've been warned ;)]

Unqueued, thanks. :)

Paolo

