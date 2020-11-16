Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352272B5055
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgKPSxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:53:16 -0500
Received: from mail-mw2nam12on2075.outbound.protection.outlook.com ([40.107.244.75]:42560
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726136AbgKPSxQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:53:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=edMlc9eM2CovJkEiso2bfcumfPyy39Nz3CXmbM3EbBt9TBqZWtW1AJsq45fN+/taSxuQDLX8EX38v/R+JLpCdBmA7Xwo/wGxxxguoZSLWrggiBRlvIe5E0jHVbwr1teyoyU7vw7sKL11KbjJlTI5sBJcaWZyYLL8wSfKapUBeAjBKLOsT7f/ez5hX37RnrWAvkiQe5b5ooBrSKmpdF/tmqFKv1Lcv8e55/hB653SYYL968cCcO21it4cGei9so69ncGdi/0PdZ+W4dMeK/pEMwUnVRNaVe3WGFJMKzyFklNkua9Uzf3mDddGs9zBIP35iWJjV4AWM5HYXcNV5zGyBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FGQW7eMWcRAl63yyStxmlmbSiV6ZK4fIJOoXMqlgVuE=;
 b=ZxwwHkoXczQjFlMu7vUCHfu00B3Mr3zONnOlXg7lrkbZPSq8L75lyX2J4IVy+M2EOPbVi/mI2LCXanc8aNaDeqOdnDZQu0A4LqBrCZ4/0fphRENcAOmrkhxlmtspPzN9+wrCu0xxdIg9n0qvqWfN48skUMvLCqMz5WjXtQA9LNyZv9o6hcuRgh+P6xCXUs2ty9T11PFDSW/X4OnBptbiiPZkpCwtVm9NGM6ohLzgsuwzEEQNw232p9EbZl2ZuwYSg5gWYqPOxdqGV3abM8Mr3Uwoyzo5ngEzJlfxDuOMTnNSdYCaI1bhbIBddw8TUudhD4tCik9Eh4YUYv4wbjy32Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FGQW7eMWcRAl63yyStxmlmbSiV6ZK4fIJOoXMqlgVuE=;
 b=jeVjZ+O7U0PK8IkyfBu4bu7UkQ5Mtd/kodRAuc+KvJPXhF/HBo0EzocWvdOuT0ONMHMsWk+fDxWTBUf6CGfzwFG5bSK37DGV//Ax9fMHtzMikuBY0pdmPLh+fPtcR/KdzelzOOjUm88bCw9JQdPKcQ70fS5syXno6wKkUYf4lxs=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Mon, 16 Nov
 2020 18:53:13 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3541.025; Mon, 16 Nov 2020
 18:53:13 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     qemu-devel@nongnu.org, rth@twiddle.net, armbru@redhat.com,
        dgilbert@redhat.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, marcel.apfelbaum@gmail.com, mtosatti@redhat.com,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        ssg.sos.patches@amd.com
Subject: [PATCH 11/11] target/i386: clear C-bit when walking SEV guest page table
Date:   Mon, 16 Nov 2020 18:53:02 +0000
Message-Id: <82ab6378638ce00118bff1c006bd346be598caec.1605316268.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605316268.git.ashish.kalra@amd.com>
References: <cover.1605316268.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR06CA0030.namprd06.prod.outlook.com
 (2603:10b6:5:120::43) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM6PR06CA0030.namprd06.prod.outlook.com (2603:10b6:5:120::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Mon, 16 Nov 2020 18:53:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a79cfd89-ac0f-460f-d47e-08d88a60deac
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4557FE7C2A075241003395088EE30@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X3gy4fdc8R01KEDDui0ypgJuygXuFOXaUERJ9zlfEtGNO099aaNdFgRrng+2BD+vVdH+sEjQiJeK6/3dahYrE/Wxsp0xBMw6QFoeTdNC4UEk4zrgpvHsNIIZihXI6pBa5vbV8K719Cay0CPHTEaGD81SaBodVJg9NKPZSL/v6czoy6MO+DkTu+BoyP4b5EzF4b4MsBICbVfpzD76iToIiKVClbXqfMCfS7ISA9giU2iDSdA/Y169Ng2j8SojfGpDqlbtn2YbliREnWNyprDtMOPQ7pq1gTEZ0eEcTAFMyYsGkiO3+HQYLqrIJbOyAyE7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(66946007)(36756003)(86362001)(2616005)(956004)(8936002)(30864003)(83380400001)(66476007)(66556008)(5660300002)(6666004)(2906002)(6486002)(478600001)(7696005)(8676002)(6916009)(16526019)(186003)(26005)(52116002)(316002)(7416002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xgPHY3cN2q9jgNw48iRwD+ziTp4cyuu4L4caLGyv5emzICAzTndBRF3pUpYGtyfB9c+XWZN/k9D3SsINDPaEmWqb0pnQNZqPWNNYI7M4zKgtuhGB9+8+/4HrOnQLPyMPane4vlf2F0uPyieQD8N66C4p6/7SPOSlUN9ps3laEk4ZO6DdCb4WFfa6qvkfauqGXIfhNDrGTax9GWo0PuoHDQ2fTGYgWhvdpY+iY/dOjiAkhTTaprvrTe927Nn2RYccXQXxKb3CaJE8w5xYVXtURTKISClwXN0JmYfkH8IGAaHDvPCNj046iBDgarv92UL2wKZhzTqJLjJQYcmC154yUjGGNRAdP37L0QZy8auZaMkcObm1+bSCDzWN4kJEzrkWcfnCXBsGXhcoz7UPOW/obTy3i8IngNOp0ZV+vbbsD2wngAGgZlkrflPVWKZtS5eykA/OXljaThZ/o+oszy4CTzkCWcg218U717miewa7oP/8mdWkyPdj8jkKeVUx7KBAe3iMt/vHWeIqXy70CyHiTejrsmVnrjWtnAYcxLJfxDKwWjhwB1Qr1IJSKF15GWcX8I/0g7mRueqIIbSJ42HnDHFmvkbwxkgvSbB0i964aZaO1X/hdBhFeWfg2iAClbhytdhCnH/pUAfYmV+XZPcDnu+ssPvcNHGw437HawEfE8PVvzP6W9nr0oUeb/59yUnssX4jNmKDTqQQqTD2cfjpHrOxNQvnE9dpkJo7pkQbRYDF32gg8OpO6eCV83rIdQ5u/sUKLsikh1yfa99UFNPl1AFmOAT+DIuHp/ihX3hdjsqT2BzMIq1bNf19ZivoWR6j6ohmObFtDK6EvACcnPiplnk5j56L0XX9/mHcPz+4QSiih6IGg82cWwzFj7J7sLOOEPaOL1pbGfTeElmC1x1t/w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a79cfd89-ac0f-460f-d47e-08d88a60deac
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2020 18:53:13.2725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +MzcMe2PuLSFC2czRN0/LkmtIORiahutx/07mUwpRKhiN7dfaTDd4D7f23Ys9iLQKSdHFStuQaA3cXs06w2DvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

In SEV-enabled guest the pte entry will have C-bit set, we need to clear
the C-bit when walking the page table.

This ensures that the proper page address translation occurs and, with the
C-bit reset, the true physical address is got.

The pte_mask to be used during guest page table walk is added as a
vendor specific assist/hook as part of the new MemoryDebugOps and
available via the new debug API interface cpu_physical_memory_pte_mask_debug().

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 include/exec/cpu-common.h |  3 ++
 include/exec/memory.h     |  1 +
 softmmu/physmem.c         | 13 +++++++-
 target/i386/monitor.c     | 70 +++++++++++++++++++++++++--------------
 target/i386/sev.c         |  3 +-
 5 files changed, 63 insertions(+), 27 deletions(-)

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index d2089e6873..3374573d39 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -96,6 +96,9 @@ static inline void cpu_physical_memory_write(hwaddr addr,
 {
     cpu_physical_memory_rw(addr, (void *)buf, len, true);
 }
+
+uint64_t cpu_physical_memory_pte_mask_debug(void);
+
 void *cpu_physical_memory_map(hwaddr addr,
                               hwaddr *plen,
                               bool is_write);
diff --git a/include/exec/memory.h b/include/exec/memory.h
index 74f2dcec00..ebe8ffc1eb 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -2428,6 +2428,7 @@ typedef struct MemoryDebugOps {
     MemTxResult (*write)(AddressSpace *as, hwaddr phys_addr,
                          MemTxAttrs attrs, const void *buf,
                          hwaddr len);
+    uint64_t (*pte_mask)(void);
 } MemoryDebugOps;
 
 void address_space_set_debug_ops(const MemoryDebugOps *ops);
diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index 6945bd5efe..fc6b5588fc 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -166,9 +166,15 @@ struct DirtyBitmapSnapshot {
     unsigned long dirty[];
 };
 
+static uint64_t address_space_pte_mask(void)
+{
+    return ~0;
+}
+
 static const MemoryDebugOps default_debug_ops = {
     .read = address_space_read,
-    .write = address_space_write_rom
+    .write = address_space_write_rom,
+    .pte_mask = address_space_pte_mask
 };
 
 static const MemoryDebugOps *debug_ops = &default_debug_ops;
@@ -3401,6 +3407,11 @@ void cpu_physical_memory_rw_debug(hwaddr addr, uint8_t *buf,
 
 }
 
+uint64_t cpu_physical_memory_pte_mask_debug(void)
+{
+    return debug_ops->pte_mask();
+}
+
 int64_t address_space_cache_init(MemoryRegionCache *cache,
                                  AddressSpace *as,
                                  hwaddr addr,
diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index 9ca9c677a5..c73cac04cb 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -106,16 +106,20 @@ static void tlb_info_pae32(Monitor *mon, CPUArchState *env)
     unsigned int l1, l2, l3;
     uint64_t pdpe, pde, pte;
     uint64_t pdp_addr, pd_addr, pt_addr;
+    uint64_t me_mask;
+
+    me_mask = cpu_physical_memory_pte_mask_debug();
 
     pdp_addr = env->cr[3] & ~0x1f;
+    pdp_addr &= me_mask;
     for (l1 = 0; l1 < 4; l1++) {
         cpu_physical_memory_read_debug(pdp_addr + l1 * 8, &pdpe, 8);
-        pdpe = le64_to_cpu(pdpe);
+        pdpe = le64_to_cpu(pdpe & me_mask);
         if (pdpe & PG_PRESENT_MASK) {
             pd_addr = pdpe & 0x3fffffffff000ULL;
             for (l2 = 0; l2 < 512; l2++) {
                 cpu_physical_memory_read_debug(pd_addr + l2 * 8, &pde, 8);
-                pde = le64_to_cpu(pde);
+                pde = le64_to_cpu(pde & me_mask);
                 if (pde & PG_PRESENT_MASK) {
                     if (pde & PG_PSE_MASK) {
                         /* 2M pages with PAE, CR4.PSE is ignored */
@@ -126,7 +130,7 @@ static void tlb_info_pae32(Monitor *mon, CPUArchState *env)
                         for (l3 = 0; l3 < 512; l3++) {
                             cpu_physical_memory_read_debug(pt_addr + l3 * 8,
                                                            &pte, 8);
-                            pte = le64_to_cpu(pte);
+                            pte = le64_to_cpu(pte & me_mask);
                             if (pte & PG_PRESENT_MASK) {
                                 print_pte(mon, env, (l1 << 30) + (l2 << 21)
                                           + (l3 << 12),
@@ -148,10 +152,13 @@ static void tlb_info_la48(Monitor *mon, CPUArchState *env,
     uint64_t l1, l2, l3, l4;
     uint64_t pml4e, pdpe, pde, pte;
     uint64_t pdp_addr, pd_addr, pt_addr;
+    uint64_t me_mask;
+
+    me_mask = cpu_physical_memory_pte_mask_debug();
 
     for (l1 = 0; l1 < 512; l1++) {
         cpu_physical_memory_read_debug(pml4_addr + l1 * 8, &pml4e, 8);
-        pml4e = le64_to_cpu(pml4e);
+        pml4e = le64_to_cpu(pml4e & me_mask);
         if (!(pml4e & PG_PRESENT_MASK)) {
             continue;
         }
@@ -159,7 +166,7 @@ static void tlb_info_la48(Monitor *mon, CPUArchState *env,
         pdp_addr = pml4e & 0x3fffffffff000ULL;
         for (l2 = 0; l2 < 512; l2++) {
             cpu_physical_memory_read_debug(pdp_addr + l2 * 8, &pdpe, 8);
-            pdpe = le64_to_cpu(pdpe);
+            pdpe = le64_to_cpu(pdpe & me_mask);
             if (!(pdpe & PG_PRESENT_MASK)) {
                 continue;
             }
@@ -174,7 +181,7 @@ static void tlb_info_la48(Monitor *mon, CPUArchState *env,
             pd_addr = pdpe & 0x3fffffffff000ULL;
             for (l3 = 0; l3 < 512; l3++) {
                 cpu_physical_memory_read_debug(pd_addr + l3 * 8, &pde, 8);
-                pde = le64_to_cpu(pde);
+                pde = le64_to_cpu(pde & me_mask);
                 if (!(pde & PG_PRESENT_MASK)) {
                     continue;
                 }
@@ -191,7 +198,7 @@ static void tlb_info_la48(Monitor *mon, CPUArchState *env,
                     cpu_physical_memory_read_debug(pt_addr
                             + l4 * 8,
                             &pte, 8);
-                    pte = le64_to_cpu(pte);
+                    pte = le64_to_cpu(pte & me_mask);
                     if (pte & PG_PRESENT_MASK) {
                         print_pte(mon, env, (l0 << 48) + (l1 << 39) +
                                 (l2 << 30) + (l3 << 21) + (l4 << 12),
@@ -208,13 +215,17 @@ static void tlb_info_la57(Monitor *mon, CPUArchState *env)
     uint64_t l0;
     uint64_t pml5e;
     uint64_t pml5_addr;
+    uint64_t me_mask;
 
-    pml5_addr = env->cr[3] & 0x3fffffffff000ULL;
+    me_mask = cpu_physical_memory_pte_mask_debug();
+
+    pml5_addr = env->cr[3] & 0x3fffffffff000ULL & me_mask;
     for (l0 = 0; l0 < 512; l0++) {
         cpu_physical_memory_read_debug(pml5_addr + l0 * 8, &pml5e, 8);
-        pml5e = le64_to_cpu(pml5e);
+        pml5e = le64_to_cpu(pml5e & me_mask);
         if (pml5e & PG_PRESENT_MASK) {
-            tlb_info_la48(mon, env, l0, pml5e & 0x3fffffffff000ULL);
+            tlb_info_la48(mon, env, l0, pml5e & 0x3fffffffff000ULL &
+                          cpu_physical_memory_pte_mask_debug());
         }
     }
 }
@@ -326,19 +337,22 @@ static void mem_info_pae32(Monitor *mon, CPUArchState *env)
     uint64_t pdpe, pde, pte;
     uint64_t pdp_addr, pd_addr, pt_addr;
     hwaddr start, end;
+    uint64_t me_mask;
 
-    pdp_addr = env->cr[3] & ~0x1f;
+    me_mask = cpu_physical_memory_pte_mask_debug();
+
+    pdp_addr = env->cr[3] & ~0x1f & me_mask;
     last_prot = 0;
     start = -1;
     for (l1 = 0; l1 < 4; l1++) {
         cpu_physical_memory_read_debug(pdp_addr + l1 * 8, &pdpe, 8);
-        pdpe = le64_to_cpu(pdpe);
+        pdpe = le64_to_cpu(pdpe & me_mask);
         end = l1 << 30;
         if (pdpe & PG_PRESENT_MASK) {
             pd_addr = pdpe & 0x3fffffffff000ULL;
             for (l2 = 0; l2 < 512; l2++) {
                 cpu_physical_memory_read_debug(pd_addr + l2 * 8, &pde, 8);
-                pde = le64_to_cpu(pde);
+                pde = le64_to_cpu(pde & me_mask);
                 end = (l1 << 30) + (l2 << 21);
                 if (pde & PG_PRESENT_MASK) {
                     if (pde & PG_PSE_MASK) {
@@ -350,7 +364,7 @@ static void mem_info_pae32(Monitor *mon, CPUArchState *env)
                         for (l3 = 0; l3 < 512; l3++) {
                             cpu_physical_memory_read_debug(pt_addr + l3 * 8,
                                                            &pte, 8);
-                            pte = le64_to_cpu(pte);
+                            pte = le64_to_cpu(pte & me_mask);
                             end = (l1 << 30) + (l2 << 21) + (l3 << 12);
                             if (pte & PG_PRESENT_MASK) {
                                 prot = pte & pde & (PG_USER_MASK | PG_RW_MASK |
@@ -383,19 +397,22 @@ static void mem_info_la48(Monitor *mon, CPUArchState *env)
     uint64_t l1, l2, l3, l4;
     uint64_t pml4e, pdpe, pde, pte;
     uint64_t pml4_addr, pdp_addr, pd_addr, pt_addr, start, end;
+    uint64_t me_mask;
+
+    me_mask = cpu_physical_memory_pte_mask_debug();
 
-    pml4_addr = env->cr[3] & 0x3fffffffff000ULL;
+    pml4_addr = env->cr[3] & 0x3fffffffff000ULL & me_mask;
     last_prot = 0;
     start = -1;
     for (l1 = 0; l1 < 512; l1++) {
         cpu_physical_memory_read_debug(pml4_addr + l1 * 8, &pml4e, 8);
-        pml4e = le64_to_cpu(pml4e);
+        pml4e = le64_to_cpu(pml4e & me_mask);
         end = l1 << 39;
         if (pml4e & PG_PRESENT_MASK) {
             pdp_addr = pml4e & 0x3fffffffff000ULL;
             for (l2 = 0; l2 < 512; l2++) {
                 cpu_physical_memory_read_debug(pdp_addr + l2 * 8, &pdpe, 8);
-                pdpe = le64_to_cpu(pdpe);
+                pdpe = le64_to_cpu(pdpe & me_mask);
                 end = (l1 << 39) + (l2 << 30);
                 if (pdpe & PG_PRESENT_MASK) {
                     if (pdpe & PG_PSE_MASK) {
@@ -408,7 +425,7 @@ static void mem_info_la48(Monitor *mon, CPUArchState *env)
                         for (l3 = 0; l3 < 512; l3++) {
                             cpu_physical_memory_read_debug(pd_addr + l3 * 8,
                                                            &pde, 8);
-                            pde = le64_to_cpu(pde);
+                            pde = le64_to_cpu(pde & me_mask);
                             end = (l1 << 39) + (l2 << 30) + (l3 << 21);
                             if (pde & PG_PRESENT_MASK) {
                                 if (pde & PG_PSE_MASK) {
@@ -423,7 +440,7 @@ static void mem_info_la48(Monitor *mon, CPUArchState *env)
                                         cpu_physical_memory_read_debug(pt_addr
                                                                  + l4 * 8,
                                                                  &pte, 8);
-                                        pte = le64_to_cpu(pte);
+                                        pte = le64_to_cpu(pte & me_mask);
                                         end = (l1 << 39) + (l2 << 30) +
                                             (l3 << 21) + (l4 << 12);
                                         if (pte & PG_PRESENT_MASK) {
@@ -464,13 +481,16 @@ static void mem_info_la57(Monitor *mon, CPUArchState *env)
     uint64_t l0, l1, l2, l3, l4;
     uint64_t pml5e, pml4e, pdpe, pde, pte;
     uint64_t pml5_addr, pml4_addr, pdp_addr, pd_addr, pt_addr, start, end;
+    uint64_t me_mask;
+
+    me_mask = cpu_physical_memory_pte_mask_debug();
 
-    pml5_addr = env->cr[3] & 0x3fffffffff000ULL;
+    pml5_addr = env->cr[3] & 0x3fffffffff000ULL & me_mask;
     last_prot = 0;
     start = -1;
     for (l0 = 0; l0 < 512; l0++) {
         cpu_physical_memory_read_debug(pml5_addr + l0 * 8, &pml5e, 8);
-        pml5e = le64_to_cpu(pml5e);
+        pml5e = le64_to_cpu(pml5e & me_mask);
         end = l0 << 48;
         if (!(pml5e & PG_PRESENT_MASK)) {
             prot = 0;
@@ -481,7 +501,7 @@ static void mem_info_la57(Monitor *mon, CPUArchState *env)
         pml4_addr = pml5e & 0x3fffffffff000ULL;
         for (l1 = 0; l1 < 512; l1++) {
             cpu_physical_memory_read_debug(pml4_addr + l1 * 8, &pml4e, 8);
-            pml4e = le64_to_cpu(pml4e);
+            pml4e = le64_to_cpu(pml4e & me_mask);
             end = (l0 << 48) + (l1 << 39);
             if (!(pml4e & PG_PRESENT_MASK)) {
                 prot = 0;
@@ -492,7 +512,7 @@ static void mem_info_la57(Monitor *mon, CPUArchState *env)
             pdp_addr = pml4e & 0x3fffffffff000ULL;
             for (l2 = 0; l2 < 512; l2++) {
                 cpu_physical_memory_read_debug(pdp_addr + l2 * 8, &pdpe, 8);
-                pdpe = le64_to_cpu(pdpe);
+                pdpe = le64_to_cpu(pdpe & me_mask);
                 end = (l0 << 48) + (l1 << 39) + (l2 << 30);
                 if (pdpe & PG_PRESENT_MASK) {
                     prot = 0;
@@ -511,7 +531,7 @@ static void mem_info_la57(Monitor *mon, CPUArchState *env)
                 pd_addr = pdpe & 0x3fffffffff000ULL;
                 for (l3 = 0; l3 < 512; l3++) {
                     cpu_physical_memory_read_debug(pd_addr + l3 * 8, &pde, 8);
-                    pde = le64_to_cpu(pde);
+                    pde = le64_to_cpu(pde & me_mask);
                     end = (l0 << 48) + (l1 << 39) + (l2 << 30) + (l3 << 21);
                     if (pde & PG_PRESENT_MASK) {
                         prot = 0;
@@ -531,7 +551,7 @@ static void mem_info_la57(Monitor *mon, CPUArchState *env)
                     for (l4 = 0; l4 < 512; l4++) {
                         cpu_physical_memory_read_debug(pt_addr + l4 * 8,
                                                        &pte, 8);
-                        pte = le64_to_cpu(pte);
+                        pte = le64_to_cpu(pte & me_mask);
                         end = (l0 << 48) + (l1 << 39) + (l2 << 30) +
                             (l3 << 21) + (l4 << 12);
                         if (pte & PG_PRESENT_MASK) {
diff --git a/target/i386/sev.c b/target/i386/sev.c
index b942593bc8..97726a639f 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1003,7 +1003,8 @@ MemTxResult sev_address_space_read_debug(AddressSpace *as, hwaddr addr,
 
 static const MemoryDebugOps sev_debug_ops = {
     .read = sev_address_space_read_debug,
-    .write = sev_address_space_write_rom_debug
+    .write = sev_address_space_write_rom_debug,
+    .pte_mask = sev_get_me_mask,
 };
 
 void
-- 
2.17.1

