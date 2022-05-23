Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E9A531306
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 18:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238271AbiEWP4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 11:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238282AbiEWPz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 11:55:58 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E87652B2A;
        Mon, 23 May 2022 08:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653321356; x=1684857356;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/SvgtnbrTcyFxT3V8Yw8Zvk25pwqcKM3FaWkynyJDfQ=;
  b=WlxGJpYnCeBl+dxVHJKGBLGDwlKl3ZaHHChNLggdUchh1pMZn1EwgmYI
   6MOvMeetGjjiumYPSCBVN4iY6Ppo8QWW2tHtmqtp5f/A9KdBM4hGDLbWV
   BCcvg7bSFO/eviJsbhtP+gbLeocwqSvsW4Jr+lIFINNQs1FC928RNr9Qb
   k9pHrfI/TfRLJZnWi/pfIu93LO+fSbzLc12MfI6hj8WdjVdEknhiSNdzZ
   5EXtB5RxVTvcQrm6PuIEqUp2XNbQKoLRyKt7YpLU3j1n+RHVbCenkU5Mi
   ZLB90pcmzdN0WmOURHe3qgpKppVvsIpRccI55Lte6S4AS4oicEApxqhbS
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="359657217"
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="359657217"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 08:54:51 -0700
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="600718969"
Received: from akleen-mobl1.amr.corp.intel.com (HELO [10.209.116.169]) ([10.209.116.169])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 08:54:51 -0700
Message-ID: <2ff19ce9-98e3-7867-9762-ffae049f1d9b@linux.intel.com>
Date:   Mon, 23 May 2022 08:54:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH V2 5/6] perf kvm report: Add guest_code support
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Leo Yan <leo.yan@linaro.org>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220517131011.6117-1-adrian.hunter@intel.com>
 <20220517131011.6117-6-adrian.hunter@intel.com>
From:   Andi Kleen <ak@linux.intel.com>
In-Reply-To: <20220517131011.6117-6-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/17/2022 6:10 AM, Adrian Hunter wrote:
> Add an option to indicate that guest code can be found in the hypervisor
> process

Sorry for harping on this, but is it correct that this assumes that the 
code is still at the original location at decode time?

If yes we need some warnings for this, something like:

This only works when the code is still available in the riginal memory 
location at decode time. This is typically the case for kernel code 
(unless modules are unloaded). For user programs it only works as long 
as there is no memory pressure which might cause the memory to be 
reused. For dynamically generated (JITed) code it might be rather 
unreliable unless the hypervisor is SIGSTOPed during decoding.

