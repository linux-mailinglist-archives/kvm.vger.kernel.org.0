Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF7E73936A
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjFUXz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjFUXzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:55:49 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087EB171C;
        Wed, 21 Jun 2023 16:55:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqPwWXvFEoacReYba+StPmkAalbnnlCdEKoZQtO9JJFNUFBpHjEbhAwc2k/yg9qNCFdBOX2sl7YlB7/wAA5ERQpvaIt6E+ZR0Jlmrs2j9pk3SHV36kW+ObnRXWXyyvWyBVeg32iqcWvoSYqAvPr7lFKtbFzfAp7rwmklsJm1sZJ1pluMyRIeeEyoXPaEAGiDC9u+GcsA8n29FxNLVKKXlC/v3ItsS9bNph9Q/7jnh4LeioEFrU5y7AAZmJnnEjsK11uT8H/zSIBT9QdXaSS+l0Gxu/wPxB3fuL5YUjCJruU8U35cKwZ96w+Tip+MXKBrUl9/Mp2zJgKiGRBTAVITCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PX0vXUy9BWz7OvCUIJQvG9oLwuPAcVLSVxcDFjuzNdQ=;
 b=kAniJeCNoNORf6ahbxYasWpCESWw9scuLPDEr5q4SG9knrtHh2CXCkBlpeOOrdOeSYKmPns9UhD7FGikM+u65FiC2/fEjTFXFpu7ABK8y19fmyaotE24Y9SJ2KgA10ZZbuXHyVduC+hQ8+SBMtx+difMLiocX5EXid8+ldeEUaN9Yo6gaOxqQFio46sP34ocqHM8zJ2xuzG64Jb9XJtQD0y6YSTds7hGL2HeHmJSxchvE8KOeshS0qbLD2LhJcAKO2SBBuZQgiiaHuCvlgZDlD5CSzDmX89YBrk5IKnVspf3RufZaYMQyPQyI6jUZxHpZn06ELQjn2KuA/tbXfEZRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PX0vXUy9BWz7OvCUIJQvG9oLwuPAcVLSVxcDFjuzNdQ=;
 b=Nm2TFKN3nWjVKrK0XP+rsa/+mHpgfW9W82nqa01tGyBCgrzZV6lBkIDCOMz45QdqXM8M88WtYDo9aR+OyoSKZEI1gH6dQ8hFIxY5Q6Hro5LhVdfrf6YaBF7ORS79Zo2XyKAohjXag/C6rXxnL5nZ+HUaQeHkFH2r9kDnzYbDjj0=
Received: from CYZPR10CA0001.namprd10.prod.outlook.com (2603:10b6:930:8a::25)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Wed, 21 Jun
 2023 23:55:45 +0000
Received: from CY4PEPF0000E9CD.namprd03.prod.outlook.com
 (2603:10b6:930:8a:cafe::b9) by CYZPR10CA0001.outlook.office365.com
 (2603:10b6:930:8a::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23 via Frontend
 Transport; Wed, 21 Jun 2023 23:55:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9CD.mail.protection.outlook.com (10.167.241.140) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.24 via Frontend Transport; Wed, 21 Jun 2023 23:55:45 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 21 Jun
 2023 18:55:43 -0500
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
Subject: [RFC PATCH 02/21] iommu/amd: Clean up spacing in amd_iommu_ops declaration
Date:   Wed, 21 Jun 2023 18:54:49 -0500
Message-ID: <20230621235508.113949-3-suravee.suthikulpanit@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CD:EE_|MN2PR12MB4270:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d6000db-7afa-41b2-4769-08db72b3077e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jNQ/zNRGdn+PoZimByTW/JtGKo91VAuSTeJIT6kwrPNDsSmaFOe7eZvtgyDrebw+7B+t1LWYR8MtaPwKbIbm54ktwbxb9DyAHSQl1Y38IAcUJdPi4ugMHztEYjM6cUYJOR/PKolWz3GdSsyE+vELGZeSzXuK6pKOQJrOJPTanR1RGdzJqebE9zpzX13N5AGvT2ZAScIuiECqy/n8ERobG/gtZ/rFs/hWYIfSZ0xSN4vXBT0URbxEFKcxD0HFSrfsDFyuI9VUEMSdJ59er5pTLs24FhMw7rfTmU9Sl8fVZy3uroMh0Cv/NdChwnown1o/SvCLn9tCwKSbwxy3UOdcadIkLvyTZxmMZBWQq9fDeGeZqYL6+Bz+vjSYJL3ighISLvxKR8CCslXdB3Lm/IUO8LoHfXHVcr57uNsfBeGM7Cba3w7lydYLbJ8yUldGSKVl/Ot3frMch8ab6xDs/Cu5YdAGeUAMj4XN0qkpvF0A+FQgZB+HZIhxBq7Jr6ewNCx2yJn+G1ubLr6p8UnH8Vdszzr1Q0JiyXDrHkBdCCjEcTMfmW4z0fp4nyRpJI0b2EVWfL+yoh60Iq4vFt3aAkb8XNwstkKV2V69izTKOKBPup1tNJQFjNNXl49b/TjPH+u9vHCQiBPW5RmuKs0X8BYuVMAY+Bc3jgaq2f6CAF69zTqw8PzQUj7XP20rvHv1AnT9p3qdcVyvNCov+z1Fkl9qSeZW4VbHYyNw5L1zmnm2UqQwfqG5xhUFoHSvU/m42Z8/x/DXM7BAEnUfTa0kqhiwCg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199021)(40470700004)(36840700001)(46966006)(478600001)(54906003)(110136005)(4326008)(47076005)(40480700001)(336012)(426003)(83380400001)(2616005)(86362001)(36756003)(36860700001)(40460700003)(2906002)(70586007)(82310400005)(16526019)(186003)(7696005)(1076003)(26005)(356005)(82740400003)(81166007)(70206006)(41300700001)(8936002)(8676002)(316002)(5660300002)(7416002)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:55:45.2392
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d6000db-7afa-41b2-4769-08db72b3077e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9CD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270
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

Preparing for additional iommu_ops. There is no functional change.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/iommu.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index bbd10698851f..356e52f478f1 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2423,17 +2423,17 @@ static bool amd_iommu_enforce_cache_coherency(struct iommu_domain *domain)
 }
 
 const struct iommu_ops amd_iommu_ops = {
-	.capable = amd_iommu_capable,
-	.domain_alloc = amd_iommu_domain_alloc,
-	.probe_device = amd_iommu_probe_device,
-	.release_device = amd_iommu_release_device,
-	.probe_finalize = amd_iommu_probe_finalize,
-	.device_group = amd_iommu_device_group,
-	.get_resv_regions = amd_iommu_get_resv_regions,
-	.is_attach_deferred = amd_iommu_is_attach_deferred,
-	.pgsize_bitmap	= AMD_IOMMU_PGSIZES,
-	.def_domain_type = amd_iommu_def_domain_type,
-	.default_domain_ops = &(const struct iommu_domain_ops) {
+	.capable		= amd_iommu_capable,
+	.domain_alloc		= amd_iommu_domain_alloc,
+	.probe_device		= amd_iommu_probe_device,
+	.release_device		= amd_iommu_release_device,
+	.probe_finalize		= amd_iommu_probe_finalize,
+	.device_group		= amd_iommu_device_group,
+	.get_resv_regions	= amd_iommu_get_resv_regions,
+	.is_attach_deferred	= amd_iommu_is_attach_deferred,
+	.pgsize_bitmap		= AMD_IOMMU_PGSIZES,
+	.def_domain_type	= amd_iommu_def_domain_type,
+	.default_domain_ops	= &(const struct iommu_domain_ops) {
 		.attach_dev	= amd_iommu_attach_device,
 		.map_pages	= amd_iommu_map_pages,
 		.unmap_pages	= amd_iommu_unmap_pages,
-- 
2.34.1

