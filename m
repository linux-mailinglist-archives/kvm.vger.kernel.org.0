Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9BA26B965
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 03:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgIPBbg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 21:31:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:12530 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgIPBbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 21:31:34 -0400
IronPort-SDR: S8S86uKIWk9duu2MQEYQTSj2FI+516LZQfYRp+jbXvlexQzEeNnNd5aLR7HmjkHrvN+pIrnoLa
 lACkmyvIJTKA==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="158661207"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="158661207"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 18:31:32 -0700
IronPort-SDR: vrQV2lNJK2eIL0XZTK+LJIElKj6m1ReVBt3cqWBVsg60bO+wYrtSMOYIqo3/HcIOl/ErYz4GDd
 Llw6G0TvWbAg==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="451648122"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 18:31:30 -0700
Date:   Wed, 16 Sep 2020 09:30:26 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: add a singleton check for vfio_group_pin_pages
Message-ID: <20200916013025.GA18827@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200915003042.14273-1-yan.y.zhao@intel.com>
 <20200915130301.15d95412@x1.home>
 <20200915133011.1e3652ee@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915133011.1e3652ee@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15, 2020 at 01:30:11PM -0600, Alex Williamson wrote:
> On Tue, 15 Sep 2020 13:03:01 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > On Tue, 15 Sep 2020 08:30:42 +0800
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > 
> > > vfio_pin_pages() and vfio_group_pin_pages() are used purely to mark dirty
> > > pages to devices with IOMMU backend as they already have all VM pages
> > > pinned at VM startup.  
> > 
> > This is wrong.  The entire initial basis of mdev devices is for
> > non-IOMMU backed devices which provide mediation outside of the scope
> > of the IOMMU.  That mediation includes interpreting device DMA
> > programming and making use of the vfio_pin_pages() interface to
> > translate and pin IOVA address to HPA.  Marking pages dirty is a
> > secondary feature.
> > 
> > > when there're multiple devices in the vfio group, the dirty pages
> > > marked through pin_pages interface by one device is not useful as the
> > > other devices may access and dirty any VM pages.  
> > 
> > I don't know of any cases where there are multiple devices in a group
> > that would make use of this interface, however, all devices within a
> > group necessarily share an IOMMU context and any one device dirtying a
> > page will dirty that page for all devices, so I don't see that this is
> > a valid statement either.
> > 
> > > So added a check such that only singleton IOMMU groups can pin pages
> > > in vfio_group_pin_pages. for mdevs, there's always only one dev in a
> > > vfio group.
> > > This is a fix to the commit below that added a singleton IOMMU group
> > > check in vfio_pin_pages.  
> > 
> > None of the justification above is accurate, please try again.  Thanks,
> 
> FWIW, I think this should read something like "Page pinning is used
> both to translate and pin device mappings for DMA purpose, as well as
> to indicate to the IOMMU backend to limit the dirty page scope to those
> pages that have been pinned, in the case of an IOMMU backed device.  To
> support this, the vfio_pin_pages() interface limits itself to only
> singleton groups such that the IOMMU backend can consider dirty page
> scope only at the group level.  Implement the same requirement for the
> vfio_group_pin_pages() interface."  Thanks,
> 
yes, I'm sorry that I didn't express the meaning clearly.
will resend it using this version.

Thanks
Yan


> 
> 
> > > Fixes: 95fc87b44104 (vfio: Selective dirty page tracking if IOMMU backed
> > > device pins pages)
> > > 
> > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > ---
> > >  drivers/vfio/vfio.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > > index 5e6e0511b5aa..2f0fa272ebf2 100644
> > > --- a/drivers/vfio/vfio.c
> > > +++ b/drivers/vfio/vfio.c
> > > @@ -2053,6 +2053,9 @@ int vfio_group_pin_pages(struct vfio_group *group,
> > >  	if (!group || !user_iova_pfn || !phys_pfn || !npage)
> > >  		return -EINVAL;
> > >  
> > > +	if (group->dev_counter > 1)
> > > +		return  -EINVAL;
> > > +
> > >  	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
> > >  		return -E2BIG;
> > >    
> > 
> 
