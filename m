Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62133F3079
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241433AbhHTQAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:00:51 -0400
Received: from mail-bn8nam08on2075.outbound.protection.outlook.com ([40.107.100.75]:31200
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241349AbhHTQAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:00:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDgGUmDryUQCuxiP0M7yfUVZscWT2IMVjA4ay5zN9H+PwvB0bstspA9lIf1dh0p9hyxghv/WooHg0UlgzEblkmdTix5g0UZRS59L4mKHTG0TCQ/JjKXp7HtjmE4Ni3RYUMliR/0wGcfnev9bqo7/gPG1at773sapqyoYhrIt6yCfPSof6uLcP0nrklU4G2OtFvsuU3pvfViRKFLHeWFJc5n0E7wdjrnmIEJyZAZuRx1irxrfnYnl8Z1zRXsenhrNBNZ69TWs9Wsw9DDyY02SJ3DIG6cc0hmTScLgR5u0rk2BXErxc7sSTeHbhv+UjO1EtQGIlrAd/w9S2nuyjx8pwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcFCHp/eiooGuqjKNQM4tnoilimf6OF8kp60GXnjlQs=;
 b=BzU4oNfVqPpB094xGI4TMIbukdv1kSQdsiHM1uarxMl/0ZHo29pebwqOBiN9+xNbPZKlzzsDjNHty7U2bbr9PhF7t7Ku08IYJeFtjQkAegIENJnTMU7naqtb83gT54ZRHFO2YIsUDwuMminwRTdx66E1J0s5EoOjisql5XtlhTapOZ4y+4Ah3WUZEeMmdzyO/16uEtJ85m+b2K8N/0dOHqNCRzKhhw9MBUoBob4gpQalKXuLgKdtLpg0s1ImW4I7I7kKgLAvTYeKBtam+UnRrdUG2aHvU3UqOsUUmTgi7LwVOthxoFd0uMUHP5eNLgmGXt1Dd4OyjaMiy7/EiO+6YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcFCHp/eiooGuqjKNQM4tnoilimf6OF8kp60GXnjlQs=;
 b=mG70e11I+9pV1BmOOpdV+LLuEnzIvNm4HrjSDQvRtUK+hRuw2tgJZ1avHuOhPJfK0p4r/IKOEOBtcmDvbE2Tzu+o+gw7/RMHIY/CUIBhBI6gQBQ5HtrzOibbTRFmN9UUoY0iWhKwpI/dqHWilrlO1w6ldketNO4tv5iar+ysiPM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 15:59:57 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 15:59:57 +0000
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
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 03/45] x86/sev: Add the host SEV-SNP initialization support
Date:   Fri, 20 Aug 2021 10:58:36 -0500
Message-Id: <20210820155918.7518-4-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 15:59:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7cbc6c72-c261-43f5-5a2f-08d963f38e9d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384AA69A8E60C7B878FF823E5C19@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z8S7/Bc29zTAYmQWGBXb+cUj/Jea7+pyOxAbwt8NJN8vs73qPn+mIWX38VfMqeJWbSwSgqhr6Pswsma1/NsuDANJ0lXmwaGwaeB9Oi6TOTQtqzLCK4YL/o3mQWfsXkX8QBsguxbEGG+Owv+5WU/2PCr3bbtZ8AYGxhymrXZ8XukGjV5IzyB0nyqGHWSOzelekUYJRcNH3ky4nOeS4VLcU0wkvPIX00XpYabdDzuWeiPdxLL3uL649iSo23Zw5s3Fe2o/AUXIJwD2unH88XTtcc+82Y0+OD32JgNM+DEl7Oqmp3vKZP6n1UnXL0Hofw4TGy71hKdxHyc5CQYK+FbvkEqnVlXcFH+K0umBFahhjcdA/Pu7JtPa1w3EqZHndVqEObzIWJfWmfGe3qSMTZ1MeDZzbVk+ceSzcuev4wii2hiCzBZgdTz3rxc40OxRY9O/iO6yVMlULKUvwGlVfWDcaxThaP4WNcLEcQeSjb6BNPFwu4d/9N8P9DhxSszcAPWEnfrD2ppV4o9Sp+fSiCVL7rP7PYe2CjEwqEguX5zyf4bSXIarG38WyoVGj1+iLZdfVvT/PBoxYSWOPGNb4Wxuw8mHwmd5D5YrxbgDaVnE8QU9+vfSrOQKIADdqZwtbgMFv+SzPdjPL91q04h7c1PG8hZPgtjAXi+QkUuzfp5t45efWHi0uZcW41Zmc7acUYctS4yJdW6oV5hLXw8Ml1mRDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(5660300002)(6666004)(52116002)(66946007)(44832011)(36756003)(7416002)(66476007)(7406005)(6486002)(956004)(8936002)(316002)(2906002)(186003)(4326008)(478600001)(86362001)(26005)(54906003)(38100700002)(38350700002)(7696005)(1076003)(8676002)(83380400001)(2616005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cP7CTp4ofF6NiPoquGlGZZXk0/BGNhTvjuYEm0Fri+fmgLI22Pq95xkcG/Z3?=
 =?us-ascii?Q?zNE3YobTUAStP35D6zKFCVRj0xmJk4mlnuqIeRdIC1ts2bQxDjbePkfrZKhX?=
 =?us-ascii?Q?rGqQP1aGBVITRf+g/gXHs9CXiGs/+o5bvAo0BNwnZki7BOKsxdTa9B27maYR?=
 =?us-ascii?Q?7DXRfOxLUI7kBQ12PlqWF2Rx7+FAjPvOJfev4snnGXyqG4QcYUohbfxBHCJk?=
 =?us-ascii?Q?MqcBaVojrQUYMCn3h2XUf/QgoPjrdUwMOVEEFBYiozf9HGdiPVuNJV+9DOGO?=
 =?us-ascii?Q?wZMc8qgiS/+GjIki+idcJG1EJTLUw+VBa45gn70lR8pwbC76BJ+pBGZXBhtq?=
 =?us-ascii?Q?DfRxd52qVorBwkAmUktgqM5438+Qog0lKFEncJjbUgHRtSryALYZMWL5uLMG?=
 =?us-ascii?Q?mq9TstO0ZpvBHgjO+1FTbHAJlgzKeu/mRBr0focD5ax8lmZNYiztvfVfrzW1?=
 =?us-ascii?Q?MqJAWmIN5qDAO/4pQeOV/PkahrAw5gl9X4bCEqw+fvAvGPRPsZjJhqadcbon?=
 =?us-ascii?Q?hmHBsreZI4IeKR03yFcMnwBDJH4UHE661oIz2ooznmB7iZde+J2pneAfihsv?=
 =?us-ascii?Q?Ar4axEwxhHbS3zpzWBqJiysB8Oass0ki3EBnXXTZ1+S2mwL3meBvi//ukxdn?=
 =?us-ascii?Q?7nXZAfOL2VfXtEEyWDgeKDwQ130pE5j2MEJZZ2Ivw4N+IK8F5LCQzEeC5mAk?=
 =?us-ascii?Q?v0+jbn3vj+QnV1ZlvA96WWqbhoQuzBUs0gSY1CocIsPYNBZieHBVIbItBeJq?=
 =?us-ascii?Q?qXPwe45qtPwZjfOxWuK1BCb5vFohX5f3Dhme6pS+ifmdfZRJTraN2StPmzU6?=
 =?us-ascii?Q?mwhWGKERrw3+Ifazxwio/OPK1sqsPyCw/XVi5/dYhWv1FR7oTqyQ+o0paWo2?=
 =?us-ascii?Q?qrIVYf1AxhM4mATEGpIPTqdf92RKAK4BdFxjORo6gMPQrZd1fBTicZkE+tcw?=
 =?us-ascii?Q?oikU4FASsmJ01OnhsE93Zag8gAVvTyx7nMi5/TAQu+FLIhS39ZavffU33iP4?=
 =?us-ascii?Q?cKEXUgE3cTNQDMKCIrvIvgWgGUiRaOFWsTGvyeEBf9Y1lAar8ebExjJ2j7BE?=
 =?us-ascii?Q?AFtaq0r7zDA+TaFGcXli9hZLf8LKwWGcnR8BYwgCFY1wxVWA5rFSmq3nbi63?=
 =?us-ascii?Q?a02H2daG86LvLVjOUgzacBa3JXhBbJDk5MUf78q8PFsDEY3zMeSOg9D7DQjQ?=
 =?us-ascii?Q?e8PJTvVty6j5mj3UgyZuOq1fPr9nPeSO7eEWErJd4mVYpKAcU0I3MOLAnLA3?=
 =?us-ascii?Q?3dQZSVUOZ1WM4adfypnt5xprZae68Qc+qQzv7yvfAFfDU4n+wtK5hJdMEolg?=
 =?us-ascii?Q?NyypF2hDnmZLRjZbuSoaRa4j?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cbc6c72-c261-43f5-5a2f-08d963f38e9d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 15:59:57.2554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wBWKzx6AdGnewRPjMsABhjRXeSYKGVT9yM4gQMd/i1A4SbGDzuTb9WHZxeAxHtqNYx9U4PGSppDKv1xM7t1U1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
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
 arch/x86/include/asm/msr-index.h         |   6 +
 arch/x86/kernel/sev.c                    | 144 +++++++++++++++++++++++
 3 files changed, 157 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 8f28fafa98b3..30a760e19c35 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -65,6 +65,12 @@
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
@@ -88,7 +94,7 @@
 			 DISABLE_ENQCMD)
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	0
-#define DISABLED_MASK19	0
+#define DISABLED_MASK19	(DISABLE_SEV_SNP)
 #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 37589da0282e..410359a9512c 100644
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
index ab17c93634e9..7936c8139c74 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -24,6 +24,8 @@
 #include <linux/sev-guest.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/cpumask.h>
+#include <linux/iommu.h>
 
 #include <asm/cpu_entry_area.h>
 #include <asm/stacktrace.h>
@@ -40,11 +42,19 @@
 #include <asm/efi.h>
 #include <asm/cpuid.h>
 #include <asm/setup.h>
+#include <asm/apic.h>
+#include <asm/iommu.h>
 
 #include "sev-internal.h"
 
 #define DR7_RESET_VALUE        0x400
 
+/*
+ * The first 16KB from the RMP_BASE is used by the processor for the
+ * bookkeeping, the range need to be added during the RMP entry lookup.
+ */
+#define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000
+
 /* For early boot hypervisor communication in SEV-ES enabled guests */
 static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
 
@@ -56,6 +66,9 @@ static struct ghcb __initdata *boot_ghcb;
 
 static u64 snp_secrets_phys;
 
+static unsigned long rmptable_start __ro_after_init;
+static unsigned long rmptable_end __ro_after_init;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -2232,3 +2245,134 @@ static int __init add_snp_guest_request(void)
 	return 0;
 }
 device_initcall(add_snp_guest_request);
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
+static bool get_rmptable_info(u64 *start, u64 *len)
+{
+	u64 calc_rmp_sz, rmp_sz, rmp_base, rmp_end, nr_pages;
+
+	rdmsrl(MSR_AMD64_RMP_BASE, rmp_base);
+	rdmsrl(MSR_AMD64_RMP_END, rmp_end);
+
+	if (!rmp_base || !rmp_end) {
+		pr_info("Memory for the RMP table has not been reserved by BIOS\n");
+		return false;
+	}
+
+	rmp_sz = rmp_end - rmp_base + 1;
+
+	/*
+	 * Calculate the amount the memory that must be reserved by the BIOS to
+	 * address the full system RAM. The reserved memory should also cover the
+	 * RMP table itself.
+	 *
+	 * See PPR Family 19h Model 01h, Revision B1 section 2.1.5.2 for more
+	 * information on memory requirement.
+	 */
+	nr_pages = totalram_pages();
+	calc_rmp_sz = (((rmp_sz >> PAGE_SHIFT) + nr_pages) << 4) + RMPTABLE_CPU_BOOKKEEPING_SZ;
+
+	if (calc_rmp_sz > rmp_sz) {
+		pr_info("Memory reserved for the RMP table does not cover full system RAM (expected 0x%llx got 0x%llx)\n",
+			calc_rmp_sz, rmp_sz);
+		return false;
+	}
+
+	*start = rmp_base;
+	*len = rmp_sz;
+
+	pr_info("RMP table physical address 0x%016llx - 0x%016llx\n", rmp_base, rmp_end);
+
+	return true;
+}
+
+static __init int __snp_rmptable_init(void)
+{
+	u64 rmp_base, sz;
+	void *start;
+	u64 val;
+
+	if (!get_rmptable_info(&rmp_base, &sz))
+		return 1;
+
+	start = memremap(rmp_base, sz, MEMREMAP_WB);
+	if (!start) {
+		pr_err("Failed to map RMP table 0x%llx+0x%llx\n", rmp_base, sz);
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
+	return 0;
+}
+
+static int __init snp_rmptable_init(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_SEV_SNP))
+		return 0;
+
+	if (!iommu_sev_snp_supported())
+		goto nosnp;
+
+	if (__snp_rmptable_init())
+		goto nosnp;
+
+	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/rmptable_init:online", __snp_enable, NULL);
+
+	return 0;
+
+nosnp:
+	setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
+	return 1;
+}
+
+/*
+ * This must be called after the PCI subsystem. This is because before enabling
+ * the SNP feature we need to ensure that IOMMU supports the SEV-SNP feature.
+ * The iommu_sev_snp_support() is used for checking the feature, and it is
+ * available after subsys_initcall().
+ */
+fs_initcall(snp_rmptable_init);
-- 
2.17.1

