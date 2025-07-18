Return-Path: <kvm+bounces-52917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03B4AB0A962
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 19:26:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89C6E1C818D0
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 17:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 252CD2E7BAB;
	Fri, 18 Jul 2025 17:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BpYGJS8g"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C23F2E6D00;
	Fri, 18 Jul 2025 17:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752859548; cv=none; b=tKzJe6uXYpGvy6knKRLopZJnYATQUNSK8vqfkIwaNkGsrtlnpEBIElBfthpFrPuaqC/inCVjm4lYnKQOXn2AwhQUDJXOKTtxEpVUmI1zyRxjl3hukB5+OGWjbTUfOysmjW4F+lp9nWXpYZJxrIlOMd+ryz8l2GOr1s8CVmw8nJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752859548; c=relaxed/simple;
	bh=0kZo1eB8bc2FYpG2nQ7zGvSsPolxhCxL/5xoSgTbknM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=BeKoJ/THrkqvpaohTkDAWB7lNM4Dz+ETx4ertivU5OMhe2Ho5hWVSpS6cptruo5bwvnvPjmuKc/XIRcoqFOrEg7h+TU1EugeQrdK1gcxgTuikLj1Wpl1wHOgmx8Q7IuBuphsTiJ0GBabX9GQ3DrM10Twwd+MUboM3o6Vm4Ctmo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BpYGJS8g; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72040C4CEEB;
	Fri, 18 Jul 2025 17:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752859547;
	bh=0kZo1eB8bc2FYpG2nQ7zGvSsPolxhCxL/5xoSgTbknM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=BpYGJS8gyOeIoyF8kVxVdgIeN5FXNEUYLgbH167taMiUZqMOXHxhOxUn8pda+L9C8
	 nF/MCpgHBl5HzOW4d7BeI+tFrL3PjxVF6pvqsfo+IYgmwwR1rHpYVHzyIxLUDEXWYi
	 0NZ5ZPiGYU6X5n1AySHZJqpGDSMfOSbV/ANRu8520EQbCFt+igSkhqUqgpzNxv1gRX
	 H+r6MygRO2SBnUhWfgY37x0CrEaokSywqN2qzDAKa7ae0u8sTGGrZXMsZZjTbIKZWh
	 m5mK82heLsKZAEOWe8q94ATBFnmn6knKaoSQoiOUeWrkayknPIQKEhlI5ei7T1c0Ve
	 hsK8Qf4bDTI2g==
Date: Fri, 18 Jul 2025 12:25:45 -0500
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
Subject: Re: [PATCH v9 9/9] PCI: Add a new 'boot_display' attribute
Message-ID: <20250718172545.GA2703510@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717173812.3633478-10-superm1@kernel.org>

On Thu, Jul 17, 2025 at 12:38:12PM -0500, Mario Limonciello wrote:
> From: Mario Limonciello <mario.limonciello@amd.com>
> 
> On systems with multiple GPUs there can be uncertainty which GPU is the
> primary one used to drive the display at bootup. In some desktop
> environments this can lead to increased power consumption because
> secondary GPUs may be used for rendering and never go to a low power
> state. In order to disambiguate this add a new sysfs attribute
> 'boot_display' that uses the output of video_is_primary_device() to
> populate whether a PCI device was used for driving the display.

> +What:		/sys/bus/pci/devices/.../boot_display
> +Date:		October 2025
> +Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
> +Description:
> +		This file indicates that displays connected to the device were
> +		used to display the boot sequence.  If a display connected to
> +		the device was used to display the boot sequence the file will
> +		be present and contain "1".

>  int __must_check pci_create_sysfs_dev_files(struct pci_dev *pdev)
>  {
> +	int retval;
> +
>  	if (!sysfs_initialized)
>  		return -EACCES;
>  
> +	retval = pci_create_boot_display_file(pdev);

In addition to Mani's question about whether /sys/bus/pci/ is the
right place for this (which is a very good question), it's also been
pointed out to me that we've been trying to get rid of
pci_create_sysfs_dev_files() for years.

If it's possible to make this a static attribute that would be much,
much cleaner.

> +	if (retval)
> +		return retval;
> +
>  	return pci_create_resource_files(pdev);
>  }
>  
> @@ -1671,6 +1716,7 @@ void pci_remove_sysfs_dev_files(struct pci_dev *pdev)
>  	if (!sysfs_initialized)
>  		return;
>  
> +	pci_remove_boot_display_file(pdev);
>  	pci_remove_resource_files(pdev);
>  }
>  
> -- 
> 2.43.0
> 

