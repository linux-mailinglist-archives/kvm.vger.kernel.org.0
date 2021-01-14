Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D962F6ED5
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 00:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730830AbhANXOh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 18:14:37 -0500
Received: from mail-bn7nam10on2044.outbound.protection.outlook.com ([40.107.92.44]:1122
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725863AbhANXOg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 18:14:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NXDKiOqwTU2qh4NMxiUbM3CnhjI0jk3xq9y/6mzyFI1cRy7/Wn4ncKFE1E6ipjZv6B6jcFf4PmSBbQl/HtIOc0ojm7WRZxxy4cnoxkFKTSTZA+gO2hzftqdV1Vy7ZZE2ViOhj0kDi9dwsDPZ1nxFFlCJnFc74Bj6+X0nSeFvgWqWV7b5Cybb6hVDRmuIQrLNLC4piOZAu0/L3Wm3zlApR25FRqcG8stwq/anFjCOhrh1mtZxlhYMN+p+Q9pZbYV39ieGBIlXwpfbdzajZZU8PR9J+RPp14Y+ntz+/3oGPlLqWosH+bHsm4yerU5ke9gRsqC0WlxpLzsdW5keJM60gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bi/qRjxqO3eDHwVtQw0kC8+ET8WaZKTRPyDGmooVHfM=;
 b=DGizj93BfGQduL9O+hLDuIQ4dt56990QuaxEt6cNQAv/KIHsEDWehqf0os0GFr3TmTbPxYs0Id6cJ9fjpkriYATB6HYIn05/ddG0pdbJwebx0p0DREfYwoMOxfbVKYcxtpK00/vzJ3aD15T0wY602/7donRBJ6UvODroFSJOklNOqvs+TS1DVoutTGAiaA0osuzZ55yFbKdfcX32b2nxF9NBW0lJOxHYUlauo4K3xBUR3+Aow3RuN/4lS12Z7hmXgwba0FS+7o/InQSz44BQCN9s8wS8XEwn0EX4uAuXsWNuC447FXDClcCiqRScyl7kZDEQ79K3XCSeRpc41C13VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bi/qRjxqO3eDHwVtQw0kC8+ET8WaZKTRPyDGmooVHfM=;
 b=xM8dzoCiRCY4V1ALQs7HHSyHNC95lTObxUh0Hb3kcuONBvJL+uMYJDoKOU8pnil0Utsr5aGZUX4teAPidyzJcirulDQ8vvbiX/0oqRSOXAW0ymY624ugpw8gGHm3uxPnFwq7rJpkSBkmGIMqkhl/xmCzFdf78h7P2MX+IF7h//U=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB2503.namprd12.prod.outlook.com (2603:10b6:4:b2::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.9; Thu, 14 Jan 2021 23:13:29 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 23:13:29 +0000
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
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v5 3/6] sev/i386: Allow AP booting under SEV-ES
Date:   Thu, 14 Jan 2021 17:12:33 -0600
Message-Id: <d3c455185bffe37da738746015db553cf903c53b.1610665956.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <cover.1610665956.git.thomas.lendacky@amd.com>
References: <cover.1610665956.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0033.namprd02.prod.outlook.com
 (2603:10b6:803:2e::19) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0201CA0033.namprd02.prod.outlook.com (2603:10b6:803:2e::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Thu, 14 Jan 2021 23:13:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4490e5e2-60fd-4a04-597b-08d8b8e20151
X-MS-TrafficTypeDiagnostic: DM5PR12MB2503:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB250315C2C674F3DD5324816CECA80@DM5PR12MB2503.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oEzcX+N46s94k50QLNJ5vZaiyEj8Szxz/Y4vFBR4mXWN2mwMmtAADGTSsbygG3Ec/zIWZL2wbQ7MQsthDeHLNycbW6t385mUI4ILzLKTD9c8TpcPGl6Z8HULE94AhTwKirBAocjcGuZlK0/GWVED/oGHUvSGbVJ2HkfWQHqBhXZCqhLze0FcUT/pPURBQA+iLBesik4SmbIozyfzPjzHDIpeMPtCN9nQoYSBCuI9c/5PKTsb2QBvmj3GUtaVYSUzzOSpx5JJAzLtYGm2Y8T20IeRE08WXLAuTkg/yzrfjclgYSdsjkBCYXay+5vFQavUpQ9lJv9XuRGwWEeZWDm9TeryuSx6OTkOW50Z3LoOBdNdmlCJA8FaqslvDh9u0d2R0cNUImlYjSS+gS6+kNpzMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(8936002)(54906003)(186003)(6666004)(6486002)(16526019)(86362001)(7696005)(956004)(66476007)(66556008)(52116002)(316002)(5660300002)(7416002)(2616005)(4326008)(36756003)(26005)(478600001)(83380400001)(2906002)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ui5Iw75OwaBHB65sVHYvBq0xNc2N5DpFlM69e6rt1OrEOPyPTXcf5TQxqpV1?=
 =?us-ascii?Q?ewBjg1OhMIogeFvyXtbDrukQOupcrGKc08o1epUgX+2PQL1+XR665kYD7ARE?=
 =?us-ascii?Q?ZlPRUyw6yHpji7R4TmmVsSRITvxzCBNDJpvKaJXgGMswcWS+Ae2A3F2eudN5?=
 =?us-ascii?Q?osCJbjYz/z6WvhXY5Dag2pmv7YnvwZi4hlWvQqQopan5+6DLtRl9Lje+b1Yg?=
 =?us-ascii?Q?Fn0wrEG6gHmDXi/oA1oZGhR7KfcTK7DHQ9lwvbpf7/450UoojiVAPxm8nyg/?=
 =?us-ascii?Q?SNaxc/9J5sBUiku8uFna58wpySQUmTiv0G2iipRxxkFIEdlIaCcoYaoNyeuJ?=
 =?us-ascii?Q?7NfYruO9wNJvPUjlUtGWSfKPMsuvqt0l4yceTZ+H3tP897eQs4He8jjcyjrV?=
 =?us-ascii?Q?kQ5bET81SANXWNWk4VNszIgzg62tPrtPu8DujK0BJrli9tclpWJHhZixpADb?=
 =?us-ascii?Q?9nE3jBq6BiczsbKd+qGxD3T+3pxD6BrDYMjFBwRrkivBcWAqmCeZP6B5U5cN?=
 =?us-ascii?Q?N0S5Bg7FeqBPWzOIxkChDSBzZdNy6a8++8McbwvBrcyalQuL7Eebk9ExJ3d3?=
 =?us-ascii?Q?DgQqBi6av59BTG3gTBYkmYrMTbHe0EHoaGaRDJKIo4ffk8smGVRdvF501pa6?=
 =?us-ascii?Q?KwW/yYU7XalgOUeu4qO7ZWzO/PKFbdcGbc5uA6liEDd1MtjYsy7FwS4m32mz?=
 =?us-ascii?Q?M+wu5lfjdDIUZxqGNnKhOm8P0lMJvKJjH8ZVtmW59miZRElHHypnxJ0UMZhc?=
 =?us-ascii?Q?ukho+JlcRTbvmJWTijvGmgwVfxMyvCmfRCaTHc8hI+j8ATCd5cg2rL+OyeMN?=
 =?us-ascii?Q?CGh9QIYYNwu5dOS7sMgxHeuVQNoBe5me8R9loZ5BWeBUf4ECGsv7cUdVq/5x?=
 =?us-ascii?Q?MMuU4IxAdeA+bCsWn14yNh2KaE4iBELWmvA4tL5QcpbuALKKyicRzf9l4DaA?=
 =?us-ascii?Q?JQs5ozSXIScIF18AOhy0bFw1EEim0k9IZoaL3apchx7/D4wFculhajvipy0O?=
 =?us-ascii?Q?0wQG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 23:13:29.5853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 4490e5e2-60fd-4a04-597b-08d8b8e20151
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YJ0RmLZzYkH9OkiCbZ5y9xkaQYMCDtzPP5ICVvJykqWH9QOIDPoAtMVNGE1hndG6ji5n265BfDzAeLwJh3N5lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2503
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
encrypted and measured. Search the guest firmware for the guest for a
specific GUID that tells Qemu the value of the reset vector to use.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 accel/kvm/kvm-all.c    | 64 ++++++++++++++++++++++++++++++++++++
 accel/stubs/kvm-stub.c |  5 +++
 hw/i386/pc_sysfw.c     | 10 +++++-
 include/sysemu/kvm.h   | 16 +++++++++
 include/sysemu/sev.h   |  3 ++
 target/i386/kvm/kvm.c  |  2 ++
 target/i386/sev.c      | 74 ++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 173 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 389eaace72..9db74b465e 100644
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
@@ -123,6 +124,12 @@ struct KVMState
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
@@ -242,6 +249,62 @@ int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
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
@@ -2213,6 +2276,7 @@ static int kvm_init(MachineState *ms)
         }
 
         kvm_state->memcrypt_encrypt_data = sev_encrypt_data;
+        kvm_state->memcrypt_save_reset_vector = sev_es_save_reset_vector;
     }
 
     ret = kvm_arch_init(ms, s);
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 680e099463..162c28429e 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -91,6 +91,11 @@ int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
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
index 436b78c587..edec28842d 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -248,7 +248,8 @@ static void pc_system_flash_map(PCMachineState *pcms,
     PFlashCFI01 *system_flash;
     MemoryRegion *flash_mem;
     void *flash_ptr;
-    int ret, flash_size;
+    uint64_t flash_size;
+    int ret;
 
     assert(PC_MACHINE_GET_CLASS(pcms)->pci_enabled);
 
@@ -301,6 +302,13 @@ static void pc_system_flash_map(PCMachineState *pcms,
                  * search for them
                  */
                 pc_system_parse_ovmf_flash(flash_ptr, flash_size);
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
index bb5d5cf497..875ca101e3 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -249,6 +249,22 @@ bool kvm_memcrypt_enabled(void);
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
index 7ab6e3e31d..6f5ad3fd03 100644
--- a/include/sysemu/sev.h
+++ b/include/sysemu/sev.h
@@ -20,4 +20,7 @@ void *sev_guest_init(const char *id);
 int sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len);
 int sev_inject_launch_secret(const char *hdr, const char *secret,
                              uint64_t gpa, Error **errp);
+int sev_es_save_reset_vector(void *handle, void *flash_ptr,
+                             uint64_t flash_size, uint32_t *addr);
+
 #endif
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6dc1ee052d..aaae79557d 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1920,6 +1920,8 @@ void kvm_arch_reset_vcpu(X86CPU *cpu)
     }
     /* enabled by default */
     env->poll_control_msr = 1;
+
+    kvm_memcrypt_set_reset_vector(CPU(cpu));
 }
 
 void kvm_arch_do_init_vcpu(X86CPU *cpu)
diff --git a/target/i386/sev.c b/target/i386/sev.c
index ddec7ebaa7..badc141554 100644
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
@@ -31,6 +32,7 @@
 #include "qom/object.h"
 #include "exec/address-spaces.h"
 #include "monitor/monitor.h"
+#include "hw/i386/pc.h"
 
 #define TYPE_SEV_GUEST "sev-guest"
 OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
@@ -71,6 +73,12 @@ struct SevGuestState {
 #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
 #define DEFAULT_SEV_DEVICE      "/dev/sev"
 
+#define SEV_INFO_BLOCK_GUID     "00f771de-1a7e-4fcb-890e-68c77e2fb44e"
+typedef struct __attribute__((__packed__)) SevInfoBlock {
+    /* SEV-ES Reset Vector Address */
+    uint32_t reset_addr;
+} SevInfoBlock;
+
 static SevGuestState *sev_guest;
 static Error *sev_mig_blocker;
 
@@ -896,6 +904,72 @@ int sev_inject_launch_secret(const char *packet_hdr, const char *secret,
     return 0;
 }
 
+static int
+sev_es_parse_reset_block(SevInfoBlock *info, uint32_t *addr)
+{
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
+int
+sev_es_save_reset_vector(void *handle, void *flash_ptr, uint64_t flash_size,
+                         uint32_t *addr)
+{
+    QemuUUID info_guid, *guid;
+    SevInfoBlock *info;
+    uint8_t *data;
+    uint16_t *len;
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
+     * The SEV GUID is located on its own (original implementation) or within
+     * the Firmware GUID Table (new implementation), either of which are
+     * located 32 bytes from the end of the flash.
+     *
+     * Check the Firmware GUID Table first.
+     */
+    if (pc_system_ovmf_table_find(SEV_INFO_BLOCK_GUID, &data, NULL)) {
+        return sev_es_parse_reset_block((SevInfoBlock *)data, addr);
+    }
+
+    /*
+     * SEV info block not found in the Firmware GUID Table (or there isn't
+     * a Firmware GUID Table), fall back to the original implementation.
+     */
+    data = flash_ptr + flash_size - 0x20;
+
+    qemu_uuid_parse(SEV_INFO_BLOCK_GUID, &info_guid);
+    info_guid = qemu_uuid_bswap(info_guid); /* GUIDs are LE */
+
+    guid = (QemuUUID *)(data - sizeof(info_guid));
+    if (!qemu_uuid_is_equal(guid, &info_guid)) {
+        error_report("SEV information block/Firmware GUID Table block not found in pflash rom");
+        return 1;
+    }
+
+    len = (uint16_t *)((uint8_t *)guid - sizeof(*len));
+    info = (SevInfoBlock *)(data - le16_to_cpu(*len));
+
+    return sev_es_parse_reset_block(info, addr);
+}
+
 static void
 sev_register_types(void)
 {
-- 
2.30.0

