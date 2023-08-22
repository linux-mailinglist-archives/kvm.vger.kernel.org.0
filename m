Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65FE2783B1C
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 09:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbjHVHqk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 03:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjHVHqj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 03:46:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0A1116
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 00:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692690397; x=1724226397;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SaJdRyM3XstR33ApZ9jm+dMPxuB2Q47L4hQ636PzyME=;
  b=D+p3cF1L9WMKljQl8I8y+41KH22QfBO7QPVoyI3Fbu2c0h2QhROLykxN
   lHUfVFPt7nT2iBGBw/R+SlHBrf6E2VBLVLK8r17N0qXaqIUpRJUWJrlnx
   ZTyG6PL82EDf+4dM+uVH0gVsF+epoWqyCnZycIxj5S/mg/SEU+OoowJZ1
   j6M8+g1cOCmlkzUxRNqB7jEy2DDnQum0BUZ/zpenLSkJYTzALd6Dip9iA
   QMAoMX3AHqqzLuVFPJ541i1vMr3bLlh8uY4xvtDTvhco45A2097Ho9ZA9
   uoZdwGbtbuW+WNgNnL7xciBlmUiYKzO2nC5rd0VWxxskTvLi1dJ9Q0Hjq
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="437726991"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="437726991"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 00:46:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="982789621"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="982789621"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 00:46:30 -0700
Message-ID: <ddcb487b-8bd2-5d03-b29e-dd79455c96cb@intel.com>
Date:   Tue, 22 Aug 2023 15:46:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH v2 07/58] i386/tdx: Introduce is_tdx_vm() helper and cache
 tdx_guest object
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
 <20230818095041.1973309-8-xiaoyao.li@intel.com> <ZOMk+kaAtgBh3Qgk@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZOMk+kaAtgBh3Qgk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/21/2023 4:48 PM, Daniel P. Berrangé wrote:
> On Fri, Aug 18, 2023 at 05:49:50AM -0400, Xiaoyao Li wrote:
>> It will need special handling for TDX VMs all around the QEMU.
>> Introduce is_tdx_vm() helper to query if it's a TDX VM.
>>
>> Cache tdx_guest object thus no need to cast from ms->cgs every time.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
>> ---
>>   target/i386/kvm/tdx.c | 13 +++++++++++++
>>   target/i386/kvm/tdx.h | 10 ++++++++++
>>   2 files changed, 23 insertions(+)
>>
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 255c47a2a553..56cb826f6125 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -21,8 +21,16 @@
>>   #include "kvm_i386.h"
>>   #include "tdx.h"
>>   
>> +static TdxGuest *tdx_guest;
>> +
>>   static struct kvm_tdx_capabilities *tdx_caps;
>>   
>> +/* It's valid after kvm_confidential_guest_init()->kvm_tdx_init() */
>> +bool is_tdx_vm(void)
>> +{
>> +    return !!tdx_guest;
>> +}
>> +
>>   enum tdx_ioctl_level{
>>       TDX_PLATFORM_IOCTL,
>>       TDX_VM_IOCTL,
>> @@ -109,10 +117,15 @@ static void get_tdx_capabilities(void)
>>   
>>   int tdx_kvm_init(MachineState *ms, Error **errp)
>>   {
>> +    TdxGuest *tdx = (TdxGuest *)object_dynamic_cast(OBJECT(ms->cgs),
>> +                                                    TYPE_TDX_GUEST);
> 
> This method can return NULL.  Presumably tdx_kvm_init() should only
> be called if we already checked  ms->cgs == TYPE_TDX_GUEST. If so
> then use object_dynamic_cast_assert() instead.
> 

object_dynamic_cast_assert() is for OBJECT_CHECK() and INTERFACE_CHECK().

So I will use TDX_GUEST(OBJECT(ms->cgs)) (introduced in patch 2) 
instead, which is the wrapper of OBJECT_CHECK().

