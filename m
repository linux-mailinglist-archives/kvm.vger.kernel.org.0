Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A395FE80A
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 06:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiJNElU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 00:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiJNElT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 00:41:19 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060.outbound.protection.outlook.com [40.107.95.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1327B18DC27;
        Thu, 13 Oct 2022 21:41:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kiw6XgzszwP4TeCBDwo1wK8sHjlo6cHS9tUp23htZluteHK3pGlT2L46lZhGvfWYNF2wh8UWoQSfJ49iNGp8sLqfjrWj2r4l4jg5+0Yl/SZCCQbDVbpB/OwvqvggVoaiV/yQlu9nKvE8P8nCaXDYPTzgCQL3OxWZOJ1RA1zexDvOiEuv9hvf1/0ibCvOX3dvKC5RUmZxPP2wKbjJAWXX8RFN2Hb5ZWWpV5C7lHpVVJlVdqQyDUNr1r5Ixqlk9JuoIgnptrS3mB/U6PZDmee/GcRSmYKYrXp8te5Ocb0Nt2UGVf0XvrLwRE6g/M+ZhRIRsdPvuX1kw9AkLHfth4Y43w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7XKjJOzezciDJQHdklMiqExgtT5/p4tneshSFqoygkQ=;
 b=FOXPzeb56RAQjAvgiTi1CcvEF2qUuP2eoNvBJtS3CerSOUW3bi1B5DPjm7dAgKfkX03hDyMjL7DRpLDeOend9/qAzLZg5G/Fr3CjoAUb4+CBIChJOp+1hRJRiuQt7+bdgLFAiNEM36w2LfJKWb+Eb/t5PZc/+E9NDWw5CaDdhKK35YtoALnzbgJKQaWE9L1UOzqPwqUKBSOhJiK462KCfZBoB2sOA98tt3l8oDyE859viAF9QQaf+Im72+K/tAQ8eakE5qnbXbmMPjwJ0nTKwM7qINXJCNR9uvlE1gpp53XGOB8w62jBQP6IfGxCE1NUBhV+lg/AGDNg0pZ4idt/8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7XKjJOzezciDJQHdklMiqExgtT5/p4tneshSFqoygkQ=;
 b=zubEblEskUcsls5Jb3y3dEruR7M/c48l5MinlpFk2SpILtysZP6F5bSKDTzF570qnk0NOA9B5YqITRQatfyYElhf4ach+lkEs0ru1AwAUejpCZo0QeJFPMQx2zQWAJYiVT4ItLdNAe3rbCsrq7ut0/wz+TiJSzubQabUS5wd29s=
Received: from MW4PR03CA0177.namprd03.prod.outlook.com (2603:10b6:303:8d::32)
 by CY5PR12MB6180.namprd12.prod.outlook.com (2603:10b6:930:23::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Fri, 14 Oct
 2022 04:41:16 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::37) by MW4PR03CA0177.outlook.office365.com
 (2603:10b6:303:8d::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30 via Frontend
 Transport; Fri, 14 Oct 2022 04:41:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Fri, 14 Oct 2022 04:41:14 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 23:41:11 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 21:40:58 -0700
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Thu, 13 Oct 2022 23:40:50 -0500
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
Subject: [RFC PATCH v4 0/8] add support for CDX bus
Date:   Fri, 14 Oct 2022 10:10:41 +0530
Message-ID: <20221014044049.2557085-1-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803122655.100254-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT058:EE_|CY5PR12MB6180:EE_
X-MS-Office365-Filtering-Correlation-Id: abd7cc70-bfe7-4ec3-40d4-08daad9e53d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bfogD0BoJ3WEZmkinRXPoyuR3d1El37DF+ZdSCh7OX9yMw6bB45iu/DmalwPZXj0j2WdMiNHEp0nVIBwnKcYesVsjNxF23NIhfEZnpXqfFxfD62owP5/PbRVlR9vYga/pINR/HN3Z/aErNXOO1nts/aae6QQg8EZxnA4LSr1COpEpBdlv6kL3JPmx/+30gfDtjgWD2qHUzdNczQs0TzUSwtNTeDD1ajfkmk63qORJyMO5/SeytrEu8GPI2FKP7wUZuUS03DFmFAX5bFENBRoxzJ9pYNZhz6vS6aIv0JDzuI8ohH8XEOGDJyEgvWWgxsOlSBqjOP1FlCWabIsY8tYDUZEMzYEuGQXIt6DxmdQ5+gz9PPoIUbPgAwxhX4bwmkmbM8ZrzNoNP+Ywy680hdUdUtWnx4yNB4yCvA2fJjFJKojZM9ATytMHVilbOTvxixilek0kt0hg6rleMpeGxeLwpOipXf+pBxeozOUmDX5EKzQt1bkik2IICiEe9JLL38PcziYO+ORC0yZDhCmStYrxWGPSxzaZu2T7sWXLMpXPE01mUg5zoawuiIT8vC+4FIqm5/ayAucJlyVdBng0MP2I2EQ0aOlnoOGEIyqx11yXcWoxBXsJDumFHJyMcKEKdlvwempyW4f5fHoOZrFj/fKw6LRyr0wywRwFIFYiMFx4zV6oGNOUB4ZOpbm7QuPgj3zxnNmEcyn5cPf4PKuyjjX35Z2hLymF5+j9XYgg2N0UrUsVjHiCqejjipweinkyNfsdIiZFzB9nzdcPNH2YXjHmxmj4DLeFJnLGrBkZpLuEKPa3sSjOmeECzcfp1fpQ93mlWJe7Vff9Pif2hrFamoPiaUAtEPka+mQ7BPsnsIHrnE6uifg2tMTNMbj9Cz6Xho9
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(346002)(396003)(376002)(451199015)(46966006)(36840700001)(40470700004)(36756003)(40480700001)(2616005)(4326008)(26005)(2906002)(82740400003)(86362001)(336012)(316002)(8936002)(54906003)(70206006)(1076003)(186003)(8676002)(6666004)(356005)(110136005)(478600001)(82310400005)(5660300002)(7416002)(81166007)(921005)(44832011)(70586007)(40460700003)(36860700001)(47076005)(426003)(41300700001)(83380400001)(2101003)(83996005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 04:41:14.7484
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: abd7cc70-bfe7-4ec3-40d4-08daad9e53d4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6180
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
- remove 'compatible' sysfs platform patch which was required
  for CDX devices exposed as platform devices

Changes in v4: 
 - Separate CDX bus and CDX controller driver (Greg K-H)
 - Added MSI interfacing to Firmware for writing MSI message
   to firmware so it can be provided to the device.
 - Fix MSI review comments - multiple cleanups (Mark Zynger)
 - Fix the device tree yaml compilation (Rob Herring, Krzysztof)
 - removed vfio-cdx from this series. It will be added after bus
   support is complete (Jason)

Nipun Gupta (8):
  dt-bindings: bus: add CDX bus device tree bindings
  bus/cdx: add the cdx bus driver
  iommu/arm-smmu-v3: support ops registration for CDX bus
  bux/cdx: support dma configuration for CDX devices
  bus/cdx: add bus and device attributes
  irq/msi: use implicit msi domain for alloc and free
  bus/cdx: add cdx-MSI domain with gic-its domain as parent
  bus/cdx: add cdx controller

 .../devicetree/bindings/bus/xlnx,cdx.yaml     |  66 +++
 MAINTAINERS                                   |   8 +
 drivers/base/platform-msi.c                   |   4 +-
 drivers/bus/Kconfig                           |   1 +
 drivers/bus/Makefile                          |   3 +
 drivers/bus/cdx/Kconfig                       |  17 +
 drivers/bus/cdx/Makefile                      |   8 +
 drivers/bus/cdx/cdx.c                         | 557 ++++++++++++++++++
 drivers/bus/cdx/cdx.h                         |  76 +++
 drivers/bus/cdx/cdx_msi.c                     | 161 +++++
 drivers/bus/cdx/controller/Kconfig            |  16 +
 drivers/bus/cdx/controller/Makefile           |   8 +
 drivers/bus/cdx/controller/cdx_controller.c   | 210 +++++++
 drivers/bus/cdx/controller/mcdi_stubs.c       |  68 +++
 drivers/bus/cdx/controller/mcdi_stubs.h       | 101 ++++
 drivers/bus/fsl-mc/fsl-mc-msi.c               |   4 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  16 +-
 drivers/pci/msi/irqdomain.c                   |   4 +-
 drivers/soc/ti/ti_sci_inta_msi.c              |   2 +-
 include/linux/cdx/cdx_bus.h                   | 165 ++++++
 include/linux/mod_devicetable.h               |  13 +
 include/linux/msi.h                           |  10 +-
 kernel/irq/msi.c                              |  22 +-
 scripts/mod/devicetable-offsets.c             |   4 +
 scripts/mod/file2alias.c                      |  12 +
 25 files changed, 1529 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
 create mode 100644 drivers/bus/cdx/Kconfig
 create mode 100644 drivers/bus/cdx/Makefile
 create mode 100644 drivers/bus/cdx/cdx.c
 create mode 100644 drivers/bus/cdx/cdx.h
 create mode 100644 drivers/bus/cdx/cdx_msi.c
 create mode 100644 drivers/bus/cdx/controller/Kconfig
 create mode 100644 drivers/bus/cdx/controller/Makefile
 create mode 100644 drivers/bus/cdx/controller/cdx_controller.c
 create mode 100644 drivers/bus/cdx/controller/mcdi_stubs.c
 create mode 100644 drivers/bus/cdx/controller/mcdi_stubs.h
 create mode 100644 include/linux/cdx/cdx_bus.h

-- 
2.25.1

