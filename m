Return-Path: <kvm+bounces-53878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 29337B1918C
	for <lists+kvm@lfdr.de>; Sun,  3 Aug 2025 04:49:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 916DD1896DDD
	for <lists+kvm@lfdr.de>; Sun,  3 Aug 2025 02:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22BD9155C88;
	Sun,  3 Aug 2025 02:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P9rS2Ben"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2075.outbound.protection.outlook.com [40.107.212.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCE0186E2E
	for <kvm@vger.kernel.org>; Sun,  3 Aug 2025 02:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754189328; cv=fail; b=sVqRtsOvD+rLVwAduMumIFXCwa69NlxJgTpUo0RZ1t0WOOijasmM4rZtiVDL11KtUDDWDBElD1z3dEfLJ7zpBhSY3IHL46ffLj1PT8Tycf8xIIXt84aVUoDCLHM3DCXK342E5sNOMw8PPa8IYFmt03LIfKKgpkbY/aWln9dY0GA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754189328; c=relaxed/simple;
	bh=AgrLXQTKSgiJuGZEmym7vD4sCUDA5pb38BF8307Yv30=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tSZOOBnUgxSBmiM0EGIWRwxlDESlW2a1MvZwpCAaMS0OgoplN88CUXvL3XPdhLUY0eeTDDyY22wB8qjnsaOvn8GHVWDwl+8MNRVNAYcRhC+zM1Q9Ql7UA24e6xXIvjJYkZgwSgYWCwF9/ZlMYQfJYepNZHnlRGkEdHfGPujDKFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P9rS2Ben; arc=fail smtp.client-ip=40.107.212.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MGnjTM6m0sP/bWRScFocZNfEIq2FZKXjxqJCjjTdlItXc7Pvw3KWQx23jy/+/lfvqZIBKOFkgYCh0Ve6WmaIFSSNRpLm6qXWlhv7aghCagKre7x58dQ0X/yd9AuCJGYbny97peCF/bndsBtal6VLFOR9dwkQAOt1lipeTsP7F/3UKxUGsttePlZsNW6bL14TZ1m+sAun+1Nk+Z/asccILCZgXs3lcFbYkkRGKipJ7KHTXE5khQv/3gItmeQqsKs5xlCprxLTO3CUpNROp4Q5Hp6tH60mMGdxlgnX8vUtc/CePqUrw/XHXPpFt4oEg2i7lKKUmEBxzkoqhAPHiyXXtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y8c80iLi5sI1S5fdamdbijcXr+uqGTSDfmWsrGKf3AI=;
 b=njQdjTPKal7fSHPsMwhZuft1mdryzN+1LZ8A4xdP9k7rs1yZdS4C+XMUlj6rla2hZmEqjWDw1o6eJ/iZQTu5JzgGhzmCqXSPHa+cseF5qCBztXV4MVXyQZGMR+p9AJOw01UoIPozZJO9a6SWzRt2V/1tgRDtIUQ2wety4ReIhD0jx0kLLuigp9hSKj/N7zosz0xW9kbixWi91IMcAFuY8mADPw9q6ZkoXyn9MkVNC0SYGtNLjffqN254m9T3awFQu7wNDJarJ74eSEVQkUlSSpJyU198BCk+hH/tWEyWyZTAlHOMWJojRBLnfeyXaIWeQO2sTBo/hJZ7iOaHW439yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8c80iLi5sI1S5fdamdbijcXr+uqGTSDfmWsrGKf3AI=;
 b=P9rS2BenqwjDoS0pEJAaVewL8hkYabOx+rkmjL01GUij3j0KSIqQIFTkIKpYP7uooQOziFxRWesQtqhwqyAEriFS02yHmAOR72zbewCHrB7gKktaCFYwXuFn8EKJOvf4wJSqglaxsbb46BB4FuLuUQ0jahPREkzKVXLO/X2t/hGyT7pf5tHXqratq2o9imZtgYWE+YosNAHWSv5rM6EuFMUYuLuIuslp2+vwdRaLRcfQ+Nm4fFRJIB2/DI5Fp4DVxFu1FLjS6XIOz9JXlN6FhcH3/3NddG+19lkKn6SYneW1M0zQmrxqcnv50+z8AASVV7YXu6YuIWE3qOmaJpKbqg==
Received: from CH2PR14CA0054.namprd14.prod.outlook.com (2603:10b6:610:56::34)
 by DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.16; Sun, 3 Aug
 2025 02:48:40 +0000
Received: from CH1PEPF0000A34B.namprd04.prod.outlook.com
 (2603:10b6:610:56:cafe::3f) by CH2PR14CA0054.outlook.office365.com
 (2603:10b6:610:56::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.18 via Frontend Transport; Sun,
 3 Aug 2025 02:48:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000A34B.mail.protection.outlook.com (10.167.244.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.8 via Frontend Transport; Sun, 3 Aug 2025 02:48:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 2 Aug
 2025 19:48:03 -0700
Received: from dev.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 2 Aug
 2025 19:47:46 -0700
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <kbusch@kernel.org>, <axboe@fb.com>, <hch@lst.de>, <sagi@grimberg.me>,
	<alex.williamson@redhat.com>, <cohuck@redhat.com>, <jgg@ziepe.ca>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <mjrosato@linux.ibm.com>, <mgurtovoy@nvidia.com>
CC: <linux-nvme@lists.infradead.org>, <kvm@vger.kernel.org>,
	<Konrad.wilk@oracle.com>, <martin.petersen@oracle.com>,
	<jmeneghi@redhat.com>, <arnd@arndb.de>, <schnelle@linux.ibm.com>,
	<bhelgaas@google.com>, <joao.m.martins@oracle.com>, Chaitanya Kulkarni
	<kch@nvidia.com>, Lei Rao <lei.rao@intel.com>
Subject: [RFC PATCH 3/4] nvme: export helpers to implement vfio-nvme lm
Date: Sat, 2 Aug 2025 19:47:04 -0700
Message-ID: <20250803024705.10256-4-kch@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20250803024705.10256-1-kch@nvidia.com>
References: <20250803024705.10256-1-kch@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A34B:EE_|DS0PR12MB7771:EE_
X-MS-Office365-Filtering-Correlation-Id: c7b376ea-877a-4907-46e5-08ddd23840fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4v7YlfdZvlWi0LU6j0isiQeKxnc7ZAIpWohGy/hZj2FrR6ylhS7CC3fye8Hl?=
 =?us-ascii?Q?fjIuK+vQ5C5+Deom3l8LCLsb5vtZaOtnA0Wbm6Y26pKnXFi+KCK2Fz4xlBSL?=
 =?us-ascii?Q?BfZLcroAKhcOQI8huq1GXbaQGaBkJk8ThDWWU7Wl2mHiN0C4uxKY2BpaXELT?=
 =?us-ascii?Q?cEfVmBTt6Lzv+L1SpM7cjy9N1CNmzJjNUoTQgfEdE+hkY5nSTpxsd2gDOyWn?=
 =?us-ascii?Q?TgkX3FizNwRxJuMwH/d8sWoHJ8vcQk3PHg68IQO2Xz7InzLJEUBk1MHFlXyZ?=
 =?us-ascii?Q?tqlydTs/qYoGv9iB/9glmAcCZQzxLecd1iS+B2nUrZ9snhEbtcuzd1jx8p9G?=
 =?us-ascii?Q?IqXOI9WWJCAd5LKXEcoDnC0Z0hZE6xcHNxB3vSjse7Ez2y3hpEkOSxxDMqyL?=
 =?us-ascii?Q?KZ7DQ5mGhHiTWevXxnIn9nEvPDkcofnNSch6MyNKe7s+VhNNaMDGpAF6u0HZ?=
 =?us-ascii?Q?/etjgmlzpryWzcc7W0Msa1cRfCpf2HMil0Qqvzeo+GSSAB6b38EhjCvSL5Sy?=
 =?us-ascii?Q?Zr6bDJc17Gr3JbJe4lfHMd10iiYbzzY5NQrwvvHBMDbeOs9Bk/ZSWxcOGl2+?=
 =?us-ascii?Q?cVS/4VPOW/UUGJsIqb9BOkARz34TeHKi0mPCppfP8fmTeBs6QW3/aZSa8G0w?=
 =?us-ascii?Q?8Nazl1M3rJ/J6XI6Gd0NEwbAItfaypBW2bR5uUnkQrGWqv8lZa/4DB8cKVtJ?=
 =?us-ascii?Q?1uXiXNGTFwzuwKSDNMgiZkabTNwtvUtV2H7jAPG5PcxerjrhgRBP0jzmFgQa?=
 =?us-ascii?Q?k/aKZoS73woQKBwC0XefqxOxw9OFuhcXakXp6qYDQXULadecukzdzAHXmBXh?=
 =?us-ascii?Q?IFyN31Xr7A4YVKdJ2HudUcxbS6KN+TYEYroG5IuJpV7RhS1H+2HizR4/DRDd?=
 =?us-ascii?Q?/8yZegTc0gNc2prumv2xNCYXfGfJ4ywDlCjwFV+hSC0cXaJrpZWUuIcUtPRh?=
 =?us-ascii?Q?HHwmkFKELdgr/pIyfd6Lf0wGLMisEEKURZae6CNxSvTYSCMSWBJDRKUUzVZb?=
 =?us-ascii?Q?RGSmUDXKjNn9VimOSUIWGLz3LyNc0uy+sWLBSc/zb8ISZj5Fl+yBOO00eEMq?=
 =?us-ascii?Q?c7DV/+12B1vD6+2YEwxH5frJNhgd1eh/Wx7FcaI3pec/SfhK0HwdGdcnWIYJ?=
 =?us-ascii?Q?DvkaAszkbMlsi2gZQ8y7WeU4LcJTWuYG6yd8R+wwBFzzq6XTNORcMZ5uVnFP?=
 =?us-ascii?Q?2Fu9KTt09uvaYJrY5JHVsfvMO7uC4r1RM0sr/tged7vk1i8KYvGh0eHGMGFf?=
 =?us-ascii?Q?yoDYW9rmTX9aTZXiT+wj+YOlYKaFSyRqeWqYBRid4hht1gJyShEmi4gLrUji?=
 =?us-ascii?Q?KwuaJP2ezLoNDivOvkdTBlHnrcYfOt6RSZ6YFCeosPoJ1HrdBCd3bdfwFUXA?=
 =?us-ascii?Q?npZh1CP/jyvp60386x57znn286OHOU5xuSzRr+RT+fmal6C0S3mr1sNtIMXD?=
 =?us-ascii?Q?Fo+3gDrRtyk9xQUItbXbMrLafhx1m0pDjbLpu2neUteEyYzahVrK5cuA6ewf?=
 =?us-ascii?Q?XBWYMWsjqei7R9yPU8DllyvbGpTQK06nnQ4Bl4IpONLpT5i7haVOUiPe2A?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2025 02:48:39.9540
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7b376ea-877a-4907-46e5-08ddd23840fd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A34B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7771

Export the nvme_error_status() function to allow error status
translation from external modules such as VFIO-based drivers.

Add helper functions in nvme-pci to support virtual function (VF)
command submission and controller ID retrieval:

  - nvme_submit_vf_cmd() submits a synchronous admin command
    from a VF context using the PF's admin queue.
  - nvme_get_ctrl_id() returns the controller ID associated
    with a PCI device.

These changes support VFIO NVMe Live Migration workflows and
infrastructure by enabling necessary low-level admin command access.

Signed-off-by: Lei Rao <lei.rao@intel.com>
Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/host/core.c |  3 ++-
 drivers/nvme/host/nvme.h |  5 +++++
 drivers/nvme/host/pci.c  | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 2445862ac7d4..3620e7cb21d1 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -278,7 +278,7 @@ void nvme_delete_ctrl_sync(struct nvme_ctrl *ctrl)
 	nvme_put_ctrl(ctrl);
 }
 
-static blk_status_t nvme_error_status(u16 status)
+blk_status_t nvme_error_status(u16 status)
 {
 	switch (status & NVME_SCT_SC_MASK) {
 	case NVME_SC_SUCCESS:
@@ -318,6 +318,7 @@ static blk_status_t nvme_error_status(u16 status)
 		return BLK_STS_IOERR;
 	}
 }
+EXPORT_SYMBOL_GPL(nvme_error_status);
 
 static void nvme_retry_req(struct request *req)
 {
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index cfd2b5b90b91..5549c7e3bcd3 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1218,4 +1218,9 @@ static inline bool nvme_multi_css(struct nvme_ctrl *ctrl)
 	return (ctrl->ctrl_config & NVME_CC_CSS_MASK) == NVME_CC_CSS_CSI;
 }
 
+blk_status_t nvme_error_status(u16 status);
+int nvme_submit_vf_cmd(struct pci_dev *dev, struct nvme_command *cmd,
+		       size_t *result, void *buffer, unsigned int bufflen);
+u16 nvme_get_ctrl_id(struct pci_dev *dev);
+
 #endif /* _NVME_H */
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 4cf87fb5d857..b239d38485ee 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3936,6 +3936,40 @@ static struct pci_driver nvme_driver = {
 	.err_handler	= &nvme_err_handler,
 };
 
+u16 nvme_get_ctrl_id(struct pci_dev *dev)
+{
+	struct nvme_dev *ndev = pci_iov_get_pf_drvdata(dev, &nvme_driver);
+
+	return ndev->ctrl.cntlid;
+}
+EXPORT_SYMBOL_GPL(nvme_get_ctrl_id);
+
+int nvme_submit_vf_cmd(struct pci_dev *dev, struct nvme_command *cmd,
+		size_t *result, void *buffer, unsigned int bufflen)
+{
+	struct nvme_dev *ndev = NULL;
+	union nvme_result res = { };
+	int ret;
+
+	ndev = pci_iov_get_pf_drvdata(dev, &nvme_driver);
+	if (IS_ERR(ndev))
+		return PTR_ERR(ndev);
+	ret = __nvme_submit_sync_cmd(ndev->ctrl.admin_q, cmd, &res, buffer,
+					bufflen, NVME_QID_ANY, 0);
+	if (ret < 0)
+		return ret;
+
+	if (ret > 0) {
+		ret = blk_status_to_errno(nvme_error_status(ret));
+		return ret;
+	}
+
+	if (result)
+		*result = le32_to_cpu(res.u32);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nvme_submit_vf_cmd);
+
 static int __init nvme_init(void)
 {
 	BUILD_BUG_ON(sizeof(struct nvme_create_cq) != 64);
-- 
2.40.0


