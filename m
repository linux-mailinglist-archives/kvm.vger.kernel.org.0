Return-Path: <kvm+bounces-18481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 316118D5977
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:35:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 399C61C238B3
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 905237D3F0;
	Fri, 31 May 2024 04:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="le7UidrR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1856D7C082;
	Fri, 31 May 2024 04:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717130043; cv=fail; b=QDtCobIftYt7i+XTwGOStAO3QSz9wHUii5GnmXVkOfi+g6aWWsfvChZVkigd3ndbdhmYcIqtEBhp6j4gZW7WgEWDRSnba/r9+yJj+gmAFN6VgA540wV6sd1B0MZQS5MKa5yaSX3nxXJyYf1lMFdCKnILRdS9G6Ymdhifkbkdi/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717130043; c=relaxed/simple;
	bh=7iOy7jEbugZeh6Ep2WThL3qqnqUlAsRqtvU2TByY3js=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kWSGxDOzBzocFT0EQOJpBdh+9mwLiFVTkGdKVXIFvEU6ZlL7S6haCW5FvPNXSdutE/C6411I5Dhtj8UKEAX/hwuvoNp8eJ93DduuXwlHvXRw+DQIgVKwWUHFH9MFJLD79jGxOBCf9damxUOUJQcf6C4I/h0gvosK35u1Agnd1SE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=le7UidrR; arc=fail smtp.client-ip=40.107.244.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4fY9K7nZgQZHEjL2WYIj9wWfq5C8xFqjOg3QiajNxBEV2DwLyhFQ5t0Dwb8iiVCFdA4ClhKA7UbDNVLriw7ZSxXHmiiJbUTbvRG6Kr92suRPICu/H8QHKHisnZK9ayvuJdM88JH08swpOuOP39QaIOt7DY2cMTTOB9L/zStm+vjdlii+OZBH83/FjzWda/o1gmqOG/+OhN3kRDyzITZjijPrBeZzv6Q6Jf3FfY9F68gZ+bEaSYbygXr1LdAhS3UNn5YwwrkkXtgVY2MMijaRlOwGe/6A5aXgtydfPeZ9QfpEwsDXaTcZoIEuu1+tyIYl6rzUNw0r7kN/1laTkSoLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JeUBT5NwoaLYVjepKfRfq5f4ozzVbIJrikYohYDTCsY=;
 b=GguOjc7IgWwhj/UY9v7NAOh6On+BTAxRZDCBtiUndXbtpPntvyvhiUhSPN1JthWzCcUG6Ctekz9GOckOCunWmjg4ihQ2QG+Wkknxl4f7JIGxYpomJE//3FvbWSkueERMLo/yMGg5mkO2Sn1SZPQ3JGKpBD5EBIWRRjXMCHU8BBiuTHvbZSblWd57dVMtFYLRvZS0xtOlJOeJe+dvfNoyjqK1yV8oPcamZDLGDvgqGn/Ml7uuw4da+tTipdFE8GJcRnMCP2cDoIZvvrMMHOwsopy1IRpW5b2vRm/c7jekICmbjiPBs+32ji6rYELao2oXjbYY2XqRhZElMF926EGobg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JeUBT5NwoaLYVjepKfRfq5f4ozzVbIJrikYohYDTCsY=;
 b=le7UidrRcWP08kgM93nxvumFwbV01E028Vx0k+OJ4BopK8Ib//i7qplc7Q1W2kDfyEHmKEZVFXcC47JYIrRUV0kJU5IFlCAzspN0GmnP0Uqdni/GMhuyH5OCAfqoWFXGvshK+ahu5joI9VAUHgzZwfIjdXcdtYJBGVSOZxE0tbQ=
Received: from DM6PR08CA0049.namprd08.prod.outlook.com (2603:10b6:5:1e0::23)
 by PH7PR12MB8825.namprd12.prod.outlook.com (2603:10b6:510:26a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.34; Fri, 31 May
 2024 04:33:57 +0000
Received: from DS3PEPF000099D7.namprd04.prod.outlook.com
 (2603:10b6:5:1e0:cafe::a8) by DM6PR08CA0049.outlook.office365.com
 (2603:10b6:5:1e0::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24 via Frontend
 Transport; Fri, 31 May 2024 04:33:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D7.mail.protection.outlook.com (10.167.17.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:33:56 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:33:52 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 13/24] x86/sev: Make sev-guest driver functional again
Date: Fri, 31 May 2024 10:00:27 +0530
Message-ID: <20240531043038.3370793-14-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D7:EE_|PH7PR12MB8825:EE_
X-MS-Office365-Filtering-Correlation-Id: 92abd6ca-7cab-4a75-b83f-08dc812ae283
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|7416005|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vDvCb6wUFh2nocAZSh2Xs6/rUuIL2VTabL2wAzORilmqSbc+QwctX3YSETXa?=
 =?us-ascii?Q?3zulU9NYaGEcg55wuKV8VgbOU8bRldIlhlG2FA+hS6uE6RrYztpgWzOyARXW?=
 =?us-ascii?Q?kSBlZpmfq3h1+OScorz9hdcdrZvzgKnl7jkaRqVIDu54WEeUwV9/tyl5oHXC?=
 =?us-ascii?Q?YBLMlt8nzc/VD9kN5Zh0F/s9Wggbxo3EePdH19lF2z+GX40ivOYtzfUH5QKJ?=
 =?us-ascii?Q?pfKlHKt6ZBAqHcIkTirYalJ7NvFllYMrj9ncZ4wgmyIYIqCeEsX6RyBnNcGi?=
 =?us-ascii?Q?iwdc6hlFcSfygX4le/JJj2jWSjh+YEXsj1t5XiX5TlDq83kCt3Z56GF92X3N?=
 =?us-ascii?Q?8NMH6MgQLUnlBVVBQlhHHFE0cK3oyDHflyU7ZU2JeeLcsH+KT7LCsBo0N7z2?=
 =?us-ascii?Q?53lmJ2lfGwdSqfFXRSsmakVMkvgDsfdtEC64qzuIUGULee27507YQRmfOg7V?=
 =?us-ascii?Q?4ErfNuocrCJZlqeKExeAQDcResyf0YRuXkOAcX4g+JcHM0t8uEtxCsOCbhbO?=
 =?us-ascii?Q?zaMK8xAvP5dvzdI8sWzv2BBAp4j7Y9fi12uEimkQUP4xE93SMiYq4qsFHLHf?=
 =?us-ascii?Q?+HmS8WDkzkfWA7y7I++0w5VLb3by+M3HX5XlWwH+op0WyWDuHjs8TLZergzk?=
 =?us-ascii?Q?6Aqn+5ycUBRhzRhiMQyOBYiPV0lbbxxFaqCfV3cXapfqBSs007Fi7Qssr4A/?=
 =?us-ascii?Q?TkeMMNt3iK+yIh4LgVKm7IvDnnJUM65l4qqsBBRAQm3+PppPCK5UHwLfdNvi?=
 =?us-ascii?Q?fJY6czJyJ4l6ANAcpcbzqAIIcP42jkRp1hfJF5QOq+gfq6959Dpig7CURuQW?=
 =?us-ascii?Q?IN0Alz/D5faP4o+ZItsbxeWqwLr1N5FxVQPCadx+JMjiluvApdGgvXM+5Scr?=
 =?us-ascii?Q?0mYk5/Id7Nm0QDd0a0muKvtUd7iEzYj03fXKxRdLt/i3/gliENDz4lseQ6kM?=
 =?us-ascii?Q?DVBpZFjdY5DfK7SfgbBKn1XeHrRS53UjvG5ic2FsL0mM1FRXVMMygfKVVx6O?=
 =?us-ascii?Q?klplJWetx5S4z4eIgM82uZdSOS8XKzQ6czEjhijycHGp3tejME4g1FDu6LU6?=
 =?us-ascii?Q?7qvWVmog+1Vw60wgsGQmfeeK6dlfUXNs1MwSFGwgZlxplibaQAjZKtRs/E5L?=
 =?us-ascii?Q?h4F8Vi7Rp8xiuI4mL7QWqvON1inrivVkneYG0Th9h3dXnkjzdCeG3soxW1Sh?=
 =?us-ascii?Q?5mq/sM3rMipWhwc3ZlbAG8vJQsbnjnbGQ+Zr3kD/J89UxPjSk1/vVLb9XKfp?=
 =?us-ascii?Q?yrOKVZzPJY9bjJSXwdymWV5Uaomke856oZFNqy22veGUu0mhwEvHR/lAcE/x?=
 =?us-ascii?Q?P12HXlqG+wiIV0iQ+QL/H9CpsITrq455yvT7FLRjglywu4gzvyjSgdX4+scc?=
 =?us-ascii?Q?tfc/RQ0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(7416005)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:33:56.7879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92abd6ca-7cab-4a75-b83f-08dc812ae283
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8825

After the pure mechanical code movement of core SEV guest driver routines,
SEV guest driver is not yet functional. Export SNP guest messaging APIs for
the sev-guest driver. Drop the stubbed routines in sev-guest driver and use
the newly exported APIs

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev.h              | 14 ++++++++++
 arch/x86/kernel/sev.c                   | 23 +++++++++------
 drivers/virt/coco/sev-guest/sev-guest.c | 37 ++-----------------------
 3 files changed, 31 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 109185daff2c..f58052fd6cb3 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -322,6 +322,12 @@ void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
 void sev_show_status(void);
+bool snp_assign_vmpck(struct snp_guest_dev *snp_dev, unsigned int vmpck_id);
+bool snp_is_vmpck_empty(struct snp_guest_dev *snp_dev);
+int snp_guest_messaging_init(struct snp_guest_dev *snp_dev, u64 secrets_gpa);
+void snp_guest_messaging_exit(struct snp_guest_dev *snp_dev);
+int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
+			   struct snp_guest_request_ioctl *rio);
 
 static inline void free_shared_pages(void *buf, size_t sz)
 {
@@ -384,6 +390,14 @@ static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
 static inline void sev_show_status(void) { }
+static inline bool snp_assign_vmpck(struct snp_guest_dev *snp_dev,
+				    unsigned int vmpck_id) { return false; }
+static inline bool snp_is_vmpck_empty(struct snp_guest_dev *snp_dev) { return true; }
+static inline int
+snp_guest_messaging_init(struct snp_guest_dev *snp_dev, u64 secrets_gpa) { return -EINVAL; }
+static inline void snp_guest_messaging_exit(struct snp_guest_dev *snp_dev) { }
+static inline int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
+					 struct snp_guest_request_ioctl *rio) { return -EINVAL; }
 static inline void free_shared_pages(void *buf, size_t sz) { }
 static inline void *alloc_shared_pages(size_t sz) { return NULL; }
 #endif
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index c2508809d4e2..878575b05b2d 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2309,7 +2309,7 @@ static inline u8 *get_vmpck(struct snp_guest_dev *snp_dev)
 	return snp_dev->secrets->vmpck[snp_dev->vmpck_id];
 }
 
-static bool __maybe_unused assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
+bool snp_assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
 {
 	if ((vmpck_id + 1) > VMPCK_MAX_NUM)
 		return false;
@@ -2318,14 +2318,16 @@ static bool __maybe_unused assign_vmpck(struct snp_guest_dev *dev, unsigned int
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(snp_assign_vmpck);
 
-static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
+bool snp_is_vmpck_empty(struct snp_guest_dev *snp_dev)
 {
 	char zero_key[VMPCK_KEY_LEN] = {0};
 	u8 *key = get_vmpck(snp_dev);
 
 	return !memcmp(key, zero_key, VMPCK_KEY_LEN);
 }
+EXPORT_SYMBOL_GPL(snp_is_vmpck_empty);
 
 /*
  * If an error is received from the host or AMD Secure Processor (ASP) there
@@ -2348,7 +2350,7 @@ static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
 {
 	u8 *key = get_vmpck(snp_dev);
 
-	if (is_vmpck_empty(snp_dev))
+	if (snp_is_vmpck_empty(snp_dev))
 		return;
 
 	pr_alert("Disabling VMPCK%u to prevent IV reuse.\n", snp_dev->vmpck_id);
@@ -2392,7 +2394,7 @@ static struct aesgcm_ctx *snp_init_crypto(struct snp_guest_dev *snp_dev)
 	struct aesgcm_ctx *ctx;
 	u8 *key;
 
-	if (is_vmpck_empty(snp_dev)) {
+	if (snp_is_vmpck_empty(snp_dev)) {
 		pr_err("VM communication key VMPCK%u is invalid\n", snp_dev->vmpck_id);
 		return NULL;
 	}
@@ -2573,9 +2575,9 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 	return rc;
 }
 
-static int __maybe_unused snp_send_guest_request(struct snp_guest_dev *snp_dev,
-						 struct snp_guest_req *req,
-						 struct snp_guest_request_ioctl *rio)
+int snp_send_guest_request(struct snp_guest_dev *snp_dev,
+			   struct snp_guest_req *req,
+			   struct snp_guest_request_ioctl *rio)
 {
 	u64 seqno;
 	int rc;
@@ -2622,8 +2624,9 @@ static int __maybe_unused snp_send_guest_request(struct snp_guest_dev *snp_dev,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(snp_send_guest_request);
 
-static int __maybe_unused snp_guest_messaging_init(struct snp_guest_dev *snp_dev, u64 secrets_gpa)
+int snp_guest_messaging_init(struct snp_guest_dev *snp_dev, u64 secrets_gpa)
 {
 	int ret = -ENOMEM;
 
@@ -2677,8 +2680,9 @@ static int __maybe_unused snp_guest_messaging_init(struct snp_guest_dev *snp_dev
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(snp_guest_messaging_init);
 
-static void __maybe_unused snp_guest_messaging_exit(struct snp_guest_dev *snp_dev)
+void snp_guest_messaging_exit(struct snp_guest_dev *snp_dev)
 {
 	if (!snp_dev)
 		return;
@@ -2690,3 +2694,4 @@ static void __maybe_unused snp_guest_messaging_exit(struct snp_guest_dev *snp_de
 	kfree(snp_dev->secret_request);
 	iounmap(snp_dev->secrets);
 }
+EXPORT_SYMBOL_GPL(snp_guest_messaging_exit);
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 567b3684eae5..41878bd968d5 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -34,12 +34,6 @@ static u32 vmpck_id;
 module_param(vmpck_id, uint, 0444);
 MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.");
 
-static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
-{
-	/* Place holder function to be removed after code movement */
-	return true;
-}
-
 static inline struct snp_guest_dev *to_snp_dev(struct file *file)
 {
 	struct miscdevice *dev = file->private_data;
@@ -47,13 +41,6 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
 	return container_of(dev, struct snp_guest_dev, misc);
 }
 
-static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
-				  struct snp_guest_request_ioctl *rio)
-{
-	/* Place holder function to be removed after code movement */
-	return -EIO;
-}
-
 struct snp_req_resp {
 	sockptr_t req_data;
 	sockptr_t resp_data;
@@ -258,7 +245,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 		return -EINVAL;
 
 	/* Check if the VMPCK is not empty */
-	if (is_vmpck_empty(snp_dev)) {
+	if (snp_is_vmpck_empty(snp_dev)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
 		return -ENOTTY;
 	}
@@ -295,12 +282,6 @@ static const struct file_operations snp_guest_fops = {
 	.unlocked_ioctl = snp_guest_ioctl,
 };
 
-static bool assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
-{
-	/* Place holder function to be removed after code movement */
-	return false;
-}
-
 struct snp_msg_report_resp_hdr {
 	u32 status;
 	u32 report_size;
@@ -332,7 +313,7 @@ static int sev_report_new(struct tsm_report *report, void *data)
 		return -ENOMEM;
 
 	/* Check if the VMPCK is not empty */
-	if (is_vmpck_empty(snp_dev)) {
+	if (snp_is_vmpck_empty(snp_dev)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
 		return -ENOTTY;
 	}
@@ -423,18 +404,6 @@ static void unregister_sev_tsm(void *data)
 	tsm_unregister(&sev_tsm_ops);
 }
 
-static int snp_guest_messaging_init(struct snp_guest_dev *snp_dev, u64 secrets_gpa)
-{
-	/* Place holder function to be removed after code movement */
-	return 0;
-}
-
-static void snp_guest_messaging_exit(struct snp_guest_dev *snp_dev)
-{
-	/* Place holder function to be removed after code movement */
-	return;
-}
-
 static int __init sev_guest_probe(struct platform_device *pdev)
 {
 	struct sev_guest_platform_data *data;
@@ -456,7 +425,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ret = -EINVAL;
-	if (!assign_vmpck(snp_dev, vmpck_id)) {
+	if (!snp_assign_vmpck(snp_dev, vmpck_id)) {
 		dev_err(dev, "Invalid VMPCK%d communication key\n", vmpck_id);
 		return ret;
 	}
-- 
2.34.1


