Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAF938DE0A
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 01:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhEWX30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 May 2021 19:29:26 -0400
Received: from mail-bn1nam07on2079.outbound.protection.outlook.com ([40.107.212.79]:46470
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231982AbhEWX3Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 May 2021 19:29:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H5KJAhuQlavLo+7h4teH/aDef3/1lFR7lgUuNBcgE9ddKg7BXCEUuvIh3sHWGhrtmdv94yHVX+0UYoaROCv5j7+RDxBh/VVKMxdwZwvdeGFIfj5p4HN/jsLaaBMV96o4xdYfziM27cBqnRMt4Rk0m+lHqP7a9cWJvNkg3iqVx/VfSHtR7ikFTNA7sfAtQdbLH4X2ymyPPD6pCJ+uzKebmKJEsXTHCYOd4jR/cdBtWVr+o1xJvFLwXej9tGJMNUIyQoCkOACmngMr5AV5WriVsaOTni3L9U33vukBcSXPkHI7oSZPBzFA/lJoUMG1OhwGkCWopqiqnx6/UlLZsQ6AKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Bx/yKLfecZPtpg6g30Bvbgj07U0VBmbGvLJZWmfer4=;
 b=HkJkZoN0DiQYp/J1milBNCo1QjjAMFauwxVD8Dr/cYsaqDtT8M9JnpSxX0aUAsKEEdMIdQQpirB9PVVvBLzcfjkQVfHLC84fDIYAtEeGKaH755MC28VOEYOShehnROcU9sIy20Elnayyw8kB7dT9knCCG+6eo66uu88M7eGotkHn0F9Gyi+2vRf1DRDCAeIXvihTAHXb4v2Y4XoH0ve4WcuN1PEEgZNC43DNfcDkSqeHaGcH0oOFbjURcxOhA/XI+j9qFOTaLjRrP7G740wVYQGTBuNhaTQRWW/R8TByeKvFIedbS70qrZZC+iS4BmvVTXsMBRE2CJJBhU1DM86VOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Bx/yKLfecZPtpg6g30Bvbgj07U0VBmbGvLJZWmfer4=;
 b=guXyGuL+WRzbTWlMXk6gMSj4h81UIdaWNr/dxgFZ4cOCrFnXCCSIQCfRNoyezCmXk41rzQYAP+WDnCI+DEKYr0cEcL4SAyjiyHfOmKFtlslQrVk10IaeJL49KHwIUNbbOMS5RDh+xXIzoDdEKU72UBVuoOFhtTB7mxxHqZuHsQyQHLe+EfGoBtqATYGhUEA5IIjPLw3aQnzHdMxbpWPV4eHyzZ54NkZKkD1QggU8XtyQZ+YNhOJtmAOdWM6YYWXZOkhMEiV4HD71yIuBNsGPV3DmXxwD0+nD8C/gF4BJvRgadOSBJfeTl/ulEIc0ukSytB4jVyy9zJOgozzi9FhN+g==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5174.namprd12.prod.outlook.com (2603:10b6:208:31c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Sun, 23 May
 2021 23:27:56 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 23:27:56 +0000
Date:   Sun, 23 May 2021 20:27:55 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 11/20] vfio/mdev: idxd: Add basic driver setup for
 idxd mdev
Message-ID: <20210523232755.GH1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164281350.261970.10539208268885731071.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162164281350.261970.10539208268885731071.stgit@djiang5-desk3.ch.intel.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH0PR13CA0039.namprd13.prod.outlook.com
 (2603:10b6:610:b2::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR13CA0039.namprd13.prod.outlook.com (2603:10b6:610:b2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Sun, 23 May 2021 23:27:56 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lkxVj-00DUg0-35; Sun, 23 May 2021 20:27:55 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65948c2a-3c94-41e3-2469-08d91e42651f
X-MS-TrafficTypeDiagnostic: BL1PR12MB5174:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB517446E0A2C48AABDBA84B5BC2279@BL1PR12MB5174.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 54WCXoSCCBIWIOm1NbGCYQyqD3Xww7rit8QrDVOUR4x2fnaFy+VM8sQvMXuXYo7cgkTlOiVSvvR6Ak8MNLFlO81g5528NyMuVciuPXSlQbVSyNEntHpd2spdjpdWfDdEoeqqS43X7Hxc6bTS01OM04X6bKD1rio7vV5S2yw8yHyXOqMs0nDt2qq3OEIelnB9+WSFBeCsoHI2JeZHahYp1r2tqmF2boeMMes19+dMm0Li8df9j/UL+xOxaqeKH3IqYytfmHJ9sMJRFsEsNT1TOlCGSyF8UAxwAj0eGZD3ktmf3J8AVrxYaFhXbXIVRdr0MIoaNA7xc+KnutuLqxlHIAOpsgIjfreJuQNRxTLAfP4cyYBF9xVCQqirBzLt+ieMyL4+78zCeSsA8/hwidLlripFqIbFZQQd/bGHleuncpPfm6sJai0F6og7v6lex0E6NuNv2QttCZmgAhmV9QM/OSoFFLxm0Cc+EX7UIACxaJX+h3VsgcJV2Z7S9untW+aq3QO3rZPeQZzBPMPtBLIzG8bnvy5NoJI/dFSYdQZkzSFaQy1wQhKNOX9X3GXt6sn5VTbGGjQQYeOACgpa4qbOe3FN5XfnLz48QEido1PJ964=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(9786002)(9746002)(83380400001)(4326008)(6916009)(426003)(8936002)(186003)(316002)(66556008)(8676002)(478600001)(26005)(33656002)(86362001)(7416002)(66476007)(66946007)(5660300002)(38100700002)(36756003)(2616005)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?t2P3VsEaWlF+HU+yMwaAyunkoOPDaudSkR4mVKwxgY8gpgZMfSTYTpf0VJTF?=
 =?us-ascii?Q?28rr8pZsPQ8XgbtG+1yblpGx6iyA6Wu6f0fuFd9tUxASC3EoubuMpQ4S05zY?=
 =?us-ascii?Q?vg+ATi3t5NaBpTm31Vkkcb9oFoadxBLLY3BdPed1NPxN4aLVvR0eSo4aJWyB?=
 =?us-ascii?Q?QMPQw7MGXCmOTJTBfquzHvoFOOMlPmhi/KpTNgu45jorvK50d3jdQ88Fp0NL?=
 =?us-ascii?Q?Hl82d7e56dead4qeLzkKF96f7vn/B4bug3KeMbGCuoQb6zH8cLyH0OeS4HJO?=
 =?us-ascii?Q?y+4YfmjOc16fJYo8x+tT1ag2zHPCBb0yQ1UiHfeamSHZhMck6MkA/oJ7eymY?=
 =?us-ascii?Q?QTArM1rw2nOtF6ZUDPdkTJGFT8Er9q3mHwoHtmgw1J9IFyfqqt6e7Dsx63T7?=
 =?us-ascii?Q?KwPQXf5Xd/NAD/Oq4rFlKdNsr9wdjwdJOgSerjpby55GHerKf3aPlm/niDKb?=
 =?us-ascii?Q?RRqWO6AbSv1qZA9WVRXnVHx3nefrF+sS5pz4EbcpHzV4C3omJHZFYpdP2TB5?=
 =?us-ascii?Q?a0UopII92/4ZV/geALLfyyXNFQtg+Jh3ADOiW7YtBOQOyFnbRksF9sJvn9OY?=
 =?us-ascii?Q?Je0Ol/itKYQOc/NDfY2e6yMbxZtBfHUSWQZwZjby2493CxQj7z0emfT6otkE?=
 =?us-ascii?Q?dDk26ojfW7ibHJVimDF1Hex9HpSF8g3/ubsba01g6bUxN93S/EqE9rJsaOou?=
 =?us-ascii?Q?6Yd28e8XTdte9v3sKMsdIuijjg8uYekxO2EDIHJsuBXYyuxCjAqZ88M9iwko?=
 =?us-ascii?Q?zUh8xK27uWaM2yhn9/Dou/Go6/ZUU6Z5qIEzxNV4YqbDSm/i5XEV0r+cmw+Q?=
 =?us-ascii?Q?kcoCPHhUjhjofVV28r0Q33RNrYDBjAGtHeSNefrlYVHSoRvRtA3erydy6xBh?=
 =?us-ascii?Q?+AzmDVl1C6J8QI7iA4I5fNa+KHgMQDuBa9KJNOzQCDNAXtV7qs4gnBi4qbAk?=
 =?us-ascii?Q?v1XiMUzCPUjkafBZPbN1nJHuMV6SxulZpBrgj1Mr2RW6yslV5iQ1EmeDyd7j?=
 =?us-ascii?Q?idb3rvABSFgH84AuR8KsYysWqQFEYUcAfdg1X8EIMSAXDlYaAWHlXAviQUIh?=
 =?us-ascii?Q?J9RQcrZfkvhZ2dgN62cp56Vt03nLGR7/mQPRBqlXh4E/Pc3WKErBYBUwtSp9?=
 =?us-ascii?Q?GM2KxFysSRr1rTYXGB7LAsGllfxIIczYMW6BDypbWIicXXp1m5KRUDXFRmkd?=
 =?us-ascii?Q?7CR1zjx0TN2q9sbAuGFu/V4eY6evOe8uxoJjZwS5hWQBCxkQwlqL2YnQ11ty?=
 =?us-ascii?Q?VBTR2XUPM9r49V4XoFtg12b/KsPKmseB4S18j4oXAQPv+4gBsp43p0EljyZn?=
 =?us-ascii?Q?qIRcbP0BdyWessBktV4NlicY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65948c2a-3c94-41e3-2469-08d91e42651f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 23:27:56.4423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hOwlE3r5+TKrqbRrQ/c6T8YnH50vWxk7C8vxah4BOUYdbxc1cUVdKbI62ALmhMFz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5174
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 21, 2021 at 05:20:13PM -0700, Dave Jiang wrote:

> +int idxd_mdev_host_init(struct idxd_device *idxd, struct mdev_driver *drv)
> +{
> +	struct device *dev = &idxd->pdev->dev;
> +	int rc;
> +
> +	if (!idxd->ims_size)
> +		return -EOPNOTSUPP;
> +
> +	rc = iommu_dev_enable_feature(dev, IOMMU_DEV_FEAT_AUX);
> +	if (rc < 0) {
> +		dev_warn(dev, "Failed to enable aux-domain: %d\n", rc);
> +		return rc;
> +	}
> +
> +	rc = mdev_register_device(dev, drv);
> +	if (rc < 0) {
> +		iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
> +		return rc;
> +	}

Don't call mdev_register_device from drivers/dma/idxd/init.c - vfio
stuff all belongs under drivers/vfio.

> +void idxd_mdev_host_release(struct kref *kref)
> +{
> +	struct idxd_device *idxd = container_of(kref, struct idxd_device, mdev_kref);
> +	struct device *dev = &idxd->pdev->dev;
> +
> +	mdev_unregister_device(dev);
> +	iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
> +}
> +EXPORT_SYMBOL_GPL(idxd_mdev_host_release);
> +
>  static int idxd_setup_interrupts(struct idxd_device *idxd)
>  {
>  	struct pci_dev *pdev = idxd->pdev;
> @@ -352,6 +387,9 @@ static int idxd_setup_internals(struct idxd_device *idxd)
>  		goto err_wkq_create;
>  	}
>  
> +	kref_init(&idxd->mdev_kref);
> +	mutex_init(&idxd->kref_lock);
> +
>  	return 0;
>  
>   err_wkq_create:
> @@ -741,6 +779,7 @@ static void idxd_remove(struct pci_dev *pdev)
>  
>  	dev_dbg(&pdev->dev, "%s called\n", __func__);
>  	idxd_shutdown(pdev);
> +	kref_put_mutex(&idxd->mdev_kref, idxd_mdev_host_release, &idxd->kref_lock);

I didn't look closely at why this is like this, but please try to
avoid kref_put_mutex(), it should only be needed in exceptional
cases and this shouldn't be exceptional.

If you need to lock a kref before using it, it isn't a kref anymore,
just use an 'int'.

Especially since the kref is calling mdev_unregister_device(),
something is really upside down to motivate refcounting that.

Jason
