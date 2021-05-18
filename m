Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0EE387385
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 09:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344885AbhERHvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 03:51:04 -0400
Received: from mga06.intel.com ([134.134.136.31]:7423 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234891AbhERHvD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 03:51:03 -0400
IronPort-SDR: bPjabTHKD/R9+mVEohmbnhTDNm4avEdaPOsPjrGyZUU6ETNpUx2sVPG26qz6pjUt09Bath4gfp
 oJT/DRPmXakQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="261881759"
X-IronPort-AV: E=Sophos;i="5.82,309,1613462400"; 
   d="scan'208";a="261881759"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 00:49:45 -0700
IronPort-SDR: iZBfAYSz0/rhPIaAMe0nLTLjrd5hleZBq/AmLOrh78fZzK4LydMV6YNn0A6x2Ff+dE4TAlzuT7
 RDc0qU1rCKtA==
X-IronPort-AV: E=Sophos;i="5.82,309,1613462400"; 
   d="scan'208";a="472828356"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 00:49:40 -0700
Subject: Re: [PATCH v6 04/16] KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit
 when vPMU is enabled
To:     Sean Christopherson <seanjc@google.com>
Cc:     Venkatesh Srinivas <venkateshs@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Yao Yuan <yuan.yao@intel.com>,
        Like Xu <like.xu@linux.intel.com>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-5-like.xu@linux.intel.com>
 <CAA0tLErUFPnZ=SL82bLe8Ddf5rFu2Pdv5xE0aq4A91mzn9=ABA@mail.gmail.com>
 <ead61a83-1534-a8a6-13ee-646898a6d1a9@intel.com>
 <YJvx4tr2iXo4bQ/d@google.com>
 <5ef2215b-1c43-fc8a-42ef-46c22e093f40@intel.com>
 <YKLdETM7NgjKEa6z@google.com> <YKMBZ5cs2siTorf1@google.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <59aaa290-1c44-f7f5-36b7-cdc42a2f6631@intel.com>
Date:   Tue, 18 May 2021 15:49:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YKMBZ5cs2siTorf1@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/18 7:51, Sean Christopherson wrote:
> On Mon, May 17, 2021, Sean Christopherson wrote:
>> On Thu, May 13, 2021, Xu, Like wrote:
>>> On 2021/5/12 23:18, Sean Christopherson wrote:
>>>> On Wed, May 12, 2021, Xu, Like wrote:
>>>>> Hi Venkatesh Srinivas,
>>>>>
>>>>> On 2021/5/12 9:58, Venkatesh Srinivas wrote:
>>>>>> On 5/10/21, Like Xu <like.xu@linux.intel.com> wrote:
>>>>>>> On Intel platforms, the software can use the IA32_MISC_ENABLE[7] bit to
>>>>>>> detect whether the processor supports performance monitoring facility.
>>>>>>>
>>>>>>> It depends on the PMU is enabled for the guest, and a software write
>>>>>>> operation to this available bit will be ignored.
>>>>>> Is the behavior that writes to IA32_MISC_ENABLE[7] are ignored (rather than #GP)
>>>>>> documented someplace?
>>>>> The bit[7] behavior of the real hardware on the native host is quite
>>>>> suspicious.
>>>> Ugh.  Can you file an SDM bug to get the wording and accessibility updated?  The
>>>> current phrasing is a mess:
>>>>
>>>>     Performance Monitoring Available (R)
>>>>     1 = Performance monitoring enabled.
>>>>     0 = Performance monitoring disabled.
>>>>
>>>> The (R) is ambiguous because most other entries that are read-only use (RO), and
>>>> the "enabled vs. disabled" implies the bit is writable and really does control
>>>> the PMU.  But on my Haswell system, it's read-only.
>>> On your Haswell system, does it cause #GP or just silent if you change this
>>> bit ?
>> Attempting to clear the bit generates a #GP.
> *sigh*
>
> Venkatesh and I are exhausting our brown paper bag supply.
>
> Attempting to clear bit 7 is ignored on both Haswell and Goldmont.  This _no_ #GP,
> the toggle is simply ignored.  I forgot to specify hex format (multiple times),
> and Venkatesh accessed the wrong MSR (0x10a instead of 0x1a0).

*sigh*

>
> So your proposal to ignore the toggle in KVM is the way to go, but please
> document in the changelog that that behavior matches bare metal.

Thank you, I will clearly state it in the commit message.

>
> It would be nice to get the SDM cleaned up to use "supported/unsupported", and to
> pick one of (R), (RO), and (R/O) for all MSRs entries for consistency, but that
> may be a pipe dream.

Glad you could review my code. I have reported this issue internally.

>
> Sorry for the run-around :-/

