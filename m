Return-Path: <kvm+bounces-46440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24B4EAB642C
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:24:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B434169979
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:24:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9155A2144A3;
	Wed, 14 May 2025 07:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Jna7yf60"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C80A205501;
	Wed, 14 May 2025 07:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207398; cv=fail; b=sOvhC8Q5sWePdl6FWFGMOSA5mHV9/8WV9Wl6e2SW4Oim2VgdLwfBjQXXfujiY43FaUmhuZBSekjdm3BSq9t6cNh/wmCThH6GF5yRkmkK0RuQYGRmDu/WsPOwMo56HkgCTdzmolHYmx8Wikr2GNyE5CuSdMqyWVHvPHw57eHUwjw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207398; c=relaxed/simple;
	bh=/JleXnG5SC6LTl/ytmVAqYc1p/IvLsd37FgA4mTyVEo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qvwChCTyMXkVGpU9AL85D4UFPpV+dS/GmhvQ47Oni+7DfuDu2lXOQ/55aaKn9teUu9elSdr743jFToW8sTiho4VDUokEO1KXKYm3y3jD1HaAdQrcQ7g76IjkZKN0usplBDylsNqYjuEIpLs6/E3AXsSilEYvAXFLgQzTyJZNtlI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Jna7yf60; arc=fail smtp.client-ip=40.107.237.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v7g5d1l4ZUF3goKXKKj8F5RklpE5fB2/M0R+AK8dQ4qD5rkgYaYBWMI7GjTXohSCiMPERVUsCrRNY51/U2OzE+JCci3vW+DwxhaJMoqXTjV5BhM7wUHzkn2bf7Zgy+PY9aqCXIthc8CEv5vhkJjbcuKBujY5pR+YFksRXHXtgC+YWpxRkKtmMaGQeEAe3A7fP66KP8QT4xW8/kOcS/DjO7XXAjjLtvfSQ9ALYb7sp09+cmmxn0s3qzEj04Tr8t6fRnejR1LmskQNaTlF90gM+3Zx34gzQj1T64+zJHpmHLZgAMeseJOusdIT2ZJphT00whVSyocXu/w6Ws8Z+iT2mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kdqUJUfQQNlmCEUb9kDJWloCGajKrMN97Qb6iv9H8K4=;
 b=qu0U9bd93ojOGrVuTNcuNJ8mji7xdoacRXA2VJwuL/ObnlNJYtgaELOtnxil6xSNYVFvdp/pSySCvtEtrBlUfSzdL2uxIvJknGlztVcpK2JU4P25+zxmtSbudwv4Qcoyx3pT5Hz8miqRmx90g2OrUqJuyIEzH9Or2JpH7guz9u12nQXbHOeEsQB8gSV0XtuFTDWvh7TcJw9jaLXOKxHe5f/UuletYmMHmDc0q0kUPiOXYWzqeKDGA2rHE/4phfNU/+KVJctnwrKCxOPwVeWwL2OneI7undWew7de5zgDclXPXKAPQkfQwdE8DmxcjTYKrrA5+mwNjt4WUNkkfCHpjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdqUJUfQQNlmCEUb9kDJWloCGajKrMN97Qb6iv9H8K4=;
 b=Jna7yf60QrRbmZQkTMnIklWS3P1DaWWDRo6E7sWBhkOExBNkxnf0nAvqBXiqdxEv4mnf25+RPwEImCMd+SW0+CgSs4rZSVXZLUUmxGK5BlU0YROiZ/c+p7Cs2AyhyqrNqxe3ZuI4pt4hVcp4D7UQgZj7gYkgo9WSpVOZ6YFUEqw=
Received: from BN9PR03CA0526.namprd03.prod.outlook.com (2603:10b6:408:131::21)
 by IA0PR12MB8277.namprd12.prod.outlook.com (2603:10b6:208:3de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 07:23:11 +0000
Received: from BN3PEPF0000B078.namprd04.prod.outlook.com
 (2603:10b6:408:131:cafe::ac) by BN9PR03CA0526.outlook.office365.com
 (2603:10b6:408:131::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.29 via Frontend Transport; Wed,
 14 May 2025 07:23:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B078.mail.protection.outlook.com (10.167.243.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:23:10 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:23:02 -0500
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
Subject: [RFC PATCH v6 12/32] x86/apic: Unionize apic regs for 32bit/64bit access w/o type casting
Date: Wed, 14 May 2025 12:47:43 +0530
Message-ID: <20250514071803.209166-13-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B078:EE_|IA0PR12MB8277:EE_
X-MS-Office365-Filtering-Correlation-Id: 48ac63ed-18e2-44ca-ec4d-08dd92b82e7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UY5lrY90DkU2qAYJfBiCBkJUP2jZ8Yo2OFYI6j/YDZhNo7tBkPOybbs/08K7?=
 =?us-ascii?Q?+THX+hmAil1a66b0wkGvvOrZRMv9kRaXfikE0bim7GB2gOm91jKjvIX/RXdl?=
 =?us-ascii?Q?neW5vOQDCQ9OV0eKCJ66y5cwxeKkl3GiCnj9manBV2YbI8cJRjVs/Dh2ZI2B?=
 =?us-ascii?Q?UWwU+Er50+gBSq0nci5ifVQ/ZUosEDjHH+Hh5uiZ55wsdgXDl1JooDw0LIhf?=
 =?us-ascii?Q?MQp50pfN0bw2loAYW0QejVcxgaAmDhfSFcR3vKg24ko1dw40k52IkAelVm+F?=
 =?us-ascii?Q?QziHfObc5o7tmnj9jJshjM50eRZqpLRm7qOTCiqmgKpQyjmeI0LZ+KzaTCnw?=
 =?us-ascii?Q?OcltYEpvHqCoHyvtP85enYHATVaKpA/zXfoY4z7ExdkhB0E5WJNLgg96vxNb?=
 =?us-ascii?Q?OI62ZyrRpc/sPdcIDuGysNFFtuS9yP4qXfZSsYk7uy4WiJMATkoakgcsCnwr?=
 =?us-ascii?Q?JuV4NKKoS7InMuR2IGe+8GAdHeVd9j3/VSyVCNIBelUp7/C5mBRDziPsRQoP?=
 =?us-ascii?Q?HeNOqWgx/juIrSfxeo/Yy4/gcLO7TMRPMVic+hoMPBZtoy5RPozotsheh7dN?=
 =?us-ascii?Q?nClLx47kKSUFfINbVXjyT6dqJA5cwqO2g5YTOVO+GdFwJCnWP5/sP2tst9b0?=
 =?us-ascii?Q?rMjjPXuj4k3vCdyv7AUNBQpTC+QV8N7ayy1aORdxsFLiyuTsGtexQQ4BOcgo?=
 =?us-ascii?Q?qWmf+/ArHpM6g2iKWgCCtt2rnZYb8h/phR6J+2TVeH/LXr93IwHGRWfNilHS?=
 =?us-ascii?Q?9QMxJuNMDBjJQawDIBRr9TJ8n/+dwpDBObC65LpwsQ9oZ7goliPj6P3bVj4r?=
 =?us-ascii?Q?x+bDwPmuu7P6tTy73BRtzOzP5emqCtIfd3aLlHY9d3vPDMH08X6APg2vpAHx?=
 =?us-ascii?Q?vxkZAHDnOz9JQ2cQ1TU5v3Fsoo6mOOqqM/UGgzyQAgkANySGcjRx97y6KUb9?=
 =?us-ascii?Q?Yzb6pXsf6A/weZvKE+kKXrM4cBQ+sVOePYizYpuIXo4ArRhf/hZFMMRqfZZy?=
 =?us-ascii?Q?UVZDdA+/x902LI+upd3yNH9nF7EMQDXTmwp+tKtcwqd45XOAqb6oJq9R2Jx0?=
 =?us-ascii?Q?nuU8uheazkmguLOqCJEN6Dnx1cITc6ksud/NT/OUvA9g+nK6kYskirZVXaSP?=
 =?us-ascii?Q?t7GBLDG5XssymQdyfNPd2S74gF6CBe7qAgd+4A11AehNaZVS8Ke+WLURpP/p?=
 =?us-ascii?Q?quYcK3Ugjx+eWY2mkuO/xi+rHDFd6B5nrOXk9kS+41vUMSZZsZpiLH9wK49J?=
 =?us-ascii?Q?JUEohRw24DOZBS+iqGggqHf1mc075eLDCIBzWhRwQR8Wc7iMBCdRZsatYWzv?=
 =?us-ascii?Q?gdKOykU5U/blmwlh/TrI8KSxhdR/7AYHMXgfwxOunbNfxLEPbvtV3L0Sg1S3?=
 =?us-ascii?Q?Q0LouFapn7IGSqje/cdYtnITUWGLt8l+JnMjfqMHK3pRSjt6KDRaNxJC8f9n?=
 =?us-ascii?Q?cAI0aLFyEroCK5LMBWbbnu4Ji4Ci4ASXv2k6gCYFE5ujU+zm99L9/pkEGWAt?=
 =?us-ascii?Q?KYRbTz4VdsMk5/o5K4UK6X4X5FSswLSDXNRP?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:23:10.7564
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48ac63ed-18e2-44ca-ec4d-08dd92b82e7b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B078.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8277

Define apic_page construct to unionize apic register 32bit/64bit
accesses and use it in apic_{get|set}*() to avoid using type
casting. Also, change 'regs' parameter to void pointer for automatic
pointer type conversion.

One caveat of this change is that the generated code is slighly
larger. Below is the code generation for apic_get_reg() using
gcc-14.2:

* Without change:

apic_get_reg:

89 f6       mov    esi,esi
8b 04 37    mov    eax,DWORD PTR [rdi+rsi*1]
c3          ret

* With change:

apic_get_reg:

c1 ee 02    shr    esi,0x2
8b 04 b7    mov    eax,DWORD PTR [rdi+rsi*4]
c3          ret

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - New change which is refactored out from v5 to apic.h.

 arch/x86/include/asm/apic.h | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index b377718d34d3..ea43e2f4c1c8 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -525,26 +525,43 @@ static inline int apic_find_highest_vector(void *bitmap)
 	return -1;
 }
 
-static inline u32 apic_get_reg(char *regs, unsigned int reg)
+struct apic_page {
+	union {
+		u64     regs64[PAGE_SIZE / 8];
+		u32     regs[PAGE_SIZE / 4];
+		u8      bytes[PAGE_SIZE];
+	};
+} __aligned(PAGE_SIZE);
+
+static inline u32 apic_get_reg(void *regs, unsigned int reg)
 {
-	return *((u32 *) (regs + reg));
+	struct apic_page *ap = regs;
+
+	return ap->regs[reg / 4];
 }
 
-static inline void apic_set_reg(char *regs, unsigned int reg, u32 val)
+static inline void apic_set_reg(void *regs, unsigned int reg, u32 val)
 {
-	*((u32 *) (regs + reg)) = val;
+	struct apic_page *ap = regs;
+
+	ap->regs[reg / 4] = val;
 }
 
-static __always_inline u64 apic_get_reg64(char *regs, unsigned int reg)
+static __always_inline u64 apic_get_reg64(void *regs, unsigned int reg)
 {
+	struct apic_page *ap = regs;
+
 	BUILD_BUG_ON(reg != APIC_ICR);
-	return *((u64 *) (regs + reg));
+
+	return ap->regs64[reg / 8];
 }
 
-static __always_inline void apic_set_reg64(char *regs, unsigned int reg, u64 val)
+static __always_inline void apic_set_reg64(void *regs, unsigned int reg, u64 val)
 {
+	struct apic_page *ap = regs;
+
 	BUILD_BUG_ON(reg != APIC_ICR);
-	*((u64 *) (regs + reg)) = val;
+	ap->regs64[reg / 8] = val;
 }
 
 static inline void apic_clear_vector(unsigned int vec, void *bitmap)
-- 
2.34.1


