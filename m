Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E3E3F3073
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241348AbhHTQAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:00:40 -0400
Received: from mail-co1nam11on2050.outbound.protection.outlook.com ([40.107.220.50]:44288
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238364AbhHTQAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:00:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W7diiwstASe75qgoTNSRcAwb9c6Ml2VgnmOnJbyiK8tMpifR5eTsDephieMtRc7FSPdbcPa6SzHT4Rc55WWYPMi01YuvIV7PymoY5ET/HPJzFBpB8/SlE5zKaAfPAogaE0zllRKseLFcBofXa1UiRWPO62f+yYEqfp0cQufVbFe7vVjBU+1Ggfg3WmMj+caZyZTYjY8uxF14ybbyAQDTxXNMcH48375VBjUQPxUXBtkYtHc8Lz8VIPJF96d9U4SvbLh/c04AoGyOBxBoV8a8obW/MvWkDTJwYwiEUuPnBFgZ2Na9M+opPPuDS3C0Zr5cINjDvqXfin6Y9sXZQRFnrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AD60n1Z9tX4RqoI9EAsyTRZUjD0EWMR8X/oIhpw0B2Q=;
 b=aiyLfgmdYD8cUrHCxOnMNKMo6ycNeRTuO98mqdXZQVPylu6/jmvzC3JTstRY8VgLC42pstGSAMZv46CZnyDLqlUHsyTYldYr/CwZKUdHLiXh2BXyYbVvBFVSZ7OdhIRHmwqfvbml8b7e/cuUGpZM1b9OJAvoqV8/Sa1bUATKGCzwRIJtlcq3RO9nsw0+LHNSumMvC7zejf4GSW48i6RSmXxE/w18K/OF0eHb+dpV2teJDWNY/+/4e4Qyla3OSyC6sONSHBKQsBR3e1f1ygeBRB2XA3yKp7x8UodMPufwiDIC+Zu/U4w/enSTRd1lb+xyA70bLc9l2wvQRsut0M1Dog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AD60n1Z9tX4RqoI9EAsyTRZUjD0EWMR8X/oIhpw0B2Q=;
 b=Z1J4KllzIen0O/9fp+Ku8RTaRYwCtvX5vaddJ183RgE3slgxe0UyX4E2eg7aZjAossDY7NCM2O9Ee74qRnO3P+k0Jam9RSKOQZyIbikcUXjNg/rOC9yUGGZXRf7Hkg/vBK3Q8o3V8pLE2pQxiG8Jdz+imGxTuo2Q3JARgs1250M=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2685.namprd12.prod.outlook.com (2603:10b6:805:67::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Fri, 20 Aug
 2021 15:59:55 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 15:59:55 +0000
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
Subject: [PATCH Part2 v5 01/45] x86/cpufeatures: Add SEV-SNP CPU feature
Date:   Fri, 20 Aug 2021 10:58:34 -0500
Message-Id: <20210820155918.7518-2-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 15:59:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4809fd9-6392-4bd1-9a96-08d963f38d35
X-MS-TrafficTypeDiagnostic: SN6PR12MB2685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2685ACCE02FC8AC5414E491EE5C19@SN6PR12MB2685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +VnpIn9OWiD6aOHXohaBi7hcODJxEqvQKKh9bkjv3aBw6KqRIrqFfEshK0iE03PmAF5s1ygcjDzqp3tYPQJGeZTOcLpweQk5GYUdN7/NuVIF1uOV8g9+8ZH59BSVhJhl/r5pIjk3ERR9t8O/b3ss5YLJgLYkkCH05JtwggduYaFg38tef0OjvAeIAgKvVigXnbPb050MwN86rcYPOjRLKm8st3edKRhrm6iJyd9NgB2fdH0LshM82vO6YELR1Vra9LITI0eUuYz58NWJIIyTp4ghALqKxr5W7Ml1Hw6K7BYnBM3px6iS7+40G3riUSWI/W1tWHObjqe84ivE3Vkw47Ql+qKJFMoZb80Kdj6tVgluSqM4izVTdGpsH26wTzmnxYlMkvQ/6C9f+8E29oBviwn1BlO0KJLx4q6u+Zj++0m3HutwW0GAfD7JU1Va+YArFuAELUWLoc5C6nEtdJ6q8f3JKqfxJHHphWPC2jAMO1M+6xGoq2hefAiMSYKmyI0D7s368X9zw9EyNSWhVR1IpAZWEiet0Xp9p0ckaJ/r5RkVEgce6xlpIt7UFug7p3RBK656Le0gWf22ixRKbmQ3jKthg10I1gEpjr25KXccowiLljG677H4ksSkW5Mfj/203gohq0jzN76gsaTikHnYBmHvLo+4Yqn9/lKq3TXXwZPBpSHY6nLLfZoheH3rPwnnpmnehO9WbjpEW7mzc4ol8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(8676002)(316002)(54906003)(5660300002)(8936002)(1076003)(2906002)(478600001)(36756003)(4326008)(38100700002)(38350700002)(86362001)(6486002)(26005)(83380400001)(186003)(956004)(2616005)(44832011)(7696005)(66946007)(52116002)(66556008)(66476007)(7406005)(7416002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5cDaGrkOPpvDqjK1+kJ9W4RKqCGBP/5qfh7jGBGaKofuXzCvk21Q7iU+Xd6B?=
 =?us-ascii?Q?ah2RQJnkj6pGRnBiJbx6m9XfVOwoXiPl9Sk3Y1K06Tey+QPJXZ3HX/uMPEJs?=
 =?us-ascii?Q?UDJXHW/+OeCufc1QvfqN0hYFoF6paxeX3Rbun9JLRpWkjXNak4Y9X9LxTISW?=
 =?us-ascii?Q?Gtsswut5UZGL06sk4eI5z0DaQ9Hpc/foV8cJh2TzlvI4JjRAtNansZfFcWL2?=
 =?us-ascii?Q?wxXSursExwHM0+Fn99elUYz1ONHfuI2fL59Via4YCt6yt8RFMRCCT4knqkyy?=
 =?us-ascii?Q?qW4hTJEwU3waWIuurIkC4mOpAFR2dahuF3MMJNT+OruhB2pg30waXtLDH0a7?=
 =?us-ascii?Q?fmYXBSi9wPZX2i5LuJPh97TwttuduejeY9ktvTJnQAgLfjRWr/Z382T9WRNX?=
 =?us-ascii?Q?GVQ/oqdgfy/8ZfcSCdCI39NPV4uNi4am6niwIuEAAAacTGHbgT92EknMQwZ+?=
 =?us-ascii?Q?xMOKoSWWkWd2JXhkNxXRtiFuvHy3RXKjKKaqtJ9x1F0KyNEuv1/SF/WydGIM?=
 =?us-ascii?Q?vG2epi0MD1v8hFjhV0Xdp9gwlSqiOSx5PKokHrp07/e4MlVSi0TioBU3wZ0R?=
 =?us-ascii?Q?G5LEUZlyXgY7fteGkBx0FgrypJKC5Y63oAwsOtVU2wRGDIzXKa65Qeq4z+Sc?=
 =?us-ascii?Q?UA4o1SqebpnL8NMMiEa7lBo5okLYxZPxUi0m+fV8SaELZTZhw6UIuWj9ku0W?=
 =?us-ascii?Q?oeDxonMtZb5Dey5+mtmw5aedmg3JUiH9tZSdWxVmzh/jAefT7CNdpa6QOHKk?=
 =?us-ascii?Q?mC9AIxyabW/REyKVCFzGom6NAu9r/SWWGY67hEQB+NhUZiws8KPkNfv+4Lqx?=
 =?us-ascii?Q?xNR0BNusxXWFw8wkTbk0LFpfWhvye//f9EwK1bIJNb99QDzA2YeNnitq+EC1?=
 =?us-ascii?Q?NNMscdxYSKJZ7NIjPmPbMLe2jCmoPkEJMDcpuOQ1B75okPZNBCPLDcpP6CuR?=
 =?us-ascii?Q?YU8NO2IS/TYASg+Z6FpKU8UtMiJ1dzF08l4gdlYc/HkHPdUXEFwYlMCzXUs0?=
 =?us-ascii?Q?P2dEsg1P1SIqhMJpEhhdde63biKLJMvaLJ+8PLkx3JRCZqbjorPyGwj1E2gL?=
 =?us-ascii?Q?//Nonyoy3L6cfSo3bh+3XkpBzv9QwvDM//2pcI0etGN+7Q+JjsQjovZ7PRcF?=
 =?us-ascii?Q?FC+v6e4enoDcWFqt2i9tTjjPNKpJnUQbqiZJdCx1W3Ag7r28lO01N8BSirXt?=
 =?us-ascii?Q?AIyUkHz4/BAK1UppkeU1l825Dgct5erZFEzITcBldNGKoim4EYy07n9G3cJu?=
 =?us-ascii?Q?5vNooD07QFgeomB9P4DfFc1I/rCYLTGh8jBzh3gVHg8I/1ptIccgVlcXd2XE?=
 =?us-ascii?Q?u15hJZh0E9oOAjPtL/edKlXj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4809fd9-6392-4bd1-9a96-08d963f38d35
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 15:59:54.8777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QejYfc3VNo6yArmcth1hxichd1vqrBAhGggedSVEDbfdFNDoMV3utlb4n44ONIWufPiX5JDEtG1ibIhLE12LaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2685
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
index d0ce5cfd3ac1..62f458680772 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -398,6 +398,7 @@
 #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_SEV_SNP		(19*32+4)  /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
 /*
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index b7c003013d41..3e6a586fb589 100644
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
index d0ce5cfd3ac1..62f458680772 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -398,6 +398,7 @@
 #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_SEV_SNP		(19*32+4)  /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
 /*
-- 
2.17.1

