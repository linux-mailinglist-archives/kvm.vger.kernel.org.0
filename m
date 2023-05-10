Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C929D6FD462
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 05:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbjEJDfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 23:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235606AbjEJDe4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 23:34:56 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AA93C20;
        Tue,  9 May 2023 20:34:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZD2VOOB4lindLKsi8miTB8FAbzBp3InDVpPKPEKASQwbDfTZxHBeNFYD5xs2gop8YU+Wca+NrfMcbfBHjzZGOhLWkut/F4waoTUmaMkwvqTkJZqbOk6mE0F3aeb0AniSW3OqWD6CXyt4ZvcD74awSKoPCMFSmrhAJu/QJDbg3lTcH/769L5aWpDynAWJbI/S4pXTvgqerg7lsXt7SIUExKyOZREknnErl30CyFRmjEjgR7Lqvxc9XLWCfrTXhfW5oMBky9rRRrLllQeJBhv7qEYYhP873HMt4WE3Gt2lSSjyRbDTRi3imQ94aNV+rDZxcbn+MCMI/4mE2ASiqQBlvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cwcuyL0Wenf+rIDKm3eUfiEWymz6Zi4dcQXl/CBlqGQ=;
 b=BXy1UZUYJYKruJxErlhnru9x4l96rNYFoPjGBDpg8qxIpNsIgZQOZ9xqKk3wY6N2HiBy05ndt37lR61VlwfqB41eA1NvWbWHMz6A9w3VkXHu+3M93PbHjPecfm3/pP5Ms5eeF6iG1iBx1mogJO3cbka9CwwL/JkOyeoFjVsf9sAbHmMy09H4TabvN6u0DP2JPnudQi19KtT3XRCcWfmzG4cPbLGmdWtNzqVjmRNvkN5oWYuNHexLcg4FXGtuKXpSzfj6diK8EdKFMrbat04+SoL4pUVYmlbSG7qwSTY24YWRSPx6gyXvMquMrIJUa6BfpNIxjJKcIE+VzmXSH7btjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cwcuyL0Wenf+rIDKm3eUfiEWymz6Zi4dcQXl/CBlqGQ=;
 b=Qn/PVT3D3BLnTT7+iTsxVwWwwW1IUOvOKrxLv9UJUXKFl90sXqFQoT0dl7J6gWsgRDiCg/biRrtjuckjR/PndcprtYRyB2FHr+j+RgYCejE52r/Doe/37E+uxWLgNTaz3az1pjkGRI6m+ZBp1k3EDIvNLeQwsg+gs6eyiwaUXGUmpO55rqyA1VCQRlhYyvROEjXXeLki3pAnEfNRV5Mwy7vvwGYM2xOj3hMph8JF2v6qxZ4F9636uhw1PB+WbxPy6SR+lpthhU+zQ33JsdtYh9b7J8bRotr5Xh9wRD1utxLZ7UrtNM8qj0ZQHrIHxI4aIQ7SANMZI635R9F3Y9hqGQ==
Received: from BN9PR03CA0430.namprd03.prod.outlook.com (2603:10b6:408:113::15)
 by CH2PR12MB4971.namprd12.prod.outlook.com (2603:10b6:610:6b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 03:34:31 +0000
Received: from BN8NAM11FT083.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113::4) by BN9PR03CA0430.outlook.office365.com
 (2603:10b6:408:113::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18 via Frontend
 Transport; Wed, 10 May 2023 03:34:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT083.mail.protection.outlook.com (10.13.177.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.34 via Frontend Transport; Wed, 10 May 2023 03:34:31 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 20:34:20 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 9 May 2023
 20:34:20 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Tue, 9 May 2023 20:34:19 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>
CC:     <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: [PATCH v2 09/17] iommu/arm-smmu-v3: Add STRTAB_STE_0_CFG_NESTED for 2-stage translation
Date:   Tue, 9 May 2023 20:33:29 -0700
Message-ID: <dbce4003f08e57271703e69bc08c01f52eef0fe1.1683688960.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683688960.git.nicolinc@nvidia.com>
References: <cover.1683688960.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT083:EE_|CH2PR12MB4971:EE_
X-MS-Office365-Filtering-Correlation-Id: 92eeeef8-77e5-4e2f-bc0b-08db5107776a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xw/ZN1qedewAPXDf+YsoFom6RUxb9FT5dEDJAVB3kCz8vO48QiiYaUMO4O8qf4HiudHWozqj9ha6pSDPQ9ilyfTDHhf4hAkfabw4wqVV7s/ez6yqqon5ZIWbKQjhE8El4yzm+MJd52QRxYDhB62jMsqUQI4n7a9YA0/vnqQoXr+DQuP5ExTyufDp9jHaZRtnaXzlaXWKO0ROS/0+xzSEC2fdsy44OQAdeFxUq5BtFH/Uy/+txie2Ug6/b6vu7e5QRvGDzG1zfjDwqolU5nWywdZVlxEOHmVHWfVL6tkVF0KpFEgGJE0dICY2+C173MyfcKEhiqZ/FQAaOU1JamowM/arG5VbN6P+ye94ybcDGFKSl2Zxh0DCtLeRhnrek7jfs6A644VoixxR7q7J3TGdoK6pjBHAFWgLWg6zINuuTixGJrboOXWW6cgjlqgtm4weYqCCkVJR0VncnzUQPdQa0A8PybShy7yefsPWuu9SzaEqNl3xyNkJIj7MS4aRy6/sGb3VS76jMvuekanydDn7WffVrfLoGeu7Mwhj9p9d+C8Nf6Cu1sjjetLuNGXnTc/c9CmvgCldyBLvVcY4Jx71mFPf/dYQ02TfhNAEx/8j/+PUSKO1dMGT6Jx4LxfbNJx25ro/r0DHBDfmrsH8kmmQ7uWRzOnIIPci/EK/+a3oLnw1Y3NeI22sa/4RvImUPgYdnZKL2EFJeclOhnKHUoVDPw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199021)(40470700004)(36840700001)(46966006)(26005)(7696005)(40480700001)(336012)(426003)(36860700001)(2616005)(36756003)(86362001)(356005)(82310400005)(186003)(40460700003)(82740400003)(47076005)(110136005)(41300700001)(54906003)(4326008)(2906002)(7636003)(5660300002)(8676002)(478600001)(8936002)(316002)(7416002)(70586007)(70206006)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 03:34:31.1286
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92eeeef8-77e5-4e2f-bc0b-08db5107776a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT083.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4971
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

From: Eric Auger <eric.auger@redhat.com>

The value of the STRTAB_STE_0_CFG field can be 0b111 as the configuration
for a 2-stage translation, meaning that both S1 and S2 are valid. Add it
and mark the ste_live accordingly.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 792e8a788e2e..74e38abf5f4c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1304,6 +1304,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 			break;
 		case STRTAB_STE_0_CFG_S1_TRANS:
 		case STRTAB_STE_0_CFG_S2_TRANS:
+		case STRTAB_STE_0_CFG_NESTED:
 			ste_live = true;
 			break;
 		case STRTAB_STE_0_CFG_ABORT:
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index e9e45ce7a899..e73707479119 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -208,6 +208,7 @@
 #define STRTAB_STE_0_CFG_BYPASS		4
 #define STRTAB_STE_0_CFG_S1_TRANS	5
 #define STRTAB_STE_0_CFG_S2_TRANS	6
+#define STRTAB_STE_0_CFG_NESTED		7
 
 #define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
 #define STRTAB_STE_0_S1FMT_LINEAR	0
-- 
2.40.1

