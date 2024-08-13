Return-Path: <kvm+bounces-23951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0059D950060
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:52:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A8E6C1F231E4
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 08:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 145ED6A8CF;
	Tue, 13 Aug 2024 08:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="ieUQMxe0"
X-Original-To: kvm@vger.kernel.org
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B39C339A1;
	Tue, 13 Aug 2024 08:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723539147; cv=none; b=r3oETvWe5h0qNZIdGnLV4cjG5oh5mvEjlAWlO9MGw3rQXZvlTCaZnrBJVlghSoapP2hAqwMKvlfuDm4FJMceyRSe0qMXr+ykq7HtGvYpXuGIta3aepEC+Bd1QsZlH69fuNME9iZmcGhl9oab/0wwMcchp4757bloCkfW3okU/hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723539147; c=relaxed/simple;
	bh=YMj67aL6wIKEzLDPFc93NrmMN0mrzP4ToduOyz628Qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QKnWQrXLBtIqWFbmJFpwAaoSiXmZDZ6HCSZfeoGtUaiiCSctnKSZuI1fCgYQ1G44QvRMKi1plCMoOQufooAz5pEj+0IhMiKJtW5d06bXPD2+rtrxmyLOznd6w4ciZeWXWgzoor5a8lcSYUmvHuu6CcKQK0gcXLKXn9MoN2fkNmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=ieUQMxe0; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (pd9fe9dd8.dip0.t-ipconnect.de [217.254.157.216])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 06BAA2A50EF;
	Tue, 13 Aug 2024 10:52:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1723539144;
	bh=YMj67aL6wIKEzLDPFc93NrmMN0mrzP4ToduOyz628Qs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ieUQMxe0HigcQJaqZh3zZsFiLkq0a1eBi2t5Pzt3YFymmi01Ww7+zL7cQPyhBKe00
	 Tv+IxDclbBH33noPMUZuJQ9t6T0YDDv95L+RRshXSwKEhqyZjHhC4pCMsJQk16HeNA
	 kOcqb6zF9TORWNX5c5ULAvMValaCgFGYUf8E6LEOsBK/MDe3BTwb3QcHe9mwiczHJD
	 AbrCE2QzIFnVacFRHILEeAHiQxJO3LUqMXn/qlZOjbttijsa3YQO7SqIeQ4SAAOvKT
	 DAoIAy9lpwIR30CvgRCaqf23OwAuncjTWDSDmSFFCObdQAUuEbBXuTYunB7Fu9UbMc
	 kv2dvXaUOmdEw==
Date: Tue, 13 Aug 2024 10:52:22 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH] iommu: Allow ATS to work on VFs when the PF uses IDENTITY
Message-ID: <ZrsexhlEKgFqwbXa@8bytes.org>
References: <0-v1-0fb4d2ab6770+7e706-ats_vf_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-0fb4d2ab6770+7e706-ats_vf_jgg@nvidia.com>

On Wed, Aug 07, 2024 at 03:19:20PM -0300, Jason Gunthorpe wrote:
> PCI ATS has a global Smallest Translation Unit field that is located in
> the PF but shared by all of the VFs.
> 
> The expectation is that the STU will be set to the root port's global STU
> capability which is driven by the IO page table configuration of the iommu
> HW. Today it becomes set when the iommu driver first enables ATS.
> 
> Thus, to enable ATS on the VF, the PF must have already had the correct
> STU programmed, even if ATS is off on the PF.
> 
> Unfortunately the PF only programs the STU when the PF enables ATS. The
> iommu drivers tend to leave ATS disabled when IDENTITY translation is
> being used.
> 
> Thus we can get into a state where the PF is setup to use IDENTITY with
> the DMA API while the VF would like to use VFIO with a PAGING domain and
> have ATS turned on. This fails because the PF never loaded a PAGING domain
> and so it never setup the STU, and the VF can't do it.
> 
> The simplest solution is to have the iommu driver set the ATS STU when it
> probes the device. This way the ATS STU is loaded immediately at boot time
> to all PFs and there is no issue when a VF comes to use it.
> 
> Add a new call pci_prepare_ats() which should be called by iommu drivers
> in their probe_device() op for every PCI device if the iommu driver
> supports ATS. This will setup the STU based on whatever page size
> capability the iommu HW has.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/amd/iommu.c                   |  3 ++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  6 ++++
>  drivers/iommu/intel/iommu.c                 |  1 +
>  drivers/pci/ats.c                           | 33 +++++++++++++++++++++
>  include/linux/pci-ats.h                     |  1 +
>  5 files changed, 44 insertions(+)

Applied, thanks.

