Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97DC817AEA4
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 20:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgCETCA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 14:02:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30445 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725977AbgCETCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 14:02:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583434919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DY5YqhvjQMnPrhbBNfCnQkD/xoye6AV9b4GrL7fHxYk=;
        b=ilhLt4Dtb7W4kYssOErTG4+ay5GSKzeG2akTGWkfMKumG8N/+LYn+18F8CqHd0qtP8FQbA
        HzQRZJ2GAiwc+pkPUeGv/fNW0CQSJ092heV7X8HV20XWxbZGdAIPHPwY8vfHosZE009cxn
        F1OKnWtXS4KhLAeXtpZjTNDYvOCxqxI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-1FQ5pFhGPaui0hpv2b7jsg-1; Thu, 05 Mar 2020 14:01:55 -0500
X-MC-Unique: 1FQ5pFhGPaui0hpv2b7jsg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA6BD8010EE;
        Thu,  5 Mar 2020 19:01:53 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E2E094B20;
        Thu,  5 Mar 2020 19:01:49 +0000 (UTC)
Date:   Thu, 5 Mar 2020 12:01:49 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Subject: Re: [PATCH v3 1/7] vfio: allow external user to get vfio group from
 device
Message-ID: <20200305120149.52f71551@w520.home>
In-Reply-To: <20200225033542.GE30338@joy-OptiPlex-7040>
References: <20200224084350.31574-1-yan.y.zhao@intel.com>
        <20200224084641.31696-1-yan.y.zhao@intel.com>
        <20200224121504.367cdfb4@w520.home>
        <20200225033542.GE30338@joy-OptiPlex-7040>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Feb 2020 22:35:42 -0500
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Tue, Feb 25, 2020 at 03:15:04AM +0800, Alex Williamson wrote:
> > On Mon, 24 Feb 2020 03:46:41 -0500
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >   
> > > external user is able to
> > > 1. add a device into an vfio group  
> > 
> > How so?  The device is added via existing mechanisms, the only thing
> > added here is an interface to get a group reference from a struct
> > device.
> >   
> > > 2. call vfio_group_get_external_user_from_dev() with the device pointer
> > > to get vfio_group associated with this device and increments the container
> > > user counter to prevent the VFIO group from disposal before KVM exits.
> > > 3. When the external KVM finishes, it calls vfio_group_put_external_user()
> > > to release the VFIO group.
> > > 
> > > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > ---
> > >  drivers/vfio/vfio.c  | 37 +++++++++++++++++++++++++++++++++++++
> > >  include/linux/vfio.h |  2 ++
> > >  2 files changed, 39 insertions(+)
> > > 
> > > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > > index c8482624ca34..914bdf4b9d73 100644
> > > --- a/drivers/vfio/vfio.c
> > > +++ b/drivers/vfio/vfio.c
> > > @@ -1720,6 +1720,43 @@ struct vfio_group *vfio_group_get_external_user(struct file *filep)
> > >  }
> > >  EXPORT_SYMBOL_GPL(vfio_group_get_external_user);
> > >  
> > > +/**
> > > + * External user API, exported by symbols to be linked dynamically.
> > > + *
> > > + * The protocol includes:
> > > + * 1. External user add a device into a vfio group
> > > + *
> > > + * 2. The external user calls vfio_group_get_external_user_from_dev()
> > > + * with the device pointer
> > > + * to verify that:
> > > + *	- there's a vfio group associated with it and is initialized;
> > > + *	- IOMMU is set for the vfio group.
> > > + * If both checks passed, vfio_group_get_external_user_from_dev()
> > > + * increments the container user counter to prevent
> > > + * the VFIO group from disposal before KVM exits.
> > > + *
> > > + * 3. When the external KVM finishes, it calls
> > > + * vfio_group_put_external_user() to release the VFIO group.
> > > + * This call decrements the container user counter.
> > > + */  
> > 
> > I don't think we need to duplicate this whole comment block for a
> > _from_dev() version of the existing vfio_group_get_external_user().
> > Please merge the comments.  
> ok. but I have a question: for an external user, as it already has group
> fd, it can use vfio_group_get_external_user() directly, is there a
> necessity for it to call vfio_group_get_external_user_from_dev() ?
> 
> If an external user wants to call this interface, it needs to first get
> device fd, passes the device fd to kernel and kernel retrieves the pointer
> to struct device, right?

If you have the fd already, then yeah, let's not add a _from_dev()
version, but how would an mdev vendor driver have the fd?  IIRC, the
existing interface is designed this way to allow the user to prove
ownership, whereas using a _from_dev() interface would be for trusted
parts of the kernel, where we can theoretically trust that code isn't
simply locating a device in order to perform malicious actions in the
user (because they'd have more direct ways than this to be malicious to
the user already).

> > > +
> > > +struct vfio_group *vfio_group_get_external_user_from_dev(struct device *dev)
> > > +{
> > > +	struct vfio_group *group;
> > > +	int ret;
> > > +
> > > +	group = vfio_group_get_from_dev(dev);
> > > +	if (!group)
> > > +		return ERR_PTR(-ENODEV);
> > > +
> > > +	ret = vfio_group_add_container_user(group);
> > > +	if (ret)
> > > +		return ERR_PTR(ret);  
> > 
> > Error path leaks group reference.
> >  
> oops, sorry for that.
> 
> > > +
> > > +	return group;
> > > +}
> > > +EXPORT_SYMBOL_GPL(vfio_group_get_external_user_from_dev);
> > > +
> > >  void vfio_group_put_external_user(struct vfio_group *group)
> > >  {
> > >  	vfio_group_try_dissolve_container(group);
> > > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > > index e42a711a2800..2e1fa0c7396f 100644
> > > --- a/include/linux/vfio.h
> > > +++ b/include/linux/vfio.h
> > > @@ -94,6 +94,8 @@ extern void vfio_unregister_iommu_driver(
> > >   */
> > >  extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
> > >  extern void vfio_group_put_external_user(struct vfio_group *group);
> > > +extern
> > > +struct vfio_group *vfio_group_get_external_user_from_dev(struct device *dev);  
> > 
> > Slight cringe at this line wrap, personally would prefer to wrap the
> > args as done repeatedly elsewhere in this file.  Thanks,
> >  
> yeah, I tried to do in that way, but the name of this interface is too long,
> as well as its return type, it passes 80 characters limit even with just one
> arg...
> 
> is it better to wrap in below way?
> extern struct vfio_group *vfio_group_get_external_user_from_dev(struct device
> 								*dev);
> 
> or just a shorter interface name?
> extern struct vfio_group *vfio_group_get_user_from_dev(struct device *dev);

I'd probably tend towards the former, keeping "external" in the name
makes it clear that it belongs to a certain class of functions with
similar conventions.  Thanks,

Alex

