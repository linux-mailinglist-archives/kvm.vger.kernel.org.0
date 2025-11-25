Return-Path: <kvm+bounces-64501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 47F42C85645
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 15:23:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 891B54EA994
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 14:22:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0CD2325711;
	Tue, 25 Nov 2025 14:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="lIER5eX5"
X-Original-To: kvm@vger.kernel.org
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5F46251791;
	Tue, 25 Nov 2025 14:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764080528; cv=none; b=BF93hThftytRUvSnRKGmPJT1T+qR5s1U6zP3hS/p1lHpBG9yCsIk21b4S4+3hrkMFskaTXDtQ69GXsxoBqDS04fInQGFFoZUsFe5I/PoCuSgFOe6QXmjjuANAXqDuezf7Kvz13a5gLeejef9gMZQXQ3z48wkT5tO2rsQ90QTerc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764080528; c=relaxed/simple;
	bh=lCT+owy5A7izWg3Y4iAUPBOhRqFZkOsq11yIy0cwvY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jY2u7HbogwM/Es/xGOzgLetwjbc9fgIAqqn+CTX0m4euBRHkbbMGf6hR0NnlKJSD4bIvlcz2WebL9hDyUwLEikHS5E1Ts2+buHC5dGpMc5VHQmgNrcrD+zocUVgKN6Ixt4AGhl6/vw4FaxdFckKqyf/L3iu02VCUlq6/5g6elh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=lIER5eX5; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p549214ac.dip0.t-ipconnect.de [84.146.20.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 3464C5C3AC;
	Tue, 25 Nov 2025 15:22:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1764080524;
	bh=lCT+owy5A7izWg3Y4iAUPBOhRqFZkOsq11yIy0cwvY4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lIER5eX5S6QaCqC+3BZZWnYz/IRTlm54MKwKdKivZSpojZZwBhuTwi5t+ViDdYbo4
	 AIiRsdmu4aJ6Xp01EcG10inM+6r7neUe3T/OHhggRCEbIGISdZJ/wHCw8OTGysgIaE
	 n/vaC+8JOLKY//KyGo+wPno++VGI3jyrzLq63Hj+CXScJeMju7pltA53Ma7vDOaNPr
	 tyzL9aWukq7F2NXS3d+smEZYybpwySz/Gw3V2J8DPc77FTj+gsq+exgp8YvIF8uRm3
	 MQyDAA47+MlrgTvd9puXOB6C+U0d0IYymQAVNFuMMVvwfoblFdm1/pqQ/QIGRfom9y
	 8w0iNll9T45jA==
Date: Tue, 25 Nov 2025 15:22:03 +0100
From: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: afael@kernel.org, bhelgaas@google.com, alex@shazbot.org, 
	jgg@nvidia.com, will@kernel.org, robin.murphy@arm.com, lenb@kernel.org, 
	kevin.tian@intel.com, baolu.lu@linux.intel.com, linux-arm-kernel@lists.infradead.org, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, 
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, patches@lists.linux.dev, 
	pjaroszynski@nvidia.com, vsethi@nvidia.com, helgaas@kernel.org, etzhao1900@gmail.com
Subject: Re: [PATCH v7 0/5] Disable ATS via iommu during PCI resets
Message-ID: <iovdqkgm7std6tpbfoolpkzksbc4hy3egfqgf6wbqmga2jlo7q@uolshjbvs3sm>
References: <cover.1763775108.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1763775108.git.nicolinc@nvidia.com>

On Fri, Nov 21, 2025 at 05:57:27PM -0800, Nicolin Chen wrote:
> Nicolin Chen (5):
>   iommu: Lock group->mutex in iommu_deferred_attach()
>   iommu: Tidy domain for iommu_setup_dma_ops()
>   iommu: Add iommu_driver_get_domain_for_dev() helper
>   iommu: Introduce pci_dev_reset_iommu_prepare/done()
>   PCI: Suspend iommu function prior to resetting a device
> 
>  drivers/iommu/dma-iommu.h                   |   5 +-
>  include/linux/iommu.h                       |  14 ++
>  include/uapi/linux/vfio.h                   |   4 +
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |   5 +-
>  drivers/iommu/dma-iommu.c                   |   4 +-
>  drivers/iommu/iommu.c                       | 220 +++++++++++++++++++-
>  drivers/pci/pci-acpi.c                      |  13 +-
>  drivers/pci/pci.c                           |  65 +++++-
>  drivers/pci/quirks.c                        |  19 +-
>  9 files changed, 326 insertions(+), 23 deletions(-)

Looks good from an IOMMU perspective, but needs Ack from PCI side.

Regards,

	Joerg

