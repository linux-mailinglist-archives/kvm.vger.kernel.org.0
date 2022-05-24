Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4595321E9
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 06:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbiEXEUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 00:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbiEXEUC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 00:20:02 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2483E7B9E9
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 21:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653366001; x=1684902001;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bOEEv/vCAuWYvT9MBnYyTSaRD96dT8DA/8SxonVEvi8=;
  b=k4WFvw+r/VkePN0TGy4lkZYFFsuvfGn2/OAUTWUkRrwBxVE6+0Vmr8B3
   HqyWf1BPD6X/XKLI1Lg3ymp07W1iFRvqWeRY1md1X25m/hh5wvK1RY+ib
   7cvNTLyj6tFXukYVhzUF14JQZ1FKuVdRaLFwfdKGO6NJtszpogx370MBg
   IsXjQTB9qipSlm5uqiXe6GKsVQYIzkDg0Fu0KTFoQVT0K7rSr7IxFHbYC
   ggLua5G0Lzt/Xv2uIpLBaaAvnxaB4dF2vNGoHM1Qt4a45LRe/CkJRU7Ue
   85HfOska5g1pKqvDUMkKMjgc5GrbZjIfWInfKRSR480XWraM4rWmnNwAe
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="273151884"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="273151884"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 21:19:59 -0700
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="601020801"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.170.252]) ([10.249.170.252])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 21:19:54 -0700
Message-ID: <1e0f0051-f7c1-ed3b-be02-d16f0cf9f25d@intel.com>
Date:   Tue, 24 May 2022 12:19:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [RFC PATCH v4 13/36] i386/tdx: Validate TD attributes
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-14-xiaoyao.li@intel.com>
 <20220523093920.o6pk5i7zig6enwnm@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220523093920.o6pk5i7zig6enwnm@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/23/2022 5:39 PM, Gerd Hoffmann wrote:
>> Validate TD attributes with tdx_caps that fixed-0 bits must be zero and
>> fixed-1 bits must be set.
> 
>> -static void setup_td_guest_attributes(X86CPU *x86cpu)
>> +static int tdx_validate_attributes(TdxGuest *tdx)
>> +{
>> +    if (((tdx->attributes & tdx_caps->attrs_fixed0) | tdx_caps->attrs_fixed1) !=
>> +        tdx->attributes) {
>> +            error_report("Invalid attributes 0x%lx for TDX VM (fixed0 0x%llx, fixed1 0x%llx)",
>> +                          tdx->attributes, tdx_caps->attrs_fixed0, tdx_caps->attrs_fixed1);
>> +            return -EINVAL;
>> +    }
> 
> So, how is this supposed to work?  Patch #2 introduces attributes as
> user-settable property.  So do users have to manually figure and pass
> the correct value, so the check passes?  Specifically the fixed1 check?
> 
> I think 'attributes' should not be user-settable in the first place.
> Each feature-bit which is actually user-settable (and not already
> covered by another option like pmu) should be a separate attribute for
> tdx-object.  Then the tdx code can create attributes from hardware
> capabilities and user settings.

In patch #2, tdx-guest.attributes is defined as a field to hold a 64 
bits value of attributes but it doesn't provide any getter/setter for 
it. So it's *not* user-settable.

Did I miss something? (I'm not good at QEMU object)

> When user-settable options might not be available depending on hardware
> capabilities best practice is to create them as OnOffAuto properties.
> 
>    Auto == qemu can pick the value, typical behavior is to enable the
>            feature if the hardware supports it.
>    On == must enable, if it isn't possible throw an error and exit.
>    Off == must disable, if it isn't possible throw an error and exit.
> 
> take care,
>    Gerd
> 

