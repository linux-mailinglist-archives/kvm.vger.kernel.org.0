Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58E4611E55
	for <lists+kvm@lfdr.de>; Sat, 29 Oct 2022 01:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiJ1Xxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 19:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiJ1Xx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 19:53:29 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D3D1C19DB;
        Fri, 28 Oct 2022 16:53:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RDFumddwj3X+HAntcaH6mgTSuzJGgaufgbGNa3DIX5emeI0C/FpWjayIletFt9eX5UVb3HTHBF/uR2DXDxLKnlkbdVsgyGtOhF1SnPsKKNrliFOYkmBRQxGgMSRM8nH2kDeq8bTRJmmYypY89wIoeqbWfhcNzWk4VKgw/O27K4hAMs6wH9MBMlBeeTrjl8V2CArze4TZO/ys4nqSVud7+dlqXAKEIsxfq6tBg15CiZhngVRnF5x2/V7yPxLl40bafuMVrTCvi973TRp4Cvcg2br4jPuq4bwKQ7wbEc2uP/Jl1Js23rvKNWVYAKJ6UR5obNETiR/FS1D6ms2f7Ua8JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yz2vhMKy56MLe8U4iiuILLTEF9KvVUBNGDKdvJAP3zw=;
 b=IToNYfb0dHVAnOt4CKV1AtRS4JUk3bF/nTJ+ETL0IcblZPKhxs3u1+MinisUmmf8oN3kesrJ/f9XW+cqynM7pD/1kcgEGkDHf8p3RN51/KeDFnXAgAyESMeuqHjDyza/zDPKUDmlAD+yQVjV69YeghOBPXAlIncTa0nugr3zc2/JnLl6ZA/V3JxB274xkcSgbDOx8/01MXv+gaaA/NYBzT6EhWBEU+A1R0nBQIwjLZeS4/hGB77vD5bOR9pQ0Q8lPOEIjOql//4l5ZDtziK4T4P6CRnYltI4MkWcxqKvbkySo4bBLbt0nZJY5NccFcxgT0oiQcrdrYuGU8Yi7p0ubg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yz2vhMKy56MLe8U4iiuILLTEF9KvVUBNGDKdvJAP3zw=;
 b=LrUuviQbKIYlJXvTVUw+JtXoDETzQLCrKcqpcEIcXZ1ovW6xmOKaAc2obyImV817hUltIbV4M+QYnExA1PnZV8rOEaHrm8pWGDcNg+YYi4xBMKIywE504a8kGGRr+Svh6HJ4DG4KSSjanu9OfTezxcqLmZVCj+jntGz7Ob2aI+aWs2HhtFHb+4XigXXHjSopx3aKGuSiaMjDeDqP85wnY6i0pSVXeoZxgSiTxKIbsklKBlSWWfxpzHCi4BqUvZG/bJl3OomdBLG8K61TGURMJl2UGKiMIf7hPi+6uk3zaynwj7WwfrF6Aako7YbebkgxzQJUlCNCxPqqd26ZF8BXRg==
Received: from MW4PR03CA0231.namprd03.prod.outlook.com (2603:10b6:303:b9::26)
 by CY5PR12MB6204.namprd12.prod.outlook.com (2603:10b6:930:23::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.14; Fri, 28 Oct
 2022 23:53:26 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::5c) by MW4PR03CA0231.outlook.office365.com
 (2603:10b6:303:b9::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15 via Frontend
 Transport; Fri, 28 Oct 2022 23:53:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.14 via Frontend Transport; Fri, 28 Oct 2022 23:53:25 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 28 Oct
 2022 16:53:21 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Fri, 28 Oct 2022 16:53:21 -0700
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Fri, 28 Oct 2022 16:53:19 -0700
Date:   Fri, 28 Oct 2022 16:53:17 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alexander Gordeev <agordeev@linux.ibm.com>,
        David Airlie <airlied@gmail.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        <dri-devel@lists.freedesktop.org>,
        Eric Auger <eric.auger@redhat.com>,
        "Eric Farman" <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        <intel-gfx@lists.freedesktop.org>,
        <intel-gvt-dev@lists.freedesktop.org>, <iommu@lists.linux.dev>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "Jason Herne" <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>,
        Longfang Liu <liulongfang@huawei.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        "Halil Pasic" <pasic@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "Rodrigo Vivi" <rodrigo.vivi@intel.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 00/10] Connect VFIO to IOMMUFD
Message-ID: <Y1xrbbTEsaEEcU7O@Asurada-Nvidia>
References: <0-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT037:EE_|CY5PR12MB6204:EE_
X-MS-Office365-Filtering-Correlation-Id: 58159224-8e72-4a7e-4d53-08dab93f9aed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L8zsAf1W4D79SnMvtU88s9R+c/kukEpRkrciAC9pott/+z3LWH690NoSgcvCDQXpFjpm4mRnUTHrhs//BwR4g+39pnY7+UREEENsfbd5GD/aUvF5YtuE3l002KByJQxzZOJFuqa6mizEobiAinMC8daZEOYnKAP1ZMWZxbWYiFEjMVzjWGzXfjzrfA1VrvJhdYw/Vkklhs9QMa1WWVDlBRkvxVCIxXcA8z2QhKFj2XNtK+8M7Zh824UcMLT1sZU3OuZyGv2pStVvEBdrXA1R7p90Dg2iMXGDnhxvrMxwBJrej1pXGVcnH4uschgPTTdDYe0GJBSAQ2SjQqMm92tdl/N2FapEe5hU/v7wddgiRXkw6sF5nIciHjn2Z/ruDZIy85nN2hgRkAniT1EanJwDSwp0ldFkpHCJKtbej6sssc7zH1juKI8ClpO0N6b2eq9bQSmjrGg+YUmBFtMygQSO5ODJUi50cft4SqwSGsbUsRQfPdR/Xad64tXA+rHk2rTTq0DKibFCQcNigx00kmdDUKanSBlQEZCCwmsbYUqMdVi52awqaLsatC6YK5xkkmmZob90H7rCvyt3flGzcDzL7os0cv0xlM9rB53cUH5223s1GeGO2BtlqSSLFC0GX0RI9dGfyUMoVcBYw5zWFFkSXrkTzpqrkPczLmJarx9/loGVQ4D6JxhU7vXdm9veKqy5NblgKJhwKmntyvjE7e8E56ox6nvgBpzO0AcKVgS8VPkzWBwCwM52DY8cCHTvYCgkUQHC5Foa0xh8tNma30cSJFezX/zEFnm8mfAY4uHV2QPLPlo2AL6TNQ2pe6raabb1gQHzUw6fm3uZQgHPiGbXuoEwoW+j8G5ncAuOzkf33PE=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(136003)(376002)(451199015)(40470700004)(36840700001)(46966006)(478600001)(966005)(356005)(7636003)(33716001)(82740400003)(6636002)(55016003)(8936002)(54906003)(316002)(86362001)(83380400001)(8676002)(70586007)(426003)(4326008)(41300700001)(70206006)(26005)(40460700003)(47076005)(82310400005)(186003)(2906002)(36860700001)(7406005)(6862004)(9686003)(5660300002)(40480700001)(7416002)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 23:53:25.8574
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58159224-8e72-4a7e-4d53-08dab93f9aed
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6204
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 25, 2022 at 03:17:06PM -0300, Jason Gunthorpe wrote:
> This series provides an alternative container layer for VFIO implemented
> using iommufd. This is optional, if CONFIG_IOMMUFD is not set then it will
> not be compiled in.
> 
> At this point iommufd can be injected by passing in a iommfd FD to
> VFIO_GROUP_SET_CONTAINER which will use the VFIO compat layer in iommufd
> to obtain the compat IOAS and then connect up all the VFIO drivers as
> appropriate.
> 
> This is temporary stopping point, a following series will provide a way to
> directly open a VFIO device FD and directly connect it to IOMMUFD using
> native ioctls that can expose the IOMMUFD features like hwpt, future
> vPASID and dynamic attachment.
> 
> This series, in compat mode, has passed all the qemu tests we have
> available, including the test suites for the Intel GVT mdev. Aside from
> the temporary limitation with P2P memory this is belived to be fully
> compatible with VFIO.
> 
> This is on github: https://github.com/jgunthorpe/linux/commits/vfio_iommufd

Tested-by: Nicolin Chen <nicoleotsuka@nvidia.com>

Tested this branch on ARM64+SMMUv3 with the iommufd selftest and
QEMU passthrough sanity using noiommu and virtio-iommu setups by
combining with both CONFIG_VFIO_CONTAINER=y and =n.
