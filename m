Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE64439829
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 16:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbhJYOM0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 10:12:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233009AbhJYOMY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 10:12:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A8B860F70;
        Mon, 25 Oct 2021 14:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635171002;
        bh=keekYHdYAWdyATEPVva/BLVQO6EKoTmmk3kBb7KadD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XBxJJmEPAXirY/tRVpXuJnIeh0slTyHNA95Ovi49PA5U63ohfmz3WuMZLCiyIc9n2
         IaoxVT1evX8GtEwThTfwpaycwgwr9lo3SyMekZYko/T6kWJN8V7UdDHig+8qKnkNoq
         NvA/6Nx4qGIvRfBzPaEpi5OlMuu/+inZXvjn3oTk=
Date:   Mon, 25 Oct 2021 16:09:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Patrick Williams <patrick@stwcx.xyz>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Zev Weiss <zev@bewilderbeest.net>, kvm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Rajat Jain <rajatja@google.com>,
        Jianxiong Gao <jxgao@google.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Saravana Kannan <saravanak@google.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        openbmc@lists.ozlabs.org, devicetree@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Jeffery <andrew@aj.id.au>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH 4/5] driver core: inhibit automatic driver binding on
 reserved devices
Message-ID: <YXa6t/ifxZGGSCNj@kroah.com>
References: <YXJ88eARBE3vU1aA@kroah.com>
 <YXLWMyleiTFDDZgm@heinlein>
 <YXPOSZPA41f+EUvM@kroah.com>
 <627101ee-7414-57d1-9952-6e023b8db317@gmail.com>
 <YXZLjTvGevAXcidW@kroah.com>
 <YXaYmie/CUHnixtX@heinlein>
 <YXap8V/jMM3Ksj7x@smile.fi.intel.com>
 <YXavBWTNYsufqj8u@heinlein>
 <YXayTeJiQvpRutU0@kroah.com>
 <YXa5AExKg+k0MmHV@heinlein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXa5AExKg+k0MmHV@heinlein>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 25, 2021 at 09:02:40AM -0500, Patrick Williams wrote:
> On Mon, Oct 25, 2021 at 03:34:05PM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Oct 25, 2021 at 08:20:05AM -0500, Patrick Williams wrote:
> > > On Mon, Oct 25, 2021 at 03:58:25PM +0300, Andy Shevchenko wrote:
> > > > On Mon, Oct 25, 2021 at 06:44:26AM -0500, Patrick Williams wrote:
> > > > > On Mon, Oct 25, 2021 at 08:15:41AM +0200, Greg Kroah-Hartman wrote:
> > > > > > On Mon, Oct 25, 2021 at 12:38:08AM -0500, Frank Rowand wrote:
> > > > > > > On 10/23/21 3:56 AM, Greg Kroah-Hartman wrote:
> > > > >  
> > > > > > We have the bind/unbind ability today, from userspace, that can control
> > > > > > this.  Why not just have Linux grab the device when it boots, and then
> > > > > > when userspace wants to "give the device up", it writes to "unbind" in
> > > > > > sysfs, and then when all is done, it writes to the "bind" file and then
> > > > > > Linux takes back over.
> > > > > > 
> > > > > > Unless for some reason Linux should _not_ grab the device when booting,
> > > > > > then things get messier, as we have seen in this thread.
> > > > > 
> > > > > This is probably more typical on a BMC than atypical.  The systems often require
> > > > > the BMC (running Linux) to be able to reboot independently from the managed host
> > > > > (running anything).  In the example Zev gave, the BMC rebooting would rip away
> > > > > the BIOS chip from the running host.
> > > > > 
> > > > > The BMC almost always needs to come up in a "I don't know what could possibly be
> > > > > going on in the system" state and re-discover where the system was left off.
> > > > 
> > > > Isn't it an architectural issue then?
> > > 
> > > I'm not sure what "it" you are referring to here.
> > > 
> > > I was trying to explain why starting in "bind" state is not a good idea for a
> > > BMC in most of these cases where we want to be able to dynamically add a device.
> > 
> > I think "it" is "something needs to be the moderator between the two
> > operating systems".  What is the external entity that handles the
> > switching between the two?
> 
> Ah, ok.
> 
> Those usually end up being system / device specific.  In the case of the BIOS
> flash, most designs I've seen use a SPI mux between the BMC and the host
> processor or IO hub (PCH on Xeons).  The BMC has a GPIO to control the mux.
> 
> As far as state, the BMC on start-up will go through a set of discovery code to
> figure out where it left the system prior to getting reset.  That involves
> looking at the power subsystem and usually doing some kind of query to the host
> to see if it is alive.  These queries are mostly system / host-processor design
> specific.  I've seen anything from an IPMI/IPMB message alert from the BMC to
> the BIOS to ask "are you alive" to reading host processor state over JTAG to
> figure out if the processors are "making progress".

But which processor is "in control" here over the hardware?  What method
is used to pass the device from one CPU to another from a logical point
of view?  Sounds like it is another driver that needs to handle all of
this, so why not have that be the one that adds/removes the devices
under control here?

thanks,

greg k-h
