Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3EE1D9BC0
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 17:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgESPyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 11:54:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45643 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728953AbgESPyI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 11:54:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589903646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HvazmUOdOf/bNdnHfUgyTxq+WDNdBaoeA71aXx2iyCY=;
        b=DL3pNcD/FPz31sI1bCZ8HAK2sdce+fSVAfQc0aTWAzXrvf8S30diIm11cZ9BpHmcmnDV69
        OtAXvQZmWA+T6WnIiIulaBRHcedT1maQyYr0JUbvAIevkT4+b4szXua42YtG5maW67GW32
        WCrFdlR8D+1PlmsD3Az58tLq8h4MeZU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-GOniji0fNR6uq00iBaf5Rw-1; Tue, 19 May 2020 11:54:02 -0400
X-MC-Unique: GOniji0fNR6uq00iBaf5Rw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C4B418FE860;
        Tue, 19 May 2020 15:53:59 +0000 (UTC)
Received: from x1.home (ovpn-112-50.phx2.redhat.com [10.3.112.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A075100164D;
        Tue, 19 May 2020 15:53:57 +0000 (UTC)
Date:   Tue, 19 May 2020 09:53:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>, <cjia@nvidia.com>,
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
Message-ID: <20200519095356.5d1f6ffa@x1.home>
In-Reply-To: <20200519173507.3cd131dd.cohuck@redhat.com>
References: <1589488667-9683-1-git-send-email-kwankhede@nvidia.com>
        <1589488667-9683-5-git-send-email-kwankhede@nvidia.com>
        <20200515125916.78723321.cohuck@redhat.com>
        <bdb9c1d3-e673-5bb1-aced-f7443f4dfe58@nvidia.com>
        <20200519173507.3cd131dd.cohuck@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 May 2020 17:35:07 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Fri, 15 May 2020 23:05:24 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
> > On 5/15/2020 4:29 PM, Cornelia Huck wrote:  
> > > On Fri, 15 May 2020 02:07:43 +0530
> > > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > >     
> > >> IOMMU container maintains a list of all pages pinned by vfio_pin_pages API.
> > >> All pages pinned by vendor driver through this API should be considered as
> > >> dirty during migration. When container consists of IOMMU capable device and
> > >> all pages are pinned and mapped, then all pages are marked dirty.
> > >> Added support to start/stop dirtied pages tracking and to get bitmap of all
> > >> dirtied pages for requested IO virtual address range.
> > >>
> > >> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> > >> Reviewed-by: Neo Jia <cjia@nvidia.com>
> > >> ---
> > >>   include/uapi/linux/vfio.h | 55 +++++++++++++++++++++++++++++++++++++++++++++++
> > >>   1 file changed, 55 insertions(+)  
> 
> (...)
> 
> > >> + * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP flag set,
> > >> + * IOCTL returns dirty pages bitmap for IOMMU container during migration for
> > >> + * given IOVA range.    
> > > 
> > > "Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_GET_BITMAP returns the
> > > dirty pages bitmap for the IOMMU container for a given IOVA range." ?
> > > 
> > > Q: How does this interact with the two other operations? I imagine
> > > getting an empty bitmap before _START     
> > 
> > No, if dirty page tracking is not started, get_bitmap IOCTL will fail 
> > with -EINVAL.
> >   
> > > and a bitmap-in-progress between
> > > _START and _STOP. > After _STOP, will subsequent calls always give the
> > > same bitmap?
> > >    
> > 
> > No, return -EINVAL.  
> 
> Maybe add
> 
> "If the IOCTL has not yet been called with
> VFIO_IOMMU_DIRTY_PAGES_FLAG_START, or if it has been called with
> VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP, calling it with
> VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP will return -EINVAL." ?

Let's not specify ourselves into a corner, I think we can simply say
that the dirty bitmap is only available while dirty logging is enabled.
We certainly don't need to specify specific errno values that'll trip
us up later.

> > >> User must provide data[] as the structure
> > >> + * vfio_iommu_type1_dirty_bitmap_get through which user provides IOVA range and
> > >> + * pgsize.    
> > > 
> > > "The user must specify the IOVA range and the pgsize through the
> > > vfio_iommu_type1_dirty_bitmap_get structure in the data[] portion."
> > > 
> > > ?
> > >     
> > >> This interface supports to get bitmap of smallest supported pgsize
> > >> + * only and can be modified in future to get bitmap of specified pgsize.    
> > > 
> > > That's a current restriction? How can the user find out whether it has
> > > been lifted (or, more generally, find out which pgsize values are
> > > supported)?    
> > 
> > Migration capability is added to IOMMU info chain. That gives supported 
> > pgsize bitmap by IOMMU driver.  
> 
> Add that info?
> 
> "The supported pgsize values for this interface are reported via the
> migration capability in the IOMMU info chain."
> 
> >   
> > >     
> > >> + * User must allocate memory for bitmap, zero the bitmap memory  and set size
> > >> + * of allocated memory in bitmap.size field.    
> > > 
> > > "The user must provide a zeroed memory area for the bitmap memory and
> > > specify its size in bitmap.size."
> > > 
> > > ?
> > >     
> > >> One bit is used to represent one
> > >> + * page consecutively starting from iova offset. User should provide page size
> > >> + * in bitmap.pgsize field.    
> > > 
> > > s/User/The user/
> > > 
> > > Is that the 'pgsize' the comment above talks about?
> > >     
> > 
> > By specifying pgsize here user can ask for bitmap of specific pgsize.  
> 
> "The user should provide the page size for the bitmap in the
> bitmap.pgsize field." ?
> 
> >   
> > >> Bit set in bitmap indicates page at that offset from
> > >> + * iova is dirty.    
> > > 
> > > "A bit set in the bitmap indicates that the page at that offset from
> > > iova is dirty." ?
> > >     
> > >> Caller must set argsz including size of structure
> > >> + * vfio_iommu_type1_dirty_bitmap_get.    
> > > 
> > > s/Caller/The caller/
> > > 
> > > Does argz also include the size of the bitmap?    
> > 
> > No.  
> 
> "The caller must set argsz to a value including the size of stuct
> vfio_io_type1_dirty_bitmap_get, but excluding the size of the actual
> bitmap." ?

Yes, it wouldn't make sense for argsz to include the size of the bitmap
itself, that's accessed independently via a user provided pointer and
we have a separate size field for that.  Thanks,

Alex

