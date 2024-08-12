Return-Path: <kvm+bounces-23882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4169394F798
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 21:42:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8725EB221B7
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 19:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BC27191F87;
	Mon, 12 Aug 2024 19:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uewOCHWj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2087.outbound.protection.outlook.com [40.107.96.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904CF1917C9;
	Mon, 12 Aug 2024 19:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723491744; cv=fail; b=HktSAPBG7WmYFDe2pQuALEhidTTNZ8CtxaQo6It2nlnCJCAM5aiRFU2LkMbu0s4HTb7ARCqz6VCk5fIIuI4TJF9UOCJapWxubfXho6dNefJ0SVFX+B14amH3EYYhoDTENZQBQBE2FzD9Vo2br4454qK9w3SvMMK5f4Ng4MR+cDc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723491744; c=relaxed/simple;
	bh=J39Dg6ZereYGELeBhrrW1Y+iPYA/6uB8kMMWhreD58M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fa+aSB8DOjEYVTcvCqM/L+nALYkLrEZaNdC4V0Ys7QJx0HcDE/HRwsYhwO2EJ2DYEyxRZIzGPvdNgvqFfgxICyxdYeVXwZeccrd+sHUVxB3TkwBYYLYQEszdZYdgKZZx9kCQUINHYFiVtDjsHqlF1hDMMb/lCQT5BMGhWPujLuc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uewOCHWj; arc=fail smtp.client-ip=40.107.96.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m8795OnnYRR6CjQKqSlWewpxyKTDhUIGxSLZIXYmK1z/RJBFPTdaBb8aJz2+C8LrnY5dLlfX3H80FwF6OIrHs0uAYMvEX1V3UfxzbKz14eGkI5DhGBeRuHP0recKV2D1Vut8o452YSUvJTND/WvJRMpmGIaRP2uK3AfFfroAk0FmHYIeXAhqrk44MVzXhGJUYT26IOB7wxnmjuR35YRZxwc07tSg4ucfN4J59VIHThnQGuiSe7wnPbHzn/oGdajpNUPgEbPPTjFbiN2YcFgwjLAGxR52afK4I1CVYBR48mP7XGRm7OFmKnkJBLJM3ZytFxZPS8/cW/JAfgN4SwZwPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jkgrVNwxYHqtZtCzMFeHoqEl+4+6oapQGju3xY/ZMQI=;
 b=oW8BTmos4/KJrI/6gwQFR4Lw3hkdE5tpazNfg/cDxjxtslNo1hl2gkGLoKFxcDJKsIEaZpFBHTGWU/cB///iqtAbhKOIRQQcuKU9Cd7xtKuChD+bICDOEGSrpvPXP14PNFVjgmmRfN61LUmS3C0A04VbU/AUtfXW07gNPUJR6ZKSomACnAeLum1e5auhQIqW4ZvCgJ13MqCw+eHpowwpLj5PpjIrqBM1UkJv/WBBRUSHzQZhWHbX5prwt0McfRalm1YL9M1Fg66AOFodbQyro4Lo7ccYmUu0WDtsEke344LU15ZND/6LzlsHwoPAi7MtEXRJE5ka7jblGb8UzYkvfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jkgrVNwxYHqtZtCzMFeHoqEl+4+6oapQGju3xY/ZMQI=;
 b=uewOCHWjMsrSu+9JC4ubP4FqEzUfx25WcItp6hX0LirJJNgcO/3ZrCjX+I2xLVDsKGEIMLyFfDIQpD58QK2FIgbWePR2RQv8HVv4+3f/l5Tmj7R5KLJ4s7c/vFcjmVrRHPmc7Yn9tvOA4kosX+zxD6bzMBpousHOglB4UZ1RCyY=
Received: from MN2PR10CA0036.namprd10.prod.outlook.com (2603:10b6:208:120::49)
 by DM4PR12MB6325.namprd12.prod.outlook.com (2603:10b6:8:a4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.14; Mon, 12 Aug
 2024 19:42:17 +0000
Received: from BL02EPF0001A0FF.namprd03.prod.outlook.com
 (2603:10b6:208:120:cafe::d2) by MN2PR10CA0036.outlook.office365.com
 (2603:10b6:208:120::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.20 via Frontend
 Transport; Mon, 12 Aug 2024 19:42:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FF.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Mon, 12 Aug 2024 19:42:17 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 12 Aug
 2024 14:42:15 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>
CC: <x86@kernel.org>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH 1/3] crypto: ccp: Extend SNP_PLATFORM_STATUS command
Date: Mon, 12 Aug 2024 19:42:05 +0000
Message-ID: <be626a28eeecd08eac7f68fb23283c5ecf5e2c68.1723490152.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1723490152.git.ashish.kalra@amd.com>
References: <cover.1723490152.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FF:EE_|DM4PR12MB6325:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c96e413-d696-4540-707e-08dcbb06df66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dWL0WeG0rrdvz3btCAv+B0k2+8R+KlXATkxDqchdD0QS31iUtZ3KFknDipW+?=
 =?us-ascii?Q?Mxj/DTaYxYpR52CZe55/rhrbjHkOVEY7XqeJPGr9dOwG5aVcAnjMoB9TulVj?=
 =?us-ascii?Q?hirUVhDpKWrndSe279t03ltJCvC4+ZEbl/SZBO2R3nA+65GqA7H48ChA7opf?=
 =?us-ascii?Q?FEljFS14cPf2WnaQJ3ZBsCnJj9grtZccDtS0DYVbLbTrj+3QGv32QNKxXI4t?=
 =?us-ascii?Q?xjtNRJQfaR2u3zHD0nouBkbVRypRzjyBrn++iYfvaTk3aeT51fheUwQnZat8?=
 =?us-ascii?Q?XLpN09G0fPnY0HSv2cKeiL+Rm8VVvw9/a3huoR3IaXoLPDnotAPbISvFEYIb?=
 =?us-ascii?Q?a405TzugApAKUvNK3J4WQz/S4e/MA0W9FNBPlikP6d8SgF29F5fvUq+iy26p?=
 =?us-ascii?Q?VBw82m8Ca1XNNQMM010Tt2iDXLTNBEmVFXgepbOuv4JSmAwDZCxv8/v/33tm?=
 =?us-ascii?Q?BuemIWqtERM14FxRZ7eSXJsaWeSZGd9DZP1MqEcJi6VSiE8BDTK+rPMRJbJz?=
 =?us-ascii?Q?DqWMeEIohy4FuRZoZJE/gkOC8FWWaYIJJHlY3ZSlFP3j0ao+j0+JQi0Vfu1s?=
 =?us-ascii?Q?smBbFh2zpOzL2mQV3yZ4S3tkB4KOy1htWyUvwyYw9hYdA9Ke552GP/hLfU6N?=
 =?us-ascii?Q?8j0IF7g7jswRdkemuoGsGuPatvO3+G4AjqsE5vPfZvuBqDgt8dYiAuytSnam?=
 =?us-ascii?Q?N6hAAlVXeLFcegM22M8m+8u2uF2mtl86mQDI0vhhuLm0a8PIWIuF1AWmmJBl?=
 =?us-ascii?Q?BcNersX9RgJ6l3bqzNHcaR5s73xWTpX1Rp6HUE0ca1pAKkz9ZrntSihFmj7Z?=
 =?us-ascii?Q?xySCukO3PD93O7fCro3YwYbtIxPHNjHdaQ4D2cgyc+9H+UDroIVTW4aXAC7m?=
 =?us-ascii?Q?5IILiyEA1O+X2r16/UeJ+aGM7h0yDyblKzJxcHuNqt2ZW4PCVaGBZc7JkEat?=
 =?us-ascii?Q?1q8lSazI4aq3UrPJDXBz6KfAP6SDQla0lEI85AK5fVXVEXHMUxHhuMSamKjv?=
 =?us-ascii?Q?kcovwRRCW19ZoLiAsV0NRm08HOgH4x5Ls6mH/wxeszEiFgxI2NGAIgYvkukY?=
 =?us-ascii?Q?hLVrYxAV9bSnRt94DRsR1qsXey2qmpa+wTP530TiumTicAFdi5M0Jj4aRpUj?=
 =?us-ascii?Q?SYf7hG+f+GkJ4pMT8DvM27kK4jcdYWezAUbSArnbn5K+LLm77KZlasjmbNoh?=
 =?us-ascii?Q?Gik3shhEkoLfI4LO9/CpXDJkUBH0OIkazYd7QWdpupC4MAbLY+SgUNBOb0I7?=
 =?us-ascii?Q?HhCSmMY9ws3HfdtQUrnXJeu5JJyn9EYI/Uzg546/1F0FAK1oYGezs0+86Rue?=
 =?us-ascii?Q?LEN9cFiFZAi8ew4A5K4G1FvTfq4/Zy07NBVfpcIP8Fcixv9ojEJep+tCGuW5?=
 =?us-ascii?Q?vl4h1nZl/o/JqKknHpkypGE0C2+G3rA4H0C6lxoBnGeSTtFgCyANq2rExwVB?=
 =?us-ascii?Q?/JFpqF3uFd4ykAgiPTuDE3vSFfxy3kk5?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2024 19:42:17.1373
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c96e413-d696-4540-707e-08dcbb06df66
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6325

From: Ashish Kalra <ashish.kalra@amd.com>

Extend information returned about SNP platform's status and capabilities
such as SNP_FEATURE_INFO command availability, ciphertext hiding enabled
and ciphertext hiding capability.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 include/uapi/linux/psp-sev.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 2289b7c76c59..19a0a284b798 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -177,6 +177,10 @@ struct sev_user_data_get_id2 {
  * @mask_chip_id: whether chip id is present in attestation reports or not
  * @mask_chip_key: whether attestation reports are signed or not
  * @vlek_en: VLEK (Version Loaded Endorsement Key) hashstick is loaded
+ * @feature_info: whether SNP_FEATURE_INFO command is available
+ * @rapl_dis: whether RAPL is disabled
+ * @ciphertext_hiding_cap: whether platform has ciphertext hiding enabled
+ * @ciphertext_hiding_en: whether ciphertext hiding is enabled
  * @rsvd1: reserved
  * @guest_count: the number of guest currently managed by the firmware
  * @current_tcb_version: current TCB version
@@ -192,7 +196,11 @@ struct sev_user_data_snp_status {
 	__u32 mask_chip_id:1;		/* Out */
 	__u32 mask_chip_key:1;		/* Out */
 	__u32 vlek_en:1;		/* Out */
-	__u32 rsvd1:29;
+	__u32 feature_info:1;		/* Out */
+	__u32 rapl_dis:1;		/* Out */
+	__u32 ciphertext_hiding_cap:1;	/* Out */
+	__u32 ciphertext_hiding_en:1;	/* Out */
+	__u32 rsvd1:25;
 	__u32 guest_count;		/* Out */
 	__u64 current_tcb_version;	/* Out */
 	__u64 reported_tcb_version;	/* Out */
-- 
2.34.1


