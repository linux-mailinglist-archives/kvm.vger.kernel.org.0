Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD30347E8B
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237109AbhCXRFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:25 -0400
Received: from mail-bn8nam11on2078.outbound.protection.outlook.com ([40.107.236.78]:50401
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236981AbhCXRE4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:04:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UFxqFIWasKsJCttmo8Q0mLFvK6kvnft4ZoSYTQRY97nYR6PUin4QWlwS7OyZEHALeZq+JtL/szSiKcRP5Ymyaahi1w/i/8FYDDxUOe4dKqx+fCYYJOxOG0WlzkDQ3WTvGWxl/SHccqhZUw7ImjW4CeCyeyjIMjLZjiLpqWEC+pVd1d8K0RoM5nh4baEPAh/ZP5n25THLCvV/Tdvq60ENOochtKIhGINjbnLCjYTorg8gDPELbg5ohFPm1L2PtTOV4nE0EGctY4lIg02TgNgvC7TT1/2wFw+x2iRXWbNpL5UUJxw+Y32u0VtvIhLHL9F+LGPZMGOYhO6Ch85n/lapdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/P8ewgCl43XidADqkdBmkjFX6Sfef4igsqANzNI8R+M=;
 b=V+WNZf+r5507cj0KOsNpgw8VAY0nUGBbtdoBcj+IvBHXm4yAjfUyz75Ve0Fhjp9Kmv6w6Y+d4rEQGhuQxLHrc4gbuDw+sXwZ58L+3w0tSHET3XQNK7YlJDNM4c06RXveQ05GEPu/FLA8PFcaxStYp4mZ/C8C8jx9s2qUF/fgOz6ce0P8ROIeaA2XkcMJuztmx8YFvSn05xIYpQJHYAYvcW9vS1KYo/nv1J83oTLabB/J9iVwEMreSbm0UQBYn0fk5TNLZMclgRfP7DTboeJZ/ieKsGrN1YQAtMOzyMUMvN9qoNRgyfEeI7pz+VwkPmnqe5IZbtvI6q0qFBgwGloRFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/P8ewgCl43XidADqkdBmkjFX6Sfef4igsqANzNI8R+M=;
 b=yrR67mFcZZUvmla5flc3pImNu/F491NCm4QDgdy2mbzuseRFemWhxYL7UGlLW4fUdFJmktvSGiTJkFXjocdKo+X62zNMd//K4uFpioAIrWaNUPfU5dWw0X7AhCglX/VqGrGk/CxzAlaObH3nqWDgph4f1TERTSrA8dQJT3C6MhM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 17:04:53 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:04:53 +0000
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
Subject: [RFC Part2 PATCH 03/30] x86: add helper functions for RMPUPDATE and PSMASH instruction
Date:   Wed, 24 Mar 2021 12:04:09 -0500
Message-Id: <20210324170436.31843-4-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:04:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2add3e07-d942-4f02-1849-08d8eee6f141
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4557F160BF6E1A0E16C985B9E5639@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 40RMwpVJISwjVp+jumvTaDBXe3dwkw3H7fZl1b9qMk09vm9L2fzRydhYPFAjdjFolReOke8MUj0eIvXAX639/Inl1SVJRhOZArWvLQ0dokutwIlxMRig8cau6yvRQmfonC8RRtJXfe51RmAOOJi0FrY9A9ADaSU5CsDMsPjigqhTupOuS0u79f8iEnvLwqAgltOzWVex9y8SooAiUQq+OYdOiEm8/uluzVpyVoPmsRGd29ck15aXF30/kcygT0L51zBTEyM+7iuuRh63Poa9fesaZPLKYUO0xdMRYWicqKW+VFmN9bg/VL7j41s6/DMYQfaBuy4LSLZUfe/qcKsC54JYPELkNk7g8gh8JXL/Eo6MODA7k7YXbXghqXNyKIAdVB7DwqqpyGrqY0R69l6oTN4zFsOwmlmavN2ZWWB2ThQ/uJS8OovdbfIxHXZBfOyd/NRiA501Ed0ElQdI8euZfsI1/NZiM124AkQsJcW62fZdEIdb4JNd3pqyCKJ/BSFPBl3t7MoCw6Sbbv8fgMf79l8o82SzyzG+gq+5Koc3qnugbcaP10atGdW6JT8QB8sd/vPh9pyoiEPr9A2LGOa5CZ6TxBOV8FmsEnB94hhjw/yg8Q2ZFT4D6dH0g1MoMTaazBo1HEknVDXnENPJmMIEcfPhk86TI4Io4AlQemxhccQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(86362001)(54906003)(186003)(44832011)(6666004)(4326008)(38100700001)(26005)(316002)(66476007)(8676002)(16526019)(1076003)(2616005)(83380400001)(5660300002)(6486002)(956004)(52116002)(8936002)(478600001)(7416002)(7696005)(66556008)(36756003)(66946007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4f6t/NMxyEUcGL8Areu0Fzy0j7UuJzWShBXjYhA2PYL1bGneKh7tGL56GbHb?=
 =?us-ascii?Q?wR0xciB6Rg1t3OdN89uRcKwcdljS+x+jMIevVGxlnu7RqSjoamyMBR6rvniZ?=
 =?us-ascii?Q?uAlpxER4A/3RRN+D6t/52ybI82BcSDjTyC/hOYemAH9mfQ/EVfD5yIACibf2?=
 =?us-ascii?Q?gE7kl55NorKBYwfGyPVDyiZBD7Phapm5dvOFJ3ejs1gFYW6BL3VRPNh2eM48?=
 =?us-ascii?Q?/R3EQ7y8d9eRpHeDkmHmoOpI2leytP1ioQosw9MwhkhYnIVTHusVnmSplaH+?=
 =?us-ascii?Q?eq8ftrRIiQxHHNCCobAqUB7FifZoAcbU4+8xj0h9MwPECVA6VXpnB8JneEno?=
 =?us-ascii?Q?f0PWSgivLu2xhTtHkv2igFc4MCra5kGBLpnfCHFtucR10HeGDpYanMu0OP8z?=
 =?us-ascii?Q?MTsBacO9AVXw7LocvG+AEhwcVOvNqMt+xpbjGYL1rmKWenYkQ6mCtxBmWgK6?=
 =?us-ascii?Q?vy17dP5QwPKHhNrdzdHZ16HJr8EEkHrkUJb1tvmoxnCbNzIbqqg2WzXRKAv6?=
 =?us-ascii?Q?0hgcukaHXQVzDaN519vCI/eYIwk5AXSUnuaKFRbVllzFNrriFyoZzzT1g1bc?=
 =?us-ascii?Q?+tVEEWsenBbrnZjGBMpz79YZcO82jsaP4bzCYBCQFuZaA4+wQ31pBDsETtU6?=
 =?us-ascii?Q?APnDxHUZScpWxFyyCZOpKcfsPSpJ4Cb4131219dvmxfx67cTvL+ZvI41FK5O?=
 =?us-ascii?Q?bfARSHWd5EULeenISPSCcUSNtB0NzlalMGaXVcwxzwPdJ1ctMipY2b7irjIX?=
 =?us-ascii?Q?eptY9Za3TgX6JjzgZEddiaji17fS9bYL3EQq8uNZHTn3zfq5rBQoh/6wNcWh?=
 =?us-ascii?Q?sYiZDtTSVZKONDDc53dOaP9k9w+Pi+7elXGmtbppp/w5xA4aaN1mV2GlXM21?=
 =?us-ascii?Q?ggYCAQITiUwmELUQ3r5C0SGt1RSIz5y92Z4ej0Vpx0n06EY957jGXXbnVxh1?=
 =?us-ascii?Q?2iP+LID/slAEyEn8BJt/iAIxgcFVpeg++M3W/Dwte/6ED7/L9U8BZ57R9wMT?=
 =?us-ascii?Q?87zEwen1FYOensovyBWz9GsP/RKBAuO/rZogZuRCK+bCsw82TopGC0iRtYKR?=
 =?us-ascii?Q?B7wtc7td2/M9/7gsQVFHd+XuqOm+qsJQJYgggNvXpBS5NKb4cAt/HMA9gV6I?=
 =?us-ascii?Q?aBiw7AeLSC5VWT3k+JF6wSEBELDMWGiW1Y85KDOIRtOsd1xCTJnDSPrXZRUE?=
 =?us-ascii?Q?xTk5g3p3timpzQ2md9sjp/z8I2cfSUFD/bo0A3Octx/a92VNkZ64TaYyrG6T?=
 =?us-ascii?Q?6BPvhrCYq6cN261BMH4bUp+LLz2QPBVYu7PWgYhPg3F3IJodWHXpxP+SYDcd?=
 =?us-ascii?Q?v2KgwiuylFJSUXZuQC7Lw10R?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2add3e07-d942-4f02-1849-08d8eee6f141
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:04:53.1788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: geYFke4iVmGLxZVzPKOeqB8z7VAxFjgUrni37C+7V5mm0ZzrlyWgdWI4fihUiM6ndeD2Wlb0s3N3A7ZDJ3F9FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The RMPUPDATE instruction writes a new RMP entry in the RMP Table. The
hypervisor will use the instruction to add pages to the RMP table. See
APM3 for details on the instruction operations.

The PSMASH instruction expands a 2MB RMP entry into a corresponding set of
contiguous 4KB-Page RMP entries. The hypervisor will use this instruction
to adjust the RMP entry without invalidating the previous RMP entry.

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
 arch/x86/include/asm/sev-snp.h | 27 ++++++++++++++++++++++
 arch/x86/mm/mem_encrypt.c      | 41 ++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/arch/x86/include/asm/sev-snp.h b/arch/x86/include/asm/sev-snp.h
index 2aa14b38c5ed..199d88a38c76 100644
--- a/arch/x86/include/asm/sev-snp.h
+++ b/arch/x86/include/asm/sev-snp.h
@@ -96,6 +96,29 @@ typedef struct rmpentry rmpentry_t;
 #define rmpentry_gpa(x)		((unsigned long)(x)->info.gpa)
 #define rmpentry_immutable(x)	((x)->info.immutable)
 
+
+/* Return code of RMPUPDATE */
+#define RMPUPDATE_SUCCESS		0
+#define RMPUPDATE_FAIL_INPUT		1
+#define RMPUPDATE_FAIL_PERMISSION	2
+#define RMPUPDATE_FAIL_INUSE		3
+#define RMPUPDATE_FAIL_OVERLAP		4
+
+struct rmpupdate {
+	u64 gpa;
+	u8 assigned;
+	u8 pagesize;
+	u8 immutable;
+	u8 rsvd;
+	u32 asid;
+} __packed;
+
+/* Return code of PSMASH */
+#define PSMASH_FAIL_INPUT		1
+#define PSMASH_FAIL_PERMISSION		2
+#define PSMASH_FAIL_INUSE		3
+#define PSMASH_FAIL_BADADDR		4
+
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 #include <linux/jump_label.h>
 
@@ -124,6 +147,8 @@ void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr
 int snp_set_memory_shared(unsigned long vaddr, unsigned int npages);
 int snp_set_memory_private(unsigned long vaddr, unsigned int npages);
 rmpentry_t *lookup_page_in_rmptable(struct page *page, int *level);
+int rmptable_psmash(struct page *page);
+int rmptable_rmpupdate(struct page *page, struct rmpupdate *e);
 
 extern struct static_key_false snp_enable_key;
 static inline bool snp_key_active(void)
@@ -155,6 +180,8 @@ static inline int snp_set_memory_shared(unsigned long vaddr, unsigned int npages
 static inline int snp_set_memory_private(unsigned long vaddr, unsigned int npages) { return 0; }
 static inline bool snp_key_active(void) { return false; }
 static inline rpmentry_t *lookup_page_in_rmptable(struct page *page, int *level) { return NULL; }
+static inline int rmptable_psmash(struct page *page) { return -ENXIO; }
+static inline int rmptable_rmpupdate(struct page *page, struct rmpupdate *e) { return -ENXIO; }
 
 #endif /* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 06394b6d56b2..7a0138cb3e17 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -644,3 +644,44 @@ rmpentry_t *lookup_page_in_rmptable(struct page *page, int *level)
 	return entry;
 }
 EXPORT_SYMBOL_GPL(lookup_page_in_rmptable);
+
+int rmptable_psmash(struct page *page)
+{
+	unsigned long spa = page_to_pfn(page) << PAGE_SHIFT;
+	int ret;
+
+	if (!static_branch_unlikely(&snp_enable_key))
+		return -ENXIO;
+
+	/* Retry if another processor is modifying the RMP entry. */
+	do {
+		asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"
+			      : "=a"(ret)
+			      : "a"(spa)
+			      : "memory", "cc");
+	} while (ret == PSMASH_FAIL_INUSE);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(rmptable_psmash);
+
+int rmptable_rmpupdate(struct page *page, struct rmpupdate *val)
+{
+	unsigned long spa = page_to_pfn(page) << PAGE_SHIFT;
+	bool flush = true;
+	int ret;
+
+	if (!static_branch_unlikely(&snp_enable_key))
+		return -ENXIO;
+
+	/* Retry if another processor is modifying the RMP entry. */
+	do {
+		asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
+			     : "=a"(ret)
+			     : "a"(spa), "c"((unsigned long)val), "d"(flush)
+			     : "memory", "cc");
+	} while (ret == PSMASH_FAIL_INUSE);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(rmptable_rmpupdate);
-- 
2.17.1

