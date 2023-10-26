Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06677D7B46
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 05:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbjJZDcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 23:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjJZDci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 23:32:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D3EA3;
        Wed, 25 Oct 2023 20:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698291156; x=1729827156;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=j0Fz8CzB06Dw8BJlqfX5Ul19OnFcKlSskxt2P3MS9M8=;
  b=WtxMPDhV5kM7LIgdkxP/zHJX1NuY8lnNkN2ZOsAEWYNS5HWbdt6wJBAL
   DO/bjR24ZPMDeoMqJBa/fClgPZul66L8S3hjoL5nwrDNKeWGnvKP3mPki
   FhtLPCzH2oLsX0QXnfBoncH9hYCp2lmemBvIBEwa9mAtrqXiIjE6RWZ7G
   vO/zogzHFgAW9iVPhf4oBimxd74l6jCNJ0/EU1TBZDnDy95i0JK6wuP1C
   ZuzldNyoB9S9OACT0AnlMi/DLHXUFjeC+SaD0Eu5k7X75oFbFrUYsHUYR
   LR/2Mx6hC5hPpvEbnss3NWbcpK+GW9ZGUGsSibvUv7hcotnZbDIFmCvZK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="366800559"
X-IronPort-AV: E=Sophos;i="6.03,252,1694761200"; 
   d="scan'208";a="366800559"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 20:32:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="759059876"
X-IronPort-AV: E=Sophos;i="6.03,252,1694761200"; 
   d="scan'208";a="759059876"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.20.184]) ([10.93.20.184])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 20:32:33 -0700
Message-ID: <719318df-dc19-4f4c-88ff-5c69377f713c@linux.intel.com>
Date:   Thu, 26 Oct 2023 11:32:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch 0/5] Fix PMU test failures on Sapphire
 Rapids
Content-Language: en-US
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Dapeng Mi <dapeng1.mi@intel.com>
References: <20231024075748.1675382-1-dapeng1.mi@linux.intel.com>
 <ZTmo9IVM2Tq6ZSrn@google.com>
From:   "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZTmo9IVM2Tq6ZSrn@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/26/2023 7:47 AM, Mingwei Zhang wrote:
> On Tue, Oct 24, 2023, Dapeng Mi wrote:
>> When running pmu test on Intel Sapphire Rapids, we found several
>> failures are encountered, such as "llc misses" failure, "all counters"
>> failure and "fixed counter 3" failure.
> hmm, I have tested your series on a SPR machine. It looks like, all "llc
> misses" already pass on my side. "all counters" always fail with/without
> your patches. "fixed counter 3" never exists... I have "fixed
> cntr-{0,1,2}" and "fixed-{0,1,2}"

1. "LLC misses" failure

Yeah, the "LLC misses" failure is not always seen. I can see the "LLC  
misses" 2 ~3 times out of 10 runs of PMU standalone test and you could 
see the failure with higher possibility if you run the full 
kvm-unit-tests. I think whether you can see the "LLC misses" failure it 
really depends on current cache status on your system, how much cache 
memory are consumed by other programs. If there are lots of free cache 
lines on system when running the pmu test, you may have higher 
possibility to see the LLC misses failures just like what I see below.

PASS: Intel: llc references-7
*FAIL*: Intel: llc misses-0
PASS: Intel: llc misses-1
PASS: Intel: llc misses-2

2. "all counters" failure

Actually the "all counters" failure are not always seen, but it doesn't 
mean current code is correct. In current code, the length of "cnt[10]" 
array in check_counters_many() is defined as 10, but there are at least 
11 counters supported (8 GP counters + 3 fixed counters) on SPR even 
though fixed counter 3 is not supported in current upstream code. 
Obviously there would be out of range memory access in 
check_counters_many().

>
> You may want to double check the requirements of your series. Not just
> under your setting without explainning those setting in detail.
>
> Maybe what I am missing is your topdown series? So, before your topdown
> series checked in. I don't see value in this series.

3. "fixed counter 3" failure

Yeah, I just realized I used the kernel which includes the vtopdown 
supporting patches after Jim's reminding. As the reply for Jim's 
comments says, the patches for support slots event are still valuable 
for current emulation framework and I would split them from the original 
vtopdown patchset and resend them as an independent patchset. Anyway, 
even though there is not slots event support in Kernel, it only impacts 
the patch 4/5, other patches are still valuable.


>
> Thanks.
> -Mingwei
>> Intel Sapphire Rapids introduces new fixed counter 3, total PMU counters
>> including GP and fixed counters increase to 12 and also optimizes cache
>> subsystem. All these changes make the original assumptions in pmu test
>> unavailable any more on Sapphire Rapids. Patches 2-4 fixes these
>> failures, patch 0 remove the duplicate code and patch 5 adds assert to
>> ensure predefine fixed events are matched with HW fixed counters.
>>
>> Dapeng Mi (4):
>>    x86: pmu: Change the minimum value of llc_misses event to 0
>>    x86: pmu: Enlarge cnt array length to 64 in check_counters_many()
>>    x86: pmu: Support validation for Intel PMU fixed counter 3
>>    x86: pmu: Add asserts to warn inconsistent fixed events and counters
>>
>> Xiong Zhang (1):
>>    x86: pmu: Remove duplicate code in pmu_init()
>>
>>   lib/x86/pmu.c |  5 -----
>>   x86/pmu.c     | 17 ++++++++++++-----
>>   2 files changed, 12 insertions(+), 10 deletions(-)
>>
>>
>> base-commit: bfe5d7d0e14c8199d134df84d6ae8487a9772c48
>> -- 
>> 2.34.1
>>
