Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93DA39F777
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 15:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbhFHNSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 09:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232808AbhFHNSq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 09:18:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1042F60FDB;
        Tue,  8 Jun 2021 13:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623158213;
        bh=l68J0PufBQc9VTWkss0coi7Fyyq+m8BOlrtncQ13wbk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lJLL1DbEJuaLQX0qsyYahVLEQCuaW9l2fWZLM3Lqhl2jiyEOneQif+zTWr2Nm8Sru
         n52HH2d04yha7Rc/ryx/HVvi5ayhN+ZJdg4BV39SOsqMDdRNnZKj1TSVJOPdkJn/wr
         GVZn0Zz+wb/Lk1njWtQSj6QGHuSdQ9TNSmeHUsIU=
Date:   Tue, 8 Jun 2021 15:16:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 03/10] driver core: Flow the return code from ->probe()
 through to sysfs bind
Message-ID: <YL9twy33JvsaeWt7@kroah.com>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <3-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <YL8SdymSgn9HHRcw@kroah.com>
 <20210608123023.GA1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608123023.GA1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 09:30:23AM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 08, 2021 at 08:47:19AM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Jun 07, 2021 at 09:55:45PM -0300, Jason Gunthorpe wrote:
> > > Currently really_probe() returns 1 on success and 0 if the probe() call
> > > fails. This return code arrangement is designed to be useful for
> > > __device_attach_driver() which is walking the device list and trying every
> > > driver. 0 means to keep trying.
> > > 
> > > However, it is not useful for the other places that call through to
> > > really_probe() that do actually want to see the probe() return code.
> > > 
> > > For instance bind_store() would be better to return the actual error code
> > > from the driver's probe method, not discarding it and returning -ENODEV.
> > 
> > Why does that matter?  Why does it need to know this?
> 
> Proper return code to userspace are important. Knowing why the driver
> probe() fails is certainly helpful for debugging. Is there are reason
> to hide them? I think this is an improvement for sysfs bind.
> 
> Why this series needs it is because mdev has fixed sys uAPI at this point
> that requires carring the return code from device driver probe() to
> a mdev sysfs function.

What is mdev and what userspace tool requires such a userspace api to
depend on this?

Tools doing manual bind/unbind from userspace are crazy, it's always
been a "look at this neat hack!" type of thing.  To do it "right" you
should always do it correctly within the kernel.

> > > +enum {
> > > +	/* Set on output if the -ERR has come from a probe() function */
> > > +	PROBEF_DRV_FAILED = 1 << 0,
> > > +};
> > > +
> > > +static int really_probe(struct device *dev, struct device_driver *drv,
> > > +			unsigned int *flags)
> > 
> > Ugh, no, please no functions with random "flags" in them, that way lies
> > madness and unmaintainable code for decades to come.
> 
> The alternative to this something like this:
> 
> static int really_probe(struct device *dev, struct device_driver *drv,
> 			int *probe_err)
> 
> And since we still need the 'do not probe defer' in next patches then
> it would have to be this:
> 
> static int really_probe(struct device *dev, struct device_driver *drv,
> 			int *probe_err, bool allow_probe_defer)
> 
> And the two new arguments flowed up through several function call
> sites.
> 
> Do you prefer one of these more?

Random boolean flags as parameters are just as bad.

Make the functions able to be understood when read.

> For your other question PROBEF_ means 'probe flag'.

That was not obvious at all, and not something I would remember the next
time I have to look at this code...

Please use full words, we don't have a limit on restricted characters
anymore, this isn't the 1980's...

thanks,

greg k-h
