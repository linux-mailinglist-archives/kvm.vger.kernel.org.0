Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3A50D21CD
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 09:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733143AbfJJHiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 03:38:10 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:45056 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733068AbfJJHbP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 03:31:15 -0400
Received: by mail-qk1-f201.google.com with SMTP id s14so4602398qkg.12
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 00:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lRc4gVxiX9A2vAyfTTykUNKX78s0vfyshPhbgF158mw=;
        b=pKfamWhqA5o/VmlkmrFWgfcuXXifDhh0VT/OCnIoPXQ1CI2I30bQ0Z4/dFIh8cUZaY
         CAT75zg54Wx7rcLARaqO7cEDGzLh9YhS2evTOdtwod78dy67s2So03fr7SiSKpnqDlMr
         qmChzb/MGpoYT+eUXEEziwWNvkwbS8efSWDIIzuqjwRz/Bktlxylc3dQoB3Jipa5fV73
         L8bmKSXZjSZXEw2zSVbOut7BL4znRec1t9HMpadJCLc9M/WY+Tc7rDVWpby5DdUbRfHY
         eW7xXe2QdysDZ1ywuXNUhHjMnvmHVX0wpr5Xy9key8Q1WDnzjRIzfNv1RdQ0xab2qq7t
         l/lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lRc4gVxiX9A2vAyfTTykUNKX78s0vfyshPhbgF158mw=;
        b=U8bNocKNaRogfoRiws018fY0EPzNcK46iBY+aFTrnvR+lFEDbO/1IbaFOwPjEqNv1z
         TN8MbwhX7gZSvM50jIaO+s/8WZRnUo4Wz04WLiAHqoBR7LpBSyrOu6YShqIvVnY1YwT9
         wqcLdu3xYvyVoQbRowrG0j0XIJKeSJRP0XJfsqGPvtam++Ezr5pCMjD0MzJwuSZsSbNN
         znRfW/PVrUxKz2oXf3DILlfB4ev7f3VYc6MyUHU0QIHnJhUCp52BLWhP9MLiJWhVHd4t
         8sorDsfZbMKEj/MhQN1hdpvgpg+9aGRSNWxrCHQTG3oowTR5LdZf669ibZR3qiVxxWKJ
         u6Zg==
X-Gm-Message-State: APjAAAV/y6SNjJT07olzpvGTi3z5XpJLNjIEsBemqYpjni8+Xwie/AF3
        m9wJpd41kjaguddDN6uvbst+6N/Csw5EFQ==
X-Google-Smtp-Source: APXvYqxTJ6oZLrEDQCMDaFAXpsBAe3TNsX0YgtXEeErhAIpuxnfa9tVw0IgMH3MwfbGKX98V2thZinTrVlSgdw==
X-Received: by 2002:ac8:6992:: with SMTP id o18mr8726329qtq.105.1570692673999;
 Thu, 10 Oct 2019 00:31:13 -0700 (PDT)
Date:   Thu, 10 Oct 2019 16:30:55 +0900
In-Reply-To: <20191010073055.183635-1-suleiman@google.com>
Message-Id: <20191010073055.183635-3-suleiman@google.com>
Mime-Version: 1.0
References: <20191010073055.183635-1-suleiman@google.com>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [RFC v2 2/2] x86/kvmclock: Introduce kvm-hostclock clocksource.
From:   Suleiman Souhlal <suleiman@google.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de
Cc:     john.stultz@linaro.org, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ssouhlal@freebsd.org, tfiga@chromium.org, vkuznets@redhat.com,
        Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When kvm-hostclock is selected, and the host supports it, update our
timekeeping parameters to be the same as the host.
This lets us have our time synchronized with the host's,
even in the presence of host NTP or suspend.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/Kconfig                    |   9 ++
 arch/x86/include/asm/kvmclock.h     |  12 +++
 arch/x86/kernel/Makefile            |   2 +
 arch/x86/kernel/kvmclock.c          |   5 +-
 arch/x86/kernel/kvmhostclock.c      | 130 ++++++++++++++++++++++++++++
 include/linux/timekeeper_internal.h |   8 ++
 kernel/time/timekeeping.c           |   2 +
 7 files changed, 167 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/kvmhostclock.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d6e1faa28c58..c5b1257ea969 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -839,6 +839,15 @@ config PARAVIRT_TIME_ACCOUNTING
 config PARAVIRT_CLOCK
 	bool
 
+config KVM_HOSTCLOCK
+	bool "kvmclock uses host timekeeping"
+	depends on KVM_GUEST
+	help
+	  Select this option to make the guest use the same timekeeping
+	  parameters as the host. This means that time will be almost
+	  exactly the same between the two. Only works if the host uses "tsc"
+	  clocksource.
+
 config JAILHOUSE_GUEST
 	bool "Jailhouse non-root cell support"
 	depends on X86_64 && PCI
diff --git a/arch/x86/include/asm/kvmclock.h b/arch/x86/include/asm/kvmclock.h
index eceea9299097..de1a590ff97e 100644
--- a/arch/x86/include/asm/kvmclock.h
+++ b/arch/x86/include/asm/kvmclock.h
@@ -2,6 +2,18 @@
 #ifndef _ASM_X86_KVM_CLOCK_H
 #define _ASM_X86_KVM_CLOCK_H
 
+#include <linux/timekeeper_internal.h>
+
 extern struct clocksource kvm_clock;
 
+unsigned long kvm_get_tsc_khz(void);
+
+#ifdef CONFIG_KVM_HOSTCLOCK
+void kvm_hostclock_init(void);
+#else
+static inline void kvm_hostclock_init(void)
+{
+}
+#endif /* KVM_HOSTCLOCK */
+
 #endif /* _ASM_X86_KVM_CLOCK_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 3578ad248bc9..bc7be935fc5e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -17,6 +17,7 @@ CFLAGS_REMOVE_tsc.o = -pg
 CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
 CFLAGS_REMOVE_pvclock.o = -pg
 CFLAGS_REMOVE_kvmclock.o = -pg
+CFLAGS_REMOVE_kvmhostclock.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 CFLAGS_REMOVE_head64.o = -pg
@@ -112,6 +113,7 @@ obj-$(CONFIG_AMD_NB)		+= amd_nb.o
 obj-$(CONFIG_DEBUG_NMI_SELFTEST) += nmi_selftest.o
 
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvmclock.o
+obj-$(CONFIG_KVM_HOSTCLOCK)	+= kvmhostclock.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch.o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= paravirt-spinlocks.o
 obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 904494b924c1..4ab862de9777 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -125,7 +125,7 @@ static inline void kvm_sched_clock_init(bool stable)
  * poll of guests can be running and trouble each other. So we preset
  * lpj here
  */
-static unsigned long kvm_get_tsc_khz(void)
+unsigned long kvm_get_tsc_khz(void)
 {
 	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
 	return pvclock_tsc_khz(this_cpu_pvti());
@@ -366,5 +366,8 @@ void __init kvmclock_init(void)
 		kvm_clock.rating = 299;
 
 	clocksource_register_hz(&kvm_clock, NSEC_PER_SEC);
+
+	kvm_hostclock_init();
+
 	pv_info.name = "KVM";
 }
diff --git a/arch/x86/kernel/kvmhostclock.c b/arch/x86/kernel/kvmhostclock.c
new file mode 100644
index 000000000000..9971343c2bed
--- /dev/null
+++ b/arch/x86/kernel/kvmhostclock.c
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KVM clocksource that uses host timekeeping.
+ * Copyright (c) 2019 Suleiman Souhlal, Google LLC
+ */
+
+#include <linux/clocksource.h>
+#include <linux/kvm_para.h>
+#include <asm/pvclock.h>
+#include <asm/msr.h>
+#include <asm/kvmclock.h>
+#include <linux/timekeeper_internal.h>
+
+struct pvclock_timekeeper pv_timekeeper;
+
+static bool pv_timekeeper_enabled;
+static bool pv_timekeeper_present;
+static int old_vclock_mode;
+
+static u64
+kvm_hostclock_get_cycles(struct clocksource *cs)
+{
+	return rdtsc_ordered();
+}
+
+static int
+kvm_hostclock_enable(struct clocksource *cs)
+{
+	pv_timekeeper_enabled = 1;
+
+	old_vclock_mode = kvm_clock.archdata.vclock_mode;
+	kvm_clock.archdata.vclock_mode = VCLOCK_TSC;
+	return 0;
+}
+
+static void
+kvm_hostclock_disable(struct clocksource *cs)
+{
+	pv_timekeeper_enabled = 0;
+	kvm_clock.archdata.vclock_mode = old_vclock_mode;
+}
+
+struct clocksource kvm_hostclock = {
+	.name = "kvm-hostclock",
+	.read = kvm_hostclock_get_cycles,
+	.enable = kvm_hostclock_enable,
+	.disable = kvm_hostclock_disable,
+	.rating = 401, /* Higher than kvm-clock */
+	.mask = CLOCKSOURCE_MASK(64),
+	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static void
+pvclock_copy_into_read_base(struct pvclock_timekeeper *pvtk,
+    struct tk_read_base *tkr, struct pvclock_read_base *pvtkr)
+{
+	int shift_diff;
+
+	tkr->mask = pvtkr->mask;
+	tkr->cycle_last = pvtkr->cycle_last + pvtk->tsc_offset;
+	tkr->mult = pvtkr->mult;
+	shift_diff = tkr->shift - pvtkr->shift;
+	tkr->shift = pvtkr->shift;
+	tkr->xtime_nsec = pvtkr->xtime_nsec;
+	tkr->base = pvtkr->base;
+}
+
+static u64
+pvtk_read_begin(struct pvclock_timekeeper *pvtk)
+{
+	u64 gen;
+
+	gen = pvtk->gen & ~1;
+	/* Make sure that the gen count is read before the data. */
+	virt_rmb();
+
+	return gen;
+}
+
+static bool
+pvtk_read_retry(struct pvclock_timekeeper *pvtk, u64 gen)
+{
+	/* Make sure that the gen count is re-read after the data. */
+	virt_rmb();
+	return unlikely(gen != pvtk->gen);
+}
+
+void
+kvm_clock_copy_into_tk(struct timekeeper *tk)
+{
+	struct pvclock_timekeeper *pvtk;
+	u64 gen;
+
+	if (!pv_timekeeper_enabled)
+		return;
+
+	pvtk = &pv_timekeeper;
+	do {
+		gen = pvtk_read_begin(pvtk);
+		if (!(pv_timekeeper.flags & PVCLOCK_TIMEKEEPER_ENABLED))
+			return;
+
+		pvclock_copy_into_read_base(pvtk, &tk->tkr_mono,
+		    &pvtk->tkr_mono);
+		pvclock_copy_into_read_base(pvtk, &tk->tkr_raw, &pvtk->tkr_raw);
+
+		tk->xtime_sec = pvtk->xtime_sec;
+		tk->ktime_sec = pvtk->ktime_sec;
+		tk->wall_to_monotonic.tv_sec = pvtk->wall_to_monotonic_sec;
+		tk->wall_to_monotonic.tv_nsec = pvtk->wall_to_monotonic_nsec;
+		tk->offs_real = pvtk->offs_real;
+		tk->offs_boot = pvtk->offs_boot;
+		tk->offs_tai = pvtk->offs_tai;
+		tk->raw_sec = pvtk->raw_sec;
+	} while (pvtk_read_retry(pvtk, gen));
+}
+
+void __init
+kvm_hostclock_init(void)
+{
+	unsigned long pa;
+
+	pa = __pa(&pv_timekeeper);
+	wrmsrl(MSR_KVM_TIMEKEEPER_EN, pa);
+	if (pv_timekeeper.flags & PVCLOCK_TIMEKEEPER_ENABLED) {
+		pv_timekeeper_present = 1;
+
+		clocksource_register_khz(&kvm_hostclock, kvm_get_tsc_khz());
+	}
+}
diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index 84ff2844df2a..43b036375cdc 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -153,4 +153,12 @@ static inline void update_vsyscall_tz(void)
 }
 #endif
 
+#ifdef CONFIG_KVM_HOSTCLOCK
+void kvm_clock_copy_into_tk(struct timekeeper *tk);
+#else
+static inline void kvm_clock_copy_into_tk(struct timekeeper *tk)
+{
+}
+#endif
+
 #endif /* _LINUX_TIMEKEEPER_INTERNAL_H */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ca69290bee2a..09bcf13b2334 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -2107,6 +2107,8 @@ static void timekeeping_advance(enum timekeeping_adv_mode mode)
 	clock_set |= accumulate_nsecs_to_secs(tk);
 
 	write_seqcount_begin(&tk_core.seq);
+	kvm_clock_copy_into_tk(tk);
+
 	/*
 	 * Update the real timekeeper.
 	 *
-- 
2.23.0.581.g78d2f28ef7-goog

