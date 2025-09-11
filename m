Return-Path: <kvm+bounces-57359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 30E6EB53CC5
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 21:57:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1BF0A1CC63DF
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 19:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FB522673B7;
	Thu, 11 Sep 2025 19:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J6E0Wa3c"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D15262808
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 19:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757620621; cv=none; b=lBSEA0bGunIJGbjahfhQL1TQeaRVxVMgxpQ60X7eMct1Q1yOh6K/QZQmkgs2CIdQdZs9JNZLKGe8fw4v+B0K56+fB358M26QRBYjVMF/xsvIwGij49N0d7w93EL27AGww9VSb1fX63uxD2ErJPojSH3yQpnOlO/IEx09ZGluluw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757620621; c=relaxed/simple;
	bh=fB06S4ZFtUWVGCTKe4l5MMYJGNwa+fb+1UiPDtQGVvA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P5BGcqaq4dkyAsF6MQ9i+a66AlqHSVXLgS5n+zzGgllBdGVTsqnkcWMMzWm8qV8mEdelyfWaT+7DRyxRvl56yevLj4BK3bonX6vHDpwqwAMY/fNCfm1HRi1IuXJ6EwhvRLn2Zz1kuMHd5lmrvQg+/U7sxnChQNfNc1GrX9Qu9h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J6E0Wa3c; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757620618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N3cNveyFhKelD03yvN9UhwY3+sLQeLXbF7GotBNmB6Y=;
	b=J6E0Wa3cs2dB5DhJnxWxbBbEZDExx60+cKiaByaTKXp43VC9MYRdXyQIMo5GVkY790P25f
	5M6Qc2zWyQ87YxwEtrTE/Rl6xLnPFsp4NP7igCjBw/qJfP68QY1gGlopRNKc60U+5a1icj
	kPf3k1ZG40Cv3YwwWy95NtfltYHd+8s=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-VomJkvi2Nu6EZ2yW76MsiQ-1; Thu, 11 Sep 2025 15:56:54 -0400
X-MC-Unique: VomJkvi2Nu6EZ2yW76MsiQ-1
X-Mimecast-MFC-AGG-ID: VomJkvi2Nu6EZ2yW76MsiQ_1757620614
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-7654126cc2cso17680006d6.0
        for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 12:56:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757620614; x=1758225414;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N3cNveyFhKelD03yvN9UhwY3+sLQeLXbF7GotBNmB6Y=;
        b=Q3XH1V3cfHrog0kpO2xgNTD3USwl59fYyTVYGm1jwRNaPtgLvDAPjUdsna8hOdMP8L
         7mZxB3LfGekHHWAy7FzaB69O+RDTb3W0MOXi1qmaNfywm++P7fsJ3nTiBFGc/brJWhpn
         l2+NR5FAra8dgPu7BHdMfhj3JH0Qfxs7lKeSw19t6Al7Z9qPufH6vDdGzPC9tbm1KKDM
         JuVNCqnGX8uTrJehUxxCHQtq1CCFCsXWRRGz3iXgrO/7tOggwh1A87MKW/FLd6ZPbQl5
         rQV4JhZ2VavvDkoYSQ06Rdd2KJiI3y/7NXeRCJYehfRTDoFzfZfvmldKfeUyOBptkHJ0
         mXAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbOBNsirXefL705uiSNzJoE/D+V/HI1CFYlq2xZSDDIjikPCLJK4EFf5Jnm6aLnNv+iqs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzI2EJxuhQIchcznqSrVeWDp/WordXmtzEHqQLMpIhBLbeJviDt
	JMjLfW1Cin0LTivzmt7TLszMTQ1VVNScbPt0e8Nag+12A5STGdELARghwtElR2qAwKrYuCmXXnJ
	WJ5TcmofLyTTqwD9okkjXbx4s9ZuJQhpsaHg1i9geP3TeCeactPX6zQ==
X-Gm-Gg: ASbGnct6CqTPBKlPbgKR7TZ+AEEm2nwGn2eMvAJ7psW4O4QgI8No4hO8I4SNrHenawg
	KrftLOW/rhqEh06qYzSvIB8aLwbminEmVg+Xcu31HSk5vfx0tLU8xI2iTO/QD6YW2Z57ldVrpMP
	Dy4W3Wo6g9mL319wgVkSVegMFxefC6x+1eSkFMeLFx9x3dBQXqpIsWkG8lhJ4Qqem24hWX5gmdE
	BaH1PlVPqo8pmZ+mE/H6lWwtPhR+S0p3NuhoTNtnG2DePxvu65ueyysZI56ReC9iH4cyedeItXR
	y3c3nZau9g16oYVFQIONt3Y9D5BAuQDzkv/JRVGb
X-Received: by 2002:a05:6214:246d:b0:725:c2b4:3335 with SMTP id 6a1803df08f44-767bac0e426mr8332616d6.4.1757620614041;
        Thu, 11 Sep 2025 12:56:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHLemFR3JpHScXx4h7q7Tkg6Nhj/3uhlgp5omv8uUp+kJSUBV2Eg/agifUMN18nW/Yywqtw1g==
X-Received: by 2002:a05:6214:246d:b0:725:c2b4:3335 with SMTP id 6a1803df08f44-767bac0e426mr8332416d6.4.1757620613594;
        Thu, 11 Sep 2025 12:56:53 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-763b642285dsm15725296d6.26.2025.09.11.12.56.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 12:56:53 -0700 (PDT)
Message-ID: <3d3f7b6c-5068-4bbc-afdb-13c5ceee1927@redhat.com>
Date: Thu, 11 Sep 2025 15:56:50 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/11] PCI: Add pci_reachable_set()
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
References: <20250909210336.GA1507895@bhelgaas>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250909210336.GA1507895@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/9/25 5:03 PM, Bjorn Helgaas wrote:
> On Fri, Sep 05, 2025 at 03:06:20PM -0300, Jason Gunthorpe wrote:
>> Implement pci_reachable_set() to efficiently compute a set of devices on
>> the same bus that are "reachable" from a starting device. The meaning of
>> reachability is defined by the caller through a callback function.
>>
>> This is a faster implementation of the same logic in
>> pci_device_group(). Being inside the PCI core allows use of pci_bus_sem so
>> it can use list_for_each_entry() on a small list of devices instead of the
>> expensive for_each_pci_dev(). Server systems can now have hundreds of PCI
>> devices, but typically only a very small number of devices per bus.
>>
>> An example of a reachability function would be pci_devs_are_dma_aliases()
>> which would compute a set of devices on the same bus that are
>> aliases. This would also be useful in future support for the ACS P2P
>> Egress Vector which has a similar reachability problem.
>>
>> This is effectively a graph algorithm where the set of devices on the bus
>> are vertexes and the reachable() function defines the edges. It returns a
>> set of vertexes that form a connected graph.
>>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> ---
>>   drivers/pci/search.c | 90 ++++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/pci.h  | 12 ++++++
>>   2 files changed, 102 insertions(+)
>>
>> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
>> index fe6c07e67cb8ce..dac6b042fd5f5d 100644
>> --- a/drivers/pci/search.c
>> +++ b/drivers/pci/search.c
>> @@ -595,3 +595,93 @@ int pci_dev_present(const struct pci_device_id *ids)
>>   	return 0;
>>   }
>>   EXPORT_SYMBOL(pci_dev_present);
>> +
>> +/**
>> + * pci_reachable_set - Generate a bitmap of devices within a reachability set
>> + * @start: First device in the set
>> + * @devfns: The set of devices on the bus
> 
> @devfns is a return parameter, right?  Maybe mention that somewhere?
> And the fact that the set only includes the *reachable* devices on the
> bus.
> 
Yes, and for clarify, I'd prefer the fcn name to be 'pci_reachable_bus_set()' so
it's clear it (or its callers) are performing an intra-bus reachable result,
and not doing inter-bus reachability checking, although returning a 256-bit
devfns without a domain prefix indirectly indicates it.

>> + * @reachable: Callback to tell if two devices can reach each other
>> + *
>> + * Compute a bitmap where every set bit is a device on the bus that is reachable
>> + * from the start device, including the start device. Reachability between two
>> + * devices is determined by a callback function.
>> + *
>> + * This is a non-recursive implementation that invokes the callback once per
>> + * pair. The callback must be commutative:
>> + *    reachable(a, b) == reachable(b, a)
>> + * reachable() can form a cyclic graph:
>> + *    reachable(a,b) == reachable(b,c) == reachable(c,a) == true
>> + *
>> + * Since this function is limited to a single bus the largest set can be 256
>> + * devices large.
>> + */
>> +void pci_reachable_set(struct pci_dev *start, struct pci_reachable_set *devfns,
>> +		       bool (*reachable)(struct pci_dev *deva,
>> +					 struct pci_dev *devb))
>> +{
>> +	struct pci_reachable_set todo_devfns = {};
>> +	struct pci_reachable_set next_devfns = {};
>> +	struct pci_bus *bus = start->bus;
>> +	bool again;
>> +
>> +	/* Assume devfn of all PCI devices is bounded by MAX_NR_DEVFNS */
>> +	static_assert(sizeof(next_devfns.devfns) * BITS_PER_BYTE >=
>> +		      MAX_NR_DEVFNS);
>> +
>> +	memset(devfns, 0, sizeof(devfns->devfns));
>> +	__set_bit(start->devfn, devfns->devfns);
>> +	__set_bit(start->devfn, next_devfns.devfns);
>> +
>> +	down_read(&pci_bus_sem);
>> +	while (true) {
>> +		unsigned int devfna;
>> +		unsigned int i;
>> +
>> +		/*
>> +		 * For each device that hasn't been checked compare every
>> +		 * device on the bus against it.
>> +		 */
>> +		again = false;
>> +		for_each_set_bit(devfna, next_devfns.devfns, MAX_NR_DEVFNS) {
>> +			struct pci_dev *deva = NULL;
>> +			struct pci_dev *devb;
>> +
>> +			list_for_each_entry(devb, &bus->devices, bus_list) {
>> +				if (devb->devfn == devfna)
>> +					deva = devb;
>> +
>> +				if (test_bit(devb->devfn, devfns->devfns))
>> +					continue;
>> +
>> +				if (!deva) {
>> +					deva = devb;
>> +					list_for_each_entry_continue(
>> +						deva, &bus->devices, bus_list)
>> +						if (deva->devfn == devfna)
>> +							break;
>> +				}
>> +
>> +				if (!reachable(deva, devb))
>> +					continue;
>> +
>> +				__set_bit(devb->devfn, todo_devfns.devfns);
>> +				again = true;
>> +			}
>> +		}
>> +
>> +		if (!again)
>> +			break;
>> +
>> +		/*
>> +		 * Every new bit adds a new deva to check, reloop the whole
>> +		 * thing. Expect this to be rare.
>> +		 */
>> +		for (i = 0; i != ARRAY_SIZE(devfns->devfns); i++) {
>> +			devfns->devfns[i] |= todo_devfns.devfns[i];
>> +			next_devfns.devfns[i] = todo_devfns.devfns[i];
>> +			todo_devfns.devfns[i] = 0;
>> +		}
>> +	}
>> +	up_read(&pci_bus_sem);
>> +}
>> +EXPORT_SYMBOL_GPL(pci_reachable_set);
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index fb9adf0562f8ef..21f6b20b487f8d 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -855,6 +855,10 @@ struct pci_dynids {
>>   	struct list_head	list;	/* For IDs added at runtime */
>>   };
>>   
>> +struct pci_reachable_set {
>> +	DECLARE_BITMAP(devfns, 256);
>> +};
>> +
>>   enum pci_bus_isolation {
>>   	/*
>>   	 * The bus is off a root port and the root port has isolated ACS flags
>> @@ -1269,6 +1273,9 @@ struct pci_dev *pci_get_domain_bus_and_slot(int domain, unsigned int bus,
>>   struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from);
>>   struct pci_dev *pci_get_base_class(unsigned int class, struct pci_dev *from);
>>   
>> +void pci_reachable_set(struct pci_dev *start, struct pci_reachable_set *devfns,
>> +		       bool (*reachable)(struct pci_dev *deva,
>> +					 struct pci_dev *devb));
>>   enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus);
>>   
>>   int pci_dev_present(const struct pci_device_id *ids);
>> @@ -2084,6 +2091,11 @@ static inline struct pci_dev *pci_get_base_class(unsigned int class,
>>   						 struct pci_dev *from)
>>   { return NULL; }
>>   
>> +static inline void
>> +pci_reachable_set(struct pci_dev *start, struct pci_reachable_set *devfns,
>> +		  bool (*reachable)(struct pci_dev *deva, struct pci_dev *devb))
>> +{ }
>> +
>>   static inline enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
>>   { return PCIE_NON_ISOLATED; }
>>   
>> -- 
>> 2.43.0
>>
> 
For the rest...
Reviewed-by: Donald Dutile <ddutile@redhat.com>


