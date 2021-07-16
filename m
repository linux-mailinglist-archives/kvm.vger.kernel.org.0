Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80F13CB750
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 14:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhGPMXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 08:23:21 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:11436 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbhGPMXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 08:23:18 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GR9GR0bgyzcdbs;
        Fri, 16 Jul 2021 20:17:03 +0800 (CST)
Received: from dggpemm500022.china.huawei.com (7.185.36.162) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Jul 2021 20:20:22 +0800
Received: from [10.174.185.67] (10.174.185.67) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Jul 2021 20:20:21 +0800
Subject: Re: [RFC v2] /dev/iommu uAPI proposal
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>
References: <a8edb2c1-9c9c-6204-072c-4f1604b7dace@huawei.com>
 <BN9PR11MB54336D6A8CAE31F951770A428C129@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210715124813.GC543781@nvidia.com> <20210715135757.GC590891@otc-nc-03>
 <20210715152325.GF543781@nvidia.com> <20210715162141.GA593686@otc-nc-03>
 <20210715171826.GG543781@nvidia.com> <20210715174836.GB593686@otc-nc-03>
 <20210715175336.GH543781@nvidia.com> <20210715180545.GD593686@otc-nc-03>
 <20210715181327.GI543781@nvidia.com>
 <BN9PR11MB543337BAEA86708470AC1E0C8C119@BN9PR11MB5433.namprd11.prod.outlook.com>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <013e240d-f627-3565-aba1-71b2d6f514b4@huawei.com>
Date:   Fri, 16 Jul 2021 20:20:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <BN9PR11MB543337BAEA86708470AC1E0C8C119@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.67]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500022.china.huawei.com (7.185.36.162)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/7/16 9:20, Tian, Kevin wrote:
 > To summarize, for vIOMMU we can work with the spec owner to
> define a proper interface to feedback such restriction into the guest 
> if necessary. For the kernel part, it's clear that IOMMU fd should 
> disallow two devices attached to a single [RID] or [RID, PASID] slot 
> in the first place.
> 
> Then the next question is how to communicate such restriction
> to the userspace. It sounds like a group, but different in concept.
> An iommu group describes the minimal isolation boundary thus all
> devices in the group can be only assigned to a single user. But this
> case is opposite - the two mdevs (both support ENQCMD submission)
> with the same parent have problem when assigned to a single VM 
> (in this case vPASID is vm-wide translated thus a same pPASID will be 
> used cross both mdevs) while they instead work pretty well when 
> assigned to different VMs (completely different vPASID spaces thus 
> different pPASIDs).
> 
> One thought is to have vfio device driver deal with it. In this proposal
> it is the vfio device driver to define the PASID virtualization policy and
> report it to userspace via VFIO_DEVICE_GET_INFO. The driver understands
> the restriction thus could just hide the vPASID capability when the user 
> calls GET_INFO on the 2nd mdev in above scenario. In this way the 
> user even doesn't need to know such restriction at all and both mdevs
> can be assigned to a single VM w/o any problem.
> 

The restriction only probably happens when two mdevs are assigned to one VM,
how could the vfio device driver get to know this info to accurately hide
the vPASID capability for the 2nd mdev when VFIO_DEVICE_GET_INFO? There is no
need to do this in other cases.

Thanks,
Shenming
