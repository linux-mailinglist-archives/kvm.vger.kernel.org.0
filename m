Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5025A010
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 17:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfF1P4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 11:56:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38296 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbfF1P4J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 11:56:09 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7E08359473;
        Fri, 28 Jun 2019 15:56:09 +0000 (UTC)
Received: from x1.home (ovpn-117-35.phx2.redhat.com [10.3.117.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16E9326E64;
        Fri, 28 Jun 2019 15:56:09 +0000 (UTC)
Date:   Fri, 28 Jun 2019 09:56:08 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kwankhede@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mdev: Send uevents around parent device registration
Message-ID: <20190628095608.7762d6d0@x1.home>
In-Reply-To: <20190627101914.32829440.cohuck@redhat.com>
References: <156155924767.11505.11457229921502145577.stgit@gimli.home>
        <20190627101914.32829440.cohuck@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 28 Jun 2019 15:56:09 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Jun 2019 10:19:14 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Wed, 26 Jun 2019 08:27:58 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > This allows udev to trigger rules when a parent device is registered
> > or unregistered from mdev.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/vfio/mdev/mdev_core.c |   10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> > index ae23151442cb..ecec2a3b13cb 100644
> > --- a/drivers/vfio/mdev/mdev_core.c
> > +++ b/drivers/vfio/mdev/mdev_core.c
> > @@ -146,6 +146,8 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
> >  {
> >  	int ret;
> >  	struct mdev_parent *parent;
> > +	char *env_string = "MDEV_STATE=registered";  
> 
> This string is probably reasonable enough.
> 
> > +	char *envp[] = { env_string, NULL };
> >  
> >  	/* check for mandatory ops */
> >  	if (!ops || !ops->create || !ops->remove || !ops->supported_type_groups)
> > @@ -196,7 +198,8 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
> >  	list_add(&parent->next, &parent_list);
> >  	mutex_unlock(&parent_list_lock);
> >  
> > -	dev_info(dev, "MDEV: Registered\n");
> > +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);  
> 
> I also agree with the positioning here.
> 
> > +
> >  	return 0;
> >  
> >  add_dev_err:
> > @@ -220,6 +223,8 @@ EXPORT_SYMBOL(mdev_register_device);
> >  void mdev_unregister_device(struct device *dev)
> >  {
> >  	struct mdev_parent *parent;
> > +	char *env_string = "MDEV_STATE=unregistered";  
> 
> Ok.
> 
> > +	char *envp[] = { env_string, NULL };
> >  
> >  	mutex_lock(&parent_list_lock);
> >  	parent = __find_parent_device(dev);
> > @@ -228,7 +233,6 @@ void mdev_unregister_device(struct device *dev)
> >  		mutex_unlock(&parent_list_lock);
> >  		return;
> >  	}
> > -	dev_info(dev, "MDEV: Unregistering\n");
> >  
> >  	list_del(&parent->next);
> >  	mutex_unlock(&parent_list_lock);
> > @@ -243,6 +247,8 @@ void mdev_unregister_device(struct device *dev)
> >  	up_write(&parent->unreg_sem);
> >  
> >  	mdev_put_parent(parent);
> > +
> > +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);  
> 
> I'm wondering whether we should indicate this uevent earlier: Once we
> have detached from the parent list, we're basically done for all
> practical purposes. So maybe move this right before we grab the
> unreg_sem?

That would make it a "this thing is about to go away" (ie.
"unregistering") rather than "this thing is gone" ("unregistered").  I
was aiming for the latter as the former just seems like it might make
userspace race to remove devices.  Note that I don't actually make use
of this event in mdevctl currently, so we could maybe save it for
later, but the symmetry seemed preferable.  Thanks,

Alex
