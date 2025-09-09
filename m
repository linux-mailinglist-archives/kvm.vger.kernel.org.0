Return-Path: <kvm+bounces-57044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90AF7B4A100
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 07:00:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 356D24E238B
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 05:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C4BA1D6BB;
	Tue,  9 Sep 2025 05:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PG/Qj//y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81B21798F
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 05:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757394018; cv=none; b=JMnnzKLvfI1UatyaZadcoWlyp2KV3Em2lH4vQl6D/OdIlxxLpAqlbrJY9Fc9bs7Fpj9ItBFOoEqzZqe56TdbPsFPzxfT0SpNs5LKGsnVN/EK+GDuHISUy5d9ZDaDyi3W64v3SPkTfA3ksgABspSuDieMQrO29o9R0lLrMelvStw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757394018; c=relaxed/simple;
	bh=1oxzIB+Bq27heH7UqJ7HD5sfAeymQ9opp8zaJLFAIQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fhjBfIrGfjbYakiGGVrWGb47sW9N241CbuNqOuO4aviEQ3yRfpy1ng+OSaWq/V6Fk1UdyQqXNxWrHHzF8X7DsKCTgy8LbRXLjwjU3FYztR7kdyxtB8Whaxe7w429txPq88fQYo+8sXpnBlCQIY9K/QWPdzQLpcmqlhxPmJTlAd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PG/Qj//y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757394014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D6iQxBUowgZS1gNMSIU064JFfiN2wIaCl+0CSNLdzGc=;
	b=PG/Qj//yinAG03rvljA8Sr1zSnRnT0dDT80uq1jOZNvkM/il58OaUhmOOAzb7FFZ6ugbqE
	Cwna7qunTHhA3LShD2UI7DC32pYA3eoduLydaDWZ/ylg3Ia5lsH4SomCGWInHXgrR440AU
	LMxYO/tqkMNLxsb82iZfHzKbfaxSUDo=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-6vaQwfekNCC7WX32qyiM2w-1; Tue, 09 Sep 2025 01:00:13 -0400
X-MC-Unique: 6vaQwfekNCC7WX32qyiM2w-1
X-Mimecast-MFC-AGG-ID: 6vaQwfekNCC7WX32qyiM2w_1757394012
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-72e83eb8cafso82109386d6.2
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 22:00:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757394012; x=1757998812;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D6iQxBUowgZS1gNMSIU064JFfiN2wIaCl+0CSNLdzGc=;
        b=hFZznVc6dcDOG4v1S+pOps/rFpdKkeQj390jFcC2Hw20IAOWkZ+3D+1WM0FlCKTsqq
         WGArKL5vwh18qOYzjbeLsdNvGUB5UqS25huPU941tM73u3lfioAV2zpsV4B+lvUU8hLx
         LGUP7slfjYw278hIaw3iFZP+DF9VNeCld6LxIvk49xugW/NRIibCt0CxI4rYyU3B52xg
         k/yRq38XAWt9uynXgQxv1LoRuFEbem36dFgongIyas+8JstQ05I/1EH8VSfof6UgW6LN
         ar1wXfgjdk696iqlVNibYpnqQSaZLEdPa0GPusMTZ7c1aXSPnDIGBgGPOPV3k/GdcsnV
         URNw==
X-Forwarded-Encrypted: i=1; AJvYcCUf4Im/w3DcVENWqCqtJqxqfh7wjT/4a6uQ4fQlkmCsY5dzDol0gbdB5SJbTMw54N8w80g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCXA8FmXTm8HrKi/BoNP0hPVH2ZrklrU5sWhPN1qMh3TMVl2pP
	qSikL5m7hkbzBBM7bzE3+xK/IK/O+GozijGrl+zBMEcMOdm3pIgkVEHJdBscMj6WNXuo398QZMe
	GGx8JwHMsy039koreL3EsUnS/nj7IS0GFr37YpKPN1v4Dz4aSc+kV2g==
X-Gm-Gg: ASbGncvxF5RkmLXpjNBEboE6jP95TYlsIq7nBYxBVQXIgSDrSUs4/qU7U/kzz7tEc8D
	w59YuohqTd/LMTSLOMapJkBozqJhGfoZahTmZxivu2v5AcIjbldPpAHsbWMSIwfJiDmTIJS9bBq
	w/Iqi9D224hrinl2OdtwsL8AJTh9SAD7UVhy8hDkZpK/+kkBtybh372AkC+EswoFinQcRqwZ/0b
	tsSmJNvPWSS3J78RGi+D19/HhG2WoZwgxcbdLopVTCj1WTPybGauPnegzes91LbUnPKxyknyqJF
	sOJSgGQVwaFGFOja6juvtDFxXyOpWp0xtJe93MW3
X-Received: by 2002:a05:6214:20a1:b0:749:a12b:2d58 with SMTP id 6a1803df08f44-749a12b2f2cmr61919916d6.60.1757394012286;
        Mon, 08 Sep 2025 22:00:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbhlr0VwTq4d+7yg1kvRuLY1QCWsGq5tYaJVVe3wMI23DU+9UPnzZF9LjoX5cUPqjAsHKB1w==
X-Received: by 2002:a05:6214:20a1:b0:749:a12b:2d58 with SMTP id 6a1803df08f44-749a12b2f2cmr61919636d6.60.1757394011771;
        Mon, 08 Sep 2025 22:00:11 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-725dda254d4sm118146646d6.8.2025.09.08.22.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 22:00:11 -0700 (PDT)
Message-ID: <9487fde9-ec40-4383-aafe-7ae0811830f5@redhat.com>
Date: Tue, 9 Sep 2025 01:00:08 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/11] iommu: Validate that pci_for_each_dma_alias()
 matches the groups
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <7-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <7-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/5/25 2:06 PM, Jason Gunthorpe wrote:
> Directly check that the devices touched by pci_for_each_dma_alias() match
> the groups that were built by pci_device_group(). This helps validate that
Do they have to match, as in equal, or be included ?

> pci_for_each_dma_alias() and pci_bus_isolated() are consistent.
> 
> This should eventually be hidden behind a debug kconfig, but for now it is
> good to get feedback from more diverse systems if there are any problems.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/iommu.c | 76 ++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 75 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index fc3c71b243a850..2bd43a5a9ad8d8 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1627,7 +1627,7 @@ static struct iommu_group *pci_hierarchy_group(struct pci_dev *pdev)
>    *     Once a PCI bus becomes non isolating the entire downstream hierarchy of
>    *     that bus becomes a single group.
>    */
> -struct iommu_group *pci_device_group(struct device *dev)
> +static struct iommu_group *__pci_device_group(struct device *dev)
>   {
>   	struct pci_dev *pdev = to_pci_dev(dev);
>   	struct iommu_group *group;
> @@ -1734,6 +1734,80 @@ struct iommu_group *pci_device_group(struct device *dev)
>   	WARN_ON(true);
>   	return ERR_PTR(-EINVAL);
>   }
> +
> +struct check_group_aliases_data {
> +	struct pci_dev *pdev;
> +	struct iommu_group *group;
> +};
> +
> +static void pci_check_group(const struct check_group_aliases_data *data,
> +			    u16 alias, struct pci_dev *pdev)
> +{
> +	struct iommu_group *group;
> +
> +	group = iommu_group_get(&pdev->dev);
> +	if (!group)
> +		return;
> +
> +	if (group != data->group)
> +		dev_err(&data->pdev->dev,
> +			"During group construction alias processing needed dev %s alias %x to have the same group but %u != %u\n",
> +			pci_name(pdev), alias, data->group->id, group->id);
> +	iommu_group_put(group);
> +}
> +
> +static int pci_check_group_aliases(struct pci_dev *pdev, u16 alias,
> +				   void *opaque)
> +{
> +	const struct check_group_aliases_data *data = opaque;
> +
> +	/*
> +	 * Sometimes when a PCIe-PCI bridge is performing transactions on behalf
> +	 * of its subordinate bus it uses devfn=0 on the subordinate bus as the
> +	 * alias. This means that 0 will alias with all devfns on the
> +	 * subordinate bus and so we expect to see those in the same group. pdev
> +	 * in this case is the bridge itself and pdev->bus is the primary bus of
> +	 * the bridge.
> +	 */
> +	if (pdev->bus->number != PCI_BUS_NUM(alias)) {
> +		struct pci_dev *piter = NULL;
> +
> +		for_each_pci_dev(piter) {
> +			if (pci_domain_nr(pdev->bus) ==
> +				    pci_domain_nr(piter->bus) &&
> +			    PCI_BUS_NUM(alias) == pdev->bus->number)
> +				pci_check_group(data, alias, piter);
> +		}
> +	} else {
> +		pci_check_group(data, alias, pdev);
> +	}
> +
> +	return 0;
> +}
> +
> +struct iommu_group *pci_device_group(struct device *dev)
> +{
> +	struct check_group_aliases_data data = {
> +		.pdev = to_pci_dev(dev),
> +	};
> +	struct iommu_group *group;
> +
> +	if (!IS_ENABLED(CONFIG_PCI))
> +		return ERR_PTR(-EINVAL);
> +
> +	group = __pci_device_group(dev);
> +	if (IS_ERR(group))
> +		return group;
> +
> +	/*
> +	 * The IOMMU driver should use pci_for_each_dma_alias() to figure out
> +	 * what RIDs to program and the core requires all the RIDs to fall
> +	 * within the same group. Validate that everything worked properly.
> +	 */
> +	data.group = group;
> +	pci_for_each_dma_alias(data.pdev, pci_check_group_aliases, &data);
> +	return group;
> +}
>   EXPORT_SYMBOL_GPL(pci_device_group);
>   
>   /* Get the IOMMU group for device on fsl-mc bus */


