Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8825C4848F9
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 20:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiADTvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 14:51:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43666 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiADTvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 14:51:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9EF5B817E6;
        Tue,  4 Jan 2022 19:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D451EC36AE0;
        Tue,  4 Jan 2022 19:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641325892;
        bh=cQ/rc+xgMIav90Ds4PeJcvf7zZYgv1fP8vCoGLbssPg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=puPO3nqx7d+GmkSnNXC9G/AwtAKKKIx5FFMh2BSWETEC8piTt3HhpmhgJCm98QHVH
         y/XMmpOWMLQV8NituJS5gbr6X5opgeZDKv81GLIIKzxu+/Jra8SMb6aapkAAvdBWm/
         CBfIMrzJHV7jgzQMomqmxIKesqm7U0pSQzrk2vLUzv1DJ16bzodSZl8Bg7EbEl+a33
         OID1XSa9lqITxrbok2oLDQvq3jfbrRTLbdzRZYwAZduED5Bq/h2mV7r6YLmoa8TlEY
         NqK/Hjk3Od+jbelNeGl+AIUlO71/UfaQ7hGOF44Az+k9Do/OaPiQqToVBZucqfYKrw
         NEQV0vU3TNw6Q==
Date:   Tue, 4 Jan 2022 13:51:30 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 09/14] PCI: portdrv: Suppress kernel DMA ownership
 auto-claiming
Message-ID: <20220104195130.GA117830@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104192614.GL2328285@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 04, 2022 at 03:26:14PM -0400, Jason Gunthorpe wrote:
> On Tue, Jan 04, 2022 at 11:06:31AM -0600, Bjorn Helgaas wrote:
> 
> > > The existing vfio framework allows the portdrv driver to be bound
> > > to the bridge while its downstream devices are assigned to user space.
> > 
> > I.e., the existing VFIO framework allows a switch to be in the same
> > IOMMU group as the devices below it, even though the switch has a
> > kernel driver and the other devices may have userspace drivers?
> 
> Yes, this patch exists to maintain current VFIO behavior which has this
> same check.
> 
> I belive the basis for VFIO doing this is that the these devices
> cannot do DMA, so don't care about the DMA API or the group->domain,
> and do not expose MMIO memory so do not care about the P2P attack.

"These devices" means bridges, right?  Not sure why we wouldn't care
about the P2P attack.

PCIe switches use MSI or MSI-X for hotplug, PME, etc, so they do DMA
for that.  Is that not relevant here?

Is there something that *prohibits* a bridge from having
device-specific functionality including DMA?

I know some bridges have device-specific BARs for performance counters
and the like.
