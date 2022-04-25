Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C42350DC87
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 11:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235800AbiDYJ3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 05:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbiDYJ3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 05:29:35 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2068.outbound.protection.outlook.com [40.107.93.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED0913F75;
        Mon, 25 Apr 2022 02:26:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Stux1L27MTK+Puy43EvOluVQbDRAeNcLIUwFfnZuWaRAOfgvIkrW8OdR9vktkitgoPe1g/zRdafxNUun1+5LgFSLuMwT0zOQVd5kaH/ZNo72pOj3603g4Mz7ZU9CHFhOv2QXR3LZFJ/da2rMQw8wEvtyK7zvn2sOtFOpL1muFPLINMq2xqKHxXLguDQclz2ANoftE3M224Q07cnT1U3hww/yVD96V2fydcRinHUk7Y07P1FyNaWKg6HNBqHocZR7yQvckBaioYsGVUqsla9ZTTWMALOSiBhRZ/BoHVVeFJmK3bBu04qK4rC1LfYSbBeP8FA7YFp49GJONiSvXecTuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NlZcgu2sketGuQtUnOhHCoD5/gw6nMrzUT3ozbRf0yY=;
 b=oI/nYyNbEBEK9TFwVXVN6tsXKAWZF0IjMMlO7ZMGvGsjYlfzOupxc8v0jsvAzzeruAq0DwoFPp4A05KwYy/OH994Cfm8ra52YGj6tJQ7EpTXQcrVOrdSuKRgZVwYizjxStr3mauXXgc+tw7gfBX6GsfRYmFrwBtexYceAZ3B43GdmGlgs+DytukcQyASbHWxJsB7ZvaubaQKrCc2PlQAxZrnZ0ZT1xeCmUlzNl15uM02RkvCnKjZubwYruVPQh/FHLdtmc1UG3kl3QBV4f75o1qIQM6U9NEQPX+arNkqp2WUPX6LE4cyZSZdlHij48u3bzOpz1VR8YeTTShVLIvP7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NlZcgu2sketGuQtUnOhHCoD5/gw6nMrzUT3ozbRf0yY=;
 b=j/nvlRQFFOkP/KY7Gu4dvDWQGi3Jg7aAMfImig0tl1QVNgCS9rheZBvH8X6rhVe1XHIN7Ax7Xrmf/GInpKl4BZ9+6MKrrPoGUXF5iqY+KrNm2gsH9xGIjLSvzc5P+KyTHWcI873NaWz8rq3ptOBvyanY8dEXcjiTqWJyJdjuvFJfIrj8M2LZRR3qs21rPaRu0v7oYzua4AmxXTzm4d239kptwxumovpb6nnLYHGCzf+IYO/VW8oh58jW3BCeC+5sMuFcDqAL6exZbUp8uWR/PI7CrCvN5o6u8gC/czVFQynUdej/cZlqWZBcz2vTa/+hsbY0ExebFl5Pjc2QoSxpPQ==
Received: from DM5PR07CA0086.namprd07.prod.outlook.com (2603:10b6:4:ae::15) by
 MW3PR12MB4554.namprd12.prod.outlook.com (2603:10b6:303:55::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.13; Mon, 25 Apr 2022 09:26:29 +0000
Received: from DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::f7) by DM5PR07CA0086.outlook.office365.com
 (2603:10b6:4:ae::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13 via Frontend
 Transport; Mon, 25 Apr 2022 09:26:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT065.mail.protection.outlook.com (10.13.172.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Mon, 25 Apr 2022 09:26:28 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 25 Apr
 2022 09:26:27 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 25 Apr
 2022 02:26:27 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 25 Apr 2022 02:26:22 -0700
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
Subject: [PATCH v3 0/8] vfio/pci: power management changes
Date:   Mon, 25 Apr 2022 14:56:07 +0530
Message-ID: <20220425092615.10133-1-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d51f43c5-bda5-4cf2-1d50-08da269dad4f
X-MS-TrafficTypeDiagnostic: MW3PR12MB4554:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB4554B3FF5DE2BDF12B741523CCF89@MW3PR12MB4554.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WATo7u+JwIpfI+y5beKnLxuT3BM4IGylk678aPxKAjCL3vAaWlp4p2PLg3j27hjUAq8gwXsiKaMRpkzza4/FqIyp0byrzDJ89e0AHbGMoC4KC4YnoRfY2OHF0aOkZ6IqWgRqAfxaWvzhM+gpzwupe9e504dXBi4kijyixMMdEGsmMcquQAgMQqt55+B2uAIDhuMedmxiA2KNUy+LQL45qYPyYK0y1LWtOAZcogdC3okRUiqlYUojnDsEWzSqZOHXcX2zwOYUQ1bU2ujaJzgW6ubsAdssXe2vc1THe/MqSrU2fUP0V/L59DNXYPJ+vdGIjrV0GXWhHh1J58NaudHI3tyWVboRCpYAGwt81vi0x8i4P0XzTZLRb09l6BDM4bVgIdcE5x4B1f8yE6qkWQJtHNfEEetTClDQ8vrtqbszesRi+xb39U2glObLz1cq2cKlK1/YfaXUnjPq+Jka056jOw25Ny2+1Tfjhbh7JytPFowt/SaPs/UYG4wcqlpxRtCqOMtt3f8d+JlvCPtG2algUlbAfyiTGatmjJhVf6lmyNrBFb0MN46J2Yw4Vn3Uu1kY4/2KvsUY7ZHrepwr7/4C7dYsV4JZlxOHDenwjv9XJDaO8vGARSKbrGePZFSWLABFx4hx7aGLTB/ITaZGhqt+EFw4WQyhYwJNVBK7Yr91MjRhN5t7nEAX0ZgvgvE2473QCO4AItYju+7wKJ2FY/QQ7F8n9SeCvZhUw1G4PX8+VLo1yR3j+jgBXJAUU9ivuGHKUd7gzOjSho3D0qCw8lWh1H5/JztIfa/6tMNSI1oHC3OP7PUrwyHUV9vT7IRNe984ZISaJ2F6eb8ECE/5Jc9dUQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(316002)(54906003)(110136005)(2906002)(70206006)(40460700003)(7696005)(47076005)(1076003)(107886003)(6666004)(508600001)(82310400005)(86362001)(966005)(36860700001)(356005)(7416002)(70586007)(81166007)(83380400001)(36756003)(5660300002)(4326008)(8676002)(186003)(26005)(8936002)(426003)(336012)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 09:26:28.4304
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d51f43c5-bda5-4cf2-1d50-08da269dad4f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4554
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, there is very limited power management support available
in the upstream vfio-pci driver. If there is no user of vfio-pci device,
then it will be moved into D3Hot state. Similarly, if we enable the
runtime power management for vfio-pci device in the guest OS, then the
device is being runtime suspended (for linux guest OS) and the PCI
device will be put into D3hot state (in function
vfio_pm_config_write()). If the D3cold state can be used instead of
D3hot, then it will help in saving maximum power. The D3cold state can't
be possible with native PCI PM. It requires interaction with platform
firmware which is system-specific. To go into low power states
(including D3cold), the runtime PM framework can be used which
internally interacts with PCI and platform firmware and puts the device
into the lowest possible D-States. This patch series registers the
vfio-pci driver with runtime PM framework and uses the same for moving
the physical PCI device to go into the low power state.

The current PM support was added with commit 6eb7018705de ("vfio-pci:
Move idle devices to D3hot power state") where the following point was
mentioned regarding D3cold state.

 "It's tempting to try to use D3cold, but we have no reason to inhibit
  hotplug of idle devices and we might get into a loop of having the
  device disappear before we have a chance to try to use it."

With the runtime PM, if the user want to prevent going into D3cold then
/sys/bus/pci/devices/.../d3cold_allowed can be set to 0 for the
devices where the above functionality is required instead of
disallowing the D3cold state for all the cases.

Since D3cold state can't be achieved by writing PCI standard PM
config registers, so a feature has been added in DEVICE_FEATURE IOCTL
for low power related handling, which changes the PCI
device from D3hot to D3cold state and then D3cold to D0 state.
The hypervisors can implement virtual ACPI methods. For example,
in guest linux OS if PCI device ACPI node has _PR3 and _PR0 power
resources with _ON/_OFF method, then guest linux OS makes the _OFF call
during D3cold transition and then _ON during D0 transition. The
hypervisor can tap these virtual ACPI calls and then do the D3cold
related IOCTL in vfio driver.

The BAR access needs to be disabled if device is in D3hot state.
Also, there should not be any config access if device is in D3cold
state. For SR-IOV, the PF power state should be higher than VF's power
state.

* Changes in v3

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
  https://lore.kernel.org/lkml/20211115133640.2231-1-abhsahu@nvidia.com/

Abhishek Sahu (8):
  vfio/pci: Invalidate mmaps and block the access in D3hot power state
  vfio/pci: Change the PF power state to D0 before enabling VFs
  vfio/pci: Virtualize PME related registers bits and initialize to zero
  vfio/pci: Add support for setting driver data inside core layer
  vfio/pci: Enable runtime PM for vfio_pci_core based drivers
  vfio: Invoke runtime PM API for IOCTL request
  vfio/pci: Mask INTx during runtime suspend
  vfio/pci: Add the support for PCI D3cold state

 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |   4 +-
 drivers/vfio/pci/mlx5/main.c                  |   3 +-
 drivers/vfio/pci/vfio_pci.c                   |   4 +-
 drivers/vfio/pci/vfio_pci_config.c            |  63 ++-
 drivers/vfio/pci/vfio_pci_core.c              | 358 +++++++++++++++---
 drivers/vfio/pci/vfio_pci_intrs.c             |   6 +-
 drivers/vfio/pci/vfio_pci_rdwr.c              |   6 +-
 drivers/vfio/vfio.c                           |  44 ++-
 include/linux/vfio_pci_core.h                 |  12 +-
 include/uapi/linux/vfio.h                     |  18 +
 10 files changed, 445 insertions(+), 73 deletions(-)

-- 
2.17.1

