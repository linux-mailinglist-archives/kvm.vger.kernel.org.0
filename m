Return-Path: <kvm+bounces-26804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F17FE977E98
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 13:39:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 294E51C224CA
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 11:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FDDA1D88CC;
	Fri, 13 Sep 2024 11:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ej62a/xs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD72A1D86EB;
	Fri, 13 Sep 2024 11:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726227552; cv=fail; b=B0o9SlfNL0/AuOMkraEAThz9imNQ3C2XCZ7Pi2NbMse8RaSVcWY/80hD2b7RWe6ERiLTyMFSZGbHZllCGMY8OxlU+5JfG3VjWPksXuRlwUUNHzGFwUBPt4/aml2gsw9HJ0XSdpUaY/BkBg9+HpL//DzQXGvyKVeJHXl2StLfPDo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726227552; c=relaxed/simple;
	bh=tJbvzSSRKhS9PL3f/UFbtIBGX+D4lbmX65DyCvIlVms=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rw6PoRk03g0RbAwCbfed2iw1HY0Fp3UtwMT4vOtgptRC2Gbj8ZqAgjtdoTk/e08DQrIuevf/O2fgbiA3wqcB6zUkrZvkeV9j34Oi6VfaPj7pfbzmNq3F3AK8cRelZFTXmP5NWB/bA+s6VVq/H7c/FmdwTeTV6k9eIkMaXZst2nY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ej62a/xs; arc=fail smtp.client-ip=40.107.92.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wflk+S1vfZ1nPt5zgZ4yWSE45rpdzcRC7SLAYytYnu4iixX5ilJBVZlEBnqcrleFZ+8RfRWZ3O8fTDjh+AMtJFr7PUrggkVPSHP0wzZXH0jtxI1iBT0EAA1ewwmaJPYjmBBn0D4fAm3pjXhV1QhiPFDSS77rdm0uYb1WhIjJed5gKunMH+AzKB8sEI7fCOIdkrggCmidhmaZHXrh/iuN17mdDkMlLD5A8u0Zlsp7jNXW14Sj6C0tiPUFILYaiDl3cZu770b0/EA4NcVmN9uWjrcDzSiOmc0FN9YUNyn40n0suYHOeKRCzoNZVD3ME1/0HImpV3Lzee2ZcdqVXVdkcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2UeH7j7k8K/P4com9m60nPj+9OI1JYn2VXg0OoORKvM=;
 b=xcScfQTX/Zorm2Imn57QqTxBRyDtWqa7H7uhk1wPDVU6FoKQhwFacEk8ZzRkUqlxUvIMNKE3jq+54WQfJMZ8MU14JbIf93p3gKM2VjsfYUD52lM3UT9/qvcZ3vSoCHIq6jyt6nj6xRGHWKK/QkF0E9JXE+hMMB+/Yc30h9vjZSYYjTKvQPPKd9jVL2WZ/oxTxGwnaoXiZP9xfJ5gL56uySkdj2wqCcdSI7/ZSEdEoujwWHgrQ1zQizgCZKCVZW58XQrIVRuIOjLeR+6msy7tGBJoIrB5zCqnaJjCW/9LoxfDTRg+MAN+a95rgoPHeJBsLFSkx7PGWqqcO7DYueCgZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2UeH7j7k8K/P4com9m60nPj+9OI1JYn2VXg0OoORKvM=;
 b=ej62a/xsDhR5kPy76+KRJdf+4QkXDZ2r8SLceF6P3GKsOKjP80il+eKzbGLGnWtGWdJeMxxxziLDn6pHg1C/+JpzbjfzqbrFgc9QJMhmonhfK6XcqIMtKX9maSjiJ+nSNbmpk7msWqmRpzQEreglu5Swgilaeh5thib/6WCLD4s=
Received: from DS7PR03CA0150.namprd03.prod.outlook.com (2603:10b6:5:3b4::35)
 by LV2PR12MB5727.namprd12.prod.outlook.com (2603:10b6:408:17d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24; Fri, 13 Sep
 2024 11:39:06 +0000
Received: from DS3PEPF000099DE.namprd04.prod.outlook.com
 (2603:10b6:5:3b4:cafe::c7) by DS7PR03CA0150.outlook.office365.com
 (2603:10b6:5:3b4::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Fri, 13 Sep 2024 11:39:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DE.mail.protection.outlook.com (10.167.17.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Fri, 13 Sep 2024 11:39:06 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 13 Sep
 2024 06:39:00 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<Thomas.Lendacky@amd.com>, <nikunj@amd.com>, <Santosh.Shukla@amd.com>,
	<Vasant.Hegde@amd.com>, <Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>,
	<David.Kaplan@amd.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>
Subject: [RFC 06/14] x86/apic: Add update_vector callback for Secure AVIC
Date: Fri, 13 Sep 2024 17:06:57 +0530
Message-ID: <20240913113705.419146-7-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DE:EE_|LV2PR12MB5727:EE_
X-MS-Office365-Filtering-Correlation-Id: 43860ea3-5e98-4371-68a3-08dcd3e8acd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/ScEjPUyfP5gJNslmIxuydkYHuPmXhtZRBygZJNC/EjP3XkDCycYg0c8oW5O?=
 =?us-ascii?Q?MhqZc7NBEd7oU68BeoWjmWrsDvh2FgTJUufcprKPRyLkNIUJ/vk7IZuavBfc?=
 =?us-ascii?Q?LMUnPfPYbkeo40P+qEqu8ai/l/XlPYL4jwOFjMOtElg4y7swVU7nC1XuCFNR?=
 =?us-ascii?Q?Yt19kCFCFTOOuuh8UBtnQCihgNRyHsQf22P1hcMTOyRBND4xoLl0mBFmlv+n?=
 =?us-ascii?Q?PLbINg0RvStDyABuCkrJwFBiXXLrlUPv71ntENaGqh6pz4u2Tg680fXCk8Vi?=
 =?us-ascii?Q?BGYp7HRmnOdoB53e0WjkpOcIl/kvfVjDU7EwSHJ+ffWzj6+ZTvDCdLSXXn8C?=
 =?us-ascii?Q?HFlrPUBky0hdQMspBbJLDARbpwp7yxqsQ57OmhnC9+/asLsb4OM2kyqaZXfz?=
 =?us-ascii?Q?JgsEEOKHhsXIR1qHyYAX7v2FBgYfipy1CrRU7c0/l9GhReD0yWmTJ6uKMq9A?=
 =?us-ascii?Q?llndHcLQgHFKaGEDxjIPZ2AFepm0HW+FLJw8YdJ7bKSDCcyFMK2oXR9O43+0?=
 =?us-ascii?Q?FDkDgS9Sf9wDTx2oJ4ILy8bhU5dDbPp0ko8b+k8cbhHivjbm8zPVsBPy2Nfh?=
 =?us-ascii?Q?epp0RPKhLBuzU1XW3tsS8uTdw6/S62UNnd5OURIVhsTFDEWeL9ExDfLKmHzX?=
 =?us-ascii?Q?hgzBUDG6YEGi5000u1eshfn9bsLW86+UJZpHs9SLkIzxXIvayfjTQ7buLgIO?=
 =?us-ascii?Q?rwGvLnE5kXQCId5j8R0Sm9nSysPTmI5v5isJwrSfmBxUcBXwEYnyof5xnwOx?=
 =?us-ascii?Q?Sfxk4191suKJvbqoY0CaSdoF2S8rtZxUyA6LIpV29OURa9KsLpnqnkz/ZpB5?=
 =?us-ascii?Q?CG6SUJC2F2IpvSW+oigeTDBKdH27bjYYKT5s55ljjDElUirBnh4rk/nvA/Sf?=
 =?us-ascii?Q?GaqTKHbIFa5ow6Ttgca2ZfqtjfHfmbCbeY+ZFu9IyUfEOvz9xYqQ+SADb+sw?=
 =?us-ascii?Q?7H4rVQnWjcCDIAp3VZ1ZCfsvMo5Z9Xv9kpgiH572mbbqvurz5C0gkbiz/qYO?=
 =?us-ascii?Q?yXqRq1HMZEW1TO3lkVTnWdWpF45XDjnrr5ON4fv4yKrHDH+l/d0/aiNtVvyr?=
 =?us-ascii?Q?JcDqu/Jak+p8oG40iAzfhfwD8lJiIYZvsFP36hmJBkknSchfntLIGux4q9iz?=
 =?us-ascii?Q?n4Dw+opITvrl6fN8PtIV0lDnTRn90hGFc5QAZ+zj4SDio5ffMqdEQgTuIOKe?=
 =?us-ascii?Q?dV2xZt0VRBMsHkIy6MYpOpUvD/ldzUseF2CPr8EjjEEi0utdvYYdKH1/yCYy?=
 =?us-ascii?Q?rY8evI+OLGIb2FvxngA3S8sMVn1lsRpexcfwIySoBtuWVmDf8HL8ZM/0/XaJ?=
 =?us-ascii?Q?+MliL7YU9aiKnfm1UHL4t9Nm8SyV7ominX2tFQkeOY1+lVUXZB/bT6B5fgDz?=
 =?us-ascii?Q?CgOGD1ZExRjnD7+O5p6yJgDB+fEXLrCyWIi7MBO5EMzBcaFJ7Toi+H1iHN1Z?=
 =?us-ascii?Q?VcUulGvwnqwwgjVceBsYC6I/AuCkrExh?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 11:39:06.4214
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43860ea3-5e98-4371-68a3-08dcd3e8acd5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5727

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Add update_vector callback to set/clear ALLOWED_IRR field in
the APIC backing page. The allowed IRR vector indicates the
interrupt vectors which the guest allows the hypervisor to
send (typically for emulated devices). ALLOWED_IRR is meant
to be used specifically for vectors that the hypervisor is
allowed to inject, such as device interrupts.  Interrupt
vectors used exclusively by the guest itself (like IPI vectors)
should not be allowed to be injected into the guest for security
reasons.

The update_vector callback is invoked from APIC vector domain
whenever a vector is allocated, freed or moved.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Co-developed-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/include/asm/apic.h         |  2 ++
 arch/x86/kernel/apic/vector.c       |  8 ++++++++
 arch/x86/kernel/apic/x2apic_savic.c | 21 +++++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index ca682c1e8748..2d5400372470 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -315,6 +315,8 @@ struct apic {
 	/* wakeup secondary CPU using 64-bit wakeup point */
 	int	(*wakeup_secondary_cpu_64)(u32 apicid, unsigned long start_eip);
 
+	void	(*update_vector)(unsigned int cpu, unsigned int vector, bool set);
+
 	char	*name;
 };
 
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 557318145038..5aa65a732b05 100644
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
index 09fbc1857bf3..a9e54c1c6446 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -19,6 +19,9 @@
 
 #include "local.h"
 
+#define VEC_POS(v)	((v) & (32 - 1))
+#define REG_POS(v)	(((v) >> 5) << 4)
+
 static DEFINE_PER_CPU(void *, apic_backing_page);
 static DEFINE_PER_CPU(bool, savic_setup_done);
 
@@ -199,6 +202,22 @@ static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, in
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
 	u32 hv_apic_id;
@@ -313,6 +332,8 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.eoi				= native_apic_msr_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
+
+	.update_vector			= x2apic_savic_update_vector,
 };
 
 apic_driver(apic_x2apic_savic);
-- 
2.34.1


