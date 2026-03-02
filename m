Return-Path: <kvm+bounces-72417-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mNOQAzMNpmmFJgAAu9opvQ
	(envelope-from <kvm+bounces-72417-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 23:20:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E68E1E534E
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 23:20:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8FE36317FC28
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 21:45:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 778273909AE;
	Mon,  2 Mar 2026 21:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qfuU1v5i"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011065.outbound.protection.outlook.com [52.101.62.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCA2332914;
	Mon,  2 Mar 2026 21:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772487339; cv=fail; b=f91B3T48JUMDPsuST0rmK0WUXAIoF8Fc3UTP8HbeRWdTqpW9LET6/HS72TAndEXJo+KSP04Xi240dH2n08xXEdCLMMJcC/exB7Tm4UXXgDYGdiD0v/dxNKCKex1iHZWtkxaazyD82mHCjgXnYPvoJSsaOQPIp1c9yVbreTAJeLs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772487339; c=relaxed/simple;
	bh=zKj5G2hOoAJdDqX0V21QZ7oTPKuHy7FMONC77bYASwo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RGkPONtuleMMolYabXp7kh90ed5/Ixnqst5qdxV7Hmoy/EopoFngVcvQ0Lm3mGNf3kSFNIhCWgvSd0CGShuK2D/4NgteOniVgv9MN0MYguKTPOQX6HS0DV+9pV7HNKZOXp4JC2rvIjtaMzoSO3gxf+EprMGpz3E6mtfEpgnJWQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qfuU1v5i; arc=fail smtp.client-ip=52.101.62.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ct/fSZnDSG8UvoElijrcuL/SjEg5ZbwBBoTN6IKQhagBGFC2Bhc25VKh0M25AlDC4nL16s+Wln62MBHMu28VhngyiaYdlnSJrPcMGDW4LHyvPE/MWLj+meR30AAckBbjItJo2GfTYrGJge8KyItz7pme1/cnuBL05RDKGV5103Z/VsqSs2/SQO8lElivQ7XXtz95Z4wA86PdUJYQ1PYGlxkbmp1LbA2KpqpL1yEUR9V7z/7jZKcG5JPmJlK/4Igka0dcXXyS8AhxM2C9G2//zCsNF68h5yNKv85DU7I+7Q1xlsDSP3mWxv11p6njsC+AtTNrhJLrpF1h2VopNz+OZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XydoCYoemEl9gDBl9i2Gi7y4JpGrh7eKpNR8+W0zg1g=;
 b=b6ukVZnYf7Thl/3t9btjC528LotDhmVOYkjunX+jejHbJ5CeKCG9vaUzaRkNq5QMqVByHhWVw+CT+2Pl2AmjqkPk/r896u0CzBUT2aLgkJ6UjpCNpxt0jx+e2x05f6AkiEq6B05m9UZRFLujzjPhA9IC1VHIIBcBxgEOLxYiqpb6wxt9b822fdD9RFkAXZcx0vKOnz1Zi6kRNInBpWSpFvfmo3hz869fSrW5G1EU9U0WqMMlPhaKwoJP3pafRPErS074VSEWrmhOuqy/w4VVE58+i5zOQ0FrGdEgizVyMjwAJ3Z8nLy68XQC291vT/ceilO7OBnug129NkfCZRAZ3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XydoCYoemEl9gDBl9i2Gi7y4JpGrh7eKpNR8+W0zg1g=;
 b=qfuU1v5icoQWrcmWo3cXhKZEnrPlr8t1hr3QKq69LvuCG8t1CFpWnJtJQDpV7I+t5V+e6euePu299QGZIFhDUMoKRO9n0+myIlAaRvKOaYmfPx5GeexDq0Ocx6ITnS96eohwZDxRR5kd3SC0zK7wCq4vgpvFAHTE/082F/kWnO8=
Received: from CH0PR07CA0004.namprd07.prod.outlook.com (2603:10b6:610:32::9)
 by SJ0PR12MB6879.namprd12.prod.outlook.com (2603:10b6:a03:484::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Mon, 2 Mar
 2026 21:35:31 +0000
Received: from DS2PEPF000061C5.namprd02.prod.outlook.com
 (2603:10b6:610:32:cafe::cf) by CH0PR07CA0004.outlook.office365.com
 (2603:10b6:610:32::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Mon,
 2 Mar 2026 21:35:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF000061C5.mail.protection.outlook.com (10.167.23.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Mon, 2 Mar 2026 21:35:30 +0000
Received: from nigeria-2635-os.aus-spse (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 2 Mar
 2026 15:35:28 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<KPrateek.Nayak@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <jackyli@google.com>, <pgonda@google.com>,
	<rientjes@google.com>, <jacobhxu@google.com>, <xin@zytor.com>,
	<pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v2 1/7] x86/cpufeatures: Add X86_FEATURE_AMD_RMPOPT feature flag
Date: Mon, 2 Mar 2026 21:35:19 +0000
Message-ID: <219ebbd57ac1d99fc5ea055431f7a8396021c2c2.1772486459.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1772486459.git.ashish.kalra@amd.com>
References: <cover.1772486459.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C5:EE_|SJ0PR12MB6879:EE_
X-MS-Office365-Filtering-Correlation-Id: d943c38e-343d-4cfa-fa05-08de78a3a0e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	hJjBnSCvQjJFRaqiu7gkdST7cee4Eu7eBJ3BPUq++3qBCtcDqBVnXmoEREbA4xqYSjt24UnydWOB/fPmFsoQTYJ2t0bMjQ17nol9sYECl0B30/0EOPUUXBQyhSy/v1VHmYSSMVTJAm82TDxVNlLipZtTn2+AXv0548KARjuIjuXfRXq7rQuh7HdwCNrdje5FJ0Wme3m3XN8pBB4tr7D7vLVEniWKRT2rY+anpa1+LB5KhZEprPBfc2c5UimCGik62LCtr/J1RJnFsuoeeJlGTiNeQ35xbIsRD/jhZeXXNroNeCMt/7+aFhPYAFTpHJl5Q1y2yigp8xUxI16t/tuxTzHpsflZuy1B74wFJuPhbhoejhDm4Rmp8L6llrSElM1V7CRONMy9dVsaPQASqp5hH8ffKaLkY15MdwbrvOaN68VYQc8N7pzKDFMgqmBAhAnyu609Ru3Q/wwCyn7zdklmOAsYFMFcDojLJXqRpXCjxky1JsLSepHc4WcYbUCK04mkLyMUFybI6MXCKKxxCVAh1zTDn7zPcMafE0dpAUekOL6von2EA0zoSjl6tMVONLMv8gZRNvgNCdQiDxqQtHF5XsmvDrbv8fJQ+IYAcnOmHwXdbxx200TOJ+dBWd+1TvCE7BS8RUjuMaTL20TCsQhgvV3tV18DdmKzw6jyHAsVu9N8G8QXpy3L9zqblmHywEekJZhXPLyzia12nXWMGLZv/omXll7Y7/I0IhTjU27g0o1y3gGI1+16jD9rf+AMF4UY1T/I9XMg0rIy1BuZQp4cnqZjbJwuoxaRSRidaoE0n2WeJtGCqg5uZDga9sZVnsJgjeI52aVj/F17IvhBhB5aOW8o8CvZ1/lFzGdiXJR8QfA=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tXIblL0+GtGwaOFC1/dFDcM5JrDdBXuBPelVcl4naLHwnUoa5SeN6emYYw9YMIAEe6LczOCPm5fi6fpznst6yRM5rMuwiIf6jVG2T1TG/AkAuRZw+t6T8zs2/KYjjPE8qGq8Vm+6pruZmjpJEP9iu4pLV9urbN8K8SI8D1zsKqMApKvjF2njZl3UpNL5SLPh8WKSqWCGm4nwkE1CLRBhB7Zi6bRCgBXVbUPvEiOjDmRqhedersF6vdQBJbWe3QWWmDXetvURqbXUCMemtWXwEfuHRKokHQkyFmTT7cVaYcqT518wNMKX0lF5TLtPHkuQNZTp5kH9eNwAk5WFwLbRmEahBpuGxuWikJxGPgncOifUi0JjZWj0JUW6FSzquFmHlI6pmtkntZ624XDScopUMg+wQAkO3c8jFm0f9ME+Lyytg/rSFKvqBgqYrrn11vXP
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 21:35:30.6640
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d943c38e-343d-4cfa-fa05-08de78a3a0e2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6879
X-Rspamd-Queue-Id: 7E68E1E534E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72417-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[33];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Ashish.Kalra@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,amd.com:dkim,amd.com:email,amd.com:url,amd.com:mid];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

From: Ashish Kalra <ashish.kalra@amd.com>

Add a flag indicating whether RMPOPT instruction is supported.

RMPOPT is a new instruction designed to minimize the performance
overhead of RMP checks on the hypervisor and on non-SNP guests by
allowing RMP checks to be skipped when 1G regions of memory are known
not to contain any SEV-SNP guest memory.

For more information on the RMPOPT instruction, see the AMD64 RMPOPT
technical documentation. [1]

Link: https://docs.amd.com/v/u/en-US/69201_1.00_AMD64_RMPOPT_PUB [1]
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 2 +-
 arch/x86/kernel/cpu/scattered.c    | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index dbe104df339b..bce1b2e2a35c 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -76,7 +76,7 @@
 #define X86_FEATURE_K8			( 3*32+ 4) /* Opteron, Athlon64 */
 #define X86_FEATURE_ZEN5		( 3*32+ 5) /* CPU based on Zen5 microarchitecture */
 #define X86_FEATURE_ZEN6		( 3*32+ 6) /* CPU based on Zen6 microarchitecture */
-/* Free                                 ( 3*32+ 7) */
+#define X86_FEATURE_RMPOPT		( 3*32+ 7) /* Support for AMD RMPOPT instruction */
 #define X86_FEATURE_CONSTANT_TSC	( 3*32+ 8) /* "constant_tsc" TSC ticks at a constant rate */
 #define X86_FEATURE_UP			( 3*32+ 9) /* "up" SMP kernel running on UP */
 #define X86_FEATURE_ART			( 3*32+10) /* "art" Always running timer (ART) */
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 42c7eac0c387..7ac3818c4502 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -65,6 +65,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_PERFMON_V2,		CPUID_EAX,  0, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_V2,		CPUID_EAX,  1, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_PMC_FREEZE,	CPUID_EAX,  2, 0x80000022, 0 },
+	{ X86_FEATURE_RMPOPT,			CPUID_EDX,  0, 0x80000025, 0 },
 	{ X86_FEATURE_AMD_HTR_CORES,		CPUID_EAX, 30, 0x80000026, 0 },
 	{ 0, 0, 0, 0, 0 }
 };
-- 
2.43.0


