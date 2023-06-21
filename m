Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D5B739353
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjFUX4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjFUXz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:55:59 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89A11BD3;
        Wed, 21 Jun 2023 16:55:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drvnfwpajwecAS44VNcbAkz6rFdmEShbMbEU0Xb85mO3+fhvfQY1YhUchGDOfjNdLcoUD7nyn6A9//tcC0xpKMnO+PS9JR5iD3QouahqS/pGfhkYEvp/AGGAtXfB94gnSoK+sonywnVBVe/fHeYKntQTHSd2P4g20po5FemIJoyW7B6BPC9QiEemkz4XIiNNbq8ULO4vXCoJSHYiW4LT77ziU8Z4E7xGCNK/fxlXKCP5pCpFP6+bmY/RDwT5JOI+G3fl6WXv6DQqDTEViy/f5oHs6vla1P6f/ZzgHeTmrw0MGw6LfBVyKrlmE65JqXl/fngaJjVm6hX+TBTFmOKbYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0uTs75xJ8qf6SN4WoGmm5L5a0Tzd0cCIt37Rg7Rj3zs=;
 b=UTNDYyrC4tfGqa9ScIqcmneJGdd2I9lXjBZY382/zPYEEjiXfhpnD+Bpbr4gZQkLz0DHWLFe4znC8WYoigQ2x+d6gJNuj8erQbSorVZ01AW5PAkIF0Rm2d/Kj6jBMUxxS8peEYpFj325DeUAUA2NYXo0bn8ixed5xeNTeb3KglPKw1puFzpGkGssr6bHBGHLuIeWWxUxTPV9cks2TRkrlmMJt9UcgiW37rPF0pkSa+71PFACcrV24dtblHFtUSwT/6ojLOxVnkM5YiFGfRsjtpX4jsnsh7NCYR24rJ8hO9OIKinO/80xxukkQ9RvaLBBvyDxQIIr3PsGCiu0PyIQCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uTs75xJ8qf6SN4WoGmm5L5a0Tzd0cCIt37Rg7Rj3zs=;
 b=UTdeTcZvGQHwibhr9GHsfXsXa0Kp/n4WLKZSLNk+jou/yFmtVlkgtjmFHvShR9BBm8XjNqNEE6X1ckIe6mImBaIPmdS4BKFevBS8Bxse+uXMIKBywoIaavHeHwEGo3fKDX3npRO2kNR2RZvLxH+JGrynGzH6k9GStT4xhXDNkzY=
Received: from CY5PR15CA0042.namprd15.prod.outlook.com (2603:10b6:930:1b::26)
 by SJ0PR12MB5485.namprd12.prod.outlook.com (2603:10b6:a03:305::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Wed, 21 Jun
 2023 23:55:55 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:930:1b:cafe::c8) by CY5PR15CA0042.outlook.office365.com
 (2603:10b6:930:1b::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21 via Frontend
 Transport; Wed, 21 Jun 2023 23:55:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.21 via Frontend Transport; Wed, 21 Jun 2023 23:55:55 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 21 Jun
 2023 18:55:52 -0500
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
Subject: [RFC PATCH 11/21] iommu/amd: Introduce Reset vMMIO Command
Date:   Wed, 21 Jun 2023 18:54:58 -0500
Message-ID: <20230621235508.113949-12-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
References: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|SJ0PR12MB5485:EE_
X-MS-Office365-Filtering-Correlation-Id: 9087e2a9-a382-4fbe-7ff5-08db72b30d77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YQtQyBvuxD49C4F+5hqCn4CWDuqFS6AnbNSPrSiqboIWpw8tjxTqpoOO1Vy8Rot+p6blqnaUQrTYMobO6Z0DR7UeQPCAdCNP9jmhoSxBWZ9ElSqamYGTym/6Xrw8coeULIqTyNMYzlxelxcWfwaejiHn1bbwNWVgBhn3qVRIW1Jgl0HInzDADGs3jPdSvb9FhF5nUb85GdbWF8WM27StfgjbCloe3drgpk9CyZYypE4B1D+/yP4xHnE49ONDqwH5P+SKZQUyaIauS7WDY2OAn7cEapfqJ8tpBmBYfGE6xbmEO2ZptQdGiX3Mo4ydjxpcr3pDkrii8U9gmsTtAbrM0QesWY33Zl3E+gKGe6ibc+PVJbYY3sieViVkpSyg+jvJc2T/YgIxB9y31TxATq3udvjhysCN+5KUFFVF4o2x3yDlRmeyTzgum3eFrW9q/Ymvn5Fjr09g26xDtU9vWf3GH4bvtH3VPs7UxoqYKaCfn+N3xgOHeZLEGrxxW7hlk/EheGJf2y5wCjjfye22dLMVkfbk2qZodQ6HurXNoQbOgFWyTYkt7BK8zD8tNjPvPoyzN3zxSIhWzqKa0C2tbQzazJK7JQs4/QhmwlmvuAuv0wqvP1EKZcLA+D9OuEHmhPOq4rY3tUA4V6Gy7FGXVxX3YccLgU7U35IfEGLoibYbsopCEZPEVjvjb5jGq+h4W0I8sbxxRCSOqPKejcFZxQvtw6z9ScoQzy6z+v5SeBTGbI0fkZFxzGl72Xa2c0yBHHYk7KRTVM4sLoDRXVAykojTJg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199021)(46966006)(36840700001)(40470700004)(40480700001)(7696005)(110136005)(478600001)(26005)(54906003)(4326008)(36860700001)(186003)(1076003)(16526019)(82310400005)(70586007)(70206006)(41300700001)(356005)(5660300002)(7416002)(8936002)(8676002)(44832011)(82740400003)(81166007)(316002)(40460700003)(86362001)(47076005)(426003)(336012)(2616005)(36756003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:55:55.2611
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9087e2a9-a382-4fbe-7ff5-08db72b30d77
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5485
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

Introduce new IOMMU commands for vIOMMU for resetting
virtualized MMIO registers of a particular guest.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/amd_iommu_types.h |  1 +
 drivers/iommu/amd/iommu.c           | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index d832e0c36a21..aa16a7079b5c 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -200,6 +200,7 @@
 #define CMD_INV_IRT		0x05
 #define CMD_COMPLETE_PPR	0x07
 #define CMD_INV_ALL		0x08
+#define CMD_RESET_VMMIO		0x0A
 
 #define CMD_COMPL_WAIT_STORE_MASK	0x01
 #define CMD_COMPL_WAIT_INT_MASK		0x02
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index efced59ba8a5..b5c62bc8249c 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1133,6 +1133,18 @@ static void build_inv_irt(struct iommu_cmd *cmd, u16 devid)
 	CMD_SET_TYPE(cmd, CMD_INV_IRT);
 }
 
+static void build_reset_vmmio(struct iommu_cmd *cmd, u16 guestId,
+			      bool vcmd, bool all)
+{
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->data[0] = guestId;
+	if (all)
+		cmd->data[0] |= (1 << 28);
+	if (vcmd)
+		cmd->data[0] |= (1 << 31);
+	CMD_SET_TYPE(cmd, CMD_RESET_VMMIO);
+}
+
 /*
  * Writes the command to the IOMMUs command buffer and informs the
  * hardware about the new command.
@@ -1315,6 +1327,16 @@ void iommu_flush_all_caches(struct amd_iommu *iommu)
 	}
 }
 
+void iommu_reset_vmmio(struct amd_iommu *iommu, u16 guestId)
+{
+	struct iommu_cmd cmd;
+
+	build_reset_vmmio(&cmd, guestId, 1, 1);
+
+	iommu_queue_command(iommu, &cmd);
+	iommu_completion_wait(iommu);
+}
+
 /*
  * Command send function for flushing on-device TLB
  */
-- 
2.34.1

