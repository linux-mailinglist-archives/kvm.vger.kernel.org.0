Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A9A398C02
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhFBONv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:13:51 -0400
Received: from mail-bn8nam11on2066.outbound.protection.outlook.com ([40.107.236.66]:15585
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230029AbhFBON0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:13:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjUs7zkZyX+mUjz95dZd6sRgSx1Ea6kv1v8iRGEvX9WuB2IwYM0oHGwQ/rP1DLeECNUa/yjWEb64tBYQxngIWPsBiNsktMldAmOT8hwdfmAOfbUW2YgcndfBNzdDhye9Kk/BMC36j+MpEq/bPVYUALg2i+n18PkZ1jvKwhwX2I+ITsIuP9V9BbwzPl+n/v5GFTTDqNEimv9uQnRhrvUxuJEsofbbPyHRAZjMu7vOjVbgIkPV99mYs/rxacEFiPLPVCDsfmrXD0RIO3nJHs7XdttfTkObqQcJLFFPQhRJNHl0C1FVPX76phNx5vJlxHZc559s4lvmbE1iJBmD3Lpwkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1UphxcpY5uChYPHuOjoorgCa1mz8ved+dqYE3LBHz70=;
 b=fvtcJjR3tD316KOLsgkuOxYiWBoumYB3DRA7NtHfG5gvGmyfnVbMZJg+uR3xwcSdylWAEkUX7Dihz2s1gsEfci5o5sIDxlRCr/ML03iMzzZ974y0IEbTqp5/x8Twi4kUGE4/GAnCCToXoASKgUucy221NHwCJp1VvuxXP8NE0AIcvsqRoBZd0l153ofL79hOCg7yonlqJ/KF/72xro68pdqIz4EZz9Mf55cXEwE8wGAuRPUo2F7FRNV0bBAkYuHbbBkyww0tfTggpNdoEodkDJS0sAFpstV1V0TuQDE6EbnXo1Hqg4Uuda/OTsnMs0DHwFHq/IV6sJlL5cdkLfaD3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1UphxcpY5uChYPHuOjoorgCa1mz8ved+dqYE3LBHz70=;
 b=3YaLkSTOm2nHMb+lmDc2TvCsa7Cuja5HBxLF9X4XhJTEK25hXBhT1UIhu3e4hDm1KTBl0TDKZ2jGPXoTo+vUdlSmh4nvWqmC2RQi/t0+6wScVsTQv1fviOy8eXSmLIlMqm2K5/iyl/oT13RKfsFhJ/wzfINXuaNQ1cMa5XxzG3Y=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 14:11:34 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:34 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 04/37] x86/sev: Add the host SEV-SNP initialization support
Date:   Wed,  2 Jun 2021 09:10:24 -0500
Message-Id: <20210602141057.27107-5-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 025ba9c4-ed41-4ca3-e2fc-08d925d05371
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23689FA05E1305B0B7623D0DE53D9@SN1PR12MB2368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jYrpWFsqujSvcHKdrDhKkOwUbeKCOkNCvA2kc4LQUoV9m4uCBO4j0LP1m4YDO3dkXIsMk+SUxcfNnXfVncoqUFffnptxs91c4IDfwWvfZja03HEWZnB6PFXeXGhdhXqx9/Eo72SzHr4ZD9wkwLR94coS12dk41AYW3jY8/3UBL/ZXEPtOKxl/GFYQfYl7+9EJpF5+g6VR2+PRKaRPJfpFqiehK2UNRpjpOZEgvMeCBMZttE85C5tJrQtPgGkSH2Af8tLinI1Qpg98xduW04Upbh/92gu4mafAJT43vfeGXrXMzxuq+k2TKoLSa2T6gQeCG8MgMUCWyFGzVwyYqqTamB4bjTUV5g6KQogrCHdgPcfKRAp2lCK4nxZgZdKdoMSDBxetK9IqK2FWb0c+3rFxFk1ePTj/z93tfqt8fnqi9tH39OKg50IbsBnGvO+89brVNCO6HxDVfYiaukn5g9+FUkMK8PulKFQpZks5/YjWpxg3tnBDgh+4VV7Bw5KU4f0+xT3MfrtQX61qn63B6NvkDA2L4rMsZ63ek6aU8EmYOSX3Li/vdKdgpaNCdSXE4ruo1cRRW0bQ1h+417m0tJcNH4qn+1k1++uZkI47BjpQOHwnz/ljIskHSaPwhRnltuFXHZYJN5mOzsSa7Key1/h8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(5660300002)(86362001)(6486002)(52116002)(7696005)(44832011)(38350700002)(38100700002)(956004)(2616005)(1076003)(8676002)(7416002)(8936002)(478600001)(186003)(316002)(4326008)(16526019)(26005)(66556008)(66476007)(2906002)(36756003)(54906003)(83380400001)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tedJwENNpupSH40iWmDpWNExfA+E7/8RAygnFGj953xk/XEIBGoGTRuHFm7q?=
 =?us-ascii?Q?wQ5WUWLaI8wUSufC8zaeIMkW64FgKEqz+nhFbTsSAZLTz85tDQEK+HKDu8s7?=
 =?us-ascii?Q?nX0IIGNPEHXZh+kSVU7tNlcXY6Zyqh5pC7jeGgmN/YZKbkIJFhqRYSWCkPaY?=
 =?us-ascii?Q?GhbUd+CXreKdtQnnMMyUPU2827vUlvlpcVaojwrtE4c+RYgZinGWSJ5cf2J4?=
 =?us-ascii?Q?O1DfpO9mi84UAQT1pVzNY9dYoxVpet/bwk1GIYyT7qxrggzbeBk8xFDUs+gl?=
 =?us-ascii?Q?WVGzBdEK5uuRHtSxbrYMIKQ91GAj9OJklNhZG9Qb/Z8eoox72QAtP4pmoZ0m?=
 =?us-ascii?Q?5e3rGzYIFXEm8g6N6vXeIUFLWLBg1AiyQGbqPRxzRQFGWJsfqdZ/X+EhuucN?=
 =?us-ascii?Q?LxwdDz9FyCoB+7K2XDEZxUdPrQ0i107C/7ywXbE3P37ycb19ukY8JlXQmA7b?=
 =?us-ascii?Q?q6WKx4LG/OtyutIgGDyWwZXevueJk/H2iry3PwjPLXIpCXnKILEomyFEo4oy?=
 =?us-ascii?Q?oGZpA/IesqdxYOat57Uct+AzyAWUKLGWcgpce+Tke62IMo/2lkjHW6ENsAGf?=
 =?us-ascii?Q?YcoqXpedstHmZqeg1BM7rkpBzuarVnpOk5DHN3H8NMunpmfaV5CFBrF516BB?=
 =?us-ascii?Q?YiJtO7zk5DMM405xl44Ck1c97ybkgfAvh4g/xXiRq+yi4aHeb8z+0wBaaTJr?=
 =?us-ascii?Q?CL5czMX37EogjZmQISdj1d3kGgWeeJCpDaWQjPTZvDRwH0N38yY3Scg1XHuH?=
 =?us-ascii?Q?eVJ+qt4xf6mrdzK+MXPyiMqH6zoZIwMvQZ/yqwp4ywiwwkiTksF+gnFeiIRF?=
 =?us-ascii?Q?++FG0Q9+SMrCjFjy12ilsScJC4nqcz7/wKSwUOg4ejmxzXgfIS4idwZu5yZd?=
 =?us-ascii?Q?LSlWqy41rK1ouwo/gRW1RH/gzS98/FV1Bj5fNEmItkJEwip+0UQc08g4yaR8?=
 =?us-ascii?Q?nx/6YYr/d7VIzaVMB8cL5QR6X53pHHmXR/CFdfthvKytxmMp46UpNrHl/s3k?=
 =?us-ascii?Q?EgDeaiG2FsbwA4p6KbzWaQ4kj7SkfMG4rKaBHBLnnghHaTmkeyAeP8j9wQcZ?=
 =?us-ascii?Q?WgYfrxjUo41UjEmNNiCQbxVvsiSdP51qaejRmEQeBQYASIpXS36U24HMwelS?=
 =?us-ascii?Q?/FNx+NijzOhAiSlkQgnXsVZcHEMVrBW+IqHP2l6A7nHbov7aOh9EAXyzixsh?=
 =?us-ascii?Q?gwun3mjgqHMkKFIqYBHk1XhKy4X5WWfdfdK3Ofv3SWtIiIPJJYfDv7qabGHI?=
 =?us-ascii?Q?Z/54YHNaHoTEgdp3nrqx8R2Dd7uXJAUIvuhzTO9KaKULZP8xUzQYzxetbBSo?=
 =?us-ascii?Q?mI2kjJss6YJwrHk60OUgMCK0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 025ba9c4-ed41-4ca3-e2fc-08d925d05371
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:33.5242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s8LadkHFVD+9sZs4VRGO9LXFTQ5LjhfHaSecUDL8jH4hsTg6yoGYcVCVD+3twKh8oihWJYV00Z1CQrK8E6z1NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The memory integrity guarantees of SEV-SNP are enforced through a new
structure called the Reverse Map Table (RMP). The RMP is a single data
structure shared across the system that contains one entry for every 4K
page of DRAM that may be used by SEV-SNP VMs. The goal of RMP is to
track the owner of each page of memory. Pages of memory can be owned by
the hypervisor, owned by a specific VM or owned by the AMD-SP. See APM2
section 15.36.3 for more detail on RMP.

The RMP table is used to enforce access control to memory. The table itself
is not directly writable by the software. New CPU instructions (RMPUPDATE,
PVALIDATE, RMPADJUST) are used to manipulate the RMP entries.

Based on the platform configuration, the BIOS reserves the memory used
for the RMP table. The start and end address of the RMP table must be
queried by reading the RMP_BASE and RMP_END MSRs. If the RMP_BASE and
RMP_END are not set then disable the SEV-SNP feature.

The SEV-SNP feature is enabled only after the RMP table is successfully
initialized.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/disabled-features.h |   8 +-
 arch/x86/include/asm/msr-index.h         |   6 ++
 arch/x86/kernel/sev.c                    | 113 +++++++++++++++++++++++
 3 files changed, 126 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index b7dd944dc867..0d5c8d08185c 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -68,6 +68,12 @@
 # define DISABLE_SGX	(1 << (X86_FEATURE_SGX & 31))
 #endif
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+# define DISABLE_SEV_SNP	0
+#else
+# define DISABLE_SEV_SNP	(1 << (X86_FEATURE_SEV_SNP & 31))
+#endif
+
 /*
  * Make sure to add features to the correct mask
  */
@@ -91,7 +97,7 @@
 			 DISABLE_ENQCMD)
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	0
-#define DISABLED_MASK19	0
+#define DISABLED_MASK19	(DISABLE_SEV_SNP)
 #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 69ce50fa3565..e8d45929010a 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -485,6 +485,8 @@
 #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
 #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
 #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
+#define MSR_AMD64_RMP_BASE		0xc0010132
+#define MSR_AMD64_RMP_END		0xc0010133
 
 #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
 
@@ -542,6 +544,10 @@
 #define MSR_AMD64_SYSCFG		0xc0010010
 #define MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT	23
 #define MSR_AMD64_SYSCFG_MEM_ENCRYPT	BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
+#define MSR_AMD64_SYSCFG_SNP_EN_BIT		24
+#define MSR_AMD64_SYSCFG_SNP_EN		BIT_ULL(MSR_AMD64_SYSCFG_SNP_EN_BIT)
+#define MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT	25
+#define MSR_AMD64_SYSCFG_SNP_VMPL_EN	BIT_ULL(MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT)
 #define MSR_K8_INT_PENDING_MSG		0xc0010055
 /* C1E active bits in int pending message */
 #define K8_INTP_C1E_ACTIVE_MASK		0x18000000
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 8aae1166f52e..172497d6cbb9 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -24,6 +24,8 @@
 #include <linux/mm.h>
 #include <linux/cpumask.h>
 #include <linux/io.h>
+#include <linux/io.h>
+#include <linux/iommu.h>
 
 #include <asm/cpu_entry_area.h>
 #include <asm/stacktrace.h>
@@ -38,6 +40,7 @@
 #include <asm/cpu.h>
 #include <asm/apic.h>
 #include <asm/setup.h>		/* For struct boot_params */
+#include <asm/iommu.h>
 
 #include "sev-internal.h"
 
@@ -54,6 +57,9 @@ static struct ghcb __initdata *boot_ghcb;
 
 static unsigned long snp_secrets_phys;
 
+static unsigned long rmptable_start __ro_after_init;
+static unsigned long rmptable_end __ro_after_init;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -2085,3 +2091,110 @@ unsigned long snp_issue_guest_request(int type, struct snp_guest_request_data *i
 	return ret;
 }
 EXPORT_SYMBOL_GPL(snp_issue_guest_request);
+
+#undef pr_fmt
+#define pr_fmt(fmt)	"SEV-SNP: " fmt
+
+static int __snp_enable(unsigned int cpu)
+{
+	u64 val;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return 0;
+
+	rdmsrl(MSR_AMD64_SYSCFG, val);
+
+	val |= MSR_AMD64_SYSCFG_SNP_EN;
+	val |= MSR_AMD64_SYSCFG_SNP_VMPL_EN;
+
+	wrmsrl(MSR_AMD64_SYSCFG, val);
+
+	return 0;
+}
+
+static __init void snp_enable(void *arg)
+{
+	__snp_enable(smp_processor_id());
+}
+
+static __init int __snp_rmptable_init(void)
+{
+	u64 rmp_base, rmp_end;
+	unsigned long sz;
+	void *start;
+	u64 val;
+
+	rdmsrl(MSR_AMD64_RMP_BASE, rmp_base);
+	rdmsrl(MSR_AMD64_RMP_END, rmp_end);
+
+	if (!rmp_base || !rmp_end) {
+		pr_info("Memory for the RMP table has not been reserved by BIOS\n");
+		return 1;
+	}
+
+	sz = rmp_end - rmp_base + 1;
+
+	start = memremap(rmp_base, sz, MEMREMAP_WB);
+	if (!start) {
+		pr_err("Failed to map RMP table 0x%llx-0x%llx\n", rmp_base, rmp_end);
+		return 1;
+	}
+
+	/*
+	 * Check if SEV-SNP is already enabled, this can happen if we are coming from
+	 * kexec boot.
+	 */
+	rdmsrl(MSR_AMD64_SYSCFG, val);
+	if (val & MSR_AMD64_SYSCFG_SNP_EN)
+		goto skip_enable;
+
+	/* Initialize the RMP table to zero */
+	memset(start, 0, sz);
+
+	/* Flush the caches to ensure that data is written before SNP is enabled. */
+	wbinvd_on_all_cpus();
+
+	/* Enable SNP on all CPUs. */
+	on_each_cpu(snp_enable, NULL, 1);
+
+skip_enable:
+	rmptable_start = (unsigned long)start;
+	rmptable_end = rmptable_start + sz;
+
+	pr_info("RMP table physical address 0x%016llx - 0x%016llx\n", rmp_base, rmp_end);
+
+	return 0;
+}
+
+static int __init snp_rmptable_init(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_SEV_SNP))
+		return 0;
+
+	/*
+	 * The SEV-SNP support requires that IOMMU must be enabled, and is not
+	 * configured in the passthrough mode.
+	 */
+	if (no_iommu || iommu_default_passthrough()) {
+		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
+		pr_err("IOMMU is either disabled or configured in passthrough mode.\n");
+		return 0;
+	}
+
+	if (__snp_rmptable_init()) {
+		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
+		return 1;
+	}
+
+	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/rmptable_init:online", __snp_enable, NULL);
+
+	return 0;
+}
+
+/*
+ * This must be called after the PCI subsystem. This is because before enabling
+ * the SNP feature we need to ensure that IOMMU is not configured in the
+ * passthrough mode. The iommu_default_passthrough() is used for checking the
+ * passthough state, and it is available after subsys_initcall().
+ */
+fs_initcall(snp_rmptable_init);
-- 
2.17.1

