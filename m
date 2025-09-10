Return-Path: <kvm+bounces-57161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 56A60B50A96
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 03:59:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03671166E2A
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 01:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22D2D2264BD;
	Wed, 10 Sep 2025 01:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CUKA3ZyN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453A11F473A
	for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 01:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757469571; cv=none; b=VDu9vxRqunOKfm05d/wOAo+v4+k8dZ4Xj8xQBaK9qQX/fKBHqAzIcTMumDD6r9mjeLn6pW5DNmde20Ws86z+pq4M6CKuTxPeKRopveuUzO54gxJo6N37cwJ9Jr34T6do9EL9KKdB0r4Q9OJdU0IrJmr3ec2N1bD2SBALWw8EKTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757469571; c=relaxed/simple;
	bh=1rxsxIhebtcsPF+0izkSvpQhkwTsK2Ui5CXRGEX6uhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JwM4dOVUKTaRBLEXVeb7n6jygveNWqWMe1nYPf+Q2QVD2A1zw/nQziaMuHlGRF3a6jahzSRUgLJ+ufm2hp1XA5VqHdnlBXMShhUza9dqgZDk1wQLquvY9sYe9F5Q93KlMhouQlPd3C4LlRHuT9c0cGoRsT1vPOUJh44yYMHJjNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CUKA3ZyN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757469568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fXA/AMFxDBLv+V0m6fG1THNgMLJEKFJoBijLaztGch4=;
	b=CUKA3ZyNNX+vAs7INGijr8eFBqBV3fYF+QU1pfY4vXv9OUw0SDj7AjGXtg4jSTlmBc/ZRI
	YuRMcyNUEhjkgbbBWcwxRual71UopR1tVNIn8osCTxNip4Lpc3/lSCVNMrKWdMS9bvPglb
	TvikyOgGeTw1IlXknh3+SbRM/HIUoQE=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-7A5HZdhwMMm8GnYcxj-fxQ-1; Tue, 09 Sep 2025 21:59:26 -0400
X-MC-Unique: 7A5HZdhwMMm8GnYcxj-fxQ-1
X-Mimecast-MFC-AGG-ID: 7A5HZdhwMMm8GnYcxj-fxQ_1757469566
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4b5e9b60ce6so147147321cf.2
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 18:59:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757469566; x=1758074366;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fXA/AMFxDBLv+V0m6fG1THNgMLJEKFJoBijLaztGch4=;
        b=rirV0prN77Hj9aAfPaPLChYlW8hi3izfHgarRRwZu4pxGBjgd00WMDSHkTnRlBL0Ip
         q/KIJReUfuhZXOEHQ7ZywA1jDczooeYQ88/5o+3NYqAl4lolfFXreFvAmnXcvwUSGRJw
         J0RQOqnXphf1KM13fwvq0mPm9USSffWd2PMPHEJvlu73q4nkMR91yzNyruAzpAIpc7pN
         Ly3yIaaiJiNGbgOoaALZqcrZZHhU9CahCsBARwQ+FwfOOjpYnVUa7JVPjjr2sbtqUmIT
         ZQVBLxO2GZHX2eY+So0fiQYDBRcAb+FrJdJZfr8XHMlBHSnZqK5Xx1uuPcFfnU38z7y8
         bQfA==
X-Forwarded-Encrypted: i=1; AJvYcCXK3KRlZEb/TvdkyvrZh5PYE4xFcQ5BE+iKE486xbUfB7orIYXU6yBZqtoShE7usGg8C1U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz74eM7i8uifteFF7jTHRmxTSEYtXmo9rYsvIvGI0/wS70l9f+z
	orPckH1I1skpcQ/pHOVkHmjrC68s1DcwEAzJrKx1F2lFb9qs0q7jL7G70damHdjp38bMJrK5aVZ
	IbnerBfPs81wgGGktBGoxaY4mmdzb8KFluun7dnnJGRVpxS82H70m8w==
X-Gm-Gg: ASbGnct52SNTcr4WhTIuHQEBKIZUxxkYySvwZD6VEu4X2M97hNs9t91ni4xGUgyo7VP
	GAvU1ynyIieGypGt7axEiTHfOc21l7iyOYwmZgK4dmcRHPuRvl7BXnU9jRyGkDe8/ywvfY9AoF6
	w0XXI8Qb0u6RvMEyzOCDaFmcG6CSSDkztL68uJuJ3DqpZKAFm6DM8WDM+DQ/oBm6q6IEqXVlBGm
	LAlhl0w2Ceo5HENcI12p3eIfgziO2OMpCEVuUSwLtt34LD82JaXuoeLtHTcuBzS60gaysRG6OYA
	OieV4C3o5R2+tY1kujN3w0ocOkvUONMzELJIIfmb
X-Received: by 2002:a05:620a:370e:b0:80f:c2d4:3fea with SMTP id af79cd13be357-813c2b21189mr1576023585a.24.1757469566089;
        Tue, 09 Sep 2025 18:59:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE62UNFw68lA96vqnlJnpP665eGyiTHX07KJk7zOdVaQ0ByGkmpx+++6I2aYWGQUqSOsYq0GQ==
X-Received: by 2002:a05:620a:370e:b0:80f:c2d4:3fea with SMTP id af79cd13be357-813c2b21189mr1576021385a.24.1757469565572;
        Tue, 09 Sep 2025 18:59:25 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-81b59f8786fsm214167685a.29.2025.09.09.18.59.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 18:59:25 -0700 (PDT)
Message-ID: <15ee1d12-6900-4cf2-9348-6e6cc8aefbe9@redhat.com>
Date: Tue, 9 Sep 2025 21:59:23 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/11] iommu: Compute iommu_groups properly for PCIe
 MFDs
Content-Language: en-US
To: Bjorn Helgaas <helgaas@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <20250909212457.GA1508122@bhelgaas>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250909212457.GA1508122@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/9/25 5:24 PM, Bjorn Helgaas wrote:
> On Fri, Sep 05, 2025 at 03:06:21PM -0300, Jason Gunthorpe wrote:
>> Like with switches the current MFD algorithm does not consider asymmetric
>> ACS within a MFD. If any MFD function has ACS that permits P2P the spec
>> says it can reach through the MFD internal loopback any other function in
>> the device.
>>
>> For discussion let's consider a simple MFD topology like the below:
>>
>>                        -- MFD 00:1f.0 ACS != REQ_ACS_FLAGS
>>        Root 00:00.00 --|- MFD 00:1f.2 ACS != REQ_ACS_FLAGS
>>                        |- MFD 00:1f.6 ACS = REQ_ACS_FLAGS
> 
> REQ_ACS_FLAGS was renamed in an earlier patch.
> 
> I don't quite understand the "Root 00:00.00" notation.  I guess it
> must refer to the root bus 00?  It looks sort of like a bridge, and
> the ".00" makes it look sort of like a bus/device/function address,
> but I don't think it is.
> 
>> This asymmetric ACS could be created using the config_acs kernel command
>> line parameter, from quirks, or from a poorly thought out device that has
>> ACS flags only on some functions.
>>
>> Since ACS is an egress property the asymmetric flags allow for 00:1f.0 to
>> do memory acesses into 00:1f.6's BARs, but 00:1f.6 cannot reach any other
>> function. Thus we expect an iommu_group to contain all three
>> devices. Instead the current algorithm gives a group of [1f.0, 1f.2] and a
>> single device group of 1f.6.
>>
>> The current algorithm sees the good ACS flags on 00:1f.6 and does not
>> consider ACS on any other MFD functions.
>>
>> For path properties the ACS flags say that 00:1f.6 is safe to use with
>> PASID and supports SVA as it will not have any portions of its address
>> space routed away from the IOMMU, this part of the ACS system is working
>> correctly.
>>
>> Further, if one of the MFD functions is a bridge, eg like 1f.2:
>>
>>                        -- MFD 00:1f.0
>>        Root 00:00.00 --|- MFD 00:1f.2 Root Port --- 01:01.0
>>                        |- MFD 00:1f.6
> 
> Same question.
> 
>> Then the correct grouping will include 01:01.0, 00:1f.0/2/6 together in a
>> group if there is any internal loopback within the MFD 00:1f. The current
>> algorithm does not understand this and gives 01:01.0 it's own group even
>> if it thinks there is an internal loopback in the MFD.
> 
> s/it's/its/
> 
>> Unfortunately this detail makes it hard to fix. Currently the code assumes
>> that any MFD without an ACS cap has an internal loopback which will cause
>> a large number of modern real systems to group in a pessimistic way.
>>
>> However, the PCI spec does not really support this:
>>
>>     PCI Section 6.12.1.2 ACS Functions in SR-IOV, SIOV, and Multi-Function
>>     Devices
>>
>>      ACS P2P Request Redirect: must be implemented by Functions that
>>      support peer-to-peer traffic with other Functions.
> 
> I would include the PCIe r7.0 spec revision, even though the PCI SIG
> seems to try to preserve section numbers across revisions.
> 
> It seems pretty clear that Multi-Function Devices that have an ACS
> Capability and support peer-to-peer traffic with other Functions are
> required to implement ACS P2P Request Redirect.
> 
>> Meaning from a spec perspective the absence of ACS indicates the absence
>> of internal loopback. Granted I think we are aware of older real devices
>> that ignore this, but it seems to be the only way forward.
> 
> It's not as clear to me that Multi-Function Devices that support
> peer-to-peer traffic are required to have an ACS Capability at all.
> 
> Alex might remember more, but I kind of suspect the current system of
> quirks is there because of devices that do internal loopback but have
> no ACS Capability.
> 
and they are quirks b/c ... they violated the spec.... they are suppose
to have an ACS Cap if they can do internal loopback p2p dma.

I'm assuming the quirks that the current system of quirks impacts the
groups and/or reachability, such that the quirks are accounted for, and that
history isn't lost (and we have another regression issue).

>> So, rely on 6.12.1.2 and assume functions without ACS do not have internal
>> loopback. This resolves the common issue with modern systems and MFD root
>> ports, but it makes the ACS quirks system less used. Instead we'd want
>> quirks that say self-loopback is actually present, not like today's quirks
>> that say it is absent. This is surely negative for older hardware, but
>> positive for new HW that complies with the spec.
>>
>> Use pci_reachable_set() in pci_device_group() to make the resulting
>> algorithm faster and easier to understand.
>>
>> Add pci_mfds_are_same_group() which specifically looks pair-wise at all
>> functions in the MFDs. Any function with ACS capabilities and non-isolated
>> aCS flags will become reachable to all other functions.
> 
> s/aCS/ACS/
> 
>> pci_reachable_set() does the calculations for figuring out the set of
>> devices under the pci_bus_sem, which is better than repeatedly searching
>> across all PCI devices.
>>
>> Once the set of devices is determined and the set has more than one device
>> use pci_get_slot() to search for any existing groups in the reachable set.
>>
>> Fixes: 104a1c13ac66 ("iommu/core: Create central IOMMU group lookup/creation interface")
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> ---
>>   drivers/iommu/iommu.c | 189 +++++++++++++++++++-----------------------
>>   1 file changed, 87 insertions(+), 102 deletions(-)
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 543d6347c0e5e3..fc3c71b243a850 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -1413,85 +1413,6 @@ int iommu_group_id(struct iommu_group *group)
>>   }
>>   EXPORT_SYMBOL_GPL(iommu_group_id);
>>   
>> -static struct iommu_group *get_pci_alias_group(struct pci_dev *pdev,
>> -					       unsigned long *devfns);
>> -
>> -/*
>> - * For multifunction devices which are not isolated from each other, find
>> - * all the other non-isolated functions and look for existing groups.  For
>> - * each function, we also need to look for aliases to or from other devices
>> - * that may already have a group.
>> - */
>> -static struct iommu_group *get_pci_function_alias_group(struct pci_dev *pdev,
>> -							unsigned long *devfns)
>> -{
>> -	struct pci_dev *tmp = NULL;
>> -	struct iommu_group *group;
>> -
>> -	if (!pdev->multifunction || pci_acs_enabled(pdev, PCI_ACS_ISOLATED))
>> -		return NULL;
>> -
>> -	for_each_pci_dev(tmp) {
>> -		if (tmp == pdev || tmp->bus != pdev->bus ||
>> -		    PCI_SLOT(tmp->devfn) != PCI_SLOT(pdev->devfn) ||
>> -		    pci_acs_enabled(tmp, PCI_ACS_ISOLATED))
>> -			continue;
>> -
>> -		group = get_pci_alias_group(tmp, devfns);
>> -		if (group) {
>> -			pci_dev_put(tmp);
>> -			return group;
>> -		}
>> -	}
>> -
>> -	return NULL;
>> -}
>> -
>> -/*
>> - * Look for aliases to or from the given device for existing groups. DMA
>> - * aliases are only supported on the same bus, therefore the search
>> - * space is quite small (especially since we're really only looking at pcie
>> - * device, and therefore only expect multiple slots on the root complex or
>> - * downstream switch ports).  It's conceivable though that a pair of
>> - * multifunction devices could have aliases between them that would cause a
>> - * loop.  To prevent this, we use a bitmap to track where we've been.
>> - */
>> -static struct iommu_group *get_pci_alias_group(struct pci_dev *pdev,
>> -					       unsigned long *devfns)
>> -{
>> -	struct pci_dev *tmp = NULL;
>> -	struct iommu_group *group;
>> -
>> -	if (test_and_set_bit(pdev->devfn & 0xff, devfns))
>> -		return NULL;
>> -
>> -	group = iommu_group_get(&pdev->dev);
>> -	if (group)
>> -		return group;
>> -
>> -	for_each_pci_dev(tmp) {
>> -		if (tmp == pdev || tmp->bus != pdev->bus)
>> -			continue;
>> -
>> -		/* We alias them or they alias us */
>> -		if (pci_devs_are_dma_aliases(pdev, tmp)) {
>> -			group = get_pci_alias_group(tmp, devfns);
>> -			if (group) {
>> -				pci_dev_put(tmp);
>> -				return group;
>> -			}
>> -
>> -			group = get_pci_function_alias_group(tmp, devfns);
>> -			if (group) {
>> -				pci_dev_put(tmp);
>> -				return group;
>> -			}
>> -		}
>> -	}
>> -
>> -	return NULL;
>> -}
>> -
>>   /*
>>    * Generic device_group call-back function. It just allocates one
>>    * iommu-group per device.
>> @@ -1534,44 +1455,108 @@ static struct iommu_group *pci_group_alloc_non_isolated(void)
>>   	return group;
>>   }
>>   
>> +/*
>> + * All functions in the MFD need to be isolated from each other and get their
>> + * own groups, otherwise the whole MFD will share a group.
>> + */
>> +static bool pci_mfds_are_same_group(struct pci_dev *deva, struct pci_dev *devb)
>> +{
>> +	/*
>> +	 * SRIOV VFs will use the group of the PF if it has
>> +	 * BUS_DATA_PCI_NON_ISOLATED. We don't support VFs that also have ACS
>> +	 * that are set to non-isolating.
> 
> "SR-IOV" is more typical in drivers/pci/.
> 
>> +	 */
>> +	if (deva->is_virtfn || devb->is_virtfn)
>> +		return false;
>> +
>> +	/* Are deva/devb functions in the same MFD? */
>> +	if (PCI_SLOT(deva->devfn) != PCI_SLOT(devb->devfn))
>> +		return false;
>> +	/* Don't understand what is happening, be conservative */
>> +	if (deva->multifunction != devb->multifunction)
>> +		return true;
>> +	if (!deva->multifunction)
>> +		return false;
>> +
>> +	/*
>> +	 * PCI Section 6.12.1.2 ACS Functions in SR-IOV, SIOV, and
> 
> PCIe r7.0, sec 6.12.1.2
> 
>> +	 * Multi-Function Devices
>> +	 *   ...
>> +	 *   ACS P2P Request Redirect: must be implemented by Functions that
>> +	 *   support peer-to-peer traffic with other Functions.
>> +	 *
>> +	 * Therefore assume if a MFD has no ACS capability then it does not
>> +	 * support a loopback. This is the reverse of what Linux <= v6.16
>> +	 * assumed - that any MFD was capable of P2P and used quirks identify
>> +	 * devices that complied with the above.
>> +	 */
>> +	if (deva->acs_cap && !pci_acs_enabled(deva, PCI_ACS_ISOLATED))
>> +		return true;
>> +	if (devb->acs_cap && !pci_acs_enabled(devb, PCI_ACS_ISOLATED))
>> +		return true;
>> +	return false;
>> +}
>> +
>> +static bool pci_devs_are_same_group(struct pci_dev *deva, struct pci_dev *devb)
>> +{
>> +	/*
>> +	 * This is allowed to return cycles: a,b -> b,c -> c,a can be aliases.
>> +	 */
>> +	if (pci_devs_are_dma_aliases(deva, devb))
>> +		return true;
>> +
>> +	return pci_mfds_are_same_group(deva, devb);
>> +}
>> +
>>   /*
>>    * Return a group if the function has isolation restrictions related to
>>    * aliases or MFD ACS.
>>    */
>>   static struct iommu_group *pci_get_function_group(struct pci_dev *pdev)
>>   {
>> -	struct iommu_group *group;
>> -	DECLARE_BITMAP(devfns, 256) = {};
>> +	struct pci_reachable_set devfns;
>> +	const unsigned int NR_DEVFNS = sizeof(devfns.devfns) * BITS_PER_BYTE;
>> +	unsigned int devfn;
>>   
>>   	/*
>> -	 * Look for existing groups on device aliases.  If we alias another
>> -	 * device or another device aliases us, use the same group.
>> +	 * Look for existing groups on device aliases and multi-function ACS. If
>> +	 * we alias another device or another device aliases us, use the same
>> +	 * group.
>> +	 *
>> +	 * pci_reachable_set() should return the same bitmap if called for any
>> +	 * device in the set and we want all devices in the set to have the same
>> +	 * group.
>>   	 */
>> -	group = get_pci_alias_group(pdev, devfns);
>> -	if (group)
>> -		return group;
>> +	pci_reachable_set(pdev, &devfns, pci_devs_are_same_group);
>> +	/* start is known to have iommu_group_get() == NULL */
>> +	__clear_bit(pdev->devfn, devfns.devfns);
>>   
>>   	/*
>> -	 * Look for existing groups on non-isolated functions on the same
>> -	 * slot and aliases of those funcions, if any.  No need to clear
>> -	 * the search bitmap, the tested devfns are still valid.
>> -	 */
>> -	group = get_pci_function_alias_group(pdev, devfns);
>> -	if (group)
>> -		return group;
>> -
>> -	/*
>> -	 * When MFD's are included in the set due to ACS we assume that if ACS
>> -	 * permits an internal loopback between functions it also permits the
>> -	 * loopback to go downstream if a function is a bridge.
>> +	 * When MFD functions are included in the set due to ACS we assume that
>> +	 * if ACS permits an internal loopback between functions it also permits
>> +	 * the loopback to go downstream if any function is a bridge.
>>   	 *
>>   	 * It is less clear what aliases mean when applied to a bridge. For now
>>   	 * be conservative and also propagate the group downstream.
>>   	 */
>> -	__clear_bit(pdev->devfn & 0xFF, devfns);
>> -	if (!bitmap_empty(devfns, sizeof(devfns) * BITS_PER_BYTE))
>> -		return pci_group_alloc_non_isolated();
>> -	return NULL;
>> +	if (bitmap_empty(devfns.devfns, NR_DEVFNS))
>> +		return NULL;
>> +
>> +	for_each_set_bit(devfn, devfns.devfns, NR_DEVFNS) {
>> +		struct iommu_group *group;
>> +		struct pci_dev *pdev_slot;
>> +
>> +		pdev_slot = pci_get_slot(pdev->bus, devfn);
>> +		group = iommu_group_get(&pdev_slot->dev);
>> +		pci_dev_put(pdev_slot);
>> +		if (group) {
>> +			if (WARN_ON(!(group->bus_data &
>> +				      BUS_DATA_PCI_NON_ISOLATED)))
>> +				group->bus_data |= BUS_DATA_PCI_NON_ISOLATED;
>> +			return group;
>> +		}
>> +	}
>> +	return pci_group_alloc_non_isolated();
>>   }
>>   
>>   /* Return a group if the upstream hierarchy has isolation restrictions. */
>> -- 
>> 2.43.0
>>
> 


