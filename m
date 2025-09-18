Return-Path: <kvm+bounces-57278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FBEDB528F0
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 08:36:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0494E7B89EF
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 06:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFF58271443;
	Thu, 11 Sep 2025 06:35:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C345C26FA46
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 06:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757572521; cv=none; b=BoHHYuGzszQgv/ay3m/yXB/8aUMqyf5UGTBziDqhF5lRpMjF6nD0mqPLkXHvyYHHfyIi7ecr4YLxZJ8vSdpYsWfKtJ5MDekvnGR/rtXcskfN+lZZ/bUAJNWScOdQQPARbQvUkc1I3wCu5cLkuhfynLiJga48leI9Pw9ShYy37Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757572521; c=relaxed/simple;
	bh=CRj9P64RxsKsVX6V9olVtMz9hZPCfuRyI41wpilmCcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbjRy50o/ks3rUtre17VQlNwijT2vN7BNs9pwWe9xqJ8ufgKVN1tkMid9kRYj4AZXZouZZ4HrHJ1B2zyO80CD+aG+CP1nnQzHkZN5ZDZaV4GGLmYRzaf/JjZXD38Q4gdbmv7D7zeJRrnh/nKdlaxwiFd9NzKdd5pvZ0AfcHtlCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DFD6922BF9;
	Thu, 11 Sep 2025 06:35:15 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C15CC1372E;
	Thu, 11 Sep 2025 06:35:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PJLTLaJtwmgeTQAAD6G6ig
	(envelope-from <jgross@suse.com>); Thu, 11 Sep 2025 06:35:14 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	virtualization@lists.linux.dev,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	xen-devel@lists.xenproject.org
Subject: [PATCH 06/14] sched: move clock related paravirt code to kernel/sched
Date: Thu, 11 Sep 2025 08:34:25 +0200
Message-ID: <20250911063433.13783-7-jgross@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250911063433.13783-1-jgross@suse.com>
References: <20250911063433.13783-1-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: DFD6922BF9
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Score: -4.00

Paravirt clock related functions are available in multiple archs.

In order to share the common parts, move the common static keys
to kernel/sched/ and remove them from the arch specific files.

Make a common paravirt_steal_clock() implementation available in
kernel/sched/cputime.c, guarding it with a new config option
CONFIG_HAVE_PV_STEAL_CLOCK_GEN, which can be selectd by an arch
in case it wants to use that common variant.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/Kconfig                           |  3 +++
 arch/arm/include/asm/paravirt.h        |  4 ----
 arch/arm/kernel/paravirt.c             |  3 ---
 arch/arm64/include/asm/paravirt.h      |  4 ----
 arch/arm64/kernel/paravirt.c           |  4 +---
 arch/loongarch/include/asm/paravirt.h  |  3 ---
 arch/loongarch/kernel/paravirt.c       |  3 +--
 arch/powerpc/include/asm/paravirt.h    |  3 ---
 arch/powerpc/platforms/pseries/setup.c |  4 +---
 arch/riscv/include/asm/paravirt.h      |  4 ----
 arch/riscv/kernel/paravirt.c           |  4 +---
 arch/x86/include/asm/paravirt.h        |  4 ----
 arch/x86/kernel/cpu/vmware.c           |  1 +
 arch/x86/kernel/kvm.c                  |  1 +
 arch/x86/kernel/paravirt.c             |  3 ---
 drivers/xen/time.c                     |  1 +
 include/linux/sched/cputime.h          | 18 ++++++++++++++++++
 kernel/sched/core.c                    |  5 +++++
 kernel/sched/cputime.c                 | 13 +++++++++++++
 kernel/sched/sched.h                   |  2 +-
 20 files changed, 47 insertions(+), 40 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index d1b4ffd6e085..7921be052472 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1003,6 +1003,9 @@ config HAVE_IRQ_TIME_ACCOUNTING
 	  Archs need to ensure they use a high enough resolution clock to
 	  support irq time accounting and then call enable_sched_clock_irqtime().
 
+config HAVE_PV_STEAL_CLOCK_GEN
+	bool
+
 config HAVE_MOVE_PUD
 	bool
 	help
diff --git a/arch/arm/include/asm/paravirt.h b/arch/arm/include/asm/paravirt.h
index 95d5b0d625cd..69da4bdcf856 100644
--- a/arch/arm/include/asm/paravirt.h
+++ b/arch/arm/include/asm/paravirt.h
@@ -5,10 +5,6 @@
 #ifdef CONFIG_PARAVIRT
 #include <linux/static_call_types.h>
 
-struct static_key;
-extern struct static_key paravirt_steal_enabled;
-extern struct static_key paravirt_steal_rq_enabled;
-
 u64 dummy_steal_clock(int cpu);
 
 DECLARE_STATIC_CALL(pv_steal_clock, dummy_steal_clock);
diff --git a/arch/arm/kernel/paravirt.c b/arch/arm/kernel/paravirt.c
index 7dd9806369fb..3895a5578852 100644
--- a/arch/arm/kernel/paravirt.c
+++ b/arch/arm/kernel/paravirt.c
@@ -12,9 +12,6 @@
 #include <linux/static_call.h>
 #include <asm/paravirt.h>
 
-struct static_key paravirt_steal_enabled;
-struct static_key paravirt_steal_rq_enabled;
-
 static u64 native_steal_clock(int cpu)
 {
 	return 0;
diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
index 9aa193e0e8f2..c9f7590baacb 100644
--- a/arch/arm64/include/asm/paravirt.h
+++ b/arch/arm64/include/asm/paravirt.h
@@ -5,10 +5,6 @@
 #ifdef CONFIG_PARAVIRT
 #include <linux/static_call_types.h>
 
-struct static_key;
-extern struct static_key paravirt_steal_enabled;
-extern struct static_key paravirt_steal_rq_enabled;
-
 u64 dummy_steal_clock(int cpu);
 
 DECLARE_STATIC_CALL(pv_steal_clock, dummy_steal_clock);
diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
index aa718d6a9274..943b60ce12f4 100644
--- a/arch/arm64/kernel/paravirt.c
+++ b/arch/arm64/kernel/paravirt.c
@@ -19,14 +19,12 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/static_call.h>
+#include <linux/sched/cputime.h>
 
 #include <asm/paravirt.h>
 #include <asm/pvclock-abi.h>
 #include <asm/smp_plat.h>
 
-struct static_key paravirt_steal_enabled;
-struct static_key paravirt_steal_rq_enabled;
-
 static u64 native_steal_clock(int cpu)
 {
 	return 0;
diff --git a/arch/loongarch/include/asm/paravirt.h b/arch/loongarch/include/asm/paravirt.h
index 3f4323603e6a..d219ea0d98ac 100644
--- a/arch/loongarch/include/asm/paravirt.h
+++ b/arch/loongarch/include/asm/paravirt.h
@@ -5,9 +5,6 @@
 #ifdef CONFIG_PARAVIRT
 
 #include <linux/static_call_types.h>
-struct static_key;
-extern struct static_key paravirt_steal_enabled;
-extern struct static_key paravirt_steal_rq_enabled;
 
 u64 dummy_steal_clock(int cpu);
 DECLARE_STATIC_CALL(pv_steal_clock, dummy_steal_clock);
diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
index b1b51f920b23..8caaa94fed1a 100644
--- a/arch/loongarch/kernel/paravirt.c
+++ b/arch/loongarch/kernel/paravirt.c
@@ -6,11 +6,10 @@
 #include <linux/kvm_para.h>
 #include <linux/reboot.h>
 #include <linux/static_call.h>
+#include <linux/sched/cputime.h>
 #include <asm/paravirt.h>
 
 static int has_steal_clock;
-struct static_key paravirt_steal_enabled;
-struct static_key paravirt_steal_rq_enabled;
 static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(64);
 DEFINE_STATIC_KEY_FALSE(virt_spin_lock_key);
 
diff --git a/arch/powerpc/include/asm/paravirt.h b/arch/powerpc/include/asm/paravirt.h
index b78b82d66057..92343a23ad15 100644
--- a/arch/powerpc/include/asm/paravirt.h
+++ b/arch/powerpc/include/asm/paravirt.h
@@ -23,9 +23,6 @@ static inline bool is_shared_processor(void)
 }
 
 #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
-extern struct static_key paravirt_steal_enabled;
-extern struct static_key paravirt_steal_rq_enabled;
-
 u64 pseries_paravirt_steal_clock(int cpu);
 
 static inline u64 paravirt_steal_clock(int cpu)
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index b10a25325238..50b26ed8432d 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -42,6 +42,7 @@
 #include <linux/memblock.h>
 #include <linux/swiotlb.h>
 #include <linux/seq_buf.h>
+#include <linux/sched/cputime.h>
 
 #include <asm/mmu.h>
 #include <asm/processor.h>
@@ -83,9 +84,6 @@ DEFINE_STATIC_KEY_FALSE(shared_processor);
 EXPORT_SYMBOL(shared_processor);
 
 #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
-struct static_key paravirt_steal_enabled;
-struct static_key paravirt_steal_rq_enabled;
-
 static bool steal_acc = true;
 static int __init parse_no_stealacc(char *arg)
 {
diff --git a/arch/riscv/include/asm/paravirt.h b/arch/riscv/include/asm/paravirt.h
index c0abde70fc2c..17e5e39c72c0 100644
--- a/arch/riscv/include/asm/paravirt.h
+++ b/arch/riscv/include/asm/paravirt.h
@@ -5,10 +5,6 @@
 #ifdef CONFIG_PARAVIRT
 #include <linux/static_call_types.h>
 
-struct static_key;
-extern struct static_key paravirt_steal_enabled;
-extern struct static_key paravirt_steal_rq_enabled;
-
 u64 dummy_steal_clock(int cpu);
 
 DECLARE_STATIC_CALL(pv_steal_clock, dummy_steal_clock);
diff --git a/arch/riscv/kernel/paravirt.c b/arch/riscv/kernel/paravirt.c
index fa6b0339a65d..d3c334f16172 100644
--- a/arch/riscv/kernel/paravirt.c
+++ b/arch/riscv/kernel/paravirt.c
@@ -16,15 +16,13 @@
 #include <linux/printk.h>
 #include <linux/static_call.h>
 #include <linux/types.h>
+#include <linux/sched/cputime.h>
 
 #include <asm/barrier.h>
 #include <asm/page.h>
 #include <asm/paravirt.h>
 #include <asm/sbi.h>
 
-struct static_key paravirt_steal_enabled;
-struct static_key paravirt_steal_rq_enabled;
-
 static u64 native_steal_clock(int cpu)
 {
 	return 0;
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 0d1e611f619c..491cb7e037bf 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -34,10 +34,6 @@ static __always_inline u64 paravirt_sched_clock(void)
 	return static_call(pv_sched_clock)();
 }
 
-struct static_key;
-extern struct static_key paravirt_steal_enabled;
-extern struct static_key paravirt_steal_rq_enabled;
-
 __visible void __native_queued_spin_unlock(struct qspinlock *lock);
 bool pv_is_native_spin_unlock(void);
 __visible bool __native_vcpu_is_preempted(long cpu);
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index cb3f900c46fc..a3e6936839b1 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -29,6 +29,7 @@
 #include <linux/efi.h>
 #include <linux/reboot.h>
 #include <linux/static_call.h>
+#include <linux/sched/cputime.h>
 #include <asm/div64.h>
 #include <asm/x86_init.h>
 #include <asm/hypervisor.h>
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 8ae750cde0c6..a23211eaaeed 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -29,6 +29,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/cc_platform.h>
 #include <linux/efi.h>
+#include <linux/sched/cputime.h>
 #include <asm/timer.h>
 #include <asm/cpu.h>
 #include <asm/traps.h>
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index ab3e172dcc69..a3ba4747be1c 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -60,9 +60,6 @@ void __init native_pv_lock_init(void)
 		static_branch_enable(&virt_spin_lock_key);
 }
 
-struct static_key paravirt_steal_enabled;
-struct static_key paravirt_steal_rq_enabled;
-
 static u64 native_steal_clock(int cpu)
 {
 	return 0;
diff --git a/drivers/xen/time.c b/drivers/xen/time.c
index 5683383d2305..d360ded2ef39 100644
--- a/drivers/xen/time.c
+++ b/drivers/xen/time.c
@@ -8,6 +8,7 @@
 #include <linux/gfp.h>
 #include <linux/slab.h>
 #include <linux/static_call.h>
+#include <linux/sched/cputime.h>
 
 #include <asm/paravirt.h>
 #include <asm/xen/hypervisor.h>
diff --git a/include/linux/sched/cputime.h b/include/linux/sched/cputime.h
index 5f8fd5b24a2e..e90efaf6d26e 100644
--- a/include/linux/sched/cputime.h
+++ b/include/linux/sched/cputime.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_SCHED_CPUTIME_H
 #define _LINUX_SCHED_CPUTIME_H
 
+#include <linux/static_call_types.h>
 #include <linux/sched/signal.h>
 
 /*
@@ -180,4 +181,21 @@ static inline void prev_cputime_init(struct prev_cputime *prev)
 extern unsigned long long
 task_sched_runtime(struct task_struct *task);
 
+#ifdef CONFIG_PARAVIRT
+struct static_key;
+extern struct static_key paravirt_steal_enabled;
+extern struct static_key paravirt_steal_rq_enabled;
+
+#ifdef CONFIG_HAVE_PV_STEAL_CLOCK_GEN
+u64 dummy_steal_clock(int cpu);
+
+DECLARE_STATIC_CALL(pv_steal_clock, dummy_steal_clock);
+
+static inline u64 paravirt_steal_clock(int cpu)
+{
+	return static_call(pv_steal_clock)(cpu);
+}
+#endif
+#endif
+
 #endif /* _LINUX_SCHED_CPUTIME_H */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index be00629f0ba4..e723226e4e11 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -767,6 +767,11 @@ struct rq *task_rq_lock(struct task_struct *p, struct rq_flags *rf)
  * RQ-clock updating methods:
  */
 
+/* Use CONFIG_PARAVIRT as this will avoid more #ifdef in arch code. */
+#ifdef CONFIG_PARAVIRT
+struct static_key paravirt_steal_rq_enabled;
+#endif
+
 static void update_rq_clock_task(struct rq *rq, s64 delta)
 {
 /*
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 7097de2c8cda..ed8f71e08047 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -251,6 +251,19 @@ void __account_forceidle_time(struct task_struct *p, u64 delta)
  * ticks are not redelivered later. Due to that, this function may on
  * occasion account more time than the calling functions think elapsed.
  */
+#ifdef CONFIG_PARAVIRT
+struct static_key paravirt_steal_enabled;
+
+#ifdef CONFIG_HAVE_PV_STEAL_CLOCK_GEN
+static u64 native_steal_clock(int cpu)
+{
+	return 0;
+}
+
+DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
+#endif
+#endif
+
 static __always_inline u64 steal_account_process_time(u64 maxtime)
 {
 #ifdef CONFIG_PARAVIRT
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 6442441b46d7..fdf3021bdf7d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -82,7 +82,7 @@ struct rt_rq;
 struct sched_group;
 struct cpuidle_state;
 
-#ifdef CONFIG_PARAVIRT
+#if defined(CONFIG_PARAVIRT) && !defined(CONFIG_HAVE_PV_STEAL_CLOCK_GEN)
 # include <asm/paravirt.h>
 #endif
 
-- 
2.51.0


