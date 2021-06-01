Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601F3396C58
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 06:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhFAEda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 00:33:30 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2808 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhFAEd3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 00:33:29 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FvJyx5fcLzWqK0;
        Tue,  1 Jun 2021 12:27:05 +0800 (CST)
Received: from dggpemm500022.china.huawei.com (7.185.36.162) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 12:31:47 +0800
Received: from [10.174.185.220] (10.174.185.220) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 12:31:46 +0800
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "Zenghui Yu" <yuzenghui@huawei.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <c9c066ae-2a25-0799-51a7-0ca47fff41a1@huawei.com>
Date:   Tue, 1 Jun 2021 12:31:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.220]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500022.china.huawei.com (7.185.36.162)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/27 15:58, Tian, Kevin wrote:
> /dev/ioasid provides an unified interface for managing I/O page tables for 
> devices assigned to userspace. Device passthrough frameworks (VFIO, vDPA, 
> etc.) are expected to use this interface instead of creating their own logic to 
> isolate untrusted device DMAs initiated by userspace. 
> 
> This proposal describes the uAPI of /dev/ioasid and also sample sequences 
> with VFIO as example in typical usages. The driver-facing kernel API provided 
> by the iommu layer is still TBD, which can be discussed after consensus is 
> made on this uAPI.
> 
> It's based on a lengthy discussion starting from here:
> 	https://lore.kernel.org/linux-iommu/20210330132830.GO2356281@nvidia.com/ 
> 
> It ends up to be a long writing due to many things to be summarized and
> non-trivial effort required to connect them into a complete proposal.
> Hope it provides a clean base to converge.
> 

[..]

> 
> /*
>   * Page fault report and response
>   *
>   * This is TBD. Can be added after other parts are cleared up. Likely it 
>   * will be a ring buffer shared between user/kernel, an eventfd to notify 
>   * the user and an ioctl to complete the fault.
>   *
>   * The fault data is per I/O address space, i.e.: IOASID + faulting_addr
>   */

Hi,

It seems that the ioasid has different usage in different situation, it could
be directly used in the physical routing, or just a virtual handle that indicates
a page table or a vPASID table (such as the GPA address space, in the simple
passthrough case, the DMA input to IOMMU will just contain a Stream ID, no
Substream ID), right?

And Baolu suggested that since one device might consume multiple page tables,
it's more reasonable to have one fault handler per page table. By this, do we
have to maintain such an ioasid info list in the IOMMU layer?

Then if we add host IOPF support (for the GPA address space) in the future
(I have sent a series for this but it aimed for VFIO, I will convert it for
IOASID later [1] :-)), how could we find the handler for the received fault
event which only contains a Stream ID... Do we also have to maintain a
dev(vPASID)->ioasid mapping in the IOMMU layer?

[1] https://lore.kernel.org/patchwork/cover/1410223/

Thanks,
Shenming
