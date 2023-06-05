Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCBFC722D30
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 19:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbjFERBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 13:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235098AbjFERBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 13:01:47 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85ECC10B
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 10:01:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WUdX5RwMtBtQqdaWCWaeW2ytKMlZ1/DL8zIEqF+iesqCwzr7jrkby/Fy3JKnSrz0KW4aGYA5fZ2ckEaR2p9UjY+McafTEaCpVdsbbjbtwiMYwrna1fccPSUhNyoVVu4y2k4/MXev4vKF8Zga4kCG9O9FdxUmFUllB0A8YNxCfana/rpm6bOKkupvkCnqmOkReH2BMxbFY2B9olYYY1Gy99zq6PatpCsV5j5f6uTUqVbLv7+f08X/YsXBExvUXvrfn28PBKJBm0cCg+0Z54f+mIdV41w5IBRAfvo3wHpPMYjESzbI+mMRFzvYNU45fJKyalwdsnvAw5VVoU7wYFCyxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRsYF2mzOqZO5LyZutNqXQRsV2egkS49sICCXshHpbo=;
 b=SSnVnD7C7NsWvPAYWpyDlnOQ4wH07N2X7iBioULIzGn17MJym+xe4pYlnsHG3NxYZ1uMK4rMSmwIVAWLNTZ1txkyu+nWT8fh3WyYjchZydFR91wfL7NqonXOEAFbQ6yq3Ixej9Nx3NjyK07GbqYErUdpPbZHJ3HIeSNk3SkdznMaGa2PUT3Rmyt8wyjC96fyyzVgQdj0tr/FmeZfBEvQnJw2zdXAtDDs+TUSw/hQmIVh6hEEJDYUqZILLA1U+IGI62Te2r2Qv0+FQRxOM1+wWVm3dy0gYaJn9v5xP/8hl0/LHNp+CDOikD7LgYwVMn9RcLy2LugQ643YmhtnIiyOww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRsYF2mzOqZO5LyZutNqXQRsV2egkS49sICCXshHpbo=;
 b=P3aJiwkNj49mKfpqO9Vjd3XdErs7htiCcB94KISspdiG8oH8EDaXuQ8va96dQFrHTOjCemNwQEayR8sTkwewGyvUMJFvK9PEC12azhchEZPigvk/cQAWhVRWnqBSJsDYYzHYwKBoIWZPZJ8edc/Rmi2L6kEK9GccWHkBWQV9pbJl4WqAYxxwtc770wZuu5UHW8f2pjJ+whbi3HACvCcda3pdDFLjyy5kSN0zSeYuJKNyYPL7u++FR4OrMgI4yB/cMl19/mEsdnI1TOTI/MlDI+m1Anxr7gN0diJ8SF6CtK9VzYqCjsG5JUT/TChRHEb98WPfap1oQ6yPmct2mooRHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB7118.namprd12.prod.outlook.com (2603:10b6:303:213::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 17:01:32 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.028; Mon, 5 Jun 2023
 17:01:31 +0000
Date:   Mon, 5 Jun 2023 14:01:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, clg@redhat.com, liulongfang@huawei.com,
        shameerali.kolothum.thodi@huawei.com, yishaih@nvidia.com,
        kevin.tian@intel.com
Subject: Re: [PATCH 1/3] vfio/pci: Cleanup Kconfig
Message-ID: <ZH4U6ElPSC3wIp1E@nvidia.com>
References: <20230602213315.2521442-1-alex.williamson@redhat.com>
 <20230602213315.2521442-2-alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602213315.2521442-2-alex.williamson@redhat.com>
X-ClientProxiedBy: BY3PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB7118:EE_
X-MS-Office365-Filtering-Correlation-Id: bc9fc189-9bf2-4e83-36ac-08db65e6827c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dp+Q3e0mwWNSPZolWMiVA7srPjgmnAp4WwzM/E6IO1w1zFrhtkeKUvNh8c/kLVo1ge3Y5+MWXB06YcUA+i68Zi5sucZwDCZCE+yJaVLosGPl+ekj/X+DObZapsD+EuIf2NWitslF9OkNuJP8FWLVPmOH3N3aCv7VqjpjeY247pZJn06+SduJZVQMk9wior4ej7DX0O3LoPjM5+0IQhGTj1WkbSKLZuITZ6Aj3tiL+b3jBSgGtO2u5lLv8ZYO1s3fjTwkC5JeFAuPx5Bpl3nHi6PCVDgZy68e4Os7nnmyg2i/yTTHuSmtrNjhm1SlIMMVa525huMCzCFViErOVJ81XzeFmE51Cbii4xDSOLaUwEpyxHupZoSyxZAwfF/JQQZa/55FuhTaPHq6nVFLDIlY1wpgBthT0E8JOaG2vswpUtPwOqxG1xGpz5Dg/+AVbAHGsMODvYWSjRiNHsUTUHuF2a7gBA3djUMY3iR/8Sc8z3dz4xe2I9EzsB+qKtrwGFZeNVT1Ge5wIOCMvQZ66mlradsHV4FpA9FHCvUWVpTqv6dT8gP69apNKIaEhm+jO9KN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(396003)(39860400002)(376002)(451199021)(8676002)(8936002)(478600001)(316002)(41300700001)(5660300002)(6666004)(6486002)(26005)(186003)(4326008)(66556008)(66946007)(66476007)(6916009)(6512007)(6506007)(2616005)(2906002)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HX8ESsOj/4lqtWLzyoPLSzl2TX/vaEH8D2MpXcSYA50FKFAxocogh4+tilVv?=
 =?us-ascii?Q?bSvIvtiOz1CsQLzyFsLoe8kO6i28hpeZxgSgSZEV01p6LwRB0J5WjaanMcDW?=
 =?us-ascii?Q?gB7wNjvHkQbPVOyi+zg0M5fktSMyksg41yC8gQnRByrXhSsx/QwqBO8FpJxV?=
 =?us-ascii?Q?RlgtffdLRwqzijNDKF8h5/TimVWPTND6bFPJDig/ISzGkkYnUeA3Ffu0yQiJ?=
 =?us-ascii?Q?i7t0IH4KfNaNhAFx0p+uA2xFL4i/EE20eM51+ftGnzynaa+vHVBVrZcogj26?=
 =?us-ascii?Q?JwXwLAxSpUn9M0p3xuFZUFHi0o+jjOnd8uiSDnqxbNHI3X4gXbafeHSrvCJC?=
 =?us-ascii?Q?XaW4S0DnE+lZw2NqgIufTz1rZX0Kz65ssjPXrzFD54I2lHsirzB5Hut6hsZ0?=
 =?us-ascii?Q?612pVGyEq0bcn9iyWeE5UAWS6nD50zurFSSzhar9fZjCvrIgcZ2L15S3k74Y?=
 =?us-ascii?Q?ir2tqcX2Ir89qv9wWRaJGR94559gyqE54DNNWfkV9cbxyCGUgUJ4XbmQeGs7?=
 =?us-ascii?Q?7g1hpYRAYS6L1fKoEOidNd/oEsUak8krGhocsrR5Dvit7nB4lpN9unt+PSei?=
 =?us-ascii?Q?wdoPzBdwC6QWVfiz1S86n5K+GgBcKigeQv9/JrBFRRwTpAe043YQuIvoKm24?=
 =?us-ascii?Q?y5d+ynnJ8D4T747OeN5wq94n4xGFBSQv6iKQJtjZvve8ARXDjMct502fPKBs?=
 =?us-ascii?Q?wV3T9pFPgj4s6ZDBh8UUd/BTC9LsKeWFZWg8mMqTEbXkOla8JGxdqVua/BAw?=
 =?us-ascii?Q?gK8hp9pMqBpho2HnJdxHfuFXMLs2tx0lYg5xDFs91DIO95W3NkIk7UkyLm85?=
 =?us-ascii?Q?1uW9uOieUSH6MI2y5ot4sIvKjz+UEqhatdg7xrloLkmE+4M1Q4KQGp1QfRdS?=
 =?us-ascii?Q?7lASnxepj0eacRFKHAPOzwy//JpxfGg4CJzf+CtI/ruP2Kqx2ZM9UaWI67f9?=
 =?us-ascii?Q?mgnpJlmK/mymn1Xx/nzh9iwjd1eWn1mokaI6RNg7Si+BwkY4J2M/vqTGQ0kP?=
 =?us-ascii?Q?Zkp1HxSbIgQ4rBNxxVeSlTu6YzxIlPzkEYX/Zhcr2a9HC3pmS+cG3MUjRmCs?=
 =?us-ascii?Q?ZGU13BZtvzgWL8SiNEbSJtDQ1+GZVBsVseth7A+7COMSYan1p9mDPZXy93S9?=
 =?us-ascii?Q?0NNEk2hBCcDIWMMlCUuFW7IK5OSpHBX3FNCQaqA0QZBqfAkDCN5vPMn0kCxA?=
 =?us-ascii?Q?vA+HbOiLt3XLrV1tjQh4+bWK1cir0a1eFUf4cL/2QM3ymETTEXKtTABHyz/m?=
 =?us-ascii?Q?ddKf8iWjPi8qe8U6ajVI12Hgyhtef7j47cczyxtlaYB9DafwEb79AuMdBxfR?=
 =?us-ascii?Q?u1SofjB4dNEkPv6gA3Fq9FeAePedksTYmYTsWcO6difmf616/8L122G4fCx5?=
 =?us-ascii?Q?zEhT3ULbJ/XnBq9W2v45P2OZRqTcWZ1foVpcGQP6gSawvx7SCKgykms7BsM6?=
 =?us-ascii?Q?i9aBNmQjptvqBLPSP2e2chuDz+Y+Ur+dMYDU1epLZ5PYoIZ5cDpNl9g+jRwu?=
 =?us-ascii?Q?vHqFGDuB6wZX4DvkDibT/WJb/OJZNWwJi3zSsx+WwKzgTqR+bdxKp3xBiUal?=
 =?us-ascii?Q?aNLIKMRrcHHKoTrPrnr7ttuEEisxlx1DQidJzSPk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc9fc189-9bf2-4e83-36ac-08db65e6827c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 17:01:31.1215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZMrLJiYp3cDLV7e7+wnPC2gADrZyAWBRHz+0S9/Gl5diRH1XpQ+bMiNMjlaMIsUu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7118
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 02, 2023 at 03:33:13PM -0600, Alex Williamson wrote:
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index 70e7dcb302ef..151e816b2ff9 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -10,7 +10,7 @@ vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
>  
>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> -obj-$(CONFIG_VFIO_PCI) += pci/
> +obj-$(CONFIG_VFIO_PCI_CORE) += pci/
>  obj-$(CONFIG_VFIO_PLATFORM) += platform/
>  obj-$(CONFIG_VFIO_MDEV) += mdev/
>  obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/

This makes sense on its own even today

> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index f9d0c908e738..86bb7835cf3c 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -1,5 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -if PCI && MMU
> +menu "VFIO support for PCI devices"
> +	depends on PCI && MMU


I still think this is excessive, it is normal to hang the makefile
components off the kconfig for the "core". Even VFIO is already doing this:

menuconfig VFIO
        tristate "VFIO Non-Privileged userspace driver framework"
        select IOMMU_API
        depends on IOMMUFD || !IOMMUFD
        select INTERVAL_TREE
        select VFIO_CONTAINER if IOMMUFD=n

[..]

obj-$(CONFIG_VFIO) += vfio.o

Jason
