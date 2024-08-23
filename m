Return-Path: <kvm+bounces-24914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B74395CDF4
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:32:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 111CE1C22063
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE557186E5F;
	Fri, 23 Aug 2024 13:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wU8tEivf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710E518661E;
	Fri, 23 Aug 2024 13:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419930; cv=fail; b=WPwvT2dOou1iaYApW2aAy2YAlsxcwWB3pI9v4SirNQhzQJofVSSvxp56FUWQ71DeJQFVtCPX3LObKdlULADf+byxIBxp99VuS6RtaprVb+BIajD4xRBjHfAMuFWLCeIPhugvJ7lKdAXumi+l2yfCb9QFubYeq17aLywdekxIh6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419930; c=relaxed/simple;
	bh=gpFgV2h2RZZkmp5vz8NZkgLisTzYr3SiwrtT5CC5iLc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WFwZ4U+xrCHF1cPd1PtbRBVQHTNEpaXt7cuEukSAUR9RD7zPzL7p6bEeBOItldFziEfX3IB4zApGXcRLTRBsxVsi1kN2u/fWDYhnk+KqtZ7qC7A/EBtj0BW0rojUEWgf6xI4cZXGN8280ckqgCXFR4b2vcvXey+J7/54ZuTI8Z0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wU8tEivf; arc=fail smtp.client-ip=40.107.94.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BqB374F+jjvmkVfIACeLoU1siToCb1F5D2kxoj3oHcSY6plBEk61y3+/RXPP4wOkVtq7JEjzNG6aQf27So6wuX95dOrurfUyrn2XLXWnHAoR6KgmTPESp/A+avS9dFgkxfTCYDWXuzJiupi/02Ro7sK3rByDkGvAOeCkXtqrQ/tEKugkagqBBclZ1LinSMIUB387b52Lj6I5YqDV0GWyLAXbV1tGd72dCZz67rtABCyQdIQGkSV04uc2JpxIQxZOP9AxYPxZPMNmwC5zxaLCjR5DdDMtCHAzm5oaFWyfg1ZFSdm5GXLK4FzLIwTKpVHv6I56Ptnr21Y3M26xH2zCIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xm5saKQT8jzFU7WuGTEk01UPQZ7xHjgNXipj6LFIXY8=;
 b=KIC5xen9mZPtpFf3RfTz8mhy7re3sQ8pFumFgVc/Q450GbU3nVkZDl8XOQSJFiT8baDDK5h9D7JoULmD2OP8kUnyw0d9YnyxhB0InHy5ouGSOAo4B/uaNTld4MF5Yu52VByHnNAfhdYyOFbEDOMjE15WG15gYyJeSjDw6Q8Hx7I9GNz0h6RZUu380PkvqIiHvr/8yjUagRx5hK5LH/80AGfXNRbI9lMIUhuE/CY3oFIcT0PpslFAYR1nI/Qkk0uiMOyOcmsa0kYllNRXi0OK6gOvC2Mv3JGSPIMGJOGgPVWJWG1CuQ2wODC9Y2ZpiGDfgoaY4oYsuFcHZRO3OTZrcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xm5saKQT8jzFU7WuGTEk01UPQZ7xHjgNXipj6LFIXY8=;
 b=wU8tEivfCMLRjeR4R0u8lYtcD/GFWLafwKzj3HOuIckn8EHen9BC2we15XBEPyzVPczG/WOX3OLKgmKCAVuKhUT0fB99jeGlQ190lxDjAOwn1z2ICsnRxMN9QwCcftri+MQ+XASudQ0Pg4QR4Z22to81l2E3riKJ03p8CB1Fyts=
Received: from PH7P220CA0003.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:326::25)
 by PH8PR12MB6747.namprd12.prod.outlook.com (2603:10b6:510:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.18; Fri, 23 Aug
 2024 13:32:04 +0000
Received: from CY4PEPF0000EE30.namprd05.prod.outlook.com
 (2603:10b6:510:326:cafe::8e) by PH7P220CA0003.outlook.office365.com
 (2603:10b6:510:326::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19 via Frontend
 Transport; Fri, 23 Aug 2024 13:32:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE30.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:32:03 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:31:57 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [RFC PATCH 16/21] coco/sev-guest: Make SEV-to-PSP request helpers public
Date: Fri, 23 Aug 2024 23:21:30 +1000
Message-ID: <20240823132137.336874-17-aik@amd.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240823132137.336874-1-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE30:EE_|PH8PR12MB6747:EE_
X-MS-Office365-Filtering-Correlation-Id: a6eea877-7511-4e31-caec-08dcc377f9c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y2SCZCKU8DMq8rzkw451w1oMC3U4hNDrzgzrCiKlpLd7LFIEu7iyM2SDFlo2?=
 =?us-ascii?Q?IP+2Re76P0ppd/hslXpNiIl/Lgo/PY8DqaNBMfBVRJ0aZBgjfPevm/a43tDR?=
 =?us-ascii?Q?sebj0VAJf0Mz7tn9MgYg+I2jqYR5oefXZXruLrCwLv9G3DYX3Rj3beqPdHFT?=
 =?us-ascii?Q?ybjZ8BcReEGGiWUHSx27UyvfTBPW4XFuL6XuXQd56ZuGV1ibjQ0HlgZx2sFX?=
 =?us-ascii?Q?yFxcX+zFWLGboNzyKEezx8tJzcog59daGXCF0ZZdJMrksgxqjteTeKDfZcDo?=
 =?us-ascii?Q?HYaGcdMni3s8JscVprSweo0eqNCwmhKSdYOzAiKj7FJkFVjPli6cAnej1HDb?=
 =?us-ascii?Q?GsEplKOd25r7YR49HAZekaifYJpnJNTAmqUn8qm7+p4RULcFz2s7c9NjCMP+?=
 =?us-ascii?Q?cPBT1KwtRrb/29tspGg7hILpL1kHDgomKklrR34cT38m8V2RQLiodkY8Ljoj?=
 =?us-ascii?Q?XPDPEo3Na8nm+DIvCd6tzg2s3wD54UePHT1K3qrEzPhGr64/am9Csb2Sz/+b?=
 =?us-ascii?Q?NOHLKVnC7V8eeCbf3ZoOqMRVDWkxueHa+4AuMYdmuIRH2Z26e7wThaFrxUum?=
 =?us-ascii?Q?rAs5Joug0FiMe3TNVue37/S6BH9xw17Pb8KalTJuKkjHWRDdbgGj24MMK9WH?=
 =?us-ascii?Q?Goy2jyqmxq7/FLOMg56A2jmawdJwZwwZXdzChJ/kpK+8BG/58e3eWhGq6wKt?=
 =?us-ascii?Q?insXgmIG23QEY27TC6IDgYTwcdLeUf+w7JdTtnsJXkivpcilTEd62QNVHVgZ?=
 =?us-ascii?Q?/9xxd07hfyD/SGm2EtzLzXuJTthcFjZ09SzROZIi6lOFxTSCVFDr+oicI6nU?=
 =?us-ascii?Q?yOeyHz8hmbQ9FLZuvaaJ9FZSfesPUxHbnx//BS02eMeSJHTSmm9H8nnT6VV3?=
 =?us-ascii?Q?3B2IEHdCyH3vjkLoC3C/cEf/pBCe8OES91R5bA6Uec6uAYB/mhC/3Wuxzsee?=
 =?us-ascii?Q?Pw6ijX2DWOsdYdWPhX3W6elPOoNYFy/vKhsGOhb10mhcyfCCoyLsoWQSV5Hk?=
 =?us-ascii?Q?R8bfGoFBXRFi26LbbF7pY0XsCXgcHqVA6Ds1zpqE/4VKusZ/ueU8HMZtMrw2?=
 =?us-ascii?Q?rbYd8gCD+vMlCXcS4iyIbCAFkgDp1bxg8BKfdZBFKHVW214d4/cUbyE1qylp?=
 =?us-ascii?Q?D/yNIpKhMKWMTgDEF7Mds3hxt5zcBnZ1+ZfD7E7CtWn/1zM1cyQ4WJZPN/VT?=
 =?us-ascii?Q?k+0oLcjOwWnNEmvo8pYIgpAGlQCdHGMtSSkODh4kGajTSo8AXLZNqDhByZHz?=
 =?us-ascii?Q?IfrqgCZOVPz4NFF8tP5lktWGUGeNwsfCcamcbjFEVlABRtN/wYMRGWHTZNeP?=
 =?us-ascii?Q?93lvQg5cpvdBYXUgFjHoV5GZHDpJS72TC47sIyy4Lin2J2rvb8w/6ZLPsFgM?=
 =?us-ascii?Q?87W6Uw+chXlvPRvz7VUC422c6jMmxxXMbLD+1BxQ5tEaaGfoh36ZYwwdsOTS?=
 =?us-ascii?Q?q1bejIIuejCK+q48GErHBxY3c6GiuI/T?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:32:03.7793
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6eea877-7511-4e31-caec-08dcc377f9c9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE30.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6747

SEV TIO is going to a separate file, these helpers will be reused.

No functional change intended.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.h | 54 ++++++++++++++++++++
 drivers/virt/coco/sev-guest/sev_guest.c | 42 +++------------
 2 files changed, 60 insertions(+), 36 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/drivers/virt/coco/sev-guest/sev-guest.h
new file mode 100644
index 000000000000..765f42ff55aa
--- /dev/null
+++ b/drivers/virt/coco/sev-guest/sev-guest.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2024 Advanced Micro Devices, Inc.
+ */
+
+#ifndef __VIRT_SEVGUEST_H__
+#define __VIRT_SEVGUEST_H__
+
+#include <linux/miscdevice.h>
+#include <linux/types.h>
+
+struct snp_guest_crypto {
+	struct crypto_aead *tfm;
+	u8 *iv, *authtag;
+	int iv_len, a_len;
+};
+
+struct snp_guest_dev {
+	struct device *dev;
+	struct miscdevice misc;
+
+	void *certs_data;
+	struct snp_guest_crypto *crypto;
+	/* request and response are in unencrypted memory */
+	struct snp_guest_msg *request, *response;
+
+	/*
+	 * Avoid information leakage by double-buffering shared messages
+	 * in fields that are in regular encrypted memory.
+	 */
+	struct snp_guest_msg secret_request, secret_response;
+
+	struct snp_secrets_page *secrets;
+	struct snp_req_data input;
+	union {
+		struct snp_report_req report;
+		struct snp_derived_key_req derived_key;
+		struct snp_ext_report_req ext_report;
+	} req;
+	u32 *os_area_msg_seqno;
+	u8 *vmpck;
+};
+
+extern struct mutex snp_cmd_mutex;
+
+int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
+				struct snp_guest_request_ioctl *rio, u8 type,
+				void *req_buf, size_t req_sz, void *resp_buf,
+				u32 resp_sz);
+
+void *alloc_shared_pages(struct device *dev, size_t sz);
+void free_shared_pages(void *buf, size_t sz);
+
+#endif /* __VIRT_SEVGUEST_H__ */
diff --git a/drivers/virt/coco/sev-guest/sev_guest.c b/drivers/virt/coco/sev-guest/sev_guest.c
index ecc6176633be..d04d270f359e 100644
--- a/drivers/virt/coco/sev-guest/sev_guest.c
+++ b/drivers/virt/coco/sev-guest/sev_guest.c
@@ -30,6 +30,8 @@
 #include <asm/svm.h>
 #include <asm/sev.h>
 
+#include "sev-guest.h"
+
 #define DEVICE_NAME	"sev-guest"
 #define AAD_LEN		48
 #define MSG_HDR_VER	1
@@ -39,38 +41,6 @@
 
 #define SVSM_MAX_RETRIES		3
 
-struct snp_guest_crypto {
-	struct crypto_aead *tfm;
-	u8 *iv, *authtag;
-	int iv_len, a_len;
-};
-
-struct snp_guest_dev {
-	struct device *dev;
-	struct miscdevice misc;
-
-	void *certs_data;
-	struct snp_guest_crypto *crypto;
-	/* request and response are in unencrypted memory */
-	struct snp_guest_msg *request, *response;
-
-	/*
-	 * Avoid information leakage by double-buffering shared messages
-	 * in fields that are in regular encrypted memory.
-	 */
-	struct snp_guest_msg secret_request, secret_response;
-
-	struct snp_secrets_page *secrets;
-	struct snp_req_data input;
-	union {
-		struct snp_report_req report;
-		struct snp_derived_key_req derived_key;
-		struct snp_ext_report_req ext_report;
-	} req;
-	u32 *os_area_msg_seqno;
-	u8 *vmpck;
-};
-
 /*
  * The VMPCK ID represents the key used by the SNP guest to communicate with the
  * SEV firmware in the AMD Secure Processor (ASP, aka PSP). By default, the key
@@ -83,7 +53,7 @@ module_param(vmpck_id, int, 0444);
 MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.");
 
 /* Mutex to serialize the shared buffer access and command handling. */
-static DEFINE_MUTEX(snp_cmd_mutex);
+DEFINE_MUTEX(snp_cmd_mutex);
 
 static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
 {
@@ -435,7 +405,7 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	return rc;
 }
 
-static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
+int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 				struct snp_guest_request_ioctl *rio, u8 type,
 				void *req_buf, size_t req_sz, void *resp_buf,
 				u32 resp_sz)
@@ -709,7 +679,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 	return ret;
 }
 
-static void free_shared_pages(void *buf, size_t sz)
+void free_shared_pages(void *buf, size_t sz)
 {
 	unsigned int npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
 	int ret;
@@ -726,7 +696,7 @@ static void free_shared_pages(void *buf, size_t sz)
 	__free_pages(virt_to_page(buf), get_order(sz));
 }
 
-static void *alloc_shared_pages(struct device *dev, size_t sz)
+void *alloc_shared_pages(struct device *dev, size_t sz)
 {
 	unsigned int npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
 	struct page *page;
-- 
2.45.2


