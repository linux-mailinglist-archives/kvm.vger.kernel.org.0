Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D381C62DE
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbgEEVSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:18:05 -0400
Received: from mail-dm6nam12on2080.outbound.protection.outlook.com ([40.107.243.80]:38440
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729031AbgEEVSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:18:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OkJ8uu4o0WocCzYsdZ9r09OCD0L0k3WK6a+UqQprvoS3kQOUmh3gfGRwTC2JvzTHaRLFtOz6qPBY/9qTxlTYG6Pl+9lap9oq6gh7UxHtbndOT7xTURQhXs5oo84yhoI7dMobdX3qPr7uFMhYYR+k5StSEqccWyBZsw5da9j5ieV/l0rZcuEVrl6GPHKYExybMfaIS2JfGR26QJyjGJ8OcaBu6bgIvu+cyJCijgwa7ihVCp5aGXmfUFiedGjHmXgV1T56invPALQFAb777wESCs4/og+zNv/xARz5eYwwmBdLyBQNJzjr7qBODZsY33m35zsmeh8Upze/6xtizGkiNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5bhVHeAVhZrK5JtuHfzsSsof/IlRxtS6Tsp+BauBXfQ=;
 b=MBZlKDUP9Iu1tc08/jBQxUwhEq2sArgbsr9dXa9GWPjFn/x1zR/ue+2va34VY0axjvBauu0UMC5h57RAnARTCiTJtG4Q56+wF2WxzfThXh6Xa0yxKMSz5X8YlNjLpdvtnFGFfXHG93qdagObNVkijWTZ7muydD2g8fZolvui+DhzNBdgRx5JcgM3xD7q4hCsZAv7TqOLlyr6VosxEa/4DKh58rh30JmIUpD2rRD2HtxALxIDX6HxtqWFBoQmwXMDCSeZpp+hAg/sZq/wL2qguEU7WXgr6cMLQC7THgzIviVWtnOykDZIZrmANCzlBgJ1OpeJPLK61mGpapPBBtZ2YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5bhVHeAVhZrK5JtuHfzsSsof/IlRxtS6Tsp+BauBXfQ=;
 b=dxKS2EBchlG9ZZsUv2HcksYjoeYH5BlBtTBKH42Ixp7+1VZozIue4HiYTvaWccBE48aTgHM7Z58B3n3Xtq5T1NfhsjEbdHpNfvTcQQ6kyfhV54+XWDW2i3ZzpOEOb89sGBcC0ALOzpSnI/VmeW2MIm8IBMVsNcwsx3QQRqVRykM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Tue, 5 May 2020 21:18:01 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 21:18:01 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v8 10/18] mm: x86: Invoke hypercall when page encryption status is changed
Date:   Tue,  5 May 2020 21:17:51 +0000
Message-Id: <40272f7b19bd179b094ac1305c787f7e5002c068.1588711355.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588711355.git.ashish.kalra@amd.com>
References: <cover.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR08CA0008.namprd08.prod.outlook.com
 (2603:10b6:5:80::21) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM6PR08CA0008.namprd08.prod.outlook.com (2603:10b6:5:80::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Tue, 5 May 2020 21:17:59 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 883b01b1-bbd5-46d9-2342-08d7f139ca33
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:|DM5PR12MB2518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2518E54E84C44D880559BB228EA70@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D7Fl9sqOZjNES3ajKs08vKFUhfh925jqui9FNn4F6PHWna8fqEhwbsrXePJJCCJMZQqk0F5Q5rdKjvPew5X9/uKaLIZDXAVif5PT9UGAk9LsJ9c/g409qEMIBUOvCXvgsnRMaBpOg+CEw0ivm8IO/zhufNmHsCgYndExaq1lywUK5cE/FwMrYfY7TyR5PTjJysubwg1S7bt3tdZCidr5Q4s8CWQHBAFmrRuPkVa4o9HTNPcQvLnh9Cp808hlCTbrFXNtPtHMeI53WGQ5nM1zW09PU+lNxMuj+icZ9ERR4BGjDdaCjdXK5WzZVI7LDwW6e7uVr58u7V8m1/WvX8YNPlisud8mdNUs+ppndTysiQYuNBtM/VCwGTM2xl6pQ2SrRWHkW95eq4SE0DflsGWI6o2jNhvUQp4M/aU9egcY7B868uuVknCdfZd45uxLfwV9Gdb3Pjqg6dXcT+H56hKVQSz0DQyOhrgwfO8wL+t/GZ8vcipgDg+4ItyNTr5ZQX1YW2TTA5KmaR1dRluHvfbMvC69dyeg02Jh2y5A6qygtzqM6u9M3zmKTW1JjNNelsaz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(33430700001)(6916009)(26005)(36756003)(956004)(16526019)(478600001)(6486002)(2906002)(5660300002)(6666004)(2616005)(66574013)(186003)(66476007)(7416002)(52116002)(8936002)(86362001)(7696005)(8676002)(66556008)(66946007)(4326008)(33440700001)(316002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4X52NAGENLL9PcGtV6myV6TVS/gb9rAfW6sSJgF5+EXywnxYs4hke/7qksfDSHE6eLYREo7VwWgzEfB771MVSLPkdx0dcBdBmce50tsQqv4Q4mdskj0gwJb7yYPLiAjoU73qaywcrBHZTdK5hTroKNhkyLgmVk0w9I6uJfKk7ElQSfp+oD6Thp66EmViuIZhzd0W2Q3ztvVk7HcEsuVYCJR8SToHyIBc2iPgm3tUtOXt2z/bZJKFr5idF60HQTMgx59N6iaumH10KFmvQodzIBO3iqhFnM1WC0TtZxVUS7FvkJx2WgrNem5pOWRITIrhv1maNQoV5uk+gFb77DnwrZxTcRO3gmtIQ/6rP3kmA0YkOmWTJGlWdr0Hxz1pmHMo6kM0v+SBKG4/dQwVQOMuktgp8GOC79orejsiMa+ZawD2xJLA1qT3UMEznHv+FGdCjqYZv1AvFCo1JkHYCEtEqOd2yP4JJzr+YjibDBLT+OzBtJzQVnBUfiISGFESw2DqG4ofMK6/SQ96nLUfRQyX4Q2V3PdbsLkn5bvSq5wVXsBcDhj8dqlnWuS3w81ZVfufuXomL1dAaGI237Ai18wTuYp7Oxc5Fo9b8p05h8Pdxl0NnB6kjJpCJcQBMJ4i6dl+UF4SKoKVXEZhZmj1aDQpuMIXRVh9PxyXxunUdaqyYhUm7MwljL14ctCP3FUAaXoz4vVD6a4A+309ZnZlSkLRPNEyGZ2gCed3w4tiuCm75b8oylvEu4lWXs5cqLo6/cFv0Q9i49Ay9qIKoWGtuwktdwameNRry8shAaSf38+lY2I=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 883b01b1-bbd5-46d9-2342-08d7f139ca33
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 21:18:00.6282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i5KJX7vg6VBCi/YsSwB4FbxAYq7c0k9ejwJQKfNBVW5zVvUaU6K31zyY6Nh3nOtvn8+k+9KQgDBSy4rhi+IsKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <Brijesh.Singh@amd.com>

Invoke a hypercall when a memory region is changed from encrypted ->
decrypted and vice versa. Hypervisor needs to know the page encryption
status during the guest migration.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
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
index 694d8daf4983..8127b9c141bf 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -78,6 +78,12 @@ static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
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
@@ -946,6 +952,10 @@ static inline void paravirt_arch_dup_mmap(struct mm_struct *oldmm,
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
index 732f62e04ddb..03bfd515c59c 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -215,6 +215,8 @@ struct pv_mmu_ops {
 
 	/* Hook for intercepting the destruction of an mm_struct. */
 	void (*exit_mmap)(struct mm_struct *mm);
+	void (*page_encryption_changed)(unsigned long vaddr, int npages,
+					bool enc);
 
 #ifdef CONFIG_PARAVIRT_XXL
 	struct paravirt_callee_save read_cr2;
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index c131ba4e70ef..840c02b23aeb 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -367,6 +367,7 @@ struct paravirt_patch_template pv_ops = {
 			(void (*)(struct mmu_gather *, void *))tlb_remove_page,
 
 	.mmu.exit_mmap		= paravirt_nop,
+	.mmu.page_encryption_changed	= paravirt_nop,
 
 #ifdef CONFIG_PARAVIRT_XXL
 	.mmu.read_cr2		= __PV_IS_CALLEE_SAVE(native_read_cr2),
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index f4bd4b431ba1..c9800fa811f6 100644
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
 
@@ -196,6 +198,47 @@ void __init sme_early_init(void)
 		swiotlb_force = SWIOTLB_FORCE;
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
@@ -253,12 +296,13 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
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
 
@@ -313,6 +357,8 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
 
 	ret = 0;
 
+	set_memory_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_SHIFT,
+					enc);
 out:
 	__flush_tlb_all();
 	return ret;
@@ -451,6 +497,15 @@ void __init mem_encrypt_init(void)
 	if (sev_active())
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
 	pr_info("AMD %s active\n",
 		sev_active() ? "Secure Encrypted Virtualization (SEV)"
 			     : "Secure Memory Encryption (SME)");
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 59eca6a94ce7..9aaf1b6f5a1b 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -27,6 +27,7 @@
 #include <asm/proto.h>
 #include <asm/memtype.h>
 #include <asm/set_memory.h>
+#include <asm/paravirt.h>
 
 #include "../mm_internal.h"
 
@@ -2003,6 +2004,12 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
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

