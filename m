Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9E132460E
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 23:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236189AbhBXWBv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 17:01:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59862 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233836AbhBXWBo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 17:01:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614204018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WxqXVlqBS1y9jKE0wOwNgyPIzeronS+UkjXdROvCzZA=;
        b=GpZb8qXqhi519r1//eXvIXKWRPTpunh7LFrJ3ZBNN8QR6oHQUm9L/VUp3LTuS5DoNbKSfw
        lsTanWLLuFxY2fBZkmicVu91UbvYlvQ9n4uuwpvWdaT1RIMZsrzclZpYItJ8SrJsXVymck
        4rmquyN2b9YwTOZC3/Vzkvf4EmCxBng=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-YzFgQoQpMReWvSTlmdVLIQ-1; Wed, 24 Feb 2021 17:00:14 -0500
X-MC-Unique: YzFgQoQpMReWvSTlmdVLIQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7FF2100A8EA;
        Wed, 24 Feb 2021 22:00:13 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53B2B5C230;
        Wed, 24 Feb 2021 22:00:13 +0000 (UTC)
Date:   Wed, 24 Feb 2021 14:55:06 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [RFC PATCH 05/10] vfio: Create a vfio_device from vma lookup
Message-ID: <20210224145506.48f6e0b4@omen.home.shazbot.org>
In-Reply-To: <20210222172913.GP4247@nvidia.com>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
        <161401268537.16443.2329805617992345365.stgit@gimli.home>
        <20210222172913.GP4247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Feb 2021 13:29:13 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Feb 22, 2021 at 09:51:25AM -0700, Alex Williamson wrote:
> 
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index da212425ab30..399c42b77fbb 100644
> > +++ b/drivers/vfio/vfio.c
> > @@ -572,6 +572,15 @@ void vfio_device_unmap_mapping_range(struct vfio_device *device,
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_device_unmap_mapping_range);
> >  
> > +/*
> > + * A VFIO bus driver using this open callback will provide a
> > + * struct vfio_device pointer in the vm_private_data field.  
> 
> The vfio_device pointer should be stored in the struct file
> 
> > +struct vfio_device *vfio_device_get_from_vma(struct vm_area_struct *vma)
> > +{
> > +	struct vfio_device *device;
> > +
> > +	if (vma->vm_ops->open != vfio_device_vma_open)
> > +		return ERR_PTR(-ENODEV);
> > +  
> 
> Having looked at VFIO alot more closely last week, this is even more
> trivial - VFIO only creates mmaps of memory we want to invalidate, so
> this is just very simple:
> 
> struct vfio_device *vfio_device_get_from_vma(struct vm_area_struct *vma)
> {
>        if (!vma->vm_file ||vma->vm_file->f_op != &vfio_device_fops)
> 	   return ERR_PTR(-ENODEV);
>        return vma->vm_file->f_private;
> }

That's pretty clever.

> The only use of the special ops would be if there are multiple types
> of mmap's going on, but for this narrow use case those would be safely
> distinguished by the vm_pgoff instead

We potentially do have device specific regions which can support mmap,
for example the migration region.  We'll need to think about how we
could even know if portions of those regions map to a device.  We could
use the notifier to announce it and require the code supporting those
device specific regions manage it.

I'm not really clear what you're getting at with vm_pgoff though, could
you explain further?

> > +extern void vfio_device_vma_open(struct vm_area_struct *vma);
> > +extern struct vfio_device *vfio_device_get_from_vma(struct vm_area_struct *vma);  
> 
> No externs on function prototypes in new code please, we've been
> slowly deleting them..

For now it's consistent with what we have there already, I'd prefer a
separate cleanup of that before or after rather than introducing
inconsistency here.  Thanks,

Alex

