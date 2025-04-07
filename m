Return-Path: <kvm+bounces-42821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2825A7D859
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 10:45:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFD07172D90
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 08:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 632E82288CB;
	Mon,  7 Apr 2025 08:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="co7wAbKk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12F92288C6
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 08:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744015470; cv=none; b=RohZFXpMQtNaoLlUBFD/dBqa0IRaYJMCbXmKvIcNSGnQXRHzfVlUVMlg7+xOBYwN9T4Hqpoy57sNS/plMFKwE7kdunJVaALzEdylne6u+9C3hDPDg97oHqIZNqTiZDGjipJirimZGBmdUq4V8vA4r5Ya6fRm+m5bvYEWpAwledw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744015470; c=relaxed/simple;
	bh=DxdHvUIBKZwcIHQV7v/k0aiM/Xh6lmFeOTIoWQLdY7c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ey4UrIiFNd9gYSxabJRY4zA/TDlanefU2vZofkDCAAkEKTUjvLTSgTqS3GvVOTu1hJIjB7Ry5XCuw5EtGM+SHHYIhzU59kxviR2fF8XJGNB51uSFH1QflF1d3Mhv1biF0b5cTvVADYQPc3Aqt4kMyF+8v7PR7pNOm4wHVM1cHWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=co7wAbKk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744015467;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/3QxZPk/vuIOLK1nwxbDV+/Kivs7gJb/xl0dNU7nvmc=;
	b=co7wAbKkPW3Fg0+c+s65UarTkXfK1phvwkwg4d/evrfTQbbQkeO9Qc+jAPQD6z5n6ioCMm
	BDgsKgelL20QwvQSerhktToDaKDrt1IB+Dv/G9hW6/hO8bw24OaZEyfl5Ftxu9umKJs17u
	i1bqlhhGOlU3yIQ7/9D/U+zs+qURBAw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-362-KjuSRSEQOn-xe0Yg45ZZoA-1; Mon, 07 Apr 2025 04:44:26 -0400
X-MC-Unique: KjuSRSEQOn-xe0Yg45ZZoA-1
X-Mimecast-MFC-AGG-ID: KjuSRSEQOn-xe0Yg45ZZoA_1744015465
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-39c184b20a2so2118243f8f.1
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 01:44:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744015465; x=1744620265;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/3QxZPk/vuIOLK1nwxbDV+/Kivs7gJb/xl0dNU7nvmc=;
        b=dvts6RShMqwzVH+NxEvkcaZk1gz2WI7Nie8qGB+Sg9nl8dcVmo8uwWLstspImNidak
         L4czrYeMHkpPnytTjPr6MuUq9RcRIeBPUSs/NfRYYG04cwi2XRuqNdAueOzc/K3DUbkU
         V8I9b7LZ2nOb6i1BRrywcVwRAZtyUvjxVdJiNTsR6OR62GCHcGrSXG7nqOYSkQ5Mgpvi
         ztvY68gZK4CvKrtPsPe0PAWWd6oJDOWa7eAvjBlDKCTRanCsfxjPyHOFk0tWbs8J+std
         BDfZ3DDwxN/sZGAwk2XKV4KYPygCGOFt0zZ1uHZ3ejgBStpprR/c97G/HzfcUa0L5hIX
         kQ8g==
X-Forwarded-Encrypted: i=1; AJvYcCXzyoN2r1F4gBHkABQwTiS5RnmDH0Wbfcf7TV5PlwEbJMNQnhNVFjl10tIJlEmQqIWIQtw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYI1zBNY1lwHdYginXbh+JzSYGTGCjlhYY+bUaeeXg1NsQla2e
	ubiEckmKCPGvmB/Qs7aAjAx4bF5/wXjlb8Bht0gEiTTERWY//9gzxUQchuOFQ9slRKDB/VrMbEg
	+C08yMs1zH4Pck+Kf2dkSMlk0D8NdPRjENzyjynYaBSyM+tA5rQ==
X-Gm-Gg: ASbGnctWytw3wc/fTrjqkLcD4ObRSbI930L41KvQQgQy+5F2R/wvk6GeVBNOUxQikql
	Mz82lyIsrxg57ivZ345zxD9gHfN/8GULmlz72zqZRcgwOL3yiE8BaDG5mjIQKbGIfpu/CjHLdQY
	l5FSXfhyrhhTVr4fxhvLQ8IxKsIwTDuG/T1tAvLdBBQk+7ucohzEW6gJr/06T/Q9XBLDLC5xgy8
	8R7jzwDYHbtCXG8Zf+D3mB5ZzYpAPNokYH1eoNg5DN7oiKBRpJiQYV1NLPFYYp/tu2i3Jk2WRH+
	GTPy11eGhb5YrV0qKvvqItQAp4evI8FzqTvDWaNaTR5MAZa5pHX1kAE9O0WkpxeyL1u+cHYz6MF
	Bg71qN23H+z8WtRnwv7NYPVvMJFYQoJMWz0hcx+9U5Dc=
X-Received: by 2002:a5d:5f52:0:b0:39c:1424:2827 with SMTP id ffacd0b85a97d-39cb3594e72mr9659942f8f.15.1744015464881;
        Mon, 07 Apr 2025 01:44:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFCWFQYkJcJEVnQ3LjoD4a7PX8sINteAC+F9y4nrTkd0ydEosOtYznrvIYSEyyJ1+xQ11Nchw==
X-Received: by 2002:a5d:5f52:0:b0:39c:1424:2827 with SMTP id ffacd0b85a97d-39cb3594e72mr9659921f8f.15.1744015464527;
        Mon, 07 Apr 2025 01:44:24 -0700 (PDT)
Received: from ?IPV6:2003:cb:c738:3c00:8b01:4fd9:b833:e1e9? (p200300cbc7383c008b014fd9b833e1e9.dip0.t-ipconnect.de. [2003:cb:c738:3c00:8b01:4fd9:b833:e1e9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec36699e0sm122875385e9.35.2025.04.07.01.44.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Apr 2025 01:44:24 -0700 (PDT)
Message-ID: <0c221abf-de20-4ce3-917d-0375c1ec9140@redhat.com>
Date: Mon, 7 Apr 2025 10:44:21 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Halil Pasic <pasic@linux.ibm.com>, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org, Chandra Merla <cmerla@redhat.com>,
 Stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Eric Farman <farman@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Wei Wang <wei.w.wang@intel.com>
References: <20250404063619.0fa60a41.pasic@linux.ibm.com>
 <4a33daa3-7415-411e-a491-07635e3cfdc4@redhat.com>
 <d54fbf56-b462-4eea-a86e-3a0defb6298b@redhat.com>
 <20250404153620.04d2df05.pasic@linux.ibm.com>
 <d6f5f854-1294-4afa-b02a-657713435435@redhat.com>
 <20250404160025.3ab56f60.pasic@linux.ibm.com>
 <6f548b8b-8c6e-4221-a5d5-8e7a9013f9c3@redhat.com>
 <20250404173910.6581706a.pasic@linux.ibm.com>
 <20250407034901-mutt-send-email-mst@kernel.org>
 <2b187710-329d-4d36-b2e7-158709ea60d6@redhat.com>
 <20250407042058-mutt-send-email-mst@kernel.org>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250407042058-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07.04.25 10:34, Michael S. Tsirkin wrote:
> On Mon, Apr 07, 2025 at 10:17:10AM +0200, David Hildenbrand wrote:
>> On 07.04.25 09:52, Michael S. Tsirkin wrote:
>>> On Fri, Apr 04, 2025 at 05:39:10PM +0200, Halil Pasic wrote:
>>>>>
>>>>> Not perfect, but AFAIKS, not horrible.
>>>>
>>>> It is like it is. QEMU does queue exist if the corresponding feature
>>>> is offered by the device, and that is what we have to live with.
>>>
>>> I don't think we can live with this properly though.
>>> It means a guest that does not know about some features
>>> does not know where to find things.
>>
>> Please describe a real scenario, I'm missing the point.
> 
> 
> OK so.
> 
> Device has VIRTIO_BALLOON_F_FREE_PAGE_HINT and VIRTIO_BALLOON_F_REPORTING
> Driver only knows about VIRTIO_BALLOON_F_REPORTING so
> it does not know what does VIRTIO_BALLOON_F_FREE_PAGE_HINT do.
> How does it know which vq to use for reporting?
> It will try to use the free page hint one.

"only knows" -- VIRTIO_BALLOON_F_FREE_PAGE_HINT was proposed + specified 
in the spec.

So I think this is not a very good example.

> 
> 
> 
>> Whoever adds new feat_X *must be aware* about all previous features,
>> otherwise we'd be reusing feature bits and everything falls to pieces.
> 
> 
> The knowledge is supposed be limited to which feature bit to use.

I think we also have to know which virtqueue bits can be used, right?

I mean, I agree that it's all nasty ...

>>>
>>> So now, I am inclined to add linux code to work with current qemu and
>>> with spec compliant one, and add qemu code to work with current linux
>>> and spec compliant one.
>>>
>>> Document the bug in the spec, maybe, in a non conformance section.
>>
>> I'm afraid this results in a lot of churn without really making things
>> better.
> 
>> IMHO, documenting things how they actually behave, and maybe moving towards
>> fixed queue indexes for new features is the low hanging fruit.
> 
> I worry about how to we ensure that?
> If old code is messed up people will just keep propagating that.
> I would like to fix old code so that new code is correct.
> 
>>
>> As raised, it's not just qemu+linux, it's *at least* also cloud-hypervisor.
>>
>> -- 
>> Cheers,
>>
>> David / dhildenb
> 
> There's a slippery slope here in that people will come to us
> with buggy devices and ask to change the spec.

I yet have to fully digest cross-vm: 
https://github.com/google/crosvm/blob/main/devices/src/virtio/balloon.rs

and how it would free-page-reporting work with upstream Linux ... :(

-- 
Cheers,

David / dhildenb


