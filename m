Return-Path: <kvm+bounces-34800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 274DFA0611E
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 17:09:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E9C1166A60
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 16:09:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD0171FECB3;
	Wed,  8 Jan 2025 16:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LbaS4z/1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2AA1FE455
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 16:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736352563; cv=none; b=PahMzHk2bINHK+rmB1j16sHYddIRKRnthcxMTqEnlOkkeaId3y2XKA5TmIWrFcUnxJFSum9ZJGygSOT1wRNUnu6rZVc35RofpxEb/i103dYw9gP/Y9YbyDy8Gpb8plKYL7r1xJ1cvJOwrlhps63tMsdO0MBwH5aw3On90cp4x/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736352563; c=relaxed/simple;
	bh=NuSrNlulfl9s9cmF0zPWRDVoyTAa1/r7CsPrXlyoVzo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tYrHcy4s8bsqAvo7pNcRaM/d+o42bSy5266bQeh41wqDQu79L0DDZuUxk2y9MPjRCOxUNE8TPI+JkVqp3n2ZUCzVi7RneRhSjcvreMXgIrtItCuGa3Wy7vrCMUcoxXq1gWuA/yhSgqUDQ+/0bGY/MsTnWltP4wQu1R/lWyesxmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LbaS4z/1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736352560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=s0rlDhIwvvVKAA/Z/ReGOUxjITf8M7mwn/BPJqxsGsg=;
	b=LbaS4z/1oB4jM4LDfy2IamOYEnD5JX8u2xwtaqLPGa+8d27t/4c8Z8SchjBVJl+n7inkS1
	ByVd9CwhKXJDB/taHQyA67eqm2om5Qr+GK8xGT8xlXVhlOpt0Dak0oWZJ8kZNriGeIeR+6
	mmqk7VNWNm4FAU6t7DpTwQjO8kgDiLA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-VgsczKF-MQGcHeuYuMDp6Q-1; Wed, 08 Jan 2025 11:09:19 -0500
X-MC-Unique: VgsczKF-MQGcHeuYuMDp6Q-1
X-Mimecast-MFC-AGG-ID: VgsczKF-MQGcHeuYuMDp6Q
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4359eb032c9so132011285e9.2
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 08:09:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736352558; x=1736957358;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s0rlDhIwvvVKAA/Z/ReGOUxjITf8M7mwn/BPJqxsGsg=;
        b=oJKRQNBod5GNqemrGl32otJz9wvh7Zsrm1kIQZghsJ2pjL6nWbirNGVTu5/6zvm2hS
         I5S55kCNk58be5aVCT+tzYwgT1rDhr5J3FHb+HfkgVkXZotqscx77M7Ctw+huO+qhriS
         K82yt7BrqJeZaeAAoJUezgNijPmGQiqvJQ9vrVJW8twgky7PKIQ3hRKdoxqbx/IR2VdS
         lLDJyDUt3yFnJ8W5F5O/9i8DZEImIQgHBsnKBAPQbTJV3Epodq8BCBdSqjtLSTCyT5g1
         OPPc8gWzyXyhuFMHIpWfbmN6cJdSsZ7/C4/s7/260CiCFzavI1PVcBTT43rc6fAn9rJY
         byKg==
X-Forwarded-Encrypted: i=1; AJvYcCXx97wHcd0hxCV1DBjasviTAbxFgw6B89FxfguVkL4maVnnViN2mucwzdHm1dgkaX6xV5M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVXRZ2j9aoyfaFc7DcB9wm6B50vMsKI7Uvanr0URAB1UKoYBoz
	TwpUR7+mUCWbfi4bQxvqUj+a5QNPCHVNpUHSSxdoBcmVqbsX41F8d3Kn47im+th2A2xguL/E76B
	UB2MKDpMLByxZQLf/6UVa5IGO8FiaZ/ttuVkorRjnDj1uK/qn4Q==
X-Gm-Gg: ASbGncslJvIIJjkZOtvk3iCh14hSSCTCg25lIdjGP+r3P/AHMAKwweV43XLQJaNpDum
	mdwv1GCWRYEV1/GKXa3BHMFixF2Xu0KOjVbKH26R7Tr5vXgOE/7r6hDxly3ZliAIhHzREJ4BqWf
	yg1jALwPIJjT/ytosVv0QkkpYMjkQQd8zlQa5iz23r+uB2yT9AyZo0dX/+YJC8MO705covlmLQO
	1olpkoGSZPiAkZlb0+UxFXrqisZWzxJSf/LVk5b43edBdYFiDvz0H74CNMUZt07zlSX/OGVxpxB
	P1+DfW27HpRuy4G1Gs3UmBM49SNiQHr4Y08yaWFR6yuKx57AFz6Y0hIsvpjYeks3GDRfqFuxtJC
	rS63mvw==
X-Received: by 2002:a05:600c:1d0c:b0:436:1bbe:f686 with SMTP id 5b1f17b1804b1-436e2707c59mr26526985e9.21.1736352557855;
        Wed, 08 Jan 2025 08:09:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHuW+kXE4dSP1dwStt7dtEmz7DMdPJOlNk4fca0pJWrMp44Izq0k2N2szKXrAfMK8IDoDv+jg==
X-Received: by 2002:a05:600c:1d0c:b0:436:1bbe:f686 with SMTP id 5b1f17b1804b1-436e2707c59mr26526505e9.21.1736352557412;
        Wed, 08 Jan 2025 08:09:17 -0800 (PST)
Received: from ?IPV6:2003:cb:c70d:3a00:d73c:6a8:ca9f:1df7? (p200300cbc70d3a00d73c06a8ca9f1df7.dip0.t-ipconnect.de. [2003:cb:c70d:3a00:d73c:6a8:ca9f:1df7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2df9f8bsm25473195e9.26.2025.01.08.08.09.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2025 08:09:16 -0800 (PST)
Message-ID: <f13622a2-6955-48d0-9793-fba6cea97a60@redhat.com>
Date: Wed, 8 Jan 2025 17:09:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: ankita@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
 shahuang@redhat.com, lpieralisi@kernel.org, aniketa@nvidia.com,
 cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
 vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
 jhubbard@nvidia.com, danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com,
 udhoke@nvidia.com, dnigam@nvidia.com, alex.williamson@redhat.com,
 sebastianene@google.com, coltonlewis@google.com, kevin.tian@intel.com,
 yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org,
 gshan@redhat.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20241118131958.4609-1-ankita@nvidia.com>
 <20241118131958.4609-2-ankita@nvidia.com>
 <a2d95399-62ad-46d3-9e48-6fa90fd2c2f3@redhat.com>
 <20250106165159.GJ5556@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250106165159.GJ5556@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 06.01.25 17:51, Jason Gunthorpe wrote:
> On Fri, Dec 20, 2024 at 04:42:35PM +0100, David Hildenbrand wrote:
>> On 18.11.24 14:19, ankita@nvidia.com wrote:
>>> From: Ankit Agrawal <ankita@nvidia.com>
>>>
>>> Currently KVM determines if a VMA is pointing at IO memory by checking
>>> pfn_is_map_memory(). However, the MM already gives us a way to tell what
>>> kind of memory it is by inspecting the VMA.
>>
>> Do you primarily care about VM_PFNMAP/VM_MIXEDMAP VMAs, or also other VMA
>> types?
> 
> I think this is exclusively about allowing cachable memory inside a
> VM_PFNMAP VMA (created by VFIO) remain cachable inside the guest VM.

Thanks!

> 
>>> This patch solves the problems where it is possible for the kernel to
>>> have VMAs pointing at cachable memory without causing
>>> pfn_is_map_memory() to be true, eg DAX memremap cases and CXL/pre-CXL
>>> devices. This memory is now properly marked as cachable in KVM.
>>
>> Does this only imply in worse performance, or does this also affect
>> correctness? I suspect performance is the problem, correct?
> 
> Correctness. Things like atomics don't work on non-cachable mappings.

Hah! This needs to be highlighted in the patch description. And maybe 
this even implies Fixes: etc?

> 
>> Maybe one could just reject such cases (if KVM PFN lookup code not
>> already rejects them, which might just be that case IIRC).
> 
> At least VFIO enforces SHARED or it won't create the VMA.
> 
> drivers/vfio/pci/vfio_pci_core.c:       if ((vma->vm_flags & VM_SHARED) == 0)

That makes a lot of sense for VFIO.

> 
> This is pretty normal/essential for drivers..
> 
> Are you suggesting the VMA flags should be inspected more?
> VM_SHARED/PFNMAP before allowing this?


I was wondering if we can safely assume that "device PFNs" can only 
exist in VM_PFNMAP mappings. Then we can avoid all that pfn_valid() / 
pfn_is_map_memory() stuff for "obviously not device" memory.

I tried to protoype, but have to give up for now; the code is too 
complicated to make quick progress :)

-- 
Cheers,

David / dhildenb


