Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE5151512E
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 18:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379276AbiD2Q7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 12:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbiD2Q7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 12:59:09 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DED31919;
        Fri, 29 Apr 2022 09:55:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LIuV27fvO9Y54Hbh2OMb7Zr8SndWh1STm1IK7VfBfILVnAQdftRVipy3drCDh48Hq367JDc8Uv8cWtQ35mhqWKp3/Nsu5c0YpIkiPyUOJ+ACce1C9wndvD2gOcrYB/YAg1DchsR/mC/CRE0blnxiKoBOrnfz4AY64vowfX88TfOKIKvttM0Yvwsck3hUZILvGxY79kScC0xzHhF59TUclI8dsSaiv0QCSO7ERhOi1sXIHPEHblNpG/ZM+uNYKdiMabLhsyrUMz7zGA6qIDyyI/pOm+RGyPmWlNXDv1tUlzTOVhwHXUDw3/PZgtAB9QW+1EoZVamQVU8y3E6WRUEs1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rGRjP2dU6gNABHmS/u6LU/2fNDY04EL2DiM8u/px7K8=;
 b=VnAj0ZRLTJsb0fZacvg8T1XulkIE2e+Tw0M/x6vg+Td51GBJz6yo3B1QF58Ok4QmkURPPnKcsel7rOFp8amX5+b58CRcBz7yIV6mvZPjcEKeqJNEbw1giuPb129K1YKMdGAa64ArEKL6rpNYPdAXLTfoOek5Tg4rB7p5j5ZK5qOp5lhxPXNs/dcIsQf7TYtvB6OJDcCv+MszhWnDQ5jxWTTN9jsgOAwpxKDt9gUUFvritD18n3NhIaPJbrxJsvrsGsRIGRWohsCKRK610EK55HJXnyuQBi0EDkW5xwMXhU7EN14Y4Ehbz8QSyfKpLbhOdMdbOkB8tS4IS1xAVx2YaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGRjP2dU6gNABHmS/u6LU/2fNDY04EL2DiM8u/px7K8=;
 b=T+0AmUYXGnPhvxZJ7zgVtHFqifTFUqxwL2lUutH/PXy7tbbAsUyh7dFnzNXhQhrvdM+/CrgTPxMtSwi3acgHAuxKqb0blfNLnmKYz3sY73n5mNlR/PyuG+7M891tVtBR5NyCNWTYukkGK85ZUgj3JBz3AA3l8DsGw1yDtom3rNbGmwxO6LRZxzGAmp8YpTfcdxhAbd7hfeNWDAoQ+au+zrIZRPcIochFK8ysMHc+oxK2O1Zmr5bRvIiq4bU8cd1CXduQWwUmaUg7mHJsJ+egUcxFe54JZw+78ijfDrRT9Q344eO+A8VIuaptsXu3+QfZLXKGz6VwYVguZjFG8hybvQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MW2PR12MB2489.namprd12.prod.outlook.com (2603:10b6:907:d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 29 Apr
 2022 16:55:48 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.026; Fri, 29 Apr 2022
 16:55:48 +0000
Date:   Fri, 29 Apr 2022 13:55:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
Subject: [GIT PULL] Please pull VFIO changes
Message-ID: <20220429165546.GD8364@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
X-ClientProxiedBy: BL1PR13CA0216.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::11) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b12c5845-6fae-4531-189b-08da2a011be5
X-MS-TrafficTypeDiagnostic: MW2PR12MB2489:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB24893E49AD05BA8427611DEDC2FC9@MW2PR12MB2489.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UAc1wtP5ankpe6JEwmH4KvBXfqKf/WDv03Odl7IS+SvGXQ0v63h0jPF4T7nkLqnSOvLLu/Y7aAVnhOPCZvo5o6l/08mMbQwXmlE/RLwfwPGYWBnOFFJSq72efzlVud5DhJ3LlGEJZL4bCP9Yg+4ZEF0Z+Q2LAU3x0tHvZs6E/QbxnQCvby3b+6P6A7RhVgHErnhNB9NVwcxl6txTMr6BNe+Pl8DxBBDiJyjyT1MmRXsELSba6NLyoKpcdK1l9Y0rukCrz96P/9J+vW5SVxPZ/VjJ681FTyPtQS8vgkpm1yEpn8GvaxhOVtD2xXU1epbdroPx2B5JDYuLQNyi0SZa44OZ+BGb+gdNw52EgCJDCjbUoAN211hdtkm6I5eNS8Y6DhYQtXOz+H8EWCoMroDPr855vuLcbu1bFkF+ZFN48acV9fV87MAkuoQqdzD9rctDQ3wiR7n0NnHL6O0N8r3EcRgqbGYGQL6yqnNNXtJwewcJjy694alIw5s2xTs1Suk13AR5OYHWxl/a1E6zmzUKsrlJGvVWitDRCooTYbvwJaH3RiAIgx+DL+KpQ0gIX4577SmHSwRBAX8Y6QCPwjNqmh9G6mGXrRvMVqbTaJVKzJ6u5g700pBlU4FeDDRw6t+F3OXUKO2q7iqEQU2YAoW9DL/vud2Cyajeh/6TEp4BqGjO41N4nJ49RMkqyEtMxU7plReDT3Hav16ehqlmdxdz64NIvH5UoxNbPmtgjK5Ps8yeKfnt8nMkzJyDYzq0CD0j7EApm/WJh2GTQC+yN12S9p+4aSuCvtolWjOSuesWx2otlDYpGazUnNG9GcNsHLfhlKPAz3lONKd6G7VjdBxrCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(36756003)(1076003)(44144004)(8676002)(66556008)(66476007)(4326008)(8936002)(5660300002)(966005)(6486002)(508600001)(2906002)(6916009)(33656002)(38100700002)(83380400001)(2616005)(86362001)(316002)(21480400003)(6512007)(26005)(54906003)(6506007)(66946007)(2700100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bZyoKY1cyQdN8hWcGCAHqBLiyP5/DoKNzuaC6y4sr9d1Ugc/6goH8u92LOuB?=
 =?us-ascii?Q?DT2+UrIcFM5fnX11XDS1AEC0AbHvLScxLdH7y88MmmRlv/Lg0xnnrAnXCXju?=
 =?us-ascii?Q?ZfBX1K58UMsvp+u+IWTuIgG5UXTK5D6gHip6hcM9p1x4y7bkqtNfb/djymnm?=
 =?us-ascii?Q?pD6JIPIoXi0Rq/qTjQSwjWddoA2aIVaYZoD1ETOvXTpB4MqlLK4+GFlh6vgu?=
 =?us-ascii?Q?P459g/nj3Lh0xZV/I8eHgP2nQf9h+AFULQsXKUrtrmog/SQ6C5CzPN93POJN?=
 =?us-ascii?Q?qWsbrESWhmwgnEm8hhzjFD+7Do3QEtRnQH9Ud2SLuYB2agfupB1VxzqEKHCc?=
 =?us-ascii?Q?YJXyyIgkbrNHOV23Dn16tWFGsBB6XnGZv4+DdR3H9ouMAcFS0tp0o5rfYn1S?=
 =?us-ascii?Q?keJSyJIpRuWHNi9dkdTQxRIlYBDgda2aHk8HBl27S7V3czt1MndT29LnSdEv?=
 =?us-ascii?Q?sn/9+PuQi9rNs4/N2s/m5hHI4Hvod58j9rS9H3sRmVpfY71JiK1tsERdT5tH?=
 =?us-ascii?Q?lyT/29s4bQ1LlJWzZkzn162gNAXAzTbFlzw8z9kQljXhaluB9a8JBK3ObHVi?=
 =?us-ascii?Q?jz020ouZz3oOJM6+d27kHIly9YHJ4vsDc06c7sJeoCmMrVEjt+oYjdc9fwHk?=
 =?us-ascii?Q?bws8HfiHnQ0AHcxO9k2xrAPFvsvZEwRR8vRZ97sLk4JvMnnD/EePC0AmqgDo?=
 =?us-ascii?Q?x/LisehPLcOp8yiM7z8wgHwv+JXUFoR0yDJsrIv4U1nU+9AfEeRqUH/Pgmr4?=
 =?us-ascii?Q?9h+GCEyUPyU2BCnfV/y8VGwO7+5gqhuStIZszjKpuFNdgjoUVu/GkCG2B9BV?=
 =?us-ascii?Q?cZwfNKTjd9Ge0Z8sG2GggU1X/0RxHeuCO9iFxEuqeQk4vXSUTiKIGP08Oe6i?=
 =?us-ascii?Q?oc1jBj7wRtA6Lmymrjv/Wzc4Dj/JH6+at6SxA/U4/ra+v6zacSurQ0j2Ph+E?=
 =?us-ascii?Q?AxFgtk3pVwd95qsCu9+70n6JmW+sJwr+9du8obog7ym4GmvHTe54YFtqkOEy?=
 =?us-ascii?Q?RartmOJsP94ElPMDonycK8nbmlP6HlZF5fwvulY9Khk7fEPwxV3x9zWUVzuh?=
 =?us-ascii?Q?k/QsMRdOHQ0Z60bwIzXjCui5W+JfoKrXPTgrBxHvFfRML9X0a4oqIivNRchi?=
 =?us-ascii?Q?XKFPNYuI1Q5ndBZX13HgHQQPKQRXY6Z9fzg3hn6D33p8H+pgBmW6DgaeO0JN?=
 =?us-ascii?Q?r6br/oc1kxOWbJu2RSBZH4Wt8s/4PJs+gLHzr/7qddCGjeXV5X8fzUlZTT4v?=
 =?us-ascii?Q?YqxnSFMuj5E1OTH/VMvK/8CTzgKy7OOMMqEmwnVMkpSbQBu/W/6gDMIUpx7H?=
 =?us-ascii?Q?0JSmodZchKi+zdt6n319Ag1Pdu3UUpK7jvswy30gUbY9G+EIyNpUzHOVvJ7/?=
 =?us-ascii?Q?OMKAATsrfigr9ITi71fzeN5z99fIbdXXi+7YXKOJwUNY+WrBmr6qpmWDOUAw?=
 =?us-ascii?Q?DMufxkNi3JjjBHM00DvaVx1tG0QsgAh2brZnh4hSyeOZ9YocoKABfHW0LTRr?=
 =?us-ascii?Q?8CSqHyQkmFG84ZVes3Qaymo/zYNX2byihujlBQs1wE6nlsXwsq1sNZNAyOLY?=
 =?us-ascii?Q?sgyAZnPmI0fq1L9kiIEjoQJiknWSe+NufWkcQEw6T4pTd35IrbY2tHyum+0S?=
 =?us-ascii?Q?UnuQauCIqvGCIi1H1uQ0bAEqDfF5izEc6NX8T3zvo4U6Vvh9Tcj5cdlOAxog?=
 =?us-ascii?Q?LOhFz8RjiZcdWN5L/AxsciX+TSujTsimHXCjy83L2Noh908rSjL6DgwP/VGO?=
 =?us-ascii?Q?aVry4wASQw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b12c5845-6fae-4531-189b-08da2a011be5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 16:55:47.9397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OZ4Ncw/hi2ooxk5ntQVCeO1PrmUyJ/aXkXYSpfm43NHYHRpMLGTCFARJO0wSASRs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2489
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Alex,

Here is the PR for Joerg's shared topic branch for VFIO. It was merged
to iommu here:

https://lore.kernel.org/all/YmpfFA1iIQyGBipX@8bytes.org/

The cover letter for making the merge commit is here:

https://lore.kernel.org/all/20220418005000.897664-1-baolu.lu@linux.intel.com/

It is based on rc4, some of the VFIO series I posted have conflicts
with this, I will repost them rebased on top of this PR and the latest
GVT PR.

Thanks,
Jason

The following changes since commit af2d861d4cd2a4da5137f795ee3509e6f944a25b:

  Linux 5.18-rc4 (2022-04-24 14:51:22 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git vfio-notifier-fix

for you to fetch changes up to a5f1bd1afacd7b1e088f93f66af5453df0d8be9a:

  iommu: Remove iommu group changes notifier (2022-04-28 15:32:20 +0200)

----------------------------------------------------------------
Jason Gunthorpe (1):
      vfio: Delete the unbound_list

Lu Baolu (10):
      iommu: Add DMA ownership management interfaces
      driver core: Add dma_cleanup callback in bus_type
      amba: Stop sharing platform_dma_configure()
      bus: platform,amba,fsl-mc,PCI: Add device DMA ownership management
      PCI: pci_stub: Set driver_managed_dma
      PCI: portdrv: Set driver_managed_dma
      vfio: Set DMA ownership for VFIO devices
      vfio: Remove use of vfio_group_viable()
      vfio: Remove iommu group notifier
      iommu: Remove iommu group changes notifier

 drivers/amba/bus.c                    |  37 ++++-
 drivers/base/dd.c                     |   5 +
 drivers/base/platform.c               |  21 ++-
 drivers/bus/fsl-mc/fsl-mc-bus.c       |  24 +++-
 drivers/iommu/iommu.c                 | 228 ++++++++++++++++++++-----------
 drivers/pci/pci-driver.c              |  18 +++
 drivers/pci/pci-stub.c                |   1 +
 drivers/pci/pcie/portdrv_pci.c        |   2 +
 drivers/vfio/fsl-mc/vfio_fsl_mc.c     |   1 +
 drivers/vfio/pci/vfio_pci.c           |   1 +
 drivers/vfio/platform/vfio_amba.c     |   1 +
 drivers/vfio/platform/vfio_platform.c |   1 +
 drivers/vfio/vfio.c                   | 245 +++-------------------------------
 include/linux/amba/bus.h              |   8 ++
 include/linux/device/bus.h            |   3 +
 include/linux/fsl/mc.h                |   8 ++
 include/linux/iommu.h                 |  54 ++++----
 include/linux/pci.h                   |   8 ++
 include/linux/platform_device.h       |  10 +-
 19 files changed, 338 insertions(+), 338 deletions(-)

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCYmwYjQAKCRCFwuHvBreF
YQMrAQCobJk/ryBnUQtfGwuk5CMb0Jqbg5IfvUNDJiD+DZNB9QEAvnigKvT6C3Ij
J8wnoIabDznotbgEukRPRKjeLb8NbAk=
=QJyd
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
