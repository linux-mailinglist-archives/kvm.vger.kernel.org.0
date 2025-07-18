Return-Path: <kvm+bounces-52933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D3D9B0ABB8
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 23:42:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 356787B4CE6
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 21:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4B262206AC;
	Fri, 18 Jul 2025 21:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eBaQ+e1p"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE676FB9
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 21:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752874920; cv=none; b=Jy+8XebCRsQkHVMC7d5r0g14/HsBxnD6ZGwSbyibsgMYfwz6dNS+IGo/PQCw6f8XfMEdbEV4YshLtb2F88WUBZ738bn4GEN773FQlt0qrZI1QFduTc//95T0i6sv1+/m31W8DISkLMwhAornZy37S+L7OSYd9RNeGr/1ctpQIVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752874920; c=relaxed/simple;
	bh=uxXpdkcHdOrQaJc+eu4/GeOXinhx7hO5tirp5wkNhw8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l/YCNEKww0qkCUqW9BGO8DjhPxTh25cT22xbG30tmO2i0mHOaY7BUv9zHqYo2M+OKwbA6fGmr7IhopHWnhCkW4Dhnf20VyYQYU3tSAPTOK53CipvRY37XrkaQCvRLdfuFnb6Qb92/NJCNG+gZxRx0kj6aZ7C0j3AWYC5fYY9gek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eBaQ+e1p; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752874916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pl8HYJY2kuf3xc5dYY1A2bTJiaSaxCFVikVVLsHu9SQ=;
	b=eBaQ+e1pI1K4HUjjQpLUxJvLhH5qDxeHaw4BIDUV/DKKxWoqXwAwO7utHYWLF/WVctT+x2
	zItsZu77WhIbVr3CV2fqBywkQMPOWTtVqM/+13EccBFFLp8VsJ6F8xoY9gR7nRGbx2usyG
	t2sba7M0tMiY2cUO4kx0FwxohfpfCjY=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-GKY57PCONXK0-nn5j43n5g-1; Fri, 18 Jul 2025 17:41:55 -0400
X-MC-Unique: GKY57PCONXK0-nn5j43n5g-1
X-Mimecast-MFC-AGG-ID: GKY57PCONXK0-nn5j43n5g_1752874914
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-235c897d378so22745495ad.1
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 14:41:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752874914; x=1753479714;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pl8HYJY2kuf3xc5dYY1A2bTJiaSaxCFVikVVLsHu9SQ=;
        b=lS3JTM3vOyH6uEX+1Zs2WJsD8ZDu4x0IFkXpLE5Rsk5PFYgx73VbnmiozxyzItPDlX
         xH+kKGa82Om2qEuE6n3SoFhx1AN1JyBn049eRZSY9FG/AlLiqZx7S8cmFagqRgIlsZ17
         J2XMBXml2diR/tLkg/7YbGlMeu7ZoaHOdfYU6ahmAkldk0k+yyoY5I7wXgq/t+sM/rsK
         9H47d0NDASxl9GPpOu3R5eGtDAnPiFIRNkqw9oc3dBHyWb8DYU6dRMa/nCgkuw5U07Qb
         IUrYQ8ZN27z2lwZF4UtP2uQZ5xULCS+on/FLYEV/a1w21a3OcmSi5rM7+p2p5M7zZFE5
         FVEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCUNPoly9SaJJ0K92SEb2vYG46C+MFYExQy/S/NOyM2k4Vk/YtytGMRbcwd/nshbnb9SU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz165O3pZ6xRXwO8CBo7PlWkRkxgHXTuL8XSYuNqgLgcfU837+M
	vIiSiIHaEybJE9zd+W1BcmmvJ6r2UucQaHP7LIqNz1LWxOKds4KcFdh2157kV1gGl+rx7Bos8vu
	EM1MbcUANVFNLzoA3ecZwR7tG5Pka778QJ6fuuX1iAQZKhnJkf0nyEA==
X-Gm-Gg: ASbGncv49v0ZS4n4rUMuN1VjT+9s3CZYuYGFJje05yNXezN9jbCRsJF6XbSvWipNfRA
	tqTTEXO2Yn5gsJ4NQjRn1D1OcW8gFjqjI1rlPq5BAmlUnZP/1OvWtgVjf97Bb+G2+p1pY5GKtEd
	HQtuTLLEgVLhwpr4UF7UKs8QyF1JyhK2tnW20znx3tRSJzwfHNUjYxnBoxt3G1Ws0DB1HBZuhfk
	6wojPfyg4CUd9tVkSU4JEtBdBZhL6rHa2f1D3DlXkSAoyV3nHBenu1EMhNk4WHWCcbIImQBaGaH
	B5f111zPSWiuVxuuGMuZi9Z2MT+6Usx+UkBAKyaf
X-Received: by 2002:a17:902:ef02:b0:234:9656:7db9 with SMTP id d9443c01a7336-23e24f4ae0emr193121295ad.32.1752874914365;
        Fri, 18 Jul 2025 14:41:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IElJIwNy/gAl1oOb5k7nEBq38Uon8tJbJo/3EEmGz51w51P0ZBbNDEpVhWKCJJ33lSWOle8bg==
X-Received: by 2002:a17:902:ef02:b0:234:9656:7db9 with SMTP id d9443c01a7336-23e24f4ae0emr193120855ad.32.1752874913939;
        Fri, 18 Jul 2025 14:41:53 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b6b4b20sm18055975ad.121.2025.07.18.14.41.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jul 2025 14:41:53 -0700 (PDT)
Message-ID: <1cda6f16-fb56-450e-8d33-b775f57ae949@redhat.com>
Date: Fri, 18 Jul 2025 17:41:47 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/16] iommu: Compute iommu_groups properly for PCIe
 switches
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <3-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <5b1f12e0-9113-41c4-accb-d8ab755cc7d7@redhat.com>
 <20250718180947.GB2394663@nvidia.com>
 <1b47ede0-bd64-46b4-a24f-4b01bbdd9710@redhat.com>
 <20250718201953.GI2250220@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250718201953.GI2250220@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/18/25 4:19 PM, Jason Gunthorpe wrote:
> On Fri, Jul 18, 2025 at 03:00:28PM -0400, Donald Dutile wrote:
>>>>> +	/*
>>>>> +	 * !self is only for SRIOV virtual busses which should have been
>>>>> +	 * excluded above.
>>>> by pci_is_root_bus() ?? -- that checks if bus->parent exists...
>>>> not sure how that excludes the case of !bus->self ...
>>>
>>> Should be this:
>>>
>>> 	/*
>>> 	 * !self is only for SRIOV virtual busses which should have been
>>> 	 * excluded by pci_physfn()
>>> 	 */
>>> 	if (WARN_ON(!bus->self))
>>>
>> my Linux tree says its this:
>> static inline bool pci_is_root_bus(struct pci_bus *pbus)
>> {
>>          return !(pbus->parent);
>> }
>>
>> is there a change to pci_is_root_bus() in a -next branch?
> 
> Not that, at the start of the function there is a pci_physfn(), the
> entire function never works on a VF, so bus is never a VF's bus.
> 
Well, i guess it depends on what you call 'a VF's bus' -- it returns the VF's->PF(pdev)->bus if virt-fn,
which I would call the VF's bus.
thanks for pointing further up... now I get your added edit above (which I didn't read carefully, /my bad).

>>>>> +	 */
>>>>> +	if (WARN_ON(!bus->self))
>>>>> +		return ERR_PTR(-EINVAL);
>>>>> +
>>>>> +	group = iommu_group_get(&bus->self->dev);
>>>>> +	if (!group) {
>>>>> +		/*
>>>>> +		 * If the upstream bridge needs the same group as pdev then
>>>>> +		 * there is no way for it's pci_device_group() to discover it.
>>>>> +		 */
>>>>> +		dev_err(&pdev->dev,
>>>>> +			"PCI device is probing out of order, upstream bridge device of %s is not probed yet\n",
>>>>> +			pci_name(bus->self));
>>>>> +		return ERR_PTR(-EPROBE_DEFER);
>>>>> +	}
>>>>> +	if (group->bus_data & BUS_DATA_PCI_NON_ISOLATED)
>>>>> +		return group;
>>>>> +	iommu_group_put(group);
>>>>> +	return NULL;
>>>> ... and w/o the function description, I don't follow:
>>>> -- rtn an iommu-group if it has NON_ISOLATED property ... but rtn null if all devices below it are isolated?
>>>
>>> Yes. For all these internal functions non null means we found a group
>>> to join, NULL means to keep checking isolation rules.
>>>
>> ah, so !group == keep looking for for non-isolated conditions.. got it.
>> Could that lead to two iommu-groups being created that could/should be one larger one?
> 
> The insistence on doing things in order should prevent that from
> happening. So long as the larger group is present in the upstream
> direction, or within the current bus, then it can be joined up.
> 
> This doesn't work if it randomly applies to PCI devices, it is why the
> above has added the "PCI device is probing out of order" detection.
> 
ok, will keep that concept in mind when reviewing.

> Jason
> 


