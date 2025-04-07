Return-Path: <kvm+bounces-42819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 35528A7D827
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 10:39:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAC32188AA43
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 08:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 622E3228CB2;
	Mon,  7 Apr 2025 08:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SlvTlLAM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491182628D
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 08:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744015147; cv=none; b=S0ezEFZxfkHBPMItesdGm///0gnP/6sZ8jzsZqKpvWvyp4zBFxZFoAGkzhgZScsY/QhxjJa3voofzLDL3Vz4vL8vqrAxSPwFudRaYxO6z8uSYuEyzNG/IXwkthedbCFKzfRvBa8elR6rZC7KIiqeDiy4uM7mj0lE4RnagYbgFE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744015147; c=relaxed/simple;
	bh=U5KjBvkq4/3tVKd0/iYeGM/mNQDmD9NXGDqllVvohgY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Dg0PFeyKe/Z34AXgUKZgDUoFqs2amXYD4NGBTgO9NQ9qIdpQcqOp777K8v1f9kjKFUXmAnobSVo3JEo3UcxYc8PP3h7MNer45UjPRdjcGdXcaV4aUxXAayLWqCivNvDliF7cxX7+BIVpFHmxYfDy7ASzQ5lYx/RoZu7kwUsb3uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SlvTlLAM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744015144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+TOiwua7UQJIPnWKqkkNj82HisezD/RCkc94FBk9/F8=;
	b=SlvTlLAMeXxiJ3koPvUHP7y+MKur62erwtAD4evCDA+WfhfV2Jn1Uw9/X8g4SZR6u/dog4
	xg/jQIoNf/4ucYv/vSFdrq8dZIsJ4BW0Yxeu7zcLuWw6Gk5Uw35GiVcoKhP3ZH/6VMrN2E
	Bqt/0RC0UuEllkX95VUaPRuKyBa0jtk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-vsYKZeUjMdykNl-gZqeoFA-1; Mon, 07 Apr 2025 04:39:02 -0400
X-MC-Unique: vsYKZeUjMdykNl-gZqeoFA-1
X-Mimecast-MFC-AGG-ID: vsYKZeUjMdykNl-gZqeoFA_1744015142
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43ced8c2eb7so31484815e9.1
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 01:39:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744015142; x=1744619942;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+TOiwua7UQJIPnWKqkkNj82HisezD/RCkc94FBk9/F8=;
        b=IHi9+eyev6fKqRo97Y+GHR2I2mCPf5b5NnqnRPO5fuTGaPPRKOauW9pmMjh9WGArwL
         jiQ7mbKrVwV00rS2SNCLUkaZ6Qe0LwifoBnC1V7VOz4pzmf8ahh/7+E1aAKHriM2NmU6
         gEsHFhM2kKzNqYtPtP//T47WWwriZ7s2PhTHKQVn2uaSVzLFrqB3CymCKQ/cOU8I370z
         Lzm06+eIgAObl1gd3FCY7hGJJv/OI/HnJMNGILfS6ZQ7+cXURiLcZukMTFheDwVY5wTl
         4HWdwSyZ94ZuTgsQoSIRKFVssS8OK/Bt1ETdZYTrO+qjv2jBBfv/+TatLtfk95HF975K
         sIyw==
X-Forwarded-Encrypted: i=1; AJvYcCUQe+QHj2MCx9lJ+1vUKN/BmehfT97h/x1BhvDYkKmEADtxBAaAphs/4KyzxN2j8EgWJn8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxriO4Y5Zvwm6BVBbEjyZ2/iscPEE/0qFkocZYaAeTqM/GF2UK/
	S8Q7f31vTGh9l1YwYUEx33O6mhzaI2eAt238XZuH5h1T63v1qkyYnJCzNdmS65XnAmkyIM7EGTB
	HU/qTZu7aeysUErPxTXRHrQYQW4B2Vs2J5lb966c7EwNaePEr3A==
X-Gm-Gg: ASbGncvFudVs0Qa7Y+zJcZNXr+WsKxtShR3lpShq/ux/f7mZpvZhQZidPz/Atg9YagD
	L4wh3dTgGGLoY4cCJqBtTrVUoysNljmHak02sOkY59f1CTqQI2vL2hEDEX68zLD8uQ7DaxiA3Ui
	H+J/t1A2GSVKZvvMVZ1i3XVxf9zHnrWfHzA+W2FVAGCdj5AW3cxNukEd6gu+KyWyerw+Z2vDXky
	DaGQkxOKF/80FmzNxdygsyS1CqQVyKQkv5pijVcdtBsmo43+9kolAuA0BapwpQovzdGazgrwX1d
	CkrhF2dnglaQ9uXioxXsumyZFFEl6jHtAHW5Z5M6D1lmlHcUyJRKPK1CWbiXpNoMGKo8AxJvhNL
	dgTgnBumnLfjc6G2wJEukabrxhHLOtHH3Y2Lqtob/m+w=
X-Received: by 2002:a7b:cb42:0:b0:43d:fa59:bcee with SMTP id 5b1f17b1804b1-43edf4581d1mr44715975e9.33.1744015141701;
        Mon, 07 Apr 2025 01:39:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHfkDDNd7OCaTotlhMoH9knuNRiDAiFILvyRWxHSuc8wY665v0zzr5kmFLDO5xrBHPd4SsSVw==
X-Received: by 2002:a7b:cb42:0:b0:43d:fa59:bcee with SMTP id 5b1f17b1804b1-43edf4581d1mr44715665e9.33.1744015141269;
        Mon, 07 Apr 2025 01:39:01 -0700 (PDT)
Received: from ?IPV6:2003:cb:c738:3c00:8b01:4fd9:b833:e1e9? (p200300cbc7383c008b014fd9b833e1e9.dip0.t-ipconnect.de. [2003:cb:c738:3c00:8b01:4fd9:b833:e1e9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec34a75fcsm121245265e9.11.2025.04.07.01.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Apr 2025 01:39:00 -0700 (PDT)
Message-ID: <39a67ca9-966b-40c1-b080-95d8e2cde376@redhat.com>
Date: Mon, 7 Apr 2025 10:38:59 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
From: David Hildenbrand <david@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Halil Pasic <pasic@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 Chandra Merla <cmerla@redhat.com>, Stable@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Eric Farman <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Wei Wang <wei.w.wang@intel.com>
References: <20250403161836.7fe9fea5.pasic@linux.ibm.com>
 <e2936e2f-022c-44ee-bb04-f07045ee2114@redhat.com>
 <20250404063619.0fa60a41.pasic@linux.ibm.com>
 <4a33daa3-7415-411e-a491-07635e3cfdc4@redhat.com>
 <d54fbf56-b462-4eea-a86e-3a0defb6298b@redhat.com>
 <20250404153620.04d2df05.pasic@linux.ibm.com>
 <d6f5f854-1294-4afa-b02a-657713435435@redhat.com>
 <20250404160025.3ab56f60.pasic@linux.ibm.com>
 <6f548b8b-8c6e-4221-a5d5-8e7a9013f9c3@redhat.com>
 <20250404173910.6581706a.pasic@linux.ibm.com>
 <20250407034901-mutt-send-email-mst@kernel.org>
 <2b187710-329d-4d36-b2e7-158709ea60d6@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <2b187710-329d-4d36-b2e7-158709ea60d6@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07.04.25 10:17, David Hildenbrand wrote:
> On 07.04.25 09:52, Michael S. Tsirkin wrote:
>> On Fri, Apr 04, 2025 at 05:39:10PM +0200, Halil Pasic wrote:
>>>>
>>>> Not perfect, but AFAIKS, not horrible.
>>>
>>> It is like it is. QEMU does queue exist if the corresponding feature
>>> is offered by the device, and that is what we have to live with.
>>
>> I don't think we can live with this properly though.
>> It means a guest that does not know about some features
>> does not know where to find things.
> 
> Please describe a real scenario, I'm missing the point.
> 
> Whoever adds new feat_X *must be aware* about all previous features,
> otherwise we'd be reusing feature bits and everything falls to pieces.
> 
>>
>> So now, I am inclined to add linux code to work with current qemu and
>> with spec compliant one, and add qemu code to work with current linux
>> and spec compliant one.
>>
>> Document the bug in the spec, maybe, in a non conformance section.
> 
> I'm afraid this results in a lot of churn without really making things
> better.
> 
> IMHO, documenting things how they actually behave, and maybe moving
> towards fixed queue indexes for new features is the low hanging fruit.
> 
> As raised, it's not just qemu+linux, it's *at least* also cloud-hypervisor.

I'm digging for other virtio-balloon implementations.


virtio-win: 
https://github.com/virtio-win/kvm-guest-drivers-windows/blob/master/Balloon/sys/balloon.c

-> Does not support hinting/reporting -> no problem


libkrun: 
https://github.com/containers/libkrun/blob/main/src/devices/src/virtio/balloon/device.rs

-> Hard-codes queue indexes but always seems to offer all features
  -> Offers VIRTIO_BALLOON_F_FREE_PAGE_HINT and VIRTIO_BALLOON_F_STATS_VQ
     even though it doesn't seem to implement them (device-triggered, so
     nothing to do probably?)
  -> Actually seems to implements VIRTIO_BALLOON_F_REPORTING


crossvm: 
https://github.com/google/crosvm/blob/main/devices/src/virtio/balloon.rs

-> Hard-codes queue numbers; does *not* offer/implement
    VIRTIO_BALLOON_F_STATS_VQ but does offer VIRTIO_BALLOON_F_STATS_VQ
    and VIRTIO_BALLOON_F_DEFLATE_ON_OOM.

-> Implements something that is not in the virtio-spec

const VIRTIO_BALLOON_F_WS_REPORTING: u32 = 8; // Working Set Reporting 
virtqueues

and

const WS_DATA_VQ: usize = 5;
const WS_OP_VQ: usize = 6;


IIUC, Linux inside cross-vm might actually be problematic? They would 
disagree on the virtqueue for free-page-reporting


Maybe I am missing something, it's a mess ...

-- 
Cheers,

David / dhildenb


