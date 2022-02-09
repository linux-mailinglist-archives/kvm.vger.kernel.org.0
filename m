Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9854AFC3C
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 19:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241403AbiBIS5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 13:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241345AbiBIS5D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 13:57:03 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23061C05CBB1;
        Wed,  9 Feb 2022 10:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644433025; x=1675969025;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=H+HvKjK7GucUNuC/42zaLPvlOv+m7Cv0FfqTh3L74mI=;
  b=GqNysNdRJ6gfgk1e3eV7YOgJayVduavEFEw49MtIewbsmCcu7HJuDTzP
   drNv9Rx7FXzFbd7Qz7FBr8dQQuDrSoiUIBSr6nGI6lEr+4Yk4eChsTXrf
   axoFKH2v105/ECQNMpmnYHb+X8lQ4UA+g9vUqjK6ISB/MiTb7rZaT8a/5
   5uyhIMJL/zX+RJCHdHfdBrQbyfijRH4YgA/Mj5kaWPgxQk6tJiy8ogbQC
   VnN4uz6aQjWYLgkvCgUgRYT+qz0OQJ3lGOeW1RBJbpOQbvsn8lJLZzRjh
   fti5/QOInwk9JlSUXep+iTLpOJcJUuMbxX908LB061mJHduga0+BRnykZ
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="249515715"
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="249515715"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 10:57:04 -0800
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="485375795"
Received: from sanvery-mobl.amr.corp.intel.com (HELO [10.212.232.139]) ([10.212.232.139])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 10:57:04 -0800
Message-ID: <67a731dd-53ba-0eb8-377f-9707e5c9be1b@intel.com>
Date:   Wed, 9 Feb 2022 10:57:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Stephane Eranian <eranian@google.com>,
        David Dunn <daviddunn@google.com>
References: <20220117085307.93030-1-likexu@tencent.com>
 <20220117085307.93030-3-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net>
 <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
 <YgO/3usazae9rCEh@hirez.programming.kicks-ass.net>
 <69c0fc41-a5bd-fea9-43f6-4724368baf66@intel.com>
 <CALMp9eS=1U7T39L-vL_cTXTNN2Li8epjtAPoP_+Hwefe9d+teQ@mail.gmail.com>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
In-Reply-To: <CALMp9eS=1U7T39L-vL_cTXTNN2Li8epjtAPoP_+Hwefe9d+teQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/22 10:47, Jim Mattson wrote:
> On Wed, Feb 9, 2022 at 7:41 AM Dave Hansen <dave.hansen@intel.com> wrote:
>>
>> On 2/9/22 05:21, Peter Zijlstra wrote:
>>> On Wed, Feb 02, 2022 at 02:35:45PM -0800, Jim Mattson wrote:
>>>> 3) TDX is going to pull the rug out from under us anyway. When the TDX
>>>> module usurps control of the PMU, any active host counters are going
>>>> to stop counting. We are going to need a way of telling the host perf
>>>> subsystem what's happening, or other host perf clients are going to
>>>> get bogus data.
>>> That's not acceptible behaviour. I'm all for unilaterally killing any
>>> guest that does this.
>>
>> I'm not sure where the "bogus data" comes or to what that refers
>> specifically.  But, the host does have some level of control:
> 
> I was referring to gaps in the collection of data that the host perf
> subsystem doesn't know about if ATTRIBUTES.PERFMON is set for a TDX
> guest. This can potentially be a problem if someone is trying to
> measure events per unit of time.

Ahh, that makes sense.

Does SGX cause problem for these people?  It can create some of the same
collection gaps:

	performance monitoring activities are suppressed when entering
	an opt-out (of performance monitoring) enclave.

>>> The host VMM controls whether a guest TD can use the performance
>>> monitoring ISA using the TD’s ATTRIBUTES.PERFMON bit...
>>
>> So, worst-case, we don't need to threaten to kill guests.  The host can
>> just deny access in the first place.
>>
>> I'm not too picky about what the PMU does, but the TDX behavior didn't
>> seem *that* onerous to me.  The gory details are all in "On-TD
>> Performance Monitoring" here:
>>
>>> https://www.intel.com/content/dam/develop/external/us/en/documents/tdx-module-1.0-public-spec-v0.931.pdf
>>
>> My read on it is that TDX host _can_ cede the PMU to TDX guests if it
>> wants.  I assume the context-switching model Jim mentioned is along the
>> lines of what TDX is already doing on host<->guest transitions.
> 
> Right. If ATTRIBUTES.PERFMON is set, then "perfmon state is
> context-switched by the Intel TDX module across TD entry and exit
> transitions." Furthermore, the VMM has no access to guest perfmon
> state.
> 
> If you're saying that setting this bit is unacceptable, then perhaps
> the TDX folks need to redesign their in-guest PMU support.

It's fine with *me*, but I'm not too picky about the PMU.  But, it
sounded like Peter was pretty concerned about it.

In any case, if we (Linux folks) need a change, it's *possible* because
most of this policy is implemented in software in the TDX module.  It
would just be painful for the folks who came up with the existing mechanism.

