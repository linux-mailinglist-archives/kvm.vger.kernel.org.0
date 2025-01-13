Return-Path: <kvm+bounces-35284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DCAEA0B4DE
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 11:54:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DE5B167713
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 10:54:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E10522F16E;
	Mon, 13 Jan 2025 10:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LIt5VkaR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6C98F49
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 10:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736765671; cv=none; b=QOMswkAmaA2GM0tNw9YwiIveQUsDNxVmBYNq7V9sjL+N8KeMku4cJxZJUlecYGM6mOzybRdlzBL/NpJjdstK72TzWrg7z/zLgwnetpRLYh4lf1gWdt0sWpLyrIoHgYYs1weUVgfREo+J5xGiDaWu8G31ZYE9glp4WfbO66SVSQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736765671; c=relaxed/simple;
	bh=TOOrF38oqaBnJB/eez+HmHVopaxkPdbTGgDp/pU5RjQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eGfaDgD0ZUhh6XaIYWwLObKU5b3/3NDQhdrRPSeLgxU1u/fcUa6pwhdML5MhRC8VebbZZkODB/E2pvwzrxxriHgBaTiLe1RI6A9IlT4vgEYlSxWASEYZG5vOVvsb/tIyPsUAuvL08vU5RxlgL9J9RtQF0mdcPJN8PPK0ETd3mHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LIt5VkaR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736765668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9HQOfMOM95s+EYJU8hmkRhPiA1PBXDgzbMrXSQJD8gI=;
	b=LIt5VkaRS4Bhji3HJNr414NLizBbi+Z91JMM4wsvCSwxtAI2eEOzGC+vfL7PNWmaWuy1JX
	sLOADvAetS+ydR5XXl/0OoJfQfKdE9CN6HOWpByyVzr0Sa0nDBL9nLmGRVY1tI2SFt8Jzr
	sc5R9rwf337VG+LDbiTsu9NJlsftUu4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-QVTEde7wMemBbGhFKM0ylQ-1; Mon, 13 Jan 2025 05:54:26 -0500
X-MC-Unique: QVTEde7wMemBbGhFKM0ylQ-1
X-Mimecast-MFC-AGG-ID: QVTEde7wMemBbGhFKM0ylQ
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4362f893bfaso23210515e9.1
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 02:54:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736765665; x=1737370465;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9HQOfMOM95s+EYJU8hmkRhPiA1PBXDgzbMrXSQJD8gI=;
        b=KaPcjoaWLhz0/Q7nnHOhxw58nmRbNRh78VjnaxBSi0XURq3vA7E3wymwnjT4bvL8HH
         Rvx9+zYvVUfds6RTSJ2vPtsmXVeiT/cXvQ2f+Iy6F53h1GHQMLRNQaj54ZSthWO2Yi9h
         kAL4ommQMHHOJgiw/TlUr+mq7KpmNUk17xQa2BEeh/diYV8GaqaKKA9QwIY63glTWweR
         QhlBXVS/zIacXnb2myD84qdEIKgaqrRv7I+iJmuxEsgqGe+ojvUX/fKOICfSVkggCzJW
         k+tgdfG0Jj0aciNCyn8tY6YRXehWiWkdNJ+WWUAu3IIfSNLacUC4MetYNofwdYJyVPkx
         XE/g==
X-Forwarded-Encrypted: i=1; AJvYcCW0sMtMGfyOGvP4wx9ldFx7MZwdFNzwov6jonxYtw2M0e12ViGOuUl//B93BoK8KMtHz4g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwkX93fCGvCnM16JTHY3ePB+UMDCKYEc7wzkKQ3VnqrbI2cSMt
	N3r5+JdKIg6bMZlzkDKon+94uU019YCcVGFGq/oTjbjLLyVWr2ibq0jTgz9uqN9v0VIz8ElsVL9
	SeCuqhlUZwCQdobj/qRD4u67/tkYWmHBbi3Y16gh0TUm+k5glZw==
X-Gm-Gg: ASbGncufdeYidlttaeqeNXykvbMC7mpzt9bt/nq2tDjOCPAhEurcrFw4U8vNVSv0jmP
	/o9DgMMtQIfaGckbY7i8fCsKe817brM88beUrzDisNaFHOhIPTHJ3vWa3T4ugT83CbLKScTORiI
	AINvziK1XiNNuB/EN74J0V//vb9mJMwqM/hVtXv/plMNLSNEXMeqGcSJoprbacg37NUIsV0SYFo
	vlN322LOWaSkCdIndHh+vaejfZpifm0J5sU2632HNH0odkT7oJ+OpgSxXUdVWftHuHa2thiL+yS
	T/+jsJaoKZ/4nbY=
X-Received: by 2002:a05:600c:3584:b0:434:9dfe:20e6 with SMTP id 5b1f17b1804b1-436e26f47efmr114821915e9.23.1736765665679;
        Mon, 13 Jan 2025 02:54:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEyL+SmsZ0teQQ4tuEt73eTUidVAJRv36R6SY49pOR4C8+5lo76tUXh61eXsqtBs68kHDjhqw==
X-Received: by 2002:a05:600c:3584:b0:434:9dfe:20e6 with SMTP id 5b1f17b1804b1-436e26f47efmr114821745e9.23.1736765665332;
        Mon, 13 Jan 2025 02:54:25 -0800 (PST)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e9d8fb99sm141190115e9.3.2025.01.13.02.54.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2025 02:54:24 -0800 (PST)
Message-ID: <9dfde186-e3af-40e3-b79f-ad4c71a4b911@redhat.com>
Date: Mon, 13 Jan 2025 11:54:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
To: Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy
 <aik@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08.01.25 11:56, Chenyi Qiang wrote:
> 
> 
> On 1/8/2025 12:48 PM, Alexey Kardashevskiy wrote:
>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>> uncoordinated discard") highlighted, some subsystems like VFIO might
>>> disable ram block discard. However, guest_memfd relies on the discard
>>> operation to perform page conversion between private and shared memory.
>>> This can lead to stale IOMMU mapping issue when assigning a hardware
>>> device to a confidential VM via shared memory (unprotected memory
>>> pages). Blocking shared page discard can solve this problem, but it
>>> could cause guests to consume twice the memory with VFIO, which is not
>>> acceptable in some cases. An alternative solution is to convey other
>>> systems like VFIO to refresh its outdated IOMMU mappings.
>>>
>>> RamDiscardManager is an existing concept (used by virtio-mem) to adjust
>>> VFIO mappings in relation to VM page assignment. Effectively page
>>> conversion is similar to hot-removing a page in one mode and adding it
>>> back in the other, so the similar work that needs to happen in response
>>> to virtio-mem changes needs to happen for page conversion events.
>>> Introduce the RamDiscardManager to guest_memfd to achieve it.
>>>
>>> However, guest_memfd is not an object so it cannot directly implement
>>> the RamDiscardManager interface.
>>>
>>> One solution is to implement the interface in HostMemoryBackend. Any
>>
>> This sounds about right.
>>
>>> guest_memfd-backed host memory backend can register itself in the target
>>> MemoryRegion. However, this solution doesn't cover the scenario where a
>>> guest_memfd MemoryRegion doesn't belong to the HostMemoryBackend, e.g.
>>> the virtual BIOS MemoryRegion.
>>
>> What is this virtual BIOS MemoryRegion exactly? What does it look like
>> in "info mtree -f"? Do we really want this memory to be DMAable?
> 
> virtual BIOS shows in a separate region:
> 
>   Root memory region: system
>    0000000000000000-000000007fffffff (prio 0, ram): pc.ram KVM
>    ...
>    00000000ffc00000-00000000ffffffff (prio 0, ram): pc.bios KVM
>    0000000100000000-000000017fffffff (prio 0, ram): pc.ram
> @0000000080000000 KVM
> 
> We also consider to implement the interface in HostMemoryBackend, but
> maybe implement with guest_memfd region is more general. We don't know
> if any DMAable memory would belong to HostMemoryBackend although at
> present it is.
> 
> If it is more appropriate to implement it with HostMemoryBackend, I can
> change to this way.

Not sure that's the right place. Isn't it the (cc) machine that controls 
the state?

It's not really the memory backend, that's just the memory provider.

-- 
Cheers,

David / dhildenb


