Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE9443B8BB
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 19:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237990AbhJZSAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 14:00:02 -0400
Received: from mail-bn8nam11on2062.outbound.protection.outlook.com ([40.107.236.62]:57056
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236589AbhJZSAB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 14:00:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1lAT0TdrA30I8WxNkABwrYDWJZkjumDThwMOd+39+Y814/TVqtSywHi6R33nZgrPfUvuuaJi9suTZdGNI1bAztIRklqpqy6RwiSmAdpeoskXCiHST79keDGwS1lvevrOGshjn55rAjG8BrCku5Ybe1/gMOqbDwFXA8GvNn4iQawJhBapYKFD/m76CpLgU+k3rw8biHDwbp0uQsKFc7f51G7bSXZofzFMIi7ORFOj5m1L3px3plYMtBUaVzEnaETD4LhG/rJ71W/N9OV+AltggDltBfdiZM1czWZkAVGZvZPpK9hM785Mio9TASAJFBlPSqhzt8xJZlv4jC5C1nViw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wNrgBHXR0FvmbXNATRARr8PlsD4WrukHejSRLLj2UU4=;
 b=GfysCpEMEBWqBzGBfqeuhY1MSTWSOf8DSCydz685LXd9JwEBtjbPjDDiQSOO7GRjsizU9zFD7vkEFUoJb+NdrRZjz8DBCD2KwBofaAqH8WOsjqNUTd196CwZniTRnmZPH4dMIAjuR90DcQyqBazM8s1oIrZETtTZx4ePq3ogyE/CGvcdLaT5M8EO4pQXcSmmSuCQ5gCA1RW3pHwxTd6FPOSOYPBb1qxr7ymEucF8J9OiZGnoAHUSN60coTdNoC/Yv22aIh7jfFlQZ+QNP9u+jijqewE2uQdr/o1sI0wsFJ6qhhcnNMWHKPVhEDhwZAKuDpYbk046RpnKwBdQL/nd9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNrgBHXR0FvmbXNATRARr8PlsD4WrukHejSRLLj2UU4=;
 b=mrcn+JnK2WCtSzA8yEbpqUwa9L+zd9LqrNK0R/VsUG1YHdS2+IhsQrOfPReDPBvzH0orSjc6phnYShMXvdtFtcVFUrhtUpVu3c/9XS5BfZ6Sm4m3gYiZKK35qEEqpif8URKHDx9/rbgAeitSvdzgXgf4jXR4/niWM1d73tVvJyK+C0GKyIJTvBJQLZMhuywrYy7IQJmhmy6sa8/zv1U3/WXiP37FcAetxndHfmrZTN1s8sZeX0uShJ5NKFr/jUH/PAgA/5QT/XxDrA9h4WGnhDLJXJOOF6Dlc1CTlxbwyE07n6zilJhJMec4Nicb6XvXu/gdu5fJw3DUUi8aR58+Dw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5048.namprd12.prod.outlook.com (2603:10b6:208:30a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Tue, 26 Oct
 2021 17:57:35 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 17:57:35 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 0/4] Move vfio_ccw to the new mdev API
Date:   Tue, 26 Oct 2021 14:57:29 -0300
Message-Id: <0-v4-cea4f5bd2c00+b52-ccw_mdev_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0102.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::21) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT3PR01CA0102.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:85::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Tue, 26 Oct 2021 17:57:35 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mfQhZ-002BJp-Es; Tue, 26 Oct 2021 14:57:33 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c41c6179-afc7-4264-e41d-08d998aa1737
X-MS-TrafficTypeDiagnostic: BL1PR12MB5048:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5048759712D2154A47F16711C2849@BL1PR12MB5048.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8afkO43Z28MTUVH2SDX7gl75S2Jg9PS8elvJ0Zvt5S0yAOxAMFGtxQVTzVgaO9tzV+uJdNQoPmUFvG6UOrpKNpmrsCnwcR4PsYK3eeR274nDNGehzfgO7wX9z5sa+U4uPLkcnO+NG2MyPtlH3E736B3Fik8e85xnXxDj9CJ+lhfRdZfXmKzaDA/39BMixYNd0CSvZhcQudSrRMT7TZiwE/pxmiBgxPlaaOoIMyh2x5xcb+3/rI4GWxtHmDp8Grd/mk1vidhKumUexLr7G1Qci2zBP/QnhrynsGaJFiS9hB/VKdgBfkF1+C3qm6OSFnWXB23LHvblc4TG04WGaJgrwkVq3fdV8v0ib/MogXxRDjrxgVB9lQErul27qswlV3V1TSb2BwvR47XbpcLL2KoOPojDwqYWsHAtOP69RDc28ASdXI0jrdJPvuJQgUKCJ03KUjreEkMLCjyqynk8dlSq6sly8CWr3huKhq/5JHs0Z+JqXftGbO9Q95JOmkrOvw9pPwzThkK4nOPACMEleRF3IEvxqrqIZ3k528F+H5ZSNSny7MsCJ0ucZw/6whq+hs2PaiDsZeDmZ65nqW56FPCnXmYS8ZkLc4iObFvvNwRttLkUC/aXBLXTGL9XoDGgXP27YTZ2JeY2FiPp4HOogz82QJA45u7DcM5nJpfuHtpVHdSHd6mOJUs+pxNOuOZPsNcM0MFnQa/195xrkT/k75ysPrDvxAKcsjMcN4QKFn9Dx4uaZVpFlZEJ0i2sOo+M8hkFWhNGRFB9ZvpZY+cw6cbwD706/DLhxVHsRdnKhTbA+J4f4qGvEC0zOoFU9CyA+8EoiRo7vkHZ4VeFDTrCdS9l7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(110136005)(54906003)(2906002)(36756003)(508600001)(2616005)(9746002)(316002)(921005)(426003)(8676002)(66556008)(83380400001)(966005)(8936002)(86362001)(26005)(5660300002)(186003)(38100700002)(66946007)(4326008)(66476007)(9786002)(7416002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+sHUweSzkUWAXPQADWqyYEO05ZsiFZeSuxOO/1eIqr0542Pc5uontEEle2p0?=
 =?us-ascii?Q?C0vPRueU92hKtkmk3EbRRukG+xGwy0knVUFwOmkjtLVtfwKwMF3SHMHojMau?=
 =?us-ascii?Q?V4QB0dmRJmb2Bb6WCnw32pq2Mh0CyNuqye1ltaPszOgMjqknMpmBSTxNSe6U?=
 =?us-ascii?Q?22qImJtuskzc6rQ0U8kFAuGlluO/nLcdZF2uo35w5rhxhwSQ1T7g7d7hk9JO?=
 =?us-ascii?Q?la9wEdvhF/B02RoVH98FhO6+dTzvN22AMv25o8o7bFIZOPBLOVQnJ+iVFXNw?=
 =?us-ascii?Q?M1kMI/Z4dPgM1NuIc0L1e8oGyt6w3i181qvgkISc1gP2Bux5n1zQsgmgnWZu?=
 =?us-ascii?Q?nMk0UbdDwLqJepj6rYd16QP1UnHPYzrY07uA09UjxMc5ec51gqpmAUboJ2t7?=
 =?us-ascii?Q?yQVRcVBVOJWAWNQAeJTfdeYsdA9r4vl9+fqtugCvwwmjCQKycgGAxzqCWQHx?=
 =?us-ascii?Q?aoh2xXQ1yDfzR5WSjuUpzfz/viGHXzb84soYuskGOqikShqW30e0udTnApjG?=
 =?us-ascii?Q?i2N1O7S6rX9KO4KHsHoXArgMULa3M79x+Spr/kvg17IsyEOlf7kj6ZRnEty7?=
 =?us-ascii?Q?rbdd+erM3jOmxwko3jfWBh7KdLz6KfbZLMCvnvEOB9U8PGRzPhwoO8lcYp3w?=
 =?us-ascii?Q?E1rIqKOQANSJjGTfGYkPDCCsy778YGkNaqViHSgPuu3V/NafbdTyYwLPSYDH?=
 =?us-ascii?Q?21K7HV1BhRizDFesT2nLLrqnM2QLW6ejfvTYMMn/gydtBmhxmXwzEgmr36/w?=
 =?us-ascii?Q?zEShZ2qv8QwmNFt3I4koONca1ijsMWOVCty3iPz9MgmIegsHyaHfhp3RCgVJ?=
 =?us-ascii?Q?8ngj+zeY9kYmMSdlf68XzxuXtTiWhLfXsmX8nx1sSspoGR+hHoiuIkrNdw+X?=
 =?us-ascii?Q?4dt69/xfDLBStSS90dvL40mT95aVbk5lu+EvVrwmcvU1RQBMIaKbRfdliW80?=
 =?us-ascii?Q?7hjXes078yXiKF6k8h4nHG9LJ9QKwKMfAe1JzlB2LNLl0cG6JytH+VR/d/qY?=
 =?us-ascii?Q?uyzpDSLahCIeK6cHoWMkRVqzT9G1nTAXwe9QSp1PUfyCNJR1/zJLskheLRjF?=
 =?us-ascii?Q?hGM+9WZPh7DHRUrvD9ooqP1w7cpl4hj3vFht3rvJj8TEHGOAlsj53xo43x87?=
 =?us-ascii?Q?QuE/4vJ0scgDbc79Q9xPx0StKRVtKb7YDrK+GNM6zpHhDLukXpCoAoqaWpzt?=
 =?us-ascii?Q?//4/BJxWdto+82mpfdNsHttdo0lisjUtGER/mX0t8a3SSQH8nXKoTVNpX1t+?=
 =?us-ascii?Q?QGh6htbyEvcAcL0HOXK4Cm8qD/2FFQw4Tx2mjkjQc0N9uNUTruJhjJ14OvQc?=
 =?us-ascii?Q?MAzv485hs6TeA4l39gNfPBsDpLIwy/eqM8+et95Ni/IKyAR0kE8au6zwEb4d?=
 =?us-ascii?Q?V8bwNIxN+UJM7dn2PR7xcJdYDR6DlRhmMvem+hBZgx1y1SQj8ETKxccoQFrx?=
 =?us-ascii?Q?8t01X3/iT1ebCxpgLFs+xAqIUod4uOo+OZFJ5eRecq/BKgRCqn/SeIaQcScR?=
 =?us-ascii?Q?Ygq0cJI+h5uITa7/jHhWRhBNw5pfqGh/UMa617NelJGBYEekweudB+rFXUj5?=
 =?us-ascii?Q?QNtWomQOXdH7v3gxsbc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c41c6179-afc7-4264-e41d-08d998aa1737
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 17:57:35.2580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dsRiEy26QQmQD7ozvgNY9PCvIyQDDPJyBCczBsfGTTFyiV+I3a6G6q6RS3Kg3Zwu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the first 4 patches of the v3 series which only change CCW to use
the new VFIO API for mdevs and leaves the lifetime model as-is.

As agreed, we will go ahead with this set and IBM can take the remaining
patches of cleanup when they want. (I won't resend them)

Alex: as Eric has now ack'd them please take them to the VFIO tree for
this upcoming merge window

This is on github: https://github.com/jgunthorpe/linux/commits/vfio_ccw

Thanks,
Jason

v4:
 - Rebase to vfio-next (9cef73918), no change
 - Add acks
v3: https://lore.kernel.org/r/0-v3-57c1502c62fd+2190-ccw_mdev_jgg@nvidia.com
 - Rebase to Christoph's group work & rc3; use
   vfio_register_emulated_iommu_dev()
 - Remove GFP_DMA
 - Order mdev_unregister_driver() symmetrically with init
 - Rework what is considered a BROKEN event in fsm_close()
 - NOP both CCW_EVENT_OPEN/CLOSE
 - Documentation updates
 - Remane goto label to err_init vfio_ccw_mdev_probe()
 - Fix NULL pointer deref in mdev_device_create()
v2: https://lore.kernel.org/r/0-v2-7d3a384024cf+2060-ccw_mdev_jgg@nvidia.com
 - Clean up the lifecycle in ccw with 7 new patches
 - Rebase
v1: https://lore.kernel.org/all/7-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com

Jason Gunthorpe (4):
  vfio/ccw: Remove unneeded GFP_DMA
  vfio/ccw: Use functions for alloc/free of the vfio_ccw_private
  vfio/ccw: Pass vfio_ccw_private not mdev_device to various functions
  vfio/ccw: Convert to use vfio_register_emulated_iommu_dev()

 drivers/s390/cio/vfio_ccw_drv.c     | 158 ++++++++++++++++------------
 drivers/s390/cio/vfio_ccw_ops.c     | 142 ++++++++++++++-----------
 drivers/s390/cio/vfio_ccw_private.h |   5 +
 3 files changed, 177 insertions(+), 128 deletions(-)


base-commit: 9cef73918e15d2284e71022291a8a07901e80bad
-- 
2.33.0

