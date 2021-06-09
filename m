Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276A73A1A2F
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 17:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237186AbhFIPxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 11:53:24 -0400
Received: from 8bytes.org ([81.169.241.247]:43546 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237156AbhFIPxX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 11:53:23 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 9B3CD434; Wed,  9 Jun 2021 17:51:27 +0200 (CEST)
Date:   Wed, 9 Jun 2021 17:51:26 +0200
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
Message-ID: <YMDjfmJKUDSrbZbo@8bytes.org>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMCy48Xnt/aphfh3@8bytes.org>
 <20210609123919.GA1002214@nvidia.com>
 <YMDC8tOMvw4FtSek@8bytes.org>
 <20210609150009.GE1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609150009.GE1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 09, 2021 at 12:00:09PM -0300, Jason Gunthorpe wrote:
> Only *drivers* know what the actual device is going to do, devices do
> not. Since the group doesn't have drivers it is the wrong layer to be
> making choices about how to configure the IOMMU.

Groups don't carry how to configure IOMMUs, that information is
mostly in the IOMMU domains. And those (or an abstraction of them) is
configured through /dev/ioasid. So not sure what you wanted to say with
the above.

All a group carries is information about which devices are not
sufficiently isolated from each other and thus need to always be in the
same domain.

> The device centric approach is my attempt at this, and it is pretty
> clean, I think.

Clean, but still insecure.

> All ACS does is prevent P2P operations, if you assign all the group
> devices into the same /dev/iommu then you may not care about that
> security isolation property. At the very least it is policy for user
> to decide, not kernel.

It is a kernel decision, because a fundamental task of the kernel is to
ensure isolation between user-space tasks as good as it can. And if a
device assigned to one task can interfer with a device of another task
(e.g. by sending P2P messages), then the promise of isolation is broken.

> Groups should be primarily about isolation security, not about IOASID
> matching.

That doesn't make any sense, what do you mean by 'IOASID matching'?

> Blocking this forever in the new uAPI just because group = IOASID is
> some historical convenience makes no sense to me.

I think it is safe to assume that devices supporting PASID will most
often be the only ones in their group. But for the non-PASID IOASID
use-cases like plain old device assignment to a VM it needs to be
group-centric.

Regards,

	Joerg
