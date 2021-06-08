Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5AB39F768
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 15:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbhFHNPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 09:15:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232625AbhFHNPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 09:15:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A60AB61249;
        Tue,  8 Jun 2021 13:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623158020;
        bh=Q1K87xelNrhFK5jO2xo0WjpIaQqlwCW307oA70m7ijw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EuhjcIqeMo2l4ceIfoRh2X/6+h2bh7NvPSg8clibhXcEr5I36TeL8PzxYXK5uaif7
         41q+AsQKTl6Q5li3IQ7vwINvZvfqMOf9o2C1ikrnCon0Y/1wYbM5qPy2gbroPHs8m4
         0SR9sQdPbKIZDzuvn3yBdma49588VFvJnbDIy++c=
Date:   Tue, 8 Jun 2021 15:13:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 01/10] driver core: Do not continue searching for drivers
 if deferred probe is used
Message-ID: <YL9tAdxK+RMhwPFi@kroah.com>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <1-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <YL8RxPEMCDTXnPDg@kroah.com>
 <20210608121654.GX1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608121654.GX1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 09:16:54AM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 08, 2021 at 08:44:20AM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Jun 07, 2021 at 09:55:43PM -0300, Jason Gunthorpe wrote:
> > > Once a driver has been matched and probe() returns with -EPROBE_DEFER the
> > > device is added to a deferred list and will be retried later.
> > > 
> > > At this point __device_attach_driver() should stop trying other drivers as
> > > we have "matched" this driver and already scheduled another probe to
> > > happen later.
> > > 
> > > Return the -EPROBE_DEFER from really_probe() instead of squashing it to
> > > zero. This is similar to the code at the top of the function which
> > > directly returns -EPROBE_DEFER.
> > > 
> > > It is not really a bug as, AFAIK, we don't actually have cases where
> > > multiple drivers can bind.
> > 
> > We _do_ have devices that multiple drivers can bind to.  Are you sure
> > you did not just break them?
> 
> I asked Cornelia Huck who added this code if she knew who was using it
> and she said she added it but never ended up using it. Can you point
> at where there are multiple drivers matching the same device?

USB storage devices is one set of devices where the drivers have the
ability to both bind to the same device but use a way to figure out the
"best" one to do so.

> If multiple drivers are matchable what creates determinism in which
> will bind?

Magic :)

> And yes, this would break devices with multiple drivers that are using
> EPROBE_DEFER to set driver bind ordering. Do you know of any place
> doing that?

Other than usb-storage and uas, not off the top of my head.  I think
there was some platform drivers using this but I can't find them at the
moment.

> > Why are you needing to change this?  What is it helping?  What problem
> > is this solving?
> 
> This special flow works by returning 'success' when the driver bind
> actually failed. This is OK in the one call site that continues to
> scan but is not OK in the other callsites that don't keep scanning and
> want to see error codes.
> 
> So after the later patches this becomes quite a bit more complicated
> to keep implemented as-is. Better to delete it if it is safe to delete.

I think you need to determine if it is safe first as it is changing the
core functionality in the kernel that a few thousand drivers depend on
:)

So a "proof" is needed before I can remove something like this.

thanks,

greg k-h
