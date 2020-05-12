Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29DC1CEC39
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 06:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbgELE6w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 00:58:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:11099 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbgELE6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 00:58:52 -0400
IronPort-SDR: xqxKEFYtPAKOLXCgSCBLXlLCVROlXgXhgKjY7wDcwOLp8yFoGbZ5EkMzWLPhyZtVk3kBhV52jn
 kP6bzRKFGBKw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 21:58:52 -0700
IronPort-SDR: 5EJmq3tbR/B4coRN78BIC3r1y2gMm90yEVNXU5ahNh29m1gJFyxO5YFeCXgQ7I8rI+0Sm4pkBA
 YVTcgWpVUdVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,382,1583222400"; 
   d="scan'208";a="286511600"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.141]) ([10.238.4.141])
  by fmsmga004.fm.intel.com with ESMTP; 11 May 2020 21:58:49 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH v10 08/11] KVM: x86/pmu: Add LBR feature emulation via
 guest LBR event
To:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.w.wang@intel.com,
        ak@linux.intel.com
References: <20200423081412.164863-1-like.xu@linux.intel.com>
 <20200423081412.164863-9-like.xu@linux.intel.com>
 <20200424121626.GB20730@hirez.programming.kicks-ass.net>
 <87abf620-d292-d997-c9be-9a5d2544f3fa@linux.intel.com>
 <20200508130931.GE5298@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <43e093a5-61fc-815e-bec8-2a11c27d08d1@intel.com>
Date:   Tue, 12 May 2020 12:58:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200508130931.GE5298@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/5/8 21:09, Peter Zijlstra wrote:
> On Mon, Apr 27, 2020 at 11:16:40AM +0800, Like Xu wrote:
>> On 2020/4/24 20:16, Peter Zijlstra wrote:
>>> And I suppose that is why you need that horrible:
>>> needs_guest_lbr_without_counter() thing to begin with.
>> Do you suggest to use event->attr.config check to replace
>> "needs_branch_stack(event) && is_kernel_event(event) &&
>> event->attr.exclude_host" check for guest LBR event ?
> That's what the BTS thing does.
Thanks, I'll apply it.
>
>>> Please allocate yourself an event from the pseudo event range:
>>> event==0x00. Currently we only have umask==3 for Fixed2 and umask==4
>>> for Fixed3, given you claim 58, which is effectively Fixed25,
>>> umask==0x1a might be appropriate.
>> OK, I assume that adding one more field ".config = 0x1a00" is
>> efficient enough for perf_event_attr to allocate guest LBR events.
> Uh what? The code is already setting .config. You just have to change it
> do another value.
Thanks, I'll apply it.
>
>>> Also, I suppose we need to claim 0x0000 as an error, so that other
>>> people won't try this again.
>> Does the following fix address your concern on this ?
>>
>> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
>> index 2405926e2dba..32d2a3f8c51f 100644
>> --- a/arch/x86/events/core.c
>> +++ b/arch/x86/events/core.c
>> @@ -498,6 +498,9 @@ int x86_pmu_max_precise(void)
>>
>>   int x86_pmu_hw_config(struct perf_event *event)
>>   {
>> +       if (!unlikely(event->attr.config & X86_ARCH_EVENT_MASK))
>> +               return -EINVAL;
>> +
>>          if (event->attr.precise_ip) {
>>                  int precise = x86_pmu_max_precise();
> That wouldn't work right for AMD. But yes, something like that.
Sure, I may figure it out and leave it in another thread.
>
>>> Also, what happens if you fail programming due to a conflicting cpu
>>> event? That pinned doesn't guarantee you'll get the event, it just means
>>> you'll error instead of getting RR.
>>>
>>> I didn't find any code checking the event state.
>>>
>> Error instead of RR is expected.
>>
>> If the KVM fails programming due to a conflicting cpu event
>> the LBR registers will not be passthrough to the guest,
>> and KVM would return zero for any guest LBR records accesses
>> until the next attempt to program the guest LBR event.
>>
>> Every time before cpu enters the non-root mode where irq is
>> disabled, the "event-> oncpu! =-1" check will be applied.
>> (more details in the comment around intel_pmu_availability_check())
>>
>> The guests administer is supposed to know the result of guest
>> LBR records is inaccurate if someone is using LBR to record
>> guest or hypervisor on the host side.
>>
>> Is this acceptable to you？
>>
>> If there is anything needs to be improved, please let me know.
> It might be nice to emit a pr_warn() or something on the host when this
> happens. Then at least the host admin can know he wrecked things for
> which guest.
Sure, I will use pr_warn () and indicate which guest it is.

If you have more comments on the patchset, please let me know.
If not, I'll spin the next version based on your current feedback.

Thanks,
Like Xu

