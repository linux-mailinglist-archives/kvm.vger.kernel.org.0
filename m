Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A09318D9E5
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 21:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgCTU7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 16:59:44 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:35550 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726738AbgCTU7o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 16:59:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584737983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VGrhaAgQuGc4nR5mDjGTeAxa5W8ePSIqBYL4zLw6fxw=;
        b=NQHdd1Ufrd2XZ4jmcrfUNFilIKq+IDUOkmCN8S/o4ASL8sj52NY/2z7yBsa6hCLJULd4We
        alYLcBr/Z3S0WuVKkKZi0L2aumoCNkEqmAjl4/Wozl7qV+N7u4+sA9ibAaoU26t7xGr1d/
        Y91YHbkrZJnQeJQEnzdDXuR4MV9B0sQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-H-tmYnP7P422El7JWjAGDQ-1; Fri, 20 Mar 2020 16:59:37 -0400
X-MC-Unique: H-tmYnP7P422El7JWjAGDQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EF2A107ACC4;
        Fri, 20 Mar 2020 20:59:36 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1B5D17B91;
        Fri, 20 Mar 2020 20:59:35 +0000 (UTC)
Date:   Fri, 20 Mar 2020 14:59:35 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yonghyun Hwang <yonghyun@google.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Havard Skinnemoen <hskinnemoen@google.com>,
        Moritz Fischer <mdf@kernel.org>,
        Joshua Lang <joshualang@google.com>
Subject: Re: [PATCH] vfio-mdev: support mediated device creation in kernel
Message-ID: <20200320145935.4617c7c0@w520.home>
In-Reply-To: <CAEauFbx1Su7Lg5kdxXnvUwfwLCH67qaGB6EZ7g3OOH-tbRfBBA@mail.gmail.com>
References: <20200320175910.180266-1-yonghyun@google.com>
        <20200320123425.49c6568e@w520.home>
        <CAEauFbx1Su7Lg5kdxXnvUwfwLCH67qaGB6EZ7g3OOH-tbRfBBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Mar 2020 13:46:04 -0700
Yonghyun Hwang <yonghyun@google.com> wrote:

> On Fri, Mar 20, 2020 at 11:34 AM Alex Williamson
> <alex.williamson@redhat.com> wrote:
> >
> > On Fri, 20 Mar 2020 10:59:10 -0700
> > Yonghyun Hwang <yonghyun@google.com> wrote:
> >  
> > > To enable a mediated device, a device driver registers its device to VFIO
> > > MDev framework. Once the mediated device gets enabled, UUID gets fed onto
> > > the sysfs attribute, "create", to create the mediated device. This
> > > additional step happens after boot-up gets complete. If the driver knows
> > > how many mediated devices need to be created during probing time, the
> > > additional step becomes cumbersome. This commit implements a new function
> > > to allow the driver to create a mediated device in kernel.  
> >
> > But pre-creating mdev devices seems like a policy decision.  Why can't
> > userspace make such a policy decision, and do so with persistent uuids,
> > via something like mdevctl?  Thanks,
> >
> > Alex  
> 
> Yep, it can be viewed as the policy decision and userspace can make
> the decision. However, it would be handy and plausible, if a device
> driver can pre-create "fixed or default" # of mdev devices, while
> allowing the device policy to come into play after bootup gets
> complete. Without this patch, a device driver should release the
> policy and the policy should be aligned with the driver, which would
> be cumbersome (sometimes painful) in a cloud environment. My use case
> with mdev is to enable a subset of vfio-pci features without losing my
> device driver.

Does this last comment suggest the parent device is not being
multiplexed through mdev, but only mediated?  If so, would something
like Yan's vendor-ops approach[1] be better?  Without a multiplexed
device, the lifecycle management of an mdev device doesn't make a lot
of sense, and I wonder if that's what you're trying to bypass here.
Even SR-IOV devices have moved to userspace enablement with most module
options to enable a default number of VFs being deprecated.  I do see
that that transition left a gap, but I'm not sure that heading in the
opposite direction with mdevs is a good idea either.  Thanks,

Alex

[1]https://lore.kernel.org/kvm/20200131020803.27519-1-yan.y.zhao@intel.com/


> > > Signed-off-by: Yonghyun Hwang <yonghyun@google.com>
> > > ---
> > >  drivers/vfio/mdev/mdev_core.c | 45 +++++++++++++++++++++++++++++++++++
> > >  include/linux/mdev.h          |  3 +++
> > >  2 files changed, 48 insertions(+)
> > >
> > > diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> > > index b558d4cfd082..a6d32516de42 100644
> > > --- a/drivers/vfio/mdev/mdev_core.c
> > > +++ b/drivers/vfio/mdev/mdev_core.c
> > > @@ -350,6 +350,51 @@ int mdev_device_create(struct kobject *kobj,
> > >       return ret;
> > >  }
> > >
> > > +/*
> > > + * mdev_create_device : Create a mdev device
> > > + * @dev: device structure representing parent device.
> > > + * @uuid: uuid char string for a mdev device.
> > > + * @group: index to supported type groups for a mdev device.
> > > + *
> > > + * Create a mdev device in kernel.
> > > + * Returns a negative value on error, otherwise 0.
> > > + */
> > > +int mdev_create_device(struct device *dev,
> > > +                     const char *uuid, int group)
> > > +{
> > > +     struct mdev_parent *parent = NULL;
> > > +     struct mdev_type *type = NULL;
> > > +     guid_t guid;
> > > +     int i = 1;
> > > +     int ret;
> > > +
> > > +     ret = guid_parse(uuid, &guid);
> > > +     if (ret) {
> > > +             dev_err(dev, "Failed to parse UUID");
> > > +             return ret;
> > > +     }
> > > +
> > > +     parent = __find_parent_device(dev);
> > > +     if (!parent) {
> > > +             dev_err(dev, "Failed to find parent mdev device");
> > > +             return -ENODEV;
> > > +     }
> > > +
> > > +     list_for_each_entry(type, &parent->type_list, next) {
> > > +             if (i == group)
> > > +                     break;
> > > +             i++;
> > > +     }
> > > +
> > > +     if (!type || i != group) {
> > > +             dev_err(dev, "Failed to find mdev device");
> > > +             return -ENODEV;
> > > +     }
> > > +
> > > +     return mdev_device_create(&type->kobj, parent->dev, &guid);
> > > +}
> > > +EXPORT_SYMBOL(mdev_create_device);
> > > +
> > >  int mdev_device_remove(struct device *dev)
> > >  {
> > >       struct mdev_device *mdev, *tmp;
> > > diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> > > index 0ce30ca78db0..b66f67998916 100644
> > > --- a/include/linux/mdev.h
> > > +++ b/include/linux/mdev.h
> > > @@ -145,4 +145,7 @@ struct device *mdev_parent_dev(struct mdev_device *mdev);
> > >  struct device *mdev_dev(struct mdev_device *mdev);
> > >  struct mdev_device *mdev_from_dev(struct device *dev);
> > >
> > > +extern int mdev_create_device(struct device *dev,
> > > +                     const char *uuid, int group_idx);
> > > +
> > >  #endif /* MDEV_H */  
> >  
> 

