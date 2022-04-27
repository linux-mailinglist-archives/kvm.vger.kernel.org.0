Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F56F512768
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 01:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbiD0XNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 19:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbiD0XNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 19:13:40 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC1626ACB;
        Wed, 27 Apr 2022 16:10:26 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651101023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d0f+m2Dqb3x2CVJe4DM+W9cwvXPiNqPC/6H9asGUciw=;
        b=hQC4wdHr3uIvFPLUK37KcFVlQVbuVrdB2JhO9mWr032woo0CTs1XzrrJ9w8d51QXkif9AL
        iqq/CtSS3SAVCOsErIZhntagIalkjek2CKzYlZKbY+1yquvkEQ+SYGxLFEeOfB9K8/iuiJ
        sJTeeJ3hD6Z+Wnv3S4GSGuF5a9lTEeyQcTKwL6ILvd79BejzkSsxSC6T5rE5aZP3TBP/n3
        +jg4S8nbkCWy5yCMu6ql/RNoji2O4gWL9/3jqEHHpACl6ssvK5LjT19uU9SgW5SHZbttuD
        IIpdWuU+v3ZLfrZlGAvsGInIufO9oQU50N6f2e5WaZw6mwwzzdp4oghy6QGLww==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651101023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d0f+m2Dqb3x2CVJe4DM+W9cwvXPiNqPC/6H9asGUciw=;
        b=GNkovCpOnyHDDop7r43RmNJOWpj1X6I0zE9A0pAj3SrYiDPcex+a91CWpFL9fN5aLfGBcx
        y5Us2rg+kicvELDA==
To:     Adrian Hunter <adrian.hunter@intel.com>,
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
Subject: Re: [PATCH V2 03/11] perf/x86: Add support for TSC in nanoseconds
 as a perf event clock
In-Reply-To: <c8033229-97a0-3e4c-66d5-74c0d1d4e15c@intel.com>
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
 <c8033229-97a0-3e4c-66d5-74c0d1d4e15c@intel.com>
Date:   Thu, 28 Apr 2022 01:10:23 +0200
Message-ID: <87ee1iw2ao.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26 2022 at 09:51, Adrian Hunter wrote:
> On 25/04/22 20:05, Thomas Gleixner wrote:
>> On Mon, Apr 25 2022 at 16:15, Adrian Hunter wrote:
>>> On 25/04/22 12:32, Thomas Gleixner wrote:
>>>> It's hillarious, that we still cling to this pvclock abomination, while
>>>> we happily expose TSC deadline timer to the guest. TSC virt scaling was
>>>> implemented in hardware for a reason.
>>>
>>> So you are talking about changing VMX TCS Offset on every VM-Entry to try to hide
>>> the time jumps when the VM is scheduled out?  Or neglect that and just let the time
>>> jumps happen?
>>>
>>> If changing VMX TCS Offset, how can TSC be kept consistent between each VCPU i.e.
>>> wouldn't that mean each VCPU has to have the same VMX TSC Offset?
>> 
>> Obviously so. That's the only thing which makes sense, no?
>
> [ Sending this again, because I notice I messed up the email "From" ]
>
> But wouldn't that mean changing all the VCPUs VMX TSC Offset at the same time,
> which means when none are currently executing?  How could that be done?

Why would you change TSC offset after the point where a VM is started
and why would it be different per vCPU?

Time is global and time moves on when a vCPU is scheduled out. Anything
else is bonkers, really. If the hypervisor tries to screw with that then
how does the guest do timekeeping in a consistent way?

    CLOCK_REALTIME = CLOCK_MONOTONIC + offset

That offset changes when something sets the clock, i.e. clock_settime(),
settimeofday() or adjtimex() in case that NTP cannot compensate or for
the beloved leap seconds adjustment. At any other time the offset is
constant.

CLOCK_MONOTONIC is derived from the underlying clocksource which is
expected to increment with constant frequency and that has to be
consistent accross _all_ vCPUs of a particular VM.

So how would a hypervisor 'hide' scheduled out time w/o screwing up
timekeeping completely?

The guest TSC which is based on the host TSC is:

    guestTSC = offset + hostTSC * factor;

If you make offset different between guest vCPUs then timekeeping in the
guest is screwed.

The whole point of that paravirt clock was to handle migration between
hosts which did not have the VMCS TSC scaling/offset mechanism. The CPUs
which did not have that went EOL at least 10 years ago.

So what are you concerned about?

Thanks,

        tglx
