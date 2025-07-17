Return-Path: <kvm+bounces-52811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 104F4B096E1
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 00:17:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 942F417EE6B
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 22:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C35B923C50E;
	Thu, 17 Jul 2025 22:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TYC72W9G"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B180421A928
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 22:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752790641; cv=none; b=OGPo00/C999b5VYVL/vYKXMkc1nMv1FDDyLE7iVP6vMwZHluGUuw5f9FWiUta2S1weyeU64h4e+tKM+Ped+aUgVuJ6kY/9szJ77R4VsgeCfo4eYNS1ChDEqr35OEq/hb88h82VCZIfEPP4foY53HSCLRTX8IPSalpszHQX+k8Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752790641; c=relaxed/simple;
	bh=58KJnD9NytLGJCW6oBveiJv4eE1/FvtFSAbReU6RBjw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=knHnYVaoyal7HNbv7i5eOs44aGlnB/LGCvJCWaho/hV6IYTWW+idc3OzylNLG+0X8S5HSc6ztqaA8VGJphvu0HIcuplT1kDxDA/NLlIBwc2KIWBHi+Y7ILzye3eky4ljtVUnfACI0oLtXCG2w+KpSWiGBvCE6xtHKgszX6uK+A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TYC72W9G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752790637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k2eLS7DZKuYaKmsCXE04egU2n+sc3hK3vsCJNQUw67k=;
	b=TYC72W9GKBi/+ZJyXy5ITAHGL2YjDS6wy8K3MM4+S0tiXrDApbaYlb8R1hFrjDgCHWMvNb
	z/QIDjcR1mwP6o85Sz7Ge/8z3wJhB0vRy5csqs2thV+0omFoHIBJlcYq1v59pGSdFoniym
	MQvIxe62DFjuI3zWmsEViwMO7rgme9o=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-Uje0xkCNN8epYx17M0GFfQ-1; Thu, 17 Jul 2025 18:17:16 -0400
X-MC-Unique: Uje0xkCNN8epYx17M0GFfQ-1
X-Mimecast-MFC-AGG-ID: Uje0xkCNN8epYx17M0GFfQ_1752790636
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6fb5720eb48so34686296d6.0
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 15:17:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752790636; x=1753395436;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k2eLS7DZKuYaKmsCXE04egU2n+sc3hK3vsCJNQUw67k=;
        b=Vr6EV/xvgWnkCs4tHviq0nZGddgT8FCqTbpVu3QICcz2wRb0MRAoceVoLlzFAhj8fA
         9r53huernYF8wM2vfK95AcqkhWIxv5f63h3nD22pNoP/J1rZH+bT9sleCPwTliSb3dKK
         +RcKlpyARRZd5BJ6w/K7NdVzBceg8yfvcvMIsdu9CWBGST6zxnPISDp6w4uHOlM0OKsK
         5OktS/B22xEDzuIG5g9iduvqbypWXyVj8yuQOfwYoM/a7wiOnphaaErusX0ts5fJygW4
         cKtt9JAaHdqyNYit9BpFrw26UVOjOqPMad+DGWmhRnWi7ow95PxqN4hYImXiiYmFJiyk
         pfBw==
X-Forwarded-Encrypted: i=1; AJvYcCUcexzmDxW/HZ34bM0l7RSqjKonmihMa/9Bj+cdFrJVLyXJjeHkpkaC5tOUvJAAQgDJKNU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzuzMjepJlFCyqdqT9aiCMSSqU0N2xnwFFWHPpRFeggf6IuNFcG
	ZvilfWkEOxQv9fj2gzhdtIL/G7YXl+uiWr5yRmJug6W3/XB9QRMb1bLIgwZhHALgJxH8lx99zAa
	wA50Xit7+BbsGkP5BjcWWxCMzy27dol80Fsv6PAH45e2UCfNb7wzkBQ==
X-Gm-Gg: ASbGncvBd4dN1bFqxQOtWH/FEKokMtq7QUTqI9axS4qD9cfFnfVLvde4d47OQKAOTCe
	DznPHtGKJSuNDbgrnaCRkJ7jHbafxgp8gXeIiM/hTBc9pm+3g2Nwo0kofkHpWHTqXZvS+iRjzPb
	QAJtA7ovoyjuwZW3bkwHDqqywjmY3mZPfBLiIbrBKAdF1zLCLr99UxsVF3sDGKoCitZO5p8nq/a
	qcEgsvfBVaB78TKrSXruZ+/h9adokQHzwrLWYPmZu6HpDrUq9MnUt7vu8YkJQx+l3bQS+6B0hgd
	R1fHrNkPh/XSBMtQEgLwmCktHCRwoKDfogno0fqV
X-Received: by 2002:a05:6214:624:b0:702:c038:af78 with SMTP id 6a1803df08f44-705054fd174mr67554556d6.5.1752790635794;
        Thu, 17 Jul 2025 15:17:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHZdYk1t9nSSqx51KlhXGP3E6Q514XZRXomUyAlPzCL3RWf3fbz0HOn4/LJXtmlAmeSbwBFBw==
X-Received: by 2002:a05:6214:624:b0:702:c038:af78 with SMTP id 6a1803df08f44-705054fd174mr67554116d6.5.1752790635341;
        Thu, 17 Jul 2025 15:17:15 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7051ba8df3fsm857016d6.79.2025.07.17.15.17.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 15:17:14 -0700 (PDT)
Message-ID: <aa84cbc8-6d7e-4e70-887d-b103f2e01a77@redhat.com>
Date: Thu, 17 Jul 2025 18:17:11 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 15/16] PCI: Check ACS DSP/USP redirect bits in
 pci_enable_pasid()
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
References: <15-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <15-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/9/25 10:52 AM, Jason Gunthorpe wrote:
> Switches ignore the PASID when routing TLPs. This means the path from the
> PASID issuing end point to the IOMMU must be direct with no possibility
> for another device to claim the addresses.
> 
> This is done using ACS flags and pci_enable_pasid() checks for this.
> 

So a PASID device is a MFD, and it has ACS caps & bits to check?

> The new ACS Enhanced bits clarify some undefined behaviors in the spec
> around what P2P Request Redirect means.
> 
> Linux has long assumed that PCI_ACS_RR implies PCI_ACS_DSP_MT_RR |
> PCI_ACS_USP_MT_RR | PCI_ACS_UNCLAIMED_RR.
> 
> If the device supports ACS Enhanced then use the information it reports to
> determine if PASID SVA is supported or not.
> 
>   PCI_ACS_DSP_MT_RR: Prevents Downstream Port BAR's from claiming upstream
>                      flowing transactions
> 
>   PCI_ACS_USP_MT_RR: Prevents Upstream Port BAR's from claiming upstream
>                      flowing transactions
> 
>   PCI_ACS_UNCLAIMED_RR: Prevents a hole in the USP bridge window compared
>                         to all the DSP bridge windows from generating a
>                         error.
> 
> Each of these cases would poke a hole in the PASID address space which is
> not permitted.
> 
> Enhance the comments around pci_acs_flags_enabled() to better explain the
> reasoning for its logic. Continue to take the approach of assuming the
> device is doing the "right ACS" if it does not explicitly declare
> otherwise.
> 
> Fixes: 201007ef707a ("PCI: Enable PASID only when ACS RR & UF enabled on upstream path")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/pci/ats.c |  4 +++-
>   drivers/pci/pci.c | 54 +++++++++++++++++++++++++++++++++++++++++------
>   2 files changed, 50 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
> index ec6c8dbdc5e9c9..00603c2c4ff0ea 100644
> --- a/drivers/pci/ats.c
> +++ b/drivers/pci/ats.c
> @@ -416,7 +416,9 @@ int pci_enable_pasid(struct pci_dev *pdev, int features)
>   	if (!pasid)
>   		return -EINVAL;
>   
> -	if (!pci_acs_path_enabled(pdev, NULL, PCI_ACS_RR | PCI_ACS_UF))
> +	if (!pci_acs_path_enabled(pdev, NULL,
> +				  PCI_ACS_RR | PCI_ACS_UF | PCI_ACS_USP_MT_RR |
> +				  PCI_ACS_DSP_MT_RR | PCI_ACS_UNCLAIMED_RR))
>   		return -EINVAL;
>   
>   	pci_read_config_word(pdev, pasid + PCI_PASID_CAP, &supported);
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index d16b92f3a0c881..e49370c90ec890 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -3601,6 +3601,52 @@ void pci_configure_ari(struct pci_dev *dev)
>   	}
>   }
>   
> +
> +/*
> + * The spec is not clear what it means if the capability bit is 0. One view is
> + * that the device acts as though the ctrl bit is zero, another view is the
> + * device behavior is undefined.
> + *
> + * Historically Linux has taken the position that the capability bit as 0 means
> + * the device supports the most favorable interpritation of the spec - ie that
> + * things like P2P RR are always on. As this is security sensitive we expect
> + * devices that do not follow this rule to be quirked.
> + *
> + * ACS Enhanced eliminated undefined areas of the spec around MMIO in root ports
> + * and switch ports. If those ports have no MMIO then it is not relavent.
> + * PCI_ACS_UNCLAIMED_RR eliminates the undefined area around an upstream switch
> + * window that is not fully decoded by the downstream windows.
> + *
> + * This takes the same approach with ACS Enhanced, if the device does not
> + * support it then we assume the ACS P2P RR has all the enhanced behaviors too.
> + *
> + * Due to ACS Enhanced bits being force set to 0 by older Linux kernels, and
> + * those values would break old kernels on the edge cases they cover, the only
> + * compatible thing for a new device to implement is ACS Enhanced supported with
> + * the control bits (except PCI_ACS_IORB) wired to follow ACS_RR.
> + */
> +static u16 pci_acs_ctrl_mask(struct pci_dev *pdev, u16 hw_cap)
> +{
> +	/*
> +	 * Egress Control enables use of the Egress Control Vector which is not
> +	 * present without the cap.
> +	 */
> +	u16 mask = PCI_ACS_EC;
> +
> +	mask = hw_cap & (PCI_ACS_SV | PCI_ACS_TB | PCI_ACS_RR |
> +				      PCI_ACS_CR | PCI_ACS_UF | PCI_ACS_DT);
> +
> +	/*
> +	 * If ACS Enhanced is supported the device reports what it is doing
> +	 * through these bits which may not be settable.
> +	 */
> +	if (hw_cap & PCI_ACS_ENHANCED)
> +		mask |= PCI_ACS_IORB | PCI_ACS_DSP_MT_RB | PCI_ACS_DSP_MT_RR |
> +			PCI_ACS_USP_MT_RB | PCI_ACS_USP_MT_RR |
> +			PCI_ACS_UNCLAIMED_RR;
> +	return mask;
> +}
> +
>   static bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
>   {
>   	int pos;
> @@ -3610,15 +3656,9 @@ static bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
>   	if (!pos)
>   		return false;
>   
> -	/*
> -	 * Except for egress control, capabilities are either required
> -	 * or only required if controllable.  Features missing from the
> -	 * capability field can therefore be assumed as hard-wired enabled.
> -	 */
>   	pci_read_config_word(pdev, pos + PCI_ACS_CAP, &cap);
> -	acs_flags &= (cap | PCI_ACS_EC);
> -
>   	pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
> +	acs_flags &= pci_acs_ctrl_mask(pdev, cap);
>   	return (ctrl & acs_flags) == acs_flags;
>   }
>   


