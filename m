Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792A2398C1C
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhFBOO5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:14:57 -0400
Received: from mail-bn8nam11on2062.outbound.protection.outlook.com ([40.107.236.62]:57888
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230339AbhFBOOF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:14:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZgYXN/Lj0XALBG3S+65bj987vTg+T2kKTwysMB2Kvr3xabymAxe400zq415VAoXnnHfO+vh9BOH/9JYPOISWOUK/bEaEbCwsLG47fpxuemLIf//cMhhvtwAxY6rI6KoYIKdDgt5WUJAmWTOnX9j5vafqHYP33+RMpaHdIm+qRfkqodRMh/JqDaMwf2K2GMd+TykAhkj4LqUxrUiNihTRrhpMljXpVE0trpruDkIqlvVuOtjeaW57qp7wAzk0QzQAz20aUXBDexJxZp3L9Jl2c9+e5Zi3t9pbdJNY1/FZpwATkWRmBzOQWv1lRrWwPt3F5cdQ8kW/uqtEVIA2S7tKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9IpMdpyuUJv/iUkp9gcvE2Lk8D0OpiJS+R9aTNr+fEg=;
 b=jB7787Hz3nC1fXqM/37ZPu+Ro1snPMbA3ksFDKGZqfJL+wz8RS0UOT2T5argJM9NBlM7HPQRmllVaq2lUpjhdj35YCiLg0ElD+VPfQqyrZYgGjpJW3SUK9SrPqH4xybkJ+BWE6OX+mGLAGM27uAGpz0eRgmMZXmjEmSi6RbSPgfTV/3ZcKIb9dpj5J2aob5ImHiDftkwGTrei85gbNNpd+2JAeQQnaIbaFwpx1d50jJU85emSgIKoJeDo26Jon60WCwixqXCDtRsLA2z11w/nK+wsphcYdc0WnQtve+azrWNP//ZoIwe7JyOaHuC72dG7nZEBR9G/TsyZCEpzrX8Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9IpMdpyuUJv/iUkp9gcvE2Lk8D0OpiJS+R9aTNr+fEg=;
 b=RlX/SHk5OkmUhbExDlGOt01JC6/U8XU8awjQRRcFZfBh5Uz1fxJALPG/p+RcN/Ohlznxq8td7Pjf3ROS5n/ZTa71OnOfeB5YE2ZWHIz/6/dFsVJs0sCJc1wfYRkJQlieqFKETkiMxIQEdaF5PE87tzQuUmL9pTPp6gAmP2ZqeYQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 14:11:38 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:38 +0000
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
Subject: [PATCH Part2 RFC v3 08/37] x86/traps: Define RMP violation #PF error code
Date:   Wed,  2 Jun 2021 09:10:28 -0500
Message-Id: <20210602141057.27107-9-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8dffd91c-765d-484c-c5dd-08d925d05640
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2368FEABD29B455D2856D900E53D9@SN1PR12MB2368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sQKtCYhTiSge3QVvuuqTx1HlCjHuZsIjtZ/qyPtMbDZqjfv8KCjKfb0aad+4PkyHuNINvuurhm7hO7GgpxqjuyW+ctvnv78YELLMztCSl7GxtV7ZH1E+8FKV/g5WO7IuRvx4AVAB4sWTfMamWBBZ+iOImU1JKJDnhzPxOVTBxZ+E2R+AgcW1h+p7K3FWzYpG9nN4Blr9zT64OERFbr7AYYPtfq9FSpwD7TI4i3Ld2h3ZENEUgHJtncgOVGto507lSY7MuDJAaSJjujEkfhE/u5B+QbTjWlSHX0iXUKAl8sgCFlRES+JWVvc2v8e/i/c9m5M1H2Ty4IPQ9p8YVwLN5sTeqy5JueKVF2QszkCV8Tx8DLPoZQxwAU0YPEwEVkd0khwlkj4JJ6dHKCwSB7sw53R0HuIK5wJegHTDctAsEGP/vNjOiN0iDDCP7qZb6PJZ72OqVqHtCxLtfAZMXmxdIpfv87X3RmsTUtb3R7GuCE+ZurjZXX2wQMKO6vIJCvnWyWC/Shy9f/dyRVRj1+DuPKt2vBLLb1UMYm7LGf/NmOLolNnWwuJDFcOeEk82n6QJ8HRFRtfZonTQ6EtA5slct7l3ZElHa74gZFXC+OgkiQxyPq8fAkENiHt+cWynXiWGiQWF2OTBT/nhVRGF4A3vZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(5660300002)(86362001)(6486002)(52116002)(7696005)(44832011)(38350700002)(38100700002)(956004)(2616005)(1076003)(8676002)(7416002)(8936002)(478600001)(186003)(316002)(4326008)(16526019)(26005)(66556008)(66476007)(2906002)(36756003)(54906003)(83380400001)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?i2Or2EdAogM0p5gpcI8lSGF8lcivZdtk5vouUt4/fYBXVZg0EwP5PgTU3Xul?=
 =?us-ascii?Q?SQgvkDMFU4d95MTrVF8DqfZqJ+96Gf9vdt3FbM4ppCZx4FpZ60qY5twf61J/?=
 =?us-ascii?Q?p4WutOY8KzXgLsYoWGqLLcGSXPXplAaEJawsE6dGfIOUClYf38skhp4skEpT?=
 =?us-ascii?Q?IWM7kKooaJ1nV25QLBFrCeaKHZ3/lLXskRfKQ1NYbTPlpRwGjH9f7daoL684?=
 =?us-ascii?Q?F4og8aGQGVWPuoVQmMqMiJGWVJWBEgCSLYyWpGj0lyY4rVBztZAXT8Gaq+aR?=
 =?us-ascii?Q?5bAYxEO+W/a677cEeGr3+3C0U0EMgniEl07Ia2pOVmlXRSlkOT0IaCqnEcGP?=
 =?us-ascii?Q?zLsPUwGa7lWKZ8rt6pXIV4ObSyh7WjY53b5QFUBp+TvQcJmAv90neZG/KZBz?=
 =?us-ascii?Q?QjnIhDSeRxDMYFLsMUafqzPH9cYtCbBrGhMmHX1WicN8GpHTDnLYwYomVMxZ?=
 =?us-ascii?Q?Ngc6YLjQmdZAY0iAxZJz9clA5daKG4NlzrOdyw9+uwQjXmwJuaCmuqwjxaks?=
 =?us-ascii?Q?phYov3cuL4z4v/A28z9nKAKoAEzO6F1mTRMZHORN6v1caapaoXQRUcv/TSJG?=
 =?us-ascii?Q?XtAB3vaPy/dAe0oGGRqXbVsKQBl+afCAhUVjSybGQeMOXf/lrHcumWDITl4Z?=
 =?us-ascii?Q?qd+uSVV/ye2WiOQwPOTAgOyeyFEJgYu8TUkfK0ZhdcxibsQu4TjDymjzXEn4?=
 =?us-ascii?Q?B+HYhX3EoMPN3T7pZYxC+DtrmreP73PyN+uAtwhECBMXjWGE/7FYO1GhY3vc?=
 =?us-ascii?Q?icGyFG/aWAQ/5xCyfeSSdX+YwajF/UwBXxTgR1m5kpC5E3SVdNSb0WUA645q?=
 =?us-ascii?Q?dtkbLQj9ea1ru/uuvIeXzdLDCxxof6dL1c6+v2Wie0aGEBF2WdWvNU/0R6zP?=
 =?us-ascii?Q?qdq8WH+VHvB20T4/yQJTp2Oo4M2kcL9XOtdciRtKGum+CfXNKgHtyn8NVZ1P?=
 =?us-ascii?Q?eZKeXEZcTqAE5n7eRNkqpP+XZZ2NdL864cQdGnP4EK7/nH8WiJDDHPoRF5kJ?=
 =?us-ascii?Q?NXQrkTV33TX2VHo4N0jNG16js81f0NTdCZlQdUypWByLXH2v0nf/ifW4CTRu?=
 =?us-ascii?Q?K8FjQoHi6GNoNgUGnYBPOLqrUg1T8Tj9hqzYen0eZw5Frj7wHOJZsYYGvd/W?=
 =?us-ascii?Q?B4XUU+kmwzLjugRsrciOWo9u8wcla0r9Pe6rE/ZFsiiFHpBlTLxSX9wpY3Km?=
 =?us-ascii?Q?1W9R9drECWgEgYxp0io1ei07G3WpJWH85SsTblfYn4F49Von61Z13aY5sZsl?=
 =?us-ascii?Q?ynMyxTZlHsEZW1jVpdCuH3+v2TJNupIgiiKjxcnycFdT2LVO7QJQUJn1Jjcw?=
 =?us-ascii?Q?gTHSJVc4CcBFFashLwOLF/xX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dffd91c-765d-484c-c5dd-08d925d05640
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:38.2485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xhLtxmARJ9QMoF6boZyr5Bt/x4BlsmHXcLqQEB9M0udihBlLeXN1QEWJMRspvtzvKENnXzomwJbtIotFECgozA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bit 31 in the page fault-error bit will be set when processor encounters
an RMP violation.

While at it, use the BIT() macro.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/trap_pf.h | 18 +++++++++++-------
 arch/x86/mm/fault.c            |  1 +
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/trap_pf.h b/arch/x86/include/asm/trap_pf.h
index 10b1de500ab1..29f678701753 100644
--- a/arch/x86/include/asm/trap_pf.h
+++ b/arch/x86/include/asm/trap_pf.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_TRAP_PF_H
 #define _ASM_X86_TRAP_PF_H
 
+#include <vdso/bits.h>  /* BIT() macro */
+
 /*
  * Page fault error code bits:
  *
@@ -12,15 +14,17 @@
  *   bit 4 ==				1: fault was an instruction fetch
  *   bit 5 ==				1: protection keys block access
  *   bit 15 ==				1: SGX MMU page-fault
+ *   bit 31 ==				1: fault was an RMP violation
  */
 enum x86_pf_error_code {
-	X86_PF_PROT	=		1 << 0,
-	X86_PF_WRITE	=		1 << 1,
-	X86_PF_USER	=		1 << 2,
-	X86_PF_RSVD	=		1 << 3,
-	X86_PF_INSTR	=		1 << 4,
-	X86_PF_PK	=		1 << 5,
-	X86_PF_SGX	=		1 << 15,
+	X86_PF_PROT	=		BIT(0),
+	X86_PF_WRITE	=		BIT(1),
+	X86_PF_USER	=		BIT(2),
+	X86_PF_RSVD	=		BIT(3),
+	X86_PF_INSTR	=		BIT(4),
+	X86_PF_PK	=		BIT(5),
+	X86_PF_SGX	=		BIT(15),
+	X86_PF_RMP	=		BIT(31),
 };
 
 #endif /* _ASM_X86_TRAP_PF_H */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 1c548ad00752..2715240c757e 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -545,6 +545,7 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
 		 !(error_code & X86_PF_PROT) ? "not-present page" :
 		 (error_code & X86_PF_RSVD)  ? "reserved bit violation" :
 		 (error_code & X86_PF_PK)    ? "protection keys violation" :
+		 (error_code & X86_PF_RMP)   ? "rmp violation" :
 					       "permissions violation");
 
 	if (!(error_code & X86_PF_USER) && user_mode(regs)) {
-- 
2.17.1

