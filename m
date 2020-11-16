Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D582B5034
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgKPSuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:50:50 -0500
Received: from mail-dm6nam12on2079.outbound.protection.outlook.com ([40.107.243.79]:54881
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725879AbgKPSut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:50:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NHDcIJTyDQojriknzaZJqNg/iHq1Z/EKpf2e4oxZvSartXvRjvy3tE0KcfOUv4LolDAQ+ke17tQPbA2U7h0pR/z8okmPzXJLYmGSrDZnq4WQuehB2ho12az51lN09sH5ZvbA81ox5O9iSIr2G1I9tZzfkcVQ6MblcfDhKl3TIRW5VSTTz1GrVxq8//H4YdOc/RMzaj+4FR5RdcrR4Yo82xuxhaebIh9ncYz8yAIlB4e7sGPD1TGNcR/6TwU1vQNneFKGZIR0p5lAnm9MryK8iAS0sLOkXianLRKCdOBzp4SU+mEjRzuJEkvPLXXL9bzBx998nloSc167UDXlo/j1HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mMhshu5C713c2SyfmmeXo3sS+iM6PeuvtkF4Ik78Nw=;
 b=NYl1IJQsr9swsj+h6zOBkLcsTk/U0POmRGor67/26+czejhrZz+Zxa7O8z24N9virMnCbDB9l55Y059Xgxy4BSAbWxH5HRcm2fZA4VdgOfaZU9zPwCQMvbffb9N99pqh16EZMriHAiPC+H1dLO2wZTvut97sFolmjobulG9p+qMRc9c+mvQeM19E25EV4g/e3a/rn1TXfp59gnWeL56Pj6S4oREO8w+77ztHWtcQCc4Vmq1WxGeXuN1PZjpr7NkFrVgrHe6wKMrZe/6nH/0wWumketgNhlRD3CCJ+e7jWIVcs4hVsWfPqRVzKyHtFPT6tz+BgIfSWoJpBC0zMYd7RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mMhshu5C713c2SyfmmeXo3sS+iM6PeuvtkF4Ik78Nw=;
 b=XWu+ORTbUouUgALD3w7nAZ29bymNs4Vf7vMRfbPN9qYMBbVwHd93qPpXn0GELfBycd0i3+hX+xaTbPsyr9aagL7eZzD6Qd8dLtqVTDQ3t/wpm+MmafX4A4X7uPM1Qbnme6P9rpGd7eqp5dv/KyZaMkppDoJEk5lxPykZYXfd/x4=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2782.namprd12.prod.outlook.com (2603:10b6:805:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19; Mon, 16 Nov
 2020 18:50:46 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3541.025; Mon, 16 Nov 2020
 18:50:46 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     qemu-devel@nongnu.org, rth@twiddle.net, armbru@redhat.com,
        dgilbert@redhat.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, marcel.apfelbaum@gmail.com, mtosatti@redhat.com,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        ssg.sos.patches@amd.com
Subject: [PATCH 04/11] exec: Add address_space_read and address_space_write debug helpers.
Date:   Mon, 16 Nov 2020 18:50:34 +0000
Message-Id: <36cda6f0d2f7e58dd7fae518e943653d8a6a559d.1605316268.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605316268.git.ashish.kalra@amd.com>
References: <cover.1605316268.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR07CA0090.namprd07.prod.outlook.com
 (2603:10b6:5:337::23) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM6PR07CA0090.namprd07.prod.outlook.com (2603:10b6:5:337::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.21 via Frontend Transport; Mon, 16 Nov 2020 18:50:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 596d3351-6689-4114-1440-08d88a60871f
X-MS-TrafficTypeDiagnostic: SN6PR12MB2782:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2782B13A84E31007DA8BAF7F8EE30@SN6PR12MB2782.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:247;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2DbaXhHFZz1vXTuHfUBJwC5cCTGvPe4NY3qKi8VtrRTe7jRjjquZfPwqCcs5wYw9jkKW8huAIrxBLl6CxncOvuP9gAbuSsr04FUgjrvEQ/Xi/RG+fHHY3/cp50umFlsQ/sdjXR8t1OkJXplNqTlvu4mak6ahcPM2j07xFl17gcO7v0YNwRl5wElm0W6y8lXfV9Nf7Qkt8mnLafB0/MNIi4wMn5pM4HQGeaM7r8vIs7IdCJhu4Rypp0kdKzKG3yoBPTF5qE2YIDXYgnsWrzKxNKl6h2aQ5YYSDEvdQFTsq9jIzh6lTzZe2HJWEyJgjxki
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(366004)(396003)(346002)(7416002)(6666004)(186003)(83380400001)(478600001)(4326008)(5660300002)(8936002)(2616005)(66556008)(8676002)(66476007)(6916009)(16526019)(66946007)(86362001)(316002)(7696005)(36756003)(52116002)(2906002)(26005)(6486002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rcYfFRDiGWGks1g2BM254n3c4JPkV2mPDQK+MZUg9FoH2PFTy1bbw884FtlF4Yi2BEf5/JNJoMV6BlOUTAH2LLfgxgsrDemgTSmi8M+Gi2ijGWwL7aQEmz0xbQD4b4snrhmLXtzlaVWVfAAeEH0zb9nvOXWXFN6TIOWycTfRE7S31mESDKjk4k+LBcAWKH0DiXDaCihbc9ndBKlnCfGmBjb56/bDBet60Be78M6Hi88SmjP9LbS09Zif0MaeJRD4UIXrBOSHyRGy3scI0dYUOu/gyDDf/XNOc28zMB4StJGkWMdLvRSo2NSSuGSRdTJwVfRsLnZ56XPtfytWq1tlk62hhYDwN00s3IuKFe7KCDHqSJLnpDxq96+7RGFy8R3hHgtLgfT1RwrxPEMz4PssFysy0ozI3iEPFjxAUqeotkpiUrdELZfyC5oMgR7j9M9LCEmlXrgexjVbg3PY9D+6MH/N8vR4ZFkQWh5LhcJ8IC7vSFuWlrJNO1cNSDC6oI1018mkWo4iqiULuE1SR/dDHZhk/7rqOpIY/Fy1yObEi2KbcPABvV89QmjLI0bu5bhAyB5ynzdLqSXDFoCvNFgDWlGu1QaNyH2Xowbxi63kyJSZoj5oqSBqrTXcugHOM0/OzlPBRcxlhe1b776mRpQD8DHvCuAPytfRAgaAVLaANxurwRkz3Buo54dJta3pPjFpkEWsDQlb2Yunx6t1ZhZLQ1DxUv4e/0Eo7uhyZgNjWaTZ/Ozm4XgljwnXZ1WuHFuCl3zY8Ft83DdEjGNKfx8MgLxPl6SAzPurICHQvVOY2AO21UHrIeAIWgx/tj34khd4OY3vlHhDIGZzx/ZI8xcoMRBmHLnbf2bj5sKH3w84HCHaDjqBuvteRDsG3/A9IuAoe6N3dst8D+gPis5y6QdTtw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 596d3351-6689-4114-1440-08d88a60871f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2020 18:50:46.3018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7nk8Dt/TYuE9V4RBkLv5p0liucLyUOk5IM1T2vWgce2FtyEYH3nD8jRgt4hcRIT8vIzyGvGW635kG1zHtqw2Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2782
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Add new address_space_read and address_space_write debug helper
interfaces which can be invoked by vendor specific guest memory
debug assist/hooks to do guest RAM memory accesses using the
added MemoryRegion callbacks.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 include/exec/memory.h | 10 +++++
 softmmu/physmem.c     | 88 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 2fb4193358..74f2dcec00 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -2432,6 +2432,16 @@ typedef struct MemoryDebugOps {
 
 void address_space_set_debug_ops(const MemoryDebugOps *ops);
 
+MemTxResult address_space_write_rom_debug(AddressSpace *as,
+                                          hwaddr addr,
+                                          MemTxAttrs attrs,
+                                          const void *ptr,
+                                          hwaddr len);
+
+MemTxResult address_space_read_debug(AddressSpace *as, hwaddr addr,
+                                     MemTxAttrs attrs, void *buf,
+                                     hwaddr len);
+
 static inline bool memory_access_is_direct(MemoryRegion *mr, bool is_write)
 {
     if (is_write) {
diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index 057d6d4ce1..2c08624ca8 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -3266,6 +3266,94 @@ void cpu_physical_memory_unmap(void *buffer, hwaddr len,
 #define RCU_READ_UNLOCK(...)     rcu_read_unlock()
 #include "memory_ldst.c.inc"
 
+MemTxResult address_space_read_debug(AddressSpace *as, hwaddr addr,
+                                     MemTxAttrs attrs, void *ptr,
+                                     hwaddr len)
+{
+    uint64_t val;
+    MemoryRegion *mr;
+    hwaddr l = len;
+    hwaddr addr1;
+    MemTxResult result = MEMTX_OK;
+    bool release_lock = false;
+    uint8_t *buf = ptr;
+    uint8_t *ram_ptr;
+
+    for (;;) {
+        RCU_READ_LOCK_GUARD();
+        mr = address_space_translate(as, addr, &addr1, &l, false, attrs);
+        if (!memory_access_is_direct(mr, false)) {
+            /* I/O case */
+            release_lock |= prepare_mmio_access(mr);
+            l = memory_access_size(mr, l, addr1);
+            result |= memory_region_dispatch_read(mr, addr1, &val,
+                                                  size_memop(l), attrs);
+            stn_he_p(buf, l, val);
+        } else {
+            /* RAM case */
+            fuzz_dma_read_cb(addr, l, mr, false);
+            ram_ptr = qemu_ram_ptr_length(mr->ram_block, addr1, &l, false);
+            if (attrs.debug && mr->ram_debug_ops) {
+                mr->ram_debug_ops->read(buf, ram_ptr, l, attrs);
+            } else {
+                memcpy(buf, ram_ptr, l);
+            }
+            result = MEMTX_OK;
+        }
+        if (release_lock) {
+            qemu_mutex_unlock_iothread();
+            release_lock = false;
+        }
+
+        len -= l;
+        buf += l;
+        addr += l;
+
+        if (!len) {
+            break;
+        }
+        l = len;
+    }
+    return result;
+}
+
+inline MemTxResult address_space_write_rom_debug(AddressSpace *as,
+                                                 hwaddr addr,
+                                                 MemTxAttrs attrs,
+                                                 const void *ptr,
+                                                 hwaddr len)
+{
+    hwaddr l;
+    uint8_t *ram_ptr;
+    hwaddr addr1;
+    MemoryRegion *mr;
+    const uint8_t *buf = ptr;
+
+    RCU_READ_LOCK_GUARD();
+    while (len > 0) {
+        l = len;
+        mr = address_space_translate(as, addr, &addr1, &l, true, attrs);
+
+        if (!(memory_region_is_ram(mr) ||
+              memory_region_is_romd(mr))) {
+            l = memory_access_size(mr, l, addr1);
+        } else {
+            /* ROM/RAM case */
+            ram_ptr = qemu_map_ram_ptr(mr->ram_block, addr1);
+            if (attrs.debug && mr->ram_debug_ops) {
+                mr->ram_debug_ops->write(ram_ptr, buf, l, attrs);
+            } else {
+                memcpy(ram_ptr, buf, l);
+            }
+            invalidate_and_set_dirty(mr, addr1, l);
+        }
+        len -= l;
+        buf += l;
+        addr += l;
+    }
+    return MEMTX_OK;
+}
+
 int64_t address_space_cache_init(MemoryRegionCache *cache,
                                  AddressSpace *as,
                                  hwaddr addr,
-- 
2.17.1

