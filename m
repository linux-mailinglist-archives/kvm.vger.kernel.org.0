Return-Path: <kvm+bounces-18472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 20D368D5965
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:32:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70BC31F23FC2
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66B5177109;
	Fri, 31 May 2024 04:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YcFQT9uM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2057.outbound.protection.outlook.com [40.107.95.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0D1208A9;
	Fri, 31 May 2024 04:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717129942; cv=fail; b=a/s9HEuaQvb6Xvo82QHwhEMaZCaRdyQq6mOwYKktsQ1GspJNdH5MqYtaSMo1RYZQ/1y+vkYmmwXuCbjQhbuM+ryp0W9c2+iM4CPCuSWloSv7PWrq1inkgAOzBWHhbDL+32rBm9oRhVfzw9VGS9u3Xv5ne5/dMrNivLPD2PKiGsA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717129942; c=relaxed/simple;
	bh=d1rWMx1QPn6jbcFd+n4eU5UAH+QltNpHO2hgC3Q/Afg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=suOWRXRvzlvpBTU15C0vS8O1M9apucgh2z4auyLXKeNkL/H/oXjoc7ng/TNrsUfvj0pQnFKr/KiPdAacXwjZ+DSFha1nd7bP2VYFgGheQHjsc5YS0B31rAXbDrITrCWcYbrrtxGuNC0uvuC6zs5gIMU4pls91nj6F4edjPWACAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YcFQT9uM; arc=fail smtp.client-ip=40.107.95.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IscfX+pAXd4fpVum2jhp/sja3OuHCxo4HsFHb91RR8JhySvo7w1CTFO0gG5OBoNFSvoZRWqidRFPX4uMBBGQ2XfdQi6IqYHPO2l0Z+RKWTp72jtAJbnoK9JZOVNvU77xGEhNKoe+94TVbnVy3+rk3yI+viS6epRJJTnGhBIAHIYaZHe8Jp514GsSpMnrDmsUhRzc4sWx/gh3WfyU9+yPy6//gHyeEPYTrMyTcoZh4l4pxi5te7bSQxXuzuZ9xJCccLmK91qiHSwhD2PWv1w3yhpVUzaEekh9uI5f2/3JuBT9WVsgbxni7rLhg03673r5Bzpx/Sboz0qS2XlwmDkPXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TvKSxTjKqXCcxa90DTuEl+Z5I8inQRhapQV6hmDUr6g=;
 b=XLs+vCLIk6azCj50IfuhyQQZ1gG3RR23EfB7FDfjxKiErtHQ89ftMUVy8nWK+cNr/x7IhuTB5vYvWgNJvRbuGvBzyDRAFwZt1jIdv71N3uWSYhrnkZpCZdqCh6Ur6rgeXe9/HOc6MmOEAkAta4AIpuor7RNJZnO0eIaeeq4tE2yiAZlyqok/mx4goCQw41CMslgAj7YSg3rGidK2kk2u6GK7tNl7SvVplPuSZWZLdhufJGJ+f825RzrkQUXbFyEPDe+Hbw/yMDN8+1KUcrpjcAF3Uj8xK07qBdHZa527NJgh8dYSir9shqLJqurQfnmle/v/AxdEWA1ZHKWl86mSOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TvKSxTjKqXCcxa90DTuEl+Z5I8inQRhapQV6hmDUr6g=;
 b=YcFQT9uMVQYqRi8GJfJdQNxQoZfomplu3R6L8doMboutZZfESCCclAq/54ryM5UUnfIIcZKmmjNl9M0dOjKyVW69kXqQXsJvzOavoYDhI3IByOnHO2zu8tNr7SO7DcBs2QUM/258Zp3lDV4YNB6m3huSXk7NG4gAZ9voMXqR9uY=
Received: from BYAPR05CA0013.namprd05.prod.outlook.com (2603:10b6:a03:c0::26)
 by IA1PR12MB8309.namprd12.prod.outlook.com (2603:10b6:208:3fe::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Fri, 31 May
 2024 04:32:17 +0000
Received: from SJ1PEPF00002321.namprd03.prod.outlook.com
 (2603:10b6:a03:c0:cafe::35) by BYAPR05CA0013.outlook.office365.com
 (2603:10b6:a03:c0::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.9 via Frontend
 Transport; Fri, 31 May 2024 04:32:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002321.mail.protection.outlook.com (10.167.242.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:32:17 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:31:31 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 04/24] virt: sev-guest: Add SNP guest request structure
Date: Fri, 31 May 2024 10:00:18 +0530
Message-ID: <20240531043038.3370793-5-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531043038.3370793-1-nikunj@amd.com>
References: <20240531043038.3370793-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002321:EE_|IA1PR12MB8309:EE_
X-MS-Office365-Filtering-Correlation-Id: deb1486a-ed39-493d-9149-08dc812aa74c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|82310400017|7416005|1800799015|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EC4VOaSFjgpTgGnkcPzNI+HPddMCF3PKqeo0QEgdrRDqqhV62Cje7O7ivmo/?=
 =?us-ascii?Q?f1N4aAIp0XJkkLGhtAih1eMAtITKXXI4ksixiDyT++mAOjEI1QFZdsnw6T9h?=
 =?us-ascii?Q?33zAtDikkyxRfstAAdNsV7j1H8fu7ol5OZisvHz60rzV/mGm4qipty7JKNvf?=
 =?us-ascii?Q?E0k37kNHTiEhOzedvPgGHH8x24vIfTxIZRMSLFlkEMXnALonqCxbdUH0kUap?=
 =?us-ascii?Q?b9KE+/+4MYW40fzcaBkAmIbmEC/mkrnSgjcJpkUUpBWugcJMJhF0h1XUjsvF?=
 =?us-ascii?Q?KKxmgCxp8bU8dvI86gdX14etAgSWAgE7mirh9IiTVIF55fZ8eHGP4Ha2So4y?=
 =?us-ascii?Q?l7+7qlPDEQKV8kJ+lntDQmCL6+f26BAbbqCF6gdrr6OiG1tczSpVjx9n/RdU?=
 =?us-ascii?Q?MH0IP+Yea4V3t5nsb1Yrza0p1JodNY51G0uTuJ0BX7e0LVGslyogNL1ruueh?=
 =?us-ascii?Q?1wUnz+uTqFXMPRvAR7U8hWR6Zof1+u5XtLcg7h6BnITn5+pd/72ZA0EJDzux?=
 =?us-ascii?Q?KuUBwu5I4iiFOiu3OZt1cRmnuKSnWq43rU08Zh9Ttv/Ee3Qt56EZF3WLJu2D?=
 =?us-ascii?Q?owPARqaZJhxgy35kAXo0r7bijdi0QXK1H46Iv7wk3SAY8NJSikTbdnkqto0a?=
 =?us-ascii?Q?BXwJviS3ltVxOciZG6WFXPF3ELeALf4Q4rvYPQL/KxhP4uRBPlo8qnRYvb21?=
 =?us-ascii?Q?fMl4Oj9BB5GUu+eRmn+g1pQidxay4X7uplIJ2ZLPde4oSB+XnisFb289sOX9?=
 =?us-ascii?Q?+XMH6aZQsjklSaQXHQAbYNY5pqiIfjPw8MjD/7SUEmX6IOLhFiQt10CL5wry?=
 =?us-ascii?Q?mgqgo8y2dpgFm8zXf0gqtLcz5gJdHH1OY/vqrGaOzYXNMnds3KRYJ8DUhOkI?=
 =?us-ascii?Q?WUi2/vVgiA5/OBXZ4TUodOs89khEjcE2NwF510CjT+iiCUy/uYzZjozNgplI?=
 =?us-ascii?Q?W3OuV38HjzJrMleQNk/tvdHAAsIV+TOZUbH11icLgdGZVgmbfVXKg+ZbA7Pe?=
 =?us-ascii?Q?F7Cwag30r3Fm/7OAEBmzt5wfYS8wcVyjGVKfHbGUAAT57GTwO3qV86H+E8Ti?=
 =?us-ascii?Q?LXUvnahuxbij03BEnPO2F/g/BZnEwXsiYYhOvatv/H4UtG7I9dOPi+n5Hma8?=
 =?us-ascii?Q?J8ZOJGut9etiFcacBhrsy5V4mRkyBbd1SQ+i2n2ePucHjVwWf2ACrAKXS3SE?=
 =?us-ascii?Q?nxm3FLEVxz534WOwKVIjXYgzhYut4l/9XBuKgGwcuqFC4yzxHatTypiDQWKu?=
 =?us-ascii?Q?8uu8l5WDYMnhi4L1pCVhvf9QEzrznNw4hmmZuxDnHArQSNiKwhmKLvHZwhaz?=
 =?us-ascii?Q?WL8yumbHVpw1hrYh5NAAuv21?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(82310400017)(7416005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:32:17.3940
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: deb1486a-ed39-493d-9149-08dc812aa74c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002321.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8309

Add a snp_guest_req structure to simplify the function arguments. This
structure will be used to call the SNP Guest message request API instead
of passing a long list of parameters.

Update the snp_issue_guest_request() prototype to include the new guest
request structure and move all the sev-guest.h header content to sev.h.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev.h              |  78 ++++++++++-
 drivers/virt/coco/sev-guest/sev-guest.h |  69 ----------
 arch/x86/kernel/sev.c                   |  15 ++-
 drivers/virt/coco/sev-guest/sev-guest.c | 169 +++++++++++++-----------
 4 files changed, 177 insertions(+), 154 deletions(-)
 delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index ca20cc4e5826..dbf17e66d52a 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -112,8 +112,6 @@ struct rmp_state {
 struct snp_req_data {
 	unsigned long req_gpa;
 	unsigned long resp_gpa;
-	unsigned long data_gpa;
-	unsigned int data_npages;
 };
 
 struct sev_guest_platform_data {
@@ -155,6 +153,76 @@ struct snp_secrets_page {
 	u8 rsvd3[3840];
 } __packed;
 
+#define MAX_AUTHTAG_LEN		32
+#define AUTHTAG_LEN		16
+#define AAD_LEN			48
+#define MSG_HDR_VER		1
+
+/* See SNP spec SNP_GUEST_REQUEST section for the structure */
+enum msg_type {
+	SNP_MSG_TYPE_INVALID = 0,
+	SNP_MSG_CPUID_REQ,
+	SNP_MSG_CPUID_RSP,
+	SNP_MSG_KEY_REQ,
+	SNP_MSG_KEY_RSP,
+	SNP_MSG_REPORT_REQ,
+	SNP_MSG_REPORT_RSP,
+	SNP_MSG_EXPORT_REQ,
+	SNP_MSG_EXPORT_RSP,
+	SNP_MSG_IMPORT_REQ,
+	SNP_MSG_IMPORT_RSP,
+	SNP_MSG_ABSORB_REQ,
+	SNP_MSG_ABSORB_RSP,
+	SNP_MSG_VMRK_REQ,
+	SNP_MSG_VMRK_RSP,
+
+	SNP_MSG_TYPE_MAX
+};
+
+enum aead_algo {
+	SNP_AEAD_INVALID,
+	SNP_AEAD_AES_256_GCM,
+};
+
+struct snp_guest_msg_hdr {
+	u8 authtag[MAX_AUTHTAG_LEN];
+	u64 msg_seqno;
+	u8 rsvd1[8];
+	u8 algo;
+	u8 hdr_version;
+	u16 hdr_sz;
+	u8 msg_type;
+	u8 msg_version;
+	u16 msg_sz;
+	u32 rsvd2;
+	u8 msg_vmpck;
+	u8 rsvd3[35];
+} __packed;
+
+struct snp_guest_msg {
+	struct snp_guest_msg_hdr hdr;
+	u8 payload[];
+} __packed;
+
+#define SNP_GUEST_MSG_SIZE 4096
+#define SNP_GUEST_MSG_PAYLOAD_SIZE (SNP_GUEST_MSG_SIZE - sizeof(struct snp_guest_msg))
+
+struct snp_guest_req {
+	void *req_buf;
+	size_t req_sz;
+
+	void *resp_buf;
+	size_t resp_sz;
+
+	void *data;
+	size_t data_npages;
+
+	u64 exit_code;
+	unsigned int vmpck_id;
+	u8 msg_version;
+	u8 msg_type;
+};
+
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 extern void __sev_es_ist_enter(struct pt_regs *regs);
 extern void __sev_es_ist_exit(void);
@@ -224,7 +292,8 @@ void snp_set_wakeup_secondary_cpu(void);
 bool snp_init(struct boot_params *bp);
 void __noreturn snp_abort(void);
 void snp_dmi_setup(void);
-int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio);
+int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+			    struct snp_guest_request_ioctl *rio);
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
@@ -249,7 +318,8 @@ static inline void snp_set_wakeup_secondary_cpu(void) { }
 static inline bool snp_init(struct boot_params *bp) { return false; }
 static inline void snp_abort(void) { }
 static inline void snp_dmi_setup(void) { }
-static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio)
+static inline int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+					  struct snp_guest_request_ioctl *rio)
 {
 	return -ENOTTY;
 }
diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/drivers/virt/coco/sev-guest/sev-guest.h
deleted file mode 100644
index 97796f658fd3..000000000000
--- a/drivers/virt/coco/sev-guest/sev-guest.h
+++ /dev/null
@@ -1,69 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2021 Advanced Micro Devices, Inc.
- *
- * Author: Brijesh Singh <brijesh.singh@amd.com>
- *
- * SEV-SNP API spec is available at https://developer.amd.com/sev
- */
-
-#ifndef __VIRT_SEVGUEST_H__
-#define __VIRT_SEVGUEST_H__
-
-#include <linux/types.h>
-
-#define MAX_AUTHTAG_LEN		32
-#define AUTHTAG_LEN		16
-#define AAD_LEN			48
-#define MSG_HDR_VER		1
-
-/* See SNP spec SNP_GUEST_REQUEST section for the structure */
-enum msg_type {
-	SNP_MSG_TYPE_INVALID = 0,
-	SNP_MSG_CPUID_REQ,
-	SNP_MSG_CPUID_RSP,
-	SNP_MSG_KEY_REQ,
-	SNP_MSG_KEY_RSP,
-	SNP_MSG_REPORT_REQ,
-	SNP_MSG_REPORT_RSP,
-	SNP_MSG_EXPORT_REQ,
-	SNP_MSG_EXPORT_RSP,
-	SNP_MSG_IMPORT_REQ,
-	SNP_MSG_IMPORT_RSP,
-	SNP_MSG_ABSORB_REQ,
-	SNP_MSG_ABSORB_RSP,
-	SNP_MSG_VMRK_REQ,
-	SNP_MSG_VMRK_RSP,
-
-	SNP_MSG_TYPE_MAX
-};
-
-enum aead_algo {
-	SNP_AEAD_INVALID,
-	SNP_AEAD_AES_256_GCM,
-};
-
-struct snp_guest_msg_hdr {
-	u8 authtag[MAX_AUTHTAG_LEN];
-	u64 msg_seqno;
-	u8 rsvd1[8];
-	u8 algo;
-	u8 hdr_version;
-	u16 hdr_sz;
-	u8 msg_type;
-	u8 msg_version;
-	u16 msg_sz;
-	u32 rsvd2;
-	u8 msg_vmpck;
-	u8 rsvd3[35];
-} __packed;
-
-struct snp_guest_msg {
-	struct snp_guest_msg_hdr hdr;
-	u8 payload[];
-} __packed;
-
-#define SNP_GUEST_MSG_SIZE 4096
-#define SNP_GUEST_MSG_PAYLOAD_SIZE (SNP_GUEST_MSG_SIZE - sizeof(struct snp_guest_msg))
-
-#endif /* __VIRT_SEVGUEST_H__ */
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 3342ed58e168..8145bf123ac9 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2191,7 +2191,8 @@ static int __init init_sev_config(char *str)
 }
 __setup("sev=", init_sev_config);
 
-int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio)
+int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+			    struct snp_guest_request_ioctl *rio)
 {
 	struct ghcb_state state;
 	struct es_em_ctxt ctxt;
@@ -2215,12 +2216,12 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
 
 	vc_ghcb_invalidate(ghcb);
 
-	if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
-		ghcb_set_rax(ghcb, input->data_gpa);
-		ghcb_set_rbx(ghcb, input->data_npages);
+	if (req->exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
+		ghcb_set_rax(ghcb, __pa(req->data));
+		ghcb_set_rbx(ghcb, req->data_npages);
 	}
 
-	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, exit_code, input->req_gpa, input->resp_gpa);
+	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, req->exit_code, input->req_gpa, input->resp_gpa);
 	if (ret)
 		goto e_put;
 
@@ -2235,8 +2236,8 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
 
 	case SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN):
 		/* Number of expected pages are returned in RBX */
-		if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
-			input->data_npages = ghcb_get_rbx(ghcb);
+		if (req->exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
+			req->data_npages = ghcb_get_rbx(ghcb);
 			ret = -ENOSPC;
 			break;
 		}
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 69bd817239d8..b6be676f82be 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -28,8 +28,6 @@
 #include <asm/svm.h>
 #include <asm/sev.h>
 
-#include "sev-guest.h"
-
 #define DEVICE_NAME	"sev-guest"
 
 #define SNP_REQ_MAX_RETRY_DURATION	(60*HZ)
@@ -169,7 +167,7 @@ static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
 	return ctx;
 }
 
-static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload, u32 sz)
+static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *req)
 {
 	struct snp_guest_msg *resp_msg = snp_dev->secret_response;
 	struct snp_guest_msg *req_msg = snp_dev->secret_request;
@@ -198,20 +196,19 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
 	 * If the message size is greater than our buffer length then return
 	 * an error.
 	 */
-	if (unlikely((resp_msg_hdr->msg_sz + ctx->authsize) > sz))
+	if (unlikely((resp_msg_hdr->msg_sz + ctx->authsize) > req->resp_sz))
 		return -EBADMSG;
 
 	/* Decrypt the payload */
 	memcpy(iv, &resp_msg_hdr->msg_seqno, min(sizeof(iv), sizeof(resp_msg_hdr->msg_seqno)));
-	if (!aesgcm_decrypt(ctx, payload, resp_msg->payload, resp_msg_hdr->msg_sz,
+	if (!aesgcm_decrypt(ctx, req->resp_buf, resp_msg->payload, resp_msg_hdr->msg_sz,
 			    &resp_msg_hdr->algo, AAD_LEN, iv, resp_msg_hdr->authtag))
 		return -EBADMSG;
 
 	return 0;
 }
 
-static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8 type,
-			void *payload, size_t sz)
+static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_guest_req *req)
 {
 	struct snp_guest_msg *msg = snp_dev->secret_request;
 	struct snp_guest_msg_hdr *hdr = &msg->hdr;
@@ -223,11 +220,11 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
 	hdr->algo = SNP_AEAD_AES_256_GCM;
 	hdr->hdr_version = MSG_HDR_VER;
 	hdr->hdr_sz = sizeof(*hdr);
-	hdr->msg_type = type;
-	hdr->msg_version = version;
+	hdr->msg_type = req->msg_type;
+	hdr->msg_version = req->msg_version;
 	hdr->msg_seqno = seqno;
-	hdr->msg_vmpck = vmpck_id;
-	hdr->msg_sz = sz;
+	hdr->msg_vmpck = req->vmpck_id;
+	hdr->msg_sz = req->req_sz;
 
 	/* Verify the sequence number is non-zero */
 	if (!hdr->msg_seqno)
@@ -236,17 +233,17 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
 	pr_debug("request [seqno %lld type %d version %d sz %d]\n",
 		 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
 
-	if (WARN_ON((sz + ctx->authsize) > SNP_GUEST_MSG_PAYLOAD_SIZE))
+	if (WARN_ON((req->req_sz + ctx->authsize) > SNP_GUEST_MSG_PAYLOAD_SIZE))
 		return -EBADMSG;
 
 	memcpy(iv, &hdr->msg_seqno, min(sizeof(iv), sizeof(hdr->msg_seqno)));
-	aesgcm_encrypt(ctx, msg->payload, payload, sz, &hdr->algo, AAD_LEN,
-		       iv, hdr->authtag);
+	aesgcm_encrypt(ctx, msg->payload, req->req_buf, req->req_sz, &hdr->algo,
+		       AAD_LEN, iv, hdr->authtag);
 
 	return 0;
 }
 
-static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
+static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
 				  struct snp_guest_request_ioctl *rio)
 {
 	unsigned long req_start = jiffies;
@@ -261,7 +258,7 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	 * sequence number must be incremented or the VMPCK must be deleted to
 	 * prevent reuse of the IV.
 	 */
-	rc = snp_issue_guest_request(exit_code, &snp_dev->input, rio);
+	rc = snp_issue_guest_request(req, &snp_dev->input, rio);
 	switch (rc) {
 	case -ENOSPC:
 		/*
@@ -271,8 +268,8 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 		 * order to increment the sequence number and thus avoid
 		 * IV reuse.
 		 */
-		override_npages = snp_dev->input.data_npages;
-		exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
+		override_npages = req->data_npages;
+		req->exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
 
 		/*
 		 * Override the error to inform callers the given extended
@@ -327,15 +324,13 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	}
 
 	if (override_npages)
-		snp_dev->input.data_npages = override_npages;
+		req->data_npages = override_npages;
 
 	return rc;
 }
 
-static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
-				struct snp_guest_request_ioctl *rio, u8 type,
-				void *req_buf, size_t req_sz, void *resp_buf,
-				u32 resp_sz)
+static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
+				  struct snp_guest_request_ioctl *rio)
 {
 	u64 seqno;
 	int rc;
@@ -349,7 +344,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	memset(snp_dev->response, 0, SNP_GUEST_MSG_SIZE);
 
 	/* Encrypt the userspace provided payload in snp_dev->secret_request. */
-	rc = enc_payload(snp_dev, seqno, rio->msg_version, type, req_buf, req_sz);
+	rc = enc_payload(snp_dev, seqno, req);
 	if (rc)
 		return rc;
 
@@ -357,9 +352,9 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	 * Write the fully encrypted request to the shared unencrypted
 	 * request page.
 	 */
-	memcpy(snp_dev->request, &snp_dev->secret_request, SNP_GUEST_MSG_SIZE);
+	memcpy(snp_dev->request, snp_dev->secret_request, SNP_GUEST_MSG_SIZE);
 
-	rc = __handle_guest_request(snp_dev, exit_code, rio);
+	rc = __handle_guest_request(snp_dev, req, rio);
 	if (rc) {
 		if (rc == -EIO &&
 		    rio->exitinfo2 == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
@@ -368,12 +363,11 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 		dev_alert(snp_dev->dev,
 			  "Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
 			  rc, rio->exitinfo2);
-
 		snp_disable_vmpck(snp_dev);
 		return rc;
 	}
 
-	rc = verify_and_dec_payload(snp_dev, resp_buf, resp_sz);
+	rc = verify_and_dec_payload(snp_dev, req);
 	if (rc) {
 		dev_alert(snp_dev->dev, "Detected unexpected decode failure from ASP. rc: %d\n", rc);
 		snp_disable_vmpck(snp_dev);
@@ -390,8 +384,9 @@ struct snp_req_resp {
 
 static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
-	struct snp_report_req *req = &snp_dev->req.report;
-	struct snp_report_resp *resp;
+	struct snp_report_req *report_req = &snp_dev->req.report;
+	struct snp_guest_req req = {0};
+	struct snp_report_resp *report_resp;
 	int rc, resp_len;
 
 	lockdep_assert_held(&snp_cmd_mutex);
@@ -399,7 +394,7 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
 
-	if (copy_from_user(req, (void __user *)arg->req_data, sizeof(*req)))
+	if (copy_from_user(report_req, (void __user *)arg->req_data, sizeof(*report_req)))
 		return -EFAULT;
 
 	/*
@@ -407,29 +402,37 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(resp->data) + snp_dev->ctx->authsize;
-	resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
-	if (!resp)
+	resp_len = sizeof(report_resp->data) + snp_dev->ctx->authsize;
+	report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
+	if (!report_resp)
 		return -ENOMEM;
 
-	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg,
-				  SNP_MSG_REPORT_REQ, req, sizeof(*req), resp->data,
-				  resp_len);
+	req.msg_version = arg->msg_version;
+	req.msg_type = SNP_MSG_REPORT_REQ;
+	req.vmpck_id = vmpck_id;
+	req.req_buf = report_req;
+	req.req_sz = sizeof(*report_req);
+	req.resp_buf = report_resp->data;
+	req.resp_sz = resp_len;
+	req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+
+	rc = snp_send_guest_request(snp_dev, &req, arg);
 	if (rc)
 		goto e_free;
 
-	if (copy_to_user((void __user *)arg->resp_data, resp, sizeof(*resp)))
+	if (copy_to_user((void __user *)arg->resp_data, report_resp, sizeof(*report_resp)))
 		rc = -EFAULT;
 
 e_free:
-	kfree(resp);
+	kfree(report_resp);
 	return rc;
 }
 
 static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
-	struct snp_derived_key_req *req = &snp_dev->req.derived_key;
-	struct snp_derived_key_resp resp = {0};
+	struct snp_derived_key_req *derived_key_req = &snp_dev->req.derived_key;
+	struct snp_derived_key_resp derived_key_resp = {0};
+	struct snp_guest_req req = {0};
 	int rc, resp_len;
 	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
 	u8 buf[64 + 16];
@@ -444,25 +447,35 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(resp.data) + snp_dev->ctx->authsize;
+	resp_len = sizeof(derived_key_resp.data) + snp_dev->ctx->authsize;
 	if (sizeof(buf) < resp_len)
 		return -ENOMEM;
 
-	if (copy_from_user(req, (void __user *)arg->req_data, sizeof(*req)))
+	if (copy_from_user(derived_key_req, (void __user *)arg->req_data,
+			   sizeof(*derived_key_req)))
 		return -EFAULT;
 
-	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg,
-				  SNP_MSG_KEY_REQ, req, sizeof(*req), buf, resp_len);
+	req.msg_version = arg->msg_version;
+	req.msg_type = SNP_MSG_KEY_REQ;
+	req.vmpck_id = vmpck_id;
+	req.req_buf = derived_key_req;
+	req.req_sz = sizeof(*derived_key_req);
+	req.resp_buf = buf;
+	req.resp_sz = resp_len;
+	req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+
+	rc = snp_send_guest_request(snp_dev, &req, arg);
 	if (rc)
 		return rc;
 
-	memcpy(resp.data, buf, sizeof(resp.data));
-	if (copy_to_user((void __user *)arg->resp_data, &resp, sizeof(resp)))
+	memcpy(derived_key_resp.data, buf, sizeof(derived_key_resp.data));
+	if (copy_to_user((void __user *)arg->resp_data, &derived_key_resp,
+			 sizeof(derived_key_resp)))
 		rc = -EFAULT;
 
 	/* The response buffer contains the sensitive data, explicitly clear it. */
 	memzero_explicit(buf, sizeof(buf));
-	memzero_explicit(&resp, sizeof(resp));
+	memzero_explicit(&derived_key_resp, sizeof(derived_key_resp));
 	return rc;
 }
 
@@ -470,32 +483,33 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 			  struct snp_req_resp *io)
 
 {
-	struct snp_ext_report_req *req = &snp_dev->req.ext_report;
-	struct snp_report_resp *resp;
-	int ret, npages = 0, resp_len;
+	struct snp_ext_report_req *report_req = &snp_dev->req.ext_report;
+	struct snp_guest_req req = {0};
+	struct snp_report_resp *report_resp;
 	sockptr_t certs_address;
+	int ret, resp_len;
 
 	lockdep_assert_held(&snp_cmd_mutex);
 
 	if (sockptr_is_null(io->req_data) || sockptr_is_null(io->resp_data))
 		return -EINVAL;
 
-	if (copy_from_sockptr(req, io->req_data, sizeof(*req)))
+	if (copy_from_sockptr(report_req, io->req_data, sizeof(*report_req)))
 		return -EFAULT;
 
 	/* caller does not want certificate data */
-	if (!req->certs_len || !req->certs_address)
+	if (!report_req->certs_len || !report_req->certs_address)
 		goto cmd;
 
-	if (req->certs_len > SEV_FW_BLOB_MAX_SIZE ||
-	    !IS_ALIGNED(req->certs_len, PAGE_SIZE))
+	if (report_req->certs_len > SEV_FW_BLOB_MAX_SIZE ||
+	    !IS_ALIGNED(report_req->certs_len, PAGE_SIZE))
 		return -EINVAL;
 
 	if (sockptr_is_kernel(io->resp_data)) {
-		certs_address = KERNEL_SOCKPTR((void *)req->certs_address);
+		certs_address = KERNEL_SOCKPTR((void *)report_req->certs_address);
 	} else {
-		certs_address = USER_SOCKPTR((void __user *)req->certs_address);
-		if (!access_ok(certs_address.user, req->certs_len))
+		certs_address = USER_SOCKPTR((void __user *)report_req->certs_address);
+		if (!access_ok(certs_address.user, report_req->certs_len))
 			return -EFAULT;
 	}
 
@@ -505,45 +519,53 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	 * the host. If host does not supply any certs in it, then copy
 	 * zeros to indicate that certificate data was not provided.
 	 */
-	memset(snp_dev->certs_data, 0, req->certs_len);
-	npages = req->certs_len >> PAGE_SHIFT;
+	memset(snp_dev->certs_data, 0, report_req->certs_len);
+	req.data_npages = report_req->certs_len >> PAGE_SHIFT;
 cmd:
 	/*
 	 * The intermediate response buffer is used while decrypting the
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(resp->data) + snp_dev->ctx->authsize;
-	resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
-	if (!resp)
+	resp_len = sizeof(report_resp->data) + snp_dev->ctx->authsize;
+	report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
+	if (!report_resp)
 		return -ENOMEM;
 
-	snp_dev->input.data_npages = npages;
-	ret = handle_guest_request(snp_dev, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg,
-				   SNP_MSG_REPORT_REQ, &req->data,
-				   sizeof(req->data), resp->data, resp_len);
+	req.msg_version = arg->msg_version;
+	req.msg_type = SNP_MSG_REPORT_REQ;
+	req.vmpck_id = vmpck_id;
+	req.req_buf = &report_req->data;
+	req.req_sz = sizeof(report_req->data);
+	req.resp_buf = report_resp->data;
+	req.resp_sz = resp_len;
+	req.exit_code = SVM_VMGEXIT_EXT_GUEST_REQUEST;
+	req.data = snp_dev->certs_data;
+
+	ret = snp_send_guest_request(snp_dev, &req, arg);
 
 	/* If certs length is invalid then copy the returned length */
 	if (arg->vmm_error == SNP_GUEST_VMM_ERR_INVALID_LEN) {
-		req->certs_len = snp_dev->input.data_npages << PAGE_SHIFT;
+		report_req->certs_len = req.data_npages << PAGE_SHIFT;
 
-		if (copy_to_sockptr(io->req_data, req, sizeof(*req)))
+		if (copy_to_sockptr(io->req_data, report_req, sizeof(*report_req)))
 			ret = -EFAULT;
 	}
 
 	if (ret)
 		goto e_free;
 
-	if (npages && copy_to_sockptr(certs_address, snp_dev->certs_data, req->certs_len)) {
+	if (req.data_npages && report_req->certs_len &&
+	    copy_to_sockptr(certs_address, snp_dev->certs_data, report_req->certs_len)) {
 		ret = -EFAULT;
 		goto e_free;
 	}
 
-	if (copy_to_sockptr(io->resp_data, resp, sizeof(*resp)))
+	if (copy_to_sockptr(io->resp_data, report_resp, sizeof(*report_resp)))
 		ret = -EFAULT;
 
 e_free:
-	kfree(resp);
+	kfree(report_resp);
 	return ret;
 }
 
@@ -873,10 +895,9 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	misc->name = DEVICE_NAME;
 	misc->fops = &snp_guest_fops;
 
-	/* initial the input address for guest request */
+	/* Initialize the input addresses for guest request */
 	snp_dev->input.req_gpa = __pa(snp_dev->request);
 	snp_dev->input.resp_gpa = __pa(snp_dev->response);
-	snp_dev->input.data_gpa = __pa(snp_dev->certs_data);
 
 	ret = tsm_register(&sev_tsm_ops, snp_dev, &tsm_report_extra_type);
 	if (ret)
-- 
2.34.1


