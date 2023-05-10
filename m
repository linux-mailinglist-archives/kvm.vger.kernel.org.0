Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9946FD467
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 05:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235685AbjEJDfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 23:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235656AbjEJDe5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 23:34:57 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC5249D4;
        Tue,  9 May 2023 20:34:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fhTOWTmpUARNxF6H5MRX3XHcutvGbiCks3JzpxwyYU43Utrweuf2DcfB+kd8LhjIcI0LToqnKyj8ycg4EJgyHFFTk+ITO1YRXDTPsefz3F822b+JgGhZSI0zSgeWESumPMicrFgTA8zdmZJy9K6jxMZuuvE2CG3fW9OHklv4YCUormBmwMtzUytEkNlKVaPdr0XC3r1f8RyO1NEPW6OkWKT2VI1ktE8/2T2aASOdHC2Gi5/hMHQ5BKJglLClVc953/8ZmsLN8HWxPo8YGBk3cq+zeaxlsLjSXkxl8NhzV6DoBt2GyVh5i21mE//J1wwqVCkgQjN/QxFK1tBmB7YiSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oArvuULAtrRr2QLD+BcfOd2SmPnve2z8ByIqyo8lKU0=;
 b=j9mE6cLyuksfHq9XiGPrvDZsw1oe/86/nve3t5qHrAQoWqjtIYESrM/70lkTE2jjqbvBw+9iwoxuPmavryKJ/mM9ruXFWdNbR4j8dCjGhcG4i1p2y6n9uf9SLdUONWstmsPdFDJMn3ojLLTZtyUZDvJpVrmpH38ZpcwsMOJkQIlJSzAUSNeKC50gS0RY7o6pOgYs2MqJ5nhRC+gPEbpkmHDUCg/EcDaZQL197ehB3wKGViH1AZgdv3C+VLAR1FD9VnflZe5CvkD7oNKmerLfk9nEJ83b7vE+xEN9d6wDLAVrwmT+et1ZuxkIhEVbow9OUfyiOvTYfpzmoesYUdMz9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oArvuULAtrRr2QLD+BcfOd2SmPnve2z8ByIqyo8lKU0=;
 b=fKwszb47YvoY3t5h8buzRvT8ww5zCzXr2oOZScfDRQ5h44U43GR59VrHV4OJsmRFLFsJA806cFLyrc8UNx0qHzZX0v9jiATPzEonAAIdim190ER4C7MZxAcTsUIRoU8s4W0oXK/4WAZNm7Moxhg6dnICU/khKAsIVGISLjGIZxxNcEeswzx6A46bJsUmgR10YjBrRnWUqJnGRU/S7kNLx48dIx/FPIpBRpQHc268DK3bZlRA62IbyktDYVOkf9ouGmHw8l0UbY216MMm7PHs+iYJwbnWUEZ+4QyK7enNK5XziNKS8nOPZQGqeze4A3BT/PdBIQnvorYUPMg4Aer0og==
Received: from MN2PR11CA0005.namprd11.prod.outlook.com (2603:10b6:208:23b::10)
 by DM6PR12MB4090.namprd12.prod.outlook.com (2603:10b6:5:217::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Wed, 10 May
 2023 03:34:35 +0000
Received: from BL02EPF000145BB.namprd05.prod.outlook.com
 (2603:10b6:208:23b:cafe::4b) by MN2PR11CA0005.outlook.office365.com
 (2603:10b6:208:23b::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19 via Frontend
 Transport; Wed, 10 May 2023 03:34:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000145BB.mail.protection.outlook.com (10.167.241.211) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.20 via Frontend Transport; Wed, 10 May 2023 03:34:35 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 20:34:22 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 9 May 2023
 20:34:22 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Tue, 9 May 2023 20:34:21 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>
CC:     <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: [PATCH v2 11/17] iommu/arm-smmu-v3: Add s1dss in struct arm_smmu_s1_cfg
Date:   Tue, 9 May 2023 20:33:31 -0700
Message-ID: <84f013e02f50f24f00eac77c2b5c416c18fc5a2c.1683688960.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683688960.git.nicolinc@nvidia.com>
References: <cover.1683688960.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000145BB:EE_|DM6PR12MB4090:EE_
X-MS-Office365-Filtering-Correlation-Id: fba4f925-a911-4312-cdcf-08db510779d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5MoqweVoKc4fZM1ZA4lzo5fIW+g20/orGvOm3Ktu7bWulUnoB/nAQCzl92H29fwGLsI5g2ukbogqQeDnmliGN7beMEVIyJj9l1EkvwQrCt7aIU8m+nJ5WbC4P2DxSiN1zMReHvIdvGOVILyQ+TETXib9ps6zXAIBqlaVGmOgKA0vCCOV8a4GiqES/thZJR/SyvDw/kHNWUUbbuyVZRMQLajxuKvAJwIUvlLKamKGWIhtyYbc4lP4A3OVvcQw9DjjnDxT7OqjO/axFcZRzzVnjvckdeKQxTYW1Ozm7kjLRwddLD/Lctw8GpBg+7KZL42xCYQMjo5ls2P6wbKOz+mh6/i69B3UX5l9DrD2qAg2p7gtWCJGUUXN2kUA10FCU/LVXB2p7N3UcgHDPyVHVDxi4lNTj1WB+kecYtBPw+6ebEutoj2qYcSx27zUYzx1lLY/6R+W4Ue6E3YwwKceHAWSoNLYuUXuCwNRFMSosYqntJabkHcIDkhwoxMEm9KFUSEQpUUQSJKoJfWKCo9zvcH5E0rdQMRxa/MTCrewuJF9Xt04R0f8v1UvadhfwGP3FBOLhbeNCGlYxPklMjPchVu53SSIHhAwXOp4sTmwVmVNyvXDIYkv36i3G08kqu8LX7/bU8aU3DoZA4/Sg5Z1zHRMFgGj3QfoAmuTUyburYp9doPt2Qkhh7S3QAv9R7BqVP7dChZTZtjG3HSzKZuawLEyotGgbU+Z3emBrSj+XZykoA5g6ZiN5kZfJhEZ3GzFdg95FJh+5A3KgLrDsB5oRZ6JGOMApBy6ZCpNNHbNDLc1k0TLOF3OjBrpp6SVEf3XNHL1
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(376002)(136003)(39860400002)(451199021)(36840700001)(40470700004)(46966006)(6666004)(7696005)(83380400001)(5660300002)(36756003)(47076005)(82740400003)(2616005)(336012)(426003)(2906002)(41300700001)(36860700001)(8676002)(8936002)(7416002)(86362001)(26005)(186003)(40480700001)(4326008)(316002)(7636003)(478600001)(356005)(110136005)(40460700003)(70206006)(70586007)(82310400005)(54906003)(32563001)(473944003)(414714003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 03:34:35.1661
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fba4f925-a911-4312-cdcf-08db510779d2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000145BB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4090
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

The s1dss has been so far hardcoded with a value STRTAB_STE_1_S1DSS_SSID0
in the STE setup routine. Yet, with a nested STE support, it should setup
the value coming from the guest OS.

Add s1dss in struct arm_smmu_s1_cfg, and set to STRTAB_STE_1_S1DSS_SSID0
in arm_smmu_domain_finalise_s1(). It will be setup with the value from a
guest OS in a separate pathway for a nested use case.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 3 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index fd3ac4802907..8b827247f4b9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1346,7 +1346,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 
 		BUG_ON(ste_live);
 		dst[1] = cpu_to_le64(
-			 FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
+			 FIELD_PREP(STRTAB_STE_1_S1DSS, s1_cfg->s1dss) |
 			 FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
 			 FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
 			 FIELD_PREP(STRTAB_STE_1_S1CSH, ARM_SMMU_SH_ISH) |
@@ -2144,6 +2144,7 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_domain *smmu_domain,
 		goto out_unlock;
 
 	cfg->s1cdmax = master->ssid_bits;
+	cfg->s1dss = STRTAB_STE_1_S1DSS_SSID0;
 
 	smmu_domain->stall_enabled = master->stall_enabled;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 232a2dda5d24..6ed86883d52e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -598,6 +598,7 @@ struct arm_smmu_s1_cfg {
 	struct arm_smmu_ctx_desc_cfg	cdcfg;
 	struct arm_smmu_ctx_desc	cd;
 	u8				s1fmt;
+	u8				s1dss;
 	u8				s1cdmax;
 };
 
-- 
2.40.1

