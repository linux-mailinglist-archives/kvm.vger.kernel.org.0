Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDBAC6FD460
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 05:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbjEJDfR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 23:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235407AbjEJDez (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 23:34:55 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2060.outbound.protection.outlook.com [40.107.212.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836285BBD;
        Tue,  9 May 2023 20:34:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJRV3P3EMIRvoc+8qlfAUKe6nstqP9EScJZdJuhs0gaZzAb48/oVgicqjgBO9QPrQwodfOkbbt35QiWtqqb0COeLPTVuQzYiVdDhxx38/oQE1WsIdbstOIaPQs+HBkBfVjSKomOYefPLMJlbWYef/ywoaQidcDsriBXyzuOC7CzfepTZj7Yp4HTMCpQjmq5erzP4OhdtWovBWdiL0R9w2N6wtVqvxrfskK3mOLUZJOnSU+oSShorHK0DCYSfM0YItH48/Z3mPiLCNNpkJgwTFiL6J7xeIZFJwjdKgufOTMhWx67t5tIleQt4LtCsJLGAu5SbS1S+8/KCrvMJviGEng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UZ8gL1brtpEsAHRv15orVOC1CnEqZShd4tHOccLP/Rw=;
 b=KmH0rTX2TKxo68kFy/iW98ccgwdCyr6/VSQLswy0dqCqc33Bu33MbuxIpLG0rx5vSPLWWTfAkd84oXMOU3gfyP24U7wwd/xJgLg5nYOoPoTIK+aKKGKiW3NAu4riS/vEVBITWFUXX1BtVawt4EYknrWJRmBZ4QUJhW4G6/urppE01p8sySCCFYeQvb6CIEOhfpy/FVLJ6QdKYvdC4HPZshrEdLwK9s/G+IRjMqgl2EhUOLw8mJnX2Zl6c/DT0w44OeXkuZAEXcyCryHkDVh0vY8gManNtjdGHPlvY0cWKVUrqva0hJ2/rygOcLj7/AjX97fRazOStdWYb26lREW/vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZ8gL1brtpEsAHRv15orVOC1CnEqZShd4tHOccLP/Rw=;
 b=M+iVomSpVB4a1EP4vGjkz+fzH5piY41aThT5dTCLvLYXHRSJGAjzNSutvN/IeI8s6JuZqMxnlf83E08P+MMcHZCDEaJ7rqRYfFSvi0h8KUFaP4L5KxcGQEEiSYf7RFtpnKq4l4vLovVE3Uz0hMJHYVhbNO5F+LlwlvIv8uO6QAArNIzPLuXeJ6+Qei8ySUw1VrbgdXNG+h8GjnAiWrn0ujbcralqIArgrmMtVzqqxfv1oXdz8sGmd3XyxcbYW8AydHK3qErPKGZX100OVDznzPITre+GcOii96jaza6ykvmNdamWqLI8oSNMLP6BMRta71pZ2UG9kfs5Vxyl+odq8g==
Received: from BN9PR03CA0193.namprd03.prod.outlook.com (2603:10b6:408:f9::18)
 by MW4PR12MB7191.namprd12.prod.outlook.com (2603:10b6:303:22d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 03:34:33 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::fa) by BN9PR03CA0193.outlook.office365.com
 (2603:10b6:408:f9::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18 via Frontend
 Transport; Wed, 10 May 2023 03:34:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.19 via Frontend Transport; Wed, 10 May 2023 03:34:32 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 20:34:21 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 9 May 2023
 20:34:21 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Tue, 9 May 2023 20:34:20 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>
CC:     <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: [PATCH v2 10/17] iommu/arm-smmu-v3: Allow ARM_SMMU_DOMAIN_S1 stage to access s2_cfg
Date:   Tue, 9 May 2023 20:33:30 -0700
Message-ID: <8e0b5fbdea1817485c86a442a072b032c9fe0ca1.1683688960.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683688960.git.nicolinc@nvidia.com>
References: <cover.1683688960.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT009:EE_|MW4PR12MB7191:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d5aff3d-0983-4822-14a9-08db51077866
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: drEI47y5AvKWXNUgUkLJd5KbGi/zEe4uG85MhpMkc/T/0oxXSF88ygac6jQzsgWXPaC3sqpqD+XYBhg4mS7GFEjLRzJAq6rVjYau7olpI4XEjWvJ+oLWMvQagqMP+p8f94swlo/El2xAopsB2ffzpl3KmJ6U5B3UIFR4y0n1iEm/1cfhQIXpjKnMP6wU7GTcVIMgR2zDPbnVgPNiIOIN2NxQMysdBP4yQWOU9/q42oGX/DCaQ+Q57IwtZrRnVevwieT1PJ9yEBh0UNXoGC40m+NdG/APkgP/VSYFIb6c/lDIlAb4MyRbKfAh3pQJ6a4NbQrA1iCzPFJvB12d5mCwJCYglEG49l86svJgCY5YlordvM/zXTXf0Y8rWQzbSles3aE2UacBck/H39XMNfaZ0Wkg3BTOJnFUzujcMThw+BrKjNukDK2WYsLDTdUq5WYYkkAnl4s8Zak+Qp9uaAjqiQF8T4xFhaOVo27nbJRCPwDR4Z9MzdjJMTQeaO7UFleJYyLgmQ5sDHIgqWu3c0JAvq8bBuvFKfByJAiU0b0YvhzPpHFiOs/MkP/byiWqNme+9ZSUHFJvA1grJS9eFkS10QzcQ39rv2TN7CVbJwgVO3rE/a+eX1GVv9kk5LI47Ma8VPBOADVWYPuDWNEymz7RBFQB57kkUnhJbEXL7o+KRGJv3ZkOmkVSlwjjwIhJ/TAwkX9XVdmYcB57MUTI+jitCQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(346002)(136003)(376002)(451199021)(46966006)(40470700004)(36840700001)(36860700001)(47076005)(82740400003)(40460700003)(86362001)(40480700001)(36756003)(7636003)(356005)(6666004)(7696005)(478600001)(2906002)(110136005)(7416002)(70206006)(70586007)(4326008)(54906003)(8936002)(5660300002)(8676002)(41300700001)(336012)(316002)(82310400005)(2616005)(426003)(186003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 03:34:32.7915
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d5aff3d-0983-4822-14a9-08db51077866
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7191
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

In a nested translation setup, the device is attached to a stage-1 domain
that represents the guest-level Context Descriptor table. A Stream Table
Entry for a 2-stage translation needs both the stage-1 Context Descriptor
table info and the stage-2 Translation table information, i.e. a pair of
s1_cfg and s2_cfg.

Add an "s2" pointer in struct arm_smmu_domain, so a nested stage-1 domain
can simply navigate its stage-2 domain for the s2_cfg pointer, upon the
availability of a domain->s2 pointer.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 2 ++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 74e38abf5f4c..fd3ac4802907 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1289,6 +1289,8 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 		switch (smmu_domain->stage) {
 		case ARM_SMMU_DOMAIN_S1:
 			s1_cfg = &smmu_domain->s1_cfg;
+			if (smmu_domain->s2)
+				s2_cfg = &smmu_domain->s2->s2_cfg;
 			break;
 		case ARM_SMMU_DOMAIN_S2:
 			s2_cfg = &smmu_domain->s2_cfg;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index e73707479119..232a2dda5d24 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -711,6 +711,7 @@ enum arm_smmu_domain_stage {
 };
 
 struct arm_smmu_domain {
+	struct arm_smmu_domain		*s2;
 	struct arm_smmu_device		*smmu;
 	struct mutex			init_mutex; /* Protects smmu pointer */
 
-- 
2.40.1

