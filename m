Return-Path: <kvm+bounces-70148-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sITPBTT5gmm2fwMAu9opvQ
	(envelope-from <kvm+bounces-70148-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:45:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 939C0E2C97
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:45:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 959863055940
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 07:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04F8134D4CB;
	Wed,  4 Feb 2026 07:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5ch4F6Wr"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011001.outbound.protection.outlook.com [52.101.52.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD8E2192FA
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 07:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770191127; cv=fail; b=SX7L0mpDCSMRhDjrwBk24bWFCRyQXUElazzZV/N5UePRZD6AylnouJskTVSe7S8ufopOxhNd8H2ORd0nKW0hvFrlbpG/oluyOg9BrV3GvdmbMZLKWfzUnf8gMXcbgbwA+gipCgP6/Tjkxe4eXwGwvVMv0ZvRg35vAIWui4a4SEY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770191127; c=relaxed/simple;
	bh=paYBNkQpp6lc88rmHIQmDfwpXlaFWoylxHTiy7Cfrys=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h7i53ydnyndGrSRs6SOpMGs58WeqCu7B5Lr5/VFdbPisSDS5V+0Xik97LkJnVXjT0av+ufkJ5eQZRbPBtwOLbOHugeWMeD9a13fSRGxKS/lYoRyOEiTPxjobiheuKCaz+HYRNLJ8Tp89RZ2euMt/b0guzmi/TNgwA2qWTw1/Zfk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5ch4F6Wr; arc=fail smtp.client-ip=52.101.52.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DgZxbeMaMLagI5ECKhAmI7837mlG7wJGzkk2oJhB9WiGldWJvPvYzcjudwRvL5VP6deyHMZPWWzUJw4vzY/CyoMMzmnMMGSGafkFyfy7Jq3tSemXT3B+jLOedsH2BSR2w6SMpfWdl9rDYxSEO1fGkskwz1fJ5DNL0hl8SNWi/e1wmS2abIHFVghbpSinCZ4IZIiMffjfgU/6jMi2rAiqL2AAaVGAEhyprmUo62Okdu+Na/PikieCfFVFBfu2wZ+okvCdD8W4DfwqJUk3vB/WFhFKqQ6ldj1n+UNL0RANBFUkCuI+/r04Jci9UohBwtsIY1/awVHaA8lkRJa/WVljaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MeKnA7gsZnQNcJjt3TW7uspHE5DUmsL3dWPHybewURY=;
 b=y8A7XXib0xTjELvfDaQTTXKHXpZmXnT9OuUXZD1i0sl3dmzvVxS7qkp1PP40KaMLdQDjMUtthsiZgBJsIvWq4EW/ZKq+vojVna9Ajlml1se5FAPXZr6R/nntGx3S+v/erWDB/g8Qe7CRe+PZNRfMMcOcwCtZCvCMjFjsyhdsHO0ncXzh03Mp5DKprK42P/K1Hacool/0BUSb0xbbZV2kcG84Px8Yhh5e+UQpb48M16GXCo7il7ioCd5Z3hncRfF96ILhd9WZCsMdW1BR4YhECdNGc4Ix+HCPd5cKPGsyiLrS8cTE481XJA9U3yLIDvhRDWAo3g1qfjdi9GwhadB8cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MeKnA7gsZnQNcJjt3TW7uspHE5DUmsL3dWPHybewURY=;
 b=5ch4F6WrzYqxeSv1gA3ViOgr9br+/2keaEh7onbSG0TswQlXAOHjoUljiub1UuvZy/nRl3C4RlO2SVNLeCDBwAB5xRIr99Q+SmoZjvaNpk5oj9DvN23SjuJCBt2f+HjtAhQhzCci1RUgagT5CwV5+ECbU4vTBbXfEFbVtMEXx1I=
Received: from SA0PR11CA0103.namprd11.prod.outlook.com (2603:10b6:806:d1::18)
 by LV8PR12MB9262.namprd12.prod.outlook.com (2603:10b6:408:1e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Wed, 4 Feb
 2026 07:45:23 +0000
Received: from SN1PEPF0002636D.namprd02.prod.outlook.com
 (2603:10b6:806:d1:cafe::de) by SA0PR11CA0103.outlook.office365.com
 (2603:10b6:806:d1::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.13 via Frontend Transport; Wed,
 4 Feb 2026 07:45:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002636D.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Wed, 4 Feb 2026 07:45:23 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 4 Feb
 2026 01:45:19 -0600
From: Manali Shukla <manali.shukla@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <Naveen.Rao@amd.com>,
	<dapeng1.mi@linux.intel.com>, <manali.shukla@amd.com>
Subject: [PATCH v1 3/9] KVM: SVM: Set kvm_caps.has_extapic when CPU supports Extended APIC
Date: Wed, 4 Feb 2026 07:44:46 +0000
Message-ID: <20260204074452.55453-4-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636D:EE_|LV8PR12MB9262:EE_
X-MS-Office365-Filtering-Correlation-Id: 67f7be0f-dbd9-45a4-2938-08de63c15a99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pZe7seVNYLPPZmY800xZM8HUw/LzlwNwV8m7zvYtxRRLvkTXn9AFe/WkSQpL?=
 =?us-ascii?Q?M1+yzKthOR3u7SeLmbQrQH59BJMgyXfdSVjp5QMaOC2GmzxLrVezjvIon/bc?=
 =?us-ascii?Q?PavudA+iuImjDIy3yAa4D3PiIqQlWvVwsV+J751URO4rort17BOLtk3nBVB0?=
 =?us-ascii?Q?88iD4/iWHb0PNwI41zVI5g0+XfcDSOj2YvAeSfr5+8Gp92JCdO30uht+Ucwf?=
 =?us-ascii?Q?yhxIEwZwsY81Ninikk/8xRBUW6Priob8MMOOpNR92teWss+KUrKYZVIV9kFz?=
 =?us-ascii?Q?dfChCMgwE8iqm+QMjlUb5jUw34iCfmw0yPsoCBNnBiGFdqyWHaMPM+XtT9k+?=
 =?us-ascii?Q?ytlk5AMbQD8IpKPfaWZy9B9UVmpl+X44tx/fGDL0DRMtJ4KKnsoShEeSMi32?=
 =?us-ascii?Q?yIrxbjh/MKdp5NwwOprt25he8sPlIcHf7D/F/Ruql4G1EmFAj229/CtyzWzh?=
 =?us-ascii?Q?EurCro8MhbAIi1sPf0Q12+M5vSIkDnG6AwQYbJyvdErbckeznWLjWsRwcQb4?=
 =?us-ascii?Q?+dQIBPiC0bACBhZiF9ZltCY0PDqQc/OMczTQ+dP0voP/GUOZ/jZkvajCeZc8?=
 =?us-ascii?Q?htMPZ/nEEtHngYGepafoguh1cuxaN2eJoltWw35IWq9Kpm8LxQd9qP83U3qo?=
 =?us-ascii?Q?a9Q4LNaPRlkdJh9sCjosa3dLlda7fKyL/Wii44mSljawTxIGlnPH6Shi6Gxx?=
 =?us-ascii?Q?ql+gNHBNWy/qRJT/DNRMtnjZgn7TyasGJJ1J2SFdpRd5Dbu4RLs78IM8p/62?=
 =?us-ascii?Q?Qsl/BlgGCgMfamFHc8IBh+tdzSJ04MGiYVl0MTGg955PviU/LPinOISMAfik?=
 =?us-ascii?Q?xtNxNLa+Ge89mmaxnZmQENuMkgjxVzKrd5WiP+8ztrglnqYd6PQEMZPyu6Yn?=
 =?us-ascii?Q?U5hHv3toGKHPnhj7/cA5L/EreWqOcOG7hd0YidD53Zgorwbj6Is4kVrdd+fz?=
 =?us-ascii?Q?M8BZJWLNY4FVguHsYOCpwX90sTpMP6KtpynUnvo3sgYSggjkHM9sAD1jwHNQ?=
 =?us-ascii?Q?Aqx7LeMZz9MrP+Bg4qrl06G8PXvycKhUHkCCViM92huwJhGlHmlZ+YI2UlXS?=
 =?us-ascii?Q?t/COAfwUv9e6fHGglToZZjJw8WLGUmrHhUmtoDTvOMwEHP4MghrGLrc1a6Us?=
 =?us-ascii?Q?+lPUTMIt41oiJ9S6xfpEiUH3zq0UqsJzFaMnnBOwJyaEt/HeHB1k9aDmLFnw?=
 =?us-ascii?Q?z/QU31uMwlUjUapviMx5XuZXNpzUVvpLXJFZpZ99cYslr3CrxOadbs4ptyxH?=
 =?us-ascii?Q?MBcUpeFGTtRYL0Kbv3QaobMiXg0B4U8sLskitqlfBC0sfgm9A8fXYIdXiw+P?=
 =?us-ascii?Q?tN3U+OM2qSMcwkWrP+iCyeWyOrBcXQYC5cySS0zZJ3fnvJxzmiisXoBx1AJx?=
 =?us-ascii?Q?vbK/XizBfUwS+ujRlFXmExuHicXYZT+Jk+HraeJLleTTGAOqNYU/jr33ZSIz?=
 =?us-ascii?Q?RVQzH8qUpAN8YnR3WAJgv175IipxON5esP/zYQkcSyhE69lXLoiWM9eLgCQa?=
 =?us-ascii?Q?xTTb4PjYWzJql090IyeAyhzv6XpU9RESm/OQXZpJKhKFgAMlfoIuXilWSbGP?=
 =?us-ascii?Q?QZHRGmcokR3znarfKchGyGu0OiEBbciRLRT01O1fUVVI0548d5AWD1dIxiXd?=
 =?us-ascii?Q?R4YeiGWGY0daUuR58iacwqMeK/dUWYQhihOoqSq44hJC5bWz4FN5AS6tf0hO?=
 =?us-ascii?Q?b+pvNg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8EvJoc4jt9rm+5e3yiIZDzF0Q9TEtvZJcfUjpfUkZvyo27xH7l7hXDkQAeGzZST+S1euyzk6piLCCBK4Xs1oVWSDGphMQA7U1WFJCnaXt43py0AkRk2HzJKWtsl444sEFN5GraIjEQG1gfrItQhF+RJYilvrJUXiTnrHLi+pjB4OKfV/LsZYRDVsSNOqTwMauzudxaXP2x5MzBLXHqhel9OhppnHKrWW70NGjr5h0S10AptBKPLFRgL948OK2nrYWGJAX/i8M0vKkVsq8dwX6hsTKDorNxREtdhDgUQtZ87vIDgixbG1tosWg1PPL7KDnhn+mw5BhGeH0eJNSLRF6AFxdpzL/2sIvBu1IUrjgE2Z9k7HZU3Xxha1hRAOWzGm2lNEkn7cSIBwFC9bhSHLfSW7TO3DDlcbMRlgr9fiKd+NFP94D7+LVlSGqwEZXK1M
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 07:45:23.2247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67f7be0f-dbd9-45a4-2938-08de63c15a99
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9262
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70148-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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
X-Rspamd-Queue-Id: 939C0E2C97
X-Rspamd-Action: no action

Set kvm_caps.has_extapic when the CPU has X86_FEATURE_EXTAPIC, allowing
KVM to expose Extended APIC functionality to AMD guests.  This is a
prerequisite for advertising AMD's extended APIC space to userspace and
enabling extended LVT emulation.

The has_extapic flag gates access to extended APIC registers (APIC_EFEAT
at 0x400, APIC_ECTRL at 0x410, and APIC_EILVTn at 0x500-0x530) beyond
the standard APIC register space.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/kvm/svm/svm.c | 3 +++
 arch/x86/kvm/x86.h     | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7803d2781144..6b582fede23d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5356,6 +5356,9 @@ static __init void svm_set_cpu_caps(void)
 	if (cpu_feature_enabled(X86_FEATURE_BUS_LOCK_THRESHOLD))
 		kvm_caps.has_bus_lock_exit = true;
 
+	if (cpu_feature_enabled(X86_FEATURE_EXTAPIC))
+		kvm_caps.has_extapic = true;
+
 	/* CPUID 0x80000008 */
 	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 70e81f008030..ec70f6579b58 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -27,6 +27,8 @@ struct kvm_caps {
 	bool has_bus_lock_exit;
 	/* notify VM exit supported? */
 	bool has_notify_vmexit;
+	/* extapic supported */
+	bool has_extapic;
 	/* bit mask of VM types */
 	u32 supported_vm_types;
 
-- 
2.43.0


