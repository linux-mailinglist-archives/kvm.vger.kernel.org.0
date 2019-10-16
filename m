Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33762D92F1
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 15:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405552AbfJPNvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 09:51:11 -0400
Received: from mga05.intel.com ([192.55.52.43]:64160 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405542AbfJPNvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 09:51:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 06:51:11 -0700
X-IronPort-AV: E=Sophos;i="5.67,304,1566889200"; 
   d="scan'208";a="186154129"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 16 Oct 2019 06:51:07 -0700
Subject: Re: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
 <1560897679-228028-10-git-send-email-fenghua.yu@intel.com>
 <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de>
 <20190626203637.GC245468@romley-ivt3.sc.intel.com>
 <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de>
 <20190925180931.GG31852@linux.intel.com>
 <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com>
 <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de>
 <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
 <alpine.DEB.2.21.1910161244060.2046@nanos.tec.linutronix.de>
 <3a12810b-1196-b70a-aa2e-9fe17dc7341a@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <b2c42a64-eb42-1f18-f609-42eec3faef18@intel.com>
Date:   Wed, 16 Oct 2019 21:51:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <3a12810b-1196-b70a-aa2e-9fe17dc7341a@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/16/2019 7:58 PM, Paolo Bonzini wrote:
> On 16/10/19 13:49, Thomas Gleixner wrote:
>> On Wed, 16 Oct 2019, Paolo Bonzini wrote:
>>> Yes it does.  But Sean's proposal, as I understand it, leads to the
>>> guest receiving #AC when it wasn't expecting one.  So for an old guest,
>>> as soon as the guest kernel happens to do a split lock, it gets an
>>> unexpected #AC and crashes and burns.  And then, after much googling and
>>> gnashing of teeth, people proceed to disable split lock detection.
>>
>> I don't think that this was what he suggested/intended.
> 
> Xiaoyao's reply suggests that he also understood it like that.
>

Actually, what I replied is a little different from what you stated 
above that guest won't receive #AC when it wasn't expecting one but the 
userspace receives this #AC.

>>> In all of these cases, the common final result is that split-lock
>>> detection is disabled on the host.  So might as well go with the
>>> simplest one and not pretend to virtualize something that (without core
>>> scheduling) is obviously not virtualizable.
>>
>> You are completely ignoring any argument here and just leave it behind your
>> signature (instead of trimming your reply).
> 
> I am not ignoring them, I think there is no doubt that this is the
> intended behavior.  I disagree that Sean's patches achieve it, however.
> 
>>>> 1) Sane guest
>>>>
>>>> Guest kernel has #AC handler and you basically prevent it from
>>>> detecting malicious user space and killing it. You also prevent #AC
>>>> detection in the guest kernel which limits debugability.
>>
>> That's a perfectly fine situation. Host has #AC enabled and exposes the
>> availability of #AC to the guest. Guest kernel has a proper handler and
>> does the right thing. So the host _CAN_ forward #AC to the guest and let it
>> deal with it. For that to work you need to expose the MSR so you know the
>> guest state in the host.
>>
>> Your lazy 'solution' just renders #AC completely useless even for
>> debugging.
>>
>>>> 2) Malicious guest
>>>>
>>>> Trigger #AC to disable the host detection and then carry out the DoS
>>>> attack.
>>
>> With your proposal you render #AC useless even on hosts which have SMT
>> disabled, which is just wrong. There are enough good reasons to disable
>> SMT.
> 
> My lazy "solution" only applies to SMT enabled.  When SMT is either not
> supported, or disabled as in "nosmt=force", we can virtualize it like
> the posted patches have done so far.
> 

Do we really need to divide it into two cases of SMT enabled and SMT 
disabled?

>> I agree that with SMT enabled the situation is truly bad, but we surely can
>> be smarter than just disabling it globally unconditionally and forever.
>>
>> Plus we want a knob which treats guests triggering #AC in the same way as
>> we treat user space, i.e. kill them with SIGBUS.
> 
> Yes, that's a valid alternative.  But if SMT is possible, I think the
> only sane possibilities are global disable and SIGBUS.  SIGBUS (or
> better, a new KVM_RUN exit code) can be acceptable for debugging guests too.

If SIGBUS, why need to globally disable?

When there is an #AC due to split-lock in guest, KVM only has below two 
choices:
1) inject back into guest.
    - If kvm advertise this feature to guest, and guest kernel is 
latest, and guest kernel must enable it too. It's the happy case that 
guest can handler it on its own purpose.
    - Any other cases, guest get an unexpected #AC and crash.
2) report to userspace (I think the same like a SIGBUS)

So for simplicity, we can do what Paolo suggested that don't advertise 
this feature and report #AC to userspace when an #AC due to split-lock 
in guest *but* we never disable the host's split-lock detection due to 
guest's split-lock.

> Paolo
> 
