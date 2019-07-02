Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D94A85C8E7
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 07:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbfGBFmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 01:42:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40888 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfGBFmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 01:42:02 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 26186308429B;
        Tue,  2 Jul 2019 05:42:02 +0000 (UTC)
Received: from x1.home (ovpn-116-83.phx2.redhat.com [10.3.116.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C431160BF3;
        Tue,  2 Jul 2019 05:42:01 +0000 (UTC)
Date:   Mon, 1 Jul 2019 23:42:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mdev: Send uevents around parent device registration
Message-ID: <20190701234201.47b6f23a@x1.home>
In-Reply-To: <14783c81-0236-2f25-6193-c06aa83392c9@nvidia.com>
References: <156199271955.1646.13321360197612813634.stgit@gimli.home>
        <08597ab4-cc37-3973-8927-f1bc430f6185@nvidia.com>
        <20190701112442.176a8407@x1.home>
        <3b338e73-7929-df20-ca2b-3223ba4ead39@nvidia.com>
        <20190701140436.45eabf07@x1.home>
        <14783c81-0236-2f25-6193-c06aa83392c9@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 02 Jul 2019 05:42:02 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2 Jul 2019 10:25:04 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 7/2/2019 1:34 AM, Alex Williamson wrote:
> > On Mon, 1 Jul 2019 23:20:35 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
> >> On 7/1/2019 10:54 PM, Alex Williamson wrote:  
> >>> On Mon, 1 Jul 2019 22:43:10 +0530
> >>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >>>     
> >>>> On 7/1/2019 8:24 PM, Alex Williamson wrote:    
> >>>>> This allows udev to trigger rules when a parent device is registered
> >>>>> or unregistered from mdev.
> >>>>>
> >>>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> >>>>> ---
> >>>>>
> >>>>> v2: Don't remove the dev_info(), Kirti requested they stay and
> >>>>>     removing them is only tangential to the goal of this change.
> >>>>>       
> >>>>
> >>>> Thanks.
> >>>>
> >>>>    
> >>>>>  drivers/vfio/mdev/mdev_core.c |    8 ++++++++
> >>>>>  1 file changed, 8 insertions(+)
> >>>>>
> >>>>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> >>>>> index ae23151442cb..7fb268136c62 100644
> >>>>> --- a/drivers/vfio/mdev/mdev_core.c
> >>>>> +++ b/drivers/vfio/mdev/mdev_core.c
> >>>>> @@ -146,6 +146,8 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
> >>>>>  {
> >>>>>  	int ret;
> >>>>>  	struct mdev_parent *parent;
> >>>>> +	char *env_string = "MDEV_STATE=registered";
> >>>>> +	char *envp[] = { env_string, NULL };
> >>>>>  
> >>>>>  	/* check for mandatory ops */
> >>>>>  	if (!ops || !ops->create || !ops->remove || !ops->supported_type_groups)
> >>>>> @@ -197,6 +199,8 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
> >>>>>  	mutex_unlock(&parent_list_lock);
> >>>>>  
> >>>>>  	dev_info(dev, "MDEV: Registered\n");
> >>>>> +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
> >>>>> +
> >>>>>  	return 0;
> >>>>>  
> >>>>>  add_dev_err:
> >>>>> @@ -220,6 +224,8 @@ EXPORT_SYMBOL(mdev_register_device);
> >>>>>  void mdev_unregister_device(struct device *dev)
> >>>>>  {
> >>>>>  	struct mdev_parent *parent;
> >>>>> +	char *env_string = "MDEV_STATE=unregistered";
> >>>>> +	char *envp[] = { env_string, NULL };
> >>>>>  
> >>>>>  	mutex_lock(&parent_list_lock);
> >>>>>  	parent = __find_parent_device(dev);
> >>>>> @@ -243,6 +249,8 @@ void mdev_unregister_device(struct device *dev)
> >>>>>  	up_write(&parent->unreg_sem);
> >>>>>  
> >>>>>  	mdev_put_parent(parent);
> >>>>> +
> >>>>> +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);      
> >>>>
> >>>> mdev_put_parent() calls put_device(dev). If this is the last instance
> >>>> holding device, then on put_device(dev) dev would get freed.
> >>>>
> >>>> This event should be before mdev_put_parent()    
> >>>
> >>> So you're suggesting the vendor driver is calling
> >>> mdev_unregister_device() without a reference to the struct device that
> >>> it's passing to unregister?  Sounds bogus to me.  We take a
> >>> reference to the device so that it can't disappear out from under us,
> >>> the caller cannot rely on our reference and the caller provided the
> >>> struct device.  Thanks,
> >>>     
> >>
> >> 1. Register uevent is sent after mdev holding reference to device, then
> >> ideally, unregister path should be mirror of register path, send uevent
> >> and then release the reference to device.  
> > 
> > I don't see the relevance here.  We're marking an event, not unwinding
> > state of the device from the registration process.  Additionally, the
> > event we're trying to mark is the completion of each process, so the
> > notion that we need to mirror the ordering between the two is invalid.
> >   
> >> 2. I agree that vendor driver shouldn't call mdev_unregister_device()
> >> without holding reference to device. But to be on safer side, if ever
> >> such case occur, to avoid any segmentation fault in kernel, better to
> >> send event before mdev release the reference to device.  
> > 
> > I know that get_device() and put_device() are GPL symbols and that's a
> > bit of an issue, but I don't think we should be kludging the code for a
> > vendor driver that might have problems with that.  A) we're using the
> > caller provided device  for the uevent, B) we're only releasing our own
> > reference to the device that was acquired during registration, the
> > vendor driver must have other references,  
> 
> Are you going to assume that someone/vendor driver is always going to do
> right thing?

mdev is a kernel driver, we make reasonable assumptions that other
drivers interact with it correctly.

> > C) the parent device
> > generally lives on a bus, with a vendor driver, there's an entire
> > ecosystem of references to the device below mdev.  Is this a paranoia
> > request or are you really concerned that your PCI device suddenly
> > disappears when mdev's reference to it disappears.   
> 
> mdev infrastructure is not always used by PCI devices. It is designed to
> be generic, so that other devices (other than PCI devices) can also use
> this framework.

Obviously mdev is not PCI specific, I only mention it because I'm
asking if you have a specific concern in mind.  If you did, I'd assume
it's related to a PCI backed vGPU.  Any physical parent device of an
mdev is likely to have some sort of bus infrastructure behind it
holding references to the device (ie. a probe and release where an
implicit reference is held between these points).  A virtual device
would be similar, it's created as part of a module init and destroyed
as part of a module exit, where mdev registration would exist between
these points.

> If there is a assumption that user of mdev framework or vendor drivers
> are always going to use mdev in right way, then there is no need for
> mdev core to held reference of the device?
> This is not a "paranoia request". This is more of a ideal scenario, mdev
> should use device by holding its reference rather than assuming (or
> relying on) someone else holding the reference of device.

In fact, at one point Parav was proposing removing these references
entirely, but Connie and I both felt uncomfortable about that.  I think
it's good practice that mdev indicates the use of the parent device by
incrementing the reference count, with each child mdev device also
taking a reference, but those references balance out within the mdev
core.  Their purpose is not to maintain the device for outside callers,
nor should outside callers assume mdev's use of references to release
their own.  I don't think it's unreasonable to assume that the caller
should have a legitimate reference to the object it's providing to this
function and therefore we should be able to use it after mdev's
internal references are balanced out.  Thanks,

Alex
