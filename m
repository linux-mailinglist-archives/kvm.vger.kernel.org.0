Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63847843E3
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 16:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbjHVOWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 10:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234647AbjHVOWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 10:22:04 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E85C7
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 07:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692714123; x=1724250123;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZvC+9MIG9rk+1jRXFoIjKvMMJNC7DAOZAeaeh5aL7hU=;
  b=OBLPvVdrqoFO0g65XAmXFPXyFmlP28bBsz8s2plnlTIHQxjqZ+OSWA1q
   sRCuMnXeU39dnkApVIRZiIm+1L00MdclUnD65pvL1pdPUnf9i9+dl8ypb
   xQoZWck0ExRfLKH+6CPnExMym9f0RoUFcERWvRZZ20mdyEWMuGymVsvfD
   ToBSUzphXBJ+7BXeRiaGduWkf8BLcwrvV5tWO93QyzDeTnrP15depcKff
   qaia2jCBDQ/aCQDQgtrIySV7n0hvOW+o8D9/RsAqddudBbn39VpUbO7+K
   QNh2b7pIKfgJ/trtVNJi0dY54aVc3E5w9oiyW4rtrLqUK6rrRNAxPA6Ic
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="460259072"
X-IronPort-AV: E=Sophos;i="6.01,193,1684825200"; 
   d="scan'208";a="460259072"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 07:22:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="686064058"
X-IronPort-AV: E=Sophos;i="6.01,193,1684825200"; 
   d="scan'208";a="686064058"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 07:21:53 -0700
Message-ID: <0a2b2d58-63ac-3764-a4d2-c777d565b61e@intel.com>
Date:   Tue, 22 Aug 2023 22:21:48 +0800
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
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

Will do it in next version.

thanks!

>> +
>> +    return 0;
>> +}
>> +
>> +static int setup_td_guest_attributes(X86CPU *x86cpu)
>>   {
>>       CPUX86State *env = &x86cpu->env;
>>   
>>       tdx_guest->attributes |= (env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_PKS) ?
>>                                TDX_TD_ATTRIBUTES_PKS : 0;
>>       tdx_guest->attributes |= x86cpu->enable_pmu ? TDX_TD_ATTRIBUTES_PERFMON : 0;
>> +
>> +    return tdx_validate_attributes(tdx_guest);
> 
> Pass along "errp" into this
> 
>>   }
>>   
>>   int tdx_pre_create_vcpu(CPUState *cpu)
>> @@ -493,7 +513,10 @@ int tdx_pre_create_vcpu(CPUState *cpu)
> 
> In an earlier patch I suggested adding 'Error **errp' to this method...
> 
>>           goto out_free;
>>       }
>>   
>> -    setup_td_guest_attributes(x86cpu);
>> +    r = setup_td_guest_attributes(x86cpu);
> 
> ...it can also be passed into this method
> 
>> +    if (r) {
>> +        goto out;
>> +    }
>>   
>>       init_vm->cpuid.nent = kvm_x86_arch_cpuid(env, init_vm->cpuid.entries, 0);
>>       init_vm->attributes = tdx_guest->attributes;
>> -- 
>> 2.34.1
>>
> 
> With regards,
> Daniel

