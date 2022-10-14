Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683D15FE81D
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 06:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiJNEma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 00:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiJNEmZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 00:42:25 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395ED1FF9C;
        Thu, 13 Oct 2022 21:42:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SuzRzkfDvyRjX9mJO2/VzZPDT7NCXWzpYY4JKf0O9+vaKOe67J2m5gnOkuFvIZLZTSVS5vIvGF1KKwfjquveyEY8OiUjDDtZitUBNqhhENG2rscM4XJIEgZ7uw27ZvxSVgwjs9C3BUJhJlJhm4gABvkR15r8yEBqzDc5Tb+hPigtNhME89ks4efKaX4/dENGLIjZkXrv6Kah5EngWWvzC6vNWKQAag4lkHkAvrgQIr8lUJ5LQm4ziTsZfUTY8pW9JsXitGD/cNbQSqPSbW14D76m1hQKmR0F4dZiwxUzB4Rbbwjqmm8kpQTJ+xoNJnA78uY8NjwyIC7yOxV9//lzUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SmYVvxz0wvs3BZvU0oP9HJ5OMvAW2v1a3YmJJAd9fu8=;
 b=TGkzy3BBsOBm4moINPJAUt99oLpQecMnkvPjdtZHgcJZUiCYzKAwRJybO0I0+Jm7mMM+9Kymwc1PySAOOryyhixCxIzcVtsxmHzqL/qEcU5fDu3UlMvzZHIf6p2+N0ZI1bMEbrbsEKNBm17+BNltYRH4zZCC6YNhz7iblB4JSuKC0FaJZK960fc6pLkXCAheXoJioar1uoF1FFMog6998fCuN3Idh67JF0UCCnft27qRremcb4iQzB6bCS2DV3NUrir6NR56vqkIvjDQaneTDAN1nf+Eo+61BP2suvU3p87EO2uaYVIK4v3lhRtsp9TbxQWpcNS9OQpRisjf6y/OMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SmYVvxz0wvs3BZvU0oP9HJ5OMvAW2v1a3YmJJAd9fu8=;
 b=is/Uei8Gpv21/6qThHu/pAmMWyWMqKFO3wdv2RRkXA7nnNePSBGGFz1JFg5u0KX42N2BRvD/Xyv7IM6DQe4zNyMDzFBNUukwwOzRDndKzcfkGx+lE834v2PSpuRAjicVrv/pLyNK1IVfkHckqqnTfopxx/oINPcl6fd16SfvuDY=
Received: from MW4PR04CA0131.namprd04.prod.outlook.com (2603:10b6:303:84::16)
 by DS7PR12MB5959.namprd12.prod.outlook.com (2603:10b6:8:7e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Fri, 14 Oct
 2022 04:42:07 +0000
Received: from CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::2f) by MW4PR04CA0131.outlook.office365.com
 (2603:10b6:303:84::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26 via Frontend
 Transport; Fri, 14 Oct 2022 04:42:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT038.mail.protection.outlook.com (10.13.174.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Fri, 14 Oct 2022 04:42:05 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 23:42:01 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 21:41:36 -0700
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Thu, 13 Oct 2022 23:41:28 -0500
From:   Nipun Gupta <nipun.gupta@amd.com>
To:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
        <eric.auger@redhat.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <puneet.gupta@amd.com>,
        <song.bao.hua@hisilicon.com>, <mchehab+huawei@kernel.org>,
        <maz@kernel.org>, <f.fainelli@gmail.com>,
        <jeffrey.l.hugo@gmail.com>, <saravanak@google.com>,
        <Michael.Srba@seznam.cz>, <mani@kernel.org>, <yishaih@nvidia.com>,
        <jgg@ziepe.ca>, <jgg@nvidia.com>, <robin.murphy@arm.com>,
        <will@kernel.org>, <joro@8bytes.org>, <masahiroy@kernel.org>,
        <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <okaya@kernel.org>, <harpreet.anand@amd.com>,
        <nikhil.agarwal@amd.com>, <michal.simek@amd.com>,
        <aleksandar.radovanovic@amd.com>, <git@amd.com>,
        Nipun Gupta <nipun.gupta@amd.com>
Subject: [RFC PATCH v4 4/8] bux/cdx: support dma configuration for CDX devices
Date:   Fri, 14 Oct 2022 10:10:45 +0530
Message-ID: <20221014044049.2557085-5-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221014044049.2557085-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20221014044049.2557085-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT038:EE_|DS7PR12MB5959:EE_
X-MS-Office365-Filtering-Correlation-Id: 21e58fa5-a159-46ab-2efb-08daad9e7223
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eGvN1LvacLKgFRjOIHuBl6MZyaU4j78wXlvutMII/ppepPTdSuGWPtngVQqDLEESFHIlV3Ab7xGF/UqHGazN8yvx7BJVBZysDzEhlMssww55+geu/mgib3JjnnrsY7qZuDaGVwLbngwL5S1JdwBOX5iinLnx1nzqeMnFY2pr41plbLIeUpyeCVocPdTEvJ4qalVI6amkZwMt+tScnaFjdzUoPVWxde3SoaDOT4D84R0a/X9kz/6xu4H/kGkyYJZvzh8M6VuLsb5+Q4X757Tnv+QGS5qJGVj9QjDQxq+I9g7up4ouvBfhae5dchjX1PW7PHan4WI5TXDp1aCqaEVpxXkwrkUJmKXTlkyhVJqltdC8hlKh9s44OQV5B0FAe4QbyfF0MVUzYgYzKJiZy0Ky/wxPIH5CMznniO0JBRJektS2J+ZXEBYyfTb9FUgdmyNrweVwRxJwxsQzqfwzJdnxVSUu7ddWDa9f/D8bTADcinI72r0jJqNtn+FTnvy4I86SHftRLCmJ24Z3e5+fV7SWsbtahC39hXQ8Vsi9N5T6Do9t8nGKw/IfziDcbL45Y+cqpwxKD2wLwQYlpebe/4WCkU/B3qG+WWQo+QYPV2UaFbtx6FyDNl0hlADhhsCdd/i0/5p3BbmBPirtzeSEiKrh5+hVs71FDnmMTe4L2B0qLvA+puCyz2TQwbsawIjcRoCvF3UMv3ZIPtp/60vrnNeE9qyS/waGcjO04Ad6bVatYTGNetu8QHYedLC1GAKLX+YA6oNZw6dPQdZjc8Em8DvJ/JK4L/9D+VgoovUeTmia4JLMVN8ADPi8P8dg+12NIodzv5rVCCkzqra9eN0BCSBtJYBwwslt6UVzwldZda4C+i2JWHefKRsn5qRfB4Uzaybt
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199015)(40470700004)(46966006)(36840700001)(36860700001)(426003)(921005)(356005)(82740400003)(47076005)(86362001)(336012)(82310400005)(7416002)(40460700003)(8676002)(478600001)(316002)(8936002)(1076003)(186003)(110136005)(81166007)(70206006)(70586007)(54906003)(4326008)(41300700001)(2906002)(44832011)(2616005)(26005)(40480700001)(6666004)(5660300002)(36756003)(2101003)(36900700001)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 04:42:05.5974
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 21e58fa5-a159-46ab-2efb-08daad9e7223
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5959
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With CDX bus supported in SMMU, devices on CDX bus can be
configured to support DMA configuration. This change adds
the dma configure callback for CDX bus.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---
 drivers/bus/cdx/cdx.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/bus/cdx/cdx.c b/drivers/bus/cdx/cdx.c
index 5a366f4ae69c..b2a7e0b34df8 100644
--- a/drivers/bus/cdx/cdx.c
+++ b/drivers/bus/cdx/cdx.c
@@ -57,6 +57,7 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/of_device.h>
 #include <linux/slab.h>
 #include <linux/cdx/cdx_bus.h>
 
@@ -180,10 +181,26 @@ static void cdx_remove(struct device *dev)
 		cdx_drv->remove(cdx_dev);
 }
 
+static int cdx_dma_configure(struct device *dev)
+{
+	struct cdx_device *cdx_dev = to_cdx_device(dev);
+	u32 input_id = cdx_dev->req_id;
+	int ret;
+
+	ret = of_dma_configure_id(dev, dev->parent->of_node, 0, &input_id);
+	if (ret) {
+		dev_err(dev, "of_dma_configure_id() failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
 struct bus_type cdx_bus_type = {
 	.name		= "cdx",
 	.match		= cdx_bus_match,
 	.remove		= cdx_remove,
+	.dma_configure  = cdx_dma_configure,
 };
 EXPORT_SYMBOL_GPL(cdx_bus_type);
 
-- 
2.25.1

