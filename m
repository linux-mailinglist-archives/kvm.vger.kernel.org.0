Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC502399776
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 03:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhFCB1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 21:27:05 -0400
Received: from mga18.intel.com ([134.134.136.126]:16794 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhFCB1E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 21:27:04 -0400
IronPort-SDR: c/i0DtMEZICzfIDIZeTG4Z5/AljjBq2dRvJ7yKpDH6eNnBf/NbIvszPjPxAPICLnep1ADWsNw3
 yTVebuqQ5UNA==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="191287111"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="191287111"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 18:25:10 -0700
IronPort-SDR: GzFnOV0xuKvubgNc9nKrMecQfXWCNkT2Aa1OE6Z+VwQEqi+EKCBa4W2YWKvILsTaeXApsa0xTV
 XpePRiqm1tnw==
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="446064971"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.254.212.10]) ([10.254.212.10])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 18:25:05 -0700
Subject: Re: [PATCH v2] KVM: VMX: Enable Notify VM exit
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, Tao Xu <tao3.xu@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
References: <20210525051204.1480610-1-tao3.xu@intel.com>
 <871r9k36ds.fsf@vitty.brq.redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <660ceed2-7569-6ce6-627a-9a4e860b8aa9@intel.com>
Date:   Thu, 3 Jun 2021 09:25:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <871r9k36ds.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/2021 6:31 PM, Vitaly Kuznetsov wrote:
> Tao Xu <tao3.xu@intel.com> writes:
> 
>> There are some cases that malicious virtual machines can cause CPU stuck
>> (event windows don't open up), e.g., infinite loop in microcode when
>> nested #AC (CVE-2015-5307). No event window obviously means no events,
>> e.g. NMIs, SMIs, and IRQs will all be blocked, may cause the related
>> hardware CPU can't be used by host or other VM.
>>
>> To resolve those cases, it can enable a notify VM exit if no event
>> window occur in VMX non-root mode for a specified amount of time
>> (notify window). Since CPU is first observed the risk of not causing
>> forward progress, after notify window time in a units of crystal clock,
>> Notify VM exit will happen. Notify VM exit can happen incident to delivery
>> of a vectored event.
>>
>> Expose a module param for configuring notify window, which is in unit of
>> crystal clock cycle.
>> - A negative value (e.g. -1) is to disable this feature.
>> - Make the default as 0. It is safe because an internal threshold is added
>> to notify window to ensure all the normal instructions being coverd.
>> - User can set it to a large value when they want to give more cycles to
>> wait for some reasons, e.g., silicon wrongly kill some normal instruction
>> due to internal threshold is too small.
>>
>> Notify VM exit is defined in latest Intel Architecture Instruction Set
>> Extensions Programming Reference, chapter 9.2.
>>
>> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Tao Xu <tao3.xu@intel.com>
>> ---
>>
>> Changelog:
>> v2:
>>       Default set notify window to 0, less than 0 to disable.
>>       Add more description in commit message.
> 
> Sorry if this was already discussed, but in case of nested
> virtualization and when L1 also enables
> SECONDARY_EXEC_NOTIFY_VM_EXITING, shouldn't we just reflect NOTIFY exits
> during L2 execution to L1 instead of crashing the whole L1?
> 

yes. If we expose it to nested, it should reflect the Notify VM exit to 
L1 when L1 enables it.

But regarding nested, there are more things need to be discussed. e.g.,
1) It has dependence between L0 and L1, for security consideration. When 
L0 enables it, it shouldn't be turned off during L2 VM is running.
    a. Don't expose to L1 but enable for L1 when L2 VM is running.
    b. expose it to L1 and force it enabled.

2) When expose it to L1, vmcs02.notify_window needs to be 
min(L0.notify_window, L1.nofity_window)

We don't deal with nested to make this Patch simple.

