Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689CF5FE80D
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 06:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiJNEl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 00:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiJNElW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 00:41:22 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2066.outbound.protection.outlook.com [40.107.212.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B9818DD45;
        Thu, 13 Oct 2022 21:41:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDY/ihSLkZSq176S9bmUZXPmdR3RWBOdScGAykTleDoTD4OZkQ4X3lepDtP7ITLMTfbc2Aax5598OaJciIZ4IOipN05zVv9+6KFjQ8rHM/Ec2GdiYBKYL8UMcJqFofxbdnAfyIsB2ELBnsVJvr9wXWBxA5OcKsTKknPS4IudGJ+kgZtFkSIigowkADHWSrf6wyATxzLjp9l9oRp63K9z6hFrO3lpOLl0avnnb+pLjTVtlmBsXGtzNd0I7CKUy32jF9D83OkvtqmmBGEzcbdCp/w5RiSl6fsra5q2PnSNeChFc7k62LKiV+XOGnqfXk8Y4s/Hom6I2rMYZMcdRO/lfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQmPzMQls6Sk1H659Pxiz3P+X+/x1S5SkEI8tEZQOV4=;
 b=jeHYKkrHJtb7oVl6eAJFI4KTo2R3MKeOmw9IU2xN1KA+Y2srb+gQWR2bh1cH+A/kHY150RpCFYxl0JmMLx6b7+HqLhK1gl2+xmt/I9Nmh/L2+QYvWmrIofzsieEWocM0DMo6DcJJ4AYX7FCJ/agWuzZ6W6U0fgtEzt/WUjhTODzKIBtzjCt80pYTlN3PtqTR2V0hFo2bz7LEzumso2QRR5Js07ZzEHTv3/XGSjRm1kglbrJ/lqDJ5o2eBKhNSHaMwn2HvDbUd+XZ7fq8ddmf0K6w5feITfroTzYinoHnB9C3jIjBAtpTBzjSpSG5u2Zv89L0jF2j1CjUjsA78NjSUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQmPzMQls6Sk1H659Pxiz3P+X+/x1S5SkEI8tEZQOV4=;
 b=Rv83xtRx/RBdOnfkFaP+hnasSOhbf8eeyYcCvpL4TF5SKXQkBcw4/ZBCNQPa4Z3iQ0ke/pI0+YeVpuPhJy9Dtju+oRHTZly7sTp8Su7Mgwf4WX4VQmT+huAR7f/07jIeU9845+PUnJio+8WxofoktzDRktdLiVW9ycCdVukBHuE=
Received: from MW4PR03CA0170.namprd03.prod.outlook.com (2603:10b6:303:8d::25)
 by MN2PR12MB4374.namprd12.prod.outlook.com (2603:10b6:208:266::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Fri, 14 Oct
 2022 04:41:16 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::1) by MW4PR03CA0170.outlook.office365.com
 (2603:10b6:303:8d::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.28 via Frontend
 Transport; Fri, 14 Oct 2022 04:41:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Fri, 14 Oct 2022 04:41:15 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 23:41:11 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 21:41:06 -0700
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Thu, 13 Oct 2022 23:40:58 -0500
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
Subject: [RFC PATCH v4 1/8] dt-bindings: bus: add CDX bus device tree bindings
Date:   Fri, 14 Oct 2022 10:10:42 +0530
Message-ID: <20221014044049.2557085-2-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221014044049.2557085-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20221014044049.2557085-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT058:EE_|MN2PR12MB4374:EE_
X-MS-Office365-Filtering-Correlation-Id: 883e60dc-d36c-4dda-6503-08daad9e5438
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TuurSXiiQmlTOOm1HRSG5+Aow64xUGKxkCgUgGY0ydHoJDShvIFvDPDKD87dY/KukV21vqyb5VZBCDKpWXVdZjoXadxRe5L3lY+TiWlZt46IV+UdLUfWpkwwA9flRn0+Z3rA6xOBYvBz2YUZkq3t7h40gcScKDsw3GdtcYJyCc1JSlGty0IhfBnVXk92zj+ZKcnvViXo0nn+zFqZKFHFoi2zlO58JJsJ0hsWOnipBdPehHMPtWhgpYSKe6nVDR+O9M/5LtGw+J908MT0bbRLl24wCyDidbWggbCq8YL9vbmwnjC3OvX3+bxpmMBJ/mDDZS7LjqAcGQ5Vi3KDGO0IMkBZyNOUJusYH03sGtvQowRHjzDf3kVMQDuBrmpGIHRQR1IKNZAhF0UQULbBf2ylrGx+DIUVmZlYI433TuuDqZV6Ob44oeZ1kftPDKvYy6MJkfRiZfQMX93Rc7YkP6NzDJ9LeITbD9px/g5ce9nheWFtBED22dvNT0QF98nP73i6NofFqOKJZe4dtZe796WcvqGvw9lHlUoTJLIkCkI4CGwbhTHbjHC9PVFlivCouZ/EGQy4Cl/0mu0A8iWWbm9ERNd0iwRGieXFdaN5z08NjFxopHM8p0QZsxPND1lnkMJc41M2ui6RzWXvt/dE8svzquuy7sm1QAxgmmo30ULMiulJOhaoPusRLpSRMXdh9ZHbEzdn1QZWPlplrLUDWDR7EsyOFhAfHoy9Kxqcp7vd7Ym0qrvZKccwcdj2AVa9EtFTI4H/tuJhyAKJoO3AZ4vx2DPllBZloM654y298IxFZCNgtoiNtuypslH+Zl0mWS7SzRHKy2tLDnbXPg9whnh0ziVoky0fkvP/Z1WJwfTF0NoY95ChZOEioo2f2JovjwO21dwqUp8fBW92vR6NJ0O19moQQGYi4MY90TbbJ9t5XbrfOTmzdm/DpXK/eQMRYcTh
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(26005)(83380400001)(5660300002)(82310400005)(36756003)(7416002)(6666004)(70206006)(41300700001)(70586007)(4326008)(8676002)(8936002)(356005)(81166007)(44832011)(921005)(36860700001)(186003)(40460700003)(336012)(86362001)(1076003)(2616005)(40480700001)(2906002)(426003)(966005)(82740400003)(47076005)(316002)(54906003)(478600001)(110136005)(36900700001)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 04:41:15.4047
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 883e60dc-d36c-4dda-6503-08daad9e5438
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4374
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds a devicetree binding documentation for CDX
bus.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---
 .../devicetree/bindings/bus/xlnx,cdx.yaml     | 65 +++++++++++++++++++
 MAINTAINERS                                   |  6 ++
 2 files changed, 71 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/bus/xlnx,cdx.yaml

diff --git a/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml b/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
new file mode 100644
index 000000000000..984ff65b668a
--- /dev/null
+++ b/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
@@ -0,0 +1,65 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/bus/xlnx,cdx.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: AMD CDX bus controller
+
+description: |
+  CDX bus controller detects CDX devices using CDX firmware and
+  add those to cdx bus. The CDX bus manages multiple FPGA based
+  hardware devices, which can support network, crypto or any other
+  specialized type of devices. These FPGA based devices can be
+  added/modified dynamically on run-time.
+
+  All devices on the CDX bus will have a unique streamid (for IOMMU)
+  and a unique device ID (for MSI) corresponding to a requestor ID
+  (one to one associated with the device). The streamid and deviceid
+  are used to configure SMMU and GIC-ITS respectively.
+
+  iommu-map property is used to define the set of stream ids
+  corresponding to each device and the associated IOMMU.
+
+  The MSI writes are accompanied by sideband data (Device ID).
+  The msi-map property is used to associate the devices with the
+  device ID as well as the associated ITS controller.
+
+maintainers:
+  - Nipun Gupta <nipun.gupta@amd.com>
+  - Nikhil Agarwal <nikhil.agarwal@amd.com>
+
+properties:
+  compatible:
+    const: xlnx,cdxbus-controller-1.0
+
+  reg:
+    maxItems: 1
+
+  iommu-map: true
+
+  msi-map: true
+
+required:
+  - compatible
+  - reg
+  - iommu-map
+  - msi-map
+
+additionalProperties: false
+
+examples:
+  - |
+    soc {
+        #address-cells = <2>;
+        #size-cells = <2>;
+
+        cdx: cdx@4000000 {
+            compatible = "xlnx,cdxbus-controller-1.0";
+            reg = <0x00000000 0x04000000 0 0x1000>;
+            /* define map for RIDs 250-259 */
+            iommu-map = <250 &smmu 250 10>;
+            /* define msi map for RIDs 250-259 */
+            msi-map = <250 &its 250 10>;
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index f5ca4aefd184..5f48f11fe0c3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -935,6 +935,12 @@ S:	Supported
 F:	drivers/crypto/ccp/
 F:	include/linux/ccp.h
 
+AMD CDX BUS DRIVER
+M:	Nipun Gupta <nipun.gupta@amd.com>
+M:	Nikhil Agarwal <nikhil.agarwal@amd.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
+
 AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SEV SUPPORT
 M:	Brijesh Singh <brijesh.singh@amd.com>
 M:	Tom Lendacky <thomas.lendacky@amd.com>
-- 
2.25.1

