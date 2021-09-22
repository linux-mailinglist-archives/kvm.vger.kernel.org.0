Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989DE413EC4
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 02:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhIVA4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 20:56:33 -0400
Received: from mail-dm6nam12on2086.outbound.protection.outlook.com ([40.107.243.86]:39402
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229480AbhIVA4c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 20:56:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NkthzIkMtYndzDFVJVpaBh3/+NtsD5q1ZTlDlnv14kkzK4A0vl0q7DaTzFlFOTxoNesXXg6sLKqhZI8wNtfRgcevJ+Tzlgb4I7e7AyqL2ROsRyvoWikLUm2w88UaWsp3Q+F+WxW4kQ7fnDMADMtnUkA8mqIhGcDSo3COvNuMGV6n1rvllVBhMWFHc1scH7qfSgx72rWKQE8e98btNirY3526Zc+sQdizpRLQPU7UiZTP+Ngw+Pz4ygppKdPX6n1Ku36R6wYZfH1wHIMepUfARWtnN2Rb2r/dhY9mE0gbfHi7yq+ptvrRp5k5EKWFVq+HoftcSiB3MC+FHBYkoxLIcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Oi86ovb32NXJlkvFoNnPAN3D5KmP4H7EuHaUYMWtxV0=;
 b=ls0RNvTLY4QpRhFdj65iXrPUmbUHn2JXUxi1bEoR/PIfw6prcngMrMRlaCakXa9HMCnDZvvF9Wl4b7Y6cTsKUnAynlf0eh+ncZQTKeVxbb1oleEXIDhpfcdbv+GA7cfNqG2zsyReyEgHau6yLXCGn/sj41hLe6yB5dhngHk3Wj7C6tGBxUHGGXEo+AdSLcZRmcg9BW2BbW6RB2OEW3F4tNynpBbVi76/TplEXwxV04DdD7DY/8eekGbdxaskxMm+EfYF5cjSpRRIT/OiQpa7pZaIQ6ZczM0QExp9s+mIZdoqxrNDv5Niptng9e6fwNvGlgxWLoiKFA//CeVyDDVdwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oi86ovb32NXJlkvFoNnPAN3D5KmP4H7EuHaUYMWtxV0=;
 b=U93KTBxmSez5LAN76loJwmLTC1NxLvD945SYuHTfqNOymNTFqYNePks17IcGsZjmeJG8tkY05ORp6yXZ8gHHX9AI3OtQyEmPAGoCdWfwkgxE3I1kHyKQWGQW9TDkQsYvMpHAcDUclnFLJI2w20YVq/GRZ+wcrzxGMgw6BMSR87YWDW67NAVAbNCUcvhBCUzu0Aki7eI7UP78wbStfE1CElKEp0081IrOmvPzP92rSzzF9R9XgBLLYcPbxJYjR2aq41CY8Pp5razG/aYWRwhL0AOVxgw0i3uvnbdolbf2KAwItK/6VFMVbka5utdFUByIFmCl6cgslUY9WFvtieJSNA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5173.namprd12.prod.outlook.com (2603:10b6:208:308::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 00:55:02 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 00:55:02 +0000
Date:   Tue, 21 Sep 2021 21:55:01 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 02/20] vfio: Add device class for /dev/vfio/devices
Message-ID: <20210922005501.GD327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-3-yi.l.liu@intel.com>
 <20210921155705.GN327412@nvidia.com>
 <BN9PR11MB5433A709ED352FD81DDBF5A68CA19@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433A709ED352FD81DDBF5A68CA19@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR02CA0056.namprd02.prod.outlook.com
 (2603:10b6:207:3d::33) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR02CA0056.namprd02.prod.outlook.com (2603:10b6:207:3d::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Wed, 22 Sep 2021 00:55:02 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mSqXN-003nNC-Hx; Tue, 21 Sep 2021 21:55:01 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49fe2311-935a-4ba1-a050-08d97d639c02
X-MS-TrafficTypeDiagnostic: BL1PR12MB5173:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5173AF20C0009CD3757281A9C2A29@BL1PR12MB5173.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vNwKehU1ZJ/DE54ak1u8Y0PR419Iba1NLWKP02wdfInPa2bOJPP0egJoxcBcEd+cPVfJGCvwGQ4/hLXUmGqePlipXngcGjaOOqWITdrtf03joBxOjQvyuOzCnqJTor1hj2RdD2tVdBDNtKcC5rj93Y3Ql0nw+PpdobZnXObTy/BAzylPuXUyFMqxorthn579enr49f/TZ631Vtn5QbE5Vpk42aBkI8RiwCmHuLKKR7QFeN87lKuTTyfR3o9pTSp556FKoKwW3PFtbGAW2cF91miTZNxHDUXv2X8ksl4f+r2UuWeHrTXMedY2tNYcS3E0T2xsE9hWqf7Zh9IcVZcR/9G0r51YZjls4eE7ABMc1h/Zv4fhME6a1SgxC+Dr+c1LNhxaGhuXXHOAZtmJHZm6E62MRVB7+CMkGMyQn1c/Ks4LTVdP0S6gWbVKWbK8HTdHYLiKe/COu5xCdD0i//mtwecOugvaTJKYpXkxH83+/iVanBlsjQBzfqygTPviycLn1ITSPGlFTcgq/j7k0fGdufbdolO98d2++Ltr6u4zEDest2sGSFRArXnBhGHZl/fNVYrUaQS9wB80YvoA5++CICTsvR1mBWHiq92XeFsdPTLnV09OEzONiwuRYfFSeRHG29UpyYesEI3ysr5cALQ7k+zIDiO/yrR8jWuEmr/GmW1jvOWftt1bqnfgtS4ga8AF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(2906002)(5660300002)(38100700002)(54906003)(66556008)(66476007)(316002)(6916009)(86362001)(186003)(2616005)(9786002)(26005)(1076003)(8676002)(83380400001)(4326008)(107886003)(9746002)(8936002)(66946007)(7416002)(426003)(36756003)(508600001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kctm95fTwD6gdKbE7etdqLQmiq4kA5DPEB4LfBDUoLfx9oih35+2h9t4JThP?=
 =?us-ascii?Q?i7N5a7QjolafbbXomItxiKyJgiVKLJVfx+Rp33XmoarlyGCf54TAsV7Oiu2Y?=
 =?us-ascii?Q?a1Cv5uYgu1St/JfHpRa/7WbIc+OmDWrzmequ3TyR5HKp8IyzMEa5gMHpJtj6?=
 =?us-ascii?Q?Po+I0iwbMbWCbW9cQhd4VZO76mm2fJjDFEqsYjx7C2jOczUSa1db+i1k25zH?=
 =?us-ascii?Q?GIGEbqw7QT7b6f1LHra/VteA2Q6t2FF9//WyyXdqldHLH8sEj+Yh5nHUBXWX?=
 =?us-ascii?Q?usejXntXOzzy0Ogp374VHU49ALB6NbpBQOXpgu64nI5zqUbi678HmnjV4bnm?=
 =?us-ascii?Q?P7Lp5W/ogwlCOjJnpCqvByKae2bUXwERts+qY2QDZ+a/fnElGVKFf8NpUks3?=
 =?us-ascii?Q?qBqw3cc/wnsKJzf2pb9K5OVhkH3++gNn/Hm+J0IAxkSBvg0B+dEK8sXttc3q?=
 =?us-ascii?Q?46UbzRnzCevVw32m3SHrd4dRrpR3g1JTfB2lfvoYEqSqNT/LfoG5IrrjN+HW?=
 =?us-ascii?Q?X2giYbnZlaIawS6mAcrT/XjVc0Yob53nYY16fyQ2tgigYsyjp+3YR7GrPUW/?=
 =?us-ascii?Q?YyLFfrtpki8fEACsKMOOY1keuKxjoIdYxuv02C8NtjJxZeuZd5xHujxNsdm4?=
 =?us-ascii?Q?DsfUO0k60SwgoXLCzBxXdfMjowrv1r34oiIjX24jlIJuRDTMnN1XOu2WvYfr?=
 =?us-ascii?Q?BakktZic+CuvgFPpr8g0Kj86OGFzSurOfUjrx4AdcttzW23mWLzduQMV6UtZ?=
 =?us-ascii?Q?4ONb1+xuQIjAo5qIl8IQViOadxhMQT7q0HAnVpCrWgDjT+JYwK/V5EG3uuXA?=
 =?us-ascii?Q?xki/tKqXSrRCialraU9+6bW+OzZbJT55CvDnZg6s45KydIAXI6EYq+14yqEz?=
 =?us-ascii?Q?AP7rcaulR+Be0RP+xLhX5aTmRa7JfTyW76Z8ELAMIfhXx5nwH3UMLmSixA5z?=
 =?us-ascii?Q?u7nVDK1USs+kcNfwzNvxVSyKMnSWuKebcLUIdfYOpQ1INLdOnh4DS3QpU9Sa?=
 =?us-ascii?Q?JamSYSBLE/LSbOPCSsgpnl5X/1Vo4uZYsq7vVCmqsdKEtH9x51+z6lDQNUqS?=
 =?us-ascii?Q?ZCASeWzihaYqtjEhtp2DdX09IG56K8B445tUH05x8+tVAq48eR4b7fvGsrs/?=
 =?us-ascii?Q?prC/ypJ1ABs5IC4V+jZk+SVVrfoetU+7pe2dR8KFPOkb71xAJsI8+2Fw2iCD?=
 =?us-ascii?Q?P2C0Gt1AbmzzcDrIZBHUEvHOC37l94yjW4akmm723EAEASZ+CmmprdwMO9KL?=
 =?us-ascii?Q?B22JUnRcr62RBj73PGv6uYJAmrEaRHH69rTg766w62pT8sIKCBgL+j5TubPO?=
 =?us-ascii?Q?8pWiCIHEORqX1LoBbxENv76j?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49fe2311-935a-4ba1-a050-08d97d639c02
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 00:55:02.4169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iqAMaSmmk3iPf02w0jt3FL4qXGOCj7WQmwO2QnLAEeEPDA345PUaO0jeWVKSULPJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5173
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 21, 2021 at 11:56:06PM +0000, Tian, Kevin wrote:
> > The opened atomic is aweful. A newly created fd should start in a
> > state where it has a disabled fops
> > 
> > The only thing the disabled fops can do is register the device to the
> > iommu fd. When successfully registered the device gets the normal fops.
> > 
> > The registration steps should be done under a normal lock inside the
> > vfio_device. If a vfio_device is already registered then further
> > registration should fail.
> > 
> > Getting the device fd via the group fd triggers the same sequence as
> > above.
> > 
> 
> Above works if the group interface is also connected to iommufd, i.e.
> making vfio type1 as a shim. In this case we can use the registration
> status as the exclusive switch. But if we keep vfio type1 separate as
> today, then a new atomic is still necessary. This all depends on how
> we want to deal with vfio type1 and iommufd, and possibly what's
> discussed here just adds another pound to the shim option...

No, it works the same either way, the group FD path is identical to
the normal FD path, it just triggers some of the state transitions
automatically internally instead of requiring external ioctls.

The device FDs starts disabled, an internal API binds it to the iommu
via open coding with the group API, and then the rest of the APIs can
be enabled. Same as today.

Jason
