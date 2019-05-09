Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D14F918798
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 11:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfEIJSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 05:18:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37742 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbfEIJSX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 05:18:23 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3779FC05E76E;
        Thu,  9 May 2019 09:18:23 +0000 (UTC)
Received: from gondolin (dhcp-192-213.str.redhat.com [10.33.192.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C24049084;
        Thu,  9 May 2019 09:18:19 +0000 (UTC)
Date:   Thu, 9 May 2019 11:18:17 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: Re: [PATCHv2 09/10] vfio/mdev: Avoid creating sysfs remove file on
 stale device removal
Message-ID: <20190509111817.36ff1791.cohuck@redhat.com>
In-Reply-To: <VI1PR0501MB2271E76A8B5E8D00AFEA8D97D1320@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190430224937.57156-1-parav@mellanox.com>
        <20190430224937.57156-10-parav@mellanox.com>
        <20190508191635.05a0f277.cohuck@redhat.com>
        <VI1PR0501MB2271E76A8B5E8D00AFEA8D97D1320@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 09 May 2019 09:18:23 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 May 2019 22:13:28 +0000
Parav Pandit <parav@mellanox.com> wrote:

> > -----Original Message-----
> > From: Cornelia Huck <cohuck@redhat.com>
> > Sent: Wednesday, May 8, 2019 12:17 PM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > kwankhede@nvidia.com; alex.williamson@redhat.com; cjia@nvidia.com
> > Subject: Re: [PATCHv2 09/10] vfio/mdev: Avoid creating sysfs remove file on
> > stale device removal
> > 
> > On Tue, 30 Apr 2019 17:49:36 -0500
> > Parav Pandit <parav@mellanox.com> wrote:
> >   
> > > If device is removal is initiated by two threads as below, mdev core
> > > attempts to create a syfs remove file on stale device.
> > > During this flow, below [1] call trace is observed.
> > >
> > >      cpu-0                                    cpu-1
> > >      -----                                    -----
> > >   mdev_unregister_device()
> > >     device_for_each_child
> > >        mdev_device_remove_cb
> > >           mdev_device_remove
> > >                                        user_syscall
> > >                                          remove_store()
> > >                                            mdev_device_remove()
> > >                                         [..]
> > >    unregister device();
> > >                                        /* not found in list or
> > >                                         * active=false.
> > >                                         */
> > >                                           sysfs_create_file()
> > >                                           ..Call trace
> > >
> > > Now that mdev core follows correct device removal system of the linux
> > > bus model, remove shouldn't fail in normal cases. If it fails, there
> > > is no point of creating a stale file or checking for specific error status.  
> > 
> > Which error cases are left? Is there anything that does not indicate that
> > something got terribly messed up internally?
> >   
> Few reasons I can think of that can fail remove are:
> 
> 1. Some device removal requires allocating memory too as it needs to issue commands to device.
> If on the path, such allocation fails, remove can fail. However such fail to allocate memory will probably result into more serious warnings before this.

Nod. If we're OOM, we probably have some bigger problems anyway.

> 2. if the device firmware has crashed, device removal commands will likely timeout and return such error upto user.

In that case, I'd consider the device pretty much unusable in any case.

> 3. If user tries to remove a device, while parent is already in removal path, this call will eventually fail as it won't find the device in the internal list.

This should be benign, I think.

> 
> > >
> > > kernel: WARNING: CPU: 2 PID: 9348 at fs/sysfs/file.c:327
> > > sysfs_create_file_ns+0x7f/0x90
> > > kernel: CPU: 2 PID: 9348 Comm: bash Kdump: loaded Not tainted
> > > 5.1.0-rc6-vdevbus+ #6
> > > kernel: Hardware name: Supermicro SYS-6028U-TR4+/X10DRU-i+, BIOS 2.0b
> > > 08/09/2016
> > > kernel: RIP: 0010:sysfs_create_file_ns+0x7f/0x90
> > > kernel: Call Trace:
> > > kernel: remove_store+0xdc/0x100 [mdev]
> > > kernel: kernfs_fop_write+0x113/0x1a0
> > > kernel: vfs_write+0xad/0x1b0
> > > kernel: ksys_write+0x5a/0xe0
> > > kernel: do_syscall_64+0x5a/0x210
> > > kernel: entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > >
> > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > ---
> > >  drivers/vfio/mdev/mdev_sysfs.c | 4 +---
> > >  1 file changed, 1 insertion(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/vfio/mdev/mdev_sysfs.c
> > > b/drivers/vfio/mdev/mdev_sysfs.c index 9f774b91d275..ffa3dcebf201
> > > 100644
> > > --- a/drivers/vfio/mdev/mdev_sysfs.c
> > > +++ b/drivers/vfio/mdev/mdev_sysfs.c
> > > @@ -237,10 +237,8 @@ static ssize_t remove_store(struct device *dev,  
> > struct device_attribute *attr,  
> > >  		int ret;
> > >
> > >  		ret = mdev_device_remove(dev);
> > > -		if (ret) {
> > > -			device_create_file(dev, attr);
> > > +		if (ret)  
> > 
> > Should you merge this into the previous patch?
> >   
> I am not sure. Previous patch changes the sequence. I think that deserved an own patch by itself.
> This change is making use of that sequence.
> So its easier to review? Alex had comment in v0 to split into more logical patches, so...
> Specially to capture a different call trace, I cut into different patch.
> Otherwise previous patch's commit message is too long.

I'm not sure if splitting out this one is worth it... your call.

> 
> > >  			return ret;
> > > -		}
> > >  	}
> > >
> > >  	return count;  
> 

