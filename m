Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06AE39D8A1
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 11:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhFGJZg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 05:25:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:8583 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230200AbhFGJZd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 05:25:33 -0400
IronPort-SDR: mycNHMkTkL3f/NEEZ+18acCX3/ICXUwHWRaOw7MYchcsEnfGw4vxFw1+QRgf7KDRPtCx8fua7u
 Z8F/B7BZi7hw==
X-IronPort-AV: E=McAfee;i="6200,9189,10007"; a="204559400"
X-IronPort-AV: E=Sophos;i="5.83,254,1616482800"; 
   d="scan'208";a="204559400"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 02:23:41 -0700
IronPort-SDR: mn3a0b9mDoaeFl4s5SQNEFzCDKBns5YRj+j+JGoMv4y+RAOe6sJxxB1vD+023HCJsxRIwRkDE+
 M3eiwjvVk06Q==
X-IronPort-AV: E=Sophos;i="5.83,254,1616482800"; 
   d="scan'208";a="447423811"
Received: from yujie-nuc.sh.intel.com (HELO [10.239.13.110]) ([10.239.13.110])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 02:23:37 -0700
Subject: Re: [PATCH v2] KVM: VMX: Enable Notify VM exit
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, Tao Xu <tao3.xu@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
References: <20210525051204.1480610-1-tao3.xu@intel.com>
 <871r9k36ds.fsf@vitty.brq.redhat.com>
 <660ceed2-7569-6ce6-627a-9a4e860b8aa9@intel.com>
 <87fsxz12e9.fsf@vitty.brq.redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <75336195-8360-656e-c6a2-dda9ed152029@intel.com>
Date:   Mon, 7 Jun 2021 17:23:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87fsxz12e9.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/3/2021 9:52 PM, Vitaly Kuznetsov wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> On 6/2/2021 6:31 PM, Vitaly Kuznetsov wrote:
>>> Tao Xu <tao3.xu@intel.com> writes:
>>>
>>>> There are some cases that malicious virtual machines can cause CPU stuck
>>>> (event windows don't open up), e.g., infinite loop in microcode when
>>>> nested #AC (CVE-2015-5307). No event window obviously means no events,
>>>> e.g. NMIs, SMIs, and IRQs will all be blocked, may cause the related
>>>> hardware CPU can't be used by host or other VM.
>>>>
>>>> To resolve those cases, it can enable a notify VM exit if no event
>>>> window occur in VMX non-root mode for a specified amount of time
>>>> (notify window). Since CPU is first observed the risk of not causing
>>>> forward progress, after notify window time in a units of crystal clock,
>>>> Notify VM exit will happen. Notify VM exit can happen incident to delivery
>>>> of a vectored event.
>>>>
>>>> Expose a module param for configuring notify window, which is in unit of
>>>> crystal clock cycle.
>>>> - A negative value (e.g. -1) is to disable this feature.
>>>> - Make the default as 0. It is safe because an internal threshold is added
>>>> to notify window to ensure all the normal instructions being coverd.
>>>> - User can set it to a large value when they want to give more cycles to
>>>> wait for some reasons, e.g., silicon wrongly kill some normal instruction
>>>> due to internal threshold is too small.
>>>>
>>>> Notify VM exit is defined in latest Intel Architecture Instruction Set
>>>> Extensions Programming Reference, chapter 9.2.
>>>>
>>>> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> Signed-off-by: Tao Xu <tao3.xu@intel.com>
>>>> ---
>>>>
>>>> Changelog:
>>>> v2:
>>>>        Default set notify window to 0, less than 0 to disable.
>>>>        Add more description in commit message.
>>>
>>> Sorry if this was already discussed, but in case of nested
>>> virtualization and when L1 also enables
>>> SECONDARY_EXEC_NOTIFY_VM_EXITING, shouldn't we just reflect NOTIFY exits
>>> during L2 execution to L1 instead of crashing the whole L1?
>>>
>>
>> yes. If we expose it to nested, it should reflect the Notify VM exit to
>> L1 when L1 enables it.
>>
>> But regarding nested, there are more things need to be discussed. e.g.,
>> 1) It has dependence between L0 and L1, for security consideration. When
>> L0 enables it, it shouldn't be turned off during L2 VM is running.
>>      a. Don't expose to L1 but enable for L1 when L2 VM is running.
>>      b. expose it to L1 and force it enabled.
> 
> Could you please elaborate on the 'security' concern? 

I mean the case that if we expose this feature to L1 VMM, L1 VMM cannot 
en/dis-able this feature on its own purpose when L0 turns it on.

i.e., vmcs02.settings has to be (L0's | L1's)

otherwise L1 guest can escape by creating an nested guest and disabling it.

> My understanding
> that during L2 execution:
> If L0 enables the feature and L1 doesn't, vmexit goes to L0.
> If L1 enables the feature and L0 doesn't, vmexit goes to L1.

> If both L0 and L1 enable the feature, vmexit can probably (I didn't put
> enough though in it I'm afraid) go to the one which has smaller window.

It sounds reasonable.

>>
>> 2) When expose it to L1, vmcs02.notify_window needs to be
>> min(L0.notify_window, L1.nofity_window)
>>
>> We don't deal with nested to make this Patch simple.
> 
> Sure, I just wanted to check with you what's the future plan and if the
> behavior you introduce is desireable in nested case.
> 

