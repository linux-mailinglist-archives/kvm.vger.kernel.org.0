Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18FB778444A
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 16:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236775AbjHVOb3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 10:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236771AbjHVOb2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 10:31:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C74BCD2
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 07:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692714680; x=1724250680;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8xbeAI3NyPJsCi4eI4jBMgXXMe+Lo9EhfttVpsCcfxc=;
  b=cjYcHdK6QPGM7QwrkMIyTge8yy20xlyjTnDhg0yGq1g4rJbuVqd93zsA
   WAKV9RRxgDRjcFRpLvL4SWHBOSiGthmafiKbR0e9bcIx4EfbGs/8PFxX2
   wLPtUGlFQo+i7WNIKbvKd6SdV+DbWJLdR5lKUHAyudIhaoxt3qMyyx/0V
   am8590qGpPxoI58lN2d8Qyip5eU0TjvsNLaEIIVkZh0eZj/ol8EFziqwE
   thHuqj9R5HyP/LcaUya4EPqP9Ah436B90MN1FoU0Vys++vcZ4n7aXPFz1
   OdYUJNhYtdGehl5drN6XG/E54vScM+uJ1G9p8CDF0Tnz/+w41KdL3VCX3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="358882570"
X-IronPort-AV: E=Sophos;i="6.01,193,1684825200"; 
   d="scan'208";a="358882570"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 07:30:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="879974193"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 07:30:55 -0700
Message-ID: <c1ad3974-876a-9d29-9a59-f54ae4f8b09e@intel.com>
Date:   Tue, 22 Aug 2023 22:30:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH v2 18/58] i386/tdx: Validate TD attributes
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-19-xiaoyao.li@intel.com>
 <ZOMrd6f0URDYp/0r@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZOMrd6f0URDYp/0r@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/21/2023 5:16 PM, Daniel P. Berrangé wrote:
> On Fri, Aug 18, 2023 at 05:50:01AM -0400, Xiaoyao Li wrote:
>> Validate TD attributes with tdx_caps that fixed-0 bits must be zero and
>> fixed-1 bits must be set.
>>
>> Besides, sanity check the attribute bits that have not been supported by
>> QEMU yet. e.g., debug bit, it will be allowed in the future when debug
>> TD support lands in QEMU.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
>> ---
>>   target/i386/kvm/tdx.c | 27 +++++++++++++++++++++++++--
>>   1 file changed, 25 insertions(+), 2 deletions(-)
>>
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 629abd267da8..73da15377ec3 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -32,6 +32,7 @@
>>                                        (1U << KVM_FEATURE_PV_SCHED_YIELD) | \
>>                                        (1U << KVM_FEATURE_MSI_EXT_DEST_ID))
>>   
>> +#define TDX_TD_ATTRIBUTES_DEBUG             BIT_ULL(0)
>>   #define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
>>   #define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
>>   #define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
>> @@ -462,13 +463,32 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
>>       return 0;
>>   }
>>   
>> -static void setup_td_guest_attributes(X86CPU *x86cpu)
>> +static int tdx_validate_attributes(TdxGuest *tdx)
>> +{
>> +    if (((tdx->attributes & tdx_caps->attrs_fixed0) | tdx_caps->attrs_fixed1) !=
>> +        tdx->attributes) {
>> +            error_report("Invalid attributes 0x%lx for TDX VM (fixed0 0x%llx, fixed1 0x%llx)",
>> +                          tdx->attributes, tdx_caps->attrs_fixed0, tdx_caps->attrs_fixed1);
>> +            return -EINVAL;
>> +    }
>> +
>> +    if (tdx->attributes & TDX_TD_ATTRIBUTES_DEBUG) {
>> +        error_report("Current QEMU doesn't support attributes.debug[bit 0] for TDX VM");
>> +        return -EINVAL;
>> +    }
> 
> Use error_setg() in both cases, passing in a 'Error **errp' object,
> and 'return -1' instead of returning an errno value.
> 

why return -1 instead of -EINVAL?

