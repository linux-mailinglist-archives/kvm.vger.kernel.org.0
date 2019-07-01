Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 442365B65F
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 10:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbfGAIKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 04:10:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37372 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727138AbfGAIKW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 04:10:22 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7251C307D90F;
        Mon,  1 Jul 2019 08:10:21 +0000 (UTC)
Received: from gondolin (ovpn-117-220.ams2.redhat.com [10.36.117.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 808357D580;
        Mon,  1 Jul 2019 08:10:13 +0000 (UTC)
Date:   Mon, 1 Jul 2019 10:10:10 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mdev: Send uevents around parent device registration
Message-ID: <20190701101010.7df050a2.cohuck@redhat.com>
In-Reply-To: <107cbedf-6c66-a666-d26a-5842d8c24e83@nvidia.com>
References: <156155924767.11505.11457229921502145577.stgit@gimli.home>
        <1ea5c171-cd42-1c10-966e-1b82a27351d9@nvidia.com>
        <20190626120551.788fa5ed@x1.home>
        <a6c2ec9e-b949-4346-13bc-4d7f9c35ea8b@nvidia.com>
        <20190627102107.3c7715d9.cohuck@redhat.com>
        <107cbedf-6c66-a666-d26a-5842d8c24e83@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 01 Jul 2019 08:10:21 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Jun 2019 19:42:32 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 6/27/2019 1:51 PM, Cornelia Huck wrote:
> > On Thu, 27 Jun 2019 00:33:59 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
> >> On 6/26/2019 11:35 PM, Alex Williamson wrote:  
> >>> On Wed, 26 Jun 2019 23:23:00 +0530
> >>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >>>     
> >>>> On 6/26/2019 7:57 PM, Alex Williamson wrote:    
> >>>>> This allows udev to trigger rules when a parent device is registered
> >>>>> or unregistered from mdev.
> >>>>>
> >>>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> >>>>> ---
> >>>>>  drivers/vfio/mdev/mdev_core.c |   10 ++++++++--
> >>>>>  1 file changed, 8 insertions(+), 2 deletions(-)
> >>>>>
> >>>>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> >>>>> index ae23151442cb..ecec2a3b13cb 100644
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
> >>>>> @@ -196,7 +198,8 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
> >>>>>  	list_add(&parent->next, &parent_list);
> >>>>>  	mutex_unlock(&parent_list_lock);
> >>>>>  
> >>>>> -	dev_info(dev, "MDEV: Registered\n");
> >>>>> +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
> >>>>> +      
> >>>>
> >>>> Its good to have udev event, but don't remove debug print from dmesg.
> >>>> Same for unregister.    
> >>>
> >>> Who consumes these?  They seem noisy.  Thanks,
> >>>     
> >>
> >> I don't think its noisy, its more of logging purpose. This is seen in
> >> kernel log only when physical device is registered to mdev.  
> > 
> > Yes; but why do you want to log success? If you need to log it
> > somewhere, wouldn't a trace event be a much better choice?
> >   
> 
> Trace events are not always collected in production environment, there
> kernel log helps.

I'm with you for *errors*, but I'm not sure you should rely on
*success* messages, though. If you want to be able to figure out the
sequence of registering etc. in all cases, I think it makes more sense
to invest in an infrastructure like tracing and make sure that is it
turned on for any system that matters.
