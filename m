Return-Path: <kvm+bounces-71639-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kKsRF0LrnWlDSgQAu9opvQ
	(envelope-from <kvm+bounces-71639-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:17:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AA3E418B2D0
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:17:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 34B32320426B
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:06:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 269E726056C;
	Tue, 24 Feb 2026 18:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3SGUz/vS"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010029.outbound.protection.outlook.com [52.101.85.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0A054758;
	Tue, 24 Feb 2026 18:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771956164; cv=fail; b=fvqL14zKphgsmVEkL6VnibDNcQpkNxhhtA6qxrIhSNwSFw28abPCP9TSn21sSb2bo+J7WgnbIkLTzotwESL71pQvMeCFBVtngmrnJkuQ9Pax5O+Ae9RudT3Yqd55UgsYLYFZjdYRFf2tys5yrvZcXCc769W1sKAFuQ1DtzywxeE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771956164; c=relaxed/simple;
	bh=CUZ0Yp8Ctj5iGXDOBzggNJqtDrYM6UhDGLbGltHeLtM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jyPYc/NfKrtS0nfBBdhvqYGdqkelaaO5T476mlJZa35vaq1hXhnQpHqUlg820BQLh9RsTRluQlpAHstRmfUnDuEvMeCxaBLEhTwr3l5xm75vLdFx6Xu8uuB3HuX26RfR+yIWRavMV4E9lcdSMm6iWCXD97igS4kmwMU4ALoHkU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3SGUz/vS; arc=fail smtp.client-ip=52.101.85.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HnRshgX2BGDippYtUHJaTgYqODBYcYb2++hLXn7uZTBzP6bzG2SCFrbptKQ7dl3iE9DO4dbuxP2xoGDzeK6qfSH/srpatpMOMfXWJS61i92GNR4yEQMQasv3t5Hsyi0sUNzb5EIn00+n0wIswuIjpDOKfc+62KDdRO9PTuz90kaFNCbIcc4m+nh1am8coUfkhQK8UjBv4jMHtygMwIsBzab6yDwmnLqNg4R9Fw9mpOUgE7RMsYmuyKrwrIhqwtuyDodPVzAZI8g5WgR1uhSczCItzBNYPytIbq5toQb0bjD3MrBr5a7SmRdMDsQybOJVQGn6rysH9t4nZJPq+OOD/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cpez5mwt4d/Bf2YizbgXqk90L42ZNm+bNgHBZd7xUck=;
 b=UqLwpa5zqAaH8DpTe+ay7SI3dvWq+mUICTm7UWsfpPOthnbQW+3/Q9KLVMJukO5R1xIXMBuCWb0mxfvgvY314OA+KHCXB/pW1ZMCkncZ68YEPbCHEhnwN1PepWLSpfbIkEPMyLum8GmnlPHUEzmi+M96i0gGU9TNvhe2uuIq6oE84y/qQgrYmX+5AX69LDCYDYsK0yrkhLKDdIxkM4FpVwaRSTta6QHLdpNj+C7WUGt8Tv0TzTY2WMxb9k1oGuJsc2q+LiTK7Ke5OXjQIEJoMn5G0X9vLaTAiEFTu/cZ5UV1uUBpAViJXtCl0TU5fzwXaKcZqOvL3i0s5fKIv7ZAmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cpez5mwt4d/Bf2YizbgXqk90L42ZNm+bNgHBZd7xUck=;
 b=3SGUz/vSGLBz3HQXgRjyjzRYHXftD3TfgGYmclQjurGdS3yHLBaw7yEAOuTGt3zZCIiT8EbnEimiQF8K3CUcVUI4wSRvaWw6aBhd4lfFo4rk24s40yFwlf4H6ZoVEUpea53XAOjs7tFCci5/GErkIH8TEeFoeu6mJICd06RSK94=
Received: from BN0PR04CA0090.namprd04.prod.outlook.com (2603:10b6:408:ea::35)
 by DM4PR12MB5961.namprd12.prod.outlook.com (2603:10b6:8:68::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 18:02:39 +0000
Received: from BL02EPF0002992E.namprd02.prod.outlook.com
 (2603:10b6:408:ea:cafe::91) by BN0PR04CA0090.outlook.office365.com
 (2603:10b6:408:ea::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Tue,
 24 Feb 2026 18:02:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0002992E.mail.protection.outlook.com (10.167.249.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 24 Feb 2026 18:02:39 +0000
Received: from dryer.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 24 Feb
 2026 12:02:37 -0600
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
Subject: [PATCH 2/3] cpu/bugs: Allow spectre_v2=ibrs on x86 vendors other than Intel
Date: Tue, 24 Feb 2026 12:01:56 -0600
Message-ID: <20260224180157.725159-3-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992E:EE_|DM4PR12MB5961:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bde4f99-bc26-45e0-b7c3-08de73cee5ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gykOjVudNgotv66cQhr0q4Htuq73rRXgsbtWShhxewochyvWouTp0hLTGodM?=
 =?us-ascii?Q?M6gqg91WZaq/FqfwADclETP6G5Z1UmTtKwUUSXtAQHTfZkFz0qXr2uJoQbm6?=
 =?us-ascii?Q?oqLEyHXgJh3sGEc7eiKUfYjT5rzHjXZ4pH4GHk7oyRtf4hqv/wVvZLj7YBlS?=
 =?us-ascii?Q?o0ApYwWd8cANKKB0CHbXxKO58ctQEjgI41llb0LGM2V4o8P5lgjTrjOxXVXg?=
 =?us-ascii?Q?y6BtGL68iowK9khlyP1ugDyxoukcyawXZDiWRQM8KgOv+01L+/jfcHU6auh9?=
 =?us-ascii?Q?8p9jI2vBjQ27mT6tF2JgUEOK3IvzMVMx63a80KIiCLDGmmkjQRzhZGkcXPAj?=
 =?us-ascii?Q?TlCrwqTyPmmpifx/ZvbDXAVsZWWOnbG8tP4+/dywx6RhAuz8pwXuUQS9uHCs?=
 =?us-ascii?Q?wMzDVPsAoWXB9ZYdfFq7zlm9Xog9aQHO28VIWAtVDpvn0JXAaLHu6M0YM3ej?=
 =?us-ascii?Q?l9MtOZKFk/AotZzuwvkhkRL5sKlA5Lcv2WF8ebii0IUw2UXxNClt4e18OLKl?=
 =?us-ascii?Q?YaRIOu5V1tFipMZfljG8B2ROkoBEtDCSpigcfvITYoRhFcItGqx9F3+k/0qu?=
 =?us-ascii?Q?tIPv27MIrKmyorwjYZAuRUbOfner2gB/8YQlnTqiUmap2qRVNRS/SJrAZOv6?=
 =?us-ascii?Q?YU8FifXX8GRHpz/XNjScxR6HPCIYe5j6+qLdCboVPTBHEUqZGbUYW2ceiyn3?=
 =?us-ascii?Q?cdfwYaq/gyhlhseaHQp1PDCpqn16mwaDT8WcsYT0wg1eE+s9+M63fu3XtQDt?=
 =?us-ascii?Q?W/F54uOW9bPuUnKFNQ6rRByh8+3GFSQXHtrWyMYidyepbfRtaFRFY93xfUaU?=
 =?us-ascii?Q?jR7cHCKrBIx2jdVxQVAr7QvafLDYzaWMCC3ojP4rf6P67aMFon+BDi2cEg1T?=
 =?us-ascii?Q?I1EA1B4S174toakH2zosovS4l9qVIr84K8utBVUb73t51rKaoVz8S0sy+Fh4?=
 =?us-ascii?Q?5+pFGcFwYJ58QYQiJ/6GeX1nsgpHoSheW6tFVr9cr51Bnn/dosD5ZeIDJAc3?=
 =?us-ascii?Q?hrRaIuwZEGNwyX7pvhfZg0jx1paWk/rnUT7QSgI0MQZa7fuuvoG2pjtWXSi5?=
 =?us-ascii?Q?NNLEUgPPi6kEf9n2k30/9bI4As9nTM0a0ppE7oP8yeTIaUSEUpmqPgi2fU2S?=
 =?us-ascii?Q?1r80Q1jDZDGT0WiF5hksqkbzQVcXRBx+Y9vgHv/TdJtCrO1IyhhvMuowNTI2?=
 =?us-ascii?Q?8tl7jKhVGR2kHBGbxkWnCGpmc6/IUecCApjI3WcNH845kpOtOK7ht7BZwwCr?=
 =?us-ascii?Q?tiT7XFKnE/KPrZWVL0IP+foLuOzmSvxWimHI9f4HB/sBBW0c/qS0SzQkw4nC?=
 =?us-ascii?Q?ksdsJMinjSbSMc/lknOUXnRGlHM1NO0V+ljaakvOA/lfEf0ZVwrwNd3gCjpB?=
 =?us-ascii?Q?cG42vKiuZBP3TrGxiRgBMLpZ7QszegsAFSdFUPB5v3Ko4UgIKqA6GqlWRgqd?=
 =?us-ascii?Q?ATPktBvRIjiVifkEZrkLQzHgwysCzqd/u92v1BAQ3NKm8vVu66OrjWAb/Ha7?=
 =?us-ascii?Q?USD0OuUld2Czxpjzj/4Mv9evaktnHiR5UM22pHX+k01Hlg7QJWR8nuOjA14o?=
 =?us-ascii?Q?02gg9YLkDCjwJjt85UzOG4OozFUisnOg2RHScADhCXQVNPetzajJEMfjPION?=
 =?us-ascii?Q?OMWP1aAjHNb//FWR/7v4lRZCd8isPrSpzjqYpeOyfyPLjdsGuJCK0IpoUTDQ?=
 =?us-ascii?Q?Q44Ztw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cnH2Vlt+RsXF8e6MrOGZ0kxqgImBI+nf4E57GJeu8ra1mlOSdJw/UEY/TmsD0H2E6vceHjGmRI7R0wzn8k45GjEL5wnv0IGm1jBGaNylI+kwkb6KBuSlFHgdN07vhnYtMKNWx8U+8z8isKFhhY5mqlL0xhhtvyg9D/vKZzIwBbCSgphtTRVN98+wLT2wFpmiamIXzLJSDQl28Ent6Ht4Y1SmW/gdZP/yUNXZMSpdN23yfb3T2RRJ4IBa6ercL859hamsx3dgSJ7dfD7hbjrYB16cyDrhTBUfY8FR6Do6iKbWOQSkKFcKQ+fbGpQVCGmLp2i7G1T+k3BTwVwwPGQegAvsgUr2AXVM9IjCmoFeNs4ap51+p5wZAAPLk0oSjEs2uH5vMQf97bRjj76Hnj62ntMEZulhs1leC0WAVWWpxC2v+U1iArniXH3433PxMXOS
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 18:02:39.0712
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bde4f99-bc26-45e0-b7c3-08de73cee5ec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5961
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71639-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kim.phillips@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,alien8.de:email,amd.com:mid,amd.com:dkim,amd.com:email,intel.com:email];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: AA3E418B2D0
X-Rspamd-Action: no action

This is to prepare to allow legacy IBRS toggling on AMD systems,
where the BTB Isolation SEV-SNP feature can use it to optimize the
quick VM exit to re-entry path.

There is no reason this wasn't allowed in the first place, therefore
adding the cc: stable and Fixes: tags.

Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@kernel.org
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/kernel/cpu/bugs.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 4eefbff4b19a..67eff5fba629 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2154,11 +2154,6 @@ static void __init spectre_v2_select_mitigation(void)
 		spectre_v2_cmd = SPECTRE_V2_CMD_AUTO;
 	}
 
-	if (spectre_v2_cmd == SPECTRE_V2_CMD_IBRS && boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
-		pr_err("IBRS selected but not Intel CPU. Switching to AUTO select\n");
-		spectre_v2_cmd = SPECTRE_V2_CMD_AUTO;
-	}
-
 	if (spectre_v2_cmd == SPECTRE_V2_CMD_IBRS && !boot_cpu_has(X86_FEATURE_IBRS)) {
 		pr_err("IBRS selected but CPU doesn't have IBRS. Switching to AUTO select\n");
 		spectre_v2_cmd = SPECTRE_V2_CMD_AUTO;
@@ -2247,7 +2242,7 @@ static void __init spectre_v2_apply_mitigation(void)
 		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
 
 	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled)) {
-		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
+		if (boot_cpu_has(X86_FEATURE_AUTOIBRS) && spectre_v2_enabled != SPECTRE_V2_IBRS) {
 			msr_set_bit(MSR_EFER, _EFER_AUTOIBRS);
 		} else {
 			x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
-- 
2.43.0


