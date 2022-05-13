Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B43105265C8
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 17:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350758AbiEMPPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 11:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381809AbiEMPPB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 11:15:01 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7402656C18;
        Fri, 13 May 2022 08:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652454900; x=1683990900;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=px2gXoFjNpJE9vOVgtdtDq3mf97BJY5Gb4Y2uSDouZw=;
  b=HWfBYkHhyoEDXP/HX92XHIFqjRjQx9eTA6iwEHu9e6gmIxNGbJOVNEk/
   H0MspkSI4vk8FALQFMuRBtQ7ZVipp4z2VABUgRTGga6m1wnNN4i0eszbz
   mZNtA6I4PW4hZlI9HvP1y3KBTmKgfKpB3de+vdfYhR59acxsI3W/0Nfdl
   O248/ibzZVeP8Wx3NLNnI+g15UNlP8eYKF5btBkoP1E4jf+lKLaYyNsVB
   XFKWJGSDDfYs4cZw7rt+fACbg+IFtIxYO1qT+B+Ktm2r0dEWMYC2JdnjZ
   7i1XjKaAi/BOYnSf0G+PNrWRdOQ0sEHkifWXdQzVE1guznxyN7sLL+G7O
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10346"; a="252373500"
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="252373500"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 08:14:56 -0700
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="595263034"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.36.190])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 08:14:53 -0700
Message-ID: <df56f04b-cb25-5a47-ffef-b2e2ee0f6b74@intel.com>
Date:   Fri, 13 May 2022 18:14:49 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [PATCH 6/6] perf intel-pt: Add guest_code support
Content-Language: en-US
To:     Andi Kleen <ak@linux.intel.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Leo Yan <leo.yan@linaro.org>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220513090237.10444-1-adrian.hunter@intel.com>
 <20220513090237.10444-7-adrian.hunter@intel.com>
 <875ym9h4mt.fsf@linux.intel.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <875ym9h4mt.fsf@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/22 17:46, Andi Kleen wrote:
> Adrian Hunter <adrian.hunter@intel.com> writes:
> 
>> A common case for KVM test programs is that the guest object code can be
>> found in the hypervisor process (i.e. the test program running on the
>> host). To support that, a new option "--guest-code" has been added in
>> previous patches.
>>
>> In this patch, add support also to Intel PT.
>>
>> In particular, ensure guest_code thread is set up before attempting to
>> walk object code or synthesize samples.
> 
> Can you make it clear in the documentation what parts runs on the host
> and what parts on the guest? 

That is up to the test program.  All the host thread maps are
copied, so perf tools doesn't have to know.

> 
> I'm still not fully sure how it exactly finds the code on the host,
> how is the code transferred?

I don't know.  From a quick look at the code in
tools/testing/selftests/kvm/lib/kvm_util.c it seems to be using
KVM_SET_USER_MEMORY_REGION IOCTL.

> 
> Other than that more support for this use case is very useful.
> 
> -Andi

