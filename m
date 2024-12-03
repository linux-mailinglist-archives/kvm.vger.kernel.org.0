Return-Path: <kvm+bounces-32910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A8F29E16A2
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 10:05:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0EF961643FB
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 09:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCBFE1DF24E;
	Tue,  3 Dec 2024 09:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RnRlB27J"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728D51DE3C9;
	Tue,  3 Dec 2024 09:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733216519; cv=fail; b=ppeAm20PwImINMyCuVRs/IKhLNFjFENi0yxNPp9exxgP5OwHuvg4fendtDQOsFfmjalxdUG0xTmNf6D58W3XOb506E4GajgyDBBtAItSrk2IlXWV0905wZQeNF0+x4KObnnyq6u2czsq+YX1auBeENWlx2HsJVCLgdqNyfy32k0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733216519; c=relaxed/simple;
	bh=4a2XzODFuQVyOytOE8rsg5rO3D9l8qwZh8Vb+pmqUpY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EoAlkXA92JETobTO7w9LZRsUmnKT3FIe/atJ1dX8lLXrzvPZFwK00UFCMZwB/9uQda5asFwBsy8w0Qu3a9jJ68J50WyelVe7i9x/P3JdaH2XtncW+eoy7es6VrRHgjg3Y3f4033+7Zzln7y38HiCy3DhlN9o2YNG67C/6I6AInE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RnRlB27J; arc=fail smtp.client-ip=40.107.243.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xi3FRUz3UDRuuA5F5J4Rqgrq03kRUvmtjZBf+oPDvhI3/oCDxdXFXu7v/EtwAUWy+lI4qKvehkfr+IHkzGjvADc8TQIsVzE7QMKWPDce3zcrDtZ6yLQl/TuSfQW0+v8RwcH25D+x3Kq84FBWO/RqNKqZWuXW4mdh/dPyi8YcTwFtXnxgNXM18CtgbtnjbZsbc0/GsxOwQVpdTJxYj0YlICJsh6k+nTYPOTA0Qnk1/ejXI2a5vt/EpGkHMwW1PkK9QFXXQKfzpDjHx/vyO4+gxw9yDTP3ANu9YdTaWke/aWmHGQvjyU3xVyig8mmierK24aSkL8Fq3XEVxKg7gmxhZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y08IGbt4QaGBoYCCEYQTD2cNqgyyVQ7RxEiJnvhiAcg=;
 b=T1y/8PlnyE1EdnF9cZ92uXnexVdiDzwdQTHp6MF1fUjLmxbK9J2a4Jncgat6DodeK0ZXjn2ID6pUa3WrC17cijsuaqMrEydyzRwGVbicoq9ACsw4qNp4j2qwAHusMQi3dgDVWH7xx9cmvi+fUzGcR5ItNEKAsGevCko62cWdjVHLAQ9VN2JpaporFgsUrnzig3q41G/dVmJtHw2VJ6YczFGMVgH7Or0DNU5pXrPtga0f3BJhEbapWInAbnJxi1WIMitpgconZNzUG/IcHANCm2p6sIqL/HhYHn5hzIYy2cLNNi5uV5IZ+JwQpD5chvLiqzEVIGpoLRu+fNQgCMiEjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y08IGbt4QaGBoYCCEYQTD2cNqgyyVQ7RxEiJnvhiAcg=;
 b=RnRlB27JE1riCbcT3R9fr+/CtFZL40Z0jjH8VWSzVzhTKlsrxe0FeiHs+46LltTrJZ6Sb8AJGZLk3bXblVV0dnXeRo8dHxVPlitPwvv4ERQy2VxTelNUgQG0TVpMqK3eAcE+G0RIz2Z3qPU1eQOiO7vUEba3h0laqkyqQbhQ2Kc=
Received: from CH0PR04CA0033.namprd04.prod.outlook.com (2603:10b6:610:77::8)
 by PH7PR12MB7985.namprd12.prod.outlook.com (2603:10b6:510:27b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 3 Dec
 2024 09:01:53 +0000
Received: from CH1PEPF0000A345.namprd04.prod.outlook.com
 (2603:10b6:610:77:cafe::73) by CH0PR04CA0033.outlook.office365.com
 (2603:10b6:610:77::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.19 via Frontend Transport; Tue,
 3 Dec 2024 09:01:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A345.mail.protection.outlook.com (10.167.244.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Tue, 3 Dec 2024 09:01:53 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Dec
 2024 03:01:49 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v15 12/13] x86/kvmclock: Abort SecureTSC enabled guest when kvmclock is selected
Date: Tue, 3 Dec 2024 14:30:44 +0530
Message-ID: <20241203090045.942078-13-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A345:EE_|PH7PR12MB7985:EE_
X-MS-Office365-Filtering-Correlation-Id: 49316b85-5b3b-4bdd-b391-08dd13792196
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oeHuFinbAzP5fd01M5nG6AxjIoiW7m5JjyA6MR0MeMJKiFhnpME/Lsg69By7?=
 =?us-ascii?Q?7gwmggUIBm954pi/lFp8paVo7bolv5gpT5c8SjbCrbQ83SkcSlvQKwPAWjt+?=
 =?us-ascii?Q?OeFHrye2r2PWpLzs87ddAqrg03MZZ/CsHAPC4B1RWtvHUgliUwq5ADEyiw52?=
 =?us-ascii?Q?up09TCPhSfOtP3M5Ekj7QZoJ9zMs18vHqgAuxJH71g6rUahBvyPmTrRqtU8Q?=
 =?us-ascii?Q?Gh9ZeWxtorrmrgaK59U4Ko2optar4YCV6lS8KIttLdYFbmRUJ8riUzaBC2Ti?=
 =?us-ascii?Q?ZToa7XDVoJAyuPCMkacw7ULVDrPsgKI6VBKunoOdI+IIx4qKO/aKBs6377CI?=
 =?us-ascii?Q?FjKVBymQyGu3/s5DhrVwIwDObqWfUYSHvvph+SKL1mVprsUIq+CyAO90FyaO?=
 =?us-ascii?Q?18tMcdMFy4jW9OkT4SouaZJez111P/2NtbUZA1So6u0s0uJCpZNeXN5+wJnj?=
 =?us-ascii?Q?Zohcv0QptRqAoc9oqgY0yxE7d0jT25Ldr4Ucf8s1ov/BMjSCE3lZsqWzs2t1?=
 =?us-ascii?Q?7Y/vEZloOVuWBMbRzOlAs1AQ/qZAF7lrJQr5OKtkRtxRzX9kD8YgE97YYD9G?=
 =?us-ascii?Q?S63bw3ad2k2/PxGbEDIT5hGIUJGllIXqfHuB/6OlRAX48589sKv2gOWVFhYE?=
 =?us-ascii?Q?fG430Jz+gvCbKlC6xN2VZxhg/02tKp2bDhJlu3iMICwnghpAZl36YODdg5w3?=
 =?us-ascii?Q?WC/2HiiK24ijK59aKqWA2FnLt49OAnwesjQFSIIavPAX6X6/73eQG4Jz/Ydj?=
 =?us-ascii?Q?AjqPFUGCFsoMfBE/mSpmTR9seVowM2Mb4iYagrAyBLtsqRYPooyEDegv3XxY?=
 =?us-ascii?Q?pfsfdCv5su73aESkT7ouIBvEFzlxjwRs+O+T8zkGKS8YcsEZr8mv4m29lA3K?=
 =?us-ascii?Q?QQUGgG/HEm1bzgdPuPEDAX4OT7yZjLKC0hf7fwIpn8W9BzqX6S05oUrSmfu1?=
 =?us-ascii?Q?RyH30qWDgDOEUR8qd7TyJndrkXQPxH9ZFSp4w46F/K1mY1vs4oDZMie2Pa7t?=
 =?us-ascii?Q?5+aLs3TeLhJ8uYn9F+EuTy157ZJ6Yuw0CSg7C/pm1HOFMVMT2oEYiEcWvA+F?=
 =?us-ascii?Q?PNIxoDCns2zERmd9oFNf/3zSwbyqn9SFPXH1AUwGkXU45ZKqSDfbb23qb+K6?=
 =?us-ascii?Q?dTCJDWJkLvgW+oA7foHpoTYh5NJFC7/LmRarPdzf2rQh8el0rRolps968Ukz?=
 =?us-ascii?Q?/JZBCK8mVxyf7A6If0P/oTz6hHaAMVdLvC8yM5IC+n83VsnMy/ZjgRCBi86i?=
 =?us-ascii?Q?5uI5f31qkxXrMoxrMs52909jx2LXonWIOMeSHnbr/xERVawkAkJelbg9c9bH?=
 =?us-ascii?Q?FwLdmzg+rJiJQ1Et99ReDjbgtbYG2ACC46UNNgzU+lMp4O/9EaPWqHeA0uu2?=
 =?us-ascii?Q?6wnLYcOUDeV2dv1sfVwIApIqr8sDGAKJjv8lsOi8zCIteZGQMuesJhwly60J?=
 =?us-ascii?Q?zoxsQ6rrvTk31diwtuCmQxCqJkm7y0No?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 09:01:53.1192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49316b85-5b3b-4bdd-b391-08dd13792196
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A345.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7985

SecureTSC enabled guests should use TSC as the only clock source, terminate
the guest with appropriate code when clock source switches to hypervisor
controlled kvmclock.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev-common.h | 1 +
 arch/x86/include/asm/sev.h        | 2 ++
 arch/x86/coco/sev/shared.c        | 3 +--
 arch/x86/kernel/kvmclock.c        | 9 +++++++++
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 6ef92432a5ce..ad0743800b0e 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -207,6 +207,7 @@ struct snp_psc_desc {
 #define GHCB_TERM_SVSM_VMPL0		8	/* SVSM is present but has set VMPL to 0 */
 #define GHCB_TERM_SVSM_CAA		9	/* SVSM is present but CAA is not page aligned */
 #define GHCB_TERM_SECURE_TSC		10	/* Secure TSC initialization failed */
+#define GHCB_TERM_SECURE_TSC_KVMCLOCK	11	/* KVM clock selected instead of Secure TSC */
 
 #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index c4dca06b3b01..12b167fd6475 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -494,6 +494,7 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
 
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
+void __noreturn sev_es_terminate(unsigned int set, unsigned int reason);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
@@ -538,6 +539,7 @@ static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_
 					 struct snp_guest_request_ioctl *rio) { return -ENODEV; }
 static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
+static inline void sev_es_terminate(unsigned int set, unsigned int reason) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/coco/sev/shared.c b/arch/x86/coco/sev/shared.c
index 879ab48b705c..840149556241 100644
--- a/arch/x86/coco/sev/shared.c
+++ b/arch/x86/coco/sev/shared.c
@@ -117,8 +117,7 @@ static bool __init sev_es_check_cpu_features(void)
 	return true;
 }
 
-static void __head __noreturn
-sev_es_terminate(unsigned int set, unsigned int reason)
+void __head __noreturn sev_es_terminate(unsigned int set, unsigned int reason)
 {
 	u64 val = GHCB_MSR_TERM_REQ;
 
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 5b2c15214a6b..39dda04b5ba0 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -21,6 +21,7 @@
 #include <asm/hypervisor.h>
 #include <asm/x86_init.h>
 #include <asm/kvmclock.h>
+#include <asm/sev.h>
 
 static int kvmclock __initdata = 1;
 static int kvmclock_vsyscall __initdata = 1;
@@ -150,6 +151,14 @@ bool kvm_check_and_clear_guest_paused(void)
 
 static int kvm_cs_enable(struct clocksource *cs)
 {
+	/*
+	 * For a guest with SecureTSC enabled, the TSC should be the only clock
+	 * source. Abort the guest when kvmclock is selected as the clock
+	 * source.
+	 */
+	if (WARN_ON(cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)))
+		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_SECURE_TSC_KVMCLOCK);
+
 	vclocks_set_used(VDSO_CLOCKMODE_PVCLOCK);
 	return 0;
 }
-- 
2.34.1


