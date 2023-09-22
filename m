Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF247AA60C
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 02:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjIVAZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 20:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjIVAZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 20:25:42 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A18211A
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 17:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695342319; x=1726878319;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dab3aAu4k3nufPAfbbu062Q1SyFnK9S9KKjzquCnxxA=;
  b=SQf1YO2EaNrztlndbgszCvijSV/FqZeesqyAXDcs23nINTkZ3Z4dfoYK
   hBzxeScN85CUMKMbtHJru55lYJicYZ9zypPUoSV6r/h6Irhe0eoHE4pNz
   1O5iKecYvGmDHGalFqdgAshgh6mMbBKqbs1hppdct3ChgNlcSnfpvpjR6
   je0HONKrOU8mLfFhIsj9voobLDW6RNfa8sCscaw22kQDLJK5Bi8uxGyNZ
   3efM4SqfQiqakQGdEh7Dq0vuTTFW49Yihe4Pu47kIgvC2xNAfQu54JhWT
   NU4mGjBcPwVlWIjMffwYlmQcmaLFnv01koKCMtkqeZlU42atIEiKRye7x
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="360088355"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="360088355"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 17:23:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="747341308"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="747341308"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.11.250]) ([10.93.11.250])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 17:23:09 -0700
Message-ID: <051011a9-c228-1485-5091-62675bb30641@intel.com>
Date:   Fri, 22 Sep 2023 08:23:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.1
Subject: Re: [RFC PATCH v2 05/21] kvm: Enable KVM_SET_USER_MEMORY_REGION2 for
 memslot
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
 <20230914035117.3285885-6-xiaoyao.li@intel.com>
 <3f8955f6-c261-d3f3-08a2-54f0bd9caf8e@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <3f8955f6-c261-d3f3-08a2-54f0bd9caf8e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/21/2023 4:56 PM, David Hildenbrand wrote:
> On 14.09.23 05:51, Xiaoyao Li wrote:
>> From: Chao Peng <chao.p.peng@linux.intel.com>
>>
>> Switch to KVM_SET_USER_MEMORY_REGION2 when supported by KVM.
>>
>> With KVM_SET_USER_MEMORY_REGION2, QEMU can set up memory region that
>> backend'ed both by hva-based shared memory and gmem fd based private
>> memory.
>>
>> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
>> Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> "Co-developed-by".

I will fix it, thanks!

