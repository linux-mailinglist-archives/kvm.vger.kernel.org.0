Return-Path: <kvm+bounces-34544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 637B5A00EB9
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 21:01:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C4033A0125
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 20:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC1821BEF7E;
	Fri,  3 Jan 2025 20:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FWICDPq4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F5A1BEF9C;
	Fri,  3 Jan 2025 20:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735934469; cv=fail; b=SoeQlMMTMpGolNOCY8DZV8147rUTGnhLvr5NtwhYosiobWcy6qv7fpV5NxW4O6KaT/TTmaKeZCetg0VoTPdEk+s2/sDQUR6n4eGB31tdJAi7M7owuvCxQURYAiGX3OX37p6MD/7w7s9qZwvJ5aUTXQXuR24L/1GwpWSs70o57l8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735934469; c=relaxed/simple;
	bh=e3L9DsLMZta3TZFGP3V8ILR11hrCz4RTozquZEk9UcQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YFXCki4y/AcfXYEbRImLJoWLeEPr8p4UYaJoyNYiSWJVowFJZ+K5auydtm/1IUbad15ODWsAuuCCCBfW36axtx+R988hEVF/OylvphMRyjwv+6VRThJLLuWSmOVnBNjGwJ03fImE2C80bCM0V38WVWbDgSf3Pdus2Y5W7tUY3Ug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FWICDPq4; arc=fail smtp.client-ip=40.107.244.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BgwcR8gsbz26EsNv7smAiSd1k1RsbU9JdQ4s3JD8Awzu1b5cKP7/wJ8QsdCq5dmhaUk25oJK00A2emQqhVYXkwv4Bl6b72htMS2x0c4PWQ0A4UqwcDwuU5K0tkAu6vUg1TzxDAhV8Q/NT2ybZKKFfuMtEGy3K6wLBc2rISpGhSMDqJ5CmUFt+TcrEEk0kLVi50uh3R1BkbFqhgVd/PE8jAa9Wr5WOqv5twUCzOAUPBd28H0mYxvK2XLF/xj3uW0GWX6iBkoti0+B9NatAjUEjynHKFZXiJnzz8d5Y+iyLscj+lGQTXOA410YjdoldKR2inzG8mf2qrBkhbawO/l5LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wsggXyd3M7q7o8HxFouKHNcmagYw1VBF1z16lrf7JSA=;
 b=pzZjG+wUglQVetRkTMWWQKH+/xM0g7ZSV4hdz4O/MkHJZ1LvhLSNucklEXG08H56h8ihC5t9BPZottadXZZrFGMMJn/JORhCczM/vBuhmxqPTa2l3xrPQ30auCNurVnTR+OMVV4qwDr+UPLetQlDrwqy3weV/0alSI22vOnCfgWpi73nSSC+uIkaxn2tWLVYm5r5zSYolSKSkehjxeD5g74Co9bPe7IKAW1KDUP444ps2EG3abU9DTc2pPS3qpEGe6cgh7Os1SWgkYSKnJzOOyEisdhjuv+DC/5tVwUpgK4msDcrp0FNIXL7OdrQih6IkTTtyEgmmP8gpT1uBmWRPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wsggXyd3M7q7o8HxFouKHNcmagYw1VBF1z16lrf7JSA=;
 b=FWICDPq4IGitU3wOJ3N+L6Jet3RQ9vn3MmVKxlJVWnbDNgZlk3zKtGuPvmuDCcRPMUbvCEpw++22pjtg8zZf40HpvZpAOtMckfXJXdPGCYQxyppseIeqFjoIHD9uj7w9vgn/j0PlbciwPShL2c5YsvxKp8P0TflVMTJNzv4ohEM=
Received: from BL1P222CA0014.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:2c7::19)
 by IA1PR12MB8538.namprd12.prod.outlook.com (2603:10b6:208:455::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.12; Fri, 3 Jan
 2025 20:00:56 +0000
Received: from BL02EPF0001A100.namprd03.prod.outlook.com
 (2603:10b6:208:2c7:cafe::d6) by BL1P222CA0014.outlook.office365.com
 (2603:10b6:208:2c7::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.14 via Frontend Transport; Fri,
 3 Jan 2025 20:00:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A100.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Fri, 3 Jan 2025 20:00:56 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 3 Jan
 2025 14:00:52 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v3 3/7] crypto: ccp: Reset TMR size at SNP Shutdown
Date: Fri, 3 Jan 2025 20:00:38 +0000
Message-ID: <425ecdc1df6566d1b76f7a8deb30471b0ce8dca3.1735931639.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1735931639.git.ashish.kalra@amd.com>
References: <cover.1735931639.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A100:EE_|IA1PR12MB8538:EE_
X-MS-Office365-Filtering-Correlation-Id: 867449e4-cfba-47e9-b044-08dd2c3155f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?INNlcRBG3wtigH37cNoHXQAMmrmgNaEY4PjII+e4ISd+sxBHr6GYU3sclpWS?=
 =?us-ascii?Q?jLDFZlpOkVqd+qII9IrQB2DR2eTzrIHNKE3pgkvyW/eLEoieQuInOqBtJBnC?=
 =?us-ascii?Q?MeUcU9ln+v8ZiQR8bhCl37ELJ7gNpan2H6AqF+oXEvtydQ2pWfmHtWeSSOwA?=
 =?us-ascii?Q?UmhK9zTFd1iFS6jIhFTuq8PoozNJjtvzPLFdaxjW3/fi2NZtH42AEc7bv24K?=
 =?us-ascii?Q?3pVmb4dB89N+cdi8zI9//fWZhjx9EOTAM0f+HrJKf/YC9aHZ+YGNvHpJWJCq?=
 =?us-ascii?Q?XV6+GpZcCKkHvBJINb7Sei33acVXYG1s+8a4I3xG4KSnLjtEFvm6CXCLeZ7y?=
 =?us-ascii?Q?fcHMt4JMSK2RvE5lgmeYNSAElyhVYpNKC1WKS+xrdKU54Wht5kLVAkd6gSrY?=
 =?us-ascii?Q?g1B8I1iWZ9xwMtbY91WN3pXguHAQi8oPAg9kxCxUQS91POf4pHoznqhsVNCp?=
 =?us-ascii?Q?NEkywY85CP/5iog2cIT8+Cx+QWD3CCvasB1ShtLSyK3TH9qBxhxiSRm5LhKZ?=
 =?us-ascii?Q?hp+X+c3higx+e2s/dN6Ls5BYrbJrBugWfzFqsNeQ5TRO/RCFfiKc9THpAx4b?=
 =?us-ascii?Q?oQ3flwNlFE4D6GEtbI0R8+DC1xE9e/7uDHkH3ysavSjxHgd0sLpw8Zyh/wwG?=
 =?us-ascii?Q?KXBOMtckCoUmsc3Vb+MzuDV4/nuES0sa4WyM00FoJ34+3lsWZWaiMj+nLEvl?=
 =?us-ascii?Q?6BAvNmfgzOih1Vi4LGFC28CPHWZ9BFDwSsfSNwlXCLh9BB5QxWbFmef5+NK4?=
 =?us-ascii?Q?yCGYwMuxcSMFIxCRWqRAR9ivlpyF0s2HagGsZrhU4e5YM6mzeWOr6gBNUXUs?=
 =?us-ascii?Q?0BXgbyubeooiL9d/qw8t2Vo3n8Kr0xL4lEIZtfS6UNH02hAQ4+0pYJRP9Io5?=
 =?us-ascii?Q?5a8jdl/9ODBnvtTjNkKjwxC5kHFo2QkDA4WcoSa9hi6t6Btr8laf9PyULQtI?=
 =?us-ascii?Q?visK02am2VkX12f/btArZ5uZ7vEsLS5difh2CVW4jHJHtzDPFepbUK2Y84nc?=
 =?us-ascii?Q?gKuQg95IB7Ceuy3GeKwxBqtnmuH+gRbsUQM46cZK5HP16AUQH7qw8YHJEy1p?=
 =?us-ascii?Q?qDxh3pUQ8+gkCWD8DDVLIuoljoJuz+oF1WA8eBdJXVpbgoKMWuWdPvS9nrRf?=
 =?us-ascii?Q?KO1NlaCISYc2t4qR53/zXsYmp8fdP9JuQsNC2alz1b7mNmMTnZOUCvsBH4Hf?=
 =?us-ascii?Q?VkH9TiAQIVu2a6c+DPagCGpXGyahwHXzXG5EqMvndXLIqoX2+CGqYbGi1OGH?=
 =?us-ascii?Q?khUYKy+wwdcxjduBvhEwUJxoCE4mkbg4/YxDI1cR3Jz5qVN2+X1hsgLebFdM?=
 =?us-ascii?Q?u60pjURQllm/SplwWulZKTQdwWVV5Qk2FyiOC2eZlK6ozS6DoQ4/0Xgx+PyV?=
 =?us-ascii?Q?5cAizcUUPtxfHyGD10PsIFLoI4ZggZj5Mwdy6oTtdJ/Ak+dbSf34mJm8dBO4?=
 =?us-ascii?Q?wfgtCnt1MJ2V2zJo0TTVo0Ks2NRfyhvuye16bUoS1ixZ4ARKwJ2I0rvqHJ9G?=
 =?us-ascii?Q?M9B+2Q8sT6Mlz1kPymP4E2Py/m8cVvAhrHCm?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2025 20:00:56.3103
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 867449e4-cfba-47e9-b044-08dd2c3155f6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A100.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8538

From: Ashish Kalra <ashish.kalra@amd.com>

When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB sized,
ensure that TMR size is reset back to default when SNP is shutdown as
SNP initialization and shutdown as part of some SNP ioctls may leave
TMR size modified and cause subsequent SEV only initialization to fail.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 0ec2e8191583..9632a9a5c92e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1751,6 +1751,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
+	/* Reset TMR size back to default */
+	sev_es_tmr_size = SEV_TMR_SIZE;
+
 	return ret;
 }
 
-- 
2.34.1


