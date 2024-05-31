Return-Path: <kvm+bounces-18476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C79218D596D
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:34:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E6281F231A0
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 368E07E78E;
	Fri, 31 May 2024 04:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OpkoHNYU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FE37D096;
	Fri, 31 May 2024 04:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717129990; cv=fail; b=nA0hL6ozOOpVjiwqqGUT0/jYewU269PWbyKi3NjwWzECZA40GAXgICbuoBKtkWsLQ2uCsMfBhVTjJwx5TTUDXMejcwq1tIj6BGzPThzyTBh27MBoJ3eb9mkI98uTIe5vP41Q1fAX5mJ5CeIMz0Cz5ss19CE+YosYXafhza4PnUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717129990; c=relaxed/simple;
	bh=JhzeNpCXiZt+ZCmy09NVMPrWAFQsr8TlaBbEBA4NAQ0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fo8FmNJpHDmWFGRg1cqwuPraTzU0SCL8BTzw2PspDulVvkr35YH4S+LE8uywnyTwaiJI3WcQeMXVMwyUTBhNexJdLfbOwYFCa1HUjcUOolH5hKGXfNdZxAB0O4tyW30rdjg3887R1x6LPXuYzB+bygQ7lF/pZdr9WZaZlXcyeBE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OpkoHNYU; arc=fail smtp.client-ip=40.107.93.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnB5C3L8VbRq5gP9m8Q4ANldP9HILMfCpYhMes7UfCAAObdexnFnkATRC80dcRWvRLUxCSeo1c4AjABXveOqgSnITEhpFya6+mPzv/iAclhAjqtoxj3ScWRwg2PQoNQCKUnZpUkWL+FrhMyCEWI0+quMAIibrQRMhM6t1y/3AbEeYbN8ZIDTC0GOObya0w67QWmqyI3iQmnTFdgWoPwX6OmHDqvbKID0ea11im44YdrpT5ActNLN+cEliPPdd0a2Rmql62N8KMrXwy5jYxbMcBNW72pNy8ZmAbF+XL1GJuauuNxZnubHspIyZEr2CEvYSp5lSN6y4AXl7/DOGk40gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xRBQlAHS9rNdGZeioNgGfyyZkvzGqblc/uPtEahNQDw=;
 b=g55vsHw6Sd+zaYfu7Tw7R7ITx6arfCvS70p1w5sPDi/4O9FJWEZjWhhLNhPwqtO5HKuOlFkGJEtEynk1nnOHeBsGG588RKBZhIHeAzR3QC6pdaSKmEfoEtoplURUUqQLUI1dwQwqMAYzEB+JD6Mt47zKrDw+qndhj8x1Ur0oMznIVwXmDGURlOvSIYU2kT9Iq5Q4GwlGSMFxjMmH0JBhqJcJjh4rbNPmlAVZk4b4zr6La6+j8m2ALOmfAAC2+Yff0/kMtcTqBS/OA401v9gM3yTx+z4gjBGMlU6qK1LJ3hY6y1Ytj4+YLLlZZI1Tn2IUPhkiFBZYWlUub1B5dEGJcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRBQlAHS9rNdGZeioNgGfyyZkvzGqblc/uPtEahNQDw=;
 b=OpkoHNYUhLv9c0ebM3MnNRJfjyjvf36vYOb+Xkm0aeXuiPBBJ0eso89iZwtqfTQe7IPgN0G8xHMsaUsAKuLh2aMuR0QOBSVf3jUR2PM3EivSHpm2arJL15fgMYytbCzPmcNGYGZVoRWnN7iuRnUPc+QrgEpYocNss5HoLV0tWqQ=
Received: from DM6PR08CA0063.namprd08.prod.outlook.com (2603:10b6:5:1e0::37)
 by CYYPR12MB8991.namprd12.prod.outlook.com (2603:10b6:930:b9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Fri, 31 May
 2024 04:33:06 +0000
Received: from DS3PEPF000099D9.namprd04.prod.outlook.com
 (2603:10b6:5:1e0:cafe::4a) by DM6PR08CA0063.outlook.office365.com
 (2603:10b6:5:1e0::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24 via Frontend
 Transport; Fri, 31 May 2024 04:33:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D9.mail.protection.outlook.com (10.167.17.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:33:00 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:32:19 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 06/24] virt: sev-guest: Simplify VMPCK and sequence number assignments
Date: Fri, 31 May 2024 10:00:20 +0530
Message-ID: <20240531043038.3370793-7-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D9:EE_|CYYPR12MB8991:EE_
X-MS-Office365-Filtering-Correlation-Id: c110c2ce-c623-404c-0974-08dc812ac0df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|376005|1800799015|82310400017|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DIKGTTkux+JqAHNBuqoXmsFHS8aiE8YnjngImfL0Pq9yj/0BPKFFwtMWPgtd?=
 =?us-ascii?Q?qqyoWqnP21Cja2nRXXfO4GsTwbhYjfhkSZyoGKJf1mblECYlzfiOC813apxq?=
 =?us-ascii?Q?cpq7oiiL3L08AnL6u4tQlYwmgwqMRAMxwr6qpBZ4/yb7hvpq6Rl8qX333dBu?=
 =?us-ascii?Q?hqjoaPuhlQ74wMoinVAKHsiLDN0MK9mhZPWvTYBzv4VDGf0wmo20KvEEyvpd?=
 =?us-ascii?Q?jvYwGW8NBBKsRMdKQJtDtHQWSGA6ib3mdqjYc2xFyGAwuJuxosclETH4UXvw?=
 =?us-ascii?Q?TXWvCybKo7oRkbmqh2BnNk8PSLEUw/HbfHK/ydIMBWbbabu/d/mugYsXSzf0?=
 =?us-ascii?Q?BvPO/iIuRJ5YmmGsvOgd1BPWR2mmG7vfft0tVhAUeQPvz/CdFIH/MNaIGl5m?=
 =?us-ascii?Q?dz/0pp+P8k9791pemD4gkJQZRBBzH/GDBltAUPgjYH5iEbAMLIPfZHiBhzE7?=
 =?us-ascii?Q?ZzkZMhE3po6yabJZQ8j6ZmBnCndZ0UTC7fY0UP9uzBJRA+g/hqe4HlwTPyc6?=
 =?us-ascii?Q?GZuKx7+gn7FB9ZJEcESxrJ+ER8+9h6OTsrRQQgVragtFIaugdodMrIFoQsYq?=
 =?us-ascii?Q?XXQKAnU4htk+AHN774sq1dpGEL7ZK+kSqH1Ll7IcVv7RAYL2I2nvPhmyR5zM?=
 =?us-ascii?Q?DcY6H/nElhm9qM2rEp9RnPj95br8IWP78if/5BlmtdcfPF0SXLInj60cn2db?=
 =?us-ascii?Q?Kwc87lb5ZZNtUVvb38Jmh9tQInZFWqj1QReCgFzc/UUz3RWxgNMqGS6fLzNF?=
 =?us-ascii?Q?0H1MJzC680Ol7OJFfJF+L3a3eMryo/RIZWPJc60GrVhX1pt0VOc0e9y5IPWr?=
 =?us-ascii?Q?tzYPMTdwvrRCFnwt4pp6K4HZbIMig12jQGTIspiWCq/bh8rmAtppLPdMS92o?=
 =?us-ascii?Q?wFeFphHAbYWljFd1fRTnbrXFr6V/tHWyudRLOnjNbXT5QQOtKKnGq6K72x5O?=
 =?us-ascii?Q?7Yjk3n0bThj7F+lRYzMWgsoT42ELhxxQDnE9PmbdpnXXWW09dtbCPMo6iJLp?=
 =?us-ascii?Q?96Lrz0DCsALhezAvzSDKxW5nppLPFf9HdQS9hyRaqrBtGOcdkSwahzeuIWQt?=
 =?us-ascii?Q?VAhy1DU2HtWhRX1jd/PNlFoM2glMRP73lG6fZ3WIFmW13q9T4uX+p6rvgeFM?=
 =?us-ascii?Q?V5UC2QPRgjfyvVe1Y+XE5FwQ1QVHUXBU4E0CVDSIJz6MZCMoNLsInMmRb+G6?=
 =?us-ascii?Q?BuPKQLc/e9T/4Gia9t1ACz+65pHTH/+U8RURy0W3bodU4GVPk+q3PjQZ6xyv?=
 =?us-ascii?Q?oHeZc+GOBtlAviAXGPgjAfIk9KZqv8COlDdlCLb8tGDSf46tMvomq6XCGDIo?=
 =?us-ascii?Q?ij9s1pdRajirHf6NM1rOyIqzAkqz969sMwJ4rfm6XrR6LfJxH7YCffzcXkIo?=
 =?us-ascii?Q?zkavhSlPnquR+aByoBD3RYOjhhDr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(1800799015)(82310400017)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:33:00.3282
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c110c2ce-c623-404c-0974-08dc812ac0df
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8991

Preparatory patch to remove direct usage of VMPCK and message sequence
number in the SEV guest driver. Use arrays for the VM platform
communication key and message sequence number to simplify the function and
usage.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev.h              | 12 ++++-------
 drivers/virt/coco/sev-guest/sev-guest.c | 27 ++++---------------------
 2 files changed, 8 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index dbf17e66d52a..d06b08f7043c 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -118,6 +118,8 @@ struct sev_guest_platform_data {
 	u64 secrets_gpa;
 };
 
+#define VMPCK_MAX_NUM		4
+
 /*
  * The secrets page contains 96-bytes of reserved field that can be used by
  * the guest OS. The guest OS uses the area to save the message sequence
@@ -126,10 +128,7 @@ struct sev_guest_platform_data {
  * See the GHCB spec section Secret page layout for the format for this area.
  */
 struct secrets_os_area {
-	u32 msg_seqno_0;
-	u32 msg_seqno_1;
-	u32 msg_seqno_2;
-	u32 msg_seqno_3;
+	u32 msg_seqno[VMPCK_MAX_NUM];
 	u64 ap_jump_table_pa;
 	u8 rsvd[40];
 	u8 guest_usage[32];
@@ -145,10 +144,7 @@ struct snp_secrets_page {
 	u32 fms;
 	u32 rsvd2;
 	u8 gosvw[16];
-	u8 vmpck0[VMPCK_KEY_LEN];
-	u8 vmpck1[VMPCK_KEY_LEN];
-	u8 vmpck2[VMPCK_KEY_LEN];
-	u8 vmpck3[VMPCK_KEY_LEN];
+	u8 vmpck[VMPCK_MAX_NUM][VMPCK_KEY_LEN];
 	struct secrets_os_area os_area;
 	u8 rsvd3[3840];
 } __packed;
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 5c0cbdad9fa2..a3c0b22d2e14 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -668,30 +668,11 @@ static const struct file_operations snp_guest_fops = {
 
 static u8 *get_vmpck(int id, struct snp_secrets_page *secrets, u32 **seqno)
 {
-	u8 *key = NULL;
-
-	switch (id) {
-	case 0:
-		*seqno = &secrets->os_area.msg_seqno_0;
-		key = secrets->vmpck0;
-		break;
-	case 1:
-		*seqno = &secrets->os_area.msg_seqno_1;
-		key = secrets->vmpck1;
-		break;
-	case 2:
-		*seqno = &secrets->os_area.msg_seqno_2;
-		key = secrets->vmpck2;
-		break;
-	case 3:
-		*seqno = &secrets->os_area.msg_seqno_3;
-		key = secrets->vmpck3;
-		break;
-	default:
-		break;
-	}
+	if ((id + 1) > VMPCK_MAX_NUM)
+		return NULL;
 
-	return key;
+	*seqno = &secrets->os_area.msg_seqno[id];
+	return secrets->vmpck[id];
 }
 
 struct snp_msg_report_resp_hdr {
-- 
2.34.1


