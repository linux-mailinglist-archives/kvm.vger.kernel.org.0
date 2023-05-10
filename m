Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E95C6FD45A
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 05:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235177AbjEJDfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 23:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235195AbjEJDem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 23:34:42 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2056.outbound.protection.outlook.com [40.107.95.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B044EE7;
        Tue,  9 May 2023 20:34:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pi8rzNti27EHeztc8Twq+MvzCuFTbGaoWKI8lnaK4zB4M7eubC8CJZ4ELo65XIMNVMOcAHWqbyH+j1uZOx9HnMsHZBYhLbhbCdM4kGD6lj4ZPQGpDV1Us0SNElCmWkFAEL0JEd5ratmWZ9PFuARGnligldgPzlOROt3UPkxMALo8wYvajdZlPsAcDgUx7AFiF1MdMjBqgANB6KsWQ0alI1eF/fhNohYeG0+LZ18MIgFNrNiGUpxI5JgFtcUuaJ+xgXodg1OAaLbytiCAtar4KeNa8PkCtleaswe5BJLtQmJK7Qp0ALB6f4ViuLM4adDGyj2I52s5z+mt4BzuEWciow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WziNHnp2+kajlgqBbWkc4kOYY/UsxfTOTYH9hMvKzOU=;
 b=QmapikBhAJhbPcb5CHqw6tWAjpof5p4ETpgPI15YA3VRMpr6gNLE6c4+sbfkB3hsY+rfWCurbLIoUSWbYKw3R6aMegciWmv5fyvCh+xIoRGNld+Vofc+91PfT7IBkxBHYMIztONCdMbIMnhkONYJXL12FoFxacXX/pMTQKovFJYidyFttLr4lDSOCEI7iZ8UTmyusesYDjqXrU0lQy/oXv9/A3slo1e+qnHbGvdEZo4c2QaxlJpoTlNHWbIM4ia8y9RyyAN8yN1W09HC35mWdHbXFP0IcRJXQdVw+AoocHj5a3PKJ55dbv6KfGRtf4Ngh6z/tk4BiQYIphTcU4a20A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WziNHnp2+kajlgqBbWkc4kOYY/UsxfTOTYH9hMvKzOU=;
 b=POTGJowO+fSaAlAW50pvh02UbmA8UFuXuCUAPy1hHkKubs97hf9nYDtFz5fhFoDulkrFW2X4Afxevvnb82wNBut/MzO/L58y34iYKPVAAtZh/VgecTcdBbaq1seja/GnpHi5wlCXeE5ZiVqliS4y5ezGywwuxnOtqgIQHtVEg78xAH8EsdfWVy32/eeP6ykQyJwkv9BqUxupVSwmiZ3dDfmfkVN4qdkIhjUS2SivEDXw4qIlZ/F7E+D+6YTUUilhW3z4PgiJXyYZr9SW392QcXtbdBSh2EZmf8Ab5b9nZJNAJ5FF0ZrRIb3n+IRjn0iBjBDARWbNLR+8v/msDHkzQA==
Received: from BN9PR03CA0201.namprd03.prod.outlook.com (2603:10b6:408:f9::26)
 by SJ0PR12MB6830.namprd12.prod.outlook.com (2603:10b6:a03:47c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 03:34:29 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::2d) by BN9PR03CA0201.outlook.office365.com
 (2603:10b6:408:f9::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.34 via Frontend
 Transport; Wed, 10 May 2023 03:34:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.19 via Frontend Transport; Wed, 10 May 2023 03:34:29 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 20:34:19 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 9 May 2023
 20:34:18 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Tue, 9 May 2023 20:34:17 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>
CC:     <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: [PATCH v2 08/17] iommu/arm-smmu-v3: Unset corresponding STE fields when s2_cfg is NULL
Date:   Tue, 9 May 2023 20:33:28 -0700
Message-ID: <8f95a33f3f28d97750afda64536de312772ce60b.1683688960.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683688960.git.nicolinc@nvidia.com>
References: <cover.1683688960.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT009:EE_|SJ0PR12MB6830:EE_
X-MS-Office365-Filtering-Correlation-Id: 63f1edcf-e6da-479f-e847-08db51077667
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DZM2jghLOt1hcy+SmCGeW31I9OLqYUnYcb7j6RAH0Cf4yRUx0XdI/ZYL1eqFPxd8LiLRqYXUD3hy2+i8xfqRbuPNeQTolTUqPBXdDElYtD75IF+Pm+AJNqVcByzWoZvyp6U9veMswoZQS4iQ3hBDjBPSd0UfFK/A4IvMQQkOzm3TLCVZZb76JRoX68/BcU7WXolI0epqDc6tOs/DKhv0ZJ6XOU0b9C6E1usVo3GEei6PI5yhEk38JknhgWu5zOuuPPwDi0BByOPj+Sa6QEXYFBxSkJT+Ub4TBgfR1ZcrrFSxSp6+nNZA1jCMnNvxVspt+9Y45btNJNdTZDF+th8DTXGIXK8I1a6y3Neugw4WuoK7k/CarUyjby7cceQBc1nqkjsp0tj3o3W0w7JO8rgbIOmrF+HOJbssnjGq51krFds71flzGg4GVtug3W7DRT7F/NFvwdbgIjQBZGohT7rzblnBDFJZLrvcaUGy0GMRoFktMgK5wU+SJx8+w7lBV2EwWwn8dsYagpJWcNmpoe7vt/WcuxWBj2bmHXY8ARL91gyA8m7T8Pd72ZRqmS+yiLK4kkQDCyXproC+0mbB2iYt2OhtLmWXmrnzT2MErV6MruLoHZd28IFEwsH6oBaNrh4ccZi92+tOo14TxlMmSTiTaKd0vTHgYSnW8UxQhTIDGti8CbJh5yBdgE1fsvCr4XJWmz8MPohAtUlTvTpsbBo3k/0BA8003Cif1DyurEWw9S7qehMPs0PgHn9lHTkyizcv
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199021)(46966006)(36840700001)(40470700004)(40460700003)(966005)(4326008)(7696005)(70586007)(6666004)(70206006)(316002)(110136005)(54906003)(47076005)(36756003)(86362001)(478600001)(336012)(36860700001)(26005)(426003)(2616005)(41300700001)(7416002)(2906002)(8676002)(8936002)(82310400005)(40480700001)(5660300002)(356005)(7636003)(186003)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 03:34:29.4324
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63f1edcf-e6da-479f-e847-08db51077667
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6830
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

Despite the spec does not seem to mention this, on some implementations,
when the STE configuration switches from an S1+S2 cfg to an S1 only one,
a C_BAD_STE error would happen if dst[3] (S2TTB) is not reset.

Explicitly reset those two higher 64b fields, to prevent that.

Note that this is not a bug at this moment, since a 2-stage translation
setup is not yet enabled, until the following patches add its support.

Reported-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Link: https://patchwork.kernel.org/cover/11449895/#23244457
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index c57c70132c0b..792e8a788e2e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1373,6 +1373,17 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 		dst[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
 
 		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS);
+	}  else {
+		/*
+		 * Unset dst[2] and dst[3] to clear stage-2 configurations. This was observed
+		 * on a HiSilicon implementation where, if the SMMUv3 is configured with both
+		 * stage-1 and stage-2 mode once, it is not possible to configure it back for
+		 * stage-1 mode for the same device (stream id). The SMMUv3 implementation on
+		 * these boards expects to set the S2TTB field in STE to zero when using S1,
+		 * otherwise it reports C_BAD_STE error.
+		 */
+		dst[2] = 0;
+		dst[3] = 0;
 	}
 
 	if (master->ats_enabled)
-- 
2.40.1

