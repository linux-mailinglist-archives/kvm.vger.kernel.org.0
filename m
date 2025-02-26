Return-Path: <kvm+bounces-39257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E976A45999
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:11:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1BE8188F05D
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E669226CF3;
	Wed, 26 Feb 2025 09:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bz2P3nMs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2088.outbound.protection.outlook.com [40.107.96.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F824207A11;
	Wed, 26 Feb 2025 09:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740560969; cv=fail; b=dDl9wC8tYUvg6OPJSVRFyuFrharu/YBzcWUQPs34EhLYzMqLmn4pp500+pf76Rma2ipUc7iecgP7xi4B7C0B6oSCobT/jr+CNp7cFqVj7zhziDLZaKox/64BekMNwOQpspPu/PVskq1xpl0FryOm3Jm5GNDpPHB9dBOGCuxSOQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740560969; c=relaxed/simple;
	bh=h/pt1aHaHip5Kqqwlr73A9STFhfHL9DR6wZEVDuN+44=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pO8SuE0LXaWT/tr4mLcTWD1keDNvOvHCFGjWPcwFgsG+zXFypJI+3QTei8iDilSKZ9LOwPcsbSQxl7JIC6JYFppYUS3PwIQTU+snNVlQun+ZegKwqlFrgHpRxpUpDFFN3/Of6QB89Wdt7AyLIpKi83Pz+sQpCeP5bPRZ6dlkGZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bz2P3nMs; arc=fail smtp.client-ip=40.107.96.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dJTXM0gTE1qcfljjtNPty79GuDRlYVZTo5gEEapNihopDn0nFDEm8ILauhMZn30OQ/ykijmb0iAkKgFR1wIYDGSjav0IhAiV9Cv2u2XVSqOYEo8mtCzx4EbhRvcDA3ZtuAVQLik6eZ2kvEEeD/Absyz0TVPCKZJTlDlBTux/aWKbsIzdY5iJ33vsCG62ynKlO72EC5L3k/7pHgKdGaN3TTdP6qqvhT479hgxRoUJ0ASkpiJPUKm+GBUr5iOC2GbsFpD4PSPmKLKjVKpgC0myY9gty44nCouKYsiaL0KN6snbqt4vobl2X3wZ7YXIrWORDo3J3kd1M/5xewnfrmDwaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LT8TAtTvHnJKQYu5eVpuIzo0wqOku7EBcHxda85Dcjw=;
 b=AuVXzZYlXvRdr6r16KGDPSt/EE+UZjq99WtxgVbr5WcCxEatGnyOkxE6tf3PWJAQA6GKp3r4EUQimcvWI9oLZq4CowgaACn6GLEuZBs69FtDu9HndHE+r0EjkEDksOzK4dceee/69NbBMmEgqA2BTl+VgZoP8s54Vx8/0b8/JTWa726xDLJxbzsg2+KamfDTKymoT+xu4IC7ysg33M3D8D4KcYEvNyIrg9M6M1ptZ2zVLU2blEfdojOeth5dhK6/Fw0afxH+mmRnytWrtE0Yqzo8/BTDM61LW/60A9XrgOJQPjts98/ERg0jqw7mHiPpxBqBQ9XM8WDsdaij8uzwnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LT8TAtTvHnJKQYu5eVpuIzo0wqOku7EBcHxda85Dcjw=;
 b=bz2P3nMsdKqRx6P9hgzPNIkcy9b12PRTBMRHQBUdBqdAKBPH9N/t4TdNXDIQwY7uFrpL46hjIB4K84PhVDdfulvJTrYeqAnnhY7VtRH01sBUJivvGJXtReT6Ay80R7h4eLStC7rN+J9juHhCRZfBTHkbGvxv5tdk9CwpNNbZNm4=
Received: from SJ0PR13CA0060.namprd13.prod.outlook.com (2603:10b6:a03:2c2::35)
 by MN0PR12MB6197.namprd12.prod.outlook.com (2603:10b6:208:3c6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Wed, 26 Feb
 2025 09:09:24 +0000
Received: from SJ1PEPF00002323.namprd03.prod.outlook.com
 (2603:10b6:a03:2c2:cafe::4b) by SJ0PR13CA0060.outlook.office365.com
 (2603:10b6:a03:2c2::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.14 via Frontend Transport; Wed,
 26 Feb 2025 09:09:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002323.mail.protection.outlook.com (10.167.242.85) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 09:09:24 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Feb
 2025 03:09:18 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>, <naveen.rao@amd.com>
Subject: [RFC v2 12/17] x86/apic: Read and write LVT* APIC registers from HV for SAVIC guests
Date: Wed, 26 Feb 2025 14:35:20 +0530
Message-ID: <20250226090525.231882-13-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002323:EE_|MN0PR12MB6197:EE_
X-MS-Office365-Filtering-Correlation-Id: e6974045-429b-4a7a-0413-08dd564543d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mLtoRA2fkwcyAtOAchqHuMNZ6NpPWNZA3r/FNyOSRyJqTvdETwsmMyMG263a?=
 =?us-ascii?Q?EE3J9uSRrS3iAsz0Qi0+X1a8MJiPP81e2xSHBsKHIZLD2+ql67amm21CgtPF?=
 =?us-ascii?Q?Hec9F8S+zNYgVLwvZG5H8h0QF2dSRruqQIiGLxPDbclllNhMZ99yuKf8eQdX?=
 =?us-ascii?Q?jxao8mAOzPUbpRXwXLfV3ts1hosuMJKHNqy9g3UnJTWkd+PMxD9QTcHpx0jf?=
 =?us-ascii?Q?1VsfxvC5N04RSeuZFMew9oRmHtQOYJISIv+YCf3wN+GM3ID5WRzQcXI7lchB?=
 =?us-ascii?Q?oeX11aSjcaGY8gmyfgMGODd/vOi4M5yXVbe4SnloYBnO08ywu7kC+hv3mO4u?=
 =?us-ascii?Q?em4eDbGwVqVLMhMbHesgCCsVmAUQ51bNam9mWwSotdlvRE74pZVzmbeNaxVz?=
 =?us-ascii?Q?SZA7shOYHpyZFYt8bsM7UEtJlvoV79HDIBjG/APfguM7rTvwpMRFOtAUFXXP?=
 =?us-ascii?Q?7xaIGMFpYqH8D5nAbdzl4eQ+OtA2cvbwtbfpTU0D5MuniHiHmJ+SspbXJ8Lf?=
 =?us-ascii?Q?4ymc4nXjXQ6u4HqAEwB7UumqzIKySxxptksXuMmPwGUSjg6OUWDRLLeFZ1dv?=
 =?us-ascii?Q?c5aK5cdL2+yLDURJuH9peEIrW9fjEt1Q2MfMqIWg5layocYlJn75dlORfk7S?=
 =?us-ascii?Q?kz2yQcs1MPGqWlX1PoZxl3R6hnR2xg7WpskAvcnnrzfx09Oh9SxchpbTK186?=
 =?us-ascii?Q?1XZxmKdraYz/4X5YccMOVmBESHZclxkTgcpoVcJ1orjytsnP8RNKPxzTSbDA?=
 =?us-ascii?Q?+S7RmJE6zMy/Gshh8I7Mv+BLplIVT3XJ7H6TunS6CzCyIBj0P8HZGX0tO/xM?=
 =?us-ascii?Q?sB5rk+9vg8fWz0lshE+1t4VKPDzkTPDau69e/LfkywwpvULD1H861dOfPrht?=
 =?us-ascii?Q?Gpx1VvVKE57RCtRMqVFRvhmeIp44RLt7ivHyM8GMsAASeg4bJn9wkxWLvMSB?=
 =?us-ascii?Q?xXDmfHpNbOwuTJUBSuI4C61euxO0pMyMR+7rCxv+6FASsSuAcouogpbIzcsl?=
 =?us-ascii?Q?V+OSYbFuAAxNy7XgKAJDH4MDapD1XSsZn4XYVWthhimNqDLAoBdYmm7e3m08?=
 =?us-ascii?Q?bSTvYjM8nlrZZztL7ql/cuNiiMOwYJaPfcFSEcUGK5t/wlzLT/b4nARHvn/t?=
 =?us-ascii?Q?g2s25H0ZI2TYDzxXgo8Zcs15ikedEprb2YY2o7wBNPr1V/egvlrGPX/IafLN?=
 =?us-ascii?Q?py8DVGyjChoLw0BXth/QfR22X+X04ZvGt74KPo186NGer0t+GXiRwxjy5+92?=
 =?us-ascii?Q?KjrkxQvL1XZ2fCl1mEy4fapVgsLonq9EASBZgrFVieBY91P3rEQBdBOE4GZo?=
 =?us-ascii?Q?y1aAwGg7OlZRw6VklDxPWyrKlPkHm4XB8Xccz2kMSPk93QUzDD/i+HO83szT?=
 =?us-ascii?Q?x80f9qRcDBYSRkLLjjwue2TYXiP21zHGxBTGvZ3nVf5UiMBkIZzhwtUKoAxc?=
 =?us-ascii?Q?sw6UcsoS3wis73y0XeL5eFGHl1esevB4XsHBj2QYU/0qigtqQLzI/bEMXYbN?=
 =?us-ascii?Q?4IsIw4CTRKjRiMQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 09:09:24.5525
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6974045-429b-4a7a-0413-08dd564543d5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002323.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6197

Hypervisor need information about the current state of LVT registers
for device emulation and NMI. So, forward reads and write of these
registers to the Hypervisor for Secure AVIC guests.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v1:
 - New change.

 arch/x86/kernel/apic/x2apic_savic.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 113d1b07a9e6..f6c72518f6ac 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -76,6 +76,11 @@ static u32 x2apic_savic_read(u32 reg)
 	case APIC_TMICT:
 	case APIC_TMCCT:
 	case APIC_TDCR:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVT0:
+	case APIC_LVT1:
+	case APIC_LVTERR:
 		return savic_ghcb_msr_read(reg);
 	case APIC_ID:
 	case APIC_LVR:
@@ -86,11 +91,6 @@ static u32 x2apic_savic_read(u32 reg)
 	case APIC_SPIV:
 	case APIC_ESR:
 	case APIC_ICR:
-	case APIC_LVTTHMR:
-	case APIC_LVTPC:
-	case APIC_LVT0:
-	case APIC_LVT1:
-	case APIC_LVTERR:
 	case APIC_EFEAT:
 	case APIC_ECTRL:
 	case APIC_SEOI:
@@ -131,19 +131,19 @@ static void x2apic_savic_write(u32 reg, u32 data)
 	case APIC_LVTT:
 	case APIC_TMICT:
 	case APIC_TDCR:
-		savic_ghcb_msr_write(reg, data);
-		break;
 	case APIC_LVT0:
 	case APIC_LVT1:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVTERR:
+		savic_ghcb_msr_write(reg, data);
+		break;
 	case APIC_TASKPRI:
 	case APIC_EOI:
 	case APIC_SPIV:
 	case SAVIC_NMI_REQ_OFFSET:
 	case APIC_ESR:
 	case APIC_ICR:
-	case APIC_LVTTHMR:
-	case APIC_LVTPC:
-	case APIC_LVTERR:
 	case APIC_ECTRL:
 	case APIC_SEOI:
 	case APIC_IER:
-- 
2.34.1


