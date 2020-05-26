Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869531E1B7F
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 08:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730420AbgEZGmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 02:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbgEZGmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 02:42:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 340C3207D8;
        Tue, 26 May 2020 06:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590475365;
        bh=E7i/b2w8LCgpcEMWjCV0/7fQbTJXMdmPWp/J7Q0+yXU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sqVToUa4KhoeKIAh6sfg7/N81FYvMoi7Vyg/KCGXeza/vQQq/Wic58V5qouYHnCwP
         PD/HgX9MKepcpRtrJNUSW8x4PakqKFhhStYHosDDFOVBKPykavJU3r4X/L0i9RK1vb
         xVIQMaMqL4z8j6utXhDrhQi2QukoJm9FCvBqWgjM=
Date:   Tue, 26 May 2020 08:42:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Cc:     linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
Subject: Re: [PATCH v2 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
Message-ID: <20200526064243.GB2580410@kroah.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
 <20200522062946.28973-8-andraprs@amazon.com>
 <20200522070708.GC771317@kroah.com>
 <fa3a72ef-ba0a-ada9-48bf-bd7cef0a8174@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa3a72ef-ba0a-ada9-48bf-bd7cef0a8174@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 11:49:50PM +0300, Paraschiv, Andra-Irina wrote:
> 
> 
> On 22/05/2020 10:07, Greg KH wrote:
> > On Fri, May 22, 2020 at 09:29:35AM +0300, Andra Paraschiv wrote:
> > > +static char *ne_cpus;
> > > +module_param(ne_cpus, charp, 0644);
> > > +MODULE_PARM_DESC(ne_cpus, "<cpu-list> - CPU pool used for Nitro Enclaves");
> > This is not the 1990's, don't use module parameters if you can help it.
> > Why is this needed, and where is it documented?
> 
> This is a CPU pool that can be set by the root user and that includes CPUs
> set aside to be used for the enclave(s) setup; these CPUs are offlined. From
> this CPU pool, the kernel logic chooses the CPUs that are set for the
> created enclave(s).
> 
> The cpu-list format is matching the same that is documented here:
> 
> https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
> 
> I've also thought of having a sysfs entry for the setup of this enclave CPU
> pool.

Ok, but again, do not use a module parameter, they are hard to use,
tough to document, and global.  All things we moved away from a long
time ago.  Please use something else for this (sysfs, configfs, etc.)
instead.

thanks,

greg k-h
