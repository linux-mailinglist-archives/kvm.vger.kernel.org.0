Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7CC193EE7
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 13:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgCZMbI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 08:31:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:6386 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbgCZMbI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 08:31:08 -0400
IronPort-SDR: ZDQ2yhZQoVR6KXNxrCYdoy7UCoBFhUb1D0B4gJP6AieXNINZmf1UyLpKCmBjrxJpRTPmZRaT3U
 KfvqEpvMzl5A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 05:31:07 -0700
IronPort-SDR: M0eluSJxi6tTW9ks2Pqo9TVinitoaYBsw8Oc/9X+yqaAbFMAuBK2e+EvjkiIaeAahwOIOqF/iu
 EmgEy2tyfRIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,308,1580803200"; 
   d="scan'208";a="393965216"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.169.99]) ([10.249.169.99])
  by orsmga004.jf.intel.com with ESMTP; 26 Mar 2020 05:31:02 -0700
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
 <9a9c0817-9ebb-524f-44df-176a15ea3fca@intel.com>
 <87ftdvxtjh.fsf@nanos.tec.linutronix.de>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <24bf6735-ce80-0c4a-ed67-946aefc7a5f9@intel.com>
Date:   Thu, 26 Mar 2020 20:31:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87ftdvxtjh.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/26/2020 7:08 PM, Thomas Gleixner wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>> On 3/25/2020 9:41 AM, Thomas Gleixner wrote:
>>> If you really want to address that scenario, then why are you needing
>>> any of those completely backwards interfaces at all?
>>>
>>> Just because your KVM exception trap uses the host handling function
>>> which sets TIF_SLD?
>>>    
>> Yes. just because KVM use the host handling function.
> 
>> If you disallow me to touch codes out of kvm. It can be achieved with
> 
> Who said you cannot touch code outside of KVM?
> 
>> Obviously re-use TIF_SLD flag to automatically switch MSR_TEST_CTRL.SLD
>> bit when switch to/from vcpu thread is better.
> 
> What's better about that?
> 
> TIF_SLD has very well defined semantics. It's used to denote that the
> SLD bit needs to be cleared for the task when its scheduled in.
> 
> So now you overload it by clearing it magically and claim that this is
> better.
> 
> vCPU-thread
> 
>     user space (qemu)
>       triggers #AC
>         -> exception
>             set TIF_SLD
> 
>     iotctl()
>       vcpu_run()
>         -> clear TIF_SLD
> 
> It's not better, it's simply wrong and inconsistent.
> 
>> And to virtualize SLD feature as full as possible for guest, we have to
>> implement the backwards interface. If you really don't want that
>> interface, we have to write code directly in kvm to modify TIF_SLD flag
>> and MSR_TEST_CTRL.SLD bit.
> 
> Wrong again. KVM has absolutely no business in fiddling with TIF_SLD and
> the function to flip the SLD bit is simply sld_update_msr(bool on) which
> does not need any KVMism at all.
> 
> There are two options to handle SLD for KVM:
> 
>     1) Follow strictly the host rules
> 
>        If user space or guest triggered #AC then TIF_SLD is set and that
>        task is excluded from ever setting SLD again.

Obviously, it's not about to virtualize SLD for guest. So we don't pick 
this one.

>     2) Track KVM guest state separately
> 
>        vcpu_run()
>          if (current_has(TIF_SLD) && guest_sld_on())
>            sld_update_msr(true);
>          else if (!current_has(TIF_SLD) && !guest_sld_on())
>            sld_update_msr(false);
>          vmenter()
>            ....
>          vmexit()
>          if (current_has(TIF_SLD) && guest_sld_on())
>            sld_update_msr(false);
>          else if (!current_has(TIF_SLD) && !guest_sld_on())
>            sld_update_msr(true);
> 
>        If the guest triggers #AC then this solely affects guest state
>        and does not fiddle with TIF_SLD.
> 

OK. So when host is sld_warn, guest's SLD value can be loaded into 
hardware MSR when vmenter.

I'll go with this option.




