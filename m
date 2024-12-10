Return-Path: <kvm+bounces-33431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 718689EB578
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 16:57:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0DA9283433
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 15:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86A3822FE0A;
	Tue, 10 Dec 2024 15:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RvUcSeuk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF9322FDF6
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 15:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733846212; cv=none; b=q+TvHneiklQjhqVg8kfP7QRr2jaB5C8nVT/SHI/ZlJn9vB5L7sKGnoCZWKg8UiyrVuXS+iHFyXVMVzKU8gqU5/BSD2QvrrQ0V9/aDg15Pa8Beyk1IydSbD4k0vSqk0zWau+5jnjUC+ZdMrf9dw0ahIjpaQm9NcweoQFRPg20SkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733846212; c=relaxed/simple;
	bh=SzR+uX2G10Zb0oIitnBL937V9VC0oJl6Rj07zpVuMlQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n+7+oCUg4GldsfgmodQSxkhh8DjQjXxBTgAukcKBjrfF2Ok8tWiFbiTFSFrv1dHZiGnXGTouDJEb7PkVFSjSXG9EmsEnGwJ/3aw2KR3iuXDhVion8yd2ZApXgGjypQKtWqRqx4YiyD0pr8A7/AIyZ3EwTX+1qB/7eNUZCTQ/W7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RvUcSeuk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733846209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O6COf3Hkk0aQA9lsD0i2AqUa4d4P/34xWsXqJ5E4hUk=;
	b=RvUcSeukDNbR4QaxVrNt90me8idF7L8YglgPMpQQIBuPAZQ+74JKNc0LoJhdZ/1Ln2ie48
	npc6Ybt1rSmIY6UMTjVsdyecwbg2j/PGxcMAovM/VG+1fnQpEqnAHsjYYqm7VEThikUMgx
	qPtDzt2iMwZAXjsq4o6sxWjuq84M8PE=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-18q7k8--O6OUBe8z8XIePQ-1; Tue, 10 Dec 2024 10:56:48 -0500
X-MC-Unique: 18q7k8--O6OUBe8z8XIePQ-1
X-Mimecast-MFC-AGG-ID: 18q7k8--O6OUBe8z8XIePQ
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-844b916f499so104035039f.0
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 07:56:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733846208; x=1734451008;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O6COf3Hkk0aQA9lsD0i2AqUa4d4P/34xWsXqJ5E4hUk=;
        b=Sjv0oz+ylzszbtjDSTNftRyo6I/bX6HIPfWAzTi8pt6lkkyoljCCnLNbk7pTfbioXC
         qrQORVAtOda1gO3P8XTK3Mh7D1P9EXbRL2YoUVGt6h9Q2Jw2Pq+V5LJTpJfYiwZ7igYV
         t/5GlMauP2C+VkSXR+JTjUryA92BxIPek1UUTkgooM/2VxGD53FRl+IP7ATY38L/lSDA
         0iLz55KnOBmwgrtWghy3Ux3n6ZnwMjZ4DL3LOMqYV0nCAvcCbyESDU5Ifn0OI61ayOTh
         Wf6SqrWIk8wEnUGq/OedFIqhOLwDnMk7gDvhAm6JJog7bJ93U5sjKwKtfqE4qM7oPWju
         XgiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvzpadVGSddy2Gd/tnZFPf0KQgTdJnFgWdm+IFKcvc8sF3t8pdjKHgGn9kuzzPtBbADGo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8j2Sg6+Q4yI4YUTAHMSe7FLstsXNi9ocFOGRI/Q/MLGAVF4yw
	TwYLxZrA9QIN4gzDazGB62Qfj0bBhwrI6Q9YXiCYA2HQBHjmPtxzviRifwmboH9kRMtTIhoVs/F
	LZfCuhmrDhE4SVIFVqOQedLObbO5SYbLxSOeGkPqvfhRXw8pinA==
X-Gm-Gg: ASbGncu1KrSrGNr1IQnf646Aj20ZkkD6r43m8H3TRKAwySZ6HAXf0QKPFFoHBmuf+L0
	fTqH9yBIWqh9pU3egRbbD3GwfL8SRRBTam0Zp1pRrH1A5Kr1ZUaqJZSDxS+QySkV7pZSJW0B/Xh
	nFPWVwcJ0JFt8qTQUDgjuh23VZM08bklCcKX6EJtnCdDSs4p1PhdpBqzFhrGXw6xMdESmQqSDv2
	HTYK/cj+syiO3uwZkk6qBVksq81tTjLdGUcz2Z6c/H6sS14DghxuPQ=
X-Received: by 2002:a05:6602:a108:b0:83a:943d:a280 with SMTP id ca18e2360f4ac-844b87f7863mr300003039f.1.1733846208070;
        Tue, 10 Dec 2024 07:56:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGO/en2fuAvQyTs2jHHMl4LqDZEtajqMB/Su9iQAs0bW7stQDAwQKFTzGD6u5DQDQ+uVMvWSg==
X-Received: by 2002:a05:6602:a108:b0:83a:943d:a280 with SMTP id ca18e2360f4ac-844b87f7863mr299997739f.1.1733846207687;
        Tue, 10 Dec 2024 07:56:47 -0800 (PST)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e2bf67d125sm1155622173.96.2024.12.10.07.56.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2024 07:56:47 -0800 (PST)
Message-ID: <0723d890-1f90-463b-a814-9f7bb7e2200b@redhat.com>
Date: Tue, 10 Dec 2024 10:56:43 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/1] KVM: arm64: Map GPU memory with no struct pages
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, Will Deacon <will@kernel.org>
Cc: ankita@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 catalin.marinas@arm.com, ryan.roberts@arm.com, shahuang@redhat.com,
 lpieralisi@kernel.org, aniketa@nvidia.com, cjia@nvidia.com,
 kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
 acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
 danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com, udhoke@nvidia.com,
 dnigam@nvidia.com, alex.williamson@redhat.com, sebastianene@google.com,
 coltonlewis@google.com, kevin.tian@intel.com, yi.l.liu@intel.com,
 ardb@kernel.org, akpm@linux-foundation.org, gshan@redhat.com,
 linux-mm@kvack.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20241118131958.4609-1-ankita@nvidia.com>
 <20241210140739.GC15607@willie-the-truck>
 <20241210141806.GI2347147@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20241210141806.GI2347147@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/10/24 9:18 AM, Jason Gunthorpe wrote:
> On Tue, Dec 10, 2024 at 02:07:40PM +0000, Will Deacon wrote:
>> On Mon, Nov 18, 2024 at 01:19:57PM +0000, ankita@nvidia.com wrote:
>>> The changes are heavily influenced by the insightful discussions between
>>> Catalin Marinas and Jason Gunthorpe [1] on v1. Many thanks for their
>>> valuable suggestions.
>>>
>>> Link: https://lore.kernel.org/lkml/20230907181459.18145-2-ankita@nvidia.com [1]
>>
>> That's a different series, no? It got merged at v9:
> 
> I was confused by this too. v1 of that series included this patch, as
> that series went along it became focused only on enabling WC
> (Normal-NC) in a VM for device MMIO and this patch for device cachable
> memory was dropped off.
> 
> There are two related things:
>   1) Device MMIO memory should be able to be Normal-NC in a VM. Already
>      merged
>   2) Device Cachable memory (ie CXL and pre-CXL coherently attached
>      memory) should be Normal Cachable in a VM, even if it doesn't have
>      struct page/etc. (this patch)
> 
> IIRC this part was dropped off because of the MTE complexity that
> Catalin raised.
> 
> Jason
> 
Jason & Catalin: Thanks for the filler for the splitting.

So, I'm not sure I read what is needed to resolve this patch.
I read Will's reply to split it further and basically along what logical lines of functionality;
is there still an MTE complexity that has to be resolved/included in the series?

IOW, I'm looking for a complete, clear (set of) statement(s) that Ankit can implement to get this (requested) series moving forward, sooner than later;
it's already been a year+ to get to this point, and I don't want further ambiguity/uncertainty to drag it out more than needed.

Thanks... Don


