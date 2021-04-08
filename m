Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447CB357BE9
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 07:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhDHFkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 01:40:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:35620 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229512AbhDHFkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 01:40:07 -0400
IronPort-SDR: 1NjWPzihncrvdfHrftvyxSL0CPpKrkdPfaq/lvoc3QOVi9hOp368Z6IUnJpA3dL6Lu7fsODx6d
 6qrBz6vgIbKw==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="213865231"
X-IronPort-AV: E=Sophos;i="5.82,205,1613462400"; 
   d="scan'208";a="213865231"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 22:39:56 -0700
IronPort-SDR: 1nFchG0VZE84cW6XjVn3o0HBS7z8MjplqzBG6Xp+pw4/ZQaO5x4nB9B+DBfeb0HsxmjRpFzKzP
 rVqP6MDPNrXA==
X-IronPort-AV: E=Sophos;i="5.82,205,1613462400"; 
   d="scan'208";a="458674706"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 22:39:51 -0700
Subject: Re: [PATCH v4 08/16] KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to
 manage guest DS buffer
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Like Xu <like.xu@linux.intel.com>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
 <20210329054137.120994-9-like.xu@linux.intel.com>
 <YG3SPsiFJPeXQXhq@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <610bfd14-3250-0542-2d93-cbd15f2b4e16@intel.com>
Date:   Thu, 8 Apr 2021 13:39:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YG3SPsiFJPeXQXhq@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

Thanks for your detailed comments.

If you have more comments for other patches, please let me know.

On 2021/4/7 23:39, Peter Zijlstra wrote:
> On Mon, Mar 29, 2021 at 01:41:29PM +0800, Like Xu wrote:
>> @@ -3869,10 +3876,12 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>>   
>>   		if (arr[1].guest)
>>   			arr[0].guest |= arr[1].guest;
>> -		else
>> +		else {
>>   			arr[1].guest = arr[1].host;
>> +			arr[2].guest = arr[2].host;
>> +		}
> What's all this gibberish?
>
> The way I read that it says:
>
> 	if guest has PEBS_ENABLED
> 		guest GLOBAL_CTRL |= PEBS_ENABLED
> 	otherwise
> 		guest PEBS_ENABLED = host PEBS_ENABLED
> 		guest DS_AREA = host DS_AREA
>
> which is just completely random garbage afaict. Why would you leak host
> msrs into the guest?

In fact, this is not a leak at all.

When we do "arr[i].guest = arr[i].host;" assignment in the 
intel_guest_get_msrs(),
the KVM will check "if (msrs[i].host == msrs[i].guest)" and if so, it 
disables the atomic
switch for this msr during vmx transaction in the caller 
atomic_switch_perf_msrs().

In that case, the msr value doesn't change and any guest write will be trapped.
If the next check is "msrs[i].host != msrs[i].guest", the atomic switch 
will be triggered again.

Compared to before, this part of the logic has not changed, which helps to 
reduce overhead.

> Why would you change guest GLOBAL_CTRL implicitly;

This is because in the early part of this function, we have operations:

     if (x86_pmu.flags & PMU_FL_PEBS_ALL)
         arr[0].guest &= ~cpuc->pebs_enabled;
     else
         arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);

and if guest has PEBS_ENABLED, we need these bits back for PEBS counters:

     arr[0].guest |= arr[1].guest;

> guest had better wrmsr that himself to control when stuff is enabled.

When vm_entry, the msr value of GLOBAL_CTRL on the hardware may be
different from trapped value "pmu->global_ctrl" written by the guest.

If the perf scheduler cross maps guest counter X to the host counter Y,
we have to enable the bit Y in GLOBAL_CTRL before vm_entry rather than X.

>
> This just cannot be right.

