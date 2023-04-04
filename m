Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5719E6D56E1
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 04:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbjDDCps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 22:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDDCpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 22:45:46 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2044B173B
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 19:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680576346; x=1712112346;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DUwQmkSqkYE5BFr6tjwLh8kLx9sndocG5guLoTgp+0Q=;
  b=cdORzF5fokNluBftQZRzd1c2y2Op5ZbUPLcanRO4qPhFM74TYeK7Z0xZ
   rF9I/VHXTTOJdEuSohjlIl2Fw7gmy6eIEzNVhEl8i7sr1Zf+QWNmQJiQR
   DCF26Pn++hTFnT/ci/0rr5ZVLvNp7Vbjkffx5Gu/xRTdF4k8xAUxU59kw
   VnGr8BP4LGy5H8iqtAAywMt+QgfVCAkrYNloBGxYvLt0hH5hKJmSMZfTy
   ywdfAhQjzoTD5OJF9cpZM/GRT5NLIuB6OTml35gtU2SVaosSqdDIwDCsJ
   82txj/vvqzRooVp3sD+You9XjqWM7vyGrtKUqFQP4ZFrp+gHeOk9buu7X
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="326090586"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="326090586"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 19:45:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="860425789"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="860425789"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.215.140]) ([10.254.215.140])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 19:45:43 -0700
Message-ID: <9d0b7b6e-9067-0ff6-c28b-358b2e39b5a8@linux.intel.com>
Date:   Tue, 4 Apr 2023 10:45:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
To:     "Huang, Kai" <kai.huang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-3-binbin.wu@linux.intel.com> <ZBhTa6QSGDp2ZkGU@gao-cwp>
 <ZBojJgTG/SNFS+3H@google.com>
 <12c4f1d3c99253f364f3945a998fdccb0ddf300f.camel@intel.com>
 <e0442b13-09f4-0985-3eb4-9b6a20d981fb@linux.intel.com>
 <682d01dec42ecdb80c9d3ffa2902dea3b1d576dd.camel@intel.com>
 <b9e9dd1c-2213-81c7-cd45-f5cf7b86610b@linux.intel.com>
 <ZCR2PBx/4lj9X0vD@google.com>
 <657efa6471503ee5c430e5942a14737ff5fbee6e.camel@intel.com>
 <349bd65a-233e-587c-25b2-12b6031b12b6@linux.intel.com>
 <fc92490afc7ee1b9679877878de64ad129853cc0.camel@intel.com>
 <559ebca9-dfb9-e041-3744-5eab36f4f4c5@linux.intel.com>
 <71214e870df7c280e2f7ddcd264c73e3191958d9.camel@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <71214e870df7c280e2f7ddcd264c73e3191958d9.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/4/2023 9:53 AM, Huang, Kai wrote:
> On Tue, 2023-04-04 at 09:21 +0800, Binbin Wu wrote:
>> On 4/3/2023 7:24 PM, Huang, Kai wrote:
>>>>
>>>> Anyway, I will seperate this patch from the LAM KVM enabling patch. And
>>>> send a patch seperately if
>>>> needed later.
>>>>
>>> I think your change for SGX is still needed based on the pseudo code of ENCLS.
>> Yes, I meant I would seperate VMX part since it is not a bug after all,
>> SGX will still be in the patchset.
>>
>>
> Shouldn't SGX part be also split out as a bug fix patch?
>
> Does it have anything to do with this LAM support series?

It is related to LAM support because LAM only effective in 64-bit mode,
so the untag action should only be done in 64-bit mode.

If the SGX fix patch is not included, that means LAM untag could be 
called in compatiblity mode in SGX ENCLS handler.


