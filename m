Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E94642AA6
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 15:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbiLEOtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 09:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiLEOtQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 09:49:16 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2D91B78A
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 06:49:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PMabZ+ymQvLmzwJ6SCIqIv7ahszqDPd/zXX7Gx8QJlz1f2pyqwDQnBgqSm/c9Q5AdAHfakJ4SE2e8DHzsChWYWUBNWQWg5d1stHjb/Ca3ZSgwHAxkQBz0S8E0CkXz7jgux6XbEF3LGamxtBY8XGAE+MxN3wakbJmhy7bcgOWFYb7YxPmyfvAJmpoZ8xEGcpYyyd+cinHIWe/rYcAlGkxXDkZMtlzaN8H2Uag08z6l5i2zBfyGUZsaZZtmxc20p4+x1mn56v2j5IJSNSkT5XeupL4u5XyA5U7kU9LSSxwQD5h9l0NZmSLUQJWlEwudQeM6wl6lLApK5GxPdheZZzEsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kMfJi407eU5UVdBVKlAPcnlrD60VBumRUvEQXdWZQzg=;
 b=ZWjUOmmd0m0GS0eg79ZlzU1q8IkC7IYxpzOdVioWzJkdqUw5/WXPswRpVjs0e7SxFmHM4rho0GKaeEk7gD9h8aBfZF/4jiccYmqiUxYVLnNIYUMUAKG7FwGZstm+aNtQNicbTy3H+xGSU6hk9Nll2G8Q/gbfHyPivwNTL+h3ASlzDMbJ+vYKJZHxo5mBJbOTciyA1IED2EkclOY21Ke/xC0voMzsIxQc0N+OyOwxuRdi6ccxZj78pCdE762W7IdskALS2UTbYO/mrjylYFkM5igrcV0dQkRS6/YLRLXmjLnSOLj5bHqa+QpuubtwkQbpEh6ROgazwJltggVLbo4EHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kMfJi407eU5UVdBVKlAPcnlrD60VBumRUvEQXdWZQzg=;
 b=VklegCNyvpXJlMXGwV7M8omV3Vx1llzkVvRG0BQfURGudbfOtTmJcF4tbPTgCxq9FFOftV2odZGixdYvIjRQbaxc917Ykeqn8Xi/dEjLTNnO3uCUCDWsKglO2C8PcZBQd4hxW7dNY0vol3vTfpSERpaCoOwbwO1PQEpgr+yJthA0HjR9qHA4rGyALz4mbRUCxEdrZuPkhKICrwMoxmfsB34Up64H7oklk4QLqX9Cos8TZNG5FFHw2MbgKho0pPpS6/TmJ78hsqACujvzYriYoYZcNd1+6N9ZmIHD495ncYgsFnG8EmfpGzjRxEEJ2jm247MicoWdvjKFnRe1s3LFIw==
Received: from CY5PR15CA0091.namprd15.prod.outlook.com (2603:10b6:930:7::10)
 by DM6PR12MB4548.namprd12.prod.outlook.com (2603:10b6:5:2a1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 14:49:13 +0000
Received: from CY4PEPF0000B8E8.namprd05.prod.outlook.com
 (2603:10b6:930:7:cafe::4f) by CY5PR15CA0091.outlook.office365.com
 (2603:10b6:930:7::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10 via Frontend
 Transport; Mon, 5 Dec 2022 14:49:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000B8E8.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.11 via Frontend Transport; Mon, 5 Dec 2022 14:49:12 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:03 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:02 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Mon, 5 Dec
 2022 06:48:59 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V3 vfio 00/14] Add migration PRE_COPY support for mlx5 driver
Date:   Mon, 5 Dec 2022 16:48:24 +0200
Message-ID: <20221205144838.245287-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8E8:EE_|DM6PR12MB4548:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cf7f244-b925-4ace-65b9-08dad6cfdfa6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pI9WQvq4ksn4m+7bynkFfpq9EGYu2lrYfQ1Wjo3Zt7YikVAtT4tFDWQUOQ7Sdpe3uLo1N26m1CRbsJamTDGjT4HJ+3hlmtymEE4k8eYhRUIot5ICzzZaLZRBKQdr1Ghb6ZKvJToEZ20VVzoCMAkm7wPWPlCt0wqLR1Ub8NZwbASF4IX0LjEqN4Ro/uKvOOT86DBbQbDwWIrjwx8P9kAer3DlW9ggOthnrwuOfdmjQkhHSXyai6PZfTNgvo7arIMjpg0FTELvVdDuIjtXDM6kit4g6lHzr5095SNmj+TXTyN6JEgpbsJFWslvMbxbMei/9GtjMT4rsjq8e2/VkXXlvrawre+eM7CzT+7DzMai97ind4ec6JE0mDUPZuMGZ9nd8g2IcewLZW1GOycm3Vgi0t8tN/ZR+B9oSNe7fiLU+sQ/MAg+QEpxW1dQnkARP4J7rXqtQCJ3ReU0a0So87oE/riYX9RjDZQbHUPprNlpSKlLM5waTr0w2BbQaDSWunSbz4EhSuybqXb4Mva5Sa+NcfG1YfNzoOWUCHPZuX0eqOs4Ifp7acS5JJi75WD7Lu0qYCvBs7jzq1NZW9JtChK9Sc2yC/IazEuF4hLuDrffRc49yFUZXmlUFGtpSjdXSGu3eAf78cgDSLLVPpCMBe9Gdqknf2RYAY2m8U7FU9YYg+m0tBYj0cEIO7Z1Mtd/1N0DXszwib4T+XbsFHxoRUkAGBbao3N8ljdqpRCLGZfCzvvsC0ocKz06/Q7Twnlob+NE1p+qTBRGgOMTkSvpQTnkN6vPiuWVxx1CXRLZi4x8ws4wJEWkmryo3whTEJOvB0uaXuBFLroZM5nYleG9hbtR9w==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199015)(46966006)(36840700001)(40470700004)(6636002)(54906003)(110136005)(478600001)(26005)(6666004)(47076005)(966005)(316002)(70586007)(70206006)(4326008)(8676002)(2616005)(7696005)(426003)(5660300002)(8936002)(1076003)(36860700001)(336012)(83380400001)(2906002)(186003)(41300700001)(36756003)(82740400003)(40460700003)(7636003)(82310400005)(356005)(40480700001)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 14:49:12.3738
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cf7f244-b925-4ace-65b9-08dad6cfdfa6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4548
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

