Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42A84AF591
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 16:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbiBIPlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 10:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236177AbiBIPld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 10:41:33 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C930C05CB89;
        Wed,  9 Feb 2022 07:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644421296; x=1675957296;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=nqAEzwP2CCzE4PuDlqHV3gy81D6zg7WpHFijeg3mZf8=;
  b=DypwGKUp89RJcd+xcpeRpBJlKZ6nOVbGA5lwMshJ4hhMNS7DtsZB1/76
   4v2AEKOHNFxfGIJCVRUG+nnFkaZTX/NLnHZY4kcC6LNGFANNrb+FAbER7
   kz64AsnwnjbjpcTig4Qn06j+fvg9SLt2L1vUe4ZLEOBq8ML0fACpPNqCR
   Zv3Tsk5rQmpCYmVd4SSizehLsoaMlwJp+5jd3yZWt6CEsK6wbJ5oSWXhn
   M1SN04eFxrcYipYsEeuJ1XTSAcsLJE+lKYiLLTILJN9/Ed5u1RwkvjLEX
   LpA6g1gvZHarXOGB8wapz9UfioYzCh6ln0OSoYd9OlckxNygr3dXi1K2a
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="335631969"
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="335631969"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 07:41:02 -0800
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="568271798"
Received: from sanvery-mobl.amr.corp.intel.com (HELO [10.212.232.139]) ([10.212.232.139])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 07:41:02 -0800
Message-ID: <69c0fc41-a5bd-fea9-43f6-4724368baf66@intel.com>
Date:   Wed, 9 Feb 2022 07:40:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Jim Mattson <jmattson@google.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
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
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
In-Reply-To: <YgO/3usazae9rCEh@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/22 05:21, Peter Zijlstra wrote:
> On Wed, Feb 02, 2022 at 02:35:45PM -0800, Jim Mattson wrote:
>> 3) TDX is going to pull the rug out from under us anyway. When the TDX
>> module usurps control of the PMU, any active host counters are going
>> to stop counting. We are going to need a way of telling the host perf
>> subsystem what's happening, or other host perf clients are going to
>> get bogus data.
> That's not acceptible behaviour. I'm all for unilaterally killing any
> guest that does this.

I'm not sure where the "bogus data" comes or to what that refers
specifically.  But, the host does have some level of control:

> The host VMM controls whether a guest TD can use the performance
> monitoring ISA using the TD’s ATTRIBUTES.PERFMON bit...

So, worst-case, we don't need to threaten to kill guests.  The host can
just deny access in the first place.

I'm not too picky about what the PMU does, but the TDX behavior didn't
seem *that* onerous to me.  The gory details are all in "On-TD
Performance Monitoring" here:

> https://www.intel.com/content/dam/develop/external/us/en/documents/tdx-module-1.0-public-spec-v0.931.pdf

My read on it is that TDX host _can_ cede the PMU to TDX guests if it
wants.  I assume the context-switching model Jim mentioned is along the
lines of what TDX is already doing on host<->guest transitions.
