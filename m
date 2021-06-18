Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EE83ACF48
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 17:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbhFRPjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 11:39:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:45828 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230334AbhFRPjr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 11:39:47 -0400
IronPort-SDR: tSvdvpt9fUhTWz2YmMjj8LlhZJtM4kLLDS/U4MafrojeJ2l8CeQv8TrtP1V77vxMsmJqN9M0M5
 LK0RyMu7yXUg==
X-IronPort-AV: E=McAfee;i="6200,9189,10019"; a="203549581"
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="203549581"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 08:37:38 -0700
IronPort-SDR: xhESf2oMa+8VoQ5jV/dGg2MUo/FbH7/yt+V3DJLY/BhMChnHHNfE0MCQxRHVYZgqywzqx4n2m3
 RcB9xiGAa+tA==
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="489102206"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 08:37:37 -0700
Date:   Fri, 18 Jun 2021 08:37:35 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210618153735.GA37688@otc-nc-03>
References: <20210612105711.7ac68c83.alex.williamson@redhat.com>
 <20210614140711.GI1002214@nvidia.com>
 <20210614102814.43ada8df.alex.williamson@redhat.com>
 <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615101215.4ba67c86.alex.williamson@redhat.com>
 <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210616133937.59050e1a.alex.williamson@redhat.com>
 <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMykBzUHmATPbmdV@8bytes.org>
 <20210618151506.GG1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618151506.GG1002214@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 18, 2021 at 12:15:06PM -0300, Jason Gunthorpe wrote:
> On Fri, Jun 18, 2021 at 03:47:51PM +0200, Joerg Roedel wrote:
> > Hi Kevin,
> > 
> > On Thu, Jun 17, 2021 at 07:31:03AM +0000, Tian, Kevin wrote:
> > > Now let's talk about the new IOMMU behavior:
> > > 
> > > -   A device is blocked from doing DMA to any resource outside of
> > >     its group when it's probed by the IOMMU driver. This could be a
> > >     special state w/o attaching to any domain, or a new special domain
> > >     type which differentiates it from existing domain types (identity, 
> > >     dma, or unmanged). Actually existing code already includes a
> > >     IOMMU_DOMAIN_BLOCKED type but nobody uses it.
> > 
> > There is a reason for the default domain to exist: Devices which require
> > RMRR mappings to be present. You can't just block all DMA from devices
> > until a driver takes over, we put much effort into making sure there is
> > not even a small window in time where RMRR regions (unity mapped regions
> > on AMD) are not mapped.
> 
> Yes, I think the DMA blocking can only start around/after a VFIO type
> driver has probed() and bound to a device in the group, not much
> different from today.

Does this mean when a device has a required "RMRR" that requires a unity
mapping we block assigning those devices to guests? I remember we had some
restriction but there was a need to go around it at some point in time.

- Either we disallow assigning devices with RMRR
- Break that unity map when the device is probed and after which any RMRR
  access from device will fault.

Cheers,
Ashok
