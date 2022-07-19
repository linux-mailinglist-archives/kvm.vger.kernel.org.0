Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA0B579C70
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 14:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbiGSMkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 08:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241285AbiGSMjT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 08:39:19 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E42452E7E;
        Tue, 19 Jul 2022 05:15:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqK4DJqFOaIOB3Cnrte26vBj/JYXDvJmra1HN6Ss3+Cz1MW06UrOVfWGZMv8b7iC3ukQwPx6lgg7clKFRVJAqGw5UL+5sBURS8pFnzsRTMfW2uMAL6Sgpqivbr7hq3Oypckd57VDFp/G1XIIYB0vO/ftRvXQ7bXmtQQFLYP80JmOfbnHewGLETaitrQhM759NFOm8LnYL5E8ECBPoPudYQg4CmOvlxHZmcWLfUAWQy9JRg2CEIKcFVG7/hzAHmxjLyAykco808R9oH2q/+72N5CjLU1kKVWjLLfsFsbxo6t3/8sejaKKxw5k4za4ZaN1iPZu8KcMouKkg/e7u6YYbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WPpbfvu8K4O/Bwhn9FibLGsFjdLHTSvrzA8Xvnn5ds0=;
 b=N7sP9aKHA24LYcHhwn5eRXyUfHPWUQAkSwz7o67LX8GaUTRBCjBK8LrY4TJj1VWRI3y3z4j+3aMuc+pEYpqSDDAkoQQC1A5CzqruR+NS710NGdLGo4oUneIOty1pxEfB8r/FG5xdg00F0m2iBuFtwN58DLWGs6DUUi8qiOGFSe54AEK85rwfMg/3QMzrgvxrTsBsaCmr6F7hDXISV8RsWbdVA6CUggqAvhxsQuGsAddTL1SmyCZ6dVjJx8OkVtWeduko6dBJmp9a19l+nLO4Oy+oUcz6pc80+IOp0bxeAXYn5Sloz32f3EsJnO9lqoclBJF8NVhn/B7Dd6pSXQ/yRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WPpbfvu8K4O/Bwhn9FibLGsFjdLHTSvrzA8Xvnn5ds0=;
 b=XChUMPQ1gJfB9Q0cJkckoiUAKc+uYATXsVyvEGbGUhHIrCgx/EYsZ2FVYd7Q5NL286/whIM8J8KkqHwrEMVSENN48zHEznBGmdEs9X4VJG9R/RTcEPEmWL8yCPKuttS/+eYEgZC+dxFr+MopJus0huCtT9HUi2snl/H9539zJnsEKKBdY32/1dP60F+kbV7xFDolC0G8smbMJykks7ABac7nqHvtKGJqW5Z8OalxQV8hM8rMZv6M10q8J58JY0WgahXSsTgb0yy/NmPAKw7VQDtf1vffyTAwuXacFiN+ehfioIiHcyTfAUpxaq2ADWrgwTg9oLtpOGWJ3Pw0vT9Ouw==
Received: from BN0PR03CA0009.namprd03.prod.outlook.com (2603:10b6:408:e6::14)
 by CY5PR12MB6600.namprd12.prod.outlook.com (2603:10b6:930:40::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 12:15:35 +0000
Received: from BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::d2) by BN0PR03CA0009.outlook.office365.com
 (2603:10b6:408:e6::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14 via Frontend
 Transport; Tue, 19 Jul 2022 12:15:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT053.mail.protection.outlook.com (10.13.177.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Tue, 19 Jul 2022 12:15:34 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 19 Jul 2022 12:15:34 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 19 Jul 2022 05:15:33 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 19 Jul 2022 05:15:27 -0700
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
Subject: [PATCH v5 0/5] vfio/pci: power management changes
Date:   Tue, 19 Jul 2022 17:45:18 +0530
Message-ID: <20220719121523.21396-1-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4d0d7dc-ece2-4cb5-4432-08da6980622c
X-MS-TrafficTypeDiagnostic: CY5PR12MB6600:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1sqK4pyWwfVz4A8PYsCaI2TvWvoGpLjM/5gf5LnS+UbJ2Zm/nRVYoptym8T6?=
 =?us-ascii?Q?XOEYeGIwF6rJ23r66OpEiQWi6YxIuBxN2I0ZzlVFIxGPN640NXq+w3sHS94p?=
 =?us-ascii?Q?92O/HcXK3A/3KLzFvaRB2DOi2AKtLrzZrVekGn6/9FVnAR1AWe5uJcohtXcS?=
 =?us-ascii?Q?0o1RF7EiQjSDMAMDJ0aj9SSjC7/rQCvcjEUG2w2ZjkhhuQ6sBQnEtaB1gvZS?=
 =?us-ascii?Q?XIxAxodM0RFqlX5UNLq9LPPCfd5KzWjyZZRd9ekhRWDAsqQv+gt7QNHkc7Fy?=
 =?us-ascii?Q?fd2jfDFpW2wCNB580AOP0J8eb/4jUfNWJQ2anmEqBcIU2PDkuXQbv19PZDF+?=
 =?us-ascii?Q?uETIZjGTj/2Qbunc24VghqbK6z6WeXWbKQd/VBbElK/Qmgr8T2GklcQ/o0I9?=
 =?us-ascii?Q?vTNiVADPoGNccArvZYI9CzIP50rEVca5DUhEoGXOnF7PTIve4nEw3t8+rpmq?=
 =?us-ascii?Q?QDW0jQzIQ+PGxKjYh1ZbzCaATn8+E2XipxpNxnlWkgyxWWCOnh92Yp4lTO1x?=
 =?us-ascii?Q?5fLkgs14q16wgZFv3mMxo8ONkO9gHzf23bu7zebFBC5nYfZZKLBuDmgE5hXg?=
 =?us-ascii?Q?vQNkIE10s6K10yK7DLDs+rewm/dJCkfTP5wz1jzdn5aPS8EOlhqaYnUmGSep?=
 =?us-ascii?Q?77Fwec+8J3QtI+GFX36J874larfq8hPjPkQ0K0RwIqbPzY/CohhC5B73M7Lb?=
 =?us-ascii?Q?Q6Fi3mShP7SsRmwlrSBvA4K8YAzfHEgq4DuNyyQG9tG8U4T26cQLGnZi7tdU?=
 =?us-ascii?Q?1+BnaswQ41N1bNASQjt2MifbBlNameYK3OpoWqHQSdb4RUFbQIp5SKUW5nF5?=
 =?us-ascii?Q?iz1xRRo5KkzJ21GkCCWRhGG/pu8Vfs4vO0qimDNoyNy9qnbwuPrAREaZBS/U?=
 =?us-ascii?Q?8WLwSmki5uh3wDfX+5HOAQJ+26Tb/nuYLtl5EcwqEQLKskksbiqeMw2+hw7g?=
 =?us-ascii?Q?BaYKIRJjqA4ON1alcbI/Ig=3D=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(136003)(376002)(36840700001)(46966006)(40470700004)(8676002)(4326008)(70586007)(336012)(70206006)(40460700003)(478600001)(82740400003)(8936002)(40480700001)(356005)(86362001)(36860700001)(36756003)(2906002)(6666004)(26005)(41300700001)(7696005)(110136005)(426003)(5660300002)(2616005)(966005)(47076005)(186003)(7416002)(83380400001)(316002)(54906003)(82310400005)(1076003)(107886003)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 12:15:34.8426
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4d0d7dc-ece2-4cb5-4432-08da6980622c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6600
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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

* Changes in v5

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

 drivers/vfio/pci/vfio_pci_core.c  | 256 ++++++++++++++++++++++++++++--
 drivers/vfio/pci/vfio_pci_intrs.c |   6 +-
 drivers/vfio/vfio.c               |  52 +++++-
 include/linux/vfio_pci_core.h     |   5 +-
 include/uapi/linux/vfio.h         |  55 +++++++
 5 files changed, 357 insertions(+), 17 deletions(-)

-- 
2.17.1

