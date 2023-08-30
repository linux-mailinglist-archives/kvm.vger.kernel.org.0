Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D7378D1DA
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 03:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241645AbjH3Bxw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 21:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238208AbjH3Bxh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 21:53:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185A6FC
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 18:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693360415; x=1724896415;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=n7+5Tnf4oVHN1YfjOKumtJWeaf4nATSJ6NM8TmlHHaU=;
  b=GOErI5kMhTxeyfFAblYmLUeJ9Sp06durowjonmJllfd8pqNONkNP4QYK
   R1u6wXKwDwXiD1azu7KcLtIzUbiKDAze5mj9dJ3GIEUyFjZv9Czb+BKx1
   u0ebrJS2ivciq4w8jmMQTtwlyAHvP+issArjGOa4ltAcd/OFXrw65qmaO
   +XTwS+s/st88UIV0ZTMG1EA7Gf3D2dgkIFNAGBypew/5/wwZ8WVmiuQjF
   h38j3UKgRUqdgT17P8mJvGfBGkceVgaN5muZJ5Kcu3Zn3rEAgIcJcEN4l
   lGBaxhIPlfoY3phSK4Rd7IPr2V3fJp/GaiJGWvvMIKeTZZGwrKofjo4Se
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="360526154"
X-IronPort-AV: E=Sophos;i="6.02,212,1688454000"; 
   d="scan'208";a="360526154"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2023 18:53:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="773937101"
X-IronPort-AV: E=Sophos;i="6.02,212,1688454000"; 
   d="scan'208";a="773937101"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.16.81]) ([10.93.16.81])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2023 18:53:29 -0700
Message-ID: <c70bee27-7277-3c9d-19fe-fe4a3a1e29b0@intel.com>
Date:   Wed, 30 Aug 2023 09:53:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH v2 36/58] memory: Introduce memory_region_init_ram_gmem()
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-37-xiaoyao.li@intel.com>
 <68526bca-6054-510e-09fe-f73bf610b005@linaro.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <68526bca-6054-510e-09fe-f73bf610b005@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/29/2023 10:33 PM, Philippe Mathieu-Daudé wrote:
> On 18/8/23 11:50, Xiaoyao Li wrote:
>> Introduce memory_region_init_ram_gmem() to allocate private gmem on the
>> MemoryRegion initialization. It's for the usercase of TDVF, which must
>> be private on TDX case.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   include/exec/memory.h |  6 +++++
>>   softmmu/memory.c      | 52 +++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 58 insertions(+)
> 
> 
>> diff --git a/softmmu/memory.c b/softmmu/memory.c
>> index af6aa3c1e3c9..ded44dcef1aa 100644
>> --- a/softmmu/memory.c
>> +++ b/softmmu/memory.c
>> @@ -25,6 +25,7 @@
>>   #include "qom/object.h"
>>   #include "trace.h"
>> +#include <linux/kvm.h>
> 
> Unlikely to build on non-Linux hosts.

Thanks for catching it!

Will warp it with CONFIG_KVM.

Anyway, it's the main open of how to integrating KVM gmem into QEMU's 
memory system, in QMEU gmem series[*]. I'm still working on it.

[*] 
https://lore.kernel.org/qemu-devel/20230731162201.271114-1-xiaoyao.li@intel.com/

>>   #include "exec/memory-internal.h"
>>   #include "exec/ram_addr.h"
>>   #include "sysemu/kvm.h"
> 

