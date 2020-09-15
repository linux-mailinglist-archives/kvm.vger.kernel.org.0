Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D6F26ADA1
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 21:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgIOTbX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 15:31:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727901AbgIOTaw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Sep 2020 15:30:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600198250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gX4cpnePMoDB0esiPXFW8NKIcY4fF4jaDx+rjfy2/4c=;
        b=FB9bpYoGddwoiAmpaRf+HIK9a+Bsy//016D40blKC9SvLOhhOGf4A4p+MS59pC+Y7cKleE
        dgTeoHjAqtD9Tr2iKLhSaPBNSoZ5LQNldIdCbDKqFKrc/uwmUojhoSZcB6zJke+5dDD9G/
        0300opbanZowQqoVWWoNEWIQ4IF9im8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-IGkZipbfN9Gxq4NWUzu4Tw-1; Tue, 15 Sep 2020 15:30:47 -0400
X-MC-Unique: IGkZipbfN9Gxq4NWUzu4Tw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26736192AB7C;
        Tue, 15 Sep 2020 19:30:12 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF55C75138;
        Tue, 15 Sep 2020 19:30:11 +0000 (UTC)
Date:   Tue, 15 Sep 2020 13:30:11 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: add a singleton check for vfio_group_pin_pages
Message-ID: <20200915133011.1e3652ee@x1.home>
In-Reply-To: <20200915130301.15d95412@x1.home>
References: <20200915003042.14273-1-yan.y.zhao@intel.com>
        <20200915130301.15d95412@x1.home>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Sep 2020 13:03:01 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 15 Sep 2020 08:30:42 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > vfio_pin_pages() and vfio_group_pin_pages() are used purely to mark dirty
> > pages to devices with IOMMU backend as they already have all VM pages
> > pinned at VM startup.  
> 
> This is wrong.  The entire initial basis of mdev devices is for
> non-IOMMU backed devices which provide mediation outside of the scope
> of the IOMMU.  That mediation includes interpreting device DMA
> programming and making use of the vfio_pin_pages() interface to
> translate and pin IOVA address to HPA.  Marking pages dirty is a
> secondary feature.
> 
> > when there're multiple devices in the vfio group, the dirty pages
> > marked through pin_pages interface by one device is not useful as the
> > other devices may access and dirty any VM pages.  
> 
> I don't know of any cases where there are multiple devices in a group
> that would make use of this interface, however, all devices within a
> group necessarily share an IOMMU context and any one device dirtying a
> page will dirty that page for all devices, so I don't see that this is
> a valid statement either.
> 
> > So added a check such that only singleton IOMMU groups can pin pages
> > in vfio_group_pin_pages. for mdevs, there's always only one dev in a
> > vfio group.
> > This is a fix to the commit below that added a singleton IOMMU group
> > check in vfio_pin_pages.  
> 
> None of the justification above is accurate, please try again.  Thanks,

FWIW, I think this should read something like "Page pinning is used
both to translate and pin device mappings for DMA purpose, as well as
to indicate to the IOMMU backend to limit the dirty page scope to those
pages that have been pinned, in the case of an IOMMU backed device.  To
support this, the vfio_pin_pages() interface limits itself to only
singleton groups such that the IOMMU backend can consider dirty page
scope only at the group level.  Implement the same requirement for the
vfio_group_pin_pages() interface."  Thanks,

Alex


> > Fixes: 95fc87b44104 (vfio: Selective dirty page tracking if IOMMU backed
> > device pins pages)
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  drivers/vfio/vfio.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index 5e6e0511b5aa..2f0fa272ebf2 100644
> > --- a/drivers/vfio/vfio.c
> > +++ b/drivers/vfio/vfio.c
> > @@ -2053,6 +2053,9 @@ int vfio_group_pin_pages(struct vfio_group *group,
> >  	if (!group || !user_iova_pfn || !phys_pfn || !npage)
> >  		return -EINVAL;
> >  
> > +	if (group->dev_counter > 1)
> > +		return  -EINVAL;
> > +
> >  	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
> >  		return -E2BIG;
> >    
> 

