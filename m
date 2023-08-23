Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE72784F7F
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 05:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbjHWD7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 23:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbjHWD7U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 23:59:20 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C457E4D
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 20:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692763158; x=1724299158;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OfOKcDn12jJixf7HQHLas2JHhxjBtPqMOoB2H3L4wXQ=;
  b=bIdI1MWpf8jht+EpnepAnxZs8jSlAQfLTBYHMjCE4gqQif5vBZO8GmJs
   Ny7c1OqzcGywhmvneOmlieMIAyji4cPsGiQYgq5NmWh6pyrDHSqWF7QGE
   C3j+bvCxf67gYEmIOBFGUp+6rDhMe56FDK33J1vpf5b1W/LxKNbBgTQS0
   ny7wiPsg8O28Lf5dY8b99Ebp8VZxqyMT4KHnaIRmm7e1/4h/im+gRzuZk
   u3BUBq/98coizVR62CVVRjWOqRTqxCHwsEM1fjvwZxjxv5Fu5Z/TnlLJL
   tO+rLfHPm5h1Y2c2OfBfCZNJ6oLXYmJuS88x7E9h6d0pjnPhbtugWA5jd
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="377816087"
X-IronPort-AV: E=Sophos;i="6.01,194,1684825200"; 
   d="scan'208";a="377816087"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 20:59:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="826564613"
X-IronPort-AV: E=Sophos;i="6.01,194,1684825200"; 
   d="scan'208";a="826564613"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 20:59:12 -0700
Message-ID: <44c62f53-f066-d359-c980-5b24af11e6d7@intel.com>
Date:   Wed, 23 Aug 2023 11:59:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH v2 08/58] i386/tdx: Adjust the supported CPUID based on
 TDX restrictions
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>, erdemaktas@google.com,
        Chenyi Qiang <chenyi.qiang@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-9-xiaoyao.li@intel.com>
 <20230821230054.GB3642077@ls.amr.corp.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230821230054.GB3642077@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/22/2023 7:00 AM, Isaku Yamahata wrote:
> On Fri, Aug 18, 2023 at 05:49:51AM -0400,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 56cb826f6125..3198bc9fd5fb 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
> ...
>> +static inline uint32_t host_cpuid_reg(uint32_t function,
>> +                                      uint32_t index, int reg)
>> +{
>> +    uint32_t eax, ebx, ecx, edx;
>> +    uint32_t ret = 0;
>> +
>> +    host_cpuid(function, index, &eax, &ebx, &ecx, &edx);
>> +
>> +    switch (reg) {
>> +    case R_EAX:
>> +        ret |= eax;
>> +        break;
>> +    case R_EBX:
>> +        ret |= ebx;
>> +        break;
>> +    case R_ECX:
>> +        ret |= ecx;
>> +        break;
>> +    case R_EDX:
>> +        ret |= edx;
> 
> Nitpick: "|" isn't needed as we initialize ret = 0 above. Just '='.

Will fix it in next version.

thanks!
