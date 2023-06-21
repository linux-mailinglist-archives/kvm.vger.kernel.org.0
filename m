Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340F073935E
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjFUX4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjFUXz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:55:59 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2073.outbound.protection.outlook.com [40.107.102.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7981BDC;
        Wed, 21 Jun 2023 16:55:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M5ZkctAjQUQLBUoEH7S3yVVXJD5+hLN1K29MpLbMvAUXJXWidtNtuZhKVTywk84aySrGou0B6OiAvv3MFdbZMPKnsxEDSa8iQQcCWf90+hy+jZCbRxr1HZZ/Eml4DvKxzHqD8deq+IwWJht9/BFbgiWja/0L9GUH5fiUCVJiPigguNQ/pUwulVKkC1sL/wwwP3tO9qL9dUnQSC3aVdXj+VU5/wGXnV9MCDvMXL39U4VHunMBquq9mh8U1bI7CmnFLtj2KyXsIcXc+m9WUlrDRfaefOAW5eVf2sTeXZvMPfR4c8wwWQ6dJa9k+cx8LgsJMIfE28RaxID9SRjC8oaKUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Es4QkeoqKK9Q+iYRHWZ9ALKb26xop5VvYjHJNvJR12M=;
 b=Oxei3InNcG/JkngoYzBQFiXBmpAJ/1IXcZGVq1CMdwRTewNLV1D5zTxM757Uu/8kvNSxzMVH1ndO1qFi1jMXZ0R4PCeeWksu551HcWbCLEhMaqjNkbWEBq0uE53/yd7XNlNnCVS+P6k+C/+8im5w8EfS/K9+vmirHfINzQc+EDgq8/SnKyMq9UR1lSW4UfHSHqHDe0hGZUNd11td/sSUhwSV4SfkWYC92pvdXygWgaBo6N4LFxiYfEAjVW0jYGP99bE62IEF8Ovo4f659xFlGDLbGW78tJMllXLzeZs5YwfXeOGezGg6vrN2PqgHo+GM2XqcNxDMorBaWRmVd1DxGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Es4QkeoqKK9Q+iYRHWZ9ALKb26xop5VvYjHJNvJR12M=;
 b=w30vbHQd0V9vKom3mVkyoegeKyyxSWoJc7JpQKHdthOC2BRKVJ7r/DgGClQNQAVjCUkTGf8LhDHdfg8v9SdGaCSN4h2CgW7V05C0WhKchQGfLeFi+XAP/R197e6pXGsMx6ncghmiCbunrEoOm4/O8DpMc8xutvfuMdn2D5hBZdA=
Received: from CY5PR15CA0045.namprd15.prod.outlook.com (2603:10b6:930:1b::23)
 by SA0PR12MB4560.namprd12.prod.outlook.com (2603:10b6:806:97::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Wed, 21 Jun
 2023 23:55:56 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:930:1b:cafe::5e) by CY5PR15CA0045.outlook.office365.com
 (2603:10b6:930:1b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23 via Frontend
 Transport; Wed, 21 Jun 2023 23:55:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.21 via Frontend Transport; Wed, 21 Jun 2023 23:55:55 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 21 Jun
 2023 18:55:53 -0500
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
Subject: [RFC PATCH 12/21] iommu/amd: Introduce AMD vIOMMU-specific UAPI
Date:   Wed, 21 Jun 2023 18:54:59 -0500
Message-ID: <20230621235508.113949-13-suravee.suthikulpanit@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|SA0PR12MB4560:EE_
X-MS-Office365-Filtering-Correlation-Id: 65208709-462b-44ff-9034-08db72b30dc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ky6UDFtn0ptih9xO7AaC5pH083ReWvflDIojiTAbYoWtzrFM5V45f/DwauxL2imB+Loy5Qdf3JWo3MqWgajdX65kSLpeP7k20cWfTZXxxQsjcproKInUTerGNZl/UQemiuPP0qI3t21AkV8ZP5JRqjeCnaOEi2HWV2Qq+2guaqYsGyYajTWXCI8eZd/yHIUtZeQ8cv35b6j8d3qtKP29/PD3KWWIZPRmKv6bJDKwpjxPKvRR1FXwAGPxlDam+E4cnOs35fcYoDQVyWSLA6/rAfbcZk9eZsMfMH9MYyWeEatiy5t/6i3rZu6o5GVP0NmqXOtqmOgCzP6Ij5CzkxQmKBouOuq2ekwyP2WQeNbUDzqflds3vFexyn95B1bBdXnWPmJ2/Gj5VQqnB6c8YazsFwJa5l2CnPiRl7g+LQ/SGfer73ZGBtaAvU/YosWUpPtUjhkm9qRMnOojVbGJ/cTe+pT3OlpGc+koN1pRIysH0d74xuxfBbftU8Z6THGn378TefzIiaOHxNQ0pZeINkhk35rh76NUOy/Ye5gBxZQzwkDlzic2WyJF7vZPbJpwRLgq6ohKadoJe3kJ+Zkws/KyXRdQAwdy/Cwm+yn5LtbKq/7TG0J8nsprwykyU0AgMwrnJrku3ELtHPvsp2Jg64yLLmfvdg/ryorQM8WWYmHPrQIE+6quats8juhJ9khk/3eoU7aBER9ERDK5MrZm9XiRl60hfGps9Rtn+dpnGPLMRDzqooCd6s2hpeC5jSwz7H3HdFNvQ0Y9kGPV6nhpcxA7MtZ8kSd41R6pnWlunYz90E+ivpi9Fc/WJbVOMixIr5Bu
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(396003)(346002)(136003)(451199021)(36840700001)(40470700004)(46966006)(54906003)(110136005)(478600001)(4326008)(26005)(16526019)(186003)(1076003)(70586007)(2906002)(82310400005)(7696005)(41300700001)(7416002)(8936002)(70206006)(8676002)(44832011)(5660300002)(316002)(82740400003)(356005)(81166007)(2616005)(86362001)(36756003)(40480700001)(47076005)(426003)(336012)(83380400001)(36860700001)(40460700003)(71600200004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:55:55.7923
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65208709-462b-44ff-9034-08db72b30dc8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4560
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

To handle various operations necessary for setting up the vIOMMU hardware.
These operations are specific to AMD hardware.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 include/uapi/linux/amd_viommu.h | 145 ++++++++++++++++++++++++++++++++
 1 file changed, 145 insertions(+)
 create mode 100644 include/uapi/linux/amd_viommu.h

diff --git a/include/uapi/linux/amd_viommu.h b/include/uapi/linux/amd_viommu.h
new file mode 100644
index 000000000000..f4a91ecd5dc2
--- /dev/null
+++ b/include/uapi/linux/amd_viommu.h
@@ -0,0 +1,145 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * AMD Hardwaer Accelerated Virtualized IOMMU (HW-vIOMMU)
+ *
+ * Copyright (c) 2023, Advanced Micro Devices, Inc.
+ *
+ */
+#ifndef _UAPI_AMD_VIOMMU_H_
+#define _UAPI_AMD_VIOMMU_H_
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+/**
+ * The ioctl interfaces in this file are specific for AMD HW-vIOMMU.
+ * They are an extension of extend the IOMMUFD ioctl interfaces.
+ * Please see include/uapi/linux/iommufd.h for more detail.
+ */
+#include <linux/iommufd.h>
+
+enum iommufd_viommu_cmd {
+	IOMMUFD_VIOMMU_CMD_BASE = 0x60,
+	IOMMUFD_CMD_IOMMU_INIT = IOMMUFD_VIOMMU_CMD_BASE,
+	IOMMUFD_CMD_IOMMU_DESTROY,
+	IOMMUFD_CMD_DEVICE_ATTACH,
+	IOMMUFD_CMD_DEVICE_DETACH,
+	IOMMUFD_CMD_DOMAIN_ATTACH,
+	IOMMUFD_CMD_DOMAIN_DETACH,
+	IOMMUFD_CMD_MMIO_ACCESS,
+	IOMMUFD_CMD_CMDBUF_UPDATE,
+};
+
+/**
+ * struct amd_viommu_iommu_info - ioctl(VIOMMU_IOMMU_[INIT|DESTROY])
+ * @size: sizeof(struct amd_viommu_iommu_info)
+ * @iommu_id: PCI device ID of the AMD IOMMU instance
+ * @gid: guest ID
+ *
+ * Initialize and destroy AMD HW-vIOMMU instances for the specified
+ * guest ID.
+ */
+struct amd_viommu_iommu_info {
+	__u32	size;
+	__u32	iommu_id;
+	__u32	gid;
+};
+#define VIOMMU_IOMMU_INIT	_IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOMMU_INIT)
+#define VIOMMU_IOMMU_DESTROY	_IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOMMU_DESTROY)
+
+/**
+ * struct amd_viommu_dev_info - ioctl(VIOMMU_DEVICE_[ATTACH|DETACH])
+ * @size: sizeof(struct amd_viommu_dev_info)
+ * @iommu_id: PCI device ID of the AMD IOMMU instance
+ * @gid: guest ID
+ * @hdev_id: host PCI device ID
+ * @gdev_id: guest PCI device ID
+ * @queue_id: guest PCI device queue ID
+ *
+ * Attach / Detach PCI device to a HW-vIOMMU instance, and program
+ * the IOMMU Device ID mapping table for the specified guest.
+ */
+struct amd_viommu_dev_info {
+	__u32	size;
+	__u32	iommu_id;
+	__u32	gid;
+	__u16	hdev_id;
+	__u16	gdev_id;
+	__u16	queue_id;
+};
+
+#define VIOMMU_DEVICE_ATTACH	_IO(IOMMUFD_TYPE, IOMMUFD_CMD_DEVICE_ATTACH)
+#define VIOMMU_DEVICE_DETACH	_IO(IOMMUFD_TYPE, IOMMUFD_CMD_DEVICE_DETACH)
+
+/**
+ * struct amd_viommu_dom_info - ioctl(VIOMMU_DOMAIN_[ATTACH|DETACH])
+ * @size: sizeof(struct amd_viommu_dom_info)
+ * @iommu_id: PCI device ID of the AMD IOMMU instance
+ * @gid: guest ID
+ * @hdev_id: host PCI device ID
+ * @gdev_id: guest PCI device ID
+ * @gdom_id: guest domain ID
+ *
+ * Attach / Detach domain of a PCI device to a HW-vIOMMU instance, and program
+ * the IOMMU Domain ID mapping table for the specified guest.
+ */
+struct amd_viommu_dom_info {
+	__u32	size;
+	__u32	iommu_id;
+	__u32	gid;
+	__u16	gdev_id;
+	__u16	gdom_id;
+};
+
+#define VIOMMU_DOMAIN_ATTACH	_IO(IOMMUFD_TYPE, IOMMUFD_CMD_DOMAIN_ATTACH)
+#define VIOMMU_DOMAIN_DETACH	_IO(IOMMUFD_TYPE, IOMMUFD_CMD_DOMAIN_DETACH)
+
+/**
+ * struct amd_viommu_mmio_data- ioctl(VIOMMU_MMIO_ACCESS)
+ * @size: sizeof(struct amd_viommu_mmio_data)
+ * @iommu_id: PCI device ID of the AMD IOMMU instance
+ * @gid: guest ID
+ * @offset: specify MMIO offset
+ * @value: specify MMIO write value or retrieving MMIO read value
+ * @mmio_size: specify MMIO size
+ * @is_write: specify MMIO read (0) / write (1)
+ *
+ * - Trap guest IOMMU MMIO write to program HW-vIOMMU for the specified
+ *   guest.
+ * - Trap guest IOMMU MMIO read to emulate return value for the specified
+ *   guest.
+ */
+struct amd_viommu_mmio_data {
+	__u32	size;
+	__u32	iommu_id;
+	__u32	gid;
+	__u32	offset;
+	__u64	value;
+	__u32	mmio_size;
+	__u8	is_write;
+};
+
+#define VIOMMU_MMIO_ACCESS	_IO(IOMMUFD_TYPE, IOMMUFD_CMD_MMIO_ACCESS)
+
+/**
+ * struct amd_viommu_cmdbuf_data - ioctl(VIOMMU_CMDBUF_UPDATE)
+ * @size: sizeof(struct amd_viommu_cmdbuf_data)
+ * @iommu_id: PCI device ID of the AMD IOMMU instance
+ * @gid: guest ID
+ * @gcmdbuf_size: guest command buffer size
+ * @hva: host virtual address for the guest command buffer
+ *
+ * Trap guest command buffer initialization to setup HW-vIOMMU command buffer
+ * for the specified guest.
+ */
+struct amd_viommu_cmdbuf_data {
+	__u32	size;
+	__u32	iommu_id;
+	__u32	gid;
+	__u32	cmdbuf_size;
+	__u64	hva;
+};
+
+#define VIOMMU_CMDBUF_UPDATE	_IO(IOMMUFD_TYPE, IOMMUFD_CMD_CMDBUF_UPDATE)
+
+#endif
-- 
2.34.1

