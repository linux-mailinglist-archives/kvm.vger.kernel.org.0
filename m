Return-Path: <kvm+bounces-51842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C425AFDE35
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:36:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9AF21891F0D
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:36:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26EA32045B6;
	Wed,  9 Jul 2025 03:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="R6rDAOBz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703FA20127D;
	Wed,  9 Jul 2025 03:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032134; cv=fail; b=H7Gc+BXh4O832BcWppbjVYQakaAHGHRE1H+Xm0Uot2kaS6coP7/8ZhOS4k3HXyNgY40dZ6I5ZRiXo2FaCLlGW8NEM0LAn0L1WUA+33y31fk1PEB7iobSP/6Fjv2J2IfSz0///Y5QFncIM7SsbYrMbvmIILx9W0a4wT2Qq3kd02I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032134; c=relaxed/simple;
	bh=/6TqBMzwPeauEO3yqgBMloh5+Ue1n2nhBvHBSgx7+YM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f61elOW7/NOT2p4iiEWntJDKiXHN71TtiqQ0ho0kACnSeomw7jA2K2W1X6KYzHfkiMo5jNhNpvNCzReqcICwdvr037Ok2gFgCfZnkOWEnWFHOwmtUQdrGP0qETGMNAqRHrdGoBgbF6TMCkRtHrqCJFKYTQ/W7gUOT0mixQqv0o0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=R6rDAOBz; arc=fail smtp.client-ip=40.107.244.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B/x6KCPGogXEqQIBknFXfUoqQHSEIYzT7URFSR5eHcuVCtMaekWQ2mM91vNwPVUYcDOaeB9UbgII0TtZJ1INu2jHZmmPTKZO/X16y0SbLF27RUMDLNXXU+hQUF8aFIVLztA3eLgsdgh8g2KrP5qDI79j/+1mAjOQtrGZL/zbPgk9mVvDBk9ZH3W+CN3vTC+KqORaADI/W3uBV2vGjN8wu+J1a7F8Sj+ZYB1IdZ+QVAI16wqmQjy2spcBED/1zrk8a3/5QS34U585HBmHslGHTlqc8CcV4XDXuugKGFmX0HXVB47R3rsWzV6+hjwyjWF4xwxAR/TEIkljoynbImEudg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sPIdg+vV0yswG9LpHfH0xvdB7xe7oeqcssLhBe9DoUg=;
 b=wOv0pEiUuHBO3YulA27U7UvPGSmv9MgPHIhJwcnWR/6n0/0KJYLsuAC9Iyu0Wti1CJkBCgWYOATINemA4kB3FfZEo1sgMzM6gyLhZo8POUAzMrVltwUcmb7E4Br9ARwqlfBNm2dHas5tjdifi786qdigi5sAO+ffaRFZXN6zeVITHYm67loKZ9bwnTDVPEFQ8nbO8VOdO3kz+mvqGia5nDMmh2PZr10WXAleD93i/vYli2rcU+c5ouJecnIJTbbIKjNEkAYS6zyhByzYtr3D7jVxHBh7NiO9IzGwWXZWzr8CC0qd9L2imQLjau83IttbaKShoDoJ8i7924pwU+Ixew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sPIdg+vV0yswG9LpHfH0xvdB7xe7oeqcssLhBe9DoUg=;
 b=R6rDAOBzDb9OidiBou00pEY6vjLH3Vigo5mctODzQgvqMYv8RmBrf0+CshUu4mQNFcFOGUyK+ybS8KwR7sstsi7mSBiXnaYLRhKE9GOqDlrczOxYgiEvDtU6AOkAayS17nUMoO4Y/M6QSPysbqJiQCfrQmFO4PCucBSIJPYcFOY=
Received: from DS2PEPF00004560.namprd21.prod.outlook.com
 (2603:10b6:f:fc00::50e) by IA1PR12MB8496.namprd12.prod.outlook.com
 (2603:10b6:208:446::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Wed, 9 Jul
 2025 03:35:29 +0000
Received: from CY4PEPF0000EE3D.namprd03.prod.outlook.com
 (2603:10b6:92f::1004:0:11) by DS2PEPF00004560.outlook.office365.com
 (2603:10b6:f:fc00::50e) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.7 via Frontend Transport; Wed, 9
 Jul 2025 03:35:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3D.mail.protection.outlook.com (10.167.242.15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Wed, 9 Jul 2025 03:35:28 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:35:22 -0500
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
Subject: [RFC PATCH v8 08/35] KVM: x86: Rename lapic get/set_reg64() helpers
Date: Wed, 9 Jul 2025 09:02:15 +0530
Message-ID: <20250709033242.267892-9-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3D:EE_|IA1PR12MB8496:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e446042-f7bd-4c5c-5e03-08ddbe99a66f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Y9UTx6YDzR7cfCDVObDAt6toiQsOkAJnxZgcP45rZkFfzfDesGtJH+VPFYtN?=
 =?us-ascii?Q?xXP/RcA3qac8qv+hz2NMkrZXLbqcrOM4BvuC5wVmdx/pqbrDFSuuq9XsJxA3?=
 =?us-ascii?Q?OMtE7Ogl3O4RF4+Uf1q/iF1VVWz5cK842Ws26EbgA+wEfKrdaPK1OkTgmE7x?=
 =?us-ascii?Q?QNMU1Qn+TdJ9U6bRjPrNE15EDupHNtGUoVz5SIVUoWcQXmdxQAfs0v1LV9Fw?=
 =?us-ascii?Q?hrwosMJLKazt/M0DyaPaEFrVLM8ydBIG7YKffvtbUX8H0zgTEOlsw2sKvJYl?=
 =?us-ascii?Q?/7w7U9rIT9/QS20HKuI8Seh8IcSkZpWjxbBAsEG/7SjPEzJ0LLkpNOFyHk4M?=
 =?us-ascii?Q?T82HXOY+2ZyoVdyz4E3hVjlU7KIJtjh1SYvdBLD0WfaJUPDJajNy1TAEgwYr?=
 =?us-ascii?Q?6ebHLxzAHSTo1rq7KM3pkn20+sKqJ+a/e+IGwjonB6C4JaP/C/fLzkdM22Bg?=
 =?us-ascii?Q?VGhoPVyIZdF4XDxhNE1osEmMwp3xjrXXdVJBWZKu1/MjKY/Jfyuz4wXsTmFG?=
 =?us-ascii?Q?qTTlmSgf+yHHEF63AeIFrXK/2nGd9TzNIJAvGzgN7cZZlB55waLZHW7VCZm7?=
 =?us-ascii?Q?SgRNnOvr2R35ljhQtHIUDTpWHVHFGv5OwSpcYRSUtYD70+ex/zOgTyagjfzK?=
 =?us-ascii?Q?ag4c1M4CkaB873v+uXjS5DNRj05llmY+GtiysNr6HBQyJGPFPGaEcFoeZoJT?=
 =?us-ascii?Q?zyD2mMTk76cLg28XbdgoAIxU/pcH5nouyQUqBT6bnDr4Bl+m2ja0bs9vgj/u?=
 =?us-ascii?Q?Bc0NOvrPcwepxYIEw5zEPdAObJghMnxbLl2K4ZlbTCyv75cLAe2A3BE4ppRi?=
 =?us-ascii?Q?9P+i3yQKwf2l2NeJ1hQv25wRnVj6M9IuDHPzeRYJpV30y9ZqWpJrcCW6OjvB?=
 =?us-ascii?Q?Mi7jwPV1y/581olPrCG5dQM2KqD0AfhVSZxx0XjC9jNNJmio75syGZztdAAf?=
 =?us-ascii?Q?kpqOBSG8Fzygg4PCb931ehS1VZy1HhpOcbF4JPGSZccOKlzmlxM8bvT+kIKs?=
 =?us-ascii?Q?OdcyeNJear/kB6klB8rpGXsSoNEv26k9srKKVcml/HhPKbrlzFgrgh7GSZeb?=
 =?us-ascii?Q?lutsJ9sDDsOQLnuvnUUqAgrxeAHrXSqdLq6+BtNS5eW1XPXtVrM69DFy12Z7?=
 =?us-ascii?Q?5ukiAxiOnqYwsIWFh53UiYmFvm52jX2pejNachnFAvizgAtkcPIMk4zVU91d?=
 =?us-ascii?Q?fzD9dbAhGpUU5oO1dyeb0U9BtfPRRlQ/Mpwf+4B8WkiSxS9klPZNYCX1Tnqt?=
 =?us-ascii?Q?GUwaQWpGBfsbcll5nBQdNwx8+TjP4LGzNur1f74nYNzr6os0kNSV34gGeu06?=
 =?us-ascii?Q?i5YChWQcfzivFzOYh9UFfLY7WKwNVe6LZ5P95hwalsdEzPjs+Fk15awwkxrv?=
 =?us-ascii?Q?0AUfSHQCQRJ1gsdbu7IRGJ2Asy95DttGelbHrP62NaoFl4skSZsYwxRq336B?=
 =?us-ascii?Q?izVdSkR3mkG39tK2tPrJDzRLwCosPGIVorM0g85UjB0GepCu+9og1lK5zOry?=
 =?us-ascii?Q?U1ZvWKinS31svBqE2FjdjqcVq8e76IGAYNVX?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:35:28.7172
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e446042-f7bd-4c5c-5e03-08ddbe99a66f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8496

In preparation for moving kvm-internal __kvm_lapic_set_reg64(),
__kvm_lapic_get_reg64() to apic.h for use in Secure AVIC APIC driver,
rename them as part of the APIC API.

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - Commit log update.

 arch/x86/kvm/lapic.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index da48e5bb1818..06d33919c47d 100644
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


