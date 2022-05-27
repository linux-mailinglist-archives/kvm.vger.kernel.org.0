Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E3D535BB8
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 10:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245104AbiE0Ij4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 04:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349813AbiE0Ijz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 04:39:55 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D7911476
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 01:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653640792; x=1685176792;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bjyDl6kDQro5FK/KVrzr1mqiYtjFN8A1wcFN6EwTDb0=;
  b=byU3PeRTZ6JZ03qk7qYdN6cVnHeJRwX0vCFlXg7VrhhDvwgUcpo8sRAg
   qXdVcaZXLs80nJOiuL9XAGwym05RqBNrA5ZCuVsEaVfm+YWPvtCrQH+UJ
   1si23xeNzRMcnJbEJlXrPBN7RFoc3iiMr4RTCRe1ZM1lDZzgN/EQ9890L
   ubLe9fibzgnCKRfXOiUVVi+5BcWHXd4xJ2qvMwemX1rD1bClOGzx/2gfM
   zGaXGPp+oa9i3Yb4dPC8L0huwUunmVjw3u8tmBgP/PX8s8JuTTq+b0nZN
   k1q2ZMIhvC7BKlFa8Pt1vDPbFYcE+pQRcQDncpPn7YnXeIHh9Mc/1s30m
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="274523461"
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="274523461"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 01:39:52 -0700
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="574449080"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.28.41]) ([10.255.28.41])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 01:39:47 -0700
Message-ID: <fa75cda1-311d-dcd7-965d-c553700c5303@intel.com>
Date:   Fri, 27 May 2022 16:39:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [RFC PATCH v4 22/36] i386/tdx: Track RAM entries for TDX VM
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
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
 <20220512031803.3315890-23-xiaoyao.li@intel.com>
 <20220524073729.xkk6s4tjkzm77wwz@sirius.home.kraxel.org>
 <5e457e0b-dc23-9e5b-de89-0b137e2baf7f@intel.com>
 <20220526184826.GA3413287@ls.amr.corp.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220526184826.GA3413287@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/27/2022 2:48 AM, Isaku Yamahata wrote:
> On Thu, May 26, 2022 at 03:33:10PM +0800,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
>> On 5/24/2022 3:37 PM, Gerd Hoffmann wrote:
>>> I think all this can be simplified, by
>>>     (1) Change the existing entry to cover the accepted ram range.
>>>     (2) If there is room before the accepted ram range add a
>>>         TDX_RAM_UNACCEPTED entry for that.
>>>     (3) If there is room after the accepted ram range add a
>>>         TDX_RAM_UNACCEPTED entry for that.
>>
>> I implement as below. Please help review.
>>
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
>> +        if (address + length < e->address ||
>> +            e->address + e->length < address) {
>> +                continue;
>> +        }
>> +
>> +        /*
>> +         * The to-be-accepted ram range must be fully contained by one
>> +         * RAM entries
>> +         */
>> +        if (e->address > address ||
>> +            e->address + e->length < address + length) {
>> +            return -EINVAL;
>> +        }
>> +
>> +        if (e->type == TDX_RAM_ADDED) {
>> +            return -EINVAL;
>> +        }
>> +
>> +        tmp_address = e->address;
>> +        tmp_length = e->length;
>> +
>> +        e->address = address;
>> +        e->length = length;
>> +        e->type = TDX_RAM_ADDED;
>> +
>> +        head_length = address - tmp_address;
>> +        if (head_length > 0) {
>> +            head_start = e->address;
>> +            tdx_add_ram_entry(head_start, head_length, TDX_RAM_UNACCEPTED);
> 
> tdx_add_ram_entry() increments tdx_guest->nr_ram_entries.  I think it's worth
> for comments why this is safe regarding to this for-loop.

The for-loop is to find the valid existing RAM entry (from E820 table).
It will update the RAM entry and increment tdx_guest->nr_ram_entries 
when the initial RAM entry needs to be split. However, once find, the 
for-loop is certainly stopped since it returns unconditionally.

