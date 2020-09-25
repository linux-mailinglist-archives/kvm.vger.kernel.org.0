Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE09279256
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 22:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgIYUis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 16:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728718AbgIYUif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 16:38:35 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::60e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1293C0613E2
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 12:19:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJfBWCAfHmmUL1GzvaL+BulGqmFPS1Ie8YvidOfVjmQh/BUzeue2J7kCmh8zWJ9G1LcePAP/mcm6hi7nDS4qOCySen0ZaQWswp81iXawCODIanGkikJdC/W5C+MYME9yHfq0sQi69urXvliXFft/ucTA/i5DK1HRMG+AdtPvP6wfi1HzLqVYItlM3fLwaVqHEXL0q5S9OP3Gq7rtwy3ZmaZX3rr+QGU/dPpVhMhSFIgPiEJDn6i4jqDgMYVs4s9L+ttFGzS+xKo9KGj5x63G+VyHL2hzti1f/7WhoQ90TACqzzOb95ypp8r34f4B/3hujCn3eP3BYQeJ+nWWVZWFQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxrwlL0cR26elBTmRMEa1mNxtYDzDEpSnRjqv5XNVuE=;
 b=fV7mdok+2GM0UMxBV6m5s2jPnCEua2YNpZ4WhBajamgfGE/ZaNl3Sv6Mt6WZZdSeB0avBR5Idt4yg7X1hUmuIknkWIDRVnt6kNGzxV7C+RkKAtVJSKZ95K3aH47BtIonHMMzUMYeV7ybm2X3E2Su8i62trsRKezATKxCePET9a76IdJSO1sgd11r2htNGMQYc70JZ9w0eNTRLwzMPcEf1B7MTbYFzLSIxE8vm2vnjWxS9WNDF/4AGmVJ+UPONnxRG1NGprsfSQyNLBi9uF7pKpePG414HHBJAhxsSw2C7A0qjrJu2zEr/1u/1VeCPX+0tisVWQq0w+bVy1u9/raCXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxrwlL0cR26elBTmRMEa1mNxtYDzDEpSnRjqv5XNVuE=;
 b=a8dsyG4vjzq23k4y8F6Uxc7D8VSTyyZZ0RFm/XG8ALpWPVBCbwFcBz2/jWv2JzqQLQcjsZ4p681J9w+Ka4ADjjAyBhUrcqTBXztjWB5rylFAoxqVg9c+RfJL+LafcpRK8cDdryxKZmNzmpykjJImqjm7fFQYGu8KDrw2kzTvZ40=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4297.namprd12.prod.outlook.com (2603:10b6:5:211::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.22; Fri, 25 Sep 2020 19:04:40 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.024; Fri, 25 Sep 2020
 19:04:40 +0000
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
Subject: [PATCH v4 3/6] sev/i386: Allow AP booting under SEV-ES
Date:   Fri, 25 Sep 2020 14:03:37 -0500
Message-Id: <1b65b7dfaceb5c06d3288bd47e712d2eb15a1d1d.1601060620.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601060620.git.thomas.lendacky@amd.com>
References: <cover.1601060620.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR2001CA0010.namprd20.prod.outlook.com
 (2603:10b6:4:16::20) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR2001CA0010.namprd20.prod.outlook.com (2603:10b6:4:16::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 19:04:39 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1d8d30ae-ce3f-4f1b-6046-08d86185dae2
X-MS-TrafficTypeDiagnostic: DM6PR12MB4297:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4297A9FAB5A9D64DA227AD07EC360@DM6PR12MB4297.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:224;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nBO++Vd/NNUVYcINUkmgTye0bumHN5iSr0FWWLFtjV8Q6/3gd+oiyRnjP86UiuzoNCyCh7d3eKoXpxjFQKHpk3wjzJOpBPUyPmCoCQRA1PDb+OHAO9Y8fL3QdchRZx0YCPc/pIYZvA6QmqmAXL04s2f7TgHNyDzGdEP4iYHowq8bFMumd56Ce4oihSGpc5W9//Qptrx4+jqNq/4ZsYClzixk9UiB8eLT2hiaxiMjPy0xClSBpnJwtE/8qu8Zx7Y0rw+60S1+MZGpzDe8Iq3rGOkN+Wpz5TWVcIX0STX6u6n75wTtR+N0HIkrMsZeTD8r8CmVMa2l5mbpeNNy8UWI+tXVWDcC1Vpzg73hZIvYs0bt1Sfu6AUS357rF94433+Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(396003)(376002)(39860400002)(26005)(7416002)(956004)(186003)(16526019)(54906003)(2616005)(6486002)(66556008)(66946007)(36756003)(8936002)(66476007)(86362001)(316002)(478600001)(7696005)(52116002)(2906002)(5660300002)(4326008)(83380400001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: unr8yxFOOszkFEUKauwYnQjAxgZ2vpk3h1osE8PKCmgFSb8CZ50q5il7F/9n21nTeV5O6uDR12Vv+lsd8NcPVVi66qbiN9Vk+VX+uZfwoXa1+H/fUqMcQsrelvS+JocMPgKz/aWhWlBddIShrfkvGm9NUIt41ftkfoO1tolLmreYJl0ORLSmi0gz52OT19Bwg2J6bjkksnZG9moC43N+SnoeQxzeO0nef/azPaguq4M+eQpNEZtOV6rhxFtqxb9KYWM6/HQOeKvr8775YkecUiNRpgplyIOAY5TPUcLgKitvoz+veLWkHvRMcIjtTKz63AdE/y7rOdU72ptbv3gJjOHx5kH4U/w66X6kHYAn+3oSlHnTk4gQrzOg66xx0sCxElSPCsiHDX7BBz7iaJn+/ch/yAMw4x7AnCATUCJyiT3co0uSUNpUaE0lz+XoshweBRs3HtoZwahiEEAgW/nEoFZHwhAyVnztmWvKrLkXQGa/ybiGU1VS0XVM+R45ibD30JOir28KZaSvxeN31psJsZALtmha8iHyx0BGa747x1aNkYoAejoKzcrCyQjg8BiRgAQsnbMjGP1JdznBpNkiFkgf4743byAvgeBep/T6RMQke5Z1i5mW+Z54MyAwC1aSHpgH/GQCkfUEkR8Sh/dWDA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d8d30ae-ce3f-4f1b-6046-08d86185dae2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 19:04:40.6367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6FIRNGMim4Uo70FpMxpskNcONnQ/HrVlwwvY4xLOZymaeqoCybGwBoWiewoCAyf8Izb6ELdn1xx8OrnA7Qx9pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4297
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
 target/i386/sev.c      | 59 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 158 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index ad8b315b35..08b66642dd 100644
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
+    uint32_t reset_cs;
+    uint32_t reset_ip;
+    bool reset_data_valid;
 
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
+    if (!kvm_state->reset_data_valid) {
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
+            kvm_state->reset_data_valid = true;
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
index 5bbea53883..b7ff481d61 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -254,6 +254,22 @@ bool kvm_memcrypt_enabled(void);
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
index 9efb07e7c8..7c2a3a123b 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -1913,6 +1913,8 @@ void kvm_arch_reset_vcpu(X86CPU *cpu)
     }
     /* enabled by default */
     env->poll_control_msr = 1;
+
+    kvm_memcrypt_set_reset_vector(CPU(cpu));
 }
 
 void kvm_arch_do_init_vcpu(X86CPU *cpu)
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 0d4bd3cd75..9c081173db 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -22,6 +22,7 @@
 #include "qom/object_interfaces.h"
 #include "qemu/base64.h"
 #include "qemu/module.h"
+#include "qemu/uuid.h"
 #include "sysemu/kvm.h"
 #include "sev_i386.h"
 #include "sysemu/sysemu.h"
@@ -69,6 +70,21 @@ struct SevGuestState {
 #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
 #define DEFAULT_SEV_DEVICE      "/dev/sev"
 
+/* SEV Information Block GUID = 00f771de-1a7e-4fcb-890e-68c77e2fb44e */
+static const QemuUUID sev_info_block_guid_le = {
+    .data = UUID_LE(0x00f771de, 0x1a7e, 0x4fcb,
+                    0x89, 0x0e, 0x68, 0xc7, 0x7e, 0x2f, 0xb4, 0x4e),
+};
+
+typedef struct __attribute__((__packed__)) SevInfoBlock {
+    /* SEV-ES Reset Vector Address */
+    uint32_t reset_addr;
+
+    /* SEV Information Block size and GUID */
+    uint16_t size;
+    QemuUUID guid;
+} SevInfoBlock;
+
 static SevGuestState *sev_guest;
 static Error *sev_mig_blocker;
 
@@ -831,6 +847,49 @@ sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
     return 0;
 }
 
+int
+sev_es_save_reset_vector(void *handle, void *flash_ptr, uint64_t flash_size,
+                         uint32_t *addr)
+{
+    QemuUUID *info_guid;
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
+     *
+     * Because SevInfoBlock is a packed structure, operate on the GUID
+     * directly to avoid compiler warnings/errors.
+     */
+    info_guid = flash_ptr + flash_size - 0x20 - sizeof(*info_guid);
+    if (!qemu_uuid_is_equal(info_guid, &sev_info_block_guid_le)) {
+        error_report("SEV information block not found in pflash rom");
+        return 1;
+    }
+
+    info = flash_ptr + flash_size - 0x20 - sizeof(*info);
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

