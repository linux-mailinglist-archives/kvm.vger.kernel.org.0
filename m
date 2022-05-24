Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5EB5332D4
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 23:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241857AbiEXVIX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 17:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241787AbiEXVIV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 17:08:21 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2081.outbound.protection.outlook.com [40.107.236.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FCB3DDF9;
        Tue, 24 May 2022 14:08:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4KopruvZ5F+27OWdlDsi9d0hTKLfZ1DwBkZHO6XnvQW9bsb/iUENZlGGjBPlaimdvb99i0f92aqmCZ4nB57oF0weER/ZOU39tX1O0zFeTBkUYa2uLyjBqtfvvu21LVdUwjIf21IKlzy4tQk34pKt8kNvf/BFb+gFRE9T+JYWnjbUxDBjJmImJJwYqsMK2ih1J2pusL7s/GziwyX0KU5kKGMAp8jvzOlrl7et68F4FskXrwAj/vCNYEapOj3ieSk9Z3C3dioab2SazPXit2f3pl98WETEcK+EnCiuQ08GgcwkVbU0QwuFv6QSIEqit2yD925x37U5tVKKu1KNfzjeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aeRNnXTazBsLlfXDKYpe5iuwgRHbkxLQ+nvMcQDvtOg=;
 b=YdVyU48//lv3miKMzOTBi6ZRRQcz2hfz/WaNHGaps7zTdXzMemj952VpO93TaaoEltRo5ftRhAwLHhpWm7AQEOnPeVdw+IQbey9vyN5+tQ4dt7y4GZypQ+9poGkoFbq3uiMZqPAroLAVwsxOJOcxncLo3wDnCetprq8SnTAUZolDHS0cMmW4qWTXXcSpyH9PcZH0z44xmpuD3XcvOxoxzrahvepNgI0zYCG2jBbuL0l0tn5BGKGu0DEx8+RHAX5t2YmoyQXZioxzzlQaNB0eEn8UKBmwXUCFT9pe59Gn1yinSxZFJhUdKfeTK+mmVffusbosV1USlhMwGfq1KQwt8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aeRNnXTazBsLlfXDKYpe5iuwgRHbkxLQ+nvMcQDvtOg=;
 b=DoyXQ66o+j4759zPF2NTP9aBbEZuKcbmrqM9W63nynr9goZWTXo7e1nHldf/TRilyS2rph1UCLl5HRl02A8+h2JvB90WBz26dDxGZwr80SD4kDAPVUW7jEmOFJzZYM9ce7aM+2Delpbfd9rmzwy0Wyt2aLUV0DjVDcPl7Hm7xM/gH/9ExXL+aenD3NjpszzbLjx9proo4W5wy/7qx9RbfRmqKeuFvzbswNHYLFKr2KObXwWqD/66ovAj4W13K0tCrs6UPyFl+8Owu0Ty76EQtw4bN1D5m+dv/8q/qDuQGUNIiv0FCxHIRkUPh7GP8edS5SAh1wlFBaASCmRNDoamLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR1201MB0100.namprd12.prod.outlook.com (2603:10b6:405:59::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Tue, 24 May
 2022 21:08:17 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%7]) with mapi id 15.20.5293.013; Tue, 24 May 2022
 21:08:17 +0000
Date:   Tue, 24 May 2022 18:08:15 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v8 17/22] vfio-pci/zdev: add open/close device hooks
Message-ID: <20220524210815.GB1343366@nvidia.com>
References: <20220524185907.140285-1-mjrosato@linux.ibm.com>
 <20220524185907.140285-18-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524185907.140285-18-mjrosato@linux.ibm.com>
X-ClientProxiedBy: BL1PR13CA0438.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::23) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b23888e-f848-425e-c439-08da3dc985eb
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0100:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0100355EDFA7785DE9DB5BD0C2D79@BN6PR1201MB0100.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sItI+OmaqXnNi2A5z4C9we0tvTRNSy/VODd1bdhHrw1GgNunaiKa5IOZbPH2vpCuDyvrRjqDMFHIBgkEENmojbwVjabeqlKyzXosUI+lPgsLdUQ102V9zVNZ1WnN3h49GX3/oTkvoD0efP6/yHiUpYJsYn6VJszqf+DBqNrtlg3pLlD2ULTpjblk0seVCK9ery3TObs7qikTt/umHco4HXuhNEMJL/Cx907OIKXngZHUNizB0rsYV78JLknGAERvMwhZFmEb92USYulLyzdeQGUyqD5c8w6Zbmt/mb3aA1LyQPbyxmtCwfSANhAjwBF1WL4ykhQSv/HylyQCdacJi1BjSo8BwRx2gC8lFtza3pHFxR5XBPRaV1Ub1ZSkpPI6owoR8cPPY58bAVboP7WAghmHnxop3M8YaO9M2uHy7XDPfhByUnWEw06PTAdJ6fS2o7ZjKVCv7tYmMAU+PMwcObUwzT5P4Z6w4B4q8Ecpzs+nAq3oRqCe/KpV2jyjsF1+Xsogum+8eVDRfoG07Px2U9BIzoXk4c3mYz0CgHMfEoj6fc2cA+OtmlK55PRaoqcuCo+sNadBPF/MgUVhtIjp0O1n4dnl5mKoDbRZgfhtNmggtZyeFIIWJD3AKHsv8X4w6gwyzJswoTAxlDJ2oWCxjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(8936002)(6486002)(1076003)(6512007)(26005)(86362001)(2906002)(6506007)(66476007)(33656002)(7416002)(508600001)(5660300002)(186003)(38100700002)(83380400001)(36756003)(66556008)(6916009)(4326008)(66946007)(316002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9h3Remy3aRyettyY/wHDmL1h8Tnw9WcH98+tu0qxPh10Nn9gNuoDsZ4kH/rz?=
 =?us-ascii?Q?YCQyR2yFjJWlqfev2cvBlSManSPnKPts5f0imoAal3x7GdgJlVVq0z96WGMm?=
 =?us-ascii?Q?EXxHwwkdGUW0hnWfwz2SEMRwklQMTv+z5tw6+4m6DSjFbMF2JOHcWCMfMT8Q?=
 =?us-ascii?Q?lQLwJyC2gHCTIZKTgN+HQ5WJ1CL5QMY/jBkA6ubhf5aHopWhhEBevvXR5H2H?=
 =?us-ascii?Q?4sAIpQne4w4WEz2egqHNjQvLMa8ENDnT22Q6TE9lPQvK2WM4bIvDc9g5YAyT?=
 =?us-ascii?Q?+TmTpUDoyIoDDrvs5Ol13AYQAdCKD7I1KZmVAgf/v+NgbcYj94bISNGMaubA?=
 =?us-ascii?Q?cNXctUJ05dmcSZbr8DP7iZr0lpVFQhC/io4L6/nOtALiSrPeZVB/sWpkeFcO?=
 =?us-ascii?Q?bF7oyHPQjNaQapYiBYS0zaQKKiPtzthLJ53FP/8YdsIu1clgAcnOGDMp1UbG?=
 =?us-ascii?Q?2cdWRcLu+UCOQ7iu/8hof+qY5B5qwcESVCu9GGxey8NIZ4m5h+AZblIGS3KY?=
 =?us-ascii?Q?4TDG/ek1Ke/Y6P4F34TLJDocVEwbWJsviaQwtEg0JOVEmRcF8H7kkc2wiba0?=
 =?us-ascii?Q?EWPZiAVmdEvUq6iBNhSQ/zeS40KOOFcJSlyoARm0R2YuOEZlslveZpO++Nyl?=
 =?us-ascii?Q?hp3pRzcRjTtCo8e35HmPt+sjpOBi0XPZBSsIsyl0bDGEg3HaqakjF3Af0gUG?=
 =?us-ascii?Q?Q0VUavOYwociuPF/TvFsn0VQNT/CHMmWfIeE3MjaqeDJxtyvnrLPHddBppUv?=
 =?us-ascii?Q?O02LS4zQWGp2bHLmmzjjVQ7sk4rz95ircYj6Tw7+hzZ4ThEQWIwxyS6KyW/1?=
 =?us-ascii?Q?rQgYMd/S5pgGSzUbflWVCj9BXGkGyd4SDvCsz5pHYGpBCXWGByJLQZaiInQQ?=
 =?us-ascii?Q?aXiy9X59smV/Q267vx5jQ0v531Qg3bsCs51JQu4VYlcneHFbHDIQkVpXFFE4?=
 =?us-ascii?Q?t3RL3Q3DHxj7+e9mRzJpTee8O454F/q/eCadfcDKAdK6gHzozOUL0yPWEN+0?=
 =?us-ascii?Q?b3Og8SRlBorSaAm4YIdDKJAETRjCkMaYyL/dZ7cFw0jOFl/OqmrAQfzuqwhn?=
 =?us-ascii?Q?AaUZX4CXlmkabLj8iz7yzQ3f+2WRdi0+m2vi2mS0e/ru+maR9d0/bgcaDW0t?=
 =?us-ascii?Q?9F3gGPy/kMr3MDfbmcVEgEgNmXBjFbxKg7l8ZeHxysHWz/InXAGm+6GBrjQ2?=
 =?us-ascii?Q?eATe8iEm+QD8QBo77VpiF8WRmhFLI2phOumQbpRxxynRCXjoHGDnTd3S62DY?=
 =?us-ascii?Q?0hA6SBECxKaGSAHQZvK704oD02jBpI2NfDOH7igHKB1wcsN5w4wVOHTTLt2J?=
 =?us-ascii?Q?w5x8kRCfKh4LHF7cOUN4nk5/d2ig+PAG8m5pLIphMECmXD5CSUUh/mMva7Nv?=
 =?us-ascii?Q?ABxNeLehOe9HOIdWYHMaNNFEhjJ2LujtcBYc1sqsn1xPsCXS4Rt8OyAAXT2B?=
 =?us-ascii?Q?9RjL+OFlRnLmEdewy1poShrMYqIOvexbc2qmJ/vab4Oy6IRJoDbB3qozeDUk?=
 =?us-ascii?Q?BG0irrEakZSJwMB6sRdDUyPgjpnKTBmEi2JDyDHpRcCBykZA8aHk6ecih8M/?=
 =?us-ascii?Q?GxRMA1fxuk7IloNReGKOsIZ571JsjuE3E3ryRAYfFqR6AQpfSrAV8ZjahJ4p?=
 =?us-ascii?Q?7Q61G9md+ODcW63GvwPCg82JHzI85Y9W5Rwvc+cFitvOfyGeJooXwV/4ngxf?=
 =?us-ascii?Q?aKOY8nz+Kf0NyL0+Yp98jsJkQKFjTWpfKAcQstSWlILhZMxUA1Cq5D0aJriN?=
 =?us-ascii?Q?/Bm+q3w+uQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b23888e-f848-425e-c439-08da3dc985eb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 21:08:17.3387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xEXuXPd60kGGE2yrgX8aWbhykT9WcKMg/fZv6bCynDJ1juj0mWNR5VNADF6TaqZD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0100
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 24, 2022 at 02:59:02PM -0400, Matthew Rosato wrote:
> During vfio-pci open_device, pass the KVM associated with the vfio group
> (if one exists).  This is needed in order to pass a special indicator
> (GISA) to firmware to allow zPCI interpretation facilities to be used
> for only the specific KVM associated with the vfio-pci device.  During
> vfio-pci close_device, unregister the notifier.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>  arch/s390/include/asm/pci.h      |  2 ++
>  drivers/vfio/pci/vfio_pci_core.c | 11 ++++++++++-
>  drivers/vfio/pci/vfio_pci_zdev.c | 27 +++++++++++++++++++++++++++
>  include/linux/vfio_pci_core.h    | 12 ++++++++++++
>  4 files changed, 51 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index 85eb0ef9d4c3..67fbce1ea0c9 100644
> +++ b/arch/s390/include/asm/pci.h
> @@ -5,6 +5,7 @@
>  #include <linux/pci.h>
>  #include <linux/mutex.h>
>  #include <linux/iommu.h>
> +#include <linux/notifier.h>
>  #include <linux/pci_hotplug.h>
>  #include <asm-generic/pci.h>
>  #include <asm/pci_clp.h>
> @@ -195,6 +196,7 @@ struct zpci_dev {
>  	struct s390_domain *s390_domain; /* s390 IOMMU domain data */
>  	struct kvm_zdev *kzdev;
>  	struct mutex kzdev_lock;
> +	struct notifier_block nb; /* vfio notifications */

This is obsolete now right? Same for the #include ?

> @@ -418,6 +424,9 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  
>  	vdev->needs_reset = true;
>  
> +	if (vfio_pci_zdev_release(vdev))
> +		pci_info(pdev, "%s: Couldn't restore zPCI state\n", __func__);
> +
>  	/*
>  	 * If we have saved state, restore it.  If we can reset the device,
>  	 * even better.  Resetting with current state seems better than
> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> index ea4c0d2b0663..d0df85c8b204 100644
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -11,6 +11,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/vfio.h>
>  #include <linux/vfio_zdev.h>
> +#include <linux/kvm_host.h>
>  #include <asm/pci_clp.h>
>  #include <asm/pci_io.h>
>  
> @@ -136,3 +137,29 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>  
>  	return ret;
>  }
> +
> +int vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
> +{
> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
> +
> +	if (!zdev)
> +		return -ENODEV;
> +
> +	if (!vdev->vdev.kvm)
> +		return 0;
> +
> +	return kvm_s390_pci_register_kvm(zdev, vdev->vdev.kvm);
> +}
> +
> +int vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
> +{
> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);

Keeping these functions named open_device/close_device wouuld probably
be clearer

> +	if (!zdev)
> +		return -ENODEV;
> +
> +	if (!vdev->vdev.kvm)
> +		return 0;
> +
> +	return kvm_s390_pci_unregister_kvm(zdev);
> +}

Again this cannot fail, you should make it return void, not ignore the
failure - or at least push the ignoring the failure down to the place
that is causing this.

Otherwise it looks fine to me, thanks

Jason
