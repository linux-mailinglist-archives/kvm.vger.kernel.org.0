Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8DE3C966F
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 05:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbhGODXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 23:23:41 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6931 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhGODXk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 23:23:40 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GQKKz5SXlz7tWX;
        Thu, 15 Jul 2021 11:17:11 +0800 (CST)
Received: from dggpemm500022.china.huawei.com (7.185.36.162) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Jul 2021 11:20:44 +0800
Received: from [10.174.185.67] (10.174.185.67) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Jul 2021 11:20:43 +0800
Subject: Re: [RFC v2] /dev/iommu uAPI proposal
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <7ea349f8-8c53-e240-fe80-382954ba7f28@huawei.com>
Date:   Thu, 15 Jul 2021 11:20:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.185.67]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500022.china.huawei.com (7.185.36.162)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/7/9 15:48, Tian, Kevin wrote:
> 4.6. I/O page fault
> +++++++++++++++++++
> 
> uAPI is TBD. Here is just about the high-level flow from host IOMMU driver
> to guest IOMMU driver and backwards. This flow assumes that I/O page faults
> are reported via IOMMU interrupts. Some devices report faults via device
> specific way instead of going through the IOMMU. That usage is not covered
> here:
> 
> -   Host IOMMU driver receives a I/O page fault with raw fault_data {rid, 
>     pasid, addr};
> 
> -   Host IOMMU driver identifies the faulting I/O page table according to
>     {rid, pasid} and calls the corresponding fault handler with an opaque
>     object (registered by the handler) and raw fault_data (rid, pasid, addr);
> 
> -   IOASID fault handler identifies the corresponding ioasid and device 
>     cookie according to the opaque object, generates an user fault_data 
>     (ioasid, cookie, addr) in the fault region, and triggers eventfd to 
>     userspace;
> 

Hi, I have some doubts here:

For mdev, it seems that the rid in the raw fault_data is the parent device's,
then in the vSVA scenario, how can we get to know the mdev(cookie) from the
rid and pasid?

And from this point of view，would it be better to register the mdev
(iommu_register_device()) with the parent device info?

Thanks,
Shenming
