Return-Path: <kvm+bounces-20253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D54D59125B8
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:43:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 990D9B25853
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:42:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E08A15EFA7;
	Fri, 21 Jun 2024 12:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nrnGpvlG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0541215DBA8;
	Fri, 21 Jun 2024 12:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973592; cv=fail; b=cYT6E+UPua/XdIentVzHhMRWWn1w2UwPHNl06e7A+6Awqm1yRSCDD2E8+rJEY1Cmv2fF25H8Eo9Nw8Cup+OJIMTzDQY28BwvkXfgNl9Y4kCzjFFmkuHv7Vkiko4qXmLddcZoD6zqrp5JyZOcL/RfuLHx1ALd/DRji8oy20byNxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973592; c=relaxed/simple;
	bh=0xXPqfPOqcXqW3fe4qUvWylRRJSfj42B3OrLs8XJaIg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=inoQXWiUkWnGcY/T0nctNp1IZmCq31GWTvBKniBo69EIN/3YO5vC92IflYGOyOVnnxTWNcezGdnVxMScrmAxjzO6ItvQafaoogbhCAhxczxBC5wvU/SJSbghAFvXJjkWdNATmb/r4gibhwlKPGBGDw3yJfpm4jEe268wQXf8E30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nrnGpvlG; arc=fail smtp.client-ip=40.107.93.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXTlYTI1DRhd1B44QghmJvPtWRetjSYnZSq+dHM1f760d9z+42lv7G0THRNn/jDuFwsqfnjBRBKewsVbveiym097XSCX1QxNq7h3Hz+PIDW6houSKf419E7gSatZyaUI9L2j9bGEfjeYCrnlPjKuLxMTOmzVDrLrVD3M7Gp81w9jSbI+RBJkl5151wrNBXT5vKAGCZ84ntO0ykkH2geQKMkRBRDM+qCU3nJrDy9WkbBbicr0kpovBM+xqwT79MmbM1nRdPL5WEGDdwbvW3YJpY8IKFFhgH1mBMEYixZ7s1XTSdxQaPXRM6J56+sAE2DDShc3xa9mnx1LFLkNLj6BTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SYYzSR5VgTyFcQNFDcLQN3cQD5ig8K5bIodpqw1JEno=;
 b=Nw+/L4wuIuFXvkQeivhsmd7Yx9urk9wDQD9pupB45AGXtCeE+kN43Xru+qZdVcbSUpAgzsg+UJXE6BwnU2qrKau2ejoojuQkAR2S0QUo0YoplTR/huT5FQ41B6IdqcSEhn9Xid00wYVcRwXFyAJEqty2Dmc626CgyRS44oMZdfX4nyPTT5vZdP/H7v+G9DYYO/gd5Bz4KTUHSOcuWJoxTswj6k+fZ0+Pwsp5xYQN07L482iwgC3mDKVCdDHYQr4tEd/vo/3v71agsZuax9/HyS+6C8ThjylCiWvArpumaCQVI8mv3mbOkWpJ4Tb2+XvDTlzUBg9VOdeNXS75/FZpbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYYzSR5VgTyFcQNFDcLQN3cQD5ig8K5bIodpqw1JEno=;
 b=nrnGpvlGloIUSKQ8JZ7tbX/FzIgD2ZX4ZJqidUubIvrAaf3oLgnXPFo9OT1ZqjQOueKmVhGIiOGktu0YXEc/54js21pkd6ocKQhL705Snygn74z2STdjS2pcJVpXNQNBXts8c37/3enHDNE7kteJxeqOIadtqZkkL6n/SVsm7/c=
Received: from PH7PR13CA0007.namprd13.prod.outlook.com (2603:10b6:510:174::17)
 by PH7PR12MB6785.namprd12.prod.outlook.com (2603:10b6:510:1ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Fri, 21 Jun
 2024 12:39:48 +0000
Received: from SN1PEPF00036F3F.namprd05.prod.outlook.com
 (2603:10b6:510:174:cafe::5e) by PH7PR13CA0007.outlook.office365.com
 (2603:10b6:510:174::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.33 via Frontend
 Transport; Fri, 21 Jun 2024 12:39:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3F.mail.protection.outlook.com (10.167.248.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:39:48 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:39:43 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 06/24] virt: sev-guest: Simplify VMPCK and sequence number assignments
Date: Fri, 21 Jun 2024 18:08:45 +0530
Message-ID: <20240621123903.2411843-7-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240621123903.2411843-1-nikunj@amd.com>
References: <20240621123903.2411843-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3F:EE_|PH7PR12MB6785:EE_
X-MS-Office365-Filtering-Correlation-Id: 7addae28-dd80-46e4-cbfa-08dc91ef3ccd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|36860700010|82310400023|1800799021|376011|7416011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mevHdGhcq+j3bbGaJ4XQTz4CRyy5YIx68MyWFgYzhOlVawAhFUQER4rScCJX?=
 =?us-ascii?Q?GcfWR8vG8UzbMezq1trjFiRGpqkYuOUEN2oUlTClmMgsw06NrJMwoRMXn9mX?=
 =?us-ascii?Q?6OO17lbwGPY3leDpzjgKTE3ZnibHseHVI35ueEZ49sH12j+dhAfzFMy4OyPg?=
 =?us-ascii?Q?vo4PB4PDPKbjFxScUBKYXLU9jUQ+SdICYNaESXFprILVV7DSdnIo5EaVJy2B?=
 =?us-ascii?Q?rZOoK5Z+6BSqJm1ZeqiKnlmTK4W4V7vEqrVk6xee0/r83j1rers5fQOoaQj5?=
 =?us-ascii?Q?LdsRNhknVEI78s39ne69LwKnnxRmTWTCr3I7eE80B/lbacbODmquV17Sc4Ki?=
 =?us-ascii?Q?OM7UFO1mRFfgsfb8WctGl/eHWh3IlQqWZVNV2uvuQNojcukDTueSJqiWryUu?=
 =?us-ascii?Q?S+sdAqf56nHgMXQJT40XBbeNDFZmZ3PpGW5iG3wClmEVJXPZlEghHpQoZ7d4?=
 =?us-ascii?Q?fn64Yil0UuBqqAkKCZEuNjqEMa77gqJg/5JFDOAExrxlI1iBraUECLsuInYQ?=
 =?us-ascii?Q?j1iNpY6UHk+PP8NSCtul/byt7a+maXN5XTJwMEAEPzdlJB/0dWUZ7uyCM438?=
 =?us-ascii?Q?hqgrwmUk+3FYsbvJMh53l+kzBQCdhsXPSNzy5vvgBWpDWsiFI1RHzspvlnSk?=
 =?us-ascii?Q?bc8dm3KlnM+kOoZH++spx/K+RlRmCbf2Yvhv4naMvKCJ/mDFzrDeluGt26r2?=
 =?us-ascii?Q?3+mhO6+PC3BUZWcG9ipnVahZfDuhdTvS0A44oKc2oso2yZLXRM4VeudGKiSC?=
 =?us-ascii?Q?XOJzF8sAWsZ+W9Ayx0fv78WNBv5nBqi+bOPCkk6pcOOx77Nr64kPUjg5b3ZP?=
 =?us-ascii?Q?1FDsRDvmLtapAmJ1Wl2H1lTse1aQAOkr6rlBB3uLi3ml4HXE6HbB9Og+E6OX?=
 =?us-ascii?Q?cXR3BiljPf4Ut661o0oIBiNlDJS5Cs4HKDJPHFAZvHncrq+Y8Mhts5b6Xn1g?=
 =?us-ascii?Q?wIR0Mdje0zW3njGkRbNKwgWsDpzsCHsTT3Zw3dVbVAdwRqmVKjMyX8vighQH?=
 =?us-ascii?Q?EygbQLJ/jGYwEtI9bdy1Us5srWRfKZqYasA9DBh2eR82TL6azhZzG3CWulbf?=
 =?us-ascii?Q?SNPImSZ1YKU+/x+Qd9z98X2oaEM52YT05GUgsJRpvA3dPTR/p1EcK+79T0TN?=
 =?us-ascii?Q?YtbGtf2mhWET84hSCxTYFKC98NRJ/N1tED46TBgVxtQJ4pGnb5O7RVbfllCy?=
 =?us-ascii?Q?YYXu7gHxHwVagUOyxg56LdMmMPsl3uezw2J+fYXgoOJ6nKZr2c6gmW9CpGyB?=
 =?us-ascii?Q?SHO2HrI4GXNWuPdPWdSlM8psCirLEpZe14+HIH8Lkls/0IUem/KbC5FzBT6V?=
 =?us-ascii?Q?/ABa3ptIiSmMWyjsYB7BRMxixF/k+5xZW2shaOiu5KJkyXm52z+43Gxrj9tH?=
 =?us-ascii?Q?eZSMqeEMhatggGPPiK4pNnX0tB6Zq5DwzaCQYzUksuRLvu6NyQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(36860700010)(82310400023)(1800799021)(376011)(7416011);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:39:48.0911
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7addae28-dd80-46e4-cbfa-08dc91ef3ccd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6785

Preparatory patch to remove direct usage of VMPCK and message sequence
number in the SEV guest driver. Use arrays for the VM platform
communication key and message sequence number to simplify the function and
usage.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/sev.h              | 12 ++++-------
 drivers/virt/coco/sev-guest/sev-guest.c | 27 ++++---------------------
 2 files changed, 8 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 2ac899adcbf6..473760208764 100644
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
@@ -214,10 +213,7 @@ struct snp_secrets_page {
 	u32 fms;
 	u32 rsvd2;
 	u8 gosvw[16];
-	u8 vmpck0[VMPCK_KEY_LEN];
-	u8 vmpck1[VMPCK_KEY_LEN];
-	u8 vmpck2[VMPCK_KEY_LEN];
-	u8 vmpck3[VMPCK_KEY_LEN];
+	u8 vmpck[VMPCK_MAX_NUM][VMPCK_KEY_LEN];
 	struct secrets_os_area os_area;
 
 	u8 vmsa_tweak_bitmap[64];
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 61e190ecfa3a..a5602c84769f 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -678,30 +678,11 @@ static const struct file_operations snp_guest_fops = {
 
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
+	if (!(id < VMPCK_MAX_NUM))
+		return NULL;
 
-	return key;
+	*seqno = &secrets->os_area.msg_seqno[id];
+	return secrets->vmpck[id];
 }
 
 struct snp_msg_report_resp_hdr {
-- 
2.34.1


