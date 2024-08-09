Return-Path: <kvm+bounces-23775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 73E4E94D708
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:12:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D8C2BB222AB
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 266B716729D;
	Fri,  9 Aug 2024 19:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RBJi1Q/8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3737115921B;
	Fri,  9 Aug 2024 19:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230653; cv=none; b=S4E5v7f+WV999I6VqQkI1XgZf9Y1HvZya8aLSDmO1+hAHGgM6DNBYcXc0PvZWR52uI2xDzuhPQN0/8EtBOwCuWgvR+IciZ3b3DXA/a1ZpQN7z3w5GRJfpVGuyQBCCFZEJj34Flw6TPDam4G5YQz8kGnalP9wFmCtJkvkVc+imi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230653; c=relaxed/simple;
	bh=xI5Rbfi+pxcRJzLQc5ic3pdeHhvxFHNMZb8wh/45EZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=ZNrdaGm8QHbHPM5evbwB6l+YJxYvn3RbwYqylxccUAFSyLPTsADYxmSHlBP+GFLnD+tTfxsVX/3pgUNVNCdqo2IXXxAbdeDCM/gcn7OT2dUwLmxDwAATvt1v3m/aB/ja5OAksnfL2VcGq6Fni+USXUj8JDTRQTcYORQzBQwunjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RBJi1Q/8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8F8C32782;
	Fri,  9 Aug 2024 19:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723230652;
	bh=xI5Rbfi+pxcRJzLQc5ic3pdeHhvxFHNMZb8wh/45EZ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=RBJi1Q/8quzblW4+FN960AoXuXHmEhNfbm9HZpN2JIzI2CqfcBTTnCpSde+mQMyWM
	 obSIfu8PqQCiHx2ESCdA1YIffLyG1BokpNr7zizU7NVriAPGPY0uL3Ecy2RRePi6Wh
	 cWXQIG4MPoZMzVajNEROuIsLFo+UtKH3t48IFY81Pu6DbKO1AtxfTtMuG+aolKJ/45
	 eXeEl7OixN1aFoFsRPpxwrsT/Yjh7TO6TreBz22Qulj2KfgrlCAeUTdjoR39e1goSI
	 QkcZmW2we3hNqn4CjDAEoVtrpAYLQN278jTiMG1lkCudLR4sxlFCB/bgGYrrOhLMLM
	 0aYj99n6+5nMw==
Date: Fri, 9 Aug 2024 14:10:50 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH] iommu: Allow ATS to work on VFs when the PF uses IDENTITY
Message-ID: <20240809191050.GA206627@bhelgaas>
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

For the pci/ats.c change:

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Happy to merge via PCI if the IOMMU folks ack it, but the behavior
change is more important on the IOMMU side, so maybe it makes more
sense to merge there.

> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index b19e8c0f48fa25..98054497d343bc 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -2203,6 +2203,9 @@ static struct iommu_device *amd_iommu_probe_device(struct device *dev)
>  
>  	iommu_completion_wait(iommu);
>  
> +	if (dev_is_pci(dev))
> +		pci_prepare_ats(to_pci_dev(dev), PAGE_SHIFT);
> +
>  	return iommu_dev;
>  }
>  
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index a31460f9f3d421..9bc50bded5af72 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -3295,6 +3295,12 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
>  	    smmu->features & ARM_SMMU_FEAT_STALL_FORCE)
>  		master->stall_enabled = true;
>  
> +	if (dev_is_pci(dev)) {
> +		unsigned int stu = __ffs(smmu->pgsize_bitmap);
> +
> +		pci_prepare_ats(to_pci_dev(dev), stu);
> +	}
> +
>  	return &smmu->iommu;
>  
>  err_free_master:
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 9ff8b83c19a3e2..ad81db026ab236 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -4091,6 +4091,7 @@ static struct iommu_device *intel_iommu_probe_device(struct device *dev)
>  
>  	dev_iommu_priv_set(dev, info);
>  	if (pdev && pci_ats_supported(pdev)) {
> +		pci_prepare_ats(pdev, VTD_PAGE_SHIFT);
>  		ret = device_rbtree_insert(iommu, info);
>  		if (ret)
>  			goto free;
> diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
> index c570892b209095..87fa03540b8a21 100644
> --- a/drivers/pci/ats.c
> +++ b/drivers/pci/ats.c
> @@ -47,6 +47,39 @@ bool pci_ats_supported(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL_GPL(pci_ats_supported);
>  
> +/**
> + * pci_prepare_ats - Setup the PS for ATS
> + * @dev: the PCI device
> + * @ps: the IOMMU page shift
> + *
> + * This must be done by the IOMMU driver on the PF before any VFs are created to
> + * ensure that the VF can have ATS enabled.
> + *
> + * Returns 0 on success, or negative on failure.
> + */
> +int pci_prepare_ats(struct pci_dev *dev, int ps)
> +{
> +	u16 ctrl;
> +
> +	if (!pci_ats_supported(dev))
> +		return -EINVAL;
> +
> +	if (WARN_ON(dev->ats_enabled))
> +		return -EBUSY;
> +
> +	if (ps < PCI_ATS_MIN_STU)
> +		return -EINVAL;
> +
> +	if (dev->is_virtfn)
> +		return 0;
> +
> +	dev->ats_stu = ps;
> +	ctrl = PCI_ATS_CTRL_STU(dev->ats_stu - PCI_ATS_MIN_STU);
> +	pci_write_config_word(dev, dev->ats_cap + PCI_ATS_CTRL, ctrl);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pci_prepare_ats);
> +
>  /**
>   * pci_enable_ats - enable the ATS capability
>   * @dev: the PCI device
> diff --git a/include/linux/pci-ats.h b/include/linux/pci-ats.h
> index df54cd5b15db09..d98929c86991be 100644
> --- a/include/linux/pci-ats.h
> +++ b/include/linux/pci-ats.h
> @@ -8,6 +8,7 @@
>  /* Address Translation Service */
>  bool pci_ats_supported(struct pci_dev *dev);
>  int pci_enable_ats(struct pci_dev *dev, int ps);
> +int pci_prepare_ats(struct pci_dev *dev, int ps);
>  void pci_disable_ats(struct pci_dev *dev);
>  int pci_ats_queue_depth(struct pci_dev *dev);
>  int pci_ats_page_aligned(struct pci_dev *dev);
> 
> base-commit: e7153d9c8cee2f17fdcd011509860717bfa91423
> -- 
> 2.46.0
> 

