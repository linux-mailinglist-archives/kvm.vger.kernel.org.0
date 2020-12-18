Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3A72DDF7D
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 09:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732940AbgLRIWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 03:22:53 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9904 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgLRIWw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Dec 2020 03:22:52 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Cy1zZ3NMpz7Gx1;
        Fri, 18 Dec 2020 16:21:30 +0800 (CST)
Received: from [10.174.187.37] (10.174.187.37) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Fri, 18 Dec 2020 16:21:59 +0800
Subject: Re: [PATCH 4/7] vfio: iommu_type1: Fix missing dirty page when
 promote pinned_scope
To:     Alex Williamson <alex.williamson@redhat.com>
References: <20201210073425.25960-1-zhukeqian1@huawei.com>
 <20201210073425.25960-5-zhukeqian1@huawei.com>
 <20201214170459.50cb8729@omen.home>
 <d2073c05-b6c9-04b4-782c-b89680834633@huawei.com>
 <20201215085359.053e73ed@x1.home>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Cornelia Huck <cohuck@redhat.com>,
        "Marc Zyngier" <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <340a58c3-3781-db31-59fa-06b015d27a5e@huawei.com>
Date:   Fri, 18 Dec 2020 16:21:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20201215085359.053e73ed@x1.home>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.37]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/12/15 23:53, Alex Williamson wrote:
> On Tue, 15 Dec 2020 17:37:11 +0800
> zhukeqian <zhukeqian1@huawei.com> wrote:
> 
>> Hi Alex,
>>
>> On 2020/12/15 8:04, Alex Williamson wrote:
[...]

>>>>  
>>>> +static void vfio_populate_bitmap_all(struct vfio_iommu *iommu)
>>>> +{
>>>> +	struct rb_node *n;
>>>> +	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
>>>> +
>>>> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
>>>> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
>>>> +		unsigned long nbits = dma->size >> pgshift;
>>>> +
>>>> +		if (dma->iommu_mapped)
>>>> +			bitmap_set(dma->bitmap, 0, nbits);
>>>> +	}
>>>> +}  
>>>
>>>
>>> If we detach a group which results in only non-IOMMU backed mdevs,
>>> don't we also clear dma->iommu_mapped as part of vfio_unmap_unpin()
>>> such that this test is invalid?  Thanks,  
>>
>> Good spot :-). The code will skip bitmap_set under this situation.
>>
>> We should set the bitmap unconditionally when vfio_iommu is promoted,
>> as we must have IOMMU backed domain before promoting the vfio_iommu.
>>
>> Besides, I think we should also mark dirty in vfio_remove_dma if dirty
>> tracking is active. Right?
> 
> There's no remaining bitmap to mark dirty if the vfio_dma is removed.
> In this case it's the user's responsibility to collect remaining dirty
> pages using the VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP support in the
> VFIO_IOMMU_UNMAP_DMA ioctl.  Thanks,
> 
Hi Alex,

Thanks for pointing it out. I also notice that vfio_iommu_type1_detach_group
will remove all dma_range (in vfio_iommu_unmap_unpin_all). If this happens
during dirty tracking, then we have no chance to report dirty log to userspace.

Besides, we will add more dirty log tracking ways to VFIO definitely, but
we has no framework to support this, thus makes it inconvenient to extend
and easy to lost dirty log.

Giving above, I plan to refactor our dirty tracking code. One core idea is
that we should distinguish Dirty Range Limit (such as pin, fully dirty) and
Real Dirty Track (such as iopf, smmu httu).

Thanks,
Keqian
