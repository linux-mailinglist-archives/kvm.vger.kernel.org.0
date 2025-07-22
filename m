Return-Path: <kvm+bounces-53151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 59D28B0E08B
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 17:33:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C7F21C81B82
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 15:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47EF527815B;
	Tue, 22 Jul 2025 15:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MWz13aDo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5539E266581;
	Tue, 22 Jul 2025 15:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753198405; cv=none; b=t1rVZegeaQutpXtF3ch3lWCecuQOLOrbhtVcM4XvimKy4qWwtmBGz2uoq5ErccojO28jMTpbj5hIeDOxrrHw802+FQlq9Xv0x81AjqVOYTuFwJXTkq72ZSw6yB03sUnQYZDyAXleS08Nh+0R0/B+5kEG4Rez2J7Y80bg6vzSP6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753198405; c=relaxed/simple;
	bh=Gnbv1HzilYTpVH5nogC8wOJ6xUf5jx7prZKcGL2wMss=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=d/aY4Lo9MsRGRcletGrGaEADoD0OerSL9mEgAPW1NncyEQRONZNbB9gTl4SB7oG+mwed0YgukNOsiRicUR7uFprVqPavK0MJAPOUI4D5akNFVdqwIZIxlbikl4vtI9cZqahn9ANDMFhlbetfQmcNA/D2jVCqBSXGIEV7WcQ8GEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MWz13aDo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED9CC4CEEB;
	Tue, 22 Jul 2025 15:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753198404;
	bh=Gnbv1HzilYTpVH5nogC8wOJ6xUf5jx7prZKcGL2wMss=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=MWz13aDofSCJ8WhodTo3vCUam7jsR2GUVtZjgMG35mtKgbDdN7sVBjRTYz3w+pafg
	 PjfxnG2HYeL9V3tzjleK7dYzb+WfaZxk+C0yqzMxZBT4Vi7Vwu3/qAgHtoDL39X3GV
	 PkQY6UhHwaAX0rQt3TQDok7Aff2/OEYEijql5BgyLEUldzFNOoE5+9WnPWqcmaYocE
	 q+AOJNVD76E1UxMR3G4zqpvDAxMBhj6HCtxMVLQrfXzvwKnUL1ZcG/hyJNJYDX3vip
	 EFTCVq4gpotoRwoYryhrVeRNgGQL1MhEeAEix4h7lkZIdeVvMBq8Uj/6xOOsVUBWEt
	 jMjTZUKIHjALQ==
Date: Tue, 22 Jul 2025 10:33:22 -0500
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
Message-ID: <20250722153322.GA2785882@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e260136-009b-44cd-8fe8-85c34cd93ff8@kernel.org>

On Tue, Jul 22, 2025 at 09:45:28AM -0500, Mario Limonciello wrote:
> On 7/22/25 9:38 AM, Bjorn Helgaas wrote:
> > On Thu, Jul 17, 2025 at 12:38:11PM -0500, Mario Limonciello wrote:
> > > From: Mario Limonciello <mario.limonciello@amd.com>
> > > 
> > > On systems with non VGA GPUs fbcon can't find the primary GPU because
> > > video_is_primary_device() only checks the VGA arbiter.
> > > 
> > > Add a screen info check to video_is_primary_device() so that callers
> > > can get accurate data on such systems.
> > 
> > This relies on screen_info, which I think is an x86 BIOS-ism.  Isn't
> > there a UEFI console path?  How does that compare with this?  Is that
> > relevant or is it something completely different?
> 
> When I created and tested this I actually did this on a UEFI system (which
> provides a UEFI GOP driver).

I guess screen_info is actually *not* an x86 BIOS-ism, and on UEFI
systems, we do actually rely on UEFI, e.g., in efi_setup_gop(),
alloc_screen_info(), init_screen_info()?

But this patch is x86-specific, so I'm guessing the same problem could
occur on arm64, Loongson, or other UEFI platforms, and this series
doesn't address those?

> > >   bool video_is_primary_device(struct device *dev)
> > >   {
> > > +#ifdef CONFIG_SCREEN_INFO
> > > +	struct screen_info *si = &screen_info;
> > > +#endif
> > >   	struct pci_dev *pdev;
> > >   	if (!dev_is_pci(dev))
> > > @@ -34,7 +38,18 @@ bool video_is_primary_device(struct device *dev)
> > >   	pdev = to_pci_dev(dev);
> > > -	return (pdev == vga_default_device());
> > > +	if (!pci_is_display(pdev))
> > > +		return false;
> > > +
> > > +	if (pdev == vga_default_device())
> > > +		return true;
> > > +
> > > +#ifdef CONFIG_SCREEN_INFO
> > > +	if (pdev == screen_info_pci_dev(si))
> > > +		return true;
> > > +#endif
> > > +
> > > +	return false;
> > >   }
> > >   EXPORT_SYMBOL(video_is_primary_device);
> > > -- 
> > > 2.43.0
> > > 
> 

