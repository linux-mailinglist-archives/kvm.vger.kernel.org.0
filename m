Return-Path: <kvm+bounces-35056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 551C8A09466
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 15:55:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 315483AD0B5
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 14:53:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54B1C211A02;
	Fri, 10 Jan 2025 14:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cr/aq+A5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F58211700
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 14:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736520619; cv=none; b=Ej9RCx82LtEINfg3GbLdi8ZAt369Jdbxo45FqsBkDQled41vlf49tRNmCCQ2oE/69cS3G5rXm3a8vHClARnltVL8R8m5hju4c4gUNFn3Slp7McdDkeVG0J4zCRpdGDFNSO56Z3yZfRpkQ2IUT069cK2JfoA+BrYG5Dla25EeWsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736520619; c=relaxed/simple;
	bh=/hfzYhWnWogzNsWnMoDegksCToyTxUcyRqj76XcxpUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UPZXmhFxrNfIOc85AcYsgol/CUOmGfruMpNATK3pGmzBUDPFoNrOQif3B9u1LaAiHu1IrgPMNyGpzF/4lTYeZqdWUFlUR9jlS1tfP13MmEFcTeZXb47hYnWgHR0rEVXE3UTAkAjpa/Wy1eCuaUsUYE0QRp/Yr+7dSz54BqL4hco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cr/aq+A5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736520615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=T+dn5zx8sybwL655A8cvbrkGYW0aEcEOgReGvTCY5E8=;
	b=Cr/aq+A5wgymcZul0G1zTJ2qzVFX+mprrRpSOD6QeEoPNVl9sOUStaUjuW11tm+mPdZSv1
	7/SnsfMwD3SGDyjN13Kze6OAapvDWULyv/qvsbZo0RNf9w3tiTvbIF9NXYW49YnmKTRpxa
	fGF4KBKGKX0vk/RbkN7rHxj276d4om4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-4cZtQNr5N9ycLLw1X0kw1g-1; Fri, 10 Jan 2025 09:50:14 -0500
X-MC-Unique: 4cZtQNr5N9ycLLw1X0kw1g-1
X-Mimecast-MFC-AGG-ID: 4cZtQNr5N9ycLLw1X0kw1g
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-385d80576abso1425854f8f.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 06:50:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736520613; x=1737125413;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=T+dn5zx8sybwL655A8cvbrkGYW0aEcEOgReGvTCY5E8=;
        b=FLZEz8nwJN3OSZVrle9rrwv/3yg6wl5/sRWup1519RFjSHPjwkL9x/yUQLePLsvM8d
         C7Nfxre+haGc7rnGupyYFNPZycH+7S9GbTXkT/b4Mb6wGIYsl86JMfzMFRR2/T1lPsm9
         N04oOA/7fuj0Ekm+IegE5Mao3n74wFofRED7/98mpT6tkai3WDDNbx4qofIOjCKGf9an
         0Jyqm325GgKHlPUGJt/gi/ZiLyGDALmexhJcP/QXe74aRuoMipjqitza8iHtbCFZWO/+
         AImF/1KT2Q5p1/6qvFF02ft0LfYJ2rSqxeSszotBkmXoQHjBeAsWBJStWNM6eS9WQ18o
         rmYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJm3pNMyseAw5sbG3v5TBbf+GQZX7idw4/dGpKETpJDF1rTomDZEW5QUrHE1HU6lUPvn4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJxDl6EfsKXb+MnuyRLI4iOGNzzfPob1clcTi3F6hpM1pGg2/7
	J4VuZoiGVrQwEm0dbIVDNPzTzy5LMfJgNqjfxonvBXnXttuowjQnuNZagJmu7/ydOtacus6gVMP
	INRQjrg+ghzZw9Fi2U/JO8GqAAbepnoFHV/sANjz1Um3mNyZzlg==
X-Gm-Gg: ASbGnctpfZa59EGUQT2e0eKgJkJnAEnm7k1Le4ZVT7ObpkVI5eh7Pc6vpxnK8g9SDfx
	sSDV9xENxDI1nxAL3eJI9uVyB7aEg66BLkStJ+5O36ofieQF6+KqxAnrEikHcc/wDcJ8kI6S0jG
	r5RCedSo8Ha5s17SPi5reuytxXu/Drgkr4bNVC9l2u/fblPjnDmMXlHwpF1Oa+Ge0NKRQ+9n57S
	J5qejZaSBNrQal2ozrV5zW5lXaa2cr4cnR+aSx8FLB1fwjKaNNKb0Ovy2QINMKl+TqPesAqT9vs
	iRFfgW9VQq344vYp4TatvrHR8U5aFVqR3W3oNytiL+VyQQKEwk6nd4zClMCD3s4BxrXx1809cAl
	mSNshs5Uu
X-Received: by 2002:a05:6000:1fa1:b0:385:f062:c2d4 with SMTP id ffacd0b85a97d-38a87338c01mr11081588f8f.37.1736520612782;
        Fri, 10 Jan 2025 06:50:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHEjPNOvQcqE6YNpKOq6FH9tky/TkiWm4L1aV74ulonKhdQxOSf+kNAwkQEOdXbJcU7YkiIyg==
X-Received: by 2002:a05:6000:1fa1:b0:385:f062:c2d4 with SMTP id ffacd0b85a97d-38a87338c01mr11081553f8f.37.1736520612415;
        Fri, 10 Jan 2025 06:50:12 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:e100:4f41:ff29:a59f:8c7a? (p200300cbc708e1004f41ff29a59f8c7a.dip0.t-ipconnect.de. [2003:cb:c708:e100:4f41:ff29:a59f:8c7a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e38bf78sm4665272f8f.48.2025.01.10.06.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 06:50:11 -0800 (PST)
Message-ID: <cce0bff5-51ca-42e9-98d7-b72ed23c9a1b@redhat.com>
Date: Fri, 10 Jan 2025 15:50:09 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Enable shared device assignment
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy
 <aik@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Michael Roth <michael.roth@amd.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <8457e035-40b0-4268-866e-baa737b6be27@intel.com>
 <6ac5ddea-42d8-40f2-beec-be490f6f289c@amd.com>
 <8f953ffc-6408-4546-a439-d11354b26665@intel.com>
 <d4b57eb8-03f1-40f3-bc7a-23b24294e3d7@amd.com>
 <57a3869d-f3d1-4125-aaa5-e529fb659421@intel.com>
 <008bfbf2-3ea4-4e6c-ad0d-91655cdfc4e8@amd.com>
 <1361f0b4-ddf8-4a83-ba21-b68321d921da@intel.com>
 <c318c89b-967d-456e-ade1-3a8cacb21bd7@redhat.com>
 <20250110132021.GE5556@nvidia.com>
 <17db435a-8eca-4132-8481-34a6b0e986cb@redhat.com>
 <20250110141401.GG5556@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250110141401.GG5556@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10.01.25 15:14, Jason Gunthorpe wrote:
> On Fri, Jan 10, 2025 at 02:45:39PM +0100, David Hildenbrand wrote:
>>
>> In your commit I read:
>>
>> "Implement the cut operation to be hitless, changes to the page table
>> during cutting must cause zero disruption to any ongoing DMA. This is the
>> expectation of the VFIO type 1 uAPI. Hitless requires HW support, it is
>> incompatible with HW requiring break-before-make."
>>
>> So I guess that would mean that, depending on HW support, one could avoid
>> disabling large pages to still allow for atomic cuts / partial unmaps that
>> don't affect concurrent DMA.
> 
> Yes. Most x86 server HW will do this, though ARM support is a bit newish.
> 
>> What would be your suggestion here to avoid the "map each 4k page
>> individually so we can unmap it individually" ? I didn't completely grasp
>> that, sorry.
> 
> Map in large ranges in the VMM, lets say 1G of shared memory as a
> single mapping (called an iommufd area)
> 
> When the guest makes a 2M chunk of it private you do a ioctl to
> iommufd to split the area into three, leaving the 2M chunk as a
> seperate area.
> 
> The new iommufd ioctl to split areas will go down into the iommu driver
> and atomically cut the 1G PTEs into smaller PTEs as necessary so that
> no PTE spans the edges of the 2M area.
> 
> Then userspace can unmap the 2M area and leave the remainder of the 1G
> area mapped.
> 
> All of this would be fully hitless to ongoing DMA.
> 
> The iommufs code is there to do this assuming the areas are mapped at
> 4k, what is missing is the iommu driver side to atomically resize
> large PTEs.
> 
>>  From "IIRC you can only trigger split using the VFIO type 1 legacy API. We
>> would need to formalize split as an IOMMUFD native ioctl.
>> Nobody should use this stuf through the legacy type 1 API!!!!"
>>
>> I assume you mean that we can only avoid the 4k map/unmap if we add proper
>> support to IOMMUFD native ioctl, and not try making it fly somehow with the
>> legacy type 1 API?
> 
> The thread was talking about the built-in support in iommufd to split
> mappings. That built-in support is only accessible through legacy APIs
> and should never be used in new qemu code. To use that built in
> support in new code we need to build new APIs. The advantage of the
> built-in support is qemu can map in large regions (which is more
> efficient) and the kernel will break it down to 4k for the iommu
> driver.
> 
> Mapping 4k at a time through the uAPI would be outrageously
> inefficient.

Got it, makes all sense, thanks!

-- 
Cheers,

David / dhildenb


