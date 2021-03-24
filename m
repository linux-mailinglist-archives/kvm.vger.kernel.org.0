Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B1C347E06
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 17:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236732AbhCXQpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 12:45:04 -0400
Received: from mail-bn8nam12on2043.outbound.protection.outlook.com ([40.107.237.43]:10848
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236555AbhCXQor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 12:44:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GFov8TEWhpDAG/4XrKHQjp1cB9FLPmQ3F30iDV9JX7HSUxFldTERDc/3jB1Th+YjAbed3zMUj0OgTBf907Jo748BdNzrs+aruJYTuAR7ZKQNEDbPDe64k6EWN6jzVlag1GI5/4IufVrAuPzC8RNxiWE9E3Jvz955I9eh2mPXjh4mv8s2OfHa0h7xIr1WnLs1lzl2KZeEKG+Ora6M0BH854Exe5e73ls1iysWdlBjatZtDE7UhxkzZVhI1LmrjF/cvrQSR+EagO2ncycnlQ9j6HULBZTgNgVEyia3UnsWMAJX4jBhiXp33lkEWr0nlhhPMKiqhMro0pHmBBGGUm20mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxdg6sQwCLEMszWQZq/87qhz0edisEZsxdZhZhjDCs0=;
 b=CIXcvdTNbIL2hcqbw3h8l9/3YsAB5gNrGCFgSd07i3LrWln77WNsrub6LuVtoww6GLWvVE42xOGZ9A8EJ7odnCapwxl5nktcRDsVh1gCKDIi67aPF+Ow+BhI31A3QS9ZBGt/eQJgGUgSbGSHHHDLz6ifBbVRt8D/n+jadwl8YS4+QNoXzpdDp/vmiCETlSHgHow+dbCfLH76zhMu72oDdBfyy3z98tpGw7lO73M5417mKmDuQ9nwG1QYfCIRhQ0zoCgzIijbHknnRiRq8VJkuL+khwq5b8g0WLj1i3trHoXgzgPqOyiZSy1ZRCxhyUhMfMHEVVpspidETXTIo+APow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxdg6sQwCLEMszWQZq/87qhz0edisEZsxdZhZhjDCs0=;
 b=DqcN8WKbpyOcepQYbXG97q6mjw7f0IxVr4szIgS7vUMQZv3ABPJ34kbJCnzEzJcclNhJBE+a02zcHkBon34JWDJH77ZZzuDc1Z6/5vvBtxCAECCeQnuc5dZ+fdgnmF9+hsnBjhyKUuTGkIpyiiwQKn78r2NstrRlW3DTdU5G7Jg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2447.namprd12.prod.outlook.com (2603:10b6:802:27::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 16:44:42 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 16:44:42 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     ak@linux.intel.com, Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC Part1 PATCH 05/13] X86/sev-es: move few helper functions in common file
Date:   Wed, 24 Mar 2021 11:44:16 -0500
Message-Id: <20210324164424.28124-6-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324164424.28124-1-brijesh.singh@amd.com>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:806:d3::15) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0010.namprd11.prod.outlook.com (2603:10b6:806:d3::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Wed, 24 Mar 2021 16:44:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 22b666db-bbb7-479b-53f7-08d8eee41f3c
X-MS-TrafficTypeDiagnostic: SN1PR12MB2447:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2447EF4D1C00FEE461CCF296E5639@SN1PR12MB2447.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 48GBTuGth4uOviAvjRlh/ISogThwsd7X5awLtTdWR60e6Zr6ploq58GZl5MI/vub/PZvmaDazsyF8Ps2xl07Ip6AAUeOLTAO6UMSkHd2DcqKOBYnLgn1nokS6I4W6qkkrdriwBhgjpoIT/+FTsLPA3v7UHcTLwoNtSjhw5r49DFiLzh+TgBXzW4bM90MSOPGvNa/T3Z0ivgu3jDktdK+RTjS/I9XrWEEfboTkMfr1gJrnquGIxc8Ugxbgnp7huBnECfcfaOBQKBGGnPdzvp41CDdOoirFRNhlGAkkkoJwejUzjq4aWtwCXsdPIc7jzM5UU9lC5HIH1jR9wCohnN7Bl87IIbEGG0jNmKN9H3UzpwEz1EhqvVcTDoYukxNwxgQV5hhTzRoRWqv3Bgcdmic5tgm6bERa6plZyYoAPAc/InFRffiESB8OhNaXueQgfHjV/UnZHc+i+kutHVRc9SAPF++P8PSq0f2plVkY0sHVrTtqmEvKVkKIbxlTkFLB46kIV+faMWlqv/uuSSaBEO53mUg3ePsk+7+s2754Bildpi4PB/rUawml0PhvhQ2Rt3TAIdF6Zm2Up3Q9X3OxueuQ/+HZrSp1p6+5j2F6UfGhEqTGz9cHcn/QmtP4/IjfbQpynIK90jKlbmZdMb48EDaHaDBllB0lhwg8Q5a+3aqKYA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(16526019)(38100700001)(5660300002)(26005)(44832011)(36756003)(1076003)(54906003)(8676002)(316002)(83380400001)(8936002)(4326008)(956004)(2906002)(186003)(6486002)(86362001)(7416002)(2616005)(66946007)(7696005)(478600001)(66556008)(66476007)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nJ2EzbM/4jA+Z8CaQ6FJybT1OB0rUQ1EXVWg1RfsVXnAwEmz7DPLpGvbo4Vi?=
 =?us-ascii?Q?U0YIX0F4nJt3TnHnmQvfeZe/G3vYe/7AVVkDQYjvATidPI4rIbVH1Wll3cIr?=
 =?us-ascii?Q?UJKXdvz/A54LI/s2ym54/1216djtSY9P9KV75VZnV7d/4cZuVWBUnEvGPtGQ?=
 =?us-ascii?Q?uxyAQPP1HPLrMSNNHS44Wup/+L3uan197q2bFsVeqGA5nFQIzMwGCnbsfogu?=
 =?us-ascii?Q?+2Ju5NmoKasaksglCabU3ispN78KYfx5B7bIJ5rg3hLiAQfc1mE1Ef/Jdqb8?=
 =?us-ascii?Q?2nEFPy6KDorFuk/8fB4ttK7ch9RMGDGsUNQapZzOxKVCLaWOCivNwIzro7Te?=
 =?us-ascii?Q?DiKBVCkB/jg97dBKYxuAfLMj64iFKKAKNX2g6u4TFkCLCVZezEkP11/IRA0U?=
 =?us-ascii?Q?Y9EiR/qXO6PQZPh1hfvkgiJ/YW0iG8logglgpOAPIXSlLr3C022YsjZoxNFx?=
 =?us-ascii?Q?coWbWWLBfKspaBvrHAbZ6Rcu/txhz01yCdCTa4q5bCTH9DDgew+lqph3brzr?=
 =?us-ascii?Q?HiUeEF/YlM/BOK6EIqiHRmEogWKZm1UPl4WbI38zj7xAXxTig2d0hca5ZcRm?=
 =?us-ascii?Q?Pwi2aB7DhfkUlmJbw0SDXNknD5FxDPBw07Js6fZxDQ2B/LzhXqboovEoU1db?=
 =?us-ascii?Q?+s0nzqCUcg+d7gPCPSmBiuwUwGTfT2iaYbw4xf8SZ2V0XXgeeaH+pVNSgigV?=
 =?us-ascii?Q?dGvUEoo//2/FeJ4OFetvXaNc23YRtdWU0ncSTljoZH2FP4iGK25QRWUYgqL9?=
 =?us-ascii?Q?U9mkdfn/qM5y2Lbs+hLJZZofly+Z/3wxc1DdOP5wLxv56H55mvnCicOb01tx?=
 =?us-ascii?Q?8z7ysyYBnqFRsUyeauqJYk1/JKOm1FaRhCEMd0ZZivlK9cdUJhQyL15AGa1K?=
 =?us-ascii?Q?dCviIeET1LlN85voPnhvNo4wyi2msSfqM/bql2V1DDllDUqe+b06jKCdl/W9?=
 =?us-ascii?Q?NVF/r1OJEcSIlkFUAzVESljCicpzeL0Ejf9ndv1vq/GW/OdfN15COt4XOTF4?=
 =?us-ascii?Q?KqQX7vpZaZxCWulq/uWo3Hljbr4oGtcAkrhKMFUvAvlK/xIzR6IL4BXrCs9q?=
 =?us-ascii?Q?XgvWu96W06YOU9PsjStKQ+2GQ4mG3MzUyA2KTo6+OZAGDHeDBCLcCsiQoMcK?=
 =?us-ascii?Q?2CtozbkLcasCqm9fuwLUaC5KVgx8urhu5ONNnVqyLN8wl/6bEYXK9vlUggO8?=
 =?us-ascii?Q?oc4ir6ZXGQBLEuTAlGBbaJ4nk7z9mQDPSTALsi9F6jF2+ieS68XdMomayQkC?=
 =?us-ascii?Q?C+1arnrRgpXq62ZzCg7AJTpH6bgsv6pBcoS0npIXo2Z2YatdvKl5HiRh/XbY?=
 =?us-ascii?Q?mbnYoD+8EwaBBXLhSBWgE8Y/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22b666db-bbb7-479b-53f7-08d8eee41f3c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 16:44:41.8505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KkQHfPiNEStRk3l6++oOySzvpQUkCSqNvaTtVYElY4r462hQLV7Is3pt3tmHyVCJoQHl6YPK+pSJaq187NZpVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2447
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The sev_es_terminate() and sev_es_{wr,rd}_ghcb_msr() helper functions
in a common file so that it can be used by both the SEV-ES and SEV-SNP.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/boot/compressed/sev-common.c | 32 +++++++++++++++++++++++++++
 arch/x86/boot/compressed/sev-es.c     | 22 ++----------------
 arch/x86/kernel/sev-common-shared.c   | 31 ++++++++++++++++++++++++++
 arch/x86/kernel/sev-es-shared.c       | 21 +++---------------
 4 files changed, 68 insertions(+), 38 deletions(-)
 create mode 100644 arch/x86/boot/compressed/sev-common.c
 create mode 100644 arch/x86/kernel/sev-common-shared.c

diff --git a/arch/x86/boot/compressed/sev-common.c b/arch/x86/boot/compressed/sev-common.c
new file mode 100644
index 000000000000..d81ff7a3a67d
--- /dev/null
+++ b/arch/x86/boot/compressed/sev-common.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * AMD Encrypted Register State Support
+ *
+ * Author: Brijesh Singh <brijesh.singh@amd.com>
+ *
+ * Copyright (C) 2021 Advanced Micro Devices, Inc.
+ *
+ * This file is not compiled stand-alone. It is includes directly in the
+ * sev-es.c and sev-snp.c.
+ */
+
+static inline u64 sev_es_rd_ghcb_msr(void)
+{
+	unsigned long low, high;
+
+	asm volatile("rdmsr" : "=a" (low), "=d" (high) :
+			"c" (MSR_AMD64_SEV_ES_GHCB));
+
+	return ((high << 32) | low);
+}
+
+static inline void sev_es_wr_ghcb_msr(u64 val)
+{
+	u32 low, high;
+
+	low  = val & 0xffffffffUL;
+	high = val >> 32;
+
+	asm volatile("wrmsr" : : "c" (MSR_AMD64_SEV_ES_GHCB),
+			"a"(low), "d" (high) : "memory");
+}
diff --git a/arch/x86/boot/compressed/sev-es.c b/arch/x86/boot/compressed/sev-es.c
index 27826c265aab..58b15b7c1aa7 100644
--- a/arch/x86/boot/compressed/sev-es.c
+++ b/arch/x86/boot/compressed/sev-es.c
@@ -54,26 +54,8 @@ static unsigned long insn_get_seg_base(struct pt_regs *regs, int seg_reg_idx)
 	return 0UL;
 }
 
-static inline u64 sev_es_rd_ghcb_msr(void)
-{
-	unsigned long low, high;
-
-	asm volatile("rdmsr" : "=a" (low), "=d" (high) :
-			"c" (MSR_AMD64_SEV_ES_GHCB));
-
-	return ((high << 32) | low);
-}
-
-static inline void sev_es_wr_ghcb_msr(u64 val)
-{
-	u32 low, high;
-
-	low  = val & 0xffffffffUL;
-	high = val >> 32;
-
-	asm volatile("wrmsr" : : "c" (MSR_AMD64_SEV_ES_GHCB),
-			"a"(low), "d" (high) : "memory");
-}
+/* Provides sev_es_{wr,rd}_ghcb_msr() */
+#include "sev-common.c"
 
 static enum es_result vc_decode_insn(struct es_em_ctxt *ctxt)
 {
diff --git a/arch/x86/kernel/sev-common-shared.c b/arch/x86/kernel/sev-common-shared.c
new file mode 100644
index 000000000000..6229566add6f
--- /dev/null
+++ b/arch/x86/kernel/sev-common-shared.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * AMD Encrypted Register State Support
+ *
+ * Author: Brijesh Singh <brijesh.singh@amd.com>
+ *
+ * Copyright (C) 2021 Advanced Micro Devices, Inc.
+ *
+ * This file is not compiled stand-alone. It contains code shared
+ * between the pre-decompression boot code and the running Linux kernel
+ * and is included directly into both code-bases.
+ */
+
+static void sev_es_terminate(unsigned int reason)
+{
+	u64 val = GHCB_SEV_TERMINATE;
+
+	/*
+	 * Tell the hypervisor what went wrong - only reason-set 0 is
+	 * currently supported.
+	 */
+	val |= GHCB_SEV_TERMINATE_REASON(0, reason);
+
+	/* Request Guest Termination from Hypvervisor */
+	sev_es_wr_ghcb_msr(val);
+	VMGEXIT();
+
+	while (true)
+		asm volatile("hlt\n" : : : "memory");
+}
+
diff --git a/arch/x86/kernel/sev-es-shared.c b/arch/x86/kernel/sev-es-shared.c
index cdc04d091242..669e15678387 100644
--- a/arch/x86/kernel/sev-es-shared.c
+++ b/arch/x86/kernel/sev-es-shared.c
@@ -14,6 +14,9 @@
 #define has_cpuflag(f)	boot_cpu_has(f)
 #endif
 
+/* Provides sev_es_terminate() */
+#include "sev-common-shared.c"
+
 static bool __init sev_es_check_cpu_features(void)
 {
 	if (!has_cpuflag(X86_FEATURE_RDRAND)) {
@@ -24,24 +27,6 @@ static bool __init sev_es_check_cpu_features(void)
 	return true;
 }
 
-static void sev_es_terminate(unsigned int reason)
-{
-	u64 val = GHCB_SEV_TERMINATE;
-
-	/*
-	 * Tell the hypervisor what went wrong - only reason-set 0 is
-	 * currently supported.
-	 */
-	val |= GHCB_SEV_TERMINATE_REASON(0, reason);
-
-	/* Request Guest Termination from Hypvervisor */
-	sev_es_wr_ghcb_msr(val);
-	VMGEXIT();
-
-	while (true)
-		asm volatile("hlt\n" : : : "memory");
-}
-
 static bool sev_es_negotiate_protocol(void)
 {
 	u64 val;
-- 
2.17.1

