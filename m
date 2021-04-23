Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED953369CFF
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 01:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhDWXD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 19:03:56 -0400
Received: from mail-mw2nam10on2084.outbound.protection.outlook.com ([40.107.94.84]:47680
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229718AbhDWXDv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 19:03:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOMhoy2gq8WtOCOyFJTlsuR7zOUkCCyNSmh8vAM02CvDHeU+Sjsx/h00cShTAlO3AUTwhtCnhRouzZwC7Dr77XsXY9/FsMVPRsEB0LQGgDaKUayjj44qsQlf3GGRhI3TP3irfVD07U3sKu00JCxVbmDdWLaVOoygDSVA23DFOFj2AAh9SAoOISx13FZI5/9bigz/ELFa4WhpYsow46y29I2zBxUm/FQRMuih2xEffE9yEPhB87wK3o3bTfhIBr4/d4Kelha1ernbg9v8xmb0RvnxEOfX1Pb66cvkyKOqqOrWd1zhWNfuBV4mvoBQ0tarAzPMIxHjBWovgzy5Yq03ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z1q3awXFXc0HeSJQj9cfvSiNE3+Z4I+19S3I6rAVhBo=;
 b=kiXXQCWDs5kipyWD/RlfyAR6iLmGiGH0l9ggAdYC5Qiu20r9wGN9MICgVx6Ud7mFOMVSVqTZcqe/4w5s6SyPzQlnVRoWRdGz9NAo9wYJz5rICIlgyDTx1WBlzcaPr4fXfevBwahqIEkdVJumDtvaKTY6yCfZlRydHxzT0xVpjro1c7IpYdiIYCwiz/We2AVS11UhblaW9bHjKGGf1+G1faW24Z40Z9XD82mFm5NaR640awvFj1E7n2Fu/BYGL0yiy2/AsqS55i1OCp31jfCS4T79fzuR3LPBGj26/g+aVRjGpAN5xKpRcM6kUAI8TAzMIlbAiMgUikcso7H6avYleQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z1q3awXFXc0HeSJQj9cfvSiNE3+Z4I+19S3I6rAVhBo=;
 b=rryBE0YBsAknoi2eLHS2ty7caZwCYRGSUZ0JxiTERxbCoFliZp4mGzc0v1p1zMNtcOLZfc1FAN9L93khOgBGC3ckgFsT7blH1UacwSIPCBA8ZxYdh6G19tgtYu0Xp6zmPpaC5Qrug7chj6Q2imG05lMKARpbPMMzZMto92ANEM81fjgxU+PdH/umHqxHCLXw8UhkOG0ZTr4VUS6GSWO+tSyFaiL6NlWvB8AWU48M50WwbXboPfBkU3GQ5yDTi133GjCi+7KgAyrhslT11FA/AkU8nzzSQ+/2e8pDDELqCs/YBYDNCv11Iyg/rPa/ig7nNRbSRj1SD9nGGEBgqDrmdA==
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3513.namprd12.prod.outlook.com (2603:10b6:5:18a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.24; Fri, 23 Apr
 2021 23:03:12 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.023; Fri, 23 Apr 2021
 23:03:12 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 00/12] Remove vfio_mdev.c, mdev_parent_ops and more
Date:   Fri, 23 Apr 2021 20:02:57 -0300
Message-Id: <0-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR20CA0038.namprd20.prod.outlook.com
 (2603:10b6:208:235::7) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR20CA0038.namprd20.prod.outlook.com (2603:10b6:208:235::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 23:03:11 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1la4pJ-00CHzN-Rw; Fri, 23 Apr 2021 20:03:09 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7774210b-31c0-41e1-4257-08d906abf790
X-MS-TrafficTypeDiagnostic: DM6PR12MB3513:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3513B494B098716CEC38C557C2459@DM6PR12MB3513.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CSLfJq7bIZL7g+3+svOc/TY0JkF/CJriiUsnjUxFml7VfO335B3xyHN3D5y+hd+951US/DT//6fe8M4iAfUkRPIsIJuZoNLmZYYpzg6TbUeOTKvQ7UzRR2H/8BGM8G7rMoD9/e0ril7UdHUB0PrB+uizpirhkxMLv5lDI5T5nJ3i7ZxxOLWp29H3Wkdcth0DsWsYxKTypswiFgUQi2GVoBfD4LBPWjzw9v/AVGrasL4V7dBdoAMXigT7PlM9nHfYERLEyRkfb75RjyX8zN9RKL6vyvf693SiFe9/kr/hz44btwoSQNHKpklaDXfSrGyIXod9PAQsprYX75z3lxBU6rVj6jsn69m5PCwuPzOzyoAfr1oeYmIbFFeFaiK+V9Z5vBsu6q88WXXk9TNpiW7iC8nQ0+TjBsJL66YDfIGbTXoklJr6/QSTCCkKTNVWQ1aKwOxjMnvxuaGw3UqZbCWsmA4WsLfibHHeD+b1d4hJTJI0FzWeBtxQMNbZwhUfE0GsC+shqAkxI2UqWFqHHcHIaH3rTBE/YC8Xs/M1XQl9iu3a7o9TSJSiSz+X7W6xAi7DMZEYQZePcv+/LQfXgFgCwPSvQ/5TNHK0olcqyxtArGBwIDd5QETP9GNNk132fvXCSfnH+FS1PBJVWETWb/Z/CVqqFA2LDOC9Cws0I4ixVNPenjGNoaBrpWo4zR+6pQoerpWeMxEDlZbD7mcwDIQX5C2gmaOv8wy0rnZRVZ8QALs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(366004)(346002)(136003)(36756003)(66556008)(26005)(66476007)(107886003)(426003)(8936002)(966005)(83380400001)(921005)(9786002)(5660300002)(186003)(86362001)(9746002)(54906003)(38100700002)(2616005)(316002)(8676002)(7416002)(2906002)(4326008)(110136005)(66946007)(6666004)(478600001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3bFOkOrgZ+c/Lp3YoTuVQVOWSrD4qcxMxSg6xhR/FD6fLF57kx2Dv3aATirj?=
 =?us-ascii?Q?y9Zh2oV7VKG1l5igwiXGEvQklQ5J5JbY6S7vWnUU/ftsk4IKVXr5BUWS0iNb?=
 =?us-ascii?Q?FdgCHdfHSpYJLSPSs6UqvEaqsgWhGZAwkitsfm6hmQMxve6LfCpc6p2KYhaA?=
 =?us-ascii?Q?SWiLdrAvqv9YtXPmrdYIRBH86NDDFVgtzxHuUK+0D0bd9dUXv3qtMM/JiB1F?=
 =?us-ascii?Q?JdhfE+kltlph39vpbsRAnCh28a8w/q844Vw/43meXng1eX5Mihci6e2W6zeK?=
 =?us-ascii?Q?sjBTxgCVv9XFQElT8WwdAdvLQlC527DpOTUfu3vdolx4gtvi6DGJ4NGjIjqb?=
 =?us-ascii?Q?vVjoUz3KDCVFGTL45Rqql1Rbsz5pi85NcpgeCwjqOLtiERUUL06ix5/Fkxf/?=
 =?us-ascii?Q?aPc/SJ+8zKGQIli7rxqY7bHct+X/T5bsqCuQ3wnB/hctPPIzTS/sMROHEwGf?=
 =?us-ascii?Q?bQNg+cOELIoWL+eigu8AVTO10IrZ2oZdM4kZX1kvNec+jIrYh5EtUcF+r3xp?=
 =?us-ascii?Q?MaW2XlED/pagV7sjz8n4aI0pxZ+zLCzCkosg/9gnLZyt4aJ3FiPkIRKAeuW7?=
 =?us-ascii?Q?8aRRxSpy55UNpy+Ip2Pvfw3lrf8iUP4J9z3bVHZrg7XJqIgLjfGgEEtpjdBf?=
 =?us-ascii?Q?aM4MkwPpW/8vD/XgKhAUTBpggfZFjPLrBo+Re1OhxAEzTMEXd8UHRjMCSw6A?=
 =?us-ascii?Q?Pf82b9EQtpEkJl7u3kg80jr5LV5/B4FwQVS43PRkDH0JuxaRvztB4PNtGT0C?=
 =?us-ascii?Q?aPfQL2bb+befNJbOQamdRLttoYR0dZVJsCwCJHgcStf77Kx0HI2RKlaoewSO?=
 =?us-ascii?Q?nwkFOOgQ8iuAM/sca/d5xDOJbfA2jQQA709r+Tk4hXTTsld04CdBuFnsNMUf?=
 =?us-ascii?Q?nTKIJPHwt/Qpq959lzhyRROtbx46uEhUzfcN11rPJa06+KGrGoxdlOV+lsz5?=
 =?us-ascii?Q?23dpgrT231uHHI+9qJXmgyFc5ePtbu+EP6Y0a66XP6gtoTuKgOXH1YTYFcbf?=
 =?us-ascii?Q?T4F5pZXBokLX/oXnABER0Ur27PizHClKxaArkr53BLM6bXVRVr4Jrpz+eItj?=
 =?us-ascii?Q?Y83+6B7dPY38vPS61+4sXrWFkGHfeTB0ihtkE91div0g/qvTcbY394MXN38Q?=
 =?us-ascii?Q?xa7qX6Yj0fRGyTnZUMS4ds58Bc7SXRTkWaQVA5aY0waAwxw6Hv+MWfXkWC95?=
 =?us-ascii?Q?IHIZol8G2yWDRn54rvEhJbjl/ihG6l1dRDMDN6lYeQD7I6PsYUHScnI/IXRR?=
 =?us-ascii?Q?cULxYMZivWn5xhY+jwLzxoKmdmD5yujXtO5OCefHSZwo+zRPnYdzKwhSoJg6?=
 =?us-ascii?Q?fSokRDvQ85U0mXT9iP7VdNcG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7774210b-31c0-41e1-4257-08d906abf790
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 23:03:11.4495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1fWxThH7+xEaCydsLn94c3kkVX/a4Obk8XAlqIeijjfyspcrcyut3JLiEafCo2R2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3513
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prologue
========

This is series #3 in part of a larger work that arose from the minor
remark that the mdev_parent_ops indirection shim is useless and
complicates things.

It applies on top of Alex's current tree and requires the prior two
series.

This series achieves the removal of vfio_mdev.c. The future patches are all
focused on leveraging the changes made in the prior series to simplify the
API and device operation.

A preview of the future series's is here:
  https://github.com/jgunthorpe/linux/pull/3/commits

========

The mdev bus's core part for managing the lifecycle of devices is mostly
as one would expect for a driver core bus subsystem.

However instead of having a normal 'struct device_driver' and binding the
actual mdev drivers through the standard driver core mechanisms it open
codes this with the struct mdev_parent_ops and provides a single driver
that shims between the VFIO core and the actual device driver.

Make every one of the mdev drivers implement an actual struct mdev_driver
and directly call vfio_register_group_dev() in the probe() function for
the mdev.

Squash what is left of the mdev_parent_ops into the mdev_driver and remap
create(), remove() and mdev_attr_groups to their driver core
equivalents. Arrange to bind the created mdev_device to the mdev_driver
that is provided by the end driver.

The actual execution flow doesn't change much, eg what was
parent_ops->create is now device_driver->probe and it is called at almost
the exact same time - except under the normal control of the driver core.

This allows deleting the entire mdev_drvdata, and tidying some of the
sysfs. Many places in the drivers start using container_of()

This cleanly splits the mdev sysfs GUID lifecycle management stuff from
the vfio_device implementation part, the only VFIO special part of mdev
that remains is the mdev specific iommu intervention.

Thanks,
Jason

Jason Gunthorpe (12):
  vfio/mdev: Remove CONFIG_VFIO_MDEV_DEVICE
  vfio/mdev: Allow the mdev_parent_ops to specify the device driver to
    bind
  vfio/mtty: Convert to use vfio_register_group_dev()
  vfio/mdpy: Convert to use vfio_register_group_dev()
  vfio/mbochs: Convert to use vfio_register_group_dev()
  vfio/ap_ops: Convert to use vfio_register_group_dev()
  vfio/ccw: Convert to use vfio_register_group_dev()
  vfio/gvt: Convert to use vfio_register_group_dev()
  vfio/mdev: Remove mdev_parent_ops dev_attr_groups
  vfio/mdev: Remove mdev_parent_ops
  vfio/mdev: Use the driver core to create the 'remove' file
  vfio/mdev: Remove mdev drvdata

 .../driver-api/vfio-mediated-device.rst       |  55 ++---
 Documentation/s390/vfio-ap.rst                |   1 -
 arch/s390/Kconfig                             |   2 +-
 drivers/gpu/drm/i915/Kconfig                  |   2 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c              | 210 +++++++++--------
 drivers/s390/cio/vfio_ccw_drv.c               |  21 +-
 drivers/s390/cio/vfio_ccw_ops.c               | 136 ++++++-----
 drivers/s390/cio/vfio_ccw_private.h           |   5 +
 drivers/s390/crypto/vfio_ap_ops.c             | 138 ++++++-----
 drivers/s390/crypto/vfio_ap_private.h         |   2 +
 drivers/vfio/mdev/Kconfig                     |   7 -
 drivers/vfio/mdev/Makefile                    |   1 -
 drivers/vfio/mdev/mdev_core.c                 |  65 ++++--
 drivers/vfio/mdev/mdev_driver.c               |  10 +-
 drivers/vfio/mdev/mdev_private.h              |   4 +-
 drivers/vfio/mdev/mdev_sysfs.c                |  37 ++-
 drivers/vfio/mdev/vfio_mdev.c                 | 180 ---------------
 drivers/vfio/vfio.c                           |   6 +-
 include/linux/mdev.h                          |  86 +------
 include/linux/vfio.h                          |   4 +
 samples/Kconfig                               |   6 +-
 samples/vfio-mdev/mbochs.c                    | 166 +++++++------
 samples/vfio-mdev/mdpy.c                      | 162 +++++++------
 samples/vfio-mdev/mtty.c                      | 218 +++++++-----------
 24 files changed, 649 insertions(+), 875 deletions(-)
 delete mode 100644 drivers/vfio/mdev/vfio_mdev.c

-- 
2.31.1

