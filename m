Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA4176C7DC
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 10:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjHBIDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 04:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbjHBIDh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 04:03:37 -0400
Received: from mgamail.intel.com (unknown [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090EA1702
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 01:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690963416; x=1722499416;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=83fW9XZQKMG666lu8RCXFlJ6rej8OW3/lE+RD9JXFks=;
  b=P1TfXbgYYzysCyJCda5cwThUC9bfz7EcwQipj3L+15YSOWAtEPFgQYhk
   ltt3Ih3GkS3Vtf2aGg01dLHAKVNkobyHa2aeY8quHOqrlniBnutQA8oeN
   INQzNxpe7Y++pS6wUip3mm9adf19GpDTPUWJo/EVjwaxWQpmUyEjfVnhT
   pCgECvcla7vtWx14gyJ5iua2IE/E/tijKftzafX/m99rMJHvGqkb75hl+
   3HDtWqmMpiOzWBPchCqlpZLzOl6vQUIQZ7a2H6N8fMjPujvKdw8MGrXXi
   yZPrjpW9h/VXelGNRH6dD0J8ukVt82zMb37g9BudCdhEPUUes5h/REEI1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="368411433"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="368411433"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2023 01:03:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="732288530"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="732288530"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2023 01:03:30 -0700
Message-ID: <2addfff0-88bf-59aa-f2f3-8129366a006d@intel.com>
Date:   Wed, 2 Aug 2023 16:03:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [RFC PATCH 08/19] HostMem: Add private property to indicate to
 use kvm gmem
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
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
 <20230731162201.271114-9-xiaoyao.li@intel.com>
 <f8e40f1a-729b-f520-299a-4132e371be61@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <f8e40f1a-729b-f520-299a-4132e371be61@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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

On 8/2/2023 1:21 AM, David Hildenbrand wrote:
> On 31.07.23 18:21, Xiaoyao Li wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   backends/hostmem.c       | 18 ++++++++++++++++++
>>   include/sysemu/hostmem.h |  2 +-
>>   qapi/qom.json            |  4 ++++
>>   3 files changed, 23 insertions(+), 1 deletion(-)
>>
>> diff --git a/backends/hostmem.c b/backends/hostmem.c
>> index 747e7838c031..dbdbb0aafd45 100644
>> --- a/backends/hostmem.c
>> +++ b/backends/hostmem.c
>> @@ -461,6 +461,20 @@ static void 
>> host_memory_backend_set_reserve(Object *o, bool value, Error **errp)
>>       }
>>       backend->reserve = value;
>>   }
>> +
>> +static bool host_memory_backend_get_private(Object *o, Error **errp)
>> +{
>> +    HostMemoryBackend *backend = MEMORY_BACKEND(o);
>> +
>> +    return backend->private;
>> +}
>> +
>> +static void host_memory_backend_set_private(Object *o, bool value, 
>> Error **errp)
>> +{
>> +    HostMemoryBackend *backend = MEMORY_BACKEND(o);
>> +
>> +    backend->private = value;
>> +}
>>   #endif /* CONFIG_LINUX */
>>   static bool
>> @@ -541,6 +555,10 @@ host_memory_backend_class_init(ObjectClass *oc, 
>> void *data)
>>           host_memory_backend_get_reserve, 
>> host_memory_backend_set_reserve);
>>       object_class_property_set_description(oc, "reserve",
>>           "Reserve swap space (or huge pages) if applicable");
>> +    object_class_property_add_bool(oc, "private",
>> +        host_memory_backend_get_private, 
>> host_memory_backend_set_private);
>> +    object_class_property_set_description(oc, "private",
>> +        "Use KVM gmem private memory");
>>   #endif /* CONFIG_LINUX */
>>       /*
>>        * Do not delete/rename option. This option must be considered 
>> stable
>> diff --git a/include/sysemu/hostmem.h b/include/sysemu/hostmem.h
>> index 39326f1d4f9c..d88970395618 100644
>> --- a/include/sysemu/hostmem.h
>> +++ b/include/sysemu/hostmem.h
>> @@ -65,7 +65,7 @@ struct HostMemoryBackend {
>>       /* protected */
>>       uint64_t size;
>>       bool merge, dump, use_canonical_path;
>> -    bool prealloc, is_mapped, share, reserve;
>> +    bool prealloc, is_mapped, share, reserve, private;
>>       uint32_t prealloc_threads;
>>       ThreadContext *prealloc_context;
>>       DECLARE_BITMAP(host_nodes, MAX_NODES + 1);
>> diff --git a/qapi/qom.json b/qapi/qom.json
>> index 7f92ea43e8e1..e0b2044e3d20 100644
>> --- a/qapi/qom.json
>> +++ b/qapi/qom.json
>> @@ -605,6 +605,9 @@
>>   # @reserve: if true, reserve swap space (or huge pages) if applicable
>>   #     (default: true) (since 6.1)
>>   #
>> +# @private: if true, use KVM gmem private memory
>> +#           (default: false) (since 8.1)
>> +#
> 
> But that's not what any of this does.
> 
> This patch only adds a property and doesn't even explain what it intends 
> to achieve with that.
> 
> How will it be used from a user? What will it affect internally? What 
> will it modify in regards of the memory backend?

How it will be used is in the next patch, patch 09.

for kvm_x86_sw_protected_vm type VM, it will allocate private gmem with 
KVM ioctl if the memory backend has property "private" on.

> That all should go into the surprisingly empty patch description.

I'm sorry. I admit the empty commit message is really bad.



