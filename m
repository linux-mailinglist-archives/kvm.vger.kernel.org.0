Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8050D55A789
	for <lists+kvm@lfdr.de>; Sat, 25 Jun 2022 08:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbiFYGih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Jun 2022 02:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbiFYGie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Jun 2022 02:38:34 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CE3286E6
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 23:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656139112; x=1687675112;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2GVOELFET4V9Emza9rgt3+SLSkc5qIevmxdyDSTK2Uw=;
  b=ibgc6CCHDzPqZYJKxs5YIhVJ3rcVCevt/RvkSE59mq0P9KeOsAro/PYP
   BWKggaDfn+pOs2qqmwl4f+khtsly+gjD/CS5zn6MG3yKwRD6u3O8Jxkqh
   bfzAoPh1GaXkS9ID3Ygfdd0rE7AaAW49jWROzJ6uCh5ORHgJyVyIQlENx
   zHgSx3O3KbjF+JZWwfL/gAvTRT8N5WfejyH6cumfEvvXpxTCSb4ZdO3RR
   Zt0QWcySpqii17Ufg6l4HSazz1TvOo1UJ1Ct8plQulPZt8l+9gX3ABnRb
   K9S/Um0QQhyFF1zyTB90lEu5wezmGgobMiqaSzLc9qygFAYIUchJxyiSo
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10388"; a="345158534"
X-IronPort-AV: E=Sophos;i="5.92,221,1650956400"; 
   d="scan'208";a="345158534"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 23:38:32 -0700
X-IronPort-AV: E=Sophos;i="5.92,221,1650956400"; 
   d="scan'208";a="645601115"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.249.169.7]) ([10.249.169.7])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 23:38:30 -0700
Message-ID: <42995965-35f3-96f9-27b5-931db8880548@intel.com>
Date:   Sat, 25 Jun 2022 14:38:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 3/3] x86: Check platform vPMU capabilities before run
 lbr tests
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
References: <20220624090828.62191-1-weijiang.yang@intel.com>
 <20220624090828.62191-4-weijiang.yang@intel.com>
 <YrY5ZNGjyWhPJy1Z@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <YrY5ZNGjyWhPJy1Z@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/25/2022 6:23 AM, Sean Christopherson wrote:
> On Fri, Jun 24, 2022, Yang Weijiang wrote:
>> Use new helper to check whether pmu is available and Perfmon/Debug
>> capbilities are supported before read MSR_IA32_PERF_CAPABILITIES to
>> avoid test failure. The issue can be captured when enable_pmu=0.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   lib/x86/processor.h |  2 +-
>>   x86/pmu_lbr.c       | 32 +++++++++++++-------------------
>>   2 files changed, 14 insertions(+), 20 deletions(-)
>>
>> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>> index 70b9193..bb917b0 100644
>> --- a/lib/x86/processor.h
>> +++ b/lib/x86/processor.h
>> @@ -193,7 +193,7 @@ static inline bool is_intel(void)
>>   #define X86_FEATURE_PAUSEFILTER     (CPUID(0x8000000A, 0, EDX, 10))
>>   #define X86_FEATURE_PFTHRESHOLD     (CPUID(0x8000000A, 0, EDX, 12))
>>   #define	X86_FEATURE_VGIF		(CPUID(0x8000000A, 0, EDX, 16))
>> -
>> +#define	X86_FEATURE_PDCM		(CPUID(0x1, 0, ECX, 15))
> Please try to think critically about the code you're writing.  All of the existing
> X86_FEATURE_* definitions are organized by leaf, sub-leaf, register _and_ bit
> position.  And now there's X86_FEATURE_PDCM...
My fault, will put it at the right place. thanks!
