Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD09E36FA7B
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhD3Mj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:39:58 -0400
Received: from mail-dm6nam10on2058.outbound.protection.outlook.com ([40.107.93.58]:15105
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232380AbhD3Mjr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:39:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JAZOlfrEqf5a4QbBT5xtiB+hKx7HiIOYCVkItsbCzbrSDCjS4DNbDKuxPab17+Kimt/ptouN6mRbJdV+9IZW5BaGHUX0tDIhkCqwIDmlGQQn4Bf4pSEZk0iBhx/ftNcMJD8heMgZ8UAtf9bCycgP+I3Xfu4IU+AwWLvlAx5verBwBLPv/rtle4JYRw73q75ovO6DUQmoZ34Li6aeXUsHDUR0skveMdVsBCYe2XLKu0qAcy+GcVd4yjuawKjAgzTSXxgeuKyk+Nbrs4bUM7ck3fYqZeYnf/tkm8KNDKMf3o+S7KE5hAYZuIwNkBFNAysSWenY6RAec4UWt2gC5aCRwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jEc3OkoB5XhRNIYGeiGIjX7xCaS7DDZ+9iL6/Hb6CXI=;
 b=Ve0NmJYiqOyAIFRmcPfZNrDvm/JCApkPX6FN+o9ZCwiF4XlUUTwsWGUTUEG+Me0NvLz/Hxdud9+fkeEDE2j5supPbvMDBvoMj5nM4aCJxjs3rxCdG7jL0RGUn7Pazgy+tNoUGc2GIHgyAVWiUCqzAdK3FV4p7+rtt6KLHi7XSiaNyntSsiaJT34mCb9qo1GuE2GT6nLDycvbOs0xwaaLGvnq9r2+8ru04D0g6aFDHilzE8s6ER4OYVUAIRTkzzJSvG2R1TMBFot7moYKgkRB7kNfLsbhJJP11Md1+2iIjA2AOdz5L4MLoh/YvQ5L22e+4boppcWvvaUxFd722vk9bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jEc3OkoB5XhRNIYGeiGIjX7xCaS7DDZ+9iL6/Hb6CXI=;
 b=WTZlT/9o4OIdjGzNIo6rST+3rv2px0D8SYazGO6gBlv2n6q65YvhiRrZW8jBJUtuq/lLpKHpYCIVMgpvTly8k9LcILN9AjkAXB7ghbnlkC2XKO5whRnEiqm/dEoDF3TPT5dyKsWYMoNTDf9v30p0rW+6VDyJUtbIC+Kjunhn1Ck=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4511.namprd12.prod.outlook.com (2603:10b6:806:95::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Fri, 30 Apr
 2021 12:38:56 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:38:56 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 04/37] x86/cpufeatures: Add SEV-SNP CPU feature
Date:   Fri, 30 Apr 2021 07:37:49 -0500
Message-Id: <20210430123822.13825-5-brijesh.singh@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: ce252337-fa67-44bd-22dc-08d90bd4ebb3
X-MS-TrafficTypeDiagnostic: SA0PR12MB4511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4511B56E3EC27297B8A4EE4EE55E9@SA0PR12MB4511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TX2ZgHI/hfcxoanPlBs/j97YKpn25VST0FrO8E2IIl8CMnAEA74cURxqzGWtiL0oQdA4P/nXvspb0axaT3U1LvUeYGZvGEWa+k+pkc3MFzdCr5Zus5RsxKWAN/HN2ZBz8htNm/nFJzL5oWpPR4eYu4oqtlAp3LPpg+dFFEOMgUhoNNXsL0k0SwmsnKOmwOjwvkXYcdiIKIYWCPJpP3qRc2lIAc6IlASgxFoOJIQ3/JN+B0E05sURSAr0edCZZz4TwxRKTkbSpJNHLV52kpRIb3a4SwnZxEO4heF7L00WEy4UIM0LSOqxuK5x8HNBLM08nao4IWDnmmCcES+xInFDZJaSG60erc/hwlvTyjU6SCJS1bO342scL11pSii2GufYv1qteO6BDcgDTZWq4nNlYcHe5GldHX+IhyfiH24/WQY5QF/Lqd/2bPsR2iSrPdHqi9x49SC8w7cjq3MIwEnP7JFwWjDANUurJ9Z3mmOXNHRU+ikIZIDN11ro0vMccHBzAZCzdqhBnFaSvwpLvfUyX9kGNnzGJ1lZJ4od4HMqn/O0RJqrgcifh0NdD0ZDMI7xPB2rWGjYsQSR4KDWhbZ33LNdUfWaPYQfDRFxDR+5GLUJkBh9I6Z+hS+ygbhOuJNjZ59hyp92n0Q9gxzyyv4XmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(83380400001)(36756003)(8936002)(86362001)(66476007)(956004)(186003)(38350700002)(16526019)(6666004)(6486002)(44832011)(52116002)(5660300002)(38100700002)(7416002)(66556008)(2616005)(26005)(478600001)(4326008)(66946007)(316002)(2906002)(8676002)(7696005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PKxAmJ6gz0Whznqn3TdTkA5UMq2Skjn6pwphOjiG/TDQjrLb0gQdE3ffNAm5?=
 =?us-ascii?Q?lOVz7lr9SBIsFe38R+6WNlz2CmBTSwIDnT2BHb+FtbvOxn9uYqDhpuAqqZ9Z?=
 =?us-ascii?Q?03lawq+9Mjhm3dJbYR3f6BF4m1Ws8hzrvBGxnyd2QyZwUrcTbMbHZvQbCfN9?=
 =?us-ascii?Q?VcHd2zhG6T55QD4MhbT2l8W35sSVxQ3r96tCX3cjmFk3a8K4Pz1wqeKL7tAE?=
 =?us-ascii?Q?tNmECnGSnBCPJZCwYBCFmU/BDRa+Pm2OkReF5p8GvwwpWC4BPByXdLaq9/OU?=
 =?us-ascii?Q?BP77vp6MaOpn4NtthSRaFWF1xge6Db6VvhQ61YYJ2msPVhdFudSmFycDy7XO?=
 =?us-ascii?Q?3cc74ukyh3AWFX7gl4+QQ1aaF2LSyrwc1lfQLYViaHhUQ6u4cW8szX4ga+Q9?=
 =?us-ascii?Q?KTwyZ44/UHqqz4mJebsqmXCVilSh6Wp4MVbuF4Jwg2eGY4vMGwPDnR0bFPBK?=
 =?us-ascii?Q?DwdzqU0dD8uZuum81v8fy6PwNEr8F5qobCD4s4azhgJo4XbT4TlOI5cNVlMK?=
 =?us-ascii?Q?SD+foqz6JsAw8890P0PRGNk0o/6amWzwGjLb1LY+ZxaI+3grK8tOy5CLeFgy?=
 =?us-ascii?Q?9ppxNf+cFO4UAaqGARg0tmyKoWXQiKlIySkWODCo/l9SKzOn3smAFrbr/Bd6?=
 =?us-ascii?Q?X1J9lIu8xMUUlOLRFPSFOTA8qeZ2EJXrhKj4jsbAR2pPg5SGvcpBE8qqLyQ5?=
 =?us-ascii?Q?4sk8NLpdX8Jc2AlotUSrGT1gNJOdWMCYnJo9sMBVXHTY33x78OvAyxYr+lxD?=
 =?us-ascii?Q?FUextUBgTTF7Op7/uuE8Ierrv6l/J10SfPCpnr3dpUJP8jkkhoy8ASG25m43?=
 =?us-ascii?Q?LEsPpIG7rymtp1gSiY3qj6VeiW66KMiG7u2B1tdpyg66T76f8ON9/e7xFnvC?=
 =?us-ascii?Q?e6GFiG2rBHFizue6CoFd06HdSPgnsEetx2mati2uD34RzVFr78cj5WPzaXlE?=
 =?us-ascii?Q?uHvzlvaOnNBLVwRkL3uLK8XS5NYf4WC1VbY1x63/eB0V1/mJaJW9FGHtMkmP?=
 =?us-ascii?Q?2KnR61NiCPP3ls3M78imzs+51z8VSTlliaQ3qt/SXRP6Ns4lzA6UpXNah75m?=
 =?us-ascii?Q?flrayps71mVg44SYMTZQXHmqTJA8qd0n1mpncevNqCRSNXV5fi0kX3+WU1X6?=
 =?us-ascii?Q?q/ZDlcq6dXEMdzICunE8iWpNw/HC6UA+wkdIRmSBQNb1UT/Bda9STOjIJrsC?=
 =?us-ascii?Q?bc6s4+ALembUYRAEVatS8vBNC+X5+r6Or6466wgNnv5u9WDXX2mPhmMQu38u?=
 =?us-ascii?Q?fjFWofIF3cobRbpbeJk1wem8birLZEeJ94wsQH6SyjxD5EixI5IvlxV7Co/l?=
 =?us-ascii?Q?gHsa9PXuMM7X8xAZkYLHH1p1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce252337-fa67-44bd-22dc-08d90bd4ebb3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:38:56.6382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ewd4c4rTXPpDPxXMzzwcQPe7S6Cfsoa06IH7MwSLineMS146223xZWXipPDdiXNhd3IdrbLvoQM1POKqu1f3LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add CPU feature detection for Secure Encrypted Virtualization with
Secure Nested Paging. This feature adds a strong memory integrity
protection to help prevent malicious hypervisor-based attacks like
data replay, memory re-mapping, and more.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/cpufeatures.h       | 1 +
 arch/x86/kernel/cpu/amd.c                | 3 ++-
 tools/arch/x86/include/asm/cpufeatures.h | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index dddc746b5455..88b21de977d8 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -393,6 +393,7 @@
 #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_SEV_SNP		(19*32+ 4) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
 /*
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index daf6c6e74ff9..15b389ebb019 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -586,7 +586,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 	 *	      If BIOS has not enabled SME then don't advertise the
 	 *	      SME feature (set in scattered.c).
 	 *   For SEV: If BIOS has not enabled SEV then don't advertise the
-	 *            SEV and SEV_ES feature (set in scattered.c).
+	 *            SEV, SEV_ES and SEV_SNP feature.
 	 *
 	 *   In all cases, since support for SME and SEV requires long mode,
 	 *   don't advertise the feature under CONFIG_X86_32.
@@ -618,6 +618,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 clear_sev:
 		setup_clear_cpu_cap(X86_FEATURE_SEV);
 		setup_clear_cpu_cap(X86_FEATURE_SEV_ES);
+		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
 	}
 }
 
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index cc96e26d69f7..2e78ab5b92ab 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -390,6 +390,7 @@
 #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_SEV_SNP		(19*32+ 4) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
 /*
-- 
2.17.1

