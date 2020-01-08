Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADAD134DF0
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 21:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbgAHUwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 15:52:42 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8010 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgAHUwl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 15:52:41 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e1641060001>; Wed, 08 Jan 2020 12:52:23 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 08 Jan 2020 12:52:40 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 08 Jan 2020 12:52:40 -0800
Received: from [10.40.100.122] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 8 Jan
 2020 20:52:30 +0000
Subject: Re: [PATCH v11 Kernel 6/6] vfio: Selective dirty page tracking if
 IOMMU backed device pins pages
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cjia@nvidia.com>, <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <1576602651-15430-1-git-send-email-kwankhede@nvidia.com>
 <1576602651-15430-7-git-send-email-kwankhede@nvidia.com>
 <20191217171219.7cc3fc1d@x1.home>
 <66512c1f-aedc-a718-8594-b52d266f4b60@nvidia.com>
 <20200107170929.74c9c92e@w520.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <17069da7-279b-872f-db15-d9995cf46285@nvidia.com>
Date:   Thu, 9 Jan 2020 02:22:26 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200107170929.74c9c92e@w520.home>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1578516743; bh=NQifUNOys4VgREQIljUZk82AJCjfd0sr0JIwtGIXPcI=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=oze48LXR1YCHKrXgzJFLy67Y8C/sXuGDCbvm+JRJtgUydp7gL0rr/V/gO40fRlONk
         hsadHyo2dNJLiRZuyQInS3oFKhPBzGneKV/g/Yj4u2xjxeW6j1tBrgXOzITlR1sPlV
         OZMhYYkBxYaY6/Lw844cRYboJqSWAxFwgnA2tMYtL0+b3cXJQIhC/3VnZy/cy0M9/Q
         M/wTQ0rggU4fIeWGaAqePg8SD9rW/M8A7gIczbY4WZt1NcXnLVZUAMjaKPet0cCBI0
         5gArPG3J4ut1tErK1vSCAKOquJlr5/jucbt7OxoT9ZpzETm6aQufoXlAAFiVfTyHVE
         QI9HqCgb1BPJw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/8/2020 5:39 AM, Alex Williamson wrote:
> On Wed, 8 Jan 2020 02:15:01 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> On 12/18/2019 5:42 AM, Alex Williamson wrote:
>>> On Tue, 17 Dec 2019 22:40:51 +0530
>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>    
>>
>> <snip>
>>
>>>
>>> This will fail when there are devices within the IOMMU group that are
>>> not represented as vfio_devices.  My original suggestion was:
>>>
>>> On Thu, 14 Nov 2019 14:06:25 -0700
>>> Alex Williamson <alex.williamson@redhat.com> wrote:
>>>> I think it does so by pinning pages.  Is it acceptable that if the
>>>> vendor driver pins any pages, then from that point forward we consider
>>>> the IOMMU group dirty page scope to be limited to pinned pages?  There
>>>> are complications around non-singleton IOMMU groups, but I think we're
>>>> already leaning towards that being a non-worthwhile problem to solve.
>>>> So if we require that only singleton IOMMU groups can pin pages and we
>>>
>>> We could tag vfio_groups as singleton at vfio_add_group_dev() time with
>>> an iommu_group_for_each_dev() walk so that we can cache the value on
>>> the struct vfio_group.
>>
>> I don't think iommu_group_for_each_dev() is required. Checking
>> group->device_list in vfio_add_group_dev() if there are more than one
>> device should work, right?
>>
>>           list_for_each_entry(vdev, &group->device_list, group_next) {
>>                   if (group->is_singleton) {
>>                           group->is_singleton = false;
>>                           break;
>>                   } else {
>>                           group->is_singleton = true;
>>                   }
>>           }
> 
> Hmm, I think you're taking a different approach to this than I was
> thinking.  Re-reading my previous comments, the fact that both vfio.c
> and vfio_iommu_type1.c each have their own private struct vfio_group
> makes things rather unclear.  I was intending to use the struct
> iommu_group as the object vfio.c provides to type1.c to associate the
> pinning.  This would require that not only the vfio view of devices in
> the group to be singleton, but also the actual iommu group to be
> singleton.  Otherwise the set of devices vfio.c has in the group might
> only be a subset of the group.  Maybe a merger of the approaches is
> easier though.
> 
> Tracking whether the vfio.c view of a group is singleton is even easier
> than above, we could simply add a device_count field to vfio_group,
> increment it in vfio_group_create_device() and decrement it in
> vfio_device_release().  vfio_pin_pages() could return error if
> device_count is not 1.  We could still add the iommu_group pointer to
> the type1 pin_pages callback, but perhaps type1 simply assumes that the
> group is singleton when pin pages is called and it's vfio.c's
> responsibility to maintain that group as singleton once pages have been
> pinned.  vfio.c would therefore also need to set a field on the
> vfio_group if pages have been pinned such that vfio_add_group_dev()
> could return error if a new device attempts to join the group.  We'd
> need to make sure that field is cleared when the group is released from
> use and pay attention to races that might occur between adding devices
> to a group and pinning pages.
> 

Thinking aloud, will adding singleton check could cause issues in near 
future? - may be in future support for p2p and direct RDMA will be added 
for mdev devices. In that case the two devices should be in same 
iommu_domain, but should be in different iommu_group - is that 
understanding correct?

>>> vfio_group_nb_add_dev() could update this if
>>> the IOMMU group composition changes.
>>
>> I don't see vfio_group_nb_add_dev() calls vfio_add_group_dev() (?)
>> If checking is_singleton is taken care in vfio_group_nb_add_dev(), which
>> is the only place where vfio_group is allocated, that should work, I think.
> 
> This was relative to maintaining that the iommu group itself is
> singleton, not just the vfio view of the group.  If we use the latter
> as our basis, then you're right, we should need this, but vfio.c would
> need to enforce that the group remains singleton if it has pinned
> pages.  Does that make sense?  Thanks,
> 

Which route should be taken - iommu_group view or vfio.c group view?

Thanks,
Kirti

> Alex
> 
>>> vfio_pin_pages() could return
>>> -EINVAL if (!group->is_singleton).
>>>    
>>>> pass the IOMMU group as a parameter to
>>>> vfio_iommu_driver_ops.pin_pages(), then the type1 backend can set a
>>>> flag on its local vfio_group struct to indicate dirty page scope is
>>>> limited to pinned pages.
>>>
>>> ie. vfio_iommu_type1_unpin_pages() calls find_iommu_group() on each
>>> domain in domain_list and the external_domain using the struct
>>> iommu_group pointer provided by vfio-core.  We set a new attribute on
>>> the vfio_group to indicate that vfio_group has (at some point) pinned
>>> pages.
>>>    
>>>>    We might want to keep a flag on the
>>>> vfio_iommu struct to indicate if all of the vfio_groups for each
>>>> vfio_domain in the vfio_iommu.domain_list dirty page scope limited to
>>>> pinned pages as an optimization to avoid walking lists too often.  Then
>>>> we could test if vfio_iommu.domain_list is not empty and this new flag
>>>> does not limit the dirty page scope, then everything within each
>>>> vfio_dma is considered dirty.
>>>
>>> So at the point where we change vfio_group.has_pinned_pages from false
>>> to true, or a group is added or removed, we walk all the groups in the
>>> vfio_iommu and if they all have has_pinned_pages set, we can set a
>>> vfio_iommu.pinned_page_dirty_scope flag to true.  If that flag is
>>> already true on page pinning, we can skip the lookup.
>>>
>>> I still like this approach better, it doesn't require a callback from
>>> type1 to vfio-core and it doesn't require a heavy weight walking for
>>> group devices and vfio data structures every time we fill a bitmap.
>>> Did you run into issues trying to implement this approach?
>>
>> Thanks for elaborative steps.
>> This works. Changing this last commit.
>>
>> Thanks,
>> Kirti
>>
> 
