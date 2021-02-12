Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF5431A6CA
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 22:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhBLVVr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 16:21:47 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1508 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbhBLVVk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 16:21:40 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6026f13c0000>; Fri, 12 Feb 2021 13:21:00 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 21:20:59 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 12 Feb 2021 21:20:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGgjRNts2sfSzEisOEPctADKdH9GsyuTkxzzS8+nasOdmZuJixSKFcUF4ApTt8tmNerl3m8HMUJPubdxSxyeMlz1eTMwau/jkVUY9aN4WN6TaOFUxxBr5Vw5zxD8F+7rdX+VWG7AAA8S5QRySt9Kv+i0X1u58qdEcf7nbk6T/eEv9oBz94VSBnl9lZ1tFr2pPrahiW+RSE46weAa3BWGhaXzrAuB5KqGwuBJSLijDRzA5u5zwFCRjnnEmGTh26g267Vb3IlrERNae3NqFGm2RqrXB5/xCe7Ep0VwrdKvUSoWcEmT1+oqAAhXkEAvUhoBPFpmYzmdAiTK/OIcCWTNqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6PCi19p5pOoVyit2tAtZOKzxJjy3RQsfsJBgzoKteU=;
 b=G/+KF0g6tHAsZYE1M9xrp4h9O+nCuEr9JjDxHCO6BCzSDwD8U5ptTibZGIk7JDhnjEw9M95yixN3ixTc3nSVVJyX8kTztgEQatVou5vJ8asnvSSzHxqPX/SiNdTQk4MDXc/cpIIzkFoaqfS8szGFZ3SBL1aBFGtvusmXXf7SPUKmsev5DHh2XorfYysd8O3OQ0wA/kzn8y6eFpnJ18jFyjDw57BcX4sy9+clqhePIvS1nO4AyHbzZeP3gsxP/zjRkazrBlZfOY3NRDspE0gMV3NgnXqbxRdNckoD986s7FQ4qEXE8FRDaIcft9nOb6Oq46OqisJ8Lgx+m2IP8dujwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3514.namprd12.prod.outlook.com (2603:10b6:5:183::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Fri, 12 Feb
 2021 21:20:58 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.030; Fri, 12 Feb 2021
 21:20:58 +0000
Date:   Fri, 12 Feb 2021 17:20:57 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [PATCH 1/3] vfio: Introduce vma ops registration and notifier
Message-ID: <20210212212057.GW4247@nvidia.com>
References: <161315658638.7320.9686203003395567745.stgit@gimli.home>
 <161315805248.7320.13358719859656681660.stgit@gimli.home>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <161315805248.7320.13358719859656681660.stgit@gimli.home>
X-ClientProxiedBy: BLAPR03CA0034.namprd03.prod.outlook.com
 (2603:10b6:208:32d::9) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0034.namprd03.prod.outlook.com (2603:10b6:208:32d::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Fri, 12 Feb 2021 21:20:58 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lAfs1-007o9H-4C; Fri, 12 Feb 2021 17:20:57 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613164860; bh=j6PCi19p5pOoVyit2tAtZOKzxJjy3RQsfsJBgzoKteU=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=EId+9CF3TRCy4czfIJsTr8wLKVizPoTM5HB1h4TVBrNYKli3K+MbVwxOxkcbq5cmz
         1mr2COMu55UiA1WwmIu2GuOpDdkB3UIeHqYyPWyWmC6gViJ3hvMWnt/d+YoX9VI73T
         WzA0ifOGqvF5y7k+D87sXKWlraQkjHwuIdbXerMiFRTip8m/OmLJr03kuIMBnn5L3J
         mcxm43uaWA0y+t9oGiZVEt5mrYJwlJsOT/NZ3E4dzD8CKidASGHAyYhx/STXFiF36T
         inFoaV6CXk/PQOGgSOT2CZUtBJffEH7OQ6ouEOi2EaU5xyTPTG5EZhcUXtoIMz1t4E
         nplaChHwYu0tw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 12, 2021 at 12:27:39PM -0700, Alex Williamson wrote:
> Create an interface through vfio-core where a vfio bus driver (ex.
> vfio-pci) can register the vm_operations_struct it uses to map device
> memory, along with a set of registration callbacks.  This allows
> vfio-core to expose interfaces for IOMMU backends to match a
> vm_area_struct to a bus driver and register a notifier for relavant
> changes to the device mapping.  For now we define only a notifier
> action for closing the device.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>  drivers/vfio/vfio.c  |  120 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/vfio.h |   20 ++++++++
>  2 files changed, 140 insertions(+)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 38779e6fd80c..568f5e37a95f 100644
> +++ b/drivers/vfio/vfio.c
> @@ -47,6 +47,8 @@ static struct vfio {
>  	struct cdev			group_cdev;
>  	dev_t				group_devt;
>  	wait_queue_head_t		release_q;
> +	struct list_head		vm_ops_list;
> +	struct mutex			vm_ops_lock;
>  } vfio;
>  
>  struct vfio_iommu_driver {
> @@ -2354,6 +2356,121 @@ struct iommu_domain *vfio_group_iommu_domain(struct vfio_group *group)
>  }
>  EXPORT_SYMBOL_GPL(vfio_group_iommu_domain);
>  
> +struct vfio_vma_ops {
> +	const struct vm_operations_struct	*vm_ops;
> +	vfio_register_vma_nb_t			*reg_fn;
> +	vfio_unregister_vma_nb_t		*unreg_fn;
> +	struct list_head			next;
> +};
> +
> +int vfio_register_vma_ops(const struct vm_operations_struct *vm_ops,
> +			  vfio_register_vma_nb_t *reg_fn,
> +			  vfio_unregister_vma_nb_t *unreg_fn)

This just feels a little bit too complicated

I've recently learned from Daniel that we can use the address_space
machinery to drive the zap_vma_ptes() via unmap_mapping_range(). This
technique replaces all the open, close and vma_list logic in vfio_pci

If we don't need open anymore, we could do something like this:

 static const struct vm_operations_struct vfio_pci_mmap_ops = {
        .open = vfio_pfn_open, // implemented in vfio.c
        .close = vfio_pfn_close,
        .fault = vfio_pci_mmap_fault,
 };

Then we could code the function needed:

struct vfio_pfn_range_handle 
{
       struct kref kref;
       struct vfio_device *vfio;
       struct notifier_block invalidation_cb;
       unsigned int flags;
}

struct vfio_pfn_range_handle *get_pfn_range(struct vm_area_struct *vma)
{
       struct vfio_pfn_range_handle *handle;

       if (vma->ops->open != vfio_pfn_open)
              return NULL;
       
       handle = vma->vm_private_data;
       if (test_bit(handle->flags, DMA_STOPPED)
              return NULL;
       kref_get(&handle->kref);
       return handle;
}

Where the common open/close only kref inc/dec the kref and all 'vfio'
VMAs always have a pointer to the same vfio_pfn_range_handle in their
private_data.

The vm_pgoff is already pointing at the physical pfn, so every part of
the system can get the information it needs fairly trivially.

Some stop access function is pretty simple looking

void stop_access(struct vfio_pfn_range_handle *handle)
{
      set_bit(handle->flags, DMA_STOPPED);
      unmap_mapping_range(handle->vfio->[..]->inode, 0, max, false);
      srcu_notifier_call_chain(handle->invalidation_cb, VFIO_VMA_NOTIFY_CLOSE, NULL);
}

(well, have to sort out the locking some more, but that is the
 general idea)

I think that would remove alot of the code added here and acts a lot
closer to how a someday dmabuf could act.

Also, this will need to update the nvlink vmops as well

Jason
