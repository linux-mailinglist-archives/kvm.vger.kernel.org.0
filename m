Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 276AD134FB4
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 23:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgAHW7q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 17:59:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46130 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726548AbgAHW7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 17:59:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578524384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OqLbt1MJpD/2l5pEoZdMNVoLWGTl0KHDQB1cd3hrBlI=;
        b=A3V1qb9VtPPkPKrg2v09xIX/xl9IGy05Um7FjzcWXT9JYNwbq8ew8kdZmZXpGtuixBDKKK
        TmEZ7qsJs01c71mCJw12IgMLNxKp8oQNbL/fxZKYxdYTrdaqKNanjICivMl+TS8r9QSckX
        3zoE5y4Ig5gmZ0D+BbKJJ6I+8hU6g6w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-5lA3Di29O3u2mxZAUm_foQ-1; Wed, 08 Jan 2020 17:59:41 -0500
X-MC-Unique: 5lA3Di29O3u2mxZAUm_foQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28159107ACC4;
        Wed,  8 Jan 2020 22:59:39 +0000 (UTC)
Received: from w520.home (ovpn-118-62.phx2.redhat.com [10.3.118.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 311095C241;
        Wed,  8 Jan 2020 22:59:37 +0000 (UTC)
Date:   Wed, 8 Jan 2020 15:59:36 -0700
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
Message-ID: <20200108155936.5e725eaa@w520.home>
In-Reply-To: <17069da7-279b-872f-db15-d9995cf46285@nvidia.com>
References: <1576602651-15430-1-git-send-email-kwankhede@nvidia.com>
        <1576602651-15430-7-git-send-email-kwankhede@nvidia.com>
        <20191217171219.7cc3fc1d@x1.home>
        <66512c1f-aedc-a718-8594-b52d266f4b60@nvidia.com>
        <20200107170929.74c9c92e@w520.home>
        <17069da7-279b-872f-db15-d9995cf46285@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Jan 2020 02:22:26 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 1/8/2020 5:39 AM, Alex Williamson wrote:
> > On Wed, 8 Jan 2020 02:15:01 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
> >> On 12/18/2019 5:42 AM, Alex Williamson wrote:  
> >>> On Tue, 17 Dec 2019 22:40:51 +0530
> >>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >>>      
> >>
> >> <snip>
> >>  
> >>>
> >>> This will fail when there are devices within the IOMMU group that are
> >>> not represented as vfio_devices.  My original suggestion was:
> >>>
> >>> On Thu, 14 Nov 2019 14:06:25 -0700
> >>> Alex Williamson <alex.williamson@redhat.com> wrote:  
> >>>> I think it does so by pinning pages.  Is it acceptable that if the
> >>>> vendor driver pins any pages, then from that point forward we consider
> >>>> the IOMMU group dirty page scope to be limited to pinned pages?  There
> >>>> are complications around non-singleton IOMMU groups, but I think we're
> >>>> already leaning towards that being a non-worthwhile problem to solve.
> >>>> So if we require that only singleton IOMMU groups can pin pages and we  
> >>>
> >>> We could tag vfio_groups as singleton at vfio_add_group_dev() time with
> >>> an iommu_group_for_each_dev() walk so that we can cache the value on
> >>> the struct vfio_group.  
> >>
> >> I don't think iommu_group_for_each_dev() is required. Checking
> >> group->device_list in vfio_add_group_dev() if there are more than one
> >> device should work, right?
> >>
> >>           list_for_each_entry(vdev, &group->device_list, group_next) {
> >>                   if (group->is_singleton) {
> >>                           group->is_singleton = false;
> >>                           break;
> >>                   } else {
> >>                           group->is_singleton = true;
> >>                   }
> >>           }  
> > 
> > Hmm, I think you're taking a different approach to this than I was
> > thinking.  Re-reading my previous comments, the fact that both vfio.c
> > and vfio_iommu_type1.c each have their own private struct vfio_group
> > makes things rather unclear.  I was intending to use the struct
> > iommu_group as the object vfio.c provides to type1.c to associate the
> > pinning.  This would require that not only the vfio view of devices in
> > the group to be singleton, but also the actual iommu group to be
> > singleton.  Otherwise the set of devices vfio.c has in the group might
> > only be a subset of the group.  Maybe a merger of the approaches is
> > easier though.
> > 
> > Tracking whether the vfio.c view of a group is singleton is even easier
> > than above, we could simply add a device_count field to vfio_group,
> > increment it in vfio_group_create_device() and decrement it in
> > vfio_device_release().  vfio_pin_pages() could return error if
> > device_count is not 1.  We could still add the iommu_group pointer to
> > the type1 pin_pages callback, but perhaps type1 simply assumes that the
> > group is singleton when pin pages is called and it's vfio.c's
> > responsibility to maintain that group as singleton once pages have been
> > pinned.  vfio.c would therefore also need to set a field on the
> > vfio_group if pages have been pinned such that vfio_add_group_dev()
> > could return error if a new device attempts to join the group.  We'd
> > need to make sure that field is cleared when the group is released from
> > use and pay attention to races that might occur between adding devices
> > to a group and pinning pages.
> >   
> 
> Thinking aloud, will adding singleton check could cause issues in near 
> future? - may be in future support for p2p and direct RDMA will be added 
> for mdev devices. In that case the two devices should be in same 
> iommu_domain, but should be in different iommu_group - is that 
> understanding correct?

The ACS redirection stuff is the only thing that actually changes iommu
grouping relative to p2p/RDMA and that's specifically for untranslated
DMA, aiui.  If we wanted translated p2p DMA to be routed downstream of
the IOMMU we'd need to enable ACS direct translation.  In any case,
those are about shortening the path for p2p between devices.  We
actually don't even need devices to be in the same iommu domain to
allow p2p, we only need the iommu domain for each respective device to
map the mmio spaces of the other device.  I don't think we're doing
anything here that would cause us trouble later in this space, but it's
also just a policy decision, we wouldn't be breaking ABI to change the
implementation later.
 
> >>> vfio_group_nb_add_dev() could update this if
> >>> the IOMMU group composition changes.  
> >>
> >> I don't see vfio_group_nb_add_dev() calls vfio_add_group_dev() (?)
> >> If checking is_singleton is taken care in vfio_group_nb_add_dev(), which
> >> is the only place where vfio_group is allocated, that should work, I think.  
> > 
> > This was relative to maintaining that the iommu group itself is
> > singleton, not just the vfio view of the group.  If we use the latter
> > as our basis, then you're right, we should need this, but vfio.c would
> > need to enforce that the group remains singleton if it has pinned
> > pages.  Does that make sense?  Thanks,
> >   
> 
> Which route should be taken - iommu_group view or vfio.c group view?

The latter seems easier, more flexible, and lower overhead as far as I
can see.  Thanks,

Alex

