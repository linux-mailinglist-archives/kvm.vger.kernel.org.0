Return-Path: <kvm+bounces-22758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1A79942D12
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 13:18:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E0C1B23722
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 11:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5770C1AC43C;
	Wed, 31 Jul 2024 11:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GVq3OWlA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64F41A4B34
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 11:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722424723; cv=none; b=liDLkQsfvZfnaS+gFnXC98vnefCEqZIXqzUK0Z/2DOYjLKLcaIs+o+2LzSzEFfIbUafQe8fZnLo5xZ2MyBjEqBu92wAy+tXxpwtOtKqM+gOeBpBvACKiGu7fG72JgeXfu4I+4vFwOU/yGhnALtHZHnaN4Ox7xJ+h4jaNktNFYgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722424723; c=relaxed/simple;
	bh=WLqihJ3i9xdEGXMP4iaHPQJkOOoVEPIqIvHLfnOfJII=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B46MEYy5pfwuiBqwdkgSe/7WxiseiWVBG/S1BOzXboceEgpLnjR1cvwheTfRzG2v+bG6qQ850u1NgiUwnyO6nYbW2Jx8UNw23i8BDLJnndm+jhDrVxiwp9NIy4bZlsGCYUimqJM9XhXplfCyZHjiE+pN5hLINxIEucOslGXXF3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GVq3OWlA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722424720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2ZAdrir/XPqbfvH9QDX+kfny3g50pUo5BZS7PsDKhr8=;
	b=GVq3OWlAsZMhcx7Q81bYJj53etPH5W20yEnL1YPUR6K5FuwJIfb2q4PSBQo0dzu6575WMd
	zzUHonuJ7BV7M0tP0nplDoNWWjUfVRZqjzPeHzT1e64LHpXVw7uqP6IiTEC0NI8SnmDnYp
	gQIFW4qPRSFB21EbVqonn1Bn9OTMlj0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-214-kDJ51CdoO6CINfC8x7oaHw-1; Wed, 31 Jul 2024 07:18:39 -0400
X-MC-Unique: kDJ51CdoO6CINfC8x7oaHw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a7535875ab7so105819466b.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 04:18:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722424718; x=1723029518;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2ZAdrir/XPqbfvH9QDX+kfny3g50pUo5BZS7PsDKhr8=;
        b=lHnoC+b27iR/T2KcV0nqV9TYor5RuT39YBJSz2HXrPPftmZe2lOEsnhzAUmWgIhSAY
         RRRtKfT3vQc2pY7T9MJSIfg9aOHZjHrSuqnQ725cxOGDYNQkunHKML+y47rC6mOk4Vdj
         fMvY9am45UQJixRlUgiCWlGgWRORlHuZ8xL+qGHq9zvrFSx/I6vvbNLzEUFsUvPYcw40
         Nd6wVnDz5A2ncWwXfd4SbWciOtdbtBLMthHe0sNuyNRIJyIryI0vOPmsL2Dgq/t8EMvg
         PmAfKrHEMqrOqv7tBj2+3pxMkF1KX33ReUI2cQlIDciocdrujKLXnSdMKLGlJK76eSs9
         xnlA==
X-Forwarded-Encrypted: i=1; AJvYcCUsSAGFhW9NQY0xjbDeRBzYeWi55n81JzJMXQZ+idee2vJPaDMrbRtdZWEAwYacbd53ow4AOlrwEV6qvfS4iM0Rm3dW
X-Gm-Message-State: AOJu0YzIvjx3u26J970aqE1gTJ8tjJHUSP1v/otcaXLCxt6weDmeg3wo
	vpx7pfRb89opWRYNrzTpj+M/oOyB2gLjhQu5WQf7K1tOjKY82qNO/0n9pjrJWFcNn5oZ5N/Jaoh
	TtdLl3Nt72OLd5yTgF1qxHbWaNlz6icedC3vQ9T61sp5lxgEjAg==
X-Received: by 2002:a17:907:7f13:b0:a6f:6337:1ad5 with SMTP id a640c23a62f3a-a7d85a4c772mr473550566b.27.1722424717758;
        Wed, 31 Jul 2024 04:18:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEtsbeRG2h5iQvMOcjjOiuOUIYF6sGKYeFbxW+JKxy4hY5/XZrj6Jyn1Ccfy7kOvO+24uK95A==
X-Received: by 2002:a17:907:7f13:b0:a6f:6337:1ad5 with SMTP id a640c23a62f3a-a7d85a4c772mr473547766b.27.1722424717174;
        Wed, 31 Jul 2024 04:18:37 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70b:5f00:9b61:28a2:eea1:fa49? (p200300cbc70b5f009b6128a2eea1fa49.dip0.t-ipconnect.de. [2003:cb:c70b:5f00:9b61:28a2:eea1:fa49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7acad41484sm756980766b.124.2024.07.31.04.18.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 04:18:36 -0700 (PDT)
Message-ID: <d299bbad-81bc-462e-91b5-a6d9c27ffe3a@redhat.com>
Date: Wed, 31 Jul 2024 13:18:35 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] Enable shared device assignment
To: Chenyi Qiang <chenyi.qiang@intel.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Edgecombe Rick P <rick.p.edgecombe@intel.com>,
 Wang Wei W <wei.w.wang@intel.com>, Peng Chao P <chao.p.peng@intel.com>,
 Gao Chao <chao.gao@intel.com>, Wu Hao <hao.wu@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20240725072118.358923-1-chenyi.qiang@intel.com>
 <ace9bb98-1415-460f-b8f5-e50607fbce20@redhat.com>
 <69091ee4-f1c9-43ce-8a2a-9bb370e8115f@intel.com>
 <d87a5e47-3c48-4e20-b3de-e83c2ca44606@redhat.com>
 <0fdd0340-8daa-45b8-9e1c-bafe6f4e6a60@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <0fdd0340-8daa-45b8-9e1c-bafe6f4e6a60@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Sorry for the late reply!

>> Current users must skip it, yes. How private memory would have to be
>> handled, and who would handle it, is rather unclear.
>>
>> Again, maybe we'd want separate RamDiscardManager for private and shared
>> memory (after all, these are two separate memory backends).
> 
> We also considered distinguishing the populate and discard operation for
> private and shared memory separately. As in method 2 above, we mentioned
> to add a new argument to indicate the memory attribute to operate on.
> They seem to have a similar idea.

Yes. Likely it's just some implementation detail. I think the following 
states would be possible:

* Discarded in shared + discarded in private (not populated)
* Discarded in shared + populated in private (private populated)
* Populated in shared + discarded in private (shared populated)

One could map these to states discarded/private/shared indeed.

[...]

>> I've had this talk with Intel, because the 4K granularity is a pain. I
>> was told that ship has sailed ... and we have to cope with random 4K
>> conversions :(
>>
>> The many mappings will likely add both memory and runtime overheads in
>> the kernel. But we only know once we measure.
> 
> In the normal case, the main runtime overhead comes from
> private<->shared flip in SWIOTLB, which defaults to 6% of memory with a
> maximum of 1Gbyte. I think this overhead is acceptable. In non-default
> case, e.g. dynamic allocated DMA buffer, the runtime overhead will
> increase. As for the memory overheads, It is indeed unavoidable.
> 
> Will these performance issues be a deal breaker for enabling shared
> device assignment in this way?

I see the most problematic part being the dma_entry_limit and all of 
these individual MAP/UNMAP calls on 4KiB granularity.

dma_entry_limit is "unsigned int", and defaults to U16_MAX. So the 
possible maximum should be 4294967296, and the default is 65535.

So we should be able to have a maximum of 16 TiB shared memory all in 
4KiB chunks.

sizeof(struct vfio_dma) is probably something like <= 96 bytes, implying 
a per-page overhead of ~2.4%, excluding the actual rbtree.

Tree lookup/modifications with that many nodes might also get a bit 
slower, but likely still tolerable as you note.

Deal breaker? Not sure. Rather "suboptimal" :) ... but maybe unavoidable 
for your use case?

-- 
Cheers,

David / dhildenb


