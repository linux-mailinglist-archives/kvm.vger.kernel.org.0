Return-Path: <kvm+bounces-54195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DD5B1B1CE14
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:51:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 604F31891A23
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70C6124728C;
	Wed,  6 Aug 2025 20:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sLyuRq2p"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B811245006;
	Wed,  6 Aug 2025 20:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754513269; cv=fail; b=EXY64fQUdxqU+nR8lJhA+gGJ56TzF9fSr6cF1+acZtXyE5++CxuOu1wXJOKIiKOf8CK5F6GwNhZgekBebeuq+z7Jc3yG9a+64aKYu3bO3vTfACOdYHFh6VFI0FJOB56XSLYoPZxAAojn8W3VoZmKgcXUNokF/W/jxMy69WrGuwQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754513269; c=relaxed/simple;
	bh=ISoMRqSeLuu8MacSd5AzLCgOFE9/GkgVRK3sN0+g3RE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S7/ISwj0argmKKt+tXE7WEZ5ZKOZzVPatNIxHWkJlZZAH7BWHAXygq5yW06mnpD6a+U+M/S9RbRyB+t1Ep1CM+nvHR89GDzNUtOs0a7SuZA3jOj2Alh2CgyAfx2ZJpx9WtA26q4rlaNfNTPaQvUB2Mo5J1tDe6wHyMKXwCETqa4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sLyuRq2p; arc=fail smtp.client-ip=40.107.237.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OV4/clNhKMKYpvXlKvT7eA8oEinFLf2DnA90nHF+tsiY1SvP6aenvl3SY+/8ngTVyOm2vkSnLHRxB/EDIqpxsEUcmlRr/fUtsKW7JwPE31HJavPSTHlIb0JD443pfa78IPGI5BIab+h/jJ92y0vJzBL3k5yN8MWVjU1MZpl25gbcyLpZpCTFeB9gF+6rs9uBt4JJG64fZXZ5xbyWL0oGQ8oXExXYs9WHF71n0B41ZKNEfItxnBY9vmrIA8uoefaVgwdmcaH1tyv1BuqKpn2vScksfT52yRYsGXwyDSbAcGbTGBIpOKOdbF2+PY4E9WphLFjGlpX6+DvpN4m/EwJ10w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ZOvRu2ptRLkfodHOVjiyO5rfhotZ9SsE3AJLrx5JS4=;
 b=b1yKX62NICPIZ6CS/IJ0vCeKw8wCnb/QruJxybvHVawl9gIkTux7zJV2QM9tfwCzY9qf4r3ks+2OT/JopNKp9SLkiCDDKGyMHlfEFYgx4AVv9/gnSgt0NxDbwUFrIUSrFnfrDP1ogH71W/bfwhPh2yRQnSVfoIN2ubA/HsE/xWbKBmBGsytWGib8d38CuXm2n1q0OhMqb10mo01gxbWBNkZeWr39gLqxy+umuDhl0Zp8n6YLWf+npzsstJCKzI4e7cbWp0CeMg9Ts22KGaSp0EETyUQzCd5ntq3CB4hV0W4qJJyGs9FRCRIvPsLPjIudusnnsWjQEO7tzyR7LcY/QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ZOvRu2ptRLkfodHOVjiyO5rfhotZ9SsE3AJLrx5JS4=;
 b=sLyuRq2pZhYZ9H4lAUypeKgyAQviYruuyBVFzH/74A6zhb41ott/4Rj1VoNjZVHNrLgsa2iyUCP5xSCCa14xxblk1Nx67H2Wm9CKBJ/anrI1NDeJEYFFaxvHodR040mW+zPX4B/B1QF5P6AgtqrmFdtojP2lNz+RlscW04FECXM=
Received: from BY3PR10CA0011.namprd10.prod.outlook.com (2603:10b6:a03:255::16)
 by DM4PR12MB8474.namprd12.prod.outlook.com (2603:10b6:8:181::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Wed, 6 Aug
 2025 20:47:44 +0000
Received: from CY4PEPF0000E9DB.namprd05.prod.outlook.com
 (2603:10b6:a03:255:cafe::fe) by BY3PR10CA0011.outlook.office365.com
 (2603:10b6:a03:255::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.13 via Frontend Transport; Wed,
 6 Aug 2025 20:47:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9DB.mail.protection.outlook.com (10.167.241.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Wed, 6 Aug 2025 20:47:43 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 6 Aug
 2025 15:47:42 -0500
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH 2/2] x86/sev-es: Include XSS value in GHCB CPUID request
Date: Wed, 6 Aug 2025 20:46:59 +0000
Message-ID: <20250806204659.59099-3-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250806204659.59099-1-john.allen@amd.com>
References: <20250806204659.59099-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DB:EE_|DM4PR12MB8474:EE_
X-MS-Office365-Filtering-Correlation-Id: fc923ed5-2b7d-4f86-49a6-08ddd52a7e35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dNWffgUbnjgKJNYte3JuLerYUOiORJEgpWiHpI0eIiCVccIbElS13Qn41b4Z?=
 =?us-ascii?Q?9uFf+tzECI16dyLTr5zQ2m7cnxTDQXF/159y01BO/SU/O3llZOlu/KsOqHD8?=
 =?us-ascii?Q?z+Q8og//iNW6SjApKoTJVVIbr1KxkmsR+nHUeNlQFoXVFj1QmeE7epH//FHr?=
 =?us-ascii?Q?7kLvqMtRrzDaFjAKXXDBi5koc2mPysrIB//7SwtooqbGgibJo5idcUJuvEuw?=
 =?us-ascii?Q?bGxoremallbuinxzocqqxRLcDxkEpZaZG/eV7GXeewszqmFQz6yluytYZmt6?=
 =?us-ascii?Q?BgnUCPhRdT90euIEszJbbFE9/vTcdB16UeBMhHjokTTU44O86jsqr3c1FHP0?=
 =?us-ascii?Q?ewNn1ZTX3lXcOO8cFnddEuqkqK0sLoUmZaZ32ALkAdgPNGJa+hEJTLwwNd5M?=
 =?us-ascii?Q?x0X90N76U6PKfqPYYslH2kGYlYd1LB7MGQ31eqjIopwISIef7QNdJ9hXNUlB?=
 =?us-ascii?Q?+6aT5+9jbR8jFKB3Lj7EiVMG9+lF00l1PwL2Y2AMu+Trhf0Y+aCi1+WsphGF?=
 =?us-ascii?Q?WsPTKJ7UDwjrSuIe9U7Oh81qhCgZDHQbBTyMXysXJlisY7VGZRvI5dA9zBlT?=
 =?us-ascii?Q?4eSW0VXpCaCQx63qzu4EVa/idHDnscioRRICDwFPhEfoVl87dtGwgOiT6TX8?=
 =?us-ascii?Q?wlBJUSXXpKC1LIV16FZ98LL1jQI+TcPsmCWtqlf8ahbu86sXM/O30V5WP0Td?=
 =?us-ascii?Q?yxb3TT9dwrACZyiX+8sfkvDZmaceh7p2FBqOybstYV1IFmu8WflBrOEvOYg6?=
 =?us-ascii?Q?9PY6/o27fG0rGJUXHLMorARbF56kH8bMcZBPZB26Ko2QGjGrsrrENW9OAKgR?=
 =?us-ascii?Q?KHsBxpQRb/lqRHvT/f7TO7Fc+FH69hPDIRNxUkWJx3/I1oZ5bDdFM5mloNsg?=
 =?us-ascii?Q?JhG0racGfV2rqp2+SHHS8GwT6RrKEmFOL1ydrPwpcNCHvxJaFYl0V1fSkGWx?=
 =?us-ascii?Q?Nc1lEqkG93V4O0VXL21GsROOOlIMyIu+d+id2dKIyXU4GcWSIm+37efgZjN1?=
 =?us-ascii?Q?Qvb1v1fRZKRmuuqwiQfBTwbajY5UWXv430LGlmBWwXxL+sZHGtCVFwlWbjv9?=
 =?us-ascii?Q?PD1GDYQ1LeDdCkGntFNDeDwsOA/zsN4oWcF26nA675Jmnx4nyl3mZY7aO4l3?=
 =?us-ascii?Q?yS3klP5Mmp8ahRbbLPNlDVnMzJJWhN1PMcPCdLNeigH+O1zhMi12+5yxfu18?=
 =?us-ascii?Q?zORf4BhbnURSfYlrWwQoa+LTl/OlYwlDtB2PToE2XdafJcGIiJHFg4BMSrIX?=
 =?us-ascii?Q?nKSdZEhICt3dVdu9sWGNXX2P4gKKZ+NpSm+l1WBtTmx4t4079YdfO9qN3qJZ?=
 =?us-ascii?Q?41M09Gqt1bawVdYnTH9XVGFYxBu1Edd4D7q8miAAmIy6tpubUygBExpS2fEJ?=
 =?us-ascii?Q?l6KkC/jFAWEySew58BeB7meepxRnfHs6PhUP39JwfrXtL2VZ5QxuLjGvtEWL?=
 =?us-ascii?Q?oJYUS+Ktz2gUtuWYuO4z/YtWaJZPxeKpBoGchbRKW3Kv+oGuRXwSIwq6lCeC?=
 =?us-ascii?Q?pGIj9e+g2Taxeypmzf/ZoBp7jlVDcxktDCUS?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 20:47:43.8366
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc923ed5-2b7d-4f86-49a6-08ddd52a7e35
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9DB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8474

When a guest issues a cpuid instruction for Fn0000000D_x0B
(CetUserOffset), the hypervisor may intercept and access the guest XSS
value. For SEV-ES, this is encrypted and needs to be included in the
GHCB to be visible to the hypervisor.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/coco/sev/vc-shared.c | 11 +++++++++++
 arch/x86/include/asm/svm.h    |  1 +
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/coco/sev/vc-shared.c b/arch/x86/coco/sev/vc-shared.c
index 2c0ab0fdc060..079fffdb12c0 100644
--- a/arch/x86/coco/sev/vc-shared.c
+++ b/arch/x86/coco/sev/vc-shared.c
@@ -1,5 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#ifndef __BOOT_COMPRESSED
+#define has_cpuflag(f)                  boot_cpu_has(f)
+#endif
+
 static enum es_result vc_check_opcode_bytes(struct es_em_ctxt *ctxt,
 					    unsigned long exit_code)
 {
@@ -452,6 +456,13 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
 		/* xgetbv will cause #GP - use reset value for xcr0 */
 		ghcb_set_xcr0(ghcb, 1);
 
+	if (has_cpuflag(X86_FEATURE_SHSTK) && regs->ax == 0xd && regs->cx <= 1) {
+		struct msr m;
+
+		raw_rdmsr(MSR_IA32_XSS, &m);
+		ghcb_set_xss(ghcb, m.q);
+	}
+
 	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
 	if (ret != ES_OK)
 		return ret;
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ffc27f676243..870ebfef86d6 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -700,5 +700,6 @@ DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
 DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
 DEFINE_GHCB_ACCESSORS(sw_scratch)
 DEFINE_GHCB_ACCESSORS(xcr0)
+DEFINE_GHCB_ACCESSORS(xss)
 
 #endif
-- 
2.34.1


