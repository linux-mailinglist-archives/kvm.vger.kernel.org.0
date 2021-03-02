Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA28F32A777
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449209AbhCBQQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:16:42 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11923 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351040AbhCBNGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 08:06:20 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603e35ee0000>; Tue, 02 Mar 2021 04:56:14 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Mar
 2021 12:56:11 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Mar
 2021 12:52:11 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 2 Mar 2021 12:52:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SItexnowg2k9pOW5aBDHeGTGJYI6ARIAcIsO6MCus23/g5BOuG/SHU5nNd8z2jcoMPUKRFJr5f33zazmdPxJPC0O6T6WlBiruscjDDgQegybFHU0Eoe47NN3i8RZTvFUmi1faGl2NqoBFcw84mUkJMafgjb5QkzJKWBGpVaDQypTiiRdaJnh7kR/rt4a/Z/FzHHLm3PIB9Y84ZMin+XlR7kGQXKIo9z6I2TnKvCBV7Xzj1BnYSmyrbk28zo/FI1Rv59iCogDM64dsNceKGTN+kAJ07yNbYN43I8yn7UnzB3soMtY6RDbDgMnRgUo5JLwQ83HG5vm5wwY6t/ULmWbxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TdySoU/aCgLDTn1V5mKAAJMwO59ZsxZFgGCSS1hi8qM=;
 b=oIltqEeeM9pLQwe90qbc9f0MFHLgI1VUDE7Lt5hJmuyYXx3I9sfSMJorTnQV96rzC6lIOZd+RZMPX46hgCVhBDGa0v49kUFNUreHJ1xTifN3vqKZzX54DdxLDECgJ78cm5sxbg6nnqGIPeAKgZo1COv92qmsa7Ou8BT9U2mCDLxB4JNxfjH964WBk7/pli96CbD69730k4/DthLz/wb+tJUqgC2EUfC8C4pIVkYA0thipJgbp7boidXLCuSy6Ubys3C7BMmkqUYPRvkdvpBlxX9KQgF1St/zI02ggmic0zyiLisGfrozMnfV+VZdyfZGjL1hez9e+6zQob944jep1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3401.namprd12.prod.outlook.com (2603:10b6:5:39::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Tue, 2 Mar
 2021 12:52:08 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.017; Tue, 2 Mar 2021
 12:52:08 +0000
Date:   Tue, 2 Mar 2021 08:52:06 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Liu Yi L <yi.l.liu@intel.com>
CC:     <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <kevin.tian@intel.com>, <jacob.jun.pan@linux.intel.com>,
        <ashok.raj@intel.com>, <jun.j.tian@intel.com>,
        <yi.y.sun@intel.com>, <jean-philippe@linaro.org>,
        <peterx@redhat.com>, <jasowang@redhat.com>, <hao.wu@intel.com>,
        <stefanha@gmail.com>, <iommu@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <Lingshan.Zhu@intel.com>,
        <vivek.gautam@arm.com>
Subject: Re: [Patch v8 03/10] vfio/type1: Report iommu nesting info to
 userspace
Message-ID: <20210302125206.GH4247@nvidia.com>
References: <20210302203545.436623-1-yi.l.liu@intel.com>
 <20210302203545.436623-4-yi.l.liu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210302203545.436623-4-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR02CA0006.namprd02.prod.outlook.com
 (2603:10b6:208:fc::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR02CA0006.namprd02.prod.outlook.com (2603:10b6:208:fc::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Tue, 2 Mar 2021 12:52:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lH4VS-0049gL-IK; Tue, 02 Mar 2021 08:52:06 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614689774; bh=TdySoU/aCgLDTn1V5mKAAJMwO59ZsxZFgGCSS1hi8qM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=mzUvPzOCS6Vj0gThLROP9KQVqeokV6TMZW0UCgKyi+nEZ/zLVPTxpNjdv/EUM9rxr
         HQiZ1axXs6ZAiC2H/RW7weZOxDyWJI1puU9g76NW8tmHvAzT/GCV7RmEscwjJG0kwK
         FgLc7CH9MgBhwbSzvlb0uUEst8OJeSEo88xJ3B5TlL0A0BAc88L1yYRcgrF4IP0Eca
         Fypn9TvrqOP1VOch/uRtY1T3pj7qgEqdro1pndlfJgs/kOTV7xn9097vNeXXli/gq6
         R47QO0uvNjhmGaaDLRbg9edsMEWxiFwIj/cXxIK8pBSum16HzdBM0qNDJn4LrhPYzk
         ioCLqQpzx+Mow==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 03, 2021 at 04:35:38AM +0800, Liu Yi L wrote:
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 4bb162c1d649..3a5c84d4f19b 100644
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -63,22 +63,24 @@ MODULE_PARM_DESC(dma_entry_limit,
>  		 "Maximum number of user DMA mappings per container (65535).");
>  
>  struct vfio_iommu {
> -	struct list_head	domain_list;
> -	struct list_head	iova_list;
> -	struct vfio_domain	*external_domain; /* domain for external user */
> -	struct mutex		lock;
> -	struct rb_root		dma_list;
> -	struct blocking_notifier_head notifier;
> -	unsigned int		dma_avail;
> -	unsigned int		vaddr_invalid_count;
> -	uint64_t		pgsize_bitmap;
> -	uint64_t		num_non_pinned_groups;
> -	wait_queue_head_t	vaddr_wait;
> -	bool			v2;
> -	bool			nesting;
> -	bool			dirty_page_tracking;
> -	bool			pinned_page_dirty_scope;
> -	bool			container_open;
> +	struct list_head		domain_list;
> +	struct list_head		iova_list;
> +	/* domain for external user */
> +	struct vfio_domain		*external_domain;
> +	struct mutex			lock;
> +	struct rb_root			dma_list;
> +	struct blocking_notifier_head	notifier;
> +	unsigned int			dma_avail;
> +	unsigned int			vaddr_invalid_count;
> +	uint64_t			pgsize_bitmap;
> +	uint64_t			num_non_pinned_groups;
> +	wait_queue_head_t		vaddr_wait;
> +	struct iommu_nesting_info	*nesting_info;
> +	bool				v2;
> +	bool				nesting;
> +	bool				dirty_page_tracking;
> +	bool				pinned_page_dirty_scope;
> +	bool				container_open;
>  };

I always hate seeing one line patches done like this. If you want to
re-indent you should remove the horizontal whitespace, not add an
unreadable amount more.

Also, Linus has been unhappy before to see lists of bool's in structs
due to the huge amount of memory they waste.

Jason
