Return-Path: <kvm+bounces-19419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB122904CDA
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 09:28:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 633311F25372
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 07:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29DBE16C440;
	Wed, 12 Jun 2024 07:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cOG7zdUf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0136168C33
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 07:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718177317; cv=none; b=knCbvD6TyGDrqQHUySTiY46Z0aTmwlYZfjXhEhpH422S+hvt0scsJS8ngjvQtZO5Jr0m+nREws4/+jjb177+YmExvCmNIOwTyr05nzrnbDu1YEuMnKK+HpIpKMQjDG7Fvfx3d/3VK7cUEUPQo8cNwqo8Cd4wljcGOLhW1h7GASI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718177317; c=relaxed/simple;
	bh=elCf9kKn2ETE+UiRgFAAbp7wIr9yvy1SWWySaTDrTbU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uBgdyq+AhO4BKvEWux14rBMLfXjVBhNxHVR9k+JAMxCEn2hntWL/64yCHFLzJi/Mh1vJI7qz8rwiEx+BK8CxQJU8zsjwPG2jYyJykspetibNx+Ic6226r5BEGvQoWOguUuUdxhxSJc2Wz0BaWNTPDAnKbp/VH4vjSx23oWGGnnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cOG7zdUf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718177314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cQ2raOj2lYJDf1Kvgmr3Fk7V0QekFROmWcOO8IPa5ao=;
	b=cOG7zdUf6GW+n/DEP3Pbi9EdRB2ba6BYBlOH0/7H2H9ZSdHaiznVnPM9KMKZxG5KwjsmPK
	WZsQx1jlWelWxuoqyy7HTs3yu3Bex/Pf0XQbBEpA1SwECD6dMeIBjYRCYYFnX/7muVVrJV
	qVVT6fnTbubnT7I5ssPkVyQIw1HJS7A=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-0icTeqNdNvyR08J2tVG0YQ-1; Wed, 12 Jun 2024 03:28:32 -0400
X-MC-Unique: 0icTeqNdNvyR08J2tVG0YQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-52c8126f372so1513713e87.1
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 00:28:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718177311; x=1718782111;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cQ2raOj2lYJDf1Kvgmr3Fk7V0QekFROmWcOO8IPa5ao=;
        b=NKooMQ0ST3iYGlxvE1Quk/TapowSEIJu7ZKS4UtZoTTf6P/svu+46j+IxqFCezxHkM
         l7+1Cz/Cma/35WM0bfc8GqjZ/wHe3JVuKK/TsQBw/8E4HDFPSnBF0Nm0da3WFKcgtWmQ
         C9FKUluHhBoVaInM+vgQfU1f1CDB1YRRVwm/xsWez+yfofZ0g8kanEuLc2lPK2ztD4/Y
         x/+CR0saaaXI+0zojEoylR4yMBC6ivISVpmO7rn6pcAvJL3hXYAMbQxPWKh1/f+TqDzE
         j+r5mhQgbFIBpdnGK/LiRPhkYDwMgKzL5JglkZTpydKZt0XoNXuuQO1jPSUWXDTMnyZ9
         yR5w==
X-Forwarded-Encrypted: i=1; AJvYcCWrl1mwLHUlpMyJDEbRo3Y+EFb6EV5QgTqsEOgHFQ1AP274qApyxuvk8OXHJHNitqcNRVZ9aBz4pEPpEBTmW6lZfc9z
X-Gm-Message-State: AOJu0Yx6jJgZsxCvEkoHp/BogfgvSv7Hd5hXF/riZW57iqeVUUSzGgnz
	s2D7EAYepJ15ZhzllGoD2RaeBM+ilBlyJpe4eT/SESkiJgpP7YnCiYKR7wUS5GXAokp3VRmLrGQ
	ipBwB+ww58STk0qCODK47njaHOhei9wetBKpAuhVvN+moJttJ5g==
X-Received: by 2002:a05:6512:110e:b0:52c:9252:f822 with SMTP id 2adb3069b0e04-52c9a3fd6e8mr635243e87.53.1718177311229;
        Wed, 12 Jun 2024 00:28:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGI2onEb6+vPmlh3Kjp9S+ApeDjbEa7aftaSwNLLRcEo6PnojYxAp/bLpzCTrag3fgd5xyDCw==
X-Received: by 2002:a05:6512:110e:b0:52c:9252:f822 with SMTP id 2adb3069b0e04-52c9a3fd6e8mr635218e87.53.1718177310798;
        Wed, 12 Jun 2024 00:28:30 -0700 (PDT)
Received: from ?IPV6:2003:cb:c702:bf00:abf6:cc3a:24d6:fa55? (p200300cbc702bf00abf6cc3a24d6fa55.dip0.t-ipconnect.de. [2003:cb:c702:bf00:abf6:cc3a:24d6:fa55])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35f1a7c663asm10448312f8f.115.2024.06.12.00.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jun 2024 00:28:30 -0700 (PDT)
Message-ID: <dafe3a34-3223-48ab-a9ae-cd20436cbda5@redhat.com>
Date: Wed, 12 Jun 2024 09:28:29 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] s390/pci: Fix s390_mmio_read/write syscall page
 fault handling
To: Alex Williamson <alex.williamson@redhat.com>,
 Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Gerd Bayer <gbayer@linux.ibm.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Suren Baghdasaryan <surenb@google.com>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20240529-vfio_pci_mmap-v3-0-cd217d019218@linux.ibm.com>
 <20240529-vfio_pci_mmap-v3-1-cd217d019218@linux.ibm.com>
 <98de56b1ba37f51639b9a2c15a745e19a45961a0.camel@linux.ibm.com>
 <30ecb17b7a3414aeb605c51f003582c7f2cf6444.camel@linux.ibm.com>
 <db10735e74d5a89aed73ad3268e0be40394efc31.camel@linux.ibm.com>
 <ce7b9655-aaeb-4a13-a3ac-bd4a70bbd173@redhat.com>
 <32b515269a31e177779f4d2d4fe2c05660beccc4.camel@linux.ibm.com>
 <89c74380-6a60-4091-ba57-93c75d9a37d7@redhat.com>
 <b38b571b753441314c090c3eb51c49c0e28a19d5.camel@linux.ibm.com>
 <20240611162119.6bc04d61.alex.williamson@redhat.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240611162119.6bc04d61.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12.06.24 00:21, Alex Williamson wrote:
> On Tue, 11 Jun 2024 17:37:20 +0200
> Niklas Schnelle <schnelle@linux.ibm.com> wrote:
> 
>> On Tue, 2024-06-11 at 17:10 +0200, David Hildenbrand wrote:
>>>>>
>>>>> which checks mmap_assert_write_locked().
>>>>>
>>>>> Setting VMA flags would be racy with the mmap lock in read mode.
>>>>>
>>>>>
>>>>> remap_pfn_range() documents: "this is only safe if the mm semaphore is
>>>>> held when called." which doesn't spell out if it needs to be held in
>>>>> write mode (which I think it does) :)
>>>>
>>>> Logically this makes sense to me. At the same time it looks like
>>>> fixup_user_fault() expects the caller to only hold mmap_read_lock() as
>>>> I do here. In there it even retakes mmap_read_lock(). But then wouldn't
>>>> any fault handling by its nature need to hold the write lock?
>>>
>>> Well, if you're calling remap_pfn_range() right now the expectation is
>>> that we hold it in write mode. :)
>>>
>>> Staring at some random users, they all call it from mmap(), where you
>>> hold the mmap lock in write mode.
>>>
>>>
>>> I wonder why we are not seeing that splat with vfio all of the time?
>>>
>>> That mmap lock check was added "recently". In 1c71222e5f23 we started
>>> using vm_flags_set(). That (including the mmap_assert_write_locked())
>>> check was added via bc292ab00f6c almost 1.5 years ago.
>>>
>>> Maybe vfio is a bit special and was never really run with lockdep?
>>>    
>>>>    
>>>>>
>>>>>
>>>>> My best guess is: if you are using remap_pfn_range() from a fault
>>>>> handler (not during mmap time) you are doing something wrong, that's why
>>>>> you get that report.
>>>>
>>>> @Alex: I guess so far the vfio_pci_mmap_fault() handler is only ever
>>>> triggered by "normal"/"actual" page faults where this isn't a problem?
>>>> Or could it be a problem there too?
>>>>    
>>>
>>> I think we should see it there as well, unless I am missing something.
>>
>> Well good news for me, bad news for everyone else. I just reproduced
>> the same problem on my x86_64 workstation. I "ported over" (hacked it
>> until it compiles) an x86 version of my trivial vfio-pci user-space
>> test code that mmaps() the BAR 0 of an NVMe and MMIO reads the NVMe
>> version field at offset 8. On my x86_64 box this leads to the following
>> splat (still on v6.10-rc1).
> 
> There's already a fix for this queued[1] in my for-linus branch for
> v6.10.  The problem has indeed existed with lockdep for some time but
> only with the recent lockdep changes to generate a warning regardless
> of debug kernel settings has it gone from just sketchy to having a fire
> under it.  There's still an outstanding question of whether we
> can/should insert as many pfns as we can during the fault[2] to reduce
> the new overhead and hopefully at some point we'll have an even cleaner
> option to use huge_fault for pfnmaps, but currently
> vmf_insert_pfn_{pmd,pud} don't work with those pfnmaps.
> 
> So hopefully this problem disappears on current linux-next, but let me
> know if there's still an issue.  Thanks,

I see us now using vmf_insert_pfn(), which should be the right thing to 
do. So I suspect this problem should be disappearing.

-- 
Cheers,

David / dhildenb


