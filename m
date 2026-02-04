Return-Path: <kvm+bounces-70149-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iNvdIj35gmm2fwMAu9opvQ
	(envelope-from <kvm+bounces-70149-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:46:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 28891E2C9F
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:46:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4A8CF303A8D1
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 07:45:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7792389E14;
	Wed,  4 Feb 2026 07:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="y9cl84RF"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010019.outbound.protection.outlook.com [52.101.46.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D685D2DECBA
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 07:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770191131; cv=fail; b=i5NhWHd6y4A6yov2XHYyz949dB/fWR0w4/8v0ougupZzYqpJ/As8GYnLaABKCDUUv7/GQa/ezEBuJGymSy4i8X5w3rD+lTezuNxwZgRYeVU1FPZ/3hhydBCw68pEgTNvHNGLewBevMKluG/tplkaiw25Jy31oXCtJHhy/BYm49U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770191131; c=relaxed/simple;
	bh=666ErxLAazHt+vNUUyUtOCW2mgJb9uHVq1CIOBET0xo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S3lCMeWugYwuEyBx3GokqZKITpWJqRfk6hUhZ61awGvmjrs9dC4rG6wWbbohYVvSRb8JhsEiHagEg+9V8Bn4kE3mQvY7SPSK6LBs/8ALAQfJqeFV+lLJckFvT9A1nz14yxwtB0nwJXTB72z/7GUTynB7rhAZvY8YS18ZkXAJPLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=y9cl84RF; arc=fail smtp.client-ip=52.101.46.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yON2fkKc7E99H4NhcQzWhHjXbTnGgwgxycOsE8ldxCJ8FS8+9OdVZ1xqBZsMYFc2ayJdd9a6GKKGYtnSwxJlNRj/oOhpvnK8LlYzm4MWuGouFjl2WIQjQJf4AagR3O7Rr9+agVTdjQqX9TTcVvZU8h6P8TfWe8eBvCABlFW37MVu03DTl8cO5XM+Env4MjD8LO4O5FlOwUy4QV0S40kyqRANGcIcr6VESlwwLT1x9KjqyXz+SNvv+6u0l2QkoSr1OSP2feKGdvQfeHVvT45b7qkq3va9rx91tjWLfGtH10v74jHkhA532PTeMi04wFtEj5J4jjFQjYAUNdHytgt9uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DVIHVcrJkJK4VEBJZgyOKfCW9fE53sxjPdTuemanOGM=;
 b=R4aSNg2oPsMj6hwA70ZR9q4v+daqAIczQsVtSDFYb+ithLOvmeX/98pFTb0hIJZL4Dbp6PedjkGJcgwK9nTqR/81qG8Khba/CWQZvgjcnnCpFBCaqA1+AXDZEn0th6A1RMcPWu4DM53/1A5XM6WIfBAj+ThNzuYuy7qD6NsKV4UKVBVl6f5S7cqme7A1kcArUfwZw2A1u3x3zvqSKsYDRqsVfdiVakDuBbK7G15FuJYGgMnjSEKTX6uBScUkoY91xqNz0x8ml/4QDzEe2RKA9QSi9tq8lba9sE+FG1/c1QNG8KBYPG/zqtGfbUjBGu/XKDU5z0/UcUn1i+PSur1aRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DVIHVcrJkJK4VEBJZgyOKfCW9fE53sxjPdTuemanOGM=;
 b=y9cl84RFpa4zjW/bG+SI3nOFAr40iSr71wKBa+6gpN1KN/iHzis59HvIeLXniubK03AyB5fRgi7Dy2D9IxwJFpeEz0nRT73+1BaMDwbRy1vbRO3rvGl5HylvSKb2TSaULsQFJOORwbKTL7WyoVxK8PfwjXckDiGaKjG8hBhwylo=
Received: from SA0PR11CA0117.namprd11.prod.outlook.com (2603:10b6:806:d1::32)
 by CH3PR12MB7617.namprd12.prod.outlook.com (2603:10b6:610:140::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Wed, 4 Feb
 2026 07:45:27 +0000
Received: from SN1PEPF0002636D.namprd02.prod.outlook.com
 (2603:10b6:806:d1:cafe::a5) by SA0PR11CA0117.outlook.office365.com
 (2603:10b6:806:d1::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.12 via Frontend Transport; Wed,
 4 Feb 2026 07:45:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002636D.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Wed, 4 Feb 2026 07:45:26 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 4 Feb
 2026 01:45:23 -0600
From: Manali Shukla <manali.shukla@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <Naveen.Rao@amd.com>,
	<dapeng1.mi@linux.intel.com>, <manali.shukla@amd.com>
Subject: [PATCH v1 4/9] KVM: x86: Introduce KVM_CAP_LAPIC2 for 4KB APIC register space support
Date: Wed, 4 Feb 2026 07:44:47 +0000
Message-ID: <20260204074452.55453-5-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260204074452.55453-1-manali.shukla@amd.com>
References: <20260204074452.55453-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636D:EE_|CH3PR12MB7617:EE_
X-MS-Office365-Filtering-Correlation-Id: fd8a305f-960d-45c6-20be-08de63c15cc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Vizf+IPp/Uo3PBvvVWtCvVrUAzm1iUCncxdbqUJa2zjifMz8q6BA4s3lSMJ1?=
 =?us-ascii?Q?bA+rH4khP5qbPMWr2zybX7DFubRHxTUSwu/vaFvpg9yME+m+I6SnfcxEz7cI?=
 =?us-ascii?Q?IZelBsN1GBGYYxEP/Z1XU07tWiIIgzObJGmHOGEMtCEyH1X6450c6HRsV3En?=
 =?us-ascii?Q?U9iUYyfrL8/paF2PUT2qTumX6AG8Ww2GRL02GaRshZyeU7u13+TrOSxlKfHV?=
 =?us-ascii?Q?ayyOphMCuOpfSBqBmM8Ah55cabXFP54sSviJky+6Qgosnb9FkdGHxiOIZ4O6?=
 =?us-ascii?Q?f8BZyW/cVxRKKBak+xZgMrayKxJGKdGqjH19A03Te7ghvUBxDAuragwWWKg+?=
 =?us-ascii?Q?B0x3SwA57ZlYNvUKI8FHu/vMtIiw5NhiMM8mvfrXA09mnbrmyEtQ7wsf/nOp?=
 =?us-ascii?Q?rRF9FQVfY0bPkzV/k+AhKB3Xtlw0YDSJuYpVhOjOgmkJkhMc6pa0JDXJc8Ex?=
 =?us-ascii?Q?m8jnTaZ/K+cL+lbNCefg2/dlNBfEGwrSCPeAyimg0t06tGRkwQS9Wk25Rak/?=
 =?us-ascii?Q?AnT+tqYw6bZgfBPLZoS7i2HFw/G3u7JZ68dT8f8VMC5cBOFAxjVu3nMn1Wuq?=
 =?us-ascii?Q?w3Krp5oWvBNgxGcWqD9wzxCSnauFzvX7K6DKPK84ladbk1mXgVFXNWZsd0RG?=
 =?us-ascii?Q?Glg3v5Q+iwexv/UUVK2r1GIqhsj3S85xHajEoxS2kE7pBP/aQ2glEeHWgYcp?=
 =?us-ascii?Q?Z44sy/MIA5yEhlT7N8wdjQsrSOXscSn4dBe4axZElV+ousfEmEBr4gXsoPBx?=
 =?us-ascii?Q?EveTw31jVaxcgbQ6mkFCBMwV1SK9NFBMQmz8jNMAiSc2tsDKquyD6TccJ0i6?=
 =?us-ascii?Q?P1mJs+H2akOPkGRZFQ1cEIWRWyJR4k84rOtHvjW7A7uHmYyCe3Cka8XXxjvo?=
 =?us-ascii?Q?CQtWVvSK+ZnI2suUoPAyv8HVtR8P3IXlkES7zL4z0dWQ0Kkk68lUJKjLtgCL?=
 =?us-ascii?Q?fbj3cxt0WDQT4lnwylUr/BpagHjqR9OMpglGTB0X5b/slv/SMEHPJArptNxZ?=
 =?us-ascii?Q?IwTGOqmEQOmXnaIFfbA26mGRuxLPMdk088TzHLrld6F2meXgiq7HnN4UmmeK?=
 =?us-ascii?Q?UD7X6fVQon60GihVGbk9HCp3wogdnNbLj/SnVBPI5hCv+o0lL+4ECZJ2bcMg?=
 =?us-ascii?Q?IZdFXK48Crxxe/C9pCIkc+6A1OIWqOln4wPYRTa+nxja1Sa1duHzMixp7tna?=
 =?us-ascii?Q?ZrJzjHkrhbVI4+0g5TfMOGwi1XZgXz/+kKHwabkY5PP0vsJa80sYpwLSSTei?=
 =?us-ascii?Q?RtqJxv5LC4pJtAy0aDr1lYjXzyroG8VL+i2GzsDfm7U+T61Fa+52WgTLXk17?=
 =?us-ascii?Q?GKo6GUFMJdhJzlZ6WSKSxNg6LdG0JfGZhMaNA9xJ4GVbFo/dsI/sfizX+Ndv?=
 =?us-ascii?Q?ZRBREYLU8pegqq28idpTnlE7mgB1MfsnZw6cqjzq7JJvhTtKjLFQDY8Vfx1g?=
 =?us-ascii?Q?5zdP1RH8FUZQt5LowfLYwDYnf0CFcSiPR7kXbV2B2dOd4L8xv+1b+WFKwbCJ?=
 =?us-ascii?Q?ZeownPsVsoxFDpyrP10DEAubLyV78KVX+MZC2BIZwYD3MSQTJbzpsArqyVli?=
 =?us-ascii?Q?qp5SqrfB7StX86/0dw/O7FAwKDGrvlEFb+N95Yi/zeIAYCcTpI3riAvDto+7?=
 =?us-ascii?Q?iPkHZyM1jp8k1cFN0HhKTJmyWb8enI6wSx4eZMH79sD/2JevgrpW6Mi4hDZ0?=
 =?us-ascii?Q?A1xyPw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1VrjvWVtM5fmYca1YeA7wIxvukJUCVi/bHinfkUBhvkrs5wi1A+3WlRF9sLRyxwjas43sLokoH8/ZtlLK9i8TdX5uSW0GJypb1GvlLMHkrAvgaC/CPxp9coMsRFenmiKe2cq8F5NjsMtR38ILI8v6C0Eionc7Qt4CKHPMHzijBECwoFe9eiBJ6uTftmcxL7hfzd41fOZ848MMcIQ/i3tzT436vVieZek5crYyb1EHGT9qzkkY0MyvEfqUoCvdI0tG9bw9sAIOPkmQB9qYXIXE/xYOQovfxvAMIfxfekIENqugLNExfiyJIqENq3W51CrZ6XjBtMTqG13hfpTOQE+C9vJIkv5FQd99LTdRP/ZPdSExDeOedDIBGjFGHJYSe8R7OfV5eneUMc+EJt7whzeYi7z6Fza9Esux5XtbOmfbk7lcYBUEjUKIGZPWLLzaMvK
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 07:45:26.8653
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd8a305f-960d-45c6-20be-08de63c15cc2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7617
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70149-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[manali.shukla@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,amd.com:dkim,amd.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 28891E2C9F
X-Rspamd-Action: no action

Add KVM_CAP_LAPIC2 to allow userspace to opt into extended APIC register
space, i.e. to expose the full 4KB APIC page to the guest.  Extended LVT
registers are part of the 4KB APIC page and are AMD-specific. Extended
APIC registers provide additional interrupt vectors for hardware features
like Instruction Based Sampling (IBS).

Use a capability negotiation model to allow for future extensibility.
KVM_CHECK_EXTENSION returns a bitmask of supported capabilities, and
userspace enables the intersection of KVM and VMM support via
KVM_ENABLE_CAP.  This allows KVM and userspace to independently add
support for new APIC configurations without breaking compatibility.

Define two capability flags:
  - KVM_LAPIC2_DEFAULT: full 4KB APIC page support
  - KVM_LAPIC2_AMD_DEFAULT: extended LVT registers are supported

Require that the capability be enabled before vCPUs are created to avoid
the need to handle runtime changes to the APIC page size.

When KVM_LAPIC2_AMD_DEFAULT is enabled, set kvm->arch.nr_extlvt to
KVM_X86_NR_EXTLVT_DEFAULT (4) to track the number of extended LVT
registers available to the guest.  Future patches will use nr_extlvt to
emulate guest accesses to extended LVT registers at APIC offset 0x500.

Suggested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 Documentation/virt/kvm/api.rst  | 31 +++++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 30 ++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h        |  5 +++++
 4 files changed, 67 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 01a3abef8abb..71b4d24f009a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -9291,6 +9291,37 @@ KVM exits with the register state of either the L1 or L2 guest
 depending on which executed at the time of an exit. Userspace must
 take care to differentiate between these cases.
 
+8.46 KVM_CAP_LAPIC2
+---------------------------
+
+:Architectures: x86
+:Target: VM
+:Parameters: args[0] is a bitmask of LAPIC2 capabilities
+:Returns: 0 on success, -EINVAL when arg[0] contains invalid bits
+
+This capability indicates that KVM supports extended APIC register space of the
+whole 4KB page.
+
+Calling KVM_CHECK_EXTENSION for this capability returns a bitmask of LAPIC2
+capabilities that can be enabled on a VM.
+
+The argument to KVM_ENABLE_CAP is also a bitmask that selects which LAPIC2
+capabilities to enable for the VM.  Userspace should enable the intersection
+of capabilities supported by KVM (from KVM_CHECK_EXTENSION) and capabilities
+supported by the VMM.  This must be called before creating any VCPUs.
+
+At this time, KVM_LAPIC2_DEFAULT and KVM_LAPIC2_AMD_DEFAULT are the supported
+capabilities:
+
+  - KVM_LAPIC2_DEFAULT: Full 4KB APIC page support
+  - KVM_LAPIC2_AMD_DEFAULT: Extended LVT registers are supported (they are part
+    of 4KB APIC page)
+
+KVM_LAPIC2_AMD_DEFAULT is available on AMD processors with ExtApicSpace feature
+(CPUID 8000_0001h.ECX[3]). Extended APIC registers start at APIC offset 400h.
+Currently 4 extended LVT registers are supported, used for features like
+Instruction Based Sampling (IBS), but future processors may support more.
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index df642723cea6..5a659982aebd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1460,6 +1460,7 @@ struct kvm_arch {
 	u32 default_tsc_khz;
 	bool user_set_tsc;
 	u64 apic_bus_cycle_ns;
+	u8 nr_extlvt;
 
 	seqcount_raw_spinlock_t pvclock_sc;
 	bool use_master_clock;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8acfdfc583a1..368ee9276366 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4990,6 +4990,18 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_READONLY_MEM:
 		r = kvm ? kvm_arch_has_readonly_mem(kvm) : 1;
 		break;
+	case KVM_CAP_LAPIC2: {
+		u8 max_extlvt;
+
+		r = KVM_LAPIC2_DEFAULT;
+		if (!kvm_caps.has_extapic)
+			break;
+
+		max_extlvt = kvm_cpu_get_max_extlvt();
+		if (max_extlvt == KVM_X86_NR_EXTLVT_DEFAULT)
+			r |= KVM_LAPIC2_AMD_DEFAULT;
+		break;
+	}
 	default:
 		break;
 	}
@@ -6966,6 +6978,24 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		mutex_unlock(&kvm->lock);
 		break;
 	}
+	case KVM_CAP_LAPIC2: {
+		r = -EINVAL;
+
+		mutex_lock(&kvm->lock);
+
+		kvm->arch.nr_extlvt = 0;
+
+		if (!kvm->created_vcpus) {
+			if (cap->args[0] & KVM_LAPIC2_DEFAULT) {
+				r = 0;
+				if (cap->args[0] & KVM_LAPIC2_AMD_DEFAULT)
+					kvm->arch.nr_extlvt = KVM_X86_NR_EXTLVT_DEFAULT;
+			}
+		}
+
+		mutex_unlock(&kvm->lock);
+		break;
+	}
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 76bd54848b11..cb27eeb09bdb 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -659,6 +659,10 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
 #define KVM_X86_DISABLE_EXITS_APERFMPERF     (1 << 4)
 
+#define KVM_X86_NR_EXTLVT_DEFAULT		4
+#define KVM_LAPIC2_DEFAULT			(1 << 0)
+#define KVM_LAPIC2_AMD_DEFAULT			(1 << 1)
+
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
 	/* in */
@@ -978,6 +982,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_GUEST_MEMFD_FLAGS 244
 #define KVM_CAP_ARM_SEA_TO_USER 245
 #define KVM_CAP_S390_USER_OPEREXEC 246
+#define KVM_CAP_LAPIC2 247
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.43.0


