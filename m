Return-Path: <kvm+bounces-56406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16E90B3D8A4
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 07:23:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97BFB3B62AB
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 05:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E24B23C513;
	Mon,  1 Sep 2025 05:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="11ziBUK9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C227115E90;
	Mon,  1 Sep 2025 05:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756704182; cv=fail; b=uksVIQO9LRzAqdQ+rIB6ScV2xL4KZTsl+N1aoe66s0YEYHAVos1Y2x0jGp5EAgx3THazdP1zeJLtZMXf+/jmMj7fkSWaoWBMEu/t1wM0mJOe7pnYt/Dj+1CxBG7O9eEuNbhltBpbMY5LIVf28xVahLTpAyofXXsJsTDXvm2JKLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756704182; c=relaxed/simple;
	bh=nZz9j6xqa1zo26p+qsYPXuPPqZol5ZiocYkrAAkJUa8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XCtCSeaojM+pJ638v8AQvSvooUPh71AfZy6rloQimdjHI1Oqu4gsZ8kiQL+rzEllDfmNJk+e8F2eSSEba622foSZQlBywq5iWQ4g/P3tMafQQegQ2jNPbqh9kybVl3ZE0gznuUbhoCOCsgvz8lDI10EkOKTrATh016530PHC7i8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=11ziBUK9; arc=fail smtp.client-ip=40.107.220.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eocXPczC3p5r0zdh94JKjMq8z/8TRTt3FUEfo0kLXkm4V0qzWyVI0fa4gbFSeKPbnelE5qlqDzhoB/ocsDpeU3bVW1sQzT+Xx+fkj96XiZj1veeRY6TW0hz1Z3ZhW7pKFLX2OAE9xv1SHycS9egUa5Mq5Ld6BeDBQJJLpXzR8lLQoyXcQ8EazIq1JgR6fUvtabi6SZmr/3w75NyYKm3py1GU4RuO9aMTA5vdobfi66/+Z/y69qTB8y2lbF6IAfxQxtQLp6c3sV0EHA+O1zdpUmRUEJGKy+DXOGyWpb5i3SHWnfPw2rcjek6BJLduD9d7GkfYfk+tYa7nyLP5GCq66w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2DmRYtGZfNDTzm6dxFRsLM/sKhte2cg3PtpnDihkWMg=;
 b=Wi8w7tmpt4Gd7T/lBxU5rFs7UMY9W7nPNOHphc6ROZxLeCVBoToeED8CW+bXDiKVlzsADQrJsD0vfN2KlR7z/YwStCFBrBOvF2RBdPrMtCcvHFy3k1J4PRzp5iSnsXOBpwTlmqGm1mNZB9lckQ5ovl96Db61fxImO3gPPtEHtzf3DmpTEf9n20ir0fxcpXeMDktCFW09AMogmiWBT2fvBEdFmd4MSj3a3RKD7lA4EXDAP4dkcTCLS4v09i8X+DJzZqOT+FY6QMuCpgdScPxGAgvnnsAAPVLm+DSRHckWmuTndpveSBy8CiDJHi6aP4/SFKxMK0KBEiSah5XKoE4saA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2DmRYtGZfNDTzm6dxFRsLM/sKhte2cg3PtpnDihkWMg=;
 b=11ziBUK9p7+q8criIYVDksR2fP0TkMnl5LCrMN+kZLRYQjNOPp30fk4EWjsOMKaN9ojL7epKD1RyNlTyluj4B0f8eM1Og9awA/tZzYPaSlTeV1UakHEjEotmLAfUmshchvrMPhbnm/GaHxnrxvH2tP1gWyqdG+4inqDQi1OIGlU=
Received: from BYAPR06CA0058.namprd06.prod.outlook.com (2603:10b6:a03:14b::35)
 by DS0PR12MB9321.namprd12.prod.outlook.com (2603:10b6:8:1b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Mon, 1 Sep
 2025 05:22:57 +0000
Received: from SJ5PEPF000001D7.namprd05.prod.outlook.com
 (2603:10b6:a03:14b:cafe::1c) by BYAPR06CA0058.outlook.office365.com
 (2603:10b6:a03:14b::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.26 via Frontend Transport; Mon,
 1 Sep 2025 05:22:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001D7.mail.protection.outlook.com (10.167.242.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Mon, 1 Sep 2025 05:22:56 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Sep
 2025 00:22:55 -0500
Received: from BLR-L-MASHUKLA.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Sun, 31 Aug
 2025 22:22:51 -0700
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v2 05/12] KVM: x86: Add emulation support for Extented LVT registers
Date: Mon, 1 Sep 2025 10:52:38 +0530
Message-ID: <20250901052238.209184-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250901051656.209083-1-manali.shukla@amd.com>
References: <20250901051656.209083-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D7:EE_|DS0PR12MB9321:EE_
X-MS-Office365-Filtering-Correlation-Id: e7814e6b-1408-48f9-e20b-08dde9179c02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WEpzMko2TklaNFVNMkp4K0J0ZnJxTVR1dlByZGxidkJwQ1VDdGswYll6clhx?=
 =?utf-8?B?d2srUmNOU1J2SUNkUVRXM2ZpZTdKNzNRbzlGdkkwbktMSy93bE9iS3hNdWhv?=
 =?utf-8?B?L0VTVEQ1a0xEK1RxbDNMWFJSKzJiT0E1dU52MTFjMUZDMmw0MENjbzBzbFRl?=
 =?utf-8?B?ZmtpLzVlSk9PQzJ0NDRmcVE1OWdQZk9yTDJGV3lqR0Z3ZC9sK1paQ0FYQW1M?=
 =?utf-8?B?a0d2Z3R5Uk5kWTE1bFErL3NWQ1RsK3dQWVk4U0NJSVZoaVdnenhGQis5Ymdn?=
 =?utf-8?B?U2c1aWVvMzFncjRZMGR6cHlqenNUcTdtWjlHRHU5SWpFdktLOGZpMTRsbWpM?=
 =?utf-8?B?ZG9GUTRTVU1Fa0lQU09KTVJQSFRLdVIrSFdqdnYxSmN5dXRaTmFUS0J6L0xN?=
 =?utf-8?B?UFRHM0grWGFzQk1sM3l2TGo3Mkp6NnBqNjNtYURQclBuOTBNN01rZDFoblI4?=
 =?utf-8?B?MWZDbzlLdmVZUVRIdHJEQUtWcFhOaVNveG5qZ05qbGFzLzdtS0JSdmR3am4y?=
 =?utf-8?B?eGRGSzNIYUsxV0E1RDA1djVpTUs3ZEJBcmQvbkhaVWhjVTFleHpqSSs4eHlF?=
 =?utf-8?B?TlhteDFlNWxSM0lpYklIeDlLeHc3c1haZCtjRzZvVWtRbWM0WXp2cndyOHNq?=
 =?utf-8?B?MERjTTMrZDBLb3lXM2syWWxtaUlNMVNlVkZEaEJWYzZZYktkTUYvdk82N3l6?=
 =?utf-8?B?bkRuUWhxWVh2bEU3WmFMY05kSXRyVXVMMnNvOHd1aW5zODk4Y2Q2Y1h6WU1q?=
 =?utf-8?B?Tmg2RlFTK001UCs0ZkdFekhzZXZXREhYMWM1dmx4Y2RmWmR2WnJaQ0M1RXVJ?=
 =?utf-8?B?ZCtIR2dFSGZGeUdUdXJQY3JyQ0lRUC9rVnZoYTUvdXp2b1ZOVmxhVE1Tb0RD?=
 =?utf-8?B?Umg4dDk1UlN3UXltQkVLa1F4Qzc3Y1IxTVV4TTVVVjdBakNXYllWSGkwMCtX?=
 =?utf-8?B?dmRxcWZGNUYydGNHRy8ybUk0Y0hLOGpTZ1drRzNNNEUxV1p4NEJPVG1NaW1V?=
 =?utf-8?B?alYwUGpHWDZMQUJNNzVISjhpaXNEVkl4VldZbWthR0xBVlFPNjRDenhYZkZo?=
 =?utf-8?B?RFBJMERYdzErVnZxZ0ppM2oyRU00N1FRVzAySllPaTJzSUZHNjdSYUE1WXlq?=
 =?utf-8?B?Ly8wWThSbmpMV0g4NUg4aTJ0TGNTRitMNE52aERUZnRxTnEySCtyQ2hQWEll?=
 =?utf-8?B?bVRWSTA0Y05uVWwvU2x5ZnpFalI3a0V0dGNJMGNnWGhaUStnU0E4NXZuMldu?=
 =?utf-8?B?R3BBQngxcWVLS2hDcklLQk84T0lOc1dObU1IaWhrYVgyV1RQZzg1REYrOGM5?=
 =?utf-8?B?OUZjblpSRHZpSVF2RWdqSy9RUDdFM0RaTXdHcGREa1htNmdDaFU3bXNlV1lU?=
 =?utf-8?B?bXRjZCt6SmtNT0g3TDNKSnQ2cDVxYlg3UzRTeExERE9vSU5rK01BTkI5MGho?=
 =?utf-8?B?OFhMS3dIeGEzNU10WkpLSUNJM00yclU1N1I2TmJZVjg3OUNpTmFGNm1aRFN3?=
 =?utf-8?B?TVMza2xhNitQaytFMjR1ZFJ1T3V3U09PQzVaVDl5RzdkK3Z6a3FTc054anBx?=
 =?utf-8?B?bS9BWUNpLzRVQnVlTjFMbnAvOXdBaWxIS0ZMQjZLa3YxTHcyWTVJRERmWDRU?=
 =?utf-8?B?SE9sR2diN2FjZ09KNWxjWXhOQWZkbmdKQi9OMmp0K2UveUZ5c2UvRGR3bDJp?=
 =?utf-8?B?bGFIZTBIY2J2WnBtVXRMM1l5Q1ZZWkl0NjVaN2VLS1paU0V2eEY0OS9Wak5a?=
 =?utf-8?B?RjZoM2MyaWhtL0ZFVTJvOXMrdVh2VXgzL1F5T1lxL0pKZEFxTWk5N01aNkVK?=
 =?utf-8?B?NTNka1d2QUZRQk52Q1QwN25vTTBMak1hQXhoQ21hRXVIM05sSHVJNHBOK01T?=
 =?utf-8?B?Mm85d0lwOWRES0lTWFpaK0U2QW5nNDV3czlvMjUvQThkRnlLRnpYa3lTL2dP?=
 =?utf-8?B?YWhCMTZpSU5tSW8yMjVqbm5SZnpOWUdVS3RCK1lCMjh4dHpWcThyMTJPdFR5?=
 =?utf-8?B?dUV0M29vZW51MGVmRnpDWVZFQ1hRNUJheXM2WWVxc2tybTIxVzBNM3dMODJU?=
 =?utf-8?B?bjJTT2RpaVZTbnlmdDN5ZWl6TXllV3hGdFpTUT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 05:22:56.6082
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7814e6b-1408-48f9-e20b-08dde9179c02
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9321

From: Santosh Shukla <santosh.shukla@amd.com>

The local interrupts are extended to include more LVT registers in
order to allow additional interrupt sources, like Instruction Based
Sampling (IBS) and many more.

Currently there are four additional LVT registers defined and they are
located at APIC offsets 400h-530h.

AMD IBS driver is designed to use EXTLVT (Extended interrupt local
vector table) by default for driver initialization.

Extended LVT registers are required to be emulated to initialize the
guest IBS driver successfully.

Please refer to Section 16.4.5 in AMD Programmer's Manual Volume 2 at
https://bugzilla.kernel.org/attachment.cgi?id=306250 for more details
on Extended LVT.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Co-developed-by: Manali Shukla <manali.shukla@amd.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/apicdef.h | 17 ++++++++++++++
 arch/x86/kvm/cpuid.c           |  6 +++++
 arch/x86/kvm/lapic.c           | 42 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/lapic.h           |  1 +
 arch/x86/kvm/svm/avic.c        |  4 ++++
 arch/x86/kvm/svm/svm.c         |  6 +++++
 6 files changed, 76 insertions(+)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 094106b6a538..4c0f580578aa 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -146,6 +146,23 @@
 #define		APIC_EILVT_MSG_EXT	0x7
 #define		APIC_EILVT_MASKED	(1 << 16)
 
+/*
+ * Initialize extended APIC registers to the default value when guest
+ * is started and EXTAPIC feature is enabled on the guest.
+ *
+ * APIC_EFEAT is a read only Extended APIC feature register, whose
+ * default value is 0x00040007. However, bits 0, 1, and 2 represent
+ * features that are not currently emulated by KVM. Therefore, these
+ * bits must be cleared during initialization. As a result, the
+ * default value used for APIC_EFEAT in KVM is 0x00040000.
+ *
+ * APIC_ECTRL is a read-write Extended APIC control register, whose
+ * default value is 0x0.
+ */
+
+#define		APIC_EFEAT_DEFAULT	0x00040000
+#define		APIC_ECTRL_DEFAULT	0x0
+
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
 #define APIC_BASE_MSR		0x800
 #define APIC_X2APIC_ID_MSR	0x802
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index cc16e28bfab2..fd97000ddd13 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -443,6 +443,12 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	/* Invoke the vendor callback only after the above state is updated. */
 	kvm_x86_call(vcpu_after_set_cpuid)(vcpu);
 
+	/*
+	 * Initialize extended LVT registers at guest startup to support delivery
+	 * of interrupts via the extended APIC space (offsets 0x400–0x530).
+	 */
+	kvm_apic_init_eilvt_regs(vcpu);
+
 	/*
 	 * Except for the MMU, which needs to do its thing any vendor specific
 	 * adjustments to the reserved GPA bits.
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8bf7e0d33da9..576d2d127d04 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1648,6 +1648,12 @@ void kvm_lapic_readable_reg_mask(struct kvm_lapic *apic, u64 mask[2])
 		APIC_REG_MASK(APIC_DFR, mask);
 		APIC_REG_MASK(APIC_ICR2, mask);
 	}
+
+	if (guest_cpu_cap_has(apic->vcpu, X86_FEATURE_EXTAPIC)) {
+		APIC_REG_MASK(APIC_EFEAT, mask);
+		APIC_REG_MASK(APIC_ECTRL, mask);
+		APIC_REGS_MASK(APIC_EILVTn(0), APIC_EILVT_NR_MAX, mask);
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_lapic_readable_reg_mask);
 
@@ -1664,6 +1670,14 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 	 * x2APIC and needs to be manually handled by the caller.
 	 */
 	WARN_ON_ONCE(apic_x2apic_mode(apic) && offset == APIC_ICR);
+	/*
+	 * The local interrupts are extended to include LVT registers to allow
+	 * additional interrupt sources when the EXTAPIC feature bit is enabled.
+	 * The Extended Interrupt LVT registers are located at APIC offsets 400-530h.
+	 */
+	if (guest_cpu_cap_has(apic->vcpu, X86_FEATURE_EXTAPIC)) {
+		last_reg = APIC_EXT_LAST_REG_OFFSET;
+	};
 
 	if (alignment + len > 4)
 		return 1;
@@ -2408,6 +2422,14 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		else
 			kvm_apic_send_ipi(apic, APIC_DEST_SELF | val, 0);
 		break;
+
+	case APIC_ECTRL:
+	case APIC_EILVTn(0):
+	case APIC_EILVTn(1):
+	case APIC_EILVTn(2):
+	case APIC_EILVTn(3):
+		kvm_lapic_set_reg(apic, reg, val);
+		break;
 	default:
 		ret = 1;
 		break;
@@ -2769,6 +2791,24 @@ void kvm_inhibit_apic_access_page(struct kvm_vcpu *vcpu)
 	kvm_vcpu_srcu_read_lock(vcpu);
 }
 
+/*
+ * Initialize extended APIC registers to the default value when guest is
+ * started. The extended APIC registers should only be initialized when the
+ * EXTAPIC feature is enabled on the guest.
+ */
+void kvm_apic_init_eilvt_regs(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	int i;
+
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_EXTAPIC)) {
+		kvm_lapic_set_reg(apic, APIC_EFEAT, APIC_EFEAT_DEFAULT);
+		kvm_lapic_set_reg(apic, APIC_ECTRL, APIC_ECTRL_DEFAULT);
+		for (i = 0; i < APIC_EILVT_NR_MAX; i++)
+			kvm_lapic_set_reg(apic, APIC_EILVTn(i), APIC_EILVT_MASKED);
+	}
+}
+
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
@@ -2830,6 +2870,8 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		kvm_lapic_set_reg(apic, APIC_ISR + 0x10 * i, 0);
 		kvm_lapic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
 	}
+	kvm_apic_init_eilvt_regs(vcpu);
+
 	kvm_apic_update_apicv(vcpu);
 	update_divide_count(apic);
 	atomic_set(&apic->lapic_timer.pending, 0);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index b411de5f33a3..66084ca38b37 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -98,6 +98,7 @@ void kvm_apic_ack_interrupt(struct kvm_vcpu *vcpu, int vector);
 int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu);
 int kvm_apic_accept_events(struct kvm_vcpu *vcpu);
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event);
+void kvm_apic_init_eilvt_regs(struct kvm_vcpu *vcpu);
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
 void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a34c5c3b164e..1b46de10e328 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -669,6 +669,10 @@ static bool is_avic_unaccelerated_access_trap(u32 offset)
 	case APIC_LVTERR:
 	case APIC_TMICT:
 	case APIC_TDCR:
+	case APIC_EILVTn(0):
+	case APIC_EILVTn(1):
+	case APIC_EILVTn(2):
+	case APIC_EILVTn(3):
 		ret = true;
 		break;
 	default:
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2797c3ab7854..0471d72a7382 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -771,6 +771,12 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 		X2APIC_MSR(APIC_TMICT),
 		X2APIC_MSR(APIC_TMCCT),
 		X2APIC_MSR(APIC_TDCR),
+		X2APIC_MSR(APIC_EFEAT),
+		X2APIC_MSR(APIC_ECTRL),
+		X2APIC_MSR(APIC_EILVTn(0)),
+		X2APIC_MSR(APIC_EILVTn(1)),
+		X2APIC_MSR(APIC_EILVTn(2)),
+		X2APIC_MSR(APIC_EILVTn(3)),
 	};
 	int i;
 
-- 
2.43.0


