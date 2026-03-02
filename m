Return-Path: <kvm+bounces-72418-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id APY1Gk8HpmkzJAAAu9opvQ
	(envelope-from <kvm+bounces-72418-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 22:55:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 26D8B1E4482
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 22:55:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B92983092417
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 21:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16C22386546;
	Mon,  2 Mar 2026 21:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vfe0Gi/g"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010061.outbound.protection.outlook.com [52.101.56.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F28375F6A;
	Mon,  2 Mar 2026 21:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772487373; cv=fail; b=QQYptagqHQhtAk31Fw/LMY9z80PWSWlCtzafdtXt4dKtGmgwHuUGffnMpoF2nTdTAuDsvoa5YcAoY3ootq0cYc30krVS6Z0gCTtxeAqeTQ4BJpSq4klTCdm00QRczDfqJ+wVStEt7Ro+T6R7uhqtsr76YoBqjU7Eq8t6MMNetys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772487373; c=relaxed/simple;
	bh=er4KRPhms6RqX5CqXaT2huWFVD/zdl35dFo7PtsT/H4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e1l5alOxW951Qg+oeaZazlvcNgkoWow/VE5pjLk3eO7erNG16BW5T5uJpfDVdUXryYz7I8uZFlOa8Kj3aRD8fPT/lxVH2QLIYkzzsXX8epcbjg3tRLoraPDzfeKq9uG7ZAbBG/yQ+ZVBwC9Jf5/t/jWt49qzgMKyWiFx75hd/Is=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vfe0Gi/g; arc=fail smtp.client-ip=52.101.56.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cux1T/6BdA6rLLoZtpZdWS06NL0QrmQ5M2M3XzmSIlEZoUxOItVSzUfWSMNBW22XKqIseMRTZUgQrQP3RbpwSCOAutTTZE2L8liRcpLtlWIEMf/hVIpvN1VB/+1jtu2a0+uG5agHv6gAJ2eXQTtMSBnhxGjYYqmL/xCGAs5Z9FiLsqaTbyvg76LCu/xmAEs0YDoTwhd3Lcma97SL5HbTx22lyQRRHA2CM1BdAOvREdGGKIizVnyZdNr7iWDLrMfoXApVaifBsKU+G6Y+/GormsJeHyGYQdlnIMxm44/32DXiPr6SL1vA4Wg815Qwz9PvbYLTE007DdHEf8aciev6JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=avIsBUyY64HPtimPp9C3pK2itMUsZgyj9uEkaruMF3U=;
 b=KFa/MXYsZa6fqXm3uP9lj4oIriw1T7pCN1j0D30Q+9ixFSDCF+DDz2ZQnztWO198tvKsADJXKz3T7kNAauwWuAqEOR7+kJ0R52UZhlV/tpGgvDqH3Z4oclCgxa0yr1BjPoIo54J80JziC9ep8Jo/kPw2wD/v+IYguI0pgaLr34eP45RzPeo10bIiNK1eb6hV/7y9+q20Rx9lxPr8uvz6GUSF4fp6bm2yl2ZSrO6b2GqrFyd/yEEACQXLKqbfXZsx4RDwKAkrPbJdSomov03MJFXiCEjRsbjYvHgLCDabWJccq7hm/SRbGswhOzz3f6fCOCpOAcymCMy5OUjjCo29Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=avIsBUyY64HPtimPp9C3pK2itMUsZgyj9uEkaruMF3U=;
 b=vfe0Gi/g13MapBZ5geSzfxyD6RtdsqTiyvnsKgaZLOjsSsJxjJU9/i9PYA8IxdIbc7cxW57Jxqa376UVyrIPfRJ4bf1zNIYnAkGzauTTOXZVGphMWwFlDMrHJVHpyiz976t69hJ9aaoKmLTEv0NvEomqYa/Jf42Huxfw3Qu/bU0=
Received: from DS7PR06CA0020.namprd06.prod.outlook.com (2603:10b6:8:2a::21) by
 LV8PR12MB9450.namprd12.prod.outlook.com (2603:10b6:408:202::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 21:36:07 +0000
Received: from DS2PEPF000061C8.namprd02.prod.outlook.com
 (2603:10b6:8:2a:cafe::d5) by DS7PR06CA0020.outlook.office365.com
 (2603:10b6:8:2a::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Mon,
 2 Mar 2026 21:36:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF000061C8.mail.protection.outlook.com (10.167.23.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Mon, 2 Mar 2026 21:36:06 +0000
Received: from nigeria-2635-os.aus-spse (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 2 Mar
 2026 15:36:05 -0600
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
Subject: [PATCH v2 2/7] x86/sev: add support for enabling RMPOPT
Date: Mon, 2 Mar 2026 21:35:55 +0000
Message-ID: <85aec55af41957678d214e9629eb6249b064fa87.1772486459.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C8:EE_|LV8PR12MB9450:EE_
X-MS-Office365-Filtering-Correlation-Id: d0e15add-c4c2-43dd-17ca-08de78a3b678
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	YjFBQTWu+3ROJ+kZdk2qFEeOhY+7TfQJMmbdmesHs5pS+1o7I4aWJ9L41IucVC88GKpP0p9YCH3TMcd9Q1Yk8TBCfD1g8EItDxwfuMFltf8qBESsyhAEwTy4G8l7L5V5o/EupFvRQVEd3Ue17+Olspzb+TIniZpeLQKvCKFfNwdTcNNkjOijsaALKiq/fcizLmKVvuKju9TYYxUTQ94TwaswMt9vRscPONrnP9YesRAv6gp6kv5UJcM86Z8kxJH7GNg+pvB7niz0FIQrcefBKRzaYe7R9W5/qDMolBnQk/nXvLrJzND62ybaOuxQQD+euHeEeemM/UmtphnsTgzJBLz6saspuoIOaH8COwc4nHx4EUJlvTTtFoQuRHf+NdEsLDsoL5tLpjEDVnm8AlchI/NlvU/5Qslnar5Z7WZFBdStN5zuiQqW2LhERm2NYFNOwjrgLXdJnVGhGGCj1NOHWqfRsBJLogOePYFw1jzfKtM3QXTzy8++Hn8Hg1x0xVp+aiIJWf6NfiFlrLyZNrsuNqfJe0CTAmmOMVUFykeIVRy8qi0b7RaPPBG7f20qNvNiThaqTFqXZc+Qv2Xy2aloR69zA9aNF+i55cEid3Sy1cqTlDRow0/YNltpMi/KU4o16jSIh7NJJh/hNjFx83ZY59QDHKFwXWLJ1dR1U5G5gGqYbhQvuy961af3xERNxmlQOP0np1keMsfDUiaqrteMvjPM2rE+0C1aBIp0LAXpTkgbHsS27oT+/mBDe7GITsfQYjz7FBMJm8yQWPvondAp2JobTMp8aA6uDIWM1MtVtPIkgmU6BK+dnc3I+aFLb+XfXdGU6paF3bxAHtqidUE5eKBwvkTE3XIPZ7+WOpJ33sI=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	38iNQi8vN32J3QE8EAskZlRimRQM123aKKcG9UmaiQlah3z6PbYeA/9XnJc2pGe3KEVrkpuVn9WLd1/TXbSkdml4xGztDeeTc6deirOGXZ4ZxfwtJweVnQQuB1PdivhgQbMUmTAhv1Njvu/0zpx85FJ3jWyw0IJFbCkOTZKkY6AaY/hJiKrf43M42Deea7M48iX6BIGZ1qjrVhSmLFeeiZYPfW+MEooLsU0uLHxp9VtFhd3jxm6RLhjQvxO+7fgQZTKHgXHunqksUcmpO877eHDxcNS5MZDjMNYuKoRdp8PWmgUA12XpGZLirgDaR3HrVLGnLCOjIjiE6rpXkQfxVzMMCfnXdw3x/GM6GRjAn3aT1YXOyozMwpXZ0jYvNU+hjgxnWex6/sBMLkviEIFvLjzsM0ehtnzTtO5Xks5RMDi53JxmVbuP48Q2hailfpii
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 21:36:06.8841
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0e15add-c4c2-43dd-17ca-08de78a3b678
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9450
X-Rspamd-Queue-Id: 26D8B1E4482
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72418-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[33];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Ashish.Kalra@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:dkim,amd.com:email,amd.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

From: Ashish Kalra <ashish.kalra@amd.com>

The new RMPOPT instruction sets bits in a per-CPU RMPOPT table, which
indicates whether specific 1GB physical memory regions contain SEV-SNP
guest memory.

Per-CPU RMPOPT tables support at most 2 TB of addressable memory for
RMP optimizations.

Initialize the per-CPU RMPOPT table base to the starting physical
address. This enables RMP optimization for up to 2 TB of system RAM on
all CPUs.

Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/msr-index.h |  3 +++
 arch/x86/virt/svm/sev.c          | 37 ++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index da5275d8eda6..8e7da03abd5b 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -753,6 +753,9 @@
 #define MSR_AMD64_SEG_RMP_ENABLED_BIT	0
 #define MSR_AMD64_SEG_RMP_ENABLED	BIT_ULL(MSR_AMD64_SEG_RMP_ENABLED_BIT)
 #define MSR_AMD64_RMP_SEGMENT_SHIFT(x)	(((x) & GENMASK_ULL(13, 8)) >> 8)
+#define MSR_AMD64_RMPOPT_BASE		0xc0010139
+#define MSR_AMD64_RMPOPT_ENABLE_BIT	0
+#define MSR_AMD64_RMPOPT_ENABLE		BIT_ULL(MSR_AMD64_RMPOPT_ENABLE_BIT)
 
 #define MSR_SVSM_CAA			0xc001f000
 
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index a4f3a364fb65..405199c2f563 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -500,6 +500,41 @@ static bool __init setup_rmptable(void)
 	}
 }
 
+static void __configure_rmpopt(void *val)
+{
+	u64 rmpopt_base = ((u64)val & PUD_MASK) | MSR_AMD64_RMPOPT_ENABLE;
+
+	wrmsrq(MSR_AMD64_RMPOPT_BASE, rmpopt_base);
+}
+
+static __init void configure_and_enable_rmpopt(void)
+{
+	phys_addr_t pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), PUD_SIZE);
+
+	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT)) {
+		pr_debug("RMPOPT not supported on this platform\n");
+		return;
+	}
+
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP)) {
+		pr_debug("RMPOPT optimizations not enabled as SNP support is not enabled\n");
+		return;
+	}
+
+	if (!(rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)) {
+		pr_info("RMPOPT optimizations not enabled, segmented RMP required\n");
+		return;
+	}
+
+	/*
+	 * Per-CPU RMPOPT tables support at most 2 TB of addressable memory for RMP optimizations.
+	 *
+	 * Set per-core RMPOPT base to min_low_pfn to enable RMP optimization for
+	 * up to 2TB of system RAM on all CPUs.
+	 */
+	on_each_cpu_mask(cpu_online_mask, __configure_rmpopt, (void *)pa_start, true);
+}
+
 /*
  * Do the necessary preparations which are verified by the firmware as
  * described in the SNP_INIT_EX firmware command description in the SNP
@@ -555,6 +590,8 @@ int __init snp_rmptable_init(void)
 skip_enable:
 	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/rmptable_init:online", __snp_enable, NULL);
 
+	configure_and_enable_rmpopt();
+
 	/*
 	 * Setting crash_kexec_post_notifiers to 'true' to ensure that SNP panic
 	 * notifier is invoked to do SNP IOMMU shutdown before kdump.
-- 
2.43.0


