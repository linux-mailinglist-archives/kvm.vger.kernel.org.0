Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E696FD450
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 05:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjEJDea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 23:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjEJDeY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 23:34:24 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0302106;
        Tue,  9 May 2023 20:34:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdZwJpdqqtI4g7vhqGYeHhDHluBPi5Ay26IOAQFYo5pN0anXZdfJlkBTv7JiQ2bRU5o6F23k7UBqMmLDFsjCrgMppZDCA8B23QWRuMndycL9WmlPkWqtu7XcNwGprxov7HHaeXDuPVHp94Gxmboxuuap7qKFRlRTTDuslV5/A/X2busjG/zDg1we6X9xiH8F7WKfCD8homr0ffX8rTYcymgTHx4KVjgHXAIEm5gYgLtUt6Ms+mw8heshjuiwnid3ZUTzYbaGo4M+PcY+jM2CUtkCNK0zHUOJ8IrBb+TSZ6TCRUCFiSkBmImqhcCeBYbidxzg150YUFU8cZWx2q3/4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cvHjgyKrQ480jN7N7o/cm/ZBNxT5I7wslxk6qwbvXhY=;
 b=TO4fFBc+iGqGbrsBwUuqtvb68doroR06ThVLyJR5zroAOG83ayLXDxQeuScm+wQnH9m2hZi3cINB+NlI+Bl+DDnMXjoEBhmb5TCzKhGMa0b5HuxydNLyQDZLI7ZAuTqjk/m0xDF4rPbNNYMAehtFTrxlEw5fqMNjNA4enZ8jfnWm/X+sUOKaA0R1a48knlAcHe9WyPS5VjiioRi1yzpTfX/+mzDfilDDslO4/R+gcN2RlnHuj3p5h8BApvQ9aDJvXHIReOa5mulJbgLmcCRZcg/h4mIHGQQcKzwXekh9tTbNzPB4wj6kHmxl9K1fMBMm1T3EOE2VP19n7JTyntrS/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cvHjgyKrQ480jN7N7o/cm/ZBNxT5I7wslxk6qwbvXhY=;
 b=eaJhWZ0+H71c2KErsS3WqO9r+OQccTUBUAAunEgN6vcT1mDTAuaiNsycZKTxGO3TIS4Zu2gyfGjEYmR+X/25dr1SCPh90tlpX5n482Y1K20v3cQQvPhgrHNZfE3sjg9b8uB5DIW0/25n+ZraMfN6LRNL13YhUrckaR55tEfvXbDbAiSWDVIC/BU0PWfMlgvteQc34tjUYTGbDU33weXM5i0X4ieYa66yZxF8W99IvnhLGV+TuUAf51qPBMESYYFQCnZMFuZkHUu+haBcZG998qF2P7aKtM4cIBpac4dT0YxFYQlizvfffQN5DrKCqK8YgQjJ+sKFl2cxuvdqXXHR4Q==
Received: from BN9PR03CA0343.namprd03.prod.outlook.com (2603:10b6:408:f6::18)
 by BL3PR12MB6426.namprd12.prod.outlook.com (2603:10b6:208:3b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 03:34:21 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::21) by BN9PR03CA0343.outlook.office365.com
 (2603:10b6:408:f6::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33 via Frontend
 Transport; Wed, 10 May 2023 03:34:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.18 via Frontend Transport; Wed, 10 May 2023 03:34:20 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 20:34:11 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 9 May 2023
 20:34:11 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Tue, 9 May 2023 20:34:10 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>
CC:     <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: [PATCH v2 02/17] iommu/dma: Support MSIs through nested domains
Date:   Tue, 9 May 2023 20:33:22 -0700
Message-ID: <f65a3d7e3e0e0c7b2f5cfc03ada9618aa8b523bb.1683688960.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683688960.git.nicolinc@nvidia.com>
References: <cover.1683688960.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT065:EE_|BL3PR12MB6426:EE_
X-MS-Office365-Filtering-Correlation-Id: ff651d43-f752-46eb-c2db-08db5107713a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YoKPqQADIGX6r+CfrPepnocVJv7x8pT4zKAjLH5ueK9tZZjQZyrfPKRNSoCc/90SsR1zhuI3D3CCEHxAhQptP1mkqrJNWNE2tXQHczfRZnm2ie5oBPwvUSiLjLmyQehoJk7MafecQh9ng4823lLDlKaL3VcY5A+eafqfmjI6szCuuQHX5YUZCVPEto4big3DKeRfcqmCgZibP+h+oDekxCDzOTfW9iV/w2xzBhZDEV3PLxkh4WCB5+70EdiF6SYYzYxkKryXkdGbBKEOCiXawtSxnU5SLiPBL57YJw7k9SAybQ2RBlcTcMopbhLXnM2yaTnrq/TaqpsNDraJRNB0hThxanF3QIfy7Ae0VewJ95wFa31OVofEI4AyG5cCu3/xDIMRAdjlGLENkx/gjV3VR/pIDrC5XxSBYBmrZ/roj56fxDljgUUop64Ek6YNgaBOvDRqkBnAL0Xu+KeNEnERVRXlKOVER7RBRvt+L5IjQ2pN4F/HzkppLzdw0NJLxJ9nlZVf4oBqQrPRklGCsUb4AJjeaZl48bKC2iybHCNxHmDMdW2KS/LrZLM7DFmO6OAd88HnFh9lTq2VtJmZecP7yYJQkUDlzQ4sYJLsUmJQIE7HDHkHK+ZC6lozjSHxRHLAYkf7f9p/USNSH7lQYOogO/wWt2sSCJsaoge7+FzJq7CDOx0+TjJ2YcKWXgV24X6nvmJGwNoOPKW2N/n4O8Oblg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(376002)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(86362001)(356005)(7636003)(316002)(41300700001)(40480700001)(40460700003)(2906002)(7416002)(36756003)(186003)(36860700001)(8936002)(8676002)(26005)(5660300002)(478600001)(82740400003)(336012)(426003)(110136005)(54906003)(6666004)(7696005)(83380400001)(70206006)(70586007)(82310400005)(47076005)(4326008)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 03:34:20.7479
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ff651d43-f752-46eb-c2db-08db5107713a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6426
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

From: Robin Murphy <robin.murphy@arm.com>

Currently, iommu-dma is the only place outside of IOMMUFD and drivers
which might need to be aware of the stage 2 domain encapsulated within
a nested domain. This would be in the legacy-VFIO-style case where we're
using host-managed MSIs with an identity mapping at stage 1, where it is
the underlying stage 2 domain which owns an MSI cookie and holds the
corresponding dynamic mappings. Hook up the new op to resolve what we
need from a nested domain.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 18 ++++++++++++++++--
 include/linux/iommu.h     |  4 ++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 7a9f0b0bddbd..da2b28eb9723 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1642,6 +1642,20 @@ static struct iommu_dma_msi_page *iommu_dma_get_msi_page(struct device *dev,
 	return NULL;
 }
 
+/*
+ * Nested domains may not have an MSI cookie or accept mappings, but they may
+ * be related to a domain which does, so we let them tell us what they need.
+ */
+static struct iommu_domain *iommu_dma_get_msi_mapping_domain(struct device *dev)
+{
+	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
+
+	if (domain && domain->type == IOMMU_DOMAIN_NESTED &&
+	    domain->ops->get_msi_mapping_domain)
+		domain = domain->ops->get_msi_mapping_domain(domain);
+	return domain;
+}
+
 /**
  * iommu_dma_prepare_msi() - Map the MSI page in the IOMMU domain
  * @desc: MSI descriptor, will store the MSI page
@@ -1652,7 +1666,7 @@ static struct iommu_dma_msi_page *iommu_dma_get_msi_page(struct device *dev,
 int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr)
 {
 	struct device *dev = msi_desc_to_dev(desc);
-	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
+	struct iommu_domain *domain = iommu_dma_get_msi_mapping_domain(dev);
 	struct iommu_dma_msi_page *msi_page;
 	static DEFINE_MUTEX(msi_prepare_lock); /* see below */
 
@@ -1685,7 +1699,7 @@ int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr)
 void iommu_dma_compose_msi_msg(struct msi_desc *desc, struct msi_msg *msg)
 {
 	struct device *dev = msi_desc_to_dev(desc);
-	const struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
+	const struct iommu_domain *domain = iommu_dma_get_msi_mapping_domain(dev);
 	const struct iommu_dma_msi_page *msi_page;
 
 	msi_page = msi_desc_get_iommu_cookie(desc);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 470b088a13f7..cb517898f55c 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -362,6 +362,8 @@ struct iommu_ops {
  *                           specific mechanisms.
  * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
  * @free: Release the domain after use.
+ * @get_msi_mapping_domain: Return the related iommu_domain that should hold the
+ *                          MSI cookie and accept mapping(s).
  */
 struct iommu_domain_ops {
 	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
@@ -396,6 +398,8 @@ struct iommu_domain_ops {
 				  unsigned long quirks);
 
 	void (*free)(struct iommu_domain *domain);
+	struct iommu_domain *
+		(*get_msi_mapping_domain)(struct iommu_domain *domain);
 };
 
 /**
-- 
2.40.1

