Return-Path: <kvm+bounces-51849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32B04AFDE45
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:38:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37B6348681C
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEB99219A7D;
	Wed,  9 Jul 2025 03:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4lpDxDzT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61DA217F29;
	Wed,  9 Jul 2025 03:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032273; cv=fail; b=U9JEUEQni97kXobWMB9/+EWrqqXS45XOBEB2UJ3lDwFjaqa6rfXvjty8PXrkdozwtZA3JcIfPRF4EX91v9xYhfKetSheGGk+xzINK6VHIGYDSO7AciAekRbYxwDH3uvvMpmfz5CrzE8ZtiNtnf885oIzR0YN7AxBBml21/Vwo48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032273; c=relaxed/simple;
	bh=p6VD5iKyrfUElHNOLtNFLBb/PAZDRWqoPm0phCX0+2U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KzaraM6SpzMfzDMxnGnNwzAgBTHbRJKnxamu/OlNrePhMd0Xg03LI2M8bBRHk9nHlZHqkatSKxsa+Rl4GrXCgawX/kxDCyaL+at4YT/nat/Y+OPij4IFjJoG8nq5G2jHsmX4zSGvlPk4bPvcVvyHjJdh0Mqaic0YT9DmZ2pvDTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4lpDxDzT; arc=fail smtp.client-ip=40.107.92.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q9Pe9JW0xsS1qq50nDuctsRl2mz9DvH6OSHkLaIREhjX4GB/DhsCCPmKJq0I9PETUCkmmySCxPeQxgW4CQrq+PIspM3DXwMMWBw7F5rB/DcNVBoqp6zk3vCyi4ENQ9fAdkdPoUBgXkZtchK5Nm/F5WveVPGBIfZE8PgsfJpWQ1w/4crusJcGodPWhHz9L/YIrNRM4TsLlYebynHB4d/Eor2qNAX/LV0epEcSzqU5v90pUYrotMj3OyozpHHKaxUyT2pAOi7eDbnltS3zNdfArigziQr7LWkF3De/SitkwUCw2Mj5aFbWY1JrnnlWU6BQnOHuTiYkRNM2q/kLjT0+pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B/w+dNCLisjxqHD84rIbJKWTJslzNCoKzaqyds9O4p8=;
 b=JTKguT0zJCuCmZ5HGfhTWr/t6v/RUNDXd49a4Y0k/r6JLNyYTwkuP1+Of0Z3aGJV8Y5Kht3d2jcCgdsJ1eM7CGzpc/YrVkyMRLPbSeO0E2v15EtyDf2yzsGuYY5cJ4PK74cX5hOfVfm/iwfClpwSR+xlmdH3z8f4Xs33lhAEPXY9FMHTH3f8Uamdgr+97J6hrBt11zlVvzRFCGIxA4MdcHo0QYd2a7dUkYs5FhWhRUKaKaJxJZKx+B/ul1Chp3+sQcZZBKL/qOmPDEu5dm0CIsOGD+HKPTjPvV3FYjwcImXMboQcXvZFSCgh5FWhCNNIZT5E2GU/3ZSGUtzflKTiNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/w+dNCLisjxqHD84rIbJKWTJslzNCoKzaqyds9O4p8=;
 b=4lpDxDzT8EOoaSZR0Mn8AUf1jKz/tvfHWuUopzxPhNExsi7TOa79tmyuiqyujmgpIPa2/YznKA4h5fjipjoZMIEANHwEpeKgoopLvsy0wEAqA/7Bt1ekZ4tlAOkZeWAsTDI8PBBEMz7RIf2g7SgowK5tVJRfGekWYevUvRkVkrg=
Received: from BL1PR13CA0209.namprd13.prod.outlook.com (2603:10b6:208:2be::34)
 by SA3PR12MB9198.namprd12.prod.outlook.com (2603:10b6:806:39f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Wed, 9 Jul
 2025 03:37:45 +0000
Received: from BL6PEPF0001AB4D.namprd04.prod.outlook.com
 (2603:10b6:208:2be:cafe::e2) by BL1PR13CA0209.outlook.office365.com
 (2603:10b6:208:2be::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:37:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB4D.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.20 via Frontend Transport; Wed, 9 Jul 2025 03:37:45 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:37:31 -0500
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
Subject: [RFC PATCH v8 15/35] x86/apic: Unionize apic regs for 32bit/64bit access w/o type casting
Date: Wed, 9 Jul 2025 09:02:22 +0530
Message-ID: <20250709033242.267892-16-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4D:EE_|SA3PR12MB9198:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e60b438-eb19-4b29-5f09-08ddbe99f7c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5nQMY0hiWRnROQ6zmq1tpyPSIS7UcR7tzz9eR3reMKnAIWVaqmokjV3ELBQy?=
 =?us-ascii?Q?IqxuEscuXIX8kEdGNKxxsdh4YewL2OBs7FN9x21AnwEBtHCDdOTPrCuhdPKR?=
 =?us-ascii?Q?bZVI+FOQbM6S7s3TiEYq+H2Dzaqn3MCXaGhwhhvswk1Ko5xeHuZdouKK9pg3?=
 =?us-ascii?Q?BUR0YL4cBXgW6grNB8owvGy4wP8PHi+rqxYckSemmp+qxLvfiZ8BS5MHmRR0?=
 =?us-ascii?Q?akaQyEMxB/gIxRFkWXJC0whHEp3vL0wIoEHb7NsDI+tWBVgpl6/hoTM69kY8?=
 =?us-ascii?Q?DtoiUdUaJAVuYmTPnYdexlyccA3TM7/MV120NbAYX0W+12tAx3KRPdgWb5yd?=
 =?us-ascii?Q?e6Yzkc2dPZuo2nzOGNiiB3gaZi+Cie26kmALzWK33XYrFb2VYEm2isEALayD?=
 =?us-ascii?Q?ofh+j6f+An3gmMZIqjDrrHrh8sCJe2RdYVSNLzgbW8aeGCw47VItx+f6cJ2r?=
 =?us-ascii?Q?3PKUc1ObRtYdW2tJAekhebRTEruQuxF4JJcR8KWaxVnHeZt2FdMSDuoOTKrE?=
 =?us-ascii?Q?Mqa0WdYlvpPuOesljfW7E/M+lM8YDdrhu+cdYl+vGu6vJXkdqNih/beM9OZj?=
 =?us-ascii?Q?Ch0a/7yFnu3OkvdKOM0ykeIhOrHVhwxGt55/fjnCibEbtE3FK2KANt+98JNi?=
 =?us-ascii?Q?vpD9GvfAogknoYyPekC/v/8cv2P1D8NaWavpYtRDAXSpUF7TPPONcempwk7B?=
 =?us-ascii?Q?C1iqJbEIPvka4ELtx0rkR5CaCvo3q5uoZb/i9y7Qswh2NoeURkh3KxQiFN31?=
 =?us-ascii?Q?HX0oqr/Fel+Rp4RaTw8ln7B0iiWejW7yxaR18PWoY1oSb7y7yre8dZvRrV7R?=
 =?us-ascii?Q?7XYRVx2/EsCkLsan2JgmAV06lZSG7q3pfatFnMwDcP4GKzoj+yVstzBZWCcg?=
 =?us-ascii?Q?LxXfybinguNbhWG2xjZwqQaC4G8t83MD1tsq6dDdxLGJf/k8CZZWRcc/Z7Ar?=
 =?us-ascii?Q?LfC4eVFIfg4HZ66szJnDZbldYHOmO7I2XilUWi9PNmx0xZFh79Sz1IdPXTea?=
 =?us-ascii?Q?d+hkir6BQovtmmoLgHLII9hbP0hKAYYld1bCtbBYOVq9XN9hi2II5G/yJ61v?=
 =?us-ascii?Q?PcyxlfgwXx2W0ACx1A6s9Lyhi/j7fbPoz2k5WgLmggxHldUc0OCJIpEf5F6G?=
 =?us-ascii?Q?U7UXcS2oGwO9UOwQmJgKrGoQOKagRiwGxNKUONXhG/6tmdUWAbOQE8O53bbZ?=
 =?us-ascii?Q?c3/r18UABtbbaVHBtEfzb7VvSr3mmF8wHm6SaplDYhhV8g8HNRbGViOYx3EE?=
 =?us-ascii?Q?PoSOclbqeYWjdgCttvBuCi+SU6ivjysS9RbXuyiBzI1MimF44Zc6hX0ybT8m?=
 =?us-ascii?Q?2suINPlDU/qWRp6ebNc2BhcVeSgqX6SceGcsqexIE5qOmoLBZIcJd/ejOU7e?=
 =?us-ascii?Q?ztP29pTVbxthmHa7wDs7i5D5dJaS8Of+hXkOWfRgaJ72/ZuIJpLFikFhjGCi?=
 =?us-ascii?Q?+0ZPY5U4m9q7fpFHe30u3FX3Q63rA/z6PeLwGIuXl1ek3goDTSiCC1XU5Hrv?=
 =?us-ascii?Q?NEj4WMI3OIUNWbRC/0dWHg6bS9AEcm+tvsQ3?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:37:45.2219
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e60b438-eb19-4b29-5f09-08ddbe99f7c5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9198

Define apic_page construct to unionize APIC register 32bit/64bit
accesses and use it in apic_{get|set}*() to avoid using type
casting.

As Secure AVIC APIC driver requires accessing APIC page at byte
offsets (to get an APIC register's bitmap start address), support
byte access granularity in apic_page (in addition to 32-bit and
64-bit accesses).

One caveat of this change is that the generated code is slighly
larger. Below is the code generation for apic_get_reg() using
gcc-14.2:

- Without change:

apic_get_reg:

89 f6       mov    %esi,%esi
8b 04 37    mov    (%rdi,%rsi,1),%eax
c3          ret

- With change:

apic_get_reg:

c1 ee 02    shr    $0x2,%esi
8b 04 b7    mov    (%rdi,%rsi,4),%eax
c3          ret

lapic.o text size change is shown below:

Obj        Old-size      New-size

lapic.o    28800         28832

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - Commit log update.

 arch/x86/include/asm/apic.h | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 07ba4935e873..b7cbe9ba363e 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -525,26 +525,43 @@ static inline int apic_find_highest_vector(void *bitmap)
 	return -1;
 }
 
+struct apic_page {
+	union {
+		u64     regs64[PAGE_SIZE / 8];
+		u32     regs[PAGE_SIZE / 4];
+		u8      bytes[PAGE_SIZE];
+	};
+} __aligned(PAGE_SIZE);
+
 static inline u32 apic_get_reg(void *regs, int reg)
 {
-	return *((u32 *) (regs + reg));
+	struct apic_page *ap = regs;
+
+	return ap->regs[reg / 4];
 }
 
 static inline void apic_set_reg(void *regs, int reg, u32 val)
 {
-	*((u32 *) (regs + reg)) = val;
+	struct apic_page *ap = regs;
+
+	ap->regs[reg / 4] = val;
 }
 
 static __always_inline u64 apic_get_reg64(void *regs, int reg)
 {
+	struct apic_page *ap = regs;
+
 	BUILD_BUG_ON(reg != APIC_ICR);
-	return *((u64 *) (regs + reg));
+
+	return ap->regs64[reg / 8];
 }
 
 static __always_inline void apic_set_reg64(void *regs, int reg, u64 val)
 {
+	struct apic_page *ap = regs;
+
 	BUILD_BUG_ON(reg != APIC_ICR);
-	*((u64 *) (regs + reg)) = val;
+	ap->regs64[reg / 8] = val;
 }
 
 static inline void apic_clear_vector(int vec, void *bitmap)
-- 
2.34.1


