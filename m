Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEE7DDA300
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 03:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393612AbfJQBYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 21:24:00 -0400
Received: from mga07.intel.com ([134.134.136.100]:50725 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388782AbfJQBX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 21:23:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 18:23:58 -0700
X-IronPort-AV: E=Sophos;i="5.67,305,1566889200"; 
   d="scan'208";a="189863183"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 16 Oct 2019 18:23:55 -0700
Subject: Re: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
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
References: <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com>
 <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de>
 <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
 <alpine.DEB.2.21.1910161244060.2046@nanos.tec.linutronix.de>
 <3a12810b-1196-b70a-aa2e-9fe17dc7341a@redhat.com>
 <b2c42a64-eb42-1f18-f609-42eec3faef18@intel.com>
 <d2fc3cbe-1506-94fc-73a4-8ed55dc9337d@redhat.com>
 <20191016154116.GA5866@linux.intel.com>
 <d235ed9a-314c-705c-691f-b31f2f8fa4e8@redhat.com>
 <20191016162337.GC5866@linux.intel.com>
 <20191016174200.GF5866@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <54cba514-23bb-5a96-f5f7-10520d1f0df2@intel.com>
Date:   Thu, 17 Oct 2019 09:23:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191016174200.GF5866@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/17/2019 1:42 AM, Sean Christopherson wrote:
> On Wed, Oct 16, 2019 at 09:23:37AM -0700, Sean Christopherson wrote:
>> On Wed, Oct 16, 2019 at 05:43:53PM +0200, Paolo Bonzini wrote:
>>> On 16/10/19 17:41, Sean Christopherson wrote:
>>>> On Wed, Oct 16, 2019 at 04:08:14PM +0200, Paolo Bonzini wrote:
>>>>> SIGBUS (actually a new KVM_EXIT_INTERNAL_ERROR result from KVM_RUN is
>>>>> better, but that's the idea) is for when you're debugging guests.
>>>>> Global disable (or alternatively, disable SMT) is for production use.
>>>>
>>>> Alternatively, for guests without split-lock #AC enabled, what if KVM were
>>>> to emulate the faulting instruction with split-lock detection temporarily
>>>> disabled?
>>>
>>> Yes we can get fancy, but remember that KVM is not yet supporting
>>> emulation of locked instructions.  Adding it is possible but shouldn't
>>> be in the critical path for the whole feature.
>>
>> Ah, didn't realize that.  I'm surprised emulating all locks with cmpxchg
>> doesn't cause problems (or am I misreading the code?).  Assuming I'm
>> reading the code correctly, the #AC path could kick all other vCPUS on
>> emulation failure and then retry emulation to "guarantee" success.  Though
>> that's starting to build quite the house of cards.
> 
> Ugh, doesn't the existing emulation behavior create another KVM issue?
> KVM uses a locked cmpxchg in emulator_cmpxchg_emulated() and the address
> is guest controlled, e.g. a guest could coerce the host into disabling
> split-lock detection via the host's #AC handler by triggering emulation
> and inducing an #AC in the emulator.
>

Exactly right.

I have tested with force_emulation_prefix. It did go into the #AC 
handler and disable the split-lock detection in host.

However, without force_emulation_prefix enabled, I'm not sure whether 
malicious guest can create the case causing the emulation with a lock 
prefix and going to the emulator_cmpxchg_emulated().
I found it impossible without force_emulation_prefix enabled and I'm not 
familiar with emulation at all. If I missed something, please let me know.

>>> How would you disable split-lock detection temporarily?  Just tweak
>>> MSR_TEST_CTRL for the time of running the one instruction, and cross
>>> fingers that the sibling doesn't notice?
>>
>> Tweak MSR_TEST_CTRL, with logic to handle the scenario where split-lock
>> detection is globally disable during emulation (so KVM doesn't
>> inadvertantly re-enable it).
>>
>> There isn't much for the sibling to notice.  The kernel would temporarily
>> allow split-locks on the sibling, but that's a performance issue and isn't
>> directly fatal.  A missed #AC in the host kernel would only delay the
>> inevitable global disabling of split-lock.  A missed #AC in userspace would
>> again just delay the inevitable SIGBUS.
