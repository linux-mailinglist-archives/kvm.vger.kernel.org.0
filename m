Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C59822AD03
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 12:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgGWKyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 06:54:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726675AbgGWKyF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 06:54:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D1CC2080D;
        Thu, 23 Jul 2020 10:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595501645;
        bh=6mmcCqMpDjuHIfe4cmovpxW4cdlpod52A2L6wyDcPis=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zIar5ScHC+i6Mq8/SSAAYEsE8slatSyTY9n5bYSFM6zw1CQQTSPgfG+Fdfe6MmtMH
         Y+NgDlJRVdZ6aFYTFOCrPrU+FBKwbG7uBTzja+6FJ8GejWP2eIrh/rJoIROOeyzOUJ
         5IolWMc6qdRUVQmS8/09gVKUOHvXNuPbd0XEGtpk=
Date:   Thu, 23 Jul 2020 12:54:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Cc:     linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>, Karen Noel <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com, Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH v5 01/18] nitro_enclaves: Add ioctl interface definition
Message-ID: <20200723105409.GC1949236@kroah.com>
References: <20200715194540.45532-1-andraprs@amazon.com>
 <20200715194540.45532-2-andraprs@amazon.com>
 <20200721121225.GA1855212@kroah.com>
 <5dad638c-0ef3-9d16-818c-54e1556d8fc8@amazon.com>
 <20200722095759.GA2817347@kroah.com>
 <b952de82-94de-fc14-74d3-f13859fe19f0@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b952de82-94de-fc14-74d3-f13859fe19f0@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 23, 2020 at 12:23:56PM +0300, Paraschiv, Andra-Irina wrote:
> 
> 
> On 22/07/2020 12:57, Greg KH wrote:
> > On Wed, Jul 22, 2020 at 11:27:29AM +0300, Paraschiv, Andra-Irina wrote:
> > > > > +#ifndef _UAPI_LINUX_NITRO_ENCLAVES_H_
> > > > > +#define _UAPI_LINUX_NITRO_ENCLAVES_H_
> > > > > +
> > > > > +#include <linux/types.h>
> > > > > +
> > > > > +/* Nitro Enclaves (NE) Kernel Driver Interface */
> > > > > +
> > > > > +#define NE_API_VERSION (1)
> > > > Why do you need this version?  It shouldn't be needed, right?
> > > The version is used as a way for the user space tooling to sync on the
> > > features set provided by the driver e.g. in case an older version of the
> > > driver is available on the system and the user space tooling expects a set
> > > of features that is not included in that driver version.
> > That is guaranteed to get out of sync instantly with different distro
> > kernels backporting random things, combined with stable kernel patch
> > updates and the like.
> > 
> > Just use the normal api interfaces instead, don't try to "version"
> > anything, it will not work, trust us :)
> > 
> > If an ioctl returns -ENOTTY then hey, it's not present and your
> > userspace code can handle it that way.
> 
> Correct, there could be a variety of kernel versions and user space tooling
> either in the original form, customized or written from scratch. And ENOTTY
> signals an ioctl not available or e.g. EINVAL (or custom error) if the
> parameter field value is not valid within a certain version. We have these
> in place, that's good. :)
> 
> However, I was thinking, for example, of an ioctl flow usage where a certain
> order needs to be followed e.g. create a VM, add resources to a VM, start a
> VM.
> 
> Let's say, for an use case wrt new features, ioctl A (create a VM) succeeds,
> ioctl B (add memory to the VM) succeeds, ioctl C (add CPU to the VM)
> succeeds and ioctl D (add any other type of resource before starting the VM)
> fails because it is not supported.
> 
> Would not need to call ioctl A to C and go through their underneath logic to
> realize ioctl D support is not there and rollback all the changes done till
> then within ioctl A to C logic. Of course, there could be ioctl A followed
> by ioctl D, and would need to rollback ioctl A changes, but I shared a more
> lengthy call chain that can be an option as well.

I think you are overthinking this.

If your interface is this complex, you have much larger issues as you
ALWAYS have to be able to handle error conditions properly, even if the
API is "supported".

Perhaps your API is showing to be too complex?

Also, where is the userspace code for all of this?  Did I miss a link to
it in the patches somewhere?

good luck!

greg k-h
