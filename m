Return-Path: <kvm+bounces-48833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02DACAD4177
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:01:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A65017C138
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:01:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC07724679C;
	Tue, 10 Jun 2025 18:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HuOYZiOk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4D0625;
	Tue, 10 Jun 2025 18:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578470; cv=fail; b=Op0OZufL0+oUn3nQe4gXEeSAFphMCUUyv5wuOsqzSArcn1rUZHcFRZnr31CUFoQiEfsQ3QVdkdpKr/SMZrUvWx0BLzTxoojZILF6oFYFKAjI9y5/rOr7G2DWlzHhDq/Bjj46tnYmSoZFSPLZ3qZFGRzDEtbNElzTGAXskqzzffo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578470; c=relaxed/simple;
	bh=oVr1+mZ9lw0i19mhjItiCOOdmLWW7eg1euR2frusLG8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aXBi6NMSf29jw7iTLWUQGiwnah5+9IkQiUgcD10r09SR5ZplPrlmSTqEtckBpEvKj8GXJOt1o53Bb10W7jMVnXd/LsG8WGLCnUOz/vV70PNCtdhhCvNmwVivlLPpW1/LKvmhTFrJpDcTAd9c9dvoxg+tEfzokU9DYaJ+9ESH23k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HuOYZiOk; arc=fail smtp.client-ip=40.107.93.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FfSrKSXnmNAQDUZowAajANtP3SGKKSpMC8qkFUw9rNS/4lwtMgKFsj8EPyzGNxgA2xWaBmusQDT7Rl1f3K73LEIem9fnQRrszoPV+u9YVo4Ou+zufZqg829xvFLhJszSnqZ8Vbfb+lpphN+6+W0OlWc/89/DIZA43gbjUfOsh3CWtV8sgCb/3JDsOj3sAyCvdN+DD/yDmmsFYJAbmW0R0EagOXU7656YXsdtX6+I9z9oSVWJwVkEkd1h69B5xCGHfin7QIWw6sZ3Xn8zFIiJqA+wyM0mED7sPV7omCcxj0R5xo2IeONhZ/kbuCxtruXXUFH8oO65QajFcTI1cLIJpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LL6B0dyvRUtINtIX09DzYUBo9Dr3I/HdAAiJtezZ3vw=;
 b=cCHV1Jt/wiCyM0OJgXtrCXUNrf9OvrVxvcUSy7mki1JS6lUarpH1TRi5OAGjeMvYGmJsNTnDffvjnOb4+GtkAeKGXqkDY0ZElBHxK3WjrFOeGenG0yZeGH7+z1Knp494dkvzNIC0sg1kiz6pTv+F2yY1PkQ6JB0oKAL1y/uWjjBytumUbTZyU1bDVSYYv/T6JL7ohiNlJ+Gc5KjcFF+UEiMFTa/L71u5FezYkIGB6d/2m0MXsj1oNOTcmlTU0yEZElJqw0CWDzAK/yp5DD8apHbVVHvKzL0Mc+00omyG/YAHwixr4DpFtFT36jkqL0ofIbcfvABnch8nt71ngz57rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LL6B0dyvRUtINtIX09DzYUBo9Dr3I/HdAAiJtezZ3vw=;
 b=HuOYZiOkfGHykGul9uLqXPr1q8kj4Uv3iVoslYOo8p59qcKTBbXH9t9iPkPEz0EL80zNNoFY6LhZdXcKJtR6sEjEzhloTCccDtgsJSx5IglvZitDrK2KLudvSaCNR6WqjDACH6LwlorEA6Y/W1z4odixioDVXGaOpDE1Pux7LWo=
Received: from BN9PR03CA0984.namprd03.prod.outlook.com (2603:10b6:408:109::29)
 by SA1PR12MB8599.namprd12.prod.outlook.com (2603:10b6:806:254::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.40; Tue, 10 Jun
 2025 18:00:58 +0000
Received: from BL02EPF00029929.namprd02.prod.outlook.com
 (2603:10b6:408:109:cafe::13) by BN9PR03CA0984.outlook.office365.com
 (2603:10b6:408:109::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.18 via Frontend Transport; Tue,
 10 Jun 2025 18:00:57 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00029929.mail.protection.outlook.com (10.167.249.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:00:56 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:00:48 -0500
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
Subject: [RFC PATCH v7 17/37] x86/apic: Unionize apic regs for 32bit/64bit access w/o type casting
Date: Tue, 10 Jun 2025 23:24:04 +0530
Message-ID: <20250610175424.209796-18-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00029929:EE_|SA1PR12MB8599:EE_
X-MS-Office365-Filtering-Correlation-Id: 02dd6d99-256a-46c2-22ff-08dda848bfb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6WSFnWoKtSB+p3sIn5A5HcauGbYs70BGuZ993dJBjgBbJn5BnuyZgkFnP2Oh?=
 =?us-ascii?Q?gtKGHiZHRWnYyqVZFSagwuSTZiAvaIKJZFxbvj76jBO+x1m5WXaFn2Cax/3V?=
 =?us-ascii?Q?QO0K8Gfwe5PR/+tw7ZauxQf7uZeYAxdEWTUaEU7Nbaa12wZHaYroe8GDND76?=
 =?us-ascii?Q?ilWg6XgURLDFCyyEr9k5sy2wcsP5gzTeUQ1fTa7yXRB1GDzEhFZa2k+9S1pr?=
 =?us-ascii?Q?qzVujRAe2i54XjR6VEC4Ef7TCktTP5ISaq9zdKx6OtR6TYtLqlOt18yfRUUv?=
 =?us-ascii?Q?6A3o4rD8c4giJpLHM3GWFd8/PYGuO4PIUpVNW/Pg5YVmTCp3/Vmbj+FHcCAp?=
 =?us-ascii?Q?ysorQhGnzhoputo0laboWfivOxr2nyvHFQkCo5ukk6+fmyv/QlpzSjAhqTyK?=
 =?us-ascii?Q?SHxbSGoyKIa7izqOl1yD4Pz7vNZGHdXl/1pPAgePBjXHBCPDyNFBK6lTZt2e?=
 =?us-ascii?Q?+AWzz/7q7OLU+sV15ezs+tbZ0Y45UYK7dyhP/EfU3KtdsF3Wrag7M01jcTQ8?=
 =?us-ascii?Q?gIxRAyk4QKB2SmS1Ob9qSYuAIdeArel4QBjKrXqQSQWIp3/JTMBFc3e3t4JG?=
 =?us-ascii?Q?FYn48UxXt/dPKpC8smrtQk/NBTQG4Y9txWOVrL5sMpMFGh1S0LzTQ3uqA/0j?=
 =?us-ascii?Q?/HF8kVT+I9UnocPesYcYL/fukbRaLILYpHNJeOexHXMZRlfznAlZHhMAoDQD?=
 =?us-ascii?Q?mAW0AQPQJnfFJjbJ0qx9xmwhaR3lIrBYv9FJYLJ6PvW/eMxbMOKoaZTfRbs4?=
 =?us-ascii?Q?c67Bs1NMR+MEVvBGoUT/TEQKaRxLhFOhv4eCClxWt6DoSrJGFJsS15J6FTYI?=
 =?us-ascii?Q?FFti8l3oNbEqBqucAD+z5CDaKnRMa193PPjmOenRIPRpabta7LM2zkHm2R7u?=
 =?us-ascii?Q?fgNeoYVOCT7FyP2squ20VCyc780hTqWdOEPpVW9kGlFVGGGcVcCFOS8pQvW0?=
 =?us-ascii?Q?FBeCxgstHawOWCfgUwaFfzQbXFv2kPQWxMh7oLgUWgCuzBBBx+jzQjxvUfJo?=
 =?us-ascii?Q?+5wxvM7gUBirVlNPShp9wSxjePq/WnRcxfAkXh4y1m7LWU1f6x088O4v4yJv?=
 =?us-ascii?Q?zcpi6pFJIyAnUHpumHWFet/2fihHGEP3bDKqNyJ+4hm8NsUIFRTn8wodI2ES?=
 =?us-ascii?Q?JY/jgPMSLrjB2u9JXxaeujXkWu2f9z16wpM5CpGdQGaPIxQ3PoMJ9SSQCPlE?=
 =?us-ascii?Q?FBDzKDzC6pYImR4rM679LDD97ktwIhUhHVu8HfCFKDMBoYnpNEMb0VG1b0GT?=
 =?us-ascii?Q?kVivg+sGnwQ9sKRsyP11KwpC7rwTXVKFvo+iOGRdKWmCpdTKKd1N2FTptQJj?=
 =?us-ascii?Q?2zKYAVCSxGtgX2X+SBakm7MPhCoCKeKGdvdaKXmjAQIjxBssuwPF3hekzW3Z?=
 =?us-ascii?Q?i/I9PLmz47YGEJ3iakD/Ib/Lh96M+RkNAmx8Rkt4Dt2HC4wDpfQyqMc81TrY?=
 =?us-ascii?Q?cn5tLZ3jQj893NBsd/AvCGX7/8sO6wD+UVfI9exBXIIEMNataLlporpstATg?=
 =?us-ascii?Q?XM4AguKEriBQZKN6HTqywKcmBD5tp8tgqXnP?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:00:56.3100
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02dd6d99-256a-46c2-22ff-08dda848bfb1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029929.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8599

Define apic_page construct to unionize apic register 32bit/64bit
accesses and use it in apic_{get|set}*() to avoid using type
casting.

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
Changes since v6:

 - Converted assmebly to AT&T format.
 - Added details about overall size change in commit log.

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


