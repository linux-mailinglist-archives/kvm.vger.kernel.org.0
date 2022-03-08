Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7955D4D1952
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 14:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236036AbiCHNi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 08:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347167AbiCHNiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 08:38:13 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 97CF949906;
        Tue,  8 Mar 2022 05:37:16 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 513A2139F;
        Tue,  8 Mar 2022 05:37:16 -0800 (PST)
Received: from [10.57.41.254] (unknown [10.57.41.254])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B013C3FA58;
        Tue,  8 Mar 2022 05:37:10 -0800 (PST)
Message-ID: <d8bbe591-b6c3-d44a-7a7d-3187e8377e4f@arm.com>
Date:   Tue, 8 Mar 2022 13:37:05 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v8 01/11] iommu: Add DMA ownership management interfaces
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
Cc:     kvm@vger.kernel.org, rafael@kernel.org,
        David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
References: <20220308054421.847385-1-baolu.lu@linux.intel.com>
 <20220308054421.847385-2-baolu.lu@linux.intel.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220308054421.847385-2-baolu.lu@linux.intel.com>
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
> Multiple devices may be placed in the same IOMMU group because they
> cannot be isolated from each other. These devices must either be
> entirely under kernel control or userspace control, never a mixture.
> 
> This adds dma ownership management in iommu core and exposes several
> interfaces for the device drivers and the device userspace assignment
> framework (i.e. VFIO), so that any conflict between user and kernel
> controlled dma could be detected at the beginning.
> 
> The device driver oriented interfaces are,
> 
> 	int iommu_device_use_default_domain(struct device *dev);
> 	void iommu_device_unuse_default_domain(struct device *dev);
> 
> By calling iommu_device_use_default_domain(), the device driver tells
> the iommu layer that the device dma is handled through the kernel DMA
> APIs. The iommu layer will manage the IOVA and use the default domain
> for DMA address translation.
> 
> The device user-space assignment framework oriented interfaces are,
> 
> 	int iommu_group_claim_dma_owner(struct iommu_group *group,
> 					void *owner);
> 	void iommu_group_release_dma_owner(struct iommu_group *group);
> 	bool iommu_group_dma_owner_claimed(struct iommu_group *group);
> 
> The device userspace assignment must be disallowed if the DMA owner
> claiming interface returns failure.

Reviewed-by: Robin Murphy <robin.murphy@arm.com>

> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
