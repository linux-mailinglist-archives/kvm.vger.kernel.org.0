Return-Path: <kvm+bounces-48824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25486AD4162
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:59:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C06987AE52F
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 17:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A11246797;
	Tue, 10 Jun 2025 17:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5exXw+Zc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2048.outbound.protection.outlook.com [40.107.102.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A54236424;
	Tue, 10 Jun 2025 17:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578262; cv=fail; b=Dsu2f/2Fwng6dxQKpxbyalpsDQbl2pvZsR/LoUBl6VvYurQ0nua5q7oE/ZL6xQLKGsmtaMraWEGodN/bTRh6D5yVkWeiXQiflHgrZjPVcbGYttTMd5euSrK8u61zXaTjW6VVTGd7gqDgGeW8YNOqFae7YlmEi64vatRuM/6x4QU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578262; c=relaxed/simple;
	bh=W1u0nuguvSNLTUKKtrOzbffMmRD+wGi/6omn7ISo7EI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qRERLGMP5bl+5j8MFs+TMRXoNLunpNoJ0gjT4Q83aMp7cgmWc+LOvlr2ss0PTSUx/AJ5i+H3jch0XIZ45fBZEONybbcVUAtEugtyrQqWcRBmSvenRLDmVw/MSuF6R3goukLj1xqoCzsaPj8XwxfvLBnItgYAheAqaNj3ZPmwmkM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5exXw+Zc; arc=fail smtp.client-ip=40.107.102.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YslYGIkgg0rmKOeJfRwSMnBch9bO0v9vxtPGVln1IHbuQKlnS+jO92t5CIpP4iozojT5DGECiwuCWS5dK2QSO79Vf1CIDK1jtjyC6gls2JbRZBmPg6J0L4MsNNkHy6AD4kky061DaxhzcQ5T9Qy4jyW3Hjantqcvtv3VeRXm7hmTgpx5gDALfTzowAFo24XNiRjkdpV6aiJ9bBVSQHxqqtLZIueBp4EYRXxTWBVnzZA8jBiKPjUS29j8hpS1OMc0gmmQ8vZxe6aRVWUGyXbNLzNTa59CkBwrPr1SnCeH4e9kvRRXubvb9r4bnm2fHCQy76YgdvINvLC4w9gOP+5MTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p5wMfHp6fdjrEQf/H4uH0BS8Apakq8eoJxgkc4QdjVk=;
 b=COYvEOUKxPJfSFSlb91V8fwWpK6Cf3BzVEsVg6I74H2DG+tdLBPKGIpnoydKLW6NKvjV59niuY+rj3cMPt2CxPOa61wKSfYBW1zGLy1hOq7EFijviOqRoCe1F1sejQ6g5aI6Eb3RW5QI9N9zfYaGg3sIAjDMjlsvEwixV6XYUJ+MvyjCrUGB5tzaQAR42OUmgI6ozIMuqRupHzwpQI+IG56xA6wS7CprKYUkzKuVo9YsljDwFzD9zDYefNNBq2kiix9SpskZ9YZ9/hTuVPeQjNwamYdHP5eO+48hdYljbbnX+jctk1G0zkxie7gWoyDdnbDHm5FipYIHYN5LichZ+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p5wMfHp6fdjrEQf/H4uH0BS8Apakq8eoJxgkc4QdjVk=;
 b=5exXw+ZcVw8YzYyntE+xPRVyolYeTJ7kojhSKbpjlADS7R//hCv/o2+Aft/LHuWKMUOeGRpLuElV2Xf7lK9On8w0AVY7673+Zwgf9b0iNJLIxPLhLXm2ZC+HK7U+u8XJlDTnpZIIBUFWKt/W3TrGnMeeTYEo/WwZ+yFuyg8Z3W0=
Received: from CH2PR02CA0020.namprd02.prod.outlook.com (2603:10b6:610:4e::30)
 by MW3PR12MB4474.namprd12.prod.outlook.com (2603:10b6:303:2e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.31; Tue, 10 Jun
 2025 17:57:38 +0000
Received: from CH1PEPF0000AD79.namprd04.prod.outlook.com
 (2603:10b6:610:4e:cafe::6e) by CH2PR02CA0020.outlook.office365.com
 (2603:10b6:610:4e::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.25 via Frontend Transport; Tue,
 10 Jun 2025 17:57:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD79.mail.protection.outlook.com (10.167.244.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 17:57:37 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 12:57:30 -0500
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
Subject: [RFC PATCH v7 08/37] KVM: lapic: Rename lapic get/set_reg64() helpers
Date: Tue, 10 Jun 2025 23:23:55 +0530
Message-ID: <20250610175424.209796-9-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD79:EE_|MW3PR12MB4474:EE_
X-MS-Office365-Filtering-Correlation-Id: 358c787d-a560-489e-fbe8-08dda848493d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BVN+6h6NpBksHmaNDwhNbdy2Renq9cNgVQpnhwXaYY4vLibY9i98igww/MK2?=
 =?us-ascii?Q?HNkSfqP4npUvOinPhkpMgrvKaoV7P6EhaJ6hMLDFL942fGvVopR1zoxOcjfU?=
 =?us-ascii?Q?19Howvmea8LaJeUeAE3q1dlNTzniwp0WNddhfLVg3tO7YDbZFaCqRzJZxNcf?=
 =?us-ascii?Q?m0yIfAy5V3me5FTRddemvyGV+nREYQuY1X2Y/TNES5UdNc8D8PhFwp/bL7TK?=
 =?us-ascii?Q?0f1NKNizsNR+w6ujgYDFOH5Rc/arcs3AkqkDohZ9cmUCUXMUjRPJ1/uZGquK?=
 =?us-ascii?Q?QbRV7RRVb34qkN9EokDi4g/fGEF/KAqz0Vsk6I209Xo/jygdaGBpCOf305Xx?=
 =?us-ascii?Q?nKn6Sha+Z4SxuXPkkgWFhcEbiHbPx0ho2/30AscB3fdBC6p26fRryzDdsrfl?=
 =?us-ascii?Q?p8QE25TKZ3uSrty54PYFDFI8k7FQIz2FXYDHpzjVObtWTUki4sMKAyMmWtIq?=
 =?us-ascii?Q?0rmtoo4Vb1eIcbObRxbUVtf2q3niSNAC6YcI19lB0jqQ7Da4PL1fOt9mBc5B?=
 =?us-ascii?Q?VYPbFh/eJWqbVmh9Wtt3GqAN5PUHiIQNFfl+G7JFc9nScl2qnY2UFlGnE9ut?=
 =?us-ascii?Q?yOCtOij2+iAmgrTElVaYKDOSsOitG1ZMDMi/+8SL/l/QA9N9q+cLJ7Tq0tr/?=
 =?us-ascii?Q?DVzZ3RMcq3TKgGG3MO7EvxvJBTaD5n3pPcbJCZUmQZBXIVFFTlBJvUSfhCRJ?=
 =?us-ascii?Q?euu/jYuzA4XtUBaiD6Wsz50RLRdpe+0UMebqk3W5J0/oEJuMiHbq8h9nMtGZ?=
 =?us-ascii?Q?cSX8ppALvpw0Hx0pX1m+UJePnfOWdCKXIEXkw6G23G26Hv/Ie4b5OVJ7Yebb?=
 =?us-ascii?Q?BHp4HWN+1dwsaV4eXZO0K/oRQS0ry3AlgQoJzaDYX81+F7Wct0V4Mphyridv?=
 =?us-ascii?Q?ADdSZnjOp8ojM8tn8G9/p3U79S7CON80r4wqlyHd0ZeKLIc9fgDSnbKe5rDj?=
 =?us-ascii?Q?AHNNJQmApSZtvZzvePcTfqf7x2kdHlP6rDqxXdGFZHQiloFC4knpZ7VoONGw?=
 =?us-ascii?Q?huB2bo9aMzEE/CXoI0Hu4he8YyFfQ/eqOsz3kEsTrKg6XcCpROI9K+xzfhGN?=
 =?us-ascii?Q?qusmxaQEcHz4KYBsL5v1fDWwt9LM2FLAs2PrztWQBHS99oukgMFmTdbuMHqz?=
 =?us-ascii?Q?3PXwTnYXVVZIVEbNIm8EYj8uLSwtTTN8te5r0zCiCc1wblhvjAYKWU30ABPY?=
 =?us-ascii?Q?pFU0AjjuiVHnwiB0njKclUpbnjfxPGmOe4PGgBPv9lTHHZNsYEE6ZZlSxzoq?=
 =?us-ascii?Q?vIuw8lGj9BIPO+nc/d8vFdYL0TWuYN19OC/7jmN17CN2YNLUzPy/GUNDQt2S?=
 =?us-ascii?Q?DIdolDRa2XCcne7XEELjToKeGXY0U+upX3LJrrbEMuuY6MEjId9vB/Bgw0z0?=
 =?us-ascii?Q?lBjzaxDsl/u4ao9m+zZID3zmVSMLPp/8P7xlfGESmfvgh5BsoCRLhndff7sI?=
 =?us-ascii?Q?UW9Iglx7XR18w1pEw8s1GCT+YxaPTTHwlBHyMEsf3dF6H+dji189QH2okgON?=
 =?us-ascii?Q?M918Qu6EevagYe8WGCl2L4Gsf8S8fmSJije3?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 17:57:37.5848
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 358c787d-a560-489e-fbe8-08dda848493d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD79.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4474

In preparation for moving kvm-internal __kvm_lapic_set_reg64(),
__kvm_lapic_get_reg64() to apic.h for use in Secure AVIC apic driver,
rename them to signify that they are part of apic api.

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - New change.

 arch/x86/kvm/lapic.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 1893a650519d..e5366548e549 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -89,7 +89,7 @@ static inline void kvm_lapic_set_reg(struct kvm_lapic *apic, int reg_off, u32 va
 	apic_set_reg(apic->regs, reg_off, val);
 }
 
-static __always_inline u64 __kvm_lapic_get_reg64(void *regs, int reg)
+static __always_inline u64 apic_get_reg64(void *regs, int reg)
 {
 	BUILD_BUG_ON(reg != APIC_ICR);
 	return *((u64 *) (regs + reg));
@@ -97,10 +97,10 @@ static __always_inline u64 __kvm_lapic_get_reg64(void *regs, int reg)
 
 static __always_inline u64 kvm_lapic_get_reg64(struct kvm_lapic *apic, int reg)
 {
-	return __kvm_lapic_get_reg64(apic->regs, reg);
+	return apic_get_reg64(apic->regs, reg);
 }
 
-static __always_inline void __kvm_lapic_set_reg64(void *regs, int reg, u64 val)
+static __always_inline void apic_set_reg64(void *regs, int reg, u64 val)
 {
 	BUILD_BUG_ON(reg != APIC_ICR);
 	*((u64 *) (regs + reg)) = val;
@@ -109,7 +109,7 @@ static __always_inline void __kvm_lapic_set_reg64(void *regs, int reg, u64 val)
 static __always_inline void kvm_lapic_set_reg64(struct kvm_lapic *apic,
 						int reg, u64 val)
 {
-	__kvm_lapic_set_reg64(apic->regs, reg, val);
+	apic_set_reg64(apic->regs, reg, val);
 }
 
 static inline int apic_test_vector(int vec, void *bitmap)
@@ -3080,9 +3080,9 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 			if (set) {
 				icr = apic_get_reg(s->regs, APIC_ICR) |
 				      (u64)apic_get_reg(s->regs, APIC_ICR2) << 32;
-				__kvm_lapic_set_reg64(s->regs, APIC_ICR, icr);
+				apic_set_reg64(s->regs, APIC_ICR, icr);
 			} else {
-				icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
+				icr = apic_get_reg64(s->regs, APIC_ICR);
 				apic_set_reg(s->regs, APIC_ICR2, icr >> 32);
 			}
 		}
-- 
2.34.1


