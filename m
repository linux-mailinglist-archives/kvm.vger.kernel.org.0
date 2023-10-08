Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7387A7BCBCB
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 05:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344342AbjJHC7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Oct 2023 22:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344334AbjJHC7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Oct 2023 22:59:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2CDBA
        for <kvm@vger.kernel.org>; Sat,  7 Oct 2023 19:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696733978; x=1728269978;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JY61nxrnTIgPfkug6sU6RVyQBMUpJyqCJ0YRGP8Yq7w=;
  b=dRSa6XRYsz3ffQdoXw7LNJG66S2M0OAE2DdqVgypOjCDJEE0QKd8w/+c
   FNimxRCYyj9qaKw/aVLN9fMruR9Lh8PNXVYPWcrMXqpIMZjeZUHUeFBze
   ACvf+PQJvhKCLeJ4OB7S9FQQEJQadI0d/kcBF6Z6+WoGc9GcSUV/sqHPv
   qvnNAp4yrDyeoGonqSeRT+zBDnsG1IXlYoEZbxe5bsT80aM7Kmr5dEUCD
   AKguzX5CW/DjUK1vfqfJKwxD1fMdUj6JhbFOI5njHteWB0oH1MAsjB4kp
   M/68Ft7yYObIho+5PeYMAdk6kYwOKi6zE6wh+MBKwLUkkADIeAr4TRwwB
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10856"; a="387839838"
X-IronPort-AV: E=Sophos;i="6.03,207,1694761200"; 
   d="scan'208";a="387839838"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2023 19:59:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10856"; a="787812956"
X-IronPort-AV: E=Sophos;i="6.03,207,1694761200"; 
   d="scan'208";a="787812956"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.19.128]) ([10.93.19.128])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2023 19:59:30 -0700
Message-ID: <5334cca3-6e96-7771-0ca4-de124ed40176@intel.com>
Date:   Sun, 8 Oct 2023 10:59:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.1
Subject: Re: [RFC PATCH v2 02/21] RAMBlock: Add support of KVM private gmem
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
 <20230914035117.3285885-3-xiaoyao.li@intel.com>
 <678bf0bf-57e7-a596-1ddf-6d0b47cd8677@redhat.com>
 <6eeb5568-2faa-85c3-8f42-ed6317ea376c@intel.com>
 <998a0ef6-a74c-feec-eca2-644aee91f27b@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <998a0ef6-a74c-feec-eca2-644aee91f27b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/22/2023 3:08 PM, David Hildenbrand wrote:
> On 22.09.23 02:22, Xiaoyao Li wrote:
>> On 9/21/2023 4:55 PM, David Hildenbrand wrote:
>>> On 14.09.23 05:50, Xiaoyao Li wrote:
>>>> From: Chao Peng <chao.p.peng@linux.intel.com>
>>>>
>>>> Add KVM gmem support to RAMBlock so both normal hva based memory
>>>> and kvm gmem fd based private memory can be associated in one RAMBlock.
>>>>
>>>> Introduce new flag RAM_KVM_GMEM. It calls KVM ioctl to create private
>>>> gmem for the RAMBlock when it's set.
>>>
>>>
>>> But who sets RAM_KVM_GMEM and when?
>>
>> The answer is in the next patch. When `private` property of memory
>> backend is set to true, it will pass RAM_KVM_GMEM flag to
>> memory_region_init_ram_*()
> 
> Okay, assuming that patch (and property) will go away, I assume this 
> flag can also go away, right?
> 

If dropping the flag RAM_KVM_GMEM, it seems we need go back to the 
approach of rfc v1[1][2], that allocating gmem inside .region_add() 
callback. Is it accepted by you?

Another option is allocating gmem inside ram_block_add() by checking the 
vm_type (it looks hacky for me). What's your opinion on this option?

One more option is, we keep the RAM_KVM_GMEM as this patch, and change 
"private" property of memory backend into "need_kvm_gmem" field (make it 
not user settable) and "need_kvm_gmem" field will be set to true in 
tdx_kvm_init() specific cgs initialization function.


[1] 
https://lore.kernel.org/qemu-devel/a154c33d-b24d-b713-0dc0-027d54f2340f@redhat.com/
[2] 
https://lore.kernel.org/qemu-devel/20230731162201.271114-10-xiaoyao.li@intel.com/




