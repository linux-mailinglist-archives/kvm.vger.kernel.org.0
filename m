Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDCA861744D
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 03:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiKCCfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 22:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiKCCfT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 22:35:19 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C2312A95;
        Wed,  2 Nov 2022 19:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667442918; x=1698978918;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qijP8nV44V8zutbFDZIO/Mf+o2BCycasqhn7uJt8cGs=;
  b=oIpOm9CtQ9VRxWBdAM/byt3DohYPSjgr0K5JykGP43d5IV6hCnKO0Hd3
   bvdlaFoj2sih4bZTbr0BGUsVY0DKAyhyLKAJnZLlTbMyabj3mUha9vvzT
   Y4R6FEoL4O3ZnOonjwuEGyglK2g2OQ1PLJ4KeTcpYcrYwYYTAD1Ubo9w0
   /c+evCIq5RP/s2d3mXxk3wfeM3jbWDgIaW+sfK1yVz7UtBblIAZoJjV5c
   nbbAGvvKHyaJ/e0s7cq8q69SqZ6cnwrlQRWeWJhBrUHgfAlKkbz65ZyE/
   JFaHJDRCua5nKf0ZH6wHrb/Vxvtqs15h9r7bIiZWP2Lrrm44KDkx03onG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="309566806"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="309566806"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 19:35:18 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="759775361"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="759775361"
Received: from jiaxiche-mobl.ccr.corp.intel.com (HELO [10.238.2.23]) ([10.238.2.23])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 19:35:12 -0700
Message-ID: <e4a17902-e11b-fe1e-30b8-16eefd443883@linux.intel.com>
Date:   Thu, 3 Nov 2022 10:35:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 1/6] x86: KVM: Enable CMPccXADD CPUID and expose it to
 guest
To:     Sean Christopherson <seanjc@google.com>
Cc:     Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        ndesaulniers@google.com, alexandre.belloni@bootlin.com,
        peterz@infradead.org, jpoimboe@kernel.org,
        chang.seok.bae@intel.com, pawan.kumar.gupta@linux.intel.com,
        babu.moger@amd.com, jmattson@google.com, sandipan.das@amd.com,
        tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        fenghua.yu@intel.com, keescook@chromium.org,
        jane.malalane@citrix.com, nathan@kernel.org,
        linux-kernel@vger.kernel.org
References: <20221019084734.3590760-1-jiaxi.chen@linux.intel.com>
 <20221019084734.3590760-2-jiaxi.chen@linux.intel.com>
 <Y1AUhlwWjIkKfZHA@google.com>
 <cce514da-32b4-3b84-cfad-67a05705bc9f@linux.intel.com>
 <Y1lrGgyIcgweVGup@zn.tnic>
 <ad24c33d-8f07-4d73-136f-ad16bb2b1981@linux.intel.com>
 <Y2E2G9Q2wKJnc8dx@google.com>
From:   Jiaxi Chen <jiaxi.chen@linux.intel.com>
In-Reply-To: <Y2E2G9Q2wKJnc8dx@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/1/2022 11:07 PM, Sean Christopherson wrote:
> On Tue, Nov 01, 2022, Jiaxi Chen wrote:
>>
>>
>> On 10/27/2022 1:15 AM, Borislav Petkov wrote:
>>> On Wed, Oct 26, 2022 at 11:40:31AM +0800, Jiaxi Chen wrote:
>>>>> What do you think about moving CPUID_7_1_EAX to be a KVM-only leaf too?  AFAICT,
>>>>> KVM passthrough is the only reason the existing features are defined.
>>>
>>> Yap, looking at the patches which added those 2 feature flags upstream,
>>> they don't look like some particular use was the goal but rather to
>>> expose it to guests. Besides, AVX512 apps do their own CPUID detection.
>>>
>>>> Since CPUID_7_1_EAX has only 5 features now, it is a big waste,       
>>>> should we move it to KVM-only leaf as Sean suggested. What's your     
>>>> opinion about this?                                                   
>>>
>>> Yes, pls do.
>>>
>>> And when you do, make sure to undo what
>>>
>>>   b302e4b176d0 ("x86/cpufeatures: Enumerate the new AVX512 BFLOAT16 instructions")
>>>
>>> added.
>>>
>>> Thx.
>>>
>> Hi Sean and Boris,
>>
>> Just realized moving CPUID_7_1_EAX to kvm-only leaf will not save space
>> in enum cpuid_leafs[]. CPUID_7_1_EAX is indeed removed, but someone
>> else, ie. CPUID_DUMMY needs to take the place, otherwise the cpuid_leafs
>> array would be deranged. Therefore, the length of x86 cpuid leaves is
>> not decreased.
> 
> The order of "enum cpuid_leafs" is completely arbitrary.
> 
> After replacing CPUID_7_1_EAX with CPUID_DUMMY, replace CPUID_DUMMY with the last
> leaf, which is currently CPUID_8000_001F_EAX, and update the #defines accordingly.
> Alternatively, Boris may prefer skipping the intermediate CPUID_DUMMY step and
> just replace CPUID_7_1_EAX with CPUID_8000_001F_EAX straightaway.

Yes, thanks for Sean's kind suggestion. I think use CPUID_DUMMY as the
transition leaf will make the code logic and commit message clearer.
Will change it in v2.
-- 
Regards,
Jiaxi
