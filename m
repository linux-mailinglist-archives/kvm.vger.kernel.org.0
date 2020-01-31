Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCD7314F183
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 18:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgAaRrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 12:47:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:18380 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgAaRrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 12:47:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 09:47:15 -0800
X-IronPort-AV: E=Sophos;i="5.70,386,1574150400"; 
   d="scan'208";a="223205284"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.174.29]) ([10.249.174.29])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 31 Jan 2020 09:47:13 -0800
Subject: Re: [PATCH 2/2] KVM: VMX: Extend VMX's #AC handding
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <3499ee3f-e734-50fd-1b50-f6923d1f4f76@intel.com>
 <5D1CAD6E-7D40-48C6-8D21-203BDC3D0B63@amacapital.net>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <df8f7580-9e7d-bc49-30c0-eca517f8db44@intel.com>
Date:   Sat, 1 Feb 2020 01:47:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <5D1CAD6E-7D40-48C6-8D21-203BDC3D0B63@amacapital.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/31/2020 11:37 PM, Andy Lutomirski wrote:
> 
> 
>> On Jan 30, 2020, at 11:22 PM, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>
>> ﻿On 1/31/2020 1:16 AM, Andy Lutomirski wrote:
>>>>> On Jan 30, 2020, at 8:30 AM, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>>>
>>>> ﻿On 1/30/2020 11:18 PM, Andy Lutomirski wrote:
>>>>>>> On Jan 30, 2020, at 4:24 AM, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>>>>>
>>>>>> ﻿There are two types of #AC can be generated in Intel CPUs:
>>>>>> 1. legacy alignment check #AC;
>>>>>> 2. split lock #AC;
>>>>>>
>>>>>> Legacy alignment check #AC can be injected to guest if guest has enabled
>>>>>> alignemnet check.
>>>>>>
>>>>>> When host enables split lock detection, i.e., split_lock_detect!=off,
>>>>>> guest will receive an unexpected #AC when there is a split_lock happens in
>>>>>> guest since KVM doesn't virtualize this feature to guest.
>>>>>>
>>>>>> Since the old guests lack split_lock #AC handler and may have split lock
>>>>>> buges. To make guest survive from split lock, applying the similar policy
>>>>>> as host's split lock detect configuration:
>>>>>> - host split lock detect is sld_warn:
>>>>>>    warning the split lock happened in guest, and disabling split lock
>>>>>>    detect around VM-enter;
>>>>>> - host split lock detect is sld_fatal:
>>>>>>    forwarding #AC to userspace. (Usually userspace dump the #AC
>>>>>>    exception and kill the guest).
>>>>> A correct userspace implementation should, with a modern guest kernel, forward the exception. Otherwise you’re introducing a DoS into the guest if the guest kernel is fine but guest userspace is buggy.
>>>>
>>>> To prevent DoS in guest, the better solution is virtualizing and advertising this feature to guest, so guest can explicitly enable it by setting split_lock_detect=fatal, if it's a latest linux guest.
>>>>
>>>> However, it's another topic, I'll send out the patches later.
>>>>
>>> Can we get a credible description of how this would work? I suggest:
>>> Intel adds and documents a new CPUID bit or core capability bit that means “split lock detection is forced on”.  If this bit is set, the MSR bit controlling split lock detection is still writable, but split lock detection is on regardless of the value.  Operating systems are expected to set the bit to 1 to indicate to a hypervisor, if present, that they understand that split lock detection is on.
>>> This would be an SDM-only change, but it would also be a commitment to certain behavior for future CPUs that don’t implement split locks.
>>
>> It sounds a PV solution for virtualization that it doesn't need to be defined in Intel-SDM but in KVM document.
>>
>> As you suggested, we can define new bit in KVM_CPUID_FEATURES (0x40000001) as KVM_FEATURE_SLD_FORCED and reuse MSR_TEST_CTL or use a new virtualized MSR for guest to tell hypervisor it understand split lock detection is forced on.
> 
> Of course KVM can do this. But this missed the point. Intel added a new CPU feature, complete with an enumeration mechanism, that cannot be correctly used if a hypervisor is present. 

Why it cannot be correctly used if a hypervisor is present?
Because it needs to disable split lock detection when running a vcpu for 
guest as this patch wants to do?

> As it stands, without specific hypervisor and guest support of a non-Intel interface, it is *impossible* to give architecturally correct behavior to a guest. If KVM implements your suggestion, *Windows* guests will still malfunction on Linux.

Actually, KVM don't need to implement my suggestion. It can just 
virtualize and expose this feature (MSR_IA32_CORE_CAPABILITIES and 
MSR_TEST_CTRL) to guest, (but it may have some requirement that HT is 
disabled and host is sld_off) then guest can use it architecturally.

If we don't virtualize and expose this feature to guest as now, both old 
and modern guest should think there is no feature split lock detection, 
and of course there is no #AC when it executes a split lock.

However, the problem here is the scope of host split lock detection, 
i.e., whether or not host's enabling of split lock detection takes 
effect on guest.

> 
> This is Intel’s mess. Intel should have some responsibility for cleaning it up. If Intel puts something like my suggestion into the SDM, all the OSes and hypervisors will implement it the *same* way and will be compatible. Sure, old OSes will still be broken, but at least new guests will work correctly. Without something like this, even new guests are busted.
> 
>>
>>> Can one of you Intel folks ask the architecture team about this?
>>

