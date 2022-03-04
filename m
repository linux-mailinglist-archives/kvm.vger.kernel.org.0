Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FB84CD116
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237128AbiCDJev (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237101AbiCDJes (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:34:48 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA7C7307E;
        Fri,  4 Mar 2022 01:34:00 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 195so7052047pgc.6;
        Fri, 04 Mar 2022 01:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=7kG/4jNg30O3RBzSCq3xXYHo00QAqmedsNutACfp6hA=;
        b=CcIHm4K4/7KEooDqN9Z59x66bZcRdW9yFagz6fG35MvcU3uIcQMHS2WqCuSPpR+tyH
         yonLKU056gXGAP1bQBAh3nq5P88Na4x24Y1N9k8zOgl4/m1wro093TLIb/89rHt3oHNB
         YTZ0c0fjFivHq5IyCYW0NLZP5vJUF84PMFWcSFvhepozjdL1e40dRkdrK5316JGZXW6W
         5ReMM1FsYYcxyHRa4jf5m8jX/ajvnm8tNEFi1QVtyCCqZ5XvD675pFrNnNaxHzetQvMW
         sOW4X0QepNKRoNs9UO4iYGZ2cZPX86ThcKm3iuUnYhAYa6gx85uZXFvC7WcG9ZRvTjfa
         h7xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=7kG/4jNg30O3RBzSCq3xXYHo00QAqmedsNutACfp6hA=;
        b=3FgVW4Ry/13DgGp4g9n2cASXhKw/2kc2gjUQdG/3cUZPl+zZSqRjiySbr74OHCIn05
         S5pzg4esbKWg95NEVBzWZVloDBDsEgWUADLVqi9xsL1RxdgOxpVlXX/MYvIpNDIv0ums
         6TDQl078ik6o3aHl/9U9ryDEy79FZtDhb+o2pX2tHGDIL60BNc3pZcBrw7NfvMKL0LrH
         YMop9uY85jHaXhu2iAxtP9o0UUOsPCEre2NZUn8sPhFw8NWZlRpKh98fnOpYWdtTyAkG
         7QnYliVcThcvcW69vaw/W3C+vjKBgerKxGl1R2JfWsqOPq9AViwfM6Z/QOyP8j0bscfc
         9dCg==
X-Gm-Message-State: AOAM5333jB91oiCbq93MQ7/w2Ucg6bxZswdhIXtPnI7NLJqQM3hlhW3H
        KekYYhkww8NLOoWbzy1Cnvk=
X-Google-Smtp-Source: ABdhPJzbawIwb3kOA+tmlRwyGrpSUS7I14fMVPrdV7vkHpvdc/hE0DAELR6bAeFuA5vUS/Mx2l6s2g==
X-Received: by 2002:a65:6941:0:b0:372:b6bc:4328 with SMTP id w1-20020a656941000000b00372b6bc4328mr33897838pgq.106.1646386439515;
        Fri, 04 Mar 2022 01:33:59 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id g7-20020a056a000b8700b004e1bed5c3bfsm5179790pfj.68.2022.03.04.01.33.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 01:33:59 -0800 (PST)
Message-ID: <e1dd4d82-b5d8-fdae-325b-75ba690eaf2e@gmail.com>
Date:   Fri, 4 Mar 2022 17:33:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH 3/3] KVM: x86/pmu: Segregate Intel and AMD specific logic
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Cc:     seanjc@google.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, alexander.shishkin@linux.intel.com,
        eranian@google.com, daviddunn@google.com, ak@linux.intel.com,
        kan.liang@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kim.phillips@amd.com,
        santosh.shukla@amd.com,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>
References: <20220221073140.10618-1-ravi.bangoria@amd.com>
 <20220221073140.10618-4-ravi.bangoria@amd.com>
 <1e0fc70a-1135-1845-b534-79f409e0c29d@gmail.com>
 <80fce7df-d387-773d-ad7d-3540c2d411d1@amd.com>
 <CALMp9eQtW6SWG83rJa0jKt7ciHPiRbvEyCi2CDNkQ-FJC+ZLjA@mail.gmail.com>
 <54d94539-a14f-49d7-e4f3-092f76045b33@amd.com>
 <CALMp9eTTpdtsEek17-EnSZu53-+LmwcSTYmou1+u34LdT3TMmQ@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <CALMp9eTTpdtsEek17-EnSZu53-+LmwcSTYmou1+u34LdT3TMmQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/3/2022 2:05 am, Jim Mattson wrote:
> On Thu, Mar 3, 2022 at 8:25 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>
>>
>>
>> On 03-Mar-22 10:08 AM, Jim Mattson wrote:
>>> On Mon, Feb 21, 2022 at 2:02 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>>>
>>>>
>>>>
>>>> On 21-Feb-22 1:27 PM, Like Xu wrote:
>>>>> On 21/2/2022 3:31 pm, Ravi Bangoria wrote:
>>>>>>    void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
>>>>>>    {
>>>>>>        struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, pmc_idx);
>>>>>> +    bool is_intel = !strncmp(kvm_x86_ops.name, "kvm_intel", 9);
>>>>>
>>>>> How about using guest_cpuid_is_intel(vcpu)
>>>>
>>>> Yeah, that's better then strncmp().
>>>>
>>>>> directly in the reprogram_gp_counter() ?
>>>>
>>>> We need this flag in reprogram_fixed_counter() as well.
>>>
>>> Explicit "is_intel" checks in any form seem clumsy,
>>
>> Indeed. However introducing arch specific callback for such tiny
>> logic seemed overkill to me. So thought to just do it this way.
> 
> I agree that arch-specific callbacks are ridiculous for these distinctions.
> 
>>> since we have
>>> already put some effort into abstracting away the implementation
>>> differences in struct kvm_pmu. It seems like these differences could
>>> be handled by adding three masks to that structure: the "raw event
>>> mask" (i.e. event selector and unit mask), the hsw_in_tx mask, and the
>>> hsw_in_tx_checkpointed mask.
>>
>> struct kvm_pmu is arch independent. You mean struct kvm_pmu_ops?
> 
> No; I meant exactly what I said. See, for example, how the
> reserved_bits field is used. It is initialized in the vendor-specific
> pmu_refresh functions, and from then on, it facilitates
> vendor-specific behaviors without explicit checks or vendor-specific
> callbacks. An eventsel_mask field would be a natural addition to this
> structure, to deal with the vendor-specific event selector widths. The
> hsw_in_tx_mask and hsw_in_tx_checkpointed_mask fields are less
> natural, since they will be 0 on AMD, but they would make it simple to
> write the corresponding code in a vendor-neutral fashion.
> 
> BTW, am I the only one who finds the HSW_ prefixes a bit absurd here,
> since TSX was never functional on Haswell?

The TSX story has more twists and turns, but we may start with 3a632cb229bf.

> 
>>>
>>> These changes should also be coordinated with Like's series that
>>> eliminates all of the PERF_TYPE_HARDWARE nonsense.
>>
>> I'll rebase this on Like's patch series.

I could take over 3nd patch w/ Co-developed-by and move on if Ravi agrees.

> 
> That's not exactly what I meant, but okay.
