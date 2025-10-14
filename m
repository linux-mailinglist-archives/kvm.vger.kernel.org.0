Return-Path: <kvm+bounces-60027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C169DBDB1AA
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 21:45:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BC8458058B
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 19:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B06D2DC760;
	Tue, 14 Oct 2025 19:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="v/kjLBGY"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013006.outbound.protection.outlook.com [40.107.201.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FE42D5939;
	Tue, 14 Oct 2025 19:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760471075; cv=fail; b=paNEir6t0a1s/V6SMs9/+o1hnBr8Pxyf7kSZop9ifpzFEE0mrOy6Hny9gAifNomF5aqRqh/Oa7MFlWw1zyOl+jLuKnhDQLW81lTOPaxcqo3p1icee4ukkpJcBiPw25Mz9o/YZaFqyzzYVdCVFCNkdC3O8mGyMoiXLT1LoYbBz+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760471075; c=relaxed/simple;
	bh=QhL+EomuEMCDv/aE4kA6Fb6StVv1lMCpxWrFoX8Hb/k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wl7PVjyVrogM0J6sKZ68VbAf8L+2yOY2we/SzQDBGvy8T9rv+cHwyRd+H3/l85T840i8wv2ydAmvBPxe2lUi1I6tEDnR7GiBmzGFz4pQRb5gENcmWuPM+TwWIxnLNIcbbZ0oHmk2Svztnc2jiH1+uR7AkOjbeWDddqTBBrYHk9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=v/kjLBGY; arc=fail smtp.client-ip=40.107.201.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nzTsw6TmDE0NxYdVpIlW1u9Qy8y+yLbYan/AORzUrMudTLJTJ1DWtK8oWVU4uUvvLhwaI8Q6XX3ENigz68SWt5B3eRl3oXbfAuoVfCAxnv2ZL1zPknNbKWideWYSeN32kOGHO58HUuRNqKdUvUKFsNdA2m4ZPEvrmpg/H9WX4Ryp4aC3DvvZP0FryzrpNSOnhpwPJZCTOX/xNUsNGxryrhodLu5q4ZEu9ra9XV5jWpAywRn/0UdezzrFGxksbT43+/wG2il2c36EBQfyiTGpH3gkT0M7UMcXkG/9ykg0nmthgsfDhwCndMkLRKa4nMLhYhrXAbl9l2xXYoMbOQ1zAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=efShXJSVLZydN+9hXguTUdJd/UdBj51drZ6lQtO1Hg8=;
 b=IxCv2RQ2GYUG5TmuhcK2lHslGD4rl9X/az/98HNSRo2ZwtUWiJQdopnN2Z4hCeDWeZ214UxXO5MVJVrwVyazqvrTxC9IorT7P4XB3jLD6kYBgmbjH2WH1m7w9nlPYAt3DkNCwftMHxDLQ8ihXTaC5Z6j71wvWJPNq9CLY3DYmEh7RABa+COcBfOAxmUb1Qvt5nH0A7QhUgVhnG5+1IXi2NZ81NK0po4tJlOBAbWRxZlVJe3giVhLBMr0dh6smX7FwRkOzx36f1jR4gK4VG4ncg+mrXedBtQJUfO/knpNRlh4Qes7LFq2jVyGJeeG+jzETBtTAVoVAZM+fPDr+SLdnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=efShXJSVLZydN+9hXguTUdJd/UdBj51drZ6lQtO1Hg8=;
 b=v/kjLBGYhQx7TGIAuZgADNSVOCk61nIolAOIHpz1sjAerGjruO9guRkQcYvB36ihcOqi7Ojn08yVcp2KlFscSpL0UeoJ7l82L1uh8ZCNG1lHJ8XIYApElfuzcl+c0LCI5oNujJ4h8JF2cWMJS2Vt01Cjl6zibMkYsPV2q9syTqk=
Received: from SA9PR13CA0042.namprd13.prod.outlook.com (2603:10b6:806:22::17)
 by CY1PR12MB9627.namprd12.prod.outlook.com (2603:10b6:930:104::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Tue, 14 Oct
 2025 19:44:28 +0000
Received: from SN1PEPF0002636B.namprd02.prod.outlook.com
 (2603:10b6:806:22:cafe::e3) by SA9PR13CA0042.outlook.office365.com
 (2603:10b6:806:22::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.10 via Frontend Transport; Tue,
 14 Oct 2025 19:44:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002636B.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Tue, 14 Oct 2025 19:44:27 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 14 Oct
 2025 12:44:23 -0700
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v4 2/2] x86/sev-es: Include XSS value in GHCB CPUID request
Date: Tue, 14 Oct 2025 19:43:47 +0000
Message-ID: <20251014194347.2374-3-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251014194347.2374-1-john.allen@amd.com>
References: <20251014194347.2374-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636B:EE_|CY1PR12MB9627:EE_
X-MS-Office365-Filtering-Correlation-Id: 55202472-a137-41c8-552e-08de0b5a15ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eN8WUABcwa0XMWzCHsIWqrQ2bC6y+pKQbWQ5iosEdViQJ1oDV14PYDqim10x?=
 =?us-ascii?Q?pxsrFrNLQxPhdykrmwhLwPHouiGPGzvGTf2F0PZiRXAMtGuCX/57X6ejubF7?=
 =?us-ascii?Q?uj/1DBG0g2WjXslx3r4uw07zueDvUi0InMDjas3UZaxOJCQcgxf4mvycDntZ?=
 =?us-ascii?Q?wRaUf3jc73cCs7JRmrfbG89IF3QZVif38K1X+CF0eVwzin76CUgBJsDPYOdo?=
 =?us-ascii?Q?Mo6Uw/nMPrkQcVFLzF1eqTeqc1iQ2a15u07RybNCIigRi2DBSdXz0bDu0aBs?=
 =?us-ascii?Q?wQVzG7VLks++RtMfnf0AlF96+2Jla3U+YaK3/SnlVONjc55PkjSIbjqiZNok?=
 =?us-ascii?Q?wDItpbqbGdoW8a+4jv7o1Lcci85vaDXefJ8TVGminNEC+YKTxFI7gV9Ulx4L?=
 =?us-ascii?Q?WOiH0Z+dXKTxzYrTGA2/Cr1QtRcPRj7XqNy+tTsvng05u/a73QBn5TnlCb3M?=
 =?us-ascii?Q?Aa2toEJbcOLIyvbD/eZIxTrjSU2z8KhYCIK+pCnh5fp+RhtlOkcw0icz6bPw?=
 =?us-ascii?Q?ZtrWwrpkv/40FSH3QnflLJRjQPo3LvLHYpZiFdlWqFIsQ1lwHEDmjV4+lmIz?=
 =?us-ascii?Q?5DkbhQZ2IOt0iBv3F+19AB5izrPIrfFPcFsPvE3U3IPA3w3RGYF+CdksG4Vh?=
 =?us-ascii?Q?XCUDKKJUn2lJyj2JJfbWLCA1hQjM1YDiR/PEpgs4rorcMctpQhWOdTCPuYC+?=
 =?us-ascii?Q?JWq9e3QpQTnd0di1+iWkSD/V2+Dy+4RSd9IJfYGXetjW3ItRGyfdGrRSrtIC?=
 =?us-ascii?Q?rBJI/8It+4GcwGG3IvXSne73V3oIdmvdPPLlkwtLcy6tKKvHalgfURvC2ZyR?=
 =?us-ascii?Q?luXajUqfcCFKy/AguTZCsojCA6Z0fzapQgsbtg/UeYxus5ClFEwvt2nKCBgg?=
 =?us-ascii?Q?pZhWOH9WIUgfNPUXL+WFrGM3QIHe848Axvir1xwhVnJYg+y3ngmFEukCOi0E?=
 =?us-ascii?Q?lN/RWpqH3/uFXKe/nqOHwg9Pm4d3hL9pLtQsxL2K0fQ45i/Eabd2S8pPy2sb?=
 =?us-ascii?Q?O7Rws6EVNk1HPMF9yr5G2nvOjxXkW7SfIyzGCb44MxCiUmUpvvE5Tct708mn?=
 =?us-ascii?Q?8Q9nNY1l2MjYAJuDHqe8F6MIt0wmpTrXwk5E0RDgJqdr6Q5m3aBRY+E2PoAO?=
 =?us-ascii?Q?Ew8DdQjEQbpVtwO9U8OWK4rYSxZTtd+RRDqNBOVz0WRvQBuKxOUreRbBvZHO?=
 =?us-ascii?Q?noA23If5DXbmY/55imvmhOG8nxK3+fv2u66k85meWy45BlvxPUVQ0wMLfWlq?=
 =?us-ascii?Q?jB6WJ/FehsZnfsQbLu2MVgO0rV3t6Vd6pxlh9Rf3Sa7pChVfp9Y6xTBisCdL?=
 =?us-ascii?Q?mkpmhXpoYRjQUowViK7VIo+fI9z9n7lYmHD217jtEEiIWO1AYmP6kCSnhanE?=
 =?us-ascii?Q?EYzxa/b+kdTgk390nhoEt8AJMTzeNjLjHlBZzyUEbsA6u/OMon0hNMJuOEbk?=
 =?us-ascii?Q?dPSiiBQmTP2BId3ovzxeCRYs8zsoh/apvX/dv8RFJTC9ApXxPszX3a0knAxJ?=
 =?us-ascii?Q?9tpd4sHTunHwHJxTqbNbEvC2G8UjOoJ9wuebMbXZVQ0YF9hvO3i7cWjEIWAJ?=
 =?us-ascii?Q?hdJgSAJtxKmaJWa8pV4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 19:44:27.5530
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55202472-a137-41c8-552e-08de0b5a15ef
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9627

When a guest issues a cpuid instruction for Fn0000000D_x01, the hypervisor may
be intercepting the CPUID instruction and need to access the guest XSS value.
For SEV-ES, the XSS value is encrypted and needs to be included in the GHCB to
be visible to the hypervisor.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/coco/sev/vc-shared.c | 13 +++++++++++++
 arch/x86/include/asm/svm.h    |  1 +
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/coco/sev/vc-shared.c b/arch/x86/coco/sev/vc-shared.c
index 9b01c9ad81be..e3aac7ff426c 100644
--- a/arch/x86/coco/sev/vc-shared.c
+++ b/arch/x86/coco/sev/vc-shared.c
@@ -1,5 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <asm/cpuid/types.h>
+
+#ifndef __BOOT_COMPRESSED
+#define has_cpuflag(f)                  boot_cpu_has(f)
+#endif
+
 static enum es_result vc_check_opcode_bytes(struct es_em_ctxt *ctxt,
 					    unsigned long exit_code)
 {
@@ -546,6 +552,13 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
 		/* xgetbv will cause #GP - use reset value for xcr0 */
 		ghcb_set_xcr0(ghcb, 1);
 
+	if (has_cpuflag(X86_FEATURE_SHSTK) && regs->ax == CPUID_LEAF_XSTATE && regs->cx == 1) {
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


