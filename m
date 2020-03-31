Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D40A198909
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 02:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729239AbgCaAyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 20:54:04 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:30890 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729019AbgCaAyE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 20:54:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585616042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BgFeQq/Am8rjefjj4RkIPmv7LhiqEOaGgh3GdUT+WoI=;
        b=TmLq9h5crEbtsd2iWDIOvnbmMj0BGyBiZ5j3EvCur8Vl56xpEc5eQKojm/lry6Y3VxoSSr
        zYhMgPrakUGUGiBtYXp7gAmy+InbEjDQfQRRr/BHdihCfTDYHtc2XbdNKabhAx035uOh/b
        OYUu/kEPsd8o9EpC9DhWNU9cMd20ZW0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-N4t9FEAWOBKM6S6e9iR4gA-1; Mon, 30 Mar 2020 20:53:54 -0400
X-MC-Unique: N4t9FEAWOBKM6S6e9iR4gA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49E65108594D;
        Tue, 31 Mar 2020 00:53:52 +0000 (UTC)
Received: from x1.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DF8C19756;
        Tue, 31 Mar 2020 00:53:48 +0000 (UTC)
Date:   Mon, 30 Mar 2020 18:53:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
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
Subject: Re: [PATCH v16 Kernel 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
Message-ID: <20200330185347.58b1ab93@x1.home>
In-Reply-To: <20200330235131.GB6478@joy-OptiPlex-7040>
References: <1585084732-18473-1-git-send-email-kwankhede@nvidia.com>
        <20200325021135.GB20109@joy-OptiPlex-7040>
        <33d38629-aeaf-1c30-26d4-958b998620b0@nvidia.com>
        <20200327003055.GB26419@joy-OptiPlex-7040>
        <deb8b18f-aa79-70d3-ce05-89b607f813c4@nvidia.com>
        <20200330032437.GD30683@joy-OptiPlex-7040>
        <e91dbf70-05bf-977f-208b-0fb5988af3a8@nvidia.com>
        <20200330235131.GB6478@joy-OptiPlex-7040>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 30 Mar 2020 19:51:31 -0400
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Mon, Mar 30, 2020 at 09:49:21PM +0800, Kirti Wankhede wrote:
> > 
> > 
> > On 3/30/2020 8:54 AM, Yan Zhao wrote:  
> > > On Fri, Mar 27, 2020 at 01:28:13PM +0800, Kirti Wankhede wrote:  
> > >> Hit send button little early.
> > >>  
> > >>   >
> > >>   > I checked v12, it's not like what I said.
> > >>   > In v12, bitmaps are generated per vfio_dma, and combination of the
> > >>   > bitmaps are required in order to generate a big bitmap suiting for dirty
> > >>   > query. It can cause problem when offset not aligning.
> > >>   > But what I propose here is to generate an rb tree orthogonal to the tree
> > >>   > of vfio_dma.
> > >>   >
> > >>   > as to CPU cycles saving, I don't think iterating/translating page by page
> > >>   > would achieve that purpose.
> > >>   >  
> > >>
> > >> Instead of creating one extra rb tree for dirty pages tracking in v10
> > >> tried to use dma->pfn_list itself, we tried changes in v10, v11 and v12,
> > >> latest version is evolved version with best possible approach after
> > >> discussion. Probably, go through v11 as well.
> > >> https://patchwork.kernel.org/patch/11298335/
> > >>  
> > > I'm not sure why all those previous implementations are bound to
> > > vfio_dma. for vIOMMU on, in most cases, a vfio_dma is only for a page,
> > > so generating a one-byte bitmap for a single page in each vfio_dma ?
> > > is it possible to creating one extra rb tree to keep dirty ranges, and
> > > one fixed length kernel bitmap whose content is generated on query,
> > > serving as a bouncing buffer for copy_to_user
> > >   
> > 
> > One fixed length? what should be fixed value? then isn't it better to 
> > fix the size to dma->size?
> > 
> > This is also to prevent DoS attack, user space application can query a 
> > very large range.
> >   
> > >>
> > >> On 3/27/2020 6:00 AM, Yan Zhao wrote:  
> > >>> On Fri, Mar 27, 2020 at 05:39:01AM +0800, Kirti Wankhede wrote:  
> > >>>>
> > >>>>
> > >>>> On 3/25/2020 7:41 AM, Yan Zhao wrote:  
> > >>>>> On Wed, Mar 25, 2020 at 05:18:52AM +0800, Kirti Wankhede wrote:  
> > >>>>>> VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
> > >>>>>> - Start dirty pages tracking while migration is active
> > >>>>>> - Stop dirty pages tracking.
> > >>>>>> - Get dirty pages bitmap. Its user space application's responsibility to
> > >>>>>>      copy content of dirty pages from source to destination during migration.
> > >>>>>>
> > >>>>>> To prevent DoS attack, memory for bitmap is allocated per vfio_dma
> > >>>>>> structure. Bitmap size is calculated considering smallest supported page
> > >>>>>> size. Bitmap is allocated for all vfio_dmas when dirty logging is enabled
> > >>>>>>
> > >>>>>> Bitmap is populated for already pinned pages when bitmap is allocated for
> > >>>>>> a vfio_dma with the smallest supported page size. Update bitmap from
> > >>>>>> pinning functions when tracking is enabled. When user application queries
> > >>>>>> bitmap, check if requested page size is same as page size used to
> > >>>>>> populated bitmap. If it is equal, copy bitmap, but if not equal, return
> > >>>>>> error.
> > >>>>>>
> > >>>>>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> > >>>>>> Reviewed-by: Neo Jia <cjia@nvidia.com>
> > >>>>>> ---
> > >>>>>>     drivers/vfio/vfio_iommu_type1.c | 266 +++++++++++++++++++++++++++++++++++++++-
> > >>>>>>     1 file changed, 260 insertions(+), 6 deletions(-)
> > >>>>>>
> > >>>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > >>>>>> index 70aeab921d0f..874a1a7ae925 100644
> > >>>>>> --- a/drivers/vfio/vfio_iommu_type1.c
> > >>>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
> > >>>>>> @@ -71,6 +71,7 @@ struct vfio_iommu {
> > >>>>>>     	unsigned int		dma_avail;
> > >>>>>>     	bool			v2;
> > >>>>>>     	bool			nesting;
> > >>>>>> +	bool			dirty_page_tracking;
> > >>>>>>     };
> > >>>>>>     
> > >>>>>>     struct vfio_domain {
> > >>>>>> @@ -91,6 +92,7 @@ struct vfio_dma {
> > >>>>>>     	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
> > >>>>>>     	struct task_struct	*task;
> > >>>>>>     	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
> > >>>>>> +	unsigned long		*bitmap;
> > >>>>>>     };
> > >>>>>>     
> > >>>>>>     struct vfio_group {
> > >>>>>> @@ -125,7 +127,21 @@ struct vfio_regions {
> > >>>>>>     #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
> > >>>>>>     					(!list_empty(&iommu->domain_list))
> > >>>>>>     
> > >>>>>> +#define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) / BITS_PER_BYTE)
> > >>>>>> +
> > >>>>>> +/*
> > >>>>>> + * Input argument of number of bits to bitmap_set() is unsigned integer, which
> > >>>>>> + * further casts to signed integer for unaligned multi-bit operation,
> > >>>>>> + * __bitmap_set().
> > >>>>>> + * Then maximum bitmap size supported is 2^31 bits divided by 2^3 bits/byte,
> > >>>>>> + * that is 2^28 (256 MB) which maps to 2^31 * 2^12 = 2^43 (8TB) on 4K page
> > >>>>>> + * system.
> > >>>>>> + */
> > >>>>>> +#define DIRTY_BITMAP_PAGES_MAX	(uint64_t)(INT_MAX - 1)
> > >>>>>> +#define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
> > >>>>>> +
> > >>>>>>     static int put_pfn(unsigned long pfn, int prot);
> > >>>>>> +static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu);
> > >>>>>>     
> > >>>>>>     /*
> > >>>>>>      * This code handles mapping and unmapping of user data buffers
> > >>>>>> @@ -175,6 +191,77 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
> > >>>>>>     	rb_erase(&old->node, &iommu->dma_list);
> > >>>>>>     }
> > >>>>>>     
> > >>>>>> +
> > >>>>>> +static int vfio_dma_bitmap_alloc(struct vfio_dma *dma, uint64_t pgsize)
> > >>>>>> +{
> > >>>>>> +	uint64_t npages = dma->size / pgsize;
> > >>>>>> +  
> > > If pgsize > dma->size, npages = 0.
> > > wouldn't it cause problem?
> > >   
> > 
> > This patch-set supports bitmap for smallest supported page size, i.e. 
> > PAGE_SIZE. vfio_dma_do_map() validates dma->size accordingly. So this 
> > case will not happen.
> >   
> as far as I know, qemu/kvm uses 4k as the unit for dirty page tracking.
> so why smallest iommu page size is used here?
> wouldn't it cause problem?

If your concern is that the IOMMU supports sub-4K page sizes, see
vfio_pgsize_bitmap().  We actually only support PAGE_SIZE as our
minimum mapping unit, even if the IOMMU supports less, so PAGE_SIZE is
our lower bound.  Thanks,

Alex

