Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531DC47853B
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 07:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbhLQGlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 01:41:51 -0500
Received: from mga17.intel.com ([192.55.52.151]:27464 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229757AbhLQGlu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 01:41:50 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="220374412"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="220374412"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 22:41:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="506653245"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga007.jf.intel.com with ESMTP; 16 Dec 2021 22:41:43 -0800
Cc:     baolu.lu@linux.intel.com, Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH v3 00/18] Fix BUG_ON in vfio_iommu_group_notifier()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <acdb63ca-bb13-6688-0914-c1c979151d60@linux.intel.com>
Date:   Fri, 17 Dec 2021 14:41:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211206015903.88687-1-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/21 9:58 AM, Lu Baolu wrote:
> Hi folks,
> 
> The iommu group is the minimal isolation boundary for DMA. Devices in
> a group can access each other's MMIO registers via peer to peer DMA
> and also need share the same I/O address space.
> 
> Once the I/O address space is assigned to user control it is no longer
> available to the dma_map* API, which effectively makes the DMA API
> non-working.
> 
> Second, userspace can use DMA initiated by a device that it controls
> to access the MMIO spaces of other devices in the group. This allows
> userspace to indirectly attack any kernel owned device and it's driver.
> 
> Therefore groups must either be entirely under kernel control or
> userspace control, never a mixture. Unfortunately some systems have
> problems with the granularity of groups and there are a couple of
> important exceptions:
> 
>   - pci_stub allows the admin to block driver binding on a device and
>     make it permanently shared with userspace. Since PCI stub does not
>     do DMA it is safe, however the admin must understand that using
>     pci_stub allows userspace to attack whatever device it was bound
>     it.
> 
>   - PCI bridges are sometimes included in groups. Typically PCI bridges
>     do not use DMA, and generally do not have MMIO regions.
> 
> Generally any device that does not have any MMIO registers is a
> possible candidate for an exception.
> 
> Currently vfio adopts a workaround to detect violations of the above
> restrictions by monitoring the driver core BOUND event, and hardwiring
> the above exceptions. Since there is no way for vfio to reject driver
> binding at this point, BUG_ON() is triggered if a violation is
> captured (kernel driver BOUND event on a group which already has some
> devices assigned to userspace). Aside from the bad user experience
> this opens a way for root userspace to crash the kernel, even in high
> integrity configurations, by manipulating the module binding and
> triggering the BUG_ON.
> 
> This series solves this problem by making the user/kernel ownership a
> core concept at the IOMMU layer. The driver core enforces kernel
> ownership while drivers are bound and violations now result in a error
> codes during probe, not BUG_ON failures.
> 
> Patch partitions:
>    [PATCH 1-9]: Detect DMA ownership conflicts during driver binding;
>    [PATCH 10-13]: Add security context management for assigned devices;
>    [PATCH 14-18]: Various cleanups.
> 
> This is part one of three initial series for IOMMUFD:
>   * Move IOMMU Group security into the iommu layer
>   - Generic IOMMUFD implementation
>   - VFIO ability to consume IOMMUFD

Thank you very much for reviewing my series. The v4 of this series has
been posted here:

https://lore.kernel.org/linux-iommu/20211217063708.1740334-1-baolu.lu@linux.intel.com/

Best regards,
baolu
