Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3546963F3E7
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 16:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiLAPa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 10:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbiLAPak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 10:30:40 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B96DAE4D0
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 07:30:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCjlJQTYGcDmapPWyj9x570/e8rN1AB6/AsvAmC1zDwh0Pt8PLCoZ01Raur1bwaQX2MTjkz8ekqFKSXViyS8sPSceUqASeIGtHw18YvUhoPnFJtljm/m7Z7zWKFjGyqcNLg4K4K+lNGWfD7eMQImUGGXsEWJUJm3BSaLiXowUGMXtsYz41i2Q6QsAyfEy73fZrAFlzo6hLN/XhE/6grRKU4z/IMz70IiIUzvIu94ZCBNbFihU1FOzdIlaWdkOXUicpbR4aQDzkD6YjIVJdmP27UqxVtkqPR+aQyBKQlgWdPqmpYxkHr8eqvnkDhtuy2XodpSI+VPREg+d7X/tSUshw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JTraMGy2wppz1ULiF1M4xGnumfJua8JFqpa+EeI30+w=;
 b=WLquv/fmKXcIf/dnoMT8GXHwgcZM6djC1pU2lHXxpL1hnWAv9SaYro5LCPMbfcjx+vrPNKGg7Z1L5yX5LaTbLAv5SGcGkTZpD4hiTr/EgeQ++kNYddS14C+D9ZLNRlLXqJV6sfcTQtmKUdwXh8U4s65nJ1vF8PkK4HZ4EgUkG49yPV1DNnp+qd/jDBryBKqE3y/sugKqWvXyJ1+T3RjcDpY/DUfqIoZ3C0FMqe2nw4n8c2pa90yGYVXX/iUSLRG+UmSDhBIvTBmuC4ZtbJsNM+YV+47JRANyXo2Qsg4f2kx8rhIhfRuFU0fHNkY4/ZDY6QF+50Z64zJR4JJCHD0L6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTraMGy2wppz1ULiF1M4xGnumfJua8JFqpa+EeI30+w=;
 b=kRfYeF6y4Ysj3CA4k1V2jPBL3JNmarPk0J9+UOSw3Yn9bks9H2aPolegGEnndddidB+U4hBZ3nh/KMzLjiTlY41UlXJmKbZaKvICe3ueZr8JY03tEcHHPdMOPKxU2qiWgMBqCH58MvSXc7GhQ1/eXJ+24sIeYLuLYug1SZsePwn4R97PVztFMo65YX985Cti0wUFSAIDDwVjzhJ5G1lhma6zJo/rVXEg1uYqWBrTAwC2HNlgWX3FCBBep7EjSGfiNxCWpc9Xap1iqy3WwloZvxd474HOa/lnoW3jYCZKi4cLLX/R+4JOJQKdVha/2PsiHrDix4kcX56/E+gGVv8Acw==
Received: from DS7PR03CA0120.namprd03.prod.outlook.com (2603:10b6:5:3b7::35)
 by SN7PR12MB7977.namprd12.prod.outlook.com (2603:10b6:806:340::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 15:30:04 +0000
Received: from DS1PEPF0000E634.namprd02.prod.outlook.com
 (2603:10b6:5:3b7:cafe::60) by DS7PR03CA0120.outlook.office365.com
 (2603:10b6:5:3b7::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 15:30:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000E634.mail.protection.outlook.com (10.167.17.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 15:30:04 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 1 Dec 2022
 07:29:59 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 1 Dec 2022 07:29:59 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 1 Dec 2022 07:29:56 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V2 vfio 00/14] Add migration PRE_COPY support for mlx5 driver
Date:   Thu, 1 Dec 2022 17:29:17 +0200
Message-ID: <20221201152931.47913-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E634:EE_|SN7PR12MB7977:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a009549-1afa-4c14-501b-08dad3b0eb9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W0n9dz4eI/jWSZkZVkbsJ2Rgtz3y+zQ3D0AcpgnhFFhMCg16q+ihVcY1Xo52ajhenD5aqArnbt717lcpiPfWyQUIVdSPVFrAPBWgXyPz8dCN5/sIj/F3SEqQnEHgfLDQ43tp+/lWCBO1FiXTecHYmqISjReHVE3RTc+Yn6vfcGEqHlb+7s+qoa6dTfe4fb/mQsAkOL41XmxGtfFJYDfFrB5IaQioW5gSGqCwTsXnp5ACyNYlMWkKiA/Uazme7d3YZ9f0f5zgwBc4jemc+KaeFuZ60opuvbw6vOmgAoiwNwAU5ZlZEXeO5ialnV5ALsghyxajwsI7gbx5uJggJZ54/MGI3PFsZIiZ2fHTimww1M4oZrCM00KRVkGle1f94LPH04UXwNN4UxzDxtQUfst1PblaptNdl+ITV2TyuyHf0dbzGmXpwB6/UloMBmERWOiAKCJNhegmLKGBTHqbGv8uuYJ9H3DRyCKyqXCv0pBfg/fs+xEbYaKz6/BThM2PvS6PsXk5D0YWFecHd5aeet+ygI4nHKvZunxCjuUJsfH7YfeNy0YOQB83ujl705iOD1cB+v1tXRiM0kZbyTjPIez11zEXQTyDzInZqyCL+cw+Lskr8irjLLkQkKZlKkiF7aFl6lWELs3s1XKg8j3mOXpeS0taBAq4JSbjdSirfO2P2S7bOEqYnmlwn3EzhC2JvkbSqeBvm/XI15UDuNa6nn5y/b44ux5BE5gmkLs78gV0JO/b4v+JUTaK1LbV9xNhwYl98AbdlQslhCPjc24nf9FiTFERiHKAePMqQELJ/tCVCraQHvG2RfW4lYVerEvRTWSTat/SicXatcmjA0FYTUTcSw==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199015)(46966006)(40470700004)(36840700001)(6666004)(5660300002)(41300700001)(356005)(316002)(54906003)(70586007)(110136005)(2906002)(36860700001)(82310400005)(40460700003)(4326008)(8936002)(6636002)(36756003)(70206006)(8676002)(478600001)(86362001)(966005)(26005)(7696005)(40480700001)(336012)(7636003)(47076005)(1076003)(186003)(2616005)(82740400003)(426003)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 15:30:04.5378
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a009549-1afa-4c14-501b-08dad3b0eb9c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E634.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7977
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds migration PRE_COPY uAPIs and their implementation as part of
mlx5 driver.

The uAPIs follow some discussion that was done in the mailing list [1] in this
area.

By the time the patches were sent, there was no driver implementation for the
uAPIs, now we have it for mlx5 driver.

The optional PRE_COPY state opens the saving data transfer FD before reaching
STOP_COPY and allows the device to dirty track the internal state changes with
the general idea to reduce the volume of data transferred in the STOP_COPY
stage.

While in PRE_COPY the device remains RUNNING, but the saving FD is open.

A new ioctl VFIO_MIG_GET_PRECOPY_INFO is provided to allow userspace to query
the progress of the precopy operation in the driver with the idea it will judge
to move to STOP_COPY once the initial data set is transferred, and possibly
after the dirty size has shrunk appropriately.

User space can detect whether PRE_COPY is supported for a given device by
checking the VFIO_MIGRATION_PRE_COPY flag once using the
VFIO_DEVICE_FEATURE_MIGRATION ioctl.

Extra details exist as part of the specific uAPI patch from the series.

Finally, we come with mlx5 implementation based on its device specification for
PRE_COPY.

To support PRE_COPY, mlx5 driver is transferring multiple states (images) of
the device. e.g.: the source VF can save and transfer multiple states, and the
target VF will load them by that order.

The device is saving three kinds of states:
1) Initial state - when the device moves to PRE_COPY state.
2) Middle state - during PRE_COPY phase via VFIO_MIG_GET_PRECOPY_INFO,
                  can be multiple such states.
3) Final state - when the device moves to STOP_COPY state.

After moving to PRE_COPY state, the user is holding the saving FD and should
use it for transferring the data from the source to the target while the VM is
still running. From user point of view, it's a stream of data, however, from
mlx5 driver point of view it includes multiple images/states. For that, it sets
some headers with metadata on the source to be parsed on the target.

At some point, user may switch the device state from PRE_COPY to STOP_COPY,
this will invoke saving of the final state.

As discussed earlier in the mailing list, the data that is returned as part of
PRE_COPY is not required to have any bearing relative to the data size
available during the STOP_COPY phase.

For this, we have the VFIO_DEVICE_FEATURE_MIG_DATA_SIZE option.

In mlx5 driver we could gain with this series about 20-30 percent improvement
in the downtime compared to the previous code when PRE_COPY wasn't supported.

The series includes some pre-patches to be ready for managing multiple images
then it comes with the PRE_COPY implementation itself.

The matching qemu changes can be previewed here [2].

They come on top of the v2 migration protocol patches that were sent already to
the mailing list.

Note:
As this series includes a net/mlx5 patch, we may need to send it as a pull
request format to VFIO to avoid conflicts before acceptance.

[1] https://lore.kernel.org/kvm/20220302172903.1995-8-shameerali.kolothum.thodi@huawei.com/
[2] https://github.com/avihai1122/qemu/commits/mig_v2_precopy

Changes from V1: https://www.spinics.net/lists/kvm/msg296475.html

Patch #2: Rephrase the 'initial_bytes' meaning as was suggested by Jason.
Patch #9: Fix to send header based on PRE_COPY support.
Patch #13: Fix some unwind flow to call complete().

Changes from V0: https://www.spinics.net/lists/kvm/msg294247.html

Drop the first 2 patches that Alex merged already.
Refactor mlx5 implementation based on Jason's comments on V0, it includes
the below:
* Refactor the PD usage to be aligned with the migration file life cycle.
* Refactor the MKEY usage to be aligned with the migration file life cycle.
* Refactor the migration file state.
* Use queue based data chunks to simplify the driver code.
* Use the FSM model on the target to simplify the driver code.
* Extend the driver pre_copy header for future use.

Yishai

Jason Gunthorpe (1):
  vfio: Extend the device migration protocol with PRE_COPY

Shay Drory (3):
  net/mlx5: Introduce ifc bits for pre_copy
  vfio/mlx5: Fallback to STOP_COPY upon specific PRE_COPY error
  vfio/mlx5: Enable MIGRATION_PRE_COPY flag

Yishai Hadas (10):
  vfio/mlx5: Enforce a single SAVE command at a time
  vfio/mlx5: Refactor PD usage
  vfio/mlx5: Refactor MKEY usage
  vfio/mlx5: Refactor migration file state
  vfio/mlx5: Refactor to use queue based data chunks
  vfio/mlx5: Introduce device transitions of PRE_COPY
  vfio/mlx5: Introduce SW headers for migration states
  vfio/mlx5: Introduce vfio precopy ioctl implementation
  vfio/mlx5: Consider temporary end of stream as part of PRE_COPY
  vfio/mlx5: Introduce multiple loads

 drivers/vfio/pci/mlx5/cmd.c   | 409 +++++++++++++++----
 drivers/vfio/pci/mlx5/cmd.h   |  96 ++++-
 drivers/vfio/pci/mlx5/main.c  | 747 ++++++++++++++++++++++++++++------
 drivers/vfio/vfio_main.c      |  74 +++-
 include/linux/mlx5/mlx5_ifc.h |  14 +-
 include/uapi/linux/vfio.h     | 122 +++++-
 6 files changed, 1242 insertions(+), 220 deletions(-)

-- 
2.18.1

