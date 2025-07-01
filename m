Return-Path: <kvm+bounces-51211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D886AF03C6
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 21:29:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 122C81C20E7A
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 19:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EB21283C89;
	Tue,  1 Jul 2025 19:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HUejPZFE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1835283130
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 19:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751398154; cv=none; b=UW/bE/uaDcV11cnWOPtQPJTtJsn3/sZOFyRq8O9gvcfwI9W4PzcSTRhzLn01qAb65MwVBBaDlAEJQaGTCDZPOuZgxuBjlxaFIfWhGdw1LAvWdEpb073uK5oykir0DozoYab9TvymnVtx96HYu9YGvlQa6J9pSQeSVfZAzuJ1VwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751398154; c=relaxed/simple;
	bh=Der6lHkCC98no1Vn4NQll5rTYBWXTKnaq2KSJ3XTARI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QuzYXHKj46NKwVK7hrKV2eFEy2r1C6IDPKVoqxv78VAJw6jGTog6L3BOhcjWEwAIx1TAuinUDYic2KdG+FENrpg/Z6mN7MzS0BFatZP9P2tvJBEY5QRx17YYupUspXx/knAbXbuNxb0g/CNrCN+KvTVRh0Scyf9CLsS/dI/58BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HUejPZFE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751398152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mjTFqfwrz80T+KU/Vvx3G5r4It+9k632M4DI6S0TxZ8=;
	b=HUejPZFEVuVnejLQENzauU6/KTD61rgpRaOVrqx7vdlvLD9nezKwPZ2kUF12fr8YaSVYvf
	a8M/pCf5XHgXxzwhkKa82z1mFRWqqlpI/FOykTFE6NT8HzZau3S2IVI3516kqYyF+Ulpy8
	7xdp+g+IrkW4Fq2IwYVSj3jH8i8mPvY=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-160-9dE_cK5oMier-sVYgXljpg-1; Tue, 01 Jul 2025 15:29:10 -0400
X-MC-Unique: 9dE_cK5oMier-sVYgXljpg-1
X-Mimecast-MFC-AGG-ID: 9dE_cK5oMier-sVYgXljpg_1751398150
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-739f16f11b3so146282a34.0
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 12:29:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751398149; x=1752002949;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mjTFqfwrz80T+KU/Vvx3G5r4It+9k632M4DI6S0TxZ8=;
        b=iIXe0p//8SSp2RsjcZ5gvcQLpbYI15mbAyJ6+HjkFw8UTGkY8Iq+d2/ZSzy/Q4ElNX
         6jNnwYMaq5WMb+xTXTWLFkuu986c5w7207JmiKqrACO1MBBYqg+8euAQWxqIuA3vyIk0
         lFtB3hwxFXmssww60PJi8Lv7FGPdrAHK6xAUJDBg/QUWEcAf1tVa2vXg9RBs34AyL0Sg
         D5F6GJ83ozYaygOczQDt14rKDbuW+DEXTRx0S/44mdZrZ4DHI5lvwzckjROgAbJ2j9j2
         NYQY2RrUffzpZntAHv4s+UcM4jzU08uwh9mZFvfkirgLsNYzs9o39wYCc+CJKOdOFwHQ
         rzTg==
X-Forwarded-Encrypted: i=1; AJvYcCXOfHNJS50D3Pn7gNdYG7Jh+IkaVu8nEl7zdnKWkS61GEMv2t/khn2dCmxb3qLVpWbTy3Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeZspPkdn/LUP37BcL+tlSg1G+h/iDldmePPubFa4b7zPkaHFG
	9LD3U8qcdY1Wg1sHNH2L9THsed2Wbfmt3Cfbzy86LGg566R5hbNtkNadyRwv3EjGycy3+tHG1C9
	GhbLDIn3mL/If0dV7HwXiBh/GtQQ9zHPUwMdex3FqroOzEbl6LJHoFg==
X-Gm-Gg: ASbGncuD3lby1/k4hMQ+kLVGnrBUo9GlRXWdCW3Yfz7pHciprjnVUHASlcXlbtvX22U
	VTE41IR+mh0OCj4J+u7gbeEr35sfzHVTLfbj06RlO/rBuGnv7nK1XEJ50R7lgWOPMoRuqMmiY+Z
	evx0kTIJ9kUmGP9qyUOVgdqd2zH7EkoO8VDM2iQSLsKC20vpnNYMcAFPBFK0GJnDwqVYFw7VExc
	C2RXrWOORLN7k2+AJLEKWsRKicdNLaJ3RsJhzyXpx4iPnrxhcKQRUmnlt8QxD7DHM6EXgnGco6C
	Q6YRvcpNuD8MZzclbIJPOcaynQ==
X-Received: by 2002:a05:6808:2217:b0:401:f524:a97d with SMTP id 5614622812f47-40b7b0a8707mr1196641b6e.4.1751398149414;
        Tue, 01 Jul 2025 12:29:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAidfeboIYE5QUTm/6yW8HPYX8OflJWQclvBEIzO4DlJkq5XCLurirKOmJEIcC02wo+DFNcg==
X-Received: by 2002:a05:6808:2217:b0:401:f524:a97d with SMTP id 5614622812f47-40b7b0a8707mr1196629b6e.4.1751398149030;
        Tue, 01 Jul 2025 12:29:09 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-40b322c1e25sm2242252b6e.20.2025.07.01.12.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 12:29:07 -0700 (PDT)
Date: Tue, 1 Jul 2025 13:29:05 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev, Joerg Roedel
 <joro@8bytes.org>, linux-pci@vger.kernel.org, Robin Murphy
 <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, Lu Baolu
 <baolu.lu@linux.intel.com>, galshalom@nvidia.com, Joerg Roedel
 <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
 maorg@nvidia.com, patches@lists.linux.dev, tdave@nvidia.com, Tony Zhu
 <tony.zhu@intel.com>
Subject: Re: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Message-ID: <20250701132905.67d29191.alex.williamson@redhat.com>
In-Reply-To: <3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 30 Jun 2025 19:28:33 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index d265de874b14b6..f4584ffacbc03d 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -65,8 +65,16 @@ struct iommu_group {
>  	struct list_head entry;
>  	unsigned int owner_cnt;
>  	void *owner;
> +
> +	/* Used by the device_group() callbacks */
> +	u32 bus_data;
>  };
>  
> +/*
> + * Everything downstream of this group should share it.
> + */
> +#define BUS_DATA_PCI_UNISOLATED BIT(0)

NON_ISOLATED for consistency w/ enum from the previous patch?

...
> +struct iommu_group *pci_device_group(struct device *dev)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct iommu_group *group;
> +	struct pci_dev *real_pdev;
> +
> +	if (WARN_ON(!dev_is_pci(dev)))
> +		return ERR_PTR(-EINVAL);
> +
> +	/*
> +	 * Arches can supply a completely different PCI device that actually
> +	 * does DMA.
> +	 */
> +	real_pdev = pci_real_dma_dev(pdev);
> +	if (real_pdev != pdev) {
> +		group = iommu_group_get(&real_pdev->dev);
> +		if (!group) {
> +			/*
> +			 * The real_pdev has not had an iommu probed to it. We
> +			 * can't create a new group here because there is no way
> +			 * for pci_device_group(real_pdev) to pick it up.
> +			 */
> +			dev_err(dev,
> +				"PCI device is probing out of order, real device of %s is not probed yet\n",
> +				pci_name(real_pdev));
> +			return ERR_PTR(-EPROBE_DEFER);
> +		}
> +		return group;
> +	}
> +
> +	if (pdev->dev_flags & PCI_DEV_FLAGS_BRIDGE_XLATE_ROOT)
> +		return iommu_group_alloc();
> +
> +	/* Anything upstream of this enforcing non-isolated? */
> +	group = pci_hierarchy_group(pdev);
>  	if (group)
>  		return group;
>  
> -	/* No shared group found, allocate new */
> -	return iommu_group_alloc();
> +	switch (pci_bus_isolated(pdev->bus)) {
> +	case PCIE_ISOLATED:
> +		/* Check multi-function groups and same-bus devfn aliases */
> +		group = pci_get_alias_group(pdev);
> +		if (group)
> +			return group;
> +
> +		/* No shared group found, allocate new */
> +		return iommu_group_alloc();

I'm not following how we'd handle a multi-function root port w/o
consistent ACS isolation here.  How/where does the resulting group get
the UNISOLATED flag set?

I think that's necessary for the look-back in pci_hierarchy_group(),
right?  Thanks,

Alex


