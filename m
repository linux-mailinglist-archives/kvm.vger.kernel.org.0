Return-Path: <kvm+bounces-29806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 171E09B2469
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 06:38:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A0801C212DC
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 05:38:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A226B1922F9;
	Mon, 28 Oct 2024 05:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yU04gy58"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D51191F84;
	Mon, 28 Oct 2024 05:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730093732; cv=fail; b=R0pVyfYX/s2ERC2EQUGZYgqekAc1gLW+NBBaPdrtv7bIYah35/nfMWe/7Mhbv5H7g1ljIcuj3hHir2SpFToVdsrOz2/2ZhCDo3Du0B2l99T3U3UxXxuRU4esIDeCnzK4pweUqhP5qhCdT/65my1dK3Kz9SSG/8jaNR5G8rHGvpw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730093732; c=relaxed/simple;
	bh=i3ZmhVc7Nr7IImnmj8NYhE4cNnqX5u2EktPp1OsemRc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KZtPJAkWiccaBsIebKag+FP9KJNkfrc5Dl+sEqxwBuOzVj9XALZSuLtIuyEDI6lQRdZW5oFFd5mq0EpbvxhUO0LaiqFyDRgv0szZg5qyrQAH+W233hSwT7LY4qWMA8gx6Vv5AVPzc1bwHP2/BMFOQX8SzIwGdSt0WRJzgRSCMKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yU04gy58; arc=fail smtp.client-ip=40.107.220.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sXhnTmRndINn5deUfjHLmn6h03Br/5wIgZE5V/8TqI5r6Grrh5M+1oYn+PiIyI6/BZb/zWl7sjb7NmUuTcTnNI+p76RHvLPe2jRENrUXUskd3ILUZCd45xpSnr7VG+DS/8OPLNFAjSeDLY4xOoxkgwJPgUDy0qtRTze+IWOv5v8vAzt8EwPqwHY4ZcTDz9HvH9uSG3/sWgC5x217icvRttpf64lEHsA/8rkF2VpTIgFeW+Syw6GGqXVk7fvWchHegjuPypDU6oJWFGOTo1I4odx8368/E3NhQXEaRmR1/GerG8k12NN0HSnwwibG+Br5CBfYCWHCSxUNLsNzQmRa/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+UBvqghZDCtRzYNcOIM3HjPWQCN1d9UafoX5Ow9nh4A=;
 b=UOFnheigucIN9KU8Rx2oBIksDKmh/VOMotnFduu85fRQhxMKHJI+kHvSJxBI1r1+V9VtDGDoXARhZVzSyhmlbVc0sYYWyyUhl1u0OOFUNb5ISWZllCvIO3Y/1Nmwm2yUBU+RV4CnC2tsx9U1Egruu9+d97Gb8gYX4JHZ7Iez5fzXB08vF8UVIMqa+HvOcTO2UNChlT9RyCpYuARE2AucKrle3LfakWnUkPCExT494u187JuclReJnuPaOkSLJHB5PhwZ3xMZoRrlmemtoJkg65N5RLj6KvO/95tKwmdVZ/snBzngakYRbzTYdXo5xXRfxhzZCfjSVR2wyuuUKo0+0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+UBvqghZDCtRzYNcOIM3HjPWQCN1d9UafoX5Ow9nh4A=;
 b=yU04gy58qagyxHFXia2BXJD2L3ZPV+PYWe5bMsfszwknmSbZ/J5ovyn13bZhTVlM1AXZ3PPk7rPoZceE+SSfcVThSn3Xni/MUqptYxSiS8sOr4dVHpRlPf5AjD5xpt+gmWYCAB+8g2TB3sGTL3gadpOsSYBhdxPfDRCnlbmmb3s=
Received: from BN1PR14CA0018.namprd14.prod.outlook.com (2603:10b6:408:e3::23)
 by IA1PR12MB7568.namprd12.prod.outlook.com (2603:10b6:208:42c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Mon, 28 Oct
 2024 05:35:27 +0000
Received: from BL6PEPF0001AB58.namprd02.prod.outlook.com
 (2603:10b6:408:e3:cafe::5d) by BN1PR14CA0018.outlook.office365.com
 (2603:10b6:408:e3::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25 via Frontend
 Transport; Mon, 28 Oct 2024 05:35:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB58.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8114.16 via Frontend Transport; Mon, 28 Oct 2024 05:35:27 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 28 Oct
 2024 00:35:23 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v14 05/13] x86/sev: Prevent RDTSC/RDTSCP interception for Secure TSC enabled guests
Date: Mon, 28 Oct 2024 11:04:23 +0530
Message-ID: <20241028053431.3439593-6-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB58:EE_|IA1PR12MB7568:EE_
X-MS-Office365-Filtering-Correlation-Id: df79551f-259e-48b1-0810-08dcf7125428
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G3KVUHxsBIkot/MFpyoZXwvTyzKzOMsaKB27eJXYg7frkrpoyzHGwGxZUGnC?=
 =?us-ascii?Q?72B2cdQDc7ms6yikjYwoupFxPiAyEXKy902FxPzr8YdlPudTe7iTE2ATTDqV?=
 =?us-ascii?Q?NvfhIxwS7xjz6JaG2r8q9gYrleCmaZatqAefHDYszZUzAdjDaSnA9N6hGA8a?=
 =?us-ascii?Q?aMLadFQpflDrAe1R7dZjXiBm3yuBIjrmuMvPag5DHCcVGaWzMC9jdyD/zk/Q?=
 =?us-ascii?Q?TEws1ZAoIhkhdq6m8sxHN3lOkXm7cKV/vm9eP4o63KerOQiu9ww9EAlNzvm1?=
 =?us-ascii?Q?Tf5v/VfUi6wMP27znNgpjBT9TKt3NEGgnZDnAigYeLYeygYgPb9xarByJHmE?=
 =?us-ascii?Q?bPNX8gwhxTTIa8emZTTTZ+enJzJUI1ZDjxRup/i132yfpZ3KrQBg+1dMFfmH?=
 =?us-ascii?Q?GhFtoGwJDyHvJEOqmeLlzgx+q9y1smhyGHGZm0l9hNSO9+QEbmS04YCx2+IA?=
 =?us-ascii?Q?7QYBh9lHuv2SXhTucWcF3kY5ZaRR475ry8tgQZK/1tjfViPPpQNDYKQZjCLA?=
 =?us-ascii?Q?/Eh/0cvegD9FzSAaJANM+1LeObM4O0XyVO3gjZO8bF+hSxBPe5M6AuX5JRfN?=
 =?us-ascii?Q?AyBiFDYhTm7A644xp67zKTlucHkELlFb1mIoC5TFXmIVzDxlOJq1e1x6kIbY?=
 =?us-ascii?Q?hq0+swP1DeruAmKwCe5n8hSBzbzai5QK6D+dykQJMgfSk3TGY8sQ4LCun8oI?=
 =?us-ascii?Q?ogYJWrxdS6p6InLMbUGZ9nc/0cKF6VuMrI37TECKBoQutvsMlgqrPrlaFWfX?=
 =?us-ascii?Q?a72MWVEycDBiFKzQWJB43vAvJ3CD4u+CcnHX6pedeNakg51wVeGJC6Da1jZ6?=
 =?us-ascii?Q?o2FWD/01R2C2RD0sHhjkzPGAhEAr3WHBsRaujokw1KMZ8L1N2BT3Ws7f0Wni?=
 =?us-ascii?Q?ViLUyYVtdqFioXjrOVsg4/xBvTmbA6bOCZgOLTgWzVtZxyqAs0zSDVylTVrr?=
 =?us-ascii?Q?F0TUtvHaMUg/5qeG+DlNhsZEoCvZ85fuRigv0GffDZGj/xyUyUKGG49XM5T7?=
 =?us-ascii?Q?yr+srhd08W8XdDvYTFW4cH033NDkFMjEwunaWOzC/iuMUb5D+R/b5KoVm9+u?=
 =?us-ascii?Q?1VP4AwzF0h8Nbrdh1jKJS6j57liIqZOqP023bDaP6F4yjCS2Rp0eMXKkLrhI?=
 =?us-ascii?Q?UvYPO3Va5rfv0ZvTSaZNAISUzgzUg48eVj8MAehhrD/CsjRWo2PHtYZfG7oc?=
 =?us-ascii?Q?qOHLp87+6cOttOEnr9Dw0sP+8IZJr3eUKlZDGFImzEoUhidRqR5jTUup5IVJ?=
 =?us-ascii?Q?Q/exYqJ4OzTza+KyyWz2inf60DAWHJZLDIC44BMQcu03xj8VGDEFou6LzOf8?=
 =?us-ascii?Q?93k9A9B/zgkl8BkrP7THIeNvxNEVhXkbGcNjg6JS965ntuPOcYVI7REVHugJ?=
 =?us-ascii?Q?434KtntnmsjWRu+U+gL+FGpM8IEc7EF5fx4DkezMmHZyIES5Dw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 05:35:27.1586
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df79551f-259e-48b1-0810-08dcf7125428
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB58.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7568

The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC is
enabled. A #VC exception will be generated if the RDTSC/RDTSCP instructions
are being intercepted. If this should occur and Secure TSC is enabled,
guest execution should be terminated as the guest cannot rely on the TSC
value provided by the hypervisor.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/coco/sev/shared.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/coco/sev/shared.c b/arch/x86/coco/sev/shared.c
index 71de53194089..c2a9e2ada659 100644
--- a/arch/x86/coco/sev/shared.c
+++ b/arch/x86/coco/sev/shared.c
@@ -1140,6 +1140,16 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
 	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
 	enum es_result ret;
 
+	/*
+	 * RDTSC and RDTSCP should not be intercepted when Secure TSC is
+	 * enabled. Terminate the SNP guest when the interception is enabled.
+	 * This file is included from kernel/sev.c and boot/compressed/sev.c,
+	 * use sev_status here as cc_platform_has() is not available when
+	 * compiling boot/compressed/sev.c.
+	 */
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+		return ES_VMM_ERROR;
+
 	ret = sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
 	if (ret != ES_OK)
 		return ret;
-- 
2.34.1


