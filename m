Return-Path: <kvm+bounces-46447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF78BAB6447
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:27:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 307841B62B60
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B4B720C465;
	Wed, 14 May 2025 07:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ja37ePfo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F4C1EB189;
	Wed, 14 May 2025 07:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207555; cv=fail; b=fEi167TW3TJydhJUBZJ0VPHO6Y5xBDbea1yReu4sUO9+gS9x3AKYkRA5uorlGVOlC6VYGYAQFfFYYAnUzbmfGqFdB3pPiNAj5TZ9Pb/k+nNe3SGNU0EaNbmkthqCGhllCBdk5uwVJV35UP4uF8ZvALUKuDO0b6EBWOJ2ualgYDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207555; c=relaxed/simple;
	bh=xJXO5Iw9dB7MUkMFBHW17x3ettNMKLQFBYTc8QacsNY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zh/F0Pwa83ZFe34Oghnh0jeDs0uZHqZ1ZgkAN0Y5emETUmpW39rQElLNE21Gb9WXKyWyTqlEcRyIQwvpoI55DnWFguZVWeqOYJlWu+hTXYYodfjYbTFfhxuPR2pbBksi+0LatAwXgY+szxV8okUm8mUqmcO0sIvc2m1Ol3wv8nE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ja37ePfo; arc=fail smtp.client-ip=40.107.94.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RAtdhlIVUnX1XopUEO3Wd3iXmLdNxrMIY32gE6fpCiGF5WGof3HiQXlBL/yrDh8sXOhlbZGL0wH7V4tsNap0oaydYVVEJDsHlXQapmf2IHbzUP51Qz9bst5GLnmGM1KIHAZG3UbA57X9mI5un7QmxzJi/qcD9FtLJrmJbN4DpL0JY/PeI15XX0igy1AHcUP9XqBFkZCBkdOvKlYWqVX0k0qmSiAgMBuhxnnhBpZE95p4M+Hps4heqOOWVtzG0SGnY0UUnpp6fOLjbmC1CJ18BnN/Ob3HlD0lir2KryUZORLbR3ZixKuegtCAHCJ65LIbX1SkKBcylxxyNk8s2j6H/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b1iHTfv9yMvNy2qO6EYwyRbCzn19vNmbKffToOBhqFI=;
 b=TuC31B7/1HLlhHP14lKjDUSBSzs2qgi1te3dgFesfYRv26sWagfEWctZBBWnokzWAMssD5Xb7rC6ulQc2vPMuvjZlGzfjfAa8uR2uAMo9LluLRbmzkzAjNNFLKunywjPuKwIjhSLN54AMuH3g0fdavZDjflo9tHNpEIrNlbyvA+10z9zbZFCA7lN0vAqrs3Tm95530OLeTj152IcZFZHji+bS3fNlS0oUnfn5EXtkb9FmLRJU53zZNQeUGBanAmap9rdmYbrMJJZ333gMhf6lRrqIYz0ZEtHCauuk7JkxcLyj8l3ErXpXwG7Yb0fpUfiO4WD1uO1l3N0O+YBxiEYtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1iHTfv9yMvNy2qO6EYwyRbCzn19vNmbKffToOBhqFI=;
 b=ja37ePfox8q5xuEXR5Sb2z9vxwHe6WiWH1UGP7ooL9m4i4qvnTZ0QInC9PYSZEqB2YMovHeEV4EeEqa8inutRH2qrzpe4pMN+Yf9iOHLF8vQC7OdeUXyWjmDxT/NdH9nNm2L6UNpKFSO1ai/Fcu0w6iJhofnkbwaxfzrA3VMS40=
Received: from BN1PR13CA0017.namprd13.prod.outlook.com (2603:10b6:408:e2::22)
 by PH7PR12MB6786.namprd12.prod.outlook.com (2603:10b6:510:1ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 07:25:48 +0000
Received: from BN3PEPF0000B077.namprd04.prod.outlook.com
 (2603:10b6:408:e2:cafe::ff) by BN1PR13CA0017.outlook.office365.com
 (2603:10b6:408:e2::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.19 via Frontend Transport; Wed,
 14 May 2025 07:25:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B077.mail.protection.outlook.com (10.167.243.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:25:48 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:25:38 -0500
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
Subject: [RFC PATCH v6 18/32] x86/apic: Initialize APIC ID for Secure AVIC
Date: Wed, 14 May 2025 12:47:49 +0530
Message-ID: <20250514071803.209166-19-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B077:EE_|PH7PR12MB6786:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bd9e8a7-44b5-4bf6-6ec3-08dd92b88c4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aacqt6K8Cs208FJhZzGRFKHv5i+unSDjh7JQHfF/LSxHmdidtJhQLZEXcwJ2?=
 =?us-ascii?Q?jyUjKsI/uiMcAYJZwG3dACP2/lDislJPbnw7xK7/PvzhHzuy3jb5qBz3If1i?=
 =?us-ascii?Q?Ud9fBDcqH/TLjq+Zm46KOEYp34MPq5rGZVhVlra5CTl0ItDmW+vQGbq6npCI?=
 =?us-ascii?Q?jHgyn2o2hV9NG2uNuDkBseNt6czg1jTxUqO5XDEahjgp/efiskdY+6Im+cka?=
 =?us-ascii?Q?P08lus9PhEABaZN8xgNmLSxq91jfpvXJXyEcVJITIqBHT6miQbz+iE1yV+ZO?=
 =?us-ascii?Q?6hhzK9GVFx/rsKkC/kCvmyQDx+7OewefqOgxOvettChlB5qNOb0FAza2DozH?=
 =?us-ascii?Q?4zIEuumE9K8QELJUe/y5XI/kX3jbZmEPudwlyv6v6/VrGEwN1nFpPibN6WdB?=
 =?us-ascii?Q?WM339UoI6t4qVbvrJt3SMHbB6iukQN0upbjK+73rtBVPuuly0SEJWQLZGyBJ?=
 =?us-ascii?Q?+UP33tb2AHeeve0FCY1czGPy3713ERiZryOmypZQff9ih3njZJWrOo9wwAPV?=
 =?us-ascii?Q?HaYaKdsLH0FsPb/M4vdVYWghyslvagop3jDeq6CHWsnYqmtEZeUDbzRWR538?=
 =?us-ascii?Q?xgPvjzdgrzEfDNuo1yxdL0mnyoulTTpJ7kx+SIxdgyTFwo6oYToClHr/SGCU?=
 =?us-ascii?Q?eV0DZzGZs+5YgiQkKfnsd/RkZXd8ZNBWKO04i0otoiwQLMdnGUhC3/dhaUBL?=
 =?us-ascii?Q?Epdqu2bE0p7vaFitkIHADvAwpTUrWgkdvozvVXHW2SLI1dKveF9z7YIv4vfd?=
 =?us-ascii?Q?zHW8casTJd/OLoCkRZDH2Fgi3zdT1sgxzgV37F0jt6xGzLbz0j9VzZaH1jWI?=
 =?us-ascii?Q?vUF0jaOkOtwJj0h0QTlJqCoo8hh52b0oQRhKbK4cjU0Zi6CDRWh8aSrqHHZP?=
 =?us-ascii?Q?b5CnWnZGxcROJwIMv5oqzO1IDN0M+ldKmwxVMZDRLDQ/GlZmZEI9CAkpBXKn?=
 =?us-ascii?Q?txOo6Q43aYg74HvSTtcWgSwN7JEOpn8xy5/9mbM1h2O6wNBxiSextMINK5st?=
 =?us-ascii?Q?WYQ6fK3XvKCfazBQC3VHzj7Q1uxpoihzCuPNfxz9Am0X6gczt4H3koUT46vI?=
 =?us-ascii?Q?q9eXnyiHGgHxZYSsWkdnS9YQX9voyyGFzEqr/77g6tMyLa6hNJK1h7gEpoYt?=
 =?us-ascii?Q?s9Ekuu5KtM26PwSeZPoAnYcdKW3icVRqv5WhgR+toE/VqSYpc4zwfJxJP/SJ?=
 =?us-ascii?Q?CIRgXQLgOAgqhUI91nspcBzJUbuEK+jg+Y6vR/KN3t/IGYM6WVcV++elHv6v?=
 =?us-ascii?Q?VvmJlPgVClfs1f1IFcPa97tNh0wb+s04Xq/XxHZUoQmZSY7ZdfA39nhb2egO?=
 =?us-ascii?Q?K5nDdJ45ZrZ8OFoSAnytucmOLeW799IdO2NEOJAMMSqO7s7mMv9qBwafoIoT?=
 =?us-ascii?Q?Vy9i88VIt//J7N0XlWDC56o/VWRu6A8Yl3MQq9wEKj21c5FOC2yJVFowD4L+?=
 =?us-ascii?Q?Dnmv/UP29M5Ywad7FFNk+dpyOPnlyloHrfx3vwPCF6jd4wfbtDSz7EIgBFDX?=
 =?us-ascii?Q?vzf9kp2BTOnuZr8wUsWxjP4rhUUZGlOHKiJz?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:25:48.1499
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bd9e8a7-44b5-4bf6-6ec3-08dd92b88c4c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B077.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6786

Initialize the APIC ID in the Secure AVIC APIC backing page with
the APIC_ID msr value read from Hypervisor. CPU topology evaluation
later during boot would catch and report any duplicate APIC ID for
two CPUs.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - Use common apic_set_reg().

 arch/x86/kernel/apic/x2apic_savic.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 186e69a5e169..618643e7242f 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -131,6 +131,18 @@ static void savic_write(u32 reg, u32 data)
 	}
 }
 
+static void init_apic_page(struct apic_page *ap)
+{
+	u32 apic_id;
+
+	/*
+	 * Before Secure AVIC is enabled, APIC msr reads are intercepted.
+	 * APIC_ID msr read returns the value from the Hypervisor.
+	 */
+	apic_id = native_apic_msr_read(APIC_ID);
+	apic_set_reg(ap, APIC_ID, apic_id);
+}
+
 static void savic_setup(void)
 {
 	void *backing_page;
@@ -138,6 +150,7 @@ static void savic_setup(void)
 	unsigned long gpa;
 
 	backing_page = this_cpu_ptr(apic_page);
+	init_apic_page(backing_page);
 	gpa = __pa(backing_page);
 
 	/*
-- 
2.34.1


