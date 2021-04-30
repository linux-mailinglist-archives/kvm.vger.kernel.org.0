Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52ED936FA7D
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbhD3MkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:40:02 -0400
Received: from mail-dm6nam10on2058.outbound.protection.outlook.com ([40.107.93.58]:15105
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231696AbhD3Mjx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:39:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WroCWdkX0M2Kk+/iSKPfLtR6ZkUIzyWYMtZwL1k/6SjD1Ew6W7ckE3DBujzENKVSpxG8DosJyuTWSR0poPC/rIB9pA5QngCIQarlqwvaTfo34t4G8xBumsm2E2bhuLuSBpn/UA4F9BfPOkkmyfwS52WhsDr/y7ygqiVHMOaGkBMr+c1IPayRT7tUsBUziyY/HRcdJRdmbVZOfNO4D4vc/vBp1Du53DwKeyHa/nsP4cSG00C6D+GezZbmn5+HrrQGpzFyrVGGWAzKy3XP3xqX5wmB7Q3q7XI33tXfGeeETQszifGJdm6+j5TBvmc8x2EgcIvdM6Vv4iGXAuqp1+WM2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3DdvCrLSEGXEdhC62vyFKT+09OMJobfB3JwxfkgxM4=;
 b=RfJ09a0/SLHQ27gmsAyLumLUWlOKpBssaOqjVsTV2UfX1V5CX54op/ZqHyLOy4DVGrjVH7mwUdtwQBDG+fMtR0kNwEDGR36+R44qwOLEIuCk9vwq9fkNxAQPFhOQbJN6oKGwbC7NLafGiwGr/CbrFsq8dNHBIJEAf/dyZgHDqwrMExL2us1u/kXRBPRSZHARkU0ZLS7v02pp8suwxTX1GrBYTZOzFAwrn6AUqqKJ6AvvGzhnDwUoqyIjXzEnuexevUf5PWeo3D5A9BPzse65abBTF/CF/1yBKxMS20lP5VbN7cK7uwvOsBNtqqRRXT9KzTefnwjmJsT7nU+GsR3+Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3DdvCrLSEGXEdhC62vyFKT+09OMJobfB3JwxfkgxM4=;
 b=hL14VNI3I3HpQgfITksqCVfy6AaUG++/foIAkGPj1WxbTA9IQdUE7t+FcwQUftiWxyYN41SFBjwwV9uej+Eh2SDXzLZkWqI+oSZYm/fPfaIX8v2cxoYG1833Y1AmiLD5mWJAZx70JKl9aaIOM+pbD14Q3dfTB73dmu8YcIogoA4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4511.namprd12.prod.outlook.com (2603:10b6:806:95::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Fri, 30 Apr
 2021 12:38:57 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:38:57 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 05/37] x86/sev: Add the host SEV-SNP initialization support
Date:   Fri, 30 Apr 2021 07:37:50 -0500
Message-Id: <20210430123822.13825-6-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:38:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 192290c4-095f-480d-39ea-08d90bd4ec1a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4511287FE79F607789B3E626E55E9@SA0PR12MB4511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a5Fh2Qe59Lnlej8+5ZdMmKy0ErgY8nEOXR3HivgVGmf76Al9IJU1jjfKlhyfypmlMBaIwZ2EisS3VosAw5+w7V63me6KAqT5Y3TtXTZmewie7MigWk5W2ZtGaeEjbWOgYGQVAAX/pUp3WBvXLloYQm0WRpWcvXTAcHPZKRBROH3yueWOCfis4l0HwMmicZ4qhzkL2ioYehzLAkFaAhtyoi0J+Gp4w8yEHJ7tkkdFWM6jEAe0npBF5H5ApK3oZKzbXjwpt6GsrASPVaVy7jtd56b7IFJITyaft1WMC3Vi7/VZOi2kRX+UKObvFbt0oe/h+lHJJCNyQX6jqm3BBso2gLgNkXqsuUfUb479dxaN1OKDju/oRbI3F+t4cVxHU4KWQW3Az+FarTzvrvUM/bVUqAARsnzPEXqisMdEH1J2CN0LzwViooc0TrJk1aqexDnlO4DDHcTE3CDrhO+D/5lPefySe+SR8lqOOljbupVG1HTZEjMr3i48woD9RNnhHJe4PP+4Knu/hWuwCcbOxWEM8PZT7dp9FE5WhMkN9zqmmS2jg38AtNaJqmEOOd6UGfu6PHFAn+wwQT7BhhNPKe//Cii/l8hrIISijXX5Mw400L8yKI1ZPUm2n4+bNJGoNHliHG4ncUAP8/Kqr+GQlD1hxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(83380400001)(36756003)(8936002)(86362001)(66476007)(956004)(186003)(38350700002)(16526019)(6666004)(6486002)(44832011)(52116002)(5660300002)(38100700002)(7416002)(66556008)(2616005)(26005)(478600001)(4326008)(66946007)(316002)(2906002)(8676002)(7696005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TC86PS4OCR7Ar9W8T/3a0ovhyWALsavxKBlLq0i3Hn1FF8BZtqxInEQR+H1o?=
 =?us-ascii?Q?9T7Gv6Hto761dXdetH0Wc9JUQzgVKihE7IRcn+dVc0MNuu/l2FjMkys3PtI2?=
 =?us-ascii?Q?VETplLIDzIXgPlYXN9AIiihGAqdlTImmsVAl5TMWHdFOTwX2w+GF6VebUAh4?=
 =?us-ascii?Q?FDDiO23o8S3j/3cEv0vSZN0GISjeHjZVAYYls9JQdaJOxGUNszhm/wLs9l2n?=
 =?us-ascii?Q?w6bVDim6JPSgFmXdyipnUD3meo/6edcszFTDWocEst7hU5hiveoHFEFanR0a?=
 =?us-ascii?Q?+l6gsJvgvpL82lOpYpbnoLuiApXSbhrpAlkDznUS7E6U/o6I0qJgIIz4o5ox?=
 =?us-ascii?Q?EnAnxFlLzn3D4ieJBh5WbQ3dhCdTWhVuxZMjm79C1J13WVYRt+25Tr0nS+4U?=
 =?us-ascii?Q?hBRqRroyOvzcHirRwd9YMjZoc0JRu19VIYyzRev3HPvZC2AAQS+2xo0V5lzH?=
 =?us-ascii?Q?3mfMbMjXfDurCnoyZV+dgBaDiliTVdsZANxBYbJ+I6RxhIrC/LBhJPp7BcJt?=
 =?us-ascii?Q?WrdZ8by4TbKsDefC9TUq7EAU+FC73k1KrkrSSEIZH5aDsGeOe/PNhLjW8uNz?=
 =?us-ascii?Q?v93P8lb5BuY+stWiyMQc7inuuuUuOgdv6RDuMJzNS0QbXTFII5VZgfJqVL1z?=
 =?us-ascii?Q?Uo34OjU8HWWWedDkwDreJ1vpc0F8e00pA9SL32f8OpQMpEktZqu7oOb1v6Dg?=
 =?us-ascii?Q?h8k/EThERNuwblXnkF2apJg8zFhLQLQqyPYl6LUTmqve0fQ5/glIFFBTZrtK?=
 =?us-ascii?Q?x3JIO7q4qa/6WAkK/EtrOdo+dF5IhKGuCgLnVu00tLjuLVF5G78voshrjT4W?=
 =?us-ascii?Q?YFVXyZHUgsnU+AqqzzlhvgYQWdxFEncgIDgWyoS+b1pqqCJxsy9LBoRvnwlB?=
 =?us-ascii?Q?n4H36Q6laWhY6CfVniumDMferI4oRBe7cx3O/mlsj8VLk6nmaKCw3qOWFyle?=
 =?us-ascii?Q?ofs+EIAcHTM11TJvSAZAQOx25YQu75ICt8eubgTAU4DSTSymBqHLry3xCR9f?=
 =?us-ascii?Q?eZsW7BR3MYT6ICERDviRK8Papqma9H4uOVvYwhXPXFXCpO39F6m/9niKAct0?=
 =?us-ascii?Q?P3MUCrqay4KVPveEq0elNHwNQR2Ol9Gc/oJsrM13VbLwTeyr3lNYD+tf7FL9?=
 =?us-ascii?Q?OeVJ2UVC1UQYrQmccGaed1+Muw5n90xpOVy9FA6798DgRZE96N1DDF3DTmEB?=
 =?us-ascii?Q?49ORxz5YYHS/ak4UAPBW3HKKPTurB6XLS9iIwmM8L+M91Y5ocyEbtX5ztzqI?=
 =?us-ascii?Q?TwAZEDsCG4p0joD/EbCfTBYBfRosq7M6C+hcgKRBeMVkuV+2ZpHXeg8P14o5?=
 =?us-ascii?Q?7a1G2BtI0hLAySKwYbBPBuOZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 192290c4-095f-480d-39ea-08d90bd4ec1a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:38:57.3568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IM2+hk1pSJv06lLcFYByutPeVufg+1+/vccdyRsaGkGiQn0P1Ll11S0f4g8Br1HSI5Uzk1GaeJSA/E4rvnRO2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4511
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
 arch/x86/include/asm/disabled-features.h |  8 ++-
 arch/x86/include/asm/msr-index.h         |  6 ++
 arch/x86/kernel/sev.c                    | 91 ++++++++++++++++++++++++
 3 files changed, 104 insertions(+), 1 deletion(-)

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
index 79f7a926476a..862cd2e777d9 100644
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
index e54a497877e1..126fa441c0f8 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -23,6 +23,7 @@
 #include <linux/efi.h>
 #include <linux/mm.h>
 #include <linux/io.h>
+#include <linux/io.h>
 
 #include <asm/cpu_entry_area.h>
 #include <asm/stacktrace.h>
@@ -48,6 +49,9 @@ static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
  */
 static struct ghcb __initdata *boot_ghcb;
 
+static unsigned long rmptable_start __ro_after_init;
+static unsigned long rmptable_end __ro_after_init;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -1782,3 +1786,90 @@ unsigned long snp_issue_guest_request(int type, struct snp_guest_request_data *i
 	return ret;
 }
 EXPORT_SYMBOL_GPL(snp_issue_guest_request);
+
+#undef pr_fmt
+#define pr_fmt(fmt)	"SEV-SNP: " fmt
+
+static void __snp_enable(void)
+{
+	u64 val;
+
+	rdmsrl(MSR_AMD64_SYSCFG, val);
+
+	val |= MSR_AMD64_SYSCFG_SNP_EN;
+	val |= MSR_AMD64_SYSCFG_SNP_VMPL_EN;
+
+	wrmsrl(MSR_AMD64_SYSCFG, val);
+}
+
+static int snp_enable(unsigned int cpu)
+{
+	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		__snp_enable();
+
+	return 0;
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
+	__snp_enable();
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
+	if (__snp_rmptable_init()) {
+		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
+		return 1;
+	}
+
+	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/rmptable_init:online", snp_enable, NULL);
+
+	return 0;
+}
+early_initcall(snp_rmptable_init);
-- 
2.17.1

