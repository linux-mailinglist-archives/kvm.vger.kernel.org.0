Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE93308286
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 01:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhA2AjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 19:39:16 -0500
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:49601
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231467AbhA2Ai2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 19:38:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OfHIAOwH5dL/7AF2tlsTJAAC4CIcfnnl+5f236UcayfHEtPMfqMrSjJjGiHlBnP/poAALCueeAYbSNpe85h3D4gfFzXiIgiUwLqGT+CpJuXSs09UTMyFgxUSg127Td+fKKhr7a3FsjopHvcENtTk8BhhEAklEAJZly44Fqp3ykDe++VLaHD0AzKci0QNDKq5IGZbn6tXHPmZwYyh6UZyet7L1r9Pvkl4ncXc0ZQJEWiL29MUatYPdaZioNFJmXA172+vHOhpK252+Yb5hnp3k4aFINPM8dcbPlZ9EjxT1Lz1mcSzO3eUCKz4s2isbDeM6UA/vcBPCUJV6xSqTd5WZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=peXwcfq24eAMODaWFHYYRbuRqjpmR30FR0l51gPg/UE=;
 b=X0fw1p73TogabWrA+39SfWArDqyDFOy8pXOJq+AZ7W2iWhS6BTs6m2Ru53pW9Ptl07xG2Sk3J66MKYrLYM9Zfrww3ZgZWZS8Vr713IU8PspTy/OeTcPwwmkecjDBdZQfQi/XGKM+n37dXkMqfplAgD0/tauLhYqgTXOPkhPOXiL0KsOXVEKAdiRtDcoZ6r62JDQFCy4fh403jZrjB5ShNzEuPYj1rGwd7XhtLSMnHFRRX3sZjLKwisliPrmj23ATc+saaSp8CbGgXkF1qLtBvXPh8iKzmJTzZww6btpJiQLKkTxlJhKCTt68FYChkHrM48AI8Bn1EPCwRHacARvfuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=peXwcfq24eAMODaWFHYYRbuRqjpmR30FR0l51gPg/UE=;
 b=g9x4ow3r+m54OtZVOJjR9g84VEU0OMnEm0YsSAzTCWNL8vl7R5vmvm4WxrGGKHgzgAB5UHRciWCyzCCVNceG9x4dGKW1aGZtw6qWZTbYRPs66Wg0OHz+HFdKXE5EY5AnNIkqKxgR+X3OG9f2Zw3LtB7td34dlW/X6WZhnlQDqic=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2525.namprd12.prod.outlook.com (2603:10b6:802:29::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 00:36:27 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3805.019; Fri, 29 Jan 2021
 00:36:27 +0000
Subject: [kvm-unit-tests PATCH v2 2/2] x86: svm: Add SPEC_CTRL feature test
From:   Babu Moger <babu.moger@amd.com>
Cc:     kvm@vger.kernel.org
Date:   Thu, 28 Jan 2021 18:36:25 -0600
Message-ID: <161188058573.28708.18210438890249970432.stgit@bmoger-ubuntu>
In-Reply-To: <161188044937.28708.9182196001493811398.stgit@bmoger-ubuntu>
References: <161188044937.28708.9182196001493811398.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0199.namprd04.prod.outlook.com
 (2603:10b6:806:126::24) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN7PR04CA0199.namprd04.prod.outlook.com (2603:10b6:806:126::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Fri, 29 Jan 2021 00:36:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7a5be1e0-62e8-425c-d0a4-08d8c3ede9a1
X-MS-TrafficTypeDiagnostic: SN1PR12MB2525:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2525E53D0B11B7BC0D3CD65D95B99@SN1PR12MB2525.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J5Bdk6Y/yISBZ/zAVFhDRfeohuj/ove6xHa+ja2ubxRSOu4jrSO3Se2KkKYzqcWdoBbaQa/zQi53IXD1NexVis094Y3yC7V9cZV2/buu/c7YTXHAvIyTJ+ZuuYbdt2kBuEC5AQ3UUDMq3+K4EgTUIXR12UC62FE8QfTtdGimM4ogRpuXP5hRppEqkN6G6NQ8YxGCbJhi0ElYYPVUdrit7EJrafiVjPGCzsELzhqbH49VQWUI/7BeUCK8adiG+Mhqn9PhDOInV6ne/luWIuJTk71Y/L26grfMYTOfGCO3gAzbMGkIz1JYVGC5LuCofqjk7FBSlzYKmPA+4GhbQSGO3GHK4hAnIF4lMDeaoHa+b9WSdr2L50gCIG6clofmGgdFJpjhlTu8x95BqsEQY4DvGfWgi4oLi/4L4xSThXLpfEqRo7uuWvmNqGlm3HMmAsAy3Xh4OjJYMKiKi8e7b22Uo4PA0j4xsVHwZXr00CS2uIIxET2gakNZzd7gTU13svSo845YhJ9INNINPfAI4bwIGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(346002)(39860400002)(366004)(136003)(376002)(83380400001)(2906002)(103116003)(66946007)(8936002)(8676002)(52116002)(4326008)(86362001)(66476007)(66556008)(109986005)(186003)(6486002)(478600001)(16526019)(26005)(5660300002)(33716001)(44832011)(316002)(16576012)(9686003)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TWJqKzJBT1ZSUXZIekVhN3Q3TGR2cjZzUGhIelJxMVdVU1g4NnpwdUs1Zyt4?=
 =?utf-8?B?bzhBWXcydW52S0NvWkJlZ0tqNkdGKzdYMUIzYzY3RlF0WDcvdW5VVFhVT3dH?=
 =?utf-8?B?RXY3VVI0M0J6RUhZem1hMThNS3pZSUdzTlVPNmdHVVR4b0d3WUxFQ3N3Vndm?=
 =?utf-8?B?cU10ajRsQU50M0RFYlpwME4ralJaMUVtT3ZoQXhQV2NKSUIweXYwWjh0ZGFi?=
 =?utf-8?B?dXRhRWJWMHZ1WVc1Umx2L29LNlNGSVRqbk0ydGFOM3d1RlhkWnVwMVVnZlNE?=
 =?utf-8?B?bGtrR0lyQ3Y4STN3YTZvdVlRZkpqRE9wVDRCZ29NMWFpODNZeC9LdGlSWkpB?=
 =?utf-8?B?WGovaG9MalNEeVR1eGIvbzk4bVNRcnRQOEt0NjNQOVZSV0FrcXZma1RJNzF5?=
 =?utf-8?B?eFZGbWJORlJMdDlhR0QvbDFXR3hXbGpHMHVDTGVFQWVZc3RXcFB0MGN2U3Bu?=
 =?utf-8?B?RnhGTjZ4R21JSCthWSs2ZlZqT0lFL2k4RG56enpPajM0ZStYRGRVb0Qwejdl?=
 =?utf-8?B?d241QXlBVVgzb254ejNDUnBDSE9UenFBOEJHUFduQXp3czdQeEJVaTI4R2lZ?=
 =?utf-8?B?cGMyMGxTM3dMYnpLYXNvNFZjZ2NmNkdlNVIvT1cwZFE5cUdpWUlhSks4R1Yy?=
 =?utf-8?B?Y1VYMzl1YytGbGlQRHBOZzFFaWNRL0M4WXhudVZUWUtaZTZVeE84TjB0SHoz?=
 =?utf-8?B?d0trb1RwWmh3d3I4Q3ZsNDFtUldsdk9uSkFuMkdPUnJHYW5VL0pBaWpOTmVS?=
 =?utf-8?B?TEVEbFlURCtteEN1Zkl5Z1NyekkwczI2elZpSmdEVkZXOVEwVmNtLzByNWFP?=
 =?utf-8?B?U0djOGpsd3RQbVV3SGRTRVRHWFk5NHhGcUttL0VUdW5zSVhIS1prUERUSXFj?=
 =?utf-8?B?MGswdlVpOTdlTjNjMGtuTDV5TVdsOU9Ka0NyQjJPbUNqemNORGcxWmZHVHRV?=
 =?utf-8?B?OURrdVQyZW9OYWhsdUNYYW1pNllTN2ZtQmovZFJOQnRHZm11MjQyUFVkVnZJ?=
 =?utf-8?B?WDlRWVJyejBvZ2F0eWs0ZHdQZ2pXRXprbHJoZUR6K0pTODI1Zzd2MnZ1aXJC?=
 =?utf-8?B?NVVOVFJxaTZoL0NVV2V5cktvaU9GSW85MkphSkxxWGp4SDdxRUYzS0lqMFd1?=
 =?utf-8?B?NUF6N1U0TUgzL25IVjQ3OHBvcDlLbk00VkFHN05pTm1yenJjWkVxbkZubnlp?=
 =?utf-8?B?MXJ4Smp0Z0FTcnIxUldISEtCL0tTTDQxYk5tUTJNcFhBS2dPTDI2dS9ndGx0?=
 =?utf-8?B?NEQ1RnY5OVhiWWFkR2JJMnFWb0QzbFpSNUhpcklVTHppKzVWNzg0NGJPT1hW?=
 =?utf-8?B?VmJvOThmZCtxcVdLajNoNHB2U1p1ZWZMeGtqT3oycHV4dmZaYVk1OWlTc3ZQ?=
 =?utf-8?B?Z2RETTF0QUFTVVUzK0RXTXRUZWJsRThUQWFUY2RjRTlxeFNvSEZRQk1FQ253?=
 =?utf-8?Q?2nq0YqGJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a5be1e0-62e8-425c-d0a4-08d8c3ede9a1
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 00:36:27.1734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JZZkEDKic5UPfw3f2ZYwLTtnmJuMkJxIDsN5J/zzdUXJfFbbMwRWnUdSD6/9Wqlv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2525
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the SPEC_CTRL tests for SVM and make sure the settings on L2
guests does not overwrite the L1 guest's SPEC_CTRL settings.

Test Method.
1. Save the L1 guests SPEC_CTRL settings(rdmsr). Normally 0.
2. Start the L2 guest
3. Change the L2 guests SPEC_CTRL settings.
4. Exit the L2 guest.
5. Verify if the settings from step #1 still holds.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 x86/svm_tests.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 29a0b59..2867337 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2002,6 +2002,55 @@ static bool init_intercept_check(struct svm_test *test)
     return init_intercept;
 }
 
+/* Indirect Branch Restricted Speculation(bit 0) */
+#define SPEC_CTRL_IBRS        1
+/* Single Thread Indirect Branch Predictor (STIBP)(bit 1) */
+#define SPEC_CTRL_STIBP       2
+/* Speculative Store Bypass Disable (bit 2) */
+#define SPEC_CTRL_SSBD        4
+
+static bool spec_ctrl_supported(void)
+{
+    return this_cpu_has(X86_FEATURE_AMD_SSBD) ||
+           this_cpu_has(X86_FEATURE_AMD_STIBP) ||
+           this_cpu_has(X86_FEATURE_AMD_IBRS);
+}
+
+static void spec_ctrl_prepare(struct svm_test *test)
+{
+    vmcb_ident(vmcb);
+    test->scratch = rdmsr(MSR_IA32_SPEC_CTRL);
+}
+
+/*
+ * Write it twice to bypass the interception. The first write to
+ * SPEC_CTRL is intercepted in older kernels.
+ */
+static void spec_ctrl_test(struct svm_test *test)
+{
+    int spec_ctrl = 0;
+
+    if (this_cpu_has(X86_FEATURE_AMD_SSBD))
+        spec_ctrl |= SPEC_CTRL_SSBD;
+    if (this_cpu_has(X86_FEATURE_AMD_STIBP))
+        spec_ctrl |= SPEC_CTRL_STIBP;
+    if (this_cpu_has(X86_FEATURE_AMD_IBRS))
+        spec_ctrl |= SPEC_CTRL_IBRS;
+
+    wrmsr(MSR_IA32_SPEC_CTRL, spec_ctrl);
+    wrmsr(MSR_IA32_SPEC_CTRL, spec_ctrl);
+}
+
+static bool spec_ctrl_finished(struct svm_test *test)
+{
+    return vmcb->control.exit_code == SVM_EXIT_VMMCALL;
+}
+
+static bool spec_ctrl_check(struct svm_test *test)
+{
+    return test->scratch == rdmsr(MSR_IA32_SPEC_CTRL);
+}
+
 #define TEST(name) { #name, .v2 = name }
 
 /*
@@ -2492,6 +2541,9 @@ struct svm_test svm_tests[] = {
     { "svm_init_intercept_test", smp_supported, init_intercept_prepare,
       default_prepare_gif_clear, init_intercept_test,
       init_intercept_finished, init_intercept_check, .on_vcpu = 2 },
+    { "SPEC_CTRL", spec_ctrl_supported, spec_ctrl_prepare,
+      default_prepare_gif_clear, spec_ctrl_test,
+      spec_ctrl_finished, spec_ctrl_check },
     TEST(svm_cr4_osxsave_test),
     TEST(svm_guest_state_test),
     TEST(svm_vmrun_errata_test),

