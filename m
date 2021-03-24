Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC668347E02
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 17:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236656AbhCXQpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 12:45:01 -0400
Received: from mail-dm6nam12on2040.outbound.protection.outlook.com ([40.107.243.40]:48321
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236548AbhCXQoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 12:44:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eE5Fe96Ma67qnkBEB91tF0KbLXhTJEL07zJNxoEPdbSKXbE2p/nZPEBoqaKQwPmWc4eKEj2B7vT1Fp8qnjjsXkJ0nwJnDhucabs2ZW9h/uMDF7AyMAG40l0StYfB7MKk9CiQ1jtDqIqswpf3eaWz4bQEtHkzydYcLwOhH1/SF7Li+BOb1kCc/XQ6+QJthkzlGz+DBhhSueo7VI4H01P/Q3k60bu+hdZKwdevghlfiW+J1sL8hau/X0TKLXQXgviajb4GVwEoKm5jMkdhO6DUoHZPsGRQJPsaRuNXyraZ79/cOwVuT89WtuGA65Zjb6IfyT0aPbWbm4Nq3MvLQlX+qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQub3ZjNV1rXAhZ8usgjtNMDaDa4+HS+MfE2Iv1RLhs=;
 b=PwSkVd7fcwNjVEuK6H+a5wqN4OhBkvp8KsddYnDam8VF1k2AGuGsTL9Y+Mg4SMG39e7bf7fM4sgULYoMJR9ZC2IScLlG/CYy+f7NfwUSPS3TzzF9BvYHBh2ir3DGGmuPoEA2e6upd5eZgRV6faIoL0FTXsquNTMW/czGa7TsKJmBhvT/u9bQMG2u7xFgy4xcJwLE89/THUQF8rGuCtHKqxFugJUaUxidsezowa2QIu3frXQtjIkzHF8uEdNQSEdHjDYFrh2rBnmcpVLQ4xo14lybiASpq6ZC88ptNpE6hZ76ReBgNswvlAaBTtf9qdwkGSKCRxkVcAqLzTHDjVLpdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQub3ZjNV1rXAhZ8usgjtNMDaDa4+HS+MfE2Iv1RLhs=;
 b=hv/S7Ohw06jCY0897o5M7MgFFVyY9l/wLfMkm99lYN/OFx528yC7sBded7INTzoX8NFI1WD/Ui31VlSmirb0qcCi8tavYRdtOrHavJ0XV2E2ot88ixEpFuU6ix0Ywoyoa5Z1KlDNahi1eG74x6GO1B4tzitfkcPSDYv/1g+hY8s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4446.namprd12.prod.outlook.com (2603:10b6:806:71::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 16:44:44 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 16:44:44 +0000
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
Subject: [RFC Part1 PATCH 08/13] x86/sev-es: register GHCB memory when SEV-SNP is active
Date:   Wed, 24 Mar 2021 11:44:19 -0500
Message-Id: <20210324164424.28124-9-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0010.namprd11.prod.outlook.com (2603:10b6:806:d3::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Wed, 24 Mar 2021 16:44:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dbc41287-d453-489a-4c62-08d8eee4209c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4446F44D2A6E6AA58C3EDC85E5639@SA0PR12MB4446.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c7zBRYksxHNE3qcnjQZ3EHhiETM3pgeKlrjiPbwdnRAeN1ysHdVFNuVNdcMTdNk9F7xTK3eYIlvAM7+UUP1+wu/P/OMwMWYRgfWCX9G0VBe/guwVxyi3dXvlydqSAF6WXmb3oN03GnRi5rhi3+vqy5wN96h+PutpI/stiE3ZswDppo2T4PCJrS9d2Sr+AP1Q8Ur4SFC5vH2nIZk6QieOirVezUD4azeqpRNXUr433wlp4vj5QENCjogXneE1AOXrsjEYlCAVvAD+Mn/M4eZLTMKDHOB9vExADCf4cvPHmImUZp4Ve7NmwPtOvRvAFjHutiLINB4MtQC+QVHZKEGnE/7Lsdwqlmt5ExKUdtgA+mBLIetLVhCu3D7WVvzsfKpbZrWhPrIZcg1G4kTDjAJdfkpqbHOhat4+4Qw6h83h+6kLGT7Q45c88bQlE0fUjhUOQkLFnSH6/RBgFbxrB5pisvb3Go4NMDsfcK87Zxle16uj4bIJzhmNqc5O0WxJZIR/WzZUurFhZj8QudQNbsM/k57cZBLKaH48e9BS7mIE7GQKevlX71sbQD8H7mDKrZbZe6cG44N4Lc0GNuZOYFoOiJeZXmLmIEbqbP2qh2OoR0kWCZVyJIXMWcUMcLmpGzdQCbwnAnY8qHwXS133MTkHBlyN4xys6cWl53aRUV9G/+g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(8676002)(1076003)(4326008)(6666004)(38100700001)(8936002)(956004)(2616005)(5660300002)(186003)(66946007)(86362001)(44832011)(36756003)(7696005)(6486002)(7416002)(478600001)(66476007)(66556008)(52116002)(316002)(83380400001)(16526019)(2906002)(26005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Jc2yIsXqQHz/ltyFqfCHQxgNOzwNyksIloBeDG8AtN2MXaaVd6qcbepQ/xzG?=
 =?us-ascii?Q?RxqUz4UA+lO8TcXaf/SaX3YApw19Djga3EGhnJy4oO9JRwWGd2DUOO9Xif7z?=
 =?us-ascii?Q?HgVAjRzGB7bo8ZcK+NhkHUzG6z8VKfCh9zdfqqDc18ebHv797azh+P4VQWeG?=
 =?us-ascii?Q?gmtZGAwqBe1v0dQanMfkTO3GIfw7f+JwYcdDj7y0Iz9QbLM3QL1meBKwoZ4u?=
 =?us-ascii?Q?rOCSwDpN4M44wtT7w+bf93SYIhgpgxh3RgVL9VBS/Fl6GZULUsCSLd/V1emz?=
 =?us-ascii?Q?00KbTmM8VzaqaCHAEO931osD2GpSwkFH7ynEJCOwNd+jhsmJ70UJtt6rVPyW?=
 =?us-ascii?Q?9P5hLw+EuwjTrHUwbWMS8pYHNgoM2IxmJJmuPx5a+6LKLCk0oKxny5X26CrS?=
 =?us-ascii?Q?fR0Cgz3ed6xcUzrhVgmFDWXPeq5vfOExPbjbsK0iXv5qzVkPY5RMZW8Dm+vP?=
 =?us-ascii?Q?JRvm+6FKaPl7Ts1epxhQbrdl8QoiOAraOFKABfDqee8Hdkuvl2qet13pL0jW?=
 =?us-ascii?Q?9xCo/YEAjPo6Ro4Fw9FLjwyWtaBAcdviZHUtZgFpk0Fuqp9wypkf2AlOvvGj?=
 =?us-ascii?Q?XskMnJYCOzPvsROYBu5iSTFeL3uFBODBo4nZlmybu+Xf2q06iXGvNdlBHfHD?=
 =?us-ascii?Q?1cjyygn9ma7p4/W3ZC9COZhhGXYMeuceivbJOxnFmyXIROj6/3yikTd7dE5C?=
 =?us-ascii?Q?az/0MnsZri0IYFuNQhFXjofG2DJZ2iLY1yeaYCgo4bf6DJ5ANKEWfJIp1tUX?=
 =?us-ascii?Q?n1kA+1GBHsw4SaLm5k16rqUQc57QYtW/o/v00k6NkjOHsdDNeUwz/OBUvxdq?=
 =?us-ascii?Q?3/jgSm9FD1d7xjUopZZyo/vEC4x21ryz6xf3Hi3953tUMB9FdH6myAZSVKgX?=
 =?us-ascii?Q?JuY5baBXBfp1Mn/adlGP+Q00rQCQQDuUr1H4pJrqWhVH+F7ayORhOo1pDbvk?=
 =?us-ascii?Q?2gqDKjkRzKAgnr5utRS9wId5Gff1+yUtO2RFLNObbqc6YAbt8HMWSgh4CzvK?=
 =?us-ascii?Q?PAt7tmwt54ddSN8FIPkmib7Gm2mXIlPg6gVDxO3sGy+ssBBjyoioK2oryDub?=
 =?us-ascii?Q?IwmacreAZ+V2aObwOHnPc1HldCKcBYZFJCELFlApWtDsQ7cnCnkbPL17Qcof?=
 =?us-ascii?Q?pvJieWed4Z/oJusJu1BS8G/IHP4kIhA6qrJ/RYhcM9uE0DDHWv6MGTCbiZPU?=
 =?us-ascii?Q?zckGESg5QKeeBm/DvxGwuTv4ghQuG5yofgwpnrEpCUZCE6cT0WlSw0Q/ieLC?=
 =?us-ascii?Q?4uQ1onqHxjvQuIptz+zPzMR90higzT2PK/8LI5IPxi3EH/n16LnwTBzxz25+?=
 =?us-ascii?Q?5zhb10V/D0kFigbRK9UBFZnj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc41287-d453-489a-4c62-08d8eee4209c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 16:44:44.1382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AxX1UYehe7/a8MVwiL/k41aFRx8H719gdpd1kEudoOnaHSEHR8Aw5+jtJtSmZ9/xhtEuN78nvvIjs7kW0uSOhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4446
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SEV-SNP guest is required to perform GHCB GPA registration. This is
because the hypervisor may prefer that a guest use a consistent and/or
specific GPA for the GHCB associated with a vCPU. For more information,
see the GHCB specification section 2.5.2.

During the boot, init_ghcb() allocates a per-cpu GHCB page. On very first
VC exception, the exception handler switch to using the per-cpu GHCB page
allocated during the init_ghcb(). The GHCB page must be registered in
the current vcpu context.

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
 arch/x86/kernel/Makefile  |  3 ++
 arch/x86/kernel/sev-es.c  | 19 +++++++++++++
 arch/x86/kernel/sev-snp.c | 58 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 80 insertions(+)
 create mode 100644 arch/x86/kernel/sev-snp.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 5eeb808eb024..2fb24c49d2e3 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -21,6 +21,7 @@ CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 CFLAGS_REMOVE_head64.o = -pg
 CFLAGS_REMOVE_sev-es.o = -pg
+CFLAGS_REMOVE_sev-snp.o = -pg
 endif
 
 KASAN_SANITIZE_head$(BITS).o				:= n
@@ -29,6 +30,7 @@ KASAN_SANITIZE_dumpstack_$(BITS).o			:= n
 KASAN_SANITIZE_stacktrace.o				:= n
 KASAN_SANITIZE_paravirt.o				:= n
 KASAN_SANITIZE_sev-es.o					:= n
+KASAN_SANITIZE_sev-snp.o				:= n
 
 # With some compiler versions the generated code results in boot hangs, caused
 # by several compilation units. To be safe, disable all instrumentation.
@@ -151,6 +153,7 @@ obj-$(CONFIG_UNWINDER_FRAME_POINTER)	+= unwind_frame.o
 obj-$(CONFIG_UNWINDER_GUESS)		+= unwind_guess.o
 
 obj-$(CONFIG_AMD_MEM_ENCRYPT)		+= sev-es.o
+obj-$(CONFIG_AMD_MEM_ENCRYPT)		+= sev-snp.o
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 0bd1a0fc587e..004bf1102dc1 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -23,6 +23,7 @@
 #include <asm/cpu_entry_area.h>
 #include <asm/stacktrace.h>
 #include <asm/sev-es.h>
+#include <asm/sev-snp.h>
 #include <asm/insn-eval.h>
 #include <asm/fpu/internal.h>
 #include <asm/processor.h>
@@ -88,6 +89,13 @@ struct sev_es_runtime_data {
 	 * is currently unsupported in SEV-ES guests.
 	 */
 	unsigned long dr7;
+
+	/*
+	 * SEV-SNP requires that the GHCB must be registered before using it.
+	 * The flag below will indicate whether the GHCB is registered, if its
+	 * not registered then sev_es_get_ghcb() will perform the registration.
+	 */
+	bool ghcb_registered;
 };
 
 struct ghcb_state {
@@ -196,6 +204,12 @@ static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
 		data->ghcb_active = true;
 	}
 
+	/* SEV-SNP guest requires that GHCB must be registered before using it. */
+	if (sev_snp_active() && !data->ghcb_registered) {
+		sev_snp_register_ghcb(__pa(ghcb));
+		data->ghcb_registered = true;
+	}
+
 	return ghcb;
 }
 
@@ -569,6 +583,10 @@ static bool __init sev_es_setup_ghcb(void)
 	/* Alright - Make the boot-ghcb public */
 	boot_ghcb = &boot_ghcb_page;
 
+	/* SEV-SNP guest requires that GHCB GPA must be registered */
+	if (sev_snp_active())
+		sev_snp_register_ghcb(__pa(&boot_ghcb_page));
+
 	return true;
 }
 
@@ -658,6 +676,7 @@ static void __init init_ghcb(int cpu)
 
 	data->ghcb_active = false;
 	data->backup_ghcb_active = false;
+	data->ghcb_registered = false;
 }
 
 void __init sev_es_init_vc_handling(void)
diff --git a/arch/x86/kernel/sev-snp.c b/arch/x86/kernel/sev-snp.c
new file mode 100644
index 000000000000..d32225c2b653
--- /dev/null
+++ b/arch/x86/kernel/sev-snp.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * AMD Memory Encryption Support
+ *
+ * Copyright (C) 2021 Advanced Micro Devices
+ *
+ * Author: Brijesh Singh <brijesh.singh@amd.com>
+ */
+
+#define pr_fmt(fmt)	"SEV-SNP: " fmt
+
+#include <linux/mem_encrypt.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+
+#include <asm/sev-es.h>
+#include <asm/sev-snp.h>
+
+static inline u64 sev_es_rd_ghcb_msr(void)
+{
+	return __rdmsr(MSR_AMD64_SEV_ES_GHCB);
+}
+
+static inline void sev_es_wr_ghcb_msr(u64 val)
+{
+	u32 low, high;
+
+	low  = (u32)(val);
+	high = (u32)(val >> 32);
+
+	native_wrmsr(MSR_AMD64_SEV_ES_GHCB, low, high);
+}
+
+/* Provides sev_es_terminate() */
+#include "sev-common-shared.c"
+
+void sev_snp_register_ghcb(unsigned long paddr)
+{
+	u64 pfn = paddr >> PAGE_SHIFT;
+	u64 old, val;
+
+	/* save the old GHCB MSR */
+	old = sev_es_rd_ghcb_msr();
+
+	/* Issue VMGEXIT */
+	sev_es_wr_ghcb_msr(GHCB_REGISTER_GPA_REQ_VAL(pfn));
+	VMGEXIT();
+
+	val = sev_es_rd_ghcb_msr();
+
+	/* If the response GPA is not ours then abort the guest */
+	if ((GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_REGISTER_GPA_RESP) ||
+	    (GHCB_REGISTER_GPA_RESP_VAL(val) != pfn))
+		sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
+
+	/* Restore the GHCB MSR value */
+	sev_es_wr_ghcb_msr(old);
+}
-- 
2.17.1

