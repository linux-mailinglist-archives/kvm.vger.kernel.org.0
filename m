Return-Path: <kvm+bounces-2851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EA0F07FE9D0
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 08:38:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 85299B20ACB
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 07:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BCC1200C9;
	Thu, 30 Nov 2023 07:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UGd1e4k5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D1F196
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 23:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701329882; x=1732865882;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nRsvxMK0xXLv2z475vawDPZCSbmouFr1izddt1pJqeY=;
  b=UGd1e4k5gPcRiKmNpVbla/WEktammAXow7XVSNUA/asJnY1gLtJdMR7y
   W7kIyCpyO5ZOZqktASqmMhIREEf1BolP/nECo2r7/86AAoRn79pa1u5n+
   eJA1M2ahR3DZP7IRf74N/zKyKS3QyuydTMGh7BCGx0EOyZEfmGWTjvC26
   Fg8drON3ioxFqtKHcHEXZWZExb3ZeAZDJ2u6fOJUknIZVWqzCxNVxCyJS
   CFg05FkSO5/lQR3GVS24jhgUxZvGNidGcOFDoJB5jMR27UnBK7FmkL24g
   Ysh36RhQyqvu59ZxOTognptaLgfyJRY3eyslrNAuT/prfYQCFJtpVl3xi
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="424432595"
X-IronPort-AV: E=Sophos;i="6.04,237,1695711600"; 
   d="scan'208";a="424432595"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2023 23:38:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="798195854"
X-IronPort-AV: E=Sophos;i="6.04,237,1695711600"; 
   d="scan'208";a="798195854"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2023 23:37:55 -0800
Message-ID: <8b2800e3-989a-4c9f-b7e5-7b2e0702e3a0@intel.com>
Date: Thu, 30 Nov 2023 15:37:49 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/70] RAMBlock: Add support of KVM private guest memfd
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Michael Roth <michael.roth@amd.com>, Sean Christopherson
 <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-3-xiaoyao.li@intel.com>
 <82ac9bf4-7463-48fc-b138-fcaa6314547f@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <82ac9bf4-7463-48fc-b138-fcaa6314547f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/20/2023 5:24 PM, David Hildenbrand wrote:
>>   uint8_t memory_region_get_dirty_log_mask(MemoryRegion *mr)
>>   {
>>       uint8_t mask = mr->dirty_log_mask;
>> diff --git a/system/physmem.c b/system/physmem.c
>> index fc2b0fee0188..0af2213cbd9c 100644
>> --- a/system/physmem.c
>> +++ b/system/physmem.c
>> @@ -1841,6 +1841,20 @@ static void ram_block_add(RAMBlock *new_block, 
>> Error **errp)
>>           }
>>       }
>> +#ifdef CONFIG_KVM
>> +    if (kvm_enabled() && new_block->flags & RAM_GUEST_MEMFD &&
> 
> 
> I recall that we prefer to write this as
> 
>      if (kvm_enabled() && (new_block->flags & RAM_GUEST_MEMFD) &&

get it.

Thanks!

>> +        new_block->guest_memfd < 0) {
>> +        /* TODO: to decide if KVM_GUEST_MEMFD_ALLOW_HUGEPAGE is 
>> supported */
>> +        uint64_t flags = 0;
>> +        new_block->guest_memfd = 
>> kvm_create_guest_memfd(new_block->max_length,
>> +                                                        flags, errp);
> 
> Get rid of "flags" and just pass 0". Whatever code wants to pass flags 
> later can decide how to do that.


How to handle it please see the reply to patch 3.


