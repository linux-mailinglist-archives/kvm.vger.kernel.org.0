Return-Path: <kvm+bounces-46438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8631AB6428
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:24:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DA2F16D12C
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:24:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C84F21C9E8;
	Wed, 14 May 2025 07:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Y2c23Flt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060D22063F0;
	Wed, 14 May 2025 07:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207358; cv=fail; b=o4ogW5TA7sKJ5bV2bTu5NIOo8357obYbfNaMYMqA/hfJyG74IW30IbZMOnWMC/jEwDrh82wpP/fOIQtbGOKBuaC8em9oo1bEt1ItXYvNzDI0ViHZAbX6ngUMUacIYBwUz38/x58If2f1RyemNeDxoTfpF+2vLuCXwII3rEwnneo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207358; c=relaxed/simple;
	bh=/URuWQg3VABghLblrjDT3v15vLJfKWCE4pjxZeikgIE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=feEVO8nzsU1ucCcBT9oFBR3BkNU15K+MAf9DJO9g1+MSvIWn/ibdfae1E3t1sv73+t70ZvIwIOgk37w249GHyNrcRAtATqX//GPDXZfgkFiTZRI7lpuCT5X5NAZVfkDs+HmG+IuOzVdomHtuEurKGvpwS23j4Dyv32oYlZs5hb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Y2c23Flt; arc=fail smtp.client-ip=40.107.223.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S2YUc4VJ68EmgMxTNhbqrAiAdiEOBnVLQVu6GTEbYXN2Whk1pyK5kMXpE5keQeogSqOunrSaI7Dv3rJKt2ZY/SYV5zXsPX8kV+7bZ7TeuIbPoU4nov/n8S098S+pfv6mRZTB6RMZwXe8fWQdqdUgVicvI60uMHu+L3XxIk7QTiqyWvCPcTnfydcOjSzOILAQC/Bms9faxKXKb2cIfyZPU6jH29JbcRGDpBlNxOzSBfIxeG9i8tTepHwqYpWFWtK4jqipbLWpL1DC9OuxAHsGdy8LiUE4zt8L4A1MrQN0UfD4P+p6V6KmRMKNQAwNXnx67MZDQAYtQW96PJF8Gx8/zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YSrTQM/cZla3IDNfWfNZWmhgY++mmj2s02nVRwa5fFw=;
 b=PTG+ZQRGaVGQLpLy9tJU55/ONDN3oKI22vPnjQVg/GdJxzInhQGp8I62D0iScAwu1ObnSTRK0Wc/vRFlDC/3uThOy9b1H6Src8SvzGLAP/PIiEO8Q4mK8832/dhosSPLGrgl1aUq9opcTSN59uYtHm4HMykmpftSnHDM1ecp991z/fYErYHSZuyeZOLEUXDPV+FTG7f/VnwxuNecmbRZN97HJvc6uve1SgKv7zg3mADVjGJIuH3bvCt5UYa3HzPwqebX42fumHAmZ/ife5xf5mXTVhra6SbWxXMFuLylchj2f+j/MVlHnczh22c294NXskTSxjHqpGZ+MH1wnCCoiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSrTQM/cZla3IDNfWfNZWmhgY++mmj2s02nVRwa5fFw=;
 b=Y2c23FltV/iAqMKfF7P3ATdFXAuuyrmC6BPzLaeyMTczBZWNSvW/LCdF/xsF/9AOmZWZ9QjBgaJvd7zkDG8S7oaUiMIrRsESb7nRy02uhvCBXPwrJR9MQzic16fi7U7a0g/rCiGjEjdTbcG2gH9yzZTwb5c2tO0y8UOgyuD7Q4g=
Received: from BL1PR13CA0322.namprd13.prod.outlook.com (2603:10b6:208:2c1::27)
 by IA1PR12MB8263.namprd12.prod.outlook.com (2603:10b6:208:3f8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 07:22:25 +0000
Received: from BN3PEPF0000B072.namprd04.prod.outlook.com
 (2603:10b6:208:2c1:cafe::d7) by BL1PR13CA0322.outlook.office365.com
 (2603:10b6:208:2c1::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.11 via Frontend Transport; Wed,
 14 May 2025 07:22:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B072.mail.protection.outlook.com (10.167.243.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:22:25 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:22:15 -0500
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
Subject: [RFC PATCH v6 10/32] x86/apic: Change apic_*_vector() vector param to unsigned
Date: Wed, 14 May 2025 12:47:41 +0530
Message-ID: <20250514071803.209166-11-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B072:EE_|IA1PR12MB8263:EE_
X-MS-Office365-Filtering-Correlation-Id: f82d3377-a5c2-43b1-e86f-08dd92b81397
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vyezw77QtYfsd7yombv/BQbsyxdyB/oo8gIf0GbFkIxuImsSKmfyrxTmo0eu?=
 =?us-ascii?Q?3giqUdqjWPLQNHCi7eG6KKOm4LvN/kADGgHVGrEhh/wLLQCNcFH/XftuMDSM?=
 =?us-ascii?Q?ydmMEA8d4M380k0LSLghZ+UzGiAcNmZJgUrQ2ioBOV9BnoY5Ip6EhM+RLS0F?=
 =?us-ascii?Q?9X+4fOukgNMjgTz9y/q7J/oGSEciEsgnlqHhUJAP7zudPi3y68pHseNTrNvB?=
 =?us-ascii?Q?rSHwHL1WYvQAGbnKgNQyaMyQHw9Emi0EqcikKAQPJI/vQWXSdF9ArjWr0WOL?=
 =?us-ascii?Q?97X4BWnFoTfavK/aMY78ioj1FVqO+FmYsty8Y8BqA5MrnFoJsXtnZSPyu2na?=
 =?us-ascii?Q?MpfNe3Jspy3ghBas/TOgFxCNKmZDXZ8jteEn3QssLPy0mJkJ1LVjvKB9+qIi?=
 =?us-ascii?Q?qNLOWKy4dxllEF/uxfeW/AqJg2K5UuEs6UW5Hv8DEXym5h14Ml3EAWqZ4Fzz?=
 =?us-ascii?Q?bpKEoSMAUib0RP/US+grUtL0jKbmDzooyhZ7cfEHZP+KqMTMWbmSgFDFnqSb?=
 =?us-ascii?Q?QIzBR4b6sDMgJoZVo74zU4DdIeCSUUKXeEn+uPMyahiesxJfara5/qT17wNG?=
 =?us-ascii?Q?jqKnwlDLGIf8iXT5k010StFfPFeit/kD14eJ3eoPrIUzTotsC+Ad3daEAcA1?=
 =?us-ascii?Q?z+NxI8DyjkV9M6Urj5m2pkGMo+udNlgeoICh7bN0mvZVvVnE6LzTmQdxnKwR?=
 =?us-ascii?Q?vtXKP7fdkGo8/1064Y7TGl9KWgm6EfAvHkDlG3x1/doSysjM3rMYuuc/spro?=
 =?us-ascii?Q?S5sgbsFne0nc2M0mYM5g1yqB/X4q2D9VqG8uoh4FL07oS6ddSnkMtTz2uX75?=
 =?us-ascii?Q?hSRNuvNylh8QejGRgz0TD1hZTQg2PXz9npeHdZQ4oqEXfo4j/mec7za5VYl0?=
 =?us-ascii?Q?93iN93JqXjG/Bm4jWDMKbObPCny+nPI32pRQlqPHIYIdgRCw2lXVXM5b4EqO?=
 =?us-ascii?Q?iR1Rfsg/3a3PCgpEu12bJ7VXQlJyMhASnnlyw/WHEXNP+M6i8SNBCENLgdgn?=
 =?us-ascii?Q?xNoVUhREy0h3kVMoem446eaeBT1aGZUe0pEVk1inKWDX6poc4pkkph6pfvJo?=
 =?us-ascii?Q?5ktpNIg9PSIdQzPigWjbp+F29/V9AgukAAKVgHRMrMkFQc6Ox9XMbVRnz9Ix?=
 =?us-ascii?Q?Cqa4t6D+PmDvfQs1tzbyXcj8AYHKunWuifKvx0KQKby6++R2cBLDGPro8MXN?=
 =?us-ascii?Q?q9xZRThR0myorX8mun5vrC742XOot2MEcUdnNI80DexI+0PFqYjLWU+zuj45?=
 =?us-ascii?Q?HN0ZPFdPmmjhiRZq2Tn0whum/1k8BtwHHQ6Q8m/NINYVIAq4B4K/DYBhpHb5?=
 =?us-ascii?Q?hAwAHYUlGsGAlWvWrNLKDvNkfhe/ueJP4Tbpg9QEeXi4oAZLO82ZqyLOgMdk?=
 =?us-ascii?Q?Wmm5u3bP/RDm+pwsCmnVW118yuRZizh7w8OEnVKd+FMbngJDDuAm+CZMdorq?=
 =?us-ascii?Q?XUvl3MCVw4g9zjYP0EGk7YM4bso2ci5y/ROntugENgwqk7t5qzYfeQDa0JLQ?=
 =?us-ascii?Q?tP9S9ENy+GG0PcicK5uOO9PXO0voGKbGjt2r?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:22:25.6412
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f82d3377-a5c2-43b1-e86f-08dd92b81397
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B072.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8263

Change vector parameter of apic_{set|clear|test}_vector to
unsigned int to optimize code generation for modulo operation.

On gcc-14.2, code generation for below C statement is given
after it.

long nr = APIC_VECTOR_TO_BIT_NUMBER(vec);

* Without change:

 mov    eax,edi
 sar    eax,0x1f
 shr    eax,0x1b
 add    edi,eax
 and    edi,0x1f
 sub    edi,eax
 movsxd rdi,edi
 mov    QWORD PTR [rsp-0x8],rdi

* With change:

 and    edi,0x1f
 mov    QWORD PTR [rsp-0x8],rdi

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - New change.

 arch/x86/include/asm/apic.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 1f9cfb5eb54e..2acf695ed1b7 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -547,17 +547,17 @@ static __always_inline void apic_set_reg64(char *regs, int reg, u64 val)
 	*((u64 *) (regs + reg)) = val;
 }
 
-static inline void apic_clear_vector(int vec, void *bitmap)
+static inline void apic_clear_vector(unsigned int vec, void *bitmap)
 {
 	clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
 }
 
-static inline void apic_set_vector(int vec, void *bitmap)
+static inline void apic_set_vector(unsigned int vec, void *bitmap)
 {
 	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
 }
 
-static inline int apic_test_vector(int vec, void *bitmap)
+static inline int apic_test_vector(unsigned int vec, void *bitmap)
 {
 	return test_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
 }
-- 
2.34.1


