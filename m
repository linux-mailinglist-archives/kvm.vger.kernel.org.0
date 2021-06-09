Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778FE3A15AC
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 15:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbhFINee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 09:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbhFINec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 09:34:32 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F2BC06175F;
        Wed,  9 Jun 2021 06:32:37 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 7774036A; Wed,  9 Jun 2021 15:32:35 +0200 (CEST)
Date:   Wed, 9 Jun 2021 15:32:34 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <YMDC8tOMvw4FtSek@8bytes.org>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMCy48Xnt/aphfh3@8bytes.org>
 <20210609123919.GA1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609123919.GA1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 09, 2021 at 09:39:19AM -0300, Jason Gunthorpe wrote:
> VFIO being group centric has made it very ugly/difficult to inject
> device driver specific knowledge into the scheme.

This whole API will be complicated and difficult anyway, so no reason to
unnecessarily simplify things here.

VFIO is group-centric for security/isolation reasons, and since IOASID
is a uAPI it also needs to account for that. In the end the devices
which are going to use this will likely have their own group anyway, so
things will not get too complicated.

> The current approach has the group try to guess the device driver
> intention in the vfio type 1 code.
> 
> I want to see this be clean and have the device driver directly tell
> the iommu layer what kind of DMA it plans to do, and thus how it needs
> the IOMMU and IOASID configured.

I am in for the general idea, it simplifies the code. But the kernel
still needs to check whether the wishlist from user-space can be
fulfilled.

> The group is causing all this mess because the group knows nothing
> about what the device drivers contained in the group actually want.

There are devices in the group, not drivers.

> Further being group centric eliminates the possibility of working in
> cases like !ACS. How do I use PASID functionality of a device behind a
> !ACS switch if the uAPI forces all IOASID's to be linked to a group,
> not a device?

You don't use it, because it is not secure for devices which are not
behind an ACS bridge.

> Device centric with an report that "all devices in the group must use
> the same IOASID" covers all the new functionality, keep the old, and
> has a better chance to keep going as a uAPI into the future.

If all devices in the group have to use the same IOASID anyway, we can
just as well force it by making the interface group-centric.

Regards,

	Joerg
