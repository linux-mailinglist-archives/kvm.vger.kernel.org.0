Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD35A5A4B14
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 14:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbiH2MHc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 08:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiH2MHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 08:07:08 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B2915A31;
        Mon, 29 Aug 2022 04:51:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNOeYqwhWWc4p1jx3Uoyzt0rz3SEBfxJf4zMEDHb2qZuHEfnuNpcxj6oMJmjL4gL0cRva1osLn1fUyRPjEN6A7/NY2xqX88SkrJkYp48BKAjCtmLHpgXOfefVDnts3gdeN4rk+XZgqil9e2pNLQLjpx4giNwvlCzOrOVFs3v6IOJkMokWK+Of9Ih3kNeetvBheQyTjBXtPKUO+RAVwcbvhw0dNbtkvIZD4xfSLX92CrYQ2pfUVkWs5Sp7chjkSc7yISHiRa3iziO6wruCk6WR8a0KaDP7lLnEOieLYu1U+4QBgTTFos4QLv31FKvMA6xo4e52UdqSSOVIrBLGL0erw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DvcB4LiYhZKoLe0a9SkPKMIsJK1cKOflBEUMLc8oGVY=;
 b=StLoolj3NBn4k5VRq1owZxVdhvtVMThF0ZCjS9pkuNDB0qaWSb9IyANJXePNh7jBA/NSFJp+9ev9QFTxIy1dHm2qLxbAr2nXZ/g0309+1W3ClTF1Bu0Iq/mDjDliYG4ycecI+kQFLcPeaRRc+TfrulQZqHSU1P7zcdzyP34+i5V0+qSOwtMGb2Zj4M8MLMKTLnbFQ4oI2UZxOEOV4UD+23Q8eFIRkk81YaC7im9zlcZ8OtoSCvyFsl5CkFX7j40zND+Q0FciPbbxdw5YOWw11cr3eSx0ziqQtpvIoUqbqyC05xozxzhHPi1Fas77yI7ZId3HjnLN3uKvpGIMDJjZ0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DvcB4LiYhZKoLe0a9SkPKMIsJK1cKOflBEUMLc8oGVY=;
 b=BS/OYeU/Z52rxAuQtw7PNJ+Mnb2TK0SvVxNQNTmyK0xtKEIOG1YeL53shEmDAJ3IwgKOFWrFm2xgqSpq7vwWJFkgHmRPnVBfS0tuJjYotWnY1dWVCb/Y4RBx1vy57kKkBX9L8JzfDQwOzXCG8vnC1/hNWkJJeHO57DNV4nDHP0bdjcVrrOzHRUBAxLoLE+a9v9S24SvFkLi0puUv84qaTxDMC8DJN5eDgDQ8ID+hQGyoB8PRjZLJkFuVVvHP25amxGyj7Qx9yjXI3nA7cdUwPKuB6TZa4l1FuBoBfLCz7s2gooSQKD7rpCJvEH3gk65LF/AOB5R1MzFubHZxsHs8zg==
Received: from BN9PR03CA0289.namprd03.prod.outlook.com (2603:10b6:408:f5::24)
 by MN2PR12MB3149.namprd12.prod.outlook.com (2603:10b6:208:d2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Mon, 29 Aug
 2022 11:49:02 +0000
Received: from BN8NAM11FT089.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::fe) by BN9PR03CA0289.outlook.office365.com
 (2603:10b6:408:f5::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Mon, 29 Aug 2022 11:49:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT089.mail.protection.outlook.com (10.13.176.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Mon, 29 Aug 2022 11:49:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Mon, 29 Aug
 2022 11:49:01 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 29 Aug
 2022 04:49:00 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 29 Aug 2022 04:48:54 -0700
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
Subject: [PATCH v7 0/5] vfio/pci: power management changes
Date:   Mon, 29 Aug 2022 17:18:45 +0530
Message-ID: <20220829114850.4341-1-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fb1a856-b828-427c-8e55-08da89b4779d
X-MS-TrafficTypeDiagnostic: MN2PR12MB3149:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SUnZ88u3rkO0SNXNSjClhv474FU+MLZlKZJosXBwHnEwtE8s3RpATcpjTVQPTwNeV/RMUzD3w7iKBJFiaMB868UXCGAhOwBV+6XfzkV/QsM/PNdiXmNPt94INVh40UMlEm6ZPqzK76xontWB+4Xpvu9HpCHGLGqhcru7MEFgHyimioi2cjsyqdkSAAJJZeDUCNGwpPdYqVfDbXpKY9nOb/RBHQ+No6d7Bwl6rgYVvR+lBauM6HS6d7zN6nlrVqUQuMHl8lE4RTvWZqJ08ef6MMqaedqFSfVmfmaFAua3ibWBZi3XzjdHm4BNiksqms7Q+QkmvwjQ4YQvgQuoTLB+ZFYzfGsvWvZ9bWIzqHnnZWYDyYjnT4JiQThXztk1iJyB/4V+p/DOeEhgzN4VKNddNjIUpkQdvwKyPP9zzkrHnuu6EKyEHxT9upQijbGT7Mbl7+9I+keK1u4iEsHH00WIuXWX6ma6PdD9xS6g1rXK1HvkFaXqQhs/3IiqBrwZnON/nUUrPjbXxJEho7TymBnIGEJk9XLqUK5D6wnJx/+FX+FKHEv0FKbQi3MiOOiZQgs+TjZRq8VkV3INMVDKiwCq5pvK9GLulsI/TO+IlTKUh1MHXatSDUOeCaxApw4+rMPt54WaoB5z7xnl2XoLrnx6AWSK7mqnpNoetZwhXTkjkBUGYBK2gtPxZhR4F31I2RFRyGbJr8rEznR3zd2mH4h0Fw2g9TH2eCYN6I7O1g/NOvxXt5a6vUbOa+gCu/Fft6pYhYKOwj1Ef/3FvtDSy+XNPzHw6VR+9mZv4MrikVMNWSkkeWKPRU+5S24RWhXuCG/R5vuINuV+tZxiOQoUKlcE9xg2oq0shU+JDfwcnFwRjxw28waNq4M7bhFtg2AGREM4VL4RW1CRIcXEjILJFGhJ2xH2Ydtm97TrhlY7/1diY+s=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(376002)(136003)(346002)(40470700004)(36840700001)(46966006)(356005)(41300700001)(7696005)(26005)(86362001)(82310400005)(6666004)(40460700003)(36860700001)(478600001)(107886003)(966005)(426003)(2616005)(47076005)(81166007)(186003)(1076003)(336012)(83380400001)(5660300002)(2906002)(82740400003)(8936002)(7416002)(70586007)(316002)(110136005)(54906003)(8676002)(4326008)(70206006)(40480700001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 11:49:01.8560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fb1a856-b828-427c-8e55-08da89b4779d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT089.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3149
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
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

* Changes in v7

- Rebased patches over the following patch series
  https://lore.kernel.org/all/0-v2-1bd95d72f298+e0e-vfio_pci_priv_jgg@nvidia.com
  https://lore.kernel.org/all/0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com

- Since is_intx() is now static function, so open coded the same
  (s/is_intx()/vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX) and
  updated the commit message for the same.
- Replaced 'void __user *arg' with
  'struct vfio_device_low_power_entry_with_wakeup __user *arg'
- Added new device features in sorted order in
  vfio_pci_core_ioctl_feature().

* Changes in v6
  (https://lore.kernel.org/lkml/20220817051323.20091-1-abhsahu@nvidia.com)

- Rebased patches on v6.0-rc1.
- Updated uAPI documentation.
- Fixed return value checking for pm_runtime_resume_and_get().
- Refactored code around low power exit to make it cleaner. 
- Updated commit message and comments at few places.

* Changes in v5
  (https://lore.kernel.org/all/20220719121523.21396-2-abhsahu@nvidia.com)

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
  (https://lore.kernel.org/lkml/20220701110814.7310-1-abhsahu@nvidia.com)

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

 drivers/vfio/pci/vfio_pci_core.c  | 248 ++++++++++++++++++++++++++++--
 drivers/vfio/pci/vfio_pci_intrs.c |   6 +-
 drivers/vfio/pci/vfio_pci_priv.h  |   2 +-
 drivers/vfio/vfio_main.c          |  52 ++++++-
 include/linux/vfio_pci_core.h     |   3 +
 include/uapi/linux/vfio.h         |  56 +++++++
 6 files changed, 350 insertions(+), 17 deletions(-)

-- 
2.17.1

