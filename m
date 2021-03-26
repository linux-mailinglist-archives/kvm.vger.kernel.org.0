Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0929634A79E
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 13:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhCZMzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 08:55:15 -0400
Received: from verein.lst.de ([213.95.11.211]:45603 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229839AbhCZMzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 08:55:11 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7BD2767373; Fri, 26 Mar 2021 13:55:08 +0100 (CET)
Date:   Fri, 26 Mar 2021 13:55:08 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 03/18] vfio/mdev: Simplify driver registration
Message-ID: <20210326125508.GA18011@lst.de>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com> <3-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com> <20210323191415.GA17735@lst.de> <20210326121048.GN2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326121048.GN2356281@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 26, 2021 at 09:10:48AM -0300, Jason Gunthorpe wrote:
> It is usually hidden and works like this:
> 
>  /* pci_register_driver() must be a macro so KBUILD_MODNAME can be expanded */
>  #define pci_register_driver(driver)		\
>  	__pci_register_driver(driver, THIS_MODULE, KBUILD_MODNAME)
>  
>  int __pci_register_driver(struct pci_driver *drv, struct module *owner,
>  			  const char *mod_name)
>  {
> 	drv->driver.owner = owner;
>   	drv->driver.mod_name = mod_name;

Indeed, there seem to be about two handful of instance of that.

> > I've not really seen that in anywere else, and the only user seems
> > to be module_add_driver for a rather odd case we shouldn't hit here.
> 
> vfio_mdev could be compiled built in? 
> 
> AFAICT it handles the case where THIS_MODULE==NULL so we still need to
> create sysfs links to the built in module.
> 
> If it is left NULL then a few sysfs files go missing for the built in
> mode but no harm done?

Yes, it seems to be needed for a few driver-specific files.  So it looks
ok, even if rather unexpected.
