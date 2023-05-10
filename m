Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721F56FD46C
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 05:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235698AbjEJDgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 23:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235770AbjEJDfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 23:35:01 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2080.outbound.protection.outlook.com [40.107.92.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9379E525A;
        Tue,  9 May 2023 20:34:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ViK41yWdiX+hoJT5RUNHY67SOgeQe+36wD5vWJpNSeUXS8GfK/gOtOLfWhAD1LTr/GxRhOAOwhMz0kySaE0bIfWtN6sr9Ek/0ZcZxoK6QW6rfMgYSbNhbjyyY+02Gsj6UXhYQWWokML+N/lD1yaysYl7JuW7tjfmpZWcyP2uHyJ1QCxvRjpULgVOV145CGOoMbfxeniaRGw/DKhr/uR/e1W5q6n8Ods9er8EsVrKfkbX7eMCjlAUd4HDYMSHhz5cVcODTT2JxgsQL4me2I81e2gUeKwUvNO3GOSVTbRtBazFr9st7xIbU7C15ZxyNIzSNcKC189qKfO6h2NhWBf/5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xk7hDUbKBv1jVjD+J1XEus0mhyRJ3/Bd28rc2bhE5ww=;
 b=GkC5CiyE1e4bqnDStRHqApMVSCbSyKl8IT+nKf+DmqXKbYEwuQHNOptFYzVG9PTdD2INrIMzJgwn4AGYKfRAtTwoVjXCiUZWHQze3uSw6dBwawaVSMK6tyEawbsQSQ7c/6oQYYz+BGftEDotT+RGUg2gjJzy6pvXwG0NNv2eUyVnaznXt2D/n9vWbAUZ/qNhiKevhjX3xxmPXZVAp3c+UYRI1Pqhlaj3PMlFnrK69t2OmedUej3+EfEhjNx0S5+bLCqNf1u1db50t5MCrcrRBV8WfuL+nR3WBMsAhNS1NeHxU2cKBrrCG32GYo16JxJ9DYwPAx8xFaRj4/M5o1iL6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xk7hDUbKBv1jVjD+J1XEus0mhyRJ3/Bd28rc2bhE5ww=;
 b=LTKqs4N04N/sicXTXibtE9kOdrHnDvbnZKlkZkYeP/1uuWGuADi695vuUM5zxICspBY2aGHQivRxa+JLoZBzgPR4wBNDpQaZ1aK5bagwVesH+G7N5hpY6u5eLlp92Lo043kBjnwdZJVKVEYGNxhrjszKPM2sqqUBfEpqgap2ZOT57ntAKs8VDVc2Y6lVK25l2sXG/bjmsuaRVvY4yvVtmNMIxiMBlU6rMeIp7DWJpynFPmGFd6aJJMkjzSnEj36KS5Zoa5trZLCMAhp963RDfJNP3BiAyfTmOsX4wdBxanNyxgsa4lGI39+itlaM/EgJ8zARRCO9R2zzmy5WB/0bIg==
Received: from BN9PR03CA0636.namprd03.prod.outlook.com (2603:10b6:408:13b::11)
 by DM4PR12MB5392.namprd12.prod.outlook.com (2603:10b6:5:39f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 03:34:39 +0000
Received: from BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::e6) by BN9PR03CA0636.outlook.office365.com
 (2603:10b6:408:13b::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19 via Frontend
 Transport; Wed, 10 May 2023 03:34:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT048.mail.protection.outlook.com (10.13.177.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.18 via Frontend Transport; Wed, 10 May 2023 03:34:38 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 20:34:26 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 9 May 2023
 20:34:26 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Tue, 9 May 2023 20:34:25 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>
CC:     <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: [PATCH v2 15/17] iommu/arm-smmu-v3: Implement arm_smmu_get_msi_mapping_domain
Date:   Tue, 9 May 2023 20:33:35 -0700
Message-ID: <4f67087fdb777c4b7822c8b95cec92161124301c.1683688960.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683688960.git.nicolinc@nvidia.com>
References: <cover.1683688960.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT048:EE_|DM4PR12MB5392:EE_
X-MS-Office365-Filtering-Correlation-Id: db0bfe14-3528-4779-e05a-08db51077c11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g72qJfFLMssQJm5dqYWTxze4hhF9XFBfu3TNDTy7O5c9eO/w+B+GXr66gzm7j127HxC6WGLVWXC8EOg3lAsxMj/Lgsxxvwsy6qInRRMXrZURhm/Mip0w1HlVHHCAjOIDEpBcgntZ+jMB2LcndGhIqFPKll+mQ8VPPT01RlWyDIQ50gOE/gmUyEagJ22SXLMr7WN/ENg6hh0ZPyAiCAvWiT1z8meYHchmgcuCAeMjd38RfcrpK5ZAQEB0sZjbQ5sAjlE48gmkN7k1Ak4UdL2HqAGe5QDsdcey1gsmdBRLwJWrNxxAGBWe4JzYquslrUsCziZwMhNJQduj+ktDN+I7RLxdR/y1jMFKPimx3SNnFC8HpuYnduxW0+XLP88jjCpmTrNnmsvComozFv+AblOZqKgVosGO+C+S5gmvva3ZVp1cwJ/abg+zcPAPkECHutQIoyzOXuUOn66jSVr8T+wENIhn/3+oUfS4DH07VP9uAbi24OjFGO7ho3Wm63KR7ZRrxc40MGP4fhc46fLRPP1OWJAYtoI1DeWhqKdP0bUMwiQ2cMkIk2waJMudPsluPoHhB70hEoor15HaWrkWykI8H/fTnH/Hq8RZNbBOnqJKF01cyVBV7bllrPL3mBn9CqGcKvgpFuoIjDFMTfxFms9ZsBCwQySg+D2DFKT6KRVoeZBA3HiF3B0anW0wa7IUPP5FpYbvXpIeUncXtYV15UaMSw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(136003)(396003)(451199021)(46966006)(40470700004)(36840700001)(86362001)(36756003)(6666004)(316002)(54906003)(70586007)(478600001)(4326008)(7696005)(70206006)(110136005)(40480700001)(82310400005)(5660300002)(8936002)(8676002)(47076005)(7416002)(356005)(41300700001)(2906002)(82740400003)(7636003)(186003)(36860700001)(26005)(336012)(426003)(2616005)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 03:34:38.9349
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db0bfe14-3528-4779-e05a-08db51077c11
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5392
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

In a 1-stage translation setup, a device is attached to an iommu_domain
(ARM_SMMU_DOMAIN_S1) that is a kernel-managed domain.

In a 2-stage translation setup, a device is attached to an iommu_domain
(ARM_SMMU_DOMAIN_S1) that is IOMMU_DOMAIN_NESTED type, which must have
a valid "s2" pointer for an iommu_domain (ARM_SMMU_DOMAIN_S2) that is
a kernel-managed domain.

The MSI mappings for dma-iommu core to use are located in a domain that
must be a kernel-managed one. Thus, add a function to return the correct
iommu_domain pointer accordingly.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3d150924581f..5fe7fed825d0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2095,6 +2095,17 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
 	kfree(smmu_domain);
 }
 
+static struct iommu_domain *
+arm_smmu_get_msi_mapping_domain(struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+
+	if (smmu_domain->s2)
+		return &smmu_domain->s2->domain;
+
+	return domain;
+}
+
 static int arm_smmu_domain_finalise_s1(struct arm_smmu_domain *smmu_domain,
 				       struct arm_smmu_master *master,
 				       struct io_pgtable_cfg *pgtbl_cfg)
@@ -2976,6 +2987,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 static const struct iommu_domain_ops arm_smmu_nested_domain_ops = {
 	.attach_dev		= arm_smmu_attach_dev,
 	.free			= arm_smmu_domain_free,
+	.get_msi_mapping_domain	= arm_smmu_get_msi_mapping_domain,
 };
 
 /**
-- 
2.40.1

