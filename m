Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66726EF5DA
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 15:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241175AbjDZNyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 09:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240750AbjDZNyA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 09:54:00 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B308E618E
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 06:53:59 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F0A9C14;
        Wed, 26 Apr 2023 06:54:43 -0700 (PDT)
Received: from [10.57.22.9] (unknown [10.57.22.9])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5E4643F587;
        Wed, 26 Apr 2023 06:53:58 -0700 (PDT)
Message-ID: <5ff0d72b-a7b8-c8a9-60e5-396e7a1ef363@arm.com>
Date:   Wed, 26 Apr 2023 14:53:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: RMRR device on non-Intel platform
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
References: <20230420081539.6bf301ad.alex.williamson@redhat.com>
 <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
 <20230420084906.2e4cce42.alex.williamson@redhat.com>
 <fd324213-8d77-cb67-1c52-01cd0997a92c@arm.com>
 <20230420154933.1a79de4e.alex.williamson@redhat.com>
 <ZEJ73s/2M4Rd5r/X@nvidia.com> <0aa4a107-57d0-6e5b-46e5-86dbe5b3087f@arm.com>
 <ZEKFdJ6yXoyFiHY+@nvidia.com> <fe7e20e5-9729-248d-ee03-c8b444a1b7c0@arm.com>
 <ZELOqZliiwbG6l5K@nvidia.com> <ZEkRnIPjeLNxbkj8@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <ZEkRnIPjeLNxbkj8@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-04-26 12:57, Jason Gunthorpe wrote:
> On Fri, Apr 21, 2023 at 02:58:01PM -0300, Jason Gunthorpe wrote:
> 
>>> which for practical purposes in this context means an ITS.
>>
>> I haven't delved into it super detail, but.. my impression was..
>>
>> The ITS page only becomes relavent to the IOMMU layer if the actual
>> IRQ driver calls iommu_dma_prepare_msi()
> 
> Nicolin and I sat down and traced this through, this explanation is
> almost right...
> 
> irq-gic-v4.c is some sub module of irq-gic-v3-its.c so it does end up
> calling iommu_dma_prepare_msi() however..

Ignore GICv4; that basically only makes a difference to what happens 
after the CPU receives an interrupt.

> qemu will setup the ACPI so that VM thinks the ITS page is at
> 0x08080000. I think it maps some dummy CPU memory to this address.
> 
> iommufd will map the real ITS page at MSI_IOVA_BASE = 0x8000000 (!!)
> and only into the IOMMU
> 
> qemu will setup some RMRR thing to make 0x8000000 1:1 at the VM's
> IOMMU
> 
> When DMA API is used iommu_dma_prepare_msi() is called which will
> select a MSI page address that avoids the reserved region, so it is
> some random value != 0x8000000 and maps the dummy CPU page to it.
> The VM will then do a MSI-X programming cycle with the S1 IOVA of the
> CPU page and the data. qemu traps this and throws away the address
> from the VM. The kernel sets up the interrupt and assumes 0x8000000
> is the right IOVA.
> 
> When VFIO is used iommufd in the VM will force the MSI window to
> 0x8000000 and instead of putting a 1:1 mapping we map the dummy CPU
> page and then everything is broken. Adding the reserved check is an
> improvement.
> 
> The only way to properly fix this is to have qemu stop throwing away
> the address during the MSI-X programming. This needs to be programmed
> into the device instead.
> 
> I have no idea how best to get there with the ARM GIC setup.. It feels
> really hard.

Give QEMU a way to tell IOMMUFD to associate that 0x08080000 address 
with a given device as an MSI target. IOMMUFD then ensures that the S2 
mapping exists from that IPA to the device's real ITS (I vaguely 
remember Eric had a patch to pre-populate an MSI cookie with specific 
pages, which may have been heading along those lines). In the worst case 
this might mean having to subdivide the per-SMMU copies of the S2 domain 
into per-ITS copies as well, so we'd probably want to detect and compare 
devices' ITS parents up-front.

QEMU will presumably also need a way to pass the VA down to IOMMUFD when 
it sees the guest programming the MSI (possibly it could pass the IPA at 
the same time so we don't need a distinct step to set up S2 beforehand?) 
- once the underlying physical MSI configuration comes back from the PCI 
layer, that VA just needs to be dropped in to replace the original 
msi_msg address.

TBH at that point it may be easier to just not have a cookie in the S2 
domain at all when nesting is enabled, and just let IOMMUFD make the ITS 
mappings directly for itself.

Thanks,
Robin.
