Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECB93421AE
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 17:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhCSQUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 12:20:45 -0400
Received: from verein.lst.de ([213.95.11.211]:46871 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229974AbhCSQUi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 12:20:38 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 49CB268BFE; Fri, 19 Mar 2021 17:20:34 +0100 (CET)
Date:   Fri, 19 Mar 2021 17:20:33 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        mjrosato@linux.ibm.com, hch@lst.de
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210319162033.GA18218@lst.de>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com> <20210309083357.65467-9-mgurtovoy@nvidia.com> <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru> <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com> <20210319092341.14bb179a@omen.home.shazbot.org> <20210319161722.GY2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319161722.GY2356281@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 19, 2021 at 01:17:22PM -0300, Jason Gunthorpe wrote:
> I think we talked about this.. We still need a better way to control
> binding of VFIO modules - now that we have device-specific modules we
> must have these match tables to control what devices they connect
> to.
> 
> Previously things used the binding of vfio_pci as the "switch" and
> hardcoded all the matches inside it.
> 
> I'm still keen to try the "driver flavour" idea I outlined earlier,
> but it is hard to say what will resonate with Greg.

IMHO the only model that really works and makes sense is to turn the
whole model around and make vfio a library called by the actual driver
for the device.  That is any device that needs device specific
funtionality simply needs a proper in-kernel driver, which then can be
switched to a vfio mode where all the normal subsystems are unbound
from the device, and VFIO functionality is found to it all while _the_
driver that controls the PCI ID is still in charge of it.

vfio_pci remains a separate driver not binding to any ID by default
and not having any device specific functionality.
