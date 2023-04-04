Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 087F86D55CF
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 03:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjDDBVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 21:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDDBV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 21:21:28 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF711FE0
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 18:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680571288; x=1712107288;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=I0Tne1xeDv3i0GoLHMNmx3mIMdSNoN2XF4qUp5t7G3A=;
  b=C/Lr01ujBIrbpoIXVrdZqKKSBtmfMEmlvD0YFyngaW5dHupB4j5gbQD9
   0MA+f9cmKA06omlTq10mhim6fd613SNLCV+Kq6b6pzdzIBiolZeaoI01Q
   Sq9ft6scPtPXwIZdipVr2tq5CqSRA4MxibNTA1YHiJGXnuCiwMMPQ7VhB
   MPaa/57hVbJQv9JoMhBAr/qBk14uic5REeFhmxsNSsp1j1gWKDAgQujZU
   WAHa33ZfHih+o6Yb1L0rmzSEJckx+9j/BHcF5bd/hTxrHEdVOyLm3szIT
   /Ksrs9EUCUuFfS4kSFBHSJSFLTtg+gHWkOOHeqJsjsivlA0aS2y2Qjt28
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="342083760"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="342083760"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 18:21:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="663401920"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="663401920"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.215.140]) ([10.254.215.140])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 18:21:25 -0700
Message-ID: <559ebca9-dfb9-e041-3744-5eab36f4f4c5@linux.intel.com>
Date:   Tue, 4 Apr 2023 09:21:23 +0800
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
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <fc92490afc7ee1b9679877878de64ad129853cc0.camel@intel.com>
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


On 4/3/2023 7:24 PM, Huang, Kai wrote:
>>
>>
>> Anyway, I will seperate this patch from the LAM KVM enabling patch. And
>> send a patch seperately if
>> needed later.
>>
> I think your change for SGX is still needed based on the pseudo code of ENCLS.

Yes, I meant I would seperate VMX part since it is not a bug after all, 
SGX will still be in the patchset.


>
