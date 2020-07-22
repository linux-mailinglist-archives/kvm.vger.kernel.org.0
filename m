Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1D022958D
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 11:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731271AbgGVJ5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 05:57:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726153AbgGVJ5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 05:57:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84C4220714;
        Wed, 22 Jul 2020 09:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595411873;
        bh=Ac2zSfnLK6EdjtxqVu1WgVKMMw2MnwHoF9j9QNHNO7g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=abKrNRxXeuctelcKVMQbIUVI1Fxcf2Kts4FdVgofW1X77fDquvE4r9eZGe7/KBJsb
         DotcyKDC//m8E2dWye8Sa6UoTEfBk+ehLisu8oOYbqRPDppbhrS835EBNvvSs5dfVa
         doYjLbY6XAMppyxD6z7vZ1B8qgDfDDKM4B3MMqRk=
Date:   Wed, 22 Jul 2020 11:57:59 +0200
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
Message-ID: <20200722095759.GA2817347@kroah.com>
References: <20200715194540.45532-1-andraprs@amazon.com>
 <20200715194540.45532-2-andraprs@amazon.com>
 <20200721121225.GA1855212@kroah.com>
 <5dad638c-0ef3-9d16-818c-54e1556d8fc8@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dad638c-0ef3-9d16-818c-54e1556d8fc8@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 22, 2020 at 11:27:29AM +0300, Paraschiv, Andra-Irina wrote:
> > > +#ifndef _UAPI_LINUX_NITRO_ENCLAVES_H_
> > > +#define _UAPI_LINUX_NITRO_ENCLAVES_H_
> > > +
> > > +#include <linux/types.h>
> > > +
> > > +/* Nitro Enclaves (NE) Kernel Driver Interface */
> > > +
> > > +#define NE_API_VERSION (1)
> > Why do you need this version?  It shouldn't be needed, right?
> 
> The version is used as a way for the user space tooling to sync on the
> features set provided by the driver e.g. in case an older version of the
> driver is available on the system and the user space tooling expects a set
> of features that is not included in that driver version.

That is guaranteed to get out of sync instantly with different distro
kernels backporting random things, combined with stable kernel patch
updates and the like.

Just use the normal api interfaces instead, don't try to "version"
anything, it will not work, trust us :)

If an ioctl returns -ENOTTY then hey, it's not present and your
userspace code can handle it that way.

thanks,

greg k-h
