Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A85059687F
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 07:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbiHQFNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 01:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbiHQFNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 01:13:40 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2061.outbound.protection.outlook.com [40.107.212.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0073DF3B;
        Tue, 16 Aug 2022 22:13:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDpeGRdNX65lNnJ4DOv9ncUvIfEfvQJrjJl//tL27EewEiFvzg2xqIiBXmS4JddtIR5ek6tnuKq0C8i4SRelAxWBk3MUjYos8swtsjW3d2trc0SskwskrjFra00+8Ffl/x8gxHCVFg6tCu+NVEF30cW1ZBYtBriMgK5ad8QVPJ86fihWTG/XIslgm0kUGvUP4Ps12tQVEYCN+PzsiA6ag1TMRAAQBw0GosB71UZz2wgz2eBXZ8er1WX5RRH3kfAhLnlk2O7Fcag0DRO+iKzcm5pVWOJRvxycD6xtwoRPFQCnJugTpyYOWS6qP2bvcwixtAX2X3L/yNmdHC0Z8zlnRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QJPpnPWJl7VlGxliADzTq0wDWbVy2wR/gxKd8KMocvA=;
 b=hy9ZGF0vQiugH0+1kZSRQVkREil3YpkTKEXgWVnkxqzH3IFI7s8GJb1SjRUmaErzoBzsgvlSc0NcjVr3viuvjBLnikHjWLCcYjAy/5pl8SZVJWhg7+ScNMjYMUswvx+LtDIDaHMnr+t/BIf4m/a0NtNEtQLNlXoOBcSpXvVyZVRy4oZ3Q30Ix6OXMbAb2UDuYtD5W0p0GgVGiej2XZwnqrF5n5htw0Tgca5pF7Yb3uoVW/gcIqAVXy+3xN9XJRXNSj4JbEFd+kV3VMIHe5grTzBRejda+EsiAnA5484++bm9pNHXLlMnrcDf/oUqzsrDMblHetgke9w0bKZ1Y5s0Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJPpnPWJl7VlGxliADzTq0wDWbVy2wR/gxKd8KMocvA=;
 b=M8gPihIUyHm2GNbx15Vdp7toLcwckYHeNVPaD5XnbkFi4bo2cnDen4jMjYb211cGtihVH8BpaOcGCLWUbUi6BhTzLRnujd4dRCM+gZbi/S7Va2/Hm3Z0vjQZX1iucHxArg2aj6XNDo7lQk7q5cYrlPVTKgTTIjbvkgMMzPCPVl9dGbYJ1k+TrxTkgX6aMpwwPIxGE7uFonzjuG6Y5sbaAvQoFEnAZ96asPe5VyyC2whs0yMXNskNdtS+NQ8KqDg26PlaS1DqEiyheNGToDSTn8INtwAfDpvknAudtyRu9vGbw2ewcCbo/L6L1CwsoO0E7wpnuWPYb/TmGitOIUHnDA==
Received: from MW4PR03CA0051.namprd03.prod.outlook.com (2603:10b6:303:8e::26)
 by BN6PR12MB1410.namprd12.prod.outlook.com (2603:10b6:404:18::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Wed, 17 Aug
 2022 05:13:35 +0000
Received: from CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::5d) by MW4PR03CA0051.outlook.office365.com
 (2603:10b6:303:8e::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19 via Frontend
 Transport; Wed, 17 Aug 2022 05:13:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT011.mail.protection.outlook.com (10.13.175.186) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.15 via Frontend Transport; Wed, 17 Aug 2022 05:13:34 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 17 Aug
 2022 05:13:33 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 16 Aug
 2022 22:13:32 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Tue, 16 Aug 2022 22:13:28 -0700
From:   Abhishek Sahu <abhsahu@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>
Subject: [PATCH v6 0/5] vfio/pci: power management changes
Date:   Wed, 17 Aug 2022 10:43:18 +0530
Message-ID: <20220817051323.20091-1-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a012d59-2220-4483-eb0f-08da800f3bfa
X-MS-TrafficTypeDiagnostic: BN6PR12MB1410:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?X2Q52sS+Mw+YitGVWmJ2zZKAHhtsYFMbx7wrFc7X53S49Zn6hAjyudlRgeu5?=
 =?us-ascii?Q?F/C5/t8++t8+/gqx6fxo4oUdEn3yJFYM8KWMAOfOn5mHGNff2WsEVVrNgagl?=
 =?us-ascii?Q?GBhmjCmXpW44A6IVsQ/0Fgf9X+tzdrzSKUBOAINegzcZya96khrF388N18w8?=
 =?us-ascii?Q?oN9lHz4qGz7sATRLP5Jr8f37/IIWM0r1ahlDSqpIAXVfKBs3Tm99Kai/wEhi?=
 =?us-ascii?Q?BahVxwggL1RKiqPi3MgjHNo693VxWhFer8mmm4N5qDZPaNEQeZT3If344z0T?=
 =?us-ascii?Q?rjuxGyWC9IEO9Q8kt6OBROq8P0MR6b7/1erqVxz2hzHIW9HnioqpG6H2KLo6?=
 =?us-ascii?Q?M0mcL+oDf/2ceIkqZxwTMLjS2I9MH+pwWsMKDBlXhAT9CXSCUTnmHKdCpZ7b?=
 =?us-ascii?Q?5vcotVpmcXlxL7p8eZQv1Dxa0pc052M7PZKHPQuyCtEqvwYb86K+SXeYdZCl?=
 =?us-ascii?Q?QOQreytKHulGAMIrNh2vMozIZrarJoB6MfTbm6gzv4YYnlnF2R5IN9pknE2z?=
 =?us-ascii?Q?PO0bJ4PAc2cutF0r7ozjpZnAa6ENd8CQv0ECC/6hYblR1R0P4/gxXpRoUnJS?=
 =?us-ascii?Q?oRbWMjk5pDKGH9gTt4t3p7UwSs3CWDSXX7VHT8UOoxnT+WqAiVEuH6qs7FGw?=
 =?us-ascii?Q?u2G3FFnjpVjhukuXSRGehpmeKIxQYJOpA4yuCjsSMAYwzjkibDp6R5SW9XwB?=
 =?us-ascii?Q?N6PP7ES+9D79SaVQ7Rp6JOJhhce+xVE3HwfrLVIq22bt5uYTIi37V+eJlPRE?=
 =?us-ascii?Q?486G/qPMkTsloSej8NIvjGP7jQn0Lqv3jBj2AeWaxleQuLautigmBbDt4Kvw?=
 =?us-ascii?Q?8cP+saE5hnOmUZ0IZs0wGtpa5kqSR3OucHO007vpXLylHqMX9o/DN82XTSya?=
 =?us-ascii?Q?vFqNI7jT4Yw6vZ0cYyhG2keixREUegzybw0We91/9S2AZAoEJ1Rh2IQ+eG/t?=
 =?us-ascii?Q?0VZMjOmDjfV9v2Rzt/JOHA=3D=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(396003)(346002)(36840700001)(40470700004)(46966006)(356005)(8676002)(81166007)(70586007)(70206006)(4326008)(47076005)(82740400003)(5660300002)(40460700003)(107886003)(336012)(186003)(2616005)(478600001)(1076003)(26005)(41300700001)(426003)(54906003)(6666004)(966005)(316002)(36860700001)(7696005)(83380400001)(110136005)(36756003)(7416002)(8936002)(86362001)(2906002)(82310400005)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 05:13:34.4573
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a012d59-2220-4483-eb0f-08da800f3bfa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1410
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is part 2 for the vfio-pci driver power management support.
Part 1 of this patch series was related to adding D3cold support
when there is no user of the VFIO device and has already merged in the
mainline kernel. If we enable the runtime power management for
vfio-pci device in the guest OS, then the device is being runtime
suspended (for linux guest OS) and the PCI device will be put into
D3hot state (in function vfio_pm_config_write()). If the D3cold
state can be used instead of D3hot, then it will help in saving
maximum power. The D3cold state can't be possible with native
PCI PM. It requires interaction with platform firmware which is
system-specific. To go into low power states (Including D3cold),
the runtime PM framework can be used which internally interacts
with PCI and platform firmware and puts the device into the
lowest possible D-States.

This patch series adds the support to engage runtime power management
initiated by the user. Since D3cold state can't be achieved by writing
PCI standard PM config registers, so new device features have been
added in DEVICE_FEATURE IOCTL for low power entry and exit related
handling. For the PCI device, this low power state will be D3cold
(if the platform supports the D3cold state). The hypervisors can implement
virtual ACPI methods to make the integration with guest OS.
For example, in guest Linux OS if PCI device ACPI node has
_PR3 and _PR0 power resources with _ON/_OFF method, then guest
Linux OS makes the _OFF call during D3cold transition and
then _ON during D0 transition. The hypervisor can tap these virtual
ACPI calls and then do the low power related IOCTL.

The entry device feature has two variants. These two variants are mainly
to support the different behaviour for the low power entry.
If there is any access for the VFIO device on the host side, then the
device will be moved out of the low power state without the user's
guest driver involvement. Some devices (for example NVIDIA VGA or
3D controller) require the user's guest driver involvement for
each low-power entry. In the first variant, the host can move the
device into low power without any guest driver involvement while
in the second variant, the host will send a notification to user
through eventfd and then user guest driver needs to move the device
into low power. The hypervisor can implement the virtual PME
support to notify the guest OS. Please refer
https://lore.kernel.org/lkml/20220701110814.7310-7-abhsahu@nvidia.com/
where initially this virtual PME was implemented in the vfio-pci driver
itself, but later-on, it has been decided that hypervisor can implement
this.

* Changes in v6

- Rebased patches on v6.0-rc1.
- Updated uAPI documentation.
- Fixed return value checking for pm_runtime_resume_and_get().
- Refactored code around low power exit to make it cleaner. 
- Updated commit message and comments at few places.

* Changes in v5
  (https://lore.kernel.org/all/20220719121523.21396-2-abhsahu@nvidia.com/)

- Rebased patches on https://github.com/awilliam/linux-vfio/tree/next.
- Implemented 3 separate device features for the low power entry and exit.
- Dropped virtual PME patch.
- Removed the special handling for power management related device feature
  and now all the ioctls will be wrapped under pm_runtime_get/put.
- Refactored code around low power entry and exit.
- Removed all the policy related code and same can be implemented in the
  userspace.
- Renamed 'intx_masked' to 'masked_changed' and updated function comment.
- Changed the order of patches.

* Changes in v4
  (https://lore.kernel.org/lkml/20220701110814.7310-1-abhsahu@nvidia.com/)

- Rebased patches on v5.19-rc4.
- Added virtual PME support.
- Used flags for low power entry and exit instead of explicit variable.
- Add the support to keep NVIDIA display related controllers in active
  state if there is any activity on the host side.
- Add a flag that can be set by the user to keep the device in the active
  state if there is any activity on the host side.
- Split the D3cold patch into smaller patches.
- Kept the runtime PM usage count incremented for all the IOCTL
  (except power management IOCTL) and all the PCI region access.
- Masked the runtime errors behind -EIO.
- Refactored logic in runtime suspend/resume routine and for power
  management device feature IOCTL.
- Add helper function for pm_runtime_put() also in the
  drivers/vfio/vfio.c and use the 'struct vfio_device' for the
  function parameter.
- Removed the requirement to move the device into D3hot before calling
  low power entry.
- Renamed power management related new members in the structure.
- Used 'pm_runtime_engaged' check in __vfio_pci_memory_enabled().

* Changes in v3
  (https://lore.kernel.org/lkml/20220425092615.10133-1-abhsahu@nvidia.com)

- Rebased patches on v5.18-rc3.
- Marked this series as PATCH instead of RFC.
- Addressed the review comments given in v2.
- Removed the limitation to keep device in D0 state if there is any
  access from host side. This is specific to NVIDIA use case and
  will be handled separately.
- Used the existing DEVICE_FEATURE IOCTL itself instead of adding new
  IOCTL for power management.
- Removed all custom code related with power management in runtime
  suspend/resume callbacks and IOCTL handling. Now, the callbacks
  contain code related with INTx handling and few other stuffs and
  all the PCI state and platform PM handling will be done by PCI core
  functions itself.
- Add the support of wake-up in main vfio layer itself since now we have
  more vfio/pci based drivers.
- Instead of assigning the 'struct dev_pm_ops' in individual parent
  driver, now the vfio_pci_core tself assigns the 'struct dev_pm_ops'. 
- Added handling of power management around SR-IOV handling.
- Moved the setting of drvdata in a separate patch.
- Masked INTx before during runtime suspended state.
- Changed the order of patches so that Fix related things are at beginning
  of this patch series.
- Removed storing the power state locally and used one new boolean to
  track the d3 (D3cold and D3hot) power state 
- Removed check for IO access in D3 power state.
- Used another helper function vfio_lock_and_set_power_state() instead
  of touching vfio_pci_set_power_state().
- Considered the fixes made in
  https://lore.kernel.org/lkml/20220217122107.22434-1-abhsahu@nvidia.com
  and updated the patches accordingly.

* Changes in v2
  (https://lore.kernel.org/lkml/20220124181726.19174-1-abhsahu@nvidia.com)

- Rebased patches on v5.17-rc1.
- Included the patch to handle BAR access in D3cold.
- Included the patch to fix memory leak.
- Made a separate IOCTL that can be used to change the power state from
  D3hot to D3cold and D3cold to D0.
- Addressed the review comments given in v1.

* v1
  (https://lore.kernel.org/lkml/20211115133640.2231-1-abhsahu@nvidia.com)

Abhishek Sahu (5):
  vfio: Add the device features for the low power entry and exit
  vfio: Increment the runtime PM usage count during IOCTL call
  vfio/pci: Mask INTx during runtime suspend
  vfio/pci: Implement VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY/EXIT
  vfio/pci: Implement VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP

 drivers/vfio/pci/vfio_pci_core.c  | 246 ++++++++++++++++++++++++++++--
 drivers/vfio/pci/vfio_pci_intrs.c |   6 +-
 drivers/vfio/vfio_main.c          |  52 ++++++-
 include/linux/vfio_pci_core.h     |   5 +-
 include/uapi/linux/vfio.h         |  56 +++++++
 5 files changed, 348 insertions(+), 17 deletions(-)

-- 
2.17.1

