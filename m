Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78444397A5
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 15:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbhJYNga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 09:36:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230137AbhJYNg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 09:36:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B78460C49;
        Mon, 25 Oct 2021 13:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635168847;
        bh=TGM36HNRsET/pFtiRfUexbyoYySsw2F2J7sSYWaL4F0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cLwXICOQfBRit9X+o06XSrCCVKcm+8e9Lr8O3G353b3PJm27R/6kJBXEgUANF2Q13
         yFo1+jzyeBnuifrTyxAID5+YW9BmeKBbwhl0bVxV6tMEmd9Ejq2LhPh+ZWRyqB1R7k
         mWNhnb3OIffD3fMCcsJpq/paMle0k8Ob1NPCM9PY=
Date:   Mon, 25 Oct 2021 15:34:05 +0200
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
Message-ID: <YXayTeJiQvpRutU0@kroah.com>
References: <YXJeYCFJ5DnBB63R@kroah.com>
 <YXJ3IPPkoLxqXiD3@hatter.bewilderbeest.net>
 <YXJ88eARBE3vU1aA@kroah.com>
 <YXLWMyleiTFDDZgm@heinlein>
 <YXPOSZPA41f+EUvM@kroah.com>
 <627101ee-7414-57d1-9952-6e023b8db317@gmail.com>
 <YXZLjTvGevAXcidW@kroah.com>
 <YXaYmie/CUHnixtX@heinlein>
 <YXap8V/jMM3Ksj7x@smile.fi.intel.com>
 <YXavBWTNYsufqj8u@heinlein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXavBWTNYsufqj8u@heinlein>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 25, 2021 at 08:20:05AM -0500, Patrick Williams wrote:
> On Mon, Oct 25, 2021 at 03:58:25PM +0300, Andy Shevchenko wrote:
> > On Mon, Oct 25, 2021 at 06:44:26AM -0500, Patrick Williams wrote:
> > > On Mon, Oct 25, 2021 at 08:15:41AM +0200, Greg Kroah-Hartman wrote:
> > > > On Mon, Oct 25, 2021 at 12:38:08AM -0500, Frank Rowand wrote:
> > > > > On 10/23/21 3:56 AM, Greg Kroah-Hartman wrote:
> > >  
> > > > We have the bind/unbind ability today, from userspace, that can control
> > > > this.  Why not just have Linux grab the device when it boots, and then
> > > > when userspace wants to "give the device up", it writes to "unbind" in
> > > > sysfs, and then when all is done, it writes to the "bind" file and then
> > > > Linux takes back over.
> > > > 
> > > > Unless for some reason Linux should _not_ grab the device when booting,
> > > > then things get messier, as we have seen in this thread.
> > > 
> > > This is probably more typical on a BMC than atypical.  The systems often require
> > > the BMC (running Linux) to be able to reboot independently from the managed host
> > > (running anything).  In the example Zev gave, the BMC rebooting would rip away
> > > the BIOS chip from the running host.
> > > 
> > > The BMC almost always needs to come up in a "I don't know what could possibly be
> > > going on in the system" state and re-discover where the system was left off.
> > 
> > Isn't it an architectural issue then?
> 
> I'm not sure what "it" you are referring to here.
> 
> I was trying to explain why starting in "bind" state is not a good idea for a
> BMC in most of these cases where we want to be able to dynamically add a device.

I think "it" is "something needs to be the moderator between the two
operating systems".  What is the external entity that handles the
switching between the two?

thanks,

greg k-h
