Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300736A4A17
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 19:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjB0Soz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 13:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjB0Sos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 13:44:48 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2052.outbound.protection.outlook.com [40.107.212.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E95206A7;
        Mon, 27 Feb 2023 10:44:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z6t45ncNJJRaBpRMTW5bbDFsXWL9DPcAcZ8ZkNt6i5+sFkLm6pmrx544cawJzLxayiC77I+YaZKq3OyDeEjOGmEgihL0iQmWKf1SiF0gPwDny+8vC0wG7R1thfErRQAY7WSMJSUk+50FNfvaX1P6yhuJ7QF0WtBZdV38bO2+5e5edqUm2QXMMFlIGOZhvDd1HwymTRsEUVw5P5yNVit8cVHIQGUJTBlpOJxEpGnmccsRuGv+hhuD2CrdQN+d+fTN7C8WW7m2M0/sQrcUJs/9b15++gTPk71B7sRm0bHqbkES93pY4Lt8RjytmCctBmXwfNQcO/pmzhkGZNRedEasjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XesbhYfw8f9EU5ZRioAjKjhtc0zOL5BhVXTCegGkiWc=;
 b=SwtuoVXi0lF2kfF8WW7c3MjV/gFO2rTBaso1U+FTJAsxYdswz4CcV4WxhQgRy1E9L0fv5XDpFxHx9gxjyqOcAlHjuJlH6XJI9F+2jj+oeY9GJEHdIGT62SJaJDr66SVxVAFCh3N7qBoRfohXRkKxpiE/i9CQKqf4Ie9ylqRFUgcxfo24IGf4f5UktdhhbYVz86iNkaXSG9U7z7H7Xn3yylKnMFS6AEa6IsCxlra/gkXF6zloP9lP+45HZzwfuNQP539LP2zu89RiqAyR3XeXRvPQHWelvoF7qVEm6Q2PWx3LjYEB7HCQFhRvr8Tgc8V7HiB997jlazgRD1BwmT45jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XesbhYfw8f9EU5ZRioAjKjhtc0zOL5BhVXTCegGkiWc=;
 b=HuuR5BBi3RY8ufH/KAeh++1ynbC5w/1y010QfR1IcAamqgryhpKQ9IIAaKbvwfrwJ6zXVIiFaVce5gxDHG4U7urapSPzuRFGhKOPkrAtkhZdxZO1mLORpsxB36PflKWIBqCqlAQbDCjJIqKgSwkzclp0qmHLwJ+CeS8cxzlgZIIShY6+eZGJr0NuTBhKS4DYI2BazRERvmPUhReNYIDwi7BAM4BNpfoa7kwbY0lDJD47Z3orUle6LaNyHETZE4chF7JO8japHf5RlbokNFKc3ipa4vGSep7P8wFJ2Xfw34eCwwJrCH5CBun9kqmDGo0QsM+Sq73d4fp0z0jUg/7eTg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 18:44:44 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 18:44:44 +0000
Date:   Mon, 27 Feb 2023 14:44:43 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: Re: [PATCH v5 11/19] vfio-iommufd: Add detach_ioas support for
 physical VFIO devices
Message-ID: <Y/z6GwZPfh2nFjpn@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-12-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227111135.61728-12-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR12CA0023.namprd12.prod.outlook.com
 (2603:10b6:208:a8::36) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH3PR12MB7763:EE_
X-MS-Office365-Filtering-Correlation-Id: 271e06c1-dfe2-4843-be4e-08db18f2b158
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ORqwfJjYWNtXEBw8NawQvbI3dUjlN43ZDAgIxE4Nb6wzipnpyp7ruPShKUDz78FMwoMT7MCi3DGUvAXq8r2D70WfJbVZUxYj38d5TqOxXqSIsAb6Ju5Ky1ISKK0GJ75VadmcPLv/sRTYEYeuwUS5qa7K2HQFW/kd9EBO174stClUvfrbAZqjRGsLUEVG1TGeUDh0LbqXmb4ryQR56KkfIRX++4pnRXIrMFaockbHSFtiVvLFA/ZL0A2AiSPizN6dnvUNkGpo1dux6murjtL0xxBFqw2eEPImmJguF4pVW9PC8Rue+B5E/t773BbSCmhKOkKSi4vaJvoPAkDHqhPpzwHNcbMIgxXnraOTriDZQkIgH79X7ecFQqlTFeraOINPb4M5ekL00hVKiGhFkeWiYp96fAm+I4lMIZK/K/8m3HhrUrg9SmGIPgxnyNnMWlxcdFNQ9LNAcWGvbRium1IybuVf1PCgkMjHedLTzTRzacs4SVi7/2lIrVGjcGijaubG58a/1rpxjl7S4kUtf4kHAtELz8qouQVYlLJrOYTIG5FRrl5sFNpnhB0Zs/akGxTbITkmbR/sUIpWuomNVGn4mi1hDNDCXvHafYSBiF8zzT86+50gkDL4plxQGZCoZrXZJs8YoR20cQRXYZLazZF/+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199018)(66476007)(41300700001)(66946007)(8676002)(4326008)(6916009)(66556008)(38100700002)(2906002)(86362001)(36756003)(7416002)(5660300002)(8936002)(6486002)(2616005)(26005)(186003)(6512007)(6506007)(478600001)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MJOQ5IxdPFF+K921DLDdkHMLJdAv2vvaiKe9Ow1Ffo63KScVmToMNf/J6zbp?=
 =?us-ascii?Q?WJ2wsDWJoM6yLVsjGFBQLwJJQF2SjTfRyc08lnna69D0M6f2MkW9Bpz+teDV?=
 =?us-ascii?Q?VJ2eW0Qas3h4kj+P8JVIbyvkT87POMFZsvAERNvYoICuN42EgTaX6qfLKYsJ?=
 =?us-ascii?Q?yB5uLFW2MzeL421HHKi0rD+5msoKZoGEpSc6zfWgWvgUFUddp3j0G4eV4nUj?=
 =?us-ascii?Q?/HRVAsdMzPg1Gtmn4nUwB7VYRmaBcp4J7O9Op0CTbdeWu5tMLlYG7ygKU/T4?=
 =?us-ascii?Q?vvf25yuUvu0Jw5C2tXYDE8FSSSF6a5fxphiTLGElKeoMcpKP+RwyHEx9XgFS?=
 =?us-ascii?Q?qB3OXquFA/Z2bFLrnLtkF2YyQcQrfMbciFCRqQUv7tuHRJt+AsTYTn03bcny?=
 =?us-ascii?Q?NldR/B3+sKz7Wp5ncjrodfCS2H4h3Pz6M2vUoJoyMnmc7dGGdAmzdTLWkGhT?=
 =?us-ascii?Q?x2tGMh3oja2H6cYSqC9BuwmVT6Rf43ZmxYy9KqJwZA7td21mLTZShoUWV4j9?=
 =?us-ascii?Q?oX/kWkXouQZ5u7knaWiOEX9X4o8yq49s2iAXcdMRQHc+lzxLXCdYnsr1JSGc?=
 =?us-ascii?Q?8v61gAfQ+Ufdl0SssCfLYY9cKYbWQgzAbbrHuXn9Y5LQD+1PUoHVwtCTIt0z?=
 =?us-ascii?Q?LPfF1tE9ulJ7vtwOS2dMvfsdH0P2c5Jv3x9BuS6PyT53pmyEW0mOqGGSvw12?=
 =?us-ascii?Q?p4jQk9o0WoeYh7aYZt3ojwMj8+nBfP/VNDXnlFaDMo4bdfZX4s38mtJY5poL?=
 =?us-ascii?Q?sRAljZXeXhs6h5eDCg/vepOKUqF599NI8sOtgQaTSTjdmhKz6Bki7ivk/TM9?=
 =?us-ascii?Q?cvJGs+oeQEGHwK6RACKPmHVI4fFNKEhYhyZ8XfjakiOsSEvr+GTuAcW2AHJl?=
 =?us-ascii?Q?KAfoyo4D5sREqoVzoBDlQeBBHCzgn6tGUD/jXB//DGSV1zPGD0UzJ6uMKhfb?=
 =?us-ascii?Q?Zey4arwWn1nx/HaUgQjnqZZag2mNhSKDyg9gXk0J3LTJnhEEoaoKZE/xoMhg?=
 =?us-ascii?Q?T48SnxwZ6SVY/Bk0h/WzNx/k7jeB7HInLYeAG8o2m1uLI8GeSGH2kwvt5oCH?=
 =?us-ascii?Q?E4BFRjjlOTJaq0U9h06fbZhF2JGpRU23Nta+iG8Fv6TX64j8LuclnocgV1wd?=
 =?us-ascii?Q?ZQ5iFDPqCUYTwzycP8RkLb+SRsG3OknJnVwSTVBy27NtfiGpSGFnTQyhnww6?=
 =?us-ascii?Q?nHTcnM71oS8hZV9ocEKmJLu9Mf/BKjd6ttalx+qvszGypDggFtlbgTyg7JU2?=
 =?us-ascii?Q?xTUe00Oi78jn2seOMmtYOKXhg5RojxWC3KV6WkoHYgQncxbEuRkGb+ihTFXL?=
 =?us-ascii?Q?5590v7voNBytI58CML1RL7b3QSSjpYZDCcCm8wyg41qJPpw9Y6aVMi5QFATo?=
 =?us-ascii?Q?yydRewzLxUVA6QlXXssOz+jEDkEvBxMVuGbNKSNm7kELnOHrm1uDEq9DRbs7?=
 =?us-ascii?Q?/YttKLHjtA456WOEmCywFboYFm1aXfnvDR1kSj2enpc8N0eHhzCKSZ2Ltm40?=
 =?us-ascii?Q?kQAOMcGPBuK+C0jHSkfZMRM4pKLoP40GSIDHpEJSaXAl79tv5QDL7s8DeSUc?=
 =?us-ascii?Q?yz3mka0I6W2LZEFeucNYG2rh1Iku48ZU0kbShCzA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 271e06c1-dfe2-4843-be4e-08db18f2b158
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 18:44:44.1623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KlEG7Gr76KP8BHALdsPdr5S4ObGFVEHTXqtNiCBGrY+Rpny4Dyv02ewschh6Ubq5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7763
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 03:11:27AM -0800, Yi Liu wrote:
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index c89a047a4cd8..d540cf683d93 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -594,6 +594,7 @@ static const struct vfio_device_ops vfio_fsl_mc_ops = {
>  	.bind_iommufd	= vfio_iommufd_physical_bind,
>  	.unbind_iommufd	= vfio_iommufd_physical_unbind,
>  	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
> +	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
>  };
>  
>  static struct fsl_mc_driver vfio_fsl_mc_driver = {
> diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> index beef6ca21107..bfaa9876499b 100644
> --- a/drivers/vfio/iommufd.c
> +++ b/drivers/vfio/iommufd.c
> @@ -88,6 +88,14 @@ int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
>  {
>  	int rc;
>  
> +	lockdep_assert_held(&vdev->dev_set->lock);
> +
> +	if (!vdev->iommufd_device)
> +		return -EINVAL;

This should be a WARN_ON. The vdev->iommufd_ctx should be NULL if it
hasn't been bound, and it can't be bound unless the
iommufd_device/attach was created.

> @@ -96,6 +104,18 @@ int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
>  }
>  EXPORT_SYMBOL_GPL(vfio_iommufd_physical_attach_ioas);
>  
> +void vfio_iommufd_physical_detach_ioas(struct vfio_device *vdev)
> +{
> +	lockdep_assert_held(&vdev->dev_set->lock);
> +
> +	if (!vdev->iommufd_device || !vdev->iommufd_attached)
> +		return;

Same

Jason
