Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51805AEC12
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 16:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240660AbiIFOSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 10:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241871AbiIFOQz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 10:16:55 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A523C63C2;
        Tue,  6 Sep 2022 06:49:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZIVje1G+LpTgpnklShigHsfCfHZhZfB/4xgZTrrC2epcURHFU8WFRn9RXqtUHG6kQ4EtFNVh+mLWvdsS7SuLbOZN8E0xIwQ7uDLXfQO33H9/2HHrB7is+YkeQUrKcMgGXNkoU8W2PHXPisHIKLry9SAl9mReW6DQ2i/MGgvDSl7AMO4dJmx4vMiEmYn8UQgfErbDzcMJf5uVx7Wt+aUhXk4aVwYXPysJ4N2DIwa/iqxW3rXze00lI7fymSy5sKijfFmKpOg5VFWFebffqkOQJVU6bMRMBNYGXQpbl9d2+BIq53emKIBpm7N7mOM19SbVvP5Q/J+57B/2c83iThfEvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8DeGwctyS44Ypj9NKd7qCQAwoVdWuOIpzaw5crT+OJA=;
 b=niLfgFbIO276z6gRy6KAGKx9EqlryLS6QpNbRSXkFZNdr/7YOO5PJdo5orzWBaM5AUzCXvRKHezmomCjWwwUWTdwl0ffw+MOMxVufGgUyXX4bxZPGDu1KMaiSRWqrJnip8mvjk9ty8CfpCspTN5YueRT1Ep8QKgILaQrbG0O1CqiWo/q93DpOLJVzfuus8HlgD8q65GaotG0W38Dn8lOS25TLDiXSr+aPsd/3TnDNyGV0a2m9fRWw7I/VDtI4oweq4aYtD102mnhiKolD6Tl5Ss0nZFuURSky0iwxEhDML89Zh37YX8UWtSgPEfybeauakRT1pv5ajU/26O4i+YcwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8DeGwctyS44Ypj9NKd7qCQAwoVdWuOIpzaw5crT+OJA=;
 b=2AVCdQz687IF3AHh/bqjJ9eNl1iEdZ+Ui1tVTYvDToJX4JSyl6FyWwXo2NPLNSF25FzEgUkPx/5ZWEIDcnwp+5Tm/i9A8jX8VuJC8FrR6lyQPosBFCDeZzFzGN86SYSU9YLgLdCFF6JtwBxPv8E/ddGp0YvtSAhtnJnDteU5+qc=
Received: from CY5PR14CA0013.namprd14.prod.outlook.com (2603:10b6:930:2::23)
 by CH2PR12MB4939.namprd12.prod.outlook.com (2603:10b6:610:61::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.15; Tue, 6 Sep
 2022 13:48:14 +0000
Received: from CY4PEPF0000B8EE.namprd05.prod.outlook.com
 (2603:10b6:930:2:cafe::b2) by CY5PR14CA0013.outlook.office365.com
 (2603:10b6:930:2::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.13 via Frontend
 Transport; Tue, 6 Sep 2022 13:48:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000B8EE.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5612.9 via Frontend Transport; Tue, 6 Sep 2022 13:48:13 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 6 Sep
 2022 08:48:12 -0500
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Tue, 6 Sep 2022 08:48:02 -0500
From:   Nipun Gupta <nipun.gupta@amd.com>
To:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
        <eric.auger@redhat.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <puneet.gupta@amd.com>,
        <song.bao.hua@hisilicon.com>, <mchehab+huawei@kernel.org>,
        <maz@kernel.org>, <f.fainelli@gmail.com>,
        <jeffrey.l.hugo@gmail.com>, <saravanak@google.com>,
        <Michael.Srba@seznam.cz>, <mani@kernel.org>, <yishaih@nvidia.com>,
        <jgg@ziepe.ca>, <jgg@nvidia.com>, <robin.murphy@arm.com>,
        <will@kernel.org>, <joro@8bytes.org>, <masahiroy@kernel.org>,
        <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <okaya@kernel.org>, <harpreet.anand@amd.com>,
        <nikhil.agarwal@amd.com>, <michal.simek@amd.com>,
        <aleksandar.radovanovic@amd.com>, <git@amd.com>,
        Nipun Gupta <nipun.gupta@amd.com>
Subject: [RFC PATCH v3 0/7] add support for CDX bus
Date:   Tue, 6 Sep 2022 19:17:54 +0530
Message-ID: <20220906134801.4079497-1-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803122655.100254-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EE:EE_|CH2PR12MB4939:EE_
X-MS-Office365-Filtering-Correlation-Id: a304928f-18c6-4a1e-7623-08da900e71a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZHDEDbSIYcgCf+jdepbH5AYoGGEate7tor1uc3Gmse7XFKGNV6KpDG7YI1ztg6e3ewJ8uLWyYD/Ko14dds/e5Uluq5wwSFaAcFa5s4EERSBl/oNroAaolHAna12gxPjcLxzCFWdXHRk7FoizeIKbqFaKjb3jBFD5CE1FDpm9+xvVIE8ximSBLUiv/1rFtio2GkdIftHpiX+9TPr5IeI+PZomvyTlWg5NbPGysqpopdXJrhHjHsJ61ZmOQ5ExN7HXoZNS4Z3NK0aI1qO6qh1XnTLnK/5cVb2/FZBm8wvZJJlXGqV7aPsOde4feEfKfYntMXFBgSJY7mKNVMgnS7q1JV00VLI9A9x7S89qC45iE1FWXrofQfQem8fHjcRwQDh5LLEzPalzGhzohfMTlDpCTfB0sWeSZrKncDI9GeIXAJ2jZ5imYor+IoVyddBSpxnxeCvA5p3MNHB9P0e2kDT0Mi+ybHcLim0FjnZTQSMMvS+2h9jjqMpHt0kBL5+2R8VroyKRbxwRQSFzg5JaksHDbsk/tHZcYhJRmJ6GikDq9DyoYu47m14HQX4W3NDD9biViq0Qljb8dX91T61+KyokQzqarAIVaY5RG/n9rY5LWDI2VJL7fSYt4eM0mGQF0hGkmjWbJciWsRwJq5InyvK7MeIv3swSMvFmhMoR/kBOSIOH88a6agblCaKmY1te31RoDlhrbcnXCU8CSuPNOOZDWTNSCdLbD02ZZ+UKV6LBnlCFdckdR2xkhObvWUZgPmV3F2TTblcD8Vy3L5duOVLm09Hrloiu4f8N6c5G3fPrM361GNeI/8P2NXizs0lk6FM9Bqu29dJ4OLiuyrApKQxLQyxUJvIyeP499cRSdNqbl+8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(346002)(39860400002)(46966006)(36840700001)(40470700004)(36860700001)(5660300002)(316002)(83380400001)(110136005)(4326008)(8676002)(7416002)(54906003)(36756003)(44832011)(70206006)(8936002)(70586007)(2906002)(40480700001)(26005)(41300700001)(478600001)(86362001)(426003)(2616005)(336012)(82310400005)(186003)(1076003)(6666004)(40460700003)(356005)(921005)(81166007)(82740400003)(47076005)(36900700001)(83996005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 13:48:13.5814
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a304928f-18c6-4a1e-7623-08da900e71a9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4939
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Devices in FPGA can be added/modified dynamically on run-time.
This patch series introduces AMD CDX bus, which provides a
mechanism to discover/rescan FPGA devices on run-time. These
devices are memory mapped on system bus for embedded CPUs, and
added as CDX devices in Linux framework.

This RFC:
- Intrduces the CDX bus controller and CDX devices.
- Adds rescan and reset support for the CDX bus.
- Add support for reset for CDX devices.
- Support for CDX bus in arm-smmu-v3 driver
- Support for CDX-MSI domain.
- Vfio-cdx driver support for CDX devices.

Please NOTE: This RFC change does not support the CDX bus firmware
interface as it is under development, and this series aims to get
an early feedback from the community. Firmware interaction are
stubbed as MCDI APIs which is a protocol used by AMD to interact
with Firmware.

Changes in v2:
- introduce CDX bus infrastructure
- fixed code for making compatible visible for devices
  having the 'compatible' property only (Greg K-H)
- moved CDX-MSI domain as part of CDX bus infrastructure.
  previously it was part of irqchip (Marc Zynger).
- fixed few prints (Greg K-H)
- support rescan and reset of CDX bus
- add VFIO reset module for CDX bus based devices

Changes in v3:
- Move CDX bus as a new bus type in kernel rather than
  using the platform devices (Greg K-H, Marc Zynger)
- Correspondingly update ARM SMMU v3
- Add support for vfio-cdx driver
- Updated device tree yaml with correct binding information
  (Krzysztof Kozlowski)
- remove 'compatible' sysfs platform patch which was requried
  for CDX devices exposed as platform devices


Following text provides a basic overview of CDX bus Architecture.

Contents summary
   - CDX overview
   - CDX Linux driver architecture overview
        - Bus driver
        - VFIO driver

CDX Overview
------------

CDX is a Hardware Architecture designed for AMD FPGA devices. It
consists of sophisticated mechanism for interaction between FPGA,
Firmware and the APUs (Application CPUs).

Firmware resides on RPU (Realtime CPUs) which interacts with
the FPGA program manager and the APUs. The RPU provides memory-mapped
interface (RPU if) which is used to communicate with APUs.

The diagram below shows an overview of the CDX architecture:


         +--------------------------------------+
         |    Application CPUs (APU)            |
         |                                      |
         |                    CDX device drivers|
         |     Linux OS                |        |
         |                        CDX bus       |
         |                             |        |
         +-----------------------------|--------+
                                       | (discover, config,
                                       |  reset, rescan)
                                       |
         +------------------------| RPU if |----+
         |                             |        |
         |                             V        |
         |          Realtime CPUs (RPU)         |
         |                                      |
         +--------------------------------------+
                               |
         +---------------------|----------------+
         |  FPGA               |                |
         |      +-----------------------+       |
         |      |           |           |       |
         | +-------+    +-------+   +-------+   |
         | | dev 1 |    | dev 2 |   | dev 3 |   |
         | +-------+    +-------+   +-------+   |
         +--------------------------------------+


The RPU firmware extracts the device information from the loaded FPGA
image and implements a mechanism that allows the APU drivers to
enumerate such devices (device personality and resource details) via
a dedicated communication channel. RPU mediates operations such as
discover, reset and rescan of the FPGA devices for the APU. This is
done using memory mapped interface provided by the RPU to APU.

Nipun Gupta (7):
  dt-bindings: bus: add CDX bus device tree bindings
  bus/cdx: add the cdx bus driver
  iommu/arm-smmu-v3: support ops registration for CDX bus
  bus/cdx: add cdx-MSI domain with gic-its domain as parent
  bus/cdx: add bus and device attributes
  vfio/cdx: add support for CDX bus
  vfio/cdx: add interrupt support

 Documentation/ABI/testing/sysfs-bus-cdx       |  54 ++
 .../devicetree/bindings/bus/xlnx,cdx.yaml     |  75 +++
 MAINTAINERS                                   |   9 +
 drivers/bus/Kconfig                           |   1 +
 drivers/bus/Makefile                          |   3 +
 drivers/bus/cdx/Kconfig                       |   7 +
 drivers/bus/cdx/Makefile                      |   3 +
 drivers/bus/cdx/cdx.c                         | 603 ++++++++++++++++++
 drivers/bus/cdx/cdx.h                         |  53 ++
 drivers/bus/cdx/cdx_msi.c                     | 236 +++++++
 drivers/bus/cdx/mcdi_stubs.c                  |  61 ++
 drivers/bus/cdx/mcdi_stubs.h                  |  87 +++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  16 +-
 drivers/vfio/Makefile                         |   1 +
 drivers/vfio/cdx/Kconfig                      |  10 +
 drivers/vfio/cdx/Makefile                     |   4 +
 drivers/vfio/cdx/vfio_cdx.c                   | 337 ++++++++++
 drivers/vfio/cdx/vfio_cdx_intr.c              | 212 ++++++
 drivers/vfio/cdx/vfio_cdx_private.h           |  50 ++
 include/linux/cdx/cdx_bus.h                   | 120 ++++
 include/linux/mod_devicetable.h               |  13 +
 scripts/mod/devicetable-offsets.c             |   4 +
 scripts/mod/file2alias.c                      |  12 +
 23 files changed, 1969 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-cdx
 create mode 100644 Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
 create mode 100644 drivers/bus/cdx/Kconfig
 create mode 100644 drivers/bus/cdx/Makefile
 create mode 100644 drivers/bus/cdx/cdx.c
 create mode 100644 drivers/bus/cdx/cdx.h
 create mode 100644 drivers/bus/cdx/cdx_msi.c
 create mode 100644 drivers/bus/cdx/mcdi_stubs.c
 create mode 100644 drivers/bus/cdx/mcdi_stubs.h
 create mode 100644 drivers/vfio/cdx/Kconfig
 create mode 100644 drivers/vfio/cdx/Makefile
 create mode 100644 drivers/vfio/cdx/vfio_cdx.c
 create mode 100644 drivers/vfio/cdx/vfio_cdx_intr.c
 create mode 100644 drivers/vfio/cdx/vfio_cdx_private.h
 create mode 100644 include/linux/cdx/cdx_bus.h

-- 
2.25.1

