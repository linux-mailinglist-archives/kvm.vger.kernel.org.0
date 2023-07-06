Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA51749FC7
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 16:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbjGFOvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 10:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbjGFOvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 10:51:14 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91608E70;
        Thu,  6 Jul 2023 07:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688655058; x=1720191058;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0nzzDQA6LpkeZuLlmFjdXa775S2+WzO38zFOZwwC/sU=;
  b=JbccH/kiOWKQ9Z56vwZMtb+fTlWhuxAbJM8I37bm101SI2uQxlSk/a1/
   5s2y+UQaokH3ApRtuKypJwPDcSVIqTrCK1XOkL5sDDMjg8IIVaszoZ/oR
   PcttBpIGdfE9T8HakJHz8ZsCRPB6qzf2ah4Q418eLScp/VFZaOc3cNriU
   gwV7tibRpQGgTNYFLL3oxRYRwz6pCJfK2Bb+y9V3vd1JCNPL0nEAreNaq
   hO4KrBF68+n0hbQXlwjnBiobREJlCPJfeENI9MkN4qw470Wr6JloGafb+
   C8Il7X2L9lpB95zq93jksUhYAIeWw4159k4YXrVHuHxmHMWJD0+tqkimf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10763"; a="343209105"
X-IronPort-AV: E=Sophos;i="6.01,185,1684825200"; 
   d="scan'208";a="343209105"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2023 07:49:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10763"; a="749174196"
X-IronPort-AV: E=Sophos;i="6.01,185,1684825200"; 
   d="scan'208";a="749174196"
Received: from adityan1-mobl1.amr.corp.intel.com (HELO [10.212.197.9]) ([10.212.197.9])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2023 07:49:53 -0700
Message-ID: <0c32f845-aad0-3059-2efa-9f6e3bb3affb@intel.com>
Date:   Thu, 6 Jul 2023 07:49:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, Sagi Shahar <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, Chao Gao <chao.gao@intel.com>,
        Len Brown <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Ying Huang <ying.huang@intel.com>,
        Dan J Williams <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
 <20230628131717.GE2438817@hirez.programming.kicks-ass.net>
 <0c9639db604a0670eeae5343d456e43d06b35d39.camel@intel.com>
 <20230630092615.GD2533791@hirez.programming.kicks-ass.net>
 <2659d6eef84f008635ba300f4712501ac88cef2c.camel@intel.com>
 <20230630183020.GA4253@hirez.programming.kicks-ass.net>
 <20230630190514.GH3436214@ls.amr.corp.intel.com>
 <ZJ9IKALhz1Q6ogu1@google.com>
 <20230704165836.GB462772@hirez.programming.kicks-ass.net>
 <1a8099e2-da28-6b2a-7b5a-1d6346b7f95d@intel.com>
 <20230705145750.GD4253@hirez.programming.kicks-ass.net>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230705145750.GD4253@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/5/23 07:57, Peter Zijlstra wrote:
> On Wed, Jul 05, 2023 at 07:34:06AM -0700, Dave Hansen wrote:
>> On 7/4/23 09:58, Peter Zijlstra wrote:
>>> If we have concerns about allocating the PAMT array, can't we use CMA
>>> for this? Allocate the whole thing at boot as CMA such that when not
>>> used for TDX it can be used for regular things like userspace and
>>> filecache pages?
>> I never thought of CMA as being super reliable.  Maybe it's improved
>> over the years.
>>
>> KVM also has a rather nasty habit of pinning pages, like for device
>> passthrough.  I suspect that means that we'll have one of two scenarios:
>>
>>  1. CMA works great, but the TDX/CMA area is unusable for KVM because
>>     it's pinning all its pages and they just get moved out of the CMA
>>     area immediately.  The CMA area is effectively wasted.
>>  2. CMA sucks, and users get sporadic TDX failures when they wait a long
>>     time to run a TDX guest after boot.  Users just work around the CMA
>>     support by starting up TDX guests at boot or demanding a module
>>     parameter be set.  Hacking in CMA support was a waste.
>>
>> Am I just too much of a pessimist?
> Well, if CMA still sucks, then that needs fixing. If CMA works, but we
> have a circular fail in that KVM needs to long-term pin the PAMT pages
> but long-term pin is evicted from CMA (the whole point of long-term pin,
> after all), then surely we can break that cycle somehow, since in this
> case the purpose of the CMA is being able to grab that memory chunk when
> we needs it.
> 
> That is, either way around is just a matter of a little code, no?

It's not a circular dependency, it's conflicting requirements.

CMA makes memory more available, but only in the face of unpinned pages.

KVM can pin lots of pages, even outside of TDX-based VMs.

So we either need to change how CMA works fundamentally or stop KVM from
pinning pages.


