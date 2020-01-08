Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 059411337D3
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 01:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgAHAJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 19:09:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60334 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725601AbgAHAJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 19:09:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578442178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NvsR3l042aE6tbJjyXLqRgr/i4kZNDwa9CXx/uDAqCA=;
        b=F5GJFkgp8/3A3LJal6IyTBAmPj6RvJaHhTLOaNdrdmLykAUaFhpS/8UGdFG+11lovVvEdg
        xkp9ZCpb8xSbymulGrflwp6SsDTLVGIrpAWKMZ/vMuQspReXyH8OZ4JG9Rf91gg2G4AvmO
        S4/aL+M5ZjDL7iHPMPSyPWRbVmNUJuM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-P76lbGjzNSS3NgVr5OM5pQ-1; Tue, 07 Jan 2020 19:09:34 -0500
X-MC-Unique: P76lbGjzNSS3NgVr5OM5pQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12718107ACC4;
        Wed,  8 Jan 2020 00:09:32 +0000 (UTC)
Received: from w520.home (ovpn-116-26.phx2.redhat.com [10.3.116.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B67B160CD3;
        Wed,  8 Jan 2020 00:09:29 +0000 (UTC)
Date:   Tue, 7 Jan 2020 17:09:29 -0700
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
Subject: Re: [PATCH v11 Kernel 6/6] vfio: Selective dirty page tracking if
 IOMMU backed device pins pages
Message-ID: <20200107170929.74c9c92e@w520.home>
In-Reply-To: <66512c1f-aedc-a718-8594-b52d266f4b60@nvidia.com>
References: <1576602651-15430-1-git-send-email-kwankhede@nvidia.com>
        <1576602651-15430-7-git-send-email-kwankhede@nvidia.com>
        <20191217171219.7cc3fc1d@x1.home>
        <66512c1f-aedc-a718-8594-b52d266f4b60@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Jan 2020 02:15:01 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 12/18/2019 5:42 AM, Alex Williamson wrote:
> > On Tue, 17 Dec 2019 22:40:51 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
> 
> <snip>
> 
> > 
> > This will fail when there are devices within the IOMMU group that are
> > not represented as vfio_devices.  My original suggestion was:
> > 
> > On Thu, 14 Nov 2019 14:06:25 -0700
> > Alex Williamson <alex.williamson@redhat.com> wrote:  
> >> I think it does so by pinning pages.  Is it acceptable that if the
> >> vendor driver pins any pages, then from that point forward we consider
> >> the IOMMU group dirty page scope to be limited to pinned pages?  There
> >> are complications around non-singleton IOMMU groups, but I think we're
> >> already leaning towards that being a non-worthwhile problem to solve.
> >> So if we require that only singleton IOMMU groups can pin pages and we  
> > 
> > We could tag vfio_groups as singleton at vfio_add_group_dev() time with
> > an iommu_group_for_each_dev() walk so that we can cache the value on
> > the struct vfio_group.   
> 
> I don't think iommu_group_for_each_dev() is required. Checking 
> group->device_list in vfio_add_group_dev() if there are more than one 
> device should work, right?
> 
>          list_for_each_entry(vdev, &group->device_list, group_next) {
>                  if (group->is_singleton) {
>                          group->is_singleton = false;
>                          break;
>                  } else {
>                          group->is_singleton = true;
>                  }
>          }

Hmm, I think you're taking a different approach to this than I was
thinking.  Re-reading my previous comments, the fact that both vfio.c
and vfio_iommu_type1.c each have their own private struct vfio_group
makes things rather unclear.  I was intending to use the struct
iommu_group as the object vfio.c provides to type1.c to associate the
pinning.  This would require that not only the vfio view of devices in
the group to be singleton, but also the actual iommu group to be
singleton.  Otherwise the set of devices vfio.c has in the group might
only be a subset of the group.  Maybe a merger of the approaches is
easier though.

Tracking whether the vfio.c view of a group is singleton is even easier
than above, we could simply add a device_count field to vfio_group,
increment it in vfio_group_create_device() and decrement it in
vfio_device_release().  vfio_pin_pages() could return error if
device_count is not 1.  We could still add the iommu_group pointer to
the type1 pin_pages callback, but perhaps type1 simply assumes that the
group is singleton when pin pages is called and it's vfio.c's
responsibility to maintain that group as singleton once pages have been
pinned.  vfio.c would therefore also need to set a field on the
vfio_group if pages have been pinned such that vfio_add_group_dev()
could return error if a new device attempts to join the group.  We'd
need to make sure that field is cleared when the group is released from
use and pay attention to races that might occur between adding devices
to a group and pinning pages.

> > vfio_group_nb_add_dev() could update this if
> > the IOMMU group composition changes.   
> 
> I don't see vfio_group_nb_add_dev() calls vfio_add_group_dev() (?)
> If checking is_singleton is taken care in vfio_group_nb_add_dev(), which 
> is the only place where vfio_group is allocated, that should work, I think.

This was relative to maintaining that the iommu group itself is
singleton, not just the vfio view of the group.  If we use the latter
as our basis, then you're right, we should need this, but vfio.c would
need to enforce that the group remains singleton if it has pinned
pages.  Does that make sense?  Thanks,

Alex

> > vfio_pin_pages() could return
> > -EINVAL if (!group->is_singleton).
> >   
> >> pass the IOMMU group as a parameter to
> >> vfio_iommu_driver_ops.pin_pages(), then the type1 backend can set a
> >> flag on its local vfio_group struct to indicate dirty page scope is
> >> limited to pinned pages.  
> > 
> > ie. vfio_iommu_type1_unpin_pages() calls find_iommu_group() on each
> > domain in domain_list and the external_domain using the struct
> > iommu_group pointer provided by vfio-core.  We set a new attribute on
> > the vfio_group to indicate that vfio_group has (at some point) pinned
> > pages.
> >   
> >>   We might want to keep a flag on the
> >> vfio_iommu struct to indicate if all of the vfio_groups for each
> >> vfio_domain in the vfio_iommu.domain_list dirty page scope limited to
> >> pinned pages as an optimization to avoid walking lists too often.  Then
> >> we could test if vfio_iommu.domain_list is not empty and this new flag
> >> does not limit the dirty page scope, then everything within each
> >> vfio_dma is considered dirty.  
> > 
> > So at the point where we change vfio_group.has_pinned_pages from false
> > to true, or a group is added or removed, we walk all the groups in the
> > vfio_iommu and if they all have has_pinned_pages set, we can set a
> > vfio_iommu.pinned_page_dirty_scope flag to true.  If that flag is
> > already true on page pinning, we can skip the lookup.
> > 
> > I still like this approach better, it doesn't require a callback from
> > type1 to vfio-core and it doesn't require a heavy weight walking for
> > group devices and vfio data structures every time we fill a bitmap.
> > Did you run into issues trying to implement this approach?   
> 
> Thanks for elaborative steps.
> This works. Changing this last commit.
> 
> Thanks,
> Kirti
> 

