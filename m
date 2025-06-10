Return-Path: <kvm+bounces-48853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 47C9DAD41B0
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:08:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 28D2E7A2194
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8770724679A;
	Tue, 10 Jun 2025 18:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GPkDtby8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4956623D290;
	Tue, 10 Jun 2025 18:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578901; cv=fail; b=mhLbvTLUIQARAoYvbrts1NXVGc+Ka7/R/3QXPVdQEDh7C4rtywp5nnJrQUHKN3Mz4jTj7WmosHXj8Z0CELL/XiX8Enu+rfh2JF7AawQ8HUUGEtKzTAqPyexlNOvpnm0NBv15h7Hkyd9SMtjc8MEuAR8r6rVXOfRk1Y96J6Kegm0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578901; c=relaxed/simple;
	bh=PXBM7CWJHllJbbd6gsMbS+DrBfhF6ZLqq97Pmw9xOcQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DmvfHjlv3xq5JzKLR7fne8AmxQnUboRp7a93zVb+o70iLw7rfI2l5F6B5ByPxvPMYbnkX0NmimC09hYTRaqMx12wf/CP0n4Yz8Ide+750XhZ9mhTNFBV3LiFSDB7fjhNgk9Sp0qcB2wnqQT97w2q6j7180Ym13/FjofQMUU01nA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GPkDtby8; arc=fail smtp.client-ip=40.107.94.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N0aB4zHKDnVF00uvbx4I5t4/EP2pbwPGePEvwRHD9p/yRV53qUmNF+A6pKVpsm6RfGtJPpIQ0rXMIk9odWd6nr5Cph+J8zVZFFU2cze8Iul6RjGzwSZmQBmv2DSH/iNYm+uJF6bXpegvmMV/lM5Q0wNfey+84edsVuf74e9t+OlfY81Nryz/weVIGGFBIt7EXvuXEQz4UHKzVZsK/r67FC7iB1hxN02PvSZuRWaSgnBK5RPAomAZDYRUMVI4kuv5M4TuQzaFnXQLJnPrmaBN+rNPJp9q2kKZvmq7tcwCraTSEFcgiDbeZUBtLii0cGrnwIZob3QL2gMrUJvpyqTxyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yZxPCV8CvX4H7Re+QmoyDX/IN2RAT2UtZXiIthq1+H8=;
 b=DYpsBM4ja6uEDi6RpVUcneuKfeIaCsO/LVzKajD62W74rkGMrdQu/u1JkpUmp9mjnm6+WFCL9qBBCCD6Pr5UvRmbZlTydsP9l7Z7uzZmipXGXJBtHWX9QqbsjGDnGuuq59SNMsetmbkf0EfttLu2b5EuNQWlMiIb5Wqef4Da3IYYCD+K0ziXNZSV/dZ693Q50Hbx2M5s5Orxj+DGx+OEFsU/OH/Ui53nwRxl4Syx1UumEqqsxL2QzjLJ2N+DovH2f+X5J/ZXam8fDxrNhgshEZ6AGzedsowTDGXZnBbIdNd+W/fCSZdCSA7tq0MMKJ5nuvK0DRVnp8DBCvgp5S/LBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yZxPCV8CvX4H7Re+QmoyDX/IN2RAT2UtZXiIthq1+H8=;
 b=GPkDtby8usrt13rTKYQgtoV15/NwR5KeEy2/G/w1TLJZH/NwURheFA+e8jNvJufhFO5XJDGeidar9Zd7NbjX2ObxCMjbWnefz7dr0NLrcnMwldMVJI0NfUXYY+FQhD8ellLh4fjtEEsaJYumVYDLwHoRwtr3F9XLe0LsJKysKME=
Received: from CH0PR07CA0007.namprd07.prod.outlook.com (2603:10b6:610:32::12)
 by CY8PR12MB7537.namprd12.prod.outlook.com (2603:10b6:930:94::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 10 Jun
 2025 18:08:18 +0000
Received: from CH1PEPF0000AD7E.namprd04.prod.outlook.com
 (2603:10b6:610:32:cafe::c2) by CH0PR07CA0007.outlook.office365.com
 (2603:10b6:610:32::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.24 via Frontend Transport; Tue,
 10 Jun 2025 18:08:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7E.mail.protection.outlook.com (10.167.244.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:08:17 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:08:10 -0500
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
Subject: [RFC PATCH v7 37/37] x86/sev: Indicate SEV-SNP guest supports Secure AVIC
Date: Tue, 10 Jun 2025 23:24:24 +0530
Message-ID: <20250610175424.209796-38-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7E:EE_|CY8PR12MB7537:EE_
X-MS-Office365-Filtering-Correlation-Id: 45fb673c-6d1d-4b4c-d15e-08dda849c6de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/cu5FnAkbVaxvQQjcblv335VTMEhzUvxshJMJzWrvVMfm7BNeCbET7/uaKKc?=
 =?us-ascii?Q?++iF52FJBGxzzs8nxe0GbPMNK6GoWpNErjIqK2WdMlNZO57+N2KFVBw9uqg2?=
 =?us-ascii?Q?0N6ECvQ111yiHUDyjkrDqrXmBjflCpm6sSHVRXwrEUsndB4lHpxKEufyaLFB?=
 =?us-ascii?Q?w3KmRbkTSGvl0IO0VrQEvJ9Ky2M4CueoTTwm9H+r49ixc/ECBkvSxJ9o9QEt?=
 =?us-ascii?Q?UXc5nw0LU0J95Le1PQLgOunfRVXFwfUown5e1P3PW4546ZMW484GKv2idDfg?=
 =?us-ascii?Q?x69Y2T/g1EtUtejfDWwWmajEfhgNhoQSoPrf8BBz7L3cyQVdZRrSa7obe+aw?=
 =?us-ascii?Q?+WhO77A2OQEIJFoGtORWRumrb37ExGxc8L30+A1+objf0vDGJXEpbJx6NvJI?=
 =?us-ascii?Q?IQ8WfZUMCUvqp0IQ6+QjUElsJ+JtNnoCjgLrYMF68OIQTuSdgdrHbOKetJja?=
 =?us-ascii?Q?kh7yvtvU9kSqTt04c96DJD9Cj7i087ZmoQzdRxcVI/IrybSn2Ukh4HTHr6wi?=
 =?us-ascii?Q?78M0SEqtlt4ohRiGomSLvXAeRRCKbrHuDBQ7d4noZrVMnew6U+78fMHjUNRq?=
 =?us-ascii?Q?I8pE5/iMfudb/V2zBuVv7vmwG6czh0GcPieLhKonTgvHmrzSU932QgGuHxOw?=
 =?us-ascii?Q?SimtgI2syFHBasj65WvXJyhZSP20Txq3vHMGOnwcW07aTZb58Qf42l/Bbj0I?=
 =?us-ascii?Q?vNZeipsrhHaPy/T7L31jWrdtOumyH3lwnxWVzO/USXjd7nj1QzqhdP5vxNoU?=
 =?us-ascii?Q?RNUhHbO8Qxev2Ig72gfMrEFHLYnpVlA/lNLYLEvEjJS4LjoEdeMeaFG3qinC?=
 =?us-ascii?Q?rmSQDgwo87xWHGIAzq08tQJhUCjbwHIjoWH4Ip3DjwiWM5UUngK0wGfPhlhZ?=
 =?us-ascii?Q?QKm/sqZLyHlotrlYoVL571nCqNOrdirTe/ukvgcJkSz+atXao+YQd/pjI4iY?=
 =?us-ascii?Q?pkS6WQHbBwOpbWirRmWEBlzAlrYzvxBMAuKIm/Krj1hTlO6vMJdY19KcreIN?=
 =?us-ascii?Q?hdOj+MHnGIZc4ElAt7hYzOiiVv537cQPoaVyC5NsMUt7CqO6twm8WM8/5amd?=
 =?us-ascii?Q?D3PDu0Hdws1aP+GJ/gT6PQJCU2s0sHZ1HbB3x9MXfotFBdUh8JxJPXEap8gh?=
 =?us-ascii?Q?/SZ+T1gKECZfpQkxDBE81NoXLi8YKyapRKeFeTXwG4cXI4DE6tQBIkk8/UpD?=
 =?us-ascii?Q?6PX89Q7csFpb3rq6tZvKr1gjOnicm2NB2ukDKvSlJsiDgHrBfWfdCJzai5A4?=
 =?us-ascii?Q?W8pCYeDEgJ4/dSOionywsDpgH0TiTAQ9ceq6xLrupo2Gfntn3qyVhQWWLqfW?=
 =?us-ascii?Q?uHbzHsqKBziw/8+NMXSw0hRBeorfbn98/Ya7aux9JIlKoGF59jYG6JKXFXSR?=
 =?us-ascii?Q?FAsU/v96Uylj7l3e2qnXxELTQFhOZ7gpSaA7+Bo9aYnrH7hLB21/g7IvamZX?=
 =?us-ascii?Q?/isBXZSKzNxLMu/no7QynM0SuyBxg+Efx1igS8HKTPhDkk/L8UC58Tpi8C/J?=
 =?us-ascii?Q?rlZovOCdKaboAlo/pWWEOGIhATJvklPTJIzn?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:08:17.8441
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45fb673c-6d1d-4b4c-d15e-08dda849c6de
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7537

Now that Secure AVIC support is added in the guest, indicate SEV-SNP
guest supports Secure AVIC feature if AMD_SECURE_AVIC config is
enabled.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - No change.

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


