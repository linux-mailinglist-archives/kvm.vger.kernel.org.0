Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30BED784605
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 17:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237290AbjHVPpc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 11:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbjHVPpb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 11:45:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F056CD5
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 08:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692719130; x=1724255130;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5v6aCju/1g5fNSmLz1BLj1E+RPrUqsxUNIS0WONK45U=;
  b=TqbMnk56hKlOqSQNgH2R5I6MrkCAnBUjGTG1r3/1hF6Osrmhtio8BmW/
   w/O7xmIlPCHbgdOfF+TFEnSoe06lPkjyybFiZIZVYMS6ifHUBPQGK9byb
   My8WrhflzSYpt785xpD5EWlIVcDinRtgT+v8Q0lPyS2Ubr9V5fCo9t19/
   3lrl3MTfwpywSHqFuW0OUb4D/8VSk//5dATFtMqCHKmsqAa+oPoql++z+
   tAZxtrtGZ2Vh8/PrKE5kPMC6cOOr+uOYXm4DEajye89gcSQZvp280gHH9
   tKDq67LCY1cJWmAInttVCeEbRzMHVaKv4knV7athlkYxu1yL5nkI/9qGq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="371335823"
X-IronPort-AV: E=Sophos;i="6.01,193,1684825200"; 
   d="scan'208";a="371335823"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 08:45:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="859961159"
X-IronPort-AV: E=Sophos;i="6.01,193,1684825200"; 
   d="scan'208";a="859961159"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 08:45:12 -0700
Message-ID: <fa401024-2a19-229b-932e-d3541c763422@intel.com>
Date:   Tue, 22 Aug 2023 23:45:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH v2 32/58] i386/tdx: Track RAM entries for TDX VM
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
 <20230818095041.1973309-33-xiaoyao.li@intel.com>
 <20230821234052.GD3642077@ls.amr.corp.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230821234052.GD3642077@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/22/2023 7:40 AM, Isaku Yamahata wrote:
> On Fri, Aug 18, 2023 at 05:50:15AM -0400,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
>> diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
>> index e9d2888162ce..9b3c427766ef 100644
>> --- a/target/i386/kvm/tdx.h
>> +++ b/target/i386/kvm/tdx.h
>> @@ -15,6 +15,17 @@ typedef struct TdxGuestClass {
>>       ConfidentialGuestSupportClass parent_class;
>>   } TdxGuestClass;
>>   
>> +enum TdxRamType{
>> +    TDX_RAM_UNACCEPTED,
>> +    TDX_RAM_ADDED,
>> +};
>> +
>> +typedef struct TdxRamEntry {
>> +    uint64_t address;
>> +    uint64_t length;
>> +    uint32_t type;
> 
> nitpick: enum TdxRamType. and related function arguments.
> 

Will do it.

Thanks!

