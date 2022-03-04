Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288944CDC6B
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 19:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241653AbiCDS2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 13:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241639AbiCDS2j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 13:28:39 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36224DF46;
        Fri,  4 Mar 2022 10:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646418470; x=1677954470;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DWG7yBjX/SsVDq1FNBzX1eDw1t6YL3NhhuMKSucJuqU=;
  b=O4vH4eOHEJQ7lchSM0g0Gr3Fu9772Hi3MWYOc8quI/8yJRWiqvfRB7W0
   nxk7/fl7yKWKa3S+WkqfQQqcOBUtOtibh2v5CrVUBFcmji2QCiSmWqllW
   9wrlz1ue5RSQaPQr2hmY+ver7/ZOby0cydtIqLmVUaDY+68BCdJw63v8G
   AnBtEbaF1ZXgk5t7zcKwMg031MtZbAs9SCrKyg2cvpTXdAPpadO+hXkX4
   pLS0dtmjI3z3s/9RgSOKf+KXfWX/jbUJX/Pz6SO5QS91n5LenRVKjlrVw
   PoiSIY8E2KS0CM6FkzfbFwkrfYNRXQZD/KMs9X5uUgfsOr5UfXLH9lDTf
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253969031"
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="253969031"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 10:27:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="552317837"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.92]) ([10.237.72.92])
  by orsmga008.jf.intel.com with ESMTP; 04 Mar 2022 10:27:46 -0800
Message-ID: <853ce127-25f0-d0fe-1d8f-0b0dd4f3ce71@intel.com>
Date:   Fri, 4 Mar 2022 20:27:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH V2 03/11] perf/x86: Add support for TSC in nanoseconds as
 a perf event clock
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, H Peter Anvin <hpa@zytor.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leo Yan <leo.yan@linaro.org>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
 <20220214110914.268126-4-adrian.hunter@intel.com>
 <YiIXFmA4vpcTSk2L@hirez.programming.kicks-ass.net>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <YiIXFmA4vpcTSk2L@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/03/2022 15:41, Peter Zijlstra wrote:
> On Mon, Feb 14, 2022 at 01:09:06PM +0200, Adrian Hunter wrote:
>> Currently, when Intel PT is used within a VM guest, it is not possible to
>> make use of TSC because perf clock is subject to paravirtualization.
> 
> Yeah, so how much of that still makes sense, or ever did? AFAIK the
> whole pv_clock thing is utter crazy. Should we not fix that instead?

Presumably pv_clock must work with different host operating systems.
Similarly, KVM must work with different guest operating systems.
Perhaps I'm wrong, but I imagine re-engineering time virtualization
might be a pretty big deal,  far exceeding the scope of these patches.

While it is not something that I really need, it is also not obvious
that the virtualization people would see any benefit.

My primary goal is to be able to make a trace covering the host and
(Linux) guests.  Intel PT can do that.  It can trace straight through
VM-Entries/Exits, politely noting them on the way past.  Perf tools
already supports decoding that, but only for tracing the kernel because
it needs more information (so-called side-band events) to decode guest
user space.  The simplest way to get that is to run perf inside the
guests to capture the side-band events, and then inject them into the
host perf.data file during post processing.  That, however, requires a
clock that works for both host and guests.  TSC is suitable because
KVM largely leaves it alone, except for VMX TSC Offset and Scaling,
but that has to be dealt with anyway because it also affects the
Intel PT trace.
