Return-Path: <kvm+bounces-27539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CF6A986BC5
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 06:40:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44C7D1F23372
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 04:40:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84AB75647F;
	Thu, 26 Sep 2024 04:40:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC66914F10E
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 04:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727325604; cv=none; b=S5ZaTf8OP7ETbauvq/QoW8QKuVVVyN5DUsTmRxKkiWwGolS9lVgDOb9eM3t/0z27tmGIJJY8ThAuHI81DbrcuYmyRsjx7Zf86xewbNvXQhfg41U1PevdtVmqZjGafRFTNIHEnHXr4oCPzgi3hMR/5cJLahPZTAcX1Ud1bLfeytY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727325604; c=relaxed/simple;
	bh=uxGZd4lcfEB9nXDIOTkhiapd9qguw8Xzz/DoZQYuR6o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nZQFfrFt2AA9WeoXyT3OKUj6AE2oLZtROePsGeubVTvXCnU8/WxL32om/iBcQocieP0KIY11YJNKJISorhvk3Jdh7uwSvNJft5/ulYKID/gGQbnV40a+CiL9pgw+9Q6tGOMdTgAUzNxxJ5SvlCYsxPAuB6DUl59bqL9RkNSRTRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: Gao Shiyuan <gaoshiyuan@baidu.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, <gaoshiyuan@baidu.com>
Subject: [PATCH v1 1/1] x86: Add support save/load HWCR MSR
Date: Thu, 26 Sep 2024 12:08:08 +0800
Message-ID: <20240926040808.9158-1-gaoshiyuan@baidu.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BC-Mail-EX08.internal.baidu.com (172.31.51.48) To
 bjkjy-mail-ex26.internal.baidu.com (172.31.50.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex10_2024-09-26 12:08:16:428
X-FEAS-Client-IP: 10.127.64.33
X-FE-Policy-ID: 52:10:53:SYSTEM

KVM commit 191c8137a939 ("x86/kvm: Implement HWCR support")
introduced support for emulating HWCR MSR.

Add support for QEMU to save/load this MSR for migration purposes.

Signed-off-by: Gao Shiyuan <gaoshiyuan@baidu.com>
---
 target/i386/cpu.c     |  1 +
 target/i386/cpu.h     |  5 +++++
 target/i386/kvm/kvm.c | 12 ++++++++++++
 target/i386/machine.c | 20 ++++++++++++++++++++
 4 files changed, 38 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 85ef7452c0..339131a39a 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7093,6 +7093,7 @@ static void x86_cpu_reset_hold(Object *obj, ResetType type)
     env->a20_mask = ~0x0;
     env->smbase = 0x30000;
     env->msr_smi_count = 0;
+    env->hwcr = 0;
 
     env->idt.limit = 0xffff;
     env->gdt.limit = 0xffff;
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 14edd57a37..a19b1ceda4 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -539,6 +539,8 @@ typedef enum X86Seg {
 
 #define MSR_AMD64_TSC_RATIO_DEFAULT     0x100000000ULL
 
+#define MSR_K7_HWCR                     0xc0010015
+
 #define MSR_VM_HSAVE_PA                 0xc0010117
 
 #define MSR_IA32_XFD                    0x000001c4
@@ -1859,6 +1861,9 @@ typedef struct CPUArchState {
     uint64_t msr_lbr_depth;
     LBREntry lbr_records[ARCH_LBR_NR_ENTRIES];
 
+    /* Hardware Configuration MSR */
+    uint64_t hwcr;
+
     /* exception/interrupt handling */
     int error_code;
     int exception_is_int;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index ada581c5d6..215c13eb13 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -145,6 +145,7 @@ static bool has_msr_ucode_rev;
 static bool has_msr_vmx_procbased_ctls2;
 static bool has_msr_perf_capabs;
 static bool has_msr_pkrs;
+static bool has_msr_hwcr;
 
 static uint32_t has_architectural_pmu_version;
 static uint32_t num_architectural_pmu_gp_counters;
@@ -2554,6 +2555,8 @@ static int kvm_get_supported_msrs(KVMState *s)
             case MSR_IA32_PKRS:
                 has_msr_pkrs = true;
                 break;
+            case MSR_K7_HWCR:
+                has_msr_hwcr = true;
             }
         }
     }
@@ -3824,6 +3827,9 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
     if (has_msr_virt_ssbd) {
         kvm_msr_entry_add(cpu, MSR_VIRT_SSBD, env->virt_ssbd);
     }
+    if (has_msr_hwcr) {
+        kvm_msr_entry_add(cpu, MSR_K7_HWCR, env->hwcr);
+    }
 
 #ifdef TARGET_X86_64
     if (lm_capable_kernel) {
@@ -4308,6 +4314,9 @@ static int kvm_get_msrs(X86CPU *cpu)
         kvm_msr_entry_add(cpu, MSR_IA32_TSC, 0);
         env->tsc_valid = !runstate_is_running();
     }
+    if (has_msr_hwcr) {
+        kvm_msr_entry_add(cpu, MSR_K7_HWCR, 0);
+    }
 
 #ifdef TARGET_X86_64
     if (lm_capable_kernel) {
@@ -4827,6 +4836,9 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
             env->lbr_records[index - MSR_ARCH_LBR_INFO_0].info = msrs[i].data;
             break;
+        case MSR_K7_HWCR:
+            env->hwcr = msrs[i].data;
+            break;
         }
     }
 
diff --git a/target/i386/machine.c b/target/i386/machine.c
index 39f8294f27..2db83acafa 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1543,6 +1543,25 @@ static const VMStateDescription vmstate_msr_xfd = {
     }
 };
 
+static bool msr_hwcr_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return env->hwcr != 0;
+}
+
+static const VMStateDescription vmstate_msr_hwcr = {
+    .name = "cpu/msr_hwcr",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = msr_hwcr_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.hwcr, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 #ifdef TARGET_X86_64
 static bool intel_fred_msrs_needed(void *opaque)
 {
@@ -1773,6 +1792,7 @@ const VMStateDescription vmstate_x86_cpu = {
         &vmstate_msr_intel_sgx,
         &vmstate_pdptrs,
         &vmstate_msr_xfd,
+        &vmstate_msr_hwcr,
 #ifdef TARGET_X86_64
         &vmstate_msr_fred,
         &vmstate_amx_xtile,
-- 
2.34.1


