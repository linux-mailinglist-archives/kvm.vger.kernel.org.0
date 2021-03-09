Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981D6333108
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 22:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhCIVjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 16:39:08 -0500
Received: from mail-bn7nam10on2073.outbound.protection.outlook.com ([40.107.92.73]:49607
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230431AbhCIVi4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 16:38:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UHYN5mF7FZfyFZG/+LRO3BaG1LYrGaDhUzh9Alo+zhVgRlRnUpqpsCd3MKrooDKb8sfbyVYjvTwitSRng7JzAP3dbtgUMfS/FyAHciUTEGHIK+rWeoomi+5haQFhPavlAvMnrK7afB0jZqJcYIVtC85iuWGlyk995oWwp+v+1G4/00G9qJu98ic44KxY4um81qbou3Mr9FrLJQoeyGISVSlnREnHe8IlgZ73Yg8Mu7bByXNaM2EP8TGWeNw2rGpuxwUpAkY5f/2yJysSOwTb5XXUQBPJzEjmaufD7YZsOWTC5xitSmw2FlGJeYFuK5w3s57neD9OuMcQ+VnIOk3vGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YzO1HoWcWYLHOh5BqYaziAqD9AYJklgyYuoiNGMSn58=;
 b=PZIaWp1zeulCVfaWjTUHVH8n/uD8+AQZc9J/DeA7CDgduAuSbX5HrhuYJDh0MHnYXSYPNZvsyRXh+ueemh+ebNllIzBuQZluqnEoKp73rSujXs7nldSqnoWRYg9vrnOGcZhGYxCvBCoaZ72i0aqFNNKFlBpdD+/Y4oyPJB93lKHQeTZd4LGssqw2lCegjqJswTgYtlcT+/aO/PwJWvBF2ny6kDLJQziS1cS1Y0P5ykHMtNg6mtutXwdK1+0pkzZOJ2z4iSW+xxq22CmriwQgGyp46B6QPJRTD7ZJwQHSaw4mlGZrFBZZ+D7QXNa7+jFbtG/pukBIJTCzYgrUviW7Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YzO1HoWcWYLHOh5BqYaziAqD9AYJklgyYuoiNGMSn58=;
 b=nLWNu+MOoeWR2EvmPf1jUcvox/AF7UZRmdkRNO51xgDsAU4AccmYef1RUaqPmncZ2hAtnaTZAnYlp8FzMLT2YCuVBV2jtZaXp1U62VkAiUE4YrR0u/81aaqLoGnpkYjjzwa6vWV0cz+AesIRzTGFoyCY/Z46B+fTU0b9djRCBjhOxl87W9QakpNbkvnTbUgc+3nWe/kYbTQE7p734G7f90lPVvv1Awf9/AVCpea94HKr8CEwj2ffoVvraXjSSu0io6aj9sD58QJCXMJeAZ8X2w5OTzUCd9QFyMBgaEccuKlHIx8oboG50mLgJ43RSWskp3dasE3cqAWlUCcUjT3MRQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB2489.namprd12.prod.outlook.com (2603:10b6:3:e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Tue, 9 Mar
 2021 21:38:54 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 21:38:54 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 00/10] Embed struct vfio_device in all sub-structures
Date:   Tue,  9 Mar 2021 17:38:42 -0400
Message-Id: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR20CA0033.namprd20.prod.outlook.com
 (2603:10b6:208:e8::46) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR20CA0033.namprd20.prod.outlook.com (2603:10b6:208:e8::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 21:38:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJk44-00AVIX-Kw; Tue, 09 Mar 2021 17:38:52 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df06cb74-fbf7-40c8-c8a7-08d8e343bc91
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2489:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB2489259CF95816D3EE18BCB4C2929@DM5PR1201MB2489.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XZwURbBFeEkxCBj2glIwOuB50LckcjUveT3k7MPHokhAnfIJaXhnqPEDXTQsg3GXKaNZQOGPjcUXv5dw7EgQMiy+vtprU9lCMTzj1Aeqx28vFJsJbCcIsB29hn+huXg9ERPFtYiScGN93tOd/iOuUZIOVrjr07WsAITyaJuspC5J8/vpB0cyvoyS553JbeuWDO7Xfd/9YskGCRpzFKGdfEGqgj4Lq5aApd3z/C15SnonEukGVuugFaf6OQ+mNhN1FxRHusE4jDhHN9PEue1rwFadCulaHTS9kj0Z4dRcif1hlvFh31a0/RLvXwmMjATPO/G5vjJgbJQnQMtzmdq+OIA9CLY9Yhvqcq3ewKpQSV9JSIzMcYncnvW9dEStTJ3GydS58Shis8Gz97EJnzPzkcLzVE2QzYwOZde6FNyb5/IA+9ALss5w850yKn+Bu3X0lmCyvFB03OF1ZVWwcFNnX2TYxKisJPCH1F8+vCD2K+blGqOZbuvy8p7He1U/bHQKBYpBFCoO6s/AN2R1/17DYVL9JoXOECEtPM9flQOD7BGIwb3dzsRSX3xkZcUH/9udiPtuDw0ANgwF7hkYZz5OpsDgFVeYmgEudl5sFX1FAJvGqCXCcns5C+abCpXLha6rCyIMJPex32OjQXDY6lyBWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(6666004)(966005)(26005)(36756003)(316002)(5660300002)(4326008)(478600001)(7416002)(54906003)(110136005)(9746002)(426003)(66556008)(66476007)(2616005)(9786002)(8936002)(86362001)(186003)(2906002)(8676002)(107886003)(83380400001)(66946007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?G+lmDpOrsaEaur0Udf8na+GDK2sOHF8F44Tt+j/btquvyYT5vbgSlv00xrL2?=
 =?us-ascii?Q?KijZL7z48YSM0bGY/NYhLbd+kI8SbBl7b1C7zTw4n2HgfwFAwOO7tvW7CJZ+?=
 =?us-ascii?Q?6/0WWLzDbcNkihHd1mWWrrv3u0vVpL8NHVnc8lbDlMNGPnHustgaMJEZOiXb?=
 =?us-ascii?Q?qIr3SWU33YtFSlqIdGHaOqmS6pwS/SbpTpwlM40/mygGtLzy/DkVALZfavhh?=
 =?us-ascii?Q?coLWyR9DckcObUsf6x1VvWgXwKu8XYLbOp5jdCs6exc+zbm0ddrfbg0X+mw+?=
 =?us-ascii?Q?+Am6WSt5fZ+X0cLTNZjyG5VGhDEDavuhqfIwGNn+eU82Yfu4PYuCRWop6CoR?=
 =?us-ascii?Q?uSMmGzMNdIELiEtYhDHS/IzAfv74X7X7jY+WpaTsUo6TM2z7RMTONxUTK4bq?=
 =?us-ascii?Q?NuDRPFUP3UW+kHBF9W29/SLaDPzlwdhaz5mkvV3T7RlcarBLLi+gdiiHP5nx?=
 =?us-ascii?Q?Sw2bK1kp6gkg/vDnSne+4hhPJ9y6Ou6FUT4P4fRF7C0f4at/wRCCgsSiKliL?=
 =?us-ascii?Q?Yt6XUBMpB6aD1MMAgoMsbOfq6janJKY7UjgRmS/dvzfjemhOVp1n9GX8IVjj?=
 =?us-ascii?Q?i46S4TnnXBJHAEMnEICMyzHCdv5yNkRWdmSYdgskPdLseeO4ENk/iofzYn13?=
 =?us-ascii?Q?J6r01x3eVyAovQeKYsG6FVUnzwdrjmsdaNGCWBGh4P+4D7p+uQVNFIHV349W?=
 =?us-ascii?Q?xXU4CHJdbE/qz05AWQixfbBobPCFapICinV1JKIplHD8wJbFmwzz+FmYWBlO?=
 =?us-ascii?Q?Xb7miCkgJG9uZ0KS71YJnbS0ssuOqqd3IsxOOa4ZuztbrrMoR6+EGSea2y0f?=
 =?us-ascii?Q?3jQcT0Oo4Fx7Df/K9rmSAU+NE5SLi70oJzpEg2gqiCuvoyCNgI5ce/bwAn6F?=
 =?us-ascii?Q?iMGwRsEo3BrVrX91kKNO9P0KkFo73aslG7dhLQiH7TSvDSIXzzBTmcU+/XQq?=
 =?us-ascii?Q?gQjZ7DnOZACey+qa64mk9f/A7fANBncxLbnAPUjS+4Zx3EL9IkZtX2J6ElG2?=
 =?us-ascii?Q?MJzRaImw9rv1oXOFEEIP3HCQSbmOUgenCghnqePpJRTX+D7hJGl1ihCrQ9t+?=
 =?us-ascii?Q?ZQaQoCABZMcKZgNq8D/SwO/1pt/5wgI4JrLxdN7L/oNYrW3TmfXUIOa+p73u?=
 =?us-ascii?Q?gJHjZF3y1W0LFOHiuasxsOwyRKFmE4JKG11E24pptRvfpW1MZ1em7DYvcF9y?=
 =?us-ascii?Q?W9ug1PskVyaoKiH8WRYUuERd+eHU7hVYc3LADWXMSbtrTChuWPo9/eWwqdNq?=
 =?us-ascii?Q?xozPuDXwJCFdsnkEdrwJg3VEAPP4yjrpdxNxgthI27d2eNH8fsuY4ZQB18hM?=
 =?us-ascii?Q?TLQI3PmyJNFUpnmXTa4paIc1D5iCJOTh6XdkxDfwUin7Gw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df06cb74-fbf7-40c8-c8a7-08d8e343bc91
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 21:38:54.1738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IvtegaQSwyzPcXk6v3WAqFrhLdAJj8YEBMYCn3f6skj7bmdQLCkOnQuYTdclKnfr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2489
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prologue
========

This series is part of a larger work that arose from the minor remark that
the mdev_parent_ops indirection shim is useless and complicates
things.

The entire project is about 70 patches broken into 5 subseries, each on a
theme:

#1 - (this series) Add type safety to the core VFIO
#2 - Add type safety to MDEV

  The mdev transformation is involved, compiler assistance through actual
  static type checking makes the transformation much more reliable, thus
  the first two steps add most of the missing types.

#3 - Make all mdev drivers register directly with the core code,
     delete vfio_mdev.c

#4 - Various minor tidies that arise from the above three series

#5 - Complete type annotations and remove unused code

A preview of the future series's is here:
  https://github.com/jgunthorpe/linux/pull/3/commits

It turns out a bunch of stuff exists in the way it does because the
'struct vfio_device' was not obviously available in places that naturally
wanted it. Across the project the following APIs are deleted as reorg
removes all the users:

   mdev_uuid()
   mdev_dev()
   mdev_get_drvdata()
   mdev_set_drvdata()
   struct mdev_parent_ops
   vfio_iommu_group_get()
   vfio_iommu_group_put(),
   vfio_group_get_external_user_from_dev()
   vfio_group_pin_pages()
   vfio_group_unpin_pages()
   vfio_group_get()
   vfio_device_data()

The remaining vfio_device related APIs in mdev.h and vfio.h have correct,
specific, types instead of 'void *' or 'struct device *'.

This work is related to, but seperate from, Max's series to split
vfio_pci. When layered on this vfio_pci_core will use a similiar
container_of scheme and layer the ultimate end-driver with container_of
all the way back to a vfio_device. Types are explicit and natural to
understand through all the layers.

Further mdev and pci get a similiar design with a set of core code
supporting normal 'struct device_driver's that directly create
vfio_device's.

In essence vfio becomes close to a normal driver subsystem pattern with a
bunch of device drivers creating vfio_devices'

========
This series:

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

Jason

Jason Gunthorpe (10):
  vfio: Simplify the lifetime logic for vfio_device
  vfio: Split creation of a vfio_device into init and register ops
  vfio/platform: Use vfio_init/register/unregister_group_dev
  vfio/fsl-mc: Use vfio_init/register/unregister_group_dev
  vfio/pci: Use vfio_init/register/unregister_group_dev
  vfio/mdev: Use vfio_init/register/unregister_group_dev
  vfio/mdev: Make to_mdev_device() into a static inline
  vfio: Make vfio_device_ops pass a 'struct vfio_device *' instead of
    'void *'
  vfio/pci: Replace uses of vfio_device_data() with container_of
  vfio: Remove device_data from the vfio bus driver API

 Documentation/driver-api/vfio.rst             |  48 ++--
 drivers/vfio/fsl-mc/vfio_fsl_mc.c             |  69 +++---
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h     |   1 +
 drivers/vfio/mdev/mdev_private.h              |   5 +-
 drivers/vfio/mdev/vfio_mdev.c                 |  57 +++--
 drivers/vfio/pci/vfio_pci.c                   | 109 +++++----
 drivers/vfio/pci/vfio_pci_private.h           |   1 +
 drivers/vfio/platform/vfio_amba.c             |   8 +-
 drivers/vfio/platform/vfio_platform.c         |  21 +-
 drivers/vfio/platform/vfio_platform_common.c  |  56 ++---
 drivers/vfio/platform/vfio_platform_private.h |   5 +-
 drivers/vfio/vfio.c                           | 210 ++++++------------
 include/linux/vfio.h                          |  37 +--
 13 files changed, 299 insertions(+), 328 deletions(-)

-- 
2.30.1

