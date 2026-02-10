Return-Path: <kvm+bounces-70705-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +LsZHsLUimnrOAAAu9opvQ
	(envelope-from <kvm+bounces-70705-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 07:48:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EF72B1177BE
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 07:48:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 865C9305D602
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 06:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8966032E73E;
	Tue, 10 Feb 2026 06:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sR+wfU0K"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013029.outbound.protection.outlook.com [40.107.201.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAB032B9BE;
	Tue, 10 Feb 2026 06:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770706013; cv=fail; b=fv/3qjfL2/3GZk3oC/Q28H3pJsy0bi/wynq7SAvHyTteRQ3HggTnTVKsnFr/gnRTOU8K6E8Ai3glNi1QbQmkTtCDvmfTALnrT11dG3lgpEv5AEietUnths2KGS3NoQIm1DyvNqVDZ+jhRvt8YEuG2zP1s7G39cIFHWwJtaGKLP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770706013; c=relaxed/simple;
	bh=Afut1vXkjmusQta3QeUKzUAIYhtZAaJj3tvU3W/UAE0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kbTGKuiTF2Y6htJg84Q0YxfDCyXp/7NtgASc2MPH3rv4cnsDV+RjEka0iK8O79awOvhFIFqaTwRZ7cvtpDaVlBoOylWSc4gbRfKhjkNI4ukDMk8jYSMc8NHbyQPvjO/pmCcMoE59kHPwsdtaYEVXjZPNewpuYY6mN3T7aJHZsM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sR+wfU0K; arc=fail smtp.client-ip=40.107.201.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y+dQmkBaOu6jsjH01MW/zpNB1C1pjRdGsymMlykt1yCkGhuX5xjuLXuwHbK3AcQJlpYgR9a9E/wZu2PeILLBSl9ZItdy486UoKuNtnm/MWL2K902T5oHvhbASO9/XEvK3g/zx8Q5eHAhTpwpkC+yYutFexuao1t/lwAjF4xAFTgCD5cQaQI+yyMPpe2qyBBrhkZLzsp6NwgrVM/a3f1E2VmB2WN3zyz+h1ikGI/oyycnJGeNP+8Wad9rZ41W8YEn0J1ZMPCC8uw7n85ZvxURmnSMXUZRYAQYvDRJ4cJLdxhFhRrwQMgX4yn7VuXg6r4S6LqXfiPkR7z0/eXn5c1hQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LsIYeZy3yDAHmuO+F9eXH6KS5suYQ4Nmpa+ELTJiK7E=;
 b=X1s7VnhqSH10UlR+xSI3yXtfidmDfQ7hLY2g67IM6gl8bcwYqnP2Z9T0M3CC1ekaatCiCbq9oZ4NI0BoEUme2ZJjPbJ3HvOF2/7YiO2/h3/0/Hh8/RM7bR3F57yy4wiAhAKFKYr3sqLU42R7uGCMcCdkVZjLe2cazf+z7rBV+RchgrakJmu0RHfSz+7TIVQiQLmLTGxESUSrTvPg2K7OvL5bNhbyuR07WT1uMVrsPodgnrepA43lO2JkS3PGEvnHN4RvviW/2PzaJZwBMqbYTBl/6pjJ6z3v+GLKvVZoDbhpO2ouy7F/euv8nqXtHHtmNTbhxVKb3qrlrIlnplH00g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LsIYeZy3yDAHmuO+F9eXH6KS5suYQ4Nmpa+ELTJiK7E=;
 b=sR+wfU0KgjEUG6+xqMskAwD03Lz0QJ1l0LlEInaG4ywtJEylNROjR0Ls3prDb/CcdYzCfIXSLsVZE0pwuBYk0EG4ZKoNoc3M8W6E2oLLo2Sv5CS9ltu6ZuakoerqSj4CBkqhsiqFQUvq19wE105A8SKoswyTOHNyMo+UlpWfCEhO48XkQRlUCYm9Hq0KdFbBE6a7627bhdIL+qVk7hpV4mxUKsSyhQh/npTCm2aqBSU5wk9v7YUDRlzRwpJeQlfQLyMyi1jmBxPg1fsSjdWKPWBPCBV4Xg7N2Q+KoFeWNiwL4P6LPsdmwNnyDsrPY5QbtrrhtLOUF3S3eUeG+33BPA==
Received: from CH5P221CA0013.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1f2::10)
 by MW6PR12MB8867.namprd12.prod.outlook.com (2603:10b6:303:249::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 06:46:47 +0000
Received: from CH2PEPF00000147.namprd02.prod.outlook.com
 (2603:10b6:610:1f2:cafe::47) by CH5P221CA0013.outlook.office365.com
 (2603:10b6:610:1f2::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.8 via Frontend
 Transport; Tue, 10 Feb 2026 06:46:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF00000147.mail.protection.outlook.com (10.167.244.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Tue, 10 Feb 2026 06:46:46 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 9 Feb
 2026 22:46:30 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 9 Feb
 2026 22:46:29 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Mon, 9 Feb
 2026 22:46:26 -0800
From: Gal Pressman <gal@nvidia.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Naveen N Rao <naveen@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Gal Pressman <gal@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>
Subject: [PATCH 2/2] KVM: x86/mmu: Fix UBSAN warning when reading nx_huge_pages parameter
Date: Tue, 10 Feb 2026 08:46:21 +0200
Message-ID: <20260210064621.1902269-3-gal@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260210064621.1902269-1-gal@nvidia.com>
References: <20260210064621.1902269-1-gal@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000147:EE_|MW6PR12MB8867:EE_
X-MS-Office365-Filtering-Correlation-Id: 98824655-f9d3-4fa1-f7fe-08de6870291c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ICe/+cmB4UFL/Sif3iuTQx8SrfX84+u28QpIdFwmmcaiEEyZ20xrFg6Jmy95?=
 =?us-ascii?Q?hMST8RIGXyHOAY9YANYUcLADpMxsThhIhu1MYK/ZR5uRwVfyrM3nFSEUv9wq?=
 =?us-ascii?Q?x4PxwfMWmr/1Q2f/dHI9MBFgmMAc47DwU9cE1QKSYNePvNmrtAK2boMSzFG1?=
 =?us-ascii?Q?uzcA93wW5/QWdyNZM/jPLnDVBfjwJZHkYU4OtR9brHv75uQ2jWeuiz9yuMn4?=
 =?us-ascii?Q?OScwywshjn2yDNr9zNUoOVx4ETx5Had0hIWM9TcN3QaG/pR2ffKfy0bHSTkG?=
 =?us-ascii?Q?rsF3R6JRFAL8cP9lAwn+GKpsDJV6qfuXooFmE9M1/h2Mct8V68CvY7IJqpn3?=
 =?us-ascii?Q?Pc/gs8nYp7VFSnQ4LP2AxV45JwObGJzgyAYRyg5uvC5M969hm85tTw1A9un9?=
 =?us-ascii?Q?YYJhItND0rZQTVFegj69FmQHgahoW8is7FCVaLgSjMKG4LlTEadFyMj+OWm8?=
 =?us-ascii?Q?7+UdhobSP/0XZtvtAb018bHz/IKaJv7WrUlVYmxD99YgCbLaJwH5T//N8Bqh?=
 =?us-ascii?Q?1TMkqOoNsjc5h/aZbU11GUuIzsV8HP4fDTax+4MFOuODj0KErfPeFTpufjNw?=
 =?us-ascii?Q?G8R0V6bF6zC0tDfoZBpBRGNwe7w4f5h5xLMGgkg0dYa3/wqOaBXUyCivaSLu?=
 =?us-ascii?Q?WZab6d7GTM9OYkVmhGnriqtjs7QBxyQIsCzhY/R2cCimvH4WpvLk4JLNH78o?=
 =?us-ascii?Q?hIeNqYGskQ6/Fl31QyToGIib3M+FnX5YrFbSj7+jo8G+KnWQxWNTKbC56KPA?=
 =?us-ascii?Q?ifgiJKlR5J/YeV5gzIw2YwtQGXMb1o0JA93qsNsjQU6X/jKv/zO0nTh/swF2?=
 =?us-ascii?Q?FLN+CG7yzyModAVCDUUe+22AZPtEHa0XqQqgVxJ4pXleAt/DDaTGszMCNdip?=
 =?us-ascii?Q?g1XVBOj9pbdhoa835LZd0JLbJ9c1xpOY2FqFzUAZCzebJ+oTvVM+rXRTZ4Rq?=
 =?us-ascii?Q?RhaPB1FScSsAdbhowGwh85mbza5+TW5hCfHbVkrazAaruVHky6tSeiaY3XJ7?=
 =?us-ascii?Q?HkYDDBff+r2jDbYuguYf+3ewC8g8d7Y6fKNJ/6MrxxAnizgzJjI8kXSLpwtG?=
 =?us-ascii?Q?WQHo483TtvPOadK+Bbh8Cu5B9P1lLjvZSsLUf2PB4X/KtryWHfDFiyWDTa6K?=
 =?us-ascii?Q?9kvK6CKAwVHmRci6Bp9hNzAsewM2ZWAXNbOv2OCA9l/yBmUpel/JMAB2Ha5S?=
 =?us-ascii?Q?Ymeegb26PSil6e23wkQm04wpqL/JuIkVBSVTLhpMOWjwTVYlLEWGHTfZjFap?=
 =?us-ascii?Q?VcuGuuUCZW1x0x2UYSe4Fv7Lo8bQXNeLYUSH1lZe0Ed+H+aBzbVX9eAQZmBA?=
 =?us-ascii?Q?2dV/YGc5i8J5oFP08RpNhxiXwKoof2+IuojLdxxKQml3nALKkXIN0gWW7yNw?=
 =?us-ascii?Q?uwW5P8cCqtJH/Wo4KUyqZr6496H11SIKQNvctvw3cGSpJnq9DNFkW0jabE+j?=
 =?us-ascii?Q?IPIa6xQyrup7Pv92yJcj7nd6okdu3+ZyJn3PJttX5ticciOcGJERC0HSC7L8?=
 =?us-ascii?Q?mJ5W3iSy5ZuczmmJhVQPSWczRG4dRzUyW5goFwWiaSd0zvZ0Zw0ZOtCWLlvq?=
 =?us-ascii?Q?WtGN8Mmex67vRqGX2pTzDaq/83vFJf2kbz0Sdmlvq9bksKQhhNc26k2jPNAe?=
 =?us-ascii?Q?CIqQxPX3WZac1DoGCYWpBFViQn5zUupTIJUrf834q4J0cy7FAV/XErDUeuUZ?=
 =?us-ascii?Q?833m7pj7W/ueRCR3IMCiVcdpa8k=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pVTao3qzfGl2pz4YU/3b5WeF/TxBboCjQmaqO7BEtxi5TSJNxhQCuZgDyBtbVYd0tt3nI26rfSlCGMJTbZo5H613qzaEqUv+hYk5mlA3gQdw6NSlJOWdsLgirdhUA3KcW/dY0V3e8Nnf0i8addwwEYW4FTv0sQTqf7ZslATKbpsPjShMyDlvidjyDPwYMuahOSiB3eYGsvd/Ogan7Q5Tw77QkbPM/HSoUnzHlBwjF/WNwpO7AqtpH72Hz/kE+E7zAE7km2UonTNdNaZrrCbXYH8zwXC93WznWsYwR+lKIBkL8353nFj4BQ0gLnBqqCSLyEm3I6ymGZ3dCtlGAY/B4VZjb087j7o7B4SwC0x0/frmvEVJyNn4CMciNYRm69gJx7EydGd5KHNo2lWqdDanQkhyV5sOS0EbzeELKzDg9PE+/QZ3uDdhfI7qMbAUU43S
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 06:46:46.6977
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98824655-f9d3-4fa1-f7fe-08de6870291c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000147.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8867
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-70705-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gal@nvidia.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,nvidia.com:mid,nvidia.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: EF72B1177BE
X-Rspamd-Action: no action

The nx_huge_pages parameter is stored as an int (initialized to -1 to
indicate auto mode), but get_nx_huge_pages() calls param_get_bool()
which expects a bool pointer.
This causes UBSAN to report "load of value 255 is not a valid value for
type '_Bool'" when the parameter is read via sysfs during a narrow time
window.

The issue occurs during module load: the module parameter is registered
and its sysfs file becomes readable before the kvm_mmu_x86_module_init()
function runs:

1. Module load begins, static variable initialized to -1
2. mod_sysfs_setup() creates /sys/module/kvm/parameters/nx_huge_pages
3. (Parameter readable, value = -1)
4. do_init_module() runs kvm_x86_init()
5. kvm_mmu_x86_module_init() resolves -1 to bool

If userspace (e.g., sos report) reads the parameter during step 3,
param_get_bool() dereferences the int as a bool, triggering the UBSAN
warning.

Fix that by properly reading and converting the -1 value into an 'auto'
string.

Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 arch/x86/kvm/mmu/mmu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 02c450686b4a..3644d1db8be1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7488,9 +7488,14 @@ static void kvm_wake_nx_recovery_thread(struct kvm *kvm)
 
 static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp)
 {
+	int val = *(int *)kp->arg;
+
 	if (nx_hugepage_mitigation_hard_disabled)
 		return sysfs_emit(buffer, "never\n");
 
+	if (val == -1)
+		return sysfs_emit(buffer, "auto\n");
+
 	return param_get_bool(buffer, kp);
 }
 
-- 
2.52.0


