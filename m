Return-Path: <kvm+bounces-70295-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sAh8OWgmhGlRzwMAu9opvQ
	(envelope-from <kvm+bounces-70295-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 06:11:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 94645EEA48
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 06:11:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9D6BD3015A68
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 05:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2331F30C62C;
	Thu,  5 Feb 2026 05:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sVGRlQ1w"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012060.outbound.protection.outlook.com [52.101.43.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E91C30AAD7;
	Thu,  5 Feb 2026 05:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770268259; cv=fail; b=hgH69bhIt9p53OTwVQ9Lz6fSeZ3GibkWhRBLtSSAzknkwLbB33n/fSp/h+7CPe4GLVjg8gR0qzhwND8FliW3SJZaXyUnxyeptEqvxxksMefA5ET1pmktC4JZbUmLe18KURgMr790YxD8CMS2x4Wy2sl+BBI+TMm28/jyG17Lapw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770268259; c=relaxed/simple;
	bh=JvVV0+kwe/d5LLbmAPwbt2EEivoMNNMv1wNgSHRHyxs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bemY5Toqx8JFMnxOa6KkGd5sKYFRBQfYSK0zAyJhOChEcrsxBItrwOTL3WrHG937aXrYPWGq1DVcMbbLB+xFm3GBzGlC3l3Z7Yg2qQx20wdwGZU+6zdFCkQWZdRxDbs+ilAuSwloLmXcoO5USM0jUOvCapB/Kfz7LW15WDQoegk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sVGRlQ1w; arc=fail smtp.client-ip=52.101.43.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yWXOTM0TGW1pxcqmIXPWbO4uxUBJtNMbKN1IhdmTeZ4r6VNks9r8q6387gaqLaogSQgAELS+Rric1Bzns1l9QXm1R7CAzOnUd51YMvGvq9CfwjIzOdw2a1wGpuJyUnPT7cWfdQxWlkEVKuQ/weiioU9e3p/cO9bJ2SDifI9gkDARoY5pixHSRc6nDhP1DU6QXZ1YQ7pIZL4JejUjO4IB9OGEHH6wOcaJQ6XuiD+zRjZqbDCkl1CzCx+KOHU5e6xFt5jhyYwDJiowu2U0ygFZolY7SuOlzRcmdeeEcX59Q2z3YLivZKhoiyRMq5q4N+2mmXHOfSiSve8LuCy2D5jo9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ru0lUoPioZ3M7e1X/9j4381qoxsR+M8XuJGYE8c0388=;
 b=rkUf3vcBakxx8ByatRklVeaRHh7vKDrFV4If60klZh7YkHQbjMvf7cYMKYpYaOhPBSp19L/OTcvRulgQbhlwIrUb48ExchSWcvQjLToOQ5Xch+XaMHzmgHolGhzLU3qlRP4HdKwyZseGD09L6DWkzWY9RFsTZBFz2S8LeyYMUY/jlk2RcLd9FMe2dWfYBmZSdBzFZ+mK20yYt1Vk+2B/zOt+aZqtVtP/8cZDKmiRJXmYOVWcJEkgvlsIuk//AQe22EOw4BPvH4glk/XZLQ2lMHku/XSdbrYNWgRNO10rNntgrhywRR/mfX7CHJxHfGz2PogLCrAUAEUrvDyLWS1/Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ru0lUoPioZ3M7e1X/9j4381qoxsR+M8XuJGYE8c0388=;
 b=sVGRlQ1wbWzzH1U0DqTISA7NETvMR6bdcZHfUarPYPivZMuvET4o8YzjNdym9XnGnGTv66KVNzwQOcJu83XIBh1JLQMX4WPNcj0sXv40fbdTuwmZRYvOQXldaq7tZNPB/1MzTYYlYKEL1zaS+M4oI31vapKayg/TJXMnOQsL5Ho=
Received: from BN9PR03CA0965.namprd03.prod.outlook.com (2603:10b6:408:109::10)
 by DS0PR12MB6463.namprd12.prod.outlook.com (2603:10b6:8:c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Thu, 5 Feb
 2026 05:10:51 +0000
Received: from BN2PEPF000055DF.namprd21.prod.outlook.com
 (2603:10b6:408:109:cafe::4f) by BN9PR03CA0965.outlook.office365.com
 (2603:10b6:408:109::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Thu,
 5 Feb 2026 05:10:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000055DF.mail.protection.outlook.com (10.167.245.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.0 via Frontend Transport; Thu, 5 Feb 2026 05:10:50 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 4 Feb
 2026 23:10:46 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <bp@alien8.de>,
	<thomas.lendacky@amd.com>
CC: <tglx@kernel.org>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <xin@zytor.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<x86@kernel.org>, <jon.grimm@amd.com>, <nikunj@amd.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
Date: Thu, 5 Feb 2026 05:10:30 +0000
Message-ID: <20260205051030.1225975-1-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DF:EE_|DS0PR12MB6463:EE_
X-MS-Office365-Filtering-Correlation-Id: 6be46e69-9e2f-4c89-6252-08de6474ee2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?alELb3GYipoxunIHfDgBj2PxzXk7rstDJUYiR7osZWyqhuP4Sa7WnMBdgaPm?=
 =?us-ascii?Q?56StVbtTJANJNqbGR+eANHD5Iz6e/IF3U0thdd5A2n1Uxg6BBxse05snRfa9?=
 =?us-ascii?Q?FS5mvnVZn2wIrztnDh8yl0NuiG0CPgxBfYt69aT9sa9QVkIHRWbLL9hj3zhS?=
 =?us-ascii?Q?VpX6tajZeXQhTFnhz3UEbTCzSvxL+QHYlAKF26buJVpBucNAHCbvA8kdBtQm?=
 =?us-ascii?Q?6sdpyZwhBNtP9oOrCnFWRqCFTCKLG3xbWmk7TZmRgpPK1ULYE9nw8C4TTze2?=
 =?us-ascii?Q?H2E1x6fOvz3z+NyHOnYcdn/YeXnWeaW/bfXXCTEI6dKjJPga9VkHA0eHao5z?=
 =?us-ascii?Q?5e4xclvVzGsMafMEdNeG4NNXTI92BbRZ8y0NeSF4BD5HfL4M7fNcTXRNw1Ed?=
 =?us-ascii?Q?VCmmDLuElrOWprLgMDBWtQ7U7/Q/CIe1AZgku2r9OEbKR/hKjdP2cjz/UQG6?=
 =?us-ascii?Q?ZqQsKgdPik69qouZC5px1cjtwz0FdBJQDUzwBRbXNQp3zDAb1eA3uiSa5m0f?=
 =?us-ascii?Q?JtsOOqQaA8zHDeg/lpFEdM4No3wl0Nh/CkD3TpVP4xTyzJfFSlSbRDs6gq7C?=
 =?us-ascii?Q?K9U6ZWJ007m4zREMR2S83yrXtW5BbUS2Qi4VExmzLK/3+VZji4XPhFnCmqv3?=
 =?us-ascii?Q?iYIKZjbagYjnBfO/9oEtIpbeUuPrApsJVqvs4KxVqeRcoY9US5mm6EPx6rkK?=
 =?us-ascii?Q?ubRnWWzFoMLbew7g0jjn784qWrVFuq8b7XRHiDk+0mohZ94Q4qolK0NA5kOJ?=
 =?us-ascii?Q?I1QhPSuktnoLDIsHi7G4Evk/KYL4DH5ZbmOOV2xlNmv5GBN3FohkA+Ejw3xI?=
 =?us-ascii?Q?UCn43im3ZBMXO2bY6208EpwPOQn0I5od5Mz5yvB3sThU9nLYczE7CmlV/QP6?=
 =?us-ascii?Q?FXckQfjJlldzReYXteZFTEgTUnZiQGYor3pCWqrZ9mUM2be8e4lHIUs+tqPN?=
 =?us-ascii?Q?pPLCM9RHkkOhXvaS4XwQC8e1q2RfXyrUPzoU2ZBceRTK9FyDZOI+Ri0Q+xEq?=
 =?us-ascii?Q?Lv6vT5i9FoE8C17uFbNm7dH9rJbH03CRe9n7Rfgdyi8jOqZ1wd7ToUA0MCtX?=
 =?us-ascii?Q?9If+0n4gJ6dbR+YeQFchMLyx+FCceoZpKQTFVY1yliNfhX1m8IHLcm3e04kI?=
 =?us-ascii?Q?enMZTQvIDKPVvy1BiD5odZ6LKYCcp5fP80iHxqK9m4OaBUxJrm8S64iWljp3?=
 =?us-ascii?Q?3jYP6wmcodjCWOEqCL8LjAnxwKBQIiWFipmK9ZUZK7kL8rdG+EYpUWoq6NMc?=
 =?us-ascii?Q?IrikZiSElO8QqKJs8DwI1QNeRcZKS6D1dasWOuzTe7brqI7J843QefL1ZHlb?=
 =?us-ascii?Q?cah5Mrb3wKzefyY2DAtMWI2QovpuIQl37/3TzaD/MkTNGt0NcwG02kvtGsK+?=
 =?us-ascii?Q?FOy6Rw6Gqsf6PYWMALsGsgKVvMD+dx4ugAFOZw94AoKHbQKZkDgkAD35zjVf?=
 =?us-ascii?Q?6P7CT7zNM2N4MUDBM9dkFgkqwBzV+PNZKxaWev25lu52dRhevEiLU5baqY9l?=
 =?us-ascii?Q?et9IvEjEllwmW1ivAWdv4rrUvgty6ceJcvCXxzM6jaHnTViFnIFCmfW+Emc8?=
 =?us-ascii?Q?Yumj2aYf2ghFc0cj8yn5fUiChYV+vKK6xPwhPoEUBbsnh+RQFBWWyqf5KgQ6?=
 =?us-ascii?Q?QXEunp3yc/kyJf1HGJnvnR7ykFOcG0CHgiZXZq375M46wZzB3F4Z4N1plIrG?=
 =?us-ascii?Q?EdI1myQiIIxLpebahJGZl3yeqWg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jWMQ6q1P6LfZpZfQb3k1+hvCIPkOeB/jSnX+N9WaMs90i9rJT+LSloHC49M/Hyv18oqARU25Z+AE6VebClgcI5gAlhwX9+vmZRuUufj/PsDO6NQsjHTXLTtqroXK9pahFwXXpG9NA3hBiYzZyFErBPMEr8Gj4jt3CT/l8//ha+T5EKAazOb1Y4jGcN2X7LjIGxCtUvSFuDCCIgraa9EOIbIpEMTFrP7VUPU0f239rQsmImMb/puTQV84BBwLRH/gSBdTvK8A9Up+YWnKLMbBMTWiQP34UDPrTXgJyC8UFMmIKlZH22mAQIk6xWidPbFzvvbpRBkNACOLNE7KfnBVzVhm2scK4+QOyLlWZ4giS9kmpnSYv3w4nCpy9RxVvhKQmXUcrwn3zgT8q5/PtieYXMu5cnbi/JeQkaSnDEZ3qh26VCOqfmuDR8pOlcBY9AYX
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 05:10:50.7642
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6be46e69-9e2f-4c89-6252-08de6474ee2c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DF.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6463
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70295-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_TWELVE(0.00)[15];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nikunj@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,amd.com:email,amd.com:dkim,amd.com:mid];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 94645EEA48
X-Rspamd-Action: no action

FRED enabled SEV-ES and SNP guests fail to boot due to the following
issues in the early boot sequence:

* FRED does not have a #VC exception handler in the dispatch logic

* For secondary CPUs, FRED is enabled before setting up the FRED MSRs, and
  console output triggers a #VC which cannot be handled

* Early FRED #VC exceptions should use boot_ghcb until per-CPU GHCBs are
  initialized

Fix these issues to ensure SEV-ES/SNP guests can handle #VC exceptions
correctly during early boot when FRED is enabled.

Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
Cc: stable@vger.kernel.org # 6.9+
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---

Reason to add stable tag:

With FRED support for SVM here 
https://lore.kernel.org/kvm/20260129063653.3553076-1-shivansh.dhiman@amd.com,
SVM and SEV guests running 6.9 and later kernels will support FRED.
However, *SEV-ES and SNP guests cannot support FRED* and will fail to boot
with the following error:

    [    0.005144] Using GB pages for direct mapping
    [    0.008402] Initialize FRED on CPU0
    qemu-system-x86_64: cpus are not resettable, terminating

Three problems were identified as detailed in the commit message above and
is fixed with this patch.

I would like the patch to be backported to the LTS kernels (6.12 and 6.18) to
ensure SEV-ES and SNP guests running these stable kernel versions can boot
with FRED enabled on FRED-enabled hypervisors.

---

 arch/x86/coco/sev/noinstr.c |  6 ++++++
 arch/x86/entry/entry_fred.c |  5 +++++
 arch/x86/kernel/fred.c      | 14 +++++++++++---
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/coco/sev/noinstr.c b/arch/x86/coco/sev/noinstr.c
index 9d94aca4a698..5afd663a1c21 100644
--- a/arch/x86/coco/sev/noinstr.c
+++ b/arch/x86/coco/sev/noinstr.c
@@ -121,6 +121,9 @@ noinstr struct ghcb *__sev_get_ghcb(struct ghcb_state *state)
 
 	WARN_ON(!irqs_disabled());
 
+	if (!sev_cfg.ghcbs_initialized)
+		return boot_ghcb;
+
 	data = this_cpu_read(runtime_data);
 	ghcb = &data->ghcb_page;
 
@@ -164,6 +167,9 @@ noinstr void __sev_put_ghcb(struct ghcb_state *state)
 
 	WARN_ON(!irqs_disabled());
 
+	if (!sev_cfg.ghcbs_initialized)
+		return;
+
 	data = this_cpu_read(runtime_data);
 	ghcb = &data->ghcb_page;
 
diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
index a9b72997103d..7a8659f19441 100644
--- a/arch/x86/entry/entry_fred.c
+++ b/arch/x86/entry/entry_fred.c
@@ -208,6 +208,11 @@ static noinstr void fred_hwexc(struct pt_regs *regs, unsigned long error_code)
 #ifdef CONFIG_X86_CET
 	case X86_TRAP_CP: return exc_control_protection(regs, error_code);
 #endif
+	case X86_TRAP_VC:
+		if (user_mode(regs))
+			return user_exc_vmm_communication(regs, error_code);
+		else
+			return kernel_exc_vmm_communication(regs, error_code);
 	default: return fred_bad_type(regs, error_code);
 	}
 
diff --git a/arch/x86/kernel/fred.c b/arch/x86/kernel/fred.c
index e736b19e18de..8cf4da546a8e 100644
--- a/arch/x86/kernel/fred.c
+++ b/arch/x86/kernel/fred.c
@@ -27,9 +27,6 @@ EXPORT_PER_CPU_SYMBOL(fred_rsp0);
 
 void cpu_init_fred_exceptions(void)
 {
-	/* When FRED is enabled by default, remove this log message */
-	pr_info("Initialize FRED on CPU%d\n", smp_processor_id());
-
 	/*
 	 * If a kernel event is delivered before a CPU goes to user level for
 	 * the first time, its SS is NULL thus NULL is pushed into the SS field
@@ -70,6 +67,17 @@ void cpu_init_fred_exceptions(void)
 	/* Use int $0x80 for 32-bit system calls in FRED mode */
 	setup_clear_cpu_cap(X86_FEATURE_SYSFAST32);
 	setup_clear_cpu_cap(X86_FEATURE_SYSCALL32);
+
+	/*
+	 * For secondary processors, FRED bit in CR4 gets enabled in cr4_init()
+	 * and FRED MSRs are not configured till the end of this function. For
+	 * SEV-ES and SNP guests, any console write before the FRED MSRs are
+	 * setup will cause a #VC and cannot be handled. Move the pr_info to
+	 * the end of this function.
+	 *
+	 * When FRED is enabled by default, remove this log message
+	 */
+	pr_info("Initialized FRED on CPU%d\n", smp_processor_id());
 }
 
 /* Must be called after setup_cpu_entry_areas() */

base-commit: 3c2ca964f75460093a8aad6b314a6cd558e80e66
-- 
2.48.1


