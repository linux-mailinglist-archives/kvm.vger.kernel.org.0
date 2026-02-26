Return-Path: <kvm+bounces-71949-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yBU8HfoUoGlAfgQAu9opvQ
	(envelope-from <kvm+bounces-71949-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 10:40:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E732E1A39A5
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 10:40:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DF90130F5252
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 09:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634273AE6E8;
	Thu, 26 Feb 2026 09:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="P26TtpWV"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011052.outbound.protection.outlook.com [52.101.62.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D123A1E7E;
	Thu, 26 Feb 2026 09:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772097882; cv=fail; b=jRiZ436sa8MIiFrdIcaHkWa1LXVJQ097nV8si+M27xd5RRZZV/vDIJzToXvdw5ak/6H1t9IC15n5Zb0S0cFB4y38why7KQnifbXr25u4NnscLjmAR1eqIL+rVRNwJpoZSR9WnM1KxD3uG9RM9L3JVxOcKOVTTMgYpiPPZ9yfLRY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772097882; c=relaxed/simple;
	bh=t1uReo6S1K3PV48Yn9wVtNS5mE9XfHw6UEq9+rzURNw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dxe8vjV1XIvZyWgKic8/fQI3uu+62UkDH85kvKhnFAkKoJi0pK+XIKM7Rb+++kPONTQfn6QPUw2qNmQ+clw9t8f73fUIcck9m9o9JCRa5T/+UvtCGTsy3iJc4G5lBI9We6V1LUhfpMc1Td4Er8N+e3cvRQSbqEotjgylwQi8EAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=P26TtpWV; arc=fail smtp.client-ip=52.101.62.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ETImkMyo6/P/IOz4SUGbmlIy+Ecl8Ba4k5Me97sDHmHVH90NbvKba3iJUKGfqzeyJxSIjJSsJfnN8ICU0E9jG1L3vpoy1IYBcO4O4T2Fa+1GoxJo9EmmOqve7Yz4wQXtkpuoOp0dijgUwo51HlcqozWm43IIpigeH0JvnbU4ZbtSTU9gYalCQH0anNOu+v3CxfM21WI1Jh4HZua2gOaHpYSJd9qd32UAPahY9vefwzwg2XYj+ZXzxvcctygKgdOD+G3sNDK1zTCJIREq3Bh0MkIOZVzj/ZcpkJd82XTKX/ACYeJv49lI+5LTKxKqW+9nRlZO2DtilOIeW4MgUVklcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QiPZmOEbzdiy5fUGW4xmQT3eRkwPxQiq+Av2H6y+HFU=;
 b=ApIamG5yNfJwHzOTFqid6rCTiWKDFO4aGsUiiGnAAR80D6FkbYb0wpoCdaB1EmxwZmPxO51+jCirhwOMUO/9tYMJ8e+HJWpFl5zw+kwXVg1+cXuwkz39zY+BfLdviaNgDVDHkZmtlJkjM0/8Ksglw/Z/iNZkWxAc82agFb8klKNPunDDoh1nVjg7p4w5cNGjCeZJ+52f/iAmeDKMVWasvb3P++RS0ocV3RBkshXqQL3IbzHkbKEu1QGxu4H8l6DFloOQzdwcCXEPwlhhMdmf/B8B8uI6WgpTzBZpsx1MX8ABczaq0nKDMXZ+iz6i68DF97Y4IQbPrV6EALz/EAfGWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QiPZmOEbzdiy5fUGW4xmQT3eRkwPxQiq+Av2H6y+HFU=;
 b=P26TtpWVEHsBwZXktLW3zHpo+b2eh1xd2B0LcrqRG3Hr5gT+tgNCet5eQTbZs2PcLNOcSl83od3/1qW78iX3i9zH/Ts/2rxAEOYQU9MDTZAXD+/yqIejimHuFPR3sjJBXtdaYP/120ZBmG0xjFNLNIVE45jgFgcA59fm3tapHp0=
Received: from BL1PR13CA0300.namprd13.prod.outlook.com (2603:10b6:208:2bc::35)
 by DM4PR12MB5939.namprd12.prod.outlook.com (2603:10b6:8:6a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Thu, 26 Feb
 2026 09:24:35 +0000
Received: from BL02EPF0001A0FA.namprd03.prod.outlook.com
 (2603:10b6:208:2bc:cafe::2a) by BL1PR13CA0300.outlook.office365.com
 (2603:10b6:208:2bc::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.0 via Frontend Transport; Thu,
 26 Feb 2026 09:24:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A0FA.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 26 Feb 2026 09:24:34 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 26 Feb
 2026 03:24:30 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <bp@alien8.de>,
	<thomas.lendacky@amd.com>
CC: <tglx@kernel.org>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <xin@zytor.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<x86@kernel.org>, <sohil.mehta@intel.com>, <jon.grimm@amd.com>,
	<nikunj@amd.com>
Subject: [PATCH v2 1/2] x86/cpu: Disable CR pinning during CPU bringup
Date: Thu, 26 Feb 2026 09:23:48 +0000
Message-ID: <20260226092349.803491-2-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260226092349.803491-1-nikunj@amd.com>
References: <20260226092349.803491-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FA:EE_|DM4PR12MB5939:EE_
X-MS-Office365-Filtering-Correlation-Id: fcf5b2ec-2520-4bf3-2d13-08de7518db21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	ceGQBicxoB95coCFHMug44BSmlsN/+lFr4Wp2YjiDzyddlut2rhic6zbPmTZHg2EkKFmms7hzq/2aZKKtABE4BQklwg/nga7tJSykfkUHGAOiUcPMRmdKg8TwWG0KLTqgbwhCcW9qr4mP8kAEFZ3OgeuZ1sF0lD8zZrf6Vf81lZRbxWOssH/XgSzEohn++FM4OaeA1dZK1aeNaEs7+i27SyQc4f3n3/3tGTLMpiW1U16gAv7Q9ljwcy6+2RpxPDpjWAt0iHgKmqQkNi0pwpM4oVuE33Ye0Sl4cEZDED3M8/IFheykK8CGaLVRX3/2WMejdfUpA6yiZmXjAiD5jOlRPn7mW8Sr4xcL1VzIy1zavJkGUrhAirRRWbJPdGPa24Jna8k76PHyOpE82SdYH+C6IN5LG9XwHdEvpTxQFEkHmcUzsXCxFb5ePGpHnrzbaZwogwS5+yGtQVYdZPHCYMswTtXukHR1f/FhbS2vaDugFhgTrIfcMKRWQ1pDY0GSeCWqx05VPRVWOvAFCc+kbYS91cb8ZBMxQmSQCFf6HNxTRaEFhSrztztVhhNri+E+5/cZ1QZnEtCSMWpbbZeoajLL4o3++sNBORJTEqCRyGi0rJrgQlHjucccPv2Uf1QGjkUCFl4miNij30MedfjG8S7tiv1dVnQqVd4kxHHrFTxqwcId/9oomHorxe7c7glhyNZxXtzvlZos+OCJj4Rww97tTQ8UtwM4dmTlv+gLuzexx8rOJyut2tbFGgjSc5lWJQ6K8ToO+ZCpVSgR2Xcm1aUwwOGKFRAiCYf3+GdQOEEu6pc7aJCC/Znj1mHfvBPPibj0w5SVQgh8W3ChPfmZyfKIQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RW0Nu42PlKsie5tZQMcPL0BUow36EajrXHnDv5C+mfwDO0tV6U+GTvhCXxv7fb7rCyU3Q0gqqEXQ1KYGcDchMTIuN7Lt+n7phK10E49pICOXbzsbKzO0SnleSgMFG8smH5ZDnrcsj59rz8p5ZbZ8nV7nvobMGx2JpdT8nTHeesEjA7TmSrI8Tq0KPnTIIObMdwJ58bI7VCogYs6V/7DezIV4/C1AVoakcLy32eZ8Tqsxj6MPo2M+MOZd5Syny+9siFK2tr8QPz3/TQdVH0sL6AMmgPdTkrzLESxVF0ZdK90GotG0GlXSF0g/QtW8bFoQaC7dzXYo1QCNoirNEcZ/BCr1cfKQ19aqezjfHvv+nSLUROR2Bd/AJOIYWlKxwD5lA1D+RhDPzhqh+qSS3UnexkSycmgQv21BmEe7TKugcoxorwR4mqoKaM1vUQKl68up
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 09:24:34.8676
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fcf5b2ec-2520-4bf3-2d13-08de7518db21
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5939
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
	TAGGED_FROM(0.00)[bounces-71949-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[15];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nikunj@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim,amd.com:email];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: E732E1A39A5
X-Rspamd-Action: no action

From: Dave Hansen <dave.hansen@linux.intel.com>

== CR Pinning Background ==

Modern CPU hardening features like SMAP/SMEP are enabled by flipping
control register (CR) bits. Attackers find these features inconvenient and
often try to disable them.

CR-pinning is a kernel hardening feature that detects when
security-sensitive control bits are flipped off, complains about it, then
turns them back on. The CR-pinning checks are performed in the CR
manipulation helpers.

X86_CR4_FRED controls FRED enabling and is pinned. There is a single,
system-wide static key that controls CR-pinning behavior. The static key is
enabled by the boot CPU after it has established its CR configuration.

The end result is that CR-pinning is not active while initializing the boot
CPU but it is active while bringing up secondary CPUs.

== FRED Background ==

FRED is a new hardware entry/exit feature for the kernel. It is not on by
default and started out as Intel-only. AMD is just adding support now.

FRED has MSRs for configuration and is enabled by the pinned X86_CR4_FRED
bit. It should not be enabled until after MSRs are properly initialized.

== SEV Background ==

AMD SEV-ES and SEV-SNP use #VC (Virtualization Communication) exceptions to
handle operations that require hypervisor assistance. These exceptions
occur during various operations including MMIO access, CPUID instructions,
and certain memory accesses.

Writes to the console can generate #VC.

== Problem ==

CR-pinning implicitly enables FRED on secondary CPUs at a different point
than the boot CPU. This point is *before* the CPU has done an explicit
cr4_set_bits(X86_CR4_FRED) and before the MSRs are initialized. This means
that there is a window where no exceptions can be handled.

For SEV-ES/SNP and TDX guests, any console output during this window
triggers #VC or #VE exceptions that result in triple faults because the
exception handlers rely on FRED MSRs that aren't yet configured.

== Fix ==

Defer CR-pinning enforcement during secondary CPU bringup. This avoids any
implicit CR changes during CPU bringup, ensuring that FRED is not enabled
before it is configured and able to handle a #VC or #VE.

This also aligns boot and secondary CPU bringup.

CR-pinning is now enforced only when the CPU is online. cr4_init() is
called during secondary CPU bringup, while the CPU is still offline, so the
pinning logic in cr4_init() is redundant. Remove it and add WARN_ON_ONCE()
to catch any future break of this assumption.

Note: FRED is not on by default anywhere so this is not likely to be
causing many problems. The only reason this was noticed was that AMD
started to enable FRED and was turning it on.

Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
Reported-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
[ Nikunj: Updated SEV background section wording ]
Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
Cc: stable@vger.kernel.org # 6.9+
---
 arch/x86/kernel/cpu/common.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 1c3261cae40c..3ccc6416a11d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -434,6 +434,21 @@ static const unsigned long cr4_pinned_mask = X86_CR4_SMEP | X86_CR4_SMAP | X86_C
 static DEFINE_STATIC_KEY_FALSE_RO(cr_pinning);
 static unsigned long cr4_pinned_bits __ro_after_init;
 
+static bool cr_pinning_enabled(void)
+{
+	if (!static_branch_likely(&cr_pinning))
+		return false;
+
+	/*
+	 * Do not enforce pinning during CPU bringup. It might
+	 * turn on features that are not set up yet, like FRED.
+	 */
+	if (!cpu_online(smp_processor_id()))
+		return false;
+
+	return true;
+}
+
 void native_write_cr0(unsigned long val)
 {
 	unsigned long bits_missing = 0;
@@ -441,7 +456,7 @@ void native_write_cr0(unsigned long val)
 set_register:
 	asm volatile("mov %0,%%cr0": "+r" (val) : : "memory");
 
-	if (static_branch_likely(&cr_pinning)) {
+	if (cr_pinning_enabled()) {
 		if (unlikely((val & X86_CR0_WP) != X86_CR0_WP)) {
 			bits_missing = X86_CR0_WP;
 			val |= bits_missing;
@@ -460,7 +475,7 @@ void __no_profile native_write_cr4(unsigned long val)
 set_register:
 	asm volatile("mov %0,%%cr4": "+r" (val) : : "memory");
 
-	if (static_branch_likely(&cr_pinning)) {
+	if (cr_pinning_enabled()) {
 		if (unlikely((val & cr4_pinned_mask) != cr4_pinned_bits)) {
 			bits_changed = (val & cr4_pinned_mask) ^ cr4_pinned_bits;
 			val = (val & ~cr4_pinned_mask) | cr4_pinned_bits;
@@ -502,8 +517,8 @@ void cr4_init(void)
 
 	if (boot_cpu_has(X86_FEATURE_PCID))
 		cr4 |= X86_CR4_PCIDE;
-	if (static_branch_likely(&cr_pinning))
-		cr4 = (cr4 & ~cr4_pinned_mask) | cr4_pinned_bits;
+
+	WARN_ON_ONCE(cr_pinning_enabled());
 
 	__write_cr4(cr4);
 
-- 
2.48.1


