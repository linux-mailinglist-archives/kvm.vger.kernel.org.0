Return-Path: <kvm+bounces-71182-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kKXnMm/LlGluHwIAu9opvQ
	(envelope-from <kvm+bounces-71182-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 21:11:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6239214FDC9
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 21:11:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DEB8D305831C
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 20:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D10537881F;
	Tue, 17 Feb 2026 20:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0Wwz6NAu"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012042.outbound.protection.outlook.com [40.93.195.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8111136BCEB;
	Tue, 17 Feb 2026 20:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771359046; cv=fail; b=Gj+iW7KlXluBp72sKhqJM/8TNh0GxColUrGDE2DEA3eCMEeQf617mZ5ATXMgdv0doQbGa76F88XjDA+Isp1G5p52CGD1uKpRgcbXyvijoqLcEQrca6zg88JvFDlOiQwPpbgp/iQoCKSMtKk+tAhY9ZxtBafq2coArC3fM12NAYI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771359046; c=relaxed/simple;
	bh=emJqWVQ/jzlyWyQc3S8WnXYq+0HIN3tksnP9HSfXVAw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rLORAWgyCC/Fv9wJgkjs/yXuSRFyILS+cr4/IBDMq5WVsuadOGQeyvCMjaFNyA7V99sAQ8GDgB3z35kT8IAqAviPICu4wx5IrDZqUx18wOgXITa/mnSmIW6AGugYEbtfHr2mvD8QZ0/dAOl5EcaK1VAuciVq/5tUGg2c5TLkxjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0Wwz6NAu; arc=fail smtp.client-ip=40.93.195.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UJdPvqQc0nqmzl4Z0eJOGYCUlx0rWESEAj1odzAc7pQwt3CeldApYNj/vrAkFdltB8+xzKuX6SfFUyu3vGejzZqpGFxiqNtjGOi6tG8UvGljvgT8MQVWM4VwXjl+L3ywYekJxHGLrS8/kBUVtsYKFzivhZ6RIQc30BSA2wP96z6pivHmoaucyPv5vuY8vdx3l/PdK6TlFtJpFkh8VFj+O/QhCy5wIZY72L0DROP3MKWAVJgMc2I0dzHWV2ZRd2pNeG5HR9TkY2Cc8Y3B9ATIU6hG4TEPl77vtCFdysuJhhbEnSfxj6Bea07xEaMWmYE4xMGW/mviQQwnWcutFJ7k8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fIm6XdEDUaHIIO5IsZChxVVSaiBE5Y2QCJF1VgkAXSs=;
 b=k6nOoaSLjU1WMspxaRRvcXOZjo5o7fv9hUvqRq6RVHMjpxGDw7YiNggd4Wv8AQZVINKSzU9sbywul6rsV4T3aXZfAfG8Yy8v2HGXcCshODHZ8I/uYtADi4JJYs+/31rAiXaTHz5XdK6csqodzRXN9VFQsRB0MdA0jXwGEsT6clRzxy1XzCaN588UHrHt59IxIKpi0EkbEAOYcAjsRMYN1Uzer1oAoHOGieLqQ1nA7xLgEeYUtES4yyIZR9zH7qB1QdLpyGrribtaYEJMuOfbAQA0hNmNv2RWTa+i5lLfY/z+Si2KFZ/6Ge9C5ZTqDtl1v5iSuCVIyPMoADZw9v2MfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fIm6XdEDUaHIIO5IsZChxVVSaiBE5Y2QCJF1VgkAXSs=;
 b=0Wwz6NAul2iLxM2qEw6IGIqCZRQ2h2cFiH1X5yuU6lgoeGqLdTiLyjCEIbYo84fUfvksxRqNTsZVCz9k3B4girsWV0X6o6PHaWD3MSSmC4aY8HWnCrgxRo+G1Sy42j+bTRNIwzKlL/6rA6vh6hShMAyFniGh/NsfRt9pap4+aOk=
Received: from BLAPR03CA0112.namprd03.prod.outlook.com (2603:10b6:208:32a::27)
 by SN7PR12MB6792.namprd12.prod.outlook.com (2603:10b6:806:267::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Tue, 17 Feb
 2026 20:10:40 +0000
Received: from BL6PEPF0001AB52.namprd02.prod.outlook.com
 (2603:10b6:208:32a:cafe::f8) by BLAPR03CA0112.outlook.office365.com
 (2603:10b6:208:32a::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.13 via Frontend Transport; Tue,
 17 Feb 2026 20:10:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB52.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 17 Feb 2026 20:10:40 +0000
Received: from nigeria-2635-os.aus-spse (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 17 Feb
 2026 14:10:38 -0600
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
Subject: [PATCH 3/6] x86/sev: add support for RMPOPT instruction
Date: Tue, 17 Feb 2026 20:10:28 +0000
Message-ID: <66348e8ad761a1b0ccb26c8027efedf46329db54.1771321114.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1771321114.git.ashish.kalra@amd.com>
References: <cover.1771321114.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB52:EE_|SN7PR12MB6792:EE_
X-MS-Office365-Filtering-Correlation-Id: 79a09322-e880-40c5-f950-08de6e609f4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DQWxbzetViajoyIKp6U2YITDhfX0Ij7xH6DOMsy8P9NdxxXVkR0ozNlM7ouw?=
 =?us-ascii?Q?NZf3BI46A+52FXZtNMV2EeVtn91NY+9vRw5as5D13BLwlDkWgYDfdv+N6t3M?=
 =?us-ascii?Q?G4kdgsctbuXwPVlm7uy/qQ/pFhh3kOQ7X84aevJcMgKgtSB2QqvrZqRkEkyO?=
 =?us-ascii?Q?XZXkU9ykrwijxphK5oF/xmovaOWJ+sHtWT5xpr4267AXgu2yd8KtrUxggokZ?=
 =?us-ascii?Q?TXIQ9kzm3f0ueVbMn1Mbenl0BLclN4MAIppZh0htyEhCwGKMsjqiCxXl5taU?=
 =?us-ascii?Q?1Qa6CJrIGZZJ5Bi+cvze7+3sYo7TVpWB25ZQIzmpKUuz6AuWCR42lONLZvM4?=
 =?us-ascii?Q?Y7Hx8+9gb+QynR+l49sJZyi7MrGy6o0qByWwDE90w47UJokWQLUIrYcGWM3Y?=
 =?us-ascii?Q?xEtmcfXyiXlrtkdUzKnERfUU36gMOTrQamn/EbY1+BPZYV0R4u9/LX2FXWxc?=
 =?us-ascii?Q?lcOmmmUN1nA5+fWiF0WAjxB5Ejcq2d5PjSJOsYcxSbRy4aOFgPkjxi1rgoPQ?=
 =?us-ascii?Q?+Ylx8foGTuoqr+UkLSWL3zeomEttOTGhYYITahpQQDltpgWxDd+RDoNrlDm+?=
 =?us-ascii?Q?GkaicPDAuTEtZ4yptX9qo43CBqn+YsEAo0SNJIufeGzRjQ3H49ftB4Hgw4Pb?=
 =?us-ascii?Q?9JLIaniptn+/w45M+LbLuDTiisLfLoZ+hmU3FN9trVDs9S6cV+2lruT9yOdB?=
 =?us-ascii?Q?HzD5tPKMU8DGFn5wf/Reiyirscguu0WACtiOTVxGr9MReBTPX6+usQq/dFm6?=
 =?us-ascii?Q?p5KL0u6JhIOB+yOzoZsgfXV/jf2UquKdEMkemRk9BoTAk/I6Q3XB4qIU+fyM?=
 =?us-ascii?Q?Kp2z6Oo84bUjAJ7Z15G27LJf56VJftIaZgLHJTMJZOpcPSb3qym+3OqFIJ3R?=
 =?us-ascii?Q?kMLtJR4NOuJQr/pzKVQ/eCF0R6DI7GB8hRUrKeWLdxal6DIrRDQR3yK42T9/?=
 =?us-ascii?Q?i7m1neZeBZZFEA+W0sivLrVd+p2ak4fmiMU2LbkaHPvJsz8qbCphPmhj6eeP?=
 =?us-ascii?Q?YzYGdk8NAP5SNro2G4v0pla7lM9XKCavQlgw9u9WYo/xPuhi7fNvYHGOvbNS?=
 =?us-ascii?Q?+rnNKaiz5E+X/XTz6bqCJrSjfSG+IO8Ty5VVm9dLKhCpmvoY6OJUWCDyP+l5?=
 =?us-ascii?Q?+IMltHcCLM4WdVGIZEpS41fTBwxUSR3FPbyQ486j0i2uEwM941xpe18EkEwo?=
 =?us-ascii?Q?cQXzhOo3FG5LiTVeiWJ0VyM+BkETO5mGUYj5asevXiq8LWfZ3ZhghjhkTIPJ?=
 =?us-ascii?Q?JaeOl/Vw6jXCO77xZgVpzvIFm0PKfwqbiiAtsZSKQJ1y/HAtMc/cdJWeUcEk?=
 =?us-ascii?Q?NFBO/djqF1+seuZCUgh68NMZSmJKlRgFRVgsedjoEZHDpzPmI2mDGTTko0/6?=
 =?us-ascii?Q?XP2rqJDfDDLBX5C1eUXeBUxnNhGt37mM7uqsmM2i1Klnle/35HO8T5IXD8vP?=
 =?us-ascii?Q?JR75LlRrtVuAQRgqHjHfFogo6DkJmY3fuLQvgi3kkClTtvSkRjuj30N+vW5E?=
 =?us-ascii?Q?Mn+NBmRAIm+QZythgCSueLN73mVNWT36sGRKDGygSWLxb/+c2fFcYNKJyH5g?=
 =?us-ascii?Q?IN4ILVGy5K2ZqF7VPgNr1N+jFuh+vdl1ZQtIZcGP3btj6zl9wRHXjj1bSS+Q?=
 =?us-ascii?Q?WL9KmlNgti9l36WJNQRo3Uczc//Q49dCoqDrmaXjek1L8HqTCJ8d3XqaRQE8?=
 =?us-ascii?Q?n2UQJAE+v9xDCoDWHHNHr6lL0aA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	txCYOG30zOC6iWvPviXJZIB+DNucKcCpCRsb4OiRtfnK+LSwMow5ItHvxJTlngKQReYP98q4zAetyazxTR8MuZNa1KloBiOG82PbhHECxtMP3w905CnNNCvYD1WAnve1wF5FdI6JXzgmlfY2NcwzJXRQWeJiofz9nIw2rG43wBESJHO80w29B4okrd0soDak9lJuVCD6UTQTtc/IN/2WozV6fHN/6xTuVh3ZOLCp5oPILgbIxNnxc36HTjxTWaxN2MKLf6ByvfPRlo8o53DxnSgwvi/KBh7lEbypf1mktqyDrXMtAcGNlxboaPx3SVBdPLEF2ThP36M4mAtiZaVNrCEUIKUZlNLjEgtHpYBX+m9PrYtcHRvTxy9zajNzGBa9kAoUcRcKKSKMlWFYLu4zEA6QG5i/sXL8bMG5aVc3WvxDSL/VIZg+IJdhCYc5RxQQ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 20:10:40.1147
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79a09322-e880-40c5-f950-08de6e609f4a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB52.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6792
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[33];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7];
	TO_DN_NONE(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Ashish.Kalra@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71182-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: 6239214FDC9
X-Rspamd-Action: no action

From: Ashish Kalra <ashish.kalra@amd.com>

As SEV-SNP is enabled by default on boot when an RMP table is
allocated by BIOS, the hypervisor and non-SNP guests are subject to
RMP write checks to provide integrity of SNP guest memory.

RMPOPT is a new instruction that minimizes the performance overhead of
RMP checks on the hypervisor and on non-SNP guests by allowing RMP
checks to be skipped for 1GB regions of memory that are known not to
contain any SEV-SNP guest memory.

Enable RMPOPT optimizations globally for all system RAM at RMP
initialization time. RMP checks can initially be skipped for 1GB memory
ranges that do not contain SEV-SNP guest memory (excluding preassigned
pages such as the RMP table and firmware pages). As SNP guests are
launched, RMPUPDATE will disable the corresponding RMPOPT optimizations.

Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/virt/svm/sev.c | 84 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index e6b784d26c33..a0d38fc50698 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -19,6 +19,7 @@
 #include <linux/iommu.h>
 #include <linux/amd-iommu.h>
 #include <linux/nospec.h>
+#include <linux/kthread.h>
 
 #include <asm/sev.h>
 #include <asm/processor.h>
@@ -127,10 +128,17 @@ static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
 static unsigned long snp_nr_leaked_pages;
 
+enum rmpopt_function {
+	RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS,
+	RMPOPT_FUNC_REPORT_STATUS
+};
+
 #define RMPOPT_TABLE_MAX_LIMIT_IN_TB	2
 #define NUM_TB(pfn_min, pfn_max)	\
 	(((pfn_max) - (pfn_min)) / (1 << (40 - PAGE_SHIFT)))
 
+static struct task_struct *rmpopt_task;
+
 struct rmpopt_socket_config {
 	unsigned long start_pfn, end_pfn;
 	cpumask_var_t cpulist;
@@ -527,6 +535,66 @@ static void get_cpumask_of_primary_threads(cpumask_var_t cpulist)
 	}
 }
 
+/*
+ * 'val' is a system physical address aligned to 1GB OR'ed with
+ * a function selection. Currently supported functions are 0
+ * (verify and report status) and 1 (report status).
+ */
+static void rmpopt(void *val)
+{
+	asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc\n\t"
+		     : : "a" ((u64)val & PUD_MASK), "c" ((u64)val & 0x1)
+		     : "memory", "cc");
+}
+
+static int rmpopt_kthread(void *__unused)
+{
+	phys_addr_t pa_start, pa_end;
+	cpumask_var_t cpus;
+
+	if (!zalloc_cpumask_var(&cpus, GFP_KERNEL))
+		return -ENOMEM;
+
+	pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), PUD_SIZE);
+	pa_end = ALIGN(PFN_PHYS(max_pfn), PUD_SIZE);
+
+	while (!kthread_should_stop()) {
+		phys_addr_t pa;
+
+		pr_info("RMP optimizations enabled on physical address range @1GB alignment [0x%016llx - 0x%016llx]\n",
+			pa_start, pa_end);
+
+		/* Only one thread per core needs to issue RMPOPT instruction */
+		get_cpumask_of_primary_threads(cpus);
+
+		/*
+		 * RMPOPT optimizations skip RMP checks at 1GB granularity if this range of
+		 * memory does not contain any SNP guest memory.
+		 */
+		for (pa = pa_start; pa < pa_end; pa += PUD_SIZE) {
+			/* Bit zero passes the function to the RMPOPT instruction. */
+			on_each_cpu_mask(cpus, rmpopt,
+					 (void *)(pa | RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS),
+					 true);
+
+			 /* Give a chance for other threads to run */
+			cond_resched();
+		}
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule();
+	}
+
+	free_cpumask_var(cpus);
+	return 0;
+}
+
+static void rmpopt_all_physmem(void)
+{
+	if (rmpopt_task)
+		wake_up_process(rmpopt_task);
+}
+
 static void __configure_rmpopt(void *val)
 {
 	u64 rmpopt_base = ((u64)val & PUD_MASK) | MSR_AMD64_RMPOPT_ENABLE;
@@ -687,6 +755,22 @@ static __init void configure_and_enable_rmpopt(void)
 	else
 		configure_rmpopt_large_physmem(primary_threads_cpulist);
 
+	rmpopt_task = kthread_create(rmpopt_kthread, NULL, "rmpopt_kthread");
+	if (IS_ERR(rmpopt_task)) {
+		pr_warn("Unable to start RMPOPT kernel thread\n");
+		rmpopt_task = NULL;
+		goto free_cpumask;
+	}
+
+	pr_info("RMPOPT worker thread created with PID %d\n", task_pid_nr(rmpopt_task));
+
+	/*
+	 * Once all per-CPU RMPOPT tables have been configured, enable RMPOPT
+	 * optimizations on all physical memory.
+	 */
+	rmpopt_all_physmem();
+
+free_cpumask:
 	free_cpumask_var(primary_threads_cpulist);
 }
 
-- 
2.43.0


