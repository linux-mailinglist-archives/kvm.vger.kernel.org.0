Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29FA77A6F60
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 01:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjISXYU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 19:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjISXYT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 19:24:19 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDC683
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 16:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695165854; x=1726701854;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SLa3CFPM9YFPKuRCsC8h0wcrJYMqW+0P11yOKPVS3Zk=;
  b=eKqHQ0W5zcNtQ5ups2+ccTY50Gi/jJTTGJKTiekZcHbluxsVDRKMk1ht
   Hz86kILnrTgWKMRnCiZydF+MkjkM5Yarl3f7HuABN0shKcrFmKJYbBb8o
   80dB/gGUczQicHrGxSI3FJzJf9MB73RL3RJvwjukcBBi6xAeuFSQhadOL
   5n8LCasvCWNZ2PSU/UvViv28x4sm2tcGx12Tx1LRdjs+gAIrgzJsmlRxd
   41mQqm7y+dxvMX9aZ8HIxwY7yLqBgBp82Ws50LuNsGDJbtydUi5QVRo1p
   ZlGHCeeRG14ZCJxpNYj2TEIahSTUttKtUlovpy+T+v7Cm2wCJYlE7Ca1M
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10838"; a="383919134"
X-IronPort-AV: E=Sophos;i="6.02,160,1688454000"; 
   d="scan'208";a="383919134"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2023 16:24:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10838"; a="696092486"
X-IronPort-AV: E=Sophos;i="6.02,160,1688454000"; 
   d="scan'208";a="696092486"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.19.128]) ([10.93.19.128])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2023 16:24:08 -0700
Message-ID: <d0e7e2f8-581d-e708-5ddd-947f2fe9676a@intel.com>
Date:   Wed, 20 Sep 2023 07:24:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.1
Subject: Re: [RFC PATCH v2 03/21] HostMem: Add private property and associate
 it with RAM_KVM_GMEM
To:     Markus Armbruster <armbru@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        isaku.yamahata@gmail.com, Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
 <20230914035117.3285885-4-xiaoyao.li@intel.com> <8734zazeag.fsf@pond.sub.org>
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <8734zazeag.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/19/2023 5:46 PM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Add a new property "private" to memory backends. When it's set to true,
>> it indicates the RAMblock of the backend also requires kvm gmem.
> 
> Can you add a brief explanation why you need the property?

It provides a mechanism for user to specify whether the memory can serve 
as private memory (need request kvm gmem).

>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> [...]
> 
>> diff --git a/qapi/qom.json b/qapi/qom.json
>> index fa3e88c8e6ab..d28c5403bc0f 100644
>> --- a/qapi/qom.json
>> +++ b/qapi/qom.json
>> @@ -605,6 +605,9 @@
>>   # @reserve: if true, reserve swap space (or huge pages) if applicable
>>   #     (default: true) (since 6.1)
>>   #
>> +# @private: if true, use KVM gmem private memory (default: false)
>> +#     (since 8.2)
>> +#
>>   # @size: size of the memory region in bytes
>>   #
>>   # @x-use-canonical-path-for-ramblock-id: if true, the canonical path
>> @@ -631,6 +634,7 @@
>>               '*prealloc-context': 'str',
>>               '*share': 'bool',
>>               '*reserve': 'bool',
>> +            '*private': 'bool',
>>               'size': 'size',
>>               '*x-use-canonical-path-for-ramblock-id': 'bool' } }
> 

