Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1ECB1435D
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 03:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbfEFBla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 May 2019 21:41:30 -0400
Received: from mga04.intel.com ([192.55.52.120]:62134 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbfEFBl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 May 2019 21:41:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 May 2019 18:41:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,435,1549958400"; 
   d="scan'208";a="146639249"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by fmsmga008.fm.intel.com with ESMTP; 05 May 2019 18:41:24 -0700
Cc:     baolu.lu@linux.intel.com, iommu@lists.linux-foundation.org,
        Tom Murphy <murphyt7@tcd.ie>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will.deacon@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Andy Gross <andy.gross@linaro.org>,
        David Brown <david.brown@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC 6/7] iommu/vt-d: convert the intel iommu driver to the
 dma-iommu ops api
To:     Tom Murphy <tmurphy@arista.com>
References: <20190504132327.27041-1-tmurphy@arista.com>
 <20190504132327.27041-7-tmurphy@arista.com>
 <602b77a2-9c68-ad14-b64f-904a7ff27a15@linux.intel.com>
 <CAPL0++57nyLYP1fq=-6zvNS0z_iCqjWLbQ1MsG5F60ODkmRCQQ@mail.gmail.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <2419e94d-bfdb-e70d-bbfd-425671886e99@linux.intel.com>
Date:   Mon, 6 May 2019 09:34:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAPL0++57nyLYP1fq=-6zvNS0z_iCqjWLbQ1MsG5F60ODkmRCQQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 5/6/19 1:03 AM, Tom Murphy wrote:
> On Sun, May 5, 2019 at 3:44 AM Lu Baolu<baolu.lu@linux.intel.com>  wrote:
>> Hi,
>>
>> On 5/4/19 9:23 PM, Tom Murphy wrote:
>>> static int intel_iommu_add_device(struct device *dev)
>>>    {
>>> +     struct dmar_domain *dmar_domain;
>>> +     struct iommu_domain *domain;
>>>        struct intel_iommu *iommu;
>>>        struct iommu_group *group;
>>> -     struct iommu_domain *domain;
>>> +     dma_addr_t base;
>>>        u8 bus, devfn;
>>>
>>>        iommu = device_to_iommu(dev, &bus, &devfn);
>>> @@ -4871,9 +4514,12 @@ static int intel_iommu_add_device(struct device *dev)
>>>        if (IS_ERR(group))
>>>                return PTR_ERR(group);
>>>
>>> +     base = IOVA_START_PFN << VTD_PAGE_SHIFT;
>>>        domain = iommu_get_domain_for_dev(dev);
>>> +     dmar_domain = to_dmar_domain(domain);
>>>        if (domain->type == IOMMU_DOMAIN_DMA)
>>> -             dev->dma_ops = &intel_dma_ops;
>>> +             iommu_setup_dma_ops(dev, base,
>>> +                             __DOMAIN_MAX_ADDR(dmar_domain->gaw) - base);
>> I didn't find the implementation of iommu_setup_dma_ops() in this
>> series. Will the iova resource be initialized in this function?
> Ah sorry, I should've mentioned this is based on the
> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dma-iommu-ops.3
> branch with the "iommu/vt-d: Delegate DMA domain to generic iommu" and
> "iommu/amd: Convert the AMD iommu driver to the dma-iommu api" patch
> sets applied.
> 
>> If so, will this block iommu_group_create_direct_mappings() which
>> reserves and maps the reserved iova ranges.
> The reserved regions will be reserved by the
> iova_reserve_iommu_regions function instead:
> (https://github.com/torvalds/linux/blob/6203838dec05352bc357625b1e9ba0a10d3bca35/drivers/iommu/dma-iommu.c#L238
> )
> iommu_setup_dma_ops calls iommu_dma_init_domain which calls
> iova_reserve_iommu_regions.
> iommu_group_create_direct_mappings will still execute normally but it
> won't be able to call the intel_iommu_apply_resv_region function
> because it's been removed in this patchset.
> This shouldn't change any behavior and the same regions should be reserved.
> 

Okay, I understand it now. Thanks for the explanation.

Best regards,
Lu Baolu
