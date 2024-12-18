Return-Path: <kvm+bounces-34043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E93B09F65F5
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 13:34:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3577016C70F
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 12:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 631321A2399;
	Wed, 18 Dec 2024 12:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MEFN93Nl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A241534EC
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 12:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734525245; cv=none; b=izv47sdh8eIXsbQ6nJfsWFWeLGD9OxgrCYz5da16CBgI9WIWdvCTxwvGrWE9AORJR8FmmzPUcarSr2PsDKZEaV6ME21uFi4AbJx+GMbJEyC0L6edsM722qHEMHNjKVBdioeemrWWF9JaOXjB2WAOdcmFga7rzckQ0cAOhnn9XOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734525245; c=relaxed/simple;
	bh=u4TqULNgZ7UtxYm95mf+wQ+QsHycZfEJDrFmEv9pvWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u2cN6W68lbQnm7KOGqwIdSeTinKHDRJbKnsYSG57Tx8CBQ71AkOpvTRRJQb31X/k6++u92posY1+bDtA0S+uJlFKIj9NZIZ55v5NokHfIlbR7MgGZP5x6VBakogpREe7e4TDqAZ2f6XvxJIKQm08ZHVJOwCMQfJ/BR19WZvq8Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MEFN93Nl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734525242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yqdd/V/bKAUPiuxzl3/8CvS/nVflswvv2IwIkRrnVTE=;
	b=MEFN93NlhVLmLbHnu78f8qTZ9h1X/P39uH6z+h6mXCTYuyMF/TNYBMkDttnQBSEGJ/jJJg
	lkjpPCXow2OeZfb1xtf/2lODsOWnr8FKE5/eeUsJOX3cj+crzwRk2H8u7j1tnLoGVlwO9B
	NaSJQPBn0puv0FmNcXR45U/aRMa0QBE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-ULB8_YKQNRCrmN81rYjjmA-1; Wed, 18 Dec 2024 07:34:01 -0500
X-MC-Unique: ULB8_YKQNRCrmN81rYjjmA-1
X-Mimecast-MFC-AGG-ID: ULB8_YKQNRCrmN81rYjjmA
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43621907030so57380715e9.1
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 04:34:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734525240; x=1735130040;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yqdd/V/bKAUPiuxzl3/8CvS/nVflswvv2IwIkRrnVTE=;
        b=Y/MwaIhXLw5L4QDBpMmtnr0NYoSi16bJ2sijMM0adpdpxP/FjkoY5+qPQ/s+r3kN9S
         TW0QGXGE2KoEc5jmjKlhd92tb1Ul139hAO+oaW3+2C3AMqFgRlxKh9aoJzf7FenrnLSm
         99AuQBhiIA09FIAleAAO3on0d4sHB/UZCLe+wzzG42i993x5OGxDoUhIktCFl5qLRvri
         X/ohs2UtB6mr6VDBqEiDKhPHpTIWdzdB9zNc3RIR0nSv+wSDY4gz+85V8uLGvtjBj5NF
         DQ1U+yZBhMLmegQYwp08t7E4xmTt/m/v+hpQwYq1UEeMx3IsOccVPZZNqWu81aoDE08L
         5QZw==
X-Forwarded-Encrypted: i=1; AJvYcCXMc0FFvKbaI4oVIuE3bXbr+s2smPnDza+IX2c+DtO6ovxPjXzQpL2CCsJAbQJMH3G7ZTE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAtdOxfx8UbZ0nIxeBLrOuhrewljNLFBQXFvetXZEQMslMzxZB
	KpShGSRADgOLJchJjTI/+cV6oDCIw3n5eh71HkyW07w2q8bKR+YC4XSKhfngmt/EgiKZVmOCKM8
	MkI93uxVjM8SkZmer2QqqxSsYsg37P5DsnaOXsikFklRmZ5++EA==
X-Gm-Gg: ASbGnctCvjnynW9q+bepE/o09pHxNQ5b/fEir3h5pO8jL9H2hfnqWz68bHXq60S8xZ9
	CSScpx/yE8mP+mqMXXv8q0JHx+Gsg9wcXbp3Ir/KRWN3rGdT0uoSMHVLmuzn7D6H0G+F0F/dui8
	CWIxuIuPZh15fDGQ5UdvoJdIfuL45jAHTDcPLWyiHRJTYPMgAwKVAFYsraQ5NT1yiZJgO2p7i9U
	tICqAJc72xxA5l1m3x2yDm3gpMCj3IreUCk0GMGjSzVH5XsQ6VtzO3lXJ2xeVOs/4srSx7hafc4
	OimDfKEmGgmur4Y=
X-Received: by 2002:a5d:6d03:0:b0:385:eb7c:5d0f with SMTP id ffacd0b85a97d-388e4d8bf86mr2407019f8f.26.1734525240134;
        Wed, 18 Dec 2024 04:34:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHjzyymPklDvLYaHRn9pY1XH0SNWpQVT5aMK6k2ZDebrB4+AA0btMW8PvvvlrwmjP3e4Z6+4A==
X-Received: by 2002:a5d:6d03:0:b0:385:eb7c:5d0f with SMTP id ffacd0b85a97d-388e4d8bf86mr2406996f8f.26.1734525239754;
        Wed, 18 Dec 2024 04:33:59 -0800 (PST)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-388c80605casm14094929f8f.86.2024.12.18.04.33.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 04:33:59 -0800 (PST)
Message-ID: <533a9810-6d0e-4f46-ab9d-83907376c080@redhat.com>
Date: Wed, 18 Dec 2024 13:33:57 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] memory: Export a helper to get intersection of a
 MemoryRegionSection with a given range
To: Chenyi Qiang <chenyi.qiang@intel.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-2-chenyi.qiang@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241213070852.106092-2-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.12.24 08:08, Chenyi Qiang wrote:
> Rename the helper to memory_region_section_intersect_range() to make it
> more generic.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>   hw/virtio/virtio-mem.c | 32 +++++---------------------------
>   include/exec/memory.h  | 13 +++++++++++++
>   system/memory.c        | 17 +++++++++++++++++
>   3 files changed, 35 insertions(+), 27 deletions(-)
> 
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index 80ada89551..e3d1ccaeeb 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -242,28 +242,6 @@ static int virtio_mem_for_each_plugged_range(VirtIOMEM *vmem, void *arg,
>       return ret;
>   }
>   
> -/*
> - * Adjust the memory section to cover the intersection with the given range.
> - *
> - * Returns false if the intersection is empty, otherwise returns true.
> - */
> -static bool virtio_mem_intersect_memory_section(MemoryRegionSection *s,
> -                                                uint64_t offset, uint64_t size)
> -{
> -    uint64_t start = MAX(s->offset_within_region, offset);
> -    uint64_t end = MIN(s->offset_within_region + int128_get64(s->size),
> -                       offset + size);
> -
> -    if (end <= start) {
> -        return false;
> -    }
> -
> -    s->offset_within_address_space += start - s->offset_within_region;
> -    s->offset_within_region = start;
> -    s->size = int128_make64(end - start);
> -    return true;
> -}
> -
>   typedef int (*virtio_mem_section_cb)(MemoryRegionSection *s, void *arg);
>   
>   static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
> @@ -285,7 +263,7 @@ static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
>                                         first_bit + 1) - 1;
>           size = (last_bit - first_bit + 1) * vmem->block_size;
>   
> -        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>               break;
>           }
>           ret = cb(&tmp, arg);
> @@ -317,7 +295,7 @@ static int virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
>                                    first_bit + 1) - 1;
>           size = (last_bit - first_bit + 1) * vmem->block_size;
>   
> -        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>               break;
>           }
>           ret = cb(&tmp, arg);
> @@ -353,7 +331,7 @@ static void virtio_mem_notify_unplug(VirtIOMEM *vmem, uint64_t offset,
>       QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
>           MemoryRegionSection tmp = *rdl->section;
>   
> -        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>               continue;
>           }
>           rdl->notify_discard(rdl, &tmp);
> @@ -369,7 +347,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
>       QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
>           MemoryRegionSection tmp = *rdl->section;
>   
> -        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>               continue;
>           }
>           ret = rdl->notify_populate(rdl, &tmp);
> @@ -386,7 +364,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
>               if (rdl2 == rdl) {
>                   break;
>               }
> -            if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
> +            if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>                   continue;
>               }
>               rdl2->notify_discard(rdl2, &tmp);
> diff --git a/include/exec/memory.h b/include/exec/memory.h
> index e5e865d1a9..ec7bc641e8 100644
> --- a/include/exec/memory.h
> +++ b/include/exec/memory.h
> @@ -1196,6 +1196,19 @@ MemoryRegionSection *memory_region_section_new_copy(MemoryRegionSection *s);
>    */
>   void memory_region_section_free_copy(MemoryRegionSection *s);
>   
> +/**
> + * memory_region_section_intersect_range: Adjust the memory section to cover
> + * the intersection with the given range.
> + *
> + * @s: the #MemoryRegionSection to be adjusted
> + * @offset: the offset of the given range in the memory region
> + * @size: the size of the given range
> + *
> + * Returns false if the intersection is empty, otherwise returns true.
> + */
> +bool memory_region_section_intersect_range(MemoryRegionSection *s,
> +                                           uint64_t offset, uint64_t size);
> +
>   /**
>    * memory_region_init: Initialize a memory region

Maybe it could simply be an inline function. In any case, LGTM:

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


