Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8538B3F308F
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhHTQBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:01:42 -0400
Received: from mail-bn8nam08on2075.outbound.protection.outlook.com ([40.107.100.75]:31200
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238044AbhHTQBH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:01:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLqHzP087BDQrtf9rWlI7LBp9MDH0w+7UkI2OUyuLaH39XCkXxc5C4rM2HKgOfPpi5OEtHWdy/wSpfkQmbfnWfiAa6w8KUjrmNUCNTJ+CDYj6PD1NVdYHfPKiEkxzwPxn4/0S9D+3FNm8OlfiCUqnjHhidqyBW/9kNL+PKZmHW0f7Qem33P8X6XB704/hgKT0OPm5f3Ovn5G4vw1HcvFNrd/we5pZkSTY4GFwMXX2ZgvQfujA7tdxVKWczoWcS+ilovLVJ9b7XwsMzSxY2Ub7UWFCOQVghB06G7O/h3Ep0XzxJf4byQeuzbA4iiEm1xPCwXYnnD/zKnt33+ZVVSfkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJ91SxYunShGipyH8ojFfTywvFt1eW8pSHUNA9OcTyU=;
 b=g+kjTcJ8Cs3HPFWCVL/nyDMfrB4wfhXeKVlrrfQt4QDzScgNKCwPYGxiAUTfbkXl9Lhh8ds5EUrAr0AEu0fQr7b/oBVLPVUw3AhlXOMAVuw7BdoEXfnCDHE/dPu+vcOkJ9//meN6TlsDrEKrTGDn2ZUuq5tFBX6svWAdqJhWhxlbkLQoG5HoqDm0fT92LlfidF5W8A1XEcNgYdCXRf3rI1p4M47+X0nImtyVbLfDERKPrmHhbuRcwOh6XPoTvJjnkOBuHx3F/2SC98Cr85eTn10gsXRQYCfIAex2Q3jaw8lPulV/7lGybo4Jt6VrIW2MZTePiylMkKKZ35Yg2HWqBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJ91SxYunShGipyH8ojFfTywvFt1eW8pSHUNA9OcTyU=;
 b=Xa6DfJHdc76qizNi/43ag2qCWvUphvg+AiQzZ3pC/Vv5wsVbnwfgdVZjfgeucnvq13nsMLSQMHkBQVEFywE8APrhDoemvwFHxd6eML2sWgupeq1jfgaIXzqpQXO+VO0U07UenMV3PrporyGaupRVNHcysF1OMFXvVl+zdQOpEq0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:00:02 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:02 +0000
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
Subject: [PATCH Part2 v5 07/45] x86/traps: Define RMP violation #PF error code
Date:   Fri, 20 Aug 2021 10:58:40 -0500
Message-Id: <20210820155918.7518-8-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e272240-cc77-4113-46e1-08d963f391d9
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384818BEA75CC912C6A71C6E5C19@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ZO5oeXtsEpQofUD3aS2P+0doDZLxIPBufyh1IvPihnXHFCttNriHiFFM/4kE2sS9J3W/AzHOv87K6Fd06TbNWAi4BFIsaRY+6o5OeE3Q3fM01jc/p2HpR5w2QxefaMtphd599c2IZ9zUv47OkYjAFQZfKXIutUzJtx7D8Q+fplaVz+HYMBh+RCYIvaev8gcEv7WmEw7M+NCJXQRvpCR/SvWqTcgcaEvcCjLwez3Wqo7U4/WHfXdALta3+8uI7XF6CHfnlru2aV3KxwA93D9ycOaWXlfsWy3PHzeb3HAdSubOY7FOJmKg+QY0YY0y6F5ITuoYnEwEMox+nKNJVk4E1fDv7ULu3epZp59mQhEtu2fyrElvs8VlUxtlsZG/t5oghyXr4Q2Ntc9oDalfDMLR2dp1p64cwk97vLL4AfPTVAWHKFRw/1QBMmTPd6UQ+8XcNssOV3Kd01YJtfB6f7YjQvezi1qsvlb/V/pBaX7WAv9CTUWen76RIN7x3teBh6PvLbJLpIb6XVVdxS3+2vjXdQKu4ibpnVw4rZEfjyZqZ9gtjK/TilYQGQno+Q0lWR8PpApIUmpAzsKIhNj3FKUGvffHGbwAst/Ajsyq6Y2dYtDxw6CXsrzVd5Y+AEqCFsIxpiiCfnTzEcG8AcO7AGXPInhVlBO6c8EjLzJYt4a08TJUjDDdqeKg7KgFF7C5ccl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(5660300002)(6666004)(52116002)(66946007)(44832011)(36756003)(7416002)(66476007)(7406005)(6486002)(956004)(8936002)(316002)(2906002)(186003)(4326008)(478600001)(86362001)(26005)(54906003)(38100700002)(38350700002)(7696005)(1076003)(8676002)(83380400001)(2616005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4MhuWrLcLHwqpklrgBxNx9uSU+xdYVIX9JN3/xKBsQAQlNr3t3PsnwEyqa2h?=
 =?us-ascii?Q?ALQR8Lohn/VrSC3VNiLZkzf2vhYQuL8ddPvidtRWrJllqMcz0BNinHCIkQM/?=
 =?us-ascii?Q?boWHLOmDekCXDrWJOvmEnLy7Ro3JSAYWzC402SRWtUnyMapS5+Ifn7Y6dWfD?=
 =?us-ascii?Q?Ug/0m50twoB/BghhfvOQSwtmiNOjnhEI8fFCMXyMX1gx1eiXMJvDYe0NPA2E?=
 =?us-ascii?Q?YRtVXchhd6Z+mJkfGjs1hHqB7rX+Ucwz9ng10voJTtmVN8aQAABedKCH4sWF?=
 =?us-ascii?Q?kbz1ELEZv+e4YPoLjKd9rrgm3FsM8nohIyWLefBLbqBa+14ZZf9aGQVwkKfb?=
 =?us-ascii?Q?kMATRdSTJgF8w/gJJzwU1jRZubqY48WIwDeZYuwCMAZPeRdeDe1cqQkKeMLD?=
 =?us-ascii?Q?seM8f9dsd6iDAehxO1AQm1EaTmC22qSV71At6lt7IKU0sZpPlpw+ZyOyJXm5?=
 =?us-ascii?Q?Sk9LdU4cfH+zk7BysmUDOBoTtht+yo2VvLnbfG6JcW5s4hoywweUepyY8myk?=
 =?us-ascii?Q?pYZ6wpwXdkPyXPd1RsHmH5Z8mSAufu2VEipOCgjjpVWFt/cm7WZpnPj9cmta?=
 =?us-ascii?Q?Hk4DvBDylvK1Qk7+Ma0LhkLmUQ7xGxmwK4UXOuAWUgqsRaMD7MepTINgISs8?=
 =?us-ascii?Q?Omnew6n3lziAJyWxgt6lElu/rrMU5VAZxMHjDPYpLPqj87ZdLYCuq2EBZS7h?=
 =?us-ascii?Q?ehmhN/Hu/REU3Ds6Z5aByAk6ujckgLaU/IQcd7+iF5Zs6UHjN6NgICOMW+Ck?=
 =?us-ascii?Q?rU6dlI7U8YfVKnsAJG6xf1z7T8YDIdJdlYLriwfMbw6qMWTZoAmqz6miOlk1?=
 =?us-ascii?Q?CLvYPOIKgW7aiJYDIl3u8A11vxZ/88zbUliXrr0l++wIUxv/A5O04AcSexi2?=
 =?us-ascii?Q?B8vk9jxw3RXvofjd8cf/q1tVrUBr2GTinFCSuqi+tKwAlYAoXhAyF63pt5qf?=
 =?us-ascii?Q?QmC8FGUXDeZ5fNQ0FZ0V6Rw7SuN9XwBLeX3wRnEZgPbyikbI82ILFrLhnxFy?=
 =?us-ascii?Q?4PR95FkUpzEXkrW0l2dky9Xq5RE5/JRO0PfF8WIvcSu7AjH6zPfUwOOh0v/o?=
 =?us-ascii?Q?C0MMgQK91AAJykdctYIFHJRLKpy9eM6dh1UujCMQBgoB8ntQ24JJQTFSlnd0?=
 =?us-ascii?Q?7vf0kY+RFxqn38eSKgDIHBwiZNWTU0o4SslZ8bUF25BrYvAVXNlXmi07CPBQ?=
 =?us-ascii?Q?+E/Ae4FSUL3fkWpqjaqesOZRdQiXz0mt3UOXFjNCDY0GdS8RHS6zsyMbC/sL?=
 =?us-ascii?Q?j5UF5gT3fE6DjpWGAamb+aRjsJ3H7imD9hiR+coOfQyhLPtINl4lW8LQ+OWf?=
 =?us-ascii?Q?5ZnsEO6FC9Jbty+xHDFMSsZh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e272240-cc77-4113-46e1-08d963f391d9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:02.6573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XjqvCw5B5RvKKLBZQd1NRnFasipj21dMaujDTyb7v8PuwFD+rc6KyGsz1YygJffOfx3g5TCG9f2BUTo8h/pj8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bit 31 in the page fault-error bit will be set when processor encounters
an RMP violation.

While at it, use the BIT_ULL() macro.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/trap_pf.h | 18 +++++++++++-------
 arch/x86/mm/fault.c            |  1 +
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/trap_pf.h b/arch/x86/include/asm/trap_pf.h
index 10b1de500ab1..89b705114b3f 100644
--- a/arch/x86/include/asm/trap_pf.h
+++ b/arch/x86/include/asm/trap_pf.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_TRAP_PF_H
 #define _ASM_X86_TRAP_PF_H
 
+#include <linux/bits.h>  /* BIT() macro */
+
 /*
  * Page fault error code bits:
  *
@@ -12,15 +14,17 @@
  *   bit 4 ==				1: fault was an instruction fetch
  *   bit 5 ==				1: protection keys block access
  *   bit 15 ==				1: SGX MMU page-fault
+ *   bit 31 ==				1: fault was due to RMP violation
  */
 enum x86_pf_error_code {
-	X86_PF_PROT	=		1 << 0,
-	X86_PF_WRITE	=		1 << 1,
-	X86_PF_USER	=		1 << 2,
-	X86_PF_RSVD	=		1 << 3,
-	X86_PF_INSTR	=		1 << 4,
-	X86_PF_PK	=		1 << 5,
-	X86_PF_SGX	=		1 << 15,
+	X86_PF_PROT	=		BIT_ULL(0),
+	X86_PF_WRITE	=		BIT_ULL(1),
+	X86_PF_USER	=		BIT_ULL(2),
+	X86_PF_RSVD	=		BIT_ULL(3),
+	X86_PF_INSTR	=		BIT_ULL(4),
+	X86_PF_PK	=		BIT_ULL(5),
+	X86_PF_SGX	=		BIT_ULL(15),
+	X86_PF_RMP	=		BIT_ULL(31),
 };
 
 #endif /* _ASM_X86_TRAP_PF_H */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index b2eefdefc108..8b7a5757440e 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -545,6 +545,7 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
 		 !(error_code & X86_PF_PROT) ? "not-present page" :
 		 (error_code & X86_PF_RSVD)  ? "reserved bit violation" :
 		 (error_code & X86_PF_PK)    ? "protection keys violation" :
+		 (error_code & X86_PF_RMP)   ? "RMP violation" :
 					       "permissions violation");
 
 	if (!(error_code & X86_PF_USER) && user_mode(regs)) {
-- 
2.17.1

