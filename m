Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675D24515B0
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 21:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238112AbhKOUsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 15:48:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:50346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243939AbhKOUmA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 15:42:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56E5561181;
        Mon, 15 Nov 2021 20:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637008730;
        bh=+MdU1gdoi9Y0H+fD2fxvZbAYwxpeArFFiStYzxrBRt8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Gc+ZpZCFlW9HOVziyYRuqE4eJwj0OMkNSDUIqef+RVb1ECfkLtMSTcD2hNYCXuvnk
         01nJBSp6ieXbE4H/KH74qenlOc4EUkKt7lCluxfg/NSMJelJF3kIPnvpQ+6l7wQgGd
         wYrErNLWfhpJ9Yno3p6LFaiDJgY/JqWOCxPmpI933Zw2CoTyHwaV6eiszNKWe2JSIV
         d0bp7kjEDweS1qBkCDYlW9crnG0uwVBa03wwswB5oVK90g+l90V0IVO5AqARkqRBBv
         r8f/4Y16sbjO2c7BMB4zxxGU6/XAZnDKrD0YBa2XbyeoyRsecAczXwJOj/RL19I+KR
         0Zk8I0UQ/lvBA==
Date:   Mon, 15 Nov 2021 14:38:48 -0600
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
Subject: Re: [PATCH 01/11] iommu: Add device dma ownership set/release
 interfaces
Message-ID: <20211115203848.GA1586192@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115020552.2378167-2-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 10:05:42AM +0800, Lu Baolu wrote:
> From the perspective of who is initiating the device to do DMA, device
> DMA could be divided into the following types:
> 
>         DMA_OWNER_KERNEL: kernel device driver intiates the DMA
>         DMA_OWNER_USER: userspace device driver intiates the DMA

s/intiates/initiates/ (twice)

As your first sentence suggests, the driver doesn't actually
*initiate* the DMA in either case.  One of the drivers programs the
device, and the *device* initiates the DMA.

> DMA_OWNER_KERNEL and DMA_OWNER_USER are exclusive for all devices in
> same iommu group as an iommu group is the smallest granularity of device
> isolation and protection that the IOMMU subsystem can guarantee.

I think this basically says DMA_OWNER_KERNEL and DMA_OWNER_USER are
attributes of the iommu_group (not an individual device), and it
applies to all devices in the iommu_group.  Below, you allude to the
fact that the interfaces are per-device.  It's not clear to me why you
made a per-device interface instead of a per-group interface.

> This
> extends the iommu core to enforce this exclusion when devices are
> assigned to userspace.
> 
> Basically two new interfaces are provided:
> 
>         int iommu_device_set_dma_owner(struct device *dev,
>                 enum iommu_dma_owner mode, struct file *user_file);
>         void iommu_device_release_dma_owner(struct device *dev,
>                 enum iommu_dma_owner mode);
> 
> Although above interfaces are per-device, DMA owner is tracked per group
> under the hood. An iommu group cannot have both DMA_OWNER_KERNEL
> and DMA_OWNER_USER set at the same time. Violation of this assumption
> fails iommu_device_set_dma_owner().
> 
> Kernel driver which does DMA have DMA_OWNER_KENREL automatically
> set/released in the driver binding process (see next patch).

s/DMA_OWNER_KENREL/DMA_OWNER_KERNEL/

> Kernel driver which doesn't do DMA should not set the owner type (via a
> new suppress flag in next patch). Device bound to such driver is considered
> same as a driver-less device which is compatible to all owner types.
> 
> Userspace driver framework (e.g. vfio) should set DMA_OWNER_USER for
> a device before the userspace is allowed to access it, plus a fd pointer to
> mark the user identity so a single group cannot be operated by multiple
> users simultaneously. Vice versa, the owner type should be released after
> the user access permission is withdrawn.
