Return-Path: <kvm+bounces-52950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDEBCB0B3AD
	for <lists+kvm@lfdr.de>; Sun, 20 Jul 2025 08:05:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13F3D17D735
	for <lists+kvm@lfdr.de>; Sun, 20 Jul 2025 06:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61FBB1B424D;
	Sun, 20 Jul 2025 06:05:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C788B76034;
	Sun, 20 Jul 2025 06:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752991535; cv=none; b=M0vpUFVN9ZTozj0SpkqQamF4fyh13RLT8b6CxHdiMt7urO21A0k3JG1H1UVcMVzxIjwI3AE60SKbGcXB3xZN7aLQ+LdNKJZ+k0xddezN1eJvFAQ2eOMfoUXM/bX1yY3lIZtcqwgVR1/sqvmsakSarPbK95aXSlqKMfTV6J5++NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752991535; c=relaxed/simple;
	bh=EF/Qb2UN4gBLnYp6FUujHmxBrvle6XRCikDDgnkVLDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=llGxCx4EubrCpbn+FfQhxay/ULyFHBI6J9dLOCcVoDhhvLWcwWoN26kfrgWEdCXCd6jIse2gQQUAJurm3Tcb7lct3GEdJUcwZgF0LGsSmXiPB3KbxIxRvDZo6/mvvtZviqy5vn1Tjowhnr6oYEBirBdZp7ecVaIH/NpN6ARqYs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.78.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout2.hostsharing.net (Postfix) with ESMTPS id 27A9320091AE;
	Sun, 20 Jul 2025 08:05:25 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 11943CC674; Sun, 20 Jul 2025 08:05:25 +0200 (CEST)
Date: Sun, 20 Jul 2025 08:05:25 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Mario Limonciello <superm1@kernel.org>
Cc: Bjorn Helgaas <helgaas@kernel.org>, David Airlie <airlied@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Simona Vetter <simona@ffwll.ch>,
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
	Daniel Dadap <ddadap@nvidia.com>
Subject: Re: [PATCH v9 9/9] PCI: Add a new 'boot_display' attribute
Message-ID: <aHyHJZwIgEya_yfn@wunner.de>
References: <20250718173648.GA2704349@bhelgaas>
 <c7c8b0bf-8602-4030-acbe-ac56678b633c@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7c8b0bf-8602-4030-acbe-ac56678b633c@kernel.org>

On Fri, Jul 18, 2025 at 12:44:11PM -0500, Mario Limonciello wrote:
> On 7/18/2025 12:36 PM, Bjorn Helgaas wrote:
> > On Fri, Jul 18, 2025 at 12:29:05PM -0500, Mario Limonciello wrote:
> > > On 7/18/2025 12:25 PM, Bjorn Helgaas wrote:
> > > > In addition to Mani's question about whether /sys/bus/pci/ is the
> > > > right place for this (which is a very good question), it's also been
> > > > pointed out to me that we've been trying to get rid of
> > > > pci_create_sysfs_dev_files() for years.
> > > > 
> > > > If it's possible to make this a static attribute that would be much,
> > > > much cleaner.
> > > 
> > > Right - I tried to do this, but the problem is at the time the PCI device is
> > > created the information needed to make the judgement isn't ready.  The
> > > options end up being:
> > > * a sysfs file for every display device with 0/1
> > > * a sysfs file that is not accurate until later in the boot
> > 
> > What's missing?  The specifics might be helpful if someone has another
> > crack at getting rid of pci_create_sysfs_dev_files() in the future.
> 
> The underlying SCREEN_INFO code tries to walk through all the PCI devices in
> a loop, but at the time all the devices are walked the memory regions
> associated with the device weren't populated.
> 
> So my earlier hack was to re-run the screen info check, and it was awful.

Well have you explored the sysfs_update_group() approach you mentioned
earlier?

https://lore.kernel.org/r/5cc01163-1feb-4a18-8060-27f4da39b2e4@kernel.org/

Thanks,

Lukas

