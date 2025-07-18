Return-Path: <kvm+bounces-52919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B2A34B0A994
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 19:37:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 596531AA8694
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 17:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B00FE2E7BAA;
	Fri, 18 Jul 2025 17:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Du+zVQmT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39A315E5C2;
	Fri, 18 Jul 2025 17:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752860211; cv=none; b=VjoNzuBPywtmxVu7xbG9SFTDvkoy+TjGYxJKv3sGC8tjAzgbAUNjX2qbCe2VmcFZlJN+MeVuYCl4sLj7LO1Rfx4ffyZV68PbLElL2Z/TN1306GqAxKYENwxQ/rgJ1C9Qm+S2hI/1078CK18OZ5G+nYXMJUmizSFp2/M2WP4+vZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752860211; c=relaxed/simple;
	bh=3G0DSuma9EoRh+0cSstUnb2PnhnazXDdqCX1tROd9/U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=iraxiyvqFVihwFW27b2hPZYtFrSOa1BL2/SzhZ00+lK3+YZWbYdW3ZN2abbOALjWj4BvDxbPrWgA4NrbEQzS6lAhQiI4iRjNJT8V7gIqaX2inQv/Dvk20O87FwLN1S7rhvKi0IuSnUUVhwJJsOCTqPsFdf4/Q0ox9x3BzTnkyCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Du+zVQmT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6A1C4CEEB;
	Fri, 18 Jul 2025 17:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752860211;
	bh=3G0DSuma9EoRh+0cSstUnb2PnhnazXDdqCX1tROd9/U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=Du+zVQmTS6WbjJUtbJ4BCs7wJ7Vipjf6ogBECh36POXjccz9iROAlMR7PehrAUOiP
	 eVkeyvrSjIhjjbd+vd1bsEgxzVIKFbXJhaPm7jyVOe7gnFzcZlyz0wC9mGHiNkRcgM
	 pW9QfY3xN91fwSPtH8yqODM5gx3tbtx7fgwS4ffpfn8AwH0/+zmtm5FD7ZmkO3UOOw
	 PTdLfHWigxSTSEvaIjtNSLB56K+cdYqaCKn1ifaTBkUR3uAwbanh2N2gKthfdinxDS
	 +UJV7jMcdbpnhcgYdYJI4RaKTCffE6arC9BxWTu+zbHNkROo2TvEeEEzpb1CvlerOI
	 Ju8fURhBaz5wA==
Date: Fri, 18 Jul 2025 12:36:48 -0500
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
Message-ID: <20250718173648.GA2704349@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee2907ba-bcda-4e60-a764-078c59b463a8@kernel.org>

On Fri, Jul 18, 2025 at 12:29:05PM -0500, Mario Limonciello wrote:
> On 7/18/2025 12:25 PM, Bjorn Helgaas wrote:
> > On Thu, Jul 17, 2025 at 12:38:12PM -0500, Mario Limonciello wrote:
> > > From: Mario Limonciello <mario.limonciello@amd.com>
> > > 
> > > On systems with multiple GPUs there can be uncertainty which GPU is the
> > > primary one used to drive the display at bootup. In some desktop
> > > environments this can lead to increased power consumption because
> > > secondary GPUs may be used for rendering and never go to a low power
> > > state. In order to disambiguate this add a new sysfs attribute
> > > 'boot_display' that uses the output of video_is_primary_device() to
> > > populate whether a PCI device was used for driving the display.
> > 
> > > +What:		/sys/bus/pci/devices/.../boot_display
> > > +Date:		October 2025
> > > +Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
> > > +Description:
> > > +		This file indicates that displays connected to the device were
> > > +		used to display the boot sequence.  If a display connected to
> > > +		the device was used to display the boot sequence the file will
> > > +		be present and contain "1".
> > 
> > >   int __must_check pci_create_sysfs_dev_files(struct pci_dev *pdev)
> > >   {
> > > +	int retval;
> > > +
> > >   	if (!sysfs_initialized)
> > >   		return -EACCES;
> > > +	retval = pci_create_boot_display_file(pdev);
> > 
> > In addition to Mani's question about whether /sys/bus/pci/ is the
> > right place for this (which is a very good question), it's also been
> > pointed out to me that we've been trying to get rid of
> > pci_create_sysfs_dev_files() for years.
> > 
> > If it's possible to make this a static attribute that would be much,
> > much cleaner.
> 
> Right - I tried to do this, but the problem is at the time the PCI device is
> created the information needed to make the judgement isn't ready.  The
> options end up being:
> * a sysfs file for every display device with 0/1
> * a sysfs file that is not accurate until later in the boot

What's missing?  The specifics might be helpful if someone has another
crack at getting rid of pci_create_sysfs_dev_files() in the future.

> So IMO it /needs/ to come later.
> 
> > 
> > > +	if (retval)
> > > +		return retval;
> > > +
> > >   	return pci_create_resource_files(pdev);
> > >   }
> > > @@ -1671,6 +1716,7 @@ void pci_remove_sysfs_dev_files(struct pci_dev *pdev)
> > >   	if (!sysfs_initialized)
> > >   		return;
> > > +	pci_remove_boot_display_file(pdev);
> > >   	pci_remove_resource_files(pdev);
> > >   }
> > > -- 
> > > 2.43.0
> > > 
> 

