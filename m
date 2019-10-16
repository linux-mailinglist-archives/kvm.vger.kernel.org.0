Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAD4D921C
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 15:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393515AbfJPNNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 09:13:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:54456 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390087AbfJPNNK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 09:13:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 06:13:10 -0700
X-IronPort-AV: E=Sophos;i="5.67,303,1566889200"; 
   d="scan'208";a="186145335"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 16 Oct 2019 06:13:06 -0700
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
 <c3ff2fb3-4380-fb07-1fa3-15896a09e748@intel.com>
 <d30652bb-89fa-671a-5691-e2c76af231d0@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <8808c9ac-0906-5eec-a31f-27cbec778f9c@intel.com>
Date:   Wed, 16 Oct 2019 21:13:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <d30652bb-89fa-671a-5691-e2c76af231d0@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/16/2019 7:26 PM, Paolo Bonzini wrote:
> On 16/10/19 13:23, Xiaoyao Li wrote:
>> KVM always traps #AC, and only advertises split-lock detection to guest
>> when the global variable split_lock_detection_enabled in host is true.
>>
>> - If guest enables #AC (CPL3 alignment check or split-lock detection
>> enabled), injecting #AC back into guest since it's supposed capable of
>> handling it.
>> - If guest doesn't enable #AC, KVM reports #AC to userspace (like other
>> unexpected exceptions), and we can print a hint in kernel, or let
>> userspace (e.g., QEMU) tell the user guest is killed because there is a
>> split-lock in guest.
>>
>> In this way, malicious guests always get killed by userspace and old
>> sane guests cannot survive as well if it causes split-lock. If we do
>> want old sane guests work we have to disable the split-lock detection
>> (through booting parameter or debugfs) in the host just the same as we
>> want to run an old and split-lock generating userspace binary.
> 
> Old guests are prevalent enough that enabling split-lock detection by
> default would be a big usability issue.  And even ignoring that, you
> would get the issue you describe below:

Right, whether enabling split-lock detection is made by the 
administrator. The administrator is supposed to know the consequence of 
enabling it. Enabling it means don't want any split-lock happens in 
userspace, of course VMM softwares are under control.

>> But there is an issue that we advertise split-lock detection to guest
>> based on the value of split_lock_detection_enabled to be true in host,
>> which can be turned into false dynamically when split-lock happens in
>> host kernel.
> 
> ... which means that supposedly safe guests become unsafe, and that is bad.
> 
>> This causes guest's capability changes at run time and I
>> don't if there is a better way to inform guest? Maybe we need a pv
>> interface?
> 
> Even a PV interface would not change the basic fact that a supposedly
> safe configuration becomes unsafe.

I don't catch you about the unsafe?

If host disables split-lock detection dynamically, then the 
MST_TEST_CTL.split_lock is clear in the hardware and we can use the PV 
interface to notify the guest so that guest knows it loses the 
capability of split-lock detection. In this case, I think safety is 
meaningless for both host and guest.

> Paolo
> 
