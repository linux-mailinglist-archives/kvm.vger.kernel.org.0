Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15AE4276DFF
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 11:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgIXJzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 05:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgIXJzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 05:55:37 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4513CC0613CE
        for <kvm@vger.kernel.org>; Thu, 24 Sep 2020 02:55:37 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id EAEBB295; Thu, 24 Sep 2020 11:55:33 +0200 (CEST)
Date:   Thu, 24 Sep 2020 11:55:32 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>, Zeng Xin <xin.zeng@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v5 0/5] iommu aux-domain APIs extensions
Message-ID: <20200924095532.GK27174@8bytes.org>
References: <20200922061042.31633-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922061042.31633-1-baolu.lu@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 22, 2020 at 02:10:37PM +0800, Lu Baolu wrote:
> Hi Jorge and Alex,
> 
> A description of this patch series could be found here.
> 
> https://lore.kernel.org/linux-iommu/20200901033422.22249-1-baolu.lu@linux.intel.com/

Hmm, I am wondering if we can avoid all this hassle and special APIs by
making the mdev framework more visible outside of the vfio code. There
is an underlying bus implementation for mdevs, so is there a reason
those can't use the standard iommu-core code to setup IOMMU mappings?

What speaks against doing:

	- IOMMU drivers capable of handling mdevs register iommu-ops
	  for the mdev_bus.

	- iommu_domain_alloc() takes bus_type as parameter, so there can
	  be special domains be allocated for mdevs.

	- Group creation and domain allocation will happen
	  automatically in the iommu-core when a new mdev is registered
	  through device-driver core code.

	- There should be no need for special iommu_aux_* APIs, as one
	  can attach a domain directly to &mdev->dev with
	  iommu_attach_device(domain, &mdev->dev).

Doing it this way will probably also keep the mdev-special code in VFIO
small.

Regards,

	Joerg
