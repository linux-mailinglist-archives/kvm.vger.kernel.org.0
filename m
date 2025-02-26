Return-Path: <kvm+bounces-39247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 401FEA45977
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:08:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B64AB189778B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11440224253;
	Wed, 26 Feb 2025 09:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hdXbcWsB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97A0258CED;
	Wed, 26 Feb 2025 09:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740560842; cv=fail; b=H5UOnf0rKjkcFKr5wqcbWDTCtLSM2W52XikWcd3tAI9TUbMHqBSjaHrb6/Ocg3Ww7UIAE18drHzSJV0LZKFEtH79eat4uF3CkJhZYCl49odlfNakd3H+HZOJBmitzGDv3FlDiebkS68EXXTV0QJWkJIInruY34rczsXWmImhXCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740560842; c=relaxed/simple;
	bh=3YnFrQXCo/INqUXLFcbfnznwCes3L5ySaGwVPv6n3VA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VCuNw0Zc+6QGv2C8ta/QJFK+Lg3kq1SsMHqAdsM1P3mUzp5NOvrOrpJy+ICQRiTPdueIkQ4YZLeQ2rYAfKBvx3x0oyCrtSU7Tat/3cdo5giSN1TNPbFDrFp1UlFacfoxnPV2A6Uf3Z5Ok0AQOf7fg6gllHEtswvCe2dkdTqdcic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hdXbcWsB; arc=fail smtp.client-ip=40.107.243.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FvQLsmDJXROHlPQUzFDSVY4yBDL1amkHzsi/WI1ufltSMfArRMqW+kAQ2PI9pGqUEEt1AP9b94d2tltrRe2kxlVpJ5nm4leN7HEfy6LKk5t73VjopxDHtd/XBJ72gssK9aWo+AVWsjNkV8SqqB9wd6SHpJXsjbx1FgffMqRl6IOeoFT9nB5B0snTOVLouxBXtP63g2SC6+qF2oyMNPFcORoOAkYfDYW2d+WOJf1Jfajb58MOj9vTrj+FhvDPg2q2iiPNx0HwLZG58//WqZWLyzW6QYOA+6gjUPYlLVeunc2Imv9SfHs5MVjcr0I8oIVj632iisottYOyScQ5r3Mepg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9r4SVFhcZ3qInjoVK0HAfkqT6nyscsZvRGcB0j6cefo=;
 b=Fkczd/Mk+lEbt2AHoAU5ifP1HJrJeTCKDXhdkxLOAfJWWSoV0NCV7lAo/5QaCLpX8gC/IMTWPPAWA2egCNroeJMje/QPZs3vl5Wywlr8lWjTJecfRGiNx1APbZbyF1srTBrVzByQ/IDGwBeNE7n/3apUuLym9ggovCMV+2MkJ/KeEX8D8UvA2D555xLj3eCeS3Gm3wG8tVIaK6GLAr9GiHHFXo4sxU+0K1gabPHIGWLc3/0EaDK6icIK/0t/KPtRNouxa72zf0jl/51lQfOQ0B9yr6cu7sJZTLcNleborYiAV4MiNxL95oCZZdRBj81jgwBnEaqjWEJ4OFMD3Wxt7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9r4SVFhcZ3qInjoVK0HAfkqT6nyscsZvRGcB0j6cefo=;
 b=hdXbcWsBSgPwu8z8vFuCSr2tMvBYPr0Q3DPzoyY3UiW7p6vomC0J7eTfaU/qeZbUYP28tJbnxKDozqbdfsDB9bGH0MNFEGcY3qczkTQDFWJsGyUSk9rSq3PsB8QxbzxgDCekvUIsI4fkJQUdXsz+h6N2KoAWw72g8FmvaHncwto=
Received: from SJ0PR03CA0259.namprd03.prod.outlook.com (2603:10b6:a03:3a0::24)
 by PH0PR12MB8127.namprd12.prod.outlook.com (2603:10b6:510:292::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Wed, 26 Feb
 2025 09:07:14 +0000
Received: from SJ1PEPF0000231B.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0:cafe::b2) by SJ0PR03CA0259.outlook.office365.com
 (2603:10b6:a03:3a0::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.21 via Frontend Transport; Wed,
 26 Feb 2025 09:07:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF0000231B.mail.protection.outlook.com (10.167.242.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 09:07:14 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Feb
 2025 03:07:07 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>, <naveen.rao@amd.com>
Subject: [RFC v2 05/17] x86/apic: Add update_vector callback for Secure AVIC
Date: Wed, 26 Feb 2025 14:35:13 +0530
Message-ID: <20250226090525.231882-6-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231B:EE_|PH0PR12MB8127:EE_
X-MS-Office365-Filtering-Correlation-Id: bd047a5e-b10e-4c6e-05b0-08dd5644f63b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BiDL6Hp1SKysPJ5DPYg/uYXPnwxvddQ/chcvucu66mmAix8WVSNEpnJpmRaU?=
 =?us-ascii?Q?H7pTaNv3mh1JiBFw7eXITEcdnmMyOLIjOOpfGh+JmXQtomyjlHwcNO2jT179?=
 =?us-ascii?Q?oqE4tyKXBMgB9UEVTsnXt3ugTRmJWKnbckCisAI4sFRGVtxdinb3oQelH+Di?=
 =?us-ascii?Q?1zbBk/tuqgreULm2mE7O2h/L4S8kdvaWORv6VD4+QeA2y4HX1ag8SWrKMPVw?=
 =?us-ascii?Q?309l/V91a81bw69nmzA3xDt5krlZOiHrJQea58IGwIo3JhlvoKfWZWzdXTgx?=
 =?us-ascii?Q?N6Ew+y35yZQoz5BSQIWvDewNOAs5Kv5p4HoGJbB0JR4h6xHka4sygPjZwQij?=
 =?us-ascii?Q?o0lhsdCwHrbdJKpUAlnw1yRaEIvVxnL7Budhxdh3fw/QC9HMfriPz28MHX2R?=
 =?us-ascii?Q?tdUVZyE9Ko9G9axw9W78WDlFrBsVwFckcSaq81ZsGU/E6D9Xh/H+x9dMal+Z?=
 =?us-ascii?Q?A2YcEgAzsiRN7jEdbMqQ3lyETS8HPlVZLOrQgz8knyUV0YUyHwEE5wShub64?=
 =?us-ascii?Q?yWqhCY7srhkXZb8UvSyGmjoXEVDHiU0mqodxVL1TNu+B/4C3/iOTriWV/J3F?=
 =?us-ascii?Q?aWTomQxLVrIYFriboSwgRmyIZYO3oIQNRXz4lIYb8sHb6vG2+AisrqU2ehs9?=
 =?us-ascii?Q?oucECC2uzXlOPhEOIhdEV4Nl/gGIvyquaXVMsVkMOF0RQ3Xkhxy6advjWxfw?=
 =?us-ascii?Q?HtHxp81jqwiFmxXLDMImgZh8fXhOaWGmLfdSV0iH1IzUhFHhjdcz6iGmZ2EQ?=
 =?us-ascii?Q?zNfpzuGKamHo5JE17324lPrtkopHaUi33A6O9jC0sYU8sh5IJYC7fYaBlwwj?=
 =?us-ascii?Q?mAapWUssFwIgIBO1IYD40MCQt7PPtj8vDpPdpGcCFAHlz8StLSygjspMwfhJ?=
 =?us-ascii?Q?ng0ZW31IPvlqmNyaOlcyeGwelAy+Il3pUu/TYMDHXdixQs8NQEUs0q6cY6bQ?=
 =?us-ascii?Q?o22DKZIq3x2FTJrsMTSmK6wkANXg2GNl2uVkdXc9+NRXrW9v99Wpk1z129ln?=
 =?us-ascii?Q?3S/LfWyPHy8BY6433dLwaR0svKXpLQRd8JYo+JWEROewko5I3kd/EYbL2769?=
 =?us-ascii?Q?dSBch0kG/G5DV+CjCFFez30p7oS9ovC7RueSMaZPuLb1Hi32jm3lbX39ywXU?=
 =?us-ascii?Q?cz6mZwh5ZK6FL8221WnNLl/JKotZAflCTCjuitOPHBptOtGQD7TWlpwOhzTO?=
 =?us-ascii?Q?k1Fw2kzsAF0lqkJcftXs5e8Dp0hsQ7aZBt21PE6m+hwnX6Qwi0kSYg2iZ5jP?=
 =?us-ascii?Q?JzHtGdRdaXhzegYZAZ9hqtgv5UxfPUHRVrEIbQ51cig95TdFt/kMZ7bGv9sD?=
 =?us-ascii?Q?hmOeFu7m9nbutotLj/OtjHlGXgJm6Ov+3lTt4m6sowoitzBdQHmTMizdCfI3?=
 =?us-ascii?Q?3F6gUWdx5+NOM0vcKLoXH4OURmZ8NP4s9NolvcZ6j40EFbM6t7zZvq8UjEer?=
 =?us-ascii?Q?pNTl+680XSUM98N0mM5075mXCImvnQk3fVsUlTqN5kLMRtv0FOoIr/5M3SdT?=
 =?us-ascii?Q?3lQKQAGbMipSXgk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 09:07:14.3744
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd047a5e-b10e-4c6e-05b0-08dd5644f63b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8127

Add update_vector callback to set/clear ALLOWED_IRR field in
the APIC backing page. The ALLOWED_IRR field indicates the
interrupt vectors which the guest allows the hypervisor to
send (typically for emulated devices). Interrupt vectors used
exclusively by the guest itself (like IPI vectors) should not
be allowed to be injected into the guest for security reasons.
The update_vector callback is invoked from APIC vector domain
whenever a vector is allocated, freed or moved.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v1:

 - No change.

 arch/x86/include/asm/apic.h         |  2 ++
 arch/x86/kernel/apic/vector.c       |  8 ++++++++
 arch/x86/kernel/apic/x2apic_savic.c | 21 +++++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 3f70aa2f3aba..7970ead55f39 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -318,6 +318,8 @@ struct apic {
 	/* wakeup secondary CPU using 64-bit wakeup point */
 	int	(*wakeup_secondary_cpu_64)(u32 apicid, unsigned long start_eip);
 
+	void	(*update_vector)(unsigned int cpu, unsigned int vector, bool set);
+
 	char	*name;
 };
 
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 72fa4bb78f0a..e0c9505e05f8 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -174,6 +174,8 @@ static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
 		apicd->prev_cpu = apicd->cpu;
 		WARN_ON_ONCE(apicd->cpu == newcpu);
 	} else {
+		if (apic->update_vector)
+			apic->update_vector(apicd->cpu, apicd->vector, false);
 		irq_matrix_free(vector_matrix, apicd->cpu, apicd->vector,
 				managed);
 	}
@@ -183,6 +185,8 @@ static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
 	apicd->cpu = newcpu;
 	BUG_ON(!IS_ERR_OR_NULL(per_cpu(vector_irq, newcpu)[newvec]));
 	per_cpu(vector_irq, newcpu)[newvec] = desc;
+	if (apic->update_vector)
+		apic->update_vector(apicd->cpu, apicd->vector, true);
 }
 
 static void vector_assign_managed_shutdown(struct irq_data *irqd)
@@ -528,11 +532,15 @@ static bool vector_configure_legacy(unsigned int virq, struct irq_data *irqd,
 	if (irqd_is_activated(irqd)) {
 		trace_vector_setup(virq, true, 0);
 		apic_update_irq_cfg(irqd, apicd->vector, apicd->cpu);
+		if (apic->update_vector)
+			apic->update_vector(apicd->cpu, apicd->vector, true);
 	} else {
 		/* Release the vector */
 		apicd->can_reserve = true;
 		irqd_set_can_reserve(irqd);
 		clear_irq_vector(irqd);
+		if (apic->update_vector)
+			apic->update_vector(apicd->cpu, apicd->vector, false);
 		realloc = true;
 	}
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 505ef2d29311..d912c53dec7a 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -19,6 +19,9 @@
 
 #include "local.h"
 
+#define VEC_POS(v)	((v) & (32 - 1))
+#define REG_POS(v)	(((v) >> 5) << 4)
+
 static DEFINE_PER_CPU(void *, apic_backing_page);
 
 struct apic_id_node {
@@ -192,6 +195,22 @@ static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, in
 	__send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
 }
 
+static void x2apic_savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
+{
+	void *backing_page;
+	unsigned long *reg;
+	int reg_off;
+
+	backing_page = per_cpu(apic_backing_page, cpu);
+	reg_off = SAVIC_ALLOWED_IRR_OFFSET + REG_POS(vector);
+	reg = (unsigned long *)((char *)backing_page + reg_off);
+
+	if (set)
+		test_and_set_bit(VEC_POS(vector), reg);
+	else
+		test_and_clear_bit(VEC_POS(vector), reg);
+}
+
 static void init_backing_page(void *backing_page)
 {
 	struct apic_id_node *next_node, *this_cpu_node;
@@ -316,6 +335,8 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.eoi				= native_apic_msr_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
+
+	.update_vector			= x2apic_savic_update_vector,
 };
 
 apic_driver(apic_x2apic_savic);
-- 
2.34.1


