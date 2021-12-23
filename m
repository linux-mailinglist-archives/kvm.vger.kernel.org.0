Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6F247DD99
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 03:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242626AbhLWCIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 21:08:43 -0500
Received: from mga06.intel.com ([134.134.136.31]:27609 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229788AbhLWCIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 21:08:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640225322; x=1671761322;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=U3C5yVoX5E5uvujjF66oQQmBBqdF/yUhDK/aFppaBqg=;
  b=TbNJhDRKor6O4L53WjQ4e5SC4yAcIm8ODaRpiL9vF7mKIcVlsPjD2Oc3
   uno4ictJPYbDat8uCqxJdaq5i/glyEREoTBsukfQpKqrCPXW9RQ+chJFB
   A2f5Y/MFgKqLITvFjiA1SBln8qodSzdYcJAL0b+1c1QIC36WXVehWK/Sg
   VPvZERXfOvAgs6m0WUtUettp7IdoLscbYJY9M8F5eSUSa4KFGjtHTynu9
   iSNbvn9cTqP3yrCUPVSFeZXKLWtx4luUSOhLQ2x1mBlAVCllX77vMcNXp
   Uhpfty/blmDbniLCg1K+0zJGO5fx4v2mG2LUvQKykE9Z6GDtKlA5GmXgm
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="301503759"
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="301503759"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 18:08:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="664445608"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 22 Dec 2021 18:08:35 -0800
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
Subject: Re: [PATCH v4 02/13] driver core: Set DMA ownership during driver
 bind/unbind
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
 <20211217063708.1740334-3-baolu.lu@linux.intel.com>
 <YcMeZlN3798noycN@kroah.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <40d67b07-b56b-d626-f71b-54ef5c80275c@linux.intel.com>
Date:   Thu, 23 Dec 2021 10:08:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YcMeZlN3798noycN@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Greg,

On 12/22/21 8:47 PM, Greg Kroah-Hartman wrote:
> Which one will actually care about the iommu_device_set_dma_owner()
> call?  All of them?  None of them?  Some of them?
> 
> Again, why can't this just happen in the (very few) bus callbacks that
> care about this?  In following patches in this series, you turn off this
> for the pci_dma_configure users, so what is left?  3 odd bus types that
> are not used often.  How well did you test devices of those types with
> this patchset?
> 
> It's fine to have "suppress" fields when they are the minority, but here
> it's a_very_  tiny tiny number of actual devices in a system that will
> ever get the chance to have this check happen for them and trigger,
> right?

Thank you for your comments. Current VFIO implementation supports
devices on pci/platform/amba/fls-mc buses for user-space DMA. So only
those buses need to call iommu_device_set/release_dma_owner() in their
dma_configure/cleanup() callbacks.

The "suppress" field is only for a few device drivers (not devices), for
example,

- vfio-pci, a PCI device driver used to bind to a PCI device so that it
   could be assigned for user-space DMA.

Other similar drivers in drivers/vfio are vfio-fsl-mc, vfio-amba and
vfio-platform. These drivers will call
iommu_device_set/release_dma_owner(DMA_OWNER_USER) explicitly when the
device is assigned to user.

The logic is that on the affected buses (pci/platform/amba/fls-mc),

- for non-vfio drivers, bus dma_configure/cleanup() will automatically
   call iommu_device_set_dma_owner(KERNEL) for the device; [This is the
   majority cases.]

- for vfio drivers, the auto-call will be suppressed, and the vfio
   drivers are supposed to call iommu_device_set_dma_owner(USER) before
   device is assigned to the userspace. [This is the rare case.]

The KERNEL and USER conflict will be detected in
iommu_device_set_dma_owner() with a -EBUSY return value. In that case,
the driver binding or device assignment should be aborted.

Best regards,
baolu
