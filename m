Return-Path: <kvm+bounces-71637-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iJQiFknsnWnnSgQAu9opvQ
	(envelope-from <kvm+bounces-71637-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:22:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AA4EB18B46E
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:22:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A501C3219D78
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:06:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDAAF3ACF0D;
	Tue, 24 Feb 2026 18:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wmT9Stzc"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012031.outbound.protection.outlook.com [40.107.209.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35C93644A7;
	Tue, 24 Feb 2026 18:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771956148; cv=fail; b=m+GxT+WdbiJ4YT4dLoIfe/3wAeNrjv2WOvI65mR5405Ys5FMp8dKPcXpWEbDAdM2N9sIEXKe96ozrK5P/wrRDMIJII+ECSdaOeMtm3F7nVtYvVJsBBgF1gAt7SR3vlNn/99+wfUJjawTv2OoKPbkUWopv/XBYgs/ajXlraLwfKk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771956148; c=relaxed/simple;
	bh=Zzo44lHK73FbCEVyAw8vxSdSQEpCqyPf/JUVBmN/y84=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EvN/y6vi3xfeEwJ1NxXYXTLN89oYlCyHvJVpZF9X1nwVWaSgvYVsW8svfzDNaKpdsqpSm+7tUt+YBNeMdIxZrqzXoNEPExQk99Wd7kWB7Sie1j31zSeqv1eBKpv2KuNYZvKcL8w9dg7vV95vqUit5HpaujBjlRuCtXZh2CI2ruw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wmT9Stzc; arc=fail smtp.client-ip=40.107.209.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yDE0W9s6pKXXt96CaV9tbC5W14fiI7JIla+TaK9YYNBXvns2S114hd246KC68mXjH1fZb62YtUsR556nUJkc6WYTUPSgCHbtG23hyWhvkkgpWfdyppdW/uBzBVoLC5NvvFfPux6sJBvMqLVZe1VjrfBcGfsQKO38S34uXVh9AQcjfVjTLv4YCH+O1NebjyHjhsrL0V/qTfQ8LFbPGqgpT2dCqipTVrjjlnS+4XPwMY3IdDVuvelfJDVHOlnlTrpfyN0cGA8pLs5aqQscuLBzE873JMuxB1iyuN2gC0ELjBqRf2Bm1yRqAAo9kT7857ky7J7Hi/iI1pPSvYzZWNFBBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=esvU+cNInMev5qUm5PHxZmhYcVWO6gsM9SdR907DRLA=;
 b=De36JK1/0/taGi+ao+W1xpZlf7NXKYKPlFTU+VyL7zIhz2HFD87AysmhOg1Zls+CrlDSkSINRpSamlF4fzbvw4J96yV4vqjbRvzHjHRtqQ/OmeYMse+fX6KkB0oNRSB8fmk9feuF3I+B26d+wIVHspEPvuoqkN6R254OYyBVCfYWh2NZT9YfkMQNkcrZvwN7ZRCAWxzmAhj9RmVxNgwaz/vpl92Jr+b95n96rBcEA5AuNk/Tnl9RPCyjA4BysRNGSBdPe7OBoW8sc+Gw2CZV03sHIZ9RSQkR3p4XU3G9bj1uqARl/1C5B/SVQZvxM9ctkriWRZJ4e8RoUY7+qRScTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=esvU+cNInMev5qUm5PHxZmhYcVWO6gsM9SdR907DRLA=;
 b=wmT9StzcGWti+sEG+xb+wUtP+2+6eqN5dFqYKiGIZwRujCCQ4ygdhk2nXWlYMj/tPMk9G+D+I5V7A2bZrZWkMC8D4eBu0w1l8bPF+8f2qZ7i3THJNyGRh+MKuddTus2wl9jWwkC76B1BoojWho3KrIFcR9EyQ1XHOm8gFLn8fhM=
Received: from MN2PR03CA0022.namprd03.prod.outlook.com (2603:10b6:208:23a::27)
 by IA0PPF7646FEBB5.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bd3) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 24 Feb
 2026 18:02:23 +0000
Received: from BL02EPF0002992B.namprd02.prod.outlook.com
 (2603:10b6:208:23a:cafe::72) by MN2PR03CA0022.outlook.office365.com
 (2603:10b6:208:23a::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Tue,
 24 Feb 2026 18:02:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0002992B.mail.protection.outlook.com (10.167.249.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 24 Feb 2026 18:02:22 +0000
Received: from dryer.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 24 Feb
 2026 12:02:21 -0600
From: Kim Phillips <kim.phillips@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, "Nikunj A
 Dadhania" <nikunj@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, "Michael
 Roth" <michael.roth@amd.com>, Borislav Petkov <borislav.petkov@amd.com>,
	Borislav Petkov <bp@alien8.de>, Naveen Rao <naveen.rao@amd.com>, David Kaplan
	<david.kaplan@amd.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, "Kim
 Phillips" <kim.phillips@amd.com>, <stable@kernel.org>
Subject: [PATCH 1/3] cpu/bugs: Fix selecting Automatic IBRS using spectre_v2=eibrs
Date: Tue, 24 Feb 2026 12:01:55 -0600
Message-ID: <20260224180157.725159-2-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260224180157.725159-1-kim.phillips@amd.com>
References: <20260224180157.725159-1-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992B:EE_|IA0PPF7646FEBB5:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ecaad79-ff76-4a00-0485-08de73cedc28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+wccmTkXatMGgOiB4yM5uBrS849XZWyQ/z4jTq0NzrxS9+UtBfeB3l2JGugj?=
 =?us-ascii?Q?/BxfN8DrE+RuNUB+GF9a7MPPbq0x5J+Z5U7t71ABfMCTOU9ERi1Cu6cbjjvs?=
 =?us-ascii?Q?RGtIUuP6YWjxLRTEEDjrnnOJi26sgrV8iWVBu3GQemCWSd/5cPW1CNma6VbG?=
 =?us-ascii?Q?ghbtuz3j4RBMDYdaWKLjIJqkUCvXCAg1a+DvkhF8hAhqOPIUzUS9S5IstEyu?=
 =?us-ascii?Q?F2Vdn/UPCxv6rHVRU8QnXlTFj3L2nw6AHKqpWWaTFSfhvFL9DrxSPIXVjO3J?=
 =?us-ascii?Q?zTVynrSckxswUTsX67U4lr8hFn3YSf0ZLfBMEYNVHXTLgbQX3Vv8td75pQQ3?=
 =?us-ascii?Q?j67Y+SauoNXLN2sn7/leuRIKjDBu0+d6VfH9QoRF5JxYsw2bVQv9Em5r4SmK?=
 =?us-ascii?Q?+UsH4O9C2CWwGWCw7237kWm/r9DMVkO4pXd8HqtK2iOoyu5+ZvqcjrbxiEAn?=
 =?us-ascii?Q?HhcVXipKxqQTO+6OflRfFZ+h1pzdpBK2gMh0bW0BAK51cMSn3oV7aZiB22sf?=
 =?us-ascii?Q?d6al/3oxFrGl99vM4Ymsi0FFAhhKxRH8j0PfzAzsyLZ+RMpHIfRZi6NDTI+r?=
 =?us-ascii?Q?yxWiLrELLP1VfyF9ptAXGhRemu6SHuPAKbcDOSc8B6m91BQXvepielttJyWt?=
 =?us-ascii?Q?1rBDyoC7npEBwPFQSQ27kdGAt88yDoff4rub7J0sZ/6kB532WNjaroZfZScF?=
 =?us-ascii?Q?VDxcXYUSM+QqBZrGfRSN5NZmYdCwZGVr9WBwe3FptNGxNPE9q0VqWTKxKSV5?=
 =?us-ascii?Q?J0GOBuTVYQWvMgmjkqaafkZWxSVkLZkWqnMEknrcEBWV1dsvtqkxRQxzqobd?=
 =?us-ascii?Q?ihj0MqqGPVeHRTOCcMHcyo9tUXrk2BonQIGyS8RlqiWqosFa6iuWjuKHpfMv?=
 =?us-ascii?Q?iEUwCAzzYYFA9C2CVE5KB3lD2GJ6bUW/1sbBFR5E1eZTHGqMBImtFuRwc2ED?=
 =?us-ascii?Q?+dXONXbeOH9v6VPtByBzToO2Unp4KHa67e6D+8LhUaYhCnFfqs5Zaz/szc9U?=
 =?us-ascii?Q?+Af9B2giMgsxVoJQvikOf13qvZVTiS9GQhofjl7uHqXOhyhnLwTf2e2FCP8z?=
 =?us-ascii?Q?IAsGmJJXGB8SmjpbjeWt5q8sKa0XFo3J/BO5BaLS+gyCV/WeCAYKbH6dFrCb?=
 =?us-ascii?Q?bonqsJasp1mekKcnFLT56PVoCsmH76z54lSz3oM7e9TOruqrffi1VkGRL8kt?=
 =?us-ascii?Q?UCmSoTD7ip0bO0mc//kc2RVUZo3MPTv6vP5VGA9fRvus212HHrQYXvN6UpkH?=
 =?us-ascii?Q?OtcywfTYhXTDOSAxiISxro3WVzzvArDl90ffBY2OOKE94LH1rj9MHB3VPG9J?=
 =?us-ascii?Q?S13GahCnVqcN/CRcmUFihergKomW5ah7FzdsVLE4HhiE8cjnzJ02OG3lgcSA?=
 =?us-ascii?Q?EuL8yznq78E6UtsvE0oRl1IFtD5cxKwWQfuciXXMgLJPhO1cqKFjHpo7u9yj?=
 =?us-ascii?Q?ToQitepYjHd97auXn89x4SS6Mti9rAgeUtnvCBb2B8QJFQBvIgKpu1J9YWJj?=
 =?us-ascii?Q?i6lv3JijWPDghyVx8WbYGFn2/2egbwlvMfeb3hc3Zv2LNl4a3+bIQ7hRLY4B?=
 =?us-ascii?Q?p7QlhE2skbpczB6FGFvtqm2uocArHD0V2sNJu/dul71mA9HIVEhETXPorhT6?=
 =?us-ascii?Q?la8G/IS+eQaMZzQzT2Lzw9Jey2qqH++muoopusSIGdUdoWbrsADa17qIeLx0?=
 =?us-ascii?Q?JDNucg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+vXhWLjan1MhQQbVIK2d1zMoAjcknf8vZROPPylY72MN6OHQqK2JjSKBFZdOUNE4U2kXEDn3MkMSQ+Lx07YzVmbP8nO3hljV5W+mS1u9fK4V+3Xr2KW/CYley6wGhx0aZYzvdZUZRIw8+BhU4UuutoVh+DyF3VrZEm1BufOu5x60pvKW8njoFiJ6btXNMzuLutprd9yasgxZrKJVX/V/gQAFLrZCQXPodAXpamWiE5oPrbxpvyfhrdeoGUVz9PqY4ngNgyJ9E6jFI+rn365Q9TgndgDjFiKhZYoFHELfw+Ey8xPqDOkDRrzbJ0ut9KqTzcPftiMncmxQMwxJVZ3SaDtoigxTTS/8N7fFYEdv7edfJNs8n8dU1JgPuFISE2KPw+Vr9AyBrSCwtK8sO7XBFkIK3G/HhYadOvRQC+M5d7fEJoOYV5FRiEO4tjvwYagp
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 18:02:22.6804
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ecaad79-ff76-4a00-0485-08de73cedc28
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF7646FEBB5
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71637-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kim.phillips@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alien8.de:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim,amd.com:email];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: AA4EB18B46E
X-Rspamd-Action: no action

The original commit that added support for Automatic IBRS neglected
to amend a condition to include AUTOIBRS in addition to the
X86_FEATURE_IBRS_ENHANCED check.  Fix that, and another couple
of minor outliers.

Fixes: e7862eda309e ("x86/cpu: Support AMD Automatic IBRS")
Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@kernel.org
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/kernel/cpu/bugs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index d0a2847a4bb0..4eefbff4b19a 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2136,7 +2136,8 @@ static void __init spectre_v2_select_mitigation(void)
 	if ((spectre_v2_cmd == SPECTRE_V2_CMD_EIBRS ||
 	     spectre_v2_cmd == SPECTRE_V2_CMD_EIBRS_LFENCE ||
 	     spectre_v2_cmd == SPECTRE_V2_CMD_EIBRS_RETPOLINE) &&
-	    !boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
+	    !(boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) ||
+	      boot_cpu_has(X86_FEATURE_AUTOIBRS))) {
 		pr_err("EIBRS selected but CPU doesn't have Enhanced or Automatic IBRS. Switching to AUTO select\n");
 		spectre_v2_cmd = SPECTRE_V2_CMD_AUTO;
 	}
@@ -2182,7 +2183,8 @@ static void __init spectre_v2_select_mitigation(void)
 			break;
 		fallthrough;
 	case SPECTRE_V2_CMD_FORCE:
-		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
+		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) ||
+		    boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
 			spectre_v2_enabled = SPECTRE_V2_EIBRS;
 			break;
 		}
@@ -2262,7 +2264,8 @@ static void __init spectre_v2_apply_mitigation(void)
 
 	case SPECTRE_V2_IBRS:
 		setup_force_cpu_cap(X86_FEATURE_KERNEL_IBRS);
-		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED))
+		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) ||
+		    boot_cpu_has(X86_FEATURE_AUTOIBRS))
 			pr_warn(SPECTRE_V2_IBRS_PERF_MSG);
 		break;
 
-- 
2.43.0


