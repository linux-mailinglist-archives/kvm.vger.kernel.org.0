Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 602E8197D7E
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 15:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgC3Ntj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 09:49:39 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:16501 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgC3Nti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 09:49:38 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e81f8e00001>; Mon, 30 Mar 2020 06:49:21 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 30 Mar 2020 06:49:34 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 30 Mar 2020 06:49:34 -0700
Received: from [10.40.101.165] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 30 Mar
 2020 13:49:25 +0000
Subject: Re: [PATCH v16 Kernel 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
To:     Yan Zhao <yan.y.zhao@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@Alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <1585084732-18473-1-git-send-email-kwankhede@nvidia.com>
 <20200325021135.GB20109@joy-OptiPlex-7040>
 <33d38629-aeaf-1c30-26d4-958b998620b0@nvidia.com>
 <20200327003055.GB26419@joy-OptiPlex-7040>
 <deb8b18f-aa79-70d3-ce05-89b607f813c4@nvidia.com>
 <20200330032437.GD30683@joy-OptiPlex-7040>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <e91dbf70-05bf-977f-208b-0fb5988af3a8@nvidia.com>
Date:   Mon, 30 Mar 2020 19:19:21 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200330032437.GD30683@joy-OptiPlex-7040>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1585576161; bh=hl5tuOx4m9EjFrKmVXf/ZGayKENorF3yrrdKQ+pBcpQ=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=mOHacjA3H0HGixO/vWFBrs5lkqZdTu9S9JSlHPVtDI7LfYjInhEiJ2D5jFNZsjB4O
         sCoL0ziQovkUpkOvfSdkYcUR5faHMLHdWRGbydsJrxbnHX4jjvfICM+3o7Urn2Lrp6
         Ca5HTmwiJUTrr9ZCesoulLw7j1GInQlobhjOkXzmivYU186TYOx+tAipM9a+VS02aw
         ZTnG/OoqCISJcncPDXPIy7En8RKijz9jAPxIa8qJD/84uI/csosOs+5Csna45sqC8N
         M1Qubxk+IsWlmmKwrZo8B8M3BmDS9kqGJ+M9Lu3n4l6cf9fLZv1A7Nk6TTnmx6qiQp
         bu6x04FGr37kg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/30/2020 8:54 AM, Yan Zhao wrote:
> On Fri, Mar 27, 2020 at 01:28:13PM +0800, Kirti Wankhede wrote:
>> Hit send button little early.
>>
>>   >
>>   > I checked v12, it's not like what I said.
>>   > In v12, bitmaps are generated per vfio_dma, and combination of the
>>   > bitmaps are required in order to generate a big bitmap suiting for dirty
>>   > query. It can cause problem when offset not aligning.
>>   > But what I propose here is to generate an rb tree orthogonal to the tree
>>   > of vfio_dma.
>>   >
>>   > as to CPU cycles saving, I don't think iterating/translating page by page
>>   > would achieve that purpose.
>>   >
>>
>> Instead of creating one extra rb tree for dirty pages tracking in v10
>> tried to use dma->pfn_list itself, we tried changes in v10, v11 and v12,
>> latest version is evolved version with best possible approach after
>> discussion. Probably, go through v11 as well.
>> https://patchwork.kernel.org/patch/11298335/
>>
> I'm not sure why all those previous implementations are bound to
> vfio_dma. for vIOMMU on, in most cases, a vfio_dma is only for a page,
> so generating a one-byte bitmap for a single page in each vfio_dma ?
> is it possible to creating one extra rb tree to keep dirty ranges, and
> one fixed length kernel bitmap whose content is generated on query,
> serving as a bouncing buffer for copy_to_user
> 

One fixed length? what should be fixed value? then isn't it better to 
fix the size to dma->size?

This is also to prevent DoS attack, user space application can query a 
very large range.

>>
>> On 3/27/2020 6:00 AM, Yan Zhao wrote:
>>> On Fri, Mar 27, 2020 at 05:39:01AM +0800, Kirti Wankhede wrote:
>>>>
>>>>
>>>> On 3/25/2020 7:41 AM, Yan Zhao wrote:
>>>>> On Wed, Mar 25, 2020 at 05:18:52AM +0800, Kirti Wankhede wrote:
>>>>>> VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
>>>>>> - Start dirty pages tracking while migration is active
>>>>>> - Stop dirty pages tracking.
>>>>>> - Get dirty pages bitmap. Its user space application's responsibility to
>>>>>>      copy content of dirty pages from source to destination during migration.
>>>>>>
>>>>>> To prevent DoS attack, memory for bitmap is allocated per vfio_dma
>>>>>> structure. Bitmap size is calculated considering smallest supported page
>>>>>> size. Bitmap is allocated for all vfio_dmas when dirty logging is enabled
>>>>>>
>>>>>> Bitmap is populated for already pinned pages when bitmap is allocated for
>>>>>> a vfio_dma with the smallest supported page size. Update bitmap from
>>>>>> pinning functions when tracking is enabled. When user application queries
>>>>>> bitmap, check if requested page size is same as page size used to
>>>>>> populated bitmap. If it is equal, copy bitmap, but if not equal, return
>>>>>> error.
>>>>>>
>>>>>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>>>>>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>>>>>> ---
>>>>>>     drivers/vfio/vfio_iommu_type1.c | 266 +++++++++++++++++++++++++++++++++++++++-
>>>>>>     1 file changed, 260 insertions(+), 6 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>>>>> index 70aeab921d0f..874a1a7ae925 100644
>>>>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>>>>> @@ -71,6 +71,7 @@ struct vfio_iommu {
>>>>>>     	unsigned int		dma_avail;
>>>>>>     	bool			v2;
>>>>>>     	bool			nesting;
>>>>>> +	bool			dirty_page_tracking;
>>>>>>     };
>>>>>>     
>>>>>>     struct vfio_domain {
>>>>>> @@ -91,6 +92,7 @@ struct vfio_dma {
>>>>>>     	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
>>>>>>     	struct task_struct	*task;
>>>>>>     	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>>>>>> +	unsigned long		*bitmap;
>>>>>>     };
>>>>>>     
>>>>>>     struct vfio_group {
>>>>>> @@ -125,7 +127,21 @@ struct vfio_regions {
>>>>>>     #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
>>>>>>     					(!list_empty(&iommu->domain_list))
>>>>>>     
>>>>>> +#define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) / BITS_PER_BYTE)
>>>>>> +
>>>>>> +/*
>>>>>> + * Input argument of number of bits to bitmap_set() is unsigned integer, which
>>>>>> + * further casts to signed integer for unaligned multi-bit operation,
>>>>>> + * __bitmap_set().
>>>>>> + * Then maximum bitmap size supported is 2^31 bits divided by 2^3 bits/byte,
>>>>>> + * that is 2^28 (256 MB) which maps to 2^31 * 2^12 = 2^43 (8TB) on 4K page
>>>>>> + * system.
>>>>>> + */
>>>>>> +#define DIRTY_BITMAP_PAGES_MAX	(uint64_t)(INT_MAX - 1)
>>>>>> +#define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
>>>>>> +
>>>>>>     static int put_pfn(unsigned long pfn, int prot);
>>>>>> +static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu);
>>>>>>     
>>>>>>     /*
>>>>>>      * This code handles mapping and unmapping of user data buffers
>>>>>> @@ -175,6 +191,77 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
>>>>>>     	rb_erase(&old->node, &iommu->dma_list);
>>>>>>     }
>>>>>>     
>>>>>> +
>>>>>> +static int vfio_dma_bitmap_alloc(struct vfio_dma *dma, uint64_t pgsize)
>>>>>> +{
>>>>>> +	uint64_t npages = dma->size / pgsize;
>>>>>> +
> If pgsize > dma->size, npages = 0.
> wouldn't it cause problem?
> 

This patch-set supports bitmap for smallest supported page size, i.e. 
PAGE_SIZE. vfio_dma_do_map() validates dma->size accordingly. So this 
case will not happen.

Thanks,
Kirti

