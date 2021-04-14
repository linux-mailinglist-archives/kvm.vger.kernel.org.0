Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A225B35F3E8
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 14:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350987AbhDNMgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 08:36:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51581 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350974AbhDNMgZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Apr 2021 08:36:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618403763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eY6vvF4PiaFOr0gEdINTrix9seCoJyWgdWe58BuWwps=;
        b=MqMH4us41+/dXVhmhtk2TjiHBGuHpkh7ffO4fNb8tyxs9dee3gzT3GaN1rdod9JxLOKNSl
        dwuwelpqTAykQZGk1hFQH97cI+oVsJIaNgklJwjxd9vQkOT0D0yrV0u8/TCtNjV8rNzggg
        q0YsmhDleDgv5rh//93mhHIJecYXgfI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-P2yon3AgNoyINuwiDxrDTQ-1; Wed, 14 Apr 2021 08:36:01 -0400
X-MC-Unique: P2yon3AgNoyINuwiDxrDTQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C84D188E3DE;
        Wed, 14 Apr 2021 12:36:00 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.196.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E44115D9CC;
        Wed, 14 Apr 2021 12:35:57 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Lenny Szubowicz <lszubowi@redhat.com>,
        Mohamed Aboubakr <mabouba@amazon.com>,
        Xiaoyi Chen <cxiaoyi@amazon.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] x86/kvm: Disable all PV features on crash
Date:   Wed, 14 Apr 2021 14:35:43 +0200
Message-Id: <20210414123544.1060604-5-vkuznets@redhat.com>
In-Reply-To: <20210414123544.1060604-1-vkuznets@redhat.com>
References: <20210414123544.1060604-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Crash shutdown handler only disables kvmclock and steal time, other PV
features remain active so we risk corrupting memory or getting some
side-effects in kdump kernel. Move crash handler to kvm.c and unify
with CPU offline.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_para.h |  6 -----
 arch/x86/kernel/kvm.c           | 44 ++++++++++++++++++++++++---------
 arch/x86/kernel/kvmclock.c      | 21 ----------------
 3 files changed, 32 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 9c56e0defd45..69299878b200 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -92,7 +92,6 @@ unsigned int kvm_arch_para_hints(void);
 void kvm_async_pf_task_wait_schedule(u32 token);
 void kvm_async_pf_task_wake(u32 token);
 u32 kvm_read_and_reset_apf_flags(void);
-void kvm_disable_steal_time(void);
 bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token);
 
 DECLARE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
@@ -137,11 +136,6 @@ static inline u32 kvm_read_and_reset_apf_flags(void)
 	return 0;
 }
 
-static inline void kvm_disable_steal_time(void)
-{
-	return;
-}
-
 static __always_inline bool kvm_handle_async_pf(struct pt_regs *regs, u32 token)
 {
 	return false;
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index df00d44f7424..1754b7c3f754 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -38,6 +38,7 @@
 #include <asm/tlb.h>
 #include <asm/cpuidle_haltpoll.h>
 #include <asm/ptrace.h>
+#include <asm/reboot.h>
 #include <asm/svm.h>
 
 DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
@@ -375,6 +376,14 @@ static void kvm_pv_disable_apf(void)
 	pr_info("disable async PF for cpu %d\n", smp_processor_id());
 }
 
+static void kvm_disable_steal_time(void)
+{
+	if (!has_steal_clock)
+		return;
+
+	wrmsr(MSR_KVM_STEAL_TIME, 0, 0);
+}
+
 static void kvm_pv_guest_cpu_reboot(void *unused)
 {
 	/*
@@ -417,14 +426,6 @@ static u64 kvm_steal_clock(int cpu)
 	return steal;
 }
 
-void kvm_disable_steal_time(void)
-{
-	if (!has_steal_clock)
-		return;
-
-	wrmsr(MSR_KVM_STEAL_TIME, 0, 0);
-}
-
 static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
 {
 	early_set_memory_decrypted((unsigned long) ptr, size);
@@ -588,13 +589,14 @@ static void __init kvm_smp_prepare_boot_cpu(void)
 	kvm_spinlock_init();
 }
 
-static void kvm_guest_cpu_offline(void)
+static void kvm_guest_cpu_offline(bool shutdown)
 {
 	kvm_disable_steal_time();
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
 		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
 	kvm_pv_disable_apf();
-	apf_task_wake_all();
+	if (!shutdown)
+		apf_task_wake_all();
 	kvmclock_disable();
 }
 
@@ -613,7 +615,7 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	kvm_guest_cpu_offline();
+	kvm_guest_cpu_offline(false);
 	local_irq_restore(flags);
 	return 0;
 }
@@ -647,7 +649,7 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
 
 static int kvm_suspend(void)
 {
-	kvm_guest_cpu_offline();
+	kvm_guest_cpu_offline(false);
 
 	return 0;
 }
@@ -662,6 +664,20 @@ static struct syscore_ops kvm_syscore_ops = {
 	.resume		= kvm_resume,
 };
 
+/*
+ * After a PV feature is registered, the host will keep writing to the
+ * registered memory location. If the guest happens to shutdown, this memory
+ * won't be valid. In cases like kexec, in which you install a new kernel, this
+ * means a random memory location will be kept being written.
+ */
+#ifdef CONFIG_KEXEC_CORE
+static void kvm_crash_shutdown(struct pt_regs *regs)
+{
+	kvm_guest_cpu_offline(true);
+	native_machine_crash_shutdown(regs);
+}
+#endif
+
 static void __init kvm_guest_init(void)
 {
 	int i;
@@ -704,6 +720,10 @@ static void __init kvm_guest_init(void)
 	kvm_guest_cpu_init();
 #endif
 
+#ifdef CONFIG_KEXEC_CORE
+	machine_ops.crash_shutdown = kvm_crash_shutdown;
+#endif
+
 	register_syscore_ops(&kvm_syscore_ops);
 
 	/*
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index cf869de98eec..b825c87c12ef 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -20,7 +20,6 @@
 #include <asm/hypervisor.h>
 #include <asm/mem_encrypt.h>
 #include <asm/x86_init.h>
-#include <asm/reboot.h>
 #include <asm/kvmclock.h>
 
 static int kvmclock __initdata = 1;
@@ -203,23 +202,6 @@ static void kvm_setup_secondary_clock(void)
 }
 #endif
 
-/*
- * After the clock is registered, the host will keep writing to the
- * registered memory location. If the guest happens to shutdown, this memory
- * won't be valid. In cases like kexec, in which you install a new kernel, this
- * means a random memory location will be kept being written. So before any
- * kind of shutdown from our side, we unregister the clock by writing anything
- * that does not have the 'enable' bit set in the msr
- */
-#ifdef CONFIG_KEXEC_CORE
-static void kvm_crash_shutdown(struct pt_regs *regs)
-{
-	native_write_msr(msr_kvm_system_time, 0, 0);
-	kvm_disable_steal_time();
-	native_machine_crash_shutdown(regs);
-}
-#endif
-
 void kvmclock_disable(void)
 {
 	native_write_msr(msr_kvm_system_time, 0, 0);
@@ -349,9 +331,6 @@ void __init kvmclock_init(void)
 #endif
 	x86_platform.save_sched_clock_state = kvm_save_sched_clock_state;
 	x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;
-#ifdef CONFIG_KEXEC_CORE
-	machine_ops.crash_shutdown  = kvm_crash_shutdown;
-#endif
 	kvm_get_preset_lpj();
 
 	/*
-- 
2.30.2

