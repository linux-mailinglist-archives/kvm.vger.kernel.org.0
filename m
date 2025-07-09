Return-Path: <kvm+bounces-51843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03CF4AFDE38
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:36:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA92F1C218BB
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E90CB215F53;
	Wed,  9 Jul 2025 03:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jOjBfoFx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2056.outbound.protection.outlook.com [40.107.102.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF755200127;
	Wed,  9 Jul 2025 03:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032153; cv=fail; b=SfOQsDTFF/G7FZCByfVO9Ytkk/h49eMomoFYTyTC7sTtG5FKoswNo+3NLG3Fe7xHgXSZnMobDDtNdlTxJ8F1yToqc6qQPzqc24pmtabH8iEDAcDwk3HLWeZhdemm5oBpjaI8DhPvIp0OHkalSAcPmaEl+0bGwq7TPIS/EhO0/Lo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032153; c=relaxed/simple;
	bh=QfIAaTkDpPliWRLkA/iNVSh9WNiR8AEy/WUdx4/Aia8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iIQGmqMgHXVvKSUa/YGGY783vnyegVsb7Dmj1xrQYhyyaAZAWmMhhtjALsT2JCgf2oqFjJSYEa3qtNa1nm/1njCC61XXUiB83jUOfpwt0cPrdvsD/vN1hAnKgDVDIKA2hMMTlh4U5s40T6nkji0SaRsoGSTjUfZCvQOlYTZBIVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jOjBfoFx; arc=fail smtp.client-ip=40.107.102.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O8STnK9FiOdfL1jV+f9orrXfchtJkONgrZP6NvlBKk/gV0R5AbCYFlR77bQbTwIQpVP3vSmhrzoln64dFa2VsTTt3xWj5jd9yF7pRARQnSbTnjQTfRSp3EJzeuu1hZrlYBJ/tsWBifHbeGckZX8pkzXLXQRHllX1L1xS85SH0pDrQcSEI+merm+SuWLZYXlsu6oPZjUNhLI0AcV8fJUt/N5Fx3mC3pQp2Tzc0fDrj2seGziJNngB9Li2Rf5Brjv4YxXrOOuJ2mZYX5mXSKuywe5pN5nf6XiTvq9yxm2KwS4FfvMOXrPnefGRUCm24kDYLRPKZ3HkzDYlLyNh9tbWgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w9rkr/4BA5Fg2U1K342dQy01ORzClP5nu0O6F0SVAeo=;
 b=KoOQLRNFPftzySpeQYtxZDj00ZEAXnt77tHj+F9cWnJnp+7gQfS8NP12ETfMHfrX+UA/C3kWf+JGAfxpuMahZzKMlv9/Mogd6zUZZTPWsxY3c70Yx2wpwXwcVNWeP8jFPHfiu4VsnjA/d7qZ7gkWc+NYL+GcC4Lh4A+l2DVujdcu5aV1ep5ncr5KAssOK0iyKyv56Mtl592znqeaVpin3TSGRy+ruN0kBckOdR7kc+YAj3IVIayVXOK/BK7xSltWTL0ijJV7d5Zn7yARtKkasEuBnmkIX3LI0ktWUIYze5VHfsnFP3Felv2AG96SfGcj6EpTSPtSBLx9LeM2WrSzgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w9rkr/4BA5Fg2U1K342dQy01ORzClP5nu0O6F0SVAeo=;
 b=jOjBfoFx5KuBfllfsU/tc7S2QjHzXFRV/7EG2pUu0KQ+147IQBAtycBoZdoJ3Vx1MXUvAYXh2tXNmsRHb8sHimNW4MRm6oWQMtB8OrAPc44IGT95mjWbvgax3u+liOawJBHTi/lWukPmOA3amnn3SXfbtJoKSDX1rmKvZiEhcb8=
Received: from DS2PEPF00004566.namprd21.prod.outlook.com
 (2603:10b6:f:fc00::508) by CYXPR12MB9280.namprd12.prod.outlook.com
 (2603:10b6:930:e4::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Wed, 9 Jul
 2025 03:35:47 +0000
Received: from CY4PEPF0000EE3D.namprd03.prod.outlook.com
 (2603:10b6:92f::1004:0:11) by DS2PEPF00004566.outlook.office365.com
 (2603:10b6:f:fc00::508) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.5 via Frontend Transport; Wed, 9
 Jul 2025 03:35:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3D.mail.protection.outlook.com (10.167.242.15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Wed, 9 Jul 2025 03:35:47 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:35:41 -0500
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
Subject: [RFC PATCH v8 09/35] KVM: x86: Rename lapic set/clear vector helpers
Date: Wed, 9 Jul 2025 09:02:16 +0530
Message-ID: <20250709033242.267892-10-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3D:EE_|CYXPR12MB9280:EE_
X-MS-Office365-Filtering-Correlation-Id: 1877a9d4-cd6e-40dc-0174-08ddbe99b175
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uQEvCIrfx2f2k7RGasUu02O7fB8GUAaWtl7LRQitCQEALEUKPBybRtzpRhqY?=
 =?us-ascii?Q?6rDw3MwRgvluMnea3pl8BSTTXmUAHLLtPzt+N4Mz7/Fw1sTDSInNAw39AhXO?=
 =?us-ascii?Q?DpDeGrdhXUCgzCAxk1kQHapmm176ppoEeEUIo5s03QoY+yx37EhIJpgfrr7e?=
 =?us-ascii?Q?YppcT7Unq+C9q/WFKjhiq0dqBgSFgun35qvfE6kn5HBFe583e8q5Je0A/kVY?=
 =?us-ascii?Q?dYB7WMuVlCcLckee/ZrWcHSS5CAYOU1D2dkKnvvraDgOOZkUiL9vMIDwKmOQ?=
 =?us-ascii?Q?sDQCxiu2p+0EgkqBu9aFGC1yR4M/w/f8JgP3h2jmsNw6N2UF7DUyYe1G2fNM?=
 =?us-ascii?Q?vlnOq+RJ+88DjxpFpRcQYKgOjLFDN7w7iJEnIzWeQjrD3xjqNNIcKEo5UqXs?=
 =?us-ascii?Q?gv8JyRdsDC4KFM7NAzyU1CU42gVkKSOMMOwWYeY0rLmtUwkRe5v1T+0KiIPP?=
 =?us-ascii?Q?i6o1AJCbNEVdOWoRqxTwETiR/vUjIEAhrz/QNO22qsY95slmfYaaajiKVdr7?=
 =?us-ascii?Q?KvCGFzyImdXccQyDxMcO/mE9SRlyce0kZcE957UPY3IaKbT+U3pOnl1V45Am?=
 =?us-ascii?Q?inmvCl/xied+h0qxDGx/kAS/E2a8FFodNf6vSICz4ftzCg3TY9/EZJ5uMqLq?=
 =?us-ascii?Q?9v+hchl1g2Bk+SN/Q2m7FaSs4z+MwhuT89U9kYr1ZCzor9J4Jfp9cmJKAVT8?=
 =?us-ascii?Q?My00blgH5M2jyN1Pn1xlrtbDG928umke0WZap+/yU9Y9Ktb694CawMZc6j7O?=
 =?us-ascii?Q?KWdducCAeZh5qBeYYsDToTQjdvOsGNtgYuV8IYrpub9uj5F9wpDLySYW5dhm?=
 =?us-ascii?Q?yMe8DoBjLBV6KbPd0Nj0cxOPXEeB7uNHlKpOAbqUMx/d8Crwz6fj7O7y6mGJ?=
 =?us-ascii?Q?+khjtcXs9ZCRmHu26Gyw1+ik1L7ZvhLg6dRBOEAs+UXpg+uUAjlK4beUlhHX?=
 =?us-ascii?Q?IzWktg61jqjzcIvoAlAcLXkYGCJZlIsIPdlt27nEK1FCqbLcr9damE0KK2H3?=
 =?us-ascii?Q?qKuPvva/A1mMZ9fMNgapiftiFg8YsnuXnRojsp5LDhIXIWjRe6g5PYisd6vU?=
 =?us-ascii?Q?nsIMpzHWPSONuIMct2/GxNMkBaTWMBPZzc3lh3HO4cA3qp3HSBVLrmYxwNT6?=
 =?us-ascii?Q?NYaUj4zS3wDC+QlvVAhQAGFH3BCgbuWzzTyxCU3HlWcLQFqNykau16j1qHxS?=
 =?us-ascii?Q?70bnYfbmB7bngjIdOCX+6YY4lDJQmcNlbudWemhaP34hYSfAYwHX0uo7bbrQ?=
 =?us-ascii?Q?KB1IhGRDr67l4omiT8g/9chSf72lVGXcUahBU2KoBf89drReEoscuVb5YvdQ?=
 =?us-ascii?Q?HnsmsjHVZNM4fvmEXeGzabN/Fkc3PrY45McbThTxQW4gidr5GKFK8cmBNKqt?=
 =?us-ascii?Q?cHghK3tgrmBuRAXEpu5OSSzzwVrdFbsx3+FFi6rkT9dZ0GKSmMFLAbsvPYeT?=
 =?us-ascii?Q?pi+DotzF6A1tftME4mzf+mUOJ84sRhKJ9q+zBFRDMoImw72mGTSD0Mpfu5XL?=
 =?us-ascii?Q?69s3cKg3CYUyKJZbXuhGC+hI+4J4w4ih0ZR5?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:35:47.2111
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1877a9d4-cd6e-40dc-0174-08ddbe99b175
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9280

In preparation for moving kvm-internal kvm_lapic_set_vector(),
kvm_lapic_clear_vector() to apic.h for use in Secure AVIC APIC driver,
rename them as part of the APIC API.

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - Commit log updates.

 arch/x86/kvm/lapic.c | 10 ++++------
 arch/x86/kvm/lapic.h |  6 +++---
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 06d33919c47d..069f3fe58def 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -718,10 +718,10 @@ static inline int apic_find_highest_irr(struct kvm_lapic *apic)
 static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
 {
 	if (unlikely(apic->apicv_active)) {
-		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
+		apic_clear_vector(vec, apic->regs + APIC_IRR);
 	} else {
 		apic->irr_pending = false;
-		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
+		apic_clear_vector(vec, apic->regs + APIC_IRR);
 		if (apic_search_irr(apic) != -1)
 			apic->irr_pending = true;
 	}
@@ -1326,11 +1326,9 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 
 		if (apic_test_vector(vector, apic->regs + APIC_TMR) != !!trig_mode) {
 			if (trig_mode)
-				kvm_lapic_set_vector(vector,
-						     apic->regs + APIC_TMR);
+				apic_set_vector(vector, apic->regs + APIC_TMR);
 			else
-				kvm_lapic_clear_vector(vector,
-						       apic->regs + APIC_TMR);
+				apic_clear_vector(vector, apic->regs + APIC_TMR);
 		}
 
 		kvm_x86_call(deliver_interrupt)(apic, delivery_mode,
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index a49e4c21db35..c7babae8af83 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -145,19 +145,19 @@ void kvm_lapic_exit(void);
 
 u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic);
 
-static inline void kvm_lapic_clear_vector(int vec, void *bitmap)
+static inline void apic_clear_vector(int vec, void *bitmap)
 {
 	clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
 }
 
-static inline void kvm_lapic_set_vector(int vec, void *bitmap)
+static inline void apic_set_vector(int vec, void *bitmap)
 {
 	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
 }
 
 static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
 {
-	kvm_lapic_set_vector(vec, apic->regs + APIC_IRR);
+	apic_set_vector(vec, apic->regs + APIC_IRR);
 	/*
 	 * irr_pending must be true if any interrupt is pending; set it after
 	 * APIC_IRR to avoid race with apic_clear_irr
-- 
2.34.1


