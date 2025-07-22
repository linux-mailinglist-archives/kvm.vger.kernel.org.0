Return-Path: <kvm+bounces-53136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8901BB0DF2F
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 16:44:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7179B3A5E3A
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 14:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 792232EACFB;
	Tue, 22 Jul 2025 14:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pnSdUe2v"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F9428BAAB;
	Tue, 22 Jul 2025 14:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753195102; cv=none; b=lo80X79Jx2r+HqCyFkzDTMIXH+TsBiFaPDXLP9Z+etGnNiSOcTvoA1hGbHB0DBtQEs/xPQxbAuvtrYvF/zNH3L/NWnzwWrGnGoMQxi6WrAkonirfvWrZauJFVEPvSwHtTt3+o0YxuDgpOsIDegT5l8miY174U0I/araipq12+Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753195102; c=relaxed/simple;
	bh=olKvJssCQ+xMT+WLhpu98KqvBUZv7VvUC2gcGKu9NrU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=TczecfwlgoB3bUcVEQ7AZxfwITFXToNznxi7vbG1lRkdA5r7WuEaT2tK/diLVOzaxzn3EkJ5e8CYDgYBnRVDnljhHCKwZIvRNZFiYLAuJz8Yv/ycKUPMgY8itik1/3hZhfsvAZhhBZyrcEpEFP9yloAUjjE4/3Qwg8E+js6b4Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pnSdUe2v; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9018DC4CEEB;
	Tue, 22 Jul 2025 14:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753195102;
	bh=olKvJssCQ+xMT+WLhpu98KqvBUZv7VvUC2gcGKu9NrU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=pnSdUe2vQ84cN467eqKaYEZORO0ldOInWuIQWSIvlsXp1s2rv3UXpF53hb38nk7GP
	 d8syRIWGle7KqN2m26+TgpxHfxHzmu8nRWzDr0OjArv5dLmBCXBsjTbw9Sd9NKY9tw
	 f/m3VCyGuV1dRaMk6SzZRGEJugoBLOK+sh1ZeQIqfequLJn6hplDiflHhKlCeC38sr
	 Qp8Mbu1+aen7Gwf45yX9lLMSOJkopMJor4Dpb9liiIMbhYaFYLlO6Rro9sjIP25gMI
	 kxg1WWGdU1cWq0CsDtWdcrS6NMALjqbn06Ezz6E/MmdQhPy+vrYotuypLDYZjtGhWH
	 1V7RkEeUFkeRA==
Date: Tue, 22 Jul 2025 09:38:17 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Mario Limonciello <superm1@kernel.org>
Cc: David Airlie <airlied@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Simona Vetter <simona@ffwll.ch>, Lukas Wunner <lukas@wunner.de>,
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
Subject: Re: [PATCH v9 8/9] fbcon: Use screen info to find primary device
Message-ID: <20250722143817.GA2783917@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717173812.3633478-9-superm1@kernel.org>

On Thu, Jul 17, 2025 at 12:38:11PM -0500, Mario Limonciello wrote:
> From: Mario Limonciello <mario.limonciello@amd.com>
> 
> On systems with non VGA GPUs fbcon can't find the primary GPU because
> video_is_primary_device() only checks the VGA arbiter.
> 
> Add a screen info check to video_is_primary_device() so that callers
> can get accurate data on such systems.

This relies on screen_info, which I think is an x86 BIOS-ism.  Isn't
there a UEFI console path?  How does that compare with this?  Is that
relevant or is it something completely different?

>  bool video_is_primary_device(struct device *dev)
>  {
> +#ifdef CONFIG_SCREEN_INFO
> +	struct screen_info *si = &screen_info;
> +#endif
>  	struct pci_dev *pdev;
>  
>  	if (!dev_is_pci(dev))
> @@ -34,7 +38,18 @@ bool video_is_primary_device(struct device *dev)
>  
>  	pdev = to_pci_dev(dev);
>  
> -	return (pdev == vga_default_device());
> +	if (!pci_is_display(pdev))
> +		return false;
> +
> +	if (pdev == vga_default_device())
> +		return true;
> +
> +#ifdef CONFIG_SCREEN_INFO
> +	if (pdev == screen_info_pci_dev(si))
> +		return true;
> +#endif
> +
> +	return false;
>  }
>  EXPORT_SYMBOL(video_is_primary_device);
>  
> -- 
> 2.43.0
> 

