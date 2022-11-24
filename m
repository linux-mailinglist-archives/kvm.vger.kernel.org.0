Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A3B637E73
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 18:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiKXRkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 12:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiKXRkc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 12:40:32 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D823F13C710
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 09:40:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nB6P6WSO4l+TEkkbeOqd/mFFKKryPb0lZSgXEHYHEMH9rw5LyaSff74kk1z4ar4JVyCiq08x4THxUL9WSxfusjwNtJETaBkc4b56fZ/cWYxwgOgLx+9QiCN/i75H7HhtefQ8UxGoqBb+NXlNR7NlAllnGm4eY8ganuZ9kIWeQZ++J7tZeWRrQ42x7n5MgHXzhzBPdMBsRFoeKzjQU9oFOANcYTIEgW3VGKaWWI4F2YLmwRkibdL2mnkBs8+gFsOziTqqdXAQooheKYS8Dw4e94j9+oNeX5TdttYdVQAC17M8J2r2iqsRpaeDMkU6K7u91EB0hncz5qdbwGjpRx7E3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U2uA68WutirA/CD+85rKP2gugm8BGoHcpvIQ8nVtyTQ=;
 b=dv5Lpv7ClSdcmY3dHot0WX1xWM/VPWd10rjXygszBWpkB+sKx4B1N+T33RratASCXmuTUeuqmXXhj/RqtbtwWGO74vKl6cMNMiXBcvp4uVMR2KKWjohABMnSCPigSFiWqiT22gAgujvlsMeylWdVpTq46EtJ0oAXNcHTOPh5Kq7aXrPQwIpj5f6GV/BqEzpYbpPT07cMzu+sfH/MrgnC7TaXptT3xKiikdN23mbF5RlkRCY7WL1lrPQGUavJ66rPelgcB5g6093PdqwpkLtp4DRN7K+tubdUJ8zKkniNmaNThFaiT4h6UjAj6robuXb21AC5Tg0RdGr9LYM3wbSJpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2uA68WutirA/CD+85rKP2gugm8BGoHcpvIQ8nVtyTQ=;
 b=YXwuhQ5TgPg7SxO/8K1HjDlnE0sjLtKsbANiR7EU8nAqItIZpXsFh9hTo3ONEyuTBCJ45E7z6+hwnoqgmhuJ609KmIN6l7Cway4/+/PYIW3e+y0qsAOxV8OmZpRa7HSN7CyDJS7etG7qFEMS4r37a6Oa1BmvtidnQ3jZYo8EPcBv0QhHQWqZAylriZEKkRDj3b1CHlMF++9KMihcIt+mLI96XV3Xl8R6liEBTT9sOxnFMVZ8tfN4XwX7WO1k/iiTHSy8etVDPoLt7x8FIlI1Ba/MRUl9aE8Ux+PaSqEdWRI4IdqfNOG+Y3X0gQnNPYuNVbZa0VdVcFpqra8aBSsgiQ==
Received: from BYAPR11CA0072.namprd11.prod.outlook.com (2603:10b6:a03:80::49)
 by SJ0PR12MB7082.namprd12.prod.outlook.com (2603:10b6:a03:4ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 17:40:28 +0000
Received: from CO1PEPF00001A5E.namprd05.prod.outlook.com
 (2603:10b6:a03:80:cafe::6) by BYAPR11CA0072.outlook.office365.com
 (2603:10b6:a03:80::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Thu, 24 Nov 2022 17:40:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1PEPF00001A5E.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.17 via Frontend Transport; Thu, 24 Nov 2022 17:40:27 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 24 Nov
 2022 09:40:19 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 24 Nov 2022 09:40:18 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 24 Nov 2022 09:40:16 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V1 vfio 00/14] Add migration PRE_COPY support for mlx5 driver
Date:   Thu, 24 Nov 2022 19:39:18 +0200
Message-ID: <20221124173932.194654-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A5E:EE_|SJ0PR12MB7082:EE_
X-MS-Office365-Filtering-Correlation-Id: 4537f28c-3f4b-4e1e-4be5-08dace42f9be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f6C0mgst2ddaLQwaKgDIZp9mzHNCz9+whSGSj7EIUZaMIat/cGqyo5SKCvpmZ3DxcKrYTCXN+cJdtT72mpOPaoEh1pIbiGuENWLpTamm5rQsc1sLbhUEjL3J3YNRAAmMvBq1fOpnZsk2Ad6ebVJsDu/WDFpT5D1IC2jxUaypkRpX5aAJx5ni6Vpy5cFB+zYob3py6F1o++5bIuMXnKqhxc1F6q+8gN7f+e+qJ4RNODipUie3bxTz4SUFaS+tcKM2cRcRsTX1R9YlDV6Kb9PlCtRaC50RykD0wEr+rVXPi9TdUIwP5N/xu2IuMwUdoWKMaT3JRofA6Ya8MRbQbjwDOW121FKWaWBYzX0UvO/M3deJWwkfmXggFfw0Ex0aDtmCZvh7favJ1Fb7Am3TEDhNoqC0itWJDE9kEoL3nz8DR4BAyZstDYtZZt/V5CUZ8t4updX6/q9pmyxs8IBNkRVhKifRaCyfbfjubqXEMyrbvls/OyfnVO/FOnAePvNKZjF4xk3OQ8xw2s7z/Fg2i9xQYSayrbhlBnhgsFClWj8cqVBYztam7wirvJlom6kOi2EuiIApmWRDwBr9GzhNoF26OTZDNQvjfe11oLoRdwN1a3oZctxg5DhK+wPp4XA2qA6iT7ZK/xRqogmwcGjjjx5Ngi4O+DdEXEeKmepsYIE1LpqMtEdpNdVa3LZi5KzPxIqbhdCyjTc2aIKKgtnHroi1rzU5KBDiZ2unkXHktKt9FOy0+B8OLn7LZo9k8dsEYZXdaFRl6u1IQ5m18NHqR8nuvKgFhmRvBCYD/mzcdIGiXEvMVMXefjlNLVU8TORWqglFh1ebo6zsB3s/YTfsxovzOw==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199015)(40470700004)(46966006)(36840700001)(426003)(47076005)(336012)(83380400001)(40460700003)(86362001)(54906003)(7696005)(110136005)(966005)(40480700001)(7636003)(356005)(36756003)(82310400005)(82740400003)(36860700001)(2616005)(1076003)(186003)(5660300002)(8936002)(26005)(478600001)(8676002)(70206006)(70586007)(6636002)(316002)(2906002)(4326008)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 17:40:27.8570
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4537f28c-3f4b-4e1e-4be5-08dace42f9be
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A5E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7082
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds migration PRE_COPY uAPIs and their implementation as
part of mlx5 driver.

The uAPIs follow some discussion that was done in the mailing list [1]
in this area.

By the time the patches were sent, there was no driver implementation
for the uAPIs, now we have it for mlx5 driver.

The optional PRE_COPY state opens the saving data transfer FD before
reaching STOP_COPY and allows the device to dirty track the internal
state changes with the general idea to reduce the volume of data
transferred in the STOP_COPY stage.

While in PRE_COPY the device remains RUNNING, but the saving FD is open.

A new ioctl VFIO_MIG_GET_PRECOPY_INFO is provided to allow userspace to
query the progress of the precopy operation in the driver with the idea
it will judge to move to STOP_COPY at least once the initial data set is
transferred, and possibly after the dirty size has shrunk appropriately.

User space can detect whether PRE_COPY is supported for a given device
by checking the VFIO_MIGRATION_PRE_COPY flag once using the
VFIO_DEVICE_FEATURE_MIGRATION ioctl.

Extra details exist as part of the specific uAPI patch from the series.

Finally, we come with mlx5 implementation based on its device
specification for PRE_COPY.

To support PRE_COPY, mlx5 driver is transferring multiple states
(images) of the device. e.g.: the source VF can save and transfer
multiple states, and the target VF will load them by that order.

The device is saving three kinds of states:
1) Initial state - when the device moves to PRE_COPY state.
2) Middle state - during PRE_COPY phase via VFIO_MIG_GET_PRECOPY_INFO,
                  can be multiple such states.
3) Final state - when the device moves to STOP_COPY state.

After moving to PRE_COPY state, the user is holding the saving FD and
should use it for transferring the data from the source to the target
while the VM is still running. From user point of view, it's a stream of
data, however, from mlx5 driver point of view it includes multiple
images/states. For that, it sets some headers with metadata on the
source to be parsed on the target.

At some point, user may switch the device state from PRE_COPY to
STOP_COPY, this will invoke saving of the final state.

As discussed earlier in the mailing list, the data that is returned as
part of PRE_COPY is not required to have any bearing relative to the
data size available during the STOP_COPY phase.

For this, we have the VFIO_DEVICE_FEATURE_MIG_DATA_SIZE option.

In mlx5 driver we could gain with this series about 20-30 percent
improvement in the downtime compared to the previous code when PRE_COPY
wasn't supported.

The series includes some pre-patches to be ready for managing multiple
images then it comes with the PRE_COPY implementation itself.

The matching qemu changes can be previewed here [2].

They come on top of the v2 migration protocol patches that were sent
already to the mailing list.

Note:
As this series includes a net/mlx5 patch, we may need to send it as a
pull request format to VFIO to avoid conflicts before acceptance.

[1] https://lore.kernel.org/kvm/20220302172903.1995-8-shameerali.kolothum.thodi@huawei.com/
[2] https://github.com/avihai1122/qemu/commits/mig_v2_precopy

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

 drivers/vfio/pci/mlx5/cmd.c   | 408 ++++++++++++++----
 drivers/vfio/pci/mlx5/cmd.h   |  93 ++++-
 drivers/vfio/pci/mlx5/main.c  | 750 ++++++++++++++++++++++++++++------
 drivers/vfio/vfio_main.c      |  74 +++-
 include/linux/mlx5/mlx5_ifc.h |  14 +-
 include/uapi/linux/vfio.h     | 122 +++++-
 6 files changed, 1241 insertions(+), 220 deletions(-)

-- 
2.18.1

