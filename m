Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0421538FD16
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 10:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhEYIrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 04:47:13 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:50249 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231450AbhEYIrN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 04:47:13 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=chaowu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0Ua3XLTC_1621932333;
Received: from localhost.localdomain(mailfrom:chaowu@linux.alibaba.com fp:SMTPD_---0Ua3XLTC_1621932333)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 25 May 2021 16:45:41 +0800
From:   Chao Wu <chaowu@linux.alibaba.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org,
        Chao Wu <chaowu@linux.alibaba.com>,
        Jiang Liu <gerry@linux.alibaba.com>,
        Zha Bin <zhabin@linux.alibaba.com>
Subject: [PATCH 1/2] ptp_kvm: fix an infinite loop in ptp_kvm_get_time_fn when vm has more than 64 vcpus 
Date:   Tue, 25 May 2021 16:44:57 +0800
Message-Id: <299220a82834b30257a710d2cff52fafa5f1fe1b.1621505277.git.chaowu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <cover.1621505277.git.chaowu@linux.alibaba.com>
References: <cover.1621505277.git.chaowu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 95a3d4454bb1 ("x86/kvmclock: Switch kvmclock data to a PER_CPU
variable") removes the static data array sized 64bytes * CONFIG_NR_CPUS
and uses a static page sized array to store pvclock data.
For the 64bytes * CONFIG_NR_CPUS size design, the address is consecutive
for all vcpus.
But for the static page sized array design, if page size is 4kB and
struct pvclock_vsyscall_time_info size is 64Byte (cache line aligned),
the maximum length of hv_clock_boot is 64.
For vcpus after 64, kernel will dynamically allocate pages for their
pvclock data in kvmclock_init_mem. So the address is not consecutive for
all vcpus.

Commit 95a3d4454bb1 ("x86/kvmclock: Switch kvmclock data to a PER_CPU
variable") uses per-cpu variable to store the pvclock_vsyscall_time_info
struct pointer to avoid the use of inconsecutive memory address. But
ptp_kvm_get_time_fn in ptp_kvm initiate hv_clock as the cpu0’s 
pvclock_vsyscall_time_info virtual address and uses &hv_clock[cpu].pvti 
to get specified cpu’s pvclock date. When the vcpu number is beyond 63,
&hv_clock[cpu].pvti will point to an incorrect virtual address and will 
cause infinite loop in the following do while code area.

Commit 95a3d4454bb1 ("x86/kvmclock: Switch kvmclock data to a PER_CPU
variable") has removed all &hv_clock[cpu].pvti usage with per-cpu in kvmclock
but the revelant code in ptp_kvm was ignored.

We use this_cpu_pvti() to get pvclock data in ptp_kvm and put per-cpu
related declaration in kvmclock.c to kvmclock.h for ptp_kvm to use.

Signed-off-by: Chao Wu <chaowu@linux.alibaba.com>
Signed-off-by: Jiang Liu <gerry@linux.alibaba.com>
Signed-off-by: Zha Bin <zhabin@linux.alibaba.com>
---
 arch/x86/include/asm/kvmclock.h | 16 ++++++++++++++++
 arch/x86/kernel/kvmclock.c      | 12 ++----------
 drivers/ptp/ptp_kvm.c           |  6 ++----
 3 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvmclock.h b/arch/x86/include/asm/kvmclock.h
index eceea9299097..69b09839e199 100644
--- a/arch/x86/include/asm/kvmclock.h
+++ b/arch/x86/include/asm/kvmclock.h
@@ -2,6 +2,22 @@
 #ifndef _ASM_X86_KVM_CLOCK_H
 #define _ASM_X86_KVM_CLOCK_H
 
+#include <asm/pvclock.h>
+
 extern struct clocksource kvm_clock;
 
+#ifdef CONFIG_KVM_GUEST
+DECLARE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu);
+
+static inline struct pvclock_vcpu_time_info *this_cpu_pvti(void)
+{
+	return &this_cpu_read(hv_clock_per_cpu)->pvti;
+}
+
+static inline struct pvclock_vsyscall_time_info *this_cpu_hvclock(void)
+{
+	return this_cpu_read(hv_clock_per_cpu);
+}
+
+#endif /* CONFIG_KVM_GUEST */
 #endif /* _ASM_X86_KVM_CLOCK_H */
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 2ec202cb9dfd..006551cccdac 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -64,18 +64,10 @@ early_param("no-kvmclock-vsyscall", parse_no_kvmclock_vsyscall);
 static struct pvclock_vsyscall_time_info
 			hv_clock_boot[HVC_BOOT_ARRAY_SIZE] __bss_decrypted __aligned(PAGE_SIZE);
 static struct pvclock_wall_clock wall_clock __bss_decrypted;
-static DEFINE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu);
 static struct pvclock_vsyscall_time_info *hvclock_mem;
 
-static inline struct pvclock_vcpu_time_info *this_cpu_pvti(void)
-{
-	return &this_cpu_read(hv_clock_per_cpu)->pvti;
-}
-
-static inline struct pvclock_vsyscall_time_info *this_cpu_hvclock(void)
-{
-	return this_cpu_read(hv_clock_per_cpu);
-}
+DEFINE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu);
+EXPORT_PER_CPU_SYMBOL_GPL(hv_clock_per_cpu);
 
 /*
  * The wallclock is the time of day when we booted. Since then, some time may
diff --git a/drivers/ptp/ptp_kvm.c b/drivers/ptp/ptp_kvm.c
index c67dd11e08b1..985e3728016b 100644
--- a/drivers/ptp/ptp_kvm.c
+++ b/drivers/ptp/ptp_kvm.c
@@ -34,7 +34,6 @@ struct kvm_ptp_clock {
 
 DEFINE_SPINLOCK(kvm_ptp_lock);
 
-static struct pvclock_vsyscall_time_info *hv_clock;
 
 static struct kvm_clock_pairing clock_pair;
 static phys_addr_t clock_pair_gpa;
@@ -53,7 +52,7 @@ static int ptp_kvm_get_time_fn(ktime_t *device_time,
 
 	preempt_disable_notrace();
 	cpu = smp_processor_id();
-	src = &hv_clock[cpu].pvti;
+	src = this_cpu_pvti();
 
 	do {
 		/*
@@ -182,9 +181,8 @@ static int __init ptp_kvm_init(void)
 		return -ENODEV;
 
 	clock_pair_gpa = slow_virt_to_phys(&clock_pair);
-	hv_clock = pvclock_get_pvti_cpu0_va();
 
-	if (!hv_clock)
+	if (!this_cpu_pvti())
 		return -ENODEV;
 
 	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING, clock_pair_gpa,
-- 
2.24.3 (Apple Git-128)

