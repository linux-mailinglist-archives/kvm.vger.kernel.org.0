Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0202AC86C
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731463AbgKIW1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:27:49 -0500
Received: from mail-bn8nam12on2041.outbound.protection.outlook.com ([40.107.237.41]:41569
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729740AbgKIW1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:27:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UoDf4k2DWaEyUNVgTM0DFaSdRdWIJ60p2b6oFOar1lbiXlcOPOfigDOuao0lmYMSbIe4ObtSraQ6x6xYRONsB+wS3u0QwBsWzqMnSvOuh51qncG7ioY4iLkgEi9m71w7mVOQbA0lonPDgUt3KnVK3v7dHu7kIFCpLfH4Kem4pupXXLNdNKbv5peS0JPO0EY0uE68ySTk8PDZx0P9r0oSGPTRrPKORJteDkxcnOVjL8hPyLnUQk1KHuzceyMVpub31qvnUHIPEKs9yMYhmbxVfvb2eclAuDggpxtFZEzWkQLIoGEloT1vSPiozfKadku0yPs3+ywBIfrlzYD6e031+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZabV9guGbxCltEM7dvO9aa9sU1wbTinyLVyTMd9S8M=;
 b=ahDm/h2rOtswmm8iGPnOAYFWbBHVGFAX2cgR1qF8iuKTurGAfKN7hGGMP9KiyUOl7FmwUb9kjynY4v+pHcIXuFgTq9QIn/0rmSORTlioD7aQezdjeOn3qDwVlT/syixq2CelYbun7WKJR/JU7sTplg2xnmVTdsUi6f9/FBo9PDHDnMyOuK4Q+4VkjP+3+bLBIkPrNgluhY/+vGFmxuf5yuSb43Wl+05e2kg16Z6KPByMjWZEvls96+UJKQeaPz4TM82jHTHKlEY5HlI3GhVNTzMIqzGKVW5WuHTRTx25AYsTb2PvIPMzejEVBbyIuWzFdUb7CSnmCFI1daIKpLgvjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZabV9guGbxCltEM7dvO9aa9sU1wbTinyLVyTMd9S8M=;
 b=Hs8T56R/UDi1KDF4BmBplQHsP+PXcuwxXXKkHzAmgr94zXB8jMcGY5mXdjREXDHOPx4osY8Sv3R9+dB0FM/g1MeUsuvlua8JdSvfJV1OLXSukydatLhZ+IEEMbfK9xfkyocxy17KiObzXrPvQpD1kPG6DFnGISJg9V+5GiYS7FQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:27:44 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:27:44 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v3 11/34] KVM: SVM: Prepare for SEV-ES exit handling in the sev.c file
Date:   Mon,  9 Nov 2020 16:25:37 -0600
Message-Id: <7b592772e59510e58911ed7531213b317d973110.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:5:334::11) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR04CA0006.namprd04.prod.outlook.com (2603:10b6:5:334::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:27:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 748e8c84-e93c-4bf6-5c39-08d884fead87
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB40580B1964F713D475F491B1ECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cThAAiufJwTRgMnwCeggLxNe+43QqNBIOr1imhTKpVQQWjjBz2GKnxIhZNeU7sEeQmFsDIM3l9QeTQr6VkOrVV8O6SHJ6HB5TwnYoG/N0j3y4MuOzTMgiVPFGYQnw3yQVEnYXs2Qmhts3uhQ0T2jaD5HnsIXKkic+p1EnsTkAinBkRLS/PrhkiQTzeuCE1z7toOIa9vSTg4136KHVqMw/8pM23OXCRz8ld1QdZTppLdTNgyALjhLwpabpRmIQXkHwiFSy5tXbiaRNUMKgSZPHZ+4UyY1BwlJ3ZyKP/YUy/fSO38FHjg8TO4tho9q+PYGFpZH+hzMeLfQxXxJD5tQHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FNHKapAUGqcnlx353VkKjc+JjQ38gh1BHyLeN+q0Dtq/gXL+DCv4m3p3gUm3VGvJyFtXkKooWMNiyUt4deT6J5h6cbGgGzkaeaCjDH9TZi8qMhXTsADMJa/nPJZ5Ytlz0wE1Haz6mHqhKZBOKN3Mlb0N+22ClRQrs6psaDZ95aWFtRNT+qENdk7Vdv+mlkl09vMFSyC+IjCDejqj8c10BjPJAra10qEbIHkWq/ekJLYjArpp8aXKKFZOe3oWq3sPi6jFbLkYbg8pS6SuNEGvjGvs/hdOMDc6rsz7nPYmrT7YvB8NatcqcKRoIL16wld5ssIyZwgOwMoMyoYWOJzGlxG0ssPlQX8gJgstvnkHC6W7Q5pxmg/tcOwsTLpYUSi+8dgBO/VOtgw2y/0jNOuvzpCCqnSMXYKoZfBlfKGWukMNrFJkjEwGz8GSGCkGTd8pmTpyW2E9huFsZhTj9yeUJF9Z63FzRVusg/vr77cKICUPclXBatA/znLZ0QzokdRfjqOFR93n2pHDcD6QWX8DYJvQqp2YbIGsXWlUp4jatEkB3v0wXOKJ0ywSlwU0/C1o/6AIhMiJ22++8MjweQf9xKZVJIYzcWrDwkjC7QhS4cwGVRDhJIcKA718lLTbtI/8dBVhYGwmYPjgKBkzUVw7Hw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 748e8c84-e93c-4bf6-5c39-08d884fead87
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:27:44.2743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OUrezKKc5o9Wz37Xh5KMYvcvOlX4Paldwx+9AsyrR6Eo+FTgUbfgeDQNDln1fE8g+MnprbECuCyQPQuKp932Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

This is a pre-patch to consolidate some exit handling code into callable
functions. Follow-on patches for SEV-ES exit handling will then be able
to use them from the sev.c file.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 64 +++++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f353039e54b6..602e20f38bdc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3147,6 +3147,43 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	       "excp_to:", save->last_excp_to);
 }
 
+static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code)
+{
+	if (exit_code < ARRAY_SIZE(svm_exit_handlers) &&
+	    svm_exit_handlers[exit_code])
+		return 0;
+
+	vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%llx\n", exit_code);
+	dump_vmcb(vcpu);
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
+	vcpu->run->internal.ndata = 2;
+	vcpu->run->internal.data[0] = exit_code;
+	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+
+	return -EINVAL;
+}
+
+static int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code)
+{
+	if (svm_handle_invalid_exit(&svm->vcpu, exit_code))
+		return 0;
+
+#ifdef CONFIG_RETPOLINE
+	if (exit_code == SVM_EXIT_MSR)
+		return msr_interception(svm);
+	else if (exit_code == SVM_EXIT_VINTR)
+		return interrupt_window_interception(svm);
+	else if (exit_code == SVM_EXIT_INTR)
+		return intr_interception(svm);
+	else if (exit_code == SVM_EXIT_HLT)
+		return halt_interception(svm);
+	else if (exit_code == SVM_EXIT_NPF)
+		return npf_interception(svm);
+#endif
+	return svm_exit_handlers[exit_code](svm);
+}
+
 static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
 			      u32 *intr_info, u32 *error_code)
 {
@@ -3213,32 +3250,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	if (exit_fastpath != EXIT_FASTPATH_NONE)
 		return 1;
 
-	if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
-	    || !svm_exit_handlers[exit_code]) {
-		vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%x\n", exit_code);
-		dump_vmcb(vcpu);
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror =
-			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-		vcpu->run->internal.ndata = 2;
-		vcpu->run->internal.data[0] = exit_code;
-		vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
-		return 0;
-	}
-
-#ifdef CONFIG_RETPOLINE
-	if (exit_code == SVM_EXIT_MSR)
-		return msr_interception(svm);
-	else if (exit_code == SVM_EXIT_VINTR)
-		return interrupt_window_interception(svm);
-	else if (exit_code == SVM_EXIT_INTR)
-		return intr_interception(svm);
-	else if (exit_code == SVM_EXIT_HLT)
-		return halt_interception(svm);
-	else if (exit_code == SVM_EXIT_NPF)
-		return npf_interception(svm);
-#endif
-	return svm_exit_handlers[exit_code](svm);
+	return svm_invoke_exit_handler(svm, exit_code);
 }
 
 static void reload_tss(struct kvm_vcpu *vcpu)
-- 
2.28.0

