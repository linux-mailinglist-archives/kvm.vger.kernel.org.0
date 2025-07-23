Return-Path: <kvm+bounces-53310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 133DCB0FA38
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 20:23:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83E499662CD
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 18:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB34322B8B6;
	Wed, 23 Jul 2025 18:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="KdPdZy8/"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A6E229B21
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 18:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753294958; cv=none; b=qBmTWAWhpwHmMTDltwBhAJGUPhHOjkLVGZiX/N9iXUxZIyOKRdO0kOWm2bN9PH/NPZ37bXmHLKB6eJFH2Phlm2yfoT1n7lwEXHOMQBn+cCMZnnSaLgRgdBFK53AsISEORfirTQONqSb7BZyCauzrYCfQB9uKhSyUhBLKoT0ErUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753294958; c=relaxed/simple;
	bh=p9bg1Orm1G+pLyvXg5vbIoRanpcIhj7C7ZS8W+t77wA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HXZHPhRrkwIxcQkhVy9kyHB7Y0tQTOL5tU6gUgQTbs/UqRIBj3hnsYYXDXajzM8jwaZxEFZqAlKmnC2MpwG0cbiGYsHmULMXlUAXHZHlQd9tI3FIUZnGezWpuTyxkRNMruFda8kkF1YcIXYhJt3Z8MMz/Zfa9ZSk5f/amuyTFhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=KdPdZy8/; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56NIMBAD1299786
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 23 Jul 2025 11:22:14 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56NIMBAD1299786
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753294935;
	bh=RPBt+AF2dCEcK0XM8sYhPFxdEaBCmzbjk0cfLAbZ6nQ=;
	h=From:To:Cc:Subject:Date:From;
	b=KdPdZy8/dNuFuqVX55JlNQ//bbH/FZqKJ7JzM/RWJOUV/6YQ7dzf4aYTlaL6RMVz4
	 DXfKaY/OSeislQ39CSugMtXxMg5gfnOmdoYcWOZiI2u1zPK+QK+UjNUu/Mnw5ilDqY
	 xpRb+Rahfqk4GyHTaXZFpY5GMJfb8kCgHLgrYZSKaVoJEG8qWrw5lqYqFzRcfNlCns
	 vxR2rIw68SVER1CWvw4QMOlo1pUm6zmObdwC4oJqoy6n/QJ89sLgkJDIL8eWz+PZ3A
	 LMhQ+YaplKSvVTRD/SgR6RxTS5TpqJs99uhqfjyG1X6iksqGfvvWg6DQt8MRMJqrKg
	 e/7GCflNsQRPw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc: mst@redhat.com, cohuck@redhat.com, pbonzini@redhat.com,
        zhao1.liu@intel.com, mtosatti@redhat.com, seanjc@google.com,
        hpa@zytor.com, xin@zytor.com, andrew.cooper3@citrix.com,
        chao.gao@intel.com
Subject: [PATCH v1 1/1] target/i386: Save/restore the nested flag of an exception
Date: Wed, 23 Jul 2025 11:22:11 -0700
Message-ID: <20250723182211.1299776-1-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Save/restore the nested flag of an exception during VM save/restore
and live migration to ensure a correct event stack level is chosen
when a nested exception is injected through FRED event delivery.

The event stack level used by FRED event delivery depends on whether
the event was a nested exception encountered during delivery of an
earlier event, because a nested exception is "regarded" as happening
on ring 0.  E.g., when #PF is configured to use stack level 1 in
IA32_FRED_STKLVLS MSR:
  - nested #PF will be delivered on the stack pointed by IA32_FRED_RSP1
    MSR when encountered in ring 3 and ring 0.
  - normal #PF will be delivered on the stack pointed by IA32_FRED_RSP0
    MSR when encountered in ring 3.
  - normal #PF will be delivered on the stack pointed by IA32_FRED_RSP1
    MSR when encountered in ring 0.

As such Qemu needs to track if an event is a nested event during VM
context save/restore and live migration.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 linux-headers/asm-x86/kvm.h |  4 +++-
 linux-headers/linux/kvm.h   |  1 +
 target/i386/cpu.c           |  1 +
 target/i386/cpu.h           |  1 +
 target/i386/kvm/kvm.c       | 35 +++++++++++++++++++++++++++++++++++
 target/i386/kvm/kvm_i386.h  |  1 +
 target/i386/machine.c       |  1 +
 7 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index f0c1a730d9..f494509b94 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -324,6 +324,7 @@ struct kvm_reinject_control {
 #define KVM_VCPUEVENT_VALID_SMM		0x00000008
 #define KVM_VCPUEVENT_VALID_PAYLOAD	0x00000010
 #define KVM_VCPUEVENT_VALID_TRIPLE_FAULT	0x00000020
+#define KVM_VCPUEVENT_VALID_NESTED_FLAG	0x00000040
 
 /* Interrupt shadow states */
 #define KVM_X86_SHADOW_INT_MOV_SS	0x01
@@ -361,7 +362,8 @@ struct kvm_vcpu_events {
 	struct {
 		__u8 pending;
 	} triple_fault;
-	__u8 reserved[26];
+	__u8 reserved[25];
+	__u8 exception_is_nested;
 	__u8 exception_has_payload;
 	__u64 exception_payload;
 };
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 32c5885a3c..521ec3af37 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -952,6 +952,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2 240
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
+#define KVM_CAP_EXCEPTION_NESTED_FLAG 243
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 251d5760a0..4483bf9d10 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -8723,6 +8723,7 @@ static void x86_cpu_reset_hold(Object *obj, ResetType type)
     env->exception_injected = 0;
     env->exception_has_payload = false;
     env->exception_payload = 0;
+    env->exception_is_nested = false;
     env->nmi_injected = false;
     env->triple_fault_pending = false;
 #if !defined(CONFIG_USER_ONLY)
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index f977fc49a7..a9116bfd2c 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2097,6 +2097,7 @@ typedef struct CPUArchState {
     uint8_t has_error_code;
     uint8_t exception_has_payload;
     uint64_t exception_payload;
+    uint8_t exception_is_nested;
     uint8_t triple_fault_pending;
     uint32_t ins_len;
     uint32_t sipi_vector;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 369626f8c8..db4af9ec2d 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -174,6 +174,7 @@ static int has_xsave2;
 static int has_xcrs;
 static int has_sregs2;
 static int has_exception_payload;
+static int has_exception_nested_flag;
 static int has_triple_fault_event;
 
 static bool has_msr_mcg_ext_ctl;
@@ -259,6 +260,11 @@ bool kvm_has_exception_payload(void)
     return has_exception_payload;
 }
 
+bool kvm_has_exception_nested_flag(void)
+{
+    return has_exception_nested_flag;
+}
+
 static bool kvm_x2apic_api_set_flags(uint64_t flags)
 {
     KVMState *s = KVM_STATE(current_accel());
@@ -3075,6 +3081,21 @@ static int kvm_vm_enable_exception_payload(KVMState *s)
     return ret;
 }
 
+static int kvm_vm_enable_exception_nested_flag(KVMState *s)
+{
+    int ret = 0;
+    has_exception_nested_flag = kvm_check_extension(s, KVM_CAP_EXCEPTION_NESTED_FLAG);
+    if (has_exception_nested_flag) {
+        ret = kvm_vm_enable_cap(s, KVM_CAP_EXCEPTION_NESTED_FLAG, 0, true);
+        if (ret < 0) {
+            error_report("kvm: Failed to enable exception nested flag cap: %s",
+                         strerror(-ret));
+        }
+    }
+
+    return ret;
+}
+
 static int kvm_vm_enable_triple_fault_event(KVMState *s)
 {
     int ret = 0;
@@ -3255,6 +3276,11 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         return ret;
     }
 
+    ret = kvm_vm_enable_exception_nested_flag(s);
+    if (ret < 0) {
+        return ret;
+    }
+
     ret = kvm_vm_enable_triple_fault_event(s);
     if (ret < 0) {
         return ret;
@@ -5041,6 +5067,10 @@ static int kvm_put_vcpu_events(X86CPU *cpu, int level)
         events.exception_has_payload = env->exception_has_payload;
         events.exception_payload = env->exception_payload;
     }
+    if (has_exception_nested_flag) {
+        events.flags |= KVM_VCPUEVENT_VALID_NESTED_FLAG;
+        events.exception_is_nested = env->exception_is_nested;
+    }
     events.exception.nr = env->exception_nr;
     events.exception.injected = env->exception_injected;
     events.exception.has_error_code = env->has_error_code;
@@ -5109,6 +5139,11 @@ static int kvm_get_vcpu_events(X86CPU *cpu)
         env->exception_pending = 0;
         env->exception_has_payload = false;
     }
+    if (events.flags & KVM_VCPUEVENT_VALID_NESTED_FLAG) {
+        env->exception_is_nested = events.exception_is_nested;
+    } else {
+        env->exception_is_nested = false;
+    }
     env->exception_injected = events.exception.injected;
     env->exception_nr =
         (env->exception_pending || env->exception_injected) ?
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 5f83e8850a..7e765b6833 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -54,6 +54,7 @@ typedef struct KvmCpuidInfo {
 bool kvm_is_vm_type_supported(int type);
 bool kvm_has_adjust_clock_stable(void);
 bool kvm_has_exception_payload(void);
+bool kvm_has_exception_nested_flag(void);
 void kvm_synchronize_all_tsc(void);
 
 void kvm_get_apic_state(DeviceState *d, struct kvm_lapic_state *kapic);
diff --git a/target/i386/machine.c b/target/i386/machine.c
index dd2dac1d44..a452d2c97e 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -458,6 +458,7 @@ static const VMStateDescription vmstate_exception_info = {
         VMSTATE_UINT8(env.exception_injected, X86CPU),
         VMSTATE_UINT8(env.exception_has_payload, X86CPU),
         VMSTATE_UINT64(env.exception_payload, X86CPU),
+        VMSTATE_UINT8(env.exception_is_nested, X86CPU),
         VMSTATE_END_OF_LIST()
     }
 };

base-commit: 9e601684dc24a521bb1d23215a63e5c6e79ea0bb
-- 
2.50.1


