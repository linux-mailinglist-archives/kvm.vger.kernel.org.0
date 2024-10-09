Return-Path: <kvm+bounces-28207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0CA9996567
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:31:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 202441C23F2A
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2956318F2FB;
	Wed,  9 Oct 2024 09:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="z5OyITtc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2082.outbound.protection.outlook.com [40.107.237.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2838818C329;
	Wed,  9 Oct 2024 09:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728466182; cv=fail; b=Li2gzLPmLcAfoTPCAjRY2xnR1+mVipkuylQHMU1Nkrydg3X/RxwsaPIsQrd3R0+wuCjJfyLCmVPhb2UP0l+FlYKRoij9x4IVJ6EDMakUeYVOQzi5ndAPyesBvKsDb3Nm0Ohzg4yFsSj3ZA2IqhWC1UwDMeq7czKQOlAhf4mwXAA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728466182; c=relaxed/simple;
	bh=fyHXB1/sTIBkZ/2FDJDmaL5lB/PTEvBtsb/I3WU17p8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JFMWyxqpIgTqByNDHTDTDl1Xee5e8EQ4oqfr1Z2YFgIP/EWz3dr2BZAhNkPlGlyctCNRgLPAhxsBnnInAWsF2zSxjyNo6o+YXeg2O+xzUK/HfqCyDug+dXwnpZlm+6imIACYiQMcbnslfXgxIeQhYxeudROXAA+XVqSHyLn47a0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=z5OyITtc; arc=fail smtp.client-ip=40.107.237.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=roaWnC2ot0IzbPG+lFuGeyowDu2pML920TH3n60umAlZd6LXRCEIPfH5SoXC5TT3yyyHKy/vu/pkhWfbxSXtgVg/dVLb78vpohWD9p+jH8jF7LIzaS1dWjBSrGEbRKfoc3KOOqtEKVXG47rX5d/0fGZU2klj7dUrOxeVRQjw3lvsJfcLMM/MLLw3F/W9jRf1xwUdLXnaXYl7IVLIywF4RIARfSosJvAyrka+tYhK1pjy28GSA/XT83maN9Geyg9n45/3fp7Lzs6fXpqjHEsdFJjJ+qqzTMhFRkUmQTxEF++G8qa1ERxHTkvA7a2ZPsgBtgayKx4iN3Rv0YTh6wdXyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YvC3dNVSwNLYoRXr+aAdTX/E+5hbYCeZjJbE7g9A4kc=;
 b=lnZ8eXXhTF0YpGDwLUdLEds5Y4VwegxQBylr3Tb3m8gyYo7kzJl2+1yWMpUedzN4MQXCl4WKNsLV3WQTCP88Ol88XGDAuyx74xJvOPo9X2G5Ykp7q+C6Lf8HppwDneZLw5JZWctuY91wPFYfgMh+1xtVDCqFwnwO4opiMoUz0RrJTSYpavVBQVJLo0GD+n9tnJBFtJipeWYaUUBKNdduLHwSHm1BoOJ9cs4lencoMJvncJNWSYJS10e/h8IRA6BBe9iwfBAaxj+50jrVAXdlB5e4aKBLEMSZHPiVHqV/FRr8pjwUYeoxFAS0U71TdSrCQ7L5TmXr9PvgKU0mBqd/xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YvC3dNVSwNLYoRXr+aAdTX/E+5hbYCeZjJbE7g9A4kc=;
 b=z5OyITtc/ESyNM6EkbKa4vYNpar0IoPR874F+XVoz+ieoSqVzh+cSz+m2dnJbYHGxrPMUj0E/uKJxoMOxa9KPASKcr0HIJqU8eiHsCF20R8aTOl4ta+qEi1b+toGVn2eOTJ3nH2x5QDsKPZ6qMYi1eehgOLm7vFhm8sSBWCyAsw=
Received: from BN0PR04CA0093.namprd04.prod.outlook.com (2603:10b6:408:ec::8)
 by LV3PR12MB9403.namprd12.prod.outlook.com (2603:10b6:408:217::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.24; Wed, 9 Oct
 2024 09:29:32 +0000
Received: from BL02EPF00021F6C.namprd02.prod.outlook.com
 (2603:10b6:408:ec:cafe::fb) by BN0PR04CA0093.outlook.office365.com
 (2603:10b6:408:ec::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.17 via Frontend
 Transport; Wed, 9 Oct 2024 09:29:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6C.mail.protection.outlook.com (10.167.249.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 09:29:32 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 9 Oct
 2024 04:29:28 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v12 06/19] virt: sev-guest: Carve out SNP message context structure
Date: Wed, 9 Oct 2024 14:58:37 +0530
Message-ID: <20241009092850.197575-7-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241009092850.197575-1-nikunj@amd.com>
References: <20241009092850.197575-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6C:EE_|LV3PR12MB9403:EE_
X-MS-Office365-Filtering-Correlation-Id: cc4fe99c-8ee7-4224-6e91-08dce844e210
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x1OM6LtzpAS0xHpNzJUscUA4temRYpSvGgxveA3sloqtH/hBqfPJvujouhwu?=
 =?us-ascii?Q?7TutIREe3pxL6mshjpDmgL7Ej5d1rzFveItEog7PjGviNicBCzDShFqwEvZq?=
 =?us-ascii?Q?1qz1vHNMuqtNq9nQd/VOrG0bbUTD5NvLc6icL82Q1cf69Z2rfq53sBVonqki?=
 =?us-ascii?Q?hXf8gjCmdx/wLqbD3FLOGR24tEruNSg9Hhko2Er6eJ32iTN+ssgmWbPBQwOG?=
 =?us-ascii?Q?jlQVTiIAf0DXg9DlmpAshG5bjBVTZ59UBpyErtcCA7iZX0omuE0qoom8gyeW?=
 =?us-ascii?Q?IxrmeRDws7bL9SCIHup/TipX+WlvxU1fwR6WaqvhcBpXcFVRQCOEDEFv4ssY?=
 =?us-ascii?Q?yl8CHno5V3gbDhfg4sgo0YJjKawrErPDP7LfyLy3KJru7KkCCL/YtskvKfuK?=
 =?us-ascii?Q?MaCXtY5DgMKUT6DE8NJ8HOvlYfSXUKlw/CcSw+GKXa7ababaAaKn61Bh+Mm+?=
 =?us-ascii?Q?Cq9jghs9Uohos3BSQ2+BGhsnBv9/eY7F5blwqQPz8XxxvvgiTc9G4LfA4VDL?=
 =?us-ascii?Q?9Z68O4o8kvNVyqz3CmwQIfPVorCxcjzdSNUnkLH/6hegRDztlah9N04M/GBz?=
 =?us-ascii?Q?Gul95rxzC0w0ePqrScxiL23OiCnHHGPQIbyR3D4UNsGHvPLUJ4Lm0e6OXBp+?=
 =?us-ascii?Q?eLZlc5+llYqEXc67D1KS2BYUQ0k005uFNya4NuzuOwr/+wxfJpLBmk/3bfnz?=
 =?us-ascii?Q?nVtFPprZMUpT/pIe/D11NhNj8udG7nl8JVmpcf/iMitqgXzi0cAKHHjSkUJ6?=
 =?us-ascii?Q?EZ8drBfhAPOsw+nFBSr9hd7qtPEoPl14ruHmuSl8sqVfj2E/YN1GktzW3srp?=
 =?us-ascii?Q?KqAU1u6D6KtExZu+0V3qj/NNRn6exB+gKKxaOiJNebrbLkzJKd9Yize4t5wW?=
 =?us-ascii?Q?oMAUVjKckebuDdeB70p6SRDCk5QWyFiuHn25dcWtTBJUjl2ykM31fRbgaA42?=
 =?us-ascii?Q?pt2WJuMcMkm3KVbRboX1N6/8p+IXZqUoriXNMrAoQ4I7DIjsVxrRrt9KSISs?=
 =?us-ascii?Q?gy0CBqFFgD2PABIMe9t5Nxl41yHMNSamIDYkFFfj2hCuzA39bvJKtudD6MnO?=
 =?us-ascii?Q?rdmZ0MFadHp1m43CIW4knAnIjAgXAeRUNo782YbYcMHOxhq1hvxujDtrsX4n?=
 =?us-ascii?Q?w460ybA7vOVlASMidZEnoR//8rNgITSBX0gh1ggoICQJ+WovQ2TMqIXcRsSo?=
 =?us-ascii?Q?nJNkIsjR52ScGjMbTq4ABIx1ru5TpllVdeKLm4o4DGaw5Kv5J7K7TmOxymRY?=
 =?us-ascii?Q?wx41/VEBJkzTOdR5OJ0uwLSrJr41A4muZ9OpOdQ82HV6KwZwyTzZCcDw6EQp?=
 =?us-ascii?Q?01foUVr3MR562lHV2k9QK6l4LN1ryh18+cUc+VC+NJEgVx/xK2RkD/bLpv9w?=
 =?us-ascii?Q?VrXOFcvD+JfkkX/dz9ivE4RRSQHo?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 09:29:32.7290
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc4fe99c-8ee7-4224-6e91-08dce844e210
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9403

Currently, the sev-guest driver is the only user of SNP guest messaging.
The snp_guest_dev structure holds all the allocated buffers, secrets page
and VMPCK details. In preparation for adding messaging allocation and
initialization APIs, decouple snp_guest_dev from messaging-related
information by carving out the guest message context
structure(snp_msg_desc).

Incorporate this newly added context into snp_send_guest_request() and all
related functions, replacing the use of the snp_guest_dev.

No functional change.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/sev.h              |  21 +++
 drivers/virt/coco/sev-guest/sev-guest.c | 178 ++++++++++++------------
 2 files changed, 108 insertions(+), 91 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 27fa1c9c3465..2e49c4a9e7fe 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -234,6 +234,27 @@ struct snp_secrets_page {
 	u8 rsvd4[3744];
 } __packed;
 
+struct snp_msg_desc {
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
+
+	void *certs_data;
+
+	struct aesgcm_ctx *ctx;
+
+	u32 *os_area_msg_seqno;
+	u8 *vmpck;
+};
+
 /*
  * The SVSM Calling Area (CA) related structures.
  */
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 1bddef822446..fca5c45ed5cd 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -40,26 +40,13 @@ struct snp_guest_dev {
 	struct device *dev;
 	struct miscdevice misc;
 
-	void *certs_data;
-	struct aesgcm_ctx *ctx;
-	/* request and response are in unencrypted memory */
-	struct snp_guest_msg *request, *response;
-
-	/*
-	 * Avoid information leakage by double-buffering shared messages
-	 * in fields that are in regular encrypted memory.
-	 */
-	struct snp_guest_msg secret_request, secret_response;
+	struct snp_msg_desc *msg_desc;
 
-	struct snp_secrets_page *secrets;
-	struct snp_req_data input;
 	union {
 		struct snp_report_req report;
 		struct snp_derived_key_req derived_key;
 		struct snp_ext_report_req ext_report;
 	} req;
-	u32 *os_area_msg_seqno;
-	u8 *vmpck;
 };
 
 /*
@@ -76,12 +63,12 @@ MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.
 /* Mutex to serialize the shared buffer access and command handling. */
 static DEFINE_MUTEX(snp_cmd_mutex);
 
-static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
+static bool is_vmpck_empty(struct snp_msg_desc *mdesc)
 {
 	char zero_key[VMPCK_KEY_LEN] = {0};
 
-	if (snp_dev->vmpck)
-		return !memcmp(snp_dev->vmpck, zero_key, VMPCK_KEY_LEN);
+	if (mdesc->vmpck)
+		return !memcmp(mdesc->vmpck, zero_key, VMPCK_KEY_LEN);
 
 	return true;
 }
@@ -103,30 +90,30 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
  * vulnerable. If the sequence number were incremented for a fresh IV the ASP
  * will reject the request.
  */
-static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
+static void snp_disable_vmpck(struct snp_msg_desc *mdesc)
 {
-	dev_alert(snp_dev->dev, "Disabling VMPCK%d communication key to prevent IV reuse.\n",
+	pr_alert("Disabling VMPCK%d communication key to prevent IV reuse.\n",
 		  vmpck_id);
-	memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
-	snp_dev->vmpck = NULL;
+	memzero_explicit(mdesc->vmpck, VMPCK_KEY_LEN);
+	mdesc->vmpck = NULL;
 }
 
-static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
+static inline u64 __snp_get_msg_seqno(struct snp_msg_desc *mdesc)
 {
 	u64 count;
 
 	lockdep_assert_held(&snp_cmd_mutex);
 
 	/* Read the current message sequence counter from secrets pages */
-	count = *snp_dev->os_area_msg_seqno;
+	count = *mdesc->os_area_msg_seqno;
 
 	return count + 1;
 }
 
 /* Return a non-zero on success */
-static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
+static u64 snp_get_msg_seqno(struct snp_msg_desc *mdesc)
 {
-	u64 count = __snp_get_msg_seqno(snp_dev);
+	u64 count = __snp_get_msg_seqno(mdesc);
 
 	/*
 	 * The message sequence counter for the SNP guest request is a  64-bit
@@ -137,20 +124,20 @@ static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
 	 * invalid number and will fail the  message request.
 	 */
 	if (count >= UINT_MAX) {
-		dev_err(snp_dev->dev, "request message sequence counter overflow\n");
+		pr_err("request message sequence counter overflow\n");
 		return 0;
 	}
 
 	return count;
 }
 
-static void snp_inc_msg_seqno(struct snp_guest_dev *snp_dev)
+static void snp_inc_msg_seqno(struct snp_msg_desc *mdesc)
 {
 	/*
 	 * The counter is also incremented by the PSP, so increment it by 2
 	 * and save in secrets page.
 	 */
-	*snp_dev->os_area_msg_seqno += 2;
+	*mdesc->os_area_msg_seqno += 2;
 }
 
 static inline struct snp_guest_dev *to_snp_dev(struct file *file)
@@ -177,13 +164,13 @@ static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
 	return ctx;
 }
 
-static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *req)
+static int verify_and_dec_payload(struct snp_msg_desc *mdesc, struct snp_guest_req *req)
 {
-	struct snp_guest_msg *resp_msg = &snp_dev->secret_response;
-	struct snp_guest_msg *req_msg = &snp_dev->secret_request;
+	struct snp_guest_msg *resp_msg = &mdesc->secret_response;
+	struct snp_guest_msg *req_msg = &mdesc->secret_request;
 	struct snp_guest_msg_hdr *req_msg_hdr = &req_msg->hdr;
 	struct snp_guest_msg_hdr *resp_msg_hdr = &resp_msg->hdr;
-	struct aesgcm_ctx *ctx = snp_dev->ctx;
+	struct aesgcm_ctx *ctx = mdesc->ctx;
 	u8 iv[GCM_AES_IV_SIZE] = {};
 
 	pr_debug("response [seqno %lld type %d version %d sz %d]\n",
@@ -191,7 +178,7 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_gues
 		 resp_msg_hdr->msg_sz);
 
 	/* Copy response from shared memory to encrypted memory. */
-	memcpy(resp_msg, snp_dev->response, sizeof(*resp_msg));
+	memcpy(resp_msg, mdesc->response, sizeof(*resp_msg));
 
 	/* Verify that the sequence counter is incremented by 1 */
 	if (unlikely(resp_msg_hdr->msg_seqno != (req_msg_hdr->msg_seqno + 1)))
@@ -218,11 +205,11 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_gues
 	return 0;
 }
 
-static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_guest_req *req)
+static int enc_payload(struct snp_msg_desc *mdesc, u64 seqno, struct snp_guest_req *req)
 {
-	struct snp_guest_msg *msg = &snp_dev->secret_request;
+	struct snp_guest_msg *msg = &mdesc->secret_request;
 	struct snp_guest_msg_hdr *hdr = &msg->hdr;
-	struct aesgcm_ctx *ctx = snp_dev->ctx;
+	struct aesgcm_ctx *ctx = mdesc->ctx;
 	u8 iv[GCM_AES_IV_SIZE] = {};
 
 	memset(msg, 0, sizeof(*msg));
@@ -253,7 +240,7 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_gues
 	return 0;
 }
 
-static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
+static int __handle_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
 				  struct snp_guest_request_ioctl *rio)
 {
 	unsigned long req_start = jiffies;
@@ -268,7 +255,7 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 	 * sequence number must be incremented or the VMPCK must be deleted to
 	 * prevent reuse of the IV.
 	 */
-	rc = snp_issue_guest_request(req, &snp_dev->input, rio);
+	rc = snp_issue_guest_request(req, &mdesc->input, rio);
 	switch (rc) {
 	case -ENOSPC:
 		/*
@@ -278,7 +265,7 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 		 * order to increment the sequence number and thus avoid
 		 * IV reuse.
 		 */
-		override_npages = snp_dev->input.data_npages;
+		override_npages = mdesc->input.data_npages;
 		req->exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
 
 		/*
@@ -318,7 +305,7 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 	 * structure and any failure will wipe the VMPCK, preventing further
 	 * use anyway.
 	 */
-	snp_inc_msg_seqno(snp_dev);
+	snp_inc_msg_seqno(mdesc);
 
 	if (override_err) {
 		rio->exitinfo2 = override_err;
@@ -334,12 +321,12 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 	}
 
 	if (override_npages)
-		snp_dev->input.data_npages = override_npages;
+		mdesc->input.data_npages = override_npages;
 
 	return rc;
 }
 
-static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
+static int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
 				  struct snp_guest_request_ioctl *rio)
 {
 	u64 seqno;
@@ -348,21 +335,21 @@ static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 	guard(mutex)(&snp_cmd_mutex);
 
 	/* Check if the VMPCK is not empty */
-	if (is_vmpck_empty(snp_dev)) {
-		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
+	if (is_vmpck_empty(mdesc)) {
+		pr_err_ratelimited("VMPCK is disabled\n");
 		return -ENOTTY;
 	}
 
 	/* Get message sequence and verify that its a non-zero */
-	seqno = snp_get_msg_seqno(snp_dev);
+	seqno = snp_get_msg_seqno(mdesc);
 	if (!seqno)
 		return -EIO;
 
 	/* Clear shared memory's response for the host to populate. */
-	memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
+	memset(mdesc->response, 0, sizeof(struct snp_guest_msg));
 
-	/* Encrypt the userspace provided payload in snp_dev->secret_request. */
-	rc = enc_payload(snp_dev, seqno, req);
+	/* Encrypt the userspace provided payload in mdesc->secret_request. */
+	rc = enc_payload(mdesc, seqno, req);
 	if (rc)
 		return rc;
 
@@ -370,27 +357,26 @@ static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 	 * Write the fully encrypted request to the shared unencrypted
 	 * request page.
 	 */
-	memcpy(snp_dev->request, &snp_dev->secret_request,
-	       sizeof(snp_dev->secret_request));
+	memcpy(mdesc->request, &mdesc->secret_request,
+	       sizeof(mdesc->secret_request));
 
-	rc = __handle_guest_request(snp_dev, req, rio);
+	rc = __handle_guest_request(mdesc, req, rio);
 	if (rc) {
 		if (rc == -EIO &&
 		    rio->exitinfo2 == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
 			return rc;
 
-		dev_alert(snp_dev->dev,
-			  "Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
-			  rc, rio->exitinfo2);
+		pr_alert("Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
+			 rc, rio->exitinfo2);
 
-		snp_disable_vmpck(snp_dev);
+		snp_disable_vmpck(mdesc);
 		return rc;
 	}
 
-	rc = verify_and_dec_payload(snp_dev, req);
+	rc = verify_and_dec_payload(mdesc, req);
 	if (rc) {
-		dev_alert(snp_dev->dev, "Detected unexpected decode failure from ASP. rc: %d\n", rc);
-		snp_disable_vmpck(snp_dev);
+		pr_alert("Detected unexpected decode failure from ASP. rc: %d\n", rc);
+		snp_disable_vmpck(mdesc);
 		return rc;
 	}
 
@@ -405,6 +391,7 @@ struct snp_req_resp {
 static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
 	struct snp_report_req *report_req = &snp_dev->req.report;
+	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
 	struct snp_report_resp *report_resp;
 	struct snp_guest_req req = {};
 	int rc, resp_len;
@@ -420,7 +407,7 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(report_resp->data) + snp_dev->ctx->authsize;
+	resp_len = sizeof(report_resp->data) + mdesc->ctx->authsize;
 	report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
 	if (!report_resp)
 		return -ENOMEM;
@@ -434,7 +421,7 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	req.resp_sz = resp_len;
 	req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
 
-	rc = snp_send_guest_request(snp_dev, &req, arg);
+	rc = snp_send_guest_request(mdesc, &req, arg);
 	if (rc)
 		goto e_free;
 
@@ -450,6 +437,7 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 {
 	struct snp_derived_key_req *derived_key_req = &snp_dev->req.derived_key;
 	struct snp_derived_key_resp derived_key_resp = {0};
+	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
 	struct snp_guest_req req = {};
 	int rc, resp_len;
 	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
@@ -463,7 +451,7 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(derived_key_resp.data) + snp_dev->ctx->authsize;
+	resp_len = sizeof(derived_key_resp.data) + mdesc->ctx->authsize;
 	if (sizeof(buf) < resp_len)
 		return -ENOMEM;
 
@@ -480,7 +468,7 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	req.resp_sz = resp_len;
 	req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
 
-	rc = snp_send_guest_request(snp_dev, &req, arg);
+	rc = snp_send_guest_request(mdesc, &req, arg);
 	if (rc)
 		return rc;
 
@@ -500,6 +488,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 
 {
 	struct snp_ext_report_req *report_req = &snp_dev->req.ext_report;
+	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
 	struct snp_report_resp *report_resp;
 	struct snp_guest_req req = {};
 	int ret, npages = 0, resp_len;
@@ -533,7 +522,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	 * the host. If host does not supply any certs in it, then copy
 	 * zeros to indicate that certificate data was not provided.
 	 */
-	memset(snp_dev->certs_data, 0, report_req->certs_len);
+	memset(mdesc->certs_data, 0, report_req->certs_len);
 	npages = report_req->certs_len >> PAGE_SHIFT;
 cmd:
 	/*
@@ -541,12 +530,12 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(report_resp->data) + snp_dev->ctx->authsize;
+	resp_len = sizeof(report_resp->data) + mdesc->ctx->authsize;
 	report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
 	if (!report_resp)
 		return -ENOMEM;
 
-	snp_dev->input.data_npages = npages;
+	mdesc->input.data_npages = npages;
 
 	req.msg_version = arg->msg_version;
 	req.msg_type = SNP_MSG_REPORT_REQ;
@@ -557,11 +546,11 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	req.resp_sz = resp_len;
 	req.exit_code = SVM_VMGEXIT_EXT_GUEST_REQUEST;
 
-	ret = snp_send_guest_request(snp_dev, &req, arg);
+	ret = snp_send_guest_request(mdesc, &req, arg);
 
 	/* If certs length is invalid then copy the returned length */
 	if (arg->vmm_error == SNP_GUEST_VMM_ERR_INVALID_LEN) {
-		report_req->certs_len = snp_dev->input.data_npages << PAGE_SHIFT;
+		report_req->certs_len = mdesc->input.data_npages << PAGE_SHIFT;
 
 		if (copy_to_sockptr(io->req_data, report_req, sizeof(*report_req)))
 			ret = -EFAULT;
@@ -570,7 +559,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	if (ret)
 		goto e_free;
 
-	if (npages && copy_to_sockptr(certs_address, snp_dev->certs_data, report_req->certs_len)) {
+	if (npages && copy_to_sockptr(certs_address, mdesc->certs_data, report_req->certs_len)) {
 		ret = -EFAULT;
 		goto e_free;
 	}
@@ -994,6 +983,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	struct snp_secrets_page *secrets;
 	struct device *dev = &pdev->dev;
 	struct snp_guest_dev *snp_dev;
+	struct snp_msg_desc *mdesc;
 	struct miscdevice *misc;
 	void __iomem *mapping;
 	int ret;
@@ -1018,43 +1008,47 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	if (!snp_dev)
 		goto e_unmap;
 
+	mdesc = devm_kzalloc(&pdev->dev, sizeof(struct snp_msg_desc), GFP_KERNEL);
+	if (!mdesc)
+		goto e_unmap;
+
 	/* Adjust the default VMPCK key based on the executing VMPL level */
 	if (vmpck_id == -1)
 		vmpck_id = snp_vmpl;
 
 	ret = -EINVAL;
-	snp_dev->vmpck = get_vmpck(vmpck_id, secrets, &snp_dev->os_area_msg_seqno);
-	if (!snp_dev->vmpck) {
+	mdesc->vmpck = get_vmpck(vmpck_id, secrets, &mdesc->os_area_msg_seqno);
+	if (!mdesc->vmpck) {
 		dev_err(dev, "Invalid VMPCK%d communication key\n", vmpck_id);
 		goto e_unmap;
 	}
 
 	/* Verify that VMPCK is not zero. */
-	if (is_vmpck_empty(snp_dev)) {
+	if (is_vmpck_empty(mdesc)) {
 		dev_err(dev, "Empty VMPCK%d communication key\n", vmpck_id);
 		goto e_unmap;
 	}
 
 	platform_set_drvdata(pdev, snp_dev);
 	snp_dev->dev = dev;
-	snp_dev->secrets = secrets;
+	mdesc->secrets = secrets;
 
 	/* Allocate the shared page used for the request and response message. */
-	snp_dev->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
-	if (!snp_dev->request)
+	mdesc->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
+	if (!mdesc->request)
 		goto e_unmap;
 
-	snp_dev->response = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
-	if (!snp_dev->response)
+	mdesc->response = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
+	if (!mdesc->response)
 		goto e_free_request;
 
-	snp_dev->certs_data = alloc_shared_pages(dev, SEV_FW_BLOB_MAX_SIZE);
-	if (!snp_dev->certs_data)
+	mdesc->certs_data = alloc_shared_pages(dev, SEV_FW_BLOB_MAX_SIZE);
+	if (!mdesc->certs_data)
 		goto e_free_response;
 
 	ret = -EIO;
-	snp_dev->ctx = snp_init_crypto(snp_dev->vmpck, VMPCK_KEY_LEN);
-	if (!snp_dev->ctx)
+	mdesc->ctx = snp_init_crypto(mdesc->vmpck, VMPCK_KEY_LEN);
+	if (!mdesc->ctx)
 		goto e_free_cert_data;
 
 	misc = &snp_dev->misc;
@@ -1063,9 +1057,9 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	misc->fops = &snp_guest_fops;
 
 	/* Initialize the input addresses for guest request */
-	snp_dev->input.req_gpa = __pa(snp_dev->request);
-	snp_dev->input.resp_gpa = __pa(snp_dev->response);
-	snp_dev->input.data_gpa = __pa(snp_dev->certs_data);
+	mdesc->input.req_gpa = __pa(mdesc->request);
+	mdesc->input.resp_gpa = __pa(mdesc->response);
+	mdesc->input.data_gpa = __pa(mdesc->certs_data);
 
 	/* Set the privlevel_floor attribute based on the vmpck_id */
 	sev_tsm_ops.privlevel_floor = vmpck_id;
@@ -1082,17 +1076,18 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	if (ret)
 		goto e_free_ctx;
 
+	snp_dev->msg_desc = mdesc;
 	dev_info(dev, "Initialized SEV guest driver (using VMPCK%d communication key)\n", vmpck_id);
 	return 0;
 
 e_free_ctx:
-	kfree(snp_dev->ctx);
+	kfree(mdesc->ctx);
 e_free_cert_data:
-	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
+	free_shared_pages(mdesc->certs_data, SEV_FW_BLOB_MAX_SIZE);
 e_free_response:
-	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
+	free_shared_pages(mdesc->response, sizeof(struct snp_guest_msg));
 e_free_request:
-	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
+	free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
 e_unmap:
 	iounmap(mapping);
 	return ret;
@@ -1101,11 +1096,12 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 static void __exit sev_guest_remove(struct platform_device *pdev)
 {
 	struct snp_guest_dev *snp_dev = platform_get_drvdata(pdev);
+	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
 
-	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
-	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
-	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
-	kfree(snp_dev->ctx);
+	free_shared_pages(mdesc->certs_data, SEV_FW_BLOB_MAX_SIZE);
+	free_shared_pages(mdesc->response, sizeof(struct snp_guest_msg));
+	free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
+	kfree(mdesc->ctx);
 	misc_deregister(&snp_dev->misc);
 }
 
-- 
2.34.1


