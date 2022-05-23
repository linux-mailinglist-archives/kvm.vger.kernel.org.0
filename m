Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6CC5318F3
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241247AbiEWS2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 14:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244199AbiEWS14 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 14:27:56 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB5413C355;
        Mon, 23 May 2022 11:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653329014; x=1684865014;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AAirzVQ1LHT4q1Vz0Dd+gXv6Ma1E8XYPflgQ8RPZTuY=;
  b=CW29qTdcVhJv6pH6rb5oe8A9s9XiSi9CSVFCpWPumc85c9m729tMy+FM
   O6N+WFSQ6PpNNwDfmoeu/YRK85oF993QyVEGwb+AIitsMx5hW1ghMqN8O
   z2aW/OADrvGt3MXZ55n6N4wRni6o130Ijh6dUW97R1hJw+zfJM5b7MbBA
   6icjHK1idVNv3HtS3ZyS7+kLM1p8GfjqJ7mV+eZxkzUw6nuzpslb/ZOmj
   g47G1cZPFqm2RGpelJqqdOkfu3NPiBwIFPp6DfH40IU47tl+c3HHN687J
   thSbqs0S3Tx+gXZCZqPLUejZJq8ekzH7sCctsZoBoFGGUmLXxBYTtksfE
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="253808334"
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="253808334"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 10:56:33 -0700
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="572224825"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.56.27])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 10:56:29 -0700
Message-ID: <46470b7f-377b-5192-60c6-8dac2fdd196e@intel.com>
Date:   Mon, 23 May 2022 20:56:23 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH V2 5/6] perf kvm report: Add guest_code support
Content-Language: en-US
To:     Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Leo Yan <leo.yan@linaro.org>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220517131011.6117-1-adrian.hunter@intel.com>
 <20220517131011.6117-6-adrian.hunter@intel.com>
 <2ff19ce9-98e3-7867-9762-ffae049f1d9b@linux.intel.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <2ff19ce9-98e3-7867-9762-ffae049f1d9b@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/05/22 18:54, Andi Kleen wrote:
> 
> On 5/17/2022 6:10 AM, Adrian Hunter wrote:
>> Add an option to indicate that guest code can be found in the hypervisor
>> process
> 
> Sorry for harping on this, but is it correct that this assumes that the code is still at the original location at decode time?

No, at decode time, the code is found in the hypervisor dso.

> 
> If yes we need some warnings for this, something like:
> 
> This only works when the code is still available in the riginal memory location at decode time. This is typically the case for kernel code (unless modules are unloaded). 

In this scenario, the VM does not have a kernel.

Note, there is an existing method to trace a guest kernel as described here:

	https://www.man7.org/linux/man-pages/man1/perf-intel-pt.1.html#TRACING_VIRTUAL_MACHINES

For user programs it only works as long as there is no memory pressure which might cause the memory to be reused.

In this scenario, there are also no user programs in the VM, only functions from the hypervisor.

For dynamically generated (JITed) code it might be rather unreliable unless the hypervisor is SIGSTOPed during decoding.
> 



