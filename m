Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9A9643EC4
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 09:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbiLFIgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 03:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbiLFIfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 03:35:41 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2046.outbound.protection.outlook.com [40.107.95.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A882DC8
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 00:35:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yr+lS9IVcKi3rea9O0EyR0db6zSEdwuyL879fiPnI0NAtJELTAfS+bNT/nLgtJsEy7Y746BhV85Z3vXYX2gSQOTFUw5XMcW7qVRHEBo2oOrsSyr+L/ynSrD1osnHNknPzLP5G0ODjfmVzv3+pB7rj5UYV26Qj840HO7iJff8YBxSWwrRU0PX5RzS82bG9NJPPkzlzoxo16OMMk5r1GpuGsTnsezV8bTl4gieXKShaSsEhpotsYOTegUTsu2h5Me/bhvXozuGpcGBSAuKIt4DpTLljVI3NjkP79uf+eULBF//hVRvbazSzpfN3SrzuWRJhLQMh4Ecr36I6rYeyvDBSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5CzUM5+tVPE7LEqZqjCyDTw35o/x/jBXCdU/jOhBbNg=;
 b=J604Fg4niDxzknaiqHWugr639cXwKNRKSULJJZii78JL/4YIogyVZaHeLC8UrwOG7qL6vuwQX9pTG9BMXMV8mLM/QuwLp8kIGNCfXSh0jccR9e6sSkOUYbAF1cBLUOOqZoPFnmDQygFWZ8eiPW0B8kAXEiNO2UOgKGcxdTe/toihKINyk6q8fK4g+5rLfU9o8Jb6KLCqX4NnVfdv+uvlegMYx2H6VO3JB/0mgjvbLDJZQ3+f5xX8n+c/83Z+z8GkyqKscscuP/GR3UfNphR+9JPaFYPD1vfzyp+s9KwHXcLCHFJd0ulDEcWrH2Rz9Xj/vPYFUU78lCus/w1kDpcVhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5CzUM5+tVPE7LEqZqjCyDTw35o/x/jBXCdU/jOhBbNg=;
 b=qG4d+jjrVu39DPaSrYiA4UYGVKvtBOQ7VaenkemcvnzgvavtEP21qR/PKCLeZFkSLw4Z6HLP99JRzAw5iBk1pI8WtLqHatlVv3EaZ96/5Q6mc8EKoLXlgodn5p4yRsNUuZUcUvuzwh2bKg59kywR5dFW3oXhBJbi8d6MYTc/VR1Nede0d4SXrWqbsbyuKQGT1qFY8DcpcmwE4HkviE+8qWBfaH23GvDvJXWsxxFsdUWyD9r+epYI1TuhwosTLrmt9ek/A4/j4B1LxUYnYmdIyX2QfC2jlqWlywG8tK/LnnUdVjJbMkyDpEZ0K0DC9Tr7dM/N6R0e0zMlGtFGpa9bsw==
Received: from DM6PR08CA0028.namprd08.prod.outlook.com (2603:10b6:5:80::41) by
 MN2PR12MB4175.namprd12.prod.outlook.com (2603:10b6:208:1d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 08:35:23 +0000
Received: from DS1PEPF0000E654.namprd02.prod.outlook.com
 (2603:10b6:5:80:cafe::ae) by DM6PR08CA0028.outlook.office365.com
 (2603:10b6:5:80::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Tue, 6 Dec 2022 08:35:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000E654.mail.protection.outlook.com (10.167.18.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Tue, 6 Dec 2022 08:35:23 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 00:35:12 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 00:35:11 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 6 Dec 2022 00:35:08 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V4 vfio 00/14] Add migration PRE_COPY support for mlx5 driver
Date:   Tue, 6 Dec 2022 10:34:24 +0200
Message-ID: <20221206083438.37807-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E654:EE_|MN2PR12MB4175:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b23630e-8ad0-4b3f-4500-08dad764d12f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a41oihS/mSFt2MHzFK9DLKMVWXXIrUK2R4GJyhTlCM66rEOfIYQSm1ANLdYtZiw7hQfSfIIDJYE3Erld2pGo8ww5lJNp/y0Xm37Qsba+2a82hxVFeoZouotNs+YPfAW3KQA6hweiI4n2jZAjMxi4twFauhlM8CWP799wp45ADI1nxjTzz3Z3O0yWUDLZi4ryv3SM/T4urj4EMsi8vKBB9soXaQkZcK7Eb49YdD6X4FFC8B5IkyHBFJ7hyeqeoNLODM7llqSEw07+gG9X9/x7HVHGfxgibZFwuaaW53ow4+gOPFJESzCUqrhrfrqo8jDXUBiOOc8Qc/y0vI+GVwBP8UVkCyitS3r62P3TKCKYeqGTcRtigkJixsgyoLd3XnHbskXA/E6irhKpntposCzoqG9cm9phond/sA8c6i1DrWcP9fiT0ShX6iy6/bAZ6X9kS4hZY5ola/FiRfm46oixANckEIST5NyckZByArvTkzZnq74hLJ5Mkxdk0Y+qWnndm/SX3aJKx0af+hEdtoacXsVF9Eek0yXAsRQX8h2JvtrRd1q84Fog+5ZkqW2YSrTjvwXqs9oDQng0XJUeBMb5QBjoFNhtAAJPSQSzHiiDMZ3SXpemP0hckSXVoGAAUh/JGK3EGwkUp9//0XW8TloJ0uxzWqkXwxutYyLcR5J1jxeQ0iJKEiY9e9qh+pHNTOpTd+MoJtdo58T7MfQZq/G826Vn4MDXNDyuC2CexpnhAdR1AyNyk+lCJU4opIMjl2VoJrJqtAYlZGTXWGKpsV07FkUT4m19VcUppMus2LmXqIWm4utieEsjsLpXdsQk1LRZI12FYR2rmrJLTPO62FWdjA==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(136003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(2906002)(41300700001)(36860700001)(966005)(7636003)(356005)(82740400003)(1076003)(2616005)(40480700001)(36756003)(186003)(7696005)(478600001)(6666004)(426003)(54906003)(40460700003)(6636002)(110136005)(26005)(8936002)(336012)(70586007)(83380400001)(70206006)(82310400005)(4326008)(47076005)(5660300002)(316002)(8676002)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 08:35:23.1021
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b23630e-8ad0-4b3f-4500-08dad764d12f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E654.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4175
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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

[1] https://lore.kernel.org/kvm/20220302172903.1995-8-shameerali.kolothum.thodi@huawei.com/
[2] https://github.com/avihai1122/qemu/commits/mig_v2_precopy

Changes from V3: https://www.spinics.net/lists/kvm/msg297449.html
Patch #1:
- Add Acked-by: Leon Romanovsky.
Patch #10:
- Fix mlx5vf_precopy_ioctl() signature to return long instead of ssize_t
  as Alex pointed out.

Changes from V2: https://www.spinics.net/lists/kvm/msg297112.html

Patch #2:
- Add a note that the VFIO_MIG_GET_PRECOPY_INFO ioctl is mandatory when
  a driver claims to support VFIO_MIGRATION_PRE_COPY as was raised by
  Shameer Kolothum.
- Add Reviewed-by: Shameer Kolothum and Kevin Tian.
Patch #3:
- Add a comment in the code as suggested by Jason.
All:
- Add Reviewed-by: Jason Gunthorpe for the series.

Note:
As pointed out by Leon in the mailing list, no need for a PR for the
first patch of net/mlx5.

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

 drivers/vfio/pci/mlx5/cmd.c   | 409 ++++++++++++++----
 drivers/vfio/pci/mlx5/cmd.h   |  96 ++++-
 drivers/vfio/pci/mlx5/main.c  | 752 ++++++++++++++++++++++++++++------
 drivers/vfio/vfio_main.c      |  74 +++-
 include/linux/mlx5/mlx5_ifc.h |  14 +-
 include/uapi/linux/vfio.h     | 123 +++++-
 6 files changed, 1248 insertions(+), 220 deletions(-)

-- 
2.18.1

