Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06CA739342
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjFUXzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjFUXzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:55:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1311733;
        Wed, 21 Jun 2023 16:55:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ecVmX3xBpyOcn/1ciknqczT53Xr3wYQr7QR7sgGYaotyYxAsbYXqktgj/edbGUtIVkLGSgEwomc6A/ppNYvS/oFO6EkDpz9czeZYxZ6m1ETNquuXZ6EXA0k4dUjGqsT/t9OVHO/QYLsgiWfKM8ONkkDXshFFnjlMVnRfxeCFjeyUTvKW4ANNaTJFdmBd52KkmC331xYMfM4LJ9OZarOPZmR1meJhJ9A7MKUQQOLnheHxUgezWRGHIsw2iffFB79qg4WW8Dway5N2G9B/WxEUwor9IWD7p4FYDBXeAdhEA1ZRnrC+gZb/eb8OLPKMhFzm1RLVKhsanjJujHt2V9or5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1V7cgQ0ZlJJZewJC/fZEaolzYKqQGTsKCFXRog8HCec=;
 b=Lvlkbj8Sf17fkYt9C77DRmglJFyWbGJQswXzcIrzGYIid3gDFA+izmqtmJIFLa0DoWa1DOmTpN7LeaYEjeCzxDo1S63J42rauzZu+QoB9R8wVPEpofb98RJLSQC+5jKtKKcrfWgPJKmwE1tjmBqlFz7uO1Krhhgnjo1Ph7lOH7U84LU/TUqgAAvo7M0idWk7REJmsn5jqyV7VbwQ7uGkwiWY4cj2Gja+y9Ou+6aFOmhJs7aAUK/2EH92RblQuBbvmNBeFXqcCqHmKQBJ2gxMXym/DTZw2u0sA4cpTlKe8BGfmbYToM0HMJHFUbv7ADwcPKAKyIa6DlH7MCkeg9cu3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1V7cgQ0ZlJJZewJC/fZEaolzYKqQGTsKCFXRog8HCec=;
 b=sMMaNMiwv81lvWmcnsxNoAhGsiZ1mGDTqCcBHK9l4gM447ybRT/c66EZiR6WlBY77Ey8Mm1ur9ATBdPS6MQtXqGkSHhyML8t2J3ZCN0PaFk65sPUOWGSKLn1wqcrkuYLCi9uokcZjhSwzQq0xNl3IS/UACKkT0WiUdKlSp9Fwu0=
Received: from CYZPR10CA0007.namprd10.prod.outlook.com (2603:10b6:930:8a::24)
 by CH2PR12MB4200.namprd12.prod.outlook.com (2603:10b6:610:ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Wed, 21 Jun
 2023 23:55:43 +0000
Received: from CY4PEPF0000E9CD.namprd03.prod.outlook.com
 (2603:10b6:930:8a:cafe::f0) by CYZPR10CA0007.outlook.office365.com
 (2603:10b6:930:8a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23 via Frontend
 Transport; Wed, 21 Jun 2023 23:55:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9CD.mail.protection.outlook.com (10.167.241.140) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.24 via Frontend Transport; Wed, 21 Jun 2023 23:55:42 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 21 Jun
 2023 18:55:41 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <iommu@lists.linux.dev>,
        <kvm@vger.kernel.org>
CC:     <joro@8bytes.org>, <robin.murphy@arm.com>, <yi.l.liu@intel.com>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <nicolinc@nvidia.com>, <baolu.lu@linux.intel.com>,
        <eric.auger@redhat.com>, <pandoh@google.com>,
        <kumaranand@google.com>, <jon.grimm@amd.com>,
        <santosh.shukla@amd.com>, <vasant.hegde@amd.com>,
        <jay.chen@amd.com>, <joseph.chung@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 00/21] iommu/amd: Introduce support for HW accelerated vIOMMU w/ nested page table
Date:   Wed, 21 Jun 2023 18:54:47 -0500
Message-ID: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CD:EE_|CH2PR12MB4200:EE_
X-MS-Office365-Filtering-Correlation-Id: b2b22664-799b-40c1-cdea-08db72b3061f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 81mj8TGZ0sXM13Ac98NNyRFxXC7khBJBbwfWPANucpIxeSd05ui+Cy86W+0Xa1OyYa4owUu5iConmXeBJYx0SYUAetgOtt/j7OeK457ly8PUE/JdE/P88NEa3B72rV11HSIZDU6em0wWyljMKOpnxXg9XZoXrYRqcSafkSOkt4nySp75cPJmWkzLJKWQQXw0loGkaKpCBuAHJzWUcfcKj2n0zk11kRBJE/0o6QRp20DQsPeIXEBoXuKEXbEHBdsvyd69LXacyCc0wFKjGNf0Y7WcKiHSBg4i9Ou88khFEQs0GeRs1L5mjqfbAm3V8L8ic6Y9StUdEd2bb5DWOR+T0fdrAMgkDCA7N9n3sNx/xyEAEKs2zkT9+OjLNyavlWxf/5SRsF39U4+b0Xl0caWCCDTxOFwN1vg2+jv9O63PAD0g3hTsnlBvBjtjdADFz3zdPx/Hq6uued61qVK2pgcvaF7cbEsegH6vrMWxIHJIHZMZFUiAjI2UsafolESAMY2SSRU5ycBX1gk4MjwRaIc3GPlcbrlVREeni05l7lCnPHLS6dt/zEgZRJ8R+b7u26OKqBWPvxESxrC0IN6q9YeQZodK8i+/SB2TuLG8Tg1uiNj1k0QeJgWFoI9tNyMBpizDUaFcv0TLPla1nUR+13PNwLFxKI6PBcgjAkNYFD+M/bOkPhR1Gb6osQ1b2cO/OZmM3daJK3BO5X1SZYxghy+EKHYQlxfqi2jwZ+xclz3gqzpk4+NMsTXXG2jQKHWrZ6ad9qPB5hTInM8+xxP6dTRtViPpyxSIwdi6Pz1/7RbAs8Y=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(82310400005)(336012)(426003)(83380400001)(16526019)(4326008)(41300700001)(8936002)(8676002)(5660300002)(7416002)(70206006)(70586007)(316002)(2616005)(40460700003)(36756003)(86362001)(26005)(186003)(1076003)(82740400003)(47076005)(36860700001)(478600001)(2906002)(7696005)(966005)(44832011)(81166007)(40480700001)(356005)(110136005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:55:42.9579
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b2b22664-799b-40c1-cdea-08db72b3061f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9CD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4200
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

OVERVIEW
--------
AMD IOMMU Hardware Accelerated Virtualized IOMMU (HW-vIOMMU) feature
provides partial hardware acceleration for implementing guest IOMMUs.
When the feature is  enabled, the following components are virtualized:
  * Guest Command Buffer
  * Guest Event Log (work-in-progress)
  * Guest PPR Log (work-in-progress))

In addition, this feature can be used in combination with nested IOMMU page
tables to accelerated address translation from GIOVA to GPA. In this case,
the host page table (a.k.a stage2 or v1) is managed by the hypervisor
(i.e. KVM/VFIO) and the guest page table (a.k.a stage1 or v2) is managed
by the guest IOMMU driver (e.g. when booting guest kernel with
amd_iommu=pgtable_v2 mode).

Since the IOMMU hardware virtualizes the guest command buffer, this allows
IOMMU operations to be accelerated such as invalidation of guest pages
(i.e. stage1) when the command is issued by the guest kernel without
intervention from the hypervisor.

This series is implemented on top of the IOMMUFD framework. It leverages
the exisiting APIs and ioctls for providing guest iommu information
(i.e. struct iommu_hw_info_amd), and allowing guest to provide guest page
table information (i.e. struct iommu_hwpt_amd_v2) for setting up user
domain.

Please see the [4],[5], and [6] for more detail on the AMD HW-vIOMMU.

NOTES
-----
This series is organized into two parts:
  * Part1: Preparing IOMMU driver for HW-vIOMMU support (Patch 1-8).

  * Part2: Introducing HW-vIOMMU support (Patch 9-21).

  * Patch 12 and 21 extends the existing IOMMUFD ioctls to support
    additional opterations, which can be categorized into:
    - Ioctls to init/destroy AMD HW-vIOMMU instance
    - Ioctls to attach/detach guest devices to the AMD HW-vIOMMU instance.
    - Ioctls to attach/detach guest domains to the AMD HW-vIOMMU instance.
    - Ioctls to trap certain AMD HW-vIOMMU MMIO register accesses.
    - Ioctls to trap AMD HW-vIOMMU command buffer initialization.
 
    Since these are specific to AMD HW-vIOMMU implementation but still
    want to leverage /dev/iommu, they are separated from existing VFIO-related
    ioctls.

  * Initial revision only supports 1 pasid in the guest (i.e. pasid 0).
    Multiple pasids support will be added in subsequent revision.

GITHUB
------
* Working Linux kernel prototype of this series [1] is based on [3].
* This sereis is tested with QEMU [2] (work-in-progress)

REFERENCES
----------
[1] Linux Github branch for this series
    https://github.com/AMDESE/linux/tree/wip/iommufd_nesting-06192023-yi_amd_viommu_20230621

[2] QEMU Github branch to be used for testing this series.
    https://github.com/AMDESE/qemu/tree/wip/iommufd_rfcv4.mig.reset.v4_var3%2Bnesting_amd_viommu_202300621

[3] Base Github branch from Yi Lui.
    https://github.com/yiliu1765/iommufd/tree/wip/iommufd_nesting-06192023-yi

[4] AMD IOMMU Specification
    https://www.amd.com/system/files/TechDocs/48882_3.07_PUB.pdf

[5] KVM Forum 2020 Presentation
    https://tinyurl.com/2p8b543c

[6] KVM Forum 2021 Presentation
    https://tinyurl.com/49sy42ry

Thank you,
Suravee Suthikulpanit

Suravee Suthikulpanit (21):
  iommu/amd: Declare helper functions as extern
  iommu/amd: Clean up spacing in amd_iommu_ops declaration
  iommu/amd: Update PASID, GATS, and GLX feature related macros
  iommu/amd: Modify domain_enable_v2() to add giov parameter
  iommu/amd: Refactor set_dte_entry() helper function
  iommu/amd: Modify set_dte_entry() to add gcr3 input parameter
  iommu/amd: Modify set_dte_entry() to add user domain input parameter
  iommu/amd: Allow nested IOMMU page tables
  iommu/amd: Add support for hw_info for iommu capability query
  iommu/amd: Introduce vIOMMU-specific events and event info
  iommu/amd: Introduce Reset vMMIO Command
  iommu/amd: Introduce AMD vIOMMU-specific UAPI
  iommu/amd: Introduce vIOMMU command-line option
  iommu/amd: Initialize vIOMMU private address space regions
  iommu/amd: Introduce vIOMMU vminit and vmdestroy ioctl
  iommu/amd: Introduce vIOMMU ioctl for updating device mapping table
  iommu/amd: Introduce vIOMMU ioctl for updating domain mapping
  iommu/amd: Introduce vIOMMU ioctl for handling guest MMIO accesses
  iommu/amd: Introduce vIOMMU ioctl for handling command buffer mapping
  iommu/amd: Introduce vIOMMU ioctl for setting up guest CR3
  iommufd: Introduce AMD HW-vIOMMU IOCTL

 drivers/iommu/amd/Makefile          |    2 +-
 drivers/iommu/amd/amd_iommu.h       |   40 +-
 drivers/iommu/amd/amd_iommu_types.h |   62 +-
 drivers/iommu/amd/amd_viommu.h      |   57 ++
 drivers/iommu/amd/init.c            |   29 +-
 drivers/iommu/amd/io_pgtable.c      |   18 +-
 drivers/iommu/amd/iommu.c           |  370 +++++++--
 drivers/iommu/amd/iommu_v2.c        |    2 +-
 drivers/iommu/amd/viommu.c          | 1110 +++++++++++++++++++++++++++
 drivers/iommu/iommufd/Makefile      |    3 +-
 drivers/iommu/iommufd/amd_viommu.c  |  158 ++++
 drivers/iommu/iommufd/main.c        |   17 +-
 include/linux/amd-viommu.h          |   26 +
 include/linux/iommu.h               |    1 +
 include/linux/iommufd.h             |    8 +
 include/uapi/linux/amd_viommu.h     |  145 ++++
 include/uapi/linux/iommufd.h        |   31 +
 17 files changed, 1964 insertions(+), 115 deletions(-)
 create mode 100644 drivers/iommu/amd/amd_viommu.h
 create mode 100644 drivers/iommu/amd/viommu.c
 create mode 100644 drivers/iommu/iommufd/amd_viommu.c
 create mode 100644 include/linux/amd-viommu.h
 create mode 100644 include/uapi/linux/amd_viommu.h

-- 
2.34.1

