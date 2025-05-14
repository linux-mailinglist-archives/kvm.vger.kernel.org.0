Return-Path: <kvm+bounces-46439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A74CEAB642A
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:24:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08774463374
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C907820FA81;
	Wed, 14 May 2025 07:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4FZIMnM0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2080.outbound.protection.outlook.com [40.107.236.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F4B1F4639;
	Wed, 14 May 2025 07:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207380; cv=fail; b=W3EixgkhapTkRtBeE+2l3Gz83xLw4QH0FViUjS0D2xgPcjq5IHbKPGtEZ6XvYu1dPlQne2BSMCF6yJ44knN5cmFmKEDhoSVA8U2yXhrtZDCVktu6iZMmW/FWKLiA/Q1SZ7I/Rhl1o7mBNTIfHV5hvBOBXerPQ/xtxzuxi3JFipA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207380; c=relaxed/simple;
	bh=LGPf06F2+GJV9xv53v/mliKxTPeV5PKLdik9lzxfVpg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CogA9hC/KqySroXhBapxcrA3ND0UtTCOQZlpUwDj2LdOhQkqtTFH7sFEDxgs1zzQsHZlHQ6cnvRwZDFPS+dVIEPMpotPwqR1d9ZtovlYQH4eTwG0xQnwhQHhgr4E4EH8XQWbDhS56mXng73Qca41aU1wJ4kYGBKLp9hgM6I6rPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4FZIMnM0; arc=fail smtp.client-ip=40.107.236.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W/nNq48ouNU5QQq2paeB6yo+ikW4VAxMAvX+LiykmB/mn0i9ndFWl3WehzBs+jtVycrTBeWndHQfkwBXhUMwUIKz507rOvcL4bl5uq/ss/V7fw0k0rq6HuKp+lyXMmY1+bzv2TvR0WZZrnX3RpV5qCY4gYxmrxPqUeMnQ/pEnQgpJ5mHGXHrQOKfcC1YWxniVQDRDKqsVxjgU0I9Nr9W08tFxkSadjEtx5K9xvyasS5KJO9CpIaFxHItscVMlLGqygOV+DU6dJyJRv4LSNwN0ebQFuzbEmSw+ungmnV9gkQAQacqdESNe5Bvl/aW6g5XXFxg51eyAgfS0bpR/agv4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0jKgTXIJ/eYvZEXkeFt1u/iklZcvLO6lc3L/EKiQq0g=;
 b=HgLNgTzq2xxlQU8rGonuOGDG8SPN9QQAG8rwotWkURGLloNI5qcUu2Fo9sq/8DGO9e6eYlD6NaP4qIOcMPYq/LbJ+9b9RXNcOrpDeCHIRxY6DauqUEWTPC/czY7BKe26Grdp63Humil+InHwYguQH9caGsOXs/9/XdbaqO24feJeZi5SxAOkhuoNfP51MaWvODjpwgAuLcMD+EoRwl1byZXjXXPfq8h5phBuPVYLhmcHa97VhLjHA8LV+OsJO5gfk/rz9X5lV2DDJ48CdWT11dl3uiUhZh10KQW1ZJFhqEAcNRb/dkT51EWHyL6aqxtmBu+tC1bN6iUN/Elm8FgZjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0jKgTXIJ/eYvZEXkeFt1u/iklZcvLO6lc3L/EKiQq0g=;
 b=4FZIMnM0a58tP4my/vunkodtv8JSOewwNdqYIVY8TGBHME4Qn26Sr0Q17S5D02sFK3e33Co4964snNfWaomx4zsr2vuTV57e11YsW/WKdRWNC/2Vg+ejgdpnZ+KoCn+FFIrV9E+pvUJZavKIX44AMBn/yShfRrRubRNnPqB431k=
Received: from BN1PR13CA0007.namprd13.prod.outlook.com (2603:10b6:408:e2::12)
 by SA1PR12MB7294.namprd12.prod.outlook.com (2603:10b6:806:2b8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 07:22:55 +0000
Received: from BN3PEPF0000B077.namprd04.prod.outlook.com
 (2603:10b6:408:e2:cafe::f) by BN1PR13CA0007.outlook.office365.com
 (2603:10b6:408:e2::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.20 via Frontend Transport; Wed,
 14 May 2025 07:22:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B077.mail.protection.outlook.com (10.167.243.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:22:55 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:22:40 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v6 11/32] x86/apic: Change get/set reg operations reg param to unsigned
Date: Wed, 14 May 2025 12:47:42 +0530
Message-ID: <20250514071803.209166-12-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B077:EE_|SA1PR12MB7294:EE_
X-MS-Office365-Filtering-Correlation-Id: c25f4349-ec48-486f-1823-08dd92b8254a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kJPWK+zk5Rw/yfw+nFavALkwU28IIlJ+ZLz9mMaHi1dQk/Ub+AaJY5twhXxD?=
 =?us-ascii?Q?YcriuQDOKXKuKdD8tL3d99lv3DWS7TX7S0dljIg2Q1Jc5cwX+t8LWD6zm1Ra?=
 =?us-ascii?Q?SDlRe1kWJBueUvdsVNZyV0nyg22dnsHYCItDvt2FdZM4IjWa23NM57vEkOo2?=
 =?us-ascii?Q?XnpQDNxa/EydHa2cIqTk1ItyFl3nqv9Kv6o3ld2b3iIH2wwR74LuTk2GDOOn?=
 =?us-ascii?Q?vGe1UiUmG7NzxVrQCvURPNsoa9T3pZSyfXBbIx1xFGpF29uR3u916ezQ+lcP?=
 =?us-ascii?Q?28cPlglXyMdaIVcRXDUQ+IL22TI29sbsJrqSAtfMZMBi1il74XMf1N2oA2BP?=
 =?us-ascii?Q?QWJB6oRIHG/JtUYyth+/y605y9xtkLG6sLA8QLPx3VDkV0Gv+VGCkgirT43f?=
 =?us-ascii?Q?zZ4ukQyKuIXv8QALv42cq1iXZtdEtZI7A0e2+hIJHW2fn+i6JqfUine7hbgc?=
 =?us-ascii?Q?RQN1Bg4Wy5jIJN/5sAz+YmT+yGOWdT0ydJFEYu27Pxa2M3l2Km3jxwOPC1rs?=
 =?us-ascii?Q?YxjpMMzN8FCtrinXfx3cvavcRC+W01MuGfp/t2v1DPDE1MGReKVX8Fhf3b3z?=
 =?us-ascii?Q?RyKSqeoQ1m7yc/ghvt+lBdFCof4ZZLph9+k3zCG0sRMP1MAb48Fm+NNK6cXs?=
 =?us-ascii?Q?fdI+y6xgakwBX3cWXT2Ngu49VQlDepKMPcTRVdmzpPNbxWlcpFGtqWuPztAH?=
 =?us-ascii?Q?054QWMF2AwEG7C5UEqVknQ5CbgnEIJFUuk+o0ShOfo11t5/mkHomnUMpiBbz?=
 =?us-ascii?Q?f4QMF9w72n6bRu1s6oMtYwYks75NqteG/C1q+L2P1sJWMOvbREiEtE1ELqmc?=
 =?us-ascii?Q?m6wDhW/JXFWirRjNC2qaYLIPhhMir0qU8osRTLL8Hegnknmkgb3CS5GL5o5d?=
 =?us-ascii?Q?y98yrJnjm6fH2/xaE0xmu2vbV0Ero+e/1lmr5w/oYbXLd7TYfzmRh1L8OE09?=
 =?us-ascii?Q?oY565RsV9czC2LAyxwOUl0SrhpLokXRni06o9u1zE0qnlCfZ4V4pq1t6iCL3?=
 =?us-ascii?Q?CD04/CWQ8kZSy2Ld9OGsFP7YdJbyHqGXriGMlHZnzf2ExNV+Ol0Qjx2x/yv/?=
 =?us-ascii?Q?QL5Mz7fyNOb7EwmfF3w2gQnlm125+PeZKU6FyvFk15Ie+DzwuHpDCUWPfmtx?=
 =?us-ascii?Q?cep7LgrWZJQihzizzt5O12uuL9/fYy5VUPdiFfpQgp+180mTtxecv31m9Prg?=
 =?us-ascii?Q?cwnEYfcQIr0usb+yWkEsIyStNJQTj0DlNnC9qx8DjMawLqgYYGhcU8YqHD1N?=
 =?us-ascii?Q?SOm9JsEw+V0/vQZc2YEnTHodE+HAmPWj+1diMFEwHa1MjEYNnFPxlfIjuDb8?=
 =?us-ascii?Q?yHU550rX9iiUq/8coC5ekRq50ofFlqPPcVo2a4fjfXhmt9UoauJM+CX5L5Dx?=
 =?us-ascii?Q?XGxbdBVVTMm+hBtjZ2m86K9/Mic702+hdVuokKAhrqz1POR3U+oUZHGv+9L8?=
 =?us-ascii?Q?jJ2srEEMfjCHDJgh/yIx0/UKLXYsYMNngdVC5B6ki+2lnnqc4We3CV7HN4HC?=
 =?us-ascii?Q?PgU7Tfp/w84Htqlf4nQ8lHMVTlME0E0UT/wP?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:22:55.3313
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c25f4349-ec48-486f-1823-08dd92b8254a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B077.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7294

Change reg parameter of apic_{set|get}_*() to unsigned int to
optimize code generation.

On gcc-14.2, code generation for apic_get_reg() is show below.

* Without change:

apic_get_reg:

48 63 f6    movsxd rsi,esi
8b 04 37    mov    eax,DWORD PTR [rdi+rsi*1]
c3          ret

* With change:

89 f6       mov    esi,esi
8b 04 37    mov    eax,DWORD PTR [rdi+rsi*1]
c3          ret

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - New change.

 arch/x86/include/asm/apic.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 2acf695ed1b7..b377718d34d3 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -525,23 +525,23 @@ static inline int apic_find_highest_vector(void *bitmap)
 	return -1;
 }
 
-static inline u32 apic_get_reg(char *regs, int reg)
+static inline u32 apic_get_reg(char *regs, unsigned int reg)
 {
 	return *((u32 *) (regs + reg));
 }
 
-static inline void apic_set_reg(char *regs, int reg, u32 val)
+static inline void apic_set_reg(char *regs, unsigned int reg, u32 val)
 {
 	*((u32 *) (regs + reg)) = val;
 }
 
-static __always_inline u64 apic_get_reg64(char *regs, int reg)
+static __always_inline u64 apic_get_reg64(char *regs, unsigned int reg)
 {
 	BUILD_BUG_ON(reg != APIC_ICR);
 	return *((u64 *) (regs + reg));
 }
 
-static __always_inline void apic_set_reg64(char *regs, int reg, u64 val)
+static __always_inline void apic_set_reg64(char *regs, unsigned int reg, u64 val)
 {
 	BUILD_BUG_ON(reg != APIC_ICR);
 	*((u64 *) (regs + reg)) = val;
-- 
2.34.1


