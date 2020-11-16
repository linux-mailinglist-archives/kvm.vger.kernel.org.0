Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3BD2B5036
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgKPSvw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:51:52 -0500
Received: from mail-mw2nam12on2080.outbound.protection.outlook.com ([40.107.244.80]:38048
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726735AbgKPSvv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:51:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P1DovjjZQigZ14JGQ9UEEHNQS8NcIGVXwVgNZLkX4yP+NCD+c8z8qtFfWAg5oWChbnxphyjd84+g41GCr3T4ujtZIFkOkUM6XWC+bsdEeFe7fe5ItnoI1JIObrmRYNC27snGlxm4vUGo2zs+Qtt1aq4F9+AhFDcX872wkVwMDFXriYDt5yQ1zsYGtkfCkINY2xyqx+PR3lhpYkIffXPERrupvuG86TtqKT75DiZ/L5S0OHpNkMwe9sIxcsiRj3aOqYyKA7rcBJy5vA1rSuXYK35hKGvmJwIy3GhauEvnuHcpOFr77S1jkU5o8DP9AcqTbOL5Yu52faCrJmoHFc5aLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0PHMOInbThNlPPraN8x2Zu3guMTvQ8XDLXhMH4tOCts=;
 b=T5juMmsxqOjoQ3uBSYzAX+RLQu1oB7Vjp5j+McKQM5iDvlSgFI3o8KM6supbmHrJ86Eyjd8LNFv7uXKVbcvNg3zV4rkGot2LPyDnq+Bh0zRbHidt3Ld0JkYKwB1qO+XT4BHhTQMsojAMO48iyWUcBMgP8BBTAwIZ3QHU0nxR87BPApdIRHTBT929XUoPiX4pe6cSB8ysgrNrptfuyvAj8or8XEn1L+wi5NIF9/z1iVkx2lLq2RD1sADz7O7tiyKmWnILkvIV/M/dgro5/K328n1pDEiVja3ruYlfooVsp64Yjn7TLkRGBpg8T+PlV8Rlo9vZHacSLl6T0AsFKthDSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0PHMOInbThNlPPraN8x2Zu3guMTvQ8XDLXhMH4tOCts=;
 b=DISZcB4g4QFCjnOAyTMTgwiCZ3Z1lD/quz2NIg4jbLybFfAnBrL1Tv6NC2vHrcuEho+SmzlAr7xf0kFKLQRLmkk665qQrSRhI17SZj9tyT1QtSDhVKOtBRFGrl6rQ8J6d+t8owo5re23mmoKnU3N68ng9tTcuuQXhreYmxhFuD4=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Mon, 16 Nov
 2020 18:51:48 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3541.025; Mon, 16 Nov 2020
 18:51:48 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     qemu-devel@nongnu.org, rth@twiddle.net, armbru@redhat.com,
        dgilbert@redhat.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, marcel.apfelbaum@gmail.com, mtosatti@redhat.com,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        ssg.sos.patches@amd.com
Subject: [PATCH 06/11] monitor/i386: use debug APIs when accessing guest memory
Date:   Mon, 16 Nov 2020 18:51:33 +0000
Message-Id: <aa90b9f98f7314ae8c197a16e2acedbd29e16200.1605316268.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605316268.git.ashish.kalra@amd.com>
References: <cover.1605316268.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR12CA0053.namprd12.prod.outlook.com
 (2603:10b6:3:103::15) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR12CA0053.namprd12.prod.outlook.com (2603:10b6:3:103::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Mon, 16 Nov 2020 18:51:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bfcaacd6-1cdc-442a-9f96-08d88a60ac16
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4557A7460850B6CE340A40AD8EE30@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sqfz7vNX4LXL95nWb5aCidm+blBIwgPYn3GS0jeHm9bRGBfRdgekHYApxfbQgtT+4kmgjS/hD7sEUhD7k/3DZtqwjxmMNnnyoTgpq6eeJpZyGozeB1u32jY5ghgOWehwe26P8f/ld7Ybg6JdjtN166dJKarK4hvVPVeFy2LYcwRTngFvUVdVUiVp86zg1iuoFJBiF47Lw+3WGQnmI2WhqqajZqOmc3U/Vud/VsBXHj/XS6hIIwdNFkPLEgkT9jsYZI7sx76lfU2EuJdAcAYl8hpF37fbGNuOuVjvyqQpSP79e9aBwV3TxMmyVE2iNJhp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(66946007)(36756003)(86362001)(2616005)(956004)(8936002)(83380400001)(66476007)(66556008)(5660300002)(6666004)(2906002)(6486002)(478600001)(7696005)(8676002)(6916009)(16526019)(186003)(26005)(52116002)(316002)(7416002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zSwkI8cgbS21dzJuXMEgI/C3Rhzny2eUL7op22aNagaQCoc/N20Mepuk7GZOko5qsISearjXOthd9mI0wZ1l9Nxtej5lYUei/WWXzoSUrSCgPD86oTdAQ8aERaJylPQzvi/MFUkQtCXfT3WRM7lIcSDeMV34Hn4ZC5HW3Y2PQg71SdWCwWriTc7xKyrma7jQcnoJx1gZe7QsZNGJSI5Bhjhkd9IC+tiPooNQjgXFgpyD+lkYE/sLwrUNOj+KWKECgsDL4NbJKIqubOQgBtqkFXgDMdVW9CzjgNYbKTjinkZSlAgZfSz+90tOWwn1vIW/5zm43uK6Q6f6cezYB1nDDps/QgyVXXXy+wAMFsE1oAvYzePO3wv6zRYYHpgpU8sGrk1Wi5IBgI1XxTjXLHIMbuOqrHOBb+2JkWNheBNGgompQsVhVOdqNofg/HGrxh0g2lcHi3EvN5ZS8xfrDt3BtwWDrSDWZ7U8VU886QZEzjF5XsaSQJqhkOFIZsAZMZocc4oKXfBEi+0EV0mKZrwzSuaEaAbEJ06kI1X5Okqr7pscAMFCQPpu/sPuAc/lXbLSksAEdXMNrq1KQNf+FsWew5/xZFxzPiJdMwv84rR4F2QQL2RtnB0xGG7VdDh+zvGwdyj2to9yZ0wmv4xgDrbIXHa9ol0ULjm6dFKMaaB/HFtmnC2X8ZPnSeOAYU6GYW6PBZNhwNIi4CnrKqRtpTJ/TnAekKgmOeZAlQAVf/YN7x8vn31r0PF2CieTsKM7JPBSIG4Xp/q+4t7YQ6dy2G27/g+jms9y5rXWEO3R9WDAFrBTeLHTl6RzCcyqQL6UcF1NgSoxuDh4axXj0N1s7lefTljLrvybw6N7DR2WwDvGZF1RH70f79KTObBQrGDvUn1HVWsmgy01+3sHUGX7+mp1UQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfcaacd6-1cdc-442a-9f96-08d88a60ac16
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2020 18:51:48.3961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IL+xTBComwjpRzhGgGcUew70HfZmgA60gMFlUdmytIMBij8Bo0y91vhN65M6qlqoSHlcAVnQyXF9/3O6Dv/o3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Update the HMP commands to use the debug version of APIs when accessing
guest memory.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 monitor/misc.c        |  4 ++--
 softmmu/cpus.c        |  2 +-
 target/i386/monitor.c | 54 ++++++++++++++++++++++++-------------------
 3 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/monitor/misc.c b/monitor/misc.c
index 32e6a8c13d..7eba3a6fce 100644
--- a/monitor/misc.c
+++ b/monitor/misc.c
@@ -824,8 +824,8 @@ static void hmp_sum(Monitor *mon, const QDict *qdict)
 
     sum = 0;
     for(addr = start; addr < (start + size); addr++) {
-        uint8_t val = address_space_ldub(&address_space_memory, addr,
-                                         MEMTXATTRS_UNSPECIFIED, NULL);
+        uint8_t val;
+        cpu_physical_memory_read_debug(addr, &val, 1);
         /* BSD sum algorithm ('sum' Unix command) */
         sum = (sum >> 1) | (sum << 15);
         sum += val;
diff --git a/softmmu/cpus.c b/softmmu/cpus.c
index e46ac68ad0..79817330b7 100644
--- a/softmmu/cpus.c
+++ b/softmmu/cpus.c
@@ -779,7 +779,7 @@ void qmp_pmemsave(int64_t addr, int64_t size, const char *filename,
         l = sizeof(buf);
         if (l > size)
             l = size;
-        cpu_physical_memory_read(addr, buf, l);
+        cpu_physical_memory_read_debug(addr, buf, l);
         if (fwrite(buf, 1, l, f) != l) {
             error_setg(errp, QERR_IO_ERROR);
             goto exit;
diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index 7abae3c8df..9ca9c677a5 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -79,7 +79,7 @@ static void tlb_info_32(Monitor *mon, CPUArchState *env)
 
     pgd = env->cr[3] & ~0xfff;
     for(l1 = 0; l1 < 1024; l1++) {
-        cpu_physical_memory_read(pgd + l1 * 4, &pde, 4);
+        cpu_physical_memory_read_debug(pgd + l1 * 4, &pde, 4);
         pde = le32_to_cpu(pde);
         if (pde & PG_PRESENT_MASK) {
             if ((pde & PG_PSE_MASK) && (env->cr[4] & CR4_PSE_MASK)) {
@@ -87,7 +87,8 @@ static void tlb_info_32(Monitor *mon, CPUArchState *env)
                 print_pte(mon, env, (l1 << 22), pde, ~((1 << 21) - 1));
             } else {
                 for(l2 = 0; l2 < 1024; l2++) {
-                    cpu_physical_memory_read((pde & ~0xfff) + l2 * 4, &pte, 4);
+                    cpu_physical_memory_read_debug((pde & ~0xfff) + l2 * 4,
+                                                   &pte, 4);
                     pte = le32_to_cpu(pte);
                     if (pte & PG_PRESENT_MASK) {
                         print_pte(mon, env, (l1 << 22) + (l2 << 12),
@@ -108,12 +109,12 @@ static void tlb_info_pae32(Monitor *mon, CPUArchState *env)
 
     pdp_addr = env->cr[3] & ~0x1f;
     for (l1 = 0; l1 < 4; l1++) {
-        cpu_physical_memory_read(pdp_addr + l1 * 8, &pdpe, 8);
+        cpu_physical_memory_read_debug(pdp_addr + l1 * 8, &pdpe, 8);
         pdpe = le64_to_cpu(pdpe);
         if (pdpe & PG_PRESENT_MASK) {
             pd_addr = pdpe & 0x3fffffffff000ULL;
             for (l2 = 0; l2 < 512; l2++) {
-                cpu_physical_memory_read(pd_addr + l2 * 8, &pde, 8);
+                cpu_physical_memory_read_debug(pd_addr + l2 * 8, &pde, 8);
                 pde = le64_to_cpu(pde);
                 if (pde & PG_PRESENT_MASK) {
                     if (pde & PG_PSE_MASK) {
@@ -123,7 +124,8 @@ static void tlb_info_pae32(Monitor *mon, CPUArchState *env)
                     } else {
                         pt_addr = pde & 0x3fffffffff000ULL;
                         for (l3 = 0; l3 < 512; l3++) {
-                            cpu_physical_memory_read(pt_addr + l3 * 8, &pte, 8);
+                            cpu_physical_memory_read_debug(pt_addr + l3 * 8,
+                                                           &pte, 8);
                             pte = le64_to_cpu(pte);
                             if (pte & PG_PRESENT_MASK) {
                                 print_pte(mon, env, (l1 << 30) + (l2 << 21)
@@ -148,7 +150,7 @@ static void tlb_info_la48(Monitor *mon, CPUArchState *env,
     uint64_t pdp_addr, pd_addr, pt_addr;
 
     for (l1 = 0; l1 < 512; l1++) {
-        cpu_physical_memory_read(pml4_addr + l1 * 8, &pml4e, 8);
+        cpu_physical_memory_read_debug(pml4_addr + l1 * 8, &pml4e, 8);
         pml4e = le64_to_cpu(pml4e);
         if (!(pml4e & PG_PRESENT_MASK)) {
             continue;
@@ -156,7 +158,7 @@ static void tlb_info_la48(Monitor *mon, CPUArchState *env,
 
         pdp_addr = pml4e & 0x3fffffffff000ULL;
         for (l2 = 0; l2 < 512; l2++) {
-            cpu_physical_memory_read(pdp_addr + l2 * 8, &pdpe, 8);
+            cpu_physical_memory_read_debug(pdp_addr + l2 * 8, &pdpe, 8);
             pdpe = le64_to_cpu(pdpe);
             if (!(pdpe & PG_PRESENT_MASK)) {
                 continue;
@@ -171,7 +173,7 @@ static void tlb_info_la48(Monitor *mon, CPUArchState *env,
 
             pd_addr = pdpe & 0x3fffffffff000ULL;
             for (l3 = 0; l3 < 512; l3++) {
-                cpu_physical_memory_read(pd_addr + l3 * 8, &pde, 8);
+                cpu_physical_memory_read_debug(pd_addr + l3 * 8, &pde, 8);
                 pde = le64_to_cpu(pde);
                 if (!(pde & PG_PRESENT_MASK)) {
                     continue;
@@ -186,7 +188,7 @@ static void tlb_info_la48(Monitor *mon, CPUArchState *env,
 
                 pt_addr = pde & 0x3fffffffff000ULL;
                 for (l4 = 0; l4 < 512; l4++) {
-                    cpu_physical_memory_read(pt_addr
+                    cpu_physical_memory_read_debug(pt_addr
                             + l4 * 8,
                             &pte, 8);
                     pte = le64_to_cpu(pte);
@@ -209,7 +211,7 @@ static void tlb_info_la57(Monitor *mon, CPUArchState *env)
 
     pml5_addr = env->cr[3] & 0x3fffffffff000ULL;
     for (l0 = 0; l0 < 512; l0++) {
-        cpu_physical_memory_read(pml5_addr + l0 * 8, &pml5e, 8);
+        cpu_physical_memory_read_debug(pml5_addr + l0 * 8, &pml5e, 8);
         pml5e = le64_to_cpu(pml5e);
         if (pml5e & PG_PRESENT_MASK) {
             tlb_info_la48(mon, env, l0, pml5e & 0x3fffffffff000ULL);
@@ -286,7 +288,7 @@ static void mem_info_32(Monitor *mon, CPUArchState *env)
     last_prot = 0;
     start = -1;
     for(l1 = 0; l1 < 1024; l1++) {
-        cpu_physical_memory_read(pgd + l1 * 4, &pde, 4);
+        cpu_physical_memory_read_debug(pgd + l1 * 4, &pde, 4);
         pde = le32_to_cpu(pde);
         end = l1 << 22;
         if (pde & PG_PRESENT_MASK) {
@@ -295,7 +297,8 @@ static void mem_info_32(Monitor *mon, CPUArchState *env)
                 mem_print(mon, env, &start, &last_prot, end, prot);
             } else {
                 for(l2 = 0; l2 < 1024; l2++) {
-                    cpu_physical_memory_read((pde & ~0xfff) + l2 * 4, &pte, 4);
+                    cpu_physical_memory_read_debug((pde & ~0xfff) + l2 * 4,
+                                                   &pte, 4);
                     pte = le32_to_cpu(pte);
                     end = (l1 << 22) + (l2 << 12);
                     if (pte & PG_PRESENT_MASK) {
@@ -328,13 +331,13 @@ static void mem_info_pae32(Monitor *mon, CPUArchState *env)
     last_prot = 0;
     start = -1;
     for (l1 = 0; l1 < 4; l1++) {
-        cpu_physical_memory_read(pdp_addr + l1 * 8, &pdpe, 8);
+        cpu_physical_memory_read_debug(pdp_addr + l1 * 8, &pdpe, 8);
         pdpe = le64_to_cpu(pdpe);
         end = l1 << 30;
         if (pdpe & PG_PRESENT_MASK) {
             pd_addr = pdpe & 0x3fffffffff000ULL;
             for (l2 = 0; l2 < 512; l2++) {
-                cpu_physical_memory_read(pd_addr + l2 * 8, &pde, 8);
+                cpu_physical_memory_read_debug(pd_addr + l2 * 8, &pde, 8);
                 pde = le64_to_cpu(pde);
                 end = (l1 << 30) + (l2 << 21);
                 if (pde & PG_PRESENT_MASK) {
@@ -345,7 +348,8 @@ static void mem_info_pae32(Monitor *mon, CPUArchState *env)
                     } else {
                         pt_addr = pde & 0x3fffffffff000ULL;
                         for (l3 = 0; l3 < 512; l3++) {
-                            cpu_physical_memory_read(pt_addr + l3 * 8, &pte, 8);
+                            cpu_physical_memory_read_debug(pt_addr + l3 * 8,
+                                                           &pte, 8);
                             pte = le64_to_cpu(pte);
                             end = (l1 << 30) + (l2 << 21) + (l3 << 12);
                             if (pte & PG_PRESENT_MASK) {
@@ -384,13 +388,13 @@ static void mem_info_la48(Monitor *mon, CPUArchState *env)
     last_prot = 0;
     start = -1;
     for (l1 = 0; l1 < 512; l1++) {
-        cpu_physical_memory_read(pml4_addr + l1 * 8, &pml4e, 8);
+        cpu_physical_memory_read_debug(pml4_addr + l1 * 8, &pml4e, 8);
         pml4e = le64_to_cpu(pml4e);
         end = l1 << 39;
         if (pml4e & PG_PRESENT_MASK) {
             pdp_addr = pml4e & 0x3fffffffff000ULL;
             for (l2 = 0; l2 < 512; l2++) {
-                cpu_physical_memory_read(pdp_addr + l2 * 8, &pdpe, 8);
+                cpu_physical_memory_read_debug(pdp_addr + l2 * 8, &pdpe, 8);
                 pdpe = le64_to_cpu(pdpe);
                 end = (l1 << 39) + (l2 << 30);
                 if (pdpe & PG_PRESENT_MASK) {
@@ -402,7 +406,8 @@ static void mem_info_la48(Monitor *mon, CPUArchState *env)
                     } else {
                         pd_addr = pdpe & 0x3fffffffff000ULL;
                         for (l3 = 0; l3 < 512; l3++) {
-                            cpu_physical_memory_read(pd_addr + l3 * 8, &pde, 8);
+                            cpu_physical_memory_read_debug(pd_addr + l3 * 8,
+                                                           &pde, 8);
                             pde = le64_to_cpu(pde);
                             end = (l1 << 39) + (l2 << 30) + (l3 << 21);
                             if (pde & PG_PRESENT_MASK) {
@@ -415,7 +420,7 @@ static void mem_info_la48(Monitor *mon, CPUArchState *env)
                                 } else {
                                     pt_addr = pde & 0x3fffffffff000ULL;
                                     for (l4 = 0; l4 < 512; l4++) {
-                                        cpu_physical_memory_read(pt_addr
+                                        cpu_physical_memory_read_debug(pt_addr
                                                                  + l4 * 8,
                                                                  &pte, 8);
                                         pte = le64_to_cpu(pte);
@@ -464,7 +469,7 @@ static void mem_info_la57(Monitor *mon, CPUArchState *env)
     last_prot = 0;
     start = -1;
     for (l0 = 0; l0 < 512; l0++) {
-        cpu_physical_memory_read(pml5_addr + l0 * 8, &pml5e, 8);
+        cpu_physical_memory_read_debug(pml5_addr + l0 * 8, &pml5e, 8);
         pml5e = le64_to_cpu(pml5e);
         end = l0 << 48;
         if (!(pml5e & PG_PRESENT_MASK)) {
@@ -475,7 +480,7 @@ static void mem_info_la57(Monitor *mon, CPUArchState *env)
 
         pml4_addr = pml5e & 0x3fffffffff000ULL;
         for (l1 = 0; l1 < 512; l1++) {
-            cpu_physical_memory_read(pml4_addr + l1 * 8, &pml4e, 8);
+            cpu_physical_memory_read_debug(pml4_addr + l1 * 8, &pml4e, 8);
             pml4e = le64_to_cpu(pml4e);
             end = (l0 << 48) + (l1 << 39);
             if (!(pml4e & PG_PRESENT_MASK)) {
@@ -486,7 +491,7 @@ static void mem_info_la57(Monitor *mon, CPUArchState *env)
 
             pdp_addr = pml4e & 0x3fffffffff000ULL;
             for (l2 = 0; l2 < 512; l2++) {
-                cpu_physical_memory_read(pdp_addr + l2 * 8, &pdpe, 8);
+                cpu_physical_memory_read_debug(pdp_addr + l2 * 8, &pdpe, 8);
                 pdpe = le64_to_cpu(pdpe);
                 end = (l0 << 48) + (l1 << 39) + (l2 << 30);
                 if (pdpe & PG_PRESENT_MASK) {
@@ -505,7 +510,7 @@ static void mem_info_la57(Monitor *mon, CPUArchState *env)
 
                 pd_addr = pdpe & 0x3fffffffff000ULL;
                 for (l3 = 0; l3 < 512; l3++) {
-                    cpu_physical_memory_read(pd_addr + l3 * 8, &pde, 8);
+                    cpu_physical_memory_read_debug(pd_addr + l3 * 8, &pde, 8);
                     pde = le64_to_cpu(pde);
                     end = (l0 << 48) + (l1 << 39) + (l2 << 30) + (l3 << 21);
                     if (pde & PG_PRESENT_MASK) {
@@ -524,7 +529,8 @@ static void mem_info_la57(Monitor *mon, CPUArchState *env)
 
                     pt_addr = pde & 0x3fffffffff000ULL;
                     for (l4 = 0; l4 < 512; l4++) {
-                        cpu_physical_memory_read(pt_addr + l4 * 8, &pte, 8);
+                        cpu_physical_memory_read_debug(pt_addr + l4 * 8,
+                                                       &pte, 8);
                         pte = le64_to_cpu(pte);
                         end = (l0 << 48) + (l1 << 39) + (l2 << 30) +
                             (l3 << 21) + (l4 << 12);
-- 
2.17.1

