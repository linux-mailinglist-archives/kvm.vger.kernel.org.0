Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAE31D3179
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 15:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgENNjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 09:39:42 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28541 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726011AbgENNjm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 09:39:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589463580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=onL0BkmbSw+AElY7qloLV7wFhrEx7Espc53UP3KFkG8=;
        b=aqLWJ8V7DGQkn3a0CmCIsF81sypCeW7Z65TACJYLZXFCtoQtl2iI79Kfgu25kApNgl1vgr
        yiL0AdkfAsWU4CmNhcdR1IJEyaTgeNbStWGjaGjiyvkAeTwgSdauBm4Qtrvm73LMDqgbCF
        7CgsaNKp3WDMp3bW5tEpRDbLUe4fxcI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-OwiIij9XO0OOQgZ3JbVWaQ-1; Thu, 14 May 2020 09:39:38 -0400
X-MC-Unique: OwiIij9XO0OOQgZ3JbVWaQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03B9D18A0721;
        Thu, 14 May 2020 13:39:36 +0000 (UTC)
Received: from x1.home (ovpn-113-111.phx2.redhat.com [10.3.113.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9556A51322;
        Thu, 14 May 2020 13:39:34 +0000 (UTC)
Date:   Thu, 14 May 2020 07:39:34 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     <cjia@nvidia.com>, <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH Kernel v19 7/8] vfio iommu: Add migration capability to
 report supported features
Message-ID: <20200514073934.2d27ac96@x1.home>
In-Reply-To: <23cb6aae-5212-2bce-6bec-fd893ea84d09@nvidia.com>
References: <1589400279-28522-1-git-send-email-kwankhede@nvidia.com>
        <1589400279-28522-8-git-send-email-kwankhede@nvidia.com>
        <20200513230153.0b5f3729@x1.home>
        <23cb6aae-5212-2bce-6bec-fd893ea84d09@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 May 2020 17:25:10 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 5/14/2020 10:31 AM, Alex Williamson wrote:
> > On Thu, 14 May 2020 01:34:38 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
> >> Added migration capability in IOMMU info chain.
> >> User application should check IOMMU info chain for migration capability
> >> to use dirty page tracking feature provided by kernel module.
> >> User application must check page sizes supported and maximum dirty
> >> bitmap size returned by this capability structure for ioctls used to get
> >> dirty bitmap.
> >>
> >> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> >> ---
> >>   drivers/vfio/vfio_iommu_type1.c | 24 +++++++++++++++++++++++-
> >>   include/uapi/linux/vfio.h       | 21 +++++++++++++++++++++
> >>   2 files changed, 44 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index 4358be26ff80..77351497a9c2 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -2389,6 +2389,22 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
> >>   	return ret;
> >>   }
> >>   
> >> +static int vfio_iommu_migration_build_caps(struct vfio_iommu *iommu,
> >> +					   struct vfio_info_cap *caps)
> >> +{
> >> +	struct vfio_iommu_type1_info_cap_migration cap_mig;
> >> +
> >> +	cap_mig.header.id = VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION;
> >> +	cap_mig.header.version = 1;
> >> +	cap_mig.flags = VFIO_IOMMU_INFO_CAPS_MIGRATION_DIRTY_PAGE_TRACK;
> >> +
> >> +	/* support minimum pgsize */
> >> +	cap_mig.pgsize_bitmap = (size_t)1 << __ffs(iommu->pgsize_bitmap);
> >> +	cap_mig.max_dirty_bitmap_size = DIRTY_BITMAP_SIZE_MAX;
> >> +
> >> +	return vfio_info_add_capability(caps, &cap_mig.header, sizeof(cap_mig));
> >> +}
> >> +
> >>   static long vfio_iommu_type1_ioctl(void *iommu_data,
> >>   				   unsigned int cmd, unsigned long arg)
> >>   {
> >> @@ -2433,10 +2449,16 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
> >>   		mutex_lock(&iommu->lock);
> >>   		info.flags = VFIO_IOMMU_INFO_PGSIZES;
> >>   
> >> +		vfio_pgsize_bitmap(iommu);  
> > 
> > 
> > Why is it necessary to rebuild the bitmap here?  The user can't get to
> > this ioctl until they've added a group to the container and set the
> > IOMMU model.
> > 
> >   
> For mdev device, domain is not added to domain_list so 
> vfio_pgsize_bitmap() doesn't get called when there is only mdev device 
> attached.
> Your concern is right though, vfio_pgsize_bitmap() should get populated 
> with attach_group,so fixing it by calling vfio_pgsize_bitmap() for mdev 
> device when iommu->external_domain is set.
> 
> >>   		info.iova_pgsizes = iommu->pgsize_bitmap;
> >>   
> >> -		ret = vfio_iommu_iova_build_caps(iommu, &caps);
> >> +		ret = vfio_iommu_migration_build_caps(iommu, &caps);
> >> +
> >> +		if (!ret)
> >> +			ret = vfio_iommu_iova_build_caps(iommu, &caps);
> >> +
> >>   		mutex_unlock(&iommu->lock);
> >> +
> >>   		if (ret)
> >>   			return ret;
> >>   
> >> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >> index e3cbf8b78623..c90604322798 100644
> >> --- a/include/uapi/linux/vfio.h
> >> +++ b/include/uapi/linux/vfio.h
> >> @@ -1013,6 +1013,27 @@ struct vfio_iommu_type1_info_cap_iova_range {
> >>   	struct	vfio_iova_range iova_ranges[];
> >>   };
> >>   
> >> +/*
> >> + * The migration capability allows to report supported features for migration.
> >> + *
> >> + * The structures below define version 1 of this capability.
> >> + *
> >> + * pgsize_bitmap: Kernel driver returns supported page sizes bitmap for dirty
> >> + * page tracking.
> >> + * max_dirty_bitmap_size: Kernel driver returns maximum supported dirty bitmap
> >> + * size in bytes to be used by user application for ioctls to get dirty bitmap.
> >> + */
> >> +#define VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION  1
> >> +
> >> +struct vfio_iommu_type1_info_cap_migration {
> >> +	struct	vfio_info_cap_header header;
> >> +	__u32	flags;
> >> +	/* supports dirty page tracking */
> >> +#define VFIO_IOMMU_INFO_CAPS_MIGRATION_DIRTY_PAGE_TRACK	(1 << 0)  
> > 
> > This flag is a bit redundant to the purpose of this capability, isn't
> > it?  I think exposing the capability itself is indicating support for
> > dirty page tracking.  We should probably be explicit in the comment
> > about exactly what interface this capability implies.  Thanks,
> >  
> 
> Capability is added to provide provision for feature flags that kernel 
> driver support, that's where we started right?
> Later added pgsize_bitmap and max supported bitmap size as you suggested.
> I'm confused now, should I keep this flag here?
> Even if the flag is removed, 'flags' field is still required so that 
> whenever new feature is added, new flag will be added. That's the whole 
> purpose we added this capability. Can we add a field which is not used? 
> and we don't know when it will be used in future?

We have empty flags fields all over the uapi.  When I look at this
capability, I wonder what it means if it were to be implemented without
VFIO_IOMMU_INFO_CAPS_MIGRATION_DIRTY_PAGE_TRACK set.  For example, what
migration feature would an IOMMU be exposing if it didn't have dirty
page tracking.  All of the extensions we're implementing to support
migration in the IOMMU are related to dirty page tracking.  Therefore
it seems that the existence of the capability itself is expressing the
support for dirty page tracking, right?  Thanks,

Alex

> >> +	__u64	pgsize_bitmap;
> >> +	__u64	max_dirty_bitmap_size;		/* in bytes */
> >> +};
> >> +
> >>   #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
> >>   
> >>   /**  
> >   
> 

