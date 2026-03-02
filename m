Return-Path: <kvm+bounces-72416-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aEyjKtQTpmnlJgAAu9opvQ
	(envelope-from <kvm+bounces-72416-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 23:48:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D64A51E5E9A
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 23:48:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1E817378168F
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 21:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 717523909A3;
	Mon,  2 Mar 2026 21:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="o0tNyxU3"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012032.outbound.protection.outlook.com [52.101.48.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB95390989;
	Mon,  2 Mar 2026 21:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772487323; cv=fail; b=rQ2FKm0Aigl9g/2ZpfDdLQU//zXz2cvADRiu5xNRqvncPTo9WkZ4S3tj1zg5pYSLNqhL3KO5WwH+O1490ZAtKYOoGQ6Qluv5bSNsyDPGvYM3KNyHyD5Dpzc0iLCnuSMuHb577Uct3bhP025B+1xzoWAKC7itbdTf4favl1cZuGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772487323; c=relaxed/simple;
	bh=ph5du07QvVo/FUpb3KPQ0uAQ2jXbj8SYAFceOOr8PwU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=n+h+tBFtJkDfY06q00DQ15ZVhbw8Q8mCFJ2haiSqHUvN1xWsZJtRQ1QiUy6TtD086IRWLsFUTdiZFlBpZCNZsJX1XLyoOB/mGtumwaPO16ewFE1ubQZmrT+/m7aMpD8f9Ub24/7C1XOkVK4jeZbpgtQAEho/jqhrmkghW035uvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=o0tNyxU3; arc=fail smtp.client-ip=52.101.48.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j9buJ4PY1Yjb0j8Iu2pqrV0jxv0eQNTbuhAoTJIZ8vwH/dtsxV/C0O18crTUQBuUEDG+0LExo1L+C3Y9S18oKwZtb86+a54/50GMAD+GfsFDuvX54mplXdfaYNN+BXONqbIj4z04yhn6+2hSnS8l5VL3B8LPZnmn+xfjj3Gou6VFJduLbuA9h+nZ7DSopUKNBV91B25V9JDRAksllNmIk8sZ97ItYZk3OnfLGnWMgAPEhHUm40HaM/Xdkem4NsdRuAytAw2+C/XyTHZkwvAYcv6VuuPps6b9PO4ZpyJZIlYADl2CHbvfjlXdw1OWkyBQcUCPYS3n6KQfl6qRiq2YpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t6ZEfNv69//2igTeGC3qRSS5Y7Dx15MQO9l0XSuNVIU=;
 b=cDgxnUdxbUS5ftyXXzmxSJ71WtaMnB+SDOCOxtlXUpfNYrxOb5DKwHA1KdDWUsDZkNH3Hb0GVZovQpS7ANHcMzwskB4Kc9u324OmeDhAQL5tsA0FUiVGUcdLgVFJSdzcFXNL8bvVfGl3DIMRf1zsyl7jlHXv28sAEbXvtENAH6B2PRyslmbiXN3uOrdiTmKxoPZ0Olv9SCDBvktCbgFUJrUu4gqPbZxb0EHcIyKU6KYryRhmGv7uGBa+OI9n0eBSdPmKMawh7gUexbg2cLH/R38J0DUhx6BgySBSAb8N6/WyXgOfLaQf0sEddz2SmtX8uP5bnPMQkJEJab+7OttekQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6ZEfNv69//2igTeGC3qRSS5Y7Dx15MQO9l0XSuNVIU=;
 b=o0tNyxU3lMsAWAF3IisOaSlECluyzimYRXZPWNZZCUQiE4Jeyy1Lmu7P8m3D+CEzFxTXRrVn6toOa6tYo0nHai7A204QTneGDcjJKwof+uc0K5/pNUwVwKC67KLovurR+mjCPraoy4wxMpoN44XNcBonABI+DniSBqphVXlvmqc=
Received: from CH0PR07CA0004.namprd07.prod.outlook.com (2603:10b6:610:32::9)
 by SJ5PPFABE38415D.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::99e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 21:35:14 +0000
Received: from DS2PEPF000061C5.namprd02.prod.outlook.com
 (2603:10b6:610:32:cafe::31) by CH0PR07CA0004.outlook.office365.com
 (2603:10b6:610:32::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Mon,
 2 Mar 2026 21:35:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF000061C5.mail.protection.outlook.com (10.167.23.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Mon, 2 Mar 2026 21:35:13 +0000
Received: from nigeria-2635-os.aus-spse (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 2 Mar
 2026 15:35:11 -0600
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
Subject: [PATCH v2 0/7] Add RMPOPT support.
Date: Mon, 2 Mar 2026 21:35:00 +0000
Message-ID: <cover.1772486459.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C5:EE_|SJ5PPFABE38415D:EE_
X-MS-Office365-Filtering-Correlation-Id: 0aeb591a-2b76-4439-9186-08de78a39680
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013|921020|13003099007;
X-Microsoft-Antispam-Message-Info:
	X2u39IWUibd/v23n3B27Ea009GA9ktNI2+BNrTAvOlC9rNXWdxL60Fen/29CEVWKo2SHh/dY6ZOPPz0ewkyy91uKge2vva3ZGkY8CpN4u4icqJg1MGKN6AmH/Mtara5MLxoJ3dqU8/XTD4otdmFPm4mIRH4xyHuOSWhrqJ7v8x/1GPVVkmaWspLk3VrTsIik4KznC6nEiBU3nJITRkU8hhvD1yZ7Z05z9pVseEevbqO8eT2RYcX+U6jkyxTZX7TAu861sd0ZgaBnWTdThQ9YfVtXx8xq6eNSisnFOA1AM7y5+g+n3VSoyvadYx8zvAS9fF04UDRkCox5wFjOz+F3aHa1pzXH9qN39nqh9HfqYMLBx2LQ8sX9KwHu+DQNekklM7xoBfwinxP46Eqk3rWShS6wg1fMF3mxAWy7j5b6a9ODwY/meJXjOe4RqbeT1klVAXtVQ3QPuLYOEqOzi8KegIBUyma62385iYdhNx5Dee2tDoWLHWsUWyC2fmlRJ9xQMwxAfMKWBMqhqj60GvCmpexajnuxhh9H7YzTMjkvyAT0++MrDeP+tYD+WTXkQCAVttbCSx55RCCwRUu4C236Nhk7hSyUkJtSOTV2Qhlo1O5bwIom+hRDsm3tZeP1Xs+hRoq3FapWjQdceRIJ4TaLxOV+GEmuMJrvntvz2HJdmW453T8CT0VIf8F+0Pf8vyOxmPZh6uf5CEzwlRhbcyeJ/bQ6Jxwpk2Sl+UUOP1n1plUnR++t/7YEde+JMXVRuPYBnZwb3HHHRDbiSOFZOk2dDJC8H+sl7SzSoZhg5VmEWJ5x3atJcYfURWh1z0lmS/J39u3cvoqc8QAgXb6o6DU1oHiA9s5B+tTaHP6mo0Enz94=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013)(921020)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	niZUMEtotXqJVhv+Iu4e1SBkagRmSi+iWMSC9AoqrNtyXMGUlNrcJbuqGbkRGd+NldAnq1izI4OkeJ5avOO7Enp9VkOPMs5w//OoHmYvVrQAUE+QyWwcCQ2itfc1peSc3HD6yUmtb9/EP8LHTVLkLe8hBiXYSh4bVrKP8w76pWE797uleKEqvibu/DySdqCHEgxmm805EPVMYwsZRa025N2vI79J3HLlwhTHev/+DE6nsiuRPCZpRanC+tiIH9uasR6znMbNoz3O2rY4XSfS6gpW1Ez44I1F1oGzovEDrbta/IjwxYOu+NRTcwmZ4FAN31EYbhjAie6IrYKySjCUPbPIhNJ3LNyXubXzkccsV29MG2PCkv0Md6/whF3uNmYT5prvdQF8fkcZyfR74nyi/P2blxd/axTAxyzd+cWM3GqQ3qFb9a+LIN3xp05J27+W
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 21:35:13.2362
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aeb591a-2b76-4439-9186-08de78a39680
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFABE38415D
X-Rspamd-Queue-Id: D64A51E5E9A
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
	TAGGED_FROM(0.00)[bounces-72416-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[33];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Ashish.Kalra@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,amd.com:dkim,amd.com:email,amd.com:url,amd.com:mid];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

From: Ashish Kalra <ashish.kalra@amd.com>

In the SEV-SNP architecture, hypervisor and non-SNP guests are subject
to RMP checks on writes to provide integrity of SEV-SNP guest memory.

The RMPOPT architecture enables optimizations whereby the RMP checks
can be skipped if 1GB regions of memory are known to not contain any
SNP guest memory.

RMPOPT is a new instruction designed to minimize the performance
overhead of RMP checks for the hypervisor and non-SNP guests. 

RMPOPT instruction currently supports two functions. In case of the
verify and report status function the CPU will read the RMP contents,
verify the entire 1GB region starting at the provided SPA is HV-owned.
For the entire 1GB region it checks that all RMP entries in this region
are HV-owned (i.e, not in assigned state) and then accordingly updates
the RMPOPT table to indicate if optimization has been enabled and
provide indication to software if the optimization was successful.

In case of report status function, the CPU returns the optimization
status for the 1GB region.

The RMPOPT table is managed by a combination of software and hardware.
Software uses the RMPOPT instruction to set bits in the table,
indicating that regions of memory are entirely HV-owned.  Hardware
automatically clears bits in the RMPOPT table when RMP contents are
changed during RMPUPDATE instruction.

For more information on the RMPOPT instruction, see the AMD64 RMPOPT
technical documentation. [1]

As SNP is enabled by default the hypervisor and non-SNP guests are
subject to RMP write checks to provide integrity of SNP guest memory.

This patch-series adds support to enable RMP optimizations for up to
2TB of system RAM across the system and allow RMPUPDATE to disable
those optimizations as SNP guests are launched.

Support for RAM larger than 2 TB will be added in follow-on series.

This series also introduces a new guest_memfd cleanup interface for
guest teardown, in case of SEV-SNP this interface is used to re-enable
RMP optimizations during guest shutdown and/or termination.

Once 1GB hugetlb guest_memfd support is merged, support for 
re-enabling RMPOPT optimizations during 1GB page cleanup will be added
in follow-on series.

Additionally add debugfs interface to report per-CPU RMPOPT status
across all system RAM.


[1] https://docs.amd.com/v/u/en-US/69201_1.00_AMD64_RMPOPT_PUB 

v2:
- Drop all NUMA and Socket configuration and enablement support and 
enable RMPOPT support for up to 2TB of system RAM.
- Drop get_cpumask_of_primary_threads() and enable per-core RMPOPT
base MSRs and issue RMPOPT instruction on all CPUs.
- Drop the configfs interface to manually re-enable RMP optimizations.
- Add new guest_memfd cleanup interface to automatically re-enable
RMP optimizations during guest shutdown.
- Include references to the public RMPOPT documentation.
- Move debugfs directory for RMPOPT under architecuture specific
parent directory.

Ashish Kalra (7):
  x86/cpufeatures: Add X86_FEATURE_AMD_RMPOPT feature flag
  x86/sev: add support for enabling RMPOPT
  x86/sev: add support for RMPOPT instruction
  x86/sev: Add interface to re-enable RMP optimizations.
  KVM: guest_memfd: Add cleanup interface for guest teardown
  KVM: SEV: Implement SEV-SNP specific guest cleanup
  x86/sev: Add debugfs support for RMPOPT

 arch/x86/include/asm/cpufeatures.h |   2 +-
 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   1 +
 arch/x86/include/asm/msr-index.h   |   3 +
 arch/x86/include/asm/sev.h         |   2 +
 arch/x86/kernel/cpu/scattered.c    |   1 +
 arch/x86/kvm/Kconfig               |   1 +
 arch/x86/kvm/svm/sev.c             |   9 ++
 arch/x86/kvm/svm/svm.c             |   1 +
 arch/x86/kvm/svm/svm.h             |   2 +
 arch/x86/kvm/x86.c                 |   7 +
 arch/x86/virt/svm/sev.c            | 231 +++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c       |   4 +
 include/linux/kvm_host.h           |   4 +
 virt/kvm/Kconfig                   |   4 +
 virt/kvm/guest_memfd.c             |   8 +
 16 files changed, 280 insertions(+), 1 deletion(-)

-- 
2.43.0


