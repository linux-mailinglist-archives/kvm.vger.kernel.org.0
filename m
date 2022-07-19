Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C03579777
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 12:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbiGSKSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 06:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiGSKSR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 06:18:17 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5731A3A6;
        Tue, 19 Jul 2022 03:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658225895; x=1689761895;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=l2szk8FN3725tnHL17BJQNWuj8HvSKSQKxxvRKjThkk=;
  b=CwWXUsJ/epsjM234b4QQ+TPOuACK++Y+h3yB+IPnXvW1veh2RIeOED1m
   H8iy5mQMR8IZEdZNF8MHZdpobeAGKHeNnL2Vp0aR5FkLImTIoi7HYyrlC
   Cm1hk2ar9uj29LNEQaS+U0bX/9VaIKyCeYvLk3trGB3B+b9DFJ20sKq5H
   EJzxRbb1Fov2Zp2yHRYJtpTFwJZ1OqNsVfUElWR3V+CJgRKdHdjR+ktF4
   UUP3/k9p2U9ANjxIrp6sX0UkxK8VsKWv527zKP+gIWowxTEvO+P5e++ip
   gpviXF8o1Sr0SUsnbPFPZCv09ekppKxujV/H6FEe1vEYYXInkk/4LRZB+
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="287604532"
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="287604532"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 03:18:15 -0700
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="572794100"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.41.111])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 03:18:13 -0700
Message-ID: <569b5766-eb6f-8811-c5e5-f5a6972a0fd5@intel.com>
Date:   Tue, 19 Jul 2022 13:18:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH 01/35] perf tools: Fix dso_id inode generation comparison
Content-Language: en-US
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220711093218.10967-1-adrian.hunter@intel.com>
 <20220711093218.10967-2-adrian.hunter@intel.com>
 <YtV0vXJLbfTywZ1B@kernel.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <YtV0vXJLbfTywZ1B@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/07/22 17:57, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jul 11, 2022 at 12:31:44PM +0300, Adrian Hunter escreveu:
>> Synthesized MMAP events have zero ino_generation, so do not compare zero
>> values.
>>
>> Fixes: 0e3149f86b99 ("perf dso: Move dso_id from 'struct map' to 'struct dso'")
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/util/dsos.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/perf/util/dsos.c b/tools/perf/util/dsos.c
>> index b97366f77bbf..839a1f384733 100644
>> --- a/tools/perf/util/dsos.c
>> +++ b/tools/perf/util/dsos.c
>> @@ -23,8 +23,14 @@ static int __dso_id__cmp(struct dso_id *a, struct dso_id *b)
>>  	if (a->ino > b->ino) return -1;
>>  	if (a->ino < b->ino) return 1;
>>  
>> -	if (a->ino_generation > b->ino_generation) return -1;
>> -	if (a->ino_generation < b->ino_generation) return 1;
>> +	/*
>> +	 * Synthesized MMAP events have zero ino_generation, so do not compare
>> +	 * zero values.
>> +	 */
>> +	if (a->ino_generation && b->ino_generation) {
>> +		if (a->ino_generation > b->ino_generation) return -1;
>> +		if (a->ino_generation < b->ino_generation) return 1;
>> +	}
> 
> But comparing didn't harm right? when its !0 now we may have three
> comparisions instead of 2 :-\
> 
> The comment has some value tho, so I'm merging this :-)

Thanks. I found it harmful because the mismatch resulted in a new
dso that did not have a build ID whereas the original dso did have
a build ID.  The build ID was essential because the object was not
found otherwise.
