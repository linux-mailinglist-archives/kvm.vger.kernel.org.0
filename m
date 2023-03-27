Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7BD6CA670
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 15:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbjC0Ntx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 09:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbjC0Ntj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 09:49:39 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A082A5FED;
        Mon, 27 Mar 2023 06:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679924895; x=1711460895;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nbbS8eaOoKnfWK3qJQXC2Lo0AgeSijaaJ8+C3KuWbcw=;
  b=SAo8PQvB9+GCkIFEKBDAtp3KmvQN59/uyRzVNA0WTkjqGqr0MHYqHO5q
   OSXNJXYH3Gm0oO7g/38nH3tmfFDI391LGmYZOPxGGBuyYsflDMvvt0YYT
   0o2AGGt69nPjq3tkkaaHlk3SgpHvHBpB9diGxJM2Fgfnile2Kg291Lyww
   w9behfqATMpn3DImOCAqpAjnOQl4j+uxiDHoQYHmjkmN2r8t8ur08v6Ek
   lC+FkBz/flRPPLbPi/ZAAQyZ+vCLLGMXuhuQxoa69q4FQzEcoRYt0uzqm
   xnETGtaV+3hvi2GQonaYXRKKBOTCiQtUU5KNgBxtQGmwpBAzdfuVF9OY9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="405190174"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="405190174"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 06:48:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="716077950"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="716077950"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.174.244]) ([10.249.174.244])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 06:48:05 -0700
Message-ID: <9b81cfa8-1e36-cbed-3399-c178f7388067@intel.com>
Date:   Mon, 27 Mar 2023 21:48:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH v4 6/6] KVM: VMX: Make CR0.WP a guest owned bit
Content-Language: en-US
To:     Mathias Krause <minipli@grsecurity.net>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <20230322013731.102955-7-minipli@grsecurity.net>
 <9261e319-084b-b6fe-550e-31b3683776c4@intel.com>
 <814c8975-17ad-f1bb-3b26-2175d79a1153@grsecurity.net>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <814c8975-17ad-f1bb-3b26-2175d79a1153@grsecurity.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/27/2023 4:37 PM, Mathias Krause wrote:
> On 27.03.23 10:33, Xiaoyao Li wrote:
>> On 3/22/2023 9:37 AM, Mathias Krause wrote:
>>> Guests like grsecurity that make heavy use of CR0.WP to implement kernel
>>> level W^X will suffer from the implied VMEXITs.
>>>
>>> With EPT there is no need to intercept a guest change of CR0.WP, so
>>> simply make it a guest owned bit if we can do so.
>>
>> I'm interested in the performance gain. Do you have data like Patch 2?
> 
> It's mentioned in the cover letter[1], quoted below:

Sorry I missed it. The data of not intercepting CR0.WP looks great as well.

> [1]
> https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/
> 
> : I used 'ssdd 10 50000' from rt-tests[5] as a micro-benchmark, running on a
> : grsecurity L1 VM. Below table shows the results (runtime in seconds, lower
> : is better):
> :
> :                               legacy     TDP    shadow
> :     kvm-x86/next@d8708b        8.43s    9.45s    70.3s
> :     + patches 1-3              5.39s    5.63s    70.2s
> :     + patches 4-6              3.51s    3.47s    67.8s
> 
> 
> Thanks,
> Mathias

