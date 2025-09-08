Return-Path: <kvm+bounces-57012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 87682B49AE4
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 22:19:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2FAA31BC5FCC
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 20:20:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7992DE6FA;
	Mon,  8 Sep 2025 20:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BvkzWVXI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2071.outbound.protection.outlook.com [40.107.96.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65512DAFA3;
	Mon,  8 Sep 2025 20:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757362732; cv=fail; b=uOYrFVvSkKomWbb6sPZMQ8+eFg9YrFKxrKDoa6eAf8815BDgBvPtOJf5Wpnsks+jh2vKxbpVpSZSBlC8Vys0yaAvzWxuRt3G1iSBV9aPWFZNPltLxqoWPH60y3Tox0dTA5pjxHtXV6Ww8vTF6k9dphnZba2JsxkzSuTUGPQ0S9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757362732; c=relaxed/simple;
	bh=R/7oePEjy1uqVFaEnokj5ZGdZlOvaf/sADacaF8lYeM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OKdhydltEH74KLDOdHlvzpNJtF1pOEtZ7qgXth4IsSHOY5jo7MwaKz/jZEcyUOjWdytXoVCtiJDqVocHt3lonu6iEu5uVFXn1hAjcJbRydFuC6BohDnfRiQVi289yzJkIyh3AXgIJlsESeU7FJduegyAbLP2qcpMBDXKBn5j5Ws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BvkzWVXI; arc=fail smtp.client-ip=40.107.96.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XxloiLvqcvBEF5Gnm7JM+9qVtf6ku8PNdJd3oPaDPK1FV8irz52T5tAm9pSAZSZX8LyWJ6v59KzMTpF6dNV0WUCjhbVKOwpp4etCDrFhAZS6+rSTWGhuHyBBgcluGxjh54pVEqyK7/ICcddOuCHpuJrmXdikVhJZ3y35XkRvSitKOrLvmfBjiMAwS1CoGDvSkFsCsDExBAVcWE7tgFbFA19vv8yTC7oSnS1ugyNmHDXJEJB7SjJ8qU5LQUZ1swEFX1PcPhW1e1jZ9PMNdO6RVpbgpVSr6MXBt/dt3YHJG3xP6KPaZtgwG8u3OouSKl8ja8XmlZTH4jiFe5/pHKfoig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HIsbIXjSMhj9bBhIDKJu2MMua14eDOmoFxg79/p0gxg=;
 b=CwC9pSiIhn9BSuHhvnxIiTLJgrqi2jf5QdFPOm2k15F8+OXzIVnpgX8n+8fsjEaP+EPITHUhG+pFQOUmcb6v9QJy3qzhn8I/rI7Lscr9uwrAYiORRLn53uEMLFIawwxrw+99U7PVjzAGs9V/MJdirTRjW09U1FyCXLSRWQHXy/t3t7HDxRe0FTEN5kUX214XRAeS6oDQHz/YPFuiqcKHrpjJyq+dUt9CJWbFUgN79urIDeytG7pkoTNoWKgqPvGNso1ZSeyFYJP6m1a/pxbRGmRfdnYtyTy0u8Kjx876E7n9AOb7pwZu6W08LY89Hbz1E7xeGQLASxU8P0eK2MwPog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HIsbIXjSMhj9bBhIDKJu2MMua14eDOmoFxg79/p0gxg=;
 b=BvkzWVXIbv9CKMCF1eJsWdbQCgUwM1/frFg3YsBLTpmUOltyU9GOuEJcmAc1bawo9ezDovTRhFJJy1sGp0nAMZoaC3KfQFf3dI6a+I9Gy+kPEcLHF/OHGxC37+iNXniW6Ufbo4oYgW1bSy8iqgf7OCBSwtKKXWA5K+ZejtkzvO4=
Received: from SN4PR0501CA0071.namprd05.prod.outlook.com
 (2603:10b6:803:41::48) by PH7PR12MB5593.namprd12.prod.outlook.com
 (2603:10b6:510:133::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 20:18:45 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10b6:803:41:cafe::4e) by SN4PR0501CA0071.outlook.office365.com
 (2603:10b6:803:41::48) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.14 via Frontend Transport; Mon,
 8 Sep 2025 20:18:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 20:18:45 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 8 Sep
 2025 13:18:36 -0700
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v4 5/5] KVM: SVM: Enable shadow stack virtualization for SVM
Date: Mon, 8 Sep 2025 20:17:50 +0000
Message-ID: <20250908201750.98824-6-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250908201750.98824-1-john.allen@amd.com>
References: <20250908201750.98824-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|PH7PR12MB5593:EE_
X-MS-Office365-Filtering-Correlation-Id: 731e9415-0291-4f53-a3a1-08ddef14e9a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MqLXNTPUVrH0rFZpwu2reOop/GxvwIC9RZO2seDXTFyesnqF839YhyKK0Vj2?=
 =?us-ascii?Q?l04qVUzuyFv1xB44sLUaulT7vYrF54DH9bQulqa8y6BIbI+ry80PPB6ncGKp?=
 =?us-ascii?Q?R2U0lGNoKr4ZmEUUstY/cA3Qp5DwO9OyfsmW0/7x+12v6Q25V8I3ygNUBnxO?=
 =?us-ascii?Q?WzIkuFjdbtfshV33sjVvNnsDSHAx7OWlPvcTS8nUDCZjkaPoITya/i3b0+sl?=
 =?us-ascii?Q?bMJwO0yfeOYfcHkEgul8H1ePrtjc2aYPFD3REwQAyjQkOfMqLvZ3bcgpp5Yk?=
 =?us-ascii?Q?W5FBBUdg5qnB/FEvbuxZjwFo1yN+2hFJwiEOmsyw9O75zStvKHB4/4SYkeFU?=
 =?us-ascii?Q?PBakq8KqIWK25ciEVr7BwgnyHHqvl6Vi764YFylXhP7G5CoaXDRhTcRl6E2j?=
 =?us-ascii?Q?NfH1fDJ11hAb2kD9NO+ffkF4/Fbsc41itnslOwjkA3jmrRjrMezTmsg9arGk?=
 =?us-ascii?Q?kfnlsh99P4m0PzoihD6SNEN1u8hGXcymhRltZU6oqpn3JoAUpQvtscWefQZr?=
 =?us-ascii?Q?UT/BMP4cAEbEB4UFdy8sC/SyOnop2Hwfn4kNOvsEzwJ3jTI4gY9SzoBLek5W?=
 =?us-ascii?Q?x6tdtGerxeS67AGMhi3C6YW1JI8vzZxVFSaE0NEuiYMIPeArwv6lyUQ5Hh0k?=
 =?us-ascii?Q?c6UDlaO1egHpiXJAWVznKVaSfin/V2p0opIaWVrUMXguR4HBTCiEzhkC+ScM?=
 =?us-ascii?Q?T8H323xxbljUE1X/Le/2kZZXAf6zsPduSJAEXAXBkE+nvwqNTqiUDmiM8OWP?=
 =?us-ascii?Q?PtLl717ixfTpGhSIfh8V50EoDZuRN+dkrSIvtMzYFPpSCsx8ssBRTAq8mf12?=
 =?us-ascii?Q?/WPGUwMF0NTBJLV9b2atS7UDiovG5DQ90L6CSOwVj9YBO2xxlkkk7MCdlqT7?=
 =?us-ascii?Q?InPweuxVUOX3reb/8j9U8mGUwfRbMp+S98TsqHK7scDl/80SeQzrZ7OLYfNL?=
 =?us-ascii?Q?E9HcPqVxEw9fUWjyrSFXzsYPos0rC1k/f9LmEVZPeufEZ81kJMasT6BuJiNr?=
 =?us-ascii?Q?FQ5mXRY5X5jXgJRZV3w6m+XsKqF5ecCQa6nwqjaqwEBwoOqFzVPt0Syomf/A?=
 =?us-ascii?Q?zXdKpnvD0/exfiBm7Gcm6auXJ4OhmhWO7Tqkkt91XD4DP7iYlDFScQz7kKxe?=
 =?us-ascii?Q?gV29rsrBj+UKnqjhzFDoUtNjdEgIQ8QBERGZMEKQ+wIOyEbEgk9jBqKgGjl1?=
 =?us-ascii?Q?smU7qISBDsG12DvHGeJkFd36JVgF01jPU9SscFpOFUFuu5SeegMopXW7SBDx?=
 =?us-ascii?Q?Co8ZxCrgTnLQ6l4k6grorKPrDXFrNIVjQIqEi8EMoXE3f+YApR+tZnHWVvoU?=
 =?us-ascii?Q?s/2qbu+ED5YPxg7xKtDel76dnsV9uKYQvzo2GKs9o96FWY931lgBPonCtzeX?=
 =?us-ascii?Q?Avsc4OSu/+t7erWX47jEu3crQdgzLafWbgR+ky/pTaD9vpH8w9aCjQ+M8sVX?=
 =?us-ascii?Q?2qwQQoJZi9HmGL9bOIYHLmAjrt0FBiybHlOstq0OLdeAQxd404fpnIX3zglz?=
 =?us-ascii?Q?jf6HBHEE9i2syT0pXa8ToZuDcrrLKRDFIaD5?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 20:18:45.4221
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 731e9415-0291-4f53-a3a1-08ddef14e9a7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5593

Remove the explicit clearing of shadow stack CPU capabilities.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: John Allen <john.allen@amd.com>
---
v4:
  - Don't remove clearing of IBT feature.
---
 arch/x86/kvm/svm/svm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b18573b530aa..304531d6c8b0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5262,10 +5262,7 @@ static __init void svm_set_cpu_caps(void)
 	kvm_set_cpu_caps();
 
 	kvm_caps.supported_perf_cap = 0;
-	kvm_caps.supported_xss = 0;
 
-	/* KVM doesn't yet support CET virtualization for SVM. */
-	kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
 	kvm_cpu_cap_clear(X86_FEATURE_IBT);
 
 	/* CPUID 0x80000001 and 0x8000000A (SVM features) */
-- 
2.47.3


