Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7E13DC2AD
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 12:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394044AbfJRKUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Oct 2019 06:20:50 -0400
Received: from mga04.intel.com ([192.55.52.120]:24969 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387890AbfJRKUu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Oct 2019 06:20:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 03:20:50 -0700
X-IronPort-AV: E=Sophos;i="5.67,311,1566889200"; 
   d="scan'208";a="371425922"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 18 Oct 2019 03:20:45 -0700
Subject: Re: [RFD] x86/split_lock: Request to Intel
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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
 <c3ff2fb3-4380-fb07-1fa3-15896a09e748@intel.com>
 <d30652bb-89fa-671a-5691-e2c76af231d0@redhat.com>
 <8808c9ac-0906-5eec-a31f-27cbec778f9c@intel.com>
 <alpine.DEB.2.21.1910161519260.2046@nanos.tec.linutronix.de>
 <ba2c0aab-1d7c-5cfd-0054-ac2c266c1df3@redhat.com>
 <alpine.DEB.2.21.1910171322530.1824@nanos.tec.linutronix.de>
 <5da90713-9a0d-6466-64f7-db435ba07dbe@intel.com>
 <alpine.DEB.2.21.1910181100000.1869@nanos.tec.linutronix.de>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <763bb046-e016-9440-55c4-33438e35e436@intel.com>
Date:   Fri, 18 Oct 2019 18:20:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1910181100000.1869@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/18/2019 5:02 PM, Thomas Gleixner wrote:
> On Fri, 18 Oct 2019, Xiaoyao Li wrote:
>> On 10/17/2019 8:29 PM, Thomas Gleixner wrote:
>>> The more I look at this trainwreck, the less interested I am in merging any
>>> of this at all.
>>>
>>> The fact that it took Intel more than a year to figure out that the MSR is
>>> per core and not per thread is yet another proof that this industry just
>>> works by pure chance.
>>>
>>
>> Whether it's per-core or per-thread doesn't affect much how we implement for
>> host/native.
> 
> How useful.

OK. IIUC. We can agree on the use model of native like below:

We enable #AC on all cores/threads to detect split lock.
  -If user space causes #AC, sending SIGBUS to it.
  -If kernel causes #AC, we globally disable #AC on all cores/threads, 
letting kernel go on working and WARN. (only disabling #AC on the thread 
generates it just doesn't help, since the buggy kernel code is possible 
to run on any threads and thus disabling #AC on all of them)

As described above, either enabled globally or disabled globally, so 
whether it's per-core or per-thread really doesn't matter

>> And also, no matter it's per-core or per-thread, we always can do something in
>> VIRT.
> 
> It matters a lot. If it would be per thread then we would not have this
> discussion at all.

Indeed, it's the fact that the control MSR bit is per-core to cause this 
discussion. But the per-core scope only makes this feature difficult or 
impossible to be virtualized.

We could make the decision to not expose it to guest to avoid the really 
bad thing. However, even we don't expose this feature to guest and don't 
virtualize it, the below problem always here.

If you think it's not a problem and acceptable to add an option to let 
KVM disable host's #AC detection, we can just make it this way. And then 
we can design the virtualizaion part without any change to native design 
at all.

>> Maybe what matters is below.
>>
>>> Seriously, this makes only sense when it's by default enabled and not
>>> rendered useless by VIRT. Otherwise we never get any reports and none of
>>> the issues are going to be fixed.
>>>
>>
>> For VIRT, it doesn't want old guest to be killed due to #AC. But for native,
>> it doesn't want VIRT to disable the #AC detection
>>
>> I think it's just about the default behavior that whether to disable the
>> host's #AC detection or kill the guest (SIGBUS or something else) once there
>> is an split-lock #AC in guest.
>>
>> So we can provide CONFIG option to set the default behavior and module
>> parameter to let KVM set/change the default behavior.
> 
> Care to read through the whole discussion and figure out WHY it's not that
> simple?
> 
> Thanks,
> 
> 	tglx
> 
