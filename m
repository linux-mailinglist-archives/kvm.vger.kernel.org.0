Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8B2687451
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 05:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjBBEPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 23:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjBBEPq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 23:15:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6EF79CB7
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 20:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675311297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IkSvZazpJaCzeN4iB/UP5EFUCE7zPAFjyxOF4y5Wi/o=;
        b=NQ45OAVMr57aODnY5ddwUgV3+/cOg9ofXseCiNPRWRDstYa/aqE/vGiLeTip+7qYS+lId+
        FI9FORPJ+oUsFavoCw6JbE5A+1mjZLJpKu7n/t/TAsAu4kGSwyW/2R+cWDhrXkTroWpLf4
        3NUZxFQqkcCc+3YUBw8r3G3MiOPSdWc=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-581-u-9kuC-1Pn6jIGMrctZzvQ-1; Wed, 01 Feb 2023 23:14:55 -0500
X-MC-Unique: u-9kuC-1Pn6jIGMrctZzvQ-1
Received: by mail-io1-f69.google.com with SMTP id d8-20020a6b6e08000000b00722d8d9c432so481650ioh.19
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 20:14:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IkSvZazpJaCzeN4iB/UP5EFUCE7zPAFjyxOF4y5Wi/o=;
        b=Uv5iot0yx3rGEZReDpnyw68lIGtwgNFXLyRedcLC3iUsf47EZeS5XPqc9A585dJC1r
         +wcb98dlLQZDkI8mBVS+w0fsReKHis7iPDzC5zusgmKCg2bHUvAx2n425HBcq6NxJM1m
         53BO6bRjxbrKneb94Ov2GPHHOttIQ712RtevDmG+8nErj1547qL3au++0oc/2m20pQ8+
         9K5+Qihhxa5EH/A7RGLigsx7CLCgR4MZJn+3R0MqX2VnFQx8+tF1w0Y1fCA1MmKtjENt
         BWoKf2lTw4mrqKzBHFAbqdwX2Kx9q7xiQpuaHl0dUG3gCnqQ+8KXrqWG0HinycbFjgj4
         QKcA==
X-Gm-Message-State: AO0yUKW5jZHvK3/Tm+37iEMEKyvz3dbdzvj5NY4+WbbHsQvuODC228ya
        Zls0Bh4aL/ERnkpj3OsmxkZbvmyrZK/Om807Z/FAEuiJH7tOXez49FGSBV3nWEr4176yCjiWgdv
        OO16pYsKQlFuq
X-Received: by 2002:a05:6e02:b45:b0:310:aa02:4903 with SMTP id f5-20020a056e020b4500b00310aa024903mr4159256ilu.29.1675311294851;
        Wed, 01 Feb 2023 20:14:54 -0800 (PST)
X-Google-Smtp-Source: AK7set/RdjucV7vuU7onJfFNgb3o6687/AcURZBDpW/6jJHQ1GTN8KVhF58TgmLZvlpQ2kLQeel/yg==
X-Received: by 2002:a05:6e02:b45:b0:310:aa02:4903 with SMTP id f5-20020a056e020b4500b00310aa024903mr4159233ilu.29.1675311294543;
        Wed, 01 Feb 2023 20:14:54 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id t2-20020a02c902000000b003a650adf5b0sm7205298jao.95.2023.02.01.20.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 20:14:53 -0800 (PST)
Date:   Wed, 1 Feb 2023 21:14:52 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] vfio: fix deadlock between group lock and kvm lock
Message-ID: <20230201211452.429c8e34.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB75298437F96D08758DB92368C3D69@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230201192010.42748-1-mjrosato@linux.ibm.com>
        <20230201162730.685b5332.alex.williamson@redhat.com>
        <DS0PR11MB75298437F96D08758DB92368C3D69@DS0PR11MB7529.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2 Feb 2023 03:46:59 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, February 2, 2023 7:28 AM
> > 
> > On Wed,  1 Feb 2023 14:20:10 -0500
> > Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> >   
> > > After 51cdc8bc120e, we have another deadlock scenario between the
> > > kvm->lock and the vfio group_lock with two different codepaths acquiring
> > > the locks in different order.  Specifically in vfio_open_device, vfio
> > > holds the vfio group_lock when issuing device->ops->open_device but  
> > some  
> > > drivers (like vfio-ap) need to acquire kvm->lock during their open_device
> > > routine;  Meanwhile, kvm_vfio_release will acquire the kvm->lock first
> > > before calling vfio_file_set_kvm which will acquire the vfio group_lock.
> > >
> > > To resolve this, let's remove the need for the vfio group_lock from the
> > > kvm_vfio_release codepath.  This is done by introducing a new spinlock to
> > > protect modifications to the vfio group kvm pointer, and acquiring a kvm
> > > ref from within vfio while holding this spinlock, with the reference held
> > > until the last close for the device in question.
> > >
> > > Fixes: 51cdc8bc120e ("kvm/vfio: Fix potential deadlock on vfio group_lock")
> > > Reported-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> > > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > ---
> > > Changes from v1:
> > > * use spin_lock instead of spin_lock_irqsave (Jason)
> > > * clear device->kvm_put as part of vfio_kvm_put_kvm (Yi)
> > > * Re-arrange code to avoid referencing the group contents from within
> > >   vfio_main (Kevin) which meant moving most of the code in this patch
> > >   to group.c along with getting/dropping of the dev_set lock
> > > ---
> > >  drivers/vfio/group.c     | 90  
> > +++++++++++++++++++++++++++++++++++++---  
> > >  drivers/vfio/vfio.h      |  1 +
> > >  drivers/vfio/vfio_main.c | 11 ++---
> > >  include/linux/vfio.h     |  2 +-
> > >  4 files changed, 91 insertions(+), 13 deletions(-)
> > >
> > > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > > index bb24b2f0271e..52f434861294 100644
> > > --- a/drivers/vfio/group.c
> > > +++ b/drivers/vfio/group.c
> > > @@ -13,6 +13,9 @@
> > >  #include <linux/vfio.h>
> > >  #include <linux/iommufd.h>
> > >  #include <linux/anon_inodes.h>
> > > +#ifdef CONFIG_HAVE_KVM
> > > +#include <linux/kvm_host.h>
> > > +#endif
> > >  #include "vfio.h"
> > >
> > >  static struct vfio {
> > > @@ -154,6 +157,55 @@ static int vfio_group_ioctl_set_container(struct  
> > vfio_group *group,  
> > >  	return ret;
> > >  }
> > >
> > > +#ifdef CONFIG_HAVE_KVM
> > > +static bool vfio_kvm_get_kvm_safe(struct vfio_device *device, struct  
> > kvm *kvm)
> > 
> > I'm tempted to name these vfio_device_get_kvm_safe() and only pass the
> > vfio_device, where of course we can get the kvm pointer from the group
> > internally.
> >   
> > > +{
> > > +	void (*pfn)(struct kvm *kvm);
> > > +	bool (*fn)(struct kvm *kvm);
> > > +	bool ret;
> > > +  
> > 
> > We should assert_lockdep_held(&device->dev_set->lock) in both of these
> > since that seems to be what's protecting device->kvm and
> > device->put_kvm.
> > 
> > If we change as above to get the kvm pointer from the group within this
> > function, we can also move the kvm_ref_lock here, which seems to
> > simplify the caller quite a bit.
> >   
> > > +	pfn = symbol_get(kvm_put_kvm);
> > > +	if (WARN_ON(!pfn))
> > > +		return false;
> > > +
> > > +	fn = symbol_get(kvm_get_kvm_safe);
> > > +	if (WARN_ON(!fn)) {
> > > +		symbol_put(kvm_put_kvm);
> > > +		return false;
> > > +	}
> > > +
> > > +	ret = fn(kvm);
> > > +	if (ret)
> > > +		device->put_kvm = pfn;
> > > +	else
> > > +		symbol_put(kvm_put_kvm);
> > > +
> > > +	symbol_put(kvm_get_kvm_safe);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static void vfio_kvm_put_kvm(struct vfio_device *device)
> > > +{
> > > +	if (WARN_ON(!device->kvm || !device->put_kvm))
> > > +		return;  
> > 
> > It simplifies the caller if we can use this even in the !device->kvm
> > case.
> >   
> > > +
> > > +	device->put_kvm(device->kvm);
> > > +	device->put_kvm = NULL;
> > > +	symbol_put(kvm_put_kvm);
> > > +}
> > > +
> > > +#else
> > > +static bool vfio_kvm_get_kvm_safe(struct vfio_device *device, struct  
> > kvm *kvm)  
> > > +{
> > > +	return false;
> > > +}
> > > +
> > > +static void vfio_kvm_put_kvm(struct vfio_device *device)
> > > +{
> > > +}
> > > +#endif
> > > +
> > >  static int vfio_device_group_open(struct vfio_device *device)
> > >  {
> > >  	int ret;
> > > @@ -164,14 +216,32 @@ static int vfio_device_group_open(struct  
> > vfio_device *device)  
> > >  		goto out_unlock;
> > >  	}
> > >
> > > +	mutex_lock(&device->dev_set->lock);
> > > +
> > >  	/*
> > > -	 * Here we pass the KVM pointer with the group under the lock.  If  
> > the  
> > > -	 * device driver will use it, it must obtain a reference and release it
> > > -	 * during close_device.
> > > +	 * Before the first device open, get the KVM pointer currently
> > > +	 * associated with the group (if there is one) and obtain a reference
> > > +	 * now that will be held until the open_count reaches 0 again.  Save
> > > +	 * the pointer in the device for use by drivers.
> > >  	 */
> > > +	if (device->open_count == 0) {
> > > +		spin_lock(&device->group->kvm_ref_lock);
> > > +		if (device->group->kvm &&
> > > +		    vfio_kvm_get_kvm_safe(device, device->group->kvm))
> > > +			device->kvm = device->group->kvm;
> > > +		spin_unlock(&device->group->kvm_ref_lock);
> > > +	}
> > > +
> > >  	ret = vfio_device_open(device, device->group->iommufd,
> > >  			       device->group->kvm);  
> > 
> > We're using device->group->kvm outside of kvm_ref_lock here, it should
> > be using device->kvm.  
> 
> Existing code set device->kvm in the vfio_device_first_open() which is
> called by vfio_device_open(). After above change, seems not necessary
> to pass kvm pointer into the call chain. Isn't it?

Yes, we can get it from the device.  I didn't check how much this
bloats the patch though.  As a fix, it might make sense to save that
refactoring for a follow-on patch.  Thanks,

Alex

