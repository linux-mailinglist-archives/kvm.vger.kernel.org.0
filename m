Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD1C2B6B5F
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbgKQRMA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:12:00 -0500
Received: from mail-dm6nam11on2042.outbound.protection.outlook.com ([40.107.223.42]:28289
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729568AbgKQRL7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:11:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mD+V/FcZbPUJohSZQpogmbWOUY4JfPOPkDCsp6wtXRHZNyp7hVQoTxXNJpoSt4VQRLrmTpEAXtyYuaMpkG1rEoF8Tq0uH5oOiEtPv4mAuQAlSTSxUPyMjk0Pp9/SwhtBV8G0SsRXJznKgellMeWOxtHoH/PKPDEE9P0FC3bmHFTJFy/IDTeHHcCpOGPlv3iKMdcmWkj2lnNN5ai54cykuEfWYk8buB7IskkCCfT/9vPmceSpNnUbqCpfIHj2Ciou0Klc5eUGx1oVBBY6Ts0avNvsvh+F67gGPWDuVfyJUj1KilqswXuagACQ9NoDQWi5zuPFcEqo38BWrnY6sfMIqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iy1FljenhRMQMsLrSMlg44h32V/5GYmYNRxIrgyuJIs=;
 b=Efr7RnU83JXluWbmW7Hzm5atW6XTdiQ8N/2B8vqMdlKjbKHGgg4QE896Hqt4tDqxmcx48jqdiU8miedaeUWQoU4xGtD4yzO4ThoP9kY6kWkPh98TeZZw+p3UwamAyU6gotNd24QaS44ndXGLMTCpaCkdRCMfPiXyfP2O5c8Bkxtaoj2KgqHLohWP2AsFLz+waUgwwYZgF6hBZBGP05RTIgTPBliJofsib1AFFRhEeDUNz6Dc3A6UAHhjEFwxzIn/iCSr3NY1UhKRqV0Mr3eOSMz5fiyhUKuWwVbAbBrDXs98TBtA0sqRjyfOLfS0WX3LToJR0UfCCeJGWF4F021SLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iy1FljenhRMQMsLrSMlg44h32V/5GYmYNRxIrgyuJIs=;
 b=XYJDyhlbgEQ59tvJb2AJSChg2nH2foSNSJfjU3yBo0dnO0/dTS6nQjgNqduUdzhoSP/3eRKWv/cxUOY+cuFnMm69EI5ihhmRZlOWrnt5DyrkvA0jfTNpRaCFVE/ha549SwuSJM9JDxjCWRv6OtWMeOL5vO0nMGtXd2Xzhi91Vd0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:11:55 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:11:55 +0000
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
Subject: [PATCH v4 29/34] KVM: SVM: Set the encryption mask for the SVM host save area
Date:   Tue, 17 Nov 2020 11:07:32 -0600
Message-Id: <09faf62d4d84d3ba87e00e83cca70526e88bfe96.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0080.namprd11.prod.outlook.com
 (2603:10b6:806:d2::25) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA0PR11CA0080.namprd11.prod.outlook.com (2603:10b6:806:d2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Tue, 17 Nov 2020 17:11:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6a9f8812-afe8-45e9-c112-08d88b1be23f
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB177292B88C08C6B03963E613ECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xXWZZN4gcNkAFgkDnQqmnzwQeu/7AEMn7exCCVprR8pwghfF3pUniWJsBaW1wXxk92NAdh3F9JhS55Bbg8HYruC4B6uJjz01BOGRof3oB8pitc3ZbhX8Urpm4ttnKgii4S1VFywdTBVeifplP8JHAdj8RXgwN5a22muufYMGW+fdluMwZ/XG4Z2Dli/E14q795bYMx297Gj7UZoGs3Mv1qtSeHbr63QuEh/6td/qwiU2LvXInMtBr5JH6V/Ln53YPCdEiuB3NbHgxms0MnHensFMM8t2mWlIuUCvIl68HNiNMPnKkAFEuLrEwmKdfXPJeTR48zojrLMRktUXugLiaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Ylx3pngpb/yQTVFpipuXF4kQctOFFNB5+sPNGsD2YxbApaAKDeo6p7Wf/HM76vQwg69YYik9N42arm3npaZWKoyhn5LPbo9SiW4KKbnZ6HE3ryF+2VzwDxt6jjKGfRNpHra6XgwRpPM1oH7N+2coWS2rC9D2l4bp0xlYjcsyLGCNp99jJ7KWbOavBtgXk10qJMrpLBNeVo7HLkPIj54WuIZoWMTDO3nf7m1HN7fVuCxmJsZx8dKKORWLIww4nOmY+SlLQYhb3XeFUnDGF9Hnfi3AOREmEDD5NTwmdAut691p6OFkP/nEXhrmW+okSM/o8hsWYLEV7iJDG5+Gv1XIfq1DNNUnFsgP+WKXtjO889Tf1cMxrECli9ijEl7cxdJHp0c+winlHhuE/GFeHONP/uoIeV6hwxDk1q5MkmCoKoksqm9JXNyVbnZ2DfGLcvJND9BBsPabbksWMaO1bltHBCO4KfjRWm86jdDxoFY47a7y1rlWRq0Q0owWzM6fVFCi3sBNQt6Q/zk5QgcQyey3ibK7nq5T9zR/8O3YupB4+8jGLhBDrgPvn2IMMLn8yqrqTLiC6KGdaxx3RlGV1VOETRPf4axKSm+wyBYTrZdLb6K4fgCmrD2hlX/4MwZMVvQtmvXZrCY6EFhaj1jfTW29Ww==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a9f8812-afe8-45e9-c112-08d88b1be23f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:11:55.1550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C8mpKTW7ZkOPxL3qqx+loImH20j7uToS+L1Kxahs35uV+4HrhD+YUj0PUotQkrm5G5JsMd7chZ3GSpT4gNcW3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The SVM host save area is used to restore some host state on VMEXIT of an
SEV-ES guest. After allocating the save area, clear it and add the
encryption mask to the SVM host save area physical address that is
programmed into the VM_HSAVE_PA MSR.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 1 -
 arch/x86/kvm/svm/svm.c | 3 ++-
 arch/x86/kvm/svm/svm.h | 2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 486c5609fa25..4797a6768eaf 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -32,7 +32,6 @@ unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
-#define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
 
 struct enc_region {
 	struct list_head list;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bb6b624c0d12..99869d781b98 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -498,7 +498,7 @@ static int svm_hardware_enable(void)
 
 	wrmsrl(MSR_EFER, efer | EFER_SVME);
 
-	wrmsrl(MSR_VM_HSAVE_PA, page_to_pfn(sd->save_area) << PAGE_SHIFT);
+	wrmsrl(MSR_VM_HSAVE_PA, __sme_page_pa(sd->save_area));
 
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
 		wrmsrl(MSR_AMD64_TSC_RATIO, TSC_RATIO_DEFAULT);
@@ -566,6 +566,7 @@ static int svm_cpu_init(int cpu)
 	sd->save_area = alloc_page(GFP_KERNEL);
 	if (!sd->save_area)
 		goto free_cpu_data;
+	clear_page(page_address(sd->save_area));
 
 	if (svm_sev_enabled()) {
 		sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4529c9487c4a..95be2ba08a01 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -21,6 +21,8 @@
 
 #include <asm/svm.h>
 
+#define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
+
 static const u32 host_save_user_msrs[] = {
 #ifdef CONFIG_X86_64
 	MSR_STAR, MSR_LSTAR, MSR_CSTAR, MSR_SYSCALL_MASK, MSR_KERNEL_GS_BASE,
-- 
2.28.0

