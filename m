Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD6D67EF32
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 21:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbjA0UGb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 15:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbjA0UGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 15:06:09 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A3D1968D;
        Fri, 27 Jan 2023 12:05:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oMfodoEU980tWnqGZN2AU8MKrGdxJlYaWUMIDjKEFE7SCwyNojfv0t5HwQe2Hs4eaD5yXkQqNs/fT8nNzbQIhuKq1c8a97li3hzgYKQH7V0elh3KDgLB26MMCIVuJA9FFOIMvjJt88wKWkA6OvfhQpNxJoBX7AUroqSy1dXKmCmD1rW6fEiBDQZjP6fmdOfeu2W7OJwN3/Ukibd5RFMwZlbM5Yy85FubAjSIy1VQfAf0oPrgAa7U9bEhZbDcV2Xdsr5Gw6CU3xvvc2/vdi5TkDE3vUuDGq+RRgabM1HjoimxhhDcgpMfzW89WIim67APtL7JO/Myk7A7GbSMfe3ukg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XgM+cev+ndotYYDg9UlvyDRsKaHnb3mMoVsLfQwtZhc=;
 b=Gvxoq8JCmcMDcf69IELBw2pGn0IJCQuU5mU9W/Xc2xRmVE7dlUsNHAxuJCULa8it9oGi6t/ruFN0etbWrrAphLW/p8JtCZkxpPwlK0GJPmv82JVJBFzkb4h4GKG7lSADqij38Z5Rm0e17fdSk6g3FATwWaqt2haW3KlkpQr9kVbiicYBc8Lze2rIwXQaqAMgJImysX8cvpj+/Defrf63uEZL58N9R4P1zGfuWdj3RWtiOX8gWmGku6Yjev60e0UMW9YFZKg7xn9Svn1fCyzwuRqdA3iAGaLcOLiny4sTPpIPhi80Oq1FV08vp+98/+UkgCfH/JHzco0K5eaBDhoGZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XgM+cev+ndotYYDg9UlvyDRsKaHnb3mMoVsLfQwtZhc=;
 b=jCRApkrqceox9F7WbzC6U9JBSlOJAYdA+YcatUtsl5Qh4HXIxnhHX+MM9h0QP1XgCYmUiIN50K+rGEtQs1nQfORg15/LdlhNQQRAaC4G1UEvp4juhin7erWKzBhX+ksGALAzWWiJL8v9HugGpJnLPwCsuhivjpVHlzviKNSHiXfZNgfIF5P3j8+n0njjIA1kSaV1T7pAEFafyKyThFIbWJDOAEpSiO/oLCwH0Yyj/4jMQmZJyFbg/kK4dSo9MZOw+/T/iM3QLDqiDFJZT2/jdemwFjH+AlfL3YRUob0xEv26azpibc2N+O3g0Xq/OadIMwcbvpALVBZxUDTWaqo/lg==
Received: from BN0PR04CA0131.namprd04.prod.outlook.com (2603:10b6:408:ed::16)
 by DM6PR12MB4417.namprd12.prod.outlook.com (2603:10b6:5:2a4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 20:05:09 +0000
Received: from BN8NAM11FT112.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::f9) by BN0PR04CA0131.outlook.office365.com
 (2603:10b6:408:ed::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25 via Frontend
 Transport; Fri, 27 Jan 2023 20:05:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT112.mail.protection.outlook.com (10.13.176.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 20:05:08 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 12:04:58 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 12:04:58 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Fri, 27 Jan 2023 12:04:56 -0800
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <kevin.tian@intel.com>, <robin.murphy@arm.com>,
        <joro@8bytes.org>, <will@kernel.org>, <agross@kernel.org>,
        <andersson@kernel.org>, <konrad.dybcio@linaro.org>,
        <yong.wu@mediatek.com>, <matthias.bgg@gmail.com>,
        <thierry.reding@gmail.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>
CC:     <vdumpa@nvidia.com>, <jonathanh@nvidia.com>,
        <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH 2/4] iommu/dma: Do not init domain if broken_unmanaged_domain
Date:   Fri, 27 Jan 2023 12:04:18 -0800
Message-ID: <451e7beb57ec6de66ee0da5b38886105436f53d7.1674849118.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674849118.git.nicolinc@nvidia.com>
References: <cover.1674849118.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT112:EE_|DM6PR12MB4417:EE_
X-MS-Office365-Filtering-Correlation-Id: e581f0a5-0c46-48b6-6296-08db00a1ca63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UaK1xkoUUrGEuWZFGoqIBoZwuwzxYLdXg3xkYOXTcjv0zILchFA7HtkIiLrHu5xJCWsjekGyoFIC3gEpzutRqdpcbA+F3KO4VHnVSwJ4m7EPTtIJu8wdByaTNY5aDzhy7/SjtHDvno+xqrg4z9mew06TfeQiLGiBHYs4jsflvNJwwaHaMfeSEESdOEChHET9I7WnYasbLrpLNVOY3vRNml8ToWHla8vAveo3Bp9N5NV265hpS+V1ivchGqOGCIzo4Q47zadRoAHMsNfuirw1IK34Sjl5gl5vs0VIqR+7sFvodtgi6V20wSfwmZXPbHIKtyBQCPTsVK4A3Z7QqHG4OeUWGQIXLpjCp9HnUr1XR4Fewxahk7dsVyLylzhoHmYzYWh17dM6rZi3ytaCKCLOFnbqLgDBEKBvPZrkyPP75kaI9QHwNTtgm7tIcwENUtlwfx/sQZ//vH8hssR6jsPFWbwEdsQOGrUe7zbDE89utGqABt7NYO/mALb+Lng4yiOETQ93vSdTGAGb5Cr/Ywgbyoj5aErCDIkgzFza/uSzRyg7UmYqsLhdpWDU4HTrA8vLeyfNXpyQP/gAJW5oih/oxtXIHLHhtswytyWRa7EgFn5Y2tPABz4lY8Po/C7SYI+dNgTzNodUp1p/qfBcnHWUonOuW/i00TXDGXW8agtUdjnqQm8VqEz1O5yb7+Iv29Ko4C6UxH4zlwKOtRZV+JKQpJrLe7/bzh1zhipHjWPSKCY=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199018)(40470700004)(36840700001)(46966006)(2906002)(5660300002)(7416002)(4744005)(41300700001)(36860700001)(426003)(47076005)(6666004)(26005)(8936002)(336012)(186003)(478600001)(2616005)(70206006)(36756003)(356005)(40460700003)(82740400003)(921005)(7636003)(70586007)(86362001)(316002)(4326008)(40480700001)(7696005)(8676002)(82310400005)(54906003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 20:05:08.6271
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e581f0a5-0c46-48b6-6296-08db00a1ca63
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT112.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4417
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a sanity of the broken_unmanaged_domain flag to reject the use of
dma-iommu in the early stage, if the flag is set by the iommu driver.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index f798c44e0903..f1e8d952b17d 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -545,6 +545,9 @@ static int iommu_dma_init_domain(struct iommu_domain *domain, dma_addr_t base,
 	if (!cookie || cookie->type != IOMMU_DMA_IOVA_COOKIE)
 		return -EINVAL;
 
+	if (WARN_ON(!device_iommu_unmanaged_supported(dev)))
+		return -EINVAL;
+
 	iovad = &cookie->iovad;
 
 	/* Use the smallest supported page size for IOVA granularity */
-- 
2.39.1

