Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8419527E76
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 09:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241023AbiEPHUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 03:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241015AbiEPHUy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 03:20:54 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A0DBE0F;
        Mon, 16 May 2022 00:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652685653; x=1684221653;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5Bmrym4ZBrZuWxcL4DbvzKLGJFYIJDTX69S3vd8Egxg=;
  b=HHdhJkt4Uy0JAko18zXwuDaZT6xuJolbnr3XuUNobk5SBtZHx5oSomxI
   XPh+IL6jTkA9xnJgtJ/6QPqup/R/NiprPlXLbKz93josntWePfubuPAUS
   Mo4tSUAkiBGd02ZKRsiJXrI5U/fBU6ZlK2/c0RGo06kGo+HkN4e3OLUcH
   K0glFQ9b0q07Ww1FpsPbgJhIe9H5FUUzb0xy4ir3LBQ0g5Qcj3IuBqJD2
   ARpttl5x9MFpWuZnCQTOKCJZaqXgDVy6li27nHuvEZPuNJXZETEk4fx02
   a7Iz4jdQqjK4fyCriIFhL5dqTY2qIDubCCEEcwFMP908t5vr+BI5HWvqt
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10348"; a="269579094"
X-IronPort-AV: E=Sophos;i="5.91,229,1647327600"; 
   d="scan'208";a="269579094"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 00:20:52 -0700
X-IronPort-AV: E=Sophos;i="5.91,229,1647327600"; 
   d="scan'208";a="596388661"
Received: from rhudecze-mobl.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.36.15])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 00:20:46 -0700
Message-ID: <dd53c419-efc4-5b2f-9fdc-e23e7145dbd1@intel.com>
Date:   Mon, 16 May 2022 10:20:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [PATCH V2 03/11] perf/x86: Add support for TSC in nanoseconds as
 a perf event clock
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        H Peter Anvin <hpa@zytor.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leo Yan <leo.yan@linaro.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "sdeep@vmware.com" <sdeep@vmware.com>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Andrew.Cooper3@citrix.com" <Andrew.Cooper3@citrix.com>,
        "Hall, Christopher S" <christopher.s.hall@intel.com>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
 <20220214110914.268126-4-adrian.hunter@intel.com>
 <YiIXFmA4vpcTSk2L@hirez.programming.kicks-ass.net>
 <853ce127-25f0-d0fe-1d8f-0b0dd4f3ce71@intel.com>
 <YiXVgEk/1UClkygX@hirez.programming.kicks-ass.net>
 <30383f92-59cb-2875-1e1b-ff1a0eacd235@intel.com>
 <YiYZv+LOmjzi5wcm@hirez.programming.kicks-ass.net>
 <013b5425-2a60-e4d4-b846-444a576f2b28@intel.com>
 <6f07a7d4e1ad4440bf6c502c8cb6c2ed@intel.com>
 <c3e1842b-79c3-634a-3121-938b5160ca4c@intel.com>
 <50fd2671-6070-0eba-ea68-9df9b79ccac3@intel.com> <87ilqx33vk.ffs@tglx>
 <ff1e190a-95e6-e2a6-dc01-a46f7ffd2162@intel.com> <87fsm114ax.ffs@tglx>
 <c8033229-97a0-3e4c-66d5-74c0d1d4e15c@intel.com> <87ee1iw2ao.ffs@tglx>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <87ee1iw2ao.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/04/22 02:10, Thomas Gleixner wrote:
> On Tue, Apr 26 2022 at 09:51, Adrian Hunter wrote:
>> On 25/04/22 20:05, Thomas Gleixner wrote:
>>> On Mon, Apr 25 2022 at 16:15, Adrian Hunter wrote:
>>>> On 25/04/22 12:32, Thomas Gleixner wrote:
>>>>> It's hillarious, that we still cling to this pvclock abomination, while
>>>>> we happily expose TSC deadline timer to the guest. TSC virt scaling was
>>>>> implemented in hardware for a reason.
>>>>
>>>> So you are talking about changing VMX TCS Offset on every VM-Entry to try to hide
>>>> the time jumps when the VM is scheduled out?  Or neglect that and just let the time
>>>> jumps happen?
>>>>
>>>> If changing VMX TCS Offset, how can TSC be kept consistent between each VCPU i.e.
>>>> wouldn't that mean each VCPU has to have the same VMX TSC Offset?
>>>
>>> Obviously so. That's the only thing which makes sense, no?
>>
>> [ Sending this again, because I notice I messed up the email "From" ]
>>
>> But wouldn't that mean changing all the VCPUs VMX TSC Offset at the same time,
>> which means when none are currently executing?  How could that be done?
> 
> Why would you change TSC offset after the point where a VM is started
> and why would it be different per vCPU?
> 
> Time is global and time moves on when a vCPU is scheduled out. Anything
> else is bonkers, really. If the hypervisor tries to screw with that then
> how does the guest do timekeeping in a consistent way?
> 
>     CLOCK_REALTIME = CLOCK_MONOTONIC + offset
> 
> That offset changes when something sets the clock, i.e. clock_settime(),
> settimeofday() or adjtimex() in case that NTP cannot compensate or for
> the beloved leap seconds adjustment. At any other time the offset is
> constant.
> 
> CLOCK_MONOTONIC is derived from the underlying clocksource which is
> expected to increment with constant frequency and that has to be
> consistent accross _all_ vCPUs of a particular VM.
> 
> So how would a hypervisor 'hide' scheduled out time w/o screwing up
> timekeeping completely?
> 
> The guest TSC which is based on the host TSC is:
> 
>     guestTSC = offset + hostTSC * factor;
> 
> If you make offset different between guest vCPUs then timekeeping in the
> guest is screwed.
> 
> The whole point of that paravirt clock was to handle migration between
> hosts which did not have the VMCS TSC scaling/offset mechanism. The CPUs
> which did not have that went EOL at least 10 years ago.
> 
> So what are you concerned about?

Thanks for the explanation.

Changing TSC offset / scaling makes it much harder for Intel PT on
the host to use, so there is no sense in my pushing for that at this
time when there is anyway kernel option no-kvmclock.

