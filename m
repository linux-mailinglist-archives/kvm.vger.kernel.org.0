Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602A54B11C6
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 16:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243658AbiBJPep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 10:34:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243638AbiBJPeo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 10:34:44 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980211D6;
        Thu, 10 Feb 2022 07:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644507285; x=1676043285;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/CpZixoP9LqieCKr1GT1o2hb5f+axkirfN4SJnts4rY=;
  b=BpMWv8fDvaE7Ld4ChjfyvBVo9OaGza/u9Vgw8tU2pdD83p5SzyapGUfb
   NykTs2b9iHV/nnw2td7Srs4y/9LCBEIuvYIE89ZfiXIkTUrSvnU5sraO4
   9VKFQ+1VTiqtm5RalhlafeIk+lV4dIPkoAVOlxlzpvk3JGTwX8QL8gKIl
   7Eiee14PZVE1DmoNUFCwv+21v/WnR38O3m2y/gvQabFdX/WE5iefkWTZg
   MgqPmNVedTJZr6sOTEvw4yco1bUn0hTeWKnWpT+DRD9iF5w/E71GKPvu3
   Zz545YIpEA8g2nUspxTXFOqSOqW7XoN6FWwCBFHOwfsT4V7YBZ62SjQ+s
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="310253233"
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="310253233"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 07:34:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="701724952"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga005.jf.intel.com with ESMTP; 10 Feb 2022 07:34:44 -0800
Received: from [10.252.133.207] (dgupta-mobl1.amr.corp.intel.com [10.252.133.207])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id C15A8580A8B;
        Thu, 10 Feb 2022 07:34:43 -0800 (PST)
Message-ID: <7b5012d8-6ae1-7cde-a381-e82685dfed4f@linux.intel.com>
Date:   Thu, 10 Feb 2022 10:34:42 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
Content-Language: en-US
To:     David Dunn <daviddunn@google.com>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Stephane Eranian <eranian@google.com>
References: <20220117085307.93030-1-likexu@tencent.com>
 <20220117085307.93030-3-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net>
 <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
 <YgO/3usazae9rCEh@hirez.programming.kicks-ass.net>
 <69c0fc41-a5bd-fea9-43f6-4724368baf66@intel.com>
 <CALMp9eS=1U7T39L-vL_cTXTNN2Li8epjtAPoP_+Hwefe9d+teQ@mail.gmail.com>
 <67a731dd-53ba-0eb8-377f-9707e5c9be1b@intel.com>
 <CABOYuvbPL0DeEgV4gsC+v786xfBAo3T6+7XQr7cVVzbaoFoEAg@mail.gmail.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <CABOYuvbPL0DeEgV4gsC+v786xfBAo3T6+7XQr7cVVzbaoFoEAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/9/2022 2:24 PM, David Dunn wrote:
> Dave,
> 
> In my opinion, the right policy depends on what the host owner and
> guest owner are trying to achieve.
> 
> If the PMU is being used to locate places where performance could be
> improved in the system, there are two sub scenarios:
>     - The host and guest are owned by same entity that is optimizing
> overall system.  In this case, the guest doesn't need PMU access and
> better information is provided by profiling the entire system from the
> host.
>     - The host and guest are owned by different entities.  In this
> case, profiling from the host can identify perf issues in the guest.
> But what action can be taken?  The host entity must communicate issues
> back to the guest owner through some sort of out-of-band information
> channel.  On the other hand, preempting the host PMU to give the guest
> a fully functional PMU serves this use case well.
> 
> TDX and SGX (outside of debug mode) strongly assume different
> entities.  And Intel is doing this to reduce insight of the host into
> guest operations.  So in my opinion, preemption makes sense.
> 
> There are also scenarios where the host owner is trying to identify
> systemwide impacts of guest actions.  For example, detecting memory
> bandwidth consumption or split locks.  In this case, host control
> without preemption is necessary.
> 
> To address these various scenarios, it seems like the host needs to be
> able to have policy control on whether it is willing to have the PMU
> preempted by the guest.
> 
> But I don't see what scenario is well served by the current situation
> in KVM.  Currently the guest will either be told it has no PMU (which
> is fine) or that it has full control of a PMU.  If the guest is told
> it has full control of the PMU, it actually doesn't.  But instead of
> losing counters on well defined events (from the guest perspective),
> they simply stop counting depending on what the host is doing with the
> PMU.

For the current perf subsystem, a PMU should be shared among different 
users via the multiplexing mechanism if the resource is limited. No one 
has full control of a PMU for lifetime. A user can only have the PMU in 
its given period. I think the user can understand how long it runs via 
total_time_enabled and total_time_running.

For a guest, it should rely on the host to tell whether the PMU resource 
is available. But unfortunately, I don't think we have such a 
notification mechanism in KVM. The guest has the wrong impression that 
the guest can have full control of the PMU.

In my opinion, we should add the notification mechanism in KVM. When the 
PMU resource is limited, the guest can know whether it's multiplexing or 
can choose to reschedule the event.

But seems the notification mechanism may not work for TDX case?
> 
> On the other hand, if we flip it around the semantics are more clear.
> A guest will be told it has no PMU (which is fine) or that it has full
> control of the PMU.  If the guest is told that it has full control of
> the PMU, it does.  And the host (which is the thing that granted the
> full PMU to the guest) knows that events inside the guest are not
> being measured.  This results in all entities seeing something that
> can be reasoned about from their perspective.
>

I assume that this is for the TDX case (where the notification mechanism 
  doesn't work). The host still control all the PMU resources. The TDX 
guest is treated as a super-user who can 'own' a PMU. The admin in the 
host can configure/change the owned PMUs of the TDX. Personally, I think 
it makes sense. But please keep in mind that the counters are not 
identical. There are some special events that can only run on a specific 
counter. If the special counter is assigned to TDX, other entities can 
never run some events. We should let other entities know if it happens. 
Or we should never let non-host entities own the special counter.


Thanks,
Kan

> Thanks,
> 
> Dave Dunn
> 
> On Wed, Feb 9, 2022 at 10:57 AM Dave Hansen <dave.hansen@intel.com> wrote:
> 
>>> I was referring to gaps in the collection of data that the host perf
>>> subsystem doesn't know about if ATTRIBUTES.PERFMON is set for a TDX
>>> guest. This can potentially be a problem if someone is trying to
>>> measure events per unit of time.
>>
>> Ahh, that makes sense.
>>
>> Does SGX cause problem for these people?  It can create some of the same
>> collection gaps:
>>
>>          performance monitoring activities are suppressed when entering
>>          an opt-out (of performance monitoring) enclave.
