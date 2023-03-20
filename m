Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132CF6C20F6
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 20:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbjCTTLp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 15:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjCTTLT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 15:11:19 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2086.outbound.protection.outlook.com [40.107.223.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44597A24D;
        Mon, 20 Mar 2023 12:03:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lu3d9D26HgmsNw+x3Mmew0O1wDmBfhyXdJz6UQMYTubkeV0yagxx+CR2gHBmzhI1TcoRj9r1evIY0MXAYe+0eCJMTX0YYbV6OMhcvgZAa1f/iMM87MhhpIY+ta7hBuz+jYQBKB1oLNONtU7eSkOEjU75JAo4Jm0u0lhgJJDIGM1JygIhW6V1po/HHaGJ1UQR4NeyYx37mFEFfYAkjVKoqbt4ecirG+/212RhlSyoi34FoICk0GVcqzDWSBk6bSAErJbYsldXxlNchWsxb4B1IO2biNRSqRzJw/Lo5aYhic1tvbJ62ohccXx9vstJJPws44T9nyOj7uWEXi5psPGKbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d8dj1J0p8i/ep2Nv1A/HyhbNZAoyxVa363S8UUqPTkQ=;
 b=A5SR7QdAiR+6vA5VekkN87RA0/2kMvGL4wSUWztj6B3lkcy8P+UBRTKEsRi+O3vGXh3QXN3M6//pQ7hG7vQMHH7gYKorpunXBNS5zusziucaf4X69ckx7EWgQGyWMiosDkmi2W+GTMFUOkk8YzFtmbHVQ1oBdA2MtWD4+OPzueFvdIAl0lQNZ1sFt8gOCw0lUqwG0l16AjWRo4aZnpTuc2QDn/Gy7PH80NPxLiAcTkmfj5hIx5jU5q7A+8u5I9mIJc43c9UoLpuLrR5cWqS+boVK1S4rm91Oh0hrFt5v6jE5k5NOTUsF/s/Mp+5+oq4/DEPm4DS8VB+FCAOOvwXZOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8dj1J0p8i/ep2Nv1A/HyhbNZAoyxVa363S8UUqPTkQ=;
 b=OmlDDmjZKevgARzM/dtji3k+4ml6BWuw++u3DEQsk+BMaWanc+KZrcbZXwt2hJjmAX/lpbJKAWc3H23Ll9cqksw6a22IoGOKwQyu/Pn4Zc+0pZoTlqykzXS4sdrNspq/CJwNyZJ6kX3F/KZd373HGP7ziBkXTG742W3nTaQr8+PDgX6J6ElesjiTM7WkWA1cw14HL1EptwYlVkn7C/feU7c7sb2fgVTqU4RHUyw0mREekxBAULyw5VzjtQ56+XM1P6U5HFPhQH8Vdkq7KV03lJyeCcXBf5f8cZ9CM4V2ObCwfQ5ZOdEMx0vXf5QDkzuq+KcEuh5zo46KUiAPDZEcEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4536.namprd12.prod.outlook.com (2603:10b6:208:263::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 19:02:43 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 19:02:43 +0000
Date:   Mon, 20 Mar 2023 16:02:42 -0300
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
Subject: Re: [PATCH 3/7] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <ZBit0rBhEtUx7y0c@nvidia.com>
References: <20230316124156.12064-1-yi.l.liu@intel.com>
 <20230316124156.12064-4-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316124156.12064-4-yi.l.liu@intel.com>
X-ClientProxiedBy: BLAPR03CA0151.namprd03.prod.outlook.com
 (2603:10b6:208:32f::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: d20ab265-03f8-4428-79e0-08db2975af33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yWHeJXX08VGkWKwKsLU2B7YJ68cumB1Me5Td6OwZWtCS4WjLAbZJcJDOjY8b+PUPdVnwYxtqypHfMFL6gZoPPmdsPVuMaNw52hqQ4gbxRWeEEKKFFOtb/XHWKuOcb7HcxMXojuHZSWJB7cVYIxm7BspHi2/OMsuhXhMEsDdwpf8s8+/gFDN9tL57FnfrHJS7x3fqmnnzW2ADWHz2Bl1oft9pbJuFbisa3F9r4IJoW+x12/CzdojDHLEmcbDdFkURTIrLZznGwFmJ4KPbNV0wpQ9OyEtx7507YXZrpGvDMaxjt58ZXc3L8Lgp1h29nep2gAuX82C5YtukGvaOZDckqHsdq0MKBQZCTcy2lDyfcy00XHt/UTJVWQUA5qAD9zH8aMvqanIO7lSBcKHCRdeF8mKjkNq9jKIPhu1fOA8bLgJTckkaQ/p1DNY/qzZleeMXkoLEyWjyqCXvGod35FVLY28xZ4ExIelbl02i61y88EgILQ4elhc0cpAihrYqXcfyLV8r5bMReBOlt3SNTccM2T0Ao+rCHrwl3R5WB0baJhxidNa6+BGAT4v1tZr7h8C+lyvP7I/t7YMIFor23ALNHFPuAx4SWBYddQTNhO75s3NU21ms0X+5jxL/hnmTW1Tazs7BKJpfu/5oNZ99Xo/eyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199018)(38100700002)(86362001)(36756003)(6506007)(4326008)(6916009)(7416002)(5660300002)(2906002)(66476007)(66556008)(8936002)(66946007)(41300700001)(2616005)(186003)(83380400001)(316002)(6486002)(478600001)(6512007)(26005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GahSsnb2NHlLlZeAMf6gem075dXA3qrGpXvFZWXdwuMV8d87FHM3N6gYkN92?=
 =?us-ascii?Q?HYxboOQg0d/RT2t89TQ739spidHy6BDQ0l5rVNUT+zNKcCyDgb3YBtduG6y/?=
 =?us-ascii?Q?6dV7FdeWFi2vY5yawn1GQ9nztrW6vLIDlnnDWT1AKZ1akxJKJe3Bw7nRN4sq?=
 =?us-ascii?Q?1XCNgo5rw4FT/usqbJBaBzHbEPBDxUTH+KMXjn36wY+L2V/36XdwVpavuSuW?=
 =?us-ascii?Q?mG/W0quHZf7Qzj2EEck5Z8ETAhfRU7jeghx1KSsRHrDmlIqlIatrTwlPMdU1?=
 =?us-ascii?Q?4cWlH2BYS4IWEl6u9ZYYyb1N60rYI7oFyitnSk3DLsOlCB4YwYjYRsbK8pGw?=
 =?us-ascii?Q?mZgEIto1qefIvBrEYgo+qoUBlT8rqzt/LCaKzGG5mB7NqjETLtjxfs+J8Cfe?=
 =?us-ascii?Q?aT7+85llNRGIm4VLdsVh9o0nk9hwC/Jlx677cIKh27hrYkj4A/XuM3y9R+T8?=
 =?us-ascii?Q?PWP4U3LBuQyzJrMfmY2A2ARyLUzR09zUNCFWvEuSK0ugJVPNvWpTIBTQLvjj?=
 =?us-ascii?Q?OsOsPgSMIPXCkDzbSh60qEBGpTm+dwlMG3HV/8bfuI7RHtj6OFE+CuAmBcnH?=
 =?us-ascii?Q?jve/Z+w3vNXOiFWw/wfzqDI4EmvhOtO8hYoTXAPVGCQCFU8muKI6uu0s4zxo?=
 =?us-ascii?Q?eezECNVkxkNBYBxXoYFUqnGg+BlYXau93s5FT4+UMATA/MEw0lTGEv62I0sN?=
 =?us-ascii?Q?MaE7cc8pJRvamkpnmYXdWeJMdGE/VuvoJYIH5ZgtgTyRjWO1fkGs9Yw/NpHT?=
 =?us-ascii?Q?wIHz3p9ZLFfSyRIW6hGvmFp4PQonBq6xHBLsZiInZPcVr7cZKaV4e4Zcmocj?=
 =?us-ascii?Q?2LE5RonYQq2LvzQUWyvW9ZO/756FRLQctJ31HHySW9DcQHM4SxOI5mQxXj8P?=
 =?us-ascii?Q?/eT/8wBZ9sugp/stPGD/OZmF2bkvCNGAmPMeJuyja6bdl8uuef73uneakHad?=
 =?us-ascii?Q?1OVSvL3APl1avfQJpUJdpwXJ9DDJPYG+4G34cY6ck73Zd4GyHnWNnVUgD2+P?=
 =?us-ascii?Q?n2U2WobizbAu2VnfiSZNhqnylf2jDSWCjKXeNSeUSXZOLCzY34IXYcYwELck?=
 =?us-ascii?Q?28mrObHn83nWmf151mfYzN9iZKoaOXkMujxFpzSnBbi3i1NZ3lAO3bb7sUTb?=
 =?us-ascii?Q?jRm3TyoMtx7qptp0Hu3soHKpgedjJvEWv6n7otFc+frLdc1baTuaVdzRR5qS?=
 =?us-ascii?Q?TVBJQXxbD280ep0pvPICSd1a2KgC1rlcvKH+mQ4zXuHzAzH5/AudsXNkdIU+?=
 =?us-ascii?Q?pepoe0arbNMAmBUMsKKaoGlyrHudodN8Nf8cauxHJByeklJeaZuDPtYeCNNP?=
 =?us-ascii?Q?63ERy91bKvo+1dCKUIMfEdqAq69jX1IrYYEagZpfJ7G40Py6mlNr4g8GnBkl?=
 =?us-ascii?Q?8X+EUfW0g6JNWwYrV9KpezG+M1sncMGhqeafxCi0d6qA2lTpTuy1/fDbDgpL?=
 =?us-ascii?Q?A+7+8jl3FPnX3qCcx90aJrm5WVaRIHAG3LU6N0NlDvKDhrKcrX6Qq1Sk/Heu?=
 =?us-ascii?Q?Nxb3gDjmZknj+pX7X3X7b/shyrPvLHUKTmRksZLONUyxbwnn3E3mfmUrrqvp?=
 =?us-ascii?Q?fPhZ2hHiFOCcWPfPCdN+965LPFQ0F1JVyC5COuaY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d20ab265-03f8-4428-79e0-08db2975af33
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 19:02:43.2386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yPfG3MDsHiFvbRp02Vfq9+mBWfkqEAmqqmpra1W2ZBmvXF9kS72VGCapaABm/4bp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4536
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023 at 05:41:52AM -0700, Yi Liu wrote:
> as an alternative method for ownership check when iommufd is used. In
> this case all opened devices in the affected dev_set are verified to
> be bound to a same valid iommufd value to allow reset. It's simpler
> and faster as user does not need to pass a set of fds and kernel no
> need to search the device within the given fds.
> 
> a device in noiommu mode doesn't have a valid iommufd, so this method
> should not be used in a dev_set which contains multiple devices and one
> of them is in noiommu. The only allowed noiommu scenario is that the
> calling device is noiommu and it's in a singleton dev_set.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommufd/device.c   |  6 ++
>  drivers/vfio/iommufd.c           |  8 +++
>  drivers/vfio/pci/vfio_pci_core.c | 94 +++++++++++++++++++++++---------
>  include/linux/iommufd.h          |  1 +
>  include/linux/vfio.h             |  3 +
>  include/uapi/linux/vfio.h        |  9 ++-
>  6 files changed, 93 insertions(+), 28 deletions(-)

This could probably be split to two or three patches

> -static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
> -					struct vfio_pci_hot_reset __user *arg)
> +static int
> +vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
> +				    struct vfio_pci_hot_reset *hdr,
> +				    bool slot,
> +				    struct vfio_pci_hot_reset __user *arg)
>  {

At least this mechanical re-organization should be in its own patch

> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 3188d8a374bd..f0a5ff317b20 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -116,6 +116,7 @@ struct vfio_device_ops {
>  int vfio_iommufd_physical_bind(struct vfio_device *vdev,
>  			       struct iommufd_ctx *ictx, u32 *out_device_id);
>  void vfio_iommufd_physical_unbind(struct vfio_device *vdev);
> +struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device *vdev);
>  int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
>  int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
>  			       struct iommufd_ctx *ictx, u32 *out_device_id);
> @@ -127,6 +128,8 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
>  		  u32 *out_device_id)) NULL)
>  #define vfio_iommufd_physical_unbind \
>  	((void (*)(struct vfio_device *vdev)) NULL)
> +#define vfio_iommufd_physical_ictx \
> +	((struct iommufd_ctx * (*)(struct vfio_device *vdev)) NULL)

??

This should just be a normal static inline?? It won't compile like
this.

It would also be a nice touch to include a new vfio_pci_hot_reset_info
that returns the dev_id's of the other devices in the reset group
instead of a BDF. It would be alot easier for userspace to work with.

Otherwise this looks basically OK.

Jason
