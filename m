Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6E46A4A1E
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 19:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjB0Sp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 13:45:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjB0SpZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 13:45:25 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2048.outbound.protection.outlook.com [40.107.212.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306C61EBED;
        Mon, 27 Feb 2023 10:45:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wokyzg8Nm9Acimn9W4TvIARbevEawv7I061ylsQtWqC9TtDuGIUB54/VrPIdco/5EFaP7evl6Co6HQDI9uIAgdD5/wOf5/SUuj2G//E1bWMJy0wfV3VLlm9rig+o+Jm6Y1ZpiEr+NAulnJmPZNpvby5dVSzqNR+cwzBbPoNgnInvGRDcu22TZ0AInjiqGAWjSULSTb1SBYRGK7JhjGBlizyKTKwLKP0rprk/QiuCvchflUB/PIyb4SkUrZcEOJT7CjxLchjXM0L0VCzFcMFNB0T03FRee5hdFhtENEeAG/lD6IuPZNNQ37KIoHAs+fDwmDrLDzzdE1h3U6DQv4uAhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d+3AkV+ra+gPKqVMLviQCKMevwE0lzTbxLHKvBU9A1Q=;
 b=B+YKdgnbDvZr0+KaRu4ng49vLSxp/dufnQ6Lh4bwbXzHSzLT9cQQFLnjJytHKH22/AGaNsiC6INCtpcpCVFzp4dKZ7CiDsFlIXmQjCvS9ZsIOor8PnNXF88mp79nLnAiI8c9D1Q+C43znFPl7V9JYr5wR6yf1lv6Y41mUSNeDr+WBuraHcLM2jkRMTvMGDw2e2Z1h4WjjBkuHWoa6Tf948ESIMTtuPTrpPnsO3okCE75UQuHRIj+Vdhn+2MWINjb6PXRbgPIuxPReJ5RuFRLmW6yJ74aeO357QU0OWixgQs1it4sasVdAA+hj/mISMm3FL3poWDJ0gbOhQNM5RnzYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+3AkV+ra+gPKqVMLviQCKMevwE0lzTbxLHKvBU9A1Q=;
 b=hIozKr1FtJLAulreguhcCbGoEhxadeflNJUJ2alCabWW9I4t1AB1sWqPaJWx6suz+wSGiO+7c0ugU+1+U5580z0Q2IhiQjgjMQ3fenruQ/dPGnWy2kjHd0cr5iyJs3UEEjjZ1fcLYtZ40GcobyO8iybRWMHSCV+zsV4Ax95tpQJiAYTdO37WI0VkphlKjkYD6qzKOvAWHbyMwM8spJXe8NKdtJTMxZ/rwzCdvQtcPG+pgwhYrEiRNBRh3Wg+aedkjiiFSbZNEghLvbotS0IL9IWVk7Z8nVAwB604fdC4lKoolprUYIPa1MYzddAwT8GStgb9bEhit9R1uiTaHXIVNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB7431.namprd12.prod.outlook.com (2603:10b6:303:225::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Mon, 27 Feb
 2023 18:45:19 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 18:45:19 +0000
Date:   Mon, 27 Feb 2023 14:45:17 -0400
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
Subject: Re: [PATCH v5 12/19] vfio-iommufd: Add detach_ioas for emulated VFIO
 devices
Message-ID: <Y/z6PRVHShmtGFON@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-13-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227111135.61728-13-yi.l.liu@intel.com>
X-ClientProxiedBy: BL0PR02CA0059.namprd02.prod.outlook.com
 (2603:10b6:207:3d::36) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB7431:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a91601b-1d03-4321-78c3-08db18f2c60e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sm0xAHJ04bUvBueaLEKvQr/7G82RKMzsjbSIXmgrjwfwDzkQOetSkjSVbFXJmtVzCOykSxfSJ/YdQb1yZ8qyhNQp+iWBKg+zwDDpP/Hsg5H1G5aSfgxcI+aOq7/8qyY/4yy9rv+hKpa1e83gRmi7aNOYRLkMrQ1MaSnWuARB2xcZdg0310J3+2OG1aCTG72MFKMkNY4fliWuNDSBfxlJg0AQzeHHe3ztUD5Rr7I7SWrDCULKlG+oXwGMEQU2yTHFkDRoT98ooZjw5NnOZRrQQ0u7vGunstADrtuyDnRTT1HbFKEIQ1xrRfDOH6KqmVKW/zPTgWhDwBmtKPPOGmpm0FMhApW4bQuD0lCtGJkQsqUD7qjBMufJ156HnGp6V06oZ2oaoph8x4Zto2uur9XKjJrNCJyJNqdXst/i4MjAbiihx2ne5IhijQv8ybvn7CxG2YYqO2NmYB+aqkXGd75tMPLcHNyPmI1TPrpSX14oONFf2KXj2jmZPlobN9vDeQ0omiguS8Isd8ROIF5224JWkawRLt3SDwZxKnpUl1v7KuoDhi+iV+a/6AXlglYH2FAU9SZ8ntY52wkOh0RYa2nLIarJaxGr5OhesSdMQKyn1baJb7IIC1ge86YTudZscmMMHEfCr2Vq3ei3Vw3yu6sQrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199018)(6916009)(8676002)(66476007)(4326008)(66556008)(66946007)(41300700001)(8936002)(478600001)(36756003)(86362001)(6506007)(6486002)(186003)(26005)(38100700002)(2616005)(2906002)(7416002)(83380400001)(6512007)(5660300002)(316002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8Pbpec43EQNiFcGCfpH+tlAfB0UsuGNjBpSsyHM8h9FF2LKF0LgjwdYRmRqe?=
 =?us-ascii?Q?UgVB0k/KTC+JUtsF5cF4QICfrVZWPsSRZI/3UCLCL4lYsx0/KnovWB9GLWRi?=
 =?us-ascii?Q?Jul+Yj+gOIgf96LQt44NJwczQMgZSSdVj79SOEji0YIQb5iA8qj7lZ6dZWzb?=
 =?us-ascii?Q?zG8Nr/yFRl++9ql+YXBDUWgTrnuuhca6e/oystPh4ACGoUHmauFp/uN1GCSr?=
 =?us-ascii?Q?2invXNwOPy9XT8coJb/87HiImwtWSBdxdb6X1uPy8MqxSZlOQaQ5XxehkS3w?=
 =?us-ascii?Q?6EN8hy2RgR3u8EHFzqWuAHk/FaiglbhHDUvfA42PJfStNEzWp8slYaKde1Gn?=
 =?us-ascii?Q?BfR7NCJZRUS/5UVZ5ahCNqmj0bpMbhlN/Ed02qPSymL5uSOPXd20LJq8M+e0?=
 =?us-ascii?Q?tntGMkNwCAleJmfnEJuFtQ39X0TtbgYPZFtFrnJnvIvoj5l0r2cAf+irNAgQ?=
 =?us-ascii?Q?xIW8QwnshySOPxvdQ5JxszVenOuijun0RVLRPpEDtHz+8M62eFJJkV3E+ykH?=
 =?us-ascii?Q?CXLZSh9P+qOqWFthDxaEYkDBXZSucwRdR7Vk4aPkBLfukYljybefeIho6zjP?=
 =?us-ascii?Q?u04EFAoJm9wnUQm5v5ntW6desrTOUdws+3HXW51QlI5u6zzaBxEUX+Maqs00?=
 =?us-ascii?Q?8sbI4yB5O2l7BEday4DljmATTdQkfqQb+Cq1YMtfgkCVCN4ePX4UO74gSK/B?=
 =?us-ascii?Q?sDnz5tLLYdimpk3kBcnMvWdus+D2Nzs+7AxCZpqyltDtGNsar5ejayu5jhDi?=
 =?us-ascii?Q?fDVUK2t+eb9ZUFsG//VHZIubxnf5qewIc8hprKODuae7Qu/ZOzpyJr/ZZYD8?=
 =?us-ascii?Q?M28n+tObQ65r5HO1nQnowZrVJMWUeJsKUGHnw2b/BR16UcnyUqvOGXX+sQmM?=
 =?us-ascii?Q?OuramhQISzCRDzaSr6kbo4sUCy9Sf6zedJIlw15EGDVzT2ARkF28t+Hsq4Nd?=
 =?us-ascii?Q?i12l8fW+Estscm1aGV8FJ4lbu6flxsuy5Ekn98nA89QJCRCDclIUELOBe72W?=
 =?us-ascii?Q?NjswicuGdVyO42uO8lTioHC25gdMsOh5apt86KfWTh86PstZvSqI40i1nY7n?=
 =?us-ascii?Q?nPLxmnIgbxM/a/kbd1JUrU0ACHfpaCR3GHXb918JRJVl2lvBwPyXJSOCuofR?=
 =?us-ascii?Q?Q36PwK095qhHG4mHp6H4lHTSpRyrLbff2rUSSA+T35yN2VGcb0AIiu0KmmoH?=
 =?us-ascii?Q?iAPzm4uk0Qo8DzHsmNbzG+fmNf+10W5ecypwFOp3goITT69ruCMasoydmMqy?=
 =?us-ascii?Q?mdbloexjCUOMNn6LJXY5a9fkeZWLP/DPEs8Mz3YrgfFKT1LGawtpLozyA2Sj?=
 =?us-ascii?Q?8vQpeetZJNRcUzGQB4r5j2ZAZkaYRp4JBnGmeC2onhZHPMxKVMfU8coxNI4V?=
 =?us-ascii?Q?gtLo6DceqVgqjiENT3jSL7/KfJn4bQBK1bXTG3/HLBda+yHUG8QU2qNAVeiZ?=
 =?us-ascii?Q?iOE6zkzu/6RUoHpNLVnaxODMtyM4sPVJpO/j0r8q0BSjJGHh1wNovSC94Idr?=
 =?us-ascii?Q?UkF4ORaUJywW3ClR2FFoUgHCb/gLyAUStD/BVZG2RH3SJA3AkNrtx7pzsI6G?=
 =?us-ascii?Q?kgTU8tssnTlkA8AkdOM94lEv7f2w2QYfxAFes1ry?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a91601b-1d03-4321-78c3-08db18f2c60e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 18:45:18.8764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j1KDYGGDyAcAPyEeCW0QJQAlf5KxLFeMUwuVEWJz8Qllc/N8Wy4MbkjtdS4H0mJu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7431
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 03:11:28AM -0800, Yi Liu wrote:
> diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> index bfaa9876499b..faf2516b0f06 100644
> --- a/drivers/vfio/iommufd.c
> +++ b/drivers/vfio/iommufd.c
> @@ -165,6 +165,12 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
>  
>  	lockdep_assert_held(&vdev->dev_set->lock);
>  
> +	if (!vdev->iommufd_ictx)
> +		return -EINVAL;

Same remark about WARN_ON here too

Jason
