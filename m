Return-Path: <kvm+bounces-28814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EAB3899D7A6
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 21:47:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63E2D1F23055
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 19:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8641F1CCED8;
	Mon, 14 Oct 2024 19:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T9duOHWN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221421C9B7A
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 19:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728935241; cv=none; b=Iqkj4UZxNnFxX6CR/k4HxryRO7x8R5pTvSQ4WHvEWfEwSfiK5wMP8EjhAk1Tl0NG86x3D7pIy+On9pN9k9ESvcr2VGo1sW0/hCHEiuiki96xyXFJTP8o8dXwp4XbQN6qvZLpSM4ZHRg3JaKRnQ3NEmAIrnzVJL70rsq5MXB79Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728935241; c=relaxed/simple;
	bh=hNsPGQlN+tgxXlyGzBEoHTvHqz1DcphwD6h1Bbjfk0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oWaIbCNZtO77jk5sSMHYDNLWRveaPk6cn/dg9FkXtAbb7IdP2fu33a/hgU8ASxZayvtgk/KgdpEWATUytkI5b4mMBQCyMXaSMHHXcet83gVT/0GvSGHeYEdit4qwfpyXGGC6giHnTMk9RsmqXh0JqBPcZxVUN4/JoyHTlOiHeEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T9duOHWN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728935239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9f+jPSSrcKbUmnkY+49+BdbeWERKSiibXu+1oFdZXw8=;
	b=T9duOHWNIA735VdZp2nMT4z9OQDxoXqz9BY2HpMXu3piOt3NUCkA/rRzaziyltAd3e7L1V
	lBPfnMZtSaq9ZvaoOmcxNUGNa1WpiU9d1JS8aghDYIBxv2inrySeh4qVvxbxNh14o40j0/
	nYxDyZgEMQuSKae71RPUWfRnllj66zA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-164-9ai9M3xGPsuEZs_PXKRR4A-1; Mon, 14 Oct 2024 15:47:17 -0400
X-MC-Unique: 9ai9M3xGPsuEZs_PXKRR4A-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-37d39bf2277so1655399f8f.2
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 12:47:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728935236; x=1729540036;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9f+jPSSrcKbUmnkY+49+BdbeWERKSiibXu+1oFdZXw8=;
        b=T9mMFPN5cb7+FJnseq1YRkF2rL+1GRVSZFN+WPKfE6V9QukqIYsoa0tP9aaR2+mvKh
         vQDoNiNpPmdp8tvoayZBcI4+nsScAJ0u8Cu/8v0wNJeE0vK1NRwpgrhLxAPR9ecGePQR
         owiE+idyUeHVryw6HlzBMq5N8Rnf74F9C7d4EwIjUVs7EhLcKmK6aziRb68w+5yN8jre
         8TQYibQ+bUJEhrfzqMMf2XY1fD1fEpPn/ERkZ0qha5p3rHAFQOUZi+icJghLYXQJglCz
         LFPa4E2BHSYIDk0T4M9NYhcDU3wCtyG1Lgh5sfr7tp+cZv1d0BvIq6kFiqeT+SFTKMtO
         C86A==
X-Forwarded-Encrypted: i=1; AJvYcCWHlCBwz+I2+dBr9hynIgnwWRl0aKQNiLEP8x3uACja8FlWmmv3RhHm70VFzhkzRMgETYI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7O15wCCe8OnYMGvBYCuq1LE47kFMWBq1WblEukGbpNYUXEpBC
	wwr+na1RvgW39RsbzYM/qMkKLTovvYlPxAQIR/ZtqLE1ft7TuPybq9iDXLREvnqwKuUAIdjoV3Y
	w8rTj+oxktZ8OnURA/KV1vN+bIOZgGR0saFK90NnoOPIAKXnD+Q==
X-Received: by 2002:adf:e608:0:b0:37d:4fe9:b6ae with SMTP id ffacd0b85a97d-37d5519881bmr7870038f8f.7.1728935236488;
        Mon, 14 Oct 2024 12:47:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGqcjEvb1jHHdnO97vII/IN5GoQk3c9Wr+EG2efmydey9JQVPNjY/EMzI1ifTzURmILDRW9Ww==
X-Received: by 2002:adf:e608:0:b0:37d:4fe9:b6ae with SMTP id ffacd0b85a97d-37d5519881bmr7870025f8f.7.1728935236015;
        Mon, 14 Oct 2024 12:47:16 -0700 (PDT)
Received: from ?IPV6:2003:cb:c71e:600:9fbb:f0bf:d958:5c70? (p200300cbc71e06009fbbf0bfd9585c70.dip0.t-ipconnect.de. [2003:cb:c71e:600:9fbb:f0bf:d958:5c70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d4b79f69dsm12226388f8f.81.2024.10.14.12.47.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2024 12:47:14 -0700 (PDT)
Message-ID: <177ca9d5-9fc7-4f43-83fb-ea5105621cc8@redhat.com>
Date: Mon, 14 Oct 2024 21:47:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/7] s390/sparsemem: reduce section size to 128 MiB
To: Heiko Carstens <hca@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
 linux-doc@vger.kernel.org, kvm@vger.kernel.org,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-8-david@redhat.com>
 <20241014175335.10447-B-hca@linux.ibm.com>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241014175335.10447-B-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14.10.24 19:53, Heiko Carstens wrote:
> On Mon, Oct 14, 2024 at 04:46:19PM +0200, David Hildenbrand wrote:
>> Ever since commit 421c175c4d609 ("[S390] Add support for memory hot-add.")
>> we've been using a section size of 256 MiB on s390 and 32 MiB on s390.
>> Before that, we were using a section size of 32 MiB on both
>> architectures.
>>
>> Likely the reason was that we'd expect a storage increment size of
>> 256 MiB under z/VM back then. As we didn't support memory blocks spanning
>> multiple memory sections, we would have had to handle having multiple
>> memory blocks for a single storage increment, which complicates things.
>> Although that issue reappeared with even bigger storage increment sizes
>> later, nowadays we have memory blocks that can span multiple memory
>> sections and we avoid any such issue completely.
> 
> I doubt that z/VM had support for memory hotplug back then already; and the
> sclp memory hotplug code was always written in a way that it could handle
> increment sizes smaller, larger or equal to section sizes.
 > > If I remember correctly the section size was also be used to 
represent each
> piece of memory in sysfs (aka memory block). So the different sizes were
> chosen to avoid an excessive number of sysfs entries on 64 bit.
 > > This problem went away later with the introduction of 
memory_block_size.
> 
> Even further back in time I think there were static arrays which had
> 2^(MAX_PHYSMEM_BITS - SECTION_SIZE_BITS) elements.

Interesting. I'll drop the "Likely ..." paragraph then!

> 
> I just gave it a try and, as nowadays expected, bloat-o-meter doesn't
> indicate anything like that anymore.
> 
>> 128 MiB has been used by x86-64 since the very beginning. arm64 with 4k
>> base pages switched to 128 MiB as well: it's just big enough on these
>> architectures to allows for using a huge page (2 MiB) in the vmemmap in
>> sane setups with sizeof(struct page) == 64 bytes and a huge page mapping
>> in the direct mapping, while still allowing for small hot(un)plug
>> granularity.
>>
>> For s390, we could even switch to a 64 MiB section size, as our huge page
>> size is 1 MiB: but the smaller the section size, the more sections we'll
>> have to manage especially on bigger machines. Making it consistent with
>> x86-64 and arm64 feels like te right thing for now.
> 
> That's fine with me.
> 
> Acked-by: Heiko Carstens <hca@linux.ibm.com>
> 

Thanks!

-- 
Cheers,

David / dhildenb


