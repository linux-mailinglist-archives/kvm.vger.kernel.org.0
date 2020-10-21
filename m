Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72154295339
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 22:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439292AbgJUUDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 16:03:22 -0400
Received: from mga17.intel.com ([192.55.52.151]:8418 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410567AbgJUUDW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 16:03:22 -0400
IronPort-SDR: WaIui7aH3ToqhnRl4Z5YerRo66VZE+MqROnm10tDJ1S4Bj4oF2d0oElVWFHEJXLvjOHxHRgkgT
 rEpLGAxxb74Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9781"; a="147285060"
X-IronPort-AV: E=Sophos;i="5.77,402,1596524400"; 
   d="scan'208";a="147285060"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 13:03:20 -0700
IronPort-SDR: xEyG+1n/eDzjVR0+DtrXQn5yv9QrenhZiu6V46hIeKkpLXZlWavLw7Y1PgxgjOpAwXqjOjTx+Y
 jH17pp8imlug==
X-IronPort-AV: E=Sophos;i="5.77,402,1596524400"; 
   d="scan'208";a="392836909"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 13:03:16 -0700
Date:   Wed, 21 Oct 2020 13:03:15 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Message-ID: <20201021200315.GA93724@otc-nc-03>
References: <20201020162430.GA85321@otc-nc-03>
 <20201020170336.GK6219@nvidia.com>
 <20201020195146.GA86371@otc-nc-03>
 <20201020195557.GO6219@nvidia.com>
 <20201020200844.GC86371@otc-nc-03>
 <20201020201403.GP6219@nvidia.com>
 <20201020202713.GF86371@otc-nc-03>
 <20201021114829.GR6219@nvidia.com>
 <20201021175146.GA92867@otc-nc-03>
 <20201021182442.GU6219@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021182442.GU6219@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 21, 2020 at 03:24:42PM -0300, Jason Gunthorpe wrote:
> 
> > Contrary to your argument, vDPA went with a half blown device only 
> > iommu user without considering existing abstractions like containers
> 
> VDPA IOMMU was done *for Intel*, as the kind of half-architected thing
> you are advocating should be allowed for IDXD here. Not sure why you
> think bashing that work is going to help your case here.

I'm not bashing that work, sorry if it comes out that way, 
but just feels like double standards.

I'm not sure why you tie in IDXD and VDPA here. How IDXD uses native
SVM is orthogonal to how we achieve mdev passthrough to guest and vSVM. 
We visited that exact thing multiple times. Doing SVM is quite simple and 
doesn't carry the weight of other (Kevin explained this in detail 
not too long ago) long list of things we need to accomplish for mdev pass through. 

For SVM, just access to hw, mmio and bind_mm to get a PASID bound with
IOMMU. 

For IDXD that creates passthough devices for guest access and vSVM is
through the VFIO path. 

For guest SVM, we expose mdev's to guest OS, idxd in the guest provides vSVM
services. vSVM is *not* build around native SVM interfaces. 
