Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4D4D57044
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 20:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfFZSFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 14:05:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56782 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfFZSFx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 14:05:53 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9C87C8E224;
        Wed, 26 Jun 2019 18:05:53 +0000 (UTC)
Received: from x1.home (ovpn-117-35.phx2.redhat.com [10.3.117.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 512775D71B;
        Wed, 26 Jun 2019 18:05:52 +0000 (UTC)
Date:   Wed, 26 Jun 2019 12:05:51 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mdev: Send uevents around parent device registration
Message-ID: <20190626120551.788fa5ed@x1.home>
In-Reply-To: <1ea5c171-cd42-1c10-966e-1b82a27351d9@nvidia.com>
References: <156155924767.11505.11457229921502145577.stgit@gimli.home>
        <1ea5c171-cd42-1c10-966e-1b82a27351d9@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 26 Jun 2019 18:05:53 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 26 Jun 2019 23:23:00 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 6/26/2019 7:57 PM, Alex Williamson wrote:
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
> > +  
> 
> Its good to have udev event, but don't remove debug print from dmesg.
> Same for unregister.

Who consumes these?  They seem noisy.  Thanks,

Alex

> >  	return 0;
> >  
> >  add_dev_err:
> > @@ -220,6 +223,8 @@ EXPORT_SYMBOL(mdev_register_device);
> >  void mdev_unregister_device(struct device *dev)
> >  {
> >  	struct mdev_parent *parent;
> > +	char *env_string = "MDEV_STATE=unregistered";
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
> >  }
> >  EXPORT_SYMBOL(mdev_unregister_device);
> >  
> >   

