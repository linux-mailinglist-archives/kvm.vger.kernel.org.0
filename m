Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BE0251F84
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 21:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgHYTGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 15:06:23 -0400
Received: from mail-bn7nam10on2056.outbound.protection.outlook.com ([40.107.92.56]:7937
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726471AbgHYTGR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 15:06:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJv7bHW3sqYN3ZdWO0NJY7sjyJpAdeV9qc1eE2kWzcft41UR8ZTxc7H/CixSuiw9ryksD9d5mONIpxFaEABv3wYjm3l/qanV3lC0/scauP/TIB/XrVazDVDtSzDOw1BCcCFBh0arK9tSHMmcwgIvSHaz+Qix9zXxixFcKLyqSZLIO6PdqE4ZFtt20ZBngqz1vmSZeHjnfWW93tyfcLuYoYL3/gjgDPG/QziIUQa7gfGGDSCajMpqvaSqOmI9u9fEX4sjbLbwdFoz7SKnmGDBrOnQAOYzjV2aQepHzuorBa2zdeODRqtIEtYit0HEGET8xJZ7xRkxxleuqrl3snb7DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXpZsopJUS+9+DSP2X2MdQm/93801DxJ2bVFn2+m9Uo=;
 b=RZGexH1ylyWpGR+itYOuR2DbnDlb4kf4Oh48G0P7Bf0WnEZb2y3EHb5pY3mfSNWixbsywSt/EkvlYIzRYfyln3kLftGebggRT1QG3TFrg89BE0Ua6sHfAsP7GWCWK4Ggw/B8eXxABtbK35mrxsWf7Mgm3n7SZkSjCsfIYtq/F7dA/UNPJVLxyPiNroSMe/5Z6hoNSlIw4HvN9oMCgmI/toCMKnmGDl+YbbB+v94jS1ctwd4djm9zpHw/iYftTkQc/BAyHPKwQo3v5ocQ58gLuLgHE2sNKE54hMaOOPdGhjETljmGZ4ovgVOxOhXSn/xDM0Mu+pgHux0IlhTY/zANNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXpZsopJUS+9+DSP2X2MdQm/93801DxJ2bVFn2+m9Uo=;
 b=2sIZU4YI9MQohUUcL5NyGwGa+pyzHgFrbbQWGeH/xd/E6hR6F1GVvnwpOItd2J9KfiowQPzvOYR0kF32pFlThvlZT4c3+noSzwR/efuZ+70omgBbH26ffGW98B8xcBlH7ZyHH2Fc8dNnZdtUuNdbgTRJMoBrw9Ofx0Qo/WFYK0E=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR1201MB0219.namprd12.prod.outlook.com (2603:10b6:4:56::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.25; Tue, 25 Aug 2020 19:06:14 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 19:06:14 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: [PATCH 2/4] sev/i386: Allow AP booting under SEV-ES
Date:   Tue, 25 Aug 2020 14:05:41 -0500
Message-Id: <a3fc1bfb697a85865710fa99a3e1169e7d355a18.1598382343.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1598382343.git.thomas.lendacky@amd.com>
References: <cover.1598382343.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0066.namprd03.prod.outlook.com
 (2603:10b6:5:100::43) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by DM6PR03CA0066.namprd03.prod.outlook.com (2603:10b6:5:100::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Tue, 25 Aug 2020 19:06:13 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 133609e1-5380-4e50-025a-08d84929efe6
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0219:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0219DA90A6F92B26E270E141EC570@DM5PR1201MB0219.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:568;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ue0KsU/mk1CqW8Oib4jeLn33wRBxqkrtMZmzZlWEetuVXZjSVXhY8La90LV8VIJ4j7YtXlWS/+/0w4hZ6N7Y/4n0HDu4sxB8KLt9iKg0RIAP/EE1tKqhm3MJnraczx1YM01EfIbsoSjbRjBU1QASZynLR7WPHcf8kw2Xal+gYOPKNr7WeFyAbdIlDMv5kbafI+Kyaa3pnVNX1DYfXoUCgvf0o9HoyPUrEUoCOi2QSkjb5JeLcwsk1ZN2HPMpzHk9aSvgsUTT44V+X6JAQL/JKg+NuaKg0D1E2WIwAfIzdzc0RzVNjzT0Tv/u8N5qvxBXwpBTiFpxDF1Hllpgd4TbkmVMsPCl9gj2A9MsSB8lCMLBScZ9C7QkAfVRw8FiOfJc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(4326008)(186003)(86362001)(8676002)(83380400001)(54906003)(16576012)(8936002)(6486002)(316002)(478600001)(36756003)(52116002)(26005)(6666004)(66556008)(2616005)(66476007)(66946007)(956004)(2906002)(5660300002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JbVVL9uA5aRZp/eJZxp2sMZMBDx7+Or2HzlsR9kVU7nq1At1ueTOTezchmi4pMT0jKZFMiQDy1LDK5n3c85pXG3KVV0+YmcAMQbeax4WArTpxSNVlOg5BKsXBD508xer18CrNFd9VZqB+JApO8v1M28feouzeimO4/qZgkIx0+t9WhZVfJfdWwchxztu3cEIkGzDkNPTCnXNts6nci6rarimZ/CY2cOCHMWCpyPN/vw9oylBec5p29+A/GU3VSZOeFRuU3WlV8TX5gmMCEc0s2o9SsqEldyM3spi699DoTNn0D0VcHU3ycd6ZyAI1XSxYX5kIYwzhJrk1zTz+APZR26rTPnF85e0sdZtZp5E675+zqX2E/hdbHpqiyKaHeKeI4GxVfcWYkYG1PoaNNHjvHJpf03hOJge0G8mcJpUryKZKox5bZTgG2HNb2+lKu4QlWNn2eX1S9hwsTS+Uqum01Q1HhuAG08wRtbQiFuxYNCC86i3JG7lf0MVTGnqbDvMOkVO2f0f6IVtbcrxlWU9SacKRBF2YCp2YLblSplOx3xLDBd9Lru/mktxf+6Seu8tJ9bjXt6o6cQgJNr9QqpKRIfsrB7UVwGkIDYl86L9N9yfbCXDzFcZVu5V4oeLuskWiEhjAjXjnJdx7RDYNDLZRw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 133609e1-5380-4e50-025a-08d84929efe6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 19:06:14.3149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oe10q60ni7whalyQp92I5PHAqq/HPrk6K6GmYabWACWqKs31vb7zt4rC3q3WdJ8ZVJ9Ua5rZlJaJaSN8X+TIPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0219
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
 accel/kvm/kvm-all.c    | 60 ++++++++++++++++++++++++++++++++++++++++++
 accel/stubs/kvm-stub.c |  5 ++++
 hw/i386/pc_sysfw.c     | 10 ++++++-
 include/sysemu/kvm.h   | 16 +++++++++++
 include/sysemu/sev.h   |  2 ++
 target/i386/kvm.c      |  2 ++
 target/i386/sev.c      | 47 +++++++++++++++++++++++++++++++++
 7 files changed, 141 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 63ef6af9a1..54e8fd098d 100644
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
@@ -120,6 +121,11 @@ struct KVMState
     /* memory encryption */
     void *memcrypt_handle;
     int (*memcrypt_encrypt_data)(void *handle, uint8_t *ptr, uint64_t len);
+    int (*memcrypt_save_reset_vector)(void *handle, void *flash_ptr, uint64_t flash_size, uint32_t *addr);
+
+    unsigned int reset_cs;
+    unsigned int reset_ip;
+    bool reset_valid;
 
     /* For "info mtree -f" to tell if an MR is registered in KVM */
     int nr_as;
@@ -239,6 +245,59 @@ int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
     return 1;
 }
 
+void kvm_memcrypt_set_reset_vector(CPUState *cpu)
+{
+    X86CPU *x86;
+    CPUX86State *env;
+
+    /* Only update if we have valid reset information */
+    if (!kvm_state->reset_valid)
+        return;
+
+    /* Do not update the BSP reset state */
+    if (cpu->cpu_index == 0)
+        return;
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
+                                                    flash_ptr, flash_size, &addr);
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
@@ -2193,6 +2252,7 @@ static int kvm_init(MachineState *ms)
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
index 98c1ec8d38..f48bfa55a7 100644
--- a/include/sysemu/sev.h
+++ b/include/sysemu/sev.h
@@ -18,4 +18,6 @@
 
 void *sev_guest_init(const char *id);
 int sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len);
+int sev_es_save_reset_vector(void *handle, void *flash_ptr, uint64_t flash_size, uint32_t *addr);
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
index 6c9cd0854b..5146b788fb 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -70,6 +70,18 @@ struct SevGuestState {
 #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
 #define DEFAULT_SEV_DEVICE      "/dev/sev"
 
+/* SEV Information Block GUID = 00f771de-1a7e-4fcb-890e-68c77e2fb44e */
+#define SEV_INFO_BLOCK_GUID "\xde\x71\xf7\x00\x7e\x1a\xcb\x4f\x89\x0e\x68\xc7\x7e\x2f\xb4\x4e"
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
 
@@ -827,6 +839,41 @@ sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
     return 0;
 }
 
+int
+sev_es_save_reset_vector(void *handle, void *flash_ptr, uint64_t flash_size, uint32_t *addr)
+{
+    SevInfoBlock *info;
+
+    assert(handle);
+
+    /* Initialize the address to zero. An address of zero with a sucessful
+     * return code indicates that SEV-ES is not active.
+     */
+    *addr = 0;
+    if (!sev_es_enabled()) {
+        return 0;
+    }
+
+    /* Extract the AP reset vector for SEV-ES guests by locating the SEV GUID.
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

