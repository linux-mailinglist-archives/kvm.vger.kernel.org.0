Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8906B485F69
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 04:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbiAFDyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 22:54:53 -0500
Received: from mga03.intel.com ([134.134.136.65]:44919 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231468AbiAFDyw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 22:54:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641441292; x=1672977292;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Rqej3wXaYOK+xVJk5ty5fNj2P0uGjYEUdNVw2YgTyps=;
  b=FLyzp0sMj0jFH0nc2xFJ/3Jgg34pLzCbW7Wob/IosAYq5xi5i9QIcw8o
   pwOYx3YclGxF4bNImqc3w4xWtgtqPEIAKIQjnMNHGJbRVmriewIK5p6X9
   YXndrZ1YRCQCppQ29DMevbS+lEWCdOQ7Ixt4Sm9WGPN+nY/8kfv4WgVNo
   PEuDKxjD91kNQ4KxVoQhJ/y8BZLfgR6ofQ2bqoRtJU9iqqCro0R0B9fpR
   Z7zI/DZ4DmsmVV8xFO6/PN80UKoTKkzoccebRm0CmEKlZ7IqL1ieTyJ/i
   XVXYL239zRwXPsZAAXzO3ZycWicrhiP4Av1ppFea5Nu/tX3STtQUk9VgR
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242540472"
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="242540472"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 19:54:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="526816309"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 05 Jan 2022 19:54:45 -0800
Cc:     baolu.lu@linux.intel.com, Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
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
Subject: Re: [PATCH v5 01/14] iommu: Add dma ownership management interfaces
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Bjorn Helgaas <helgaas@kernel.org>
References: <YdQcgFhIMYvUwABV@infradead.org>
 <20220104164100.GA101735@bhelgaas> <20220104192348.GK2328285@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <9486face-0778-b8d0-6989-94c2e876446b@linux.intel.com>
Date:   Thu, 6 Jan 2022 11:54:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220104192348.GK2328285@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/22 3:23 AM, Jason Gunthorpe wrote:
>>>> The device driver oriented interfaces are,
>>>>
>>>> 	int iommu_device_use_dma_api(struct device *dev);
>>>> 	void iommu_device_unuse_dma_api(struct device *dev);
>> Nit, do we care whether it uses the actual DMA API?  Or is it just
>> that iommu_device_use_dma_api() tells us the driver may program the
>> device to do DMA?
> As the main purpose, yes this is all about the DMA API because it
> asserts the group domain is the DMA API's domain.
> 
> There is a secondary purpose that has to do with the user/kernel
> attack you mentioned above. Maintaining the DMA API domain also
> prevents VFIO from allowing userspace to operate any device in the
> group which blocks P2P attacks to MMIO of other devices.
> 
> This is why, even if the driver doesn't use DMA, it should still do a
> iommu_device_use_dma_api(), except in the special cases where we don't
> care about P2P attacks (eg pci-stub, bridges, etc).
> 

By the way, use_dma_api seems hard to read. How about

	iommu_device_use_default_dma()?

Best regards,
baolu
