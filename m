Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76301347E83
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237093AbhCXRFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:23 -0400
Received: from mail-bn8nam11on2078.outbound.protection.outlook.com ([40.107.236.78]:50401
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236883AbhCXREy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:04:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IPML2SFD4jmHIR2PszDU3Vp4A2vxZ/RK3e4DiqliTfwC5J2g/+zVbf9+0zvV2eX+o8AsWcrZRp/3bFyryxjX7XfMlnGfTZYSO9OChZB1CG/4jB6wJUGUENF4q9fgUEOQCsRcS2ZUbuwhG/vRWKFfvMTrKjaGj62IumKeY6P4M7KPeUY+6liA7f7n8IsPSv/nbmUk1XgxC3GbBMYpEkyldtpKbqTA+eucOkykvPKrte3L97dmf9/HTqTnZWhMmjBYeKRkswI44EENJl1R6I5hB7GchV/WGKTqmSzamLwJ0UHCyuSCuqek+FuPXTullWddpexb5dzO4CEvZPnhej4dqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FLIgnglfwxb6MRfi4trwa2szQhyt+oIcEfzRrEzx9fQ=;
 b=RVT1fFFFQyA4/NFjk3UNcL0Dadae+sjQNGl7SP4/TCd0Qsrm6X6Dwbe9IpV87rnXEfimeemYAeNVt40ed/Ft5oJhLEhHJ+Ss23HWek9B172H7Uu7A7SkMc3rHbtQIMVOMzxU26jo/+WnJaHmq+jN3m/SN5O5pwykeTZ72P6uuEvE7Tj3/Cr28Mi9YOchSWduWyS0CGGqvddLQ9XARUhx068UKAoWoa+htX6MlpNsutLNfoKYUBXyPXZ9NII3CbxRQh5n5GxIMgmCjvRWUxouvcP69bLw/NmUmiGli+jkRO+z1v1i9Jf6LPKHbcKqEdZs5IybyeKGhoQexfAqb9tgog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FLIgnglfwxb6MRfi4trwa2szQhyt+oIcEfzRrEzx9fQ=;
 b=JDOVSJNvtvOZQWZXIZmkrxDEoj5IDIWz97x9IRW72oXxGeNdkQKVDjf/MXA7xTKgBmU9GWFKNHKGH52BUyu+eU7i2B8GNi7oNd6HEfF4tevfvPlLlxO5e7bDukFkT4uGzfIis6TvbxqjDOhLUcvEL3cs/sC8iXRIKL0ONqWrrCE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 17:04:51 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:04:51 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
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
Subject: [RFC Part2 PATCH 01/30] x86: Add the host SEV-SNP initialization support
Date:   Wed, 24 Mar 2021 12:04:07 -0500
Message-Id: <20210324170436.31843-2-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:04:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 162c34f5-ead8-4fdd-de9e-08d8eee6f05d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4557B2BC21D1BD788C1E119BE5639@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CwExjS+mMprWmh/f0+fKc3Py6iADibBOC/8LtqT5vLisXiEygkQ2X6UTeH58NnZE3VZj19hn2EC6UBdT7KiUQFNPXvVM98/46OI76l2EJXqfbbKePn12LvAVbJ1ukJQLApMfIF7PNoIm0Elxv4Vy/Uy9OH9A4r/7gBLpsC00uwOBr3Zv9PwdxQ5pNWbvqP7AF3I6DcwDjtRpmsIKDZglYP5+upG+3p0Sq6TtnM8Q//yu3P32zmCYG40pJGPVJdQyCqzAMxm8/ZVmIgQorQ9PGPy6AOOqBopGrzJl8xSjD33Wx8gPVk1z3Qy2jomqqp+EyTvar35Ey0IIkmYUEVytDrdgegGdrDDART5urLs6n8ceScu7sHSWG5iBQfhPJLS7NyWP9mbljJNL10CpS0rRN+SHPlro71KIb0JpXcprp614WAi1St9R7oulgdg0/gBBpbtfh9vIfoe+mWp/3RdHG0qFX6c2zSXOksdohXPNBtYWFs6UbpJL9vZhyeNr8JEJ7ptdxAp3EIktb7maT8L2+bTgAe6/ELfcW3f/UdWi35kbtyxz6YEgsf25T7z1mRy6kKwjUpBaX8Gz/AOy+XvTVSuh4+dRE2s3N9PXmcitUUUqpP6HOGsRyMofrHvxyUTBN4zwU6H+qwOSKVyeuEQpY1uBlhlvEC39esageNfhVZs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(86362001)(54906003)(186003)(44832011)(6666004)(4326008)(38100700001)(26005)(316002)(66476007)(8676002)(16526019)(1076003)(2616005)(83380400001)(5660300002)(6486002)(956004)(52116002)(8936002)(478600001)(7416002)(7696005)(66556008)(36756003)(66946007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?W8uVOt1DE25xw+pyNgHzMQlxZY7ReZVVXDK2NJhLSY3mQVa/jnLCiHd1nlps?=
 =?us-ascii?Q?RExgzzy6mg23avkPkwUMteaSCqajJpyBzeC+guThCVe92HA3Wbogs7mE08Lm?=
 =?us-ascii?Q?F+4KLaqWZ0yDwemQ8UQw0zD+9JlOU2lxpvTeDm86SSzmuPIFuaHFg9rDk+DQ?=
 =?us-ascii?Q?qbsnhquLg2H5AcuCcWwcH7wpuNFL8iot6bfML5u7+ZHxwTzOvyTb/mjs1/40?=
 =?us-ascii?Q?RGvn8askRl+Bl3tJItCLShgHn6JfFXH0NcwgUG576OVNVLvZQ0+nNFhlDr4b?=
 =?us-ascii?Q?EB4uWofP0/HOTsxYDjXoRit3+w4N58ksKAC3v9nna32fCt3SV5wXApb0kEu6?=
 =?us-ascii?Q?BYXVweQAPAOPkK+YMm2YTDIJ9c82OZNw7J5dSU0m5xmQAd/8I6haiP8SOAqA?=
 =?us-ascii?Q?+KtXuOKYMDZmgHglyqdZ7quXr0jIbnMpQ8BYuKBkt3ujXL/8m4Ugmh66V+N8?=
 =?us-ascii?Q?M8Dyzs0Jsj7/yKdDIThD8BojMnIO2VRiDXDrsDs2SvM0mLRXvdUeeP4njQYC?=
 =?us-ascii?Q?Fxk+2Gv6AKYq4MXWtZP8JNo1VZ0YD2Ov4pWCt/keGjCyAbGz6tPz+xPB2u/M?=
 =?us-ascii?Q?fDgcep4S5mtPd52GOfhDHzdq7Gnxpy+CbDeigqV/pMJiIw0Nd8pVV7NmVRlg?=
 =?us-ascii?Q?Oq2vBrcl+XFf08FPfagvCqjghux6B++oiVP6RkoWXE8oO1JpXgReu89JgPZC?=
 =?us-ascii?Q?miyZUVAQBgyEL8SOrB80QOuykhfLk4EO6bfyTeYOaGaIL5oartjxzH7+qDDD?=
 =?us-ascii?Q?r40yz5EnDjKV0x+KcPLwPz+z9B+pscAkAYMa0NT+YvrRji9rkcl7/qwIbQE4?=
 =?us-ascii?Q?kkb1IRv3eBwd1p+81tdRK6O3y8guAlKxjgCLBEmNMeYr1w5pFWsNJCK9Ik5G?=
 =?us-ascii?Q?rcfSsPHoeR0BFnc8XkMDftb5q0mDmA+GvQJDm7ARqUYE8xpiodMjBATSBIKI?=
 =?us-ascii?Q?rPUAUf1FGuXf/sqdzCFMPMDtQphAHobFSUELVYUpGRQN6u7w4/OUmYbIvK63?=
 =?us-ascii?Q?mli9bkahVB+j7mr+zbWt2jGyPlYPftMWtTxsoui22vmPXQoa90UYmkDiwqa/?=
 =?us-ascii?Q?Vz7vv4z1y667CcO76C9j5kmI+k0QrcpU2crwycbxj99SewgYRJ2hVjD7TpdB?=
 =?us-ascii?Q?Jbc+pyFeMbq9mT8ldsm3cIhv+KZTPWhH8kY7J8vfNFF5N8ZOJzPIkF6IqHmZ?=
 =?us-ascii?Q?yuBiqfb04WyMGFTBlm7dLmLXJT+0S77Fe7A3NYe3P9mxNgPTI5x6daHfBokE?=
 =?us-ascii?Q?iZeR8XLUjDE9AmzHLTA3iBSCkb69LRQRi7ZtK/B62CegJ8SAu7TvYjjCjwZY?=
 =?us-ascii?Q?H6gruExd91Yxyp318TZ7Tfke?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 162c34f5-ead8-4fdd-de9e-08d8eee6f05d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:04:51.7106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v1yTp8jp+rHmSMO1vLLLnzu3woTZbmGKoQnR9tvu7jZWnyfLZ3am0As+35DSLVShq8xY44xyRY5udvgxGRYo5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
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
for the RMP table. The start and end address of the RMP table can be
queried by reading the RMP_BASE and RMP_END MSRs. If the RMP_BASE and
RMP_END are not set then we disable the SEV-SNP feature.

The SEV-SNP feature is enabled only after the RMP table is successfully
initialized.

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
 arch/x86/include/asm/msr-index.h |  6 +++
 arch/x86/include/asm/sev-snp.h   | 10 ++++
 arch/x86/mm/mem_encrypt.c        | 84 ++++++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index b03694e116fe..1142d31eb06c 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -481,6 +481,8 @@
 #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
 #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
 #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
+#define MSR_AMD64_RMP_BASE		0xc0010132
+#define MSR_AMD64_RMP_END		0xc0010133
 
 #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
 
@@ -538,6 +540,10 @@
 #define MSR_K8_SYSCFG			0xc0010010
 #define MSR_K8_SYSCFG_MEM_ENCRYPT_BIT	23
 #define MSR_K8_SYSCFG_MEM_ENCRYPT	BIT_ULL(MSR_K8_SYSCFG_MEM_ENCRYPT_BIT)
+#define MSR_K8_SYSCFG_SNP_EN_BIT	24
+#define MSR_K8_SYSCFG_SNP_EN		BIT_ULL(MSR_K8_SYSCFG_SNP_EN_BIT)
+#define MSR_K8_SYSCFG_SNP_VMPL_EN_BIT	25
+#define MSR_K8_SYSCFG_SNP_VMPL_EN	BIT_ULL(MSR_K8_SYSCFG_SNP_VMPL_EN_BIT)
 #define MSR_K8_INT_PENDING_MSG		0xc0010055
 /* C1E active bits in int pending message */
 #define K8_INTP_C1E_ACTIVE_MASK		0x18000000
diff --git a/arch/x86/include/asm/sev-snp.h b/arch/x86/include/asm/sev-snp.h
index 59b57a5f6524..f7280d5c6158 100644
--- a/arch/x86/include/asm/sev-snp.h
+++ b/arch/x86/include/asm/sev-snp.h
@@ -68,6 +68,8 @@ struct __packed snp_page_state_change {
 #define RMP_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
+#include <linux/jump_label.h>
+
 static inline int __pvalidate(unsigned long vaddr, int rmp_psize, int validate,
 			      unsigned long *rflags)
 {
@@ -93,6 +95,13 @@ void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr
 int snp_set_memory_shared(unsigned long vaddr, unsigned int npages);
 int snp_set_memory_private(unsigned long vaddr, unsigned int npages);
 
+extern struct static_key_false snp_enable_key;
+static inline bool snp_key_active(void)
+{
+	return static_branch_unlikely(&snp_enable_key);
+}
+
+
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
 static inline int __pvalidate(unsigned long vaddr, int psize, int validate, unsigned long *eflags)
@@ -114,6 +123,7 @@ early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr, unsigned i
 }
 static inline int snp_set_memory_shared(unsigned long vaddr, unsigned int npages) { return 0; }
 static inline int snp_set_memory_private(unsigned long vaddr, unsigned int npages) { return 0; }
+static inline bool snp_key_active(void) { return false; }
 
 #endif /* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 35af2f21b8f1..39461b9cb34e 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -30,6 +30,7 @@
 #include <asm/msr.h>
 #include <asm/cmdline.h>
 #include <asm/sev-snp.h>
+#include <linux/io.h>
 
 #include "mm_internal.h"
 
@@ -44,12 +45,16 @@ u64 sev_check_data __section(".data") = 0;
 EXPORT_SYMBOL(sme_me_mask);
 DEFINE_STATIC_KEY_FALSE(sev_enable_key);
 EXPORT_SYMBOL_GPL(sev_enable_key);
+DEFINE_STATIC_KEY_FALSE(snp_enable_key);
+EXPORT_SYMBOL_GPL(snp_enable_key);
 
 bool sev_enabled __section(".data");
 
 /* Buffer used for early in-place encryption by BSP, no locking needed */
 static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
 
+static unsigned long rmptable_start, rmptable_end;
+
 /*
  * When SNP is active, this routine changes the page state from private to shared before
  * copying the data from the source to destination and restore after the copy. This is required
@@ -528,3 +533,82 @@ void __init mem_encrypt_init(void)
 	print_mem_encrypt_feature_info();
 }
 
+static __init void snp_enable(void *arg)
+{
+	u64 val;
+
+	rdmsrl_safe(MSR_K8_SYSCFG, &val);
+
+	val |= MSR_K8_SYSCFG_SNP_EN;
+	val |= MSR_K8_SYSCFG_SNP_VMPL_EN;
+
+	wrmsrl(MSR_K8_SYSCFG, val);
+}
+
+static __init int rmptable_init(void)
+{
+	u64 rmp_base, rmp_end;
+	unsigned long sz;
+	void *start;
+	u64 val;
+
+	rdmsrl_safe(MSR_AMD64_RMP_BASE, &rmp_base);
+	rdmsrl_safe(MSR_AMD64_RMP_END, &rmp_end);
+
+	if (!rmp_base || !rmp_end) {
+		pr_info("SEV-SNP: Memory for the RMP table has not been reserved by BIOS\n");
+		return 1;
+	}
+
+	sz = rmp_end - rmp_base + 1;
+
+	start = memremap(rmp_base, sz, MEMREMAP_WB);
+	if (!start) {
+		pr_err("SEV-SNP: Failed to map RMP table 0x%llx-0x%llx\n", rmp_base, rmp_end);
+		return 1;
+	}
+
+	/*
+	 * Check if SEV-SNP is already enabled, this can happen if we are coming from kexec boot.
+	 * Do not initialize the RMP table when SEV-SNP is already.
+	 */
+	rdmsrl_safe(MSR_K8_SYSCFG, &val);
+	if (val & MSR_K8_SYSCFG_SNP_EN)
+		goto skip_enable;
+
+	/* Initialize the RMP table to zero */
+	memset(start, 0, sz);
+
+	/* Flush the caches to ensure that data is written before we enable the SNP */
+	wbinvd_on_all_cpus();
+
+	/* Enable the SNP feature */
+	on_each_cpu(snp_enable, NULL, 1);
+
+skip_enable:
+	rmptable_start = (unsigned long)start;
+	rmptable_end = rmptable_start + sz;
+
+	pr_info("SEV-SNP: RMP table physical address 0x%016llx - 0x%016llx\n", rmp_base, rmp_end);
+
+	return 0;
+}
+
+static int __init mem_encrypt_snp_init(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_SEV_SNP))
+		return 1;
+
+	if (rmptable_init()) {
+		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
+		return 1;
+	}
+
+	static_branch_enable(&snp_enable_key);
+
+	return 0;
+}
+/*
+ * SEV-SNP must be enabled across all CPUs, so make the initialization as a late initcall.
+ */
+late_initcall(mem_encrypt_snp_init);
-- 
2.17.1

