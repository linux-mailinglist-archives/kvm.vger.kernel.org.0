Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1687736F9E8
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbhD3MSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:18:04 -0400
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:57920
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232262AbhD3MR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:17:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lm8PauTqVS2uvX+azkCN2Iq9dUm9NDhiSZBajUUyiXM5iW64BFIUGLPdF954BBkqjnJPk8yeWD2X8wBV4C/g9WfZjoWdamKtFg22sKu3kfU381iV2p1WxRFlTUGkRGNEVjeKDHntP3JYEwFpvKlfGD24wwFp+auZcENvIlxupWlL0hX/XRqpNd3sl+J3R7tFxSmxpKisAHsi+ZL7JK0o6yqCLat+f2+BVpagWlhlyOQxp2gVST799du1pTQpI6n9b3JsiGiMokCeRi8HoMrM7POt+ckBALdFYeF6wLm6lvdd00tb0f7oytnuIvM4w//m8YlkXVEVS258q+lEmMPNhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2kay/JRDY37noxVSdPHyzu5DZP76xKmddeLfmtODzDw=;
 b=G8zNFh0eXiM2A2vaUoTneWaLU03zYpDlF0uYjzuJlnVuCAq17lEdGrt/Ec/ZkEAAZACBp88enYb9jTt650Diq3oC8qe0PKeoollRwv62xeLjBoNDtk1foxuRPcO1uMOZ6Dnfd/y2Ac2ncDCp8+P26EdO0OW8NxiI2vJepq+zvtKNAK9AnrlQ+/lI4lnguLBBYiUSyxjfnMXLmB4llfj5a9qN/4rwDMOceDHag9WTN2wLmvcCge2brVzlFniT63RBGdXmex0uULtfDX42RzbbrRITV7KltcfyW/eYwxysffCqm0x9RlNMd2aR9q1v4XjaaTg7q5p8QWe0WJAH13ELug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2kay/JRDY37noxVSdPHyzu5DZP76xKmddeLfmtODzDw=;
 b=yY8+v5zrhBBOKVUguZQGwYjYNR/1X88meSlXXynP5FaAk0TeOTC8IT/MevfoPfzPvO0SeznmQJ0jOyUIMZA8HFH4f9bx/stgOGNhuPgaNAVhUGXQdCtU/W57VX+1AHFSn7rLoZ6yDv8KZYxnvrhy7Fz7go7M/1oGoPYGsqnysQg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Fri, 30 Apr
 2021 12:16:57 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:16:57 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part1 RFC v2 08/20] x86/mm: Add sev_snp_active() helper
Date:   Fri, 30 Apr 2021 07:16:04 -0500
Message-Id: <20210430121616.2295-9-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430121616.2295-1-brijesh.singh@amd.com>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0021.namprd04.prod.outlook.com
 (2603:10b6:803:21::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0021.namprd04.prod.outlook.com (2603:10b6:803:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 12:16:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c316e454-1da7-488a-ceb1-08d90bd1d6d9
X-MS-TrafficTypeDiagnostic: SA0PR12MB4431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44311A5BB40F44CCB74AB973E55E9@SA0PR12MB4431.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w7GrWvVa0G0SsPFJ9tvu1sRo9R+6VArJit/kg9gaIPXFEPMxTcXuRNHF3ZZh/gGlKXVtvCpeIGgMXZzoGHjS+TSnXyCh3/oBrRFVnu96Pouh7bG9CGaK8PDvVKc6lR3VAixSuzEh8/oDJxQreQCZyHFjJ6/bn65RYnRTzQNCcCfQxXmk6etjX4iAIQ0u7LEns9Yi3UzN0pLqNZT0kbWy2zud3bNTyJoUwkidCPqc4kvIelm0kMWMkW72si/La57YBO0Cs/iFIqHbU9bi0oAp+YcTIcgMOZASBTVepneKNWGL1Mq37TOCtJrpbJE3Sz3jleuyFnGWOWAmHkCulVFXRQPcOd8/caWePcKPgsnL8Rxa8oCq61K/dSVmSild5/lS733NHu9yShUb9qalKOEmQ6AlifvW4rKR/iAikyxzC+AkoX62GlifqXOm7AHQIomET6pZo/bcXx6wMeIrO/S98hHT28ifkv0Pxq8+Ix7ylnOrmuobW7t4SnU++wZEE5JkGLTsX/PL0HQrDlaIK/kOn3fAvwpzeolmgChhu9FOEY0YmdwtO1ToKiFrWT6YXbOPYlNkJYOeGpedRnVogdjMbay8vCxXS7rYJqJb+bnXVvug9jv8k0vzJvCUwt07tlMuevKjgyd0pQ/9faKcqtHGMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(6666004)(2906002)(38100700002)(8936002)(316002)(5660300002)(38350700002)(478600001)(1076003)(16526019)(26005)(7696005)(7416002)(186003)(8676002)(52116002)(4326008)(36756003)(956004)(6486002)(2616005)(66946007)(66476007)(66556008)(86362001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ZNBXjj031+WcKkh81Kb+3GfQUXqRKO+z/qhekWo6h9ZcFymFNIp64ZzkR3zd?=
 =?us-ascii?Q?QL8QWHj7VVC99EHWOU8f9DPTQLVf/yCyMhRVTTFfNTUmhcDaDbOfwuDptk8V?=
 =?us-ascii?Q?lvLHo6ucQBjyRcM9Yh6YMUTbwL8yT4O1vDlDpOBH3oNxRCQCj+/hfRfKEzG8?=
 =?us-ascii?Q?Ax/1ztUqmNuhw82vEa0lUjsoM3pJEBY87G9ihExg2Rr/r6YvLW1v2Bcs6CBg?=
 =?us-ascii?Q?g3QqMSftlMP+e2k+zgzgflnC/BqBaHJTXDMS28com8Q0+RzVYx4OCNuIEXdp?=
 =?us-ascii?Q?tpI59juGIg5ntB8cXZ4w0bf8/3dn795AUp6ey+KLEKu+aQ/H9zQXJ3QNc+f+?=
 =?us-ascii?Q?IfwS5/vNT2s8ZI9TFVEQRFqWVW9NW0JE4RDUZywr2OP0A7a90mn7dUkusNgq?=
 =?us-ascii?Q?ep0m1YJfxoqbwapVB5vldKNVheFI+OgmQlDGoglhLjxnQ5rN60RePUm19fws?=
 =?us-ascii?Q?JBQwccR0VYoHgKxhX68hSjbCe8MPTJCuot+GgaRxeeeG95Ya5SEvfl/9pj6j?=
 =?us-ascii?Q?lQESF9S0ntjbmrP2k0Wtt8n+dhHt73cLJ0ueFxYuNf9tqX3wNlBSO+FAwzoh?=
 =?us-ascii?Q?IUb5izHupjgeGu27j++sxNJWzfhjjk1kSiiqVqsfDIDTR1tAjXA4KmEcuZbG?=
 =?us-ascii?Q?R0DjddGC9MTu/NyvGSKE6lN4Q9qci4/SgAvH6ItKO9TQukTBjLGTR/u4S5gI?=
 =?us-ascii?Q?fARCpqTHM6f+oAwNtdmOhrFdKfxnX6IQP2toDelhTOa9NcJ0jqXQkmz5++it?=
 =?us-ascii?Q?DRt9Qdo+8ocVGYvqVQ9VuIqSUN9poNY4f50nkAHJ0ubAZ1m6VSKwhxDT1XqD?=
 =?us-ascii?Q?jJwoSDG9mf+qsb8/GZyeS9ZqhVwjFUKD7juaAj5+zNQUq3EjiQWDPjszPle2?=
 =?us-ascii?Q?Tffj3alCNY2hcoOYH7absPC3aGkzYFnk2cJISV2d1iHg2MkW2tvZ+pqQluoI?=
 =?us-ascii?Q?jV4rLHUEMj+bQUyi5v7lFZqQSNUd5BlVhTlTu5v7h5WXmkreqadj7sySWflk?=
 =?us-ascii?Q?f3CY6ewnUolbKFuZNQUm8RA4SoRgqWM4hEJLONlsucNSmgaKnIwR30ZKmeln?=
 =?us-ascii?Q?cFOBYSo34O4GhKDvP+Hx/Ekj2O3ljJxF/0xrk/scTVonCCb7U9Nlt0aYiweO?=
 =?us-ascii?Q?SjHq7XRtjWQeXe0FoC4l2xTh+aUeEZ5bKTakK3eLF+9UK2DYzgupuEunBHZI?=
 =?us-ascii?Q?iDr/e/1BFdZWMVGjB63yV/XurkQS+eeu9zb7fmgdBlWPla8WUHXUE5gEFbn8?=
 =?us-ascii?Q?LVr5CY0Wmz1pU3YDzHAwv64fzqRlNTs2Hz9YJr3ToAOXXV8/aVr1fx+5kZu9?=
 =?us-ascii?Q?W0YpqREBsbPOoDpXSqMZ+Ton?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c316e454-1da7-488a-ceb1-08d90bd1d6d9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:16:53.2383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wOC0zxz9neqAwFFRCAujuHs47yw+x5zMFhWBYyNIq2hgk2JZ1JUQ9sulxNZjCvLpFriVrBP360D7mmer4j4Qng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The sev_snp_active() helper can be used by the guest to query whether the
SNP - Secure Nested Paging feature is active.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/mem_encrypt.h | 2 ++
 arch/x86/include/asm/msr-index.h   | 2 ++
 arch/x86/mm/mem_encrypt.c          | 9 +++++++++
 3 files changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 31c4df123aa0..d99aa260d328 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -54,6 +54,7 @@ void __init sev_es_init_vc_handling(void);
 bool sme_active(void);
 bool sev_active(void);
 bool sev_es_active(void);
+bool sev_snp_active(void);
 
 #define __bss_decrypted __section(".bss..decrypted")
 
@@ -79,6 +80,7 @@ static inline void sev_es_init_vc_handling(void) { }
 static inline bool sme_active(void) { return false; }
 static inline bool sev_active(void) { return false; }
 static inline bool sev_es_active(void) { return false; }
+static inline bool sev_snp_active(void) { return false; }
 
 static inline int __init
 early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0; }
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 211ba3375ee9..69ce50fa3565 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -481,8 +481,10 @@
 #define MSR_AMD64_SEV			0xc0010131
 #define MSR_AMD64_SEV_ENABLED_BIT	0
 #define MSR_AMD64_SEV_ES_ENABLED_BIT	1
+#define MSR_AMD64_SEV_SNP_ENABLED_BIT	2
 #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
 #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
+#define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
 
 #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
 
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index f633f9e23b8f..076d993acba3 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -391,6 +391,11 @@ bool noinstr sev_es_active(void)
 	return sev_status & MSR_AMD64_SEV_ES_ENABLED;
 }
 
+bool sev_snp_active(void)
+{
+	return sev_status & MSR_AMD64_SEV_SNP_ENABLED;
+}
+
 /* Override for DMA direct allocation check - ARCH_HAS_FORCE_DMA_UNENCRYPTED */
 bool force_dma_unencrypted(struct device *dev)
 {
@@ -463,6 +468,10 @@ static void print_mem_encrypt_feature_info(void)
 	if (sev_es_active())
 		pr_cont(" SEV-ES");
 
+	/* Secure Nested Paging */
+	if (sev_snp_active())
+		pr_cont(" SEV-SNP");
+
 	pr_cont("\n");
 }
 
-- 
2.17.1

