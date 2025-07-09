Return-Path: <kvm+bounces-51848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F6E6AFDE42
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:38:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C23116A484
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512AE21423C;
	Wed,  9 Jul 2025 03:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HWQsdQrd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273161DE2C2;
	Wed,  9 Jul 2025 03:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032244; cv=fail; b=cG0mQzWTlMAHnDK/jUB3RsseH/VrFWLKf79Jo/ucyDD4RIvXDXER4JKCEduqpEHBwecS8890a2vhFx6hwUleclxr2IUh2rfzgJt0478lvFBxkM2geGxIuwbUwnd/WoJ8H+jNz/9yZiddl3pxOCjV6VOzVD299SC0k6NxoML1Mgk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032244; c=relaxed/simple;
	bh=Ie7XCMa/WO1ihheDv2s7lOBgdplBDlsu2ZWSzLKLOYQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Auh/3y/fG+TqoGr0Ifl5NBUiK1NQxeBvnFprCHK7I0GovWa86REw3Nxt/Woyp3h/7yxarwDh3GEKB/O6l30hu65aV3cZKC6HEYZ5Q02s6+jAw9TPR19l1CwRB+xcnfPN1cBJY0oWmBcEo33EAupw5Gz0qTxr26TGo8ILGXENSo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HWQsdQrd; arc=fail smtp.client-ip=40.107.237.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tyT6iFMK04W+BRzg0Cp7HSv/AgumU5OCF31f2jqoz0sc0Ako4WXvJ62QtFHomu0lKNWkuTQbclAbj1HHgp4hw/sMr9UDds5oU6XI8stnZRDdTKYwA4z4PihqWqV+NnLmw6mKLSiJiKmlumL4PlzEKs9dAA5XMY3szHQmy0i9TQjBhKOcdYCdLWo8LynoGxphjWB9qisYq3ODoI/5ifr0TsIDth1rHeU+1on5VgdHPP4dyrh0eFhFKPeoCIWe6pvNwW/cPBpdfhlFk952ZySbBe2J2CifUOqK18i8sg1GxOSZ16zYN0k8sGx9/mJPFFuHKgzIl1O32Arg2UBqkHAV+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w/Ur3uY742ryE/c3u4og6RBfKPYuJ/Vi8+J23Xdfsj4=;
 b=p68uqnUo5tv06ZkKYqHm1UJrv2aF0NmJsscIS6BdhzuoyyvCx8Fj8Sw9W+q/Fur6hG6Hc09aHX5k/odcI79qXFP1IZNhnQwOZzGdgMJqC+nUkvaBpAdI8F1YguPxlNB2mny5OMTxSPdAe0gXihJiFPF7FLIT0HoTOA80X9iiFS6QvPAFbXIT8uZF+kwhry2jnG6466abPUFIBFx+4Nt96VY2d9ZkmSZdDN46LrAYP7NDkZTNBcQkKmpgW9dmP3exrc2TcGt8XlvfhtzSNeEfUsBqiaCNTKztNyb4NsLo5CL9zqmXuq6Qaul3hANTYnjBoZz7HNNBk+TM3/L5QiLy2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/Ur3uY742ryE/c3u4og6RBfKPYuJ/Vi8+J23Xdfsj4=;
 b=HWQsdQrdDgmCDcBsxh1r14ldcObSAROUF1i0JeARd/JeGCIhmwX9dSWk0tnUGRqDUQM08CuogdoBug7SWRVYn5I1XgZe17u40xzQfwqZEQ55HLekFJTHZovzX0k3/QWWiNB72ZyEdsnWvQ7bLgEbXQZNHuVFinNZQWlV0A9erxU=
Received: from CYZPR02CA0023.namprd02.prod.outlook.com (2603:10b6:930:a1::21)
 by BN7PPF521FFE181.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Wed, 9 Jul
 2025 03:37:19 +0000
Received: from CY4PEPF0000EE3A.namprd03.prod.outlook.com
 (2603:10b6:930:a1:cafe::e2) by CYZPR02CA0023.outlook.office365.com
 (2603:10b6:930:a1::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:37:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3A.mail.protection.outlook.com (10.167.242.12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Wed, 9 Jul 2025 03:37:19 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:37:13 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <kai.huang@intel.com>
Subject: [RFC PATCH v8 14/35] x86/apic: Rename 'reg_off' to 'reg'
Date: Wed, 9 Jul 2025 09:02:21 +0530
Message-ID: <20250709033242.267892-15-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3A:EE_|BN7PPF521FFE181:EE_
X-MS-Office365-Filtering-Correlation-Id: 240ce0c0-6a5a-4597-6978-08ddbe99e888
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?itoor8GAQfwzLjrxxJy5wpH1lfv6AkLzTWlGvDUjzmD9K2rH1DRWlBVQCRWa?=
 =?us-ascii?Q?JjeuFs7tcLm3F9T+XqD7CQc+mAr+2ux4LuIvwHiwHQSeBI8w3iF5P/y+z/5E?=
 =?us-ascii?Q?Q8HFr6fpYwsudRpRvXN/4od06XH5pwQBXCEeDd8xiORVuPtC9EA36F6dxxPX?=
 =?us-ascii?Q?0XJxUiO/PSObJeUvgBm9VMJ+uPSxM7v/+h/6AkMAZ2zFXtPYuJx9fv+orIbb?=
 =?us-ascii?Q?LS0iOq1RZbYs01oNyMOJ/fPXxdNzpaVxIuUxFol/bsUsrXvU3Y7IJ/8UEZyq?=
 =?us-ascii?Q?tia0o3mb5HFTdggHpAZtwkPpUy8cBcEMzltIfnR3utLQnjoqXHplKd09KgFH?=
 =?us-ascii?Q?UxHVYFTnOYvjWKM8FtMAjccr7vfjZuGfeL9Y4vFnoqnRL4OjdY0QIP8oQfVh?=
 =?us-ascii?Q?ywFUW1quKfFk4fQeIb3FJmBLx6dWc1sOtHpKNsWnNyLJIHZKZaGB3qy8GtAX?=
 =?us-ascii?Q?GiFEJ9aiwKbW6ItV2qO/ilZBG2PdArhCc5jW3Lk7EgnfnfPlzKIpIOyIGchW?=
 =?us-ascii?Q?cN/ZMvJiY4DiK4OtGUPNS4M4GosaydKZwAiBzV4j17xEmktjquMcJH2czXI2?=
 =?us-ascii?Q?ncHvLxIL8pdD6jH5OhiKkxfRrpj/XV5Py4rxEwopBPQ3t1cTEmbEYVDFE/gA?=
 =?us-ascii?Q?U3EhzHCHtWdwQ1c0gFGggbDPingioJvY+VG26BoyUuuk27msOUGBRH/7nOgk?=
 =?us-ascii?Q?TtI3fOps4SF6MGjErV4y2zWr9wbo6J6i65ixgPtraAeDH0Dp3uoF6otlbv5A?=
 =?us-ascii?Q?jXc7mdiPmk7j1pPUWmSC7Gni2SxMmVug5yd4W/7xqLfDXV5Q1S40WdvuHvoH?=
 =?us-ascii?Q?hoxH2gOtsk6YsgwDZouMO2HCfaODVr/HRdBFRNqL6/3Sng5p37R6G236a7yc?=
 =?us-ascii?Q?T7MNcbJwpog5H8md6j9myVnqYaACz9rifWHIp/JxLC4VpmqeFgh1KDQitAqq?=
 =?us-ascii?Q?yS+URB1i3dI5aWsfgliJOQOseNiri6nB+dUD1UyzOVmBdy6Kw23/dszHCuOf?=
 =?us-ascii?Q?hCbI31tD1ghqlXb4r2y8WxaoRxYu4azd7C1cJs5LYTBBpGGJQ8GapugnVnLu?=
 =?us-ascii?Q?3/IalI2KABNTKLQexfoVz1xTQdNMfNSg1m5lizbUjv/Gx/uuVnNypqRGBzSR?=
 =?us-ascii?Q?sSoF3rmd/0EVnNEqm3g+eEuKcYgzAoVcuMlgq31VImP4HoWV2rW1t6S6nP5A?=
 =?us-ascii?Q?h2RXfsFuCjjlBKIMesgNDi8vd5ViS6l2FvOQSWxcdbcYEIssiKmnkMYqi2K2?=
 =?us-ascii?Q?zomgDbUIVTEwqRV43328bCMB9mmVKDPqd6XjHQCR0vX/5YV/qTtpqGWaVvin?=
 =?us-ascii?Q?PgzcXisKD8MIrU7Q/Tmht0x3nXJDnQ/4wCKhcwWsyJf3i61dT/78xkFzRCet?=
 =?us-ascii?Q?VBVuzXaH8drWLGqGpezHT469JdTKf8LFd4d70T6eHbtFMsk+TEMQ6UM2TTb8?=
 =?us-ascii?Q?RRqWpml6hCP0EvvZzqfVOUF1Q2uTG4nNsZZmgrDsnnRn+3dpi2+W6rwSExop?=
 =?us-ascii?Q?fVHu8fQdQr+AZb12CHKh1lZ9kOoCAm1QBe0h?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:37:19.6125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 240ce0c0-6a5a-4597-6978-08ddbe99e888
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3A.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF521FFE181

Rename the 'reg_off' parameter of apic_{set|get}_reg() to 'reg' to
match other usages in apic.h.

No functional change intended.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - No change.

 arch/x86/include/asm/apic.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 34e9b43d8940..07ba4935e873 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -525,14 +525,14 @@ static inline int apic_find_highest_vector(void *bitmap)
 	return -1;
 }
 
-static inline u32 apic_get_reg(void *regs, int reg_off)
+static inline u32 apic_get_reg(void *regs, int reg)
 {
-	return *((u32 *) (regs + reg_off));
+	return *((u32 *) (regs + reg));
 }
 
-static inline void apic_set_reg(void *regs, int reg_off, u32 val)
+static inline void apic_set_reg(void *regs, int reg, u32 val)
 {
-	*((u32 *) (regs + reg_off)) = val;
+	*((u32 *) (regs + reg)) = val;
 }
 
 static __always_inline u64 apic_get_reg64(void *regs, int reg)
-- 
2.34.1


