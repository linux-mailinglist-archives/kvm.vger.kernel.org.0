Return-Path: <kvm+bounces-52797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B4312B09610
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 22:57:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8267056838F
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 20:57:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E8692309B2;
	Thu, 17 Jul 2025 20:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nmPdFv9s"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F4EEEBB;
	Thu, 17 Jul 2025 20:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752785820; cv=none; b=rDZQeg0DNFN7zEoctc+HgE7PYk4u3IG6MnZ71wzGTZ5wJEviF60wCHYv7vR97yj7zM8bxaaraeEFKNilHH9fARekm11k41gT0Ot+av3LUhImx93dmKM+X+jxhKCfsiqcpq2BuWflHsiiRVQ5WDj2yORq5uUPG9R1nTI+/BsActY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752785820; c=relaxed/simple;
	bh=hB3ECq2LvtFhlKyMHw+BjidxFJ+IC5vbDWpXnTL/FLU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=ewvlJ4w0PnOlnpPb27kFPXTllNMQTbC09PT5gSItAaHxZoCB0dQ9koLWMhtg/u9uz/iS+XjKmZqS+x2M/4mfq3G2nQrF382lAy1r8MY/9gazEpKMTUWQD7dLlNtewmRcD5CD6nPDzAVl7dtk+YpNxk/b/v0iInbvWnUCcleZDDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nmPdFv9s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0A7C4CEE3;
	Thu, 17 Jul 2025 20:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752785819;
	bh=hB3ECq2LvtFhlKyMHw+BjidxFJ+IC5vbDWpXnTL/FLU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=nmPdFv9s4xlXAy1klUkoXPSEIZfqAtNu7pPXMsYZ+mkkqp7kW6roP3ESMsMkt0Tm0
	 sL7bQJ++QD5UvWMGMxt7cNCTr0sRD83lrrn6hnkyxBkvXEUubljBVW7FgmtDcrhGH0
	 nIDJO5CMCu1v2NUKcXj2djnP97ipb2+mtihiXNhZGRfQAAIAgNQZIUCpUeQPTeLW33
	 dXIt1V7/3Lnm/M2nXKSluFU5Rghb2HxuGVB8fPckOvJNGb26yYgDKZpsxme0YZN/no
	 8FBUx984WqoniDQvFrFm++xzhE49NoljTVZVgS8oVn0vv2p/Nxd1tslrTGk3D6XktK
	 WcBSbB+Fg1GTA==
Date: Thu, 17 Jul 2025 15:56:58 -0500
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
Subject: Re: [PATCH v9 0/9] Adjust fbcon console device detection
Message-ID: <20250717205658.GA2654514@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717173812.3633478-1-superm1@kernel.org>

On Thu, Jul 17, 2025 at 12:38:03PM -0500, Mario Limonciello wrote:
> From: Mario Limonciello <mario.limonciello@amd.com>
> 
> Systems with more than one GPU userspace doesn't know which one to be
> used to treat as primary.  The concept of primary is important to be
> able to decide which GPU is used for display and  which is used for
> rendering.  If it's guessed wrong then both GPUs will be kept awake
> burning a lot of power.
> 
> Historically it would use the "boot_vga" attribute but this isn't
> present on modern GPUs.
> 
> This series started out as changes to VGA arbiter to try to handle a case
> of a system with 2 GPUs that are not VGA devices and avoid changes to
> userspace.  This was discussed but decided not to overload the VGA arbiter
> for non VGA devices.
> 
> Instead move the x86 specific detection of framebuffer resources into x86
> specific code that the fbcon can use to properly identify the primary
> device. This code is still called from the VGA arbiter, and the logic does
> not change there. To avoid regression default to VGA arbiter and only fall
> back to looking up with x86 specific detection method.
> 
> In order for userspace to also be able to discover which device was the
> primary video display device create a new sysfs file 'boot_display'.
> 
> A matching userspace implementation for this file is available here:
> Link: https://gitlab.freedesktop.org/xorg/lib/libpciaccess/-/merge_requests/39
> Link: https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/2038
> 
> Dave Airlie has been pinged for a comment on this approach.
> Dave had suggested in the past [1]:
> 
> "
>  But yes if that doesn't work, then maybe we need to make the boot_vga
>  flag mean boot_display_gpu, and fix it in the kernel
> "
> 
> This was one of the approached tried in earlier revisions and it was
> rejected in favor of creating a new sysfs file (which is what this
> version does).
> 
> It is suggested that this series merge entirely through the PCI tree.
> 
> Link: https://gitlab.freedesktop.org/xorg/lib/libpciaccess/-/merge_requests/37#note_2938602 [1]
> 
> v9:
>  * Add more to cover letter
>  * Add bug link to last patch
>  * Update commit message for last patch
>  * Update boot_display documentation description
> 
> Mario Limonciello (9):
>   PCI: Add helper for checking if a PCI device is a display controller
>   vfio/pci: Use pci_is_display()
>   vga_switcheroo: Use pci_is_display()
>   iommu/vt-d: Use pci_is_display()
>   ALSA: hda: Use pci_is_display()
>   Fix access to video_is_primary_device() when compiled without
>     CONFIG_VIDEO
>   PCI/VGA: Replace vga_is_firmware_default() with a screen info check
>   fbcon: Use screen info to find primary device
>   PCI: Add a new 'boot_display' attribute
> 
>  Documentation/ABI/testing/sysfs-bus-pci |  9 +++++
>  arch/parisc/include/asm/video.h         |  2 +-
>  arch/sparc/include/asm/video.h          |  2 ++
>  arch/x86/include/asm/video.h            |  2 ++
>  arch/x86/video/video-common.c           | 17 ++++++++-
>  drivers/gpu/vga/vga_switcheroo.c        |  2 +-
>  drivers/iommu/intel/iommu.c             |  2 +-
>  drivers/pci/pci-sysfs.c                 | 46 +++++++++++++++++++++++++
>  drivers/pci/vgaarb.c                    | 31 +++--------------
>  drivers/vfio/pci/vfio_pci_igd.c         |  3 +-
>  include/linux/pci.h                     | 15 ++++++++
>  sound/hda/hdac_i915.c                   |  2 +-
>  sound/pci/hda/hda_intel.c               |  4 +--
>  13 files changed, 102 insertions(+), 35 deletions(-)

Applied to pci/boot-display for v6.17, thanks!

