Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F071D73BD22
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 18:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbjFWQtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 12:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbjFWQtF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 12:49:05 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9AB295E;
        Fri, 23 Jun 2023 09:48:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CDBVXEwWzamIJSNpIhiH0ewjWV83hXHleUNir/NsZyMvmXrDXYsir17Dd3N0fbAleBrhjPhqWXSzOv1cmdcpvG6CopfoH/fobDCHPbtdka6BDyRgMGSmWCRfxP7cKdH/H2jFQ3tQ5SK7314PfdcwM/klvj2iOcE2rKaBIMuys75M2Orm76MIF9/syEmo4QyDEEO3r11WGDDi2/sFiLlXHDODboPGI/kXI3ujbNR9JTAtcEy2O0Py10SjNJkChRnIrRcfWObtQM+ax37nSY8ezpF9zeO7b1sCgLpisrlkvEbpK5JgKJV1HVNjzCBH3+/NHyt9W4vp3Up2GdG01DA9Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZL+1+IPZmaDY/lEPG6N0cjcps6vBgQzi0wBbw8L4KFA=;
 b=W4aw1r/rwGT6kOeyqAzBeOrboHYoviHShdwlSUkGq8UWX9ahMvdGjQD4Tl3FbLYdOcfDDK/CTiBLtgBXW1zRgl5P/0Bth6B4k3dM2kN2k5mEGLZk12S33DK9VpH/eIY+Xp7XLQ01kP+FjU+DY22IPmkwBiIIjV4SL9GIr4rlbGe4ddhPHVdBJG3pElDq2NxLYN0yhfzYIg/bAshAgNCRrT0bwwl9quhihH2TcqdSzEb2I7Hh5oZeIxiC0HNSniKM97ElJvUh/VSJ6DPech9aeYrOVOcv86Et7Jw5raz6/m0UttBGhbD2MgSaf/7Gx3rK5EOMil35ccinvzbAGAgc6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZL+1+IPZmaDY/lEPG6N0cjcps6vBgQzi0wBbw8L4KFA=;
 b=ZGQT+JDinBpQ9aJqiseEwDGGx497DBElYIgzin5FwR8KQq846zOUc/8ysNbstHf0lBvrVyyd++8GzKjLJhV7rsJISaqGIO6bK96TnldIkhg2xepqKR+xBnA9gTE3f9GjK3JJISgK9Cd66YpeMIf1l7ZsMMyNfCa5UnFM/RYfCl9we4XXpeEwJEhDd9GhbzPR9hcP5g8Lvla9MBtPIydA3FiTCI+X3WpINj1PN4YqrftrTeq/8ix2qqgGS3orkK1m+qS5pF73DC+MRmH/ASCvlVv9uFc7+0tfB8njnkjmxn/ZI28D+zK0Ce5cyHVFF+j/HPRyl0GTM9gLDrIVMYd5yg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB7584.namprd12.prod.outlook.com (2603:10b6:8:13b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 23 Jun
 2023 16:48:22 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 16:48:22 +0000
Date:   Fri, 23 Jun 2023 13:48:20 -0300
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v13 00/22] Add vfio_device cdev for iommufd support
Message-ID: <ZJXM1Co96do1a+1p@nvidia.com>
References: <20230616093946.68711-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616093946.68711-1-yi.l.liu@intel.com>
X-ClientProxiedBy: CH0P221CA0040.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB7584:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cec17ef-0d2c-4b67-b70b-08db7409a790
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LZS09JrpuppY0PecEjOM/j3/ItQDFsa2rPm5hPj1A8YUEwkINe1z4dh/7hOCAd1WWCT+9COKx0tLQKlnZuSFuGSUy5sTM4/ICYZARHWZukrSIUzPtBjRQ19rpl31jGX2dTw3+8nt1e8AOFOfB+4+4NeJsH65fmBm+HMvGrxikwPn9ty3py02GYoxSMbUhBSCNZuHMDu4yRIWqa9bI4N8f+br8dEtaUdS0ZCL2D/qP7u2mMrOr2DbV1gJx1sT/hBME2v73l2FhXXTIrr5hC1NNrHEXH/TBaCuQTL6EkAoyerzrk5DXaEzTprJW+Zb/XFyqj0Pjvgf22zJ5yNQoyKI7IyHsRYwGqYRfgj0Kc2qN1Sl8s524+I1PASGuY/cY6lNFkQFLKiMhREteswzlEwYnFK8/y0U0pP5tHdlK4Zf6WGhOu8kU4I+SHpeSh1/8eiA7VngZlL7zMtrR186xqYqtI5ZuVb3ZNk1iDxMd6IGJDuAQmpodsJURTFbvSGitndJ4Nfev/8TY6EE/CqR7fo+EDLQRnGqWDU1//ehAnUdNBVwMPU9I6yohyBYYvyICQ+1nAWF9s8UK9+jhTYq/q15ef8rqImUoVPwH9bi/3RHmeE/Nb8LKl4IzA2cH13R6yd3QpIB+Wm8VnS2zlab/i7d2p19LovfVkJPy/wqCl+DU383IGOcD0NxwNez651g14aD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(451199021)(5660300002)(2906002)(7416002)(38100700002)(86362001)(36756003)(45080400002)(478600001)(966005)(6486002)(316002)(8676002)(41300700001)(8936002)(66946007)(66556008)(66476007)(6916009)(4326008)(6512007)(186003)(26005)(6506007)(2616005)(83380400001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zq49osK4DCDw5Do2ZiVE4QCh9E1ZXn4qyw3wCVtJ4+y5MUdMshl7y0fEr7zW?=
 =?us-ascii?Q?Mv5yqfXWcvyg56eN4bCyY8bdlSAtIhc7TJA6STW+KHKcMaD4f74Ap/crzLRA?=
 =?us-ascii?Q?ngyntlSiQvovA0A3ZInN4chk4gOuSWynC6hWIWyrKofWEFGeOJygoGDZcEhU?=
 =?us-ascii?Q?WMrwL86ZnggrstBanUtb520UMoEPdngT67rDkjRDaAVssq1uHyE2f/qBpTc8?=
 =?us-ascii?Q?vaK3ICuCSjkGDgxrPpB1FFfUotG5XI+Wcz+1WrN2x3b4djbvx5BGQOp3waJ8?=
 =?us-ascii?Q?j6rQISXN0jxUmXrGrSseEyAeuoBizEXtFbP1jNSdoQyXbA+TAZzDHVXgsd62?=
 =?us-ascii?Q?zjODScqRjfEqSL0wZ6KAahpl48+DFAB0oo0xrze6uKL9pC/YVSgaQ4JFSe9J?=
 =?us-ascii?Q?qOolmOd7Z8eQXyjaKQNTiYiBdix2BnOoxEtBqMeBDiK8mG1D+1lQG3IbQ0gJ?=
 =?us-ascii?Q?tenaomdTuSPUmzfpKKh83V25uKxAMoH4lqlr00OQ87V2BC0MdymaHxL9y8jr?=
 =?us-ascii?Q?8U8XwmHk03O0zCrVZ4RZwQ97rUz71a0dkAAe6H0yoh8H7YmQLd3hQOAlXLZ/?=
 =?us-ascii?Q?+H7yN0T3J746AiwQzhp3ZMW8bmOhVGr6tY+ImQ5xo+EVh7PteXWhPfSiZRQK?=
 =?us-ascii?Q?SLz6VTN/gM+N3zF9BHihU9w6gC6hFY1Ju3uAJNpT+okHaacsqdFROhigacK1?=
 =?us-ascii?Q?TnpgY0XSKOPpSsIrbv+BHlKOL8bHvr0IWXdWM5FFT46Hnou4LlETqRxcsakJ?=
 =?us-ascii?Q?gMa8ppR+77343nhVV7soqFjtaCqanVTz6PxGQ01xbBldVfRX5/pDhdVj5Tko?=
 =?us-ascii?Q?UyTUiytmGMpaY9juGW1+4x/w6bTQsOvzvV44fo9QXSoodIqyMnmax056cGNS?=
 =?us-ascii?Q?3PQD+tygGE577/EfTcVHR3ChWAwnVTiIIMwcjlD1e+vKrobsplzp13/sEF8u?=
 =?us-ascii?Q?be9r5w17edSkhE7KZXL1EZPpFNaIFRMan32nPgstHbMptY73y0qBdq/km2My?=
 =?us-ascii?Q?/vqNEwkIxs11DSCwNOitBYj/g0JevyAJYeHIkGBVURHQck1pm2e8QDWZMl7G?=
 =?us-ascii?Q?ZS/0X06deWAR7BPHj5QrhQJT1JsJIqhHmeoPk8Et/AifOqrySYTBqrs7JB0+?=
 =?us-ascii?Q?LkjZ4n9wDjRXACr7BfR6aMr0Mk4SigNQR2f+/MeM519eIEkDm8L9nYl8vAPy?=
 =?us-ascii?Q?OXcjT+AvqzITeFQGOXsRDpk8Mn6VPKYim/Pt07GvGzMjIiSztiXV7qo2FhJM?=
 =?us-ascii?Q?MlRkY1kRoOfg0ZVgB1nTVPlLw4Pq+X9qWSD8C0h78EBbEswfdFNcjHVKdJYe?=
 =?us-ascii?Q?zoshwqUFQoaGezoG3I07LP2AfrLJ6ROwuJbgTGa4f2V/T59vyPPdVHjbhlUe?=
 =?us-ascii?Q?bknt7Owv6/44aP1RvbFkUhdDh34qm9hJWjzKDyGsi4AfHu1FfNs0OROdW0pD?=
 =?us-ascii?Q?QwuPRmNbi8zhwSoWK+iipQXaliLQTYFds7/HRkZb+Od2O05JXx4pmWSxyUVY?=
 =?us-ascii?Q?4XvqMrsQtrvBPvmPnph3EiqeAJVzfWos4eeDuJJ0YlpIPRN3bGn5i6Z9IRIM?=
 =?us-ascii?Q?CWISRCTwOebb1ytnrDFhoJRvnK9yE6nPkYViSuYK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cec17ef-0d2c-4b67-b70b-08db7409a790
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 16:48:21.9815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CNYE7CBEk1EBtydBSYmRDzXIHxbcLUSPJJhlcB0Wq2aKEGzRSnVbA90QzN7qPjFT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7584
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023 at 02:39:24AM -0700, Yi Liu wrote:
> Existing VFIO provides group-centric user APIs for userspace. Userspace
> opens the /dev/vfio/$group_id first before getting device fd and hence
> getting access to device. This is not the desired model for iommufd. Per
> the conclusion of community discussion[1], iommufd provides device-centric
> kAPIs and requires its consumer (like VFIO) to be device-centric user
> APIs. Such user APIs are used to associate device with iommufd and also
> the I/O address spaces managed by the iommufd.
> 
> This series first introduces a per device file structure to be prepared
> for further enhancement and refactors the kvm-vfio code to be prepared
> for accepting device file from userspace. After this, adds a mechanism for
> blocking device access before iommufd bind. Then refactors the vfio to be
> able to handle cdev path (e.g. iommufd binding, no-iommufd, [de]attach ioas).
> This refactor includes making the device_open exclusive between the group
> and the cdev path, only allow single device open in cdev path; vfio-iommufd
> code is also refactored to support cdev. e.g. split the vfio_iommufd_bind()
> into two steps. Eventually, adds the cdev support for vfio device and the
> new ioctls, then makes group infrastructure optional as it is not needed
> when vfio device cdev is compiled.
> 
> This series is based on some preparation works done to vfio emulated devices[2]
> and vfio pci hot reset enhancements[3].
> 
> This series is a prerequisite for iommu nesting for vfio device[4] [5].
> 
> The complete code can be found in below branch, simple tests done to the
> legacy group path and the cdev path. Draft QEMU branch can be found at[6]
> However, the noiommu mode test is only done with some hacks in kernel and
> qemu to check if qemu can boot with noiommu devices.
> 
> https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v13
> (config CONFIG_IOMMUFD=y CONFIG_VFIO_DEVICE_CDEV=y)
> 
> base-commit: dcc9d48709e6bc6ec3da97626b8768582e138326
> 
> [1] https://lore.kernel.org/kvm/BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com/
> [2] https://lore.kernel.org/kvm/20230327093351.44505-1-yi.l.liu@intel.com/ - merged
> [3] https://lore.kernel.org/kvm/20230616093042.65094-1-yi.l.liu@intel.com/
> [4] https://lore.kernel.org/linux-iommu/20230511143844.22693-1-yi.l.liu@intel.com/
> [5] https://lore.kernel.org/linux-iommu/20230511145110.27707-1-yi.l.liu@intel.com/#t
> [6] https://github.com/yiliu1765/qemu/tree/iommufd_rfcv4.mig.reset.v4_var3
> 
> Change log:
> 
> v13:
>  - vfio_device_first_open() and vfio_device_last_close() to be vfio_df_device_first_open()
>    vfio_df_device_last_close() (Alex)
>  - Define struct vfio_device_file::access_granted as u8 and also place the u32 devid to
>    be behind this flag as this structure access is hot, so needs to avoid too much hole
>    in the structure (Alex)
>  - Use u8 instead bool in the struct vfio_device for the flags (Alex)
>  - Define BIND, ATTACH, DETACH ioctl behind VFIO_DEVICE_FEATURE whose offset is 17 (Alex)
>  - Drop patch 20, 21, 22 of v12 (Alex)
>  - Per the patch drop, still needs to detect the physical devices that do not have
>    IOMMU in the cdev registration as cdev does not support such devices. Per the
>    suggestion from Jason, lift the IOMMU_CAP_CACHE_COHERENCY check to be in vfio_main.c
>    so that it can fail the registration of such devices if only cdev is compiled. (Jason, Alex)
>  - Refine the vfio.rst doc, highlight that the cdev device access is stil bound with
>    iommu group. (Alex)
>  - Reaffirm t-b from below folks:
>    Nicolin Chen - Test nesting branch which is based on cdev v12, the test is done on ARM64 (SMMUv3)
>    Matthew Rosato - vfio-pci, vfio-ap, vfio-ccw under container, compat and cdev mode, and nesting
>                     test on SMMUv3 and Intel.
>    Yanting Jiang - regression tests with NIC passthrough on Intel platform

I accendiently put my remarks on v12, but they all apply here, and I
don't have any new remarks for this version.

Thanks,
Jason
