Return-Path: <kvm+bounces-44311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A0848A9C924
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 14:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E2BC1BC73B9
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 12:45:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB95424C06A;
	Fri, 25 Apr 2025 12:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i6xo3dPi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD3F4438B
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 12:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745585084; cv=none; b=iGXaSkGQE5+rhHHms8Y4M/EHJpfXb0rB5ZIgEZUP/hD3QhHdVlGBX+xVrhacnuYvLLN0c9njGC0xcecOClJO1M6dmfSI02lX+E5nACIj8up0dc4g5wSUSAvTrbX2TVU34GPDcxs+yrMs7yqE4J2RWZTlCC98qwljcgBfAEPf6EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745585084; c=relaxed/simple;
	bh=BiBoIZjEnHILzAMycHROXbLFdGmvPtF9EdJX52pmVxo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VxM0NNBHtB9QGkaSBMoNmrwBNzmbR2lK86aD/LcVLRfEJeMIcIjcp906QD5TK53TSV230W8nKSMw7ga4lK+0yoK7nxBruSUwMQGScvGR7GV2EenxBIEl6aZLY+DJVhqz6thQWwR13xF5DjVgptS5rMs69GJOEfp2Wj7vOHlzhBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i6xo3dPi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745585082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BUIzuZIoevKaOOrNrc57gS2evt9gSa+yv9zGeRW2cyU=;
	b=i6xo3dPiO5QcTN1GlBPh13+Eksm7MKvQSwKUk2KX+wnlzasAui40xvRkqbBKJyjIttD64s
	VWPzovQ9qdwosJPlvKHSKex/Vnx9kyLNuaIflI9MLCsu2yiY0eaT1RxzNwJ+yRCGfH1VkK
	nOuPeZyJsfxj3WMgEyvPMPh0xF/dKNY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-338-KrSIhY_HNye8EeDlGQxUtQ-1; Fri, 25 Apr 2025 08:44:40 -0400
X-MC-Unique: KrSIhY_HNye8EeDlGQxUtQ-1
X-Mimecast-MFC-AGG-ID: KrSIhY_HNye8EeDlGQxUtQ_1745585079
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43eea5a5d80so9740395e9.1
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 05:44:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745585079; x=1746189879;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BUIzuZIoevKaOOrNrc57gS2evt9gSa+yv9zGeRW2cyU=;
        b=k+AZ7PTteAUU8ys1AVTgnIVApSrEk2QfhR0U416SeVa6TbL6aZtcLZ764/ohchbFrD
         t8BsvDgWpYI4UNsOgjCTgPQsa97QF2Rwb/8o1RteZ0vkRSHzkidFF+yKAfJIaDqGNCZT
         zrxeRDwwwcCPBjfe6i4s6nVLBN4VvzdZdutqJJoUcyAx4fhFgZFkkuStvkuhFp0AL1zl
         kEbgX9MGsM8MrZFTxQvQ5e5uMDK9Ap6U9GiKXT/SwIAleJqnEnxCfZqAWkelxOw2OASJ
         0xDHY4g92TjkcO0NnQYF7334oCqdNWpo67L3L8yfME9LSI7M8j6L0OlNmd1jnGRIRHgG
         wmYw==
X-Forwarded-Encrypted: i=1; AJvYcCXvarW1pZ05cWwX6Qs+1l/81KEcwJlJl+zeSYwRD1DN+axCH4QRRRwwKlSmL5KVPoDSjgQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSLE1Q8Ty+T8HIGBtvnsQy2c7JDmgPYVKfSmTAVp1hmfNvtvJI
	1gSsaE3lVoqR63Cxqb3I7gd8H5pzsZlMqy0TpY+BNFDCyd3S5R6QcvlfpzyVZECCsd43YCVy64q
	MNvjxXbllpKqjZAYceyS4gYJsJZZnaZ020cc/gRnIlqfOz7iGGQ==
X-Gm-Gg: ASbGnctd4mSAZAJWACjldlT4Gu3c52uUKGQeQ3AP/MxdMWQTWTamniNPMyB3E7sWyiI
	hqlRtBOFG8JHj/g9N8qVFoNQFhzu034wBfybPmjETBW2REu7L8W8Py22HfB5ybjNb+jbstt5YHa
	GN/M59+vMEJXwTEHMm5aEeEYD4kYwNpUE5pjJ3alf6wB8u/LnLneBHEbrvfiCYlqU7oFPRqfJy/
	pqYbczm87kHXT8VMrICLAbPATKyTCPQIY3zmJto9dJ1TMslZRFeDs6clxoEvdVp9+5nFaUrX7h5
	0j1AvdMlXtZAg0ScAkb8OiCqR9eCVTr8X7QPb+Wb/24bVxM/c4mxIjRxDSG8PhXHea66DpQGrgc
	czlhqPZj8WwUAj3YBpWPGNFgoWV7mf8V6kSfD
X-Received: by 2002:a05:600c:a4d:b0:43d:fa5d:9315 with SMTP id 5b1f17b1804b1-440a66ad3f8mr17256825e9.33.1745585079437;
        Fri, 25 Apr 2025 05:44:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBoLPoqGSG/0NDRVw5LHTV4wzNnvb2OFU5vUs3hic7PoU35/VFWfDbxaH2WJF1RI8OM1ejJQ==
X-Received: by 2002:a05:600c:a4d:b0:43d:fa5d:9315 with SMTP id 5b1f17b1804b1-440a66ad3f8mr17256595e9.33.1745585078989;
        Fri, 25 Apr 2025 05:44:38 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70f:6900:6c56:80f8:c14:6d2a? (p200300cbc70f69006c5680f80c146d2a.dip0.t-ipconnect.de. [2003:cb:c70f:6900:6c56:80f8:c14:6d2a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-440a538f9c6sm23690585e9.39.2025.04.25.05.44.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 05:44:38 -0700 (PDT)
Message-ID: <57af7479-890e-4123-bfeb-9c478dbfd62f@redhat.com>
Date: Fri, 25 Apr 2025 14:44:37 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/13] memory: Unify the definiton of
 ReplayRamPopulate() and ReplayRamDiscard()
To: Alexey Kardashevskiy <aik@amd.com>, Chenyi Qiang
 <chenyi.qiang@intel.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-4-chenyi.qiang@intel.com>
 <20936115-1d56-4504-9305-e023eaac081d@amd.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20936115-1d56-4504-9305-e023eaac081d@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09.04.25 07:43, Alexey Kardashevskiy wrote:
> 
> 
> On 7/4/25 17:49, Chenyi Qiang wrote:
>> Update ReplayRamDiscard() function to return the result and unify the
>> ReplayRamPopulate() and ReplayRamDiscard() to ReplayStateChange() at
>> the same time due to their identical definitions. This unification
>> simplifies related structures, such as VirtIOMEMReplayData, which makes
>> it more cleaner and maintainable.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>> Changes in v4:
>>       - Modify the commit message. We won't use Replay() operation when
>>         doing the attribute change like v3.
>>
>> Changes in v3:
>>       - Newly added.
>> ---
>>    hw/virtio/virtio-mem.c | 20 ++++++++++----------
>>    include/exec/memory.h  | 31 ++++++++++++++++---------------
>>    migration/ram.c        |  5 +++--
>>    system/memory.c        | 12 ++++++------
>>    4 files changed, 35 insertions(+), 33 deletions(-)
>>
>> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
>> index d0d3a0240f..1a88d649cb 100644
>> --- a/hw/virtio/virtio-mem.c
>> +++ b/hw/virtio/virtio-mem.c
>> @@ -1733,7 +1733,7 @@ static bool virtio_mem_rdm_is_populated(const RamDiscardManager *rdm,
>>    }
>>    
>>    struct VirtIOMEMReplayData {
>> -    void *fn;
>> +    ReplayStateChange fn;
> 
> 
> s/ReplayStateChange/ReplayRamStateChange/
> 
> Just "State" is way too generic imho.

Right, but raised in my review, the "Change" is wrong, it's not a change.

ReplayRamState ... ReplayRamDiscardState or sth like that ?

After all, it's the "RAM Discard manager".

-- 
Cheers,

David / dhildenb


