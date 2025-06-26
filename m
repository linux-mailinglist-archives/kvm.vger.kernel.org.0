Return-Path: <kvm+bounces-50906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 25FF4AEA865
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 22:45:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87B151C41D4A
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 20:46:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDD8823B62B;
	Thu, 26 Jun 2025 20:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hn9LJB4+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA9C1B4F09;
	Thu, 26 Jun 2025 20:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750970742; cv=none; b=TVlBucX+z9iKnj+GSBmi3utOblcWc8C+6R9MmOBcAlCR6WKgqKZOrVohJPVscCz3vSHk7Mb77nQltE7snlsBmKhQ8XsbJ3m1cj9xqIBbx/zudYOmoVbNY/lKbyfz1dgNX0z+y7ldMOBLbMZ4XpnVI5c0GG0gJF7R17etnlJnCvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750970742; c=relaxed/simple;
	bh=y44KbF3C7rhYBkeJUpprj4Hik/9NkPbfiCyQ/CmZYI0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=jyJ7Yvf5B1bzyPudzjYG2QtjawNs+lFVD4SFSTL5cV5SGh8UfGrX0/LZH6xcpZXr1sAW1q9wQNndwPc1u8+PVsZmR694glsXDIWB7ItPi+yzKGtQgAcK0uO2Y2Awv6KymLDB9RJhpUQlnXmN7Iu4IH43++OmhrO5C5bLHVpX6mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hn9LJB4+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4413AC4CEEB;
	Thu, 26 Jun 2025 20:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750970741;
	bh=y44KbF3C7rhYBkeJUpprj4Hik/9NkPbfiCyQ/CmZYI0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=Hn9LJB4+wuyQ+xtwfZPAIAyfAmaPZUL8TYDnbOGgRk1KSbDX80XziLoX9/rjjXh6V
	 h9waOa+PkLTNAYq+a3LdV0aqRp33R2fikWgze11a+4RZ6aArT8MOB9nS39tJnvfiMK
	 NiT4q6hEuHnJarVyVAh+zl7vXxBSPzL8hyHmvVCzLDeE/UHCB37jK4BXOO4pYNh5oC
	 3SH6f98nl6R+X5bjxWiBngJPgh2NlA86FPTgsyMD5IYaqdGtWtPXVU6zde6G4QojZg
	 +b8epJ/QvMWT15Ffkzt35F32OqZ/B5Qg9ZZxqJSmgYQxvdVQc4qHXHbgABOgzqVASJ
	 HDwhGBhsohBAQ==
Date: Thu, 26 Jun 2025 15:45:40 -0500
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
	Mario Limonciello <mario.limonciello@amd.com>
Subject: Re: [PATCH v5 7/9] PCI/VGA: Replace vga_is_firmware_default() with a
 screen info check
Message-ID: <20250626204540.GA1639372@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624203042.1102346-8-superm1@kernel.org>

On Tue, Jun 24, 2025 at 03:30:40PM -0500, Mario Limonciello wrote:
> From: Mario Limonciello <mario.limonciello@amd.com>
> 
> vga_is_firmware_default() checks firmware resources to find the owner
> framebuffer resources to find the firmware PCI device.  This is an
> open coded implementation of screen_info_pci_dev().  Switch to using
> screen_info_pci_dev() instead.
> 
> Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

(after the kernel robot issue is fixed, of course)

> ---
> v5:
>  * split from next patch
> ---
>  drivers/pci/vgaarb.c | 29 ++---------------------------
>  1 file changed, 2 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/pci/vgaarb.c b/drivers/pci/vgaarb.c
> index 78748e8d2dbae..c3457708c01e3 100644
> --- a/drivers/pci/vgaarb.c
> +++ b/drivers/pci/vgaarb.c
> @@ -556,34 +556,9 @@ EXPORT_SYMBOL(vga_put);
>  
>  static bool vga_is_firmware_default(struct pci_dev *pdev)
>  {
> -#if defined(CONFIG_X86)
> -	u64 base = screen_info.lfb_base;
> -	u64 size = screen_info.lfb_size;
> -	struct resource *r;
> -	u64 limit;
> +	struct screen_info *si = &screen_info;
>  
> -	/* Select the device owning the boot framebuffer if there is one */
> -
> -	if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
> -		base |= (u64)screen_info.ext_lfb_base << 32;
> -
> -	limit = base + size;
> -
> -	/* Does firmware framebuffer belong to us? */
> -	pci_dev_for_each_resource(pdev, r) {
> -		if (resource_type(r) != IORESOURCE_MEM)
> -			continue;
> -
> -		if (!r->start || !r->end)
> -			continue;
> -
> -		if (base < r->start || limit >= r->end)
> -			continue;
> -
> -		return true;
> -	}
> -#endif
> -	return false;
> +	return pdev == screen_info_pci_dev(si);
>  }
>  
>  static bool vga_arb_integrated_gpu(struct device *dev)
> -- 
> 2.43.0
> 

