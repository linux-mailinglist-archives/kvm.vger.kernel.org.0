Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA801E21EF
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 14:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388786AbgEZMdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 08:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727983AbgEZMdD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 08:33:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65C92207CB;
        Tue, 26 May 2020 12:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590496382;
        bh=J/ofThaxaM0xtQe0vxdfxn88U1thkKvd6+Zp8nzo9Dc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VI8lVcZaStraG3F7QrFdbQRFYgTSpxxmY5UByKI031j2asxt8f9es5GWacdgl8yvG
         IjTmGv3pBiv4nKsyLjwd518QH8y/M7YpXKpGJPyhx7iiW/5gp2O+3BNZsf93QMkRG5
         CSK8+BDK2gsYwlFpNJWpzFatILursP5MvwYZVt6g=
Date:   Tue, 26 May 2020 14:33:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Graf <graf@amazon.de>
Cc:     Andra Paraschiv <andraprs@amazon.com>,
        linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
Subject: Re: [PATCH v3 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
Message-ID: <20200526123300.GA2798@kroah.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-8-andraprs@amazon.com>
 <20200526065133.GD2580530@kroah.com>
 <72647fa4-79d9-7754-9843-a254487703ea@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72647fa4-79d9-7754-9843-a254487703ea@amazon.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 26, 2020 at 01:42:41PM +0200, Alexander Graf wrote:
> 
> 
> On 26.05.20 08:51, Greg KH wrote:
> > 
> > On Tue, May 26, 2020 at 01:13:23AM +0300, Andra Paraschiv wrote:
> > > +#define NE "nitro_enclaves: "
> > 
> > Again, no need for this.
> > 
> > > +#define NE_DEV_NAME "nitro_enclaves"
> > 
> > KBUILD_MODNAME?
> > 
> > > +#define NE_IMAGE_LOAD_OFFSET (8 * 1024UL * 1024UL)
> > > +
> > > +static char *ne_cpus;
> > > +module_param(ne_cpus, charp, 0644);
> > > +MODULE_PARM_DESC(ne_cpus, "<cpu-list> - CPU pool used for Nitro Enclaves");
> > 
> > Again, please do not do this.
> 
> I actually asked her to put this one in specifically.
> 
> The concept of this parameter is very similar to isolcpus= and maxcpus= in
> that it takes CPUs away from Linux and instead donates them to the
> underlying hypervisor, so that it can spawn enclaves using them.
> 
> From an admin's point of view, this is a setting I would like to keep
> persisted across reboots. How would this work with sysfs?

How about just as the "initial" ioctl command to set things up?  Don't
grab any cpu pools until asked to.  Otherwise, what happens when you
load this module on a system that can't support it?

module parameters are a major pain, you know this :)

> So yes, let's give everyone in CC the change to review v3 properly first
> before v4 goes out.
> 
> > And get them to sign off on it too, showing they agree with the design
> > decisions here :)
> 
> I would expect a Reviewed-by tag as a result from the above would satisfy
> this? :)

That would be most appreciated.

thanks,

greg k-h
