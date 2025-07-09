Return-Path: <kvm+bounces-51847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E538AFDE3F
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:37:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51EA41C259BA
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84A86205E26;
	Wed,  9 Jul 2025 03:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1GWPhiVO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBE51FBCB1;
	Wed,  9 Jul 2025 03:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032231; cv=fail; b=tRg3t30QUFXjp5LvbIJ5O2BWkdlZkZgyOTp9RSTz+KJFqQA4idFmR5xDTeRmtSl2eIIwA1js99449PLZt59KXTRwZ0ZY2G3xu18Nhn4SM/p3ncpjaNac6rpw0IxkZOMf/FT2TSv0JoMkuS135FjxbRT/HjC87Zbd6+YRWYOZVYI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032231; c=relaxed/simple;
	bh=4aD2enaeIJJEgY5abImzuRWN0Ti0AolXKFmH09GXcDw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E9yaPUiTKi8b2hic11Q5S0/5JLX4nyDUDIcwLTJ7qULEyHbK1oAmsp6sm5d6sjo9T3/H4at1CzjZTaGhcZ1Vny7qd3FQnin5SGJOIKHi9KF1613MF5a6bI6twcggA8JAIFPHNdgj9nCX0gBFtRgVpHuRcSgBHVv8kiopANqKshs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1GWPhiVO; arc=fail smtp.client-ip=40.107.220.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ErgiNm6ZrMKO0wD2ND1my1+VyLYzXO6AC9JqWwYbddHaweSBOCKzyNwWRDuidXvYlsIztoJvZSXaIbNQ1hEPpIZUXePZ0VfCPjo3P8aO4McYV//PziWcBNkyT/+sLaoCpr2g7AGZaJWWHtpOdNlAPeXVQG5LdxJDNHCEBKoPRviFPoQh4P25AskwBhs3cQnsIHYcSPHzUsWQ4nipI2bjiP8YKPFo6uW9Hi3CwjvSIZzLb7ntkpFK89ynLNpP7IWlHdNOJEpgDIAsjtvlqnvjhJZ+ICQzlhqpWpI14jrx0TZPLtxWEHfu5ofUGeBbAoUPPH5ABB+p+K9n6ZLczXGO4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s6LyWQVXv6Awul8BYJUB1A8aueGA4Bga8rbD4gWwxiU=;
 b=xcEwN5FVV4EgPrYtxe7NNC7F+C+osnvaDD2lNcLtkteWcMDEiQtKd8DHj7tjtMoridEyvQWCdLvRVOJJMNkeFiYSGKHBSCvgFRQzU6jcHk7SmOhwlw0q33MNzJPVNdj5ZOozAK13IHW9Wg661scktHVriOxzXS2oRK5ZwyJSCI9mFCgtBerrQp3L/2MAVFi2fAVV70mkgjJZ0vrZHsqXrLAB+wudaJps7vwR19O7XXIu/ZsTWNk/k7janqj4DISJwWMWYx9HkDYv3x1HUavM4NNFm9SUQHzZviH6bizL1aa4SLk4dfp4hd7H5Xi4eUbg0tBrps0OadWqzlL+zhk+Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6LyWQVXv6Awul8BYJUB1A8aueGA4Bga8rbD4gWwxiU=;
 b=1GWPhiVOXBRk4kBAKC2zdS4SAfQpQl4YcmNd5KERVCqBMe8fYkdDzI8wLIs5rRBJlI28CRo/RfokQ3xggUs789IxkCIl3leLTKpowzCEgbucaxfziAwDc9rBC03gehVUmfl0ML5GT1RA9Rz1MIzUigcT2D7PXFNwL8uQ+MnIalw=
Received: from CY5PR16CA0013.namprd16.prod.outlook.com (2603:10b6:930:10::32)
 by SA1PR12MB6799.namprd12.prod.outlook.com (2603:10b6:806:25b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Wed, 9 Jul
 2025 03:37:06 +0000
Received: from CY4PEPF0000EE3C.namprd03.prod.outlook.com
 (2603:10b6:930:10:cafe::8a) by CY5PR16CA0013.outlook.office365.com
 (2603:10b6:930:10::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:37:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3C.mail.protection.outlook.com (10.167.242.13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Wed, 9 Jul 2025 03:37:01 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:36:55 -0500
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
Subject: [RFC PATCH v8 13/35] x86/apic: KVM: Move apic_test)vector() to common code
Date: Wed, 9 Jul 2025 09:02:20 +0530
Message-ID: <20250709033242.267892-14-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3C:EE_|SA1PR12MB6799:EE_
X-MS-Office365-Filtering-Correlation-Id: c011e76e-ddd5-4421-ea64-08ddbe99dda8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mMkEeVzbDBkTK5e0Y1H440eKZ7/dkNPy3K6EKfOE/sBGjBvLgkCw/ffw0nfl?=
 =?us-ascii?Q?S0QziRdHmBj0M4CB6hgIhtwa9iHnNHhJ9RsLJAT22MDIjROaRxJmxE4F4dwZ?=
 =?us-ascii?Q?0dUZGHysUDdZip1UF6+UENfEob4sKkUnr47Mbb7CIgEKjeiy6TC6kTc9Yq16?=
 =?us-ascii?Q?UhJeuX/PZANS0E2mxWqsYQykwoeNKmINupaQWwQARLZ8R4myVqh/5nZihV1o?=
 =?us-ascii?Q?h0deLW3GX8mVKNr58BncnF0vAU80yB0kLbXgp/tmizf5e+NcCcFQpfvz4O62?=
 =?us-ascii?Q?HPwwTZNphJu5Sj2pYFR38TfXpSDhP/brCnN4Y0itdHooi0WXq2FloK0pv3zB?=
 =?us-ascii?Q?XhJxrLqC/vZXE5CFEB/0M9lZ9VWv/nf8IqCmYQWL2FDdaCSLu+OcgcA3ZSVC?=
 =?us-ascii?Q?5vPUjA8alKDyIwUnkJEHapckLP+vz8HU0pw6NRag0XCWgkNC2xq8KMoz2cIS?=
 =?us-ascii?Q?dYqdRQpdSUNHyvVwXm9bJBOKcaW9qa41wY3K7Ln0lXgto4+I5WIkwOQKnnnB?=
 =?us-ascii?Q?O4/2oviq4S8f6PF6nUxRJuXGi817Opr306maD5v7qDKex4bRRj4TW0mvl+zb?=
 =?us-ascii?Q?Xb5zHIVwOUuAEfk0n66TfKe2jhV59c7pLsWxD0K9OtLxrcZ5LTNvLcHuH7OJ?=
 =?us-ascii?Q?yDyuyfOkqYQZqmpUSqV1MartGBfv4svWGT583hnnAGL/XYusRF+E08BJmEGI?=
 =?us-ascii?Q?/Be8/8A2MVEgsCX+Oua8l3yIAOFoe2D6IaVqFUpgNmeFe+gHBZZvG1akbzGx?=
 =?us-ascii?Q?fyDnJmA8YGz5YJwtmpC/SjDJVv53fF/KMeiysn7Si0M/je2jYUZumw5/4FBt?=
 =?us-ascii?Q?6ZAqiNfGiUM9738VpRnalKU1L5uohfk+1JKOWVuKfnmcraOtwK2imxWu4xKp?=
 =?us-ascii?Q?A+iQfRAZnor1xq6Z7SIqYgNZbG+6pGr0S39wFNLAWdLOJC5Lw1RXbExmVNKI?=
 =?us-ascii?Q?/ATKa0JRul4oOPJvU4LXx0QbJ4qVy4yZuFqzOD/X5mTs8VBn1OXqPd7+uuGY?=
 =?us-ascii?Q?mTIjiD7IhrEIXdiTBrNgD9q6rGlOuq+EWVKwdxCjNIlv9rw9KnDbk9EUlMVJ?=
 =?us-ascii?Q?fVE3OqVbAT3L65WOstIGWF5jOYkUf46wOjzYYWSFF5eBaNZ9mPSBoVLZGUNU?=
 =?us-ascii?Q?6SF3fO3/Op5sn46JlQQwCafstDbcOa23dubRtTPfkt8k7hEYs+D9nZDGluU4?=
 =?us-ascii?Q?uyFIXOlW6ZvGXRELOzET6lq5wKE1EmO9DfHRfFMAGXDALrCkDsMIOtfm7T7o?=
 =?us-ascii?Q?gj6CzPDA7jfXxnwtK9Il13eE9IaVH9XaMYG9m4csb+QWI0H1OOWcyK7Aj661?=
 =?us-ascii?Q?o6OFVQC3RA4frvJ3OyqGXb+dzNmmWOZXeOyfIxpjNv0UDSiDqb41Ygc5lFOJ?=
 =?us-ascii?Q?71biqOgQK/jJk/lWZsbQ4mLdYAMeoGJq8dKL2GKHm/8eTr/i4FKrM2u18zES?=
 =?us-ascii?Q?cXoGRdij5/Y+GfreAJQJANAfhWIlNgJIr5vA1SFwrLSMM9qnxBf/nYKyIYoz?=
 =?us-ascii?Q?XmRw6snw/WD3ZZk4tBw6Unl9sUKcejQ5RMSI?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:37:01.3707
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c011e76e-ddd5-4421-ea64-08ddbe99dda8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6799

Move apic_test_vector() to apic.h in order to reuse it in the Secure AVIC
guest APIC driver in later patches to test vector state in the APIC
backing page.

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/include/asm/apic.h | 5 +++++
 arch/x86/kvm/lapic.c        | 5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index c6d1c51f71ec..34e9b43d8940 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -557,6 +557,11 @@ static inline void apic_set_vector(int vec, void *bitmap)
 	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
 }
 
+static inline int apic_test_vector(int vec, void *bitmap)
+{
+	return test_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
+}
+
 /*
  * Warm reset vector position:
  */
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c7c609171a40..bcb7bf9c0fb5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -93,11 +93,6 @@ static __always_inline void kvm_lapic_set_reg64(struct kvm_lapic *apic,
 	apic_set_reg64(apic->regs, reg, val);
 }
 
-static inline int apic_test_vector(int vec, void *bitmap)
-{
-	return test_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
-}
-
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-- 
2.34.1


