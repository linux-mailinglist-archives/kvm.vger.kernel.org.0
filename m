Return-Path: <kvm+bounces-40202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11A27A53F37
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 01:38:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA348173962
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 00:38:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E319224FA;
	Thu,  6 Mar 2025 00:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oRoNQxUY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA251804A;
	Thu,  6 Mar 2025 00:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741221514; cv=fail; b=Yw0U2ZbRHHl7gfpYm8RGPrseI8UFy2lOy+es3Y/1x47HH+5EC7N4HLgRKPG8VFu8S/UDzW93ReEXhB84z4QN4pstpyPXn6XAftYoZzbo6EnTwI6J/+FZxeSNLKy3gZHhjN+4nOx2IvXBXbJPMyGU4Z+GQt45cAvRLPOHdhvjeL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741221514; c=relaxed/simple;
	bh=WOExddemattqav3duA9BbU2MlpWXhK70bbNl34/4bZI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jlm90eTaGHcP10eM5CwqZUHq/1RC5sFRTXH7/v6/EGaE9nqtU2Z5tOLlOvQyK09Vp5RIoh4hW6ntcC9+u+cF56Ti6xa9XMRNIQDE4prfkmv5WLTlUQ7zBU/C5jp9ULe/FEaUgbLeh4FMBAtM2G9J+sTl4nlb9gDEYXv3wuhhqMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oRoNQxUY; arc=fail smtp.client-ip=40.107.243.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dYAR3rrsRvjxcaDqsKx/X9q69UHavQnzK4EayEyht6Nl8e7hV2zsDeniTlSSk/bpd4WHc13TdA2EZqDyTtC+W9PT2+AO8ZBqcp1fQPJ2ZzJTxDaGXHz1CnwtgpbtJaMdQhqw34Ex3sYyKqwmgJEqeCyego+J7XtLQ3olXw2mMt4ARPP3JrG0uXEOYFrb4cBA9RG03HxQKbjBLicM0Tf09rrrBxG2qrUXHwfMaHf2k3r3asvOWm69fpjnp1mZ6Wccbdj4uKjF//02W2RepV3HgPeRF1IMxZu7/lfdpPbR1mAGalpbZ3oo770H2nFlkGFnnTcHz80y92IwcAjkq7VEtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ySB/EXLdNZKqlzQIW/S/iBi6S0sbmuRM8JMIvhk1yds=;
 b=SLuAlmXmBXCW5+0KkaOLn5gzD2zQ+8BEdqSU9CYlSICnxq5ow6ASaP8MAd7Y20X9P1kZ/Pl8+qv1hdg2T5Xnez/gCEwHccP66LfIiQ2/NUam+0rPtSI6BH8/m9JbgyRBeAobc2hiSTvp8fgkJA+UdzuiLs9TC6idqnif1De/wj5u/wU3Qq7VmL1p2SxCm8BWCjGsx/8fA74ynp+nlPy9iNPPA84cTVqkYJzx5DFtfZu7M5w6ESe2puOj1XsEz1p//2AuHnFiP9FEckr1VIeOmhQmeQjQ3MDPbb1Jj/UNYBKLE5UKZCT1CgiCuH31Zr9sFeqynxl9YD/qfL4VAoverQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ySB/EXLdNZKqlzQIW/S/iBi6S0sbmuRM8JMIvhk1yds=;
 b=oRoNQxUYkGHnoSOUUgLopTKZoYAVjOvDA6vuaOruu+CM/UPBEOProzO86UD6G8znwH15jCJb0G224fcsi0i8OgE5fx4YCg4NVXO1GkOHqjTmnvaQkl8phAqkj9y5oAUICYzUKAHdEX8eCkdpOEeF5zY+1gEOskGbcNV4/k5njR8=
Received: from BL0PR02CA0097.namprd02.prod.outlook.com (2603:10b6:208:51::38)
 by DS7PR12MB8324.namprd12.prod.outlook.com (2603:10b6:8:ec::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.25; Thu, 6 Mar 2025 00:38:25 +0000
Received: from MN1PEPF0000F0E3.namprd04.prod.outlook.com
 (2603:10b6:208:51:cafe::f7) by BL0PR02CA0097.outlook.office365.com
 (2603:10b6:208:51::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.27 via Frontend Transport; Thu,
 6 Mar 2025 00:38:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E3.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8511.15 via Frontend Transport; Thu, 6 Mar 2025 00:38:25 +0000
Received: from zweier.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 5 Mar
 2025 18:38:23 -0600
From: Kim Phillips <kim.phillips@amd.com>
To: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth
	<michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, "Nikunj A .
 Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Kim
 Phillips <kim.phillips@amd.com>
Subject: [PATCH v4 1/2] x86/cpufeatures: Add "Allowed SEV Features" Feature
Date: Wed, 5 Mar 2025 18:38:04 -0600
Message-ID: <20250306003806.1048517-2-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250306003806.1048517-1-kim.phillips@amd.com>
References: <20250306003806.1048517-1-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E3:EE_|DS7PR12MB8324:EE_
X-MS-Office365-Filtering-Correlation-Id: 725f1370-9550-46de-c95f-08dd5c4734be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OcR0GRW2vZUeTU44sXQfGmCeEVWEX2fpXp5voVk/TwZ4yomND5q/SCn2/HNc?=
 =?us-ascii?Q?3SJGDPMnefZO/VG2Bg+DACqPa+LxXLFGPh9LtfEG2Ix9krDAXSr5b/+oTAAe?=
 =?us-ascii?Q?C6/lyxA1YJvbsaROXmW5a/qonj0IycaZtNOvOLUPfw/vbyCBwzMaK9ePXZjw?=
 =?us-ascii?Q?4fqAoA1S5KjGPphpTW2bZYanXTgTr/xMzbksFIP4RnOyrS/mZ6fK0dsNi1Uq?=
 =?us-ascii?Q?mlpffQupfJV3SmKSi9bpbW6aLVHbnItJLm8OFh2nI3JDrLpg9ouDpfvgh8tE?=
 =?us-ascii?Q?GoABuBKZP4IAyVyHOgVf9NYbmztrcH0MAD/hzx287YL26e1uc9Q5G3eMnZWO?=
 =?us-ascii?Q?j2jxvprhBJY5iHVxinsbYAdyNXo8mG/nEw3O5gt+zMXRGPfMIzo+Hnd7sLU7?=
 =?us-ascii?Q?r8bOWV9qrRLN0JDR43IPmxT0/8WJng1pcQTHdMiUZbeGW7v2WKlItIuVIEQ3?=
 =?us-ascii?Q?/R4M4U0e2qzzmgjm+D1Bci8DA4UcXipLEzplXe/PFssFaOEw9VSu/TcBAwEw?=
 =?us-ascii?Q?yDUHcjoiYRo1PI4dJnQM8PcYejZo7JkTbpvPqDoAUUhwwKf3olPHHIf250fm?=
 =?us-ascii?Q?ksrqIvw/KbgaCJaxfdFGI9NRkEA+GUE2NlD6KIvLiY3E07aEIQKQfUD+TW9R?=
 =?us-ascii?Q?sD5uYqnirXpHn5NiFBPjc8h+Se70yhUy4p9LGgytnzcYvOfVzz2RYJWwghfd?=
 =?us-ascii?Q?0IlJScuBPIV0iyZZPm/8U9C7n3/19+EiPE6ZacBg40BXQbb7C49vJC58jqpp?=
 =?us-ascii?Q?MK57Rd24mqgKyCUu4dwKruuJhmM0NQkL5F5wiM32pI3aiIuTN1lSavK3JJmB?=
 =?us-ascii?Q?S4m0TkB/rkjjgQDZ9Ki3eQS/Se0zSLjrHlSJFVu3zGtzgsWXyXE2n9oThTD2?=
 =?us-ascii?Q?ArzcLiXKAzTUQiAoj8aHYR3SbI/epfbCRFNLn3QoVNicY5AEaCMICq83kjsR?=
 =?us-ascii?Q?suMfkMvrXCQc9Xi0n1b0jx8pZop+QxgxRGUyI+KTAhOQNGoWQZ1scgg9Q4Pr?=
 =?us-ascii?Q?IXr6fHeK41ikCMGRKRMu7+eusWNz+7ZwhjzrxNp6R2FAdrXO97y1ln1eoTDh?=
 =?us-ascii?Q?z6Mqhs5Ui05W5Pn3omo/w1GSHrgieOGin24+Lj917P8PHs6vacHaPucj9wE6?=
 =?us-ascii?Q?jokQiuKBsWyZroFk4AmjO5sqhsighNM+VslgdeBc1VSJi5o/qtJResLq942M?=
 =?us-ascii?Q?nHWbSPYvYRtCp9piF2lwNS0ulk29xxRhQXg+DoTfyoWZcqJUjsIPuO8fKJRn?=
 =?us-ascii?Q?MWZHtyO4zDJChF/NeDkY/eOLMv82OgrNfvPc4zeNlDCIJY4g44i9KNiahJY2?=
 =?us-ascii?Q?Q6+LAvz+/NLEKLQOAX+R4DuiUi1tKqdi3DNJaJbdR3ecm1nQyD1cJdSLLXFc?=
 =?us-ascii?Q?uNhUXJ0Li3+JhK7AoWMFllA7wuZneWkfWwSXMhqWULGqZybQFWe3XMrimpFv?=
 =?us-ascii?Q?GnPv+aPZ1uph3q38x0OOIx80gjsGhyh8jOO3k+RXcCxqHSFr0E+PcWcoQZ7q?=
 =?us-ascii?Q?VVROIkQso9Rtwec=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 00:38:25.3518
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 725f1370-9550-46de-c95f-08dd5c4734be
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8324

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Add CPU feature detection for "Allowed SEV Features" to allow the
Hypervisor to enforce that SEV-ES and SEV-SNP guest VMs cannot
enable features (via SEV_FEATURES) that the Hypervisor does not
support or wish to be enabled.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 8f8aaf94dc00..6a12c8c48bd2 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -454,6 +454,7 @@
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" SEV-ES full debug state swap support */
 #define X86_FEATURE_RMPREAD		(19*32+21) /* RMPREAD instruction */
 #define X86_FEATURE_SEGMENTED_RMP	(19*32+23) /* Segmented RMP support */
+#define X86_FEATURE_ALLOWED_SEV_FEATURES (19*32+27) /* Allowed SEV Features */
 #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
 #define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Allow Write to in-use hypervisor-owned pages */
 
-- 
2.43.0


