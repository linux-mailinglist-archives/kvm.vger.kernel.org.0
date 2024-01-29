Return-Path: <kvm+bounces-7297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF80383FC27
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 03:24:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 822AC1F23339
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 02:24:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45DCDFC0A;
	Mon, 29 Jan 2024 02:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cfjhs6Aw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A82FBE8
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 02:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706495037; cv=none; b=oRuMG/kOd17aekbkYA14LM+ko/q6Mz+S8lnbpdl45Ws4HTljw8Q2UZuQvubHhPxmVqo1XUVpRg+yIzFAb2/KwXPhOrDzpcOcE9gQ2RmDGT8z8q08h8HpXqXqHLdh8JG/7eQPgQY8ELSo+S/UMbRRmYnGymAu8xfYwNGlyM9OJ+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706495037; c=relaxed/simple;
	bh=orAmYn8pMaJxl8CsOhFgwF/0wRPX8swPuGuvQx5fGAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dGoU8hSN0e/uPLWK0o5dkqFxDbnDScuo0OfTz1VE2z2LynEdUdx6WsWO6o1EviJiV7gzYsowynMr0MXc8n4LJuNDBqzd0vyOeJ4Irzyryp6s3d1L9+jV9MW1yrJ3IPPkot2tqZgBTGJRb9007d/ZeoLp0u3afTbu4WUe8Mdmqc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cfjhs6Aw; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706495035; x=1738031035;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=orAmYn8pMaJxl8CsOhFgwF/0wRPX8swPuGuvQx5fGAo=;
  b=cfjhs6AwzsPoELktjhpiciMpl/2C1/i0Mg59v0OVJrxk3cArGDTaPqzM
   1dSFcqtZpltrsU64WlcjlRVe94vpRizi8tXgm1h5WtOdFNQWLJQBExbl1
   ubLZNTS9VSkWmD7uXJJpeyNZi3izi1X3NZzpJj4fmRcp/OmEbxcF1P2IM
   RiabU7WUhuftHmJ//XbLzVVS6WzTMvUDHVEEOzSOFFRRARVy79sn3D2mn
   CGbV4GSEzEgYDpUyc188arwBAa6GmxUe0a34zlBn7KOgZ5t/Xnnv96T4I
   s8FdoyG9y84R/KHHo+pD26DfIgUgKfZ6kAezffYV0ivYkkSQZe4emDKK9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10967"; a="16188449"
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="16188449"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 18:23:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="3206435"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.33.17]) ([10.93.33.17])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 18:23:48 -0800
Message-ID: <28570a5f-a989-496d-b347-b75763c4ac69@intel.com>
Date: Mon, 29 Jan 2024 10:23:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/66] RAMBlock: Add support of KVM private guest memfd
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
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
 <20240125032328.2522472-3-xiaoyao.li@intel.com>
 <504fca4f-89a1-4f92-a2f0-f64b04473ec4@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <504fca4f-89a1-4f92-a2f0-f64b04473ec4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/26/2024 9:57 PM, David Hildenbrand wrote:
>>   uint8_t memory_region_get_dirty_log_mask(MemoryRegion *mr)
>>   {
>>       uint8_t mask = mr->dirty_log_mask;
>> diff --git a/system/physmem.c b/system/physmem.c
>> index c1b22bac77c2..4735b0462ed9 100644
>> --- a/system/physmem.c
>> +++ b/system/physmem.c
>> @@ -1841,6 +1841,17 @@ static void ram_block_add(RAMBlock *new_block, 
>> Error **errp)
>>           }
>>       }
>> +    if (kvm_enabled() && (new_block->flags & RAM_GUEST_MEMFD) &&
>> +        new_block->guest_memfd < 0) {
> 
> How could we have a guest_memfd already at this point? Smells more like 
> an assert(new_block->guest_memfd < 0);

you are right. I will change it to the assert()

>> +        /* TODO: to decide if KVM_GUEST_MEMFD_ALLOW_HUGEPAGE is 
>> supported */
> 
> I suggest dropping that completely. As long as it's not upstream, not 
> even the name of that thing is stable.

OK

>> +        new_block->guest_memfd = 
>> kvm_create_guest_memfd(new_block->max_length,
>> +                                                        0, errp);
>> +        if (new_block->guest_memfd < 0) {
>> +            qemu_mutex_unlock_ramlist();
>> +            return;
>> +        }
>> +    }
>> +
> 
> 
> In general, LGTM. With the two nits above:
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> 

Thanks!



