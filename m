Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02FFF4F96A3
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 15:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236226AbiDHNaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 09:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiDHNaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 09:30:13 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 403A5AE
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 06:28:10 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 05A02113E;
        Fri,  8 Apr 2022 06:28:10 -0700 (PDT)
Received: from [10.57.41.19] (unknown [10.57.41.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 40AE63F5A1;
        Fri,  8 Apr 2022 06:28:07 -0700 (PDT)
Message-ID: <d6b1c72b-c05e-8bd8-c0cb-38e6c7ccfdb6@arm.com>
Date:   Fri, 8 Apr 2022 14:28:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 4/4] vfio: Require that devices support DMA cache
 coherence
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <4-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <BN9PR11MB52764BF8AC747D4B2E2B8BAA8CE99@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220408122256.GV2120790@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220408122256.GV2120790@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-04-08 13:22, Jason Gunthorpe wrote:
> On Fri, Apr 08, 2022 at 08:26:10AM +0000, Tian, Kevin wrote:
>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>> Sent: Thursday, April 7, 2022 11:24 PM
>>>
>>> IOMMU_CACHE means that normal DMAs do not require any additional
>>> coherency
>>> mechanism and is the basic uAPI that VFIO exposes to userspace. For
>>> instance VFIO applications like DPDK will not work if additional coherency
>>> operations are required.
>>>
>>> Therefore check IOMMU_CAP_CACHE_COHERENCY like vdpa & usnic do
>>> before
>>> allowing an IOMMU backed VFIO device to be created.
>>>
>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>>   drivers/vfio/vfio.c | 7 +++++++
>>>   1 file changed, 7 insertions(+)
>>>
>>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>>> index a4555014bd1e72..9edad767cfdad3 100644
>>> +++ b/drivers/vfio/vfio.c
>>> @@ -815,6 +815,13 @@ static int __vfio_register_dev(struct vfio_device
>>> *device,
>>>
>>>   int vfio_register_group_dev(struct vfio_device *device)
>>>   {
>>> +	/*
>>> +	 * VFIO always sets IOMMU_CACHE because we offer no way for
>>> userspace to
>>> +	 * restore cache coherency.
>>> +	 */
>>> +	if (!iommu_capable(device->dev->bus,
>>> IOMMU_CAP_CACHE_COHERENCY))
>>> +		return -EINVAL;
>>> +
>>
>> One nit. Is it logistically more reasonable to put this patch before
>> changing VFIO to always set IOMMU_CACHE?
> 
> For bisectability it has to be after
> 
>      iommu: Redefine IOMMU_CAP_CACHE_COHERENCY as the cap flag for IOMMU_CACHE
> 
> Otherwise Intel iommu will stop working with VFIO
> 
> The ordering is OK as is because no IOMMU that works with VFIO cares
> about IOMMU_CACHE.

The Arm SMMU drivers do (without it even coherent traffic would be 
downgraded to non-cacheable), but then they also handle 
IOMMU_CAP_CACHE_COHERENCY nonsensically, and it happens to work out 
since AFAIK there aren't (yet) any Arm-based systems where you can 
reasonably try to use VFIO that don't also have hardware-coherent PCI. 
Thus I don't think there's any risk of regression for us here.

Robin.
