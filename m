Return-Path: <kvm+bounces-42653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 59C5CA7BEE3
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 16:17:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46D923B8AAC
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 14:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 661171F30C3;
	Fri,  4 Apr 2025 14:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y6MyNDrW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18321D9A79
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 14:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743776242; cv=none; b=IXisT1TZ/+7NFQp4mFfF4DZXONRbDkGPjeRHVOFBz29Q3GTsExDZlr8xLaJCR3JocMJEuY/zcz2IhRLQ+HB3J6SjnboxclPF3NScyI6V7zhX2fgR7Ig4eFYtJN1zgbvEG+rIpPVbnAxcHKm3nUwN1XQYQKEW2jUlIl5L0JrjpD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743776242; c=relaxed/simple;
	bh=pqMUlZ5ggwaGqc7Jf8UoGV7UJviwGrcnxt8jFNJ+ChI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UgiVJ2rf9A6Rx7hatneo5SbWiEpz9kgy0HdvrVxp0N8CMP3bc0EskMWsnQyqnjVQPmOxvdaRNUBX8bqjpB1Ls5ShwPQ4PEZqhYR0Qf9vZmD/lBbpduqJ54oeJIilBFF8UBRY84zWC1u19JeSOcD3OrjHokUzySzFUWcY+jQQOII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y6MyNDrW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743776239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YYP97SFevEMrsDa/3M9lWyqV8pmUiVIrFbb/z/mL3Z0=;
	b=Y6MyNDrWcjD0ungjCvYYeChk0+IKe1Au1e2pPhL7Tc0FhQGo17A9CmxZ1/4oMDe1iMGx4R
	6Kfof66Xb1LItgZSFMf/DBbD0F+cpPa4xC9zvAsvEXDSLVdSoLPOGAPxS9BkjffXIvbVbd
	uDvsmnuap4/j6M/XWH/0Gd1Tq5bQFsE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-209-dQdPu4pSMOenX78UuvYKOQ-1; Fri, 04 Apr 2025 10:17:17 -0400
X-MC-Unique: dQdPu4pSMOenX78UuvYKOQ-1
X-Mimecast-MFC-AGG-ID: dQdPu4pSMOenX78UuvYKOQ_1743776236
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-39141ffa913so1078444f8f.2
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 07:17:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743776236; x=1744381036;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YYP97SFevEMrsDa/3M9lWyqV8pmUiVIrFbb/z/mL3Z0=;
        b=psaqsmn297RqB5jdvkRHM7Fs0ESlAyCUbntS2N3Hfv4+oT7bXs8q/Dc3B9Nr8+efwz
         QYWPR5HicpmmkIGVKzsRSwRlZZidbfkE4f2GQ4D7ECz7dm6Qc2FlHribiBmNJUilr6KS
         1WYb4S6Hp8jKbA/GIeQJ4y/EMgmZtNuNO+C2zjnvD+V7CpzwA+DCTfjopE/1CBbmqcIp
         nVW2C5F88tuXdJXBdLDfIXAl5cc7vw72xd62TwDh+NOTykGTC8K5NCBFYftSxX4uOmqL
         hT5BE5d+yTYxPnBdyiHW0ztmKbwuiL7inlhyqH6HKCUWlxROwPvw6VHLgXz+vcp2hKVD
         M03Q==
X-Forwarded-Encrypted: i=1; AJvYcCWP10uVPix2u2/BfC972EEzBZExMKXrLcYsHKGNvHazMZN09gssRYYfLfxAGydrlWyI/rY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy+6Jqg3q8kLqUhCFRWL/B26SrHAGB6s4A+cnCEzsieqiRkHLL
	Ke2KJ5WwFFt74CLArdCZo3dDHYQc5td37xrtaJ7MYvgbO704EjwJr/ZnJJY5ixQX6EtBmhFCi4l
	T+zhb0XD/w9RH2l/hn6NMf3bYJ0PvxNr7Ep7J36iZ3/hUr4ClXw==
X-Gm-Gg: ASbGncukrhSa56RScuRsuKX4cThS9F6DXFK1VTpvIJJ1tiicWJiJRWJtkSNB1gP4Wc9
	7+7c/Zfad5foNwQg8sskcvrDAEQQpGC88s8nelHb4ZZbYdoJyOpZRTvYwW378oqjVqlpCFXkvtx
	bU+5z8UwFFEk8c2nwyn+lSosRPvRudCpk+5jyHrNn96U9EgynU/VrJ3jL0SrgYj2FYVAFkJRgE0
	lxa8hdCP4oNLzZtuUL/7GBPyFv27xjBCdRwqhPktzZ1B6i1i5sC+VwgUTT3yfQ1iuxCqXJRkd8g
	+wJrYHNGZR5cxRhDPY857K1vNQK5jceHJg8clrFnj4fsZ/6yj2U+3tKeHnov4OTW8ikbRuR49xJ
	gceR5rDOsoeuZqMmArl62zDS+1UV+VP/JKlcJaya7ebk=
X-Received: by 2002:a5d:59ae:0:b0:39c:13fd:ec44 with SMTP id ffacd0b85a97d-39d07ad4dd0mr2783598f8f.5.1743776236353;
        Fri, 04 Apr 2025 07:17:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzB4oRagYa80h55DAQhWRP4vFklx96QovmW2r4XQ4xCAa+3beYUWgZNPww/EaMcaEReuN57A==
X-Received: by 2002:a5d:59ae:0:b0:39c:13fd:ec44 with SMTP id ffacd0b85a97d-39d07ad4dd0mr2783533f8f.5.1743776235896;
        Fri, 04 Apr 2025 07:17:15 -0700 (PDT)
Received: from ?IPV6:2003:cb:c71b:7900:8752:fae3:f9c9:a07e? (p200300cbc71b79008752fae3f9c9a07e.dip0.t-ipconnect.de. [2003:cb:c71b:7900:8752:fae3:f9c9:a07e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301a7225sm4454629f8f.26.2025.04.04.07.17.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 07:17:15 -0700 (PDT)
Message-ID: <6f548b8b-8c6e-4221-a5d5-8e7a9013f9c3@redhat.com>
Date: Fri, 4 Apr 2025 16:17:14 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
To: Halil Pasic <pasic@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 Chandra Merla <cmerla@redhat.com>, Stable@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Eric Farman <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Wei Wang <wei.w.wang@intel.com>
References: <20250402203621.940090-1-david@redhat.com>
 <20250403161836.7fe9fea5.pasic@linux.ibm.com>
 <e2936e2f-022c-44ee-bb04-f07045ee2114@redhat.com>
 <20250404063619.0fa60a41.pasic@linux.ibm.com>
 <4a33daa3-7415-411e-a491-07635e3cfdc4@redhat.com>
 <d54fbf56-b462-4eea-a86e-3a0defb6298b@redhat.com>
 <20250404153620.04d2df05.pasic@linux.ibm.com>
 <d6f5f854-1294-4afa-b02a-657713435435@redhat.com>
 <20250404160025.3ab56f60.pasic@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250404160025.3ab56f60.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.04.25 16:00, Halil Pasic wrote:
> On Fri, 4 Apr 2025 15:48:49 +0200
> David Hildenbrand <david@redhat.com> wrote:
> 
>>> Sounds good to me! But I'm still a little confused by the "holes".
>>> What confuses me is that i can think of at least 2 distinct types of
>>> "holes": 1) Holes that can be filled later. The queue conceptually
>>> exists, but there is no need to back it with any resources for now
>>> because it is dormant (it can be seen a hole in comparison to queues
>>> that need to materialize -- vring, notifiers, ...)
>>> 2) Holes that can not be filled without resetting the device: i.e. if
>>>      certain features are not negotiated, then a queue X does not
>>> exist, but subsequent queues retain their index.
>>
>> I think it is not about "negotiated", that might be the wrong
>> terminology.
>>
>> E.g., in QEMU virtio_balloon_device_realize() we define the virtqueues
>> (virtio_add_queue()) if virtio_has_feature(s->host_features).
>>
>> That is, it's independent of a feature negotiation (IIUC), it's static
>> for the device --  "host_features"
>>
>>
>> Is that really "negotiated" or is it "the device offers the feature X"
>> ?
> 
> It is offered. And this is precisely why I'm so keen on having a precise
> wording here.

Yes, me too. The current phrasing in the spec is not clear.

Linux similarly checks 
virtio_has_feature()->virtio_check_driver_offered_feature().

> 
> Usually for compatibility one needs negotiated. Because the feature
> negotiation is mostly about compatibility. I.e. the driver should be
> able to say, hey I don't know about that feature, and get compatible
> behavior. If for example VIRTIO_BALLOON_F_FREE_PAGE_HINT and
> VIRTIO_BALLOON_F_PAGE_REPORTING are both offered but only
> VIRTIO_BALLOON_F_PAGE_REPORTING is negotiated. That would make reporting_vq
> jump to +1 compared to the case where VIRTIO_BALLOON_F_FREE_PAGE_HINT is
> not offered. Which is IMHO no good, because for the features that the
> driver is going to reject in most of the cases it should not matter if
> it was offered or not.

Yes. The key part is that we may only add new features to the tail of 
our feature list; maybe we should document that as well.

I agree that a driver that implements VIRTIO_BALLOON_F_PAGE_REPORTING 
*must* be aware that VIRTIO_BALLOON_F_FREE_PAGE_HINT exists. So queue 
existence is not about feature negotiation but about features being 
offered from the device.

... which is a bit the same behavior as with fixed-assigned numbers a 
bit. VIRTIO_BALLOON_F_PAGE_REPORTING was documented as "4" because 
VIRTIO_BALLOON_F_FREE_PAGE_HINT was documented to be "3" -- IOW, it 
already existed in the spec.

Not perfect, but AFAIKS, not horrible.

(as Linux supports all these features, it's easy. A driver that only 
supports some features has to calculate the queue index manually based 
on the offered features)

> 
> @MST: Please correct me if I'm wrong!
> 
> Regards,
> Halil
> 


-- 
Cheers,

David / dhildenb


