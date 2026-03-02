Return-Path: <kvm+bounces-72423-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yP1QL48UpmnlJgAAu9opvQ
	(envelope-from <kvm+bounces-72423-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 23:51:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 45D991E5F1C
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 23:51:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F2B39380469D
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 21:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8215138B022;
	Mon,  2 Mar 2026 21:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Zccse3Az"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011062.outbound.protection.outlook.com [40.93.194.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EBB37E682;
	Mon,  2 Mar 2026 21:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772487466; cv=fail; b=oZbtoR8OCN8dWrvEP6ynOhvIDhDKbAtON4XgPK3ZBxpIztj6n+2WdK6Q8dvX7m+HbGr/nem3OXFDGCI6RZqeJH+aoz1v6cXPPi9sYpwCKhyq2Fz05smP9xjrH3xqEfhBmCM9ocX4znHG+kTihNmbAbjwXCC3sjcV16pTyLhOlLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772487466; c=relaxed/simple;
	bh=TKvEodTkiW5FZ8zovTcaqqRclHhYEhq9qj9slYVIaa8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pIPpmhfKwlFyQDgTZS25zKAvJDp3rNBfdRy+Hmfr3gPKfZ+ul21VnsV2WUyyP3D6PmVQZudWZOH5pDVp6WrSEAVyE0ucnUkupaaQXjEO3dflB6e4sVXcEolQZNsASx0wev1qoBvqPW7t8A4Y6EkPFvXTtQ4VCDOy1roP/dA2mqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Zccse3Az; arc=fail smtp.client-ip=40.93.194.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NRHcb7OOZWSOc7l4Je3/sTZuyUJm0fI0xkOaRAnKykFn5yb9mi5Oi9jpbSzRb5H7fcfTPCgXFf4ApAjBEhUfGjbK+AjLTAwQnECskyKJ62T9oZi9EgCOUBRRkvmzygyx68UsaJpQjL7WYuQc6I2Z5kHyiqy3CuasKdpLL5iO4VjMrlBt+utqaiSwPj8FaDmMogax7s6bI0yM6tonsLsLdO5ZMfCim8QZBOAQC5Kwg9vlGhI9oTBMVwavS0HQmdl5MYVGmMnyvJCrDkHdD6y5e/FAiK9X9gB0ImJiyIxHnKfjV6k9obe6Et4QzgQTSJGa8tX3ORYDFvJd8Vi8gI0Rxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5KabDjPLVSfBS647KfV3I/TxeBbALzYgaCL+9laF59w=;
 b=qrXWGOjnpCfizsJLQi88M006dZ3Kuq+mXNBgDVoWk6+obAvgavYWWWBN+3ccSkfXOmUdGGMYWI5NYAZqpmhPnfga6nlXk+rqnq4n5jp5Ak+dV/IkvqZBqaBLD7JPqSosHAdxW7MTZR7h+AXjlrxBvGrrnls9rLL1UbQA49yV/ce/DfDj9Q4gq74JB7vZE1r52Y/pxoMTLhKRRmCvn1NjttcNBOHvU1sYkkRg70fGFXneZdVrR5BBlp3dv2o17AF9O9ihlkfw/4hm2P1B7teittjn6kpuHYsR0HCSSuTod3Tb7tI50SgQxrRsxnSBn4ti51T6P3VDUYBvYwCVWZr++g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KabDjPLVSfBS647KfV3I/TxeBbALzYgaCL+9laF59w=;
 b=Zccse3AzVQBtNrje9umwLaYX+4BkAkcfUrbC4QqzkQCaNcxErsmXbWTEk/YzTAl60q3zg98re1JkBZGoQPGc68W/mzY2jTjL+Im2K8S1UiqNPE9+Q1dJsKeujVKHCJ/iPFYrQpoplutsjaEgflCLK8eaee2iIPHfLTh1jqfZycQ=
Received: from CH5PR02CA0018.namprd02.prod.outlook.com (2603:10b6:610:1ed::20)
 by DS0PR12MB7852.namprd12.prod.outlook.com (2603:10b6:8:147::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Mon, 2 Mar
 2026 21:37:37 +0000
Received: from DS2PEPF000061C3.namprd02.prod.outlook.com
 (2603:10b6:610:1ed:cafe::d2) by CH5PR02CA0018.outlook.office365.com
 (2603:10b6:610:1ed::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Mon,
 2 Mar 2026 21:37:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF000061C3.mail.protection.outlook.com (10.167.23.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Mon, 2 Mar 2026 21:37:36 +0000
Received: from nigeria-2635-os.aus-spse (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 2 Mar
 2026 15:37:34 -0600
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
Subject: [PATCH v2 7/7] x86/sev: Add debugfs support for RMPOPT
Date: Mon, 2 Mar 2026 21:37:25 +0000
Message-ID: <7dcbcbe5dab82fa59056fdb0bfa330cd0da8e62a.1772486459.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C3:EE_|DS0PR12MB7852:EE_
X-MS-Office365-Filtering-Correlation-Id: e22d2292-e6a6-4361-2336-08de78a3ec0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	HJ5GmPviqbFmeMs92ggSGzjt0DNjsENS28pqnqrMS5rkQWnVcRKgt87Oa5cuwtzFmIiKR+KVEN8bfs3JfWQzqGx9j0ksvwxROzurUWr7zwXZUvyONDqB5D6a5YThX1+w+OMUxJLKXfmIKS88tEp03AF8yeJ+BykirsW5njuN9O11pwp+d3X7wxE0oUUlniZo6CWphoCmKP3hTZh4DrjYtBR83dYu1xQGzZ8242JhGlwkR0dFrHV8TP/LGmP42OmVfxIjLTrPA5mmCZ3I7uO3ewLOBYXFj92SrpIt5TaTol+UIvcYGI2KiTg8VqzG1gjOR26vQjfAZq/TqCH8C2kTkpC5irY4dqEB6M69RuSDcJ2y/rYxgjNKI6cQ0W+53BPBW01FQLyTYIgmvsP44cl42Q6nPOlBdtkPRhcNebmO8ETU+UlA82Mw5ieU8vmCymTO5rTEkYWnBYF4hc3+IFEgpHjEatv+v2q5LR0Yc8yjocywEhdICeZVsNJXbpseMsW1jWtp3ltQuEAezX+3THlhCJ3LASA2HKzuHDIPnvhD5Orgf1JYIafkDkt/G2mOWFiklX/5F1PSTry3Cwm1QOg5cybyabOgkxEu03EI6MWOzVigNt6n+uSEJT02nx8hWpyw8hHXcKUmQSzaV15WAJlp/3X/nKaXUUVa/DR8qi6di0x8TLM0yu9S957Fgll/0GFSU5kBfxH0MYC51GlcaTCBEnNRIb3Z8FpFi2/gXJtkWnG2Tc1tM+mEK/OE8wh6Mgt4dEk3/gBTrG1fsw+NuN+CTdaBod0rdYjvEx9JxWRCUwODVopkesBsmh95LllqHUpyleX4yUAS06/RrOPJwCXHwIDwTinL2+k1NsYW4lII7BA=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wRtEnaRKdKBEJ5/xH4N/vcmJoqK73iHDXFtk3NpBK8eZ+tSMaEVl4cAn2undZVuAsMk9rHYguEk7EZb2c3b82vYcRq84yi6ESAqzibhG9YTnjCBUvwF+xRVk6BRCX34lAK/8awBkWYgMrRF4tGXe3iLmaVFWPZ+qkgxw7LdUoqY+eSUQvQd7cKcTHPDSROV7DH/mS1zckR4KZ1CuB7Z+OGlkOWcMCgUFe2pt8OmzPV4ILSS2aMLdj2PqLll6iVO/WF6mhuwxfGdczV5FssRVCbQXZre8NN7cdVbjPNshjSgFooEeo1cblnnYT8x7CL21erP7IapA8xBZ9a0Ey6yeqYAwx+ok9wcp5N/mFHSNFuuJbev0x8iim7r2wrnTTl+ZiLIuNImx0sabGlQG+XGpScBT6ebGIuz+H/s9svZ69gJiI63frwxdNESN9sFE9CaI
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 21:37:36.7596
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e22d2292-e6a6-4361-2336-08de78a3ec0b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7852
X-Rspamd-Queue-Id: 45D991E5F1C
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
	TAGGED_FROM(0.00)[bounces-72423-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[33];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Ashish.Kalra@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:dkim,amd.com:email,amd.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

From: Ashish Kalra <ashish.kalra@amd.com>

Add a debugfs interface to report per-CPU RMPOPT status across all
system RAM.

To dump the per-CPU RMPOPT status for all system RAM:

/sys/kernel/debug/rmpopt# cat rmpopt-table

Memory @  0GB: CPU(s): none
Memory @  1GB: CPU(s): none
Memory @  2GB: CPU(s): 0-1023
Memory @  3GB: CPU(s): 0-1023
Memory @  4GB: CPU(s): none
Memory @  5GB: CPU(s): 0-1023
Memory @  6GB: CPU(s): 0-1023
Memory @  7GB: CPU(s): 0-1023
...
Memory @1025GB: CPU(s): 0-1023
Memory @1026GB: CPU(s): 0-1023
Memory @1027GB: CPU(s): 0-1023
Memory @1028GB: CPU(s): 0-1023
Memory @1029GB: CPU(s): 0-1023
Memory @1030GB: CPU(s): 0-1023
Memory @1031GB: CPU(s): 0-1023
Memory @1032GB: CPU(s): 0-1023
Memory @1033GB: CPU(s): 0-1023
Memory @1034GB: CPU(s): 0-1023
Memory @1035GB: CPU(s): 0-1023
Memory @1036GB: CPU(s): 0-1023
Memory @1037GB: CPU(s): 0-1023
Memory @1038GB: CPU(s): none

Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/virt/svm/sev.c | 101 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 100 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 4dd5a525ad32..49bd7ba76169 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -20,6 +20,8 @@
 #include <linux/amd-iommu.h>
 #include <linux/nospec.h>
 #include <linux/kthread.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
 
 #include <asm/sev.h>
 #include <asm/processor.h>
@@ -135,6 +137,13 @@ static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
 static unsigned long snp_nr_leaked_pages;
 
+static cpumask_t rmpopt_cpumask;
+static struct dentry *rmpopt_debugfs;
+
+struct seq_paddr {
+	phys_addr_t next_seq_paddr;
+};
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
@@ -515,9 +524,14 @@ static bool __init setup_rmptable(void)
  */
 static void rmpopt(void *val)
 {
+	bool optimized;
+
 	asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc"
-		     : : "a" ((u64)val & PUD_MASK), "c" ((u64)val & 0x1)
+		     : "=@ccc" (optimized)
+		     : "a" ((u64)val & PUD_MASK), "c" ((u64)val & 0x1)
 		     : "memory", "cc");
+
+	assign_cpu(smp_processor_id(), &rmpopt_cpumask, optimized);
 }
 
 static int rmpopt_kthread(void *__unused)
@@ -563,6 +577,89 @@ static void rmpopt_all_physmem(void)
 		wake_up_process(rmpopt_task);
 }
 
+/*
+ * start() can be called multiple times if allocated buffer has overflowed
+ * and bigger buffer is allocated.
+ */
+static void *rmpopt_table_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	phys_addr_t end_paddr = ALIGN(PFN_PHYS(max_pfn), PUD_SIZE);
+	struct seq_paddr *p = seq->private;
+
+	if (*pos == 0) {
+		p->next_seq_paddr = ALIGN_DOWN(PFN_PHYS(min_low_pfn), PUD_SIZE);
+		return &p->next_seq_paddr;
+	}
+
+	if (p->next_seq_paddr == end_paddr)
+		return NULL;
+
+	return &p->next_seq_paddr;
+}
+
+static void *rmpopt_table_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	phys_addr_t end_paddr = ALIGN(PFN_PHYS(max_pfn), PUD_SIZE);
+	phys_addr_t *curr_paddr = v;
+
+	(*pos)++;
+	if (*curr_paddr == end_paddr)
+		return NULL;
+	*curr_paddr += PUD_SIZE;
+
+	return curr_paddr;
+}
+
+static void rmpopt_table_seq_stop(struct seq_file *seq, void *v)
+{
+}
+
+static int rmpopt_table_seq_show(struct seq_file *seq, void *v)
+{
+	phys_addr_t *curr_paddr = v;
+
+	seq_printf(seq, "Memory @%3lluGB: ", *curr_paddr >> PUD_SHIFT);
+
+	cpumask_clear(&rmpopt_cpumask);
+	on_each_cpu_mask(cpu_online_mask, rmpopt,
+			 (void *)(*curr_paddr | RMPOPT_FUNC_REPORT_STATUS),
+			 true);
+
+	if (cpumask_empty(&rmpopt_cpumask))
+		seq_puts(seq, "CPU(s): none\n");
+	else
+		seq_printf(seq, "CPU(s): %*pbl\n", cpumask_pr_args(&rmpopt_cpumask));
+
+	return 0;
+}
+
+static const struct seq_operations rmpopt_table_seq_ops = {
+	.start = rmpopt_table_seq_start,
+	.next = rmpopt_table_seq_next,
+	.stop = rmpopt_table_seq_stop,
+	.show = rmpopt_table_seq_show
+};
+
+static int rmpopt_table_open(struct inode *inode, struct file *file)
+{
+	return seq_open_private(file, &rmpopt_table_seq_ops, sizeof(struct seq_paddr));
+}
+
+static const struct file_operations rmpopt_table_fops = {
+	.open = rmpopt_table_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release_private,
+};
+
+static void rmpopt_debugfs_setup(void)
+{
+	rmpopt_debugfs = debugfs_create_dir("rmpopt", arch_debugfs_dir);
+
+	debugfs_create_file("rmpopt-table", 0444, rmpopt_debugfs,
+			    NULL, &rmpopt_table_fops);
+}
+
 static void __configure_rmpopt(void *val)
 {
 	u64 rmpopt_base = ((u64)val & PUD_MASK) | MSR_AMD64_RMPOPT_ENABLE;
@@ -611,6 +708,8 @@ static __init void configure_and_enable_rmpopt(void)
 	 * optimizations on all physical memory.
 	 */
 	rmpopt_all_physmem();
+
+	rmpopt_debugfs_setup();
 }
 
 /*
-- 
2.43.0


