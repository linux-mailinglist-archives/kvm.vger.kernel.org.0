Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC172B5035
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgKPSv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:51:28 -0500
Received: from mail-dm6nam12on2069.outbound.protection.outlook.com ([40.107.243.69]:55515
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726536AbgKPSv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:51:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZAZR4igKNeP/yQQjSkGUV3l+SP8wfALoL+Q89wFc5fnKiT7VxSBDz2dVqQvwUgRbC6q8sRhi9705VwBlhft154iX6clCZNmR+odzt3Srlybp20QALWGds85un99qfMJS7kXAFGDKZxA+gN66RNjiP5Z9xFXiNR7JK1cR/Q34tPmxNRYWHFh10IFN3g7RDvN5YyYKcWA3TXwZ0PNnAJ9LXRB0no6v00cLdvyuOgMpqfCHKVeVE6aS1SoVrYslXSuJficbI0H6poqOOIoF3sBAGSDLvdor6ukhr/ziyv38qw1vDwn0t0w7dhaZ2jq6YLWGmuZNpPp3SeQPse3JqsNHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1tGD5kFPp5vT4bC1fLGw54p0iU6u5g1fzK1AuT4DFdM=;
 b=e/awd9Q6tvQ03TkDqwxx1QF6h2VPlczWjE3Nq+RSdN+tK9E9O3+60nOFBqjQwBT6hPSJH6W6YzHeaYjmko3UzsufMzXaJpUoL7rBwqwgukvD7u+aX2gO92rwEQZCE7sDy1vUnkIqq9pMKcJnOlZ6hCJ77FCqoFTCV8yv6FtcA36q79KZ9Z5Nvt380w7Ny1LvywZQCFJITVCcpkBP+cCMRyLydlhbvzkQZqiIhEkEWdLo7ww14OkoYgz6NDWElNA/Qa19VrCqU9YLLZaHUqQHg40E0eb2ka60PJDXaUAYG4WRpIKR7a6m5uDBvy6xU4s+BC7HnDhmhnSQfJ+ZsM+rkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1tGD5kFPp5vT4bC1fLGw54p0iU6u5g1fzK1AuT4DFdM=;
 b=KvpbuLbdCr8ZuxwwYUdN1DKMZihAB/Oq6aWNr9kr3JfFb0NtHPovfVfW1f9A4QEEf8PseoYqhSUWMQxCeRaQqx+FNKaRBSX+zS7oTBfp1qQCK6CaBCRHHHP6by7pD8JR4mlQo1XL2gFVCeuKvg94BEBrtDho04LYSKuXDVo+vM0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Mon, 16 Nov
 2020 18:51:26 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3541.025; Mon, 16 Nov 2020
 18:51:26 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     qemu-devel@nongnu.org, rth@twiddle.net, armbru@redhat.com,
        dgilbert@redhat.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, marcel.apfelbaum@gmail.com, mtosatti@redhat.com,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        ssg.sos.patches@amd.com
Subject: [PATCH 05/11] exec: add debug version of physical memory read and write API
Date:   Mon, 16 Nov 2020 18:51:14 +0000
Message-Id: <7f254436d56679b27ba0112c16472831a6a66b49.1605316268.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605316268.git.ashish.kalra@amd.com>
References: <cover.1605316268.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR19CA0069.namprd19.prod.outlook.com
 (2603:10b6:3:116::31) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR19CA0069.namprd19.prod.outlook.com (2603:10b6:3:116::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Mon, 16 Nov 2020 18:51:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cca836d4-a569-446e-3b4f-08d88a609eb0
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4557B1563D21D40512A1FC008EE30@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yK7fS3EJw6dpc5S6dIgbfyTb2jYKFb4WhhAtrZPqbswgoE5CEuIetmHNIYiHFfHG+ccdSSekxmyFMzhADhM1hIX8OYlyY4NDuPLoVtn3cqmgxerCTjkqY9WVGmtWfpbuby/+oVTTs2ToFl6iL8vbBWGYgxlwx9drVBmFM17AU2zHJZiBvscqBA2dl46R+JAFj00D2x3WHob9CpLYY/QVedFDPxgjtjOfVut8HFEMKbqZZQKxxDs5o0BEl006eRx/cXMiW6jGUC9q7lYOzxHXHQ8owt4ENwRTxHcXz5yF3lY/OVw7SYz0NY0yV286Dl3d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(66946007)(36756003)(86362001)(2616005)(956004)(8936002)(83380400001)(66476007)(66556008)(5660300002)(6666004)(2906002)(6486002)(478600001)(7696005)(8676002)(6916009)(16526019)(186003)(26005)(52116002)(316002)(7416002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UoqikJvmvP8ijThA2cJYm9Sa7wP61P0XBJsVqjfThTUzYHI68yAQZ93YTnN8A6njOpP7N0n9ic+6dDI9CPiCxbhduQ3z/DRXlguLa2bqRA9AuP+6I/xjW5SFzMigY2r2bH8Q9xvzM/BXy6PYYgGmUdtJWQCQ0yRIknVImVszQaf56eroMkWJpoI+ai68lFhVe8FEStFdUsVEFwH9y3c4LI3ekDuUBxefsg3lvEn6aboJvOnYrJF1mT5z5xCUebNXl5X9ZfXPxOlt3naM1ulqebHhyAZcTaRYTkrxgNJTBtG8DN161mQMXkECKdDnRY0PUXFEE1LOuc53BLiuNvHTVGlE8tYQEUZNMLYVgXCpUaTcSkAKSIQhQxqxSNrAO2liiMI3jXdHlDk5w0GD6Eh+auTq2ySXANIVCUfJyllcbPeRVwZa6GxmHd4TJ54li+fKxpf/U23QcIDvCGPbqOIZ9Ior1z9jqgdQEvRHNVGx61wBjbLTh2xWpPd2MdD/cKWygpnwL4FUQvDhqh0qWKuhPy0wHYe18fHTooRRM4KUk9fi9PC+iK2ad69sUFa+kXqLSrR3+gzCrY/Z207+h82FOjLpdShwHhj6wDiN93YSiqDnShgbGu2rmcGIPIUJKYXTGfsNVO0nDvGw73i/4g6Upj4ks+mbE6PpeTt8k4uYgGhIiUl9gyJmCuMtfgFDEABmrkQF5NspjX2EzALdKrcx8P6lv5xOgeNtcbIPIWQbuqv3QGEoN1aVqS0TvMqa2Iswt2x3tWMLdaP4lT90/22Rj8iCOcpNLxSl2SpzJ8iyXpr8/gOPyxGymMDL7Tk3JEmOfCPwLb2CezSRz4RjvdZwhzODSp4hYsuMr7iG1GTwJfh3oXoK+C1CkPDCykdMW19FT/dPDV4ycz2vmYXxebv8bg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cca836d4-a569-446e-3b4f-08d88a609eb0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2020 18:51:25.8877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MjoUQG9v3SyFuAYOxob8DVrMDBTwjp/ckvTnGRFDf9rLrqCcOB+De0WqLQAkfGHzS74XHNOaHDZtAwGDS8S9rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Adds the following new APIs
- cpu_physical_memory_read_debug
- cpu_physical_memory_write_debug
- cpu_physical_memory_rw_debug
- ldl_phys_debug
- ldq_phys_debug

The subsequent patch will make use of the API introduced, to ensure
that the page table walks are handled correctly when debugging an
SEV guest.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 include/exec/cpu-common.h | 15 +++++++++++++
 softmmu/physmem.c         | 47 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 19805ed6db..d2089e6873 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -71,11 +71,26 @@ size_t qemu_ram_pagesize_largest(void);
 
 void cpu_physical_memory_rw(hwaddr addr, void *buf,
                             hwaddr len, bool is_write);
+void cpu_physical_memory_rw_debug(hwaddr addr, uint8_t *buf,
+                                  int len, int is_write);
 static inline void cpu_physical_memory_read(hwaddr addr,
                                             void *buf, hwaddr len)
 {
     cpu_physical_memory_rw(addr, buf, len, false);
 }
+static inline void cpu_physical_memory_read_debug(hwaddr addr,
+                                                  void *buf, int len)
+{
+    cpu_physical_memory_rw_debug(addr, buf, len, false);
+}
+static inline void cpu_physical_memory_write_debug(hwaddr addr,
+                                                   const void *buf, int len)
+{
+    cpu_physical_memory_rw_debug(addr, (void *)buf, len, true);
+}
+uint32_t ldl_phys_debug(CPUState *cpu, hwaddr addr);
+uint64_t ldq_phys_debug(CPUState *cpu, hwaddr addr);
+
 static inline void cpu_physical_memory_write(hwaddr addr,
                                              const void *buf, hwaddr len)
 {
diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index 2c08624ca8..6945bd5efe 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -3354,6 +3354,53 @@ inline MemTxResult address_space_write_rom_debug(AddressSpace *as,
     return MEMTX_OK;
 }
 
+uint32_t ldl_phys_debug(CPUState *cpu, hwaddr addr)
+{
+    MemTxAttrs attrs;
+    int asidx = cpu_asidx_from_attrs(cpu, attrs);
+    uint32_t val;
+
+    /* set debug attrs to indicate memory access is from the debugger */
+    attrs.debug = 1;
+
+    debug_ops->read(cpu->cpu_ases[asidx].as, addr, attrs,
+                    (void *) &val, 4);
+
+    return tswap32(val);
+}
+
+uint64_t ldq_phys_debug(CPUState *cpu, hwaddr addr)
+{
+    MemTxAttrs attrs;
+    int asidx = cpu_asidx_from_attrs(cpu, attrs);
+    uint64_t val;
+
+    /* set debug attrs to indicate memory access is from the debugger */
+    attrs.debug = 1;
+
+    debug_ops->read(cpu->cpu_ases[asidx].as, addr, attrs,
+                    (void *) &val, 8);
+    return val;
+}
+
+void cpu_physical_memory_rw_debug(hwaddr addr, uint8_t *buf,
+                                  int len, int is_write)
+{
+    MemTxAttrs attrs;
+
+    /* set debug attrs to indicate memory access is from the debugger */
+    attrs.debug = 1;
+
+    if (is_write) {
+                debug_ops->write(&address_space_memory, addr,
+                                 attrs, buf, len);
+        } else {
+                debug_ops->read(&address_space_memory, addr,
+                                attrs, buf, len);
+        }
+
+}
+
 int64_t address_space_cache_init(MemoryRegionCache *cache,
                                  AddressSpace *as,
                                  hwaddr addr,
-- 
2.17.1

