Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3DE46B0D26
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 16:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbjCHPnu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 10:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbjCHPn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 10:43:27 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A379F92723;
        Wed,  8 Mar 2023 07:42:25 -0800 (PST)
Received: from [192.168.2.24] (77-166-152-30.fixed.kpn.net [77.166.152.30])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0157520BBF92;
        Wed,  8 Mar 2023 07:42:04 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0157520BBF92
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1678290126;
        bh=zFYFwWuo+Y9TAr6dR2+IlULhrthw608V/1+z0YyYpdU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=NDsDPBY6Xgj+5a6Lg6mE1Gz5DnyeO49hu+svsM4CkiX5/NFRXKUXhiq8Z0zfnW+pm
         MmKpNJT0ZsmoDh3z6D+8SZXt1LnGAeHVurJ7RHPyXwNQ6vr5GAm/svD7mKmwNEf/EX
         PnjCNIsBtOpmjMv/hnpUibqpV9Ejc7QrJSlFK3yk=
Message-ID: <ef5f6c79-3c75-1bda-80d3-bb6d84cc27b2@linux.microsoft.com>
Date:   Wed, 8 Mar 2023 16:42:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] KVM: SVM: Disable TDP MMU when running on Hyper-V
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
References: <20230227171751.1211786-1-jpiotrowski@linux.microsoft.com>
 <87lek9zs05.fsf@redhat.com>
 <c6bb4b57-f134-d992-7f30-be80151fb67e@linux.microsoft.com>
 <87a60ozxga.fsf@redhat.com>
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <87a60ozxga.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/03/2023 11:07, Vitaly Kuznetsov wrote:
> Jeremi Piotrowski <jpiotrowski@linux.microsoft.com> writes:
> 
>> On 06/03/2023 18:52, Vitaly Kuznetsov wrote:
>>> Jeremi Piotrowski <jpiotrowski@linux.microsoft.com> writes:
>>>
>>>> TDP MMU has been broken on AMD CPUs when running on Hyper-V since v5.17.
>>>> The issue was first introduced by two commmits:
>>>>
>>>> - bb95dfb9e2dfbe6b3f5eb5e8a20e0259dadbe906 "KVM: x86/mmu: Defer TLB
>>>>   flush to caller when freeing TDP MMU shadow pages"
>>>> - efd995dae5eba57c5d28d6886a85298b390a4f07 "KVM: x86/mmu: Zap defunct
>>>>   roots via asynchronous worker"
>>>>
>>>> The root cause is that since then there are missing TLB flushes which
>>>> are required by HV_X64_NESTED_ENLIGHTENED_TLB.
>>>
>>> Please share more details on what's actually missing as you get them,
>>> I'd like to understand which flushes can be legally avoided on bare
>>> hardware and Hyper-V/VMX but not on Hyper-V/SVM.
>>>
>>
>> See the linked thread here
>> https://lore.kernel.org/lkml/20d189fc-8d20-8083-b448-460cc0420151@linux.microsoft.com/#t
>> for all the details/analyses but the summary was that either of these 2
>> options would work, with a) having less flushes (footnote: less flushes is not necessarily
>> better):
>>
>> a) adding a hyperv_flush_guest_mapping(__pa(root->spt) after kvm_tdp_mmu_get_vcpu_root_hpa's call to tdp_mmu_alloc_sp()
>> b) adding a hyperv_flush_guest_mapping(vcpu->arch.mmu->root.hpa) to svm_flush_tlb_current()
>>
>> These are only needed on Hyper-V/SVM because of how the enlightenment works (needs an explicit
>> flush to rebuild L0 shadow page tables). Hyper-V/VMX does not need any changes and currently
>> works. Let me know if you need more information on something here, I'll try to get it.
>>
> 
> Ah, I missed the whole party! Thanks for the pointers!
> 
>>>>  The failure manifests
>>>> as L2 guest VMs being unable to complete boot due to memory
>>>> inconsistencies between L1 and L2 guests which lead to various
>>>> assertion/emulation failures.
> 
> Which levels are we talking about here, *real* L1 and L2 or L1 and L2
> from KVM's perspective (real L2 and L3)?

Real L1 and L2. In this whole discussion L0 is Hyper-V, L1 is KVM and L2 is a Linux VM.

> 
>>>>
>>>> The HV_X64_NESTED_ENLIGHTENED_TLB enlightenment is always exposed by
>>>> Hyper-V on AMD and is always used by Linux. The TLB flush required by
>>>> HV_X64_NESTED_ENLIGHTENED_TLB is much stricter than the local TLB flush
>>>> that TDP MMU wants to issue. We have also found that with TDP MMU L2 guest
>>>> boot performance on AMD is reproducibly slower compared to when TDP MMU is
>>>> disabled.
>>>>
>>>> Disable TDP MMU when using SVM Hyper-V for the time being while we
>>>> search for a better fix.
>>>
>>> I'd suggest we go the other way around: disable
>>> HV_X64_NESTED_ENLIGHTENED_TLB on SVM:
>>
>> Paolo suggested disabling TDP_MMU when HV_X64_NESTED_ENLIGHTENED_TLB is used, and
>> I prefer that option too. The enlighenment does offer a nice performance advantage
>> with non-TDP_MMU, and I did not see TDP_MMU perform any better compared to that.
>> Afaik the code to use the enlightenment on Hyper-V/SVM was written/tested before
>> TDP_MMU became the default.
>>
>> If you have a specific scenario in mind, we could test and see what the implications
>> are there.
> 
> I don't have a strong opinion here, I've suggested a smaller change so
> it's easier to backport it to stable kernels and easier to revert when a
> proper fix comes to mainline.

Noted. My concern here is about changing a default in a way that lowers performance,
because the proper fix that comes later might end up not being suitable for stable.

> For performance implication, I'd only
> consider non-nested scenarios from KVM's perspective (i.e. real L2 from
> Hyper-V's PoV), as running L3 is unlikely a common use-case and, if I
> understood correctly, is broken anyway.

I agree with that. Right now L2 is broken, I've never even attempted L3 to
see if it would work.

Jeremi
