Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCBB44D195D
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 14:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237420AbiCHNlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 08:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbiCHNk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 08:40:59 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D4D3F48E78;
        Tue,  8 Mar 2022 05:40:02 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 756F3139F;
        Tue,  8 Mar 2022 05:40:02 -0800 (PST)
Received: from [10.57.41.254] (unknown [10.57.41.254])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD2C73FA58;
        Tue,  8 Mar 2022 05:39:56 -0800 (PST)
Message-ID: <400b2dd3-120b-9728-3990-801b53447a2b@arm.com>
Date:   Tue, 8 Mar 2022 13:39:51 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v8 04/11] bus: platform,amba,fsl-mc,PCI: Add device DMA
 ownership management
Content-Language: en-GB
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Will Deacon <will@kernel.org>,
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
References: <20220308054421.847385-1-baolu.lu@linux.intel.com>
 <20220308054421.847385-5-baolu.lu@linux.intel.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220308054421.847385-5-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-03-08 05:44, Lu Baolu wrote:
> The devices on platform/amba/fsl-mc/PCI buses could be bound to drivers
> with the device DMA managed by kernel drivers or user-space applications.
> Unfortunately, multiple devices may be placed in the same IOMMU group
> because they cannot be isolated from each other. The DMA on these devices
> must either be entirely under kernel control or userspace control, never
> a mixture. Otherwise the driver integrity is not guaranteed because they
> could access each other through the peer-to-peer accesses which by-pass
> the IOMMU protection.
> 
> This checks and sets the default DMA mode during driver binding, and
> cleanups during driver unbinding. In the default mode, the device DMA is
> managed by the device driver which handles DMA operations through the
> kernel DMA APIs (see Documentation/core-api/dma-api.rst).
> 
> For cases where the devices are assigned for userspace control through the
> userspace driver framework(i.e. VFIO), the drivers(for example, vfio_pci/
> vfio_platfrom etc.) may set a new flag (driver_managed_dma) to skip this
> default setting in the assumption that the drivers know what they are
> doing with the device DMA.
> 
> Calling iommu_device_use_default_domain() before {of,acpi}_dma_configure
> is currently a problem. As things stand, the IOMMU driver ignored the
> initial iommu_probe_device() call when the device was added, since at
> that point it had no fwspec yet. In this situation,
> {of,acpi}_iommu_configure() are retriggering iommu_probe_device() after
> the IOMMU driver has seen the firmware data via .of_xlate to learn that
> it actually responsible for the given device. As the result, before
> that gets fixed, iommu_use_default_domain() goes at the end, and calls
> arch_teardown_dma_ops() if it fails.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Stuart Yoder <stuyoder@gmail.com>
> Cc: Laurentiu Tudor <laurentiu.tudor@nxp.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Robin Murphy <robin.murphy@arm.com>
