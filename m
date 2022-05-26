Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8FA65348DC
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 04:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346175AbiEZCZj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 22:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiEZCZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 22:25:37 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D7ABCEA4
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 19:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653531936; x=1685067936;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sv7dvPzxgZU2loEhA73w1Vns5XlLncRcMXnvraJptVQ=;
  b=HoqhIOF+aI5qT2WJovtwUV2Xp9bC19PImNhhXpHQKIqJC84AlZt7Oh40
   vbM9khokR2yMBtcDb7079vbAnvmVknzB1O639PuZ5aro7vS437Speu8PM
   /AXKRnuHVnsDxMmHuhyCScByLQ5aQRC9E/EAO6iiGrAZhptfaDwozwoVz
   xyUNSn3oyjaFeYoli/q7sfQg5zdiSS80cHK6/Pn4i2zzGuSCq+BRInZgU
   CZpN/dfFoZ607bXWU8Fw30wuVO8IfGkMlni9xqQmJmwM7Kb8JfEnWO58m
   gWZPBQLpphpi3C8RZlQ0++8dMNQDAO4taeJb8TmxBJr434U5560xQaBEX
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="271572799"
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="271572799"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 19:25:36 -0700
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="573630666"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.28.212]) ([10.255.28.212])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 19:25:31 -0700
Message-ID: <5f363432-9fcd-c05a-f253-237216716689@intel.com>
Date:   Thu, 26 May 2022 10:25:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [RFC PATCH v4 16/36] i386/tdvf: Introduce function to parse TDVF
 metadata
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
 <20220512031803.3315890-17-xiaoyao.li@intel.com>
 <20220524070258.evtfwwujone36yjx@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220524070258.evtfwwujone36yjx@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/2022 3:02 PM, Gerd Hoffmann wrote:
>    Hi,
> 
>> +static int tdvf_parse_section_entry(const TdvfSectionEntry *src,
>> +                                     TdxFirmwareEntry *entry)
> 
>> +    /* sanity check */
> 
> That is what the whole function is doing.  So rename it to
> tdvf_check_section_entry to clarify that?

I will rename it to tdvf_parse_and_check_section_entry() since it first 
parses the section entries from TDVF to software defined data structure 
TdxFirmwareEntry

> take care,
>    Gerd
> 

