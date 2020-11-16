Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E7F2B5030
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbgKPSta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:49:30 -0500
Received: from mail-dm6nam08on2059.outbound.protection.outlook.com ([40.107.102.59]:46305
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726886AbgKPSta (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:49:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iqZur4guZm/rpMBbWrLQOqm/z7BcxviAeq4xBVRakqRz+vK6XxYwMiZvE1KVj6ssgbXUz5rZrSeqiSYTzG+FeeINoknE09z2EFAAmibhhY3FJBgiGsBtC5SRlmRVd8U9dg3AuasdOpGYhO8DKX62UNVs7qjGTWXy7ei6LlXDa0KTSYxBdLdFuVZX/yilpuY3QoZhHDaP7bvRDZpCwvwFRtEjn5kXEt5pF1Y1WnCd8pvZGyaK6sy9UdzfeaxVmJp66wjbQd0pLGe5IJ4i2PzYWK1tE4u/CRU8aw2xL50oRg5Oo4kc1c1XLM1swqqB1LkOhLtwIbUD+r012wrWNDn6Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ambiGrX8FcaNuelrmpZ/RrHxc1WSpleBvG7jGdWWWZs=;
 b=CmW/3x5thaZ2MkxQS9ddEpRnnrttSMQK03OcoQZtVfM2sNg0K/QgyTcgjITRSfZ8lmivdaf4Ppw/mIOtu8/EQ3cwIk9pDVdiEUAd/v+mWLUwMZgg3x6Y9PEUlpZgv8g8n/AucEZfN4xm0g0i4MhINAPffSu3R7Bg2Y1YeescTi7AWL6yKxHEAWduk090s5i5dBxXBRlaMaxkgGPW9fqZrE4xh4JF6t2eNoPAtHKdiYSTo9lXs83ZTUW7P0xg6k4ZLAPhsLzHJbgb0ERh9g+jYiKnWwn7qQ1dsDjUrKYPjmqgYGzjD/76aeVLWlYPhryuvyuxAIzoTFRTDBQkJiOh2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ambiGrX8FcaNuelrmpZ/RrHxc1WSpleBvG7jGdWWWZs=;
 b=CLivh4kPRhlUBe0Im9UUqOj7i6SdhZkVpUJvYikgJTjy0vddxisaChaqWF92707vhqd7PWjpnQ5728rqiLYc3PN6tMgGcVdcfXTrkWJmT0c6kbpFgpVu/4HU+XxgV5HwI5KauF7RzAhEnBp9swLHr2Fx45jnpE7JILOtUd8Q1iY=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2782.namprd12.prod.outlook.com (2603:10b6:805:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19; Mon, 16 Nov
 2020 18:49:26 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3541.025; Mon, 16 Nov 2020
 18:49:26 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     qemu-devel@nongnu.org, rth@twiddle.net, armbru@redhat.com,
        dgilbert@redhat.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, marcel.apfelbaum@gmail.com, mtosatti@redhat.com,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        ssg.sos.patches@amd.com
Subject: [PATCH 02/11] exec: Add new MemoryDebugOps.
Date:   Mon, 16 Nov 2020 18:49:15 +0000
Message-Id: <4393d426ae8f070c6be45ff0252bae2dca8bbd42.1605316268.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605316268.git.ashish.kalra@amd.com>
References: <cover.1605316268.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR04CA0039.namprd04.prod.outlook.com
 (2603:10b6:3:12b::25) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR04CA0039.namprd04.prod.outlook.com (2603:10b6:3:12b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Mon, 16 Nov 2020 18:49:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f9c87c64-81c9-4a37-029b-08d88a6057b6
X-MS-TrafficTypeDiagnostic: SN6PR12MB2782:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB278251E8E7A3372DD7B057868EE30@SN6PR12MB2782.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8c65/kXAyZL8opuYa1ts3osISPP1lCX4Tl95Xn3X3Dre11xIQySIALvu0G82cBX+2lWOZkRUJrxBMqpS4MDYJgJj1xjiWNO3/iicpqhgy0nGn5FAKe30/WC933JdhtMY/ARIGHlsepUz+7TM5+AinZ+T4KIo7dlk8fdobc3ly0JXQ2ap9sdrQzged+ioS7kIsbejvAUMPO6hkg8vKiLK/yLk2/JB08eVT39btel+TJYW7kgLlhIDcsjT4YXwxfOxi0PFpqgUYde5WRjN3OVzT4F23g07NhjeoQagZD3AwyHoqRYWo/tyiWC2qHRlbf6XWoobIILajdYhy4RebzAVSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(366004)(396003)(346002)(7416002)(6666004)(186003)(83380400001)(478600001)(4326008)(5660300002)(8936002)(2616005)(66556008)(8676002)(66476007)(6916009)(16526019)(66946007)(86362001)(316002)(7696005)(36756003)(52116002)(2906002)(26005)(6486002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: u4fY3/uwvQupXqRdWlAiL0lVfDdX9V2OVfrbumAPzqJE7yl6WT6CBncrOBncC0KRdB9wNvF99RV7OKEyOMS3vL0BzL/A/F1p5JtXuxVeqPLDYoRWZl+xMpcd+1skn2f40CAJDVNRnnjA2T8w565hiY9cv5AiNu7d32kaidlaTLz59j2xPgkTG7keuhrNZ3FCXvXKWfM3b7m6nloFSVPAFhJntT2xT0OAtwb6T584aaQPs2GQjBGCubOMv4NmyLqVldLsxXkUQI0DFiVolEAnvpYSkLqoHZoe6bsJ5zNNEAVcUcSz9gxKIS5E6USX3/gqp5JayUxZoFhPrdPYiluv4am/LzjTOT9b0lk5CcNvyxaovffrcRKfp8WBzBJ5xXy94bqCwpZsFZgH+NcVrwvQAU+io7Zak/8mpoYFuetz/giQq8B1hhhr6+1ftx8vJ66FPqzTssJoY0cndG91/BfXBImjJhD0SZI1GLNtx4XVDyiy+t2O1hSmOYZDhfAUtK9x4QuIxGezyRmj1j/sGWeORbwzv0W+ZqWRASB2BWbwt6TJS4/gTHmdjex/xcHGieQnT3FxotOPv3p4D7Rmh5kB24jfHJKrmioe94plVaFuZy88H/SItL2/B2FPIulFcIa5ipc7xBJunkg6pxqBhk+E4PL7CXnZSTQK3/kWTvghTcX+Jl1N7QgjT0HfUIUtsf4jZTEBiec+Pvp+Os109WJUQcHO6mxPL6GnAXDYayYwPC9kymxhiV56ZPQuw7/LntPCWhKBVu2keFc12hCSyocfPRdamabTh5Pphk86aVLndo9wHaW9Zon5/EL11fszz4y/rgTBYUF7i0q2GqZtIR2AAS6zgyVPTpBFFvZ+NQpQJEmk9/CaEi44v16JKYyoLJxOsVOoucbT9OfNbiE64rjvnw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9c87c64-81c9-4a37-029b-08d88a6057b6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2020 18:49:26.8213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2mJRmQy8r4IA2HkO8DUBUBACBAxOLTCUph9tA8Xh5Dr9ZEUn/7p6up6rUNd+bUwklhm4qHYJ1GWSZSNlr0Io0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2782
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Introduce new MemoryDebugOps which hook into guest virtual and physical
memory debug interfaces such as cpu_memory_rw_debug, to allow vendor specific
assist/hooks for debugging and delegating accessing the guest memory.
This is required for example in case of AMD SEV platform where the guest
memory is encrypted and a SEV specific debug assist/hook will be required
to access the guest memory.

The MemoryDebugOps are used by cpu_memory_rw_debug() and default to
address_space_read and address_space_write_rom.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 include/exec/memory.h | 11 +++++++++++
 softmmu/physmem.c     | 24 ++++++++++++++++++++----
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index aff6ef7605..73deb4b456 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -2394,6 +2394,17 @@ MemTxResult address_space_write_cached_slow(MemoryRegionCache *cache,
                                             hwaddr addr, const void *buf,
                                             hwaddr len);
 
+typedef struct MemoryDebugOps {
+    MemTxResult (*read)(AddressSpace *as, hwaddr phys_addr,
+                        MemTxAttrs attrs, void *buf,
+                        hwaddr len);
+    MemTxResult (*write)(AddressSpace *as, hwaddr phys_addr,
+                         MemTxAttrs attrs, const void *buf,
+                         hwaddr len);
+} MemoryDebugOps;
+
+void address_space_set_debug_ops(const MemoryDebugOps *ops);
+
 static inline bool memory_access_is_direct(MemoryRegion *mr, bool is_write)
 {
     if (is_write) {
diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index a9adedb9f8..057d6d4ce1 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -166,6 +166,18 @@ struct DirtyBitmapSnapshot {
     unsigned long dirty[];
 };
 
+static const MemoryDebugOps default_debug_ops = {
+    .read = address_space_read,
+    .write = address_space_write_rom
+};
+
+static const MemoryDebugOps *debug_ops = &default_debug_ops;
+
+void address_space_set_debug_ops(const MemoryDebugOps *ops)
+{
+    debug_ops = ops;
+}
+
 static void phys_map_node_reserve(PhysPageMap *map, unsigned nodes)
 {
     static unsigned alloc_hint = 16;
@@ -3407,6 +3419,10 @@ int cpu_memory_rw_debug(CPUState *cpu, target_ulong addr,
         page = addr & TARGET_PAGE_MASK;
         phys_addr = cpu_get_phys_page_attrs_debug(cpu, page, &attrs);
         asidx = cpu_asidx_from_attrs(cpu, attrs);
+
+        /* set debug attrs to indicate memory access is from the debugger */
+        attrs.debug = 1;
+
         /* if no physical page mapped, return an error */
         if (phys_addr == -1)
             return -1;
@@ -3415,11 +3431,11 @@ int cpu_memory_rw_debug(CPUState *cpu, target_ulong addr,
             l = len;
         phys_addr += (addr & ~TARGET_PAGE_MASK);
         if (is_write) {
-            res = address_space_write_rom(cpu->cpu_ases[asidx].as, phys_addr,
-                                          attrs, buf, l);
+            res = debug_ops->write(cpu->cpu_ases[asidx].as, phys_addr,
+                                   attrs, buf, l);
         } else {
-            res = address_space_read(cpu->cpu_ases[asidx].as, phys_addr,
-                                     attrs, buf, l);
+            res = debug_ops->read(cpu->cpu_ases[asidx].as, phys_addr,
+                                  attrs, buf, l);
         }
         if (res != MEMTX_OK) {
             return -1;
-- 
2.17.1

