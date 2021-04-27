Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625D436C4EA
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 13:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbhD0LSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 07:18:11 -0400
Received: from mail-eopbgr750082.outbound.protection.outlook.com ([40.107.75.82]:21193
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237758AbhD0LR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 07:17:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YC2vXWoCeXIg71/Bl0CtLM1Gs5fwhHl8w9Nw/l8yFjRHUVbkpMabD3+Mjw8m9sT51gAligpPA3SUn61azwKg7SEpvIX2LALk55KcSfxWc4/LdhGvna9RXWPLtaO4Kbl/dWZkGE7jXwbhdum8oYCtBjsdhWJhU7Fpj3JoO4F1TnU2pVO13jQgwSQvK6HmOOMqAIJMzc8lgSiGkeBYIV+bRVXqHWICZ/pcF298fVX3ZvccYkjAre6DFiSSqwjsxKUO2GooJwQbwAeutr2T75QrHEzr/B2g1BdcB/EvrrlnqXcHv3xaIjkoMJuSnjmGuASAG18Mg2URzoykt9n2TBVYKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5/DEsqDCLSfU4Q47KivLUA8dx+NDMSrB7OU8Drym08=;
 b=cffQ8gpgasBf9h3h7KBXHrVvc1K7G6xvS/OrooQuwxb7ueCXwrcKoE4motT1ZsD2c3ZCLzB8jJzW4JcPUYzt77v+xld9ZOgEI7NKqL/GFOD7Mt6aCBsJiAffjXOhXej0oqmiZBNZ9uTfhY2T9txL/HfHXv33xOrC2oB6yj7OQSbv7L4ctwOOgzvk8as4Yli0SkZXyFkvWre2mkZyUF5rQnmcwWnxeN6IaYGEYp9RNLtvtB0Q5oqkihYD2mrYVti4aIMqU7cSqNzwE3jVqjArWDIRI+b8zdRY2sZltqyuBeuH+AhFAj+vnTp92o9ggeKxEJDr2CfXIae2hDvCVT6PlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5/DEsqDCLSfU4Q47KivLUA8dx+NDMSrB7OU8Drym08=;
 b=e8BV/rk2+KJu9vRAsCnbsGThwo0LS7uvgS98wv3Vzi7ehfCG7y2MerpPMbJftQ+XvSwVZrhtkoJB+GstA4e98HM2GXyYO6R4lPhGTmNa4/DDEib/9qzG4XP1aMvjbC4UyEACuDGeTPsXHy8i8UR0D1k2pCqBe2H1JT3bMhCcq/Y=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4432.namprd12.prod.outlook.com (2603:10b6:806:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Tue, 27 Apr
 2021 11:16:51 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 11:16:50 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH 2/3] x86/sev: Move GHCB MSR protocol and NAE definitions in a common header
Date:   Tue, 27 Apr 2021 06:16:35 -0500
Message-Id: <20210427111636.1207-3-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210427111636.1207-1-brijesh.singh@amd.com>
References: <20210427111636.1207-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0054.namprd02.prod.outlook.com
 (2603:10b6:803:20::16) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0201CA0054.namprd02.prod.outlook.com (2603:10b6:803:20::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Tue, 27 Apr 2021 11:16:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c4a5a6a-799e-447b-d5fc-08d9096df43c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4432:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4432CFCF4F492DACFF5BEA58E5419@SA0PR12MB4432.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OWNtb1TQlfRBHmEIiu1G0osY+fI9mK1PvvOpAlcxJLZ7DxMmhe7OuhCtO40uxuvoXlf2BXbIqrh5eUk0KZITXPq2rsEF7mETYS42eQetWFdyGT7w++z/qAEs9Aec1aWn9qSrsvWVPxN3BVc3Y8uvNnYr7bnCLo3CDqBBywYQrav1y+Tq7tIY2QorOPpu9N0Vrox6oRMgOTYVpsmEBi1ssHR0h/BBMY4HohbnfSpDpVcTt47AwcKnqlrA7FB3P2Kx5fB5KHcckJFpKtGy/CsCEerduNi/+tE2RxUxoirW0jFOSMsZhucNn6LKuwfa9emoy1RHbeshQEZAliHyGuIs6jwf3U1j96v5PjYNTb/iCszl174NbQdaFYKEg3cHmPL9wfpXbktgL+K2ZyItPZHEaMMKpvcj4iwjYIOens4oSCF4zy6I85MMLX8zhMsM7taTRSvksYUjylVUMfAy9IBXw5lKG8g6lCxxvld2GXer7MOnHYhTGLjAKVQqsSUXZmtbETMnyPutVFhzmECn06RhDVX15Mjyn75a9iDztcOpX94ydIac0+ZABKOCWMJ/VfK8126HSSrBPYjg4YszNvVvL+oYaWwuE50VsqpkYdIk2MfnlAFguUgod95HooVKifjPGdwXh0h5otPRMlICkPjuskaiOV0N2RVefRp8uUwMH+M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(366004)(376002)(39860400002)(66556008)(66476007)(5660300002)(2616005)(956004)(478600001)(316002)(6916009)(66946007)(6666004)(44832011)(52116002)(86362001)(7696005)(1076003)(36756003)(8676002)(26005)(8936002)(16526019)(4326008)(2906002)(6486002)(83380400001)(186003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jJky66XeaK9VTMeFuL37n5BXb/Z8t19sPadPafU4W1MsMNPsgWc1aj3Te1WJ?=
 =?us-ascii?Q?DNv32TDFx/jyjOwywe42NlNPpFWJjVlmlmLEQGgv5St+W3t16PKXNje/rIfL?=
 =?us-ascii?Q?5334ZGNzE9ifkxzd8VFIYxShuRVpH30suqkLOS0qTXt+K5efrdSDiWBnEshA?=
 =?us-ascii?Q?2obbTqXQ8HnodBiuPBr3Zjk7wAeO/4bPTpi69z/nfXPlP3mIaXYVyx451V0T?=
 =?us-ascii?Q?L5FR5VEQs3kQXZNcmlpLuz5QggN7poP2IRu/N06qiKhq4xiz23vLeHgE4oSY?=
 =?us-ascii?Q?gYWzvXRtogYm/t4/WsmS94veKTdpmwULzt6z72K6prtHFYYo70jJgeSzx4XO?=
 =?us-ascii?Q?JH9ozHdXRG4z+0DOLnFbmxlDCJCzTXuAVF+n/MwaqF83ae2IzFQLq3VgcwLd?=
 =?us-ascii?Q?gVppfwDRPeZlT6y5HXpS5VQAJLCsxqMvJA4EZGa5IeCZ5fSHPZ8aQt02XqJM?=
 =?us-ascii?Q?mEXvFTdx6IG3BoGuq0Cxjd+pfMpUmG5uPXjtXmr+UJ4AmEEonhPDD7CZNilL?=
 =?us-ascii?Q?ii54ChAN9Yu3BUAQnBQlWJYhvFgTycygiSsCZnd4PzzK8aPeVEHxgRw/FyRF?=
 =?us-ascii?Q?HrBDoNp1mheNfkZiAl2RZdIFpBK9u7d0Kg0qt68cItg88/kSZUMzEZo//66Y?=
 =?us-ascii?Q?YLMfX9KNyI5LPAd60oI2H0NokCdMa7PLAwrFR54Pw4yP3CU5Bxg4gN3sFTEm?=
 =?us-ascii?Q?sE8XmgDNac+SGcMg6ERh0mINFcI5KpjiB9AE2NKMYTgapCYj5+N0OEs0HML8?=
 =?us-ascii?Q?4uCdG4ep0MZYM+940r2IkEFMEZqR36chwBk0IIFGc3LMp5oi9ZoyD4mG2gZl?=
 =?us-ascii?Q?oMmMkVze5mLNvHzaVMQ7FU01BKfum4cSi1zLqnwimqXMJ1mFkCUPp4YJI/pi?=
 =?us-ascii?Q?VyxxRB4trqAi/HSG3FjjVnJcogX6ommyZak+YdK8Lk+0aQ6WoeyfZ7Rz0ShJ?=
 =?us-ascii?Q?V4PWaeUVRY1Y4Mzw7LO8qSz1ioiddgWYYQ4kfK71fdnPzTSE7MefvDuM0hu4?=
 =?us-ascii?Q?BZeK0wF/hkQEM1xf9vRojzl8iBXIYLxP7rW6nB9JU/Fq8F7p/j5uCvm9eOa9?=
 =?us-ascii?Q?6fK05j2lUPbl/0TVLwW8QocQhhpXXtxVwrg241gzDZksKuiGU/xnn8l+IsD8?=
 =?us-ascii?Q?sI82y7j5VLb02JocwGkVSdo0LP6EKT//ZtaH3YyepeGJPgkyMyy/ALj4PsP5?=
 =?us-ascii?Q?AeKQPDfD9SKEQBZEJJrqU1mQ0UhKmKQrKBBHLIlnzyzXV8CUm0UtbFts1pTD?=
 =?us-ascii?Q?SIeyT3FVIxxUks/jhBQWclI2urO9lI0YJO58SlY5CKd6C8IRamc2mHNfJ3Kh?=
 =?us-ascii?Q?rsRknw9X2oNlhBsnqjTyLniz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c4a5a6a-799e-447b-d5fc-08d9096df43c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2021 11:16:50.4817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aI+mCsKOPm/1cn6glw/LufODootkwgOmlvEPrtzzK8i8B4PqsC4BMcu945ah+0OCVicPRINNrDH20Q3Qa07b8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4432
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest and the hypervisor contain separate macros to get and set
the GHCB MSR protocol and NAE event fields. Consolidate the GHCB
protocol definitions and helper macros in one place.

Leave the supported protocol version define in separate files to keep
the guest and hypervisor flexibility to support different GHCB version
in the same release.

There is no functional change intended.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev-common.h | 62 +++++++++++++++++++++++++++++++
 arch/x86/include/asm/sev.h        | 30 ++-------------
 arch/x86/kernel/sev-shared.c      | 20 +++++-----
 arch/x86/kvm/svm/svm.h            | 38 ++-----------------
 4 files changed, 80 insertions(+), 70 deletions(-)
 create mode 100644 arch/x86/include/asm/sev-common.h

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
new file mode 100644
index 000000000000..629c3df243f0
--- /dev/null
+++ b/arch/x86/include/asm/sev-common.h
@@ -0,0 +1,62 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * AMD SEV header common between the guest and the hypervisor.
+ *
+ * Author: Brijesh Singh <brijesh.singh@amd.com>
+ */
+
+#ifndef __ASM_X86_SEV_COMMON_H
+#define __ASM_X86_SEV_COMMON_H
+
+#define GHCB_MSR_INFO_POS		0
+#define GHCB_MSR_INFO_MASK		(BIT_ULL(12) - 1)
+
+#define GHCB_MSR_SEV_INFO_RESP		0x001
+#define GHCB_MSR_SEV_INFO_REQ		0x002
+#define GHCB_MSR_VER_MAX_POS		48
+#define GHCB_MSR_VER_MAX_MASK		0xffff
+#define GHCB_MSR_VER_MIN_POS		32
+#define GHCB_MSR_VER_MIN_MASK		0xffff
+#define GHCB_MSR_CBIT_POS		24
+#define GHCB_MSR_CBIT_MASK		0xff
+#define GHCB_MSR_SEV_INFO(_max, _min, _cbit)				\
+	((((_max) & GHCB_MSR_VER_MAX_MASK) << GHCB_MSR_VER_MAX_POS) |	\
+	 (((_min) & GHCB_MSR_VER_MIN_MASK) << GHCB_MSR_VER_MIN_POS) |	\
+	 (((_cbit) & GHCB_MSR_CBIT_MASK) << GHCB_MSR_CBIT_POS) |	\
+	 GHCB_MSR_SEV_INFO_RESP)
+#define GHCB_MSR_INFO(v)		((v) & 0xfffUL)
+#define GHCB_MSR_PROTO_MAX(v)		(((v) >> GHCB_MSR_VER_MAX_POS) & GHCB_MSR_VER_MAX_MASK)
+#define GHCB_MSR_PROTO_MIN(v)		(((v) >> GHCB_MSR_VER_MIN_POS) & GHCB_MSR_VER_MIN_MASK)
+
+#define GHCB_MSR_CPUID_REQ		0x004
+#define GHCB_MSR_CPUID_RESP		0x005
+#define GHCB_MSR_CPUID_FUNC_POS		32
+#define GHCB_MSR_CPUID_FUNC_MASK	0xffffffff
+#define GHCB_MSR_CPUID_VALUE_POS	32
+#define GHCB_MSR_CPUID_VALUE_MASK	0xffffffff
+#define GHCB_MSR_CPUID_REG_POS		30
+#define GHCB_MSR_CPUID_REG_MASK		0x3
+#define GHCB_CPUID_REQ_EAX		0
+#define GHCB_CPUID_REQ_EBX		1
+#define GHCB_CPUID_REQ_ECX		2
+#define GHCB_CPUID_REQ_EDX		3
+#define GHCB_CPUID_REQ(fn, reg)		\
+		(GHCB_MSR_CPUID_REQ | \
+		(((unsigned long)reg & GHCB_MSR_CPUID_REG_MASK) << GHCB_MSR_CPUID_REG_POS) | \
+		(((unsigned long)fn) << GHCB_MSR_CPUID_FUNC_POS))
+
+#define GHCB_MSR_TERM_REQ		0x100
+#define GHCB_MSR_TERM_REASON_SET_POS	12
+#define GHCB_MSR_TERM_REASON_SET_MASK	0xf
+#define GHCB_MSR_TERM_REASON_POS	16
+#define GHCB_MSR_TERM_REASON_MASK	0xff
+#define GHCB_SEV_TERM_REASON(reason_set, reason_val)						  \
+	(((((u64)reason_set) &  GHCB_MSR_TERM_REASON_SET_MASK) << GHCB_MSR_TERM_REASON_SET_POS) | \
+	((((u64)reason_val) & GHCB_MSR_TERM_REASON_MASK) << GHCB_MSR_TERM_REASON_POS))
+
+#define GHCB_SEV_ES_REASON_GENERAL_REQUEST	0
+#define GHCB_SEV_ES_REASON_PROTOCOL_UNSUPPORTED	1
+
+#define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
+
+#endif
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index cf1d957c7091..fa5cd05d3b5b 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -10,34 +10,12 @@
 
 #include <linux/types.h>
 #include <asm/insn.h>
+#include <asm/sev-common.h>
 
-#define GHCB_SEV_INFO		0x001UL
-#define GHCB_SEV_INFO_REQ	0x002UL
-#define		GHCB_INFO(v)		((v) & 0xfffUL)
-#define		GHCB_PROTO_MAX(v)	(((v) >> 48) & 0xffffUL)
-#define		GHCB_PROTO_MIN(v)	(((v) >> 32) & 0xffffUL)
-#define		GHCB_PROTO_OUR		0x0001UL
-#define GHCB_SEV_CPUID_REQ	0x004UL
-#define		GHCB_CPUID_REQ_EAX	0
-#define		GHCB_CPUID_REQ_EBX	1
-#define		GHCB_CPUID_REQ_ECX	2
-#define		GHCB_CPUID_REQ_EDX	3
-#define		GHCB_CPUID_REQ(fn, reg) (GHCB_SEV_CPUID_REQ | \
-					(((unsigned long)reg & 3) << 30) | \
-					(((unsigned long)fn) << 32))
+#define GHCB_PROTO_OUR		0x0001UL
+#define GHCB_PROTOCOL_MAX	1ULL
+#define GHCB_DEFAULT_USAGE	0ULL
 
-#define	GHCB_PROTOCOL_MAX	0x0001UL
-#define GHCB_DEFAULT_USAGE	0x0000UL
-
-#define GHCB_SEV_CPUID_RESP	0x005UL
-#define GHCB_SEV_TERMINATE	0x100UL
-#define		GHCB_SEV_TERMINATE_REASON(reason_set, reason_val)	\
-			(((((u64)reason_set) &  0x7) << 12) |		\
-			 ((((u64)reason_val) & 0xff) << 16))
-#define		GHCB_SEV_ES_REASON_GENERAL_REQUEST	0
-#define		GHCB_SEV_ES_REASON_PROTOCOL_UNSUPPORTED	1
-
-#define	GHCB_SEV_GHCB_RESP_CODE(v)	((v) & 0xfff)
 #define	VMGEXIT()			{ asm volatile("rep; vmmcall\n\r"); }
 
 enum es_result {
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 0aa9f13efd57..6ec8b3bfd76e 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -26,13 +26,13 @@ static bool __init sev_es_check_cpu_features(void)
 
 static void __noreturn sev_es_terminate(unsigned int reason)
 {
-	u64 val = GHCB_SEV_TERMINATE;
+	u64 val = GHCB_MSR_TERM_REQ;
 
 	/*
 	 * Tell the hypervisor what went wrong - only reason-set 0 is
 	 * currently supported.
 	 */
-	val |= GHCB_SEV_TERMINATE_REASON(0, reason);
+	val |= GHCB_SEV_TERM_REASON(0, reason);
 
 	/* Request Guest Termination from Hypvervisor */
 	sev_es_wr_ghcb_msr(val);
@@ -47,15 +47,15 @@ static bool sev_es_negotiate_protocol(void)
 	u64 val;
 
 	/* Do the GHCB protocol version negotiation */
-	sev_es_wr_ghcb_msr(GHCB_SEV_INFO_REQ);
+	sev_es_wr_ghcb_msr(GHCB_MSR_SEV_INFO_REQ);
 	VMGEXIT();
 	val = sev_es_rd_ghcb_msr();
 
-	if (GHCB_INFO(val) != GHCB_SEV_INFO)
+	if (GHCB_MSR_INFO(val) != GHCB_MSR_SEV_INFO_RESP)
 		return false;
 
-	if (GHCB_PROTO_MAX(val) < GHCB_PROTO_OUR ||
-	    GHCB_PROTO_MIN(val) > GHCB_PROTO_OUR)
+	if (GHCB_MSR_PROTO_MAX(val) < GHCB_PROTO_OUR ||
+	    GHCB_MSR_PROTO_MIN(val) > GHCB_PROTO_OUR)
 		return false;
 
 	return true;
@@ -153,28 +153,28 @@ void __init do_vc_no_ghcb(struct pt_regs *regs, unsigned long exit_code)
 	sev_es_wr_ghcb_msr(GHCB_CPUID_REQ(fn, GHCB_CPUID_REQ_EAX));
 	VMGEXIT();
 	val = sev_es_rd_ghcb_msr();
-	if (GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_SEV_CPUID_RESP)
+	if (GHCB_RESP_CODE(val) != GHCB_MSR_CPUID_RESP)
 		goto fail;
 	regs->ax = val >> 32;
 
 	sev_es_wr_ghcb_msr(GHCB_CPUID_REQ(fn, GHCB_CPUID_REQ_EBX));
 	VMGEXIT();
 	val = sev_es_rd_ghcb_msr();
-	if (GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_SEV_CPUID_RESP)
+	if (GHCB_RESP_CODE(val) != GHCB_MSR_CPUID_RESP)
 		goto fail;
 	regs->bx = val >> 32;
 
 	sev_es_wr_ghcb_msr(GHCB_CPUID_REQ(fn, GHCB_CPUID_REQ_ECX));
 	VMGEXIT();
 	val = sev_es_rd_ghcb_msr();
-	if (GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_SEV_CPUID_RESP)
+	if (GHCB_RESP_CODE(val) != GHCB_MSR_CPUID_RESP)
 		goto fail;
 	regs->cx = val >> 32;
 
 	sev_es_wr_ghcb_msr(GHCB_CPUID_REQ(fn, GHCB_CPUID_REQ_EDX));
 	VMGEXIT();
 	val = sev_es_rd_ghcb_msr();
-	if (GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_SEV_CPUID_RESP)
+	if (GHCB_RESP_CODE(val) != GHCB_MSR_CPUID_RESP)
 		goto fail;
 	regs->dx = val >> 32;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 39e071fdab0c..6605789bd903 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -20,6 +20,7 @@
 #include <linux/bits.h>
 
 #include <asm/svm.h>
+#include <asm/sev-common.h>
 
 #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
 
@@ -513,40 +514,9 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
-#define GHCB_VERSION_MAX		1ULL
-#define GHCB_VERSION_MIN		1ULL
-
-#define GHCB_MSR_INFO_POS		0
-#define GHCB_MSR_INFO_MASK		(BIT_ULL(12) - 1)
-
-#define GHCB_MSR_SEV_INFO_RESP		0x001
-#define GHCB_MSR_SEV_INFO_REQ		0x002
-#define GHCB_MSR_VER_MAX_POS		48
-#define GHCB_MSR_VER_MAX_MASK		0xffff
-#define GHCB_MSR_VER_MIN_POS		32
-#define GHCB_MSR_VER_MIN_MASK		0xffff
-#define GHCB_MSR_CBIT_POS		24
-#define GHCB_MSR_CBIT_MASK		0xff
-#define GHCB_MSR_SEV_INFO(_max, _min, _cbit)				\
-	((((_max) & GHCB_MSR_VER_MAX_MASK) << GHCB_MSR_VER_MAX_POS) |	\
-	 (((_min) & GHCB_MSR_VER_MIN_MASK) << GHCB_MSR_VER_MIN_POS) |	\
-	 (((_cbit) & GHCB_MSR_CBIT_MASK) << GHCB_MSR_CBIT_POS) |	\
-	 GHCB_MSR_SEV_INFO_RESP)
-
-#define GHCB_MSR_CPUID_REQ		0x004
-#define GHCB_MSR_CPUID_RESP		0x005
-#define GHCB_MSR_CPUID_FUNC_POS		32
-#define GHCB_MSR_CPUID_FUNC_MASK	0xffffffff
-#define GHCB_MSR_CPUID_VALUE_POS	32
-#define GHCB_MSR_CPUID_VALUE_MASK	0xffffffff
-#define GHCB_MSR_CPUID_REG_POS		30
-#define GHCB_MSR_CPUID_REG_MASK		0x3
-
-#define GHCB_MSR_TERM_REQ		0x100
-#define GHCB_MSR_TERM_REASON_SET_POS	12
-#define GHCB_MSR_TERM_REASON_SET_MASK	0xf
-#define GHCB_MSR_TERM_REASON_POS	16
-#define GHCB_MSR_TERM_REASON_MASK	0xff
+#define GHCB_VERSION_MAX	1ULL
+#define GHCB_VERSION_MIN	1ULL
+
 
 extern unsigned int max_sev_asid;
 
-- 
2.17.1

