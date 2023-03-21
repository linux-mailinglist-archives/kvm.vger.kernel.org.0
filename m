Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897856C311F
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 13:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbjCUMAw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 08:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjCUMAu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 08:00:50 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F4F1AB;
        Tue, 21 Mar 2023 05:00:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kXkfZyD/lyN0+3+I3JyISRvcPD5OSPHzsZ/wylsTM4IANbnQwoQT0MFWiEcnR2EHyZA00KWTzEQnt16weFvjHXzUPQmoKeMkbMZekkV98felF25U/8asZx7RRXCFN7fbaAApn9F4J1OHXXASIV92wqggS6Ti9heTWwbMtGQFSNqyCr6E5qsKaPPod96ZOerEQZh17KKIUM/11Wgyb4sbSKKlccyAeqttAKTg3DEcrWRozYzfVu3TMSUouuchppRBmffjpElDYQmWLB/BNkvelOk0COdk3TuffdH/NbNmNpHnY2PH63voZjJbXFb6EecQgFJ2NbKQqjkffTL+S5I81Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ete283pTSRg7/MveVCdnN2a2jDYfqCdOnoNhsw1o5fU=;
 b=PkbeY7NveUCQj62gozZ7owIEaQ6NUdwuYHVHeJ8DgbERZ91EKak6P+RVOlsiC0gdkLcj6IHXyxRjKB1bOdjRUZSFRqu8WadJMrDy5zCu2jMB1iWz37bFTebPRxgcxqNahne51LcZ4lCsHgCEEO899PAble/SqKY/tQjk47GO0w4vWUZ2b1k0mRczqr59SZ5/UY4Lep27lfTqk+DZZrVpAZGoIt9YmwWLwdQcAYCWm+Diwgqf1ldiTDJVXB+rqw/Wet+8vwXuxw0o054m8XFENQLAB7hY6KZAdzDChMX8loxQItePB5dCTEpMWb+CZcLVbx+79IhH+OC60BaPFalhTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ete283pTSRg7/MveVCdnN2a2jDYfqCdOnoNhsw1o5fU=;
 b=hEHaN5qAPYCoRyQ2aHeI/W/SIByFzcodvlfrbskgSU678zd8j6iLWTXdqF41irvHIyKsXVex4KxHxXntKU+xZG1srB+Ysb/i2nNN+mkZLySzO1TDRknzJA6pIBZ1G+i+GcLw4c9arLymcr2Cw3bsjCc9PSdYK9ZX+XTmkhli7/jSoJWajsuJOp+uJfqbk7hTKqJojUSPUhJl0b7qnFwgBBNQAJgBF7owtJ1GylxXTbffFFzn1G5O1jhm/UxFtgx5KxjjPB0HTFdwW8x2u3P6GB8zScpsURn/VS5twodO9TNDz68QMyfQQr5WKsgHxqokuGqkNlSJj9S7+GKR5D88Tw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB7723.namprd12.prod.outlook.com (2603:10b6:208:431::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 12:00:46 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 12:00:46 +0000
Date:   Tue, 21 Mar 2023 09:00:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v6 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <ZBmcbMuE4lyDIpT6@nvidia.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-22-yi.l.liu@intel.com>
 <BN9PR11MB527665CA5753E413CB4291AE8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529B3BFD999C9720836F049C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276684B2C0CD076FA3CD0938CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752922A0C9058583F677369EC3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBhpNyrBr9nm5Ae+@nvidia.com>
 <9875e60c-68a7-b360-9d52-66d4915808a0@intel.com>
 <ZBiU8KoSmiM+JkAw@nvidia.com>
 <BN9PR11MB527605E6609222431DFB8AA58C819@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527605E6609222431DFB8AA58C819@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR02CA0110.namprd02.prod.outlook.com
 (2603:10b6:208:35::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB7723:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ca8c3d5-ee5b-43ad-37ef-08db2a03e75f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p7YcyfDqAsMKzeSixtt76WMxTsh5KrVAjs0Owk98Asem3O8a8U+ZqYkVPn5lFKvBB3M0s5BkmGRQluA4j2Gprc01IQgygrQ180cclcf3qe9WoxQN/tFUtu/Ko+0j3MxVt7jrpwMnbzknkiN0tk25StEsOJzqRRZGhLfoj2bdk5Fwa644tDy/w5TrcLErQcSEQSKaxTZbAiX1LuSZYKdoe6rn9ci5nqO4rga/HvAToEKZ5Lb2OPX8JCB2huHmyTKY47WM2/wOKK/emMwK9jqfEM7MvLd+HB0tATdXMKXWba6wo4Aq4VokH94iH5kcJV8xLpzmsOJsR5P2oMobn8444wmLZFXg30OtxLP0eg4WIoYZkPqQ6GylIAWrRhDTIfcO+FTk24s9JWvdSR1LyvH9bfHAbGrYRkJydahu+1gRCxDbUgQdHn8t0cwHea0nsqQe214ZXF/xnXkMUk7eup3pHbkckuiFraq4j5Zy9hxgqiqc/zs+ji/17ISisbSc8HsuLJJBhgzIOMzed5ATk+VZ6l1thmesuXmDuJWNTMxSLOqQGeWmZtEt3sfvqy8bAb5+ymi0KK7w4mNkqEupKwpNMXe0wziSzVKF87J/fK5lCeqCNBOSW7kn+uh9BSyu3xPPKlSzGWiVk/i12zOXxaeM1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(396003)(366004)(136003)(376002)(451199018)(6486002)(2616005)(316002)(83380400001)(38100700002)(86362001)(6916009)(4326008)(36756003)(66476007)(66556008)(8676002)(41300700001)(66946007)(5660300002)(2906002)(8936002)(26005)(6512007)(186003)(54906003)(53546011)(7416002)(6506007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c28pF68VXqze8cBKtL6YVHHgu4GPRppuE2QKjIzUsoORojahIo8Pm/YCApgd?=
 =?us-ascii?Q?ghxNzJBADzCuJNTiTDCw+efBwBkUEorRAim9MbGJWIKYOKGIM9vCxeCnOaNs?=
 =?us-ascii?Q?o93QPnwLLLR62OjFn7GDD9VtD14G4yUzF1jjAAxTsxxdeKsgElu9s8kqRx1T?=
 =?us-ascii?Q?j7BYbIYcpv765Ze6uvr3eaqGWxwIONRYlhJRgs/gQYIfziVm8bMJS0kjUCge?=
 =?us-ascii?Q?6nP8Jn0gF4cKd8RkUWTSnEH2wsyd9wsvBWu8ByjK31ZKqWcdl8As5OGAxhRt?=
 =?us-ascii?Q?TF11Gc/QbtEkq4WVm9annboMrBNpMPpLWMmboO5ohXldHawm87iM6a2txuhZ?=
 =?us-ascii?Q?vn0dGwYXoYVMTUM4bcsJlocU5yKThDn9Wi/imMf4NHMBaxO9eV0+SlYhAMSD?=
 =?us-ascii?Q?5IMI1ouSORK0/6tGqUmalad9lurYGBOtHg6aTp4SD6UXhUsu/jiFA2cbZk7g?=
 =?us-ascii?Q?6Cbu9heM9ixmRmTl/AO1KxaGGCA85ZQzs77IfQzLn6ZYmZXheVqKDblxJBB7?=
 =?us-ascii?Q?lk9LdXQ5Ivrq6hJDmdPKfqTxQ68Hb4Vg9zeRNfv8URqNSeUiqdmxyEyRKim6?=
 =?us-ascii?Q?PqoCzFScT+GghI8E5Xmo81Ahy9T1AEW3gxbCdyjjnxb1vEanyfnn+/9oZ8Tm?=
 =?us-ascii?Q?itqQp00lc0+9uakcmprKcSyv2b2+PGKqwIZN9l7TXanZGMOPEmsuOMMjKa5v?=
 =?us-ascii?Q?EL7IdRq4zxfsEEniNRzmn4zqAOZWpeXjgDRmD5P0p8NKxnxzHK8v38CXdMfZ?=
 =?us-ascii?Q?bSGhCQ8SPTANax6U7xKU7hd9TveKBwGEnV6bAckIzT3+MEgjUTHkzBGN1Eul?=
 =?us-ascii?Q?dsN1BoQZ2VCBIgGCbVTz5JFZHWQuDEzgO1f2zEEQhcIYrnweOG2XLfJP9scW?=
 =?us-ascii?Q?b3xh6Ir55EDJW/B3lMevGRZyI03LsP1Qr0n1K2o4ByaZQ+8hovdNuI5QbBll?=
 =?us-ascii?Q?52QXxBz9iW1dMrv0b0ZB8tgznv0C8ffYmMzlRVunUmwcSL8cUZoQfQ6UBHes?=
 =?us-ascii?Q?rU1sQ4rhDjt2KkaXph7NiymAdFzTAfcZeV+P3Bo6dwfeAjy7RmXEbYIoOUza?=
 =?us-ascii?Q?4vVnuS1jmKQrE87T+9R3a2ypy1TiW0EEOJEWfXpdw9VKqVaBR0GQ0lPG9z8Z?=
 =?us-ascii?Q?pJmaelRAKAbAjbuZ0lAcYzaOiaQNjZ9BoErEZieesZSR7EzApLj0fTeDspYV?=
 =?us-ascii?Q?BNg6pNvOtHkEwZyhYRTHnSq9ywbgTxV8X294QrSVvmgtjo4gOsEw5bc5cTm6?=
 =?us-ascii?Q?9qpd5+u4V2bqy9zit6QNAmjNSPvq/Q/EVnQy/m3fkWCGsj0Fro51Tm1iQ9Eb?=
 =?us-ascii?Q?N0LayLle9hwTOJ9G8ethe4XkgIEVqkK6/27Rm2+F3Vgk3m40OfvvSF7adB0+?=
 =?us-ascii?Q?odpT5xTwSLhJETe3aRjMcpOK9RkZgxlVkwbAnJOR3gK09JBoDNyPTyM+hGyJ?=
 =?us-ascii?Q?UBhwHYLATPrXkyJuxxBOlVOhmUnNFCdGmZ8CBKMhcNG0o5lOnRabm1sBkRsU?=
 =?us-ascii?Q?8fJ355RDDcxzcynrfk7wEdLSsEYFA2X5Zv8CtftnnK/NS/dj89SedoW3OCLD?=
 =?us-ascii?Q?XALvS+frqk/JJCeqiDr5Q0v8+GSpbjwSUR38+cGB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ca8c3d5-ee5b-43ad-37ef-08db2a03e75f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 12:00:45.9664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KdGrjBKvSCeF+RtB8y5gDD1oB5vJeZKau+BQzP7i2BmbI59qVHn03HPBqoAf+vY6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7723
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 01:30:34AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, March 21, 2023 1:17 AM
> > 
> > On Mon, Mar 20, 2023 at 10:31:53PM +0800, Yi Liu wrote:
> > > On 2023/3/20 22:09, Jason Gunthorpe wrote:
> > > > On Wed, Mar 15, 2023 at 04:40:19AM +0000, Liu, Yi L wrote:
> > > >
> > > > > # if IS_ENABLED(CONFIG_VFIO_GROUP)
> > > > > static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> > > > > {
> > > > >          return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> > > > >                 vdev->group->type == VFIO_NO_IOMMU;
> > > > > }
> > > > > #else
> > > > > static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> > > > > {
> > > > >          struct iommu_group *iommu_group;
> > > > >
> > > > >          if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU) || !vfio_noiommu)
> > > > >                  return -EINVAL;
> > > > >
> > > > >          iommu_group = iommu_group_get(vdev->dev);
> > > > >          if (iommu_group)
> > > > >                  iommu_group_put(iommu_group);
> > > > >
> > > > >          return !iommu_group;
> > > >
> > > > If we don't have VFIO_GROUP then no-iommu is signaled by a NULL
> > > > iommu_ctx pointer in the vdev, don't mess with groups
> > >
> > > yes, NULL iommufd_ctx pointer would be set in vdev and passed to the
> > > vfio_device_open(). But here, we want to use this helper to check if
> > > user can use noiommu mode. This is before calling vfio_device_open().
> > > e.g. if the device is protected by iommu, then user cannot use noiommu
> > > mode on it.
> > 
> > Why not allow it?
> > 
> > If the admin has enabled this mode we may as well let it be used.
> > 
> > You explicitly ask for no-iommu mode by passing -1 for the iommufd
> > parameter. If the module parameter says it is allowed then that is all
> > you need.
> > 
> 
> IMHO we should disallow noiommu on a device which already has
> a iommu group. This is how noiommu works with vfio group. I don't
> think it's a good idea to further relax it in cdev.

This isn't the same thing, this will trigger for mdevs and stuff that
should not be noiommu as well.

If you want to copy what the group code does then noiommu needs to be
statically determined at physical vfio device allocation time.

Jason
