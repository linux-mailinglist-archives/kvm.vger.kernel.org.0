Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608231D63BB
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 21:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgEPTI3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 15:08:29 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10573 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgEPTI2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 15:08:28 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ec03a1f0000>; Sat, 16 May 2020 12:08:15 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Sat, 16 May 2020 12:08:27 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Sat, 16 May 2020 12:08:27 -0700
Received: from [10.40.103.94] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 16 May
 2020 19:08:19 +0000
Subject: Re: [PATCH Kernel v21 5/8] vfio iommu: Implementation of ioctl for
 dirty pages tracking
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
References: <1589577203-20640-1-git-send-email-kwankhede@nvidia.com>
 <1589577203-20640-6-git-send-email-kwankhede@nvidia.com>
 <20200515163307.72951dd2@w520.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <a8fdd629-d49d-d333-0711-0d8d742d9b47@nvidia.com>
Date:   Sun, 17 May 2020 00:38:15 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200515163307.72951dd2@w520.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
	t=1589656095; bh=+tZ0dBYIJDY6PHAfvMYygljkbJgDRKM2mXYJTiJ5LAU=;
	h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
	 Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
	 X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
	 Content-Transfer-Encoding;
	b=AIbO+yRdmNHn4LV2XE0br8vquXdgTLtrWscElXmWTZiSzrFeRqlATyPGsHleQF3QU
	 nBcXsRa9tsbQOwgPkyh0nhMBzcV+q6CoKMw4c3CmRhkSXWG6XnQepdpEF4WDC5VJ1j
	 /kxVKDvmS/WIGEMLowaG/lra0BpLqY9FQLPkCc2up9t94NJ15nHzMx+poYTeVeomWq
	 x3b9j+KGJesMojeYHF4p02v5kpaquce7dYmP7FjlUMTdEZTgbB46FMu/GynDs3ZPLp
	 5Jj51SmTeTP/0NR8+K7XjbAFdNc/ux1RzpNITw6FFJ7kmcIImwoKGPat0qKhpN2P6u
	 J2ThfIZtvw0wg==


On 5/16/2020 4:03 AM, Alex Williamson wrote:
> On Sat, 16 May 2020 02:43:20 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 

<snip>

>> +static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>> +				  dma_addr_t iova, size_t size, size_t pgsize)
>> +{
>> +	struct vfio_dma *dma;
>> +	unsigned long pgshift = __ffs(pgsize);
>> +	int ret;
>> +
>> +	/*
>> +	 * GET_BITMAP request must fully cover vfio_dma mappings.  Multiple
>> +	 * vfio_dma mappings may be clubbed by specifying large ranges, but
>> +	 * there must not be any previous mappings bisected by the range.
>> +	 * An error will be returned if these conditions are not met.
>> +	 */
>> +	dma = vfio_find_dma(iommu, iova, 1);
>> +	if (dma && dma->iova != iova)
>> +		return -EINVAL;
>> +
>> +	dma = vfio_find_dma(iommu, iova + size - 1, 0);
>> +	if (dma && dma->iova + dma->size != iova + size)
>> +		return -EINVAL;
>> +
>> +	dma = vfio_find_dma(iommu, iova, size);
>> +
>> +	while (dma && (dma->iova >= iova) &&
>> +		(dma->iova + dma->size <= iova + size)) {
> 
> Thanks for doing this!  Unfortunately I think I've mislead you :(
> But I think there was a bug here in the last version as well, so maybe
> it's all for the better ;)
> 
> vfio_find_dma() does not guarantee to find the first dma in the range
> (ie. the lowest iova), it only guarantees to find a dma in the range.
> Since we have a tree structure, as we descend the nodes we might find
> multiple nodes within the range.  vfio_find_dma() only returns the first
> occurrence it finds, so we can't assume that other matching nodes are
> next in the tree or that their iovas are greater than the iova of the
> node we found.
> 
> All the other use cases of vfio_find_dma() are looking for specific
> pages or boundaries or checking for the existence of a conflict or are
> removing all of the instances within the range, which is probably the
> example that was used in the v20 version of this patch, since it was
> quite similar to vfio_dma_do_unmap() but tried to adjust the size to
> get the next match rather than removing the entry.  That could
> potentially lead to an entire unexplored half of the tree making our
> bitmap incomplete.
> 
> So I think my initial suggestion[1] on the previous version is probably
> the way we should go.  Sorry!  OTOH, it would have been a nasty bug to
> find later, it's a subtle semantic that's easy to overlook.  Thanks,
> 
> Alex
> 
> [1]https://lore.kernel.org/kvm/20200514212720.479cc3ba@x1.home/
> 

Ok. Got your point.

Replacing
	dma = vfio_find_dma(iommu, iova, size);

with below should work

for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
         struct vfio_dma *ldma = rb_entry(n, struct vfio_dma, node);

         if (ldma->iova >= iova)
                 break;
}

dma = n ? rb_entry(n, struct vfio_dma, node) : NULL;

Should I update all patches with v22 version? or Is it fine to update 
this patch with v21 only?

Thanks,
Kirti

