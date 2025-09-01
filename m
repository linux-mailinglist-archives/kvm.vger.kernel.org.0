Return-Path: <kvm+bounces-56404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EA152B3D89B
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 07:22:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49B8B18940F9
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 05:22:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46D3236A8B;
	Mon,  1 Sep 2025 05:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4Atoq7Ym"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EAC15E90;
	Mon,  1 Sep 2025 05:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756704135; cv=fail; b=iA7ClZ+DKsURakYb1mDvr3A7BI8qFRfoXEKRjFnQ+LNfuGF+k0tnSc3pxlK0bt+n4qguGodqYHWOGRSKk8btxWgjH6CRNsBAiuSUKybdoYwemRc2YKVBr8+6Vmn0A/eHav2dVQTcjNqb0blfNSWtaj56uxlcDwWk2fPaLpDGt7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756704135; c=relaxed/simple;
	bh=SdUlZE/lhT1/A4p4UXj5N/3UobaMObI6SKN0O925G+0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T2+F0JgvhoipEVXOlVcz5mRCwSlzQML701AKR+WfMgqy8rHrnf4gYrXPH3ItD94ZyRYL+xPIL9s5EaqmO6YeZS25MmoHQWS03Q79JsUKg5xnmnSyMuQSaFOHsLoyswrQiAQ1WTipKyKLPHpIVITpz1zo0Jq2645s57daumshH8M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4Atoq7Ym; arc=fail smtp.client-ip=40.107.92.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sE7YVULFkULz3Ym1KSLF3tmhJ8JcNk7qcyygiDYCYlXk6T3ErnrbRYDYhhGZaiJVTyRu2FNpseiOEQ/jWsT5H70W7CHHLDe8qYWJqIBxzMI8pw7vUsOOImCiViltdx9tP0VKwy1qtB3b5zGWctXZjT6T/O+lI5rmdBpDJav33fwZYeeN0aIW2WtxRVNo/xaqVBPVJo1IWaBdie6mvKFDMXHTyZBONbu1H4QQiQEOeCaxXSRl/ZFSPL+MHwgmA6VqEwebeDNZC/5pVeCWWEDwh31G7G1BftAiQFoVfZOnBe+BUm17CEk0ddcaJJo82mTry+QNtc2JWFD3NDTPAIqPhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N+knjp0Rng7JU0wTw6w8F+SgQs8R07Sb4OYKK+Wi3Sg=;
 b=URQhYBw1r4bRaN8xv0vNhsp8fKyXogWVl0Bk4Z0lnbWGaFG6mEK0vttdUS5KzkWZ8/mH5WQQmAjgvDAjWiK1LQ968QPT4BCFquO4keVrDabGLO3sa3BxQ+g/SOOkp9xMkUhdcnGo9RkOxEniC1syEf1BXtlaWNSa7EBNuRTbPaZGMm31QlnL5cmN9Y6UPyc6t2QKwXsnDitu+ivdt37dSEKdWmdIC0I263Sp9cjF02zqFy3kA9bpsjPQHAtqPeF1Nt0Jl1DJPCNfRa3I4wFBKnRGmnkaiBRQuTcfR8aivCEBfiD0D4C1yOU1PWUEYEf20GHGeiWoi/jD1o/EzvT94g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+knjp0Rng7JU0wTw6w8F+SgQs8R07Sb4OYKK+Wi3Sg=;
 b=4Atoq7Ym3yWiZyq4GeTyOB445IChRsZMWj7lu7FSXAlG64G1J/FX3XP7iLLuY+DDt1oJPgvlCNXXLvzEVFn0/v/qeFttleTk/LDS/m5OQdiQexkZZcS8nnKCWbiTJGf8799dtKvJRoFgPnMJuKNEL6gyp9lDHdFpoR0kL4j3qhU=
Received: from DM6PR08CA0010.namprd08.prod.outlook.com (2603:10b6:5:80::23) by
 BN5PR12MB9512.namprd12.prod.outlook.com (2603:10b6:408:2ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.26; Mon, 1 Sep
 2025 05:22:08 +0000
Received: from DS3PEPF000099D4.namprd04.prod.outlook.com
 (2603:10b6:5:80:cafe::66) by DM6PR08CA0010.outlook.office365.com
 (2603:10b6:5:80::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Mon,
 1 Sep 2025 05:22:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS3PEPF000099D4.mail.protection.outlook.com (10.167.17.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Mon, 1 Sep 2025 05:22:08 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Sep
 2025 00:22:04 -0500
Received: from BLR-L-MASHUKLA.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Sun, 31 Aug
 2025 22:22:00 -0700
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v2 03/12] KVM: Add KVM_GET_EXT_LAPIC and KVM_SET_EXT_LAPIC for extapic
Date: Mon, 1 Sep 2025 10:51:46 +0530
Message-ID: <20250901052146.209158-1-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D4:EE_|BN5PR12MB9512:EE_
X-MS-Office365-Filtering-Correlation-Id: f04e2207-0c03-4b8b-2997-08dde9177f04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VEliaWxSNWJyNXFtZU81cE0xdnJWdTFnM0xWSHRabHhSQ1BXVEF1dGFMUWN4?=
 =?utf-8?B?YVFITTVETEVlODE2ZDhWVDNvaHNWQjMzQVI3OHJUU2lmNVNJZnZxTVAxZ0p6?=
 =?utf-8?B?WHZsT1FNdTN4c01sK3pobTFRQVc2THVQRDU2YWtCb2prRmptdm1kK3FteDdq?=
 =?utf-8?B?aDJqckhRZjFnTjlPSkxmZVVaaGNWYlFPQlRxaEU3eXZLRHVkTy9wejlpWTZl?=
 =?utf-8?B?YUZnZ1B2QVJ3SFl0T28yWWNRVG9CSXUvYkQyblZXczFzTHZsdGcwYTZhSy9k?=
 =?utf-8?B?TVVCTlZINm55RDJ5U24rV0N0M3JXWlpMQ1dPZVdvcFE1SkFrRGlLakgyOTZn?=
 =?utf-8?B?SGRjRy9xMkl0Wjl4dm9mN1VoSmpxaXJMWW9hRmoyM2RYVU1Ld041UWVuQ2RS?=
 =?utf-8?B?U1lNaHVlbnlVZDZxVDQycEN5ck53MFFSNnBWUjJrL3d0ZU9wTHlNbW1vVVly?=
 =?utf-8?B?dUJlK2wycjRwTGFDNUxhREdZZFhkTm5rZ1Q5Z2J2VUdiMWMwUTh0dHUwZTVx?=
 =?utf-8?B?VEJ3dldwK1FESllQb1FJUzBnZnBRZTlaNnJ4eng3ZDdxTyt6K0c5SExiU0lL?=
 =?utf-8?B?V2lVQ01SK2lBN2VzcWh6blRJU3RZYWJiR0orVHpsWnE2Y2RCaUlUTHJQSU56?=
 =?utf-8?B?WkJWWEcrNk1IYUxSRk04M1YyQWMrWFlYb3l0d3BsbHVLcDJyVTdWOU5tZ3JN?=
 =?utf-8?B?RzZwYWhHaitDR25jNjhtR1piYitDNXgvYmlZeTJTZzE3eTY3NjJHcU9RcUJQ?=
 =?utf-8?B?R250YXpuRHBSNDVGM3h6OTJtVVowTm5pK0U5QmtZclJUYzMrUXRlNW1aVTE4?=
 =?utf-8?B?d0RmVGtjcmRDTmFzSWgzYUNiZWdOK0J1YnZTZ0NySm1GNnFjU1BWWWFHaldN?=
 =?utf-8?B?a0FhOE5HeUVCL0FKZTJuR2Y1ZXM4VW9GVThPd0tpQXRuMUJXU0d3WnZKVWxv?=
 =?utf-8?B?ZGdCSTIwRU1MOFg5VmxmTy9JdGhaRkovM0d2SDA0Nzk0WHNSMkFGSktsV0Va?=
 =?utf-8?B?a2JqeGsrMW9SS1dZZDIrenpvSWFyQ2pxNnNZem9FUnBoTkhxWGR5c0pMYTJh?=
 =?utf-8?B?Y253ajBQa2h5bG84eDA3aHNoSEdhTFlBOXRPQWx2UDY3ZGRRV0Z1ZzN4dWtu?=
 =?utf-8?B?Z2txTWk3ak5DRnc0VVFWeThQbkVhREM4VHlBekNTQ3VQNGJKMGhxR3RhaTRO?=
 =?utf-8?B?VWFjY1U2TkRENDZqR0tZaGFreXR2dTJDTW55eEl6TkxaK0xNVDVERi9NKysr?=
 =?utf-8?B?ZmZpcGIyRUlwb0x4UEZpbWhLSFFwaEY5akRXZHJyY0REbituZ2dnMkFFbW16?=
 =?utf-8?B?ODRrZHNJSFBZSXo1VjVrMlZUY3BFeEdneVJyd1hXNVVJQlJYTnpUbU40alpv?=
 =?utf-8?B?bm1CSnZiQTljRisrKzlhUXk5bW9jRmdxbDRZWWJ1bU9PeENLWHVpWEtrYldO?=
 =?utf-8?B?UzhxTkx0NkVVbFdCSm45K0ZLNjlDVFJvNFJMQXc0bzNIbkRRcVBSN0x3RTRP?=
 =?utf-8?B?blY3Kyt6YTR1NnhYbHgzT2dKMHV1Vk42dERpK2ZQbXFCQXBwemJneFV0V1ds?=
 =?utf-8?B?dVZpcWtlbWJJdkQ0OVcxSVdvc1AxdHg0MDVLS1cwY2Nxamc0eExwWU9zdDNu?=
 =?utf-8?B?ZmtTTmdaNkxxMFljWHQ5b3crODk2VlZ4ZUgvTkloUUZJVkpwdlhRRVBvNy9H?=
 =?utf-8?B?UGk5c2JKa1cvTXlRdUQ1ZFZDOGNMQVVmYUF5RUxpa0ViYkc2em90QVBRa2pM?=
 =?utf-8?B?OXN0aHpBUVVEckkwcjRFSHltWXRzQy9KNW5kREJmbnYxY1Q2WkpkUTJiTXJZ?=
 =?utf-8?B?WUxxcjNwdHA1dFJYcUFJdkNUYU1SVy8zNmJZU3R4NzFpQTFYSEoydmJtVTF5?=
 =?utf-8?B?OUM2M2V2RDBVRHlxREJvVXkzVWxHNEpFRWhSNXEva1BOdFZPa1YxaUhzUjZn?=
 =?utf-8?B?OUVET2VWM2xlNVhuQy9OYzExdGNZY01WQlIwZWNtMnoyTDI4cHpaSTBGZGxM?=
 =?utf-8?B?a2ZxbjY3T3BhUTZCVlQwa1BtVUdtaW12MC9FNzhYTzdFRzJhYWxWYUppUlBh?=
 =?utf-8?B?b2ZVVnM2M0VRZmJub2FmUG1wWkZyTE5Fa25hUT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 05:22:08.0143
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f04e2207-0c03-4b8b-2997-08dde9177f04
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9512

Modern AMD processors expose four additional extended LVT registers in
the extended APIC register space, which can be used for additional
interrupt sources such as instruction-based sampling and others.

To support this, introduce two new vCPU-based IOCTLs:
KVM_GET_EXT_LAPIC and KVM_SET_EXT_LAPIC. These IOCTLs works similarly
to KVM_GET_LAPIC and KVM_SET_LAPIC, but operate on APIC page with
extended APIC register space located at APIC offsets 400h-530h.

These IOCTLs are intended for use when extended APIC support is
enabled in the guest. They allow saving and restoring the full APIC
page, including the extended registers.

To support this, the `struct kvm_ext_lapic_state` has been made
extensible rather than hardcoding its size, improving forward
compatibility.

Documentation for the new IOCTLs has also been added.

For more details on the extended APIC space, refer to AMD Programmer’s
Manual Volume 2, Section 16.4.5: Extended Interrupts.
https://bugzilla.kernel.org/attachment.cgi?id=306250

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 Documentation/virt/kvm/api.rst  | 23 ++++++++++++++++++++
 arch/x86/include/uapi/asm/kvm.h |  5 +++++
 arch/x86/kvm/lapic.c            | 12 ++++++-----
 arch/x86/kvm/lapic.h            |  6 ++++--
 arch/x86/kvm/x86.c              | 37 ++++++++++++++++++++++++---------
 include/uapi/linux/kvm.h        | 10 +++++++++
 6 files changed, 76 insertions(+), 17 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6aa40ee05a4a..0653718a4f04 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2048,6 +2048,18 @@ error.
 Reads the Local APIC registers and copies them into the input argument.  The
 data format and layout are the same as documented in the architecture manual.
 
+::
+
+  #define KVM_APIC_EXT_REG_SIZE 0x540
+  struct kvm_ext_lapic_state {
+	__DECLARE_FLEX_ARRAY(__u8, regs);
+  };
+
+Applications should use KVM_GET_EXT_LAPIC ioctl if extended APIC is
+enabled. KVM_GET_EXT_LAPIC reads Local APIC registers with extended
+APIC register space located at offsets 400h-530h and copies them into input
+argument.
+
 If KVM_X2APIC_API_USE_32BIT_IDS feature of KVM_CAP_X2APIC_API is
 enabled, then the format of APIC_ID register depends on the APIC mode
 (reported by MSR_IA32_APICBASE) of its VCPU.  x2APIC stores APIC ID in
@@ -2079,6 +2091,17 @@ always uses xAPIC format.
 Copies the input argument into the Local APIC registers.  The data format
 and layout are the same as documented in the architecture manual.
 
+::
+
+  #define KVM_APIC_EXT_REG_SIZE 0x540
+  struct kvm_ext_lapic_state {
+	__DECLARE_FLEX_ARRAY(__u8, regs);
+  };
+
+Applications should use KVM_SET_EXT_LAPIC ioctl if extended APIC is enabled.
+KVM_SET_EXT_LAPIC copies input arguments with extended APIC register into
+Local APIC and extended APIC registers.
+
 The format of the APIC ID register (bytes 32-35 of struct kvm_lapic_state's
 regs field) depends on the state of the KVM_CAP_X2APIC_API capability.
 See the note in KVM_GET_LAPIC.
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 0f15d683817d..d26e1e1bf856 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -124,6 +124,11 @@ struct kvm_lapic_state {
 	char regs[KVM_APIC_REG_SIZE];
 };
 
+#define KVM_APIC_EXT_REG_SIZE 0x540
+struct kvm_ext_lapic_state {
+	__DECLARE_FLEX_ARRAY(__u8, regs);
+};
+
 struct kvm_segment {
 	__u64 base;
 	__u32 limit;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f92e3f53ee75..8bf7e0d33da9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -3058,7 +3058,7 @@ void kvm_apic_ack_interrupt(struct kvm_vcpu *vcpu, int vector)
 EXPORT_SYMBOL_GPL(kvm_apic_ack_interrupt);
 
 static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
-		struct kvm_lapic_state *s, bool set)
+		struct kvm_ext_lapic_state *s, bool set)
 {
 	if (apic_x2apic_mode(vcpu->arch.apic)) {
 		u32 x2apic_id = kvm_x2apic_id(vcpu->arch.apic);
@@ -3109,9 +3109,10 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
+int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_ext_lapic_state *s,
+		       unsigned int size)
 {
-	memcpy(s->regs, vcpu->arch.apic->regs, sizeof(*s));
+	memcpy(s->regs, vcpu->arch.apic->regs, size);
 
 	/*
 	 * Get calculated timer current count for remaining timer period (if
@@ -3122,7 +3123,8 @@ int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	return kvm_apic_state_fixup(vcpu, s, false);
 }
 
-int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
+int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_ext_lapic_state *s,
+		       unsigned int size)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	int r;
@@ -3137,7 +3139,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 		kvm_recalculate_apic_map(vcpu->kvm);
 		return r;
 	}
-	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
+	memcpy(vcpu->arch.apic->regs, s->regs, size);
 
 	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 	kvm_recalculate_apic_map(vcpu->kvm);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index a07f8524d04a..b411de5f33a3 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -122,9 +122,11 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high);
 
 int kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value, bool host_initiated);
-int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
-int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 void kvm_apic_update_hwapic_isr(struct kvm_vcpu *vcpu);
+int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_ext_lapic_state *s,
+		       unsigned int size);
+int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_ext_lapic_state *s,
+		       unsigned int size);
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
 
 u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e612a34779d7..b249e4c74063 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5131,25 +5131,25 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 }
 
 static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
-				    struct kvm_lapic_state *s)
+				    struct kvm_ext_lapic_state *s, unsigned int size)
 {
 	if (vcpu->arch.apic->guest_apic_protected)
 		return -EINVAL;
 
 	kvm_x86_call(sync_pir_to_irr)(vcpu);
 
-	return kvm_apic_get_state(vcpu, s);
+	return kvm_apic_get_state(vcpu, s, size);
 }
 
 static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
-				    struct kvm_lapic_state *s)
+				    struct kvm_ext_lapic_state *s, unsigned int size)
 {
 	int r;
 
 	if (vcpu->arch.apic->guest_apic_protected)
 		return -EINVAL;
 
-	r = kvm_apic_set_state(vcpu, s);
+	r = kvm_apic_set_state(vcpu, s, size);
 	if (r)
 		return r;
 	update_cr8_intercept(vcpu);
@@ -5872,10 +5872,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 {
 	struct kvm_vcpu *vcpu = filp->private_data;
 	void __user *argp = (void __user *)arg;
+	unsigned long size;
 	int r;
 	union {
 		struct kvm_sregs2 *sregs2;
-		struct kvm_lapic_state *lapic;
+		struct kvm_ext_lapic_state *lapic;
 		struct kvm_xsave *xsave;
 		struct kvm_xcrs *xcrs;
 		void *buffer;
@@ -5885,35 +5886,51 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 	u.buffer = NULL;
 	switch (ioctl) {
+	case KVM_GET_EXT_LAPIC:
 	case KVM_GET_LAPIC: {
 		r = -EINVAL;
 		if (!lapic_in_kernel(vcpu))
 			goto out;
-		u.lapic = kzalloc(sizeof(struct kvm_lapic_state), GFP_KERNEL);
+
+		if (ioctl == KVM_GET_EXT_LAPIC)
+			size = struct_size(u.lapic, regs, KVM_APIC_EXT_REG_SIZE);
+		else
+			size = sizeof(struct kvm_lapic_state);
+
+		u.lapic = kzalloc(size, GFP_KERNEL);
 
 		r = -ENOMEM;
 		if (!u.lapic)
 			goto out;
-		r = kvm_vcpu_ioctl_get_lapic(vcpu, u.lapic);
+		r = kvm_vcpu_ioctl_get_lapic(vcpu, u.lapic, size);
 		if (r)
 			goto out;
+
 		r = -EFAULT;
-		if (copy_to_user(argp, u.lapic, sizeof(struct kvm_lapic_state)))
+		if (copy_to_user(argp, u.lapic, size))
 			goto out;
+
 		r = 0;
 		break;
 	}
+	case KVM_SET_EXT_LAPIC:
 	case KVM_SET_LAPIC: {
 		r = -EINVAL;
 		if (!lapic_in_kernel(vcpu))
 			goto out;
-		u.lapic = memdup_user(argp, sizeof(*u.lapic));
+
+		if (ioctl == KVM_SET_EXT_LAPIC)
+			size = struct_size(u.lapic, regs, KVM_APIC_EXT_REG_SIZE);
+		else
+			size = sizeof(struct kvm_lapic_state);
+		u.lapic = memdup_user(argp, size);
+
 		if (IS_ERR(u.lapic)) {
 			r = PTR_ERR(u.lapic);
 			goto out_nofree;
 		}
 
-		r = kvm_vcpu_ioctl_set_lapic(vcpu, u.lapic);
+		r = kvm_vcpu_ioctl_set_lapic(vcpu, u.lapic, size);
 		break;
 	}
 	case KVM_INTERRUPT: {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f0f0d49d2544..e72e536e82bc 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1318,6 +1318,16 @@ struct kvm_vfio_spapr_tce {
 #define KVM_SET_FPU               _IOW(KVMIO,  0x8d, struct kvm_fpu)
 #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
 #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
+/*
+ * Added to save/restore local APIC registers with extended APIC (extapic)
+ * register space.
+ *
+ * Qemu emulates extapic logic only when KVM enables extapic functionality via
+ * KVM capability. In the condition where Qemu sets extapic registers, but KVM doesn't
+ * set extapic capability, Qemu ends up using KVM_GET_LAPIC and KVM_SET_LAPIC.
+ */
+#define KVM_GET_EXT_LAPIC	  _IOR(KVMIO,  0x8e, struct kvm_ext_lapic_state)
+#define KVM_SET_EXT_LAPIC	  _IOW(KVMIO,  0x8f, struct kvm_ext_lapic_state)
 #define KVM_SET_CPUID2            _IOW(KVMIO,  0x90, struct kvm_cpuid2)
 #define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
 /* Available with KVM_CAP_VAPIC */
-- 
2.43.0


