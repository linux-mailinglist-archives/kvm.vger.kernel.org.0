Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5448467EF41
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 21:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbjA0UGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 15:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbjA0UGK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 15:06:10 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2041.outbound.protection.outlook.com [40.107.100.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E3821A27;
        Fri, 27 Jan 2023 12:05:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3rcDnhsQSnEkly2N0k8HFUEjMZx6Thg5Duvku+27pNLvBmVNo1S8B9a+JxylOuhIcuWSNvb5ISMSzRxuz4oGhuxCQSALBfnPS8Q2JpMzfRmhrmHW5RdUuxuPd17ve2DHbFzQeIY7brqGtQztjl+YXl6gAFOu5Cl8f80dXCFmpKyeJLpLTgliXRORCa8Go7hNXGNavrfaZCZuU+hZpdPniQXjxS+svV2Qsk7lefJiKz60oIfG/wsYqFpgF86/HrDQEVO+GCaBZgB7kefr/SmEnLakgLFOUxIKYouKH/U3WJisdrcB5oBVkD+mjSzGkPdLmvowIWZzPjw6dFIxKMsWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uWv5oShpOqmRwrYUOL8K7idqgxwF1nEJXKyGa5wWZYQ=;
 b=Uks1od/m3EYbes9KqTCOgaPREUI5nlbUCTdT9JZBycOGEFLFh+durnv7/qtJcsSTgBbTAdJUrgQ9F77aQlltSODVpmON9X7qhsIQYaPwMw3QjecRCRqD5rnTbx/FCrv74ptbeRNia0Lk7g/1JsnaEjGz8dlo/f+C5tj6z0+eFiDT/ZuG8i5Ht6UPhQoHtCfsMXH/CvX1TcSAx1h+QDAduqd8uha2i4wWBBVsGjjYiqJxOYGBTc5tuqiD5yFt8HCSvtPaA+iEkovwP0M5f8iKeJu7QbJnzUwIIh1s18fJK3506ZR8qMfo38ewegRk4yfeU9tn72t7Cu84wJt/NvhI8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uWv5oShpOqmRwrYUOL8K7idqgxwF1nEJXKyGa5wWZYQ=;
 b=Xls7BTZayMdQxeMPSnGrHbQ3DzmIi+Ty97STYvPjY0jr3ZKU6NddUh2/MCt96kR7ygsC2AobfMavTQpJAzwKONelZrrHZcpEin8oYn3emXZ6IbW3JhG/niVdbVduEfUIg3Ahb7XNNkS96XXXzoRKME8SQiy2ajZbKeEkRkJ8H/k6V3Q61wRZeeCeboFz3xn7VHZu/O3g6JARQCLBzIxl7yNilnhp/WVImdN8/GrDtrU5y6VF/7uOg1+G6R1xo+/qKww3FzrE09vj5EhZp3AWXKlB7AnqwM0PIVpdmOxLmS+oDc959G86dHTK8WBM24xQwbGQ/kiMDTs4POU25z8CBg==
Received: from BN0PR04CA0130.namprd04.prod.outlook.com (2603:10b6:408:ed::15)
 by PH0PR12MB5645.namprd12.prod.outlook.com (2603:10b6:510:140::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 20:05:11 +0000
Received: from BN8NAM11FT112.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::34) by BN0PR04CA0130.outlook.office365.com
 (2603:10b6:408:ed::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 20:05:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT112.mail.protection.outlook.com (10.13.176.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 20:05:10 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 12:05:00 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 12:05:00 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Fri, 27 Jan 2023 12:04:58 -0800
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
Subject: [PATCH 3/4] iommufd: Do not allocate device object if broken_unmanaged_domain
Date:   Fri, 27 Jan 2023 12:04:19 -0800
Message-ID: <74f7033192488c472ca04b7d03e4dc5705f80cc0.1674849118.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674849118.git.nicolinc@nvidia.com>
References: <cover.1674849118.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT112:EE_|PH0PR12MB5645:EE_
X-MS-Office365-Filtering-Correlation-Id: b5919e60-d0da-458f-8b87-08db00a1cb75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NKSqk9o5cX9lKBL8HtamrIZthCOgEBSlEUpvnVlR9wTmUfTl88EPzEMe3v9wCj9U3mBZSPTZlOCr4w1VMKzuoxPCmv8npYN39kfCLPbzGCoFOxIuqRBECPjLw+M1DdvrI2E4I8arWSUiuIQx9pE8KSWzkH06xMNm5It4/aR1eS7LG/9vhWiRYwm/RT9UDyDE1Nu+mVIDnBBY8nVWkNRmHm3gqE3ffuDmXqVsAJgILGk9otOudH/7Qg7GTVfmC8bpfDumN8Wr/he34J/+GcM5W6A4nDjyGOIrstb+w47l0R0rbN4kmh38JxIWuc4ON2BuZo5cjz4/z9pu2QiB/dBecfrEpIuyWPg2O81IhVRQphY18txDd7UWiEVPLJNkwlB6vUyMrX3CQuosDmAXMV5UmwgC56V8dnmiRBrkI2nG2IjDDhg2LuR/Ou4igTFYuK7kRHB4jLDmk82+0r4J0J/pvYgYwfmmxe91SN1VH4TXaMaevXS6onhgP6Ws24NLKqmqUAAI2f8knrkrW9/K3LtpAYeAKwQ16brolz1mcEz2fMYN/ygnLqi4CN2kyFIMbgydl6tF3J1IOk1BTvh2SgQd4z6LjoRZpV/6imAbb5xMFNHMuRxCwjYq3h57wBGYZvfKxmmUOPRsScN/bCrxs3nYRuoVQaFE2e/EYtlAgM0e8xSysr+It+t2tdNR8K2vPRKBCgvI2iGaGULRd18L6G1IlTkkorPSHJYeKW8IxnVQuxM=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199018)(46966006)(40470700004)(36840700001)(47076005)(82310400005)(8676002)(36756003)(40460700003)(40480700001)(336012)(7696005)(316002)(356005)(36860700001)(921005)(7636003)(426003)(2616005)(26005)(186003)(86362001)(5660300002)(4744005)(7416002)(110136005)(478600001)(6666004)(54906003)(70586007)(41300700001)(82740400003)(8936002)(2906002)(4326008)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 20:05:10.4238
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5919e60-d0da-458f-8b87-08db00a1cb75
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT112.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5645
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
iommufd in the early stage, if the flag is set by the iommu driver.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index d81f93a321af..41b55615a693 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -73,6 +73,9 @@ struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
 	if (!device_iommu_capable(dev, IOMMU_CAP_CACHE_COHERENCY))
 		return ERR_PTR(-EINVAL);
 
+	if (!device_iommu_unmanaged_supported(dev))
+		return ERR_PTR(-EINVAL);
+
 	group = iommu_group_get(dev);
 	if (!group)
 		return ERR_PTR(-ENODEV);
-- 
2.39.1

