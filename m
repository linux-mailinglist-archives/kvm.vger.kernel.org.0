Return-Path: <kvm+bounces-52808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D140AB096C7
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 00:07:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A0B3581267
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 22:07:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9E3123D289;
	Thu, 17 Jul 2025 22:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d8oTeNxd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7927723AB85
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 22:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752790034; cv=none; b=FzdbNR6JP9eTvLnYxjtb4EXigZ4GfpI+tOQcF6VXTyDtoBebHkJWGIFM9QA3pZL1SCA34y70KxODSCOcPWK//sR80KLDoTpPmbgyR6Zf3sLj6RlfVukQ6qkVsXMCX2Osw6o+FuHgoNdgm9NwkIS179uu0pEVAJhsN4PSv3lBDM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752790034; c=relaxed/simple;
	bh=EG+lJKnf2Bs5h5ukGDK7/JBBSQzQipiVsWFvQtRbYIw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cm72z4sHhlwupeaDWtb2JfB2ZDoQGVQ/V5+fUZVk9m+JifqzsE7W2SBaFHjRXYbVyqGSPE7jvZ4UzgzLAHhuyzBlWrDqnAudjcUPxMqvtDqh1XayP5HLnI7OfGc2WlFf8SWf6Oduk7cBdA0O+jRF9p6y0e+jPS0EarlIP5QunxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d8oTeNxd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752790031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6/7LIzWGZTHEMGcMK+WE53GZ9j5TSEz1spH81A3VRh8=;
	b=d8oTeNxd+Uk2hCvH63D0frcG9Ta3qIC6TQ/tI10CI4edGYmC3QkdHgikX7DYISGvwNJdQU
	tRcVegUE+CqEbTJduD8pqMWNeg/YgFOAUEYqhiMYm+84TzMgkYZWMVFEtVVzrE2lbaf6bU
	c44H+aw/kLNTLqiYeU0Yd/w54WwddnM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-Tmt--fd3MWe4wEf_8iJpgA-1; Thu, 17 Jul 2025 18:07:09 -0400
X-MC-Unique: Tmt--fd3MWe4wEf_8iJpgA-1
X-Mimecast-MFC-AGG-ID: Tmt--fd3MWe4wEf_8iJpgA_1752790029
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7e338e627f1so385469685a.0
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 15:07:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752790029; x=1753394829;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6/7LIzWGZTHEMGcMK+WE53GZ9j5TSEz1spH81A3VRh8=;
        b=A3dBjsSn+uk3+UV/bwleNLoM6EtNUJnMnRA5ZnKERP4Pwrod6yqU4MEFzTZdD3th4b
         /ZEAxO6mTalA0603YDIPxmYcAVCK3djUbDkttFXVgPCgg3onQxVJfyxTU6YxZQmuHhLB
         k9U7bxqtgf/qK5dzobRaQwDnCsmS2PDno7kmKMfJKSW6tDAvFYGv2CdTYAJxQMEIyu3R
         yB5ua52G9pFICUlGPmIzX9uJoIJWggoBsFb1IUQYAci9oH2raBomYBmIft5QDVKIg0jf
         QwZyYjvw3lJF0twJ93UGeP/rfnWUaHBR6Op0/rhqFjcnx8SpAyHQmHDM4HeJD5RC6eWp
         oDcw==
X-Forwarded-Encrypted: i=1; AJvYcCU8ECxqeAaTpwFw7qmmV+61+Rdyzn8P4PJ7jHKptNs+KbNJ9S3KFqw/d/TavrH2jQscgM0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWx8FZ3BF0wI3P/mkdMSRNRo8sRs6r5n8wHdv6kEZ8vYqFLpFY
	yJuKsm4WdChMF6GnmbUXI0QDjtFUDPlQ4tIjQxuvDkWgW8tN/7Lo/mqDu8KziisWjnWZ4oqD4UB
	fSXVl7042n3Zbd9V67z1nURn6K3SJl0StE6FbSaA/eiWZwDs38FGCVw==
X-Gm-Gg: ASbGncuC99Auhx/CGOmxTWiagcV/+ThUmVynx5bq9CXDP+qoWs98XkfbJBtMjij+Swa
	UVwFzeyCB4DhyLNNJOxyGkvpHKjk28gVkAoxSGHYaslubef87s6aE+tQApQFmy9zmTMByqqAHL6
	iN6YHTAOtKAwzYqTYk4Geuv3MuzNpttksVT+Y3RSsgkPjVKL7eZe763SNyraQtgh2oXWgkq4mb9
	P5xM3SBJJb6EbzThBD5nxop0c4nOiCM76kZbYas1lCaRQ/PuNww08F91sH2y7CLMbIA8dEtoT6k
	SRxFJ8/sb7pR0iAX99ewUCXI4TvIhtAe7SMN9UJb
X-Received: by 2002:a05:620a:1a8d:b0:7d4:6123:fae0 with SMTP id af79cd13be357-7e356b058a6mr86371585a.44.1752790028588;
        Thu, 17 Jul 2025 15:07:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHbseTo+gO4cZxdtMq5RbINML3GgRZjSc2b9jj9nPnFlA7otH7sfkPnFo9zj9g7oUpzhXsLAg==
X-Received: by 2002:a05:620a:1a8d:b0:7d4:6123:fae0 with SMTP id af79cd13be357-7e356b058a6mr86365585a.44.1752790027957;
        Thu, 17 Jul 2025 15:07:07 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e356b28a7esm17195285a.19.2025.07.17.15.07.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 15:07:07 -0700 (PDT)
Message-ID: <e951d3a6-faa6-44e5-a3c4-19bfd20782ee@redhat.com>
Date: Thu, 17 Jul 2025 18:07:05 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/16] iommu: Validate that pci_for_each_dma_alias()
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
References: <12-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <12-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/9/25 10:52 AM, Jason Gunthorpe wrote:
> Directly check that the devices touched by pci_for_each_dma_alias() match
> the groups that were built by pci_device_group(). This helps validate that
> pci_for_each_dma_alias() and pci_bus_isolated() are consistent.
> 
> This should eventually be hidden behind a debug kconfig, but for now it is
> good to get feedback from more diverse systems if there are any problems.
> 
+1 ... good idea!

> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/iommu.c | 73 ++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 72 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index cd26b43916e8be..e4ae1d064554e4 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1606,7 +1606,7 @@ static struct iommu_group *pci_hierarchy_group(struct pci_dev *pdev)
>    *     Once a PCI bus becomes non isolating the entire downstream hierarchy of
>    *     that bus becomes a single group.
>    */
> -struct iommu_group *pci_device_group(struct device *dev)
> +static struct iommu_group *__pci_device_group(struct device *dev)
>   {
>   	struct pci_dev *pdev = to_pci_dev(dev);
>   	struct iommu_group *group;
> @@ -1713,6 +1713,77 @@ struct iommu_group *pci_device_group(struct device *dev)
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
> +	struct iommu_group *group = __pci_device_group(dev);
> +
> +	if (!IS_ERR(group)) {
> +		struct check_group_aliases_data data = {
> +			.pdev = to_pci_dev(dev), .group = group
> +		};
> +
> +		/*
> +		 * The IOMMU driver should use pci_for_each_dma_alias() to
> +		 * figure out what RIDs to program and the core requires all the
> +		 * RIDs to fall within the same group. Validate that everything
> +		 * worked properly.
> +		 */
> +		pci_for_each_dma_alias(data.pdev, pci_check_group_aliases,
> +				       &data);
> +	}
> +	return group;
> +}
>   EXPORT_SYMBOL_GPL(pci_device_group);
>   
>   /* Get the IOMMU group for device on fsl-mc bus */


