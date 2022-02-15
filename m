Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B674B6CEF
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 14:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238055AbiBONDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 08:03:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbiBONDR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 08:03:17 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E8899FB52;
        Tue, 15 Feb 2022 05:03:07 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C0581480;
        Tue, 15 Feb 2022 05:03:07 -0800 (PST)
Received: from [10.57.70.89] (unknown [10.57.70.89])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D094A3F718;
        Tue, 15 Feb 2022 05:03:02 -0800 (PST)
Message-ID: <b2fd22a1-b52b-8eb1-91e9-9829830f1400@arm.com>
Date:   Tue, 15 Feb 2022 13:02:58 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v1 5/8] iommu/amd: Use iommu_attach/detach_device()
Content-Language: en-GB
To:     Joerg Roedel <joro@8bytes.org>, Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
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
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-6-baolu.lu@linux.intel.com>
 <20220106143345.GC2328285@nvidia.com> <Ygo8iek2CwtPp2hj@8bytes.org>
 <20220214131544.GX4160@nvidia.com> <Ygpb6CxmTdUHiN50@8bytes.org>
 <20220214140236.GC929467@nvidia.com> <YgplyyjofwlM+1tc@8bytes.org>
 <20220214150059.GE4160@nvidia.com> <YgtuJQhY8SNlv9/6@8bytes.org>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <YgtuJQhY8SNlv9/6@8bytes.org>
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

On 2022-02-15 09:11, Joerg Roedel wrote:
> On Mon, Feb 14, 2022 at 11:00:59AM -0400, Jason Gunthorpe wrote:
>> On Mon, Feb 14, 2022 at 03:23:07PM +0100, Joerg Roedel wrote:
>>
>>> Device drivers calling into iommu_attach_device() is seldom a good
>>> idea.  In this case the sound device has some generic hardware
>>> interface so that an existing sound driver can be re-used. Making this
>>> driver call iommu-specific functions for some devices is something hard
>>> to justify.
>>
>> Er, so this is transparent to the generic sound device? I guess
>> something fixed up the dma_api on that device to keep working?
> 
> Right, this is completly transparent to the sound device. The IOMMU code
> will not set dma_ops on the device because it uses a direct mapping and
> so the standard implementation will be used.
> 
>> But, then, the requirement is that nobody is using the dma API when we
>> make this change?
> 
> That is the tricky part. DMA-API keeps working after the change is made,
> because the new domain is also direct mapped. The new domain just has
> the ability to assign host page-tables to device PASIDs, so that DMA
> requests with a PASID TLP will be remapped.
> 
> It was actually a requirement for this code that when it jumps in, the
> DMA-API mappings stay live. And the reason a direct mapping is used at
> all is that the page-table walker of the IOMMU is a two-dimensional
> walker, which will treat the addresses found in the host page-tables as
> IO-virtual an translates them through the underlying page-table. So to
> use host-pagetables the underlying mapping must be direct mapped.

Given how things have evolved since that code was originally written, 
and that we seemingly now have the def_domain_type override kicking in 
as soon as we first see an IOMMUv2-capable device, do we even need to 
then subsequently switch to this special unmanaged domain with its 
pagetable sucked out, or could we just install the PASID table in the 
default domain itself?

Robin.

>> I don't think it matters how big/small the group is, only that when we
>> change the domain we know everything flowing through the domain is
>> still happy.
> 
> Yes, that matters. The group size matters too for DMA-API performance.
> If two devices compete for the same lock in the allocator and/or the
> same cached magazines, things will slow down. That only matters for
> high-throughput devices, but still...
> 
> Regards,
> 
> 	Joerg
> 
