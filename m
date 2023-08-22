Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDE87845BC
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 17:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237222AbjHVPjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 11:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237212AbjHVPjM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 11:39:12 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4DDCCB
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 08:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692718750; x=1724254750;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9kngf6wYTpV66d+4lW1aCHCO61j099WF3nKx5ig4uLg=;
  b=Ivyx1cAzNpgbopKnKIqj5aoetTYrmQQyPdiIi89sU2yTJOCo6CbkMgdV
   j0lSHmgnJCG33+VRDeqR4cH28lKx4dY1782Sim68RMMGn1qJ77CJSI3Cf
   6ctKAJYRMR/glj9TEO4bv8WwKRNfXOJxOJMkz2IhnokJos0OlA44xdi8l
   /DsUSonvKMxIv0wo2M8LPNnwbWqkwDeMXrNq1c6CAeSkVVTJ4A02O87cp
   Rli199xvkJOIkoPsLxIN21KHXqHvWWLrF7BkznjDWfeh8/Ne07U2sSWQV
   BJCEGRh/K0BQ06mjrNIYYmE7twlgzuf4xrRoR9/sxRsSjGizBeI/AyAGn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="377674910"
X-IronPort-AV: E=Sophos;i="6.01,193,1684825200"; 
   d="scan'208";a="377674910"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 08:39:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="1067105293"
X-IronPort-AV: E=Sophos;i="6.01,193,1684825200"; 
   d="scan'208";a="1067105293"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 08:39:04 -0700
Message-ID: <1241e07d-c9ee-1c63-7009-f5e9f2a040a4@intel.com>
Date:   Tue, 22 Aug 2023 23:39:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH v2 32/58] i386/tdx: Track RAM entries for TDX VM
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
 <20230818095041.1973309-33-xiaoyao.li@intel.com>
 <ZOMwin3eGaYLNNQh@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZOMwin3eGaYLNNQh@redhat.com>
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

On 8/21/2023 5:38 PM, Daniel P. Berrangé wrote:
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index bb806736b4ff..ed617ebab266 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> +static int tdx_accept_ram_range(uint64_t address, uint64_t length)
>> +{
>> +    uint64_t head_start, tail_start, head_length, tail_length;
>> +    uint64_t tmp_address, tmp_length;
>> +    TdxRamEntry *e;
>> +    int i;
>> +
>> +    for (i = 0; i < tdx_guest->nr_ram_entries; i++) {
>> +        e = &tdx_guest->ram_entries[i];
>> +
>> +        if (address + length <= e->address ||
>> +            e->address + e->length <= address) {
>> +                continue;
> Indented too far
> 

Fixed.

Thanks!
-Xiaoyao
