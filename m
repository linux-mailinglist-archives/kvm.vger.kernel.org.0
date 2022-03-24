Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0204E5E2C
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 06:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347733AbiCXFeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 01:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347330AbiCXFeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 01:34:14 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2057.outbound.protection.outlook.com [40.107.212.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C87395489
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 22:32:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RAru+vwqDB99dpqn3zdFxGB8n/T5e2ajY9mVIVfPhGZbZ+mGKRoa11zcjth5Fj2+C19Wlz6MscVXhJvrxfx98Xyt1jgF2rMarSnRn96sVv/RoG33DIdzhZKJX1BsYlUtpX8rm0iqa+piASZtvTQwsszm69chcfGJcv+QX4EvgWk6c3LkKWr6pGXA9wAQTifAR/CmRpLWcHrAVy13MjvUPcmPc49fXbYmN4GwnJovHkrZgoEbGFTTZarPGyqoD/tMVYrc/Sdyu7qXe2uY2UZqsHU3UH/EiB5u1RO2efXkHVq/WlnuPAROLk4nJ9k5B/O8AvsYrV118ScqUVPLWzj32Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vuufgxs1vDeJsyIwm5XCLXd3wBpdXqepFfr/JY6fVos=;
 b=T3HNPEgd4ap6jf0lTghZVfsWJpQGHfgLY6PqACvmZTRbyKlu8Qm2HCH8VFsSI3nRNH1odvv56sN/Rqfh+8efvMYrVgmhCxC7q1XJfh5g6mo++vAUgRDpdMKZX5Mdtg/5sFLcR2fI0RD0X7OAuerjmhnI56NdAC6UkTt3l6NVgi2d6WfOvuDlgtZWct2xXlg7tE9WO+Wj3pvCUwSvFOGOu6/A4g8wqe7SNxNhOHUc55cOHZ1MzuZ04HsehfCbGt80MjTAbbA2RoOYEo82CkD80EMgVdrFkvLjifDIs6qzxiD+uDVelxbolAWdfMgR3LcD3TF0vSv3st/nFg9RVoxkRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuufgxs1vDeJsyIwm5XCLXd3wBpdXqepFfr/JY6fVos=;
 b=cjSzTa8R+uqk40p3Hr6AiFSRTMtjsm/1ho7a1uatXLOPVrncvBTqQ6ym3wPz/1WX3mqinQytB8zr2jUPnRZKawyfUFmTshUPD+PxQQe3l7oOVQgSXylfV1XffUaOok/7Sh7yzFrnz6aRvd/EhqWwB46ZmB+gr9HGt1AoPBFnq4w=
Received: from MWHPR04CA0029.namprd04.prod.outlook.com (2603:10b6:300:ee::15)
 by BL0PR12MB4722.namprd12.prod.outlook.com (2603:10b6:208:8c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Thu, 24 Mar
 2022 05:32:41 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ee:cafe::9f) by MWHPR04CA0029.outlook.office365.com
 (2603:10b6:300:ee::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17 via Frontend
 Transport; Thu, 24 Mar 2022 05:32:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5102.17 via Frontend Transport; Thu, 24 Mar 2022 05:32:40 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 24 Mar
 2022 00:32:37 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v2 4/4] x86: nSVM: Build up the nested page table dynamically
Date:   Thu, 24 Mar 2022 05:30:46 +0000
Message-ID: <20220324053046.200556-5-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220324053046.200556-1-manali.shukla@amd.com>
References: <20220324053046.200556-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ac110ee-f8fa-4f6c-bc34-08da0d57b6dc
X-MS-TrafficTypeDiagnostic: BL0PR12MB4722:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB47226B06D67FAFAB278EDC3FFD199@BL0PR12MB4722.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S6AkyOdbniDtAe+AyIvf2GHnDGE9eWXk9vxWMR7Py167+5OtbS2DOyqS+fgMzhv2ZD3x9ZZS+II5G80E7pgF13VzfRZ/RIGHBnxC0tcmpVXQWv5jebtBeuow8opAjST8ptfzOvSb/tgN03eIwfTHRvbl8xduzHTOz1L53wamgk2XZ54ijdvv4Powze3FijBqiHqBxU7UHXHkOfOkWqUKof3bqG4lK5rDJBJz7d+pk9MqVTJOJmC1FOtkPgLbqDkoUqqFUg7lGi1LX0dvRsn8CRkd9G5CqykjcRXh1n1oZhclRPm5CPpi0s2tMpAYEc8xQ1se9FbILvJw6KEHkf7Dbt/XnSsqCuvmjvxt/fMZiFJyjKL/CHOcQTPdiBD2MrCf3SVi3fUNDR6CnDROCBP8NYLC0Ce0/pi8YFsc4Gr31euluMtmnVbS8SC1NLz5xOpTSwtY0a5VwajIQ4uVK/klLql0IpGAJV6RysmKyr9qmesK9MeEOCJwTDwD8fvYAIb1RxZVFkvWVpUkK49Z3bfLx/d2nYvjJN+UZJgXXIk7ykf8z/t3T/dxg6AgffOQ7fGdjeK8IH3fAOfPVmuiq/xwTs+B64Dzk5f+3hK8o8p6TFZixlsQz70A9O4JkTDAgIBMDXxg9+/ruxdgtLsNeznKE49ZgZeRV9gMel6+M2zzTjX2ydEr7A2hbet7bSmosw9wAEhO6uimYZeptOmlv4UegQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(16526019)(508600001)(6666004)(82310400004)(426003)(8936002)(336012)(186003)(26005)(316002)(110136005)(2906002)(8676002)(36860700001)(81166007)(47076005)(1076003)(356005)(5660300002)(44832011)(86362001)(40460700003)(36756003)(4326008)(83380400001)(7696005)(2616005)(70586007)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 05:32:40.5550
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ac110ee-f8fa-4f6c-bc34-08da0d57b6dc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4722
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current implementation of nested page table does the page
table build up statistically with 2048 PTEs and one pml4 entry.
That is why current implementation is not extensible.

New implementation does page table build up dynamically based
on the RAM size of the VM which enables us to have separate
memory range to test various npt test cases.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm.c     | 163 ++++++++++++++++++++++++++++++++++----------------
 x86/svm.h     |  17 +++++-
 x86/svm_npt.c |   4 +-
 3 files changed, 130 insertions(+), 54 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index d0d523a..67dbe31 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -8,6 +8,7 @@
 #include "desc.h"
 #include "msr.h"
 #include "vm.h"
+#include "fwcfg.h"
 #include "smp.h"
 #include "types.h"
 #include "alloc_page.h"
@@ -16,38 +17,67 @@
 #include "vmalloc.h"
 
 /* for the nested page table*/
-u64 *pte[2048];
-u64 *pde[4];
-u64 *pdpe;
 u64 *pml4e;
 
 struct vmcb *vmcb;
 
-u64 *npt_get_pte(u64 address)
+u64* get_npt_pte(u64 *pml4, u64 guest_addr, int level)
 {
-	int i1, i2;
+    int l;
+    u64 *pt = pml4, iter_pte;
+    unsigned offset;
+
+    assert(level >= 1 && level <= 4);
+
+    for(l = NPT_PAGE_LEVEL; ; --l) {
+        offset = (guest_addr >> (((l - 1) * NPT_PGDIR_WIDTH) + 12))
+                 & NPT_PGDIR_MASK;
+        iter_pte = pt[offset];
+        if (l == level)
+            break;
+        if (!(iter_pte & NPT_PRESENT))
+            return false;
+        pt = (u64*)(iter_pte & PT_ADDR_MASK);
+    }
+    offset = (guest_addr >> (((l - 1) * NPT_PGDIR_WIDTH) + 12))
+             & NPT_PGDIR_MASK;
+    return  &pt[offset];
+}
 
-	address >>= 12;
-	i1 = (address >> 9) & 0x7ff;
-	i2 = address & 0x1ff;
+void set_npt_pte(u64 *pml4, u64 guest_addr,
+        int level, u64  pte_val)
+{
+    int l;
+    unsigned long *pt = pml4;
+    unsigned offset;
+
+    for (l = NPT_PAGE_LEVEL; ; --l) {
+        offset = (guest_addr >> (((l - 1) * NPT_PGDIR_WIDTH) + 12))
+                 & NPT_PGDIR_MASK;
+        if (l == level)
+            break;
+        if (!(pt[offset] & NPT_PRESENT))
+            return;
+        pt = (u64*)(pt[offset] & PT_ADDR_MASK);
+    }
+    offset = (guest_addr >> (((l - 1) * NPT_PGDIR_WIDTH) + 12))
+              & NPT_PGDIR_MASK;
+    pt[offset] = pte_val;
+}
 
-	return &pte[i1][i2];
+u64 *npt_get_pte(u64 address)
+{
+    return get_npt_pte(npt_get_pml4e(), address, 1);
 }
 
 u64 *npt_get_pde(u64 address)
 {
-	int i1, i2;
-
-	address >>= 21;
-	i1 = (address >> 9) & 0x3;
-	i2 = address & 0x1ff;
-
-	return &pde[i1][i2];
+    return get_npt_pte(npt_get_pml4e(), address, 2);
 }
 
-u64 *npt_get_pdpe(void)
+u64 *npt_get_pdpe(u64 address)
 {
-	return pdpe;
+	return get_npt_pte(npt_get_pml4e(), address, 3);
 }
 
 u64 *npt_get_pml4e(void)
@@ -309,11 +339,72 @@ static void set_additional_vcpu_msr(void *msr_efer)
 	wrmsr(MSR_EFER, (ulong)msr_efer | EFER_SVME);
 }
 
+static void install_npt_entry(u64 *pml4,
+        int pte_level,
+        u64 guest_addr,
+        u64 pte,
+        u64 *pt_page)
+{
+    int level;
+    unsigned long *pt = pml4;
+    unsigned offset;
+
+    for (level = NPT_PAGE_LEVEL; level > pte_level; --level) {
+        offset = (guest_addr >> (((level - 1) * NPT_PGDIR_WIDTH) + 12))
+                  & NPT_PGDIR_MASK;
+        if (!(pt[offset] & PT_PRESENT_MASK)) {
+            unsigned long *new_pt = pt_page;
+            if (!new_pt) {
+                new_pt = alloc_page();
+            } else
+                pt_page = 0;
+            memset(new_pt, 0, PAGE_SIZE);
+
+            pt[offset] = virt_to_phys(new_pt) | NPT_USER_ACCESS |
+                         NPT_ACCESS_BIT | NPT_PRESENT | NPT_RW_ACCESS;
+        }
+        pt = phys_to_virt(pt[offset] & PT_ADDR_MASK);
+    }
+    offset = (guest_addr >> (((level - 1) * NPT_PGDIR_WIDTH) + 12))
+              & NPT_PGDIR_MASK;
+    pt[offset] = pte | NPT_USER_ACCESS | NPT_ACCESS_BIT | NPT_DIRTY_BIT;
+}
+
+void install_npt(u64 *pml4, u64 phys, u64 guest_addr,
+        u64 perm)
+{
+    install_npt_entry(pml4, 1, guest_addr,
+            (phys & PAGE_MASK) | perm, 0);
+}
+
+static void setup_npt_range(u64 *pml4, u64 start,
+        u64 len, u64 perm)
+{
+    u64 phys = start;
+    u64 max = (u64)len + (u64)start;
+
+    while (phys + PAGE_SIZE <= max) {
+        install_npt(pml4, phys, phys, perm);
+        phys += PAGE_SIZE;
+    }
+}
+
+void setup_npt(void) {
+    u64 end_of_memory;
+    pml4e = alloc_page();
+
+    end_of_memory = fwcfg_get_u64(FW_CFG_RAM_SIZE);
+    if (end_of_memory < (1ul << 32))
+        end_of_memory = (1ul << 32);
+
+    setup_npt_range(pml4e, 0, end_of_memory,
+            NPT_PRESENT | NPT_RW_ACCESS);
+}
+
 static void setup_svm(void)
 {
 	void *hsave = alloc_page();
-	u64 *page, address;
-	int i,j;
+    int i;
 
 	wrmsr(MSR_VM_HSAVE_PA, virt_to_phys(hsave));
 	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SVME);
@@ -335,37 +426,7 @@ static void setup_svm(void)
 	* Build the page-table bottom-up and map everything with 4k
 	* pages to get enough granularity for the NPT unit-tests.
 	*/
-
-	address = 0;
-
-	/* PTE level */
-	for (i = 0; i < 2048; ++i) {
-		page = alloc_page();
-
-		for (j = 0; j < 512; ++j, address += 4096)
-	    		page[j] = address | 0x067ULL;
-
-		pte[i] = page;
-	}
-
-	/* PDE level */
-	for (i = 0; i < 4; ++i) {
-		page = alloc_page();
-
-	for (j = 0; j < 512; ++j)
-	    page[j] = (u64)pte[(i * 512) + j] | 0x027ULL;
-
-		pde[i] = page;
-	}
-
-	/* PDPe level */
-	pdpe   = alloc_page();
-	for (i = 0; i < 4; ++i)
-		pdpe[i] = ((u64)(pde[i])) | 0x27;
-
-	/* PML4e level */
-	pml4e    = alloc_page();
-	pml4e[0] = ((u64)pdpe) | 0x27;
+    setup_npt();
 }
 
 int matched;
diff --git a/x86/svm.h b/x86/svm.h
index 9ab3aa5..7815f56 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -147,6 +147,17 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_VM_CR_SVM_LOCK_MASK 0x0008ULL
 #define SVM_VM_CR_SVM_DIS_MASK  0x0010ULL
 
+#define NPT_PAGE_LEVEL      4
+#define NPT_PGDIR_WIDTH     9
+#define NPT_PGDIR_MASK      511
+
+#define NPT_PRESENT         (1ul << 0)
+#define NPT_RW_ACCESS       (1ul << 1)
+#define NPT_USER_ACCESS     (1ul << 2)
+#define NPT_ACCESS_BIT      (1ul << 5)
+#define NPT_DIRTY_BIT       (1ul << 6)
+#define NPT_NX_ACCESS       (1ul << 63)
+
 struct __attribute__ ((__packed__)) vmcb_seg {
 	u16 selector;
 	u16 attrib;
@@ -401,7 +412,7 @@ typedef void (*test_guest_func)(struct svm_test *);
 int run_svm_tests(int ac, char **av);
 u64 *npt_get_pte(u64 address);
 u64 *npt_get_pde(u64 address);
-u64 *npt_get_pdpe(void);
+u64 *npt_get_pdpe(u64 address);
 u64 *npt_get_pml4e(void);
 bool smp_supported(void);
 bool default_supported(void);
@@ -418,7 +429,11 @@ struct regs get_regs(void);
 void vmmcall(void);
 int __svm_vmrun(u64 rip);
 int svm_vmrun(void);
+void setup_npt(void);
 void test_set_guest(test_guest_func func);
+void install_npt(u64 *pml4, u64 phys, u64 guest_addr, u64 perm);
+u64* get_npt_pte(u64 *pml4, u64 guest_addr, int level);
+void set_npt_pte(u64 *pml4, u64 guest_addr, int level, u64  pte_val);
 
 extern struct vmcb *vmcb;
 extern struct svm_test svm_tests[];
diff --git a/x86/svm_npt.c b/x86/svm_npt.c
index 4f80d9a..4f95ae0 100644
--- a/x86/svm_npt.c
+++ b/x86/svm_npt.c
@@ -208,7 +208,7 @@ static void __svm_npt_rsvd_bits_test(u64 *pxe, u64 rsvd_bits, u64 efer,
     report(exit_reason == SVM_EXIT_NPF,
            "Wanted #NPF on rsvd bits = 0x%lx, got exit = 0x%x", rsvd_bits, exit_reason);
 
-    if (pxe == npt_get_pdpe() || pxe == npt_get_pml4e()) {
+    if (pxe == npt_get_pdpe((u64)basic_guest_main) || pxe == npt_get_pml4e()) {
         /*
          * The guest's page tables will blow up on a bad PDPE/PML4E,
          * before starting the final walk of the guest page.
@@ -336,7 +336,7 @@ skip_pte_test:
                 get_random_bits(20, 13) | PT_PAGE_SIZE_MASK,
                 host_efer, host_cr4, guest_efer, guest_cr4);
 
-    _svm_npt_rsvd_bits_test(npt_get_pdpe(),
+    _svm_npt_rsvd_bits_test(npt_get_pdpe((u64)basic_guest_main),
                 PT_PAGE_SIZE_MASK |
                     (this_cpu_has(X86_FEATURE_GBPAGES) ? get_random_bits(29, 13) : 0),
                 host_efer, host_cr4, guest_efer, guest_cr4);
-- 
2.30.2

