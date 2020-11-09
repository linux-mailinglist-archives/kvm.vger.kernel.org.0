Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F352AC895
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732534AbgKIWaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:30:02 -0500
Received: from mail-bn8nam12on2057.outbound.protection.outlook.com ([40.107.237.57]:17985
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732431AbgKIWaC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:30:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XwF3Upil9E/UNXHumdlv6ys0rolGYrqddbNkyC5r9tylNly3WIaHDfdnEU+SGfYAgy2nkEbGqfTbqr8ioTakZWpPIbvT4xeGPJ9iZhxqD9UkQ+9+GC5tOGrFCco4AEnukNN/TqWZJ/1WhXi1hcBurCvEEhWyF5hR/kiZN2AziHopFHxkWX5nUgDl/TldSaCBSWEH99yXm/IeX0W4l2z1qYbu66CI0FwFpYt9GETzgTJmVo2y7QvqCobt1aXz299f584TuQJO+huXd1Ri5f/haX3tdYH4TVRNQg9GtFqIQ4NtyCxRVT/wHsvcv/aXjppSSaakx8vr3j6NWdbdViSYrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1O8B9vw91BBA5ORUmOB9tZi4PT+Xq2VtOuSs51MKD/I=;
 b=A36csmD+wuhuiltWw1pRauWYqtT2FPivvWo9EUstfWqrohJetb6wASrXezaSUPi0vFNC0VSj+Ce1Hs6qdM/+55JKYv0LuIS8K16dBc7RiSE0Q3c5Oo8sGhq9944FMdEEE9JkOlxjoBx/jPil9L8YJBww4wONzHJPryNJgP3qai9E13xVEYtCW7T9yBaJvE74NwTEmSn31Ja4iOswcvatB1P4RtdpBNUr6lDjR2Uywcldc4/nqshLBaOEDLNxAlMmTCYyrMzN75jqKkQbqszD+/MRhrPPkXur8klc8XR4ItUZc3krqGSIXhQma4+2a9q9CaDJg7n9xc/dHcsGM1qK4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1O8B9vw91BBA5ORUmOB9tZi4PT+Xq2VtOuSs51MKD/I=;
 b=3r2EH8+oULzSKZornK44MO5H5cvo1ZRxMAkJZelMhEJioLncKOzGCfWI34chB2kQDEHAT5TfYRjQFSVXQFb4k1qeRAcX+dj4eeKte9ol9E8rUjvKoRYuIsPCwAASRLYyTLOdn5YHCyP+2kT7vUyVWyCWBujNOkQES7DYYZsXP28=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:29:59 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:29:59 +0000
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
Subject: [PATCH v3 29/34] KVM: SVM: Set the encryption mask for the SVM host save area
Date:   Mon,  9 Nov 2020 16:25:55 -0600
Message-Id: <4d226553ae77fd6133df60072de60b04d31fb9e1.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:3:d4::28) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR05CA0018.namprd05.prod.outlook.com (2603:10b6:3:d4::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.13 via Frontend Transport; Mon, 9 Nov 2020 22:29:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 384fd699-d38e-4336-27dd-08d884fefe42
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4058CD8D884003205BBE63C2ECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6kUtTlPy3XHqdu9Ou+pkFNpx6A2jqXh8ydT8q+oAEZlyj67j9K++yWvgaxrU5KEcBGSCX9AEeApCshDVxRizS5ME57SQSFYG+SBHBvH5pSvoT5I8PGiAjO+6dAmGTt6evutbyjKq6iryGM7cNwVDLaMevaIAsJArMdmQ6nI5JWghp50Hza8khA2tvTR7dTt29FjjPzxSxL00V3suIpY8UJVSpsaco6txXpJFnW/l3tHGatr3EtaN5edKQctw+TshAH9fHtixWtUkzZEKjs8NbUuTFwvBXpqgd9j+2L+R1wD43ytZYQsP2yzan7oHE6dtl8/36ohBNHlfRn7FdUHQYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 0QbcJx6YDzzJ3A88MCtENwsnVN33SPBe0IMv4mO3RqDpDJZgzW1eTkMUQqdlmsJLADKiT/FWX6up8yJNGpnyx911V/YSnfyi4oWIGWzOpYhTdrj30MOeLm3aB/iYkmRSgBZVDzH9jgV55Jy5AEWfv0hCu/ME6rKgBa5Vim9yTWv/UMLrb4WNSLsaQG5hDlLMH1jyUZJjzTLf+GmEPFJxR+qYwDHt+QCjwXXp5w2YOOtzkO+5CfwuTu2vWSvyQvBeta93bU1dk8eybHVMuX5r+vFtuB6++YA0m5paqa/XJkcZ9LAuFVpE6AFtOOxON18B6n7f0sV4SGsIatyMqnzVdmecidXmeW3C2wslHB5Hd6Da08N+5ZP9S6sCx1e4s5BYJeEjvRI4sVJFg/aFDkKciHn2UgEc+USy+XZt/jCqeY+6uPiU9URp26nTyazj3o8QtEIYuluxOSJzp9E2P16FkY2GOefvYvFe8UJlzJgga9BK5RDYtyjnaxpfiS8qIR/WINLWo6KgIwzRX773AJh/hSKeo25fzrZPXXj+X0U9pkH9PHPRPwLLCuYGPSwtSOjaAhU5oiTWSXE00U+4QJXpB5NWFEo7HR1JhSoSdpx+UDzyg+VOh9miSF74R4MOozReQmZD5gcWidYMZI32f9/5sQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 384fd699-d38e-4336-27dd-08d884fefe42
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:29:59.7812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wQwPd05vsoaYtom3BzXKdw8fjCJsikvprr7BDIpl3wwNAL9t/3s0dOy6wHcYXE/nkWibSx6OJE6YbOcST6Nxiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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
index ef31396b846c..375169fc3dd5 100644
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
index 9dfd60395c8d..073b5b044bf1 100644
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

