Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7967616B82D
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 04:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgBYDpH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 22:45:07 -0500
Received: from mga07.intel.com ([134.134.136.100]:30180 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbgBYDpH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 22:45:07 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 19:45:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,482,1574150400"; 
   d="scan'208";a="384340464"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga004.jf.intel.com with ESMTP; 24 Feb 2020 19:45:04 -0800
Date:   Mon, 24 Feb 2020 22:35:42 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
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
Message-ID: <20200225033542.GE30338@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200224084350.31574-1-yan.y.zhao@intel.com>
 <20200224084641.31696-1-yan.y.zhao@intel.com>
 <20200224121504.367cdfb4@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224121504.367cdfb4@w520.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 25, 2020 at 03:15:04AM +0800, Alex Williamson wrote:
> On Mon, 24 Feb 2020 03:46:41 -0500
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > external user is able to
> > 1. add a device into an vfio group
> 
> How so?  The device is added via existing mechanisms, the only thing
> added here is an interface to get a group reference from a struct
> device.
> 
> > 2. call vfio_group_get_external_user_from_dev() with the device pointer
> > to get vfio_group associated with this device and increments the container
> > user counter to prevent the VFIO group from disposal before KVM exits.
> > 3. When the external KVM finishes, it calls vfio_group_put_external_user()
> > to release the VFIO group.
> > 
> > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  drivers/vfio/vfio.c  | 37 +++++++++++++++++++++++++++++++++++++
> >  include/linux/vfio.h |  2 ++
> >  2 files changed, 39 insertions(+)
> > 
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index c8482624ca34..914bdf4b9d73 100644
> > --- a/drivers/vfio/vfio.c
> > +++ b/drivers/vfio/vfio.c
> > @@ -1720,6 +1720,43 @@ struct vfio_group *vfio_group_get_external_user(struct file *filep)
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_group_get_external_user);
> >  
> > +/**
> > + * External user API, exported by symbols to be linked dynamically.
> > + *
> > + * The protocol includes:
> > + * 1. External user add a device into a vfio group
> > + *
> > + * 2. The external user calls vfio_group_get_external_user_from_dev()
> > + * with the device pointer
> > + * to verify that:
> > + *	- there's a vfio group associated with it and is initialized;
> > + *	- IOMMU is set for the vfio group.
> > + * If both checks passed, vfio_group_get_external_user_from_dev()
> > + * increments the container user counter to prevent
> > + * the VFIO group from disposal before KVM exits.
> > + *
> > + * 3. When the external KVM finishes, it calls
> > + * vfio_group_put_external_user() to release the VFIO group.
> > + * This call decrements the container user counter.
> > + */
> 
> I don't think we need to duplicate this whole comment block for a
> _from_dev() version of the existing vfio_group_get_external_user().
> Please merge the comments.
ok. but I have a question: for an external user, as it already has group
fd, it can use vfio_group_get_external_user() directly, is there a
necessity for it to call vfio_group_get_external_user_from_dev() ?

If an external user wants to call this interface, it needs to first get
device fd, passes the device fd to kernel and kernel retrieves the pointer
to struct device, right?


> > +
> > +struct vfio_group *vfio_group_get_external_user_from_dev(struct device *dev)
> > +{
> > +	struct vfio_group *group;
> > +	int ret;
> > +
> > +	group = vfio_group_get_from_dev(dev);
> > +	if (!group)
> > +		return ERR_PTR(-ENODEV);
> > +
> > +	ret = vfio_group_add_container_user(group);
> > +	if (ret)
> > +		return ERR_PTR(ret);
> 
> Error path leaks group reference.
>
oops, sorry for that.

> > +
> > +	return group;
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_group_get_external_user_from_dev);
> > +
> >  void vfio_group_put_external_user(struct vfio_group *group)
> >  {
> >  	vfio_group_try_dissolve_container(group);
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index e42a711a2800..2e1fa0c7396f 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -94,6 +94,8 @@ extern void vfio_unregister_iommu_driver(
> >   */
> >  extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
> >  extern void vfio_group_put_external_user(struct vfio_group *group);
> > +extern
> > +struct vfio_group *vfio_group_get_external_user_from_dev(struct device *dev);
> 
> Slight cringe at this line wrap, personally would prefer to wrap the
> args as done repeatedly elsewhere in this file.  Thanks,
>
yeah, I tried to do in that way, but the name of this interface is too long,
as well as its return type, it passes 80 characters limit even with just one
arg...

is it better to wrap in below way?
extern struct vfio_group *vfio_group_get_external_user_from_dev(struct device
								*dev);

or just a shorter interface name?
extern struct vfio_group *vfio_group_get_user_from_dev(struct device *dev);

Thanks
Yan
> 
> >  extern bool vfio_external_group_match_file(struct vfio_group *group,
> >  					   struct file *filep);
> >  extern int vfio_external_user_iommu_id(struct vfio_group *group);
> 
