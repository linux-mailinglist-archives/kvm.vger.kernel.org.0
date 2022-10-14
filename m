Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151E45FE816
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 06:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiJNEmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 00:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiJNEmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 00:42:22 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2057.outbound.protection.outlook.com [40.107.101.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436831FF88;
        Thu, 13 Oct 2022 21:42:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UwST/bgCOADim6RQZFwwqhwAF2+dT/iJsn1MQfHZQg+IToiu/CsaX6DUUHdUY+nJxhV5On0qI0UEwQSoFBtIrQjCzyw6hAkeyA15bt/god/13u/s1uaN8Bd+ytLMWmnsZj3dSo5VOYtTbCuNIhdniIJclOsz9MllKemLY8o12BGT/zd9IJ29m4FOIVs7OJjsk0A4gHL8VpB3l7D7b2eHDffBDxA1khTnE4+42xdnQ69buyE+sSWLPu4KxnganEEMFPDaEly6X4NU68N9hxkKcU/zUPzjFjpXyQZpoGaoQTj++VkUi1h91qwex8zXDiiXSaFjfvPekF9zXnk1TDaCSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HFLqRFQwdCB/AVMKNaSF9HMOVyLB+Gzq9vpFzIaP/vg=;
 b=BB6hcTo+nuWi4YkQyItQ8NVBrapBBAB25yCZLfDiAxiwwczlcIKd4QnT5AUsua0SeH0KuWoFRqUZDc3/Y8LkVUMZcuQtDXAeQa3wNEnd9TogJD7vqMQbg/NckTS7MiQ0lIpQbjgUlZl+le7blN7immbRqr5ULO/JGa4nkelM3ClAQU2nGWnc8hGxUQGQUPkHV0vAuysfdTPyIs0kQt82Q0Ioh0UUuosuZey69R+3dq/QpFUWrICrSz5OVrM2enI7m5G+cdZyMaH8+ooamWTLUuSTgL8l7ib7VAc6bVphfiPxfowJK1MroaBnAvT5GQpCNp19afWuXMhvPJJAfqmtUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HFLqRFQwdCB/AVMKNaSF9HMOVyLB+Gzq9vpFzIaP/vg=;
 b=wXMtYl7PWPeXGXW4QrfS751LBaksOjabHcO8eFXcUJ9BGwHfCYeOGyLlXcdu6ibP+u6HpCwQ+ciIBFLoMAg0F3bHd83+HDz2ytW/zl6xCH7Yl46NcotNAxAR7gJlbQxaSJR38jutNmbKuw8ulALyk91Q92MYDEa4rj/t3hPM+64=
Received: from MW4PR04CA0061.namprd04.prod.outlook.com (2603:10b6:303:6b::6)
 by DM4PR12MB5136.namprd12.prod.outlook.com (2603:10b6:5:393::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Fri, 14 Oct
 2022 04:42:04 +0000
Received: from CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::b9) by MW4PR04CA0061.outlook.office365.com
 (2603:10b6:303:6b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.22 via Frontend
 Transport; Fri, 14 Oct 2022 04:42:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT048.mail.protection.outlook.com (10.13.175.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Fri, 14 Oct 2022 04:42:02 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 23:41:29 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 21:41:28 -0700
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Thu, 13 Oct 2022 23:41:20 -0500
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
Subject: [RFC PATCH v4 3/8] iommu/arm-smmu-v3: support ops registration for CDX bus
Date:   Fri, 14 Oct 2022 10:10:44 +0530
Message-ID: <20221014044049.2557085-4-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221014044049.2557085-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20221014044049.2557085-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT048:EE_|DM4PR12MB5136:EE_
X-MS-Office365-Filtering-Correlation-Id: 8193247b-d68a-4e67-49dd-08daad9e7082
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6oggO/NvTlGA6JA54wTAPe2eggVmLw0htNxVs6UbBMz2z7TNDs+u00bJSs16a9kvFquy66/wrfjj3sRhMEYlgn7mJjPmAfyIiebnZSp5g3v5J1ua3N1NeLtELnfyD90RO/F8jX+tjOOhNcUxUGJ5DZMfAza2qCIdkMd1QsYBXwnvw5OgpqMAWDXND+OPx9LOFrNjlE/nf7D/LYiVEpsXe6C8PZyqgVCQdWOvrbZUAoZbnxWr2j5cRtJF5gcVBTudlUcyCFlDgJ9/szrFTaqyW6ypdudtgF/l9V/h96YwNwu/90n6k1J5jEWieX9lGANO5G2nwUX4/3aCGuLnwsUIEaGdMYbBYGlTNpBfPxW+GxrWU/VfI8FBUqB+Ph7i1SaCITcKV7mawh1Ao2KExOfV6PxDz6oUb7F6eYYYLLBbeyvhFwyra/tshVey5x37DYnqdgbbJF/PTodR5kLPIgCJ6efnKiuanLkKQOMqwNQEzLC3G/xcw93axOOb9A6MQS7issy8kppPMnU7c7BHWb08VczDv8WyMRKFPl1XN7sSyCOScqIRfbr5UoPioAR1rz59JREfU1ovnJTy7nG6OQe+IqfDWxIGKcbSkbvvMEMUg5cvCjI4HGYjm+Rbegn94B5Jiw+hthY/8SiBRRFPlHHyALiqLlygFj8eHcLiGSrpkQgsyeKYO4sTIEideGn0bm9SxvknsTsF9QWjwtMlNmaXeBPVcYrRBRga3L+ggj6xTH9J14LZx7adv+MVLzlVp7gYUuoLFl/wMo/vrnGylBbEKjJkTE6j+CSakqx4DS504aWHOgcD1bcdANjf1C37r6vnq+JT9OqOuen7b9VGteEEfTPTpOHZW1n//ZWfANLqW4Yre6IDF913f9EESYNXbbyE
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199015)(40470700004)(46966006)(36840700001)(426003)(83380400001)(47076005)(82740400003)(36756003)(5660300002)(54906003)(86362001)(110136005)(81166007)(7416002)(8936002)(70206006)(70586007)(4326008)(44832011)(6666004)(8676002)(41300700001)(316002)(26005)(356005)(40480700001)(40460700003)(2616005)(1076003)(2906002)(186003)(336012)(82310400005)(36860700001)(478600001)(921005)(36900700001)(83996005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 04:42:02.8652
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8193247b-d68a-4e67-49dd-08daad9e7082
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5136
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With new CDX bus supported for AMD FPGA devices on ARM
platform, the bus requires registration for the SMMU v3
driver.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index d32b02336411..8ec9f2baf12d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -29,6 +29,7 @@
 #include <linux/platform_device.h>
 
 #include <linux/amba/bus.h>
+#include <linux/cdx/cdx_bus.h>
 
 #include "arm-smmu-v3.h"
 #include "../../iommu-sva-lib.h"
@@ -3690,16 +3691,27 @@ static int arm_smmu_set_bus_ops(struct iommu_ops *ops)
 		if (err)
 			goto err_reset_pci_ops;
 	}
+#endif
+#ifdef CONFIG_CDX_BUS
+	if (cdx_bus_type.iommu_ops != ops) {
+		err = bus_set_iommu(&cdx_bus_type, ops);
+		if (err)
+			goto err_reset_amba_ops;
+	}
 #endif
 	if (platform_bus_type.iommu_ops != ops) {
 		err = bus_set_iommu(&platform_bus_type, ops);
 		if (err)
-			goto err_reset_amba_ops;
+			goto err_reset_cdx_ops;
 	}
 
 	return 0;
 
-err_reset_amba_ops:
+err_reset_cdx_ops:
+#ifdef CONFIG_CDX_BUS
+	bus_set_iommu(&cdx_bus_type, NULL);
+#endif
+err_reset_amba_ops: __maybe_unused;
 #ifdef CONFIG_ARM_AMBA
 	bus_set_iommu(&amba_bustype, NULL);
 #endif
-- 
2.25.1

