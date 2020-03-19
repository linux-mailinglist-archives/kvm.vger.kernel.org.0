Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D302518BFBF
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 19:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgCSS5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 14:57:42 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13955 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgCSS5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 14:57:42 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e73c0430000>; Thu, 19 Mar 2020 11:56:03 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 19 Mar 2020 11:57:41 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 19 Mar 2020 11:57:41 -0700
Received: from [10.40.102.54] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 19 Mar
 2020 18:57:32 +0000
Subject: Re: [PATCH v14 Kernel 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
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
References: <1584560474-19946-1-git-send-email-kwankhede@nvidia.com>
 <1584560474-19946-5-git-send-email-kwankhede@nvidia.com>
 <20200318214500.1a0cb985@w520.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <be22d111-123c-e1bb-a376-e66b10ebe55f@nvidia.com>
Date:   Fri, 20 Mar 2020 00:27:28 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200318214500.1a0cb985@w520.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1584644163; bh=vfV88Ij06FqO4WLmvlV/YCflIZKfz0v6Hvy6pULwZuo=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=js7IJV3SHXnODSgCqg8UiUybsPrToVSihTWkqALlgfltkrfbUtz38Z/Luc+B2LOtl
         nhj2unhILoPL8ylxCKt4T7/cx5xxsJ0TnqUJqulGfYgDHTVYXL/mfyYgBSaH53Bk9I
         Cf7KlYbENjlJ9u2xHnGlSxeNPEsjdykAAU3nX3gb7AeSQquxZnX05kRpuveFq5wNwo
         F09yhhuJ8Ld3bbCUe2qcdWdU7vN+D4FB8yVzKSHcv299nOZ9pbLcrHdYnMNg8joYWj
         AkS0OtxrQovgYRdbl9GrKOn9VyrfzoNEccn6WJAAFclQiKnffwv6rohXXxGCwoLcxt
         lO9MCHV7w473g==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/19/2020 9:15 AM, Alex Williamson wrote:
> On Thu, 19 Mar 2020 01:11:11 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>=20
>> VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
>> - Start dirty pages tracking while migration is active
>> - Stop dirty pages tracking.
>> - Get dirty pages bitmap. Its user space application's responsibility to
>>    copy content of dirty pages from source to destination during migrati=
on.
>>
>> To prevent DoS attack, memory for bitmap is allocated per vfio_dma
>> structure. Bitmap size is calculated considering smallest supported page
>> size. Bitmap is allocated for all vfio_dmas when dirty logging is enable=
d
>>
>> Bitmap is populated for already pinned pages when bitmap is allocated fo=
r
>> a vfio_dma with the smallest supported page size. Update bitmap from
>> pinning functions when tracking is enabled. When user application querie=
s
>> bitmap, check if requested page size is same as page size used to
>> populated bitmap. If it is equal, copy bitmap, but if not equal, return
>> error.
>>
>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 205 ++++++++++++++++++++++++++++++++=
+++++++-
>>   1 file changed, 203 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_t=
ype1.c
>> index 70aeab921d0f..d6417fb02174 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -71,6 +71,7 @@ struct vfio_iommu {
>>   	unsigned int		dma_avail;
>>   	bool			v2;
>>   	bool			nesting;
>> +	bool			dirty_page_tracking;
>>   };
>>  =20
>>   struct vfio_domain {
>> @@ -91,6 +92,7 @@ struct vfio_dma {
>>   	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
>>   	struct task_struct	*task;
>>   	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>> +	unsigned long		*bitmap;
>=20
> We've made the bitmap a width invariant u64 else, should be here as
> well.
>=20

Changing to u64 causes compile time warnings as below. Keeping 'unsigned=20
long *'

drivers/vfio/vfio_iommu_type1.c: In function =E2=80=98vfio_dma_bitmap_alloc=
_all=E2=80=99:
drivers/vfio/vfio_iommu_type1.c:232:8: warning: passing argument 1 of=20
=E2=80=98bitmap_set=E2=80=99 from incompatible pointer type [enabled by def=
ault]
         (vpfn->iova - dma->iova) / pgsize, 1);
         ^
In file included from ./include/linux/cpumask.h:12:0,
                  from ./arch/x86/include/asm/cpumask.h:5,
                  from ./arch/x86/include/asm/msr.h:11,
                  from ./arch/x86/include/asm/processor.h:22,
                  from ./arch/x86/include/asm/cpufeature.h:5,
                  from ./arch/x86/include/asm/thread_info.h:53,
                  from ./include/linux/thread_info.h:38,
                  from ./arch/x86/include/asm/preempt.h:7,
                  from ./include/linux/preempt.h:78,
                  from ./include/linux/spinlock.h:51,
                  from ./include/linux/seqlock.h:36,
                  from ./include/linux/time.h:6,
                  from ./include/linux/compat.h:10,
                  from drivers/vfio/vfio_iommu_type1.c:24:
./include/linux/bitmap.h:405:29: note: expected =E2=80=98long unsigned int =
*=E2=80=99=20
but argument is of type =E2=80=98u64 *=E2=80=99
  static __always_inline void bitmap_set(unsigned long *map, unsigned=20
int start,

Thanks,
Kirti
