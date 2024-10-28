Return-Path: <kvm+bounces-29813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE87E9B247B
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 06:41:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F20391C213C5
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 05:41:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 103CE1D5178;
	Mon, 28 Oct 2024 05:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eKmBUVGn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B23818CBEC;
	Mon, 28 Oct 2024 05:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730093762; cv=fail; b=BmCR6tJBoEw0K6xQjv4M8PQYREYC+Qe1aUmZVdEYJA2/qY28712k690LEg5qvMEBEt1T2OUpYGT8PRcfGMufqzosQXEyQqnXAkMKanuMfJxBfB12g3ZE9HXp26gT49wYOtS5gJTZCu+XQMK/xGOtjHqCWB2BIFfqtA4sF1JkJas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730093762; c=relaxed/simple;
	bh=YnD4/6vvVaIcqsZxXAJiIONT0oWUG8QRzHPp/70Bue0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UFskKlcxSz4paek2H/PWxU1BG/KE0zhUGDn+EvBpGitjr4HIoL5Tp5xgWB4Hgkn0j+Xga6Lsji5H7yATIigY+evZqyrWNhct+sFMl2XYGT90OxQtkUaYq5ggjyNQEEdLcPXIGJvyaP+PnvY0vUVCCSOp1X7qeQG3xi1tNGD4dNg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=eKmBUVGn; arc=fail smtp.client-ip=40.107.92.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XkyNlLZZmTuwDOARCpVD07J8pNWrIxj9ysi2Yb+Y2DcKVIzRvogj0AvoMKTrJLERKV0c8m0kH72J1nGq5uTzGLEo2cL2WiycKBMhAF/Oqx6Pe9h5hE2tly5oOzx8N8JKOjVKtNnCNRtwHho0D18X3l2jdRD2WffL4CSuzGxA0yu32EivT6dJb/0p9whP3Td9cgOfVmS0YOU+fUocKID9X/sOliRk9a9bsQqiKuNR88RmzAhFE9OOIXeVf3HaXImiPLbW+2PlMdEjJDc1KYvmr8tMlKN/XNLRCY8iTSnVbY+7dvyk1iZqrdv7zDJ19LXfuRmwxicgGTHQlXwD1JThzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YMZootdqQlrbmJT8z5xz7E275aebH+r3KKMcmjLatFk=;
 b=YzoMYePqx2quLCkn2PKrn/SSqtCaGnPzjxNdvtsRbUWv+kJdMht24yXo2f9gqI/bhCIQEtDoowCjDId7kS3VDtdTYRhlW285c1wY3vu9OSx160OIEymmpK1ExsbwLDQGftEWYd2F9tiHghHUQ36dLUh/cADJaGxpY8fF6/F3l6ugoMU9FpXaKfDTfIpmIFonERcs+71HtHh01g7CrIwpnGDDQSatv/rFYp4WTdv3Bi7q63P2455mfd4FufY237ysAqP/v69SypTVc298XCx4BJqPKQRUOBbn5wipi74ys5dXABnrnu2mw4qSrXJt7l4N/7c2Zt13DfSxKAf8pPs59A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YMZootdqQlrbmJT8z5xz7E275aebH+r3KKMcmjLatFk=;
 b=eKmBUVGncxw7JHgbc3pB1Jp9Ya0ReppsXvW0T3G56IcQ6iPmKaY+7UdCj4eiWnbn5ta1vCj1f84Sa+68Rw5clZCN/70a4B+YWtyOAM0jCrgN6wxl1uWVCn/iU2NPWWYidcGcMDSJaskw2ufMz6OTAdgCFFc2yVRu6aZ0OVKi8rw=
Received: from BY5PR03CA0007.namprd03.prod.outlook.com (2603:10b6:a03:1e0::17)
 by BL1PR12MB5921.namprd12.prod.outlook.com (2603:10b6:208:398::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Mon, 28 Oct
 2024 05:35:55 +0000
Received: from SJ1PEPF00001CE6.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::66) by BY5PR03CA0007.outlook.office365.com
 (2603:10b6:a03:1e0::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.19 via Frontend
 Transport; Mon, 28 Oct 2024 05:35:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE6.mail.protection.outlook.com (10.167.242.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8093.14 via Frontend Transport; Mon, 28 Oct 2024 05:35:54 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 28 Oct
 2024 00:35:50 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v14 12/13] x86/kvmclock: Abort SecureTSC enabled guest when kvmclock is selected
Date: Mon, 28 Oct 2024 11:04:30 +0530
Message-ID: <20241028053431.3439593-13-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241028053431.3439593-1-nikunj@amd.com>
References: <20241028053431.3439593-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE6:EE_|BL1PR12MB5921:EE_
X-MS-Office365-Filtering-Correlation-Id: 96d32ca0-6f54-439a-878d-08dcf712647c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bb3wCE8pxsIw32rvegsmqIX7J1+IDJKPtK16ISXktlSEIzPJ5x/JvL3ePMdC?=
 =?us-ascii?Q?tdiEY3qQvMgCUKDkyiYyGfqofBIJFuI39QJjfYPgmVU34dawUO7eiDQcmiej?=
 =?us-ascii?Q?8bighUCTcO09DhoAHVbzQu+61dDQOZ9nkk0La9gYfbpWK0Q6SBpmvGlPZY+b?=
 =?us-ascii?Q?V9+pNYsXMBDBFWF9sgPl0DVVK4MLtcqaAs7SA1NVM21Exr6eagfxcvt6ktVw?=
 =?us-ascii?Q?TN3lGG+jQzofXJJdH3TOmvUijcxUNN8izsAPBkFtC8TYghMWB74K4pVneHFD?=
 =?us-ascii?Q?u2ud9CQneTxCJ9Or9rKbokaw1bU7buCzaDE+NXZ4aRV+tYM+/YJZtE5HLvD8?=
 =?us-ascii?Q?zkP1HD7iNwuvxiGc5/N3N0wEiWHL+lz4ldysvXNEnwlMP0DH3wOR6LXXvBXZ?=
 =?us-ascii?Q?ELvqEcpBAEQWViv25/AQn+9o9Q1cHk2HZUsoV10ngCkQdXJ5VsZU2nlqzj73?=
 =?us-ascii?Q?6Yp4dnsxaI5hf/Wg04TRhui6TF6MByMu/NOnIgasU2p/lK7T9fLwORegDLkj?=
 =?us-ascii?Q?Zr5JqLcl8iHiu/4UAB6/tBWDvN7Jx6tWEFq3sUSB0KVVd34ambDN9GMg+Aya?=
 =?us-ascii?Q?d941nsEdfk9qYNmHpLd6KHqIyqM6JEJyGylIgjzAebyBZhNxlxs/S3KAMPcA?=
 =?us-ascii?Q?X1b+OiZE8VfrV06bEYW77phO21OW6kh+a3QTMP8VZile3kAIBDzIfwXiyLUk?=
 =?us-ascii?Q?i1r8ej6IwG/2crmqIki2C4jw8fT9/eUddhjRAhfq5QcPCWDcrKQuk9l4x9Jz?=
 =?us-ascii?Q?2lAdRKrfucLf1YDuyREKWpbh2pDM+V2rcKP+CSiuWCZR1nl/CdL+WW8//qmU?=
 =?us-ascii?Q?YIT0T0XHwUQvBtguZaAO+A4hYUQmAZeXyq0q37pH/LhmK6rucjd5+1bffCxI?=
 =?us-ascii?Q?cjaCQCyORqjBJw2ItZ1wj7/rtLZBGldKHcBK9jF1dzs0n3+tRTGXz+heQDuZ?=
 =?us-ascii?Q?PSGyz1eKrcOjiesEY6DxBS9vcL90qdIdi1I7Hdpu8+Nv9aaCyhJEJeB0Ya5F?=
 =?us-ascii?Q?S2FF+huK2/gLji0HXFGwzspUSjsSc5CFvo0Fccz/dpJhNDvAptTKCrlSRwxf?=
 =?us-ascii?Q?VKJOuD6SW3uLOL+jTVfWchQlIrOZ/VHdJ93eRZlJKp9VQVdop8SNnACSMjVA?=
 =?us-ascii?Q?ikFP7uynckmQngBrIZS8JQM1hlNOw71eK+EweRgoSRz/gcu8YYoRlUTB+Zpg?=
 =?us-ascii?Q?jNR5mjS/lH652SZKKh/TWTTCJJmIlVsRaA3f3GNWMhc5/TmqCkfPdvDW0FbE?=
 =?us-ascii?Q?8qOOpXX4UA4v9kJcEOHLLzjpFW5DeL+hjHyP1mv5JRKHtZ/aj91U8I01SgyJ?=
 =?us-ascii?Q?lJe+qZ4MyZEGmBeSgvl2gCUX7Tu7qE1+diDryT1aGW8cMcFF3zd/Skfdzqan?=
 =?us-ascii?Q?3oBr02hGkkvM5RbuGs7SFsIOgfVT391g4UEx/O/ZDdDccz0Lzw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 05:35:54.4466
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96d32ca0-6f54-439a-878d-08dcf712647c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5921

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
index 9ee63ddd0d90..99877e96c986 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -537,6 +537,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
 
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
+void __noreturn sev_es_terminate(unsigned int set, unsigned int reason);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
@@ -586,6 +587,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
 
 static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
+static inline void sev_es_terminate(unsigned int set, unsigned int reason) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/coco/sev/shared.c b/arch/x86/coco/sev/shared.c
index c2a9e2ada659..d202790e1385 100644
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


