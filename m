Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDBF453AD9
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 21:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbhKPUZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 15:25:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:45858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229456AbhKPUZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 15:25:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A201617E4;
        Tue, 16 Nov 2021 20:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637094123;
        bh=8Nzv2cPbd00BDsI1fAdB/LfuCL2nT15qZoftCaEc4tM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Gjg3zvVxAKilsJ3ONEcJx/zQWFsZfUCfzp+owCZnqhbIuQj8qRiRqMapWs1aNYMy6
         A2XIAJJrYp+vFy3CDfT5L4Mt+U3jxLDClzYAbOWx2aYDYkG6dZysYJGZKiKao0sfO5
         gAJtbWVHAkH6qpNZ6gFYP5//vTvuLP3GTIkBK9fHxkd+yZOE0/VOerNpE5U9XE7MPJ
         3p39EWggDyJsR4mRE/wsMglgC3ZS6/vT0Am13HjFNr7aFFu5duBkksG2RSxHnfVAuO
         4FuhU2dai49w1dyKDdKAC2xRqVnBib2wih+bHW8GlvOVER7qcODYeIQi6j4/LtprVM
         UkP2T7LCnZu5Q==
Date:   Tue, 16 Nov 2021 14:22:01 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        rafael@kernel.org, Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/11] PCI: portdrv: Suppress kernel DMA ownership
 auto-claiming
Message-ID: <20211116202201.GA1676368@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f95bea7-3c1c-4f12-aed5-a3fcdcd3fee3@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021 at 03:24:29PM +0800, Lu Baolu wrote:
> On 2021/11/16 4:44, Bjorn Helgaas wrote:
> > On Mon, Nov 15, 2021 at 10:05:45AM +0800, Lu Baolu wrote:
> > > IOMMU grouping on PCI necessitates that if we lack isolation on a bridge
> > > then all of the downstream devices will be part of the same IOMMU group
> > > as the bridge.
> > 
> > I think this means something like: "If a PCIe Switch Downstream Port
> > lacks <a specific set of ACS capabilities>, all downstream devices
> > will be part of the same IOMMU group as the switch," right?
> 
> For this patch, yes.
> 
> > If so, can you fill in the details to make it specific and concrete?
> 
> The existing vfio implementation allows a kernel driver to bind with a
> PCI bridge while its downstream devices are assigned to the user space
> though there lacks ACS-like isolation in bridge.
> 
> drivers/vfio/vfio.c:
>  540 static bool vfio_dev_driver_allowed(struct device *dev,
>  541                                     struct device_driver *drv)
>  542 {
>  543         if (dev_is_pci(dev)) {
>  544                 struct pci_dev *pdev = to_pci_dev(dev);
>  545
>  546                 if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
>  547                         return true;
>  548         }
> 
> We are moving the group viability check to IOMMU core, and trying to
> make it compatible with the current vfio policy. We saw three types of
> bridges:
> 
> #1) PCIe/PCI-to-PCI bridges
>     These bridges are configured in the PCI framework, there's no
>     dedicated driver for such devices.
> 
> #2) Generic PCIe switch downstream port
>     The port driver doesn't map and access any MMIO in the PCI BAR.
>     The iommu group is viable to user even this driver is bound.
> 
> #3) Hot Plug Controller
>     The controller driver maps and access the device MMIO. The iommu
>     group is not viable to user with this driver bound to its device.

I *guess* the question here is whether the bridge can or will do DMA?

I think that's orthogonal to the question of whether it implements
BARs, so I'm not sure why the MMIO BARs are part of this discussion.
I assume it's theoretically possible for a driver to use registers in
config space to program a device to do DMA, even if the device has no
BARs.

Bjorn
