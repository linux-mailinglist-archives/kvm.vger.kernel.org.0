Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323077C8B58
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 18:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbjJMQT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 12:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbjJMQTL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 12:19:11 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBC946A8
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 09:14:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FaVWOyFmPe4qgRBuUUz0ZszaQfEIg7usGWMk8+1uXr+8vZbBqr/B8tS1CbisGRcGsnsKGHpiLbo6roB1RYAEZNaMDZ6rYWJ8+Hel0H6NIBSn72HQ93XpZSwfmGXRzOePR5uJC70kVh44cP//muaJzW5pXlz1OkXl3Iv9WSdBQlfuLq+Pa+2xp6J7lktQsCnpBkT1sMMqUo0CPo65AdWVFqy4RqOAdAOcqGz5vuEqNCrjz4QU2hsihaoPyCvK0SFYo9IicUPJBlaWP5mQmXbP/KH3At4MjMaI5QL8a+fK1KanZ+0Qddlv+e3IYIhsdFM33GOSGJzUR8DNodtTeBn53w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+hBcLHSn/efxZc/Ip6DrLhbZFCqXxRqb1zeTmftwTw=;
 b=jOHycTYwBzTxDDI1jvkiJzMI7RdTVSAKnvVF12CN6wssvrbARb7FtLDJ8cnaBdioQM3SKJpaC8bGa7K16D/MfFxDRAMDZh4o+ObDspWqZPtTm0D52hWLdnFH6nhrKohaPEdnzXdx8SRrDd9CEoVZa038k+3b3MemdEgLPbCpU2C9mg9VgAKum78pX5cy9t5mKVlHas5+kzhFiIn20grC17dIPUp9+lbLPoUiffG9o1hA5MKVerIHamxND3nqFDbIaMPZY8ZcBemz3jS9/0Db6R98LmB81XfFjXHr/nwRFF2p7opYV1vHrznpqYwKk5sjIS4NVDIwGqOCck341FwKIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+hBcLHSn/efxZc/Ip6DrLhbZFCqXxRqb1zeTmftwTw=;
 b=FTXiz6tQPdsXdt7d/OoMOwbaZaAGxqletChoTzk/aIHwcNtIluScur5m152jWOWY+CvUiZYTkMPDEoCw9RSD4V22lGe2hrIk8gejaVnRXdssaeqw30xEcm5iDhyFpHE9APQ0568azelx7UJnm7XSztaLa0vZD9ZRl00IztkQ8vcjxekOMj1m7P0/waWMKqN2xzhM4C4L5F4qNadNycMOV7uhg6pg4pKQOEnpXuD9MlAaiRMu81Zvf96Kl0eSOj25tbBuOxtjZsaYuKHVD1nfiuoCaeohUknWAUbrnEjbkh3tsGGgaVIIvi50xPa53xl3RoXOS/YMXN35vK3j7ta48g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6774.namprd12.prod.outlook.com (2603:10b6:806:259::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Fri, 13 Oct
 2023 16:13:53 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 16:13:53 +0000
Date:   Fri, 13 Oct 2023 13:13:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 08/19] iommufd: Add IOMMU_HWPT_SET_DIRTY
Message-ID: <20231013161352.GD3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-9-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230923012511.10379-9-joao.m.martins@oracle.com>
X-ClientProxiedBy: MN2PR07CA0010.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6774:EE_
X-MS-Office365-Filtering-Correlation-Id: 110cf40f-cda7-460e-51d8-08dbcc0764a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MX9aTX+RXlq4mrN64LUq2tr+36XtTsyyjCvEV8k2MIzkjf/HfvMjdzrqEVArVdLCjYlmc2QqOX7auLAQX1UcZLY6apFkI0WkSXn0qJBkft2YaAuli3MQf0e7jYctlgdoSlK3tMFy7CZ1zWvNk/lhWMujt0sMA/GQqGDNLj+9dhUOkiIqjee3rk/RbQo1WWueWFQJ3EV4zfbwyb7ck7uNW5MHcYeGE2AJs1UFrVEVHSb1HAfZSPUi/hg14C/tTbVACXAgVPpWnP+vrguW6GSwGpZtz/onfc+WsAd6tIJDyqLEnDE4qozsREqzLVjC2sZM0MXUa64wJuiyMFndUMVb7qP1fcqw6VZLd5VA8TaaDVDo8O7DOTu7hLr1XBnkIb9kK7LHkMby+Vydoyi0EpQ7zVkefRNTYYEXhUdRjwb7Z4gUJYApzqBk36Zz069VI2Eu96PxtLoXinWNTagILG4IuksUkTSTJUDKnjzATMU504QMwf8bA3yfeLxckHvVUOBmLBFsNdCbbeDXzkGRrVfQbZp2fgvktNJGZd6ZD8LVE8XzFFniEz4MH7UeNhuHdj9WwBJzuGXNANcNkJRMRPSJHIrQxdMWWyw3Ha3o8tCvkOc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(376002)(366004)(39860400002)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(66476007)(54906003)(8936002)(38100700002)(316002)(6916009)(7416002)(66946007)(66556008)(86362001)(4326008)(5660300002)(2906002)(83380400001)(41300700001)(6486002)(478600001)(6506007)(8676002)(33656002)(2616005)(36756003)(26005)(6512007)(1076003)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YblRJPwKf+GeZrhGTSjuoYxuG1ABz0iM5GqkK8SQzdTdAvuLKA/hBW+u9L5Q?=
 =?us-ascii?Q?tr3F+WCd48q3kquiXqp81LWW7SDE9lj4RzgkSo/nmMC4CgIxE3s7p88o7Ksn?=
 =?us-ascii?Q?p6avLjBwJGEBsNslM0jwe4vOQPO5tUWJs9+d3PMjkR48TRFzGvam5zEx8CMW?=
 =?us-ascii?Q?Ap3upqYrl4poNGw5Zc/6w2gGbMcTS7qYgfXCgosZrP8Tc7guNZA6FihMs4Ra?=
 =?us-ascii?Q?nroBkmueXOQHA06lT0wvzWIkwwtgTcWLkKv/aTvkshjvkI9tiHjRlu3SWUNT?=
 =?us-ascii?Q?H9H1L3S0HfDS0x8JPBzGk/63gXnTPPhuWpopSTPXHCoadF76oLzogchXv96K?=
 =?us-ascii?Q?Bf7SU7NGmBoOq7gBXGfFkjHH8cnS7nZylSxSS7v0//3p0Cyz0DtPyikR44V5?=
 =?us-ascii?Q?mAdi7B+tEljwuYRBtolVBzOK6/WMzjwEXB/AQmBQWeDFIYwr/O7By3PdHGmX?=
 =?us-ascii?Q?utlpylP8kcDbhoKQo81XLhexTBWnpUrOvkFZlkk1G16O6OZX856bmxBbZ5Zg?=
 =?us-ascii?Q?ISJoemcmQwOT4Iy1OQSb3qg14B0ASNHUc8zhFxhIkIHAyX5Lcp8csWWWX9F7?=
 =?us-ascii?Q?u0FFpOq7NBha7qSW6d2CYmZbblfY2J4kPd3FS4yUpTiuSTX1yiJPNstghrGx?=
 =?us-ascii?Q?iFNqH9Zjd4jxlAhQKahqTYmX1QfFJB20xzPnXms/9YYUY4/JK3PTZh3mhLhG?=
 =?us-ascii?Q?7GjVoy/NP8sbttLdOSQjtmGtFW3NSmqZfIRxhjGA9Kzr9Zw+heXS7MsCnEfg?=
 =?us-ascii?Q?AdnezCXnhuHRXmh13BdXeEXZt+QTtwra/fBQtKDDcbbhZYJi/MKYIetuqFAw?=
 =?us-ascii?Q?9vjXe1nWW4YafmTeqhWPV/UjRjmoE8FlL2HatBhqEbncCEIFI+wMy8UB1rlb?=
 =?us-ascii?Q?Qi6T8YzLwFOCrS7DoICkhp7bU41T0fPSMoFEogId3txzOy4vSKJu/kcbFRm3?=
 =?us-ascii?Q?6Cr0E7CaTyqEwhXKCVvCTjQprt/N1Bh6SoQFOV3cL55lA9IPbV2d8XSe8ZZV?=
 =?us-ascii?Q?fuc31myv25I3OLaDYGxa5OnGuFQ06fYW2gVQQgcJMnrzdomya/gIkXMHzlIJ?=
 =?us-ascii?Q?1qmhyFFk08G6phyS7bRfBRwFnxqMXsyTupl3wiDKtTYmIjimEH7xGFx4MrtB?=
 =?us-ascii?Q?gGqr799458flDnnYPYHsq4UFwpZFdnTivw6dxQfuX7eGPqHai2KgLxStpGpI?=
 =?us-ascii?Q?leH35lZoNxsFmBXeXCzwMkDwqfjkQP9fhwgIH9uhyRuSf2L98UM6pptnKoUR?=
 =?us-ascii?Q?na2Eao5HOjnJsnxe3rnfw+vLSQOeEWyVTXtwcQZzugI5WSm1CEfWJ3FbAIxH?=
 =?us-ascii?Q?A/rKuK9T8E5Pr5ZMeDq8L3FUAoq3rlFZUp7iY39O1x2K6zNcEmGYNJ6BX9YS?=
 =?us-ascii?Q?3+eV7eAE3Dbt4t9g4Ej9nlCRFHcJ6sUfFMKXFc60zBjp67+kj2XbcTZmCKvJ?=
 =?us-ascii?Q?yrP/T4svhnwMG+1lGE9OpjlGi0jFuisRazcX0caQbWpyBCPWwu4S2wVsOfPv?=
 =?us-ascii?Q?pTnnwgAgD1N29IAIT0XpHmPpNmtQGQp8fRBhFWLckicVaCMRwis7Dotk+lWI?=
 =?us-ascii?Q?NcE2iAX9+wl321qzacOeMcuP2E+UQciJYxmao9cc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 110cf40f-cda7-460e-51d8-08dbcc0764a7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 16:13:53.0754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R9XX5zOFc6u4bBJPi00McwmkkerISd9TjbktKLsvQbPIvQyWorGtepKVgSy2+Dyk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6774
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 23, 2023 at 02:25:00AM +0100, Joao Martins wrote:
> diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
> index 32e259245314..22354b0ba554 100644
> --- a/drivers/iommu/iommufd/hw_pagetable.c
> +++ b/drivers/iommu/iommufd/hw_pagetable.c
> @@ -198,3 +198,24 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
>  	iommufd_put_object(&idev->obj);
>  	return rc;
>  }
> +
> +int iommufd_hwpt_set_dirty(struct iommufd_ucmd *ucmd)
> +{
> +	struct iommu_hwpt_set_dirty *cmd = ucmd->cmd;
> +	struct iommufd_hw_pagetable *hwpt;
> +	struct iommufd_ioas *ioas;
> +	int rc = -EOPNOTSUPP;

Default is never used?

> +	bool enable;
> +
> +	hwpt = iommufd_get_hwpt(ucmd, cmd->hwpt_id);
> +	if (IS_ERR(hwpt))
> +		return PTR_ERR(hwpt);
> +
> +	ioas = hwpt->ioas;
> +	enable = cmd->flags & IOMMU_DIRTY_TRACKING_ENABLED;

Check that incoming flags are not invalid

if (cmd->flags & ~IOMMU_DIRTY_TRACKING_ENABLED)
    return -EOPNOTSUPP

> diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
> index e71523cbd0de..ec0c34086af3 100644
> --- a/drivers/iommu/iommufd/main.c
> +++ b/drivers/iommu/iommufd/main.c
> @@ -315,6 +315,7 @@ union ucmd_buffer {
>  	struct iommu_ioas_unmap unmap;
>  	struct iommu_option option;
>  	struct iommu_vfio_ioas vfio_ioas;
> +	struct iommu_hwpt_set_dirty set_dirty;
>  #ifdef CONFIG_IOMMUFD_TEST
>  	struct iommu_test_cmd test;
>  #endif
> @@ -358,6 +359,8 @@ static const struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
>  		 val64),
>  	IOCTL_OP(IOMMU_VFIO_IOAS, iommufd_vfio_ioas, struct iommu_vfio_ioas,
>  		 __reserved),
> +	IOCTL_OP(IOMMU_HWPT_SET_DIRTY, iommufd_hwpt_set_dirty,
> +		 struct iommu_hwpt_set_dirty, __reserved),
>  #ifdef CONFIG_IOMMUFD_TEST
>  	IOCTL_OP(IOMMU_TEST_CMD, iommufd_test, struct iommu_test_cmd, last),
>  #endif

These two lists of things are sorted
> +
> +/*

/** ?

> + * enum iommufd_set_dirty_flags - Flags for steering dirty tracking
> + * @IOMMU_DIRTY_TRACKING_DISABLED: Disables dirty tracking
> + * @IOMMU_DIRTY_TRACKING_ENABLED: Enables dirty tracking
> + */
> +enum iommufd_hwpt_set_dirty_flags {
> +	IOMMU_DIRTY_TRACKING_DISABLED = 0,
> +	IOMMU_DIRTY_TRACKING_ENABLED = 1,
> +};

Probably get rid of disabled and call it _ENABLE so it is actualy a
flag

Jason
