Return-Path: <kvm+bounces-51836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B8C1AFDE26
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:33:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01C0E582926
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:33:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A4E01FBEA8;
	Wed,  9 Jul 2025 03:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="x8YMRlEU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC43E1F866A;
	Wed,  9 Jul 2025 03:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032020; cv=fail; b=eM3sI+RKTKG+vAvjhYMhUrG9B1CashQaMU8PooLjsKsDRebsjtsbVgRkOjRu5WHBqDS2V9YhlbZ26PUyRak0/YkgIdkjKqaND2BnwE34sru+62f6MSBf+/Mq2eHetcuLho8i5/MzPHlzUk+hSR1ng+dc39rvZbIXrGSCY482tJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032020; c=relaxed/simple;
	bh=08n80cV4ol+axWQGUc9PVqXM6dOl8dokDnjnBycVINE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j0nfHcZ031ipcqPPZ39c8Ddm7MAwaDQzjA4TEW4CA/wc/0IQrPxHYmCQU8+RkoJnvhTCOT/dcpe1ZrEtCCa7VRyhinS8jP2UVGGgEMmCTZQp22k90Pjd99l9ZFbKmxkHJBUr/2N91O8gOHnLzpXy3P4ciN6c/JC59R29OU6Z1z4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=x8YMRlEU; arc=fail smtp.client-ip=40.107.237.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LzBcKKlohRY2CXf/5JFs8kBiUav/tCT/txub2xCW5lW4z2omNa5CUCyUpRw2cu2H/GUg6TqFE6Sl7PV1k0lnFsWjomTycvHhRv/TcB3i9azqUb7ETwqrJI6Y+UgbIh6ZDxTw2MkAY3IKMWhFDx5O885gdz0eBYRpD4wdeN6/WGyKpGKD027b0jQBKNS2lhuxHmC5CNlSK93Cs+NxntgxlwkhOG86HADGyAMW7Y2UzwXwE2axhJfSxZ9MJHzgkZjwNKX3QU22/v1j8+Xqeg4xRkAsZhR3i5yBWpHlvbyLc1sA3InLjNirLa/wLEMWCi3V73h16W1NtogbTGCzCVf/HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9cMnJba8t3uYUFZVIrfaCWJ6HjwCaCfqEIwzwJKnHOU=;
 b=cyyQNM8g+OqmXrPZxi9EsgDiKnMzK3Sy4MNR/8dXdzs00Cbhm9uKRgk9Rk9J1ocHej0rZ2TUFmJNsgwUFe08q8K13AGrx+jgSolvNZVzo85rUT8GvyjhKAOFRMOe96PoUEXsfH6qgV60fqQ65slqo+sC1esbUSL/IBzflYlsUo+gq9SME/MI86bq/6d9cyRTjgFXKfrbKsu0+8tan8jEKeU3//ksQSZP9Abo0SnUo/QJXFrCiqxshwJExKRcTBPzxYTCUBoqAWbOjMHTnUOFnUIiotUCyDVm/u4h3UoqjDbEoEoiwZD3/Qi2qahX20TNm2/8NlYLFEOteTuazWwROg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9cMnJba8t3uYUFZVIrfaCWJ6HjwCaCfqEIwzwJKnHOU=;
 b=x8YMRlEUAdtDalG3ERPRlF2UhWryH+4+4OF8Lek8Xtb75AH3cbl6M/wMGa468HuBDMlogWAIyjKB0gY3xZCvXKQ3eXGv9whcwqKRiYti4707wqtZYPVT9BYZBPg5rYHXqPnUrMhIsOneo7xhd5OC3EI4Zrx4VJ6+gCP4UHu31vc=
Received: from PH8PR07CA0013.namprd07.prod.outlook.com (2603:10b6:510:2cd::14)
 by BY5PR12MB4146.namprd12.prod.outlook.com (2603:10b6:a03:20d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Wed, 9 Jul
 2025 03:33:33 +0000
Received: from CY4PEPF0000EE38.namprd03.prod.outlook.com
 (2603:10b6:510:2cd:cafe::c0) by PH8PR07CA0013.outlook.office365.com
 (2603:10b6:510:2cd::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.22 via Frontend Transport; Wed,
 9 Jul 2025 03:33:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE38.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Wed, 9 Jul 2025 03:33:33 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:33:27 -0500
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
Subject: [RFC PATCH v8 02/35] KVM: x86: Remove redundant parentheses around 'bitmap'
Date: Wed, 9 Jul 2025 09:02:09 +0530
Message-ID: <20250709033242.267892-3-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE38:EE_|BY5PR12MB4146:EE_
X-MS-Office365-Filtering-Correlation-Id: f91cd624-869d-4aa7-796b-08ddbe9961a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?g9YJId69wSzmuULFJWH6e58bNRdfvwbV/yaqTiPN23xvwPHxkdnaEHyo3YLK?=
 =?us-ascii?Q?xRhLQfzzpQIMkXKAMXm2DtRiEC8aGiWjgiuogR3PnnyB91R+5zEWfJI0XhMV?=
 =?us-ascii?Q?dKESK4Heuc5RiN1q7h48qHKhoXTObSb2UmxGagTZsqbT5I1zmxakvHdWpe/J?=
 =?us-ascii?Q?aUjeRXlffvm9El4T85//wNHAKcH6aIBc9rTHo7KO2D54uyoD5wNQlO6ojzV6?=
 =?us-ascii?Q?GmbYyunXfJicqGm2Hhqcvn3GFQQB26igK4n4NZhLJpcPn0CBQjrbpFagymqy?=
 =?us-ascii?Q?6TY2b3zNQYqJIuT8/gZ/pz7E2kHyfN+j3NWuJpp1mkVe6j7ZZNcVyjRtRb2i?=
 =?us-ascii?Q?yPVdsoaSRpftuthzdIk2kUciGlpaVFrWsv7j4RvribMtaJO96BkcS6uPL1+W?=
 =?us-ascii?Q?rCs8weJpi9CpbAifL/63PTrItcwkkaizNW6vBYn6XGswGI1+6g2a8RLqNC8P?=
 =?us-ascii?Q?Vh3okw8pwWIXCcms00QXk5c8P0Dnt+lzVmKyKFbgth8DrjhQ5gMZbVVw6W4z?=
 =?us-ascii?Q?3beGDMELH8PWwSgqDFVyB3OcebEukGgF28FHS86386xlLHgwLW5elO9V0pXG?=
 =?us-ascii?Q?lseOKOtAvOnJDtncU5EAcuwWxKfSWXp+THj6vlUNrrhntTK2sDn7E7aXWKxx?=
 =?us-ascii?Q?lvfhVmCK9CSNuXlFI5/c1m3o53Sg4Y1rB6qZtkLrF1/18HSYIZ/P+CLJbJzg?=
 =?us-ascii?Q?KjWOhw01f9Qx5helqTzTqYiMKPCITy1kqnxvwquIcom3SEmRE1T1sIFVbfWA?=
 =?us-ascii?Q?MH6DYH1N3wvuBdDjEFFcAKqt72QUgXy/K3kQZ/t/qkZwcvekaYe24YFPg1sC?=
 =?us-ascii?Q?nBvYb3txhW/whXaw2PiRQ5Qs8JdA4Cx85rFzqrKhwrJAgDUPnLa2CCt2+Fme?=
 =?us-ascii?Q?LqwZRfQ9xqyE0EmRi2qdoSyOVUTgaq442QXEtcxDt1ZVtpGtUiOQ2URBePSc?=
 =?us-ascii?Q?MGnolr42+osnz+vqTgoE3AWKZH63XKJVurdo7MiJTmk2sngj6DPsQcIgfi0E?=
 =?us-ascii?Q?/rsqT4YU3c3i4+WjRPSVEu4LuT8D8eVvMN6VzxSHm/mNKs5wBHlveEu7IMYg?=
 =?us-ascii?Q?MtJlGXbRYKAV5zDL3SDHUTvWhtj/VyWGuIJtUmC3LoCaRQlllMa7QXQ20GAn?=
 =?us-ascii?Q?1TJfOezNWT6wBaoZI/twuV/+ZqUhkNkbTvGzKwolWvYf3oC04GHqph2MM44p?=
 =?us-ascii?Q?qBb07ELi9Q9+ejJcIKdcr9Z27axYghSOZUIP67nz9q+JIRIAYkAR9SGedoK2?=
 =?us-ascii?Q?SXtjOGXfCOBJdPpHTy+J59rY0zGdLJittpp/nZfYnnwpNVo8BJmOnI1+tcTP?=
 =?us-ascii?Q?Ud0LfA3u3qXrYTdiNDicjuXONfymsfbrd5hG6beP6ARtBYwiaOkewrmJBgVE?=
 =?us-ascii?Q?6sE1BufUiBb74MDTKXlZZaegu0wkW3ZF2oL9GgIdY+KjbE95/5/+ZJUUfeGM?=
 =?us-ascii?Q?Eq01UDLNTeT1+5ZjmHM7/5H8egqh3qHU7z0c1RNtCfhGWNBrt32t3WoVn4lG?=
 =?us-ascii?Q?Vj4AlgZOSu41hhaGIq3jYZCHs6bhNgcVXLfP?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:33:33.2778
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f91cd624-869d-4aa7-796b-08ddbe9961a0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE38.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4146

When doing pointer arithmetic in apic_test_vector() and
kvm_lapic_{set|clear}_vector(), remove the unnecessary
parentheses surrounding the 'bitmap' parameter.

No functional change intended.

Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - Applied Boris's Reviewed-by.
 - Commit shortlog update.

 arch/x86/kvm/lapic.c | 2 +-
 arch/x86/kvm/lapic.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 013e8681247f..533daf6dd1b1 100644
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


