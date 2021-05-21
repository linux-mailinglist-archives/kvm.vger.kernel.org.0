Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C3538BF9A
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 08:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbhEUGjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 02:39:06 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3458 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbhEUGi4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 02:38:56 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FmcKG17ZbzCvPY;
        Fri, 21 May 2021 14:34:42 +0800 (CST)
Received: from dggpemm500022.china.huawei.com (7.185.36.162) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 14:37:30 +0800
Received: from [10.174.187.155] (10.174.187.155) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 14:37:29 +0800
Subject: Re: [RFC PATCH v3 1/8] iommu: Evolve the device fault reporting
 framework
To:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>
CC:     Cornelia Huck <cohuck@redhat.com>, Will Deacon <will@kernel.org>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-api@vger.kernel.org>,
        <yi.l.liu@intel.com>, Christoph Hellwig <hch@infradead.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "Barry Song" <song.bao.hua@hisilicon.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20210409034420.1799-1-lushenming@huawei.com>
 <20210409034420.1799-2-lushenming@huawei.com>
 <20210518125843.68552b67.alex.williamson@redhat.com>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <e929e47d-4d41-52e6-8702-d9a61321c2b0@huawei.com>
Date:   Fri, 21 May 2021 14:37:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20210518125843.68552b67.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.155]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500022.china.huawei.com (7.185.36.162)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/19 2:58, Alex Williamson wrote:
> On Fri, 9 Apr 2021 11:44:13 +0800
> Shenming Lu <lushenming@huawei.com> wrote:
> 
>> This patch follows the discussion here:
>>
>> https://lore.kernel.org/linux-acpi/YAaxjmJW+ZMvrhac@myrica/
>>
>> Besides SVA/vSVA, such as VFIO may also enable (2nd level) IOPF to remove
>> pinning restriction. In order to better support more scenarios of using
>> device faults, we extend iommu_register_fault_handler() with flags and
>> introduce FAULT_REPORT_ to describe the device fault reporting capability
>> under a specific configuration.
>>
>> Note that we don't further distinguish recoverable and unrecoverable faults
>> by flags in the fault reporting cap, having PAGE_FAULT_REPORT_ +
>> UNRECOV_FAULT_REPORT_ seems not a clean way.
>>
>> In addition, still take VFIO as an example, in nested mode, the 1st level
>> and 2nd level fault reporting may be configured separately and currently
>> each device can only register one iommu dev fault handler, so we add a
>> handler update interface for this.
> 
> 
> IIUC, you're introducing flags for the fault handler callout, which
> essentially allows the IOMMU layer to filter which types of faults the
> handler can receive.  You then need an update function to modify those
> flags.  Why can't the handler itself perform this filtering?  For
> instance in your vfio example, the handler registered by the type1
> backend could itself return fault until the fault transfer path to the
> device driver is established.  Thanks,

As discussed in [1]:

In nested IOPF, we have to figure out whether a fault comes from L1 or L2.
A SMMU stall event comes with this information, but a PRI page request doesn't.
The IOMMU driver can walk the page tables to find out the level information.
If the walk terminates at L1, further inject to the guest. Otherwise fix the
fault at L2 in VFIO. It's not efficient compared to hardware-provided info.

And in pinned case, if VFIO can tell the IOMMU driver that no L2 fault is
expected, there is no need to walk the page tables in the IOMMU driver?

[1] https://patchwork.kernel.org/project/linux-arm-kernel/patch/20210108145217.2254447-4-jean-philippe@linaro.org/

Thanks,
Shenming

> 
> Alex
> 
> .
> 
