Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D687973935D
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjFUX4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjFUXz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:55:59 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545B11BD1;
        Wed, 21 Jun 2023 16:55:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0O2U0605ZDGGWcIgrfzdEl94LGHf/CmOtu3b9MOLDEtAT/CbyLXXyGClB6ZWAWL6eS3HrYQybSMYRcMMWUXMgD+w2Qe7joFT1SSQiqsY25vSV5zrVzH53O+PcyFfADgCrm3t01FoOJOjpVcxI6OifN7s6PVeMh6ni+dNHpFFBsv1T3D5u2y1LVwK38u2Mr/LiWk16vw8UtbPe6lHpziNsthENRlo//dWeVLN9VEU+aEMROAdX3v4jEJ7d33iNTCvuTHqg1QYCZj6t3ARSUwY+wWEglUkGYuqi/EB/DydEUc27X8AICoUdlvfrj4OZ49fyTOmb3DLYZscKyq2eg16w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iNi76l97aG+cBmxW0ckshX+65t8V4Tsn+yZofetA6J0=;
 b=IpgEgjvfBPoP2hisnZS2QG/8pAmcoLS3g1ZlIp0Ky0W6OpRFtP3LpuZ9AiKV/rftoxqng2zFE3jlNO9YV1rh0N1M4OGGDC7tRyxOwmYYisD3GsdJzm2IJ2vn96gLWU+7SO2X6OE2DBfMHZEoQuWjx8fwVaxJUd9lsEDW3FFKLevFwkZ8EvMATpcRCtFpWiewJNcUx0fMZvKSt1+uMVvJN1LVsmHUKGcQ1RK6imxiaCJGGWYiSPhv64nk6aCD2bsUc7snBqFfgpA4DDG1ZwD4bpiMZdJsAE5cP8ZnaKWcTpvrHoPjqIrmE7C35o6jP60w5CGVzizKAN2ltJRIFlmE8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNi76l97aG+cBmxW0ckshX+65t8V4Tsn+yZofetA6J0=;
 b=VvH7gKy7SpWAkHREpxkmwjrX2h3XRTvMSQWWcw+qXy4Oadn9SnAt3M6G1h7jPJ7OvPG1DwgUh9vmM0Xkiz3O34wAwRdKk4e58sxnS44X4XORGsI0RbhBUT8KmD+8eDQ8VVqb21KJR4GytiwT7ZFSvkHEorenqJQ59OZG1wZQQEs=
Received: from CY5PR15CA0050.namprd15.prod.outlook.com (2603:10b6:930:1b::16)
 by CY8PR12MB7337.namprd12.prod.outlook.com (2603:10b6:930:53::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Wed, 21 Jun
 2023 23:55:54 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:930:1b:cafe::68) by CY5PR15CA0050.outlook.office365.com
 (2603:10b6:930:1b::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23 via Frontend
 Transport; Wed, 21 Jun 2023 23:55:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.21 via Frontend Transport; Wed, 21 Jun 2023 23:55:54 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 21 Jun
 2023 18:55:51 -0500
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
Subject: [RFC PATCH 10/21] iommu/amd: Introduce vIOMMU-specific events and event info
Date:   Wed, 21 Jun 2023 18:54:57 -0500
Message-ID: <20230621235508.113949-11-suravee.suthikulpanit@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|CY8PR12MB7337:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a412335-fbd6-45bd-5fd5-08db72b30cd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xa18HEMfdNdkm+uq4BS9+eAkt9R6wUNH//HHw4LsXJYrwRnMfP0nABxVHjdDhazqu8Hth09N95IS1pQIH9z2aigxeLFa+F9/yBokBYN5PfgJWUJzCLY8tHuyntZCIR3vUkl5O4UX6y0KqK1dYYIeozoVkWpd3Y5wUNi2mBVYB8DZuh9i6K1Or3CwdC+6ZQogOdZLi7frjpU7vuRV9fByrYo4f1OCExSkKrffdrZNlCSI87s74TwatCPiakzKLdWhy2x8w/+y1qYeH3Jp4YuM3xfY8Z9z0+2lniV/pP5O3RuTo9C5/q9VcG+msLgjmSh7GDSU6w7DHvDZ4BS+7SlMv9wnkMuUhd+4OizGUMmIdDaXw0qtdWwwKhNkV1UwF/UW4E/IbBpSvAbbPyW412aM8aO5DcZTCJQgj/aFh9AL4AxIvnpl3V/jAckLrN84N45gQHkWvPMgkuvcv25Ck8/CiU7nRhIg8uOr8WkkpxCKUeCFlZNMMMZHJjJN+B7VNLIRJHZ/odhVjyuejCPIlXzj8gMc2ad3pJL3mCtqBeMgjnoSDLsM1ZTNuiyjfLdcBYQBWetYBB2jZ/7VinkY8pwGPg1zKnA1OyOEbuLkQe2we9GXJ66m1O+3K0fzQpoTEJdNXYP/OsDCv5IyajFp84Hjana2lJ5VHsvmefPGc/beZwb/eDmyxiSZyh6L4UsWZmd3mM8PUxodsj+zja1GXtWnQYtydbInD5ncVoTKNkZ6FwSR0PsrpcwYt8YFlRmHP0/eduKAFwTuaqHTzSGFrLZQrA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199021)(40470700004)(36840700001)(46966006)(54906003)(7696005)(478600001)(110136005)(70206006)(70586007)(16526019)(26005)(186003)(1076003)(2906002)(82310400005)(8676002)(4326008)(41300700001)(5660300002)(44832011)(8936002)(7416002)(316002)(356005)(81166007)(82740400003)(86362001)(36756003)(40460700003)(47076005)(336012)(83380400001)(2616005)(36860700001)(40480700001)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:55:54.1986
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a412335-fbd6-45bd-5fd5-08db72b30cd5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7337
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

Adding support for new vIOMMU events:
  * Guest Event Fault event
  * vIOMMU Hardware Error event

Also, adding support for the additional vIOMMU related flags
in existing events.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/amd_iommu_types.h |  3 ++
 drivers/iommu/amd/iommu.c           | 58 ++++++++++++++++++++++-------
 2 files changed, 48 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 8830f511bee4..d832e0c36a21 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -145,6 +145,9 @@
 #define EVENT_TYPE_IOTLB_INV_TO	0x7
 #define EVENT_TYPE_INV_DEV_REQ	0x8
 #define EVENT_TYPE_INV_PPR_REQ	0x9
+#define EVENT_TYPE_GUEST_EVENT_FAULT	0xb
+#define EVENT_TYPE_VIOMMU_HW_ERR	0xc
+
 #define EVENT_TYPE_RMP_FAULT	0xd
 #define EVENT_TYPE_RMP_HW_ERR	0xe
 #define EVENT_DEVID_MASK	0xffff
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 4a42af85664e..efced59ba8a5 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -541,7 +541,7 @@ static void amd_iommu_report_rmp_fault(struct amd_iommu *iommu, volatile u32 *ev
 
 static void amd_iommu_report_page_fault(struct amd_iommu *iommu,
 					u16 devid, u16 domain_id,
-					u64 address, int flags)
+					u64 address, int flags, u8 vflags)
 {
 	struct iommu_dev_data *dev_data = NULL;
 	struct pci_dev *pdev;
@@ -576,13 +576,13 @@ static void amd_iommu_report_page_fault(struct amd_iommu *iommu,
 		}
 
 		if (__ratelimit(&dev_data->rs)) {
-			pci_err(pdev, "Event logged [IO_PAGE_FAULT domain=0x%04x address=0x%llx flags=0x%04x]\n",
-				domain_id, address, flags);
+			pci_err(pdev, "Event logged [IO_PAGE_FAULT domain=0x%04x address=0x%llx flags=0x%04x vflags=%#x]\n",
+				domain_id, address, flags, vflags);
 		}
 	} else {
-		pr_err_ratelimited("Event logged [IO_PAGE_FAULT device=%04x:%02x:%02x.%x domain=0x%04x address=0x%llx flags=0x%04x]\n",
+		pr_err_ratelimited("Event logged [IO_PAGE_FAULT device=%04x:%02x:%02x.%x domain=0x%04x address=0x%llx flags=0x%04x vflags=%#x]\n",
 			iommu->pci_seg->id, PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-			domain_id, address, flags);
+			domain_id, address, flags, vflags);
 	}
 
 out:
@@ -618,28 +618,41 @@ static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
 	}
 
 	if (type == EVENT_TYPE_IO_FAULT) {
-		amd_iommu_report_page_fault(iommu, devid, pasid, address, flags);
+		u8 vflags = (event[0] >> 27) & 0x1F;
+
+		amd_iommu_report_page_fault(iommu, devid, pasid, address, flags, vflags);
 		return;
 	}
 
 	switch (type) {
 	case EVENT_TYPE_ILL_DEV:
-		dev_err(dev, "Event logged [ILLEGAL_DEV_TABLE_ENTRY device=%04x:%02x:%02x.%x pasid=0x%05x address=0x%llx flags=0x%04x]\n",
+	{
+		u8 vflags = (event[0] >> 27) & 0x1F;
+
+		dev_err(dev, "Event logged [ILLEGAL_DEV_TABLE_ENTRY deice=%04x:%02x:%02x.%x pasid=0x%05x address=0x%llx flags=0x%04x vflags=%#x]\n",
 			iommu->pci_seg->id, PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-			pasid, address, flags);
+			pasid, address, flags, vflags);
 		dump_dte_entry(iommu, devid);
 		break;
+	}
 	case EVENT_TYPE_DEV_TAB_ERR:
-		dev_err(dev, "Event logged [DEV_TAB_HARDWARE_ERROR device=%04x:%02x:%02x.%x "
-			"address=0x%llx flags=0x%04x]\n",
+	{
+		u8 vflags = (event[0] >> 27) & 0x1F;
+
+		dev_err(dev, "Event logged [DEV_TAB_HARDWARE_ERROR device=%04x:%02x:%02x.%x address=%#llx flags=%#04x vlfags=%#x]\n",
 			iommu->pci_seg->id, PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-			address, flags);
+			address, flags, vflags);
 		break;
+	}
 	case EVENT_TYPE_PAGE_TAB_ERR:
-		dev_err(dev, "Event logged [PAGE_TAB_HARDWARE_ERROR device=%04x:%02x:%02x.%x pasid=0x%04x address=0x%llx flags=0x%04x]\n",
+	{
+		u8 vflags = (event[0] >> 27) & 0x1F;
+
+		dev_err(dev, "Event logged [PAGE_TAB_HARDWARE_ERROR device=%04x:%02x:%02x.%x pasid=0x%04x address=0x%llx flags=0x%04x vflags=%#x]\n",
 			iommu->pci_seg->id, PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-			pasid, address, flags);
+			pasid, address, flags, vflags);
 		break;
+	}
 	case EVENT_TYPE_ILL_CMD:
 		dev_err(dev, "Event logged [ILLEGAL_COMMAND_ERROR address=0x%llx]\n", address);
 		dump_command(address);
@@ -671,6 +684,25 @@ static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
 			iommu->pci_seg->id, PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 			pasid, address, flags, tag);
 		break;
+	case EVENT_TYPE_GUEST_EVENT_FAULT:
+	{
+		u8 gid = event[1] & 0xFFFF;
+		u8 vflags = (event[0] >> 27) & 0x1F;
+
+		dev_err(dev, "Event logged [GUEST_EVENT_FAULT gid=#%x flags=0x%04x vflags=%#x]\n",
+			gid, flags, vflags);
+		break;
+	}
+	case EVENT_TYPE_VIOMMU_HW_ERR:
+	{
+		u16 gid = event[0] & 0xFFFF;
+		u8 src = (event[0] >> 16) & 0x3;
+		u8 vflags = (event[0] >> 27) & 0x1F;
+
+		dev_err(dev, "Event logged [VIOMMU_HW_ERR gid=%#x address=%#llx src=%#x flags=%#x vflags=%#x]\n",
+			gid, address, src, flags, vflags);
+		break;
+	}
 	default:
 		dev_err(dev, "Event logged [UNKNOWN event[0]=0x%08x event[1]=0x%08x event[2]=0x%08x event[3]=0x%08x\n",
 			event[0], event[1], event[2], event[3]);
-- 
2.34.1

