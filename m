Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBC4597299
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 17:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240748AbiHQPHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 11:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240746AbiHQPGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 11:06:49 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925579E2E6;
        Wed, 17 Aug 2022 08:06:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PIRAIXbH5xhyUFCIRwWtnuo+JrcvqTURRZcE50IwF11Fh7FDFKZYG9pN7oXYh9yK+MBrVSyNoo1QY6fYvdfa/W4EncPFFGRx9P5aihTA23FmGyKE7elAV2sq8JaFOhNg+dJQToW7RwSOHaDtNzThdiP5JyVz2hSkl+XXfo1bx+a4zRu0XTycACyrURu9mLiGuECI4UctuEN6NDsHGUJ6NFMbH3Rj6N6bO75PPDShuPAX7wgT7ez9pH698krG2Nn+vyDjaFpKTi0kk48Der9SSjQr0s/sNBVL5QeWcB2LZ+BmsSNhOe8PJuSyFkJfkl2zgngMf4FvyMwlaWN73iUpDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fFh9PDJ617b22QU1PLfeCktJ9Sl8syvia19GQ7QMAqQ=;
 b=MEboTqdUlggTZLdmwjOLOtDHCJdSrKW9Frlmb1L3EXTZzPgORddab+m62mOdKumTZrsI7H6JQlnKD3ENGPqt/+g7ReWadnaAFNwIEZZuD4SDHF5gn70apwwMMsrW3r7SvLVRwGPC72zvGDoiJ8gHuz0SFQ7q5JlL4B71eHkc9TUfrqCAYrydJTrt48g+hLd2p7Z3yFoX4skVZxQ4XWWOrrFgGkIi+ZsqJg6tN5XBBxeWNGawCLtXLqWJEj4SDQ05ihkEogREH9V6LNkYlrRkaftbG9Z7F3I1l8YgWXZzU7TjaeCzBl+elJDLiSNDJxMknO5liypeR7FOhsQaEoxREA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fFh9PDJ617b22QU1PLfeCktJ9Sl8syvia19GQ7QMAqQ=;
 b=2HrB4Cc95bR8D8kp6+439x1kBMJgNE5UzTfrC/zZGuBtgD8VKx8EMvUeozaine/1qEFjNHEmdC/WlNjrI5GAxjx3OT/I6Ubc/nKZiM2OF38Ob9ND/zKAlGU7W2EXWxoQb8NhyQkBsDN2xNTFzlVZSewezAF6n4UUpwIei8M3ryE=
Received: from MW2PR2101CA0013.namprd21.prod.outlook.com (2603:10b6:302:1::26)
 by DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5525.11; Wed, 17 Aug 2022 15:06:41 +0000
Received: from CO1NAM11FT091.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::3d) by MW2PR2101CA0013.outlook.office365.com
 (2603:10b6:302:1::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.4 via Frontend
 Transport; Wed, 17 Aug 2022 15:06:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT091.mail.protection.outlook.com (10.13.175.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5546.7 via Frontend Transport; Wed, 17 Aug 2022 15:06:41 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 17 Aug
 2022 10:06:40 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 17 Aug
 2022 08:06:40 -0700
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Wed, 17 Aug 2022 10:06:32 -0500
From:   Nipun Gupta <nipun.gupta@amd.com>
To:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
        <eric.auger@redhat.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <puneet.gupta@amd.com>,
        <song.bao.hua@hisilicon.com>, <mchehab+huawei@kernel.org>,
        <maz@kernel.org>, <f.fainelli@gmail.com>,
        <jeffrey.l.hugo@gmail.com>, <saravanak@google.com>,
        <Michael.Srba@seznam.cz>, <mani@kernel.org>, <yishaih@nvidia.com>,
        <jgg@ziepe.ca>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <okaya@kernel.org>, <harpreet.anand@amd.com>,
        <nikhil.agarwal@amd.com>, <michal.simek@amd.com>, <git@amd.com>,
        Nipun Gupta <nipun.gupta@amd.com>
Subject: [RFC PATCH v2 6/6] driver core: add compatible string in sysfs for platform devices
Date:   Wed, 17 Aug 2022 20:35:42 +0530
Message-ID: <20220817150542.483291-7-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220817150542.483291-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95b58235-45c0-4cd4-8875-08da80621772
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cjMtkrE2JUlt4UKpUUkRZGXH6jKmhiDetmjhr7jwBJMesPulQvyBNsBDSm/vv19Zlq2la9cyn0bxxiR6id1UfPP5gTiMtWZmy48CbzENXuLcMXIoaVavHFxaIVZqBNRR71Wt2MO0m20Z41Rmg62OuCWcfzzPyUIFLV0tBNuiTKROvnvVsvqYqEJaqa2HglsvS6FHqBvL6lvdpyCb0h1fSdjUoUBQRgusorKYjJGJUAQpEijrM4v3wZEaUPuK+8UjKeW4BsyHxqNIJ2xpHYUPS8/H/0UtyI2HlzYpDvdpkqtNrf5VSPz3xGPxtvT2brn6yA+7b9r9mCEftqkydTmKjDvxU324erfTo59I39WMSEAAczqvc8G6oC7X07a+KumDux/XPt7Jtdv8ol0sJ9rfa3yPubeDl707KcRaC/X4kOgPmA7FJcNLWDZ1ImwA3p0jS20l+AyG2FErpbMeQ8n6Geskj0kVR5R0nmr7dLUyif6y5+fYjbxL9iknti/ZJ0lGYmdWlS5kFxAKEQlb9kIFi27KfG6rzbZg9AS2h3XnXgApOEnJMMVMe7IyMcFPBvCByW750PWu55ytSlY9X/H0Tds5nF8R5SY/hkHHQKaeIYX/xx51/jJS2TzAhKxzqVuH/rIUCxXThf2e9wwaLupY05pq5jwD30XJtvTs2rWvlSMLQeX0mrUgQUHz2gGyZ+IssrGX+lnhnCqhQbb8Mfc1UcP8TZ03Ii3x2LkUnNAptEgA3EnIwWD3WTGNZKXCWQHp+B7xQ/eqJ/Sb9I3zH//nXH6RKa4tl3i+h+dKGpbVRnxBZlFCWN1Fyn0ju5fpJxSJIRZCB74P+lBF8rG7/MdIsFC1eL7L9ZLlKFSH1Rj+FVIBixcqZNBHpS2va5SxRZxbGsMkPS4iS7hECy9J1ULpRg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(376002)(136003)(346002)(46966006)(40470700004)(36840700001)(54906003)(47076005)(336012)(1076003)(2616005)(40480700001)(6666004)(186003)(86362001)(36860700001)(36756003)(26005)(110136005)(40460700003)(82310400005)(316002)(4326008)(426003)(41300700001)(70206006)(44832011)(70586007)(478600001)(5660300002)(2906002)(81166007)(921005)(82740400003)(8676002)(356005)(8936002)(7416002)(36900700001)(83996005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 15:06:41.3003
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b58235-45c0-4cd4-8875-08da80621772
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT091.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6048
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This change adds compatible string for the platform based
devices.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---
 Documentation/ABI/testing/sysfs-bus-platform |  8 +++++++
 drivers/base/platform.c                      | 23 ++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-platform b/Documentation/ABI/testing/sysfs-bus-platform
index c4dfe7355c2d..d95ff83d768c 100644
--- a/Documentation/ABI/testing/sysfs-bus-platform
+++ b/Documentation/ABI/testing/sysfs-bus-platform
@@ -54,3 +54,11 @@ Description:
 		Other platform devices use, instead:
 
 			- platform:`driver name`
+
+What:		/sys/bus/platform/devices/.../compatible
+Date:		August 2022
+Contact:	Nipun Gupta <nipun.gupta@amd.com>
+Description:
+		compatible string associated with the device. This is
+		a read only and is visible if the device have "compatible"
+		property associated with it.
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 51bb2289865c..94c33efaa9b8 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -1289,10 +1289,25 @@ static ssize_t driver_override_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(driver_override);
 
+static ssize_t compatible_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
+{
+	const char *compat;
+	int ret;
+
+	ret = device_property_read_string(dev, "compatible", &compat);
+	if (ret != 0)
+		return 0;
+
+	return sysfs_emit(buf, "%s", compat);
+}
+static DEVICE_ATTR_RO(compatible);
+
 static struct attribute *platform_dev_attrs[] = {
 	&dev_attr_modalias.attr,
 	&dev_attr_numa_node.attr,
 	&dev_attr_driver_override.attr,
+	&dev_attr_compatible.attr,
 	NULL,
 };
 
@@ -1300,11 +1315,19 @@ static umode_t platform_dev_attrs_visible(struct kobject *kobj, struct attribute
 		int n)
 {
 	struct device *dev = container_of(kobj, typeof(*dev), kobj);
+	const char *compat;
+	int ret;
 
 	if (a == &dev_attr_numa_node.attr &&
 			dev_to_node(dev) == NUMA_NO_NODE)
 		return 0;
 
+	if (a == &dev_attr_compatible.attr) {
+		ret = device_property_read_string(dev, "compatible", &compat);
+		if (ret != 0)
+			return 0;
+	}
+
 	return a->mode;
 }
 
-- 
2.25.1

