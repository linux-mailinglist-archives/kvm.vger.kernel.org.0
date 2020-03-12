Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3300A182F76
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 12:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgCLLm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 07:42:58 -0400
Received: from mga03.intel.com ([134.134.136.65]:19326 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgCLLm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 07:42:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 04:42:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,544,1574150400"; 
   d="scan'208";a="389577574"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.169.134]) ([10.249.169.134])
  by orsmga004.jf.intel.com with ESMTP; 12 Mar 2020 04:42:54 -0700
Subject: Re: [PATCH v2 3/6] kvm: x86: Emulate split-lock access as a write
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Laight <David.Laight@aculab.com>
References: <20200203151608.28053-1-xiaoyao.li@intel.com>
 <20200203151608.28053-4-xiaoyao.li@intel.com>
 <95d29a81-62d5-f5b6-0eb6-9d002c0bba23@redhat.com>
 <878sl945tj.fsf@nanos.tec.linutronix.de>
 <d690c2e3-e9ef-a504-ede3-d0059ec1e0f6@redhat.com>
 <20200227001117.GX9940@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <18333d32-9ec4-4aee-8c58-b2f44bb8e83d@intel.com>
Date:   Thu, 12 Mar 2020 19:42:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200227001117.GX9940@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/27/2020 8:11 AM, Sean Christopherson wrote:
> On Tue, Feb 11, 2020 at 02:34:18PM +0100, Paolo Bonzini wrote:
>> On 11/02/20 14:22, Thomas Gleixner wrote:
>>> Paolo Bonzini <pbonzini@redhat.com> writes:
>>>> On 03/02/20 16:16, Xiaoyao Li wrote:
>>>>> A sane guest should never tigger emulation on a split-lock access, but
>>>>> it cannot prevent malicous guest from doing this. So just emulating the
>>>>> access as a write if it's a split-lock access to avoid malicous guest
>>>>> polluting the kernel log.
>>>>
>>>> Saying that anything doing a split lock access is malicious makes little
>>>> sense.
>>>
>>> Correct, but we also have to accept, that split lock access can be used
>>> in a malicious way, aka. DoS.
>>
>> Indeed, a more accurate emulation such as temporarily disabling
>> split-lock detection in the emulator would allow the guest to use split
>> lock access as a vehicle for DoS, but that's not what the commit message
>> says.  If it were only about polluting the kernel log, there's
>> printk_ratelimited for that.  (In fact, if we went for incorrect
>> emulation as in this patch, a rate-limited pr_warn would be a good idea).
>>
>> It is much more convincing to say that since this is pretty much a
>> theoretical case, we can assume that it is only done with the purpose of
>> DoS-ing the host or something like that, and therefore we kill the guest.
> 
> The problem with "kill the guest", and the reason I'd prefer to emulate the
> split-lock as a write, is that killing the guest in this case is annoyingly
> difficult.
> 
> Returning X86EMUL_UNHANDLEABLE / EMULATION_FAILED gets KVM to
> handle_emulation_failure(), but handle_emulation_failure() will only "kill"
> the guest if emulation failed in L1 CPL==0.  For all other modes, it will
> inject a #UD and resume the guest.  KVM also injects a #UD for L1 CPL==0,
> but that's the least annoying thing.
> 
> Adding a new emulation type isn't an option because this code can be
> triggered through normal emulation.  A new return type could be added for
> split-lock, but that's code I'd really not add, both from an Intel
> perspective and a KVM maintenance perspective.  And, we'd still have the
> conundrum of what to do if/when split-lock #AC is exposed to L1, e.g. in
> that case, KVM should inject an #AC into L1, not kill the guest.  Again,
> totally doable, but ugly and IMO an unnecessary maintenance burden.
> 
> I completely agree that poorly emulating the instruction from the (likely)
> malicious guest is a hack, but it's a simple and easy to maintain hack.

Paolo,

What's your opinion about above?

>>>> Split lock detection is essentially a debugging feature, there's a
>>>> reason why the MSR is called "TEST_CTL".  So you don't want to make the
>>>
>>> The fact that it ended up in MSR_TEST_CTL does not say anything. That's
>>> where they it ended up to be as it was hastily cobbled together for
>>> whatever reason.
>>
>> Or perhaps it was there all the time in test silicon or something like
>> that...  That would be a very plausible reason for all the quirks behind it.
>>
>> Paolo
>>

