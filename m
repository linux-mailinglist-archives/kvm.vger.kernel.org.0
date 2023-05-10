Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96AA96FD471
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 05:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbjEJDgQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 23:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235869AbjEJDfb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 23:35:31 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E11F6A48;
        Tue,  9 May 2023 20:34:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FHcy1DKcWiFK3wPhMT/bgS3SMHXk/Z05VclWok39dYGMNvWSR4ZAwWtPpICGoGsvt1Otw0RgTdBhIWWBpYT80WvLVrLp61rYgm/5/BNmtvf5yK77UH/3g5Po6QK0pG6Tt5VEzl5Z2JonVDhmfoojkzu6IZMk3Lb4OVNpLG/C7JaHla7m0O05tyQzLQt7YCvvSsmvAUgigFGky93w5tmOM2qsDU0HsXCUiFYobNLlFgSDRTEOZr7Bs08yjbdHu/BKHHmzQkRRwxm73MHUJbSv/++Yf0B9CSIbq7Wq5moO0OZN0vWCniQH4iTd7kRylHsBpuTL5ADQDWfL0FNs9JjzDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H3rtvKMREw8MQARcTr6aa6xYz4uEqadpb+U5I9v5Lw8=;
 b=nUNmaUMRBhTnyQw2Yty9KYY55rApKALj7DVv5MtcHTfWjXhheCtywAD6J09jHn4NBQcWMb080ZJkjGRyRD+uDAZUvmarl62ff6xvl4JePluck7gmToam8Woe9IGYBkpR8LOVKCAZKmmBBN/6MVF+TM0Fh3/5D7/hwtwf3ELUjDyJrYIe6jUl6p8k7atahot0Oa9un+7PNQx6+aT86vyj9e0MoPFWk+TphrUqIMAMmjA+qexZtMcRrYrljPQXJ4ZmPiyICicohkZsYScf1VvIlU7UHrIBoByzuJCaREJsgJ8ARip8L56PSr7/ZWWm5TFSfDFQnZqVPnUt5buOw5c4gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3rtvKMREw8MQARcTr6aa6xYz4uEqadpb+U5I9v5Lw8=;
 b=I6Z9OCx73lj37dotzhUe1pp2kftQw7J4t/f5loaINsQp5kHmJb2VHyvyD2044o5nSfD58xT1zoLgyjnLCnKzBHUEzi6CH3nlgPkNDx4Y9j5iJkNK4qE3biF4WoHujjzwDF4nvi9XE0XHZafOzGYglwdO1fliqSSQYpUMHB602FZc+0IBJTb61J1B1rm16yWuKjbbyVlcP2AxIfnIqOazv9C+udtrMM9RLPmg13dM4gvs9EUi+4iPULsaXrRzorBI+T8iLe0ReNbob3aImT0QpLwfsnDy6D/7l09vok+68Yg2cPbmnPhAqnFwKJrAUPGJSbRMSw7JsrB/FLXdW0b8HA==
Received: from MN2PR11CA0002.namprd11.prod.outlook.com (2603:10b6:208:23b::7)
 by MN2PR12MB4208.namprd12.prod.outlook.com (2603:10b6:208:1d0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 03:34:40 +0000
Received: from BL02EPF000145BB.namprd05.prod.outlook.com
 (2603:10b6:208:23b:cafe::22) by MN2PR11CA0002.outlook.office365.com
 (2603:10b6:208:23b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33 via Frontend
 Transport; Wed, 10 May 2023 03:34:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000145BB.mail.protection.outlook.com (10.167.241.211) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.20 via Frontend Transport; Wed, 10 May 2023 03:34:40 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 20:34:28 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 9 May 2023
 20:34:27 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Tue, 9 May 2023 20:34:26 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>
CC:     <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: [PATCH v2 16/17] iommu/arm-smmu-v3: Add CMDQ_OP_TLBI_NH_VAA and CMDQ_OP_TLBI_NH_ALL
Date:   Tue, 9 May 2023 20:33:36 -0700
Message-ID: <b2d9dc7fb611c398a38f97843041673a44b784f3.1683688960.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683688960.git.nicolinc@nvidia.com>
References: <cover.1683688960.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000145BB:EE_|MN2PR12MB4208:EE_
X-MS-Office365-Filtering-Correlation-Id: e047e666-40a5-4cc6-bc79-08db51077d0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yAuFpRqIjpiYcq4zHXx1sy3HsXvM1WpFSdAe+nC9WX4zejjgmrUOja1ks2B3OaCTgc/TqHQPulOLvviNwOwWhiZ18TW10pw00isLGsx7n3FxjcymbpxPNjKCmvr2TnM2NmufGKLD6NIT/dyCG1DrgB8htqaLoba0sfDsHNxRKroAQLivhoeUSzGoxxJKBurbB8//psU4xHnOoko/6R/wb6OQajjjSi9dfLzPsTFavR63uG+YhauvId/3ZH5cytpEL3/iGbqjk5GBt3EWmvuj7zJunBrbduu45yb2LKEirzhCJ+x7ixT7nR3Juwfj2oase/3G1RC8x/uHsVqS+MWz4YQHPyx5lPVHkU9Av7yhd9U7tQ3H67pcVTkde96QvvpxKS9G6ty1pkzEjB+p64W1eJHpe6GgB+OAEYM08O1nzOyfSBV7FKUwXUJR+NOUqeyaFH+IkJ50R5SAgdkpP2rL10ZhmZ7a641aIvuy10azfNS+9r5OSTF3mqPgYqwYScKcyJewCmlseXa5ZSB7aWqajawrLbOaOwBrW7c3jB5+WimqejMylIC7loMRP46tBQQB/GVpfxoFRDsBWmcB91Lrf8fovGcT9XhnHVK3jsDdtjjxP+tVe//p0sy3HqSAOnfj8shlh9DUKuuGDRJUQUF3tNVAXTVM1e3DGUFEsP1xbFn9o/ikegByk+JbQUNPRKhH+yCoA/8xjldkIUgxT1gBfA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(136003)(396003)(451199021)(36840700001)(46966006)(40470700004)(40460700003)(2906002)(47076005)(36860700001)(426003)(7416002)(5660300002)(7636003)(356005)(82740400003)(82310400005)(36756003)(86362001)(40480700001)(54906003)(110136005)(186003)(26005)(478600001)(83380400001)(7696005)(6666004)(316002)(2616005)(8936002)(336012)(8676002)(41300700001)(70586007)(4326008)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 03:34:40.5724
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e047e666-40a5-4cc6-bc79-08db51077d0b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000145BB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4208
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

With a nested translation setup, a stage-1 Context Descriptor table can be
managed by a guest OS in the user space. So, the kernel driver should not
assume that the guest OS will use a user space device driver that doesn't
support TLBI_NH_VAA and TLBI_NH_ALL commands.

Add them in the arm_smmu_cmdq_build_cmd(), to prepare for support of these
two TLBI invalidation requests from the guest level.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 12 +++++++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 ++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5fe7fed825d0..3902dd8cfcfa 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -272,8 +272,17 @@ static int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
 		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
 		break;
 	case CMDQ_OP_TLBI_NH_VA:
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
 		fallthrough;
+	case CMDQ_OP_TLBI_NH_VAA:
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_NUM, ent->tlbi.num);
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_SCALE, ent->tlbi.scale);
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
+		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_LEAF, ent->tlbi.leaf);
+		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TTL, ent->tlbi.ttl);
+		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TG, ent->tlbi.tg);
+		cmd[1] |= ent->tlbi.addr & CMDQ_TLBI_1_VA_MASK;
+		break;
 	case CMDQ_OP_TLBI_EL2_VA:
 		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_NUM, ent->tlbi.num);
 		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_SCALE, ent->tlbi.scale);
@@ -295,6 +304,7 @@ static int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
 	case CMDQ_OP_TLBI_NH_ASID:
 		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
 		fallthrough;
+	case CMDQ_OP_TLBI_NH_ALL:
 	case CMDQ_OP_TLBI_S12_VMALL:
 		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
 		break;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 9540926b4598..43c971af663c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -455,8 +455,10 @@ struct arm_smmu_cmdq_ent {
 			};
 		} cfgi;
 
+		#define CMDQ_OP_TLBI_NH_ALL	0x10
 		#define CMDQ_OP_TLBI_NH_ASID	0x11
 		#define CMDQ_OP_TLBI_NH_VA	0x12
+		#define CMDQ_OP_TLBI_NH_VAA	0x13
 		#define CMDQ_OP_TLBI_EL2_ALL	0x20
 		#define CMDQ_OP_TLBI_EL2_ASID	0x21
 		#define CMDQ_OP_TLBI_EL2_VA	0x22
-- 
2.40.1

