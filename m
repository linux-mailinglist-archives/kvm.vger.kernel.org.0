Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37AF73ACCAE
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 15:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhFRNuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 09:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233615AbhFRNuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 09:50:03 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCA0C061574;
        Fri, 18 Jun 2021 06:47:53 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 6801E3A7; Fri, 18 Jun 2021 15:47:52 +0200 (CEST)
Date:   Fri, 18 Jun 2021 15:47:51 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
Message-ID: <YMykBzUHmATPbmdV@8bytes.org>
References: <20210611133828.6c6e8b29.alex.williamson@redhat.com>
 <20210612012846.GC1002214@nvidia.com>
 <20210612105711.7ac68c83.alex.williamson@redhat.com>
 <20210614140711.GI1002214@nvidia.com>
 <20210614102814.43ada8df.alex.williamson@redhat.com>
 <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615101215.4ba67c86.alex.williamson@redhat.com>
 <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210616133937.59050e1a.alex.williamson@redhat.com>
 <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

On Thu, Jun 17, 2021 at 07:31:03AM +0000, Tian, Kevin wrote:
> Now let's talk about the new IOMMU behavior:
> 
> -   A device is blocked from doing DMA to any resource outside of
>     its group when it's probed by the IOMMU driver. This could be a
>     special state w/o attaching to any domain, or a new special domain
>     type which differentiates it from existing domain types (identity, 
>     dma, or unmanged). Actually existing code already includes a
>     IOMMU_DOMAIN_BLOCKED type but nobody uses it.

There is a reason for the default domain to exist: Devices which require
RMRR mappings to be present. You can't just block all DMA from devices
until a driver takes over, we put much effort into making sure there is
not even a small window in time where RMRR regions (unity mapped regions
on AMD) are not mapped.

And if a device has no RMRR regions defined, then the default domain
will be identical to a blocking domain. Device driver bugs don't count
here, as they can be fixed. The kernel trusts itself, so we can rely on
drivers unmapping all of their DMA buffers. Maybe that should be checked
by dma-debug to find violations there.

Regards,

	Joerg
