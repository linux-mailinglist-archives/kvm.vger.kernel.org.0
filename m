Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668C6304C57
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 23:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbhAZWil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:38:41 -0500
Received: from mail-co1nam11on2074.outbound.protection.outlook.com ([40.107.220.74]:33601
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392739AbhAZRjm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 12:39:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ozp5cCdfzw9gZ2Z6zLeSbhJ10EtIJPdd1KffSFi4/aMzAplMcGJcWWZZc8mPUfbpsgc7Zc4y4YYIPzewGMRSzkQeFUkGzplDiAyVK2hltp29py83ueQLjbtYxA/GGaw8Ypdea5vSQvWnaCISsQCx7AH28MrNMKMu/OHzOTARPcftaCgjp95U817Pl3+rK3XQ8c2Y/H/YgRgUsHbuZWaVBu9Y5Rs2ImyrNQqbqwvsH99Q/sXtuwEusRcZMCoPi/Ju60P/oWtBuW3EXblqYwhCw6bFHKLh5PJowbh9z2JFElycgKBOlpXnHKu1zfG/u3kq/SENnXca0jPwzK3SQGRWsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qn6uXkYsgPpBufxkwzzkYaYmmLis3W0DaS30xUlTKeg=;
 b=nFI2Gs7imtRUdE2QPsHz4UmA7Xobli51Z7rzlegts58/Y4uriTaQoTB74jxGxjHXH23kt0Y3psnC1QiWSQxVJoXBmdIlkL8ZBHpH7Wk4+xyLZkth0dcXlHJMv7lu/Q2Oo7B5wIWeRNTN1iB2+rAH7Rx6EEUyP2m8F8I+xXP4re8eUJhZq805VZOMqMQdkv/Nj658rv75ywBBn4+PdpIpnssXOTF7pSiMPSFhhygKvOp1mzMPUklG9sAFwqM+N2WnYKFZpOV/Q9QovmD+4H2P93oheLf2eV6e9onW847on/rW5rdB7HbB8Y4f+tuiuBKaLQFrPJEIUJmsaBpqEJ8tug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qn6uXkYsgPpBufxkwzzkYaYmmLis3W0DaS30xUlTKeg=;
 b=YM1pjoEmEW52QWTASSsus+5zIixS5F/FnlzJS1y01W4GvApygh/oAjb72NMPA2H5vTpJXZ2qOzF+kt12Kr1nKA/VArzsusgNe/wuVgLCfhIKEbM0iLo8dCGCz9EMDAJmpfe2pfPlwGkmSMK5Cs9qUupczb0dB5ha0MH/KVXqDSg=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4153.namprd12.prod.outlook.com (2603:10b6:5:212::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.13; Tue, 26 Jan 2021 17:37:29 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914%4]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 17:37:29 +0000
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
Subject: [PATCH v6 3/6] sev/i386: Allow AP booting under SEV-ES
Date:   Tue, 26 Jan 2021 11:36:46 -0600
Message-Id: <22db2bfb4d6551aed661a9ae95b4fdbef613ca21.1611682609.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <cover.1611682609.git.thomas.lendacky@amd.com>
References: <cover.1611682609.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR2101CA0009.namprd21.prod.outlook.com
 (2603:10b6:805:106::19) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN6PR2101CA0009.namprd21.prod.outlook.com (2603:10b6:805:106::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.2 via Frontend Transport; Tue, 26 Jan 2021 17:37:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9f9004f9-2721-40f8-9aca-08d8c2210dc4
X-MS-TrafficTypeDiagnostic: DM6PR12MB4153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4153C460FE519587EC87D2D1ECBC9@DM6PR12MB4153.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4XOQCJx93cCHqL3Iz2nOaHEs6mENhZyct066DqwfzhyLCjoQy+1fr+JtMyFfs9AcBzxjf/g0Itmgi30/UQavW3VmF4KRZD/+GmYg+W2N2E0OIjEBv3hxxoR5KLXQVR62jdjZjWLESMJHVq32AQyq+shDsXgD/7wpI8ojqQIt9A9Ok2e6gSLO/o11U5KtRUx6RXpxm6E8NXb0z8yXozJc1plcHyCgdC5vmOqIoEOJ04grTb9fPMszbxUl6XZ1GCaD9UiQTo4BT8gEreElZmrFFRra40xyUILpJdDyeQVA+rlwiiWlX25cUvUPIAlLxRgvSMolqIToi8gosYvyr0IeGrOYCrnVY5GdrtynVNFO9WlKG042gExFR78OupbrLSxU1vVwpPBELgRh5v9ZDXt5wQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(8676002)(7696005)(52116002)(478600001)(6666004)(7416002)(4326008)(2906002)(66476007)(316002)(54906003)(5660300002)(26005)(2616005)(956004)(86362001)(83380400001)(36756003)(186003)(16526019)(6486002)(66946007)(8936002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?O+Y8xzGb/RtB4aEwz3MoKuhAIiZ7nADqJ5Hkbab2tR9V5C7d103VTd9BfdlP?=
 =?us-ascii?Q?GLbsWs82DgMNWc78HegjPEOYVb7if4z94BD5z4m8H6hprbIkMkHtlqJQar3W?=
 =?us-ascii?Q?rGUa0j5wh3KumVGUJVLZGx0/wi1tiUtG0fKJI20p8cLMVbYIWb3l3d4E8+N8?=
 =?us-ascii?Q?diKWLNmAmjDB/D4VE3DXYYGTkrt8cyuj2z5oWXhZj9Q3U2pttYWEarPyRV7e?=
 =?us-ascii?Q?/hTMu0wYbegzAwwp9Z1E237Ggrx4IBtnpvDGiLAM2W0cgICxV/MbW/uq6KM5?=
 =?us-ascii?Q?VT9kVVG7gBHImtd8BRvkWHkY8R71IE5tgkAW60TdHxCcyQ/eJOF12pxXcf0H?=
 =?us-ascii?Q?RROCGWf1TQBR5sCbeng0kfVMGXYSotbbxwj9ZRVQbhGMVZ0kMbC9HNnRGNjD?=
 =?us-ascii?Q?7Bo4lBZwQI9IaJb/RVhlKkg5aqwHHr+9ANYV3UumC1bzfrMoa9VBfySgp7rC?=
 =?us-ascii?Q?o8kkSI74SXyajMVP1seZmjEiDDAkhrjjJnL7pd05hTC5DO6IabtBbRtqOhPn?=
 =?us-ascii?Q?z6p1hmBflz094RdNXs2+0Ags3xShz1WkO2FsdwCwXWkQFNYPoDomQMrbNC3A?=
 =?us-ascii?Q?RXys6Fa04tmlh9i9a/W9gShi4o+l/glrdk8vytd8qNezM3/30FAXjhfMMw4p?=
 =?us-ascii?Q?gw0NAuK/Fzu6FSStOx30lcyAphej8jYQxagj1B2Lp6uG/e8wxQEDJS99LgrM?=
 =?us-ascii?Q?+gvrLysu/ZVbUGgI/asR2JirojSDppnxCEzThHW+LwHq3Js8CzXBPonmMDK2?=
 =?us-ascii?Q?8VWpjUJitQOgDzCL0gjwo8gcvMUjTPBaELwj3cxOdYGtPFEBEoeC1Avc/VEJ?=
 =?us-ascii?Q?XnIdj1RYwdcOh+1WA7c8d1S2KEwugqBIIJClMfKXT+F9jtxZDUA2xxWtytxv?=
 =?us-ascii?Q?U70yQi5iElOtioJ/g/gE50PXqRlQAfh4c+STK3dp3EexI3gZ3DeGLUrIj36T?=
 =?us-ascii?Q?ExcMddja7eq0UjmrcsK2USlI4yRJR9GQTa9DeWCyZLTKnkEA+BPCiFOLKLBM?=
 =?us-ascii?Q?yfa9nIs94BRTCdPlCeAy9VT7GaPiDCF6Vd9M4B9FFc4gD/R5VLE1RXt5dKAj?=
 =?us-ascii?Q?bmcIwM0K?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f9004f9-2721-40f8-9aca-08d8c2210dc4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 17:37:29.5172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jrSFNohBX3e1gsD0R+Hz+KH4Y/c8O/3zCRyqSvsdAsPI+o9W9MuL+G+aXxYDrPA+Z2DyNjxjoCOUr8hBLBc+vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4153
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
index 3feb17d965..410879cf94 100644
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
@@ -126,6 +127,12 @@ struct KVMState
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
@@ -245,6 +252,62 @@ int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
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
@@ -2216,6 +2279,7 @@ static int kvm_init(MachineState *ms)
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

