Return-Path: <kvm+bounces-52792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E8FC1B094F8
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 21:25:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CE753AE139
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 19:25:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A2112FC3C9;
	Thu, 17 Jul 2025 19:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nz/+92uI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1992EBDD0
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 19:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752780343; cv=none; b=aRscKrOkWQy3XG8XF7SRE4i0+tBoNsM99740p5ZWmKP15jfzsuCLuc25JrHTkt2IODlmcP0og7txqn4KFKSEvn/tkYOpuGv2qqq2MjSu8CvzrAAGHkv34eGt/ZjYh7S6jytiLUj17MTSbTZ4empzEPvOQXgt93SWNfNFIVPna7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752780343; c=relaxed/simple;
	bh=02CBJpA30ZmYUrtaYuKhiq5fm/WwvrZXQ7YWNnmbFHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UyQFPCUHOiabiTwvaieIDPqPM+FGv0IVXG9xmlOWm3eRbsuegdOGN7oTTgJ/jKtVgDgce2tXKncbiVASFDGdfM0jUyLz9b5U4SU1lt7BY789CMN5qKaZELh60LRnKYAtIM8q7pIL78zra7CHjwlPXaFD0Gnmr6HEqTnNB5aeF4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nz/+92uI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752780341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7cjM6leMNWJaFyvB8pUYw1XsGkeqyh24r2b2Mr0FYMs=;
	b=Nz/+92uIUhJt2HaC2XEF397dllZTerlkuD9MHzMUkuDTSoRiqMQJNSt+BOEMMxSzQFqp/M
	OIE57t4E4TAmeUlkDwAM+RpmcAp0EihsoazzLfIBiZaZBRicIEW11jXf9BfdRQveoQThu1
	9YUBjakjCcgO9+SADlPC2J/M77f21kc=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-a3FMxjQlOLK3GrcVDbQuEg-1; Thu, 17 Jul 2025 15:25:40 -0400
X-MC-Unique: a3FMxjQlOLK3GrcVDbQuEg-1
X-Mimecast-MFC-AGG-ID: a3FMxjQlOLK3GrcVDbQuEg_1752780339
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6fad8b4c92cso32584196d6.0
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 12:25:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752780339; x=1753385139;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7cjM6leMNWJaFyvB8pUYw1XsGkeqyh24r2b2Mr0FYMs=;
        b=SYm/JO3flysAK4/CvswmiXRxcVIAq8WfUhE++r7abBPIAhD84K2hefVYKd+qWgG8io
         6qV12ovr4cYzw05QVuUxnLRGyBHK+7s/slZg0EfJHvAQ3/2K/N191lQfb0NYRTXbPM1+
         w60ORbxTQqPQtGnEB86aU1YZSwpqCH7603xB1DSH2p4ybLLpeHyFvltqjPyfBK32LUtQ
         PGgm336zSzO4J8zQFy/Qtc7+RszgBkQCUkC87g0Hb3EPy0/LfH1CTdov1ZAi2Yb66j8Y
         QCi3yEC7L86+cV2EK1mrCsWnZYGuxjMaRIa4aD6nlVsFX7YfkCmGA+NjarIFDHXLChiK
         0bQg==
X-Forwarded-Encrypted: i=1; AJvYcCU3WnWOnEEoIRnzrpET6FnnMHoSU91tjpOsSi7gBDjBP6ipEA6gUm0GbFeU2sj5IJ/2NhM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw23/DarB23Us3HiKdsNBUff0nN9FgRbWGBMJIHVuqQGbRPzJSe
	pN8oIK+3S/NiV0IASQLWpgw6g5qlyErMJ/UKwehiGFr3qT7l480Z4IK4CgpOUBicCASbLZ82ao4
	nWsgmLHU1g/7mPX9AfJic8eqLbelusHKMQp7Cm1/7qtO2TjNKbSG3Dg==
X-Gm-Gg: ASbGncseYevG4ZGzD42Vxo2j1e5PPZRSO92wbAAE/OiP6WgETFmCzu0Z0/Y3fRRYpZK
	yRLg4UGj7N3x+aKWnv+4B8RqkPa4ALtu1ui40uS3BVDVcFmHjUrgaUIIZ84vtXimIT9s0VppoWm
	Q75T/0jkYzh1K9H5JlAynTohOHkbGUy0flpeJ4QyHvGDNq285chIopxkskHEkPzMlfABhjX1aCv
	HFWAjP+V5+eqml9zIfsCJbuT6AacHdcLS7TNgzYXVLpEUffqUM5YieTtwei16BgpGcrq3sAFusZ
	/3+7xBNOChBUC5kUXwNuGp8xbjMKVD1zJikPcFl8
X-Received: by 2002:a05:6214:3d0f:b0:704:a0be:87e9 with SMTP id 6a1803df08f44-7051a114f9bmr2753546d6.27.1752780339394;
        Thu, 17 Jul 2025 12:25:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnouXokKlyOlp4XW8RUcaaVzppnw9rpmDfmEo0M//qCUQGk6pO2DfCJ8LdT9+rTbiA9leEEA==
X-Received: by 2002:a05:6214:3d0f:b0:704:a0be:87e9 with SMTP id 6a1803df08f44-7051a114f9bmr2752986d6.27.1752780338822;
        Thu, 17 Jul 2025 12:25:38 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-704979b48bdsm88133626d6.28.2025.07.17.12.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 12:25:38 -0700 (PDT)
Message-ID: <c05104a1-7c8e-4ce9-bfa3-bcbc8c9e0ef5@redhat.com>
Date: Thu, 17 Jul 2025 15:25:35 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <20250701132905.67d29191.alex.williamson@redhat.com>
 <20250702010407.GB1051729@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250702010407.GB1051729@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/1/25 9:04 PM, Jason Gunthorpe wrote:
> On Tue, Jul 01, 2025 at 01:29:05PM -0600, Alex Williamson wrote:
>> On Mon, 30 Jun 2025 19:28:33 -0300
>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>>> index d265de874b14b6..f4584ffacbc03d 100644
>>> --- a/drivers/iommu/iommu.c
>>> +++ b/drivers/iommu/iommu.c
>>> @@ -65,8 +65,16 @@ struct iommu_group {
>>>   	struct list_head entry;
>>>   	unsigned int owner_cnt;
>>>   	void *owner;
>>> +
>>> +	/* Used by the device_group() callbacks */
>>> +	u32 bus_data;
>>>   };
>>>   
>>> +/*
>>> + * Everything downstream of this group should share it.
>>> + */
>>> +#define BUS_DATA_PCI_UNISOLATED BIT(0)
>>
>> NON_ISOLATED for consistency w/ enum from the previous patch?
> 
> Yes
> 
>>> -	/* No shared group found, allocate new */
>>> -	return iommu_group_alloc();
>>> +	switch (pci_bus_isolated(pdev->bus)) {
>>> +	case PCIE_ISOLATED:
>>> +		/* Check multi-function groups and same-bus devfn aliases */
>>> +		group = pci_get_alias_group(pdev);
>>> +		if (group)
>>> +			return group;
>>> +
>>> +		/* No shared group found, allocate new */
>>> +		return iommu_group_alloc();
>>
>> I'm not following how we'd handle a multi-function root port w/o
>> consistent ACS isolation here.  How/where does the resulting group get
>> the UNISOLATED flag set?
> 
> Still wobbly on the root port/root bus.. So the answer is probably
> that it doesn't.
> 
> What does a multi-function root port with different ACS flags even
> mean and how should we treat it? I had in mind that the first root
> port is the TA and immediately goes the IOMMU.
> 
I'm looking for clarification what you are asking...

when you say 'multi-function root port', do you mean an RP that is a function
in a MFD in an RC ?  other?  A more explicit (complex?) example be given to
clarify?

IMO, the rule of MFD in an RC applies here, and that means the per-function ACS rules
for an MFD apply -- well, that's how I read section 6.12 (PCIe 7.0.-1.0-PUB).
This may mean checking ACS P2P Egress Control.  Table 6-11 may help wrt Egress control bits & RPs & Fcns.

If no (optional) ACS P2P Egress control, and no other ACS control, then I read/decode
the spec to mean no p2p btwn functions is possible, b/c if it is possible, by spec,
it must have an ACS cap to control it; ergo, no ACS cap, no p2p capability/routing.

- Don
> If you can explain a bit more about how you see the root ports working
> I can try to make an implementation.
> 
> AFAICT the spec sort of says 'implementation defined' for ACS on root
> ports??
> 
> Thanks,
> Jason
> 


