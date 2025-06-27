Return-Path: <kvm+bounces-51014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CBE11AEBD36
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 18:27:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 234B956204B
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 16:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 566A92EA74C;
	Fri, 27 Jun 2025 16:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RLhGZPZa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2080.outbound.protection.outlook.com [40.107.102.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11C92E9ECE;
	Fri, 27 Jun 2025 16:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751041588; cv=fail; b=SXhuKX6vdLnCQFrhrjbKMhHwyhAy0T0hG/MbYVI14a0uuEGKgaxYrlnznQC9DkLJ/2XGz2tOJ8jvKpnXeQBG9/6PfMrcDIR7LeVuM2+ThHNpy5CZnWP6rzZxqC0LvZLsLbV+uJFjdFYDenxQovF551DeiC3vAC1gQdztYjtyskk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751041588; c=relaxed/simple;
	bh=5YFTM3j4z6IIV3kgH4kVW0nRUcJy6lrUzWim6/LqDFY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y5nfQ1oC0qvSG8m/zlWAlcNBpxz6cDns/X4QCJea+XRrow2s/lvw/uij3+Si37BYX7EN9o+PrBq0EfVUbWx8MeHwdU7TdT0QAH+OBpW+nl4QZ4232hu/QOFhcI6c0b55Wg6NTdlrE2mq8x+gNltWQgw+L7KuXyWb9cktg3QFnMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RLhGZPZa; arc=fail smtp.client-ip=40.107.102.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ejbS16hJSZ2duQ0tU/x6bTzhJ1yWILdAUd5gBReaXbCxx6Dj2PSF+1/C3z1U1poBrgTsa1Wv0gPBiSObd8vAJlUTXaq6onxAutRVY8TFvVBn+ZYS1qplc7If0s9YSteIIy765SvzxPgo16mHZZOzuekBaQUm4dpAM5Dd2UhzPioOtlFN28tCD69ZhsBMe+nyOz9cD14ZHxvnFFj0LDpGfPHnP417MnHIV3p6qkVnzbV9HfrJ7IWGR57uTH79x5AwMvrRkqpkRPga5SSCLSziWWwStI6Y4kbGJKgjNOcs5B/YXejvzW9Unk4yyFcCObBok4Re1+CgNmlG8wN35hms6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ozMJOMMY7hQ9bCxEQRo4CdWxIWUu0z1dGiDg+kzuyk=;
 b=dnIAvUoVKmUrkieq7Rxt90pVgkJNRupTyE5+Poqw8h3xcViVL1pJ/UZzN9A3Wfnj5uYNkbpxHHv4PHwDTLlhwM9dhVXmysyWknKolDg8zUR+sTzYddD5FZXOS7OKZOOE8JU8Yzn6IWD939j3BKDKF/demOm4RfGnXrrUINJUEn6jX3XX3y6U+1Uw6Sz2Lf28eByc6HcNSDYzNZq91Fs/5wRdgBhD1QXKh/BWT9QmCCYo8DCqv86UVb5rhuD7kHlD6yCTo+OLiz948Ihu6xAE93CTPORskOtqTG+ZNc16+81aLtd7uEnQwlfFmWgxLebWAxOvsFzhneHHbHc+iJofjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ozMJOMMY7hQ9bCxEQRo4CdWxIWUu0z1dGiDg+kzuyk=;
 b=RLhGZPZa+VK7orNRBxR2FNGic42c7+WjiwDV8fFMYLZzrcoJmY23Wk/9UOO+C4i5AAYFjzgmoVqye39S3T7RVJUbOBOCgSxBJhfo04Q1Q4m0vK7nxlgxq2jjDLgwZv3IK4bpEQb5kJGuIfTAHP26Ofaf7r6gnv0lAn40+j3c4Hg=
Received: from SN6PR05CA0007.namprd05.prod.outlook.com (2603:10b6:805:de::20)
 by CYYPR12MB8749.namprd12.prod.outlook.com (2603:10b6:930:c6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Fri, 27 Jun
 2025 16:26:24 +0000
Received: from SN1PEPF000397B3.namprd05.prod.outlook.com
 (2603:10b6:805:de:cafe::ae) by SN6PR05CA0007.outlook.office365.com
 (2603:10b6:805:de::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.11 via Frontend Transport; Fri,
 27 Jun 2025 16:26:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000397B3.mail.protection.outlook.com (10.167.248.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8880.14 via Frontend Transport; Fri, 27 Jun 2025 16:26:23 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 27 Jun
 2025 11:26:18 -0500
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v1 02/11] KVM: Add KVM_GET_LAPIC_W_EXTAPIC and KVM_SET_LAPIC_W_EXTAPIC for extapic
Date: Fri, 27 Jun 2025 16:25:30 +0000
Message-ID: <20250627162550.14197-3-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250627162550.14197-1-manali.shukla@amd.com>
References: <20250627162550.14197-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B3:EE_|CYYPR12MB8749:EE_
X-MS-Office365-Filtering-Correlation-Id: f268e432-1370-42e9-385d-08ddb5975bb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?enFoTHhKaW1HSnVYL0REVDVDYjdXK1dOb1hIWVNYNGRWajczdDh6Mmpuc0wx?=
 =?utf-8?B?SGpJT3hMOUpSRHZCV0NYYjJrNWNZWlNNd29PNFBIRnBuYnAvUmUzUDl0dElo?=
 =?utf-8?B?b1NIVFBEaUtRY3VSYUFwdWdTMlhobG9lYytYaTFIQVcyS3RSRHpVYStiL281?=
 =?utf-8?B?V2NnTXR0RmsxdEsrUGljaC9kRCtGYTBwL3dYYjRnWFFjdTFVM2kvWFZBWDE5?=
 =?utf-8?B?VjZ1THVsdHluSnZZdFVGVEhnSUVpeGVpNnBiMTJnOUZqeWRFZDNDQmkrQVAz?=
 =?utf-8?B?OXZyUGVhTmlPODZNODRkWmk1dkdia1lHaU1zWnh1UUUxejlwSndlQW53MWZs?=
 =?utf-8?B?TTlaQ1NSNm5UaTdNdW9PRHBzNmN4Zm5BMDgrelc2YzFFZmd1K0tYL0xBMjZV?=
 =?utf-8?B?d1JvRkJHLzRjaTdQaGEwbUFEOFg4Qy9YeWxta2pIQitycktPNU5HRkFMRy9D?=
 =?utf-8?B?bFBqaSszaU45TEIvWFA2UFQ4Qks5d3AvWHZ5WFJOWjZ4QVR3YjUrUDNpenI3?=
 =?utf-8?B?aHB3NEtUUERCdUJma0F3eW82NER6cUdNU0xzV1F1Zmhoai8rTDBwcE1HTDN4?=
 =?utf-8?B?UThaSk1vd2svK1I0MkRSYitrQm53R2FkWXNrSnlGQVpzOWFScE5JcElXQVpr?=
 =?utf-8?B?SWs0N0VpY2dQUXlOZUJ1MVFYS1JpUnhnaGhac2tSa24vZ1M0TG4yMVNndWs1?=
 =?utf-8?B?cFFJK1hTNU5LcnVpU1NrSklpUXMzbWMyVjBGZURudmYvL3FaTDJCci9ObFZl?=
 =?utf-8?B?U1JLb3RqUnBMTTBZbHVjUHNVNklyU3ZIaENhZ1JFZVZNRDIwQmxwNEFldlBS?=
 =?utf-8?B?OHdVWEgxZERvZzI0aGVjaktwV2JkVDBXaUdyQmg2V0hCaW9DdzZNWkVqSzYv?=
 =?utf-8?B?clNseThCeFlqU2JtWklFOURzSnpYRGxLYUFKbWZGS1J4OEVpbCtBYzRaQzJy?=
 =?utf-8?B?YUtMYXB1R2dKL0JIQ052SXJGN0VqR2VhaVl6UW9sR2JucUdvNFNIaDhLQVZl?=
 =?utf-8?B?M2JqbWlpcjQrQ0UyZXdGYW5ZdFVzdVRDUVVPdzVyTUg2YTJDVGduQmswSWlR?=
 =?utf-8?B?UHpESEI2cEc4Q2NNaG1HOEJ4MEt3NWZmUDhIN2VIWG5KMnlzaW1qdzB4VWxh?=
 =?utf-8?B?SS80aUZqUnFWMmJhbmFiUUhWUlpwWmZwOHFxdWZ2VTNVVDNEcVkvNjhKaUxR?=
 =?utf-8?B?WmxqeUYzQUN3eUJZQ0hKOVoxZEdVRXNnOWN1em5GTFF1RVpDL1RIL2tTcTJR?=
 =?utf-8?B?ZGltTnp5L0JwbDdvSEtLNTVLc1N0cHZ6cG8vMElWMFFSZlZ1Q1JqcHYrb3Js?=
 =?utf-8?B?eVdPWlBxUWVTZTZZTnp2UFdSWUVDNEtYWjVRT0VlUVJ6ZTZSV0tnOGU0Wk96?=
 =?utf-8?B?V1RwK2J5Ump1c3NJZ2REMVM2ek9qQXo4OGZWM3R2WXN5UnRjbU5iMlRwVDdI?=
 =?utf-8?B?c3k2SnFMYXBUUnhIVStiU3FOelJQNUVCQ3lFWTE3bjQ4UWIyVTRpUWxITnBh?=
 =?utf-8?B?VUl1WlIwYWhwd29XaVNKVEdUTWJMSDhVRjYrU2dRZmdsMW9YQWdiZHFBZUZD?=
 =?utf-8?B?dC96WVR3VU5IcisrRzl0S1RhZjZFWjUwR0FpODdXRUNTdTBYRTJHSmZWKzZ4?=
 =?utf-8?B?bnFHelNxSUNQRU96MlR0L2xRNTRZM0V4QWYrUnQ3TjlJTVcxaUh5K1B4dGVO?=
 =?utf-8?B?ZWN1a0RNYThDelgxUGg1dEtPMm1sRmNWVGZlZ2tteUtBeHdoNndhbXUrbHpo?=
 =?utf-8?B?MmFDNmxZcFJCcmRRUE04MTRZYzA0VzRvMVZhc1NES2ZiK1hHSTgvNVpmcU85?=
 =?utf-8?B?SXBlM0UwN2s0ME8zSjhEQ2JnclFMSHJOMjhVSVUzZnQ1NjlSQmVrcEFWcjZW?=
 =?utf-8?B?blVhY3lQejNVV010dWxYemJLcGpoMEdDci9Ba3dWd0IrYXh5cnl4cWlVeWI4?=
 =?utf-8?B?RC9jSlR4L1g5R09Yb1U3K0pGMzZrZTl6YUpGU3YwdWpLOFhLdUhMMk9QOHY0?=
 =?utf-8?B?WUFKellqOFpBWE5qV0dnTHFEc2kwUGJzSmQ2UHh0WVU2ZVF0ZnIrR2NKRFFQ?=
 =?utf-8?B?MVRCZDdRN0RRSEZOdUlrQklIWlA4L2t6ZlJvUT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 16:26:23.9107
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f268e432-1370-42e9-385d-08ddb5975bb5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8749

Modern AMD processors expose four additional extended LVT registers in
the extended APIC register space, which can be used for additional
interrupt sources such as instruction-based sampling and others.

To support this, introduce two new vCPU-based IOCTLs:
KVM_GET_LAPIC_W_EXTAPIC and KVM_SET_LAPIC_W_EXTAPIC. These IOCTLs works
similarly to KVM_GET_LAPIC and KVM_SET_LAPIC, but operate on APIC page
with extended APIC register space located at APIC offsets 400h-530h.

These IOCTLs are intended for use when extended APIC support is
enabled in the guest. They allow saving and restoring the full APIC
page, including the extended registers.

To support this, the `struct kvm_lapic_state_w_extapic` has been made
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
index 1bd2d42e6424..0ca11d43f833 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2041,6 +2041,18 @@ error.
 Reads the Local APIC registers and copies them into the input argument.  The
 data format and layout are the same as documented in the architecture manual.
 
+::
+
+  #define KVM_APIC_EXT_REG_SIZE 0x540
+  struct kvm_lapic_state_w_extapic {
+	__DECLARE_FLEX_ARRAY(__u8, regs);
+  };
+
+Applications should use KVM_GET_LAPIC_W_EXTAPIC ioctl if extended APIC is
+enabled. KVM_GET_LAPIC_W_EXTAPIC reads Local APIC registers with extended
+APIC register space located at offsets 400h-530h and copies them into input
+argument.
+
 If KVM_X2APIC_API_USE_32BIT_IDS feature of KVM_CAP_X2APIC_API is
 enabled, then the format of APIC_ID register depends on the APIC mode
 (reported by MSR_IA32_APICBASE) of its VCPU.  x2APIC stores APIC ID in
@@ -2072,6 +2084,17 @@ always uses xAPIC format.
 Copies the input argument into the Local APIC registers.  The data format
 and layout are the same as documented in the architecture manual.
 
+::
+
+  #define KVM_APIC_EXT_REG_SIZE 0x540
+  struct kvm_lapic_state_w_extapic {
+	__DECLARE_FLEX_ARRAY(__u8, regs);
+  };
+
+Applications should use KVM_SET_LAPIC_W_EXTAPIC ioctl if extended APIC is enabled.
+KVM_SET_LAPIC_W_EXTAPIC copies input arguments with extended APIC register into
+Local APIC and extended APIC registers.
+
 The format of the APIC ID register (bytes 32-35 of struct kvm_lapic_state's
 regs field) depends on the state of the KVM_CAP_X2APIC_API capability.
 See the note in KVM_GET_LAPIC.
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 6f3499507c5e..91c3c5b8cae3 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -124,6 +124,11 @@ struct kvm_lapic_state {
 	char regs[KVM_APIC_REG_SIZE];
 };
 
+#define KVM_APIC_EXT_REG_SIZE 0x540
+struct kvm_lapic_state_w_extapic {
+	__DECLARE_FLEX_ARRAY(__u8, regs);
+};
+
 struct kvm_segment {
 	__u64 base;
 	__u32 limit;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 73418dc0ebb2..00ca2b0faa45 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -3046,7 +3046,7 @@ void kvm_apic_ack_interrupt(struct kvm_vcpu *vcpu, int vector)
 EXPORT_SYMBOL_GPL(kvm_apic_ack_interrupt);
 
 static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
-		struct kvm_lapic_state *s, bool set)
+		struct kvm_lapic_state_w_extapic *s, bool set)
 {
 	if (apic_x2apic_mode(vcpu->arch.apic)) {
 		u32 x2apic_id = kvm_x2apic_id(vcpu->arch.apic);
@@ -3097,9 +3097,10 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
+int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state_w_extapic *s,
+		       unsigned int size)
 {
-	memcpy(s->regs, vcpu->arch.apic->regs, sizeof(*s));
+	memcpy(s->regs, vcpu->arch.apic->regs, size);
 
 	/*
 	 * Get calculated timer current count for remaining timer period (if
@@ -3111,7 +3112,8 @@ int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	return kvm_apic_state_fixup(vcpu, s, false);
 }
 
-int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
+int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state_w_extapic *s,
+		       unsigned int size)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	int r;
@@ -3126,7 +3128,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 		kvm_recalculate_apic_map(vcpu->kvm);
 		return r;
 	}
-	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
+	memcpy(vcpu->arch.apic->regs, s->regs, size);
 
 	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 	kvm_recalculate_apic_map(vcpu->kvm);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 4518b4e0552f..7ad946b3738d 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -120,9 +120,11 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high);
 
 int kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value, bool host_initiated);
-int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
-int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 void kvm_apic_update_hwapic_isr(struct kvm_vcpu *vcpu);
+int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state_w_extapic *s,
+		       unsigned int size);
+int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state_w_extapic *s,
+		       unsigned int size);
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
 
 u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c880a512005e..c273bbbbbcc6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5156,25 +5156,25 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 }
 
 static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
-				    struct kvm_lapic_state *s)
+				    struct kvm_lapic_state_w_extapic *s, unsigned int size)
 {
 	if (vcpu->arch.apic->guest_apic_protected)
 		return -EINVAL;
 
 	kvm_x86_call(sync_pir_to_irr)(vcpu);
 
-	return kvm_apic_get_state(vcpu, s);
+	return kvm_apic_get_state(vcpu, s, size);
 }
 
 static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
-				    struct kvm_lapic_state *s)
+				    struct kvm_lapic_state_w_extapic *s, unsigned int size)
 {
 	int r;
 
 	if (vcpu->arch.apic->guest_apic_protected)
 		return -EINVAL;
 
-	r = kvm_apic_set_state(vcpu, s);
+	r = kvm_apic_set_state(vcpu, s, size);
 	if (r)
 		return r;
 	update_cr8_intercept(vcpu);
@@ -5903,10 +5903,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 {
 	struct kvm_vcpu *vcpu = filp->private_data;
 	void __user *argp = (void __user *)arg;
+	unsigned long size;
 	int r;
 	union {
 		struct kvm_sregs2 *sregs2;
-		struct kvm_lapic_state *lapic;
+		struct kvm_lapic_state_w_extapic *lapic;
 		struct kvm_xsave *xsave;
 		struct kvm_xcrs *xcrs;
 		void *buffer;
@@ -5916,35 +5917,51 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 	u.buffer = NULL;
 	switch (ioctl) {
+	case KVM_GET_LAPIC_W_EXTAPIC:
 	case KVM_GET_LAPIC: {
 		r = -EINVAL;
 		if (!lapic_in_kernel(vcpu))
 			goto out;
-		u.lapic = kzalloc(sizeof(struct kvm_lapic_state), GFP_KERNEL);
+
+		if (ioctl == KVM_GET_LAPIC_W_EXTAPIC)
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
+	case KVM_SET_LAPIC_W_EXTAPIC:
 	case KVM_SET_LAPIC: {
 		r = -EINVAL;
 		if (!lapic_in_kernel(vcpu))
 			goto out;
-		u.lapic = memdup_user(argp, sizeof(*u.lapic));
+
+		if (ioctl == KVM_SET_LAPIC_W_EXTAPIC)
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
index d00b85cb168c..cf23c1b52c49 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1290,6 +1290,16 @@ struct kvm_vfio_spapr_tce {
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
+#define KVM_GET_LAPIC_W_EXTAPIC   _IOR(KVMIO,  0x8e, struct kvm_lapic_state_w_extapic)
+#define KVM_SET_LAPIC_W_EXTAPIC   _IOW(KVMIO,  0x8f, struct kvm_lapic_state_w_extapic)
 #define KVM_SET_CPUID2            _IOW(KVMIO,  0x90, struct kvm_cpuid2)
 #define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
 /* Available with KVM_CAP_VAPIC */
-- 
2.43.0


