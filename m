Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58854B2794
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 15:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350708AbiBKOL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 09:11:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237634AbiBKOL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 09:11:27 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47696DF8;
        Fri, 11 Feb 2022 06:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644588686; x=1676124686;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YMJyD6AIL8XEcvGW+p5ssEnXts8VbG0Kpj/AKg6+SZg=;
  b=aesf7ImYlmUmIaKGdtmty47n/xzUVdfbUm5eoMiIy6FBJ5zW0ynEuu8t
   U94ihgNxf6GpqJLsO6n39/0os0I9X1SN8R56qUS4btZOKKzESkMFQASWv
   xSPKiSjxpZdXdo9oG2RaS+z1FBV96aRUq9laTeDBY0/dwjUDA4k7E1FX4
   UOJJCPFYUldY3hQgNpN3GBvDZDpenbcwIe5jEt3hjAI1QMCJfpp3KAII5
   xLgpaXj8pF8mC3aDM9NuVqDSRbzpg2g4VNPi8AFDqFLkAKXXA80fTytdx
   IB7LvjrWUwKTNjgbBPnDsdyHeXtuyQ8+C96OYyj1BRJm/Ir9V8+fyyUqp
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="313018446"
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="313018446"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 06:11:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="487835180"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga006.jf.intel.com with ESMTP; 11 Feb 2022 06:11:12 -0800
Received: from [10.212.150.232] (akpowval-MOBL1.amr.corp.intel.com [10.212.150.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id CC9025808BE;
        Fri, 11 Feb 2022 06:11:11 -0800 (PST)
Message-ID: <6afcec02-fb44-7b72-e527-6517a94855d4@linux.intel.com>
Date:   Fri, 11 Feb 2022 09:11:10 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
Content-Language: en-US
To:     David Dunn <daviddunn@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
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
 <7b5012d8-6ae1-7cde-a381-e82685dfed4f@linux.intel.com>
 <CALMp9eTOaWxQPfdwMSAn-OYAHKPLcuCyse7BpsSOM35vg5d0Jg@mail.gmail.com>
 <e06db1a5-1b67-28ac-ee4c-34ece5857b1f@linux.intel.com>
 <CALMp9eSjDro169JjTXyCZn=Rf3PT0uHhdNXEifiXGYQK-Zn8LA@mail.gmail.com>
 <d86ba87b-d98a-53a0-b2cd-5bf77b97b592@linux.intel.com>
 <CABOYuvZ9SZAWeRkrhhhpMM4XwzMzXv9A1WDpc6z8SUBquf0SFQ@mail.gmail.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <CABOYuvZ9SZAWeRkrhhhpMM4XwzMzXv9A1WDpc6z8SUBquf0SFQ@mail.gmail.com>
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



On 2/10/2022 2:55 PM, David Dunn wrote:
> Kan,
> 
> On Thu, Feb 10, 2022 at 11:46 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
> 
>> No, we don't, at least for Linux. Because the host own everything. It
>> doesn't need the MSR to tell which one is in use. We track it in an SW way.
>>
>> For the new request from the guest to own a counter, I guess maybe it is
>> worth implementing it. But yes, the existing/legacy guest never check
>> the MSR.
> 
> This is the expectation of all software that uses the PMU in every
> guest.  It isn't just the Linux perf system.
> 
> The KVM vPMU model we have today results in the PMU utilizing software
> simply not working properly in a guest.  The only case that can
> consistently "work" today is not giving the guest a PMU at all.
> 
> And that's why you are hearing requests to gift the entire PMU to the
> guest while it is running. All existing PMU software knows about the
> various constraints on exactly how each MSR must be used to get sane
> data.  And by gifting the entire PMU it allows that software to work
> properly.  But that has to be controlled by policy at host level such
> that the owner of the host knows that they are not going to have PMU
> visibility into guests that have control of PMU.
> 

I think here is how a guest event works today with KVM and perf subsystem.
     - Guest create an event A
     - The guest kernel assigns a guest counter M to event A, and config 
the related MSRs of the guest counter M.
     - KVM intercepts the MSR access and create a host event B. (The 
host event B is based on the settings of the guest counter M. As I said, 
at least for Linux, some SW config impacts the counter assignment. KVM 
never knows it. Event B can only be a similar event to A.)
     - Linux perf subsystem assigns a physical counter N to a host event 
B according to event B's constraint. (N may not be the same as M, 
because A and B may have different event constraints)

As you can see, even the entire PMU is given to the guest, we still 
cannot guarantee that the physical counter M can be assigned to the 
guest event A.

How to fix it? The only thing I can imagine is "passthrough". Let KVM 
directly assign the counter M to guest. So, to me, this policy sounds 
like let KVM replace the perf to control the whole PMU resources, and we 
will handover them to our guest then. Is it what we want?


Thanks,
Kan
