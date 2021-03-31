Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A143B3464AC
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbhCWQPc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:15:32 -0400
Received: from mail-mw2nam10on2048.outbound.protection.outlook.com ([40.107.94.48]:9569
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233118AbhCWQPL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:15:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mq9tEAE9lyh4rvIZd4hkjyJ5vpCalmKWket4r+G0S5VCPwEs5mO6TekYUUV/A76svplRaCGnFeHrrGuDidY2USeBrdtE8KdetazoKQpVg3COIG8FeiHZuGOwW220UKreUfQOaRIY3AoqtCOuOUAN/onJ+dJWxfyjr6XQx3UP0s3OpYIlz38xyzYX4u1PYce48d0vNZbJOtWTner+92wGYERJb0n1XbVMU1jnZqLjggkQ95DTO+O7q6ZDkIsFBTij65QF1oPJLwS7RW5LWGjaNJJm5cFl44dFld2NUOMwmT+zWvASGa9wFYm/GmjhTXg2sCyCtP9+GFNZDEJ+Ve8PTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPMesbtEJoef/OEF6aKiGz53e7AWyoPvfx/uKZplaHM=;
 b=hadnfrvGaWA44J53qmfyv6W8umw3Id68U9CJINv0LfXmCNqdXt1/EKM/Fs8cG0Q1xVOdAcjiGP/vhNCxmRpYvmiR8MNoXR1K3LT+3GaIpmC0hSrGT8t7xCT5NIdFdvAAXsvvDJH1gSv26MV2+pLWeaMtw1OCt+JGvKO/+SbUerbl4KetkiJiwxM88uwj8qgRQ9XZZ30zfMzaPqVyvAGbnGaL74qeULFZP7ve38QRNEIjdFH6wvzNUNc5Z95mzxvhHL6MlL9CmCgqNxjLkPbUmtvNBJ3VoY48wCbzJ6m61j3CRVdYseXzyFtD2lEk8b4epRGdsv170fGxer4E2o6bHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPMesbtEJoef/OEF6aKiGz53e7AWyoPvfx/uKZplaHM=;
 b=Tpp0NW1DuhiHWUOTnNs74CPLc4lKuNHLlqEgb+l/fyUi2Jg6vosYxgetmCXp0zh6kwzo1Mt3hUEmkvWQqWOwIMr1O8sxSVqYxQ2v32m78dL+xvr6tppmNxTq725IGg2HjPqSB3BwMJEY+XSnYBciA7n/HA1CUtj5DUZEVGh4mZMzjrnr7ljJES8HUeVHfO+NEM7cAr4Gb0TJ+TAhwar2WjyrHBFXvK3cMnvdwnXX6UT3mMp2PBXMPzx7bctYBcwT+/E4YRD9M5EEKTvBSFWRUvYxE3v5b0tfFh2SczkKG+aL1q2kNvhXCbOtgzN/oAuq9C2U9sSa2upEA88ZSYvnUA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2440.namprd12.prod.outlook.com (2603:10b6:4:b6::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 23 Mar
 2021 16:15:08 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 16:15:08 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Jike Song <jike.song@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: [PATCH v3 00/14] Embed struct vfio_device in all sub-structures
Date:   Tue, 23 Mar 2021 13:14:52 -0300
Message-Id: <0-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: MN2PR19CA0019.namprd19.prod.outlook.com
 (2603:10b6:208:178::32) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by MN2PR19CA0019.namprd19.prod.outlook.com (2603:10b6:208:178::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 16:15:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOjgQ-001aCM-9T; Tue, 23 Mar 2021 13:15:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22e52f60-0197-4766-02c5-08d8ee16d36f
X-MS-TrafficTypeDiagnostic: DM5PR12MB2440:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2440653A003C886004198117C2649@DM5PR12MB2440.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ulJo4HeASzBmUefh8SVlb3gATJh2nG2Mq3C2jibQ/Vl/etwKzNSGRUn2/CA/AH84ofU/0XH4coLwoyufsRsZOuvNGJljUEjSTb1RGjXAy0cb8EFHcNynrkrYfNg/LIitzbi8sQoX9ShikzFTkAzQgYCZwqB9Mdcb7zjKhsNCJpVTU4GDPKricRnFaStvhezWkt2dZeEpgsYecENGjsrfSvbpm1wm/UUIBgbpAy0zR2UikXrsI6T80U8O5wB2dyngUHl2bLJn2I45PuHY9Pw+u7DdSeb1SbOfEr9oF3/wrdLHowQEZlm7WrxKzYGGeJ2F6zEMfWLdA14T2BiNYvt/JW8iQWEDg0XbZKCy8de6/rUCju3mWg1E1BjBcOL31bIi9g1Hb9pwleAFrm149QhKw8nxlKV/mFdp7jgaIS5lRDMGvsNNeFyoetvFKSvUOSMzLPBc/Wd+y86ZQOI2o9FAD6o5ql/z8XhzgDVa9ZhE11d4e/Kig5U9eibbexFdovCxhU1aiMrs3EQv+MvMTvqy/BH3QRK9SQTU6nFVpMKLQ0+uj7xEktRHoqx/QLZoHUyFmE8/beNf/N6NjtdEcp6/e68hhSotno09h4I2zLET8uR1XT8VY3eKN9/THZae6uZLIwXltVtiOpWXwHW9ESmI18ArTODUcOWM7iWj39JLgXTOM4Vz7TL+YDxV7lXTDViCTc3d1MvmeORQ62Z/kdb71UaDDbozpk7YQl9LTxNoqupkZnJvRRspTLzgxvkdn5gcdQJiyVnuf084zTScWoXVMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(66476007)(66556008)(186003)(36756003)(966005)(6666004)(86362001)(38100700001)(66946007)(4326008)(7416002)(8936002)(54906003)(9746002)(26005)(478600001)(426003)(8676002)(9786002)(83380400001)(110136005)(2906002)(316002)(5660300002)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FxyUsTzlrrUgz5lDeW1O3G+zKAIqqwCOvDTQfQbBAM8sN7XNT7QKSyP6o3G9?=
 =?us-ascii?Q?L3Bke1gxvS3ezryztU9pUNPjyKfVbNND+e3BwzDplRvxeu4p3S1MNPs8jdPP?=
 =?us-ascii?Q?d+GK1PKFdFgtZ/R26zh1HC0gPt5RXL9Ds8IJYVd8NNoByxzv7lBsIVmuxEMh?=
 =?us-ascii?Q?83wD2GwxMWEAxP0E7RAZZISTZPsjG+0S1FR/nVM/ohm5cCjuKayTVOduSjr+?=
 =?us-ascii?Q?yUleDq+qDTCvE2LwbDVDuV0NmmPsjFj6LFTWGlQPT7BUnDtcJX0kZ0Ja5piv?=
 =?us-ascii?Q?adjlxU1AmPS3ZugAF4/47YTOV1GyVZunsnALKcrCFJ3dJH5gaQ6SIS12W9Lv?=
 =?us-ascii?Q?lRMC6nKS+X1NTz4xcvot/rGsCjvQQV+NV39WAs0ly8P5USTuH6j5TBcMmAhV?=
 =?us-ascii?Q?rQPstQNpHDnyskqdb51uhQRQ8CYjHbbFeQyy0P8F64xBa/TeMvp/DYaBUjwF?=
 =?us-ascii?Q?/rqkrR8H1JS0NuIhaW8c0DQy5cPn8g3B9KSMarlRfISw9bwzVL2SEaQcF0em?=
 =?us-ascii?Q?1vuirRVRIKzXW79ir8mJWTQm0d265a7pf4WLDHszYpuy+xipnMGspU06XQeA?=
 =?us-ascii?Q?InUBsBO+uHbur4y36yIVdKf2jtIdODTy2YnG8FambgsI2KFF2LLCMgU4Fp62?=
 =?us-ascii?Q?QgcGACGGLREB6Pe+l2/u8N3HLM17ZeR9l/p2OHFY8P5eBeGBftUwFCBqBylQ?=
 =?us-ascii?Q?GaZFWadiCx6JEGLpfHqrkhRHKBkyr4/53RhdpK5J4lW7yO0ey5mWkdzpSOkT?=
 =?us-ascii?Q?QLKHbefDgMMDuYuPnoM7zjiDtWUd0Y1xZP1uJOwsWUWn1JTuIPExdU4JNcsB?=
 =?us-ascii?Q?FSwdwcZQ5RJ+rv+g0MMPk3wb0Z9vFwc3uDm36sd3ctpBXsNS3TCRBocm+9Bl?=
 =?us-ascii?Q?RpzuZEtfLMkWIc7RMZWwS1rM1gprsFqCGov5w5ohxntCFjzrJkhgxMjtDLu+?=
 =?us-ascii?Q?jOBSypxiba7KAACM29TZ+qRM9jTttp+CN8N8Y8MPqeRBWjYCUi5bf5QPCjjA?=
 =?us-ascii?Q?0QbRTLIqMHWxUuConHQf0n33WrEnwAGRjHq53qMvPfijddwpXXh59AwKHCls?=
 =?us-ascii?Q?o+tjVlwE3BM/9xg2D8FhdxRk3XA/oDanJsNNW3CaJO9FkoUakN5i4yg+JxBR?=
 =?us-ascii?Q?/d60xdE/R0uZkdCs89SdZ1hb3qKvEhvpol1i9Y6KKlA7BorVvsZqKyJBwb3q?=
 =?us-ascii?Q?+cevgk86gwhdyDrDQ4Z16dh2g3kBTDzhqgbLTLlM2nei5BkfuDZ3+Cekjuo7?=
 =?us-ascii?Q?B8DdloOwUpdFo1Az4Z50ttUqCJH8cJw1el7uq7CL8J+auE1rqxyqC3aM1G9R?=
 =?us-ascii?Q?GEuJzwEgVnFjCMGQ37ewMCfu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22e52f60-0197-4766-02c5-08d8ee16d36f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 16:15:07.8962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MjdfHtupLxQixeGUbeM7T0yeFDUHQdevO0oxOW4uodxyoa1uGwOGirauI4R16VsD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2440
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The main focus of this series is to make VFIO follow the normal kernel
convention of structure embedding for structure inheritance instead of
linking using a 'void *opaque'. Here we focus on moving the vfio_device to
be a member of every struct vfio_XX_device that is linked by a
vfio_add_group_dev().

In turn this allows 'struct vfio_device *' to be used everwhere, and the
public API out of vfio.c can be cleaned to remove places using 'struct
device *' and 'void *' as surrogates to refer to the device.

While this has the minor trade off of moving 'struct vfio_device' the
clarity of the design is worth it. I can speak directly to this idea, as
I've invested a fair amount of time carefully working backwards what all
the type-erased APIs are supposed to be and it is certainly not trivial or
intuitive.

When we get into mdev land things become even more inscrutable, and while
I now have a pretty clear picture, it was hard to obtain. I think this
agrees with the kernel style ideal of being explicit in typing and not
sacrificing clarity to create opaque structs.

After this series the general rules are:
 - Any vfio_XX_device * can be obtained at no cost from a vfio_device *
   using container_of(), and the reverse is possible by &XXdev->vdev

   This is similar to how 'struct pci_device' and 'struct device' are
   interrelated.

   This allows 'device_data' to be completely removed from the vfio.c API.

 - The drvdata for a struct device points at the vfio_XX_device that
   belongs to the driver that was probed. drvdata is removed from the core
   code, and only used as part of the implementation of the struct
   device_driver.

 - The lifetime of vfio_XX_device and vfio_device are identical, they are
   the same memory.

   This follows the existing model where vfio_del_group_dev() blocks until
   all vfio_device_put()'s are completed. This in turn means the struct
   device_driver remove() blocks, and thus under the driver_lock() a bound
   driver must have a valid drvdata pointing at both vfio device
   structs. A following series exploits this further.

Most vfio_XX_device structs have data that duplicates the 'struct
device *dev' member of vfio_device, a following series removes that
duplication too.

Thanks everyone for the reviews!

v3:
 - Fix typos in commit messages
 - Fix missed name change of vfio_group_create_device() in a comment
 - Remove wrong kfree(vdev->name) in vfio_platform
 - Keep dprc_scan_container() after vfio_add_group_dev()
 - Remove struct mdev_vfio_device
v2: https://lore.kernel.org/r/0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com
 - Split the get/put changes out of "Simlpify the lifetime logic for
   vfio_device"
 - Add a patch to fix probe ordering in fsl-mc and remove FIXME
 - Add a patch to re-org pci probe
 - Add a patch to fix probe odering in pci and remove FIXME
 - Remove the **pf_dev output from get_pf_vdev()
v1: https://lore.kernel.org/r/0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com

Jason Gunthorpe (14):
  vfio: Remove extra put/gets around vfio_device->group
  vfio: Simplify the lifetime logic for vfio_device
  vfio: Split creation of a vfio_device into init and register ops
  vfio/platform: Use vfio_init/register/unregister_group_dev
  vfio/fsl-mc: Re-order vfio_fsl_mc_probe()
  vfio/fsl-mc: Use vfio_init/register/unregister_group_dev
  vfio/pci: Move VGA and VF initialization to functions
  vfio/pci: Re-order vfio_pci_probe()
  vfio/pci: Use vfio_init/register/unregister_group_dev
  vfio/mdev: Use vfio_init/register/unregister_group_dev
  vfio/mdev: Make to_mdev_device() into a static inline
  vfio: Make vfio_device_ops pass a 'struct vfio_device *' instead of
    'void *'
  vfio/pci: Replace uses of vfio_device_data() with container_of
  vfio: Remove device_data from the vfio bus driver API

 Documentation/driver-api/vfio.rst             |  48 ++--
 drivers/vfio/fsl-mc/vfio_fsl_mc.c             | 127 +++++----
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h     |   1 +
 drivers/vfio/mdev/mdev_private.h              |   5 +-
 drivers/vfio/mdev/vfio_mdev.c                 |  53 ++--
 drivers/vfio/pci/vfio_pci.c                   | 253 ++++++++++--------
 drivers/vfio/pci/vfio_pci_private.h           |   1 +
 drivers/vfio/platform/vfio_amba.c             |   8 +-
 drivers/vfio/platform/vfio_platform.c         |  20 +-
 drivers/vfio/platform/vfio_platform_common.c  |  56 ++--
 drivers/vfio/platform/vfio_platform_private.h |   5 +-
 drivers/vfio/vfio.c                           | 210 +++++----------
 include/linux/vfio.h                          |  37 ++-
 13 files changed, 417 insertions(+), 407 deletions(-)

-- 
2.31.0

