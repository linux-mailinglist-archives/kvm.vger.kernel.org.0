Return-Path: <kvm+bounces-57048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2135B4A119
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 07:04:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E4973B5119
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 05:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45CAF2EBB89;
	Tue,  9 Sep 2025 05:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eSm37yw9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E56147C9B
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 05:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757394265; cv=none; b=of4Af0ZfUBEoFAt2zxBQKVUMkfVENySqh46lFx8H11SMC+VdlDmxSmOTy+AxOpTJ0CbPrIeJ0LhOcCQ+lP7XXWjlkWALDUzUPuG0tbVmjZcbVw6/axcjogozHrDFsZy4NqvFOZAMuBdKiAQ5kRlhUtl7dofZBa9ylFyO3yS+Fxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757394265; c=relaxed/simple;
	bh=WRKEjVB88UyDSuQnn2M8CsE1PKosjlo1Gos8s6oIScU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rurwWaXjBQHiPEXwdhHCPH3R85whcRGvrTbzU+cnrFwz9dJT/3GeBBQgpOosUwCi+8XzSBBPkQrP4JMZiqJdIm/+kYRRMl+QK1ROcY8+r7CpqpJoQcvK2akR56y3BHeAXc9tq7PQqFphQtSfQHjtGHJQIZRA3sL6QtdY5YQjwKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eSm37yw9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757394262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wr2ePTIKgu+dXGPmYEIQm5pOk8ImaQGQj8O0LKwZ6pU=;
	b=eSm37yw9NOpsyoundLVopN2CaT50Q0JxrKMxqrSx5VTjO5ldAcrQsD0BAO4S2/sCL2lI6r
	FUYXXE9kALTPlS6190Ed1ic3fAlXRQZUxsxqgDhRJRtV2ChfHbLJwiPlvJB4454wJ+B4dM
	lMUEEWNp7a0uuTzQ5EZFsILV6SAIoSk=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-Qf2XM5-vPOu5AXRGJ-1Cww-1; Tue, 09 Sep 2025 01:04:21 -0400
X-MC-Unique: Qf2XM5-vPOu5AXRGJ-1Cww-1
X-Mimecast-MFC-AGG-ID: Qf2XM5-vPOu5AXRGJ-1Cww_1757394260
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-81b8e3e29edso56483885a.0
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 22:04:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757394260; x=1757999060;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wr2ePTIKgu+dXGPmYEIQm5pOk8ImaQGQj8O0LKwZ6pU=;
        b=mA4/4VQgiI6nZKEtP42UpC+qVqusNfpEBkanIi2bVQa6D5o6/8GG8dFwx+L7VGF0JU
         yWX/X+HE1gBwdpGPyD2mJldZa+q80ojoulHBh2BJ9pHZF9wDygW2VTCPu6rOocd4lC3h
         iNe1IOmKJqAI5TuTUex9zfkBn5ilepvQzS1UtOBE0oqAsMTNfohBg19uxRjluqxnzfrt
         dd3bfeCBZkYDS0Bxbu+aEYkq8LR2JEV9PPKKn98VC8hiO0rmzFlwIUJVeTn7Kz7FTMoL
         Mm+aj8OLiniREewbCSXXG4wW1IA4M1a9D85uHTbo16Wm3YpyxdyhgbSNuqFYamnmTxnf
         cOsw==
X-Forwarded-Encrypted: i=1; AJvYcCUyJYJNcSjKCBsbc6TVe+OUG4UU3gSW3653AKHcCfBVe9lPMttM6/ynjrw8SXhhCCGWu3w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcBICIqIpi34RflnOtieCnuWBTI5EYD1k76YP+uo2wm5QoRfUD
	4e18u776x8SJdOSV2n1R1bcx3Q/vDFmOD5Jgc3hJkI2PLIIfGDM3jfW9tprKBFx0622m22aVFaT
	dlFQKq8lTIQVny4IwZIni/xUmLFxiHn9TKxABnei43R2ISqvK3Ji7Kw==
X-Gm-Gg: ASbGncsAAPX+7dju12w0Qi8dCCcCeY9hUTKfO9ZC19IHFiwCN2EbhQSv1RMwSLV7j4X
	GrltIJ/jXtLGfJyOppjfzKUPmbigJcqtVogQ0YuI1CaSZp4opXfUJYKwzP9DYcCqzL3fCRbNbZ9
	lRRTXD6Wg8/jx6v30Csad6A/+bIIlMrc6++FBViN95MUC0PbYILTzp8AJHvKLKOlzQwZo68GJJt
	1bJb4akbEQVutLSVDXjMPnyKrSBUtdhhC7XZEGWaI15WT4tMP37SoNj79Rz45Y8zHa/8Wnb7ZWG
	wLGFwpZDqMgBRuzHDKtvNsxkhh1CuJQHU3mPTw9y
X-Received: by 2002:a05:620a:4049:b0:7e6:9a11:f0c8 with SMTP id af79cd13be357-813beffa169mr1079399285a.21.1757394260364;
        Mon, 08 Sep 2025 22:04:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+4M9jnqZ7XEtL8iNZFr7DfeWbk4fN2cPgrooLCIHf05hyNRzqCDxbOlnIixcIpPme44IWnw==
X-Received: by 2002:a05:620a:4049:b0:7e6:9a11:f0c8 with SMTP id af79cd13be357-813beffa169mr1079397285a.21.1757394259952;
        Mon, 08 Sep 2025 22:04:19 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-81b58c51dacsm64417585a.12.2025.09.08.22.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 22:04:19 -0700 (PDT)
Message-ID: <b71c7500-3e1b-491b-8cf0-989401bc6795@redhat.com>
Date: Tue, 9 Sep 2025 01:04:17 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/11] PCI: Check ACS Extended flags for
 pci_bus_isolated()
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com
References: <11-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <11-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/5/25 2:06 PM, Jason Gunthorpe wrote:
> When looking at a PCIe switch we want to see that the USP/DSP MMIO have
> request redirect enabled. Detect the case where the USP is expressly not
> isolated from the DSP and ensure the USP is included in the group.
> 
> The DSP Memory Target also applies to the Root Port, check it there
> too. If upstream directed transactions can reach the root port MMIO then
> it is not isolated.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/pci/search.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
> index dac6b042fd5f5d..cba417cbe3476e 100644
> --- a/drivers/pci/search.c
> +++ b/drivers/pci/search.c
> @@ -127,6 +127,8 @@ static enum pci_bus_isolation pcie_switch_isolated(struct pci_bus *bus)
>   	 * traffic flowing upstream back downstream through another DSP.
>   	 *
>   	 * Thus any non-permissive DSP spoils the whole bus.
> +	 * PCI_ACS_UNCLAIMED_RR is not required since rejecting requests with
> +	 * error is still isolation.
>   	 */
>   	guard(rwsem_read)(&pci_bus_sem);
>   	list_for_each_entry(pdev, &bus->devices, bus_list) {
> @@ -136,8 +138,14 @@ static enum pci_bus_isolation pcie_switch_isolated(struct pci_bus *bus)
>   		    pdev->dma_alias_mask)
>   			return PCIE_NON_ISOLATED;
>   
> -		if (!pci_acs_enabled(pdev, PCI_ACS_ISOLATED))
> +		if (!pci_acs_enabled(pdev, PCI_ACS_ISOLATED |
> +						   PCI_ACS_DSP_MT_RR |
> +						   PCI_ACS_USP_MT_RR)) {
> +			/* The USP is isolated from the DSP */
> +			if (!pci_acs_enabled(pdev, PCI_ACS_USP_MT_RR))
> +				return PCIE_NON_ISOLATED;
>   			return PCIE_SWITCH_DSP_NON_ISOLATED;
> +		}
>   	}
>   	return PCIE_ISOLATED;
>   }
> @@ -232,11 +240,13 @@ enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
>   	/*
>   	 * Since PCIe links are point to point root ports are isolated if there
>   	 * is no internal loopback to the root port's MMIO. Like MFDs assume if
> -	 * there is no ACS cap then there is no loopback.
> +	 * there is no ACS cap then there is no loopback. The root port uses
> +	 * DSP_MT_RR for its own MMIO.
>   	 */
>   	case PCI_EXP_TYPE_ROOT_PORT:
>   		if (bridge->acs_cap &&
> -		    !pci_acs_enabled(bridge, PCI_ACS_ISOLATED))
> +		    !pci_acs_enabled(bridge,
> +				     PCI_ACS_ISOLATED | PCI_ACS_DSP_MT_RR))
>   			return PCIE_NON_ISOLATED;
>   		return PCIE_ISOLATED;
>   
Reviewed-by: Donald Dutile <ddutile@redhat.com>


