Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D8862CC44
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 22:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbiKPVHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 16:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239175AbiKPVGp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 16:06:45 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77965CD1D
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 13:05:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/WCI8dGHpy78lClcjzAb1Iv0awpXBbz4sJ5py17uojUrDMFP2SPs4/U9f61PC9qBdAyfDZM+11JYibl+QNODR5/sfVwiJ5+C66hhURQ1YaJgGPuUHqkL0b/DlNGns4CGUOgitd8oxLjyMpuKwNT0LMjZ6m2E/YXR5Ar/ioCyOXM/E8kKi/WtH4cbMy9+TFPLmtRF/7tnBZzG20V57Dh0SJu6hlyTnYFXbQo2CYVaPdmXw+0mBcae5XZ8UD/ka3pBKjHCU+pvAI7e/HJMOV71z+AgiqXIs6gNEk6eGVyQcVl4qwy3jeMAfZg6e2WWs/rsOf6RlJqSUWqGrqBCx1hiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rUGQGalgrSSaGItEGmLj5WB4U/tziD1t/G53aIGR2As=;
 b=D8qwY/ka2AqO/o53V1XZnsKFrQs8UTEk4dwALtk7DajUqwtiCiPt8/WfajI3E698Augg5/Q1HGASpZ1ypn2u+9NwdIrg268RYVR/RGxoE2kIHQLYei96pNwqpeR5ykFkbUk00LQCma3mkKIR7htKeSJF0qkhT64mtRdbV0d5yF2bYulHsheTKp8bsC0BChpE+wC1V2COGhTleGiu0eEyS0yGaRfcBohLulA5CZsyXuL4ukItjT2gScYXX7DRco+NNP8hCEKgtHptHGnMeolhxPiLv5w4eB6+p507Fhw9qKM1AW0RpSC8pVtl6fNtDLDu1f4KUlUWtpVOYfc6SulxAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rUGQGalgrSSaGItEGmLj5WB4U/tziD1t/G53aIGR2As=;
 b=flbqpb8k3XGorMUP27D8ZxK6Ji5xy7UpKCJ2elmm1/Wsr0AxXAQV7ovbU+QGc2oqQEEdCWN4RRDkm9w6e9/UGw7ztHQRBrFHsjARVtsFsJdPfu0fXLva3+0J3dvoLmDUYxHBJ3VLNo+tYjYNOMRn3f3J60tUPBc3EexlxzC620sQM8ghz4oa5EY0SqAjnz0jx9zdv1p7f4hjpb5uiBsXJyFFIOaEPMCv4kMMARa8KruhUAMe1/McM1HjWkePTSmWSbw0jTXzX7TkmJ83ydDDB0KDMULsFLCRekvTofrx+J+wDHThp61nbHR0xu6M2o1RMCABANA2EybGTrZ8C+hCDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB5609.namprd12.prod.outlook.com (2603:10b6:a03:42c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 21:05:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 21:05:39 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: [PATCH v3 00/11] Connect VFIO to IOMMUFD
Date:   Wed, 16 Nov 2022 17:05:25 -0400
Message-Id: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0002.namprd20.prod.outlook.com
 (2603:10b6:208:e8::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: fb55814d-1965-4630-4acd-08dac8164fc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hxep08ThdTfEumcJOM6fFxcsQxsEpfTZKnkMcYCM/oCrY1oyBGFoYm/li6dzj9Fq4P+EXFnd1L8A3pAjtFBLj/IbcMCU+kVKOI7L0harsv8n0bTggjeRA5q1SA4tko/NPiI+PxRra91iqOZdLk0x6qV4agzf98hzNyPMz5N/Km/A90ohruJSxplafDeAOmMWZY4nDYau/3JESlYNahdeLrxiYg4vzpuEGkNVSHwxAA6hY3aZJTtmPMpQzxVFG8ieDEPtjtEjsv8jANH5GhgXYXp2JkWfd/UswqyMTpGVu8p+BMzbWM7Z+vvsP3b1Gt5xOaczDkkxdN8Uo0mFbRUkGzCk52vIgRkyVxlYEX9fz8js6q3jg3TRWCHTyBqrDWC7KV6w9awBMnGo2S2GaN348E/oYlHhiKoSvOZcVbIRKQaYz7JUXpZQ3WhGnD7zxiF5tEqhBwvnqhDC1Qk4CrcM7GGx12E/5aHAIyautCW+IWzURnQh6EQEwe7IYple8hhsQxn5ssl9MPNec0Jh76HozlQRKktT1nVD4EALeyFH0vctGPI39IJmm4ghNB7uwaqFH2PKovboq/vC7RbGjMPN297NKfUeABY2Lq8ynx8W+2ZxViO9Aoz7G9wikfWdUQlbviDCHiIW3m95i+ccper/lP6HKvTMt2cx1Ab+ZmUH5cw26ePr+COjpOi5PMCdjz+oeGVOdkmMkrDYSRMxKH0vBpVJn0BXBOCGz4NMvTfPYFcXPAfZXYEeRz9qoYrQ9UsBQ1s3AkdKbL0o1nC+GNKr+s83QomSDxDebdC0kk2ooYKjyupNAi6zW4LBEk7hrghgAqqWts+6472C26r1+Wpw01+BZmcdAjJ6j301NxmG6dD59F172pHezCLRrdn6COTQMV1Q1NDOekSjj0qqv1u0mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(451199015)(109986013)(86362001)(36756003)(38100700002)(54906003)(316002)(6506007)(966005)(6486002)(478600001)(2906002)(5660300002)(7416002)(186003)(2616005)(6666004)(8936002)(66556008)(4326008)(66476007)(66946007)(83380400001)(6512007)(41300700001)(26005)(8676002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NG1dlAgVl6JyxUKVJUuwNfylj93NZtvoKjnSikfmH3EwpOjrSch9z0TKHcX9?=
 =?us-ascii?Q?4sS9jv9awrzDzkjtO/5Bk+tq1THXPvoJTd+AWCYNPlkuZu+IRQBk4juzd+ZA?=
 =?us-ascii?Q?xkc5SjCXR6wpr9QCX3vSrYD3asMRtqpHh8Z/o8W7+I8vFOq/UhP2ya5rkGeP?=
 =?us-ascii?Q?Qj3YRCz+15NjWZUeZpSv13UFIMxSj9DU4SddIUAnKyoVuVNnD6SoNr509fBG?=
 =?us-ascii?Q?QKfRk3aMmVRuY8kbKSg2eDnKM5Max39hUPNplqqYz2tqSUyq1KOPKZBdngWI?=
 =?us-ascii?Q?oAvS3B36MtL0hIY17Jn7fkK/O/hyRrndHYRzbQF2F2YpR3WauOHSlq6VyJ4v?=
 =?us-ascii?Q?im4V/khLquWj6+eFosb1ekdAjI7BIqCeJRe5GtFwqT7rIZxI/Ij7uFNliuBH?=
 =?us-ascii?Q?Lcqq2hFtLLt4rwwr+3eGFLpqw9xHptxdD7Ym7ywVhJU2GStZk7LgmAwBF2ul?=
 =?us-ascii?Q?oqK8yPXvtpzX4Yrz9QhEBB4CoNNFEJr4bBvDwa32VgBrZT7I7ARsCoLK+w4D?=
 =?us-ascii?Q?kCA/k/gKmOcoRXxPvRSp5zcvlF5R94lXUTsN30s16TmGU1qXpCCPBgcNVaOf?=
 =?us-ascii?Q?y1Ow618IXe+K5sBIYf2dMXDkiK47hGj+iL82a6r+Hodo8DMB6nZX6nUdCVyd?=
 =?us-ascii?Q?Z6YXf7jLh6xmhLvt52Rcci6AWDJX61+vRolXu0i5x+WPvvOsYibK8cUQwjJA?=
 =?us-ascii?Q?mR5DdJnbCSZH5AO7CwBmsoa51SIy2QvVO5Pa6KrC/Ye1ip+Zp6YPiTOINii1?=
 =?us-ascii?Q?g1RQHaFcWpeKhT4CbJtlJjV5AhUSU6WuyOM1QRUBreUeIC82Vt6lLQNnXGSv?=
 =?us-ascii?Q?KzDpChNW0wbNoeGAUNNkfEtpqap1OJtGiMKPFOn31r/3GHekx3GgNNUxR8fT?=
 =?us-ascii?Q?4MAYNV2s5HcqTne3Ep1Q1RDyMpLUTBIh0kGeK45HCw51m1VqGCdsiPtx6hSg?=
 =?us-ascii?Q?/h51pkAgMpuEP4RpHPs1YCk03EpxYMdiq0sPvkkD9sgY/6GYi28k7FxRUmUa?=
 =?us-ascii?Q?BsfHINuNLA+xkAevjBjFhvMxOsmO1ZW5J1OSZARbohZvyrObP6Vvd9+q6bxu?=
 =?us-ascii?Q?30t/qhVrTmDwp24ueSQdpkLqXxLeZmrYqmLIdq4vcxJJnCVhKTgtcaM9WaZd?=
 =?us-ascii?Q?IiN0nAQykppfsuFYj8xRQ2wkDL8hY7B+W7qPOxu4J/v44hbEp9hkvbnnQ/RX?=
 =?us-ascii?Q?5z5Ofbx1rcrUaL69HRq+tplwbxFcBUnkowanXToYsvuhBCr9RM5QsdET6tCq?=
 =?us-ascii?Q?2DcPO3qdnZ2Ok+Nop50cBtzz1KMIx6KYcC/e277jPZJKKiuE11s9fL4/l1E9?=
 =?us-ascii?Q?wmtv9eO0GBfSCPRR1AudHAjv/vj89bNp3a5bCFL1mVwe1VkaVE/9FZDL7dx6?=
 =?us-ascii?Q?kuGMAwYjxCfF+WeO9qOhxVjH90l2V3Ii/dFiuW+OMGihKFXkBizJMctq2bu5?=
 =?us-ascii?Q?OOEwjPsQ1skxGHaDdyfhajgxb6nhYdd8DYL7bMtjuLozaKFlcsRI4Jlw+0UP?=
 =?us-ascii?Q?0lps1HsZ34cHPv6vLfo3Td8HETuO80J2ZA+yuAC8euvpBSt0CyPTfQsWOfzh?=
 =?us-ascii?Q?NV90hCGEuamrKxN6Ncg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb55814d-1965-4630-4acd-08dac8164fc9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 21:05:38.1023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TTZLKytZ0NaOnljTqQeyikVy4UfN+OgjvFFTqzJ6bD+ZePD7/ZaJ+Gz4//Bt4iEp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5609
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series provides an alternative container layer for VFIO implemented
using iommufd. This is optional, if CONFIG_IOMMUFD is not set then it will
not be compiled in.

At this point iommufd can be injected by passing in a iommfd FD to
VFIO_GROUP_SET_CONTAINER which will use the VFIO compat layer in iommufd
to obtain the compat IOAS and then connect up all the VFIO drivers as
appropriate.

This is temporary stopping point, a following series will provide a way to
directly open a VFIO device FD and directly connect it to IOMMUFD using
native ioctls that can expose the IOMMUFD features like hwpt, future
vPASID and dynamic attachment.

This series, in compat mode, has passed all the qemu tests we have
available, including the test suites for the Intel GVT mdev. Aside from
the temporary limitation with P2P memory this is belived to be fully
compatible with VFIO.

This is on github: https://github.com/jgunthorpe/linux/commits/vfio_iommufd

It requires the iommufd series:

https://lore.kernel.org/r/0-v5-4001c2997bd0+30c-iommufd_jgg@nvidia.com

v3:
 - Fix iommufd_attached to be only used in the vfio_iommufd_physical_*
   funcs
 - Always check for iommufd before invoking a iommufd function
 - Fix mismatch between vfio_pin_pages and iommufd_access when the IOVA
   is not aligned. Resolves problems on S390
v2: https://lore.kernel.org/r/0-v2-65016290f146+33e-vfio_iommufd_jgg@nvidia.com
 - Rebase to v6.1-rc3, v4 iommufd series
 - Fixup comments and commit messages from list remarks
 - Fix leaking of the iommufd for mdevs
 - New patch to fix vfio modaliases when vfio container is disabled
 - Add a dmesg once when the iommufd provided /dev/vfio/vfio is opened
   to signal that iommufd is providing this
v1: https://lore.kernel.org/r/0-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com

Jason Gunthorpe (11):
  vfio: Move vfio_device driver open/close code to a function
  vfio: Move vfio_device_assign_container() into
    vfio_device_first_open()
  vfio: Rename vfio_device_assign/unassign_container()
  vfio: Move storage of allow_unsafe_interrupts to vfio_main.c
  vfio: Use IOMMU_CAP_ENFORCE_CACHE_COHERENCY for
    vfio_file_enforced_coherent()
  vfio-iommufd: Allow iommufd to be used in place of a container fd
  vfio-iommufd: Support iommufd for physical VFIO devices
  vfio-iommufd: Support iommufd for emulated VFIO devices
  vfio: Move container related MODULE_ALIAS statements into container.c
  vfio: Make vfio_container optionally compiled
  iommufd: Allow iommufd to supply /dev/vfio/vfio

 drivers/gpu/drm/i915/gvt/kvmgt.c              |   3 +
 drivers/iommu/iommufd/Kconfig                 |  12 +
 drivers/iommu/iommufd/main.c                  |  36 ++
 drivers/s390/cio/vfio_ccw_ops.c               |   3 +
 drivers/s390/crypto/vfio_ap_ops.c             |   3 +
 drivers/vfio/Kconfig                          |  36 +-
 drivers/vfio/Makefile                         |   5 +-
 drivers/vfio/container.c                      | 141 ++-----
 drivers/vfio/fsl-mc/vfio_fsl_mc.c             |   3 +
 drivers/vfio/iommufd.c                        | 161 ++++++++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |   6 +
 drivers/vfio/pci/mlx5/main.c                  |   3 +
 drivers/vfio/pci/vfio_pci.c                   |   3 +
 drivers/vfio/platform/vfio_amba.c             |   3 +
 drivers/vfio/platform/vfio_platform.c         |   3 +
 drivers/vfio/vfio.h                           | 100 ++++-
 drivers/vfio/vfio_iommu_type1.c               |   5 +-
 drivers/vfio/vfio_main.c                      | 348 ++++++++++++++----
 include/linux/vfio.h                          |  39 ++
 19 files changed, 714 insertions(+), 199 deletions(-)
 create mode 100644 drivers/vfio/iommufd.c


base-commit: 9d367dc905dd278614aaf601afb28e511b82fb3b
-- 
2.38.1

