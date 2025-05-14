Return-Path: <kvm+bounces-46435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3078AAB640B
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:22:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3474861370
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:21:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93C3921ADD6;
	Wed, 14 May 2025 07:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Md1r1Ywz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2054.outbound.protection.outlook.com [40.107.102.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39843216E23;
	Wed, 14 May 2025 07:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207276; cv=fail; b=m6n2zC7AUErFo/I0C/S/+Gg0szYXOA+EIFGb3VBhaGi0FCUbrjJ+gRUik1nF0xvUJ7zB2mIDBZFLoy//I73c1YaIW/kYTN5N5hUaDvvGf5LuGxm2qZoKFLuT4ffTR/Ka8ft4vleXqEAZKhAVDM2JfhsPqCeQaoFaNzL/49jNnog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207276; c=relaxed/simple;
	bh=b3+K4ObIgu4HsjGAuty5yH+Fk3MNnUaP0oB0wPQ+VIg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CGcxBlMz6ldBbEkpaevDDUpCNWFtCNWya7yBmBwHZ1ho711U5avLrXvcZvDtDd9jS1KsOVb+JoWuyA6vD2AJUSG1din6llfkUhm+2An6slnjCPYX2EfR3XXENN7i0BKsF/4eMYK68oRY36jmPKxtRRLPZxJW59N/rkWqDwxYzmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Md1r1Ywz; arc=fail smtp.client-ip=40.107.102.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RafAvMIB8QTgCQVA5UdMqbQL9Ac9JQ2Zc7JpMjYgHZ/b9hHTmWQKp3CG7sB3JarUQJrmJ/tKsVfoY5vQkSACyynKZesT2IU75f2tVor7TBF4hDSdxQFsFMRrfS1ojFpRvp3o5g00RE89S3ZOpnMLqAxp4U2ywcBqGnlOQoP+LNUkZY5E8pXwGx1MqpE9hw/hyvuKxHZswJPISAOBoj9oBuK00nZ5Tvcok34DhSaupmy4QuT6/zelzN6OAQ5OT0lIOsKsJPcL5D7LvtcjSpfjdc38CuidxHdckb5BxBoPY66TxyJgB0F3FDou9tH09VpMMV/CMEGGhBAeWr/zy5pXCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4IQnfBKvhsu/aQJOy5wBqMpPaVwAilhm80/Cv0iBuEk=;
 b=oX4FVqug2C4xMWH0unsaQOnj2O/TytQ3y26bd/j8AD0K1o/QImWMaibaSD406oFcVWSo3rkXhFflMMBA/udvasvP1xqy27smdkxq2Xfj61Xy7JXVmwte0o0Efbom6zbCPXExNAuWKI/88DzltmcqhtadZ9mrr6TIsSg8sSjv0Cf3kJawOHqbvEDqJ5ZO25Mx5W3lzhUAvdajIi9y9e51VNcF+m8BlGmiwb24IyUK4XLaR//K5Loqmeh2HTRcpBFXpP/L2LRDyCiBGUw+dwxpS5zJMxY+amv21QjcEY3i0GLZw/Ph5PjgaNub/SezwMkOCXV8nDVrk68ih7KeOd1m4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4IQnfBKvhsu/aQJOy5wBqMpPaVwAilhm80/Cv0iBuEk=;
 b=Md1r1Ywz8Auaq45YJ5dSCpNL6oN4O14zcR0Cr/ibsT86CSVdzKLVRhRjOtl1JL58zJwoRn9/tne7wIgAS8hfQI+8viDGFENwibbXR4zjYPMUu6YeMZc2REYmZq7zLCANFf94oyzN2Z3DENdniP/6j9qi4TD7PJ0Q7U7aUzSxwn0=
Received: from SN4PR0501CA0018.namprd05.prod.outlook.com
 (2603:10b6:803:40::31) by LV8PR12MB9207.namprd12.prod.outlook.com
 (2603:10b6:408:187::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Wed, 14 May
 2025 07:21:06 +0000
Received: from SN1PEPF00036F3F.namprd05.prod.outlook.com
 (2603:10b6:803:40:cafe::e2) by SN4PR0501CA0018.outlook.office365.com
 (2603:10b6:803:40::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.16 via Frontend Transport; Wed,
 14 May 2025 07:21:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3F.mail.protection.outlook.com (10.167.248.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:21:05 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:20:56 -0500
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
Subject: [RFC PATCH v6 07/32] KVM: x86: apic_test_vector() to common code
Date: Wed, 14 May 2025 12:47:38 +0530
Message-ID: <20250514071803.209166-8-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3F:EE_|LV8PR12MB9207:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b7bb677-a530-4ce3-bfc9-08dd92b7e413
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BIrVj4XUiW37wC4ebU4f9C84kxLT/Hn+dbw5UnlYVH3+YCEWE2ap3DP/wlk/?=
 =?us-ascii?Q?sFjD7HkLyxJNLpq4A0uKwTkIpOIMUBj2t6XzETO0RorrtvoYf32mBwOE1gBV?=
 =?us-ascii?Q?gysns1x6GEQYztsDI3ekwUk1Lv17Z8s0A6Cpr21WRbRyQWK1nyk7eepx+BdN?=
 =?us-ascii?Q?3WOLLXZKyzXB+AE3WcIfYrVicfECXQNOy1vqVKjPNU/GPypHcW4f19OazKHO?=
 =?us-ascii?Q?QqESMES9Hq2HJKVdnrDDlKVfAavESD+wn3sM27Oop/Bx0+GuqWmwuaTT2QnX?=
 =?us-ascii?Q?EexSSM0sG8uoGh0Gv81InbDRq7YG9vLKzaF/gmhrfTdCnQbkFhgsXhciJ+0Z?=
 =?us-ascii?Q?0DPdsTQwdrwUsWCxK4+ygEGY3u1K2vVaczwZVksbB4OOvrp46Hj8AaZ35p3E?=
 =?us-ascii?Q?p0jv7iwDy1bWCBcXDEwWW3VPWy4+D6NVG9K9l0ySU9pZL1mwYOsA9kgd3vRq?=
 =?us-ascii?Q?F4zWYuKSbcVdmswS8UQwPY0Jrh8H4DHGxT3hOz0LlbYZH8ZX4gutHozZTdY7?=
 =?us-ascii?Q?iXU2ndXsIXO7jJ3hysycKNESKZeBW27Tz0ABacLCquSANJdXrzaZ5g/RcM2Q?=
 =?us-ascii?Q?84zdVgQTgk9PO9fT52OkmJfwrgh2/2erAQpVAIcM5lUxZQ9ROlBLPpbWpDBX?=
 =?us-ascii?Q?oF7JK3cRB8HL4WbK5t2skLBHBqPzhIV43cRE277IHA0Y5Evd3LIb8IaJUDsD?=
 =?us-ascii?Q?uyWOtSFtw9m2BVC3ciBcBFqRhGIInuEpcRPCVavTy/ZrqzuoU8iMNGepzqju?=
 =?us-ascii?Q?M/kILISpmIMKl5q/tTRwwGidVPRtpyUQv1VaqUYJwb+A8naTuxkR/lRoKKWs?=
 =?us-ascii?Q?nUaKiM+v7OzB7vRNhF5fNNvmsQYaUT3BSYwy4U+VEMUj1W3VDJLNRFCV+1Tg?=
 =?us-ascii?Q?Jx7mRHC9Gz/uu4ic57P3OMnixrOzLxO45BiRBvTacViI+lWKKVuQY6HW7cFI?=
 =?us-ascii?Q?RPAbdSW/Qrn4RzQ6n9DQ1Xz/FKzaXU7L1VEzyo5H7Iy0uH0NKWt6pgvASmQL?=
 =?us-ascii?Q?y/FjiblY5It2saittCt68Nc6JUmWBV5X4EVSxgyh08Yse2bBFR3rpM/91kxu?=
 =?us-ascii?Q?atzpmuEDIyxL6JzvYxz+ezobD7nD9RmTVtcB5gXZzEHdZJXCVfNWssQqHDQZ?=
 =?us-ascii?Q?EeFJhgFZKfdwr9XhckvMPd/0Q0kYYe8q8jfR+w1PCGTw0hL4JzhhvPUYpXgk?=
 =?us-ascii?Q?fGo5pag2sjd3q0MwPIckYQr+rWPPzZRNr2SgK1b0x0JG1bnXdk1807DBzwkJ?=
 =?us-ascii?Q?Xg2Drt28YJNFXCBthBbr2DeSCipMfCOPAJHwexYO+01urQdKEdwxmOLG+LOI?=
 =?us-ascii?Q?Tm4X4NFSjvAUjHuGlucqrI2lSgrSzbPQM3VHG7wlpxuVRy5RuIRy5gLHzPJW?=
 =?us-ascii?Q?YUl5NV0vZ9SYbxnVuZszlSjs0LVCqSKJSuR52SEDzzwILqF8qgcfAU+CRdc5?=
 =?us-ascii?Q?19GihwNfWytXMS8GarW6PFcgC1qdq51WIBWKHWYAO+H2i6DttYW6BCmaQ2QS?=
 =?us-ascii?Q?ST/rkdlltegv9rcK9xMkASwIygMG4rokQsrz?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:21:05.8915
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b7bb677-a530-4ce3-bfc9-08dd92b7e413
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9207

Move apic_test_vector() to apic.h in order to reuse it in the
Secure AVIC guest APIC driver in later patches to test vector
state in the APIC backing page.

No function changes intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - New change.

 arch/x86/include/asm/apic.h | 5 +++++
 arch/x86/kvm/lapic.c        | 5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index ef5b1be5eeab..d7377615d93a 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -557,6 +557,11 @@ static inline void apic_set_vector(int vec, void *bitmap)
 	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), (bitmap) + APIC_VECTOR_TO_REG_OFFSET(vec));
 }
 
+static inline int apic_test_vector(int vec, void *bitmap)
+{
+	return test_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), (bitmap) + APIC_VECTOR_TO_REG_OFFSET(vec));
+}
+
 /*
  * Warm reset vector position:
  */
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 25fd4ad72554..8ecc3e960121 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -96,11 +96,6 @@ static __always_inline void kvm_lapic_set_reg64(struct kvm_lapic *apic,
 	apic_set_reg64(apic->regs, reg, val);
 }
 
-static inline int apic_test_vector(int vec, void *bitmap)
-{
-	return test_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
-}
-
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-- 
2.34.1


