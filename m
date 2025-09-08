Return-Path: <kvm+bounces-57016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E95DAB49AFA
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 22:22:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 559824E2421
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 20:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B50722DECC6;
	Mon,  8 Sep 2025 20:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="O/A3fDEa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEC42DEA9D;
	Mon,  8 Sep 2025 20:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757362871; cv=fail; b=bRXWNumMjfBglUCuQ/vkOSXQf+g2DK61KtIopZoOXyVQKCrjU4FPlnh/jJCu4cmvgJZqPx4jZX3JAATCXHxhhyH9Em660aCLZgkflaMDRgJ9pewH3CgD5+xl+i/yZDH5PYQPYR9MPq2ea1ZD49OnzQKhCAhIiw2Ko8sVgZVrIKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757362871; c=relaxed/simple;
	bh=RzoMW60CTohTYnQMas4K68GdJtIBWNb8c8HO4CPL7dg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TQXoFUyPZNFfFxcpm9fiTZdh0dOsSkGPB/TTRd62VYxBT0nOOi+IuEyPdnnDk7ewP1lF84lFYQw2mIZXE00wmqhj+DZnyxfibWgDDgUqQdohZNN8R48dehlJLFKZZDQZBItkBPyZeY845vXRFQ0Rq8impJT/+9zcFLxu8yn6FRQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=O/A3fDEa; arc=fail smtp.client-ip=40.107.93.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hwEKIirCv2jp1o0+hLvnbltYpWU8r8Y2I99U22gOHZ4M1Sz1b47YmPwo5dNwrazltslh7GD9xTpm7+mIIIjFjVh9hQr/njx3zTR8MJhKjH4rgiTHTjPdSUtQGt3j+W7UjZ3bjWyxuDz5cY1y6wAB/yEvKypoc9RQQOZ/UlVo5wrHHa7erGUlCgt4wQacCd1bLHI60XZxKNGi9ZfuN1uMwo+2fae7oeGcAa4NsG6mId/6U74elN9ap+8hxVMscYI8EKboMEXOgesXneUpwsNt+p71WXG1unB+dESw7kxIgz4qHnLzj23LEzRAjDqVZ0rQce/WhL9vX7HxNfVvrTovZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZLrWTo8sUyOhdLTg+K7x+sE1ukfFnNwcP9GYLxRzNso=;
 b=icoph57w6FgEnNGyX/kY3cVqL2tNsNFy+cC+q4naQU3EjhCl8qu6SdH2Un0d1180KwsKuMdRjiPmxvdeJ8PJqQB28Sy9f/gTvc/iMUbbQUibDYd0xv3c+IORrBITPMlQj4ALs+hh5tunYoXG0fgtpzxrFYwWUZef7F7EVtPS+IxFIS7n+NNLaflYa4C5ZwNnNsjS+TQQkUU003A3TQqJWbUxpp4DUTeJAwNv1Eom2gv/roLvRoRZs8og0Ok1krPpOUc7V202p9a5EGVL9Uf6wDpAuOuRBnXtJwn+PzDV9rBrPFxQfhGsxDoZV2u91opw/2/yM/edW3cfTF+bIDCuVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLrWTo8sUyOhdLTg+K7x+sE1ukfFnNwcP9GYLxRzNso=;
 b=O/A3fDEa8YhWCG8WPLmFZUo9ggnW7rjp8ItT4aBDui37NfyTNlUJadMH88Ks0vtJX3VzFH0d6xzU77cIEPTQSebQQxriOnRAiePAIuMmZoN921jIaenK4LyUja5DoWVx5zhO9OKBXuOLerYhklJOTeFNBeK3nR3+rXbimE3lIAk=
Received: from SA0PR11CA0150.namprd11.prod.outlook.com (2603:10b6:806:131::35)
 by LV8PR12MB9336.namprd12.prod.outlook.com (2603:10b6:408:208::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 20:21:07 +0000
Received: from SN1PEPF0002529F.namprd05.prod.outlook.com
 (2603:10b6:806:131:cafe::4a) by SA0PR11CA0150.outlook.office365.com
 (2603:10b6:806:131::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.22 via Frontend Transport; Mon,
 8 Sep 2025 20:21:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002529F.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 20:21:07 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 8 Sep
 2025 13:21:02 -0700
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v2 2/2] x86/sev-es: Include XSS value in GHCB CPUID request
Date: Mon, 8 Sep 2025 20:20:34 +0000
Message-ID: <20250908202034.98854-3-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250908202034.98854-1-john.allen@amd.com>
References: <20250908202034.98854-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529F:EE_|LV8PR12MB9336:EE_
X-MS-Office365-Filtering-Correlation-Id: 82ae537c-d074-441e-dc1a-08ddef153e2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bFuzmuwFu70pTdi9SteBsa5N+fgi9caSWlik43sJceCxBTnpnEmGKw3Q1BxY?=
 =?us-ascii?Q?bumES6jF639vzc3jOhrhW+9NQk9t1rsnW7FvqNX4Pa8dLaHdVrlnoNTTTttz?=
 =?us-ascii?Q?5qL3i4mULGNNY7rBBjv8og+HcIi1W+rmE+d5H4H4rmT3T4bph+R+GF0vryp0?=
 =?us-ascii?Q?XFd42/l9+/iAw+Qk3hU9GRxMM9L8MaXx99Zz9YVL68tKwNOPUW2X5NDwYvNS?=
 =?us-ascii?Q?H0/MS87/7CISJeuUgMfno69fKchAHtGsmr+67FOkUuu/wCDGZs16uMJYa510?=
 =?us-ascii?Q?+H1g5C7zivy2QuTcl6iVuBRYMifZRJd5aCB1J6OQmoKH2ZNfxP5TqS6S/I35?=
 =?us-ascii?Q?CIbiJxFoOx/eG2BVJ0vQZ97wBYO6pWJYPEppAi8AFLm1sb99whiz40RjVegx?=
 =?us-ascii?Q?TYsF7jOPrNayAAZdsEX0oLtxvA49VUB+o8/A5JiF6v4cEku8Qt2O7C/t4n1N?=
 =?us-ascii?Q?K2p8CytKQiwJo8hOhmzHqdvQshTGabeoPyrj3URpSd3f4umjMkh9lLN+1hOJ?=
 =?us-ascii?Q?VxyDM/aks9rocgKP8etakMa4Kaxx7zzhUCswxJPWqphwCptWewPapS9zX2YS?=
 =?us-ascii?Q?zy728J8TvQFsFMvh1PGlnLj5dFZYNdoTjk6hBu45Q1vJ9zMLbruugouvNCrS?=
 =?us-ascii?Q?vS45ZtTDG2qFU24ZdnJFBkUuoTsyNDvDJNVnhcECXqnZr2I/569sjg35Jx1n?=
 =?us-ascii?Q?7DkPelwTvTgn7WH8jE3mN6AhPyrhPmVnnRekFLA45JpjFjVZbjP/udokdf1y?=
 =?us-ascii?Q?vgCnAUyKDXsZF/k5xZ7LcDtJ3FrVQuxEy0o6XP7PaUQA1+GpRaK4tBWJ7QT7?=
 =?us-ascii?Q?+Gi5iX0N9QrsDhr2UXkXGx22Wg+BcaRpYGzAGfMWFwx3/vIrEtVBtgZ68mun?=
 =?us-ascii?Q?IyS9Vn2PPvj4gF7lTnZNyUERdlV9pcMHHrs6x0EWM7wmyZP1HRg+OJ2khS9z?=
 =?us-ascii?Q?vGOakjajmutJYtz6Z260SsB5m1U5AXUZKAmfrw13z9ph3Ycx49sOeE+nzVPN?=
 =?us-ascii?Q?sMkmj7XAR3E5L21JHofMUXwwi/5ihAkGZNjSUS6VkzAy3Ta4NjBw6ewWlQxE?=
 =?us-ascii?Q?UwtVrs0vIBhB7lIuqtZfmETlmDCRzHyjXzmCaVbIMj/C5/wdd6D6OMvC9oKz?=
 =?us-ascii?Q?LDhgivfQz9fYo9PxhkyuRXNFxGXYFaUfe4LPtb1+wUnBx0EoR5cEh8vn61p2?=
 =?us-ascii?Q?x/eCP+nW3Or7vfUQQ/3uZETBqtY+L/Hfw0KWqVSN837c52kH4zfKX9rbEdaq?=
 =?us-ascii?Q?HjTddVbrN+ZkV1lJgC7YixRtQt57zyFNmVJatfJPPEeaF4zkTcEo/8ajj/x3?=
 =?us-ascii?Q?mgUaa6nXUQyKeps0iAy2MiKGrkZ3L+pq1op2Xbx7yqMM+XQp8gngmfm6dl72?=
 =?us-ascii?Q?M/JtFqtW6S1NmozMOLAfGl5A6c24R/Uzf6iJbfRTWD1w6FboUQRUKwIy4WK7?=
 =?us-ascii?Q?l5bVkGfH+jEyqp1aR4PH6Qeug6be+MqlLN1N/riL2qtD0QBfo5vCt5aR4J79?=
 =?us-ascii?Q?kAo+4hDEaKzeEh36kLHFEArWl9wrm+vWbvqf?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 20:21:07.2360
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82ae537c-d074-441e-dc1a-08ddef153e2d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9336

When a guest issues a cpuid instruction for Fn0000000D_{x00,x01}, the
hypervisor will be intercepting the CPUID instruction and will need to access
the guest XSS value. For SEV-ES, the XSS value is encrypted and needs to be
included in the GHCB to be visible to the hypervisor.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
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
index 17f6c3fedeee..0581c477d466 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -701,5 +701,6 @@ DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
 DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
 DEFINE_GHCB_ACCESSORS(sw_scratch)
 DEFINE_GHCB_ACCESSORS(xcr0)
+DEFINE_GHCB_ACCESSORS(xss)
 
 #endif
-- 
2.47.3


