Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A02D476E9C
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 11:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235816AbhLPKOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 05:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbhLPKOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 05:14:39 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F80EC061574;
        Thu, 16 Dec 2021 02:14:39 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so22192383pjb.1;
        Thu, 16 Dec 2021 02:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=fe0hGKbwgdoyA8YYOpCWaXMJg1AN70Y0guzCKM5koz0=;
        b=UIl6jb/SOCzH0dQ5jPBW9lankZ5zFMkGJ3ozf+2i0cIcmnqjo9+FX00xrSLh4VsAiC
         H7ELjjLIvx03VR8Ip8TBD4La8DRqrpOg2BuMhWAM+9XEuyKwG0KcFqr4W/GY97KwmrIY
         aO0CnaJSvenSCYBYsJmkWJonAAWedU4uN+NhwDKcYw+pIKUvB3Y/j9wohfg9zvxH8yOX
         z+TIkL0VsUfG+Kyb8nsCz3Z5aB4lMqblueez++jwMYD1CK2xh2K4YHG6a+nrN3OGy2rZ
         oj3CAawlbrAd7CRE5KHrkPD+8ZkUCsQd8kzOwzQSWPSNLkiQaKwC4j7h/WCsBiox/f7G
         XnNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=fe0hGKbwgdoyA8YYOpCWaXMJg1AN70Y0guzCKM5koz0=;
        b=VHNaE6m7vpeWwgJVnt7UDiQKzPtc+3BpvV07zb4w9Bqwvh4val/GpeoCDTk68y9kPC
         gQKjHGgRWEXZ4ExbzBJa/OP4vy3N5uMlCGbz2N4lc/LOIoaqzMpUcXf9NqDR2m6su8EC
         oTSYychp+DvLjk0jp/30jCxZpcCyr0Ki89C2w2t/JZ/tzG2yEGFODCcG8Zdv67vqXTdG
         6vwiSwDfedYECzd+wubCa34o8vX4LOlRQPb7KR4MJ67HgvtIzsfKwY1qsyRIP7Z49HLD
         iNuhP2oNHCtu5Z1CGOK6qg5E/lhr4fsHa1VBxoXP9xbKCFp2F8mHPHiQpVjVNBTGtqt4
         nXWQ==
X-Gm-Message-State: AOAM532OxlPjX5mav6QMV2VBos/1CMAVivnnHyYUnNtqNyklCHs2EKcw
        WRe1oBGByRj3wHU/WbPou00=
X-Google-Smtp-Source: ABdhPJxXW8oN+6p4ZgPi69Ebug5Du1mAsPlRaVKmfyaRaTRTAFYYoohVcABFwIuT63igGB3blyIOBw==
X-Received: by 2002:a17:90b:1b4a:: with SMTP id nv10mr5213963pjb.118.1639649678747;
        Thu, 16 Dec 2021 02:14:38 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b19sm5739126pfv.63.2021.12.16.02.14.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 02:14:38 -0800 (PST)
Message-ID: <2527a359-eaad-9e7f-bc9a-bf2732997afd@gmail.com>
Date:   Thu, 16 Dec 2021 18:14:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH v2 0/6] KVM: x86/pmu: Count two basic events for emulated
 instructions
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <20211130074221.93635-1-likexu@tencent.com>
 <3118559d-8d4e-e080-2849-b526917969eb@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <3118559d-8d4e-e080-2849-b526917969eb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/2021 3:30 am, Paolo Bonzini wrote:
> On 11/30/21 08:42, Like Xu wrote:
>> Hi,
>>
>> [ Jim is on holiday, so I'm here to continue this work. ]
>>
>> Some cloud customers need accurate virtualization of two
>> basic PMU events on x86 hardware: "instructions retired" and
>> "branch instructions retired". The existing PMU virtualization code
>> fails to account for instructions (e.g, CPUID) that are emulated by KVM.
>>
>> Accurately virtualizing all PMU events for all microarchitectures is a
>> herculean task, let's just stick to the two events covered by this set.
>>
>> Eric Hankland wrote this code originally, but his plate is full, so Jim
>> and I volunteered to shepherd the changes through upstream acceptance.
>>
>> Thanks,
>>
>> v1 -> v2 Changelog:
>> - Include the patch set [1] and drop the intel_find_fixed_event(); [Paolo]
>>    (we will fix the misleading Intel CPUID events in another patch set)
>> - Drop checks for pmc->perf_event or event state or event type;
>> - Increase a counter once its umask bits and the first 8 select bits are matched;
>> - Rewrite kvm_pmu_incr_counter() with a less invasive approach to the host perf;
>> - Rename kvm_pmu_record_event to kvm_pmu_trigger_event;
>> - Add counter enable check for kvm_pmu_trigger_event();
>> - Add vcpu CPL check for kvm_pmu_trigger_event(); [Jim]
>>
>> Previous:
>> https://lore.kernel.org/kvm/20211112235235.1125060-2-jmattson@google.com/
>>
>> [1] https://lore.kernel.org/kvm/20211119064856.77948-1-likexu@tencent.com/
>>
>> Jim Mattson (1):
>>    KVM: x86: Update vPMCs when retiring branch instructions
>>
>> Like Xu (5):
>>    KVM: x86/pmu: Setup pmc->eventsel for fixed PMCs
>>    KVM: x86/pmu: Refactoring find_arch_event() to pmc_perf_hw_id()
>>    KVM: x86/pmu: Reuse pmc_perf_hw_id() and drop find_fixed_event()
>>    KVM: x86/pmu: Add pmc->intr to refactor kvm_perf_overflow{_intr}()
>>    KVM: x86: Update vPMCs when retiring instructions
>>
>>   arch/x86/include/asm/kvm_host.h |   1 +
>>   arch/x86/kvm/emulate.c          |  55 ++++++++------
>>   arch/x86/kvm/kvm_emulate.h      |   1 +
>>   arch/x86/kvm/pmu.c              | 128 ++++++++++++++++++++++----------
>>   arch/x86/kvm/pmu.h              |   5 +-
>>   arch/x86/kvm/svm/pmu.c          |  19 ++---
>>   arch/x86/kvm/vmx/nested.c       |   7 +-
>>   arch/x86/kvm/vmx/pmu_intel.c    |  44 ++++++-----
>>   arch/x86/kvm/x86.c              |   5 ++
>>   9 files changed, 167 insertions(+), 98 deletions(-)
>>
> 
> Queued patches 1-4, thanks.
> 
> Paolo
> 

Hi Paolo,

do we miss the fourth patch in the kvm/queue tree or are there
any new ideas or comments that we don't take it on board ?

Actually, the motivation is that the v11 pebs is rebased w/ first four patches.

Thanks,
Like Xu
