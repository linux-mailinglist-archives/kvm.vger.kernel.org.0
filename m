Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93D638BFB2
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 08:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbhEUGnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 02:43:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3609 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbhEUGlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 02:41:08 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FmcLQ2VNVzQpjW;
        Fri, 21 May 2021 14:35:42 +0800 (CST)
Received: from dggpemm500022.china.huawei.com (7.185.36.162) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 14:39:14 +0800
Received: from [10.174.187.155] (10.174.187.155) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 14:39:13 +0800
Subject: Re: [RFC PATCH v3 7/8] vfio/type1: Add selective DMA faulting support
To:     Alex Williamson <alex.williamson@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
CC:     Cornelia Huck <cohuck@redhat.com>, Will Deacon <will@kernel.org>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-api@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20210409034420.1799-1-lushenming@huawei.com>
 <20210409034420.1799-8-lushenming@huawei.com>
 <20210518125813.7b8a78f1.alex.williamson@redhat.com>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <ee41159c-7adf-6e96-1bb2-9c735512080a@huawei.com>
Date:   Fri, 21 May 2021 14:39:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20210518125813.7b8a78f1.alex.williamson@redhat.com>
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
> On Fri, 9 Apr 2021 11:44:19 +0800
> Shenming Lu <lushenming@huawei.com> wrote:
> 
>> Some devices only allow selective DMA faulting. Similar to the selective
>> dirty page tracking, the vendor driver can call vfio_pin_pages() to
>> indicate the non-faultable scope, we add a new struct vfio_range to
>> record it, then when the IOPF handler receives any page request out
>> of the scope, we can directly return with an invalid response.
> 
> Seems like this highlights a deficiency in the design, that the user
> can't specify mappings as iopf enabled or disabled.  Also, if the
> vendor driver has pinned pages within the range, shouldn't that prevent
> them from faulting in the first place?  Why do we need yet more
> tracking structures?  Pages pinned by the vendor driver need to count
> against the user's locked memory limits regardless of iopf.  Thanks,

Currently we only have a vfio_pfn struct to track the external pinned pages
(single page granularity), so I add a vfio_range struct for efficient lookup.

Yeah, by this patch, for the non-pinned scope, we can directly return INVALID,
but for the pinned(non-faultable) scope, tracking the pinned range doesn't seem
to help more...

Thanks,
Shenming

> 
> Alex
> 
> .
> 
