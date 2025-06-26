Return-Path: <kvm+bounces-50903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AAF73AEA855
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 22:44:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3998A3A9BA3
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 20:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B18992F0E59;
	Thu, 26 Jun 2025 20:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jHSFUIqZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C369E2EF9C5;
	Thu, 26 Jun 2025 20:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750970629; cv=none; b=J8cY7/tzLDQsaOvO2e0gI5CzDAN6DcfxiUzuFXD1fRq+riMCzfiq+kP6oLAvym/VNqGMvZUM/aUXIVUkj7ugKn2ZTIV8jiM1ApB3SatBJoJRplF2E2XWzcYqI07FMMFOw8XiFhdKYvYMGdQPDSMyLzQGDTxigjKFi7rgaNzsdx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750970629; c=relaxed/simple;
	bh=RxyMC+2G+d8PymhCGrHX7YP1mVjswtwkuXu40rNBTkU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=eQ1O0Sb2WurlfuBP9H7V+ZLdWf7uCwd3/nRbokamH3Wul/mZpyHZHjBZsfZSfJxr+ZGMMuv8ZGOq2p4bj7Y6WsgX6Iqogggg9B0YTt1tZHKpNa6o2tf+UveC8gg/L+qnpsZhmpFCg1i6EuKHctZdFjBwvBwYZt0MSKct6/vbz+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jHSFUIqZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AFDC4CEEB;
	Thu, 26 Jun 2025 20:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750970629;
	bh=RxyMC+2G+d8PymhCGrHX7YP1mVjswtwkuXu40rNBTkU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=jHSFUIqZ0TTJQpruH30p17NnWNGatOoB4vi9WQfZYchyL+arvyBGio0XxKMElG4am
	 36jyKQkGirTxX9VRBWkqhMmOsmo0SxMFd2Ql78FpR3LxsxSPmhdzPWC2JFFrqO5qOy
	 XOF5y38I320zXYHhJC+THSW6VWcgTNRoBRj+c7Snbf+h8Jfcy3YVRNOoqx0rmpFOyd
	 ZDAAneTSGiN8xGe/BBds1mnROHCYF5r/vDlwHjMFpN7VkMwqOEGZmqEzW2zKwb+UK4
	 tBSgM4XoBU3mDn9yIzEFRm5kXY2VT2PUneU24hjsn0PD63yCds2swtwDFKzYR9B6Np
	 5q6CuPFLe/ViQ==
Date: Thu, 26 Jun 2025 15:43:47 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Mario Limonciello <superm1@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Lukas Wunner <lukas@wunner.de>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	"open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:INTEL IOMMU (VT-d)" <iommu@lists.linux.dev>,
	"open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>,
	"open list:VFIO DRIVER" <kvm@vger.kernel.org>,
	"open list:SOUND" <linux-sound@vger.kernel.org>,
	Daniel Dadap <ddadap@nvidia.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Simona Vetter <simona.vetter@ffwll.ch>
Subject: Re: [PATCH v5 1/9] PCI: Add helper for checking if a PCI device is a
 display controller
Message-ID: <20250626204347.GA1638339@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624203042.1102346-2-superm1@kernel.org>

On Tue, Jun 24, 2025 at 03:30:34PM -0500, Mario Limonciello wrote:
> From: Mario Limonciello <mario.limonciello@amd.com>
> 
> Several places in the kernel do class shifting to match whether a
> PCI device is display class.  Introduce a helper for those places to
> use.
> 
> Reviewed-by: Daniel Dadap <ddadap@nvidia.com>
> Reviewed-by: Simona Vetter <simona.vetter@ffwll.ch>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Not sure how this should be merged, let me know if you want me to do
something with it.

> ---
>  include/linux/pci.h | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 05e68f35f3923..e77754e43c629 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -744,6 +744,21 @@ static inline bool pci_is_vga(struct pci_dev *pdev)
>  	return false;
>  }
>  
> +/**
> + * pci_is_display - Check if a PCI device is a display controller
> + * @pdev: Pointer to the PCI device structure
> + *
> + * This function determines whether the given PCI device corresponds
> + * to a display controller. Display controllers are typically used
> + * for graphical output and are identified based on their class code.
> + *
> + * Return: true if the PCI device is a display controller, false otherwise.
> + */
> +static inline bool pci_is_display(struct pci_dev *pdev)
> +{
> +	return (pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY;
> +}
> +
>  #define for_each_pci_bridge(dev, bus)				\
>  	list_for_each_entry(dev, &bus->devices, bus_list)	\
>  		if (!pci_is_bridge(dev)) {} else
> -- 
> 2.43.0
> 

