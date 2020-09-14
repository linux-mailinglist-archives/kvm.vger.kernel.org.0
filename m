Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7D826967C
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgINU02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:26:28 -0400
Received: from mail-bn8nam12on2068.outbound.protection.outlook.com ([40.107.237.68]:3544
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726319AbgINUVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:21:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehc3Nt6UrFpyj5MrivPZTICkZkmbF/U+0iBsRTbiiWAO/jMBImY+vi7/HLZ3GRwcXBiH7gOAEpAZdtMOo0Z4/zbq5Cg57sA3caYmpFdiWigX04X0AwrvIgzUeQ+yqNIET2WDJtQcyaOIr74NjfH6nTuTAG1RlgGHYoqr8D5Kkd+Vxsd4/szKhX+1JqabOLstsTBvstagJr63yzwevjqGgduLkLEm3zB515p8BCHYWEnxE2lZoqXQNW4I5+vM+GqP4NxxEdHYGEqy+E7zx1OQN04DiC8nnFeZta+OsGxbxxnqHDfWRcVcmbyM7gIU17talx7jbNYWzR4PEJjpCC3vrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2IfzXz5pCeBVSNqO2P8ueuO8d48gH8QtoPw4fXPxrsc=;
 b=br4uDpAoeSDPedXKT3G+jjvXjp/TKEsz1hIrqogRh6WT+osC653hChkuUIk3fgRG2bnNA/kooWn5oLAsHpGMRmJYlbxsj3Ko4QGPA9BZTslIm4QyQIV3xd0GxXAfWZCATZkottNJFP4CysImJgkjxC0117aUNqbEhDy0LOMkOLITC85Qi3wiTLmgKxEWhIcedK2gSauKnt1N22hBLut1dAmspUZ8rRe7RE65XprwZW165ffFwvIZ9AA26GYyo1fIINberl7iFRmU/nMCMHXWPp3fmcv4PxiliCzSq+QPMIQU/r0seSwzBkU1lwt1jQPdaesn0lwowISvB3zujx5E8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2IfzXz5pCeBVSNqO2P8ueuO8d48gH8QtoPw4fXPxrsc=;
 b=p0wk6OwyeHQeMBz+tcsTrXh8xOPZA2XqdQxNRr9VZ4DbFPb4lBr3mt3ecQvHe9nvTGcs5R0FSuz0t5cVqzzFL5ygpD07pgSOZcQvE05G4qmPCNkizN8T1Y3fHdv5fpQMS/1CkHR+B89QeFrEm1KYHQBIxoXmY+5pIoNXTVx8xGc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2988.namprd12.prod.outlook.com (2603:10b6:5:3d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:20:00 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:20:00 +0000
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
Subject: [RFC PATCH 30/35] KVM: SVM: Set the encryption mask for the SVM host save area
Date:   Mon, 14 Sep 2020 15:15:44 -0500
Message-Id: <d47eada86fccff6d7d5df385750bcb2a4b6c9974.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0034.namprd05.prod.outlook.com
 (2603:10b6:803:40::47) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0501CA0034.namprd05.prod.outlook.com (2603:10b6:803:40::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.5 via Frontend Transport; Mon, 14 Sep 2020 20:19:59 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 816b2110-93cb-46d4-8d38-08d858eb8e98
X-MS-TrafficTypeDiagnostic: DM6PR12MB2988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB29883FAB4549944AF8DA2F18EC230@DM6PR12MB2988.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VkPUagT79VCMpRkkQorkd0q/OlpwqF4aH76yobUgooK4TZdWZnJ24wVfjIlisCX3sYEZtPc9tffUe8+sBIvoBpTe8rtKB+mA/MyM0I5VmCMrYjbACMThqL1Xyvk1j+b5aOKANq7qFXll7giz1TgtBzqqj/s6D1aeet3iMa+Mm3aLnbfkQrUKs1fZbQqvfo/N7g28t3TxLa99aB00Q8VOZ2b2qbRxyy1ME/uFyBz0J7hudVWPeBjs5hhkKKwf9SS+WNB8642pZXXOgquRMoMPe/hlWtCAOTjY8EAx7Vu9ngjh1JjESktD8uh7+92fZHMpVm5AIkCBPLvdT7hZU6X/dw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(8936002)(36756003)(316002)(478600001)(5660300002)(2616005)(956004)(66556008)(66946007)(186003)(4326008)(26005)(54906003)(2906002)(16526019)(66476007)(6666004)(8676002)(83380400001)(86362001)(52116002)(7696005)(7416002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2/qVl+ayttaQsz9eKD9ESShVupTCkJyeMSZO/cjKB+gTEni6p/ZdMigJtB9L7IRX1a31iVn0G86jN6WTIrYyNS5j1UpT3D4J6e4s8gvtFRdDEIUvukACFaB+qHhr+063lvuhS3ERLecykJdYhb7jNTpqtWMKeC0iiukuibWCxkKfu6DfOxnPnxXg242jGU79rEC7lvWDfcGvvGX4YVLmAbleQB/2x2p39CswlZJyg5rmglxWrgTdgxslFtFsvTjngBXkCOJ5lph3+HEP1VFHYOprVKPc49ifglpMoba+TrhAzh3HtpKIA4Ma6VUz3b3yN9rw65IuqG7OneadEO1Fct3MKFhC15wKaAw3kWcSPf0LyQQaY7T3XFkey4SpxU2nSzl2rfL0NC3fT9uVZek8Pz98aaKaZCpZutoqO2YCVKSIXTDfKwSZcmxMvWYuxaHip1nqhyUjoNlFZLHwBXv9VZ22cZ/iDNvgro0IXHIb7SLdwiBtYOw2m77b+2Afiurp4ycfaRu+hPvCLcyDxTkvlmyqmwkSGZqeQT43ukUsZykvR8DmEh/ukyJ3mZma04w9dz/WJZ7T9k0GbrrplQcMcNBLoqteMo2H+dEL++pEcCwHGP39j/4JupNGN8LEldUmMJIwFGd3ApuL/98dm9uLnQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 816b2110-93cb-46d4-8d38-08d858eb8e98
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:20:00.8455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jj5yWKE3t/aXeRj5fxD8+zD4bL8l1ZjLNo2voSexksZLGqACMYdBVeJzI77dM13DIcgFe4DY9bbZYWr6mcT9LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2988
Sender: kvm-owner@vger.kernel.org
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
index 9bf7411a4b5d..15be71b30e2a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -30,7 +30,6 @@ unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
-#define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
 
 struct enc_region {
 	struct list_head list;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fcd4f0d983e9..fcb59d0b3c52 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -478,7 +478,7 @@ static int svm_hardware_enable(void)
 
 	wrmsrl(MSR_EFER, efer | EFER_SVME);
 
-	wrmsrl(MSR_VM_HSAVE_PA, page_to_pfn(sd->save_area) << PAGE_SHIFT);
+	wrmsrl(MSR_VM_HSAVE_PA, __sme_page_pa(sd->save_area));
 
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
 		wrmsrl(MSR_AMD64_TSC_RATIO, TSC_RATIO_DEFAULT);
@@ -546,6 +546,7 @@ static int svm_cpu_init(int cpu)
 	sd->save_area = alloc_page(GFP_KERNEL);
 	if (!sd->save_area)
 		goto free_cpu_data;
+	clear_page(page_address(sd->save_area));
 
 	if (svm_sev_enabled()) {
 		sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a0b226c90feb..e3b4b0368bd8 100644
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

