Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98F26D8F4E
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 13:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392737AbfJPLX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 07:23:27 -0400
Received: from mga12.intel.com ([192.55.52.136]:20212 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392658AbfJPLX1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 07:23:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 04:23:26 -0700
X-IronPort-AV: E=Sophos;i="5.67,303,1566889200"; 
   d="scan'208";a="186119904"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 16 Oct 2019 04:23:23 -0700
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
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <c3ff2fb3-4380-fb07-1fa3-15896a09e748@intel.com>
Date:   Wed, 16 Oct 2019 19:23:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/16/2019 6:16 PM, Paolo Bonzini wrote:
> On 16/10/19 11:47, Thomas Gleixner wrote:
>> On Wed, 16 Oct 2019, Paolo Bonzini wrote:
>>> Just never advertise split-lock
>>> detection to guests.  If the host has enabled split-lock detection,
>>> trap #AC and forward it to the host handler---which would disable
>>> split lock detection globally and reenter the guest.
>>
>> Which completely defeats the purpose.
> 
> Yes it does.  But Sean's proposal, as I understand it, leads to the
> guest receiving #AC when it wasn't expecting one.  So for an old guest,
> as soon as the guest kernel happens to do a split lock, it gets an
> unexpected #AC and crashes and burns.  And then, after much googling and
> gnashing of teeth, people proceed to disable split lock detection.
> 
> (Old guests are the common case: you're a cloud provider and your
> customers run old stuff; it's a workstation and you want to play that
> game that requires an old version of Windows; etc.).
> 
> To save them the googling and gnashing of teeth, I guess we can do a
> pr_warn_ratelimited on the first split lock encountered by a guest.  (It
> has to be ratelimited because userspace could create an arbitrary amount
> of guests to spam the kernel logs).  But the end result is the same,
> split lock detection is disabled by the user.
> 
> The first alternative I thought of was:
> 
> - Remove KVM loading of MSR_TEST_CTRL, i.e. KVM *never* writes the CPU's
>    actual MSR_TEST_CTRL.  KVM still emulates MSR_TEST_CTRL so that the
>    guest can do WRMSR and handle its own #AC faults, but KVM doesn't
>    change the value in hardware.
> 
> - trap #AC if the guest encounters a split lock while detection is
>    disabled, and then disable split-lock detection in the host.
> 
> But I discarded it because it still doesn't do anything for malicious
> guests, which can trigger #AC as they prefer.  And it makes things
> _worse_ for sane guests, because they think split-lock detection is
> enabled but they become vulnerable as soon as there is only one
> malicious guest on the same machine.
> 
> In all of these cases, the common final result is that split-lock
> detection is disabled on the host.  So might as well go with the
> simplest one and not pretend to virtualize something that (without core
> scheduling) is obviously not virtualizable.

Right, the nature of core-scope makes MSR_TEST_CTL impossible/hard to 
virtualize.

- Making old guests survive needs to disable split-lock detection in 
host(hardware).
- Defending malicious guests needs to enable split-lock detection in 
host(hardware).

We cannot achieve them at the same time.

In my opinion, letting kvm disable the split-lock detection in host is 
not acceptable that it just opens the door for malicious guests to 
attack. I think we can use Sean's proposal like below.

KVM always traps #AC, and only advertises split-lock detection to guest 
when the global variable split_lock_detection_enabled in host is true.

- If guest enables #AC (CPL3 alignment check or split-lock detection 
enabled), injecting #AC back into guest since it's supposed capable of 
handling it.
- If guest doesn't enable #AC, KVM reports #AC to userspace (like other 
unexpected exceptions), and we can print a hint in kernel, or let 
userspace (e.g., QEMU) tell the user guest is killed because there is a 
split-lock in guest.

In this way, malicious guests always get killed by userspace and old 
sane guests cannot survive as well if it causes split-lock. If we do 
want old sane guests work we have to disable the split-lock detection 
(through booting parameter or debugfs) in the host just the same as we 
want to run an old and split-lock generating userspace binary.

But there is an issue that we advertise split-lock detection to guest 
based on the value of split_lock_detection_enabled to be true in host, 
which can be turned into false dynamically when split-lock happens in 
host kernel. This causes guest's capability changes at run time and I 
don't if there is a better way to inform guest? Maybe we need a pv 
interface?

> Thanks,
> 
> Paolo
> 
>> 1) Sane guest
>>
>> Guest kernel has #AC handler and you basically prevent it from
>> detecting malicious user space and killing it. You also prevent #AC
>> detection in the guest kernel which limits debugability.
>>
>> 2) Malicious guest
>>
>> Trigger #AC to disable the host detection and then carry out the DoS
>> attack.
> 
> 
