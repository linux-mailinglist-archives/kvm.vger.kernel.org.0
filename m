Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954DC3F3083
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbhHTQBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:01:08 -0400
Received: from mail-bn8nam08on2075.outbound.protection.outlook.com ([40.107.100.75]:31200
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234121AbhHTQAu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:00:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Djd1ffdiRXr7bcIQezuqe641Er/tTol8jeDLRV9CHJah5DGGbtXdBh1UpF2mhohkeBlutIFdNqj6P0RrdWWkWn3aSbTU6KtO5M2rXyeogFKHD9HeLdvXv7hgmseMwYMGLSdFe3MfQtjc7qDE5Pya3WDY9/emX7Ch0IxURrQaLpYe79f8roFmpEKL2lCVVRioRUHfhs+zcb5pFvbfLmFDRcSq4zbdIeoZL+8au+7usFZnHfzHCG7ApDOBLS2EfERtRh5/eDfXs4eQLDTEIGploZD0IBSzfQnfA9o1k3uiyLeialvwsdG6i3qHHdsQ0i5BSVlD1TGDJEps2xEyDsKkpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIfZlMpWwv9SLwtCUiTd7tb4jwVzws6SFSRmlPVJSwY=;
 b=L98BVKNmTcf5ghpDbu2gJPaWOOZyDCR/WbcE38G6egAaGmbAaJEjwkLaG50VFFM8/GKXKtQsi9vKMViA3+feGDvPWog8PQ7I6zpEIW4Af8tJr+3MICTLPrFTssQU+Q+wCJXt9rMe5sT15DZL4KOVW0qAMzU1Lg0fC2epnP6M6jvb/9Nkkl0l9O/9dzAN2IGZPfWM5acKj34Sqaedx/cGPKQakdOFiMywTP/XydGktlBVKnCLaAphB3G3JiO9TlAULXaCBRHepo/pL0zvd3KU/m0vfjEI7QPHU6SdL5WDiJY21KqeeswW3VdnBJVpGr6I7r09mlloPlgyuzEBoq/ITg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIfZlMpWwv9SLwtCUiTd7tb4jwVzws6SFSRmlPVJSwY=;
 b=LUk6tzK6q50Mjcz0hy99r97KfQxpb/di5pEmKfSbUSxhCN+p1bhQb7pCXAXsqUE7p7Qi/mT1TRozpUpgch5oAFV2yRIQ1TKi+bHCEUmkUIdlwbGl2HtJbeGvstcoOuB5Pz19tRUy1O7pSvtVBBKiLTsmER5QnPRqXjVjy9tSTfQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 15:59:59 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 15:59:59 +0000
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
Subject: [PATCH Part2 v5 05/45] x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
Date:   Fri, 20 Aug 2021 10:58:38 -0500
Message-Id: <20210820155918.7518-6-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 15:59:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83e37bef-251a-4609-0402-08d963f39006
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384C9AAD2E876A50FBA131FE5C19@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z83hTp1WRXnNnveHEjRvnCeW3VQ1mKt6FMg4KtbCAgUkcHZxiaEwiQA2+f3+OARMycVMrRjTRpescYjhS1vpJHhYq6JtGS0hMvo/E2pQ7OW2ZDeBJbQeWxJghuFWJkRDx1VdMMul4kW67ZLx3vE3EqeYgee3HmjDWequOKPKLqcO6IE2cTh7gojYD5ZBI28d+xodZLwDzeLdCBHbU/M4msqa7LbvO2c0YokHl99gRjiYAL4lhu+8rvCvte8f2EKHj4rTXairj5TweEys9pzrjQWKvqCRXxPOruuKsK5dlN2fqYicJsSoSMMp5MfLf0HM3wIQUR+wQNwzjg/KPfihgF43idNQDAihr0VsUPcRiU0Br/7XqIlVmi9uXhds2OcuX75TiEge+GVVeWploQGis3Q3wFMboLMeYLrYM1pxprQCtoW4ZzgSYLmVyvmoaOA0EDxYADD9zu3MSOHy7RLoDu1fEhRw3vjB77LLEogcxirG7nuxqAV3ijDpyWzl7TRS/M8xSoipnRGiQt1nyq7ju9T54pCzghXfeX6mqGdnR8Ya4fi1Y+f9UjWHi5gDORfYnY+vmXaT1+3fw8qhxdTxVvs/pTHIAey05ag4j83PC6JfGGO4v7yMchXZa05Gs5wZUvG1viQQHeLv8ctUgWPH/UiR87nlD9Pir7uGblcABYb12c4oVG9G9HDv8WZVuEwp7iSWtg+cpwd+1wxHDwvBRjN48u4EOylXBXs1m8m70Ps=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(5660300002)(6666004)(52116002)(66946007)(44832011)(36756003)(7416002)(66476007)(7406005)(6486002)(956004)(8936002)(316002)(2906002)(186003)(4326008)(478600001)(86362001)(26005)(54906003)(38100700002)(38350700002)(7696005)(1076003)(8676002)(83380400001)(2616005)(66556008)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4T2SB+cG4C9xQ0qS/BmH2BJebtWNAoCeDjj7GK2knHKFjJkUVjeHo6tjgURO?=
 =?us-ascii?Q?tNwws/a1mMUiX70sldgld2LtyzNlpjm68IN4IGSF2MNlNxG+8fuGvXiJkqpC?=
 =?us-ascii?Q?jPDfYuhtENtJr/dM/sr9y6a6PjZzyzvbxIYcYFrhWdIfDFdJJQoMERNLy861?=
 =?us-ascii?Q?+Js1EJN8MmgbXoexV1DYlPag/5SWCf0ANbatvsu8WVDkmFZ6Y8xIJ8sHcPLY?=
 =?us-ascii?Q?QiOtVPv8Q7jfgB5eXe/sXzfHkTJwzgtlDBTpkZ0+y81xR1qfPsRBOKnWGZL0?=
 =?us-ascii?Q?tk2T95T89L4/zBrYVqO344RuVc8yvxiOsH8YDfu01BKKMQ0A0kCZ+bkL9wdf?=
 =?us-ascii?Q?SiZIYA4GKXX7ysLkVgXM/aiKQh7ixFw3emBdCMc/gVSUrDYcQ/DPML/Sbr3I?=
 =?us-ascii?Q?pZam/5QIxzibiBlVeS/O4lqoIL94VWu2l02a/k4xC4U94zsTEvo+eDRADmVb?=
 =?us-ascii?Q?4xyJtvpnAVQd0TP26e5ElxwxC37u9ghPg+yZ+8CRrUgwYbYRVeggIpP48+/h?=
 =?us-ascii?Q?F5wPbBDVEPaZQ1Cy/qP7Ou7aduSYVkr0mQucbjs7UKmK6WHOIxU9sK8Xun6S?=
 =?us-ascii?Q?qt9B/TfxCEQZ+ZpW05xSExBz3Icqug7zuRmEgiAfMY1sCiksMusZhG9cP73M?=
 =?us-ascii?Q?GiUSfnCYDUN/H88KtGvHIM67ltBrZ/JrkD/OvTy2JjGUuM4mwUvClnBQZ6Oy?=
 =?us-ascii?Q?sCwdA3OTN4UD/WbRlYoOSF7g66xjyWSnhHNPf/ig89CpyZxs0Co8nuiOV/21?=
 =?us-ascii?Q?o7k3nBtr7ggIkF9Ck0MVHbNQhoSLUA0bNnJMgkxIMbRAz39o6g4v4X2PBHEb?=
 =?us-ascii?Q?DBRIHtOzIOKzYSRkX6gG1UYiDDcW94B1NL/4Jeqq3lPZUNILKiwt36MLMbdK?=
 =?us-ascii?Q?UwR+JZ4XuMj3Oq798yiq80lRnl5TKk+3yj513KbpDhcKuOr4J4aEd1wy0VJM?=
 =?us-ascii?Q?JC0h3Y/PJhl66aT1d087WGnYummPG77G1TcHh57BEKHb4DFoel72+uZqxsCf?=
 =?us-ascii?Q?JNKfDX+p5Hkft+U35PXFX84qKyuV6RBxAvZoqhIfO/amu/G+UOXZnW44jvd4?=
 =?us-ascii?Q?oJpYm+onOxzZetOW4KdeLHqk8TOxAfYVUkpiMr0SfwTiSw7qcLhVY8qG3uz8?=
 =?us-ascii?Q?zbZGzNy/TPdoaeSuirIRp84pIGjEZh9vek/ELr2GrEqx0BG7m9Y8NkRVUnxU?=
 =?us-ascii?Q?8MvVSrqMqtLDgKqUK0Im9l/iPJ0TF0JKK6buI3pkSWY9xd99Arp6ZxPx6C+w?=
 =?us-ascii?Q?n3wx1jwbHHFC2JuXYjNzMGUcz2KpskftZA+WWpAoEGbgp9sG0akRsN9VSqlK?=
 =?us-ascii?Q?PBH67CKQN+0zQV2HU9pGZ1IN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83e37bef-251a-4609-0402-08d963f39006
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 15:59:59.6150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CoqLtGWVE0Ox52UFir9Z2au8qsGAcnEtcrzkgvYaDdZtjUlF3ORzV8oQMSUXEHENCY4TWJ/dOxeB980RLJfUxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The RMPUPDATE instruction writes a new RMP entry in the RMP Table. The
hypervisor will use the instruction to add pages to the RMP table. See
APM3 for details on the instruction operations.

The PSMASH instruction expands a 2MB RMP entry into a corresponding set of
contiguous 4KB-Page RMP entries. The hypervisor will use this instruction
to adjust the RMP entry without invalidating the previous RMP entry.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev.h | 11 ++++++
 arch/x86/kernel/sev.c      | 72 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 5b1a6a075c47..92ced9626e95 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -78,7 +78,9 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 
 /* RMP page size */
 #define RMP_PG_SIZE_4K			0
+#define RMP_PG_SIZE_2M			1
 #define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
+#define X86_TO_RMP_PG_LEVEL(level)	(((level) == PG_LEVEL_4K) ? RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
 
 /*
  * The RMP entry format is not architectural. The format is defined in PPR
@@ -107,6 +109,15 @@ struct __packed rmpentry {
 
 #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)
 
+struct rmpupdate {
+	u64 gpa;
+	u8 assigned;
+	u8 pagesize;
+	u8 immutable;
+	u8 rsvd;
+	u32 asid;
+} __packed;
+
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 extern struct static_key_false sev_es_enable_key;
 extern void __sev_es_ist_enter(struct pt_regs *regs);
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index f383d2a89263..8627c49666c9 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2419,3 +2419,75 @@ int snp_lookup_rmpentry(u64 pfn, int *level)
 	return !!rmpentry_assigned(e);
 }
 EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
+
+int psmash(u64 pfn)
+{
+	unsigned long paddr = pfn << PAGE_SHIFT;
+	int ret;
+
+	if (!pfn_valid(pfn))
+		return -EINVAL;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return -ENXIO;
+
+	/* Binutils version 2.36 supports the PSMASH mnemonic. */
+	asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"
+		      : "=a"(ret)
+		      : "a"(paddr)
+		      : "memory", "cc");
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(psmash);
+
+static int rmpupdate(u64 pfn, struct rmpupdate *val)
+{
+	unsigned long paddr = pfn << PAGE_SHIFT;
+	int ret;
+
+	if (!pfn_valid(pfn))
+		return -EINVAL;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return -ENXIO;
+
+	/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
+	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
+		     : "=a"(ret)
+		     : "a"(paddr), "c"((unsigned long)val)
+		     : "memory", "cc");
+	return ret;
+}
+
+int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable)
+{
+	struct rmpupdate val;
+
+	if (!pfn_valid(pfn))
+		return -EINVAL;
+
+	memset(&val, 0, sizeof(val));
+	val.assigned = 1;
+	val.asid = asid;
+	val.immutable = immutable;
+	val.gpa = gpa;
+	val.pagesize = X86_TO_RMP_PG_LEVEL(level);
+
+	return rmpupdate(pfn, &val);
+}
+EXPORT_SYMBOL_GPL(rmp_make_private);
+
+int rmp_make_shared(u64 pfn, enum pg_level level)
+{
+	struct rmpupdate val;
+
+	if (!pfn_valid(pfn))
+		return -EINVAL;
+
+	memset(&val, 0, sizeof(val));
+	val.pagesize = X86_TO_RMP_PG_LEVEL(level);
+
+	return rmpupdate(pfn, &val);
+}
+EXPORT_SYMBOL_GPL(rmp_make_shared);
-- 
2.17.1

