Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D8A5972A3
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 17:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240690AbiHQPGO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 11:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237629AbiHQPGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 11:06:02 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D581160;
        Wed, 17 Aug 2022 08:06:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YkgHOrhANpaZvxWyxYqqSYkeGZHWBc6DnjIgeQeee8YCCZBEB+RnGNtKlZ84VD7nKg7dNeqTQBg4D0UasKiVsrL3bwYOYbsxIMyBgFhqce2ghejXJ5l5Fjb79jGmM/CoHHIbZZhk/k//xWjBuGbda0Bvqq+oCiFNggTj0boo/at94nFvDsHIVHHKuFF0U8U9Z/7EvRtDupW5RUnoGKQEq3cV10zB+f/TRh30hEu9XiUXu+MXXoicWMTQwI3qwM781twB3Zn8hoQlYQeGDd0a4GfrTeQueGDXFVFsHCczjkbtGaZzHtl+UK7QYMmEKq4Heg0HCMSuZDcve6cpDnTplA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PI6W3cxiitpmxnVoar212WtuWVmPDrDtBRSY0DdixAs=;
 b=EE+BnhipXZbTatMw6YNEWWXSJFhkK/1siBsxj5Tf5uG0EO5e39NNE6JZIKMnSOtq8GtEAeI5L1Wzlnrf/po7stuyGPPE7v0MeseNCzgZYWG6JAAD3Xc0d+tjliE4ZPItYsbte338DDfKw1Ips0kR1cqV63ErsNpc4Zpo097daVQ9yJyc9NY8ojgRH8yAvObSqi8bWfv4Tw/z6yB2Z7Ix3uz+GOfdhocUa7xUW4QI55G7xpNe5z9Qmt8a8dVDYSXeuW/rPhVNaj6PscKNTIXt9b2456+qbR7+quz4CeMZkld8iUY0m2WpmUqRd7qYLMxgdtBrPeMOj5dszb6znPk+xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PI6W3cxiitpmxnVoar212WtuWVmPDrDtBRSY0DdixAs=;
 b=LIb4lr7lZd0Dr71+BEzLQ9XZ/41Ol2wtSw8R8WZVrHPeHpLxvU872pReTKGz+f/BASiNFEH3habRr4AiIEMGDndgliP1BA/Imito0IU10rRtnJi92VIPcBtuVKlR64sGIu4VyRckanVqivXTrfA5Bl2gJ+e2L0TxaKZ9hsdslEU=
Received: from MW4PR03CA0299.namprd03.prod.outlook.com (2603:10b6:303:b5::34)
 by MN2PR12MB4031.namprd12.prod.outlook.com (2603:10b6:208:16e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.23; Wed, 17 Aug
 2022 15:05:57 +0000
Received: from CO1NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::ba) by MW4PR03CA0299.outlook.office365.com
 (2603:10b6:303:b5::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19 via Frontend
 Transport; Wed, 17 Aug 2022 15:05:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT073.mail.protection.outlook.com (10.13.174.196) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5546.7 via Frontend Transport; Wed, 17 Aug 2022 15:05:56 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 17 Aug
 2022 10:05:52 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 17 Aug
 2022 10:05:51 -0500
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Wed, 17 Aug 2022 10:05:43 -0500
From:   Nipun Gupta <nipun.gupta@amd.com>
To:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
        <eric.auger@redhat.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <puneet.gupta@amd.com>,
        <song.bao.hua@hisilicon.com>, <mchehab+huawei@kernel.org>,
        <maz@kernel.org>, <f.fainelli@gmail.com>,
        <jeffrey.l.hugo@gmail.com>, <saravanak@google.com>,
        <Michael.Srba@seznam.cz>, <mani@kernel.org>, <yishaih@nvidia.com>,
        <jgg@ziepe.ca>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <okaya@kernel.org>, <harpreet.anand@amd.com>,
        <nikhil.agarwal@amd.com>, <michal.simek@amd.com>, <git@amd.com>,
        Nipun Gupta <nipun.gupta@amd.com>
Subject: [RFC PATCH v2 0/6] add support for CDX bus controller
Date:   Wed, 17 Aug 2022 20:35:36 +0530
Message-ID: <20220817150542.483291-1-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803122655.100254-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e47982b-4658-4b97-5e80-08da8061fcf8
X-MS-TrafficTypeDiagnostic: MN2PR12MB4031:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FW6vpZVOrBAjjzKQFHrkyItMdTpF47f9DQjfU0eQ+cNW/Ri6+8T/yUNpdjb43mpTwYIdpIMSI2SsDnI2pk6EovAULb41R0/G/3/AIUgl/bNtE75yMyVxeWqb8DwiDXe4xv2LF5qjMzCfvCmecYmdpcxrYU/cw6cRRSkl0WcCJ9EkoLZKFk609lOJRPDnevtpc5up89y09AaMHbx8EehFTIEQZNcFeBdfSNuCob67Jx9iNEfyJK6/gJ8mF1aLn0cghIItEjfn6J7nqoqFhfbtFzILBtb3HkZE1NVwFCyVFwdZYEV+f9FtRk9VV7+51uMOpHUPvff5+b4S5KwHx2cK6jlvACE7n9soeQ0jwCKYIqPS+ouBZwcOKrXyhU4if0vXTPGVM4V+1iZwM9jT/lQnWuIuagfTxP+TUz/hIQ2FBhRFP4cBWKqBXLX4D7COX2JRw9YEAt3/DIg06tuGwTX6tIT+gvE3TGpzs+WKiTMdFPo/m22quAYr4kjBY1Bembj7oJkwzZEuY6EIDa4r7TG0s9bTzzsgnxes7XWJ5XR6y5wsZ4X005cbt2U1IMifQJbAdQx0fBdZX1AA+kFGcWBygjJROIc7hAeH8hGkls+S8X2j3EjU+MOCDgQ5MaztK42gjzhsz/pweUjGNQAelNntJjsKA1JAE9Vq5fl5IekdmSaWoOkmH+3bhmSOo6zx4RL/fPSU8UY78Q9UpV+yyEoLTq6grD9L7j6AdnjQeyfhNaZaLReHngVt9Yat7B6/AyvQgbVI53vmh+OFPlv/X8/dDM6IgLvUm2olG7dI/fRLzipVukjwpNC3FZEtDi9UH0Gqyg4CtzPUMVzcJnV7dlzgl/YgrsYxTFldjvnE++zKyven7EI9CEFFo99tDsudM/DtlF6wmnXrez4ZN7f4uSvC+g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(396003)(136003)(346002)(40470700004)(36840700001)(46966006)(2616005)(86362001)(81166007)(1076003)(186003)(47076005)(110136005)(426003)(336012)(921005)(82740400003)(356005)(40460700003)(83380400001)(36860700001)(7416002)(5660300002)(70206006)(4326008)(8676002)(70586007)(82310400005)(316002)(44832011)(36756003)(2906002)(478600001)(8936002)(40480700001)(41300700001)(26005)(6666004)(54906003)(2101003)(83996005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 15:05:56.8790
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e47982b-4658-4b97-5e80-08da8061fcf8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4031
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Devices in FPGA can be added/modified dynamically on run-time.
These devices are exposed on system bus to embedded CPUs.

Xilinx CDX bus, caters to the requirement for dynamically
discovered FPGA devices. These devices are added as platform
devices where fwnode is created using 'software nodes' in
Linux framework.

This RFC:
- Intrduces the CDX bus controller and platform device
  creation for the devices on the CDX bus.
- Add rescan and reset support for the CDX buses as well
  as reset of the devices on the CDX bus.
- VFIO platform reset support for CDX bus.
- creates a sysfs entry to expose the compatible string
  for platform devices.

Please NOTE: This is a RFC change which does not yet support
the CDX bus firmware interface as it is under development, and
this series aims to get an early feedback from the community.
There are TODO items mentioned in the patches which needs to
be updated for complete bus support.

Changes in v2: 
- introduce basic CDX bus infrastructure
- fixed code for making compatible visible for devices
  having the 'compatible' property only.
- moved CDX-MSI domain as part of CDX bus infrastructure
  (previously it was part of irqchip).
- fixed few prints
- support rescan and reset of CDX bus 
- add VFIO reset module for CDX bus based devices

Nipun Gupta (6):
  Documentation: DT: Add entry for CDX controller
  bus/cdx: add the cdx bus driver
  bus/cdx: add cdx-MSI domain with gic-its domain as parent
  bus/cdx: add rescan and reset support
  vfio: platform: reset: add reset for cdx devices
  driver core: add compatible string in sysfs for platform devices

 Documentation/ABI/testing/sysfs-bus-cdx       |  34 ++
 Documentation/ABI/testing/sysfs-bus-platform  |   8 +
 .../devicetree/bindings/bus/xlnx,cdx.yaml     | 110 +++++
 MAINTAINERS                                   |   8 +
 drivers/base/platform.c                       |  23 ++
 drivers/bus/Kconfig                           |   1 +
 drivers/bus/Makefile                          |   3 +
 drivers/bus/cdx/Kconfig                       |   7 +
 drivers/bus/cdx/Makefile                      |   3 +
 drivers/bus/cdx/cdx.c                         | 391 ++++++++++++++++++
 drivers/bus/cdx/cdx.h                         |  51 +++
 drivers/bus/cdx/cdx_msi_domain.c              |  90 ++++
 drivers/vfio/platform/reset/Kconfig           |   8 +
 drivers/vfio/platform/reset/Makefile          |   1 +
 .../vfio/platform/reset/vfio_platform_cdx.c   | 104 +++++
 include/linux/cdx/cdx_bus.h                   |  53 +++
 16 files changed, 895 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-cdx
 create mode 100644 Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
 create mode 100644 drivers/bus/cdx/Kconfig
 create mode 100644 drivers/bus/cdx/Makefile
 create mode 100644 drivers/bus/cdx/cdx.c
 create mode 100644 drivers/bus/cdx/cdx.h
 create mode 100644 drivers/bus/cdx/cdx_msi_domain.c
 create mode 100644 drivers/vfio/platform/reset/vfio_platform_cdx.c
 create mode 100644 include/linux/cdx/cdx_bus.h

-- 
2.25.1

