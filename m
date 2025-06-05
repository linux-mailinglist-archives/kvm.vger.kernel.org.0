Return-Path: <kvm+bounces-48517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 03F0FACEEDB
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 14:04:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4E351673EB
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 12:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FB5521A444;
	Thu,  5 Jun 2025 12:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VmAAhXWz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A04C17B50F;
	Thu,  5 Jun 2025 12:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749125050; cv=none; b=VUQXHVO0bkGMLd36YLgos9njC5tPpPXqV21JScWuKTskJaZoGC3Jn5MF8PeSXfpEd8erII+eKruH9RXPcRFQLpl2YeRmunfficz46mGJQfGk4VrOylVpNraZj+kyRk2oAOFxjBwTomnIyGxkxg+9HDNB3bE7ePg1g4FeUzxxKMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749125050; c=relaxed/simple;
	bh=lCVZA25/isGuQai3LP6gi6FwlJVk5NeO2+7NBohc5SU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=K7+ouXKY+djQUsCrvcABuyzdpLI8eqpos5icVmyjS5eJOM6//4KSikyJa/v+Yt3bTjofAtiYvORS5f21ETJtwNIVuMw4rSi5Bb5bOAXb9hU5UWlXtv7Df3pglNbu4fZXIgtGDanpb9disAgjD+NRRNOoLKtPxLzfvr1zhyAc24k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VmAAhXWz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AF1C4CEE7;
	Thu,  5 Jun 2025 12:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749125049;
	bh=lCVZA25/isGuQai3LP6gi6FwlJVk5NeO2+7NBohc5SU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=VmAAhXWzVGBjeWNpVW2wh+mAxiJcDJYA6OUElXSkndlFiRbwoupeUKMTH94sxLGvI
	 mm+H/Gf2F7yPxlLw3e05dd0veLXsk1JP4wjON1COr10tlCInZjoSa7vOOesZdr9d96
	 gUOhYR2G5S6tS+73HgdIsXGy6YWJgRN8aWYW/EKfjs3ZHWxP+MMaJm2zNM99QG71LN
	 6u/uC+PiBbdLJ33bKUgN8BjrnLIAr+4iPVhyTo6jd6bdl2vM+pfnbPwBAOm/6o6A6f
	 lmP5838AChfUmUz4tXi4HnRBYEm8WQTUGcFn9QLj5penqKRJvzkYco8PtO6YVZQ4Mz
	 ZmTOk2gmbJV4w==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Xu Yilun <yilun.xu@linux.intel.com>, kvm@vger.kernel.org,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	jgg@nvidia.com, dan.j.williams@intel.com, aik@amd.com,
	linux-coco@lists.linux.dev
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, vivek.kasireddy@intel.com,
	yilun.xu@intel.com, yilun.xu@linux.intel.com,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, tao1.su@intel.com,
	linux-pci@vger.kernel.org, zhiw@nvidia.com, simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com, iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: Re: [RFC PATCH 19/30] vfio/pci: Add TSM TDI bind/unbind IOCTLs for
 TEE-IO support
In-Reply-To: <20250529053513.1592088-20-yilun.xu@linux.intel.com>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
 <20250529053513.1592088-20-yilun.xu@linux.intel.com>
Date: Thu, 05 Jun 2025 17:33:52 +0530
Message-ID: <yq5ah60u8kev.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Xu Yilun <yilun.xu@linux.intel.com> writes:

> Add new IOCTLs to do TSM based TDI bind/unbind. These IOCTLs are
> expected to be called by userspace when CoCo VM issues TDI bind/unbind
> command to VMM. Specifically for TDX Connect, these commands are some
> secure Hypervisor call named GHCI (Guest-Hypervisor Communication
> Interface).
>
> The TSM TDI bind/unbind operations are expected to be initiated by a
> running CoCo VM, which already have the legacy assigned device in place.
> The TSM bind operation is to request VMM make all secure configurations
> to support device work as a TDI, and then issue TDISP messages to move
> the TDI to CONFIG_LOCKED or RUN state, waiting for guest's attestation.
>
> Do TSM Unbind before vfio_pci_core_disable(), otherwise will lead
> device to TDISP ERROR state.
>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
> Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
>

....

> +
> +	/* To ensure no host side MMIO access is possible */
> +	ret = pci_request_regions_exclusive(pdev, "vfio-pci-tsm");
> +	if (ret)
> +		goto out_unlock;
> +
>

I am hitting failures here with similar changes. Can you share the Qemu
changes needed to make this pci_request_regions_exclusive successful.
Also after the TDI is unbound, we want the region ownership backto
"vfio-pci" so that things continue to work as non-secure device. I don't
see we doing that. I could add a pci_bar_deactivate/pci_bar_activate in
userspace which will result in vfio_unmap()/vfio_map(). But that doesn't
release the region ownership.


> +	ret = vfio_iommufd_tsm_bind(&vdev->vdev, tsm_bind.vdevice_id);
> +	if (ret)
> +		goto out_release_region;
> +
> +	vdev->is_tsm_bound = true;
> +	mutex_unlock(&vdev->vdev.dev_set->lock);
> +
> +	return 0;
> +
> +out_release_region:
> +	pci_release_regions(pdev);
> +out_unlock:
> +	mutex_unlock(&vdev->vdev.dev_set->lock);
> +	return ret;
> +}

-aneesh

