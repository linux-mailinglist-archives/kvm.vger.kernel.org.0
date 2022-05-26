Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C301534963
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 05:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238306AbiEZDoR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 23:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbiEZDoQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 23:44:16 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF3810AE
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 20:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653536654; x=1685072654;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oLdKtrVWRz08CWT64PN6UcYHzqiEl/ro32pb6xYNL4E=;
  b=iB4N8YOfVgoJkDDTkbgTbJ3NN8NpNyjgco+qol1qLpHzsS14GBGXRoQd
   ohgvidx342Vnc9Hi0uCSCwB61c7x4BgImb4lNFcfFvrwafBz9utX8URpN
   qwBEyflreve8eqHvAfb9yTvt4bmUIcfSjE+5w+VUHqE7Wg4wo9vS6CYIh
   PpzhIXRU/PAv14uPenTFtsPlOqtv0F99qMaqHVmtMfwIVRzjQzWYoU/nX
   aHklHAvN3kQBTfbdF1k0hqORSaWj8QuT+ds3tejiHCsVc0mYaaDZIv7VL
   83tSIYfCc2bGsmiJC2QERpLrwLHVLPOcKbZvPd08LQ7ASjQH2FT9HgVtI
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="274019448"
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="274019448"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 20:44:14 -0700
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="573662025"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.28.212]) ([10.255.28.212])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 20:44:09 -0700
Message-ID: <641d640a-398c-3004-382f-f208e779a26e@intel.com>
Date:   Thu, 26 May 2022 11:44:06 +0800
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
 <1e0f0051-f7c1-ed3b-be02-d16f0cf9f25d@intel.com>
 <20220524065959.umzmlhwcspfwi7m2@sirius.home.kraxel.org>
 <89534991-1850-be09-8abd-6d29bef5958e@intel.com>
 <20220524082939.2clruwficvkdwnzh@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220524082939.2clruwficvkdwnzh@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/2022 4:29 PM, Gerd Hoffmann wrote:
> On Tue, May 24, 2022 at 04:11:56PM +0800, Xiaoyao Li wrote:
>> On 5/24/2022 2:59 PM, Gerd Hoffmann wrote:
>>> On Tue, May 24, 2022 at 12:19:51PM +0800, Xiaoyao Li wrote:
>>>> On 5/23/2022 5:39 PM, Gerd Hoffmann wrote:
>>>>> So, how is this supposed to work?  Patch #2 introduces attributes as
>>>>> user-settable property.  So do users have to manually figure and pass
>>>>> the correct value, so the check passes?  Specifically the fixed1 check?
>>>>>
>>>>> I think 'attributes' should not be user-settable in the first place.
>>>>> Each feature-bit which is actually user-settable (and not already
>>>>> covered by another option like pmu) should be a separate attribute for
>>>>> tdx-object.  Then the tdx code can create attributes from hardware
>>>>> capabilities and user settings.
>>>>
>>>> In patch #2, tdx-guest.attributes is defined as a field to hold a 64 bits
>>>> value of attributes but it doesn't provide any getter/setter for it. So it's
>>>> *not* user-settable.
>>>
>>> Ok.  Why it is declared as object property in the first place then?
>>
>> Is there another way to define a member/field of object besides property?
> 
> Well, the C object struct is completely independent from the qapi
> struct.  Typically qapi-generated structs are added as struct fields.
> Look at ui/input-linux.c for example.
> 
> struct InputLinux holds all the object state.  It has a GrabToggleKeys
> field, that is a qapi-generated enum (see qapi/common.json) and is
> user-configurable (there are getter and setter for it).
> 
> So, you can have a private 'attributes' struct field in your tdx class,
> but the field doesn't have to be in the qapi struct for that.

I see. Thanks for the explanation!

I will remove the qom property definition in patch 2.

> HTH,
>    Gerd
> 

