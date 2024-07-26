Return-Path: <kvm+bounces-22299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A5C3A93CEBB
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 09:20:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C76B91C211FC
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 07:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E76A015666F;
	Fri, 26 Jul 2024 07:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TYHnsqHS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EF7225D7
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 07:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721978421; cv=none; b=OIk1Vz1hZEScrafILdYBsLuH9rqeiuZ8I3Kn4VCPR6Tv87xCyEfIWx93fYbW01W+nA17mW2iWp+jEE63GXSvDikbf70CG4nTwwFEQ/GhdHFjUSb7Js0kdTm6JLkselq3L/lcn6zjVzkAfO295tsC4PpI9FbDadC2UAoHXVp4pCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721978421; c=relaxed/simple;
	bh=BhIZBT4P5S+4MKtCGHB3bCve65Z6YMbQqgytvtkTRkY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TjADlOhDsGyvvkbmIMfWsFhCIWjWbIt/Sm1Jrt6moyoUtNpcNUqjpfKfbc8izCzam1d3KTZZUnWju8j5kwyqo9l+Phlz+z5Dy0LbQ7toYLPZk8dWT2jzz0t/cD9HiW7lLbEYhFfTfPh2I3s1mF01d8w3TdnW5QZhvDnP3TAdMWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TYHnsqHS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721978417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BEIEOLAuEweMadinLOrLjd7LgBw95vSxsGBKlxcpCXk=;
	b=TYHnsqHS2X+QVGPSDNT0LFjuTXBaVrwWvm0SxVufgUiug1LNgsJ5FVyE+koEIz35sjHiut
	mmXpc8TupRPXLouLKWorzSd9gQp8WRGpIdMW1mHeKqtOnFEzQvqLeLw8AxQil5UGZHUNt1
	ULVTXohvQ4JXFQssPZVSlxRFnvqYs5w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-318-lrioCRA1PMGiG_Xiom045Q-1; Fri, 26 Jul 2024 03:20:13 -0400
X-MC-Unique: lrioCRA1PMGiG_Xiom045Q-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-36835f6ebdcso1343319f8f.1
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 00:20:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721978412; x=1722583212;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BEIEOLAuEweMadinLOrLjd7LgBw95vSxsGBKlxcpCXk=;
        b=INyJWBUHVJk+QEk4ZnvNiNBIWF4uQ1V83LkFHfnMJOxbfovK4w8rJrxNP8ugiHj1sc
         MD+Ef1ojN2yPccJFXgr9hGFD3+vT+WcCFb4IWgGAjyXBE0swmaKv0rJLa6oI50+nPkai
         jnXC5yLMaclMLpggmdzsZIeL7C3njf7n/oFu0KMtlL0cr533GKGSmcbQCm0/EhMGBATK
         CgHcWIRLeXn4YtrZCrigPN+F9k59ZuhswG0LN/6yAFBXGK3XlusADJt845wLpw/CNj62
         THZeRF3qvcpp7medQrD8pPOCoIKVvzDVbMzWbcKKoU+nb5KOHh0UWj0sLbAowM74yXjk
         2blg==
X-Forwarded-Encrypted: i=1; AJvYcCXcxXME09UYSqsmSTWDoZfOTnPnpKA1j6Ie0kI6eDinBl2oz3sCY4U9G0sMAH4DLAWU7t4eO3D8CZ+pG3w9yIFvOmeO
X-Gm-Message-State: AOJu0YxH7iRd2ST0u7cs8tNUpTl8HQ5pHUh+8aJXY2hK/mzWa8dcJm6Y
	+rZDkR5xEpUAoYUeu/XAAY1NzMCO/rd6H/gjKtUeZRETJBx7IkVN6hGXaF1J6wb1ahjaQcDIidH
	HzPRfiolB9a68WNaiyIy5AgDHrklPtlhJu5OI7U3YjfwHOxaieg==
X-Received: by 2002:a5d:6d0f:0:b0:369:f664:ff4a with SMTP id ffacd0b85a97d-36b3642184emr4189931f8f.38.1721978412514;
        Fri, 26 Jul 2024 00:20:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGjRyLoFUKzXtxlvPy7gyYGobBtIV7zlMmdMTnYDl0erg6xc0NZgcjmiV5FPdY5DvzhjMpjGA==
X-Received: by 2002:a5d:6d0f:0:b0:369:f664:ff4a with SMTP id ffacd0b85a97d-36b3642184emr4189904f8f.38.1721978412062;
        Fri, 26 Jul 2024 00:20:12 -0700 (PDT)
Received: from ?IPV6:2003:cb:c713:a600:7ca0:23b3:d48a:97c7? (p200300cbc713a6007ca023b3d48a97c7.dip0.t-ipconnect.de. [2003:cb:c713:a600:7ca0:23b3:d48a:97c7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b367d9393sm4186108f8f.26.2024.07.26.00.20.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jul 2024 00:20:11 -0700 (PDT)
Message-ID: <d87a5e47-3c48-4e20-b3de-e83c2ca44606@redhat.com>
Date: Fri, 26 Jul 2024 09:20:10 +0200
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
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <69091ee4-f1c9-43ce-8a2a-9bb370e8115f@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 26.07.24 08:20, Chenyi Qiang wrote:
> 
> 
> On 7/25/2024 10:04 PM, David Hildenbrand wrote:
>>> Open
>>> ====
>>> Implementing a RamDiscardManager to notify VFIO of page conversions
>>> causes changes in semantics: private memory is treated as discarded (or
>>> hot-removed) memory. This isn't aligned with the expectation of current
>>> RamDiscardManager users (e.g. VFIO or live migration) who really
>>> expect that discarded memory is hot-removed and thus can be skipped when
>>> the users are processing guest memory. Treating private memory as
>>> discarded won't work in future if VFIO or live migration needs to handle
>>> private memory. e.g. VFIO may need to map private memory to support
>>> Trusted IO and live migration for confidential VMs need to migrate
>>> private memory.
>>
>> "VFIO may need to map private memory to support Trusted IO"
>>
>> I've been told that the way we handle shared memory won't be the way
>> this is going to work with guest_memfd. KVM will coordinate directly
>> with VFIO or $whatever and update the IOMMU tables itself right in the
>> kernel; the pages are pinned/owned by guest_memfd, so that will just
>> work. So I don't consider that currently a concern. guest_memfd private
>> memory is not mapped into user page tables and as it currently seems it
>> never will be.
> 
> That's correct. AFAIK, some TEE IO solution like TDX Connect would let
> kernel coordinate and update private mapping in IOMMU tables. Here, It
> mentions that VFIO "may" need map private memory. I want to make this
> more generic to account for potential future TEE IO solutions that may
> require such functionality. :)

Careful to not over-enginner something that is not even real or 
close-to-be-real yet, though. :) Nobody really knows who that will look 
like, besides that we know for Intel that we won't need that.

> 
>>
>> Similarly: live migration. We cannot simply migrate that memory the
>> traditional way. We even have to track the dirty state differently.
>>
>> So IMHO, treating both memory as discarded == don't touch it the usual
>> way might actually be a feature not a bug ;)
> 
> Do you mean treating the private memory in both VFIO and live migration
> as discarded? That is what this patch series does. And as you mentioned,
> these RDM users cannot follow the traditional RDM way. Because of this,
> we also considered whether we should use RDM or a more generic mechanism
> like notifier_list below.

Yes, the shared memory is logically discarded. At the same time we 
*might* get private memory effectively populated. See my reply to Kevin 
that there might be ways of having shared vs. private populate/discard 
in the future, if required. Just some idea, though.

> 
>>
>>>
>>> There are two possible ways to mitigate the semantics changes.
>>> 1. Develop a new mechanism to notify the page conversions between
>>> private and shared. For example, utilize the notifier_list in QEMU. VFIO
>>> registers its own handler and gets notified upon page conversions. This
>>> is a clean approach which only touches the notifier workflow. A
>>> challenge is that for device hotplug, existing shared memory should be
>>> mapped in IOMMU. This will need additional changes.
>>>
>>> 2. Extend the existing RamDiscardManager interface to manage not only
>>> the discarded/populated status of guest memory but also the
>>> shared/private status. RamDiscardManager users like VFIO will be
>>> notified with one more argument indicating what change is happening and
>>> can take action accordingly. It also has challenges e.g. QEMU allows
>>> only one RamDiscardManager, how to support virtio-mem for confidential
>>> VMs would be a problem. And some APIs like .is_populated() exposed by
>>> RamDiscardManager are meaningless to shared/private memory. So they may
>>> need some adjustments.
>>
>> Think of all of that in terms of "shared memory is populated, private
>> memory is some inaccessible stuff that needs very special way and other
>> means for device assignment, live migration, etc.". Then it actually
>> quite makes sense to use of RamDiscardManager (AFAIKS :) ).
> 
> Yes, such notification mechanism is what we want. But for the users of
> RDM, it would require additional change accordingly. Current users just
> skip inaccessible stuff, but in private memory case, it can't be simply
> skipped. Maybe renaming RamDiscardManager to RamStateManager is more
> accurate then. :)

Current users must skip it, yes. How private memory would have to be 
handled, and who would handle it, is rather unclear.

Again, maybe we'd want separate RamDiscardManager for private and shared 
memory (after all, these are two separate memory backends).

Not sure that "RamStateManager" terminology would be reasonable in that 
approach.

> 
>>
>>>
>>> Testing
>>> =======
>>> This patch series is tested based on the internal TDX KVM/QEMU tree.
>>>
>>> To facilitate shared device assignment with the NIC, employ the legacy
>>> type1 VFIO with the QEMU command:
>>>
>>> qemu-system-x86_64 [...]
>>>       -device vfio-pci,host=XX:XX.X
>>>
>>> The parameter of dma_entry_limit needs to be adjusted. For example, a
>>> 16GB guest needs to adjust the parameter like
>>> vfio_iommu_type1.dma_entry_limit=4194304.
>>
>> But here you note the biggest real issue I see (not related to
>> RAMDiscardManager, but that we have to prepare for conversion of each
>> possible private page to shared and back): we need a single IOMMU
>> mapping for each 4 KiB page.
>>
>> Doesn't that mean that we limit shared memory to 4194304*4096 == 16 GiB.
>> Does it even scale then?
> 
> The entry limitation needs to be increased as the guest memory size
> increases. For this issue, are you concerned that having too many
> entries might bring some performance issue? Maybe we could introduce
> some PV mechanism to coordinate with guest to convert memory only in 2M
> granularity. This may help mitigate the problem.

I've had this talk with Intel, because the 4K granularity is a pain. I 
was told that ship has sailed ... and we have to cope with random 4K 
conversions :(

The many mappings will likely add both memory and runtime overheads in 
the kernel. But we only know once we measure.

Key point is that even 4194304 "only" allows for 16 GiB. Imagine 1 TiB 
of shared memory :/

> 
>>
>>
>> There is the alternative of having in-place private/shared conversion
>> when we also let guest_memfd manage some shared memory. It has plenty of
>> downsides, but for the problem at hand it would mean that we don't
>> discard on shared/private conversion.>
>> But whenever we want to convert memory shared->private we would
>> similarly have to from IOMMU page tables via VFIO. (the in-place
>> conversion will only be allowed if any additional references on a page
>> are gone -- when it is inaccessible by userspace/kernel).
> 
> I'm not clear about this in-place private/shared conversion. Can you
> elaborate a little bit? It seems this alternative changes private and
> shared management in current guest_memfd?

Yes, there have been discussions about that, also in the context of 
supporting huge pages while allowing for the guest to still convert 
individual 4K chunks ...

A summary is here [1]. Likely more things will be covered at Linux Plumbers.


[1] 
https://lore.kernel.org/kvm/20240712232937.2861788-1-ackerleytng@google.com/

-- 
Cheers,

David / dhildenb


