Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0B14193553
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 02:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbgCZBiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 21:38:46 -0400
Received: from mga17.intel.com ([192.55.52.151]:42384 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727561AbgCZBiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 21:38:46 -0400
IronPort-SDR: hVYXu+B8pvcrPbErHIAb/hpmYS5oT0SN5pQLUHIeVyxuXmOJColcyQvTejsHa6HDKdBxfvNaIo
 7HekWrORtsJA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 18:38:45 -0700
IronPort-SDR: 7DWvfRxUQreA/Q190eIf2b298X/vwaLYWTHwRHmUZRBTDuK3nyIC21DKuWhuVc0/TfSBBsvIg2
 Kaze8U5kT1PQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,306,1580803200"; 
   d="scan'208";a="393813500"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.169.99]) ([10.249.169.99])
  by orsmga004.jf.intel.com with ESMTP; 25 Mar 2020 18:38:41 -0700
Subject: Re: [PATCH v6 8/8] kvm: vmx: virtualize split lock detection
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>
References: <20200324151859.31068-1-xiaoyao.li@intel.com>
 <20200324151859.31068-9-xiaoyao.li@intel.com>
 <87eethz2p6.fsf@nanos.tec.linutronix.de>
 <6d3e7e03-d304-8ec0-b00d-050b1c12140d@intel.com>
 <87369xyzvk.fsf@nanos.tec.linutronix.de>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <9a9c0817-9ebb-524f-44df-176a15ea3fca@intel.com>
Date:   Thu, 26 Mar 2020 09:38:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87369xyzvk.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/25/2020 9:41 AM, Thomas Gleixner wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>> On 3/25/2020 8:40 AM, Thomas Gleixner wrote:
>>>>    		if (!split_lock_detect_on() ||
>>>> +		    guest_cpu_split_lock_detect_on(vmx) ||
>>>>    		    guest_cpu_alignment_check_enabled(vcpu)) {
>>>
>>> If the host has split lock detection disabled then how is the guest
>>> supposed to have it enabled in the first place?
>>
>> So we need to reach an agreement on whether we need a state that host
>> turns it off but feature is available to be exposed to guest.
> 
> There is a very simple agreement:
> 
>    If the host turns it off, then it is not available at all
> 
>    If the host sets 'warn' then this applies to everything
> 
>    If the host sets 'fatal' then this applies to everything
> 
> Make it simple and consistent.

OK. you are the boss.

>>>> +	if (static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
>>>> +	    guest_cpu_split_lock_detect_on(vmx)) {
>>>> +		if (test_thread_flag(TIF_SLD))
>>>> +			sld_turn_back_on();
>>>
>>> This is completely inconsistent behaviour. The only way that TIF_SLD is
>>> set is when the host has sld_state == sld_warn and the guest triggered
>>> a split lock #AC.
>>
>> Can you image the case that both host and guest set sld_state == sld_warn.
>>
>> 1. There is guest userspace thread causing split lock.
>> 2. It sets TIF_SLD for the thread in guest, and clears SLD bit to re-
>> execute the instruction in guest.
>> 3. Then it still causes #AC since hardware SLD is not cleared. In host
>> kvm, we call handle_user_split_lock() that sets TIF_SLD for this VMM
>> thread, and clears hardware SLD bit. Then it enters guest and re-execute
>> the instruction.
>> 4. In guest, it schedules to another thread without TIF_SLD being set.
>> it sets the SLD bit to detect the split lock for this thread. So for
>> this purpose, we need to turn sld back on for the VMM thread, otherwise
>> this guest vcpu cannot catch split lock any more.
> 
> If you really want to address that scenario, then why are you needing
> any of those completely backwards interfaces at all?
> 
> Just because your KVM exception trap uses the host handling function
> which sets TIF_SLD?
>   

Yes. just because KVM use the host handling function.

If you disallow me to touch codes out of kvm. It can be achieved with 
something like in v2:
https://lore.kernel.org/kvm/20200203151608.28053-1-xiaoyao.li@intel.com/

Obviously re-use TIF_SLD flag to automatically switch MSR_TEST_CTRL.SLD 
bit when switch to/from vcpu thread is better.

And to virtualize SLD feature as full as possible for guest, we have to 
implement the backwards interface. If you really don't want that 
interface, we have to write code directly in kvm to modify TIF_SLD flag 
and MSR_TEST_CTRL.SLD bit.

