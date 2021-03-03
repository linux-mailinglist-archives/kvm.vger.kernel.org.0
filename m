Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84EF32C75E
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387996AbhCDAbl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 3 Mar 2021 19:31:41 -0500
Received: from mga14.intel.com ([192.55.52.115]:59824 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377019AbhCCTo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 14:44:56 -0500
IronPort-SDR: v1NC3ReYebK5plJ6XwGmxyol44w3U5+au81QX0kxKuDoQCU2dW2PVkOSZO0m66X0XEcOYc6iUI
 qW+dhlSttFqw==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="186614500"
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="186614500"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 11:39:57 -0800
IronPort-SDR: OdWGxtDOTrbt2xAehg361Kyac1/DrJMpD2/y6cI5y2BRW5S4BA85lehFEoc8rHcWhexqlqbAbe
 RjtgNnQeWrjg==
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="384112777"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 11:39:56 -0800
Date:   Wed, 3 Mar 2021 11:42:12 -0800
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Liu Yi L <yi.l.liu@intel.com>, <alex.williamson@redhat.com>,
        <eric.auger@redhat.com>, <baolu.lu@linux.intel.com>,
        <joro@8bytes.org>, <kevin.tian@intel.com>, <ashok.raj@intel.com>,
        <jun.j.tian@intel.com>, <yi.y.sun@intel.com>,
        <jean-philippe@linaro.org>, <peterx@redhat.com>,
        <jasowang@redhat.com>, <hao.wu@intel.com>, <stefanha@gmail.com>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <Lingshan.Zhu@intel.com>, <vivek.gautam@arm.com>,
        jacob.jun.pan@linux.intel.com, Jason Wang <jasowang@redhat.com>
Subject: Re: [Patch v8 04/10] vfio/type1: Support binding guest page tables
 to PASID
Message-ID: <20210303114212.1cd86579@jacob-builder>
In-Reply-To: <20210302171551.GK4247@nvidia.com>
References: <20210302203545.436623-1-yi.l.liu@intel.com>
        <20210302203545.436623-5-yi.l.liu@intel.com>
        <20210302125628.GI4247@nvidia.com>
        <20210302091319.1446a47b@jacob-builder>
        <20210302171551.GK4247@nvidia.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On Tue, 2 Mar 2021 13:15:51 -0400, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Mar 02, 2021 at 09:13:19AM -0800, Jacob Pan wrote:
> > Hi Jason,
> > 
> > On Tue, 2 Mar 2021 08:56:28 -0400, Jason Gunthorpe <jgg@nvidia.com>
> > wrote: 
> > > On Wed, Mar 03, 2021 at 04:35:39AM +0800, Liu Yi L wrote:  
> > > >  
> > > > +static int vfio_dev_bind_gpasid_fn(struct device *dev, void *data)
> > > > +{
> > > > +	struct domain_capsule *dc = (struct domain_capsule *)data;
> > > > +	unsigned long arg = *(unsigned long *)dc->data;
> > > > +
> > > > +	return iommu_uapi_sva_bind_gpasid(dc->domain, dev,
> > > > +					  (void __user *)arg);    
> > > 
> > > This arg buisness is really tortured. The type should be set at the
> > > ioctl, not constantly passed down as unsigned long or worse void *.
> > > 
> > > And why is this passing a __user pointer deep into an iommu_* API??
> > >   
> > The idea was that IOMMU UAPI (not API) is independent of VFIO or other
> > user driver frameworks. The design is documented here:
> > Documentation/userspace-api/iommu.rst
> > IOMMU UAPI handles the type and sanitation of user provided data.  
> 
> Why? If it is uapi it has defined types and those types should be
> completely clear from the C code, not obfuscated.
> 
From the user's p.o.v., it is plain c code nothing obfuscated. As for
kernel handling of the data types, it has to be answered by the bigger
question of how we deal with sharing IOMMU among multiple subsystems with
UAPIs.

> I haven't looked at the design doc yet, but this is a just a big red
> flag, you shouldn't be tunneling one subsytems uAPI through another
> subsystem.
>
> If you need to hook two subsystems together it should be more
> directly, like VFIO takes in the IOMMU FD and 'registers' itself in
> some way with the IOMMU then you can do the IOMMU actions through the
> IOMMU FD and it can call back to VFIO as needed.
> 
> At least in this way we can swap VFIO for other things in the API.
> 
> Having every subsystem that wants to implement IOMMU also implement
> tunneled ops seems very backwards.
>
Let me try to understand your proposal, you are saying:
1. Create a new user interface such that FDs can be obtained as a reference
to an IOMMU.
2. Handle over the IOMMU FD to VFIO or other subsystem which wish to
register for IOMMU service.

However, IOMMU is a system device which has little value to be exposed to
the userspace. Not to mention the device-IOMMU affinity/topology. VFIO
nicely abstracts IOMMU from the userspace, why do we want to reverse that?

With this UAPI layering approach, we converge common code at the IOMMU
layer. Without introducing new user interfaces, we can support multiple
subsystems that want to use IOMMU service. e.g. VDPA and VFIO.

> > Could you be more specific about your concerns?  
> 
> Avoid using unsigned long, void * and flex arrays to describe
> concretely typed things.
> 
> Jason


Thanks,

Jacob
