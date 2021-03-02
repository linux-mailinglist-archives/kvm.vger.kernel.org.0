Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA51732A792
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839336AbhCBQRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:17:17 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7357 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351433AbhCBOYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 09:24:39 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603e36090001>; Tue, 02 Mar 2021 04:56:41 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Mar
 2021 12:56:31 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 2 Mar 2021 12:56:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JVBGe1a+0bdT+uQl//+se6BS36aERgqzoj4jxC28EhKKHReJTlTKyRExsqQadUp7XG8wrU+n3Jh//qSPYrRDj3ST1fzMvnApxORf39RDQtr6HlGyBLDB5xqkmHLnPiOM6gsqKBy/bbeNbUFjq9EmIJtUtU1T0ftctSIChARx8kPcQpHFDdeCJt6oe1Vmyk0AacKD009cLlurETzq10RLkZA3lPcli8AlYPGw+7mkrlnMMkjv5Eau4uu9hqAj/UbsPPRbiKKQVFFSWSVrsML42aEHNOzjafKOfpQSexzVPVn/C1RemauG9/GKGtX7K1dRqGVGE7bF3iO0Og0dh0lFCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9MgLTm4NUOav1OVsggZ0AhuQUe5IdICnRZfme77w4MM=;
 b=LTsTx67l7MykGA/X8wQmm+dxy2pSQCNYpgm8u/irC744IEQPrkoqVscN4y8/SkatF+eatt1ky6i0AWwwabQT+0kRDqC2hmWv/Pim7AQ0M2Ca2MXWaVKUE0I1/3liDrj8QVNgPbP8wGR8x3AJj8N5fiLPN3SutQuIoC6QyDdYH85iOSeBQ+uvc3n1YRIxmiB7ntj8XRcHeif6bzyp+HGWPPECnavSjt3YnC8dCbNKWRaD+RxReqHV8EhcIv5O2J/0/A0HSJ1OOKXPO81l3+nJA9gD1cNk2zSESQ6CdCi9fTUmHK8WtoEo7j3yvr5NWhgLgwvA6lOH0BSuD4JIeJvbjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1515.namprd12.prod.outlook.com (2603:10b6:4:6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.20; Tue, 2 Mar 2021 12:56:30 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.017; Tue, 2 Mar 2021
 12:56:29 +0000
Date:   Tue, 2 Mar 2021 08:56:28 -0400
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
Subject: Re: [Patch v8 04/10] vfio/type1: Support binding guest page tables
 to PASID
Message-ID: <20210302125628.GI4247@nvidia.com>
References: <20210302203545.436623-1-yi.l.liu@intel.com>
 <20210302203545.436623-5-yi.l.liu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210302203545.436623-5-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR20CA0049.namprd20.prod.outlook.com
 (2603:10b6:208:235::18) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR20CA0049.namprd20.prod.outlook.com (2603:10b6:208:235::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Tue, 2 Mar 2021 12:56:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lH4Zg-0049l2-AZ; Tue, 02 Mar 2021 08:56:28 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614689801; bh=9MgLTm4NUOav1OVsggZ0AhuQUe5IdICnRZfme77w4MM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=CvLvudj1bLNW4uS1FHwJ8ieEhafikTtef3ToiDwvY45Dxpv62TIB68vY6GkGegtQ+
         3RLXwBbC1YwLeEB+xf2UONelKeYY7BBQ8uvv9Grc0jrBbYKnEmUqaRx8pC2y4M7//S
         2Z+2mCaPtB8Z2HLgw8cgm2sracAAUhEZI5xIMek8vUEhe4DVsr98ll2p8Sxr50Qcc5
         b6fGCoL7LN69RDQRyAXaX+R/jOL4ApFHVZu9IHHtvFF/msr9/6SXGZXMWO3+dzrn4+
         MD0BtK/OC55o7vaunlZ/lAibpboie+E1qYsm/Sc8p7QC0chSjGMsreKIFNYX0c+GYJ
         3R+dg+oGZikEQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 03, 2021 at 04:35:39AM +0800, Liu Yi L wrote:
>  
> +static int vfio_dev_bind_gpasid_fn(struct device *dev, void *data)
> +{
> +	struct domain_capsule *dc = (struct domain_capsule *)data;
> +	unsigned long arg = *(unsigned long *)dc->data;
> +
> +	return iommu_uapi_sva_bind_gpasid(dc->domain, dev,
> +					  (void __user *)arg);

This arg buisness is really tortured. The type should be set at the
ioctl, not constantly passed down as unsigned long or worse void *.

And why is this passing a __user pointer deep into an iommu_* API??

> +/**
> + * VFIO_IOMMU_NESTING_OP - _IOW(VFIO_TYPE, VFIO_BASE + 18,
> + *				struct vfio_iommu_type1_nesting_op)
> + *
> + * This interface allows userspace to utilize the nesting IOMMU
> + * capabilities as reported in VFIO_IOMMU_TYPE1_INFO_CAP_NESTING
> + * cap through VFIO_IOMMU_GET_INFO. For platforms which require
> + * system wide PASID, PASID will be allocated by VFIO_IOMMU_PASID
> + * _REQUEST.
> + *
> + * @data[] types defined for each op:
> + * +=================+===============================================+
> + * | NESTING OP      |      @data[]                                  |
> + * +=================+===============================================+
> + * | BIND_PGTBL      |      struct iommu_gpasid_bind_data            |
> + * +-----------------+-----------------------------------------------+
> + * | UNBIND_PGTBL    |      struct iommu_gpasid_bind_data            |
> + *
> +-----------------+-----------------------------------------------+

If the type is known why does the struct have a flex array?

Jason
