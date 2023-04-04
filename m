Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8322F6D5715
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 05:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbjDDDP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 23:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjDDDP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 23:15:56 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2331718
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 20:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680578156; x=1712114156;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pjwfnvy686ftXesM9aWNpE0jbQU3M78kbWirZZHLAGY=;
  b=WkyjDxRtAwaPVSPbIzCnLrrJD/qQ9EqyYNpeWvuyWMgKaFnuTZwP2ZAP
   GXriFpl51Wkr2tbG1GPN8p96tRUWfuPripCZ0BA7K6eOQVrgTFtCLQGrT
   VP7FvZZQxRRtZ+DoRbWLo4n+BTpSacAO4wNDDBrPuGNYnw9IJ9oT0TTVZ
   p5WnmMSg7jgq/TyzJRW12HrogDVwgX0R/QpQcFtMNNV06gxP2oiqYdX3C
   DjTcgQfaeE/TpLu4BxDm/qvOeadO85ypsEkLkfhmQhjY642p8rQH+1cYT
   dlgg3xbMhU+hfKcKU1VzF5RDQbSntBAW5VgoB45ly6RU4g9N8S7CtHr1p
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="428362438"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="428362438"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 20:15:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="636353641"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="636353641"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.215.140]) ([10.254.215.140])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 20:15:53 -0700
Message-ID: <254ee5cf-be58-d33f-4b49-d2405c105a76@linux.intel.com>
Date:   Tue, 4 Apr 2023 11:15:50 +0800
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
 <9d0b7b6e-9067-0ff6-c28b-358b2e39b5a8@linux.intel.com>
 <74a840d0042b6413963c3fd37ffb83e0a4866735.camel@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <74a840d0042b6413963c3fd37ffb83e0a4866735.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/4/2023 11:09 AM, Huang, Kai wrote:
> On Tue, 2023-04-04 at 10:45 +0800, Binbin Wu wrote:
>> On 4/4/2023 9:53 AM, Huang, Kai wrote:
>>> On Tue, 2023-04-04 at 09:21 +0800, Binbin Wu wrote:
>>>> On 4/3/2023 7:24 PM, Huang, Kai wrote:
>>>>>> Anyway, I will seperate this patch from the LAM KVM enabling patch. And
>>>>>> send a patch seperately if
>>>>>> needed later.
>>>>>>
>>>>> I think your change for SGX is still needed based on the pseudo code of ENCLS.
>>>> Yes, I meant I would seperate VMX part since it is not a bug after all,
>>>> SGX will still be in the patchset.
>>>>
>>>>
>>> Shouldn't SGX part be also split out as a bug fix patch?
>>>
>>> Does it have anything to do with this LAM support series?
>> It is related to LAM support because LAM only effective in 64-bit mode,
>> so the untag action should only be done in 64-bit mode.
>>
>> If the SGX fix patch is not included, that means LAM untag could be
>> called in compatiblity mode in SGX ENCLS handler.
>>
>>
> Yes I got this point, and your patch 6/7 depends on it.
>
> But my point is this fix is needed anyway regardless the LAM support, and it
> should be merged, for instance, asap as a bug fix (and CC stable perhaps) --
> while the LAM support is a feature, and can be merged at a different time frame.

OK, I can seperate the patch.


>
> Of course just my 2cents and this is up to maintainers.
