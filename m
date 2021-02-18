Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE91E31E3C5
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 02:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhBRBM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 20:12:58 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17138 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhBRBM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 20:12:57 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602dbef00001>; Wed, 17 Feb 2021 17:12:16 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Feb
 2021 01:12:15 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Feb
 2021 01:12:14 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 18 Feb 2021 01:12:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ammXQ+d6yu/fbTUP7hfxIgrhrhB66OqReYzC+WQGEVvK/YqZZaFMFvievPjbktHcXKB7IoRfXxbbkKSwZi7wpY0E0Y7kBCYZbwF6zhot3yL3Nezy/GlyD/66t8y4cy57R7zQ/QYZtP7C108EOo+R40lSmkoX6WDhjVCBSVXbM4sR6rLbaKgwe6wG/+zmW7ojuGzQJ2BAr1NXDtzPSaCh1kvmEA/AbtNVN2ltkry85v3uHiaWu1iU525ngyDgn8pi1ySNBpVYJH4BVATygSmmzQJcnCVfEAsOFVF7OBoonEr+aZTCeiXhdvvDbH7IWO503dRsT1Y5vJZhIMSbPWB2FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MchBGiDfOaado7pZaK6qUEEFGl235K6mNfNOuUI04no=;
 b=jeN3DbZL2VDTxFLNWYhYyhS+fcLyG9sRi20Y696VEe1+aH9V3UPuF9tmCKzyyIdE0xVOS2vq/+WxM5fGWu3Dwvqo5s8/6yn+6GbMa/3DHliImf5axgP+bdprd+Wwz/a4yXmHZwSNzn66Mffdjcmy+cEi6/O5E8bnmfcC8Rm83yhVwOOO4XLOLDiqWMzCKGwCRajBWGOEPoTV0AJCOmU0hQZsQHXL/dpKnjBzuM4eYUmuBZF8KlWMF4VbS0iBn8JyBwqEP/pUTNZjB/SxwFGVb5g7VioOo+koB6l0HBTJSV6vXfiqq3n7vmxj/Pq89y9WCzZfCMLGLvH/fDoNKZPucA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1340.namprd12.prod.outlook.com (2603:10b6:3:76::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 18 Feb
 2021 01:12:11 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.041; Thu, 18 Feb 2021
 01:12:10 +0000
Date:   Wed, 17 Feb 2021 21:12:09 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [PATCH 1/3] vfio: Introduce vma ops registration and notifier
Message-ID: <20210218011209.GB4247@nvidia.com>
References: <161315658638.7320.9686203003395567745.stgit@gimli.home>
 <161315805248.7320.13358719859656681660.stgit@gimli.home>
 <20210212212057.GW4247@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210212212057.GW4247@nvidia.com>
X-ClientProxiedBy: MN2PR11CA0025.namprd11.prod.outlook.com
 (2603:10b6:208:23b::30) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR11CA0025.namprd11.prod.outlook.com (2603:10b6:208:23b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 01:12:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lCXrV-00AFuF-BT; Wed, 17 Feb 2021 21:12:09 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613610736; bh=MchBGiDfOaado7pZaK6qUEEFGl235K6mNfNOuUI04no=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=hg4emgLimtY59DnVVirmLc4JsJ5pwZBlBh/6NLeUS3Zk+gubL4HrXYSX/IULWtt2U
         L7/b+4yRpa0+hOZ30QnW0rVOZhNVlQaz3G2GnDaoJzhEWyYGy5o1mlbxAFVDEAnvYj
         51H/lQHCeW+TiuuSYrmQezo2s4S8k4pj4xh8sZoGNdpt67D2+Al0+T8HomZacWAc6i
         y5x9FohCewpOJxgqQMSUorALjBVeIrweiGc+Iye6/xSkUrcv8Tdd5AeVBbfcqBZ0MS
         PUao1I6V7JCCRjEZCLYMbunPDGLwYRzG4fRBq6INPs4e5LwNFbYzI3g58UNqAE+3+P
         3K2Gv2oSouTxw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 12, 2021 at 05:20:57PM -0400, Jason Gunthorpe wrote:
> On Fri, Feb 12, 2021 at 12:27:39PM -0700, Alex Williamson wrote:
> > Create an interface through vfio-core where a vfio bus driver (ex.
> > vfio-pci) can register the vm_operations_struct it uses to map device
> > memory, along with a set of registration callbacks.  This allows
> > vfio-core to expose interfaces for IOMMU backends to match a
> > vm_area_struct to a bus driver and register a notifier for relavant
> > changes to the device mapping.  For now we define only a notifier
> > action for closing the device.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> >  drivers/vfio/vfio.c  |  120 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/vfio.h |   20 ++++++++
> >  2 files changed, 140 insertions(+)
> > 
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index 38779e6fd80c..568f5e37a95f 100644
> > +++ b/drivers/vfio/vfio.c
> > @@ -47,6 +47,8 @@ static struct vfio {
> >  	struct cdev			group_cdev;
> >  	dev_t				group_devt;
> >  	wait_queue_head_t		release_q;
> > +	struct list_head		vm_ops_list;
> > +	struct mutex			vm_ops_lock;
> >  } vfio;
> >  
> >  struct vfio_iommu_driver {
> > @@ -2354,6 +2356,121 @@ struct iommu_domain *vfio_group_iommu_domain(struct vfio_group *group)
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_group_iommu_domain);
> >  
> > +struct vfio_vma_ops {
> > +	const struct vm_operations_struct	*vm_ops;
> > +	vfio_register_vma_nb_t			*reg_fn;
> > +	vfio_unregister_vma_nb_t		*unreg_fn;
> > +	struct list_head			next;
> > +};
> > +
> > +int vfio_register_vma_ops(const struct vm_operations_struct *vm_ops,
> > +			  vfio_register_vma_nb_t *reg_fn,
> > +			  vfio_unregister_vma_nb_t *unreg_fn)
> 
> This just feels a little bit too complicated
> 
> I've recently learned from Daniel that we can use the address_space
> machinery to drive the zap_vma_ptes() via unmap_mapping_range(). This
> technique replaces all the open, close and vma_list logic in vfio_pci

Here is my effort to make rdma use this, it removes a lot of ugly code:

https://github.com/jgunthorpe/linux/commits/rdma_addr_space

Still needs some more detailed testing.

This gives an option to detect vfio VMAs by checking

   if (vma->vm_file &&
       file_inode(vma->vm_file) &&
       file_inode(vma->vm_file)->i_sb->s_type == vfio_fs_type)

And all vfio VMA's can have some consistent vm_private_data, or at
worst a consistent extended vm operations struct.

Jason
