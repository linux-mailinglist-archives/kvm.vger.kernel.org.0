Return-Path: <kvm+bounces-22757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 959B3942CB3
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 13:06:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B799287494
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 11:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 603171AD418;
	Wed, 31 Jul 2024 11:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DgEzT78t"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E723F1AD416
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 11:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722423957; cv=none; b=RFH7qGujJxRKpEukOfvSCYl3TcGyhjDrCc7n+xdKt1VjQn8dKHg/xrCUCnWJeypOjGs6TbrGs6NCcsFJZP/VvsGss+j4+/BMIxr/bk39uGLUVSCwWCaoUN2phWjank6nt1iQZ+xPsRhIO1CtUYnu2vL5BXKVa7DZQrsq7HyRhB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722423957; c=relaxed/simple;
	bh=s9iscE8Ou55GOs7nk3B13eljDkuq3rb62pb2AErSqLU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BGJfY853dO5PLeiwA4YcKcXeuBhzjAazLgW/I51Z4JSvU0oAqEXyD3Znsgs1Sao0j3OXpKggSXgSAYLZte9iDOnFlhwHE1q8cxmKz4lR3yOAUi6KvNCiOwcuHE/RT7PoX6vckRE6G4bG5LVtMbYT2i6lER8xN0jojphkwIAhK3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DgEzT78t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722423954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C1dgIfrxTHcoygnjZ8tW0sN/9U9IrukaY4P8Tmposwc=;
	b=DgEzT78tLHl8YFIiF7Vc2ExtFNCWHEqzqGnpCyenYnNmw8MCBm3kYSXdGee82Tcqk6Fj2i
	ghXQxzMJo+I62uquQ4ORM1fzPYKbsuWJUu9K8kVEKoVjOOcVo5mEVBcAZFnu0ttxxPGftA
	VZK1MST1j7yOu101urG8W5Iwp/OPuHE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-L0YPcCIKOTGvXs-WP7nkww-1; Wed, 31 Jul 2024 07:05:53 -0400
X-MC-Unique: L0YPcCIKOTGvXs-WP7nkww-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3687a1a6846so2702333f8f.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 04:05:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722423952; x=1723028752;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C1dgIfrxTHcoygnjZ8tW0sN/9U9IrukaY4P8Tmposwc=;
        b=okr1SRPcyH0bpmqQ1/Nnza2Gl4ou7TaLoSMsulcTL3NLxACPZAMhLFvTi8AuWnrsRO
         Bsk28leny07v3YsuECuxg2mTKIE/d2UdpX1mPjdKHKFscBVJSJm15uX25iIBepICOFWB
         lYXIZNLaW3bRONWM1E2qV8GX502UarBvDw6eMRWtGs3L8n++uXmol0S8K6rHgo64xIZy
         vPQSSpZnoyV+QGr6lRuksgJxPcI0VbA7CCvrM/4JDzZ4IYUZtxEn9zuQzFc3xYWkBKyj
         ErtnO2Aw5f1UbgjyPoTewW+pv/lSEHC9qIHXE+jmjBglOozKjPxPdiGslHWYiycy+9w/
         fOnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOjt75Gtyzvqu+SR07L0YAasvjJ71zU+kEZm+mshlLUaavYJH1w9ojcSJrsMKVjQNFkjQabvqDVJn+1cdg01tnnG0X
X-Gm-Message-State: AOJu0YydZR3GCiNGA4ziDKfZG5c1efWgCkUBkAmxIUX2GQ2b0PC0eycG
	enDufg4auvKYvFM6CF4TKX8e0sUyFM8DxzV2CN7kclj5mmegidRbDZaulneM0KUi+rVElL0x/hi
	UVZWDfan8t7MoMDdaDtdo/WjsR0Ru3pnXQHcXFc023ipcWS2Xcw==
X-Received: by 2002:adf:e64f:0:b0:368:6f64:3072 with SMTP id ffacd0b85a97d-36b5cee46b7mr9407379f8f.7.1722423952329;
        Wed, 31 Jul 2024 04:05:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHSUCOdkVJc0wbLcGmfjIq3JfIabhqwCZ1PrjP4T+bwuWDsO0/Yp/EEfrQ67qQRV57ei1eihw==
X-Received: by 2002:adf:e64f:0:b0:368:6f64:3072 with SMTP id ffacd0b85a97d-36b5cee46b7mr9407352f8f.7.1722423951724;
        Wed, 31 Jul 2024 04:05:51 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70b:5f00:9b61:28a2:eea1:fa49? (p200300cbc70b5f009b6128a2eea1fa49.dip0.t-ipconnect.de. [2003:cb:c70b:5f00:9b61:28a2:eea1:fa49])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b367d9b30sm16823751f8f.40.2024.07.31.04.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 04:05:51 -0700 (PDT)
Message-ID: <272e3dbf-ed4a-43f5-8b5f-56bf6d74930c@redhat.com>
Date: Wed, 31 Jul 2024 13:05:50 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] Enable shared device assignment
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
 "Qiang, Chenyi" <chenyi.qiang@intel.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Wang, Wei W" <wei.w.wang@intel.com>, "Peng, Chao P"
 <chao.p.peng@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
 "Wu, Hao" <hao.wu@intel.com>, "Xu, Yilun" <yilun.xu@intel.com>
References: <20240725072118.358923-1-chenyi.qiang@intel.com>
 <ace9bb98-1415-460f-b8f5-e50607fbce20@redhat.com>
 <BN9PR11MB527635939C0A2A0763E326A58CB42@BN9PR11MB5276.namprd11.prod.outlook.com>
 <c9556944-16e4-4eb0-b9cd-56426099f813@redhat.com>
 <Zqnj7PZKX6Rzh/yl@yilunxu-OptiPlex-7050>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Zqnj7PZKX6Rzh/yl@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31.07.24 09:12, Xu Yilun wrote:
> On Fri, Jul 26, 2024 at 09:08:51AM +0200, David Hildenbrand wrote:
>> On 26.07.24 07:02, Tian, Kevin wrote:
>>>> From: David Hildenbrand <david@redhat.com>
>>>> Sent: Thursday, July 25, 2024 10:04 PM
>>>>
>>>>> Open
>>>>> ====
>>>>> Implementing a RamDiscardManager to notify VFIO of page conversions
>>>>> causes changes in semantics: private memory is treated as discarded (or
>>>>> hot-removed) memory. This isn't aligned with the expectation of current
>>>>> RamDiscardManager users (e.g. VFIO or live migration) who really
>>>>> expect that discarded memory is hot-removed and thus can be skipped
>>>> when
>>>>> the users are processing guest memory. Treating private memory as
>>>>> discarded won't work in future if VFIO or live migration needs to handle
>>>>> private memory. e.g. VFIO may need to map private memory to support
>>>>> Trusted IO and live migration for confidential VMs need to migrate
>>>>> private memory.
>>>>
>>>> "VFIO may need to map private memory to support Trusted IO"
>>>>
>>>> I've been told that the way we handle shared memory won't be the way
>>>> this is going to work with guest_memfd. KVM will coordinate directly
>>>> with VFIO or $whatever and update the IOMMU tables itself right in the
>>>> kernel; the pages are pinned/owned by guest_memfd, so that will just
>>>> work. So I don't consider that currently a concern. guest_memfd private
>>>> memory is not mapped into user page tables and as it currently seems it
>>>> never will be.
>>>
>>> Or could extend MAP_DMA to accept guest_memfd+offset in place of
> 
> With TIO, I can imagine several buffer sharing requirements: KVM maps VFIO
> owned private MMIO, IOMMU maps gmem owned private memory, IOMMU maps VFIO
> owned private MMIO. These buffers cannot be found by user page table
> anymore. I'm wondering it would be messy to have specific PFN finding
> methods for each FD type. Is it possible we have a unified way for
> buffer sharing and PFN finding, is dma-buf a candidate?

No expert on that, so I'm afraid I can't help.

> 
>>> 'vaddr' and have VFIO/IOMMUFD call guest_memfd helpers to retrieve
>>> the pinned pfn.
>>
>> In theory yes, and I've been thinking of the same for a while. Until people
>> told me that it is unlikely that it will work that way in the future.
> 
> Could you help specify why it won't work? As Kevin mentioned below, SEV-TIO
> may still allow userspace to manage the IOMMU mapping for private. I'm
> not sure how they map private memory for IOMMU without touching gmemfd.

I raised that question in [1]:

"How would the device be able to grab/access "private memory", if not 
via the user page tables?"

Jason summarized it as "The approaches I'm aware of require the secure 
world to own the IOMMU and generate the IOMMU page tables. So we will 
not use a GUP approach with VFIO today as the kernel will not have any 
reason to generate a page table in the first place. Instead we will say 
"this PCI device translates through the secure world" and walk away."

I think for some cVM approaches it really cannot work without letting 
KVM/secure world handle the IOMMU (e.g., sharing of page tables between 
IOMMU and KVM).

For your use case it *might* work, but I am wondering if this is how it 
should be done, and if there are better alternatives.


[1] https://lkml.org/lkml/2024/6/20/920

-- 
Cheers,

David / dhildenb


