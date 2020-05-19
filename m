Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDD71D9B64
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 17:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbgESPf0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 11:35:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29513 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728994AbgESPfZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 11:35:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589902524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tdh7I/F1KCzk31L6f8YhMKl++fAO0z5EMARL1BVk2HI=;
        b=aalE+Dlhx7EAkG/5Xt6qXoaqM99iHR66luySs6kXaAdTtBnQ5T907r8hpFPzr1EVUpAfB0
        qJknqBRCfqdxhx3fXTAEt82hrOsd/CIFIOEJUCpznN4/GsiEBVF/s69KTLSwQb3+DpSjez
        XXfDOzfWuS2ZsICI+MiS3pnovNM3M7o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-fbSBmljbN6OXLkWFYRCrSg-1; Tue, 19 May 2020 11:35:22 -0400
X-MC-Unique: fbSBmljbN6OXLkWFYRCrSg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD98B1B18BC0;
        Tue, 19 May 2020 15:35:19 +0000 (UTC)
Received: from gondolin (ovpn-112-229.ams2.redhat.com [10.36.112.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C55586ACE6;
        Tue, 19 May 2020 15:35:09 +0000 (UTC)
Date:   Tue, 19 May 2020 17:35:07 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     <alex.williamson@redhat.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH Kernel v20 4/8] vfio iommu: Add ioctl definition for
 dirty pages tracking
Message-ID: <20200519173507.3cd131dd.cohuck@redhat.com>
In-Reply-To: <bdb9c1d3-e673-5bb1-aced-f7443f4dfe58@nvidia.com>
References: <1589488667-9683-1-git-send-email-kwankhede@nvidia.com>
        <1589488667-9683-5-git-send-email-kwankhede@nvidia.com>
        <20200515125916.78723321.cohuck@redhat.com>
        <bdb9c1d3-e673-5bb1-aced-f7443f4dfe58@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 May 2020 23:05:24 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 5/15/2020 4:29 PM, Cornelia Huck wrote:
> > On Fri, 15 May 2020 02:07:43 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
> >> IOMMU container maintains a list of all pages pinned by vfio_pin_pages API.
> >> All pages pinned by vendor driver through this API should be considered as
> >> dirty during migration. When container consists of IOMMU capable device and
> >> all pages are pinned and mapped, then all pages are marked dirty.
> >> Added support to start/stop dirtied pages tracking and to get bitmap of all
> >> dirtied pages for requested IO virtual address range.
> >>
> >> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> >> Reviewed-by: Neo Jia <cjia@nvidia.com>
> >> ---
> >>   include/uapi/linux/vfio.h | 55 +++++++++++++++++++++++++++++++++++++++++++++++
> >>   1 file changed, 55 insertions(+)

(...)

> >> + * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP flag set,
> >> + * IOCTL returns dirty pages bitmap for IOMMU container during migration for
> >> + * given IOVA range.  
> > 
> > "Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_GET_BITMAP returns the
> > dirty pages bitmap for the IOMMU container for a given IOVA range." ?
> > 
> > Q: How does this interact with the two other operations? I imagine
> > getting an empty bitmap before _START   
> 
> No, if dirty page tracking is not started, get_bitmap IOCTL will fail 
> with -EINVAL.
> 
> > and a bitmap-in-progress between
> > _START and _STOP. > After _STOP, will subsequent calls always give the
> > same bitmap?
> >  
> 
> No, return -EINVAL.

Maybe add

"If the IOCTL has not yet been called with
VFIO_IOMMU_DIRTY_PAGES_FLAG_START, or if it has been called with
VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP, calling it with
VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP will return -EINVAL." ?

> 
> 
> >> User must provide data[] as the structure
> >> + * vfio_iommu_type1_dirty_bitmap_get through which user provides IOVA range and
> >> + * pgsize.  
> > 
> > "The user must specify the IOVA range and the pgsize through the
> > vfio_iommu_type1_dirty_bitmap_get structure in the data[] portion."
> > 
> > ?
> >   
> >> This interface supports to get bitmap of smallest supported pgsize
> >> + * only and can be modified in future to get bitmap of specified pgsize.  
> > 
> > That's a current restriction? How can the user find out whether it has
> > been lifted (or, more generally, find out which pgsize values are
> > supported)?  
> 
> Migration capability is added to IOMMU info chain. That gives supported 
> pgsize bitmap by IOMMU driver.

Add that info?

"The supported pgsize values for this interface are reported via the
migration capability in the IOMMU info chain."

> 
> >   
> >> + * User must allocate memory for bitmap, zero the bitmap memory  and set size
> >> + * of allocated memory in bitmap.size field.  
> > 
> > "The user must provide a zeroed memory area for the bitmap memory and
> > specify its size in bitmap.size."
> > 
> > ?
> >   
> >> One bit is used to represent one
> >> + * page consecutively starting from iova offset. User should provide page size
> >> + * in bitmap.pgsize field.  
> > 
> > s/User/The user/
> > 
> > Is that the 'pgsize' the comment above talks about?
> >   
> 
> By specifying pgsize here user can ask for bitmap of specific pgsize.

"The user should provide the page size for the bitmap in the
bitmap.pgsize field." ?

> 
> >> Bit set in bitmap indicates page at that offset from
> >> + * iova is dirty.  
> > 
> > "A bit set in the bitmap indicates that the page at that offset from
> > iova is dirty." ?
> >   
> >> Caller must set argsz including size of structure
> >> + * vfio_iommu_type1_dirty_bitmap_get.  
> > 
> > s/Caller/The caller/
> > 
> > Does argz also include the size of the bitmap?  
> 
> No.

"The caller must set argsz to a value including the size of stuct
vfio_io_type1_dirty_bitmap_get, but excluding the size of the actual
bitmap." ?

