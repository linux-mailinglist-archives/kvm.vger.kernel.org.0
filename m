Return-Path: <kvm+bounces-59871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A62CDBD1A94
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 08:26:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01E221886BA3
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 06:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B70E2E5437;
	Mon, 13 Oct 2025 06:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RFnWFkFo"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010064.outbound.protection.outlook.com [52.101.46.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBF32E424F
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 06:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760336760; cv=fail; b=pZkYji3kmFtoh4yJhfNx/XW4GXjSJGEvnBjjXgHAHpFTl2l8l2GvcYOrHyrN94GFwhJLXTNdVKVhxoitUVWEhSMWkW2+NwPKqtAff7oIuDPZp1rdjP56GI8cUuGvRubFVE/8X2MnY/xljlj8t2i+mFTsa/rgA9FbHSd6e0Ze5o8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760336760; c=relaxed/simple;
	bh=ojhD9uezaBnieMbqi1tj6t8bZlJAlbKz5edcQdxsFEc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GScZG8lhZipJWGO4hrK8bMa9hHYSTooPNvcP9CVB64KWjaPYWIYRONRJfZ3TMefsKr3LPBJl5xrOSo8wxiuDkXWsKL67iL0iGA4sT3G9DXEmJoCx1VZBRE0YJySePma6lK6nTPfpWf7t4XLCYydIaAiBItFFAhvrNw41xOmjKAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RFnWFkFo; arc=fail smtp.client-ip=52.101.46.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mF1hTiCJPc33E4/ZzX2RCnSwA9Vufz3JX4M+/3ZNbemSEMlUAhVr30JGtWASEVNt8ojw0ULLko0fMtKo8QBwF1sIt9ql2y2kqHcQ08227tDCh1A07+YtzK964r/YADs//pckXYezkQB4zhW/6tCL7HuxShu08qk3ve5g4uspCsqrebJZlNGyp3WNgUtjtTAFTJeDz5g5teFBJSopFIqtI2YLMg5lQkicQH+InHzgjYy7Om6eVjwdL9Xw6xqVoTC1EsIuodbVx5Ks1By0bIS+cnwrEk8q6CKY4OIIemyw32XiiJIPe8ftoc/lP5c68WIsywVpSbhMETbZ+sE7Cp51RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EsbIkxiycb2yH2lhvdC17H04SJq3TjWOqVnxHsraEBQ=;
 b=VMlQzjVMJImjmSmdPlGvnaT9wkmEb8kWZa2YxZZgH4WvLvxbHokfI5fFF1PAPWQFg+9WhsW8rD2bydI1CVGi9NRPoVfWKNl6Ox5dWrzYE3gsAir/wxb9xZNeIptSaiBpYBHsMCjNvqnqnqOxnOh1QBs124PUW0v97IBC5Yg1Yss5ZdQC0mbkwjeCj9kQ94qj60gV+sH3vfGTY0hEp1QI6q7GScQGht2k9AxIZpnkeVykio2+z4GaP8AcGe9UpnWx8k05KgBOiAgobsPjoVPzWRn0ZkTLhfDFMCAd+Q2CBUo5OoLeesbU3w/usxSN2c6UGui2tqZhrZSrF5O1pSa5kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EsbIkxiycb2yH2lhvdC17H04SJq3TjWOqVnxHsraEBQ=;
 b=RFnWFkFomltiR1A7AoJlTpJh91f1ALhmGarianyyl8ir9TOwtTK2Wj88aQ1hUz1+QUdfet/FljH0OktwHD2beG/QTZq742kt6oKkGdFUUW+kTGD2mHtzGIqR+R+VhzLuswPQVVo61YHj/FcVD+6tSu9hetXA96lyFQw8q3HPQuk=
Received: from DM6PR02CA0143.namprd02.prod.outlook.com (2603:10b6:5:332::10)
 by MN0PR12MB6128.namprd12.prod.outlook.com (2603:10b6:208:3c4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 06:25:54 +0000
Received: from DS3PEPF0000C381.namprd04.prod.outlook.com
 (2603:10b6:5:332:cafe::53) by DM6PR02CA0143.outlook.office365.com
 (2603:10b6:5:332::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.12 via Frontend Transport; Mon,
 13 Oct 2025 06:25:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF0000C381.mail.protection.outlook.com (10.167.23.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Mon, 13 Oct 2025 06:25:54 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 12 Oct
 2025 23:25:50 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v4 3/7] KVM: x86: Move enable_pml variable to common x86 code
Date: Mon, 13 Oct 2025 06:25:11 +0000
Message-ID: <20251013062515.3712430-4-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251013062515.3712430-1-nikunj@amd.com>
References: <20251013062515.3712430-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C381:EE_|MN0PR12MB6128:EE_
X-MS-Office365-Filtering-Correlation-Id: b4677b68-5dc9-4d02-b488-08de0a215cde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AfATy3TVai3h9QOvDjVotHJCJSfjpQfRbyEloNNIvoJnWW6/+rpNJPs6dl13?=
 =?us-ascii?Q?nn+4qlJYNK/NaObW5Swvcmmp95COdUAtxIGqGZ2NeV55WJa5OjndV5SxO+HM?=
 =?us-ascii?Q?yryp9HIwTMA4gWLZhoLRQWb/kEBtSeriO5dsM9zzjWSWuBIWwQbMDpQPIwfR?=
 =?us-ascii?Q?7hDceUe57dfK60j33qKwTqYPYAzRhab3ZpX39wdHj6oTKHAp3do9WMASaEov?=
 =?us-ascii?Q?apAc07ssedrH2R03ZCLeenLUIV7fdvSxmNe50qro/3GeREkWYboMD4B+vqHG?=
 =?us-ascii?Q?PSwPUHf4dflW/OtF0lT3xZGZu/dAgBGdzrJNc3G6RTTvjXoDQ5UX+wWynv4/?=
 =?us-ascii?Q?DhgXJZumusgf900NFJdPzigJta2XThpm1TG3qqbaSiN8eI1ioeStnQ28FTfV?=
 =?us-ascii?Q?/0b3eBqCuHjhd98ih30zcy04y72KSh+zlC4TL36XEXQ+byogaZUtBKQgThmb?=
 =?us-ascii?Q?e5CNl139DK4/AHjPs2J4O5lkZdoaereXXmrA48Z11Y1YQZlMiy0ODgTXyN7q?=
 =?us-ascii?Q?EoSesGSrEoUWXxVRT8dVtrk6vTZU4qkyhoGzKPmL6le/XOAWknTt4pmkVwQe?=
 =?us-ascii?Q?1yMSC2dYvA4puP/9QuGo39MaXp6ivE/me4mWrWkoJ+JTRuav80JIZotBqJse?=
 =?us-ascii?Q?9Up9mP4xXNpxM3uHOBDjQeR7gyRBZX0kMoisjO/47TMbv/ZBEp9tcmbjAjc+?=
 =?us-ascii?Q?NE5qw4zoG5hnNNQ5aoeZEMm9dkUKJ48K0wVi0fIrWOjIyFNXvmuOta5X9Qju?=
 =?us-ascii?Q?AA1VJsFusIgupBoiIkJw432FlwuqaDNgX1voJ/J2aZMaCz9TJ2qTN6/tLjn7?=
 =?us-ascii?Q?JCPKkB4vwG1/CrvVd8wk1fXM/WhpUXjZ5xc4lfxDcCVlRCxDka4MEepQvyI9?=
 =?us-ascii?Q?msqpY8/z+NvF/nkmlV87hysz0Lj3MR0d3zMKpp3LRPMBtGvR+gehv8Tsu8Ew?=
 =?us-ascii?Q?1OnZvSW0mmJM5PMnORPyFWUoYDY9nYAf6czJfaGkyuqBOQXsz3FGY5mpNKfr?=
 =?us-ascii?Q?7OtffOsQPlPnxkQHd3cfkg7JJ0TqHwEfkqlO95oyUFySPC/8loFIjfwmgfPD?=
 =?us-ascii?Q?w+h9WCxppmUuwiiXeg9dg0aGHfoULNX3tayqYExunJV+dXiVmAyuO8I5DZaR?=
 =?us-ascii?Q?tOo86ZRoqoElI8gSkujIT1rJ3TOw3CAaFO8oT9Mft8/atkTOQZN5HTIWHoJs?=
 =?us-ascii?Q?k4Wnk1ul2YuH6v5MEot257KLjtq5xjsZvIOyfqwYRI9fit2ZF5nnLkv8JcT/?=
 =?us-ascii?Q?9yfp4fOg36WghAhLOahiFMF6KXdoq7ewbq0SFb+en3ZYzg7SozB31zmqsxnv?=
 =?us-ascii?Q?brLGoBY9qJTWzNE0uQaYoKfwYw3KCmJxDTYtQJJ8FNvLLYbSAtI79jKV4iwh?=
 =?us-ascii?Q?/Wt7QKsPSw23KKGvOVpzo5uFWg38aw5YrxtLX06nw7neaF8TFkdP8VaIUBA7?=
 =?us-ascii?Q?Vuj+0pCOIZRCncLgbHZDhqx8uMpFHW37HAwo9Ax/D9B1YBha982WbIDQJHXY?=
 =?us-ascii?Q?MfeZMbktMaJMkBhLnVUGnWIaWrnfUGxWCA8Md2Q/ENGDsZ5aIcZ5XuhWIWaW?=
 =?us-ascii?Q?A7EcHIJFrsdG/5wPbYk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 06:25:54.0693
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4677b68-5dc9-4d02-b488-08de0a215cde
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C381.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6128

Move the enable_pml module parameter from VMX-specific code to common x86
KVM code. This allows both VMX and SVM implementations to access the same
PML enable/disable control.

No functional change, just code reorganization to support shared PML
infrastructure.

Suggested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/vmx/vmx.c          | 1 -
 arch/x86/kvm/x86.c              | 3 +++
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7e5dceb4530e..73b16cecc06d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1991,6 +1991,7 @@ extern bool __read_mostly allow_smaller_maxphyaddr;
 extern bool __read_mostly enable_apicv;
 extern bool __read_mostly enable_ipiv;
 extern bool __read_mostly enable_device_posted_irqs;
+extern bool __read_mostly enable_pml;
 extern struct kvm_x86_ops kvm_x86_ops;
 
 #define kvm_x86_call(func) static_call(kvm_x86_##func)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aa1ba8db6392..81216deb3959 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -127,7 +127,6 @@ module_param(enable_device_posted_irqs, bool, 0444);
 static bool __read_mostly nested = 1;
 module_param(nested, bool, 0444);
 
-bool __read_mostly enable_pml = 1;
 module_param_named(pml, enable_pml, bool, 0444);
 
 static bool __read_mostly error_on_inconsistent_vmcs_config = true;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index be8483d20fbc..2b23d7721444 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -241,6 +241,9 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(enable_ipiv);
 bool __read_mostly enable_device_posted_irqs = true;
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(enable_device_posted_irqs);
 
+bool __read_mostly enable_pml = true;
+EXPORT_SYMBOL_GPL(enable_pml);
+
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
 	STATS_DESC_COUNTER(VM, mmu_shadow_zapped),
-- 
2.48.1


