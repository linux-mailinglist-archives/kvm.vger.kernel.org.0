Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C8B1D9BE4
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 18:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgESQBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 12:01:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54224 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729055AbgESQBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 12:01:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589904079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KlpBq/BXBFnjMr/SkJtxdRR7h+flQXgDwrlXGBm938A=;
        b=Ra8HI4OlPDIPBhdPKpjA1lSr9lO4uBjh6rqfYGWvagMVZ6W/i6sUdiLH1gZe35CcWodrDG
        6W25nyNwhvGanCGlMCnFoXpE6ZWxtdj4YH9uZPg+QVFjYn8BERQ7oxe4OdA/NOZAoJUUuB
        AJYxFTsdZ7M0KMDU8sLEwPcvt8eaaKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-CV9ojqhYOeWSsFwg92gVFg-1; Tue, 19 May 2020 12:01:15 -0400
X-MC-Unique: CV9ojqhYOeWSsFwg92gVFg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40BDE18FF663;
        Tue, 19 May 2020 16:01:10 +0000 (UTC)
Received: from gondolin (ovpn-112-229.ams2.redhat.com [10.36.112.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93B7C5C1C8;
        Tue, 19 May 2020 16:01:01 +0000 (UTC)
Date:   Tue, 19 May 2020 18:00:59 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
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
Message-ID: <20200519180059.68f2c338.cohuck@redhat.com>
In-Reply-To: <20200519095356.5d1f6ffa@x1.home>
References: <1589488667-9683-1-git-send-email-kwankhede@nvidia.com>
        <1589488667-9683-5-git-send-email-kwankhede@nvidia.com>
        <20200515125916.78723321.cohuck@redhat.com>
        <bdb9c1d3-e673-5bb1-aced-f7443f4dfe58@nvidia.com>
        <20200519173507.3cd131dd.cohuck@redhat.com>
        <20200519095356.5d1f6ffa@x1.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 May 2020 09:53:56 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 19 May 2020 17:35:07 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Fri, 15 May 2020 23:05:24 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
> > > On 5/15/2020 4:29 PM, Cornelia Huck wrote:    
> > > > On Fri, 15 May 2020 02:07:43 +0530
> > > > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > > >       
> > > >> IOMMU container maintains a list of all pages pinned by vfio_pin_pages API.
> > > >> All pages pinned by vendor driver through this API should be considered as
> > > >> dirty during migration. When container consists of IOMMU capable device and
> > > >> all pages are pinned and mapped, then all pages are marked dirty.
> > > >> Added support to start/stop dirtied pages tracking and to get bitmap of all
> > > >> dirtied pages for requested IO virtual address range.
> > > >>
> > > >> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> > > >> Reviewed-by: Neo Jia <cjia@nvidia.com>
> > > >> ---
> > > >>   include/uapi/linux/vfio.h | 55 +++++++++++++++++++++++++++++++++++++++++++++++
> > > >>   1 file changed, 55 insertions(+)    
> > 
> > (...)
> >   
> > > >> + * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP flag set,
> > > >> + * IOCTL returns dirty pages bitmap for IOMMU container during migration for
> > > >> + * given IOVA range.      
> > > > 
> > > > "Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_GET_BITMAP returns the
> > > > dirty pages bitmap for the IOMMU container for a given IOVA range." ?
> > > > 
> > > > Q: How does this interact with the two other operations? I imagine
> > > > getting an empty bitmap before _START       
> > > 
> > > No, if dirty page tracking is not started, get_bitmap IOCTL will fail 
> > > with -EINVAL.
> > >     
> > > > and a bitmap-in-progress between
> > > > _START and _STOP. > After _STOP, will subsequent calls always give the
> > > > same bitmap?
> > > >      
> > > 
> > > No, return -EINVAL.    
> > 
> > Maybe add
> > 
> > "If the IOCTL has not yet been called with
> > VFIO_IOMMU_DIRTY_PAGES_FLAG_START, or if it has been called with
> > VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP, calling it with
> > VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP will return -EINVAL." ?  
> 
> Let's not specify ourselves into a corner, I think we can simply say
> that the dirty bitmap is only available while dirty logging is enabled.
> We certainly don't need to specify specific errno values that'll trip
> us up later.

"If dirty logging is not enabled, an error will be returned." ?

(...)

> > > >> Caller must set argsz including size of structure
> > > >> + * vfio_iommu_type1_dirty_bitmap_get.      
> > > > 
> > > > s/Caller/The caller/
> > > > 
> > > > Does argz also include the size of the bitmap?      
> > > 
> > > No.    
> > 
> > "The caller must set argsz to a value including the size of stuct
> > vfio_io_type1_dirty_bitmap_get, but excluding the size of the actual
> > bitmap." ?  
> 
> Yes, it wouldn't make sense for argsz to include the size of the bitmap
> itself, that's accessed independently via a user provided pointer and
> we have a separate size field for that.  Thanks,
> 
> Alex

Yes, I just wanted to make it as obvious as possible to make it easier
for folks trying to interact with this interface.

