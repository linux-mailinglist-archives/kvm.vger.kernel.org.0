Return-Path: <kvm+bounces-58705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FE5FB9BD03
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 22:09:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 697A11B24CBE
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 20:10:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F0DC323F42;
	Wed, 24 Sep 2025 20:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pBZB66DU"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013019.outbound.protection.outlook.com [40.93.201.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C223233EF;
	Wed, 24 Sep 2025 20:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758744565; cv=fail; b=ivvElQ4ZYXMzcuINZbTcilyVqi471mpFYzavqh65w200aTvCGey9lwqg2Fp6lbksIuv7MI/M6gPKCEMVJzTAA9tX6Z68z/+VVzEE7THCy3Supas+QcydB36sgyVHb+uFRPaO7WQWXnHbKXFUvlQKYsdrqBP5hU64PyuGBos5jSg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758744565; c=relaxed/simple;
	bh=ABIdT81QIqxle0h0xqOFSr+lb5xCohW7rZ8iSwrfp0Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gLsaiOk9ZWT9uh3HMZSzqWvvd5nGQkL9Y0bLODdc/Y5UQo1/J4USijm8HFslikT0FKS/BRAXoGDd+MjeHZh2xKitDOS7ATbAsxtdevYU15fLKmMS9PJAr4L3XH7deIMvZa8nUUKpAE2ObGYWwKcvsYr3HM0vdbunfEoI/5E+4Sc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pBZB66DU; arc=fail smtp.client-ip=40.93.201.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y1yNVJu7C9qQrTE8E4eCM3BOwZjN+RDi7HzJWXOKj7A9nznxSriVXsb6Z3azQCQPoYg8FRCFxlcg8V6tBNIzzdABcEOzeUfTHdvuGobEz+25DsNjmkw0s6VqqmVP4WMwS7PvLdPFlpihX9zX9FYe7lhWT9Vx5rvz3Y+mFAFE63ggb2b9506df5XW+Ln/VU/nxCOmQZrmosO93C7Kw2M6FH2ounoiPQbEeDiuecbE/02UMm6GztbJZY2+ofundq+QjapiLGMSjsT33F9a8jYy5QjwBXLVHPbeEjXsDPMFody0fwp9j/cwwZ7NjT0PlStYjD4N7i3pmf80fQRDg3ExaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hySj9cBGHOlVCku0U59dn29FN5R+7hldnHrspOoqS5M=;
 b=To4cowQmvrBAk0UmKr11JxbOOBccc5KwR3BUeB8Eu2pS/4QBjFvRKlSnI1Njo60eGNFZOXE+ZL2YbmNvwvKcUTPg7mNbldwslVEXspVjnGtcmvCCWy1FknZRw88HvJiJ4PwfyVDD9foG03njsEn/EpfG5lA+uRO3Z//n/ZnYiflPwrh7tXdPF1jr8HWeyVN+KZGSO0C98dxQ6K99HbzPPElRsvsUZXKVnBJHu64YB2XuzJ4gwhommp+NWYPS9aWTxeNBfSz0YpHnf2xVl9L8YlbKIn5SIpZJmT/NR0t2aiHnFTu4TNNNAnlOWm5swI85Xv3iucMqxMSrY92UKAhkag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hySj9cBGHOlVCku0U59dn29FN5R+7hldnHrspOoqS5M=;
 b=pBZB66DU/iISjtOdYRIVNPNyN8/uMpAq54xZdHXNV7tdYwzH+BlaTAYDDpXUNdQTo3JIe8Sj4g/f01oZVLtUwG7pMGsWlR26AkYUM1obd6iDRsgHVSVLYwBGKU1Y/Po6vg6bXYTScR45wdh9Uan4goVDz5/aILU//EaLRHh71RM=
Received: from CH2PR03CA0022.namprd03.prod.outlook.com (2603:10b6:610:59::32)
 by DS2PR12MB9565.namprd12.prod.outlook.com (2603:10b6:8:279::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Wed, 24 Sep
 2025 20:09:20 +0000
Received: from CH3PEPF0000000F.namprd04.prod.outlook.com
 (2603:10b6:610:59:cafe::51) by CH2PR03CA0022.outlook.office365.com
 (2603:10b6:610:59::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.20 via Frontend Transport; Wed,
 24 Sep 2025 20:09:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH3PEPF0000000F.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Wed, 24 Sep 2025 20:09:19 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 24 Sep
 2025 13:09:18 -0700
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v3 2/2] x86/sev-es: Include XSS value in GHCB CPUID request
Date: Wed, 24 Sep 2025 20:08:52 +0000
Message-ID: <20250924200852.4452-3-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250924200852.4452-1-john.allen@amd.com>
References: <20250924200852.4452-1-john.allen@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000F:EE_|DS2PR12MB9565:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ec69431-43a3-453f-0aed-08ddfba63f36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HhT8jPHuy3gGe9tS6Q5iLB1OVc5IOG4Fzpb2BrGPdWI9yGpB+xlLx6O0CXLP?=
 =?us-ascii?Q?O39IMD7dWAecCM/ZbtbeSmFUl1ImtahQFDb1lFRw8Axxp1zIl343qQXO8l2S?=
 =?us-ascii?Q?MeUdZVRiWiBym/lyATMjqpDZhDKlNYK+qTnNn/mCYeeSp2ImEOiEafcdgty9?=
 =?us-ascii?Q?LxFcO86f/VkHcEnIypQS7tIwyu1IqDBqnsHQR6dsbgkiEb1/ID/gaVQbliGH?=
 =?us-ascii?Q?+BNGgBMmgOdszi0BPG6uaJ/z1fRhpADu977Y7bF7Y7gc1+H/g/fafHAKqqrc?=
 =?us-ascii?Q?Ntb0tnUcCG6T7VkYqFgUVC11MtY5pn9AQbNlN1jiwIxq8y8vN+7iDUnFcp41?=
 =?us-ascii?Q?2Kilh5H0+8jAUDFLPYrjSxydIwSS1y/ERQj+wVZecL0lANFec2yzuVdY1YoI?=
 =?us-ascii?Q?rnnq8GU1mRlZx/0YYsjO5/rCxK46UICaW8cSHP1JLjpAwBbl/X5WA0WMFiCr?=
 =?us-ascii?Q?hLUI9H9R+jC3/ZdCt2db7c77NC455swescf9KMLGS3LVmr0FCFb5FqARtQaa?=
 =?us-ascii?Q?UvshSKzeNp+fxnEmvY9+F5Nk9cCqDO4ZsAaQClIT+YWTfPozINdjnR2cc3nH?=
 =?us-ascii?Q?qvmcsOWNnQtReqZEWz0tLbG5cu0SS0D6xZ+0q8veq7kTzE6X7Jf4eodHhUMO?=
 =?us-ascii?Q?l2XyEL4gM5KyLvPirBZJBjPAAmYwnqw6/rtx5P4qJLpQZIfgHKN4N6kX7uHc?=
 =?us-ascii?Q?VYHrutVmS5GrfgsRtS18jz+V908rxHiuho6S7LMDJSvVw3KN1cvjsKV9miLo?=
 =?us-ascii?Q?mowcegYWxlmoNNdaDgJjcwjN3NOpb9vptwYgc6nyvOKSVlfa1dYZ1kHgePF1?=
 =?us-ascii?Q?KMDAj7O8Y7p3ZEoIiGwNWhQOUH4VwAkHQEjps0nEScq2F8y1ZO9aUERW+9fU?=
 =?us-ascii?Q?kxopWOhjF95EJwH87zzqF+6NhoQwJBlyns0nJLoAnREUD+v3maDhqS7hS04g?=
 =?us-ascii?Q?DSCdIdNonjTIkuGKfUkN+JZBxgTO87htf2z6votnldDPU9/saeeVY/3ZeDK4?=
 =?us-ascii?Q?XsOTchx+v95ly2JlrJoUz+hlDsH4ia0DlxilZCOWAptKX158smmSy6oXcStg?=
 =?us-ascii?Q?h0s+r5eozKBmAB7N+bZauTA2FyXNFZXbsDN+/Nnv3hEBQHOXBJ5KO/Xvx6Kr?=
 =?us-ascii?Q?lrM7W6tQCUCFM7to8aFxxEBfS4T4mu28aBiBTxYfpkZwutyFbt7xFAQj1RVL?=
 =?us-ascii?Q?cdg/PIkRIJeqDvqeTWJTpaUIAXTbKt9Xyz0OTqSKLsOrelo6LOTicczTOZZw?=
 =?us-ascii?Q?EAnYh44AxrMs2oJAkeFxGY9eEl0uHRPTqLr1BsOKhSwLPKjJIlT700Wmq7WL?=
 =?us-ascii?Q?jL/RKwu1LTm7zBL1EAjggRJVduRPcshkQAvKv6veW0VpdEHqPxXiccnpexsg?=
 =?us-ascii?Q?qn1L3Dfl5m839t/xNS8O5Qi993CmeJONe88It20FXvfy5R3AqfL3UjzUjtHg?=
 =?us-ascii?Q?0Ca3MQa+9ytVYDvVATPD7gO4mdKWY6Hi2+xxqC+8dAGJXVUpHY34JJWf2UMq?=
 =?us-ascii?Q?DR62bq3EDTfeGCDoCMyg0ePZYY5QoNGsDVD6?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 20:09:19.8399
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ec69431-43a3-453f-0aed-08ddfba63f36
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9565

When a guest issues a cpuid instruction for Fn0000000D_x01, the hypervisor may
be intercepting the CPUID instruction and need to access the guest XSS value.
For SEV-ES, the XSS value is encrypted and needs to be included in the GHCB to
be visible to the hypervisor.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: John Allen <john.allen@amd.com>
---
v3:
  - Only CPUID.0xD.1 consumes XSS. Limit including XSS in GHCB for this
    case.
---
 arch/x86/coco/sev/vc-shared.c | 11 +++++++++++
 arch/x86/include/asm/svm.h    |  1 +
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/coco/sev/vc-shared.c b/arch/x86/coco/sev/vc-shared.c
index 2c0ab0fdc060..b281feeda32b 100644
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
 
+	if (has_cpuflag(X86_FEATURE_SHSTK) && regs->ax == 0xd && regs->cx == 1) {
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


