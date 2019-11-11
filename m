Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 549A4F79D1
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 18:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKKRXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 12:23:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:32972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbfKKRXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 12:23:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2536A214DB;
        Mon, 11 Nov 2019 17:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573493004;
        bh=FdXhlcSnmQXZ512UJAwnB/JLm0W9BnHa+GET9e6BVV8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VcdI+yQ6JQj+/B1nStLolWUligtFElZUe7UsWr7g/kmdLjIhj6L9UgPV9fWDeYY2d
         IrSwoefmKTdFqj1LjlY0Z/EicQr+OA4Rrcr4EYpw7cpyzDLOM1oP4opT7UDKwjs6ij
         GMLfc6i277bBXRE4ZSOEDrxjN96fjopM6xkMbMKc=
Date:   Mon, 11 Nov 2019 18:23:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     lantianyu1986@gmail.com, alex.williamson@redhat.com,
        cohuck@redhat.com, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>, sashal@kernel.org,
        mchehab+samsung@kernel.org, davem@davemloft.net, robh@kernel.org,
        Jonathan.Cameron@huawei.com, paulmck@linux.ibm.com,
        Michael Kelley <mikelley@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets <vkuznets@redhat.com>
Subject: Re: [PATCH] VFIO/VMBUS: Add VFIO VMBUS driver support
Message-ID: <20191111172322.GB1077444@kroah.com>
References: <20191111084507.9286-1-Tianyu.Lan@microsoft.com>
 <20191111094920.GA135867@kroah.com>
 <20191111084712.37ba7d5a@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111084712.37ba7d5a@hermes.lan>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 11, 2019 at 08:47:12AM -0800, Stephen Hemminger wrote:
> On Mon, 11 Nov 2019 01:49:20 -0800
> "Greg KH" <gregkh@linuxfoundation.org> wrote:
> 
> > > +	ret = sysfs_create_bin_file(&channel->kobj,  
> > &ring_buffer_bin_attr);
> > > +	if (ret)
> > > +		dev_notice(&dev->device,
> > > +			   "sysfs create ring bin file failed; %d\n",  
> > ret);
> > > +  
> > 
> > Again, don't create sysfs files on your own, the bus code should be
> > doing this for you automatically and in a way that is race-free.
> > 
> > thanks,
> > 
> > greg k-h
> 
> The sysfs file is only created if the VFIO/UIO driveris used.

That's even worse.  Again, sysfs files should be automatically created
by the driver core when the device is created.  To randomly add/remove
random files after that happens means userspace is never notified of
that and that's not good.

We've been working for a while to fix up these types of races, don't
purposfully add new ones for no good reason please :)

thanks,

greg k-h
