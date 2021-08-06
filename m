Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB8D3E2E26
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 18:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhHFQJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 12:09:06 -0400
Received: from mail-bn8nam11on2054.outbound.protection.outlook.com ([40.107.236.54]:54369
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229765AbhHFQJF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 12:09:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctYNhI1J3PCfX+rrqiTwasccCogFUkdZlN7YZNxU/QJe0sw8WqYzEuzNsbQ769vYHClpXM0hvaK3bnUjJNtyohdI23H2ImBj6VQqig0sTKEOVJxr5kZ/muNrfjD3lVPY4SpE1k3JAETjH05MhDmQziAJQ3vN62zZb+J+PDnlFwpWuQnwHbiraDPDjEKNlpoyP8mieh+DgmGcjhK0T9oVsxr1PxQXm3GNjKCJtQpSUU3xIXDjH4YHRG28aUUaKzJ/xURm8fc5+d8yefBew51incvlOW4mJ3P+FgeCEtx4NLELBDCjHUOQjFyMtcp3gL00wtEh4LVD29OuQ3bpG5zMUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5a9gWC+4lovfo0mPrrRWdj3E7Ss0SXiqs96Ol5Q265k=;
 b=f+FjjKv661KN82d5FRSA6T0GWbCtttqfLsWlj/MmNAovxNDZbEP1oTKW+pShefC/CHFjjp1VnRjMitKEO2TfzNNa1eR0PvONf9X9EUxA49IaSRSyE54ond4LEa6ODhvqpEnjCc5OVA92Cx2bUPqaNhagL3LMwwWrwCx9pMg9/eWQluVeQK6dygfCRg9ZsqaSqAh5FjK1cIFOR2DGblnL981khAvUbpY7fslCWsexD7M9zy5Zaw61bgUsg6ax4HWaDzQ2hb6hOgdFm/g3ZGGHidkmL6WuDe6fXUViF2Ca8TmgAWtV9FC4mscmrFjwhSu5vJDnCUZCcPCtcDjigMpPIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5a9gWC+4lovfo0mPrrRWdj3E7Ss0SXiqs96Ol5Q265k=;
 b=TsBK83TtMhFFFW1OdH2VwKOgcXh4m815OH0rsYVNr6RLnuZaQoo9DKm9X1lswPlTaezxR6j0dwEhMO6eGUx2vCZuN/n3f0jQmMPPJzqngiKJpYbZBd73wdk/gHnbUXqQ8ghz83DTGvE4nw032CgFg4QdTI94NSGcy6Ws6ovsSl0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MWHPR1201MB0206.namprd12.prod.outlook.com (2603:10b6:301:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Fri, 6 Aug
 2021 16:08:47 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::add0:6be1:b4de:8bf7]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::add0:6be1:b4de:8bf7%7]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 16:08:47 +0000
Subject: [kvm-unit-tests PATCH 2/2] nSVM: Fix NPT reserved bits test hang
From:   Babu Moger <babu.moger@amd.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
        kvm@vger.kernel.org, babu.moger@amd.com
Date:   Fri, 06 Aug 2021 11:08:44 -0500
Message-ID: <162826612490.32391.15921978067790218645.stgit@bmoger-ubuntu>
In-Reply-To: <162826604263.32391.7580736822527851972.stgit@bmoger-ubuntu>
References: <162826604263.32391.7580736822527851972.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0401CA0005.namprd04.prod.outlook.com
 (2603:10b6:803:21::15) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0401CA0005.namprd04.prod.outlook.com (2603:10b6:803:21::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 16:08:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4b90727-2a21-4565-c069-08d958f478e3
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0206:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1201MB02063089FAC47F1ED30690D095F39@MWHPR1201MB0206.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ow17HQ5/qftCEiUE0SiigURLlZsLyQ2Q409etWfNRuUjiZzgLiyb5x2Cvv7ureKb842ePK2jjs7WXL/PjfY3ZCbRs9RW6nSkvKZ+4Tap1fmDFaIxp5bFNgpMNKKr8pFZeU/iPYw3SuE+hhJB8YyET4x+aJEhKfZRPBZt5zmWCoRS9odsynwZD5l9Q+gMU7ANBmKSz3J6zncGMId32GkCkwuNC+z5Nb6xpl3/QoQCOzEb7gGnc4/rRF1Pw3Zj702ri7ZZZJdLZ1dIhSuV4KBmY/ulUzN4veASId3wYvMCcEdCgL0iq5D5qXRgPJZtDGQSIfF+OH5aOwAmGtIK30N6bQGICgqSZv9pGZnlQnYLDP7MNU6My6oPELLzdAy+5V4JtFaJSgcCDrwtphJN+vSqtmBOhyIr4LiFOd02f3+lppJquvzqpoanq3kjq9XEq2fLw2JUMoXM+975QpGSo/2RINUDhHhw/XFyNFmQwZ+7IMHZYJWBagInpYdDbluwGdE06QOe2L81WZzBt/NFr2lX7MP33vfdDT2BnMrxFkLG1foP6F7UrjS87GXdrjRjTaugs5YbygMRlHRHWWJrTOQA0qrBinUF5NToR7uXSHUUd8DZKjQYxnBU9g6NNe//YlG6979ND5sA/A6wPwiZA7ygZGhZadMiEYgkBn1tpCWo/g86S44s2mGFF1avmvBUgHIosCiPa3LMJ0pKp+pgXSilgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(376002)(396003)(39860400002)(346002)(136003)(26005)(8676002)(316002)(103116003)(16576012)(8936002)(2906002)(186003)(4326008)(44832011)(109986005)(38100700002)(38350700002)(52116002)(478600001)(5660300002)(86362001)(33716001)(83380400001)(66476007)(66556008)(956004)(6486002)(9686003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Uk81NXIzbXF3a1FkaEs4djZULzU0czEwUE9BZGxNVmUxWmVkNEd3WW1Na1VT?=
 =?utf-8?B?dEVNQlIzUzFQcm1tQVFzYWl1em9QWC9FZ2dFRUlDeUdBOXRRZkpaWmVpMkN5?=
 =?utf-8?B?dFl6aFIvQ0g5ZDVidVFmbzZOY3d4b2h4SnU3dVdRZ0ZyVkRsc0JuckhSTnVV?=
 =?utf-8?B?aVdXL1FDZEVlZW1RakpqMHVBMkt6RDZqYW9CeHQwOWNnWm5OR1IrRzIzNmZV?=
 =?utf-8?B?UDZrWjJLcTZQSFZBbTkyVnQvVkQyTlplM2tVdGxwaW0wRW9sVHBPV0dhaGtK?=
 =?utf-8?B?TFkrQk05M2FISk9STGlXb1oxeDBaVEk1dE1hUTdMaXBxMXhRR2hUd2k4UVQ2?=
 =?utf-8?B?MG5rbU1oUys0cDlPcHhWKzJTOXBRVUVDbjVqQjZJWDMvdXB2QXp6RStqZzJP?=
 =?utf-8?B?MHhpSkN6emFBcExFd1FFV0o5cXJGbFBJWWFqYXl1bmdQcFBIMGxVbk55OWt0?=
 =?utf-8?B?WitMUmU1ZHpwVWVySml4dEZaaEJ2WFR0NmNoUmV3L2V0a1pQVVEzQ3V0djdS?=
 =?utf-8?B?OE5GNS9OT2xQN2Y4SUVyd2xtTHUwcnlmY1QvS0w2WXNjWWJGMGdOYkZHSmF3?=
 =?utf-8?B?cnNCU1FXTTdvdXlRRFlkVENtMlIvQmI0bFNkZytvYWFSQXdBbVNvMHNmZVRq?=
 =?utf-8?B?N3FlU1BuMWg3WTNVQVBhNWpkNzBZSGlJVDJDcGkxbHc3T0VQQ1NNVVQvSXhI?=
 =?utf-8?B?dFMyRUYwS3BJOCtQNnZ2WDZ4dWtJUUt6M2ozUk8yWG40Nkw2aC9ySHdRK1I5?=
 =?utf-8?B?RFNFazh0K3JaWi9zVjhoQ0w2SzdQazlZbGZPc3pWRGhXblNPNVFZOHRMZE5l?=
 =?utf-8?B?c3REN2xDREFSYW5wc0xuUVoyTkZsMWJPeDlWd0gyY0dmbDlTcWlwRi9mY252?=
 =?utf-8?B?K21SSGV3bExNTXlhNisxdE1uOXlFdWsyWlVlQ1BvcEtxdGRUckFFYWdxank5?=
 =?utf-8?B?dmtOamdmRGJFTzVqWkxac2ZmTWVFVUkrc3dvWXI0NUVCMUVna0hQZmRGTUdS?=
 =?utf-8?B?RjlsUXQ4Q0thOHAwK3RyNm0rZjhDTkZxMmE3RzRHZm5xM1Vsdkc1L0FNSVB2?=
 =?utf-8?B?U3pMS3FvdmFkRzJkcmVDSUcwVUlJNktUOGZzNTRZajBwNUlQZ1k4V2hKV1dP?=
 =?utf-8?B?YXFwYlp0ZExoU3hOUTA2RkdGQ2kzUVhYcW9aWGRDR3IvRy8zeEFnQmFoSzNJ?=
 =?utf-8?B?YUFua3UzSjF5cXhlYWpKZGFuWWFBR1lTRm9lbHZjL0lnVTlzZmVJS29lSSsv?=
 =?utf-8?B?V0M4bElLZTRVWnVOUTI1elN3TlZUKzhJS2czcWh0S1FWMkFlRzNzRjhaNFJt?=
 =?utf-8?B?RUloeFpEMEFFaFQ1djFNdE1jZUFLREZJUXFxUDluUGhXN29sN3BtUFNEU3Fu?=
 =?utf-8?B?WnJzRGswUmNWcTg2T0UvK3pCMm1yVkJyMFlNaVhDVEJ0OHR3SWUzaUxIclRU?=
 =?utf-8?B?U2ZHZEFVMkwwQXFvNSt6QjRVZW5OejEvSVl3YTJOSlk4NGhDTTBGNEkzbW5I?=
 =?utf-8?B?NEUwVmFBQVpDSTVHaFQvZlRHaWVmWFpWbUdJd3FQbEdQcWZFZEp0MFpzUlBS?=
 =?utf-8?B?ci8rMVdaTkljc0trMWd5NUY0YWdEQUQxRjYwbVNWcmNmbityNXlkNWpNWGNq?=
 =?utf-8?B?NUhEdnVXWkZremdOWmtLbTEwVlY0cFlLQ2NQdnpuaHg4YjFaeURNekxXSG9N?=
 =?utf-8?B?M25qVXVzeU03dUQ4N1hyTVNOUFlveTRFNnRzbXNybTlIMVV5RkxFQndmblFB?=
 =?utf-8?Q?buJ5I/KIeLXYOHSP8RLWpbqrChfJm+n/pGjJaEf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4b90727-2a21-4565-c069-08d958f478e3
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 16:08:47.4286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: frxLZqugZJdM2rlhH5Xnv+cjfRbiOXZ4dqYr1ys6HaqdsMBEszxwTUeAGzJ5imGP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0206
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Babu Moger <Babu.Moger@amd.com>

SVM reserved bits tests hangs in a infinite loop. The test uses the
instruction 'rdtsc' to generate the random reserved bits. It hangs
while generating the valid reserved bits.

The AMD64 Architecture Programmers Manual Volume 2: System
Programming manual says, When using the TSC to measure elapsed time,
programmers must be aware that for some implementations, the rate at
which the TSC is incremented varies based on the processor power
management state (Pstate). For other implementations, the TSC
increment rate is fixed and is not subject to power-management
related changes in processor frequency.

In AMD gen3 machine, the rdtsc value is a P state multiplier.
Here are the rdtsc value in 10 sucessive reads.
0 rdtsc = 0x1ec92919b9710
1 rdtsc = 0x1ec92919c01f0
2 rdtsc = 0x1ec92919c0f70
3 rdtsc = 0x1ec92919c18d0
4 rdtsc = 0x1ec92919c2060
5 rdtsc = 0x1ec92919c28d0
6 rdtsc = 0x1ec92919c30b0
7 rdtsc = 0x1ec92919c5660
8 rdtsc = 0x1ec92919c6150
9 rdtsc = 0x1ec92919c7c80

This test uses the lower nibble and right shifts to generate the
valid reserved bit. It loops forever because the lower nibble is always
zero.

Fixing the issue with replacing rdrand instruction if available or
skipping the test if we cannot generate the valid reserved bits.

Signed-off-by: Babu Moger <Babu.Moger@amd.com>
---
 lib/x86/processor.h |   10 ++++++++++
 x86/svm_tests.c     |   25 +++++++++++++++++++------
 2 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index a08ea1f..974077a 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -531,6 +531,16 @@ static inline void sti(void)
     asm volatile ("sti");
 }
 
+static inline unsigned long long rdrand(void)
+{
+	long long r;
+
+	asm volatile("1:;\n\
+	              rdrand %0;\n\
+		      jnc 1b;\n":"=r"(r));
+	return r;
+}
+
 static inline unsigned long long rdtsc(void)
 {
 	long long r;
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 79ed48e..a2963c0 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2704,11 +2704,23 @@ static void _svm_npt_rsvd_bits_test(u64 *pxe, u64 pxe_rsvd_bits,  u64 efer,
 
 static u64 get_random_bits(u64 hi, u64 low)
 {
-	u64 rsvd_bits;
+	unsigned retry = 5;
+	u64 rsvd_bits = 0;
+
+	if (this_cpu_has(X86_FEATURE_RDRAND)) {
+		do {
+			rsvd_bits = (rdrand() << low) & GENMASK_ULL(hi, low);
+			retry--;
+		} while (!rsvd_bits && retry);
+	}
 
-	do {
-		rsvd_bits = (rdtsc() << low) & GENMASK_ULL(hi, low);
-	} while (!rsvd_bits);
+	if (!rsvd_bits) {
+		retry = 5;
+		do {
+			rsvd_bits = (rdtsc() << low) & GENMASK_ULL(hi, low);
+			retry--;
+		} while (!rsvd_bits && retry);
+	}
 
 	return rsvd_bits;
 }
@@ -2733,10 +2745,11 @@ static void svm_npt_rsvd_bits_test(void)
 
 	/*
 	 * 4k PTEs don't have reserved bits if MAXPHYADDR >= 52, just skip the
-	 * sub-test.  The NX test is still valid, but the extra bit of coverage
+	 * sub-test. Also skip if cannot generate the valid random reserved bits.
+	 * The NX test is still valid, but the extra bit of coverage
 	 * isn't worth the extra complexity.
 	 */
-	if (cpuid_maxphyaddr() >= 52)
+	if ((cpuid_maxphyaddr() >= 52) || !get_random_bits(51, cpuid_maxphyaddr()))
 		goto skip_pte_test;
 
 	_svm_npt_rsvd_bits_test(npt_get_pte((u64)basic_guest_main),

