Return-Path: <kvm+bounces-48818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3701EAD414B
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:56:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 005843A762A
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 17:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 131DC2472B7;
	Tue, 10 Jun 2025 17:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GOQ7SVVH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2058.outbound.protection.outlook.com [40.107.100.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA42B2459D0;
	Tue, 10 Jun 2025 17:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578130; cv=fail; b=RbnMRvkWOgi57HqN3HTumANmyF9HdCs5vCIEAt+EbmeFQXh+SpxhXDtL2xXSfwDtn2C3hab3+xdx6PtEDNaQM+oZt7Od2JOpUcN+gQrRnL8gsFoEkwcW43S46B3qABQo5zE3PV+l1ZlLPce4JAfyLy0dXuYA9pF3u3wfs3PtbaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578130; c=relaxed/simple;
	bh=6hUpNbw4kQGca0HO65zNPnjHuov0m7Tl39CYO1BrgY0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WzKPJiSulyoN6o8MCZ4KBYQJIcEsavlmCGvnzBDmVvBc/wNz6DSaPLna2OPFC9NdS3f0a66q0NRKKc6fVvZkeWiD6zvoneZe0I00hznnH0/cMaGUN7u6PcDsRcvXiQYZrbqXlrsgFpfMbPcnhXxISgjOvDwfhrQoeWOk0m3CeJY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GOQ7SVVH; arc=fail smtp.client-ip=40.107.100.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f4S00FtFGVecX+L+jS8bcX+hzgUPgImutdjJEsRbGHGlIeUklTo49hqDvsELn+JAyBWDIaKIE+q04CXejk2TxMFlSRmdm2krrLquZ9h/f+uW63XEVXbycBe/oRT5D9sT8ZZYHxGTYRXSftzRK/ApFDVqonDWu8ArNwvjkfOnAHE25rc4qTTsl5S1pmi0pjrZpJRAh1X7DgttM+w5y1geu6byRwZMdVwpA1IhM63P47wV2vwe/+kBGaJXO03BpL0p+Y5W3HuWviFb05T3EsUA4P3RfFeibgi0rkpUTw3lXNy/ruxnCJVEvGyYRtUi5AmtCnh3yM8KJhx8W2cs6T4uBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/in8VR/+AmMU2RySINEbUXO9U4aEBbz5xNRGF0k6qcQ=;
 b=DXWjxz55DrHSr34X6BK+Ix4dHmMH8+9z69UbaZ7Einq7Ut6b6T8I6A72m3hM+WA5Ze4PTC+Wbuv3/d/rB3Wv9tFII0iKFc8nZnmuDvei15ZqISzs71yGkkfijgFa9QsAiMRSydyLBG2dKBc5fQuDESe5+xgnA2OpeTIckEfMOoQDbw4eFwuCMjHt/KJ5JwuIsv2kVOEQ6Jrrd/sh0NrCdc7lIMvPWF/9BXdQwJUQXMVSq7vCRySOMOQXpZGLfy07TlFzIIEpm0mzXQCA7TW2Kx3IlnjgCigec63tfrN9kVdShSnpCDirWzCbhNfW3f5F0qeZl1h37k0m7FaOFYSkSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/in8VR/+AmMU2RySINEbUXO9U4aEBbz5xNRGF0k6qcQ=;
 b=GOQ7SVVHCq5dLQ734/RyevQCKB2Zqgz5QjCKSdB09Y+Rkdwi8aeyFBfWmskbe7MzTGkcBQ6DzcEezf462GJn2+b6XPjHfT8/Achx1BGvo5YQxlDZFde7lsLCpGy37l0vmFIaawte85mIT+3Z5EdllaSpYCBxtyZvAjdktFR8/Eg=
Received: from BN0PR04CA0063.namprd04.prod.outlook.com (2603:10b6:408:ea::8)
 by PH8PR12MB7231.namprd12.prod.outlook.com (2603:10b6:510:225::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.39; Tue, 10 Jun
 2025 17:55:25 +0000
Received: from BN1PEPF0000468E.namprd05.prod.outlook.com
 (2603:10b6:408:ea:cafe::28) by BN0PR04CA0063.outlook.office365.com
 (2603:10b6:408:ea::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.19 via Frontend Transport; Tue,
 10 Jun 2025 17:55:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF0000468E.mail.protection.outlook.com (10.167.243.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 17:55:24 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 12:55:17 -0500
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
Subject: [RFC PATCH v7 02/37] KVM: lapic: Remove redundant parentheses around 'bitmap'
Date: Tue, 10 Jun 2025 23:23:49 +0530
Message-ID: <20250610175424.209796-3-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468E:EE_|PH8PR12MB7231:EE_
X-MS-Office365-Filtering-Correlation-Id: 35313fe8-af80-49ae-4e0b-08dda847fa19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?I8HKtDt6GXcq+5N3NhSbeo8xo3O+0tk2/t0UoI0m2M0IIhLjelxW04QFn1Iz?=
 =?us-ascii?Q?+4mJkGdcCGLmc/jVYfoLLoH9kIFJEtay0TPQpDrWdRhKK0g5jIXDiypex4MQ?=
 =?us-ascii?Q?xI2GtL/coLl9Dc0uqXXqw4s0fIuRuClsI+rI9VDE75MiOVRsCA+jK6dtZI4u?=
 =?us-ascii?Q?TrPsExkPAqAWNhkRYu6tNres/hU2YEEtFXZfNAKKb2SiND0QF7luGZE1lQ/r?=
 =?us-ascii?Q?S27J2+HS4XG/WlqfWxho7MxTcCESp2wVmgRfVKZuuRXnl0kRd4uEW7gUj+el?=
 =?us-ascii?Q?86DP0QpeLWTaE/eEY3agKI5H2VfLP9O0Te4av+cFmr6csI+lSPL+DvbbLFRN?=
 =?us-ascii?Q?A6DWJXPQcj+qaimAwVe2SL3aMbKcukeehQYRpmZJ/GprYWiye62e+pQNFHod?=
 =?us-ascii?Q?G+qLoOwO9TuxfieaCC9mvawsnl1hk3ou5BOqwCtSnxDcF2ReGN+qzkv5UB7E?=
 =?us-ascii?Q?ieortq3UgyLVjHiC8g3UyE5wRG8uZpBMnUKDqxvk+AX9WEX8OFrl1ZWlSfaH?=
 =?us-ascii?Q?21dPBVPqdoIKRDIB9HEyYtRMQnoiaAUZL+nLV8MIzZ3Nrc0hEuXdQ8GX4bdO?=
 =?us-ascii?Q?DaTAiOTNMNjCwtEZkaeTNUzb+d6UTR0vqMcfNia40Yxwz0MzPQMOWPFK8dNh?=
 =?us-ascii?Q?Gk5pXZFU3SBnFiERWKgcqt/7dcb/rrp9qpAoySvm+bL35RJTiTQqhhkJf/et?=
 =?us-ascii?Q?eMrFiL05D5YAySJ63HxMT6dgaio72VE+SmLSQxnTin4j7UH4p5jpbf/pr5sv?=
 =?us-ascii?Q?G/Uq4o/V0/NCL5k+wx+8lsyDkG7adnK8vACS8MnIwCfPxJNJ8SzcRwa2xT64?=
 =?us-ascii?Q?7bH/Rh+kaUsTUvlZH50HTtrcwo5qA6YwYodKoMMJvJoX8HwxpN+jpF5ieKkR?=
 =?us-ascii?Q?WhrMniIJgdw2rLXWCwy6hSfO2pakOuU8xQGyxn554LLzSb0yLYKlssq6ykCZ?=
 =?us-ascii?Q?8Y36bvikIHVh4diYO/KhVF5YBk+zza4y1oDtPI2ruMU0ABqQ+j3DdSVe1fla?=
 =?us-ascii?Q?Sw8Ubq8hq0rr3ofDrgSJPvDF/pv/bSG8Rp9Sst2eZud/GYlJ1L74ur+2BIBz?=
 =?us-ascii?Q?hFMT9o4fBwg1RfZlT2Xyb3cz0lcVdqrGwuPz+aZCQOjFMNKFWXG5/sHVHZlS?=
 =?us-ascii?Q?bojgDRK4De3l5RMGmFXn0W14ADxuk+T52fKy2peg/tXzOSIxj13SwrDl+34T?=
 =?us-ascii?Q?4uA23m1e75LmbDlhHZITg5weM/N5U6fYJFQxXAr9nNV+FqRHgXQ4i4G9bRPg?=
 =?us-ascii?Q?BQmdczm0tydTR+o7yNQp7IWxUrNof8jYiTLorpmW/RIARo7WCxqESEhQgwms?=
 =?us-ascii?Q?DYG4NQ+OLcGCR9XhtqYDAmV+YRUsTB8LinAbEIL7UUvR4mdTmikTK+zLDZUm?=
 =?us-ascii?Q?pFP/VkrqO0J6aDSP5mccRXYQJGFY9t0gjri1hK1wowKuQ63lcG61pmrwbh9I?=
 =?us-ascii?Q?ka11qxapcdm4+yKPJ+IQoSfJ16wQc0y5wmE/ZoO7jah/P8hgWfesuiYYE0Mq?=
 =?us-ascii?Q?Ty8cHvBXgrg/sylnL3x92X5QPIV0NhQ8tVXo?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 17:55:24.8154
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35313fe8-af80-49ae-4e0b-08dda847fa19
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7231

When doing pointer arithmetic in apic_test_vector() and
kvm_lapic_{set|clear}_vector(), remove the unnecessary
parentheses surrounding the 'bitmap' parameter.

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - Refactored and moved to the start of the series.

 arch/x86/kvm/lapic.c | 2 +-
 arch/x86/kvm/lapic.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 11e57f351ce5..aa645b5cf013 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -114,7 +114,7 @@ static __always_inline void kvm_lapic_set_reg64(struct kvm_lapic *apic,
 
 static inline int apic_test_vector(int vec, void *bitmap)
 {
-	return test_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
+	return test_bit(VEC_POS(vec), bitmap + REG_POS(vec));
 }
 
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 4ce30db65828..1638a3da383a 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -150,12 +150,12 @@ u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic);
 
 static inline void kvm_lapic_clear_vector(int vec, void *bitmap)
 {
-	clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
+	clear_bit(VEC_POS(vec), bitmap + REG_POS(vec));
 }
 
 static inline void kvm_lapic_set_vector(int vec, void *bitmap)
 {
-	set_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
+	set_bit(VEC_POS(vec), bitmap + REG_POS(vec));
 }
 
 static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
-- 
2.34.1


