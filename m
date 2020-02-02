Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 228F514FB68
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2020 05:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgBBEd2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 23:33:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:32950 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726794AbgBBEd2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 23:33:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 20:33:26 -0800
X-IronPort-AV: E=Sophos;i="5.70,391,1574150400"; 
   d="scan'208";a="223572210"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.174.29]) ([10.249.174.29])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 01 Feb 2020 20:33:24 -0800
Subject: Re: [PATCH 2/2] KVM: VMX: Extend VMX's #AC handding
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <b2e2310d-2228-45c2-8174-048e18a46bb6@intel.com>
 <A2622E15-756D-434D-AF64-4F67781C0A74@amacapital.net>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <0fe84cd6-dac0-2241-59e5-84cb83b7c42b@intel.com>
Date:   Sun, 2 Feb 2020 12:33:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <A2622E15-756D-434D-AF64-4F67781C0A74@amacapital.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/2/2020 1:56 AM, Andy Lutomirski wrote:
> 
> 
>> On Feb 1, 2020, at 8:58 AM, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>
>> ﻿On 2/1/2020 5:33 AM, Andy Lutomirski wrote:
>>>>> On Jan 31, 2020, at 1:04 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
>>>>
>>>> ﻿On Fri, Jan 31, 2020 at 12:57:51PM -0800, Andy Lutomirski wrote:
>>>>>
>>>>>>> On Jan 31, 2020, at 12:18 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
>>>>>>
>>>>>> This is essentially what I proposed a while back.  KVM would allow enabling
>>>>>> split-lock #AC in the guest if and only if SMT is disabled or the enable bit
>>>>>> is per-thread, *or* the host is in "warn" mode (can live with split-lock #AC
>>>>>> being randomly disabled/enabled) and userspace has communicated to KVM that
>>>>>> it is pinning vCPUs.
>>>>>
>>>>> How about covering the actual sensible case: host is set to fatal?  In this
>>>>> mode, the guest gets split lock detection whether it wants it or not. How do
>>>>> we communicate this to the guest?
>>>>
>>>> KVM doesn't advertise split-lock #AC to the guest and returns -EFAULT to the
>>>> userspace VMM if the guest triggers a split-lock #AC.
>>>>
>>>> Effectively the same behavior as any other userspace process, just that KVM
>>>> explicitly returns -EFAULT instead of the process getting a SIGBUS.
>>> Which helps how if the guest is actually SLD-aware?
>>> I suppose we could make the argument that, if an SLD-aware guest gets #AC at CPL0, it’s a bug, but it still seems rather nicer to forward the #AC to the guest instead of summarily killing it.
>>
>> If KVM does advertise split-lock detection to the guest, then kvm/host can know whether a guest is SLD-aware by checking guest's MSR_TEST_CTRL.SPLIT_LOCK_DETECT bit.
>>
>> - If guest's MSR_TEST_CTRL.SPLIT_LOCK_DETECT is set, it indicates guest is SLD-aware so KVM forwards #AC to guest.
>>
> 
> I disagree. If you advertise split-lock detection with the current core capability bit, it should *work*.  And it won’t.  The choices you’re actually giving the guest are:
> 
> a) Guest understands SLD and wants it on.  The guest gets the same behavior as in bare metal.
> 
> b) Guest does not understand. Guest gets killed if it screws up as described below.
> 
>> - If not set. It may be a old guest or a malicious guest or a guest without SLD support, and we cannot figure it out. So we have to kill the guest when host is SLD-fatal, and let guest survive when SLD-WARN for old sane buggy guest.
> 
> All true, but the result of running a Linux guest in SLD-warn mode will be broken.
> 
>>
>> In a word, all the above is on the condition that KVM advertise split-lock detection to guest. But this patch doesn't do this. Maybe I should add that part in v2.
> 
> I think you should think the details all the way through, and I think you’re likely to determine that the Intel architecture team needs to do *something* to clean up this mess.
> 
> There are two independent problems here.  First, SLD *can’t* be virtualized sanely because it’s per-core not per-thread.

Sadly, it's the fact we cannot change. So it's better virtualized only 
when SMT is disabled to make thing simple.

> Second, most users *won’t want* to virtualize it correctly even if they could: if a guest is allowed to do split locks, it can DoS the system.

To avoid DoS attack, it must use sld_fatal mode. In this case, guest are 
forbidden to do split locks.

> So I think there should be an architectural way to tell a guest that SLD is on whether it likes it or not. And the guest, if booted with sld=warn, can print a message saying “haha, actually SLD is fatal” and carry on.

OK. Let me sort it out.

If SMT is disabled/unsupported, so KVM advertises SLD feature to guest. 
below are all the case:

-----------------------------------------------------------------------
Host	Guest	Guest behavior
-----------------------------------------------------------------------
1. off		same as in bare metal
-----------------------------------------------------------------------	
2. warn	off	allow guest do split lock (for old guest):
		hardware bit set initially, once split lock
		happens, clear hardware bit when vcpu is running
		So, it's the same as in bare metal
	
3.	warn	1. user space: get #AC, then clear MSR bit, but
		   hardware bit is not cleared, #AC again, finally
		   clear hardware bit when vcpu is running.
		   So it's somehow the same as in bare-metal

		2. kernel: same as in bare metal.
	
4.	fatal	same as in bare metal
----------------------------------------------------------------------
5.fatal	off	guest is killed when split lock,
		or forward #AC to guest, this way guest gets an
		unexpected #AC
	
6.	warn	1. user space: get #AC, then clear MSR bit, but
		   hardware bit is not cleared, #AC again,
		   finally guest is killed, or KVM forwards #AC
		   to guest then guest gets an unexpected #AC.
		2. kernel: same as in bare metal, call die();
	
7.	fatal	same as in bare metal
----------------------------------------------------------------------

Based on the table above, if we want guest has same behavior as in bare 
metal, we can set host to sld_warn mode.
If we want prevent DoS from guest, we should set host to sld_fatal mode.


Now, let's analysis what if there is an architectural way to tell a 
guest that SLD is forced on. Assume it's a SLD_forced_on cpuid bit.

- Host is sld_off, SLD_forced_on cpuid bit is not set, no change for
   case #1

- Host is sld_fatal, SLD_forced_on cpuid bit must be set:
	- if guest is SLD-aware, guest is supposed to only use fatal
	  mode that goes to case #7. And guest is not recommended
	  using warn mode. if guest persists, it goes to case #6

	- if guest is not SLD-aware, maybe it's an old guest or it's a
	  malicious guest that pretends not SLD-aware, it goes to
	  case #5.

- Host is sld_warn, we have two choice
	- set SLD_forced_on cpuid bit, it's the same as host is fatal.
	- not set SLD_force_on_cpuid bit, it's the same as case #2,#3,#4

So I think introducing an architectural way to tell a guest that SLD is 
forced on can make the only difference is that, there is a way to tell 
guest not to use warn mode, thus eliminating case #6.

If you think it really matters, I can forward this requirement to our 
Intel architecture people.
>>
>>> ISTM, on an SLD-fatal host with an SLD-aware guest, the host should tell the guest “hey, you may not do split locks — SLD is forced on” and the guest should somehow acknowledge it so that it sees the architectural behavior instead of something we made up.  Hence my suggestion.
>>

