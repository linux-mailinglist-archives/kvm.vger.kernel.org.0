Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA89735EAEF
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 04:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344702AbhDNCgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 22:36:55 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16909 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhDNCgy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 22:36:54 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FKmlM6j0LzjYxw;
        Wed, 14 Apr 2021 10:34:39 +0800 (CST)
Received: from [10.174.185.226] (10.174.185.226) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Wed, 14 Apr 2021 10:36:23 +0800
To:     Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <jean-philippe@linaro.org>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <will@kernel.org>,
        <maz@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
        <alex.williamson@redhat.com>, <tn@semihalf.com>,
        <zhukeqian1@huawei.com>
CC:     <jacob.jun.pan@linux.intel.com>, <yi.l.liu@intel.com>,
        <zhangfei.gao@linaro.org>, <zhangfei.gao@gmail.com>,
        <vivek.gautam@arm.com>, <shameerali.kolothum.thodi@huawei.com>,
        <yuzenghui@huawei.com>, <nicoleotsuka@gmail.com>,
        <lushenming@huawei.com>, <vsethi@nvidia.com>,
        <chenxiang66@hisilicon.com>, <vdumpa@nvidia.com>,
        <jiangkunkun@huawei.com>
References: <20210411111228.14386-1-eric.auger@redhat.com>
From:   Xingang Wang <wangxingang5@huawei.com>
Subject: Re: [PATCH v15 00/12] SMMUv3 Nested Stage Setup (IOMMU part)
Message-ID: <55930e46-0a45-0d43-b34e-432cf332b42c@huawei.com>
Date:   Wed, 14 Apr 2021 10:36:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210411111228.14386-1-eric.auger@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric, Jean-Philippe

On 2021/4/11 19:12, Eric Auger wrote:
> SMMUv3 Nested Stage Setup (IOMMU part)
> 
> This series brings the IOMMU part of HW nested paging support
> in the SMMUv3. The VFIO part is submitted separately.
> 
> This is based on Jean-Philippe's
> [PATCH v14 00/10] iommu: I/O page faults for SMMUv3
> https://www.spinics.net/lists/arm-kernel/msg886518.html
> (including the patches that were not pulled for 5.13)
> 
> The IOMMU API is extended to support 2 new API functionalities:
> 1) pass the guest stage 1 configuration
> 2) pass stage 1 MSI bindings
> 
> Then those capabilities gets implemented in the SMMUv3 driver.
> 
> The virtualizer passes information through the VFIO user API
> which cascades them to the iommu subsystem. This allows the guest
> to own stage 1 tables and context descriptors (so-called PASID
> table) while the host owns stage 2 tables and main configuration
> structures (STE).
> 
> Best Regards
> 
> Eric
> 
> This series can be found at:
> v5.12-rc6-jean-iopf-14-2stage-v15
> (including the VFIO part in its last version: v13)
> 

I am testing the performance of an accelerator with/without SVA/vSVA,
and found there might be some potential performance loss risk for SVA/vSVA.

I use a Network and computing encryption device (SEC), and send 1MB 
request for 10000 times.

I trigger mm fault before I send the request, so there should be no iopf.

Here's what I got:

physical scenario:
performance:		SVA:9MB/s  	NOSVA:9MB/s
tlb_miss: 		SVA:302,651	NOSVA:1,223
trans_table_walk_access:SVA:302,276	NOSVA:1,237

VM scenario:
performance:		vSVA:9MB/s  	NOvSVA:6MB/s  about 30~40% loss
tlb_miss: 		vSVA:4,423,897	NOvSVA:1,907
trans_table_walk_access:vSVA:61,928,430	NOvSVA:21,948

In physical scenario, there's almost no performance loss, but the 
tlb_miss and trans_table_walk_access of stage 1 for SVA is quite high, 
comparing to NOSVA.

In VM scenario, there's about 30~40% performance loss, this is because 
the two stage tlb_miss and trans_table_walk_access is even higher, and 
impact the performance.

I compare the procedure of building page table of SVA and NOSVA, and 
found that NOSVA uses 2MB mapping as far as possible, while SVA uses 
only 4KB.

I retest with huge page, and huge page could solve this problem, the 
performance of SVA/vSVA is almost the same as NOSVA.

I am wondering do you have any other solution for the performance loss 
of vSVA, or any other method to reduce the tlb_miss/trans_table_walk.

Thanks

Xingang

.
