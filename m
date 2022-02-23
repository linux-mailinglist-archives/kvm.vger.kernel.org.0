Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE214C0B29
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 05:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237022AbiBWEgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 23:36:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiBWEgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 23:36:17 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C02B51321;
        Tue, 22 Feb 2022 20:35:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hWnQNcPkc4KFBE1LAJ3yPgkVvWzUmOKvlHNvMzO1I1qtlLLU9YS0pD6GIzRcIdYK1evPJvIfngP1UROMq0GxQcn0WK4PKnNt5NjXcCA+Kj0rZ5uFFyr/ktcAhoT/lCE6bsLBiKSFRP+yJgSLrIkb9XNdRXwoTW2ofEUjzFz1PcO1WdZZzXkZxkzxLVXyMN3AtDdentjdexFpu8vjRUzV3ltcuL+kECweAUrPoHIvM4hu0Sl6b0bdvdwvzlcjrhXI5j2SCmacI5FGZohvzaNl4QTwZqqOQCRibI1auys1Z+1UgyJlm5aTlaLeRYp4knONgbEHwsxRlxcafkFSbGVp1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9U5rD0hb1Z8Ln2RGlpgoLf7gHNc6ts0MWLIZEKws//M=;
 b=RJCDJY96x5741cSfeNgNVCo3Z34R2D844AcWkmmJO2SERYO/iJr3hDN5f/PTVG6lLPTKQbc6MXtMk6yyvexDcgLC6OzTr6DaPStiWgdf1SyNb29HlhI5LvkRdaSro24HZh1+sDv37nI/bDkFGnMWvc+Rbd7bs+UqirlBSw4b7EMeFx5taxqXWGga8CP3iS7eA7B7pcvL0hF/4Zo9Q1MVkcdBe3XeC+2YYC5Duq0Nd1DcYhtn8oUJDE159i2e4rVGJlM8A7rDA4hMesp6v3JvXwHios7bqQ1lA/e9N29N95Myw0W/+/WK6OHTh6w19oDrxlRnGeg6Vu4i+kiGlJZKKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9U5rD0hb1Z8Ln2RGlpgoLf7gHNc6ts0MWLIZEKws//M=;
 b=PcKKm2ufLQwemof50mZOu3LXJrv77Qcy1W9vNU3ed3LFVeuTnzu1LOxC8HMMjsOVLGG4cDBq3/lepjR524ePlp3fs3EkFTQXKj5zm0OWVQneuuZPIN8dnbJn8qHk7X1SfAnssy5vxHStI8F5yILlCrOF6Az5Ehy+FLctFo6EwDQ=
Received: from DM6PR14CA0049.namprd14.prod.outlook.com (2603:10b6:5:18f::26)
 by CY4PR12MB1480.namprd12.prod.outlook.com (2603:10b6:910:f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Wed, 23 Feb
 2022 04:35:47 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::45) by DM6PR14CA0049.outlook.office365.com
 (2603:10b6:5:18f::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Wed, 23 Feb 2022 04:35:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Wed, 23 Feb 2022 04:35:46 +0000
Received: from sbrijesh-desktop.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 22 Feb
 2022 22:35:44 -0600
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        Peter Gonda <pgonda@google.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH] x86/mm/cpa: Generalize __set_memory_enc_pgtable()
Date:   Tue, 22 Feb 2022 22:35:28 -0600
Message-ID: <20220223043528.2093214-1-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220222185740.26228-1-kirill.shutemov@linux.intel.com>
References: <20220222185740.26228-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90a0bf09-cd3b-470e-65c1-08d9f685f601
X-MS-TrafficTypeDiagnostic: CY4PR12MB1480:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1480082EAE6D85875ECE11DBE53C9@CY4PR12MB1480.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +/IBxH6JMWh6jr29k7hPjzuPI+IDOuAqn8QIbM4JAZHgfLkS+JRGjnLM4/+4XYs1p+TdCSdETxxxUbBvPgJqHHne40ys8xCUiwiHZCxFrxoVZr55Q7SKo1fMXDpQip0DYB04+QGwX2zmAv7GAcKPhwcbjdHTavJbSjE7sf0F3lvCzGqbkhMP3EYHvCM9kwmoTWNsfBI6bewMXI+2JMoXfBDrfdl4e5ehARI2pI7UjTs40ITUReclgH8xkDkw6icsAl4oVF/aSuVKqQUIPZZ6w54gLuEkjTNHQCl2LXDy4riu9wUkcRtRbeVVqu/vHUwGYyPtY3EH6koahpwZ9JiFD96QN8CZdVG2vrvZeUq9ycfxCVcTuYR2n9K4ZUd4WNQSdcCVKBeLPS/00fDyZJTbAsnaWEanehM/MRb4ARUSQw1tAZAxfC8aJJEojqChbvoBoFmQlVKr/O5WZLjMRVYqkoPRTs/1SvRqPpEo7WDvK3amiCcP3b0uK8v2zYRjs+kyj6WR+9QrD+BpPEpmxKu1dBgwcaS0Cd8kPVUxLVpQasoecPtct8CwBsnfK0OqxhRF8FA6KHScXCXTJf6JY5Ap9PmZwF5n6vNM9GDs6mBB7m3/3k61MLSWQQK8+GM4jSOvO5jfG2Eb0XtzJTNUk5oOivzGaZcaV6kq7SbPClnywWBcoss0iK5naDCqRxsDntAhbg/WgCIDdId8P6AI1zsEb5fyLNslrrDSgcE9ZtwalYC6O7Tpo5hs2ja/iMQIDdZJxgi+X5md1LF6L8wmh4/5oYvPbF2K24o3FY9mXkvqTAU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(26005)(2906002)(4326008)(70206006)(70586007)(44832011)(356005)(81166007)(1076003)(7416002)(8936002)(8676002)(54906003)(2616005)(186003)(110136005)(316002)(36756003)(5660300002)(40460700003)(426003)(86362001)(47076005)(36860700001)(7696005)(83380400001)(82310400004)(336012)(966005)(16526019)(6666004)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 04:35:46.6912
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90a0bf09-cd3b-470e-65c1-08d9f685f601
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1480
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kernel provides infrastructure to set or clear the encryption mask
from the pages for AMD SEV, but TDX requires few tweaks.

- TDX and SEV have different requirements to the cache and tlb
  flushing.

- TDX has own routine to notify VMM about page encryption status change.

Modify __set_memory_enc_pgtable() and make it flexible enough to cover
both AMD SEV and Intel TDX. The AMD-specific behavior is isolated in
callback under x86_platform.cc. TDX will provide own version of the
callbacks.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---

Depends on Krill's CC cleanup
https://lore.kernel.org/all/20220222185740.26228-1-kirill.shutemov@linux.intel.com/

 arch/x86/include/asm/set_memory.h |  1 -
 arch/x86/include/asm/x86_init.h   | 21 +++++++++
 arch/x86/mm/mem_encrypt_amd.c     | 75 ++++++++++++++++++++++---------
 arch/x86/mm/pat/set_memory.c      | 20 +++++----
 4 files changed, 85 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index ff0f2d90338a..ce8dd215f5b3 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -84,7 +84,6 @@ int set_pages_rw(struct page *page, int numpages);
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
 bool kernel_page_present(struct page *page);
-void notify_range_enc_status_changed(unsigned long vaddr, int npages, bool enc);
 
 extern int kernel_set_to_readonly;
 
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 22b7412c08f6..dce92e2cb9e1 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -141,6 +141,26 @@ struct x86_init_acpi {
 	void (*reduced_hw_early_init)(void);
 };
 
+/**
+ * struct x86_cc_runtime - Functions used by misc guest incarnations like SEV, TDX, etc.
+ *
+ * @enc_status_change_prepare	Notify HV before the encryption status of a range
+ *				is changed.
+ *
+ * @enc_status_change_finish	Notify HV after the encryption status of a range
+ *				is changed.
+ *
+ * @enc_tlb_flush_required	Flush the TLB before changing the encryption status.
+ *
+ * @enc_cache_flush_required	Flush the caches before changing the encryption status.
+ */
+struct x86_cc_runtime {
+	void (*enc_status_change_prepare)(unsigned long vaddr, int npages, bool enc);
+	void (*enc_status_change_finish)(unsigned long vaddr, int npages, bool enc);
+	bool (*enc_tlb_flush_required)(bool enc);
+	bool (*enc_cache_flush_required)(void);
+};
+
 /**
  * struct x86_init_ops - functions for platform specific setup
  *
@@ -287,6 +307,7 @@ struct x86_platform_ops {
 	struct x86_legacy_features legacy;
 	void (*set_legacy_features)(void);
 	struct x86_hyper_runtime hyper;
+	const struct x86_cc_runtime *cc;
 };
 
 struct x86_apic_ops {
diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 2b2d018ea345..22b86af5edf1 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -177,25 +177,6 @@ void __init sme_map_bootdata(char *real_mode_data)
 	__sme_early_map_unmap_mem(__va(cmdline_paddr), COMMAND_LINE_SIZE, true);
 }
 
-void __init sme_early_init(void)
-{
-	unsigned int i;
-
-	if (!sme_me_mask)
-		return;
-
-	early_pmd_flags = __sme_set(early_pmd_flags);
-
-	__supported_pte_mask = __sme_set(__supported_pte_mask);
-
-	/* Update the protection map with memory encryption mask */
-	for (i = 0; i < ARRAY_SIZE(protection_map); i++)
-		protection_map[i] = pgprot_encrypted(protection_map[i]);
-
-	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
-		swiotlb_force = SWIOTLB_FORCE;
-}
-
 void __init sev_setup_arch(void)
 {
 	phys_addr_t total_mem = memblock_phys_mem_size();
@@ -256,7 +237,17 @@ static unsigned long pg_level_to_pfn(int level, pte_t *kpte, pgprot_t *ret_prot)
 	return pfn;
 }
 
-void notify_range_enc_status_changed(unsigned long vaddr, int npages, bool enc)
+static bool amd_enc_tlb_flush_required(bool enc)
+{
+	return true;
+}
+
+static bool amd_enc_cache_flush_required(void)
+{
+	return !this_cpu_has(X86_FEATURE_SME_COHERENT);
+}
+
+static void enc_dec_hypercall(unsigned long vaddr, int npages, bool enc)
 {
 #ifdef CONFIG_PARAVIRT
 	unsigned long sz = npages << PAGE_SHIFT;
@@ -287,6 +278,18 @@ void notify_range_enc_status_changed(unsigned long vaddr, int npages, bool enc)
 #endif
 }
 
+static void amd_enc_status_change_prepare(unsigned long vaddr, int npages, bool enc)
+{
+}
+
+static void amd_enc_status_change_finish(unsigned long vaddr, int npages, bool enc)
+{
+	if (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
+		return;
+
+	enc_dec_hypercall(vaddr, npages, enc);
+}
+
 static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
 {
 	pgprot_t old_prot, new_prot;
@@ -392,7 +395,7 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
 
 	ret = 0;
 
-	notify_range_enc_status_changed(start, PAGE_ALIGN(size) >> PAGE_SHIFT, enc);
+	early_set_mem_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_SHIFT, enc);
 out:
 	__flush_tlb_all();
 	return ret;
@@ -410,7 +413,35 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
 
 void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc)
 {
-	notify_range_enc_status_changed(vaddr, npages, enc);
+	enc_dec_hypercall(vaddr, npages, enc);
+}
+
+static const struct x86_cc_runtime amd_cc_runtime = {
+	.enc_status_change_prepare = amd_enc_status_change_prepare,
+	.enc_status_change_finish = amd_enc_status_change_finish,
+	.enc_tlb_flush_required = amd_enc_tlb_flush_required,
+	.enc_cache_flush_required = amd_enc_cache_flush_required,
+};
+
+void __init sme_early_init(void)
+{
+	unsigned int i;
+
+	if (!sme_me_mask)
+		return;
+
+	early_pmd_flags = __sme_set(early_pmd_flags);
+
+	__supported_pte_mask = __sme_set(__supported_pte_mask);
+
+	/* Update the protection map with memory encryption mask */
+	for (i = 0; i < ARRAY_SIZE(protection_map); i++)
+		protection_map[i] = pgprot_encrypted(protection_map[i]);
+
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
+		swiotlb_force = SWIOTLB_FORCE;
+
+	x86_platform.cc = &amd_cc_runtime;
 }
 
 void __init mem_encrypt_free_decrypted_mem(void)
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index af77dbfd143c..4de2a7509039 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1997,6 +1997,8 @@ static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bool enc)
 	if (WARN_ONCE(addr & ~PAGE_MASK, "misaligned address: %#lx\n", addr))
 		addr &= PAGE_MASK;
 
+	BUG_ON(!x86_platform.cc);
+
 	memset(&cpa, 0, sizeof(cpa));
 	cpa.vaddr = &addr;
 	cpa.numpages = numpages;
@@ -2008,10 +2010,12 @@ static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bool enc)
 	kmap_flush_unused();
 	vm_unmap_aliases();
 
-	/*
-	 * Before changing the encryption attribute, we need to flush caches.
-	 */
-	cpa_flush(&cpa, !this_cpu_has(X86_FEATURE_SME_COHERENT));
+	/* Flush the caches as needed before changing the encryption attribute. */
+	if (x86_platform.cc->enc_tlb_flush_required(enc))
+		cpa_flush(&cpa, x86_platform.cc->enc_cache_flush_required());
+
+	/* Notify hypervisor that we are about to set/clr encryption attribute. */
+	x86_platform.cc->enc_status_change_prepare(addr, numpages, enc);
 
 	ret = __change_page_attr_set_clr(&cpa, 1);
 
@@ -2024,11 +2028,9 @@ static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bool enc)
 	 */
 	cpa_flush(&cpa, 0);
 
-	/*
-	 * Notify hypervisor that a given memory range is mapped encrypted
-	 * or decrypted.
-	 */
-	notify_range_enc_status_changed(addr, numpages, enc);
+	/* Notify hypervisor that we have successfully set/clr encryption attribute. */
+	if (!ret)
+		x86_platform.cc->enc_status_change_finish(addr, numpages, enc);
 
 	return ret;
 }
-- 
2.25.1

