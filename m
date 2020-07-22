Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E975228E4D
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 04:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731856AbgGVC4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 22:56:10 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8350 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731641AbgGVC4J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 22:56:09 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5A289FF4945750D32C85;
        Wed, 22 Jul 2020 10:56:00 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.83) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Wed, 22 Jul 2020
 10:55:54 +0800
Subject: Re: [PATCH Kernel v24 0/8] Add UAPIs to support migration for VFIO
 devices
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Kirti Wankhede <kwankhede@nvidia.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        "Wang Haibin" <wanghaibin.wang@huawei.com>
References: <1590697854-21364-1-git-send-email-kwankhede@nvidia.com>
 <450612c3-2a92-9034-7958-ee7f3c1a8c52@huawei.com>
 <20200721164304.0ce76b2e@x1.home>
From:   Xiang Zheng <zhengxiang9@huawei.com>
Message-ID: <3351a7d0-4fb1-a902-b902-a638a3d3047a@huawei.com>
Date:   Wed, 22 Jul 2020 10:55:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20200721164304.0ce76b2e@x1.home>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.83]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

Thank you for your suggestion.

On 2020/7/22 6:43, Alex Williamson wrote:
> On Tue, 21 Jul 2020 10:43:21 +0800
> Xiang Zheng <zhengxiang9@huawei.com> wrote:
> 
>> Hi Kirti,
>>
>> Sorry to disturb you since this patch set has been merged, and I cannot
>> receive the qemu-side emails about this patch set.
>>
>> We are going to support migration for VFIO devices which support dirty
>> pages tracking.
>>
>> And we also plan to leverage SMMU HTTU feature to do the dirty pages
>> tracking for the devices which don't support dirty pages tracking.
>>
>> For the above two cases, which side determines to choose IOMMU driver or
>> vendor driver to do dirty bitmap tracking, Qemu or VFIO?
>>
>> In brief, if both IOMMU and VFIO devices support dirty pages tracking,
>> we can check the capability and prefer to track dirty pages on device
>> vendor driver which is more efficient.
>>
>> The qusetion is which side to do the check and selection? In my opinion,
>> Qemu/userspace seems more suitable.
> 
> Dirty page tracking is consolidated at the vfio container level.
> Userspace has no basis for determining or interface for selecting a
> dirty bitmap provider, so I would disagree that QEMU should play any
> role here.  The container dirty bitmap tries to provide the finest
> granularity available based on the support of all the devices/groups
> managed by the container.  If there are groups attached to the
> container that have not participated in page pinning, then we consider
> all DMA mappings within the container as persistently dirty.  Once all
> of the participants subscribe to page pinning, the dirty scope is
> reduced to the pinned pages.  IOMMU support for dirty page logging would
> introduce finer granularity yet, which we would probably prefer over
> page pinning, but interfaces for this have not been devised.

Kevin and his colleagues may add these APIs in the future.
We also plan to support these interfaces on SMMU driver and afterwards we
can have a further discussion.

> 
> Ideally userspace should be unaware of any of this, the benefit would
> be seen transparently by having a more sparsely filled dirty bitmap,
> which more accurately reflects how memory is actually being dirtied.

Yes, indeed.

-- 
Thanks,
Xiang

