Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6DE76C7EC
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 10:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbjHBIGA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 04:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbjHBIF7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 04:05:59 -0400
Received: from mgamail.intel.com (unknown [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AAFDE
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 01:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690963558; x=1722499558;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=s7uxDsvdyNjvEpJX+EuA7U1P4mwvUNZMv60CP4+Om6s=;
  b=LxNOGReUz1p79eVs8lEiyHSLMTJmJu/ijYW4cjtf6yfd02T3y+m/CZ2D
   gh/WT256NJLPcZbsd1KH+E1O1AOAxm5xuxejoWbdQOF16GYyaoFcP4N6E
   EeS5u16KPPxItzdUzQjpmbMrzzfHMS1XpkBwoPPaMH1ThWId0Wxyj/2+T
   y/EM5OU411VMCBf89bwvdOOKFMoP2aSmyajKABjhGf+7x/EUky/Xk2Ec3
   laRkWHLlcn5IpM9ZCpdh47QBhCXlbfM5sPAfcz4zm+G8V1Joyi1qixEZr
   W21kAHzx4eNKRqb0qtNtwS7IsnAEfbgmOoQE956KrubElQh0r1mZhnDNF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="368411913"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="368411913"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2023 01:05:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="732289713"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="732289713"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2023 01:05:53 -0700
Message-ID: <02e6d578-63c0-1453-42a1-5c315ce51529@intel.com>
Date:   Wed, 2 Aug 2023 16:05:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [RFC PATCH 04/19] memory: Introduce
 memory_region_can_be_private()
Content-Language: en-US
To:     Claudio Fontana <cfontana@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <20230731162201.271114-5-xiaoyao.li@intel.com>
 <3a14456d-244c-ce8f-9d1c-8bcdb75de81c@suse.de>
 <835a9d0c-4e3a-d2b6-6392-a17f583f0842@suse.de>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <835a9d0c-4e3a-d2b6-6392-a17f583f0842@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/2/2023 12:52 AM, Claudio Fontana wrote:
> On 8/1/23 18:48, Claudio Fontana wrote:
>> On 7/31/23 18:21, Xiaoyao Li wrote:
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> ---
>>>   include/exec/memory.h | 9 +++++++++
>>>   softmmu/memory.c      | 5 +++++
>>>   2 files changed, 14 insertions(+)
>>>
>>> diff --git a/include/exec/memory.h b/include/exec/memory.h
>>> index 61e31c7b9874..e119d3ce1a1d 100644
>>> --- a/include/exec/memory.h
>>> +++ b/include/exec/memory.h
>>> @@ -1679,6 +1679,15 @@ static inline bool memory_region_is_romd(MemoryRegion *mr)
>>>    */
>>>   bool memory_region_is_protected(MemoryRegion *mr);
>>>   
>>> +/**
>>> + * memory_region_can_be_private: check whether a memory region can be private
>>
>> The name of the function is not particularly informative,
>>
>>> + *
>>> + * Returns %true if a memory region's ram_block has valid gmem fd assigned.
>>
>> but in your comment you describe more accurately what it does, why not make it the function name?
>>
>> bool memory_region_has_valid_gmem_fd()
> 
> 
> btw can a memory region have an invalid gmem_fd ?
> 
> If an invalid gmem_fd is just used to mark whether gmem_fd is present or not,
> 
> we could make it just:
> 
> bool memory_region_has_gmem_fd()

yes. It's a good suggestion!

I will use it in next version if no objection from others.

Thanks,
-Xiaoyao




