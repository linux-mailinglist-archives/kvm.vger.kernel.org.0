Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A41525AEB88
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 16:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241391AbiIFOU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 10:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241665AbiIFOR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 10:17:28 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CA3DEF7;
        Tue,  6 Sep 2022 06:49:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XemBOO3nC6WNAP+aI+9SSmsvwLFQuoEHbTqjUQN+JiHjEoO2k7aLdUwYo9zQ8rQaAAy76QTdB+OpASnLZ83qVgAc7TAEtW3pcJJgmZEWxmVPhuQQIu7YvD5vI4UVntHiS2WI3GD4Fm0lu825S0i1Q/+doGjQVb8LrWa4Mcc+EMGxzr637jaVeFeGCF6zaLuDLizWYW+0qG7A0ZmW4hr5BnNJlVyIbCxTYEHh/IpeQaCNCMo0ie1kR7HNgoNABy5QfreUoDDntMONvJvAWS51dFotaXxa45d8+5jIJX0lwl8iF2psmgdX12O3odV0QiePW4bsMDD5XRc954PcqUHpRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uCJIG/W6utr64/ZhPwmV6hiUCVl91LQmkAFBIzF02+s=;
 b=n6qUfxojKz/a+43tjPHftgay9mJJBXUu2lissSOQ7B9r2YSszs7AbnBy2h5FHixp+iH6p7PE+HpdmHI4r2+gUu6UwNfqSxfWr6zCF2U0jFWlvuskEc9pjbrseOALBgjtwMTbi5GuWTIXeszEeji4uGZaX36YEmZn4R9DVxAUYF3JSwT8c+sFkm+/gQuFdChMypIqXjhGE6oRr6Nf1iLwUPtFEk5nq4nKbfnccAm3ON09AzzwUfk9JJmpBe6O+T3x8Ycite1m0M1xQq2H+xRokOvfq5M06yML+wddKxg2eHPxVdV86mgsgkHLWBu3keTW7i4dCAp9gBsGKOhwXVvOJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uCJIG/W6utr64/ZhPwmV6hiUCVl91LQmkAFBIzF02+s=;
 b=otFUDPNyUSc4xTmscwM7i2gMEHFRi2Y0g8bXOWGmziKYGmoXdCIn+txcZe/fFw6lyltUKdibSZbcCQqLHhuk/1oVOSS1qgiHmj9E/GQXOnXZvmCTIvqXrnLgPKKiWQqTcK3Q4r5wCBfAeZ7LK6ujuy3gxmH1+0xyZRYi1zS/d60=
Received: from CY5PR22CA0004.namprd22.prod.outlook.com (2603:10b6:930:16::29)
 by DM4PR12MB7573.namprd12.prod.outlook.com (2603:10b6:8:10f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Tue, 6 Sep
 2022 13:48:29 +0000
Received: from CY4PEPF0000B8ED.namprd05.prod.outlook.com
 (2603:10b6:930:16:cafe::d7) by CY5PR22CA0004.outlook.office365.com
 (2603:10b6:930:16::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12 via Frontend
 Transport; Tue, 6 Sep 2022 13:48:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000B8ED.mail.protection.outlook.com (10.167.241.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5612.10 via Frontend Transport; Tue, 6 Sep 2022 13:48:29 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 6 Sep
 2022 08:48:23 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 6 Sep
 2022 06:48:22 -0700
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Tue, 6 Sep 2022 08:48:12 -0500
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
Subject: [RFC PATCH v3 1/7] dt-bindings: bus: add CDX bus device tree bindings
Date:   Tue, 6 Sep 2022 19:17:55 +0530
Message-ID: <20220906134801.4079497-2-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906134801.4079497-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8ED:EE_|DM4PR12MB7573:EE_
X-MS-Office365-Filtering-Correlation-Id: c70549d4-1204-48dc-1f19-08da900e7b09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0C4YTxBp6+Y0di6IdLA3qW++l/vhqi7kx5E5zz2EoLsqUPAcKHDC3Zlrc3NwxOhq2kO5ZIoWj0EMnDE45WyD3R17se5u6eehQnOxtEBNmkkTY5Qv9DD7RddGrcl13lZ+C5mXT5ubOOWzPfAYIUG0cX9T2eLGmz2jFA4Cm87ntsABLvBcFM7z/SIH6JAnPAmzGg3HMxSZzv8UdssAMSHkF0+RXzjcHAXEAJTRaG1jCgek5sk3G+Ey2cTUq2p1pDOM9KwD8AE0mFKdjSkVOkyjdsvqcaB7Rt8edZDZqfhi8S/FS3Dwyl14pTLnACf0k5fIX9SGjZduB6aVao4lycprnL/AGTMXl4QyF7SiW4qzAxV6fqPJV+lVvKVuDiGeyILAFwKSD6e3XCuk6HigA9esPezeSGFGq7eqJDTWJ/FP0v3R9aEai8L2Rr7Ae615a4CDM7SCsuEmKGK9TUf0ORsEBb6HV65ipdfi5mRqnlIrPswPQ2qjJDG03Is9tTKl0eMv0H8xqZvsiJNei/8f3PTi4u6vtq7OZaRVqmwhiKQOyKX2zpOFeW9+OD0YGwtIiKOfBpT/r33hkjo+H1mmIrImyAymCZmmnPGfF/4AtO35NdRprbERYCFtXtYrB1+QArtH9OsLdMfVU9fdp1iEEH+J9GnoBx1mUfeKS5w2ayf+v/QPaqfY3jfTtRKtpfAjjXfeX5obLiiZN8bdQvm7Ubb6oFAWRmdq/ZW0LCpRGbzFm6VRhjKH7QwRynVqBap8Jp5gt8gSQmaropna5psX1lWLvdXcnB2YF/sW4LiEUc22HHkW5zJ8VrQ42WpUka174FUvfL/LX6URnm4xSydSkOlKMgAL1LHgE4TKfDhXasq3eCaTGfx69hQZqeWIvGYjzi5NJAk4RVvRNTBXgFmFIHKr73jJlI3XDF4XJXg2IX9y9OOVq6U8bsBhu8U0B5flWDOm
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(396003)(39860400002)(40470700004)(36840700001)(46966006)(8936002)(7416002)(5660300002)(36860700001)(44832011)(2906002)(83380400001)(36756003)(8676002)(40460700003)(82740400003)(40480700001)(70586007)(4326008)(70206006)(110136005)(316002)(54906003)(6666004)(86362001)(82310400005)(47076005)(426003)(336012)(81166007)(2616005)(26005)(1076003)(186003)(356005)(921005)(41300700001)(478600001)(966005)(36900700001)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 13:48:29.1983
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c70549d4-1204-48dc-1f19-08da900e7b09
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8ED.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7573
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds a devicetree binding documentation for CDX
bus.

CDX bus controller dynamically detects CDX bus and the
devices on these bus using CDX firmware.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---
 .../devicetree/bindings/bus/xlnx,cdx.yaml     | 75 +++++++++++++++++++
 MAINTAINERS                                   |  6 ++
 2 files changed, 81 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/bus/xlnx,cdx.yaml

diff --git a/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml b/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
new file mode 100644
index 000000000000..0aa5599ada8e
--- /dev/null
+++ b/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
@@ -0,0 +1,75 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/bus/xlnx,cdx.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: AMD CDX bus controller
+
+description: |
+  CDX bus controller for AMD devices is implemented to dynamically
+  detect CDX bus and devices on these bus using the firmware.
+  The CDX bus manages multiple FPGA based hardware devices, which
+  can support network, crypto or any other specialized type of
+  devices. These FPGA based devices can be added/modified dynamically
+  on run-time.
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
+    smmu@ec000000 {
+        compatible = "arm,smmu-v3";
+        #iommu-cells = <1>;
+    };
+
+    gic@e2000000 {
+        compatible = "arm,gic-v3";
+        interrupt-controller;
+        its: gic-its@e2040000 {
+            compatible = "arm,gic-v3-its";
+            msi-controller;
+        };
+    };
+
+    cdx: cdx@4000000 {
+        compatible = "xlnx,cdxbus-controller-1.0";
+        reg = <0x00000000 0x04000000 0 0x1000>;
+        /* define map for RIDs 250-259 */
+        iommu-map = <250 &smmu 250 10>;
+        /* define msi map for RIDs 250-259 */
+        msi-map = <250 &its 250 10>;
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 9d7f64dc0efe..f0598b3d731c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -934,6 +934,12 @@ S:	Supported
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

