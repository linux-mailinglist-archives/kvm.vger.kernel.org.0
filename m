Return-Path: <kvm+bounces-50911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB759AEA904
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 23:47:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C73D3B4231
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 21:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78AAB2609F0;
	Thu, 26 Jun 2025 21:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UgXmVwi2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D01A1DF980;
	Thu, 26 Jun 2025 21:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750974443; cv=none; b=f1BDn3b+XdWWLZTBBD2IhwTs+FjCDElAXhtGw0+Eyomb0GAEH1W9XDFHK+DjfP/uTBi82sB+RdJfmYfwnOW92qrMNq+5VeSDW73OG4nJdFnd+h20K2Z+OCAaqsKBiq4nQLl0VRmhxQcGEoGqFxjncfXtgCYeYXJlPH3P3DtmWYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750974443; c=relaxed/simple;
	bh=hxQVzBMNwyC88HTo8GzVCXXrinORweyOG/ceTNc1kGM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=vABZW1PEqBJwo8pbdEzIQXuxNat1PhMRB+YTWpNonAflQvV/Di1wfzi6SG13S4lnKU80A+fgbXi79ZZpW8WW2AdgvA32wP/8Fl9ay2ud6VWcbzAuhvYLsK2ec7SBExzpNe5yoUathTCBBWCXATlaA7QJNn608FN7zgEYtDt/NvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UgXmVwi2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0A8C4CEEB;
	Thu, 26 Jun 2025 21:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750974443;
	bh=hxQVzBMNwyC88HTo8GzVCXXrinORweyOG/ceTNc1kGM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=UgXmVwi2rCspNSmYuTGBVBB5eZtbt0N8aMBn19wXnNbJDBpzVoKGeEI8qzxdZLWqu
	 1Ynn3B8WPGbXQbmkMpuWmrRzpEElcnoGHQv5OXP6j66CtEr6Szwb0G6kWjDE4+0Evp
	 SmfOa6ipBqiY8TMUW12WOhwBER/p7n3saqwFiWmdHO2ALllJtX+QP5pMHySRCHR3tp
	 H4oLzTFK4nmOUf5SnEGTBdjkW2Dt+Xcp+K4Q+NqVYSq3VRAzx4piP5uFPMlrHovCye
	 uZ7KbYkkIQJeAit/jV3So7jOqhyet5n5U6Gaxdth/dF0Qy0yGwwqF8o/ZYJuUeUUUX
	 3at8xacc2T1Zw==
Date: Thu, 26 Jun 2025 16:47:21 -0500
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
Subject: Re: [PATCH v5 9/9] PCI: Add a new 'boot_display' attribute
Message-ID: <20250626214721.GA1642412@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58625a35-4a3e-4c91-939d-9f0d6635f8c0@kernel.org>

On Thu, Jun 26, 2025 at 04:12:21PM -0500, Mario Limonciello wrote:
> On 6/26/2025 3:45 PM, Bjorn Helgaas wrote:
> > On Tue, Jun 24, 2025 at 03:30:42PM -0500, Mario Limonciello wrote:
> > > From: Mario Limonciello <mario.limonciello@amd.com>
> > > 
> > > On systems with multiple GPUs there can be uncertainty which GPU is the
> > > primary one used to drive the display at bootup. In order to disambiguate
> > > this add a new sysfs attribute 'boot_display' that uses the output of
> > > video_is_primary_device() to populate whether a PCI device was used for
> > > driving the display.
> > > 
> > > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > 
> > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> > 
> > Question below.
> > 
> > > ---
> > > v4:
> > >   * new patch
> > > ---
> > >   Documentation/ABI/testing/sysfs-bus-pci |  9 +++++++++
> > >   drivers/pci/pci-sysfs.c                 | 14 ++++++++++++++
> > >   2 files changed, 23 insertions(+)
> > > 
> > > diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> > > index 69f952fffec72..897cfc1b0de0f 100644
> > > --- a/Documentation/ABI/testing/sysfs-bus-pci
> > > +++ b/Documentation/ABI/testing/sysfs-bus-pci
> > > @@ -612,3 +612,12 @@ Description:
> > >   		  # ls doe_features
> > >   		  0001:01        0001:02        doe_discovery
> > > +
> > > +What:		/sys/bus/pci/devices/.../boot_display
> > > +Date:		October 2025
> > > +Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
> > > +Description:
> > > +		This file indicates whether the device was used as a boot
> > > +		display. If the device was used as the boot display, the file
> > > +		will contain "1". If the device is a display device but wasn't
> > > +		used as a boot display, the file will contain "0".
> > 
> > Is there a reason to expose this file if it wasn't a boot display
> > device?  Maybe it doesn't need to exist at all unless it contains "1"?
> 
> I was mostly thinking that it's a handy way for userspace to know whether
> the kernel even supports this feature.  If userspace sees that file on any
> GPU as it walks a list then it knows it can use that for a hint.
> 
> But if you would rather it only shows up for the boot display yes it's
> possible to do I think.  It's just more complexity to the visibility lookup
> to also call video_is_primary_device().

I think for a singleton situation like this it makes more sense to
only expose the file for one device, not several files where only one
of them contains "1".

> > > diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> > > index 268c69daa4d57..5bbf79b1b953d 100644
> > > --- a/drivers/pci/pci-sysfs.c
> > > +++ b/drivers/pci/pci-sysfs.c
> > > @@ -30,6 +30,7 @@
> > >   #include <linux/msi.h>
> > >   #include <linux/of.h>
> > >   #include <linux/aperture.h>
> > > +#include <asm/video.h>
> > >   #include "pci.h"
> > >   #ifndef ARCH_PCI_DEV_GROUPS
> > > @@ -679,6 +680,13 @@ const struct attribute_group *pcibus_groups[] = {
> > >   	NULL,
> > >   };
> > > +static ssize_t boot_display_show(struct device *dev, struct device_attribute *attr,
> > > +				 char *buf)
> > > +{
> > > +	return sysfs_emit(buf, "%u\n", video_is_primary_device(dev));
> > > +}
> > > +static DEVICE_ATTR_RO(boot_display);
> > > +
> > >   static ssize_t boot_vga_show(struct device *dev, struct device_attribute *attr,
> > >   			     char *buf)
> > >   {
> > > @@ -1698,6 +1706,7 @@ late_initcall(pci_sysfs_init);
> > >   static struct attribute *pci_dev_dev_attrs[] = {
> > >   	&dev_attr_boot_vga.attr,
> > > +	&dev_attr_boot_display.attr,
> > >   	NULL,
> > >   };
> > > @@ -1710,6 +1719,11 @@ static umode_t pci_dev_attrs_are_visible(struct kobject *kobj,
> > >   	if (a == &dev_attr_boot_vga.attr && pci_is_vga(pdev))
> > >   		return a->mode;
> > > +#ifdef CONFIG_VIDEO
> > > +	if (a == &dev_attr_boot_display.attr && pci_is_display(pdev))
> > > +		return a->mode;
> > > +#endif
> > > +
> > >   	return 0;
> > >   }
> > > -- 
> > > 2.43.0
> > > 
> 

