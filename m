Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC77257D79
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 17:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgHaPh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 11:37:58 -0400
Received: from mail-dm6nam08on2043.outbound.protection.outlook.com ([40.107.102.43]:56437
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729012AbgHaPhx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 11:37:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dBoo/l1dyGKjfi5t9E9FCEZ0WElaJ8h9Rp7NmnfabhiO9pKeVtxJwym5QwqJLfRIirsBLAs9muHj+/cIlrBDPnFtO3VpIuSfN3MLr8slWZx2OjsG7XfNoaKSyj/HiOYYRBx7FGFHBU+TXeSx2+YkqRV8YQU8UxG3KejLMYYuPj4OSH1r9i0GyCsD+LBe1mE78I/iphfNsZq3oZt3TMom40tcfBuNltaV/srMQ1j3AMtq1VChfJEDBQwzuiWsrz7MV36Vj/fskGpM6vP61ZBVgqBeQNE6EzPfHvhL42l0PfM6WcEeaFaynLVOo95rgCJL1zdGO3LgpV1HaBb611asLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RAFqVcWGNrVBCumzMwanuzQxEErwN32x9/5HVxnaLUM=;
 b=kT5fV3ATLvMB8m3z9+Aq78BX2u1Pnhk4QvEgmAihP8CjAJ1jrdy82XG1uI7s/Ii3hshNKELKV+tCh/wcVKNW5e/EAVI/Pv0IjWBvbHWyAg0/WJzVnkRHWtRXNTTiQ7Qs/nUtxQidklJ+Yh6iR69ASFeE/rKMzDq8i0HwQsTfotY77mOMRiV5FOK5hP35rOQ3Bo1ybCpwv3I2jL2MBMwSTUap9SFvqHV4FHJtjMZo4hJ8GmF5TrOGqk5Sb/oSMpiSDAfYZBZLf33n0jJodeupRq6ZqQHWhlb54do/n9M/kFTXrYHQGFiqokqDmLWx+QFWKjNC08fYDEukuAAaKS4YbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RAFqVcWGNrVBCumzMwanuzQxEErwN32x9/5HVxnaLUM=;
 b=EgFXawrwixoAAtnCepVrbnHGF/CaaF4V9rcUIj1LfxBOcKaURHgPYEOurLfy9zv9/VH9glXruiRwJWZ7Bs4PTBmOVR6UbhzmmDfDFyFlwTQGTCsAYklP00e4rBT6wnXA+3o8edwTVRH28fbGTVpiOiopeg7GUkBOkdRhCfTUB/E=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4484.namprd12.prod.outlook.com (2603:10b6:5:28f::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3326.19; Mon, 31 Aug 2020 15:37:45 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 15:37:45 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v2 2/4] sev/i386: Allow AP booting under SEV-ES
Date:   Mon, 31 Aug 2020 10:37:11 -0500
Message-Id: <3f4edde053460c94a6611ce2dde35851f93c9cb7.1598888232.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1598888232.git.thomas.lendacky@amd.com>
References: <cover.1598888232.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0401CA0048.namprd04.prod.outlook.com
 (2603:10b6:803:2a::34) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by SN4PR0401CA0048.namprd04.prod.outlook.com (2603:10b6:803:2a::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Mon, 31 Aug 2020 15:37:44 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3da89453-4fd1-4a9a-26c1-08d84dc3ce4c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4484:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB44843F9AF7A6E90BE5DF7111EC510@DM6PR12MB4484.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:568;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g06XzJdZa0oTIi2EELwfVs6aNwVQ98+Qmrn2drr+vntErFltRQ71mMt6gyaM+SbxukSBPKSledrQAw7u7A3U7M5D4gPNO/Lzc43q0ifjWLMBiAG1CN1wce8p19CPbfj2Ub5psJ7Wvt3+eFatiwHyZBsTH0Lk7V0GNa81fYGVOpR0gAe4seIcAXrZlLujEufUjgNRunTRIOL/OQ4xBrNi7u4qqinMJPc1AJ1Cth9bDdWQpmOs2dkKmLGnhpE+LLtyQdnQkx0JUbPxzoUAJqDcecp/xSVIlKdoDvDUHbMj7nHgqIdRNOmHbCSv2zybCN9kEe2JuUJ+9DDzEJevYxYQOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(54906003)(956004)(16576012)(7416002)(2906002)(6666004)(4326008)(2616005)(6486002)(316002)(66556008)(8676002)(66946007)(478600001)(186003)(5660300002)(8936002)(86362001)(83380400001)(66476007)(36756003)(52116002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kmwy0CsI3sVrcbh4SlfMBBWImml/ZhEiA7guqDsgrtY78kqR8BMZWWBXf5I+/Xq66bk5XVXiW4ZL0gyl7An4uYApYUeGi1eOCA83+/1B/VjAzDcy4RShD7b9udstuJMPHLj9nECm4H+79VrNMmYwd737JdxCp68fffzPXDYx0WExZSxiii2NfQrEpTJrrXQQG87affapcNSW0XFdBD2JnCp75dTGwa56rrAO2ve5XnMgMM7XJJyYPsiZEtp6Ph2qSJV+q+uevZEUbsul5ejNLOrKQJhFnNFJ+mx18YyhSJb9gncwNr/R5CB8F8vf9TTYP1mmmnKVBHYKxhX4/vNoFRQ7ncDcB1hdQCttRxcT2xKRYylOjQRVIT+ys+yPxF3ZeAq2PrfhnJx833wDNca/KU8ZjECnrDhKfkLac9Q6YR711svcZpMRlme+Uy5tJySXvtNd9Fk9tHnNtd3LPDKfZPVPfEYxUUsESVqdXcbLbJ85goGSo4jSi4rGumXAMchjnTPFYvAekIz2Dsrxb4VHILXgaCFwec4qKtBFbwwpgvvFRld53FPWS/IQhaqo2q6e/FSavfswbmID92zr8QJddbAHoZBkrJQaKyEav7QS8XvERvbHyXxbT4WvO1WxWvRJW0rqK62L5sHyy7KcVpUHgw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3da89453-4fd1-4a9a-26c1-08d84dc3ce4c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 15:37:45.2351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rurh7oXpfA59WqVLUvjEAPqdgVFJEBk63qERRu1ov/W9dvxAKV2JyeSsmWnR9DjRgjxs0+WFCkj0FOOEgNQV1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4484
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

When SEV-ES is enabled, it is not possible modify the guests register
state after it has been initially created, encrypted and measured.

Normally, an INIT-SIPI-SIPI request is used to boot the AP. However, the
hypervisor cannot emulate this because it cannot update the AP register
state. For the very first boot by an AP, the reset vector CS segment
value and the EIP value must be programmed before the register has been
encrypted and measured.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 accel/kvm/kvm-all.c    | 64 ++++++++++++++++++++++++++++++++++++++++++
 accel/stubs/kvm-stub.c |  5 ++++
 hw/i386/pc_sysfw.c     | 10 ++++++-
 include/sysemu/kvm.h   | 16 +++++++++++
 include/sysemu/sev.h   |  3 ++
 target/i386/kvm.c      |  2 ++
 target/i386/sev.c      | 51 +++++++++++++++++++++++++++++++++
 7 files changed, 150 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 63ef6af9a1..20725b0368 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -39,6 +39,7 @@
 #include "qemu/main-loop.h"
 #include "trace.h"
 #include "hw/irq.h"
+#include "sysemu/kvm.h"
 #include "sysemu/sev.h"
 #include "qapi/visitor.h"
 #include "qapi/qapi-types-common.h"
@@ -120,6 +121,12 @@ struct KVMState
     /* memory encryption */
     void *memcrypt_handle;
     int (*memcrypt_encrypt_data)(void *handle, uint8_t *ptr, uint64_t len);
+    int (*memcrypt_save_reset_vector)(void *handle, void *flash_ptr,
+                                      uint64_t flash_size, uint32_t *addr);
+
+    unsigned int reset_cs;
+    unsigned int reset_ip;
+    bool reset_valid;
 
     /* For "info mtree -f" to tell if an MR is registered in KVM */
     int nr_as;
@@ -239,6 +246,62 @@ int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
     return 1;
 }
 
+void kvm_memcrypt_set_reset_vector(CPUState *cpu)
+{
+    X86CPU *x86;
+    CPUX86State *env;
+
+    /* Only update if we have valid reset information */
+    if (!kvm_state->reset_valid) {
+        return;
+    }
+
+    /* Do not update the BSP reset state */
+    if (cpu->cpu_index == 0) {
+        return;
+    }
+
+    x86 = X86_CPU(cpu);
+    env = &x86->env;
+
+    cpu_x86_load_seg_cache(env, R_CS, 0xf000, kvm_state->reset_cs, 0xffff,
+                           DESC_P_MASK | DESC_S_MASK | DESC_CS_MASK |
+                           DESC_R_MASK | DESC_A_MASK);
+
+    env->eip = kvm_state->reset_ip;
+}
+
+int kvm_memcrypt_save_reset_vector(void *flash_ptr, uint64_t flash_size)
+{
+    CPUState *cpu;
+    uint32_t addr;
+    int ret;
+
+    if (kvm_memcrypt_enabled() &&
+        kvm_state->memcrypt_save_reset_vector) {
+
+        addr = 0;
+        ret = kvm_state->memcrypt_save_reset_vector(kvm_state->memcrypt_handle,
+                                                    flash_ptr, flash_size,
+                                                    &addr);
+        if (ret) {
+            return ret;
+        }
+
+        if (addr) {
+            kvm_state->reset_cs = addr & 0xffff0000;
+            kvm_state->reset_ip = addr & 0x0000ffff;
+            kvm_state->reset_valid = true;
+
+            CPU_FOREACH(cpu) {
+                kvm_memcrypt_set_reset_vector(cpu);
+            }
+        }
+    }
+
+    return 0;
+}
+
 /* Called with KVMMemoryListener.slots_lock held */
 static KVMSlot *kvm_get_free_slot(KVMMemoryListener *kml)
 {
@@ -2193,6 +2256,7 @@ static int kvm_init(MachineState *ms)
         }
 
         kvm_state->memcrypt_encrypt_data = sev_encrypt_data;
+        kvm_state->memcrypt_save_reset_vector = sev_es_save_reset_vector;
     }
 
     ret = kvm_arch_init(ms, s);
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 82f118d2df..3aece9b513 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -114,6 +114,11 @@ int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
   return 1;
 }
 
+int kvm_memcrypt_save_reset_vector(void *flash_ptr, uint64_t flash_size)
+{
+    return -ENOSYS;
+}
+
 #ifndef CONFIG_USER_ONLY
 int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev)
 {
diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index b6c0822fe3..321ff94261 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -156,7 +156,8 @@ static void pc_system_flash_map(PCMachineState *pcms,
     PFlashCFI01 *system_flash;
     MemoryRegion *flash_mem;
     void *flash_ptr;
-    int ret, flash_size;
+    uint64_t flash_size;
+    int ret;
 
     assert(PC_MACHINE_GET_CLASS(pcms)->pci_enabled);
 
@@ -204,6 +205,13 @@ static void pc_system_flash_map(PCMachineState *pcms,
             if (kvm_memcrypt_enabled()) {
                 flash_ptr = memory_region_get_ram_ptr(flash_mem);
                 flash_size = memory_region_size(flash_mem);
+
+                ret = kvm_memcrypt_save_reset_vector(flash_ptr, flash_size);
+                if (ret) {
+                    error_report("failed to locate and/or save reset vector");
+                    exit(1);
+                }
+
                 ret = kvm_memcrypt_encrypt_data(flash_ptr, flash_size);
                 if (ret) {
                     error_report("failed to encrypt pflash rom");
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index b4174d941c..f74cfa85ab 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -247,6 +247,22 @@ bool kvm_memcrypt_enabled(void);
  */
 int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len);
 
+/**
+ * kvm_memcrypt_set_reset_vector - sets the CS/IP value for the AP if SEV-ES
+ *                                 is active.
+ */
+void kvm_memcrypt_set_reset_vector(CPUState *cpu);
+
+/**
+ * kvm_memcrypt_save_reset_vector - locates and saves the reset vector to be
+ *                                  used as the initial CS/IP value for APs
+ *                                  if SEV-ES is active.
+ *
+ * Return: 1 SEV-ES is active and failed to locate a valid reset vector
+ *         0 SEV-ES is not active or successfully located and saved the
+ *           reset vector address
+ */
+int kvm_memcrypt_save_reset_vector(void *flash_prt, uint64_t flash_size);
 
 #ifdef NEED_CPU_H
 #include "cpu.h"
diff --git a/include/sysemu/sev.h b/include/sysemu/sev.h
index 98c1ec8d38..5198e5a621 100644
--- a/include/sysemu/sev.h
+++ b/include/sysemu/sev.h
@@ -18,4 +18,7 @@
 
 void *sev_guest_init(const char *id);
 int sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len);
+int sev_es_save_reset_vector(void *handle, void *flash_ptr,
+                             uint64_t flash_size, uint32_t *addr);
+
 #endif
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 6f18d940a5..10eaba8943 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -1912,6 +1912,8 @@ void kvm_arch_reset_vcpu(X86CPU *cpu)
     }
     /* enabled by default */
     env->poll_control_msr = 1;
+
+    kvm_memcrypt_set_reset_vector(CPU(cpu));
 }
 
 void kvm_arch_do_init_vcpu(X86CPU *cpu)
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 6c9cd0854b..0bc497379b 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -70,6 +70,19 @@ struct SevGuestState {
 #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
 #define DEFAULT_SEV_DEVICE      "/dev/sev"
 
+/* SEV Information Block GUID = 00f771de-1a7e-4fcb-890e-68c77e2fb44e */
+#define SEV_INFO_BLOCK_GUID \
+    "\xde\x71\xf7\x00\x7e\x1a\xcb\x4f\x89\x0e\x68\xc7\x7e\x2f\xb4\x4e"
+
+typedef struct __attribute__((__packed__)) SevInfoBlock {
+    /* SEV-ES Reset Vector Address */
+    uint32_t reset_addr;
+
+    /* SEV Information Block size and GUID */
+    uint16_t size;
+    char guid[16];
+} SevInfoBlock;
+
 static SevGuestState *sev_guest;
 static Error *sev_mig_blocker;
 
@@ -827,6 +840,44 @@ sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
     return 0;
 }
 
+int
+sev_es_save_reset_vector(void *handle, void *flash_ptr, uint64_t flash_size,
+                         uint32_t *addr)
+{
+    SevInfoBlock *info;
+
+    assert(handle);
+
+    /*
+     * Initialize the address to zero. An address of zero with a successful
+     * return code indicates that SEV-ES is not active.
+     */
+    *addr = 0;
+    if (!sev_es_enabled()) {
+        return 0;
+    }
+
+    /*
+     * Extract the AP reset vector for SEV-ES guests by locating the SEV GUID.
+     * The SEV GUID is located 32 bytes from the end of the flash. Use this
+     * address to base the SEV information block.
+     */
+    info = flash_ptr + flash_size - 0x20 - sizeof(*info);
+    if (memcmp(info->guid, SEV_INFO_BLOCK_GUID, 16)) {
+        error_report("SEV information block not found in pflash rom");
+        return 1;
+    }
+
+    if (!info->reset_addr) {
+        error_report("SEV-ES reset address is zero");
+        return 1;
+    }
+
+    *addr = info->reset_addr;
+
+    return 0;
+}
+
 static void
 sev_register_types(void)
 {
-- 
2.28.0

