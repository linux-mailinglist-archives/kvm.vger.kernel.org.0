Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A87B25365B
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 20:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgHZSOj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 14:14:39 -0400
Received: from foss.arm.com ([217.140.110.172]:49688 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726241AbgHZSOh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 14:14:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF4DA101E;
        Wed, 26 Aug 2020 11:14:36 -0700 (PDT)
Received: from [10.57.40.122] (unknown [10.57.40.122])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6133E3F71F;
        Wed, 26 Aug 2020 11:14:31 -0700 (PDT)
Subject: Re: [PATCH 0/8] Convert the intel iommu driver to the dma-iommu api
To:     Tom Murphy <murphyt7@tcd.ie>, iommu@lists.linux-foundation.org
Cc:     Heiko Stuebner <heiko@sntech.de>, kvm@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        dri-devel@lists.freedesktop.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-tegra@vger.kernel.org, Julien Grall <julien.grall@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Will Deacon <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        linux-samsung-soc@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-rockchip@lists.infradead.org, Andy Gross <agross@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>
References: <20191221150402.13868-1-murphyt7@tcd.ie>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <03caf286-09e8-a072-8d3a-b6bcca991516@arm.com>
Date:   Wed, 26 Aug 2020 19:14:28 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20191221150402.13868-1-murphyt7@tcd.ie>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tom,

On 2019-12-21 15:03, Tom Murphy wrote:
> This patchset converts the intel iommu driver to the dma-iommu api.
> 
> While converting the driver I exposed a bug in the intel i915 driver which causes a huge amount of artifacts on the screen of my laptop. You can see a picture of it here:
> https://github.com/pippy360/kernelPatches/blob/master/IMG_20191219_225922.jpg
> 
> This issue is most likely in the i915 driver and is most likely caused by the driver not respecting the return value of the dma_map_ops::map_sg function. You can see the driver ignoring the return value here:
> https://github.com/torvalds/linux/blob/7e0165b2f1a912a06e381e91f0f4e495f4ac3736/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c#L51
> 
> Previously this didn’t cause issues because the intel map_sg always returned the same number of elements as the input scatter gather list but with the change to this dma-iommu api this is no longer the case. I wasn’t able to track the bug down to a specific line of code unfortunately.
> 
> Could someone from the intel team look at this?
> 
> 
> I have been testing on a lenovo x1 carbon 5th generation. Let me know if there’s any more information you need.
> 
> To allow my patch set to be tested I have added a patch (patch 8/8) in this series to disable combining sg segments in the dma-iommu api which fixes the bug but it doesn't fix the actual problem.
> 
> As part of this patch series I copied the intel bounce buffer code to the dma-iommu path. The addition of the bounce buffer code took me by surprise. I did most of my development on this patch series before the bounce buffer code was added and my reimplementation in the dma-iommu path is very rushed and not properly tested but I’m running out of time to work on this patch set.
> 
> On top of that I also didn’t port over the intel tracing code from this commit:
> https://github.com/torvalds/linux/commit/3b53034c268d550d9e8522e613a14ab53b8840d8#diff-6b3e7c4993f05e76331e463ab1fc87e1
> So all the work in that commit is now wasted. The code will need to be removed and reimplemented in the dma-iommu path. I would like to take the time to do this but I really don’t have the time at the moment and I want to get these changes out before the iommu code changes any more.

Further to what we just discussed at LPC, I've realised that tracepoints 
are actually something I could do with *right now* for debugging my Arm 
DMA ops series, so if I'm going to hack something up anyway I may as 
well take responsibility for polishing it into a proper patch as well :)

Robin.

> 
> Tom Murphy (8):
>    iommu/vt-d: clean up 32bit si_domain assignment
>    iommu/vt-d: Use default dma_direct_* mapping functions for direct
>      mapped devices
>    iommu/vt-d: Remove IOVA handling code from non-dma_ops path
>    iommu: Handle freelists when using deferred flushing in iommu drivers
>    iommu: Add iommu_dma_free_cpu_cached_iovas function
>    iommu: allow the dma-iommu api to use bounce buffers
>    iommu/vt-d: Convert intel iommu driver to the iommu ops
>    DO NOT MERGE: iommu: disable list appending in dma-iommu
> 
>   drivers/iommu/Kconfig           |   1 +
>   drivers/iommu/amd_iommu.c       |  14 +-
>   drivers/iommu/arm-smmu-v3.c     |   3 +-
>   drivers/iommu/arm-smmu.c        |   3 +-
>   drivers/iommu/dma-iommu.c       | 183 +++++--
>   drivers/iommu/exynos-iommu.c    |   3 +-
>   drivers/iommu/intel-iommu.c     | 936 ++++----------------------------
>   drivers/iommu/iommu.c           |  39 +-
>   drivers/iommu/ipmmu-vmsa.c      |   3 +-
>   drivers/iommu/msm_iommu.c       |   3 +-
>   drivers/iommu/mtk_iommu.c       |   3 +-
>   drivers/iommu/mtk_iommu_v1.c    |   3 +-
>   drivers/iommu/omap-iommu.c      |   3 +-
>   drivers/iommu/qcom_iommu.c      |   3 +-
>   drivers/iommu/rockchip-iommu.c  |   3 +-
>   drivers/iommu/s390-iommu.c      |   3 +-
>   drivers/iommu/tegra-gart.c      |   3 +-
>   drivers/iommu/tegra-smmu.c      |   3 +-
>   drivers/iommu/virtio-iommu.c    |   3 +-
>   drivers/vfio/vfio_iommu_type1.c |   2 +-
>   include/linux/dma-iommu.h       |   3 +
>   include/linux/intel-iommu.h     |   1 -
>   include/linux/iommu.h           |  32 +-
>   23 files changed, 345 insertions(+), 908 deletions(-)
> 
