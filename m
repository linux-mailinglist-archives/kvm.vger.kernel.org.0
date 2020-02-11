Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8416D159157
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 15:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgBKODA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 09:03:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:1539 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728205AbgBKODA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 09:03:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 06:02:59 -0800
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="226511401"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.30.111]) ([10.255.30.111])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 11 Feb 2020 06:02:56 -0800
Subject: Re: [PATCH v2 3/6] kvm: x86: Emulate split-lock access as a write
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Laight <David.Laight@aculab.com>
References: <20200203151608.28053-1-xiaoyao.li@intel.com>
 <20200203151608.28053-4-xiaoyao.li@intel.com>
 <95d29a81-62d5-f5b6-0eb6-9d002c0bba23@redhat.com>
 <878sl945tj.fsf@nanos.tec.linutronix.de>
 <d690c2e3-e9ef-a504-ede3-d0059ec1e0f6@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <f6d37da1-ce56-7a11-63d8-32126b76094a@intel.com>
Date:   Tue, 11 Feb 2020 22:02:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <d690c2e3-e9ef-a504-ede3-d0059ec1e0f6@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/11/2020 9:34 PM, Paolo Bonzini wrote:
> On 11/02/20 14:22, Thomas Gleixner wrote:
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>>> On 03/02/20 16:16, Xiaoyao Li wrote:
>>>> A sane guest should never tigger emulation on a split-lock access, but
>>>> it cannot prevent malicous guest from doing this. So just emulating the
>>>> access as a write if it's a split-lock access to avoid malicous guest
>>>> polluting the kernel log.
>>>
>>> Saying that anything doing a split lock access is malicious makes little
>>> sense.
>>
>> Correct, but we also have to accept, that split lock access can be used
>> in a malicious way, aka. DoS.
> 
> Indeed, a more accurate emulation such as temporarily disabling
> split-lock detection in the emulator would allow the guest to use split
> lock access as a vehicle for DoS, but that's not what the commit message
> says.  If it were only about polluting the kernel log, there's
> printk_ratelimited for that.  (In fact, if we went for incorrect
> emulation as in this patch, a rate-limited pr_warn would be a good idea).
> 
> It is much more convincing to say that since this is pretty much a
> theoretical case, we can assume that it is only done with the purpose of
> DoS-ing the host or something like that, and therefore we kill the guest.

So you think there is no need to emulate this feature and return #AC to 
guest?
Anyway, I'm fine with killing the guest.

BTW, Can it really be used for DoS purpose by malicious guest? Since 
it's in kvm emulator so it needs vm-exit first and won't the die() in 
kernel handler kill KVM? (Actually I'm not clear about KVM after die())

>>> Split lock detection is essentially a debugging feature, there's a
>>> reason why the MSR is called "TEST_CTL".  So you don't want to make the
>>
>> The fact that it ended up in MSR_TEST_CTL does not say anything. That's
>> where they it ended up to be as it was hastily cobbled together for
>> whatever reason.
> 
> Or perhaps it was there all the time in test silicon or something like
> that...  That would be a very plausible reason for all the quirks behind it.

Alright, I don't know the history of TEST_CTRL, there is a bit 31 in it 
which means "Disable LOCK# assertion for split locked access" when set. 
Bit 31 exists for a long period, but linux seems not use it so I guess 
it may be a testing purpose bit.

However, when it comes to bit 29, split lock #AC, the main purpose is to 
prevent any split lock more than debugging.

BTW, I guess the reason putting it in MSR_TEST_CTRL is that it's related 
with split lock as bit 31.

> Paolo
> 

