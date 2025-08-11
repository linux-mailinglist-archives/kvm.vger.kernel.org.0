Return-Path: <kvm+bounces-54406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 23ED4B2047C
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:53:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED5C418A077A
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:53:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9E6B275B0D;
	Mon, 11 Aug 2025 09:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yjXPR9ai"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95091A3BD7;
	Mon, 11 Aug 2025 09:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754905899; cv=fail; b=mFF693UJ8EU3KCiUZPwSqxCq/bOmAw9jpmGLFkVKMovyJ3X5fMnCSdGvVOxoOmJgro1hGmSoJ238iNoWaAbGrlU5O7xwC/ZHIePDaOFIN37hUmu8XAAhxbTNDKWKA6p5OMqZkYu2jNKEHzEiCou9K5vKk2tkaqpAWsUBpbED5I4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754905899; c=relaxed/simple;
	bh=VSAb0bn4SyEMh4exzpeP5TEXbc/iDc7VRbj4HtyLBkI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jgaxvqLlxvQ+4UVZgUGm3mLyCa/0yaMPH8KupDFCFFMdtbgLof16ZDU1WARfIzirXrSvy5e++l6GpVTQ1CDyeaSnCCzA1T+GP7kIzpSErwJO8QU+jnwT0CUw08iZCLH/9kGICLGv0Bdo1POH55xh1FMaTiedMM+mPfp9JNq0wa0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yjXPR9ai; arc=fail smtp.client-ip=40.107.93.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dov6NKMbYOmpuK6BbTx9ok3VsxAeYMYH+pfWTa2XNgYI7nogsEmyqe57X0km2v61ffk4HT3zyaGgm4Lmc5TjTgiev/OCDo7OEjmiv0LBhZZ66ldrlBgUpMaFnOjZuiqBq3FIt037Zhze+FMbr+npsqzrIHxw7yxicPmozKgSsoE3bjq1/hx4GtDv8UxO0BHk2s+0YJOK0YhzyOasSv8NlLqfSTKHd52Y+O88Rxhq8N0V7kJHZZpW7QAoqJuXrKvD5CbsME9qDw138tZvJjqawg6eA+v6QGlbHzthCofj/bBzHXcpZsysoEhA9zYbpHccFcO2wDJQSHXklXOnUBaKgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OJPsBV/XfC3adQ0yO0Ptmve/rjtrCAkSXZmSEe1ZGQ0=;
 b=fvA/b9WAqMo+5DBsHHpFRzUlRpazdv1bOYGFhAzkgRMQ0HEgmbnooHyUHkxCGjI8Rq+SEy6leWdeu2Q+OhxbQmzaGbRmcymUwSL/9UIS0G06s5wQYSySjK6gwXoo1QsEa3lQz3+PjFfmR1kafxZ1Ven+09Dr0tNvbFCb61T6ZtXuIz2wkNwWiA7L7CKwxHX9yjNyCq3Sy9nbkmBdn7eE/gSpdothbcIRnURj142xd0lS4Lc/9/UDVIxfLtlrSDcuWS2nNM0YqASlki5y3rjuprru/QA+bKJtKXdHLwgtflKjX83zqWyShJLTnbTomvP1SscjSWRahwK3UrnSpi0baQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OJPsBV/XfC3adQ0yO0Ptmve/rjtrCAkSXZmSEe1ZGQ0=;
 b=yjXPR9aiiv+T86HCD5gZ7NcEpkRS6kXmnEDzWbEZHFpkQdoVMeDcQozQFQBtxJoxUHLTW6i4UQXwN7MdrspJuz2aKpkS7bAblcL2qFRedY/PbcKM4fjtTiWQp4I2t5KVY7XuxmVJw+iHzJF0FY8thWppHtKmUn/dU5wOJ2vdcHQ=
Received: from SJ0PR05CA0160.namprd05.prod.outlook.com (2603:10b6:a03:339::15)
 by MW4PR12MB6683.namprd12.prod.outlook.com (2603:10b6:303:1e2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Mon, 11 Aug
 2025 09:51:28 +0000
Received: from SJ1PEPF000023CD.namprd02.prod.outlook.com
 (2603:10b6:a03:339:cafe::6d) by SJ0PR05CA0160.outlook.office365.com
 (2603:10b6:a03:339::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.13 via Frontend Transport; Mon,
 11 Aug 2025 09:51:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023CD.mail.protection.outlook.com (10.167.244.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:51:28 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:51:21 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [PATCH v9 18/18] x86/sev: Indicate SEV-SNP guest supports Secure AVIC
Date: Mon, 11 Aug 2025 15:14:44 +0530
Message-ID: <20250811094444.203161-19-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CD:EE_|MW4PR12MB6683:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fdd8a63-f1fc-4551-9ae1-08ddd8bca4c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G3oRQDbdbz7fvv3LniR26HJ4odlKJZpykJi1d+nThAHbO0/A7ylVBMX6kkG6?=
 =?us-ascii?Q?bd7eHjTcRTNV4iP2QF3hxOmxiW7r/SQT0u0ozqfldpZJzqJ/e9EAdKlyQkpL?=
 =?us-ascii?Q?6tyJKfo+OfHQsf9BmEeDSekh3JQvuKKV05iUZNM3bxVZ/5Q2JzWqj/0CzwGC?=
 =?us-ascii?Q?l6SxYQ430bxQsv3jy7+D5m2XRbYe9iWKqeeda2NGcK8Zm6foXG9VEYNHX5qF?=
 =?us-ascii?Q?ZOGHbA8LqH0LZQvvQvFJQC7TtqulprTS5iUdP2oHsMWF/WIVXaD3upqrJ7Hb?=
 =?us-ascii?Q?69zOIJ7nmbmHI3g2m5/c24ZUTwu47WXNnlzP8QoTfbgWVqkS1E7p5rvXwVcg?=
 =?us-ascii?Q?lqAS9QwLbTCySoBxLsmqlLqV79/B9Go2bxael+8uiYVl+8+Nbq/8W84AUh1V?=
 =?us-ascii?Q?ZiUF0aPWnFARvzgmcDddNE/0iH5gi3uHD6j/ADVHrJo5WFGmwHksiKHKCU0Q?=
 =?us-ascii?Q?dSXoLQtL1d7ZvvCfZBqWwWvEP+Pt/0PCCrzpy1kHNxlIN7DXLOdYEr2vSx8K?=
 =?us-ascii?Q?kb+TmAd03II9F6d1QUMWJy3qS1+wMPc4tktFaD9aiP1XRJgYn+G5Qe5f/9FQ?=
 =?us-ascii?Q?OGqF14E4en4oD1TGYhLfyZXicEKj5D60jQAi4cHB7a59UHMSygkFbhcYFPrm?=
 =?us-ascii?Q?dvpiR7v202eoWQTmB1/ngG6xCFALY4OWAbtMd6X9Cx3wyNfQwDwxvywn8xRN?=
 =?us-ascii?Q?Ge0Q+McEZqjTQMSGDucsAc0gDLlqWCKE+xDgQ6oegGFW+sFqyzddbU1OdYPF?=
 =?us-ascii?Q?fheLtvvDSYNkflCBMZ2TVYBNsojCqN2A4rTW7Q4sFMcygPoms08BQJhTGG7O?=
 =?us-ascii?Q?ls7QSel0+7jbr70GUOo02Dhto+Q+W9W39VA1HendsT/vNmMDdOZuJOjr2GQO?=
 =?us-ascii?Q?n8AiUXhA24Jqny2wgLDCI+Mj3yPvjuGgSBRUg1DBl9eH3jl+w3BBS975yNwB?=
 =?us-ascii?Q?/gdF66kHvN2Mc46Eh2vKYZIV+0U3KNU/CLkMQcyRrIX/t8G6VyewIlUGAU9+?=
 =?us-ascii?Q?brxGjBkf3/2qCcw6ICGDH8nDByCwNi6wsWkFUfRxFoLngHWhfEzGn4gTfEQb?=
 =?us-ascii?Q?2SwmiRj5BohymHPV74y7nfhfpfeSQ3Cay0J9giR5zTqhoaGNU3RhmLwtzc2U?=
 =?us-ascii?Q?/918q0rlDP3Yl5k04Hgn1i4+rg/QsATL81TmzviAMZqHLk7ixUhd44aFsnit?=
 =?us-ascii?Q?AIUHomsIyQkSqJjoF6UjvSM3rBMLgWjjgEaqg00SZZ9gs+RlKq01TUgGesm7?=
 =?us-ascii?Q?t4JsGVDVRVD+JJxeCDCajt7m9mozaONePxjmefMRGdAp8HA6VrrYll7b23pw?=
 =?us-ascii?Q?kVlsvQkCNWJAsnVlI8qKoLI82lnXtxm4W74VoKpe8/k/gp+nbS+ppAVgSOPZ?=
 =?us-ascii?Q?7v9QXOg0Yep+L7sEKqABLVE0U2ROVLczuTVayrOUo8m84NOyxRQxt1i+5BPx?=
 =?us-ascii?Q?9Suu/4tgg2INrVy6yprZU4Tep+T4DSRDp0bzqkPop5NAAIm34Owaa/7qsfa/?=
 =?us-ascii?Q?AM7AAs6rHumN0thy78EcBZCs3eG28KrdgYw2?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:51:28.5002
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fdd8a63-f1fc-4551-9ae1-08ddd8bca4c5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CD.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6683

Now that Secure AVIC support is added in the guest, indicate SEV-SNP
guest supports Secure AVIC feature if AMD_SECURE_AVIC config is
enabled.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v8:
 Add Tianyu's Reviewed-by.

 arch/x86/boot/compressed/sev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 74e083feb2d9..048d3e8839c3 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -238,13 +238,20 @@ bool sev_es_check_ghcb_fault(unsigned long address)
 				 MSR_AMD64_SNP_SECURE_AVIC |		\
 				 MSR_AMD64_SNP_RESERVED_MASK)
 
+#ifdef CONFIG_AMD_SECURE_AVIC
+#define SNP_FEATURE_SECURE_AVIC		MSR_AMD64_SNP_SECURE_AVIC
+#else
+#define SNP_FEATURE_SECURE_AVIC		0
+#endif
+
 /*
  * SNP_FEATURES_PRESENT is the mask of SNP features that are implemented
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
 #define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP |	\
-				 MSR_AMD64_SNP_SECURE_TSC)
+				 MSR_AMD64_SNP_SECURE_TSC |	\
+				 SNP_FEATURE_SECURE_AVIC)
 
 u64 snp_get_unsupported_features(u64 status)
 {
-- 
2.34.1


