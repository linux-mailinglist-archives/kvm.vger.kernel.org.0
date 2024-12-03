Return-Path: <kvm+bounces-32907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A42B69E18CB
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 11:06:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 76808B3684D
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 09:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06CA61E0E0B;
	Tue,  3 Dec 2024 09:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2Ar98UrJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2074.outbound.protection.outlook.com [40.107.95.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915E01E0DBE;
	Tue,  3 Dec 2024 09:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733216506; cv=fail; b=jYuVJ2BLEZMoTdm/Xcfn29vEthXxOrWGPlz2n8uVq/JYJqGX+2hDQGCjssqTeN598ot1GU+FX2IqHyRwIm1ifa008DiZnWqKLw8X9zhHp1nx7JnPjEeUrOyxXXDum0WuWTrZEIo8LNfhDf+dPZl5oKnuE01cLMq4A2KTMALov/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733216506; c=relaxed/simple;
	bh=P1u32rIZ+FqWAL216aVVfOa7lDFV7oeVfPh5C68lBK4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e9NrqyzQD1kXidR3wm63pkzC8/DC6ocbc4hJgtYCDOwj1WJeOaoobKd5JBDgT9wlQn/rgsamW3HGERTmSvRDTQIxh07n221uFEPzfFozj7Vp6dh9Dr6STrxUn4cqZ8CM9d294N/X9mjxW03USRse2ilD/hE1dwo9ENauuxEB5os=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2Ar98UrJ; arc=fail smtp.client-ip=40.107.95.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jr2Jelpn2wnzOUY0zXfAuNNDbJKAY5Xucp33RcrZnj2RIZZ5QpOtl/CuxkwEM/BBJIB4yegFokOMNqh2q+SAEx+f84EEdOabGjJ6T770vSsKLjhtOWPJ+tQFawYg0vfB5xAQpTtsJtRePJ3zJClo1nHpU4ZLq4oiJ4Vtd15WZdzpiW2p5bOFVKmE/uIetup/NgpjtfkgFvtc22qNyvg0Ct+mIhaQUD451E6YJ9YqK06auQsMx2F67xcq30X1UpsvCe+yadddr3doC2MbJe3asL9DkR6E+VkgFNIa69HIyDxMw7olSiw0a3RbZG0Mv8x2T8pp8NLlidVnq06hV3HM2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TnFNgpFnVxXh6rkEe/mdjR31OUGytIueqp5ARvjA/74=;
 b=gPbpon0QC8G6zs+FPiaV0HaeV2aXAfFYfkDeIaCahkZOGsOAnCCYBhpaWRsG3DmEbpo2v3hYMafeypug67Q7Qn9EEWljXGDAL9P+BmaAiUoyOOcGLbjEzjOtN6Zk1R88fiYAZWjUz+gZ6tQHJeAAT0MJfMhqq+7a5ecuvlM7go3oYvVsLiMLwLviw8fVq7XAJlb2MHNMwrBPY7Uy0Ruwksl4rIF8gqhpyjYHOpGzxKWakH62Glb/keQcQzquPpJejuoaFcphTaAyrzOuPmepbXPQjgGfF6KO/EKptub3ky4X1FQKvxN9V1ib1UKfaB88i+8hQUblZed7Ura2TyD1KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TnFNgpFnVxXh6rkEe/mdjR31OUGytIueqp5ARvjA/74=;
 b=2Ar98UrJvNKGWKSVW1GIw0kHiu+264m+ciUd4RLN0czgIbGqnG4oTxpVcRg5SWWniqYusa3lRRfUhCRkfJIxKMCfhjlRk7ELgkWzAHmwbQLPUj+no+22lGhB4+f/VSHbqd1QLDZw7kAGZ75cw3IjhHdl92f1a0jimeKqwcadH4o=
Received: from CH0P221CA0036.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11d::14)
 by CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Tue, 3 Dec
 2024 09:01:41 +0000
Received: from CH1PEPF0000A349.namprd04.prod.outlook.com
 (2603:10b6:610:11d:cafe::be) by CH0P221CA0036.outlook.office365.com
 (2603:10b6:610:11d::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.18 via Frontend Transport; Tue,
 3 Dec 2024 09:01:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A349.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Tue, 3 Dec 2024 09:01:41 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Dec
 2024 03:01:37 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v15 09/13] tsc: Use the GUEST_TSC_FREQ MSR for discovering TSC frequency
Date: Tue, 3 Dec 2024 14:30:41 +0530
Message-ID: <20241203090045.942078-10-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241203090045.942078-1-nikunj@amd.com>
References: <20241203090045.942078-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A349:EE_|CH3PR12MB7548:EE_
X-MS-Office365-Filtering-Correlation-Id: a98a3ae7-a62b-481e-8db2-08dd13791a71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zQ2Wmrfr6yRmIj5a5ePXd2dusK9+QG+JA4+0psTDlw73rXcv4ddFZShjraUX?=
 =?us-ascii?Q?q9YTwPnVFygsTnlrmr/fUxRYP3HkXVZbxZAcHU3yPikiEjS6pY9BxvL9U/1/?=
 =?us-ascii?Q?+QgnsNp6ZoTw17E+copnFCQ75Geps+wTiOZwWvYkiEd/mFiCTxbvXj3c/pnO?=
 =?us-ascii?Q?8q5X8F3r3uHfkrMnwWFYYciNDQwBZKP5uHdqDMXC5zw9mQWmwLz+8S6xOubl?=
 =?us-ascii?Q?zWVtHHr3iIlIss4eeCuErKIIrwS2u6pVX0Q0wp464WIcq8QUTUcPppnkKpOf?=
 =?us-ascii?Q?u35Ktizn04GZYeM21Np70pofn2JfsROY3rYsn4wzryHd0K3H4RbxBJz7knk1?=
 =?us-ascii?Q?YAqC3csMCQFcuTPnLUgcvDKawTJInRBGBJMa4G0A49lfL98CdK4VOXVpT+O5?=
 =?us-ascii?Q?P1DJpsWafTGoSf2EEZcfMKqBKjTDHR3sodAMFUYy+n6BPptLdDUokO/brstW?=
 =?us-ascii?Q?El1Nk0mYwQ98uxynROzZrwSiSHNZx0xZPiRi+keN7rC/nPuOwypl65lr1NwV?=
 =?us-ascii?Q?i8ZKE6b2/U+q+P/haXXWn0VVJdhOQq4h1JFJ0EHcjGohv95XBS2mI3P/Y80Z?=
 =?us-ascii?Q?6ckO/YbZ/lKcgVknYR+IXywzLNlgi14mFB9YzUKnBSTpXoQ7bAyhES031dAM?=
 =?us-ascii?Q?mDBKFqLAGc0bXNPa0eS0u1W36WlJEiRy+JaE8O7kxeLmzu08eTTqYElqJsyr?=
 =?us-ascii?Q?IbuMuWzMuYeXsdTsJoDpsj9PnYKKguTv+caf8tqM9E24Xim2BaxiEBqRwRv8?=
 =?us-ascii?Q?d1ocu23KctTZcI8loz9ReZ3FbShzkbFis4Hg8R1jnVYiRFXsduHu7/CUx5AJ?=
 =?us-ascii?Q?fNWYdD1JcQ0aB9cphdG4hl0ielmpQtCATbN6O506WfJejpchehOwDEpPitS3?=
 =?us-ascii?Q?7XiXfCMIu12Cu/ggDepn3dGsPCt5gGqoaeVI9TWFceAmEKn4AiaGHXn+qiiy?=
 =?us-ascii?Q?5xNpIAAiz2akF6gjM8H6HB3TDjZQZ5JG3vxVtxVONg0qja8kbbpb/md2kIXR?=
 =?us-ascii?Q?8bhm/inGA+Tz6lTIPuF28ZOr+fjqmfhjx03O1mUSiCGSRINxGGfbQpzh1vyO?=
 =?us-ascii?Q?EcuMKJyBDl7dqM/pyCDrqRyIpo84NzxREV7ZPLnxORXcVxPt65zozkjueeJ5?=
 =?us-ascii?Q?h0jDqWkt8hPETQ9mPyHNWoJyFsXhv2JaQ3ogRe3PytT3Q7MrSAzKlkxl6ywZ?=
 =?us-ascii?Q?BE+jU70OZ0xCrudcHQGZhQaCYbTNI6VklKAXlH/7eFVXCyrwHeqS6LFZ18M8?=
 =?us-ascii?Q?zR/QyI4+Y4AkspVJpf5DqHvG4cDRpyhthWv90g4+ZC5pS2yRiX0qEtGgGD23?=
 =?us-ascii?Q?Rr8pGl9Mi1/lig7lVkb1i42WGhWHXX4P6Y1euRv+7ePCBgpoqvINCI9Xaw2W?=
 =?us-ascii?Q?Qc9SmKKB0VHARaI5bfWb1g6tP69qI9l4d5M0Wnr2+iagvnzavjKPOlQ35AF3?=
 =?us-ascii?Q?7k/c2h4xc2bA9+e/zGtu1RSFoGTP3+jj?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 09:01:41.1317
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a98a3ae7-a62b-481e-8db2-08dd13791a71
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A349.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7548

Calibrating the TSC frequency using the kvmclock is not correct for
SecureTSC enabled guests. Use the platform provided TSC frequency via the
GUEST_TSC_FREQ MSR (C001_0134h).

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev.h |  2 ++
 arch/x86/coco/sev/core.c   | 16 ++++++++++++++++
 arch/x86/kernel/tsc.c      |  5 +++++
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 9fd02efef08e..c4dca06b3b01 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -493,6 +493,7 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
 			   struct snp_guest_request_ioctl *rio);
 
 void __init snp_secure_tsc_prepare(void);
+void __init snp_secure_tsc_init(void);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
@@ -536,6 +537,7 @@ static inline void snp_msg_free(struct snp_msg_desc *mdesc) { }
 static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
 					 struct snp_guest_request_ioctl *rio) { return -ENODEV; }
 static inline void __init snp_secure_tsc_prepare(void) { }
+static inline void __init snp_secure_tsc_init(void) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 59c5e716fdd1..1bc668883058 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -3279,3 +3279,19 @@ void __init snp_secure_tsc_prepare(void)
 
 	pr_debug("SecureTSC enabled");
 }
+
+static unsigned long securetsc_get_tsc_khz(void)
+{
+	unsigned long long tsc_freq_mhz;
+
+	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
+	rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
+
+	return (unsigned long)(tsc_freq_mhz * 1000);
+}
+
+void __init snp_secure_tsc_init(void)
+{
+	x86_platform.calibrate_cpu = securetsc_get_tsc_khz;
+	x86_platform.calibrate_tsc = securetsc_get_tsc_khz;
+}
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 67aeaba4ba9c..c0eef924b84e 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -30,6 +30,7 @@
 #include <asm/i8259.h>
 #include <asm/topology.h>
 #include <asm/uv/uv.h>
+#include <asm/sev.h>
 
 unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
@@ -1515,6 +1516,10 @@ void __init tsc_early_init(void)
 	/* Don't change UV TSC multi-chassis synchronization */
 	if (is_early_uv_system())
 		return;
+
+	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
+		snp_secure_tsc_init();
+
 	if (!determine_cpu_tsc_frequencies(true))
 		return;
 	tsc_enable_sched_clock();
-- 
2.34.1


