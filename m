Return-Path: <kvm+bounces-52928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 426E0B0AA7F
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 21:00:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F05FD3AD4D0
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 19:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A61C32E7F33;
	Fri, 18 Jul 2025 19:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G4Z6UVUU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4A62E36EE
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 19:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752865239; cv=none; b=C+NJPEbsCjHpumxH5y78YXJStJ8/QDp8oNTT9LpEaDpIwMSupFM5JBNm0W9tf2mLNG0/byqyDYOLCabOqxezn4dCuDLnoNXwG6vksr60NlEqPkJZt0Yhx/MUv+j1MyjdL9mmPzLCsYbUKeWc9iavLHHzwqPIIPPNV5NAdTvqjxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752865239; c=relaxed/simple;
	bh=veoWHeeI1Gm+Z/VWrGPVgODw868Qai1kaliqd0AgE/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tYn3XmrGRzhe/3FiDflSljTd7yKw3GDgLyaYWrzxEfUZ5FUKOaHTUdC00Rn6L9afwdRnv+ylOAkS2/seYWtCGYw3l+1+UxhSbDkRKnVWgY9e93WOiOmNpVTMoXKwFgaqQSSK6Kl1s8dhxjiOq8MNFEl6mVZmNl0FdoSEdwDzcWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G4Z6UVUU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752865237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fuzjkisuZnR7aiSCtO5mtZoLyIN2+57+reZAqeqjfrU=;
	b=G4Z6UVUUApr4NVUuGh/RIBwoJnvWj5BDahPzvjDKokRLEaA07GZb+eodEOnDhF7SYU7QL5
	yeHWqdzXcC0dHr+N4+n3Q+PwDuOFC0rFxNhl1iqXNAHfbRATP3UurborM2GTkJMMrJAd4x
	6Q/8dMOVteN5ThSucLLQpvr3IYNkdmI=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-5gk3DwQbOHe_yRhpDrumDQ-1; Fri, 18 Jul 2025 15:00:35 -0400
X-MC-Unique: 5gk3DwQbOHe_yRhpDrumDQ-1
X-Mimecast-MFC-AGG-ID: 5gk3DwQbOHe_yRhpDrumDQ_1752865234
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3138c50d2a0so3527183a91.2
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 12:00:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752865234; x=1753470034;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fuzjkisuZnR7aiSCtO5mtZoLyIN2+57+reZAqeqjfrU=;
        b=m0/llYiL/uq48P5Kl6ArCW9QlLDXTk46MG39s0mlrJL20ahuarclrg5EUR19cZ/Z38
         wekkNch8bqVLtUcUIz5+qMZqtc3ACp/y/G7vu82pSFn+23AJ9G4YixFfDe3kqj8fEgSr
         IG39MEsoFFsrA4qLkPJcsUKGN/yw5LAHnQxUbSIpPAyDyYqeD6utAriJLvSeUvPr8uwS
         YiqUddVnMvQuXtAK6viMBAOzhaW4VU1rK/h/Ktvgg7z3uDNL607hccWOIgITU9bNqj4n
         JWQhvIyKf3BANx3kCgLGkDzTtDsP/qrKltLdBhOazcmfa4b9gyQvuN4ODl/m0Ls21Qi9
         GFxg==
X-Forwarded-Encrypted: i=1; AJvYcCUKc5UosjT2SSf/I0LDeOsAbX63xmo8uO2Puj269p25AOQAfgTDf2KofaiOIfV+sZu4C3k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoO+oK7ExRVO6InFA0Tk9Lsuw+wxqKeyqVabVefjcLLOwWrCZP
	DBwvM+J2semxm1AD+7EwHbhqJHffINYDpZoqbJyajoYMCN++/cDbFn1e0NtrajxIm3CUgSBMQ3Z
	ZJSbeF8xpOc1DX3x3JLFsT6A82TOoUUWkEaG85QvLcWoEfipMMjjGpw==
X-Gm-Gg: ASbGncu2OUGv5eDmNVhluXvu44YS4c2j8sv2bWb7OsMqCo0fof9t3SuJubG+6AzdY2G
	m0pZE4pVsWMOVdqBxiUwgh3RqGPTWa7iO6TEdhzYjjiEZ9znlMBHUUy2cModBuEGUUwCvdJoWGZ
	Vqc+SEhAmyXjPatjFSihkOA0FSQolo1J0sKiUdklqXsZHxGjg9IQn/N/wPybT9OadRjzOB2ErUo
	567fmOB7yU0/E6Rrtu1hqES+kpHbu+z54cWxdrBhUMNtLalUCgh0TGeebf2+p/yp1fCrHGMQQcG
	ZV6cdszzw5lGdSfr5o9BJYDd+2BZlIRTynbaU/Qi
X-Received: by 2002:a17:90b:4ec8:b0:311:c970:c9ce with SMTP id 98e67ed59e1d1-31caf8f0311mr11212464a91.28.1752865234284;
        Fri, 18 Jul 2025 12:00:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEuByiZID+4aMiL/O1DOKL6YE07GBrCSQNpOuPpUzXosmW3/GE0r8YaZaCryfvXqwrxsY8cDg==
X-Received: by 2002:a17:90b:4ec8:b0:311:c970:c9ce with SMTP id 98e67ed59e1d1-31caf8f0311mr11212413a91.28.1752865233617;
        Fri, 18 Jul 2025 12:00:33 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31cc33715b2sm1765550a91.24.2025.07.18.12.00.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jul 2025 12:00:33 -0700 (PDT)
Message-ID: <1b47ede0-bd64-46b4-a24f-4b01bbdd9710@redhat.com>
Date: Fri, 18 Jul 2025 15:00:28 -0400
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
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250718180947.GB2394663@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Jason,
Thanks for replies, clarifications...
Couple questions below.

On 7/18/25 2:09 PM, Jason Gunthorpe wrote:
> On Thu, Jul 17, 2025 at 06:03:42PM -0400, Donald Dutile wrote:
>>> +static struct iommu_group *pci_get_alias_group(struct pci_dev *pdev)
>> So, the former pci_device_group() is completely re-written below,
>> and what it use to do is renamed pci_get_alias_group(), which shouldn't be
>> (easily) confused with ...
>>
>>> +{
>>> +	struct iommu_group *group;
>>> +	DECLARE_BITMAP(devfns, 256) = {};
>>>    	/*
>>>    	 * Look for existing groups on device aliases.  If we alias another
>>>    	 * device or another device aliases us, use the same group.
>>>    	 */
>>> -	group = get_pci_alias_group(pdev, (unsigned long *)devfns);
>>> +	group = get_pci_alias_group(pdev, devfns);
>> ... get_pci_alias_group() ?
>>
>> ... and it's only used for PCIe case below (in pci_device_group), so
>> should it be named 'pcie_get_alias_group()' ?
> 
> Well, the naming is alot better after this is reworked with the
> reachable set patch and these two functions are removed.
> 
Didn't notice that... will re-look.

> But even then I guess it is not a great name.
> 
> How about:
> 
> /*
>   * Return a group if the function has isolation restrictions related to
>   * aliases or MFD ACS.
>   */
> static struct iommu_group *pci_get_function_group(struct pci_dev *pdev)
> {
> 
sure...

>>> +static struct iommu_group *pci_hierarchy_group(struct pci_dev *pdev)
>> although static, could you provide a function description for its purpose ?
> 
> /* Return a group if the upstream hierarchy has isolation restrictions. */
> 
>>> +	/*
>>> +	 * !self is only for SRIOV virtual busses which should have been
>>> +	 * excluded above.
>> by pci_is_root_bus() ?? -- that checks if bus->parent exists...
>> not sure how that excludes the case of !bus->self ...
> 
> Should be this:
> 
> 	/*
> 	 * !self is only for SRIOV virtual busses which should have been
> 	 * excluded by pci_physfn()
> 	 */
> 	if (WARN_ON(!bus->self))
> 
my Linux tree says its this:
static inline bool pci_is_root_bus(struct pci_bus *pbus)
{
         return !(pbus->parent);
}

is there a change to pci_is_root_bus() in a -next branch?

>>> +	 */
>>> +	if (WARN_ON(!bus->self))
>>> +		return ERR_PTR(-EINVAL);
>>> +
>>> +	group = iommu_group_get(&bus->self->dev);
>>> +	if (!group) {
>>> +		/*
>>> +		 * If the upstream bridge needs the same group as pdev then
>>> +		 * there is no way for it's pci_device_group() to discover it.
>>> +		 */
>>> +		dev_err(&pdev->dev,
>>> +			"PCI device is probing out of order, upstream bridge device of %s is not probed yet\n",
>>> +			pci_name(bus->self));
>>> +		return ERR_PTR(-EPROBE_DEFER);
>>> +	}
>>> +	if (group->bus_data & BUS_DATA_PCI_NON_ISOLATED)
>>> +		return group;
>>> +	iommu_group_put(group);
>>> +	return NULL;
>> ... and w/o the function description, I don't follow:
>> -- rtn an iommu-group if it has NON_ISOLATED property ... but rtn null if all devices below it are isolated?
> 
> Yes. For all these internal functions non null means we found a group
> to join, NULL means to keep checking isolation rules.
> 
ah, so !group == keep looking for for non-isolated conditions.. got it.
Could that lead to two iommu-groups being created that could/should be one larger one?

> Thanks,
> Jason
> 


