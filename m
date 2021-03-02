Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E9A32B567
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhCCHHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:07:38 -0500
Received: from mga12.intel.com ([192.55.52.136]:34070 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242439AbhCBRNy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 12:13:54 -0500
IronPort-SDR: z45Z+tmPdHZSbw09ZOwcWxRwV5v562d5nIFaATzXoUo42+LB804vpkmLvY4Fq7UZhx+AClbStL
 OrMht8D1RaAA==
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="166137667"
X-IronPort-AV: E=Sophos;i="5.81,217,1610438400"; 
   d="scan'208";a="166137667"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 09:11:16 -0800
IronPort-SDR: JIH2cPgHmEyDB8jcG5yboYFvOA0L9iZ92yElD4Sh1mVurz8gs9R9/rix56DWOPR21483d6q24Y
 Qo1GBYI0EoRg==
X-IronPort-AV: E=Sophos;i="5.81,217,1610438400"; 
   d="scan'208";a="383628600"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 09:11:16 -0800
Date:   Tue, 2 Mar 2021 09:13:19 -0800
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
        jacob.jun.pan@linux.intel.com
Subject: Re: [Patch v8 04/10] vfio/type1: Support binding guest page tables
 to PASID
Message-ID: <20210302091319.1446a47b@jacob-builder>
In-Reply-To: <20210302125628.GI4247@nvidia.com>
References: <20210302203545.436623-1-yi.l.liu@intel.com>
        <20210302203545.436623-5-yi.l.liu@intel.com>
        <20210302125628.GI4247@nvidia.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On Tue, 2 Mar 2021 08:56:28 -0400, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Mar 03, 2021 at 04:35:39AM +0800, Liu Yi L wrote:
> >  
> > +static int vfio_dev_bind_gpasid_fn(struct device *dev, void *data)
> > +{
> > +	struct domain_capsule *dc = (struct domain_capsule *)data;
> > +	unsigned long arg = *(unsigned long *)dc->data;
> > +
> > +	return iommu_uapi_sva_bind_gpasid(dc->domain, dev,
> > +					  (void __user *)arg);  
> 
> This arg buisness is really tortured. The type should be set at the
> ioctl, not constantly passed down as unsigned long or worse void *.
> 
> And why is this passing a __user pointer deep into an iommu_* API??
> 
The idea was that IOMMU UAPI (not API) is independent of VFIO or other user
driver frameworks. The design is documented here:
Documentation/userspace-api/iommu.rst
IOMMU UAPI handles the type and sanitation of user provided data.

Could you be more specific about your concerns?

> > +/**
> > + * VFIO_IOMMU_NESTING_OP - _IOW(VFIO_TYPE, VFIO_BASE + 18,
> > + *				struct vfio_iommu_type1_nesting_op)
> > + *
> > + * This interface allows userspace to utilize the nesting IOMMU
> > + * capabilities as reported in VFIO_IOMMU_TYPE1_INFO_CAP_NESTING
> > + * cap through VFIO_IOMMU_GET_INFO. For platforms which require
> > + * system wide PASID, PASID will be allocated by VFIO_IOMMU_PASID
> > + * _REQUEST.
> > + *
> > + * @data[] types defined for each op:
> > + * +=================+===============================================+
> > + * | NESTING OP      |      @data[]                                  |
> > + * +=================+===============================================+
> > + * | BIND_PGTBL      |      struct iommu_gpasid_bind_data            |
> > + * +-----------------+-----------------------------------------------+
> > + * | UNBIND_PGTBL    |      struct iommu_gpasid_bind_data            |
> > + *
> > +-----------------+-----------------------------------------------+  
> 
> If the type is known why does the struct have a flex array?
> 
This will be extended to other types in the next patches.

> Jason


Thanks,

Jacob
