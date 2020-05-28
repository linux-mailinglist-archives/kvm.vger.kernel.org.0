Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145231E67FB
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 19:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405221AbgE1Q76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 12:59:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:7797 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405172AbgE1Q75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 12:59:57 -0400
IronPort-SDR: VFl719Le3/YhyYKHTMmnWaBvNaSwjTN0lHPp8Gk8j+wcc9KhY7Bzugjq//MOp+3BotJcwK6n0i
 T/XNviqU+44A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 09:59:56 -0700
IronPort-SDR: /SJhqbZYThfntgjSQvaZupZa5nrhFNdOhLATo7BmrAKyoxHMV6BL71I46xS//OFGhtL3pk1z3l
 LkmLgy1iM/xw==
X-IronPort-AV: E=Sophos;i="5.73,445,1583222400"; 
   d="scan'208";a="267279706"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.174.96]) ([10.249.174.96])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 09:59:54 -0700
Subject: Re: [PATCH] KVM: X86: Call kvm_x86_ops.cpuid_update() after CPUIDs
 fully updated
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20200528151927.14346-1-xiaoyao.li@intel.com>
 <b639a333-d7fe-74fd-ee11-6daede184676@redhat.com>
 <1f45de43-af43-24da-b7d3-00b9d2bd517c@intel.com>
 <5d8bc1da-f866-4741-7746-1fa2a3cfbafd@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <54497675-2b35-b351-4259-8eb819daca87@intel.com>
Date:   Fri, 29 May 2020 00:59:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <5d8bc1da-f866-4741-7746-1fa2a3cfbafd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/29/2020 12:15 AM, Paolo Bonzini wrote:
> On 28/05/20 17:40, Xiaoyao Li wrote:
>>>
>>>> kvm_x86_ops.cpuid_update() is used to update vmx/svm settings based on
>>>> updated CPUID settings. So it's supposed to be called after CPUIDs are
>>>> fully updated, not in the middle stage.
>>>>
>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>
>>> Are you seeing anything bad happening from this?
>>
>> Not yet.
>>
>> IMO changing the order is more reasonable and less confusing.
> 
> Indeed, I just could not decide whether to include it in 5.7 or not.

Maybe for 5.8

I have a new idea to refactor a bit more that I find it does three 
things in kvm_update_cpuid():
- update cpuid;
- update vcpu states, e.g., apic->lapic_timer.timer_mode_mask, 
guest_supported_xcr0, maxphyaddr, ... etc,
- cpuid check, for vaddr_bits

I'm going to split it, and make the order as:
1. kvm_check_cpuid(), if invalid value return error;
2. kvm_update_cpuid();
3. kvm_update_state_based_on_cpuid();
    and kvm_x86_ops.kvm_x86_ops.cpuid_update() can be called inside it.

If you feel OK, I'll do it tomorrow.

-Xiaoyao


