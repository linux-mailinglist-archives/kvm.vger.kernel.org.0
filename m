Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2EE43720C
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 08:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhJVGtT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 02:49:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229609AbhJVGtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Oct 2021 02:49:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 488E560F50;
        Fri, 22 Oct 2021 06:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634885221;
        bh=+Fkp4XMTW4DD+TiuV8fRU7EzH5a/UJyx5ELdTnoO+vk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jq3iY2JKlAX0xOntAT8OGpltqeTISuwgz9HM/ViUZxGGBAkGBpWCFtN5QwmUL3Klh
         pfe6nt3IzzL8gQpJixVJyghPQe8Xb47mIFZpYdwC2qrrFLVuf669y7dnCCFN8AgvoV
         4nSyjbrHqJTYIHyauyIpVbelASHdZvypS4/QAP5A=
Date:   Fri, 22 Oct 2021 08:46:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Zev Weiss <zev@bewilderbeest.net>
Cc:     Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, openbmc@lists.ozlabs.org,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Saravana Kannan <saravanak@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Jianxiong Gao <jxgao@google.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rajat Jain <rajatja@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dmaengine@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 4/5] driver core: inhibit automatic driver binding on
 reserved devices
Message-ID: <YXJeYCFJ5DnBB63R@kroah.com>
References: <20211022020032.26980-1-zev@bewilderbeest.net>
 <20211022020032.26980-5-zev@bewilderbeest.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022020032.26980-5-zev@bewilderbeest.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 21, 2021 at 07:00:31PM -0700, Zev Weiss wrote:
> Devices whose fwnodes are marked as reserved are instantiated, but
> will not have a driver bound to them unless userspace explicitly
> requests it by writing to a 'bind' sysfs file.  This is to enable
> devices that may require special (userspace-mediated) preparation
> before a driver can safely probe them.
> 
> Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
> ---
>  drivers/base/bus.c            |  2 +-
>  drivers/base/dd.c             | 13 ++++++++-----
>  drivers/dma/idxd/compat.c     |  3 +--
>  drivers/vfio/mdev/mdev_core.c |  2 +-
>  include/linux/device.h        | 14 +++++++++++++-
>  5 files changed, 24 insertions(+), 10 deletions(-)

Ugh, no, I don't really want to add yet-another-state to the driver core
like this.  Why are these devices even in the kernel with a driver that
wants to bind to them registered if the driver somehow should NOT be
bound to it?  Shouldn't all of that logic be in the crazy driver itself
as that is a very rare and odd thing to do that the driver core should
not care about at all.

And why does a device need userspace interaction at all?  Again, why
would the driver not know about this and handle it all directly?

thanks,

greg k-h
