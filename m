Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FCF347E00
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 17:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236632AbhCXQo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 12:44:59 -0400
Received: from mail-bn8nam12on2055.outbound.protection.outlook.com ([40.107.237.55]:61165
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236534AbhCXQop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 12:44:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GPCAg6ReHFJ16//ZVWRYY6uIPZcFF076ZnYAtHbRj0Z4XwUfZPkMW8D6cbnG5l9LeMUfe9f88bYlyLoEkDtvS2Q/X+65Lnr0UE3/l6q4xMm5Ldxl4O0dZdMsKLLkuTVV73JxKTUrHHBXLZOHcvqBWbJE6oEhSLJroNiXxXbnxAhceshnEU42RMrTeZNat68tqeesKRdGGxKZ6LaHHkMi3H0nLk+fOOq4VV6+nbO9KQZ0ysruziXAOmmn/TDiUgucyTqJg44daGCYRO+IvVNXjCmU5E1guzNYregBRGr/zT2sn0lSJQyiWq1T74J/AmYPOf/Qcpn0MMUKd6SdTgmTzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tpeREZuGyZHkejv4iB1xhXBxxu95RMFStqFm9qXQHQQ=;
 b=TwYEca622f5+FfyuTxOE0Qv7QecL0yixfULnElXLBhHEi6pyDOlGkchFtO7xfKBauifLDmy2RK42Di1fIM/pw4W9xsoCHAQCbOUtlZrD9rz8jPXWMZMdb2/af+9mMbl3xMEs9X9u4u3y8n5NKmW4CaK4FM9cfTmscJ6y17MZw89pIx3yQJJPRmkghynfvSqTh2qdnXUn2aXgSAw/zPM0LESabRNZIxnvmUC1arvn45H1uqi9UTDDyPJJo6WFA5xyJpgLMpQ8TpFd8MFGt23LykPIjfbI3p8BUCuuk4zCKZc056Gcag/DfvQUgVgvGybQer2n8/aX0008OeYGACqYnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tpeREZuGyZHkejv4iB1xhXBxxu95RMFStqFm9qXQHQQ=;
 b=L7nlokroXUJVb5Q0kiSCLuvjYovhFoxGA+yveaHEiN0fcCRjU03CeZ7Tc59zk6yqorrLymg5XQ5vTU3Ihm/6EA5nCsGNcAml7ilVlIhQfBkHCPBCoATG3f9KMHI/0DjsIhARtWlHs4sI9q64pTtyRyctL3pfaxM8SNvZfEKSxtU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2447.namprd12.prod.outlook.com (2603:10b6:802:27::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 16:44:40 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 16:44:40 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     ak@linux.intel.com, Brijesh Singh <brijesh.singh@amd.com>,
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
Subject: [RFC Part1 PATCH 03/13] x86: add a helper routine for the PVALIDATE instruction
Date:   Wed, 24 Mar 2021 11:44:14 -0500
Message-Id: <20210324164424.28124-4-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324164424.28124-1-brijesh.singh@amd.com>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:806:d3::15) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0010.namprd11.prod.outlook.com (2603:10b6:806:d3::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Wed, 24 Mar 2021 16:44:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c876d590-53fe-4127-13e3-08d8eee41e39
X-MS-TrafficTypeDiagnostic: SN1PR12MB2447:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2447F0324E75FA3B7DB8F4A7E5639@SN1PR12MB2447.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tzj2pBO2/42vmolapRiur+BL/a2og3C+O/6H32c65czUcVSHlB2zpBSqLMv72CTHX8PYsHsKllWWBSQHgepz4PXgSu+uzzl0tEKs5I+ELrWGL4gDnnaU1Ah2qwtuwVywDb7eBTh3X1Sym0UbrHKjkalYwX6R6I96xze16xoKW3LcrAwouWRU4cm8/G1WKmzAprmNam0bFbdRNkZwGjM0SNaEUjERyhjJfqlvXv2vhWMFhUQqYgbnuVJsLGb/fmbjRQLjxbhEZhKCXKKHfWSOeXb1RRor91YTBPNe/xIqNy85BotBv5xt9Ecoo7cvQWAxiRIYFUBvQRRQOV/4RVfsjIvExmy1MIGsLDOi+KqovnaN6jtCf1y7Zn57Z/j5/siG6/+izPQPRNgTQdweKJzId5AAym8OgC5ld1w8Uar/LEhJ8FbHVQEG+6bVTMXY6TlGi27L2JxvgiGh2xcwuzjfS1lsHMdGNlUkzw4Xb1+8fUwFXh9Vmt8XG7aXNbO4rGeX1fDP5X16h3+PnkrAW12/1/Tacg3h030VjqvzkMn3AhIdzjGW7lwUnA1APzTGBIAFDb/LVHLj4T9Ub7//JTXJerD3m21TGGpIXxFfEMbma8eXUpnrO7Qkr5Fb8AMTQLWlL2R2W7vkD/DuzehBhpprgv1m9sYzKfseQwSPmM7jOlk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(16526019)(38100700001)(5660300002)(26005)(44832011)(36756003)(1076003)(54906003)(8676002)(316002)(83380400001)(8936002)(4326008)(956004)(2906002)(186003)(6486002)(86362001)(7416002)(2616005)(66946007)(7696005)(478600001)(66556008)(66476007)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?LzZMc2tBck1FM0daUlNGUysyeU9PWG1oZ1dYOE5JMHVRTVJqeUljQWlMcUx0?=
 =?utf-8?B?clp2SGNjVFpPZktqVjBpMzlZc2VpWmNnbnJ6cm9kS0srLzVXdnRnRzFnaUhm?=
 =?utf-8?B?NXd4UHJXN3ZzRDNUaTgvdEJGdHFKeUR4REhLVklCM2k2dW9tTUk1WDd6TGJQ?=
 =?utf-8?B?WUVtRldGbzJhcmV3NHpJYWFQaElacU5jbTRQRGcyQVZlVnV6U1E2L0t1WXRY?=
 =?utf-8?B?KzV3QkIwVWEzbnBkNWk5Q2wxSjEvYUdBN1ptRVl6blhuZjh0akhPSGExMVlX?=
 =?utf-8?B?enRkMzNaNVMvUlVXd09QcFdhVWdEY2ZFelJhbk11d0dFa2F5OHdyQWlGTWUr?=
 =?utf-8?B?OUxXdThFRktKVm5uaVNNUFNLbCsvU3piVXAvcEtSNW9MNUdMQzlvRmU0VXFk?=
 =?utf-8?B?bVoxdnloNXVydmJkdG9pWDNnYnY0Mm9mWWtmZWRKZlp3cCtqay81N0xlcHNF?=
 =?utf-8?B?eUlkcEpHNitXT0FnNjVhcVRSZXQzRUw4a25uVVJyRFFVYi9LUkhkbHhpMXVa?=
 =?utf-8?B?WVBCdkc0RzNHNkl5c3NQZHBndkcxMG80SVpoc3J5L2F4MDg4MFpiSjg3TGgv?=
 =?utf-8?B?SHdqVDNjR1JlSUJKM1ZYVGhiM1JkQTdyYjl4Ujlac2k0aWdKZFJXem1FVVc4?=
 =?utf-8?B?Q1dDaW40b2JTWENWUmdxTUdRV1VLc0F4S1RCUUxHZTJSUytFcUlKQ1IvK1Q0?=
 =?utf-8?B?RzRPbTBzRGhNS1hBOUJWUVozSUk2Q1ZWLzgrZkYrT0hzVXFPRUlTVXJRcUtS?=
 =?utf-8?B?cUNaaVJVNVVtMDdjTDh4ZmdLZ1RuOVZYRjJleGNtU2xqZ25VallHcDdzSlIw?=
 =?utf-8?B?L0tGM3RCdFJyUWEzYVZMaWViSnltemNwUkk5cXVWRmFlZ2hZMTdmOTE1djV1?=
 =?utf-8?B?aEtabkxmcmJLc0FGT3VMVDVKSFdYbzAxYjRNMUQ2alpIbWdmMWFkSmE0aUdm?=
 =?utf-8?B?WVhDallIWFludGZpMGhjRXcvSkVpS2ZTMjk5RGlOeE9UdkkxWTZzanU0a2tH?=
 =?utf-8?B?TUFiYSsrcUo3KzNWK1djMjhWclVMMFRYT1pZRTZhWGtSbWdtTjVpZFFhNDE4?=
 =?utf-8?B?bnFqYmZKQWJucDkwbGZUTFlEV2NHb3NlZi9UcXlaTktudmhjV3lFY2dZNEZv?=
 =?utf-8?B?c0hvZHU5WG0wZDRYalJuMG5jdWw5Z0FEK3ZkSCswQ0tmUjBQeDFGMUtnYWN0?=
 =?utf-8?B?dFdNZ0pNbG5YSkJ1VWlEWlcrUWRWYmMrbmxKQ1NoWU54N2IxdnVKU0ZUUWYw?=
 =?utf-8?B?S0lSNHpsK3BSN09QV0V2NUpUNVA0R0RPM3ZPWndsbWxzajRuZ0Q0TVh3aSt1?=
 =?utf-8?B?NUxqZ09BVkQrRU45MWFlQmdWNWZHODRjWGpXaFdwaTVSOHpZWjFwRDB2SjV1?=
 =?utf-8?B?c1FwMkFneTRXMWtmZVBXbnpPbVFWZ0oxeFliQmtQTXlNTkNpbTUxaSs1UmdQ?=
 =?utf-8?B?aHI0YkF6aVQ1Q3JTQU1LVm5hWFRJVEo5Qm5mYy9NN2t1TXY1MGl5NFhTeVhn?=
 =?utf-8?B?cXZyU0g2Z0hXYlJuM3JZRTJpQUMzUXl3QlRGUXBDOHRkTmNRNm82OXd4YkJP?=
 =?utf-8?B?M01zK29wR25kZEFvV1ArU01vdENRR2VpanZPeEZsMk9CNDVzVjNyeVZIM05x?=
 =?utf-8?B?WkFkcEs1eWg2RUZVNUR2WmNzWGs2aWllS1c1dVk5Y1JKdG5hY1J0TlBxUmk5?=
 =?utf-8?B?N0dndGJKRFBnUnVpZ3BZSnZBdEVlaVlIZ1MwV293Y1hIekVKNlBkSDExa1do?=
 =?utf-8?Q?rPxxOBuZzto+J+fTOxF+Otm6xB/LpEk/8rVlchd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c876d590-53fe-4127-13e3-08d8eee41e39
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 16:44:40.2774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nk9ms1w641ZWpzEr2SrztZgGQKNvaigXr81LEPncB9F04MCTtf8leMJBPcm5sP52utqz9PQZijSCXtQmhCK00g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2447
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An SNP-active guest uses the PVALIDATE instruction to validate or
rescind the validation of a guest page’s RMP entry. Upon completion,
a return code is stored in EAX and rFLAGS bits are set based on the
return code. If the instruction completed successfully, the CF
indicates if the content of the RMP were changed or not.

See AMD APM Volume 3 for additional details.

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
 arch/x86/include/asm/sev-snp.h | 52 ++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 arch/x86/include/asm/sev-snp.h

diff --git a/arch/x86/include/asm/sev-snp.h b/arch/x86/include/asm/sev-snp.h
new file mode 100644
index 000000000000..5a6d1367cab7
--- /dev/null
+++ b/arch/x86/include/asm/sev-snp.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * AMD SEV Secure Nested Paging Support
+ *
+ * Copyright (C) 2021 Advanced Micro Devices, Inc.
+ *
+ * Author: Brijesh Singh <brijesh.singh@amd.com>
+ */
+
+#ifndef __ASM_SECURE_NESTED_PAGING_H
+#define __ASM_SECURE_NESTED_PAGING_H
+
+#ifndef __ASSEMBLY__
+#include <asm/irqflags.h> /* native_save_fl() */
+
+/* Return code of __pvalidate */
+#define PVALIDATE_SUCCESS		0
+#define PVALIDATE_FAIL_INPUT		1
+#define PVALIDATE_FAIL_SIZEMISMATCH	6
+
+/* RMP page size */
+#define RMP_PG_SIZE_2M			1
+#define RMP_PG_SIZE_4K			0
+
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+static inline int __pvalidate(unsigned long vaddr, int rmp_psize, int validate,
+			      unsigned long *rflags)
+{
+	unsigned long flags;
+	int rc;
+
+	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFF\n\t"
+		     "pushf; pop %0\n\t"
+		     : "=rm"(flags), "=a"(rc)
+		     : "a"(vaddr), "c"(rmp_psize), "d"(validate)
+		     : "memory", "cc");
+
+	*rflags = flags;
+	return rc;
+}
+
+#else	/* !CONFIG_AMD_MEM_ENCRYPT */
+
+static inline int __pvalidate(unsigned long vaddr, int psize, int validate, unsigned long *eflags)
+{
+	return 0;
+}
+
+#endif /* CONFIG_AMD_MEM_ENCRYPT */
+
+#endif	/* __ASSEMBLY__ */
+#endif  /* __ASM_SECURE_NESTED_PAGING_H */
-- 
2.17.1

