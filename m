Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F362176B811
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 16:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbjHAOyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 10:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbjHAOyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 10:54:54 -0400
Received: from mgamail.intel.com (unknown [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0805120
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 07:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690901693; x=1722437693;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hFAFf3KVZlwutGJFb9g4o8PQ8QKXQi2tI4AFdT2Qoco=;
  b=Lk7eE9UFhrerUblaepJy3PGR2XucS4Vesr3Ja805zs27uT6zKdnEt08e
   1kSKTcpQGhH5K5DiLevCKop8asbD4MbuWPJbdjwjk+/fsRasyxlkk8joK
   F0Ikd+VRfsFj+fiZB6056i6HpkBcEqooDIvZrJezyZqx4g8Y6LVGdefWF
   f4P7wys3DPnjZr42x6/r/OxAZ6rpT666K0nhuHHnfQqjQhgl6QzRhObMW
   YcWwSJSGEKs7jLZJypGsz9j9xXWJfdzD3iEplWeUzYBgXelm0h8I9FmBM
   zM+95VZp+kCieSttPhiLfC0RWYHbnRGSFx6/RU4h8TmM7MqgWOfoG9BPx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="348919094"
X-IronPort-AV: E=Sophos;i="6.01,247,1684825200"; 
   d="scan'208";a="348919094"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 07:54:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="975335372"
X-IronPort-AV: E=Sophos;i="6.01,247,1684825200"; 
   d="scan'208";a="975335372"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 07:54:48 -0700
Message-ID: <54ca98fb-2c26-9787-9da6-6d56c0b68213@intel.com>
Date:   Tue, 1 Aug 2023 22:54:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [RFC PATCH 08/19] HostMem: Add private property to indicate to
 use kvm gmem
Content-Language: en-US
To:     Markus Armbruster <armbru@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <20230731162201.271114-9-xiaoyao.li@intel.com> <87o7js808y.fsf@pond.sub.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <87o7js808y.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/1/2023 1:22 AM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> [...]
> 
>> diff --git a/qapi/qom.json b/qapi/qom.json
>> index 7f92ea43e8e1..e0b2044e3d20 100644
>> --- a/qapi/qom.json
>> +++ b/qapi/qom.json
>> @@ -605,6 +605,9 @@
>>   # @reserve: if true, reserve swap space (or huge pages) if applicable
>>   #     (default: true) (since 6.1)
>>   #
>> +# @private: if true, use KVM gmem private memory
>> +#           (default: false) (since 8.1)
>> +#
> 
> Please format like
> 
>     # @private: if true, use KVM gmem private memory (default: false)
>     #     (since 8.1)
> 
> to blend in with recent commit a937b6aa739 (qapi: Reformat doc comments
> to conform to current conventions).

will do it in next version.

Thanks!
-Xiaoyao

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

