Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A873E6EA5B3
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 10:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbjDUIUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 04:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjDUIUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 04:20:34 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3367DAA;
        Fri, 21 Apr 2023 01:20:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gnr7mVIq/GVsMMlIh8YGHe3VEchhio9NtN0OaRow2p73uxINve6Q2w89maHqqc8oF390EIeTZdKmy9MictrkhvLTu48B2XLfyZiQD2zvHJCoapP1gOySmltK1loFVTdoZS5aW6HUVddtfEg9u7UjTuSwuheM0yTzdcAlV1lt3mJ0guq4mdsrJPnWC8tuIZQosTETV1rDqj1jNFJsRbFyQPR7LqUPrfbYtS78nhD58PnU/C2f/XiDQlSPhdwDkUJ4xuKOq2GX4+/yCuqyv93abjH7WoDVd07itbVDLAgcWKxJqKx1iuE556ISfaHsWtoc5VTT0X0f9tSuowg4k50EAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JWQWxUDWpFX9Z46EKQrJqcY8B/G36WRGl5KDUyq0ALg=;
 b=NZlG1fbjScjRZMfk3nupd14GNlp1+x92TfPBWgElyrZwci+0glHC1rdPVXkH4xJEg+Haor9yB9C8FFD6qh6zgTw6/QECgGxkJRVrUUjqRhomUv4e2zQn0oeEJbmjqtQAJ+tMYfcUy9w23WIkNbMVDi2RVT5z+bE7dwqP6suQuYTl2l1NKCLhz9w2vAM9cznBBSGXZB6UORvrLw0GumlhvPdvk+z7VPfWRxwWucwVYHCGWo2jCObd0MjTK/k3bRbXhLmKhO/rQPYWjA3c7b4wdLH26WyLeTSgUT9bKU1Q8lNSJxhrS+jXMO6qYcG9Nr+Uig5+xydlEj9nfsPbmYhIgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWQWxUDWpFX9Z46EKQrJqcY8B/G36WRGl5KDUyq0ALg=;
 b=umQwaOmW5H39iQJQxZPZfPuBLFf4lUuN+bPrO1cuKWBpBCyus05G7vIs6ShGC4GzFVtNE98BKC5A74IecnEi38NZKVrA7mOEAtIXYCPG42frge+IprL9XagxSBUnjM8raqzyIT2jneuYORvzHD32SQB3PECAvxQoLa39fi//m2evl130yq15ck55w6p2Yy9g8s6IKq0BcxSIm/fH9CyjPV5/L5VJKblU3T7X9NHn32MwPswu5ZCl4wD5sib007irVYIHbabYpP0Q44SDYu7BepexFKQYN7P4cvFJ0rfQztDsXIvl4tTaEFSFbf/BPTs1Tyrg7lDB15Lm2AZz1GOLtw==
Received: from DM6PR06CA0024.namprd06.prod.outlook.com (2603:10b6:5:120::37)
 by SA1PR12MB8842.namprd12.prod.outlook.com (2603:10b6:806:378::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 08:20:27 +0000
Received: from DM6NAM11FT089.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::28) by DM6PR06CA0024.outlook.office365.com
 (2603:10b6:5:120::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.25 via Frontend
 Transport; Fri, 21 Apr 2023 08:20:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM6NAM11FT089.mail.protection.outlook.com (10.13.173.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.27 via Frontend Transport; Fri, 21 Apr 2023 08:20:27 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 21 Apr 2023
 01:20:15 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 21 Apr 2023 01:20:15 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Fri, 21 Apr 2023 01:20:14 -0700
Date:   Fri, 21 Apr 2023 01:20:13 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v2 0/3] Add set_dev_data and unset_dev_data support
Message-ID: <ZEJHPb1E1/eI8V6A@Asurada-Nvidia>
References: <cover.1681976394.git.nicolinc@nvidia.com>
 <BN9PR11MB52764ED59905104D3A5A68C08C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEI+LBkEeNZdJyTB@Asurada-Nvidia>
 <BN9PR11MB5276C39E256CD4B922435E1C8C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEJBldGXBNGEy9tV@Asurada-Nvidia>
 <BN9PR11MB527693075725A13DB9EE18678C609@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527693075725A13DB9EE18678C609@BN9PR11MB5276.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT089:EE_|SA1PR12MB8842:EE_
X-MS-Office365-Filtering-Correlation-Id: 771a14c9-70a0-480e-8a46-08db42414393
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hb6onrmqm1U+Aff5xa0G/2CzIpHJVsmh5EuPf9q5J4zLlNsvSK2WVSJ8o7crWrz5YzL6+j6X027XnqXEONyqC7n2embTwa6UTVGPRpR0/ZgY9hCNBOl+wxjtC/J5g0ScSsuH9tT6p0UHtD2xKD4Sw60yLwS4w9iwndzNmosEalwlg3869upF+/DKbQ0Gz0VjNgbHo1sS0l2HxfunUtCCUfOBNIopTwnHrHte2QvOxS5e12DsSIp1lk04fnfRfEW6L27SFgW4EoLftveFJTd2045fkGsSlmlKrzIm9OELJ5nirjy27U9a2Sqgae/r3d+bUklCcUlcpSEuI7/wddL1UOepQ/pOvBK/SBHV7rjaKZzIhGnRsW7WHYp6eCZwutkArPrVzjcErrJOY0bwH1nR4AjkIEsyCwfUtEedwZcTROG+FhMuEB+ge8u5mPi2625hzXlgG4Ypt6sHjFg1nZvz0PaoopkxPraHhNDpFB5E0AWqxcosPQgKh2+3oWJTA6kjJK31+TGduPnJpD4wC6ZyWhp8GRGbNIvPzWzxDXv4botpMOSwQf+b47+JRPumE22InmMDFsCZTuUTBudDv8y3ty6W+2xXfJF5NAzrBR9XjFIZ7rkAomoXkJUSc95HAZpZpSKnZ0eDb7YZuWpGu08b9x2yhiFTwtkPWHKNdj6vhO25TrWsneClwLBeorijZ4CTG91L5a34KUCmY/RVVSSbq8OciYLId9JUIwZSsKQ67NZa6/uc/4IEY4Kjx/7UpRrilwUJzNInwFuc3FA8zLQ08oUEhvu3U+UtASrB40RSXsieJsGWqTF2bmbt1ki+zmB4f/wju8tiA9gG/mfOxII+Gp3Cto4l7O31eOYAWZeiot8=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(40460700003)(2906002)(8936002)(8676002)(356005)(7636003)(7416002)(86362001)(5660300002)(82310400005)(33716001)(41300700001)(40480700001)(55016003)(26005)(9686003)(966005)(54906003)(34020700004)(36860700001)(478600001)(83380400001)(47076005)(426003)(336012)(186003)(82740400003)(316002)(70586007)(70206006)(4326008)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 08:20:27.5857
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 771a14c9-70a0-480e-8a46-08db42414393
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT089.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8842
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

On Fri, Apr 21, 2023 at 08:07:19AM +0000, Tian, Kevin wrote:
> External email: Use caution opening links or attachments
> 
> 
> > From: Nicolin Chen <nicolinc@nvidia.com>
> > Sent: Friday, April 21, 2023 3:56 PM
> >
> > On Fri, Apr 21, 2023 at 07:47:13AM +0000, Tian, Kevin wrote:
> >
> > > > It is in the commit message of the cover-letter though:
> > > >
> > https://github.com/nicolinc/iommufd/commit/5e17d270bfca2a5e3e7401d4b
> > > > f58ae53eb7a8a55
> > > > --------------------------------------------------------
> > > > Changelog
> > > > v2:
> > > >  * Integrated the uAPI into VFIO_DEVICE_BIND_IOMMUFD call
> > > >  * Renamed the previous set_rid_user to set_dev_data, to decouple from
> > > >    the PCI regime.
> > > > v1:
> > > >  https://lore.kernel.org/all/cover.1680762112.git.nicolinc@nvidia.com/
> > > > --------------------------------------------------------
> > > >
> > > > > Could you add some words why changing from passing the information
> > > > > in an iommufd ioctl to bind_iommufd? My gut-feeling leans toward
> > > > > the latter option...
> > > >
> > > > Yea. Jason told me to decouple it from PCI. And merge it into
> > > > a general uAPI. So I picked the BIND ioctl.
> > > >
> > >
> > > 'decouple it from PCI' is kind of covered by renaming set_rid
> > > to set_data. but I didn't get why this has to be merged with another
> > > uAPI. Once iommufd_device is created we could have separate
> > > ioctls to poke its attributes individually. What'd be broken if this
> > > is not done at BIND time?
> >
> > Oh, sorry. He didn't literally told me to merge, but commented
> > "make sense" at my proposal of reusing BIND. So, I don't think
> > adding to the BIND is a must here.
> >
> > The BIND is done in vfio_realize() where the RID (dev_data) is
> > available also. And the new uAPI in my v1 actually gets called
> > near the BIND. So, I feel we may just do it once? I am open to
> > a better idea.
> >
> 
> IMHO if this can be done within iommufd then that should be
> the choice. vfio doesn't need to know this data at all and doing
> so means vdpa or a 3rd driver also needs to implement similar
> logic in their uAPI...

Reusing the VFIO ioctl is because the device is a VFIO device.
But doing it within iommufd could save us a lot of efforts, as
you said.

So...

+/**
+ * struct iommufd_device_set_data - ioctl(IOMMU_DEVICE_SET_DATA)
+ * @size: sizeof(struct iommufd_device_set_data)
+ * @dev_id: The device to set a device data
+ * @data_uptr: User pointer of the device user data.
+ * @data_len: Length of the device user data.
+ */
+struct iommufd_device_set_data {
+	__u32 size;
+	__u32 dev_id;
+	__aligned_u64   data_uptr;
+	__u32 data_len;
+};
+#define IOMMU_DEVICE_SET_DATA _IO(IOMMUFD_TYPE, IOMMUFD_CMD_DEVICE_SET_DATA)
+
+/**
+ * struct iommufd_device_unset_data - ioctl(IOMMU_DEVICE_UNSET_DATA)
+ * @size: sizeof(struct iommufd_device_unset_data)
+ * @dev_id: The device to unset its device data
+ */
+struct iommufd_device_unset_data {
+	__u32 size;
+	__u32 dev_id;
+};
+#define IOMMU_DEVICE_UNSET_DATA _IO(IOMMUFD_TYPE, IOMMUFD_CMD_DEVICE_UNSET_DATA)

Maybe just like this?

Thanks
Nic
