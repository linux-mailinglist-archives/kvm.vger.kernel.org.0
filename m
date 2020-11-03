Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165E12A3C00
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 06:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbgKCFfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 00:35:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:45876 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgKCFfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 00:35:12 -0500
IronPort-SDR: /8G/iwx1jS1P9pvqL/CYU12LHgN0LireLJQsJW6R3YR1Hr7bDIieiIoSKKmXq5Idsoz4gZtV7I
 /cnFd3tpUeTA==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="165498172"
X-IronPort-AV: E=Sophos;i="5.77,447,1596524400"; 
   d="scan'208";a="165498172"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 21:35:11 -0800
IronPort-SDR: pvXmgZq8pEXonYygE2Xdqk69XDdFwn87bm3Tg7b+fGG1MIhdL2gAzuDXzcaic8ZnrtsOLoFU1f
 b8Qae/eTGlUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,447,1596524400"; 
   d="scan'208";a="353081268"
Received: from unknown (HELO [0.0.0.0]) ([10.109.19.69])
  by fmsmga004.fm.intel.com with ESMTP; 02 Nov 2020 21:35:08 -0800
Subject: Re: [PATCH] KVM: VMX: Enable Notify VM exit
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
References: <20201102061445.191638-1-tao3.xu@intel.com>
 <CALCETrVqdq4zw=Dcd6dZzSmUZTMXHP50d=SRSaY2AV5sauUzOw@mail.gmail.com>
 <20201102173130.GC21563@linux.intel.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <34576238-eedf-4a94-880a-c961d2d5b237@intel.com>
Date:   Tue, 3 Nov 2020 13:35:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201102173130.GC21563@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/3/20 1:31 AM, Sean Christopherson wrote:
> On Mon, Nov 02, 2020 at 08:43:30AM -0800, Andy Lutomirski wrote:
>> On Sun, Nov 1, 2020 at 10:14 PM Tao Xu <tao3.xu@intel.com> wrote:
>>> 2. Another patch to disable interception of #DB and #AC when notify
>>> VM-Exiting is enabled.
>>
>> Whoa there.
>>
>> A VM control that says "hey, CPU, if you messed up and livelocked for
>> a long time, please break out of the loop" is not a substitute for
>> fixing the livelocks.  So I don't think you get do disable
>> interception of #DB and #AC.
> 
> I think that can be incorporated into a module param, i.e. let the platform
> owner decide which tool(s) they want to use to mitigate the legacy architecture
> flaws.
> 
>> I also think you should print a loud warning
> 
> I'm not so sure on this one, e.g. userspace could just spin up a new instance
> if its malicious guest and spam the kernel log.
> 
>> and have some intelligent handling when this new exit triggers.
> 
> We discussed something similar in the context of the new bus lock VM-Exit.  I
> don't know that it makes sense to try and add intelligence into the kernel.
> In many use cases, e.g. clouds, the userspace VMM is trusted (inasmuch as
> userspace can be trusted), while the guest is completely untrusted.  Reporting
> the error to userspace and letting the userspace stack take action is likely
> preferable to doing something fancy in the kernel.
> 
> 
> Tao, this patch should probably be tagged RFC, at least until we can experiment
> with the threshold on real silicon.  KVM and kernel behavior may depend on the
> accuracy of detecting actual attacks, e.g. if we can set a threshold that has
> zero false negatives and near-zero false postives, then it probably makes sense
> to be more assertive in how such VM-Exits are reported and logged.
> 
Sorry, I should add RFC tag for this patch. I will add it next time.
