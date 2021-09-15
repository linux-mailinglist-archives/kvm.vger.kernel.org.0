Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D7140C5AF
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 14:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbhIOMxL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 08:53:11 -0400
Received: from mail-co1nam11on2043.outbound.protection.outlook.com ([40.107.220.43]:13181
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233139AbhIOMxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 08:53:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPHhwIXRxKI93tW/YgzBXWa08qdHt/VCyNn96E9BVKtsRFSh/eSEQWRFonQOEGK11blEGamqNaX0xtuu+L4/sQcFa2Nob8KxopeHCGv9mwv1Z1nQv9CETbraO/YZfWp9GbLdoT5+Qp0pIv1yT1t3Y8JQWXk65RY6MY8ykwTmfR+Sxc2as6T/Kq5dNH/n6tBLWZ5IeCqYTRcmtGBI8bRn6i778VpLMQMSijdYx7LOgbSriYqSLogt+VWX42CZua+P588RiXq4gtSBKkHARtSJ6o/QXmFQM8QFlZfXISdvjZvZ1B5p5TNFhcSDnm2hHgZKVfi059/ZJcbRbhjwqPf5OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=WfZEAQPfAum67/FfNLP2VYOgfEgslR59rkcRAaYVVrE=;
 b=D3vHvjYIzEzMXVclX7aDg6FEWPPtSou4B9QvE3+pe+pDi86ooypPc7aidA4PLGqb6YXBl2olzWakgLYV/fGugd02ciSiMFBwHypxDuYHvj/NK5lwGaOZF2AZ+ARtUrD77Dej9d242dRf1MrIAo4V8IyZH3IAo+17xUo1tJbnf4Ax8tvEM3kNlM4lIkYtWGxxqIR2ejI+AoXvIpXrwmh6VGb3aq3TXbSnt7JUwwm06XGn4ua1uFBjMxaloaXNQp8OJ2uH2wepe9aDfS+/tQcK0IczENy0NUqTF3o+AIM8YBgG/ICoxouu8KJo1LZMfO8v+aNRYcW3F2F9DHm54sY/oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WfZEAQPfAum67/FfNLP2VYOgfEgslR59rkcRAaYVVrE=;
 b=WFNnqI6/iVVvo7rR4PNGLMQksC/1iaskz603ztpYQGOlyh8JBIiIsoHfNAqlcr/tiWs7DhQzFcnp2Kt/xm+KjSuAncTndQ09YiTgfxPxIltLM6XGAO9ETaYB2pcDN0eNxmxL51TEMDGuXyy7ysVk/wDHhQVi0NGPtKEh4qfWl2+a8tjnsq42xgMVGtlnWVRX2KhfqA2SdeO+3R2w4POBmt1EsVuA6RGfSxDH3AiCJxwE8GeouEmBWMHN+6WZf75pZkMPDl59C8PtHiXz6ojMbH0HEsHrMNPacSkVYJ0JW42TvRdvEa+csIGI4bqtwJIRtySaQiNEDq8ZPaprlEGVUw==
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Wed, 15 Sep
 2021 12:51:48 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4523.014; Wed, 15 Sep 2021
 12:51:48 +0000
Date:   Wed, 15 Sep 2021 09:51:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, alex.williamson@redhat.com,
        mgurtovoy@nvidia.com, linuxarm@huawei.com, liulongfang@huawei.com,
        prime.zeng@hisilicon.com, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH v3 4/6] hisi-acc-vfio-pci: add new vfio_pci driver for
 HiSilicon ACC devices
Message-ID: <20210915125146.GI4065468@nvidia.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
 <20210915095037.1149-5-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915095037.1149-5-shameerali.kolothum.thodi@huawei.com>
X-ClientProxiedBy: YTXPR0101CA0017.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YTXPR0101CA0017.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 15 Sep 2021 12:51:47 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mQUOA-000s8X-2U; Wed, 15 Sep 2021 09:51:46 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7f1d142-14f3-4464-13ad-08d97847947a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5304:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53046C5731801DE7419FDC04C2DB9@BL1PR12MB5304.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JRUj68FUNOVNTlFLCwcXnmMpSNdRKy+bPA02K4rpjIWR23xLox0HC4JAMy3s+DEt0KEUZvieUa0mFM6mhMhaqjozEcBGLnEXNLVPIFcsgEEHg/ehjHfbnpr095dVIyVS4ok8Z8ESe1kMO5KnYdc2jxIXZRDP7AFKHxfNaHKavPy1ZqtHCkuiNGqsP/+JruHjDhG/Q5qGl2Itly7NNsyAv9dohrZPLykXfh2vc3JFFlxNg5DcWlS7N1OREJ6oYyATAZqyVSUygz2XVRT3pW4jDyueg8IHYFaJBkC/w3Gbr2TMDCpeROaJkkvdSOrdC1Xb8hXgtQxKWRRdaBqe/dg7X7iBgEapXJGqLq5QyFeEkvFjdUoeucjPR3209zkppuVpVFD+mwfoLqo3Uk1GMe3bD4RXk2GVAqxSFfTwe6dcGL0OoShYngwuOQEzfosgHIwz6eXVo7XI8lORrfcB1Oimz/wzPzBRTcefAiRs/nb6vcmRoMI3BXbXadsOIAqE798wSkG+dnaKEzc5vB8BwBAMXF9iFuWGJv9COuwxMQUnuPwAK1wCmDdI8feNdSXXfzGv1CvLeti2smzC/P9O7EXUsTkE3EPhhj77VsvSCzMF4nahSGeSzj/r6YUsatnlMbPnmzqCxibFuuHxIJyw6iHyKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(5660300002)(8936002)(8676002)(478600001)(6916009)(66946007)(1076003)(66476007)(66556008)(7416002)(9746002)(36756003)(86362001)(33656002)(2906002)(38100700002)(426003)(2616005)(26005)(186003)(4326008)(83380400001)(316002)(9786002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iYgouChASin7p3CKCfx0jsIN/1LT0fVX8mmEIvzVP0N5iZ69M7nbUjH5aInu?=
 =?us-ascii?Q?8g40zp0SoJJVQrHD4VYk+rEfQqaMdeGVXxFhDVc2V3IsQ+yOyC642jDM5Il3?=
 =?us-ascii?Q?l3ik7vYYYIEbAgsVAFMu+1qH/9Zu7jmY6u+240kGnkz1FTn3btU7Lg2gPzAy?=
 =?us-ascii?Q?4LnfkFZAZSXKA6WUjMa9E7j1bVmi6iaJO+sCN6nTJu1W9f3LlPi84PkwFu7/?=
 =?us-ascii?Q?+29TOZmuTukLP3dd6EBT22AEvoRb8VnM3EmPDqcA0/5xxxwLsQ6WUG9piy1V?=
 =?us-ascii?Q?NKyY9V6j7HubZhVQ4jjHOFb8P31FEUeKfI6sneUOSAhL8yueIFEZXGXX5JKM?=
 =?us-ascii?Q?7WUcYoQTgD8YSJwUjmTu9E+WOdQmDFU8gJAPRd9NHVvaYcGA+5rax8Vv1Wqi?=
 =?us-ascii?Q?b9+WqzUq682gSo9NhLrs4ON1hPZ83jPRX6CZp27S5NkMzlwADXBm7KLIhRit?=
 =?us-ascii?Q?tl6BaDoWV+uEyaswli/26lGp4qE5s9EKOw2usXFPnpCkPaKSJY1qt/r9fCht?=
 =?us-ascii?Q?iJiHIpBM3i1vXsFmWRXBmu92aj/tKZrSIbPgKLrFB7bgPPwiHTofpbm2vOPf?=
 =?us-ascii?Q?vjn6+Zba3gYBgeIzMx0jpHlDWrfO+/2DeC8sEDR5zmnLZqFfj+l9xRd7emjB?=
 =?us-ascii?Q?8WsqMYMwtlfY+ejJkuvYgW+fqSXw6nTTZbfOFQL8YqZAhfsbB5+4vWyVix8J?=
 =?us-ascii?Q?kZ34QA9jTO0JLGF725KejeEtWX5qp+mD3pWDbEiPhuN6paBPvegUcqaNe6tG?=
 =?us-ascii?Q?j+hW+2ezC9t/kkZSTwASiTF8CUNioHCGU09vydTYqAZEMPWGZogmsgR/NXqI?=
 =?us-ascii?Q?sX1CwZw+w41lQPIlllpVGkxnK+o7qhqxERlaOHjQXXCwc+WYKmNRCwjqDrig?=
 =?us-ascii?Q?64Jz9fb6Le1a10Ton0psqQHQeHGIoK+AqVf9NezTj8QbWcmeyYVMCEzW/lRo?=
 =?us-ascii?Q?cT3LQJEMQSzcgs3JldZBlN9nWUwnSUAnvRQS5gYJJ67ueYAdlubH/06Hvb3i?=
 =?us-ascii?Q?Wtq55XAbgp+nybf/Z6YbPvtNr9LjaQ0cyi0Rcb/nAM58E9IvoB87VEfklbeF?=
 =?us-ascii?Q?EvOP0pAahNctcet8lMJo2PgJNT3e6DPj2x7bU1VQ5MQj1s7ckBi4DGR1MhTa?=
 =?us-ascii?Q?6+BjJvmNTL8m5P3nVfbr/XiFm0e6LFtaWwKaqA/5wWHFdCjMvgxaFqCmQmN5?=
 =?us-ascii?Q?YIS6aUzOqlfWFxxaiaUqGehYu1TAH6o0xMGrckSkWv+bsj3LaBDmo/Kh7Zsv?=
 =?us-ascii?Q?1KLk0QltR4wdyYGfzlXDVEgyj0p/laA5kmrAdd3KWffaTRsctbA3bbCVzTtT?=
 =?us-ascii?Q?mUyvbpOC71l3AcHmpaU44hcV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7f1d142-14f3-4464-13ad-08d97847947a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 12:51:48.0248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EelXkKUY+WeuaXSt+RoQnZiuAwu5klDs8mbKTTh8yYbilLFyEo3N0G9ORgQaXyeV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5304
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 15, 2021 at 10:50:35AM +0100, Shameer Kolothum wrote:
> +static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
> +	.name		= "hisi-acc-vfio-pci",
> +	.open_device	= hisi_acc_vfio_pci_open_device,
> +	.close_device	= vfio_pci_core_close_device,
> +	.ioctl		= vfio_pci_core_ioctl,
> +	.read		= vfio_pci_core_read,
> +	.write		= vfio_pci_core_write,
> +	.mmap		= vfio_pci_core_mmap,
> +	.request	= vfio_pci_core_request,
> +	.match		= vfio_pci_core_match,
> +};

Avoid horizontal alignments please

> +static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
> +
> +	vfio_pci_core_unregister_device(vdev);
> +	vfio_pci_core_uninit_device(vdev);
> +	kfree(vdev);
> +}
> +
> +static const struct pci_device_id hisi_acc_vfio_pci_table[] = {
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI, SEC_VF_PCI_DEVICE_ID) },
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI, HPRE_VF_PCI_DEVICE_ID) },
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI, ZIP_VF_PCI_DEVICE_ID) },
> +	{ 0, }

Just {}

> +};
> +
> +MODULE_DEVICE_TABLE(pci, hisi_acc_vfio_pci_table);
> +
> +static struct pci_driver hisi_acc_vfio_pci_driver = {
> +	.name			= "hisi-acc-vfio-pci",

This shoud be KBUILD_MODNAME, the string must always match the module
name 

Jason
