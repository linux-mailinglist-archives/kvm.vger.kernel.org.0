Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBD93C5AA5
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 13:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235047AbhGLKN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 06:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238459AbhGLKNa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 06:13:30 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503F6C0613DD;
        Mon, 12 Jul 2021 03:10:40 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id a2so17707390pgi.6;
        Mon, 12 Jul 2021 03:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iEk/ir9/c5kSFxMDMVhuyjD1jxHThSmk1Tkskkir1rU=;
        b=qqUoJbLgzwxcX4qaTCPtUubntnRMo4Vgt1/AK90kCTwnlF+r6vfCJAGfGrOQ7+7kLV
         eL0vgadXeOt3waCA8JqCWLMabNjAocZjePvEW3lSDXTf8UJD8SBLxi5S1B5amaXko1um
         +7lhS5imt0lIAbec/vN+K5ugke7Vai7AKAh6cLU42JsAX5e01rmuYT0fdrkEUzK/76mU
         Ge5vpzKCtZUlfUuUtbMnEEH+mHqVWP7vgZ7oVdgIzMLW7hcY6tWqUkg81gWPbLA4BrmL
         Ev7hjolxznPvBHPZZT58AIbHxXJOuQogNkrW21XTTlJytr3cFGUrmc79OSNGLVg3nLdm
         Vzaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iEk/ir9/c5kSFxMDMVhuyjD1jxHThSmk1Tkskkir1rU=;
        b=bGa2b/xUJCf+95sqjaZYVOkw8etOOz1PIHoiq4UiPNC4Ct2DpKnS8tuDL4QJyu1cVA
         rVneLDchAJ49R6rqcCxXJmCtVXSh2FCr13loG2/lbG3u8EDe87zhhpec7bZ4B2uDBoc/
         apEs0jNKQMuxbyQadRtj7VUXZRMAG0WBQJupbTyWkzh5O6YM9iX8vo3IOR7OpzRSB4ok
         zHGoYKKyWUG9qsCNUTZul845MTUddGMmnr33kVHgnLes5ac+DW+EWO863cWpfKtHtCbZ
         b3uxZpugNJAgsuFtApI0ZtTz663gTK/Swt9eALqp8RLqneHrx/7oMFphvJhc3DZO3V60
         JzOg==
X-Gm-Message-State: AOAM5332nwmzpVSzjDiakltX9sioYzByAqvIfd6goUeCGrSkI0EuAXe/
        hBPtZgWsBLtM7ORgqdKUSss=
X-Google-Smtp-Source: ABdhPJzXCINaueh7u8MBAcqVETylU6Tc2av30BJoHPIU+k0H57txwsmCcHe/7/KIPAmNm6a2xskU9g==
X-Received: by 2002:a65:6489:: with SMTP id e9mr24110978pgv.409.1626084639845;
        Mon, 12 Jul 2021 03:10:39 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j19sm17051700pgm.44.2021.07.12.03.10.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 03:10:39 -0700 (PDT)
Subject: Re: [PATCH v5 05/13] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for guest
 Arch LBR
To:     Yang Weijiang <weijiang.yang@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
 <1625825111-6604-6-git-send-email-weijiang.yang@intel.com>
 <CALMp9eR8mbVXS5E6sB7TwEocytpWcG_6w-ijmfxAd4ciHPtfmw@mail.gmail.com>
 <20210712093626.GC12162@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Message-ID: <bd386ed1-69d8-39ab-8bee-6e3aed8d2ee2@gmail.com>
Date:   Mon, 12 Jul 2021 18:10:30 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712093626.GC12162@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/2021 5:36 pm, Yang Weijiang wrote:
> On Fri, Jul 09, 2021 at 02:55:35PM -0700, Jim Mattson wrote:
>> On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
>>>
>>> From: Like Xu <like.xu@linux.intel.com>
>>>
>>> Arch LBRs are enabled by setting MSR_ARCH_LBR_CTL.LBREn to 1. A new guest
>>> state field named "Guest IA32_LBR_CTL" is added to enhance guest LBR usage.
>>> When guest Arch LBR is enabled, a guest LBR event will be created like the
>>> model-specific LBR does. Clear guest LBR enable bit on host PMI handling so
>>> guest can see expected config.
>>>
>>> On processors that support Arch LBR, MSR_IA32_DEBUGCTLMSR[bit 0] has no
>>> meaning. It can be written to 0 or 1, but reads will always return 0.
>>> Like IA32_DEBUGCTL, IA32_ARCH_LBR_CTL msr is also reserved on INIT.
>>
>> I suspect you mean "preserved" rather than "reserved."
> Yes, should be preserved.
> 
>>
>>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>> ---
>>>   arch/x86/events/intel/lbr.c      |  2 --
>>>   arch/x86/include/asm/msr-index.h |  1 +
>>>   arch/x86/include/asm/vmx.h       |  2 ++
>>>   arch/x86/kvm/vmx/pmu_intel.c     | 31 ++++++++++++++++++++++++++-----
>>>   arch/x86/kvm/vmx/vmx.c           |  9 +++++++++
>>>   5 files changed, 38 insertions(+), 7 deletions(-)
>>>
>>
>>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>>> index da68f0e74702..4500c564c63a 100644
>>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>>> @@ -19,6 +19,11 @@
>>>   #include "pmu.h"
>>>
>>>   #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
>>> +/*
>>> + * Regardless of the Arch LBR or legacy LBR, when the LBR_EN bit 0 of the
>>> + * corresponding control MSR is set to 1, LBR recording will be enabled.
>>> + */
>>
>> Is this comment misplaced? It doesn't seem to have anything to do with
>> the macro being defined below.
> Agree, will put this in commit message.
>>
>>> @@ -458,6 +467,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>                  lbr_desc->records.nr = data;
>>>                  lbr_desc->arch_lbr_reset = true;
>>>                  return 0;
>>> +       case MSR_ARCH_LBR_CTL:
>>> +               if (data & ~KVM_ARCH_LBR_CTL_MASK)
>>
>> Is a static mask sufficient? Per the Intel® Architecture Instruction
>> Set Extensions and Future Features Programming Reference, some of
>> these bits may not be supported on all microarchitectures. See Table
>> 7-8. CPUID Leaf 01CH Enumeration of Architectural LBR Capabilities.
> Yes, more sanity checks are required, thanks!
> 
>>
>>> +                       break;
>>> +               vmcs_write64(GUEST_IA32_LBR_CTL, data);
>>> +               if (intel_pmu_lbr_is_enabled(vcpu) && !lbr_desc->event &&
>>> +                   (data & ARCH_LBR_CTL_LBREN))
>>> +                       intel_pmu_create_guest_lbr_event(vcpu);
>>
>> Nothing has to be done when the LBREN bit goes from 1 to 0?
> Need to release the event and reset related flag when the bit goes from
> 1 to 0. Thanks!

No need to release the LBR event and it will be lazily released.

>>
>>> +               return 0;
>>>          default:
>>>                  if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>>>                      (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
>>
>> Per the Intel® Architecture Instruction Set Extensions and Future
>> Features Programming Reference, "IA32_LBR_CTL.LBREn is saved and
>> cleared on #SMI, and restored on RSM." I don't see that happening
>> anywhere. That manual also says, "On a warm reset...IA32_LBR_CTL.LBREn
>> is cleared to 0, disabling LBRs." I don't see that happening either.
> 
> Yes, I'll add related code to make it consistent with spec, thanks!
>>
>> I have a question about section 7.1.4.4 in that manual. It says, "On a
>> debug breakpoint event (#DB), IA32_LBR_CTL.LBREn is cleared." When,
>> exactly, does that happen? In particular, if kvm synthesizes such an
>> event (for example, in kvm_vcpu_do_singlestep), does
>> IA32_LBR_CTL.LBREn automatically get cleared (after loading the guest
>> IA32_LBR_CTL value from the VMCS)? Or does kvm need to explicitly
>> clear that bit in the VMCS before injecting the #DB?
> OK, I don't have answer now, will ask the Arch to get clear answer on this,
> thanks for raising the question!

I think we also need a kvm-unit-tests to cover it (as well as the legacy 
LBR).

> 
