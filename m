Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695FB4F857B
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 19:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238181AbiDGRFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 13:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiDGRFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 13:05:46 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 68C6DE6E
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 10:03:45 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1156512FC;
        Thu,  7 Apr 2022 10:03:45 -0700 (PDT)
Received: from [10.57.41.19] (unknown [10.57.41.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 13CC83F5A1;
        Thu,  7 Apr 2022 10:03:42 -0700 (PDT)
Message-ID: <f5acf507-b4ef-b393-159c-05ca04feb43d@arm.com>
Date:   Thu, 7 Apr 2022 18:03:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 0/4] Make the iommu driver no-snoop block feature
 consistent
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
References: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-04-07 16:23, Jason Gunthorpe wrote:
> PCIe defines a 'no-snoop' bit in each the TLP which is usually implemented
> by a platform as bypassing elements in the DMA coherent CPU cache
> hierarchy. A driver can command a device to set this bit on some of its
> transactions as a micro-optimization.
> 
> However, the driver is now responsible to synchronize the CPU cache with
> the DMA that bypassed it. On x86 this may be done through the wbinvd
> instruction, and the i915 GPU driver is the only Linux DMA driver that
> calls it.
> 
> The problem comes that KVM on x86 will normally disable the wbinvd
> instruction in the guest and render it a NOP. As the driver running in the
> guest is not aware the wbinvd doesn't work it may still cause the device
> to set the no-snoop bit and the platform will bypass the CPU cache.
> Without a working wbinvd there is no way to re-synchronize the CPU cache
> and the driver in the VM has data corruption.
> 
> Thus, we see a general direction on x86 that the IOMMU HW is able to block
> the no-snoop bit in the TLP. This NOP's the optimization and allows KVM to
> to NOP the wbinvd without causing any data corruption.
> 
> This control for Intel IOMMU was exposed by using IOMMU_CACHE and
> IOMMU_CAP_CACHE_COHERENCY, however these two values now have multiple
> meanings and usages beyond blocking no-snoop and the whole thing has
> become confused. AMD IOMMU has the same feature and same IOPTE bits
> however it unconditionally blocks no-snoop.
> 
> Change it so that:
>   - IOMMU_CACHE is only about the DMA coherence of normal DMAs from a
>     device. It is used by the DMA API/VFIO/etc when the user of the
>     iommu_domain will not be doing manual cache coherency operations.
> 
>   - IOMMU_CAP_CACHE_COHERENCY indicates if IOMMU_CACHE can be used with the
>     device.
> 
>   - The new optional domain op enforce_cache_coherency() will cause the
>     entire domain to block no-snoop requests - ie there is no way for any
>     device attached to the domain to opt out of the IOMMU_CACHE behavior.
>     This is permanent on the domain and must apply to any future devices
>     attached to it.
> 
> Ideally an iommu driver should implement enforce_cache_coherency() so that
> by DMA API domains allow the no-snoop optimization. This leaves it
> available to kernel drivers like i915. VFIO will call
> enforce_cache_coherency() before establishing any mappings and the domain
> should then permanently block no-snoop.
> 
> If enforce_cache_coherency() fails VFIO will communicate back through to
> KVM into the arch code via kvm_arch_register_noncoherent_dma()
> (only implemented by x86) which triggers a working wbinvd to be made
> available to the VM.
> 
> While other iommu drivers are certainly welcome to implement
> enforce_cache_coherency(), it is not clear there is any benefit in doing
> so right now.
> 
> This is on github: https://github.com/jgunthorpe/linux/commits/intel_no_snoop
> 
> v2:
>   - Abandon removing IOMMU_CAP_CACHE_COHERENCY - instead make it the cap
>     flag that indicates IOMMU_CACHE is supported
>   - Put the VFIO tests for IOMMU_CACHE at VFIO device registration
>   - In the Intel driver remove the domain->iommu_snooping value, this is
>     global not per-domain

At a glance, this all looks about the right shape to me now, thanks!

Ideally I'd hope patch #4 could go straight to device_iommu_capable() 
from my Thunderbolt series, but we can figure that out in a couple of 
weeks once Joerg starts queueing 5.19 material. I've got another VFIO 
patch waiting for the DMA ownership series to land anyway, so it's 
hardly the end of the world if I have to come back to follow up on this 
one too.

For the series,

Acked-by: Robin Murphy <robin.murphy@arm.com>

> v1: https://lore.kernel.org/r/0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com
> 
> Jason Gunthorpe (4):
>    iommu: Introduce the domain op enforce_cache_coherency()
>    vfio: Move the Intel no-snoop control off of IOMMU_CACHE
>    iommu: Redefine IOMMU_CAP_CACHE_COHERENCY as the cap flag for
>      IOMMU_CACHE
>    vfio: Require that devices support DMA cache coherence
> 
>   drivers/iommu/amd/iommu.c       |  7 +++++++
>   drivers/iommu/intel/iommu.c     | 17 +++++++++++++----
>   drivers/vfio/vfio.c             |  7 +++++++
>   drivers/vfio/vfio_iommu_type1.c | 30 +++++++++++++++++++-----------
>   include/linux/intel-iommu.h     |  2 +-
>   include/linux/iommu.h           |  7 +++++--
>   6 files changed, 52 insertions(+), 18 deletions(-)
> 
> 
> base-commit: 3123109284176b1532874591f7c81f3837bbdc17
