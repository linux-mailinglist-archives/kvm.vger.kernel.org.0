Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60175324FC
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 10:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbiEXIMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 04:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiEXIMH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 04:12:07 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8044F4832E
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 01:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653379925; x=1684915925;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=p0AzvFL26WE5tpeWJg9IQQ/7Q4siWy3k1jt1lWZOFkY=;
  b=nagMZc6dYfZQyJElGeZlfU/HAlakXaC49L84ikoo19R8msZqb/vSqfJa
   YF9l0lAZ/3/E5YguNLWWx5Oc4J59035vKM1pl2JP/s08A5qPcxpcryqLj
   h54ZiDJK7g/P+IrqhmHdSrQPrQ1SmJZnHUtpRkgTlfLPRU1LqU2mYsQ3R
   HVV5mPlJvXQKn9HVkrvpyhbvfChL8nFLhk5kscXQHJCeXGpVcnD4tcI78
   35Jf5apilVZmdnfphxZWAx2MjF8XHdpqyYKIv6Rp5cvVjRrGGYx7It0be
   JW7ESMM5I5i7ehYl0YTVR73pNVNPdkVC8qnANay5Kic3BRHv4rhKCX1E3
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="261072196"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="261072196"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 01:12:04 -0700
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="601105029"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.170.252]) ([10.249.170.252])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 01:11:59 -0700
Message-ID: <89534991-1850-be09-8abd-6d29bef5958e@intel.com>
Date:   Tue, 24 May 2022 16:11:56 +0800
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
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220524065959.umzmlhwcspfwi7m2@sirius.home.kraxel.org>
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

On 5/24/2022 2:59 PM, Gerd Hoffmann wrote:
> On Tue, May 24, 2022 at 12:19:51PM +0800, Xiaoyao Li wrote:
>> On 5/23/2022 5:39 PM, Gerd Hoffmann wrote:
>>> So, how is this supposed to work?  Patch #2 introduces attributes as
>>> user-settable property.  So do users have to manually figure and pass
>>> the correct value, so the check passes?  Specifically the fixed1 check?
>>>
>>> I think 'attributes' should not be user-settable in the first place.
>>> Each feature-bit which is actually user-settable (and not already
>>> covered by another option like pmu) should be a separate attribute for
>>> tdx-object.  Then the tdx code can create attributes from hardware
>>> capabilities and user settings.
>>
>> In patch #2, tdx-guest.attributes is defined as a field to hold a 64 bits
>> value of attributes but it doesn't provide any getter/setter for it. So it's
>> *not* user-settable.
> 
> Ok.  Why it is declared as object property in the first place then?

Is there another way to define a member/field of object besides property?

> take care,
>    Gerd
> 

