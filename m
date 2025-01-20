Return-Path: <kvm+bounces-36004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44549A16C8B
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 13:50:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BEE83A10A5
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 12:50:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5AE11DFD80;
	Mon, 20 Jan 2025 12:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YAyNUZay"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401981FC8
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 12:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737377452; cv=none; b=CC3fufWEbER/DdOZgofKFbdIV/4H1G/Reo4k4/J5kGX5WXjrDVjU7hdNiws1mhJ44U8nVJVYB0cBRms39wnIl6JlE1QP4kTTukYJqanK8w267F48RFwVd3Dj7DwFa1IWvkmef2Cfx2r+3wpMEqbfFMAgdMClDTXNh6wi4N7BO9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737377452; c=relaxed/simple;
	bh=z95N+ZPpD/876rA5JJZ6KQsTatmMG8RGVYQXRi+VVcE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BjVgnV/iNc/6ZboMS8jgOMKnlibTNVxC6OGZmpr48tluCQDVd4QYBpyGaJ0RwQ3lNDJ/Q/Q+LdwV6meR8vFXiZY+rHTi5WR+YgsHpo4Va/mlFI3OfQr6cSb1sdeMLD/qgS2WkioVsoRQKk1zhu3bVyDYv9BeIIMuDE9suvB/f84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YAyNUZay; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737377449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UjeveJr0nKAk4vsUnn+qk5nokU6V0SYpsBAXoq0q6gA=;
	b=YAyNUZay6b9/sfBlfth6QuItmHSMGr7F8Z0NFj2S9tQ5L5jrBRK3JlU6BXJ37ZsBlE4U2o
	GNw00hR/Tg1EgYFftnkixWJIREwR3ax1rUvlaG6IlqziFc93xVmupoCDN/1g2hD5w1/wdb
	4i+3F6Sk4RGKLhFJbT3ua2imJN31eSI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-SSX9fHsLPXWxBbLIzP5Sjg-1; Mon, 20 Jan 2025 07:50:47 -0500
X-MC-Unique: SSX9fHsLPXWxBbLIzP5Sjg-1
X-Mimecast-MFC-AGG-ID: SSX9fHsLPXWxBbLIzP5Sjg
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4361fc2b2d6so23967735e9.3
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 04:50:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737377446; x=1737982246;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UjeveJr0nKAk4vsUnn+qk5nokU6V0SYpsBAXoq0q6gA=;
        b=t5lXztYlnm9x/Q1fvQggakV5qJw/L6mXdhJN0E1H4oFiVtOWC6TeNmruXfYNoChVSB
         Uh5hz6n5RO7f7SHp2aBLZkF5g0Pbcn9aSE4g1jUI+dxB7hWsYxch1fA7Q13ay9mwlBDc
         4BODj2vD1DCLNSz5fx7Vi3hMReij2PtaI5Uub230JBQneTitJ9E5xlUHG3S01QijmIJS
         nGfQT36PflZPe3u4cGi3DOgT7sic3uoCvO4lsQvO/uxe/5EIC/z3EA0dJzf8KkiXqoZW
         w2fEttpwHQkHTwNQN3vVT5n6XgEV3fSE/VHzXudAL360rG4DEqFAeQWdMHGUgK89bOgJ
         p75g==
X-Forwarded-Encrypted: i=1; AJvYcCXzC+mXoMe2I90yoZicFVOKeCY3/4C2rL41KOzN1RC+PtJ3uz0lAybxxUVLnYvjb//Tqks=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxsdnEMm3RCMkiP+QHJU4/vxTU+nZhwzrSVB6rArLLfg3+Vbpq
	zPPh73F2tdmVgVVd439uG5E+Pr9/a1Xy+cQXnVJNaHZvi8Dczqo5IRyO+zbjB4VYgMWwx2Gz0Ah
	BQc9EmdTACP0UmVBnTL992V4zkh/h9tk6syS+92xehcuq0hNlKA==
X-Gm-Gg: ASbGncsAjckseOqAoNMIdvRYkzk8AId4Q647VEHNurAdFC1FtMGXlNDhut+ZAs2rE7b
	81xJTeAP7gAmbeblfPlvPzVZj0vAsHSEfr/hh0KYs13LE/FItXxaFkOGWU6ufqH5qvOdvfJ+8W9
	ZVg5FmGW3AiTlKPNWkqWI2fxo1xYw3QszudAVckMoph8Wexg92AR2a8czUEWa+wA/tEBOc2tWrM
	ogUucoPx0lWWLt0v0A+tZUInK23lohuxzlxxzYUV/ay0Z37BKd7KxVlT6p1mLMUkRxmSJ9zIk2b
	dKkdYq7TdBDgIe++adxfdaEpTUoUSkq4RiJMHLK2avt7dysOvYioZz7u5jVUZO4l8TuasaSbx6D
	Q/rqVq4v56rjO/kW6BquipQ==
X-Received: by 2002:a05:600c:870a:b0:434:a923:9310 with SMTP id 5b1f17b1804b1-438913ec91dmr125458815e9.15.1737377446468;
        Mon, 20 Jan 2025 04:50:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFCMdNMN+xjBND7a4BGyFF3kqQ8uibGtg+rYIoHUhzoDM7xwFgviI6NCHx5/zTRP8KWkdXFeQ==
X-Received: by 2002:a05:600c:870a:b0:434:a923:9310 with SMTP id 5b1f17b1804b1-438913ec91dmr125458535e9.15.1737377446037;
        Mon, 20 Jan 2025 04:50:46 -0800 (PST)
Received: from ?IPV6:2003:d8:2f22:1000:d72d:fd5f:4118:c70b? (p200300d82f221000d72dfd5f4118c70b.dip0.t-ipconnect.de. [2003:d8:2f22:1000:d72d:fd5f:4118:c70b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43890413795sm136263025e9.14.2025.01.20.04.50.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2025 04:50:45 -0800 (PST)
Message-ID: <5aa112ff-5b45-4ef1-a0a9-c80191331f6c@redhat.com>
Date: Mon, 20 Jan 2025 13:50:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] memory: Export a helper to get intersection of a
 MemoryRegionSection with a given range
To: Alexey Kardashevskiy <aik@amd.com>, Chenyi Qiang
 <chenyi.qiang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-2-chenyi.qiang@intel.com>
 <30624aca-a718-4a7d-b14f-25ab26e6bded@amd.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <30624aca-a718-4a7d-b14f-25ab26e6bded@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08.01.25 05:47, Alexey Kardashevskiy wrote:
> On 13/12/24 18:08, Chenyi Qiang wrote:
>> Rename the helper to memory_region_section_intersect_range() to make it
>> more generic.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>>    hw/virtio/virtio-mem.c | 32 +++++---------------------------
>>    include/exec/memory.h  | 13 +++++++++++++
>>    system/memory.c        | 17 +++++++++++++++++
>>    3 files changed, 35 insertions(+), 27 deletions(-)
>>
>> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
>> index 80ada89551..e3d1ccaeeb 100644
>> --- a/hw/virtio/virtio-mem.c
>> +++ b/hw/virtio/virtio-mem.c
>> @@ -242,28 +242,6 @@ static int virtio_mem_for_each_plugged_range(VirtIOMEM *vmem, void *arg,
>>        return ret;
>>    }
>>    
>> -/*
>> - * Adjust the memory section to cover the intersection with the given range.
>> - *
>> - * Returns false if the intersection is empty, otherwise returns true.
>> - */
>> -static bool virtio_mem_intersect_memory_section(MemoryRegionSection *s,
>> -                                                uint64_t offset, uint64_t size)
>> -{
>> -    uint64_t start = MAX(s->offset_within_region, offset);
>> -    uint64_t end = MIN(s->offset_within_region + int128_get64(s->size),
>> -                       offset + size);
>> -
>> -    if (end <= start) {
>> -        return false;
>> -    }
>> -
>> -    s->offset_within_address_space += start - s->offset_within_region;
>> -    s->offset_within_region = start;
>> -    s->size = int128_make64(end - start);
>> -    return true;
>> -}
>> -
>>    typedef int (*virtio_mem_section_cb)(MemoryRegionSection *s, void *arg);
>>    
>>    static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
>> @@ -285,7 +263,7 @@ static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
>>                                          first_bit + 1) - 1;
>>            size = (last_bit - first_bit + 1) * vmem->block_size;
>>    
>> -        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
>> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>>                break;
>>            }
>>            ret = cb(&tmp, arg);
>> @@ -317,7 +295,7 @@ static int virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
>>                                     first_bit + 1) - 1;
>>            size = (last_bit - first_bit + 1) * vmem->block_size;
>>    
>> -        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
>> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>>                break;
>>            }
>>            ret = cb(&tmp, arg);
>> @@ -353,7 +331,7 @@ static void virtio_mem_notify_unplug(VirtIOMEM *vmem, uint64_t offset,
>>        QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
>>            MemoryRegionSection tmp = *rdl->section;
>>    
>> -        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
>> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>>                continue;
>>            }
>>            rdl->notify_discard(rdl, &tmp);
>> @@ -369,7 +347,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
>>        QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
>>            MemoryRegionSection tmp = *rdl->section;
>>    
>> -        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
>> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>>                continue;
>>            }
>>            ret = rdl->notify_populate(rdl, &tmp);
>> @@ -386,7 +364,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
>>                if (rdl2 == rdl) {
>>                    break;
>>                }
>> -            if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
>> +            if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>>                    continue;
>>                }
>>                rdl2->notify_discard(rdl2, &tmp);
>> diff --git a/include/exec/memory.h b/include/exec/memory.h
>> index e5e865d1a9..ec7bc641e8 100644
>> --- a/include/exec/memory.h
>> +++ b/include/exec/memory.h
>> @@ -1196,6 +1196,19 @@ MemoryRegionSection *memory_region_section_new_copy(MemoryRegionSection *s);
>>     */
>>    void memory_region_section_free_copy(MemoryRegionSection *s);
>>    
>> +/**
>> + * memory_region_section_intersect_range: Adjust the memory section to cover
>> + * the intersection with the given range.
>> + *
>> + * @s: the #MemoryRegionSection to be adjusted
>> + * @offset: the offset of the given range in the memory region
>> + * @size: the size of the given range
>> + *
>> + * Returns false if the intersection is empty, otherwise returns true.
>> + */
>> +bool memory_region_section_intersect_range(MemoryRegionSection *s,
>> +                                           uint64_t offset, uint64_t size);
>> +
>>    /**
>>     * memory_region_init: Initialize a memory region
>>     *
>> diff --git a/system/memory.c b/system/memory.c
>> index 85f6834cb3..ddcec90f5e 100644
>> --- a/system/memory.c
>> +++ b/system/memory.c
>> @@ -2898,6 +2898,23 @@ void memory_region_section_free_copy(MemoryRegionSection *s)
>>        g_free(s);
>>    }
>>    
>> +bool memory_region_section_intersect_range(MemoryRegionSection *s,
>> +                                           uint64_t offset, uint64_t size)
>> +{
>> +    uint64_t start = MAX(s->offset_within_region, offset);
>> +    uint64_t end = MIN(s->offset_within_region + int128_get64(s->size),
>> +                       offset + size);
> 
> imho @end needs to be Int128 and s/MIN/int128_min/, etc to be totally
> correct (although it is going to look horrendous). May be it was alright
> when it was just virtio but now it is a wider API.

Yes, virtio-mem operates on RAM regions only, so it does not exceed 64bit.

I understand this is
> cut-n-paste and unlikely scenario of offset+size crossing 1<<64 but
> still.

It's been bugging me for a while that size is 128bit 
butoffset_within_address_space and friends are 64bit. Likely we'll never 
get offset+size > 64bit here as of now, but it is indeed cleaner to just 
handle it using the correct type.

-- 
Cheers,

David / dhildenb


