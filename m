Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60E83542CC
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 16:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241368AbhDEOaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 10:30:05 -0400
Received: from mail-dm6nam12on2073.outbound.protection.outlook.com ([40.107.243.73]:16353
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235915AbhDEOaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 10:30:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYGXd7HE9j+Y2KvUwzY1/TNIgP8o6EVhvXrDcyhuAbOW2drp2t5Q+PPzMJ1isOI0D5GMPAqAvtFINr9DOilC8gsEUjYKQl48zrmjWnFz4UEVgIJd5lPxSM+wQTEITxhXAWJIxegLaOXQWsShrNrX99c6lBpCZ2t4m4WJe1qjgY6n3SrXqy0z0AMrZBCJ7sZmteRh0bcIO6UFH3Tj6wxBqnD7X/ff/r9OvMJps2W2CyndmSSCO8I7AwxgbkJf12OvFNgESYSTStLpfC0PEMvfglfPnvIewxokZsMe5arAo1C30CLPEbTf7LPS/C+29VVpCuRHP9LTB6rSvnrHfXp2Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptwi1W+4zT0Cz1ubGqqSi1V3I2VOGialOuW68ChkUDM=;
 b=YokomW78j8QgLrChXuHtr4efEP81USoEiSGxejK5X3r+/OhNYSphBsaS7jc88pzihAhl4IFVZipEG22p3utpZl4KtWGgNhUM7s1modobzOYYX/l5PMYRfdldmm9ma2yZYDfxN3ocbAj9/0a3shf1t311IIyBoknAnPMsxmmOSzvp5ZWNf/YHLE5xsj6ZLXc55n8JJ/z0XMS41d7RA/y3PN3moUfaO8M1EUvrEI8MpxohXg2VdJ5R82ksOIXP/DBcDEiylDU0aIsVsFUHI8dZ1UNRy7eMtNPAwrnlRjJw9lH80kWXeoPqIngmXTU4fWp5fmIVXBoE6hg4KPrIHOpcoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptwi1W+4zT0Cz1ubGqqSi1V3I2VOGialOuW68ChkUDM=;
 b=shB5bzYI3B7OIUOYvaUgaNV1DH4tA7BtX5ucL93HB1omLTvIW5PdOJz/+XrcQw/YbaXhg795Eb7FS92beEfCUdJTnHgynwiUHdpQKL/jvyOBDsjXRiMmvr3mloQnISDon6BRPHFJFfHsS37HsTYJZbsc2jpn4o/uX40/87kOh/s=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4413.namprd12.prod.outlook.com (2603:10b6:806:9e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Mon, 5 Apr
 2021 14:29:55 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 14:29:55 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v11 09/13] mm: x86: Invoke hypercall when page encryption status is changed
Date:   Mon,  5 Apr 2021 14:29:46 +0000
Message-Id: <fbac31512192c62b51790c5e07e8980a8646a1c3.1617302792.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1617302792.git.ashish.kalra@amd.com>
References: <cover.1617302792.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR04CA0108.namprd04.prod.outlook.com
 (2603:10b6:805:f2::49) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR04CA0108.namprd04.prod.outlook.com (2603:10b6:805:f2::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Mon, 5 Apr 2021 14:29:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e15bc9e2-ef77-4775-8330-08d8f83f4884
X-MS-TrafficTypeDiagnostic: SA0PR12MB4413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4413A303AEC17AD5C0AE60128E779@SA0PR12MB4413.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c612td/fEkLbpdN1+W4oDYTpd7tCS0KmK5b78sg9VWfi7ilEuRHN69Jmg16N3BFdHCAIzH4MTe2W8Mmnyecpoo2nemxxK3AOdUOk+Trs7z1dnmsOatchqD5iG5NPjZ4Hoxpgq+WRxrOjktezNvNnvs1MvGPCrSpgRaCxE8pZl8IxNvJNIRox5TNO1ekV5iRQ4p4gKOhugjfYcB0lYthfxNEmyDyh36gya6vH4KlGdYi4pAeiRmJ0eDtAcVozlqCQzpPETl+qqiIUwtVZGe8m8tyYf+AsAO3MI9G4rfoQsyNvlygRmprBoVJhCIO072K8BXfCq9hiv/OWGHNLiIEw7lsWfTQeEhuiIqrUPjrdtRJ4efhzGKdanXYXWSowQx8W1//GPZk0zr56L3EBM6A67fmm6MfsDPi8GiUl+VPErt8Hu4WzrA0jdroDhbSsLQOvBPr+g+jj4myJw1BpBTmtDWFFu6eYl7fAh47JWNhnFN+Rzr9vvcnVLaOiCMkJq9O65/m42zsA0ybRLxznuKs7Gnnj78RhHwy3MlRapiDWQimSQemgQhS01FxjgrosKpWIKOF0APKa2AuBgFOyXyPz4p0bF7tHB6OxCsxdW+GZapn1KF5VZ/qJnSdAnVGi8pHdZjDQ7BrNXiKCb4g/yHq1YBmfe4LiUO61ws+cqoVWfRE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(38100700001)(7416002)(26005)(316002)(8936002)(83380400001)(16526019)(956004)(52116002)(7696005)(66946007)(6666004)(6486002)(36756003)(478600001)(8676002)(86362001)(66476007)(2616005)(2906002)(4326008)(6916009)(186003)(66556008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RWlWbFBBcEwxWGNsSTJ1Wm9QWWdvYjFaTWpmN0FDQms3bUVpd3FCRXVYTWYw?=
 =?utf-8?B?OVkyOEdua0c5b01JL0ZjN0p5LzM2OEtEV3lGY1NDaStqd3NOQlJyU0dIajhw?=
 =?utf-8?B?UnVzdFdxSEl3MFNMYjlyejFVU29jS2IxNVlqN3pMR1JaNm9BNFpKeXNqRG90?=
 =?utf-8?B?d0R4eWQzMCtSWkJDMGlKR2RqS3RMdXdOZnZxS3BQZmtlZXV6SElFMDloQUox?=
 =?utf-8?B?UkYyME1pSVVhSk51U2YvVldZaTZ0djRnU1o3eFdJY0VWRTI2cnR6S1hOZU5J?=
 =?utf-8?B?YVZDckFoUE8rVm1MWCt1VlkxbExwSWNrbkNxeHBjbTIxWXcvNWNqV2lPK2g5?=
 =?utf-8?B?YmhRY1h6QnMrQUlGbEY1VEhHSk5ZYkEwWlFSVXM1RzFNZFkyUmlNNDdTWWp3?=
 =?utf-8?B?akorK0huQy96eTlrUUFOZDgrV2lIRVRYUURnTHUxbW9PM1RneFFvQzNOMlg2?=
 =?utf-8?B?OEI5Y1d5RGFRbUNUS3VIclprSVFsbDk5ZkhKcFFWMkdTS2c2L0VDWWlLOXE1?=
 =?utf-8?B?ekswVTc2ZUpONVUrQU43MjdZTW4wMTREdGVYdDJvbER1RTBmazRYbFovMUlX?=
 =?utf-8?B?OWp1NWhhSkEvYXBldnpsUllkOVRtNW1FU2NOdmdSM3lqQ0ZZMlVTTG9TTXpY?=
 =?utf-8?B?SFcxL1hsR25BNU5WUEdFZ2gxa1hmSXRmdFFmNCtQWXBkbnl2WlFERmpNaXNt?=
 =?utf-8?B?bVFhZ0dGS2dlcGxleWdqeHRtMUcwcUFPKzF4SlhxSUZtWkVDMk03aWgrNnBn?=
 =?utf-8?B?K0h0MEt0UWxDNDFLYUpsb0owU0tLS0kybk5JYm0xK2dvMmoxeE5sYTBVTExm?=
 =?utf-8?B?eGlsVVNsM2cydnZaam1nTUIzWi9LQ3ZEb29GaEc2TFArYzh6Z3BubE1FeTgv?=
 =?utf-8?B?VkFUN1ZCZWhodWRIV254ZUh6VWhsYmNZNXRueGV6RVN5d2dWa0g0WEt2b0Vy?=
 =?utf-8?B?NlpTR0ZOWDU1OWt2aVBDOTFOZ3pDUUJTcUdseThrYkJycFBES0g5bERQdWJF?=
 =?utf-8?B?QUYwdTR5YlFOTW5tN1dFWVgzVnFaTTNEVDBXWFhEdHJWUGgvN0FObHdDSFpK?=
 =?utf-8?B?RkNEaVAwckNtQ2EzbnhhRlJHZm50OVpsdkxvdEd4blhrTE5teHRsMEFTcGFp?=
 =?utf-8?B?OUE4MDcrMUkxWjlqUXg5bUJ6V0k0MkNaMm1mcFlPeGFuZGY4QWhrck0zd09s?=
 =?utf-8?B?TWwxczhJZjNoTys2QkRXR1BneVJsTVZLajRhOUJUN1dyQk9sL3J0S2tFWjU4?=
 =?utf-8?B?Rks0RSt3TVkzOFdTMnFXVHBZODA5Rzc2UCsvOE9Zam4rS2gybnVWMU1EN29L?=
 =?utf-8?B?VEZIVjUxaHEvZ25YVHBzRWFLSjJiVWRLSGhwVnhWaFdFNTkyRDJpZ0FWSlVv?=
 =?utf-8?B?dDBZMndaQkNZVzJuaEZMeGg4aFJPajNHT1FKWU5lNHZKSFRMT0VpR2FlOW9z?=
 =?utf-8?B?ZEJuTWVkc1lEK2JoUWZ0eFJIQk93K0pWei8yQnRCNDB4SS92Nzllczc4VW1R?=
 =?utf-8?B?UXgvQU5sRXVDRUQ0c0hyODdvd0ZBaXR2YXBoa3AzUlRSSkVlcVh5dWN0ampK?=
 =?utf-8?B?cTNxWFlkRlFGelg0ZnNQUUZyRDBGNit0eUQwcnp2U3ZMbEZNSGdXdVFoRFQy?=
 =?utf-8?B?aEp2L2dscXc1ZkhnRjdmWXpQbzArRVFnNVZsZEY5UTEvVFRXVlJnUjdHQlZS?=
 =?utf-8?B?OHkzK0pqKzhFcU1VZWp1Q1ZEdFI4bHhJUUpFa0xORWNJcU1UNVhUQklLS0dk?=
 =?utf-8?Q?8c3Z++0q/9WImcBeMyrzMS5InSC0Ow72JHR7LtR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e15bc9e2-ef77-4775-8330-08d8f83f4884
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 14:29:55.7446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ql0WxH1XD7k3kEztQ9jJvT/7PqjL+BB34efSuh04EbxfxZbpRRmHQTfYBlnFu5aR36I2aesmqVFt/JRrvsjIoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4413
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Invoke a hypercall when a memory region is changed from encrypted ->
decrypted and vice versa. Hypervisor needs to know the page encryption
status during the guest migration.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/paravirt.h       | 10 +++++
 arch/x86/include/asm/paravirt_types.h |  2 +
 arch/x86/kernel/paravirt.c            |  1 +
 arch/x86/mm/mem_encrypt.c             | 57 ++++++++++++++++++++++++++-
 arch/x86/mm/pat/set_memory.c          |  7 ++++
 5 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 4abf110e2243..efaa3e628967 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -84,6 +84,12 @@ static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
 	PVOP_VCALL1(mmu.exit_mmap, mm);
 }
 
+static inline void page_encryption_changed(unsigned long vaddr, int npages,
+						bool enc)
+{
+	PVOP_VCALL3(mmu.page_encryption_changed, vaddr, npages, enc);
+}
+
 #ifdef CONFIG_PARAVIRT_XXL
 static inline void load_sp0(unsigned long sp0)
 {
@@ -799,6 +805,10 @@ static inline void paravirt_arch_dup_mmap(struct mm_struct *oldmm,
 static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
 {
 }
+
+static inline void page_encryption_changed(unsigned long vaddr, int npages, bool enc)
+{
+}
 #endif
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_PARAVIRT_H */
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index de87087d3bde..69ef9c207b38 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -195,6 +195,8 @@ struct pv_mmu_ops {
 
 	/* Hook for intercepting the destruction of an mm_struct. */
 	void (*exit_mmap)(struct mm_struct *mm);
+	void (*page_encryption_changed)(unsigned long vaddr, int npages,
+					bool enc);
 
 #ifdef CONFIG_PARAVIRT_XXL
 	struct paravirt_callee_save read_cr2;
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index c60222ab8ab9..9f206e192f6b 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -335,6 +335,7 @@ struct paravirt_patch_template pv_ops = {
 			(void (*)(struct mmu_gather *, void *))tlb_remove_page,
 
 	.mmu.exit_mmap		= paravirt_nop,
+	.mmu.page_encryption_changed	= paravirt_nop,
 
 #ifdef CONFIG_PARAVIRT_XXL
 	.mmu.read_cr2		= __PV_IS_CALLEE_SAVE(native_read_cr2),
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index ae78cef79980..fae9ccbd0da7 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/bitops.h>
 #include <linux/dma-mapping.h>
+#include <linux/kvm_para.h>
 
 #include <asm/tlbflush.h>
 #include <asm/fixmap.h>
@@ -29,6 +30,7 @@
 #include <asm/processor-flags.h>
 #include <asm/msr.h>
 #include <asm/cmdline.h>
+#include <asm/kvm_para.h>
 
 #include "mm_internal.h"
 
@@ -229,6 +231,47 @@ void __init sev_setup_arch(void)
 	swiotlb_adjust_size(size);
 }
 
+static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages,
+					bool enc)
+{
+	unsigned long sz = npages << PAGE_SHIFT;
+	unsigned long vaddr_end, vaddr_next;
+
+	vaddr_end = vaddr + sz;
+
+	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
+		int psize, pmask, level;
+		unsigned long pfn;
+		pte_t *kpte;
+
+		kpte = lookup_address(vaddr, &level);
+		if (!kpte || pte_none(*kpte))
+			return;
+
+		switch (level) {
+		case PG_LEVEL_4K:
+			pfn = pte_pfn(*kpte);
+			break;
+		case PG_LEVEL_2M:
+			pfn = pmd_pfn(*(pmd_t *)kpte);
+			break;
+		case PG_LEVEL_1G:
+			pfn = pud_pfn(*(pud_t *)kpte);
+			break;
+		default:
+			return;
+		}
+
+		psize = page_level_size(level);
+		pmask = page_level_mask(level);
+
+		kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
+				   pfn << PAGE_SHIFT, psize >> PAGE_SHIFT, enc);
+
+		vaddr_next = (vaddr & pmask) + psize;
+	}
+}
+
 static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
 {
 	pgprot_t old_prot, new_prot;
@@ -286,12 +329,13 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
 static int __init early_set_memory_enc_dec(unsigned long vaddr,
 					   unsigned long size, bool enc)
 {
-	unsigned long vaddr_end, vaddr_next;
+	unsigned long vaddr_end, vaddr_next, start;
 	unsigned long psize, pmask;
 	int split_page_size_mask;
 	int level, ret;
 	pte_t *kpte;
 
+	start = vaddr;
 	vaddr_next = vaddr;
 	vaddr_end = vaddr + size;
 
@@ -346,6 +390,8 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
 
 	ret = 0;
 
+	set_memory_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_SHIFT,
+					enc);
 out:
 	__flush_tlb_all();
 	return ret;
@@ -481,6 +527,15 @@ void __init mem_encrypt_init(void)
 	if (sev_active() && !sev_es_active())
 		static_branch_enable(&sev_enable_key);
 
+#ifdef CONFIG_PARAVIRT
+	/*
+	 * With SEV, we need to make a hypercall when page encryption state is
+	 * changed.
+	 */
+	if (sev_active())
+		pv_ops.mmu.page_encryption_changed = set_memory_enc_dec_hypercall;
+#endif
+
 	print_mem_encrypt_feature_info();
 }
 
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 16f878c26667..3576b583ac65 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -27,6 +27,7 @@
 #include <asm/proto.h>
 #include <asm/memtype.h>
 #include <asm/set_memory.h>
+#include <asm/paravirt.h>
 
 #include "../mm_internal.h"
 
@@ -2012,6 +2013,12 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 	 */
 	cpa_flush(&cpa, 0);
 
+	/* Notify hypervisor that a given memory range is mapped encrypted
+	 * or decrypted. The hypervisor will use this information during the
+	 * VM migration.
+	 */
+	page_encryption_changed(addr, numpages, enc);
+
 	return ret;
 }
 
-- 
2.17.1

