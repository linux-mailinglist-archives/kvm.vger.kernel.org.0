Return-Path: <kvm+bounces-55982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1342AB38F8A
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 02:03:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FF8E1C2407A
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 00:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C510238C0F;
	Thu, 28 Aug 2025 00:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qVi2AUVK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3831FC0E2
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 00:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756339334; cv=none; b=MoUqnsF0B12DxY+X5bw8CLdTGJHzVt1RJgbavvlD4QyUPpONDVcGfeKD1rW+0e8c72aGwBNgGU50BxdqIynFrpCHX7FqdnyEa93Ue4eHw9thAVOSqFe8k7Xx1YXNwQxaKiGBSYLlzyTCxo1tH5rKxc+qo1FXNalBqeIcYdGvL1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756339334; c=relaxed/simple;
	bh=lsbTtJ9REHlgrqBN+k6iaEHNVEPv1fMDNzSuVRZk8kQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qaNrKgBGFo4yDFxcASIwRea7i/PRpCn47JF36S43QhSen2zyZzkJt3bSZkXNVM5Eah+P8+Fi3dH5IdlFUjm4CSfhFnUfs8ycFz0gnWiC6DTiLw7BFldrPIwnXmcNI9o7YUojNJR9yH829Jw2DxnhSlpMi/9mUY032HlC/vEfrjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qVi2AUVK; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-325e31cecd6so308882a91.3
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 17:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756339331; x=1756944131; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7ZBmpPS6PywnvKIddGOxOnP1jmQ+MNdB8M5wZqe5Cyo=;
        b=qVi2AUVKCwLQy5R04zWPPRucgyj4qO1yf8a48gMZyqHYJiyxJ8LILF+LtlfV0PrlmN
         BXQ3anT5Ty8dk4YwFa8rOcJY0UhxGDpB6ukt/5tATGaowl4F/CvNkoYvEE0Re4fxp7Eu
         bolvWFeITS41QU4FF/J1BgjHOhZdKixTFPgDJd9NOdL+mxOYoothF6XZc5vH8okXOZT9
         xgETTd8416y2QYokrv3y5sZTIAvCtLig7UUDSMecddrsCrbtgnubCLBn6rhN5G39gX6d
         CnHTC/QD4L4QhgvJ/QmfUragKTZ5gwIYGMoWCSfhv55pNhobM26CZQ7oxHRMb6WFLqOa
         QUeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756339331; x=1756944131;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ZBmpPS6PywnvKIddGOxOnP1jmQ+MNdB8M5wZqe5Cyo=;
        b=ejWQ74PKBCkk2/0GOJaGkcoOxp3jVydy1ae2w+7TwqKi+0q94f3XEtVw8Uke+ewa59
         PmxZ7W/SK2rDmvSr49gk5C/gJ/cPPAmVf56beGegx3/aPwpbokTNR5DKoOcEtnlIyMvD
         fqa3I20HiTmIfnK4Apj5ka+qAhffs7cJeirn6c8bS8NKep4K5gmHA7N3VEgxyxjoq1Ob
         oO8/QC1TIXM9UT4ycg5kkhb2Ch8a6jYGzYKHzngT1bYz4wsDQiwh48PCSXwZMEZaugc8
         lVGcHoaaJPgLDFcvo4u+32iXxpQsYYgovSj3SFtVvWEmR5Rkn/8Jmf+VqqXjT1kxhoc1
         RbYA==
X-Forwarded-Encrypted: i=1; AJvYcCVvUoO4blCVEpHVgPlmSeZz8Iv12zEfuoBHvjrlWZOWKz9KpAlqkxnQbqMFjVM8g9tWzFA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxd9FbA1vHHdYc6kQ71f+aR4ppEmGq9Qw5xdS43/2yOoaKX9dxi
	XZkvhmE9nq5NLaNLGwMBWp3yR2elypCBFbsVx385AW1AHm4cwb5o7ENSgmez5Pvvk0RHERVNdRj
	iRKXFWg==
X-Google-Smtp-Source: AGHT+IEObhMRiog6LB3x56k1ysUr452rBBv/DRbv5B4tUYWRR2fTs8YO333KIDdDJ77/kyKV99u2TWP8gGM=
X-Received: from pjbpm6.prod.google.com ([2002:a17:90b:3c46:b0:325:238b:5dc6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2ccd:b0:321:4760:c65a
 with SMTP id 98e67ed59e1d1-32517d1e054mr26335387a91.27.1756339331031; Wed, 27
 Aug 2025 17:02:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Aug 2025 17:01:54 -0700
In-Reply-To: <20250828000156.23389-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250828000156.23389-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.268.g9569e192d0-goog
Message-ID: <20250828000156.23389-6-seanjc@google.com>
Subject: [PATCH v2 5/7] entry: Rename "kvm" entry code assets to "virt" to
 genericize APIs
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andy Lutomirski <luto@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-hyperv@vger.kernel.org, rcu@vger.kernel.org, 
	Nuno Das Neves <nunodasneves@linux.microsoft.com>, Mukesh R <mrathor@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"

Rename the "kvm" entry code files and Kconfigs to use generic "virt"
nomenclature so that the code can be reused by other hypervisors (or
rather, their root/dom0 partition drivers), without incorrectly suggesting
the code somehow relies on and/or involves KVM.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 MAINTAINERS                                 | 2 +-
 arch/arm64/kvm/Kconfig                      | 2 +-
 arch/loongarch/kvm/Kconfig                  | 2 +-
 arch/riscv/kvm/Kconfig                      | 2 +-
 arch/x86/kvm/Kconfig                        | 2 +-
 include/linux/{entry-kvm.h => entry-virt.h} | 8 ++++----
 include/linux/kvm_host.h                    | 6 +++---
 include/linux/rcupdate.h                    | 2 +-
 kernel/entry/Makefile                       | 2 +-
 kernel/entry/{kvm.c => virt.c}              | 2 +-
 kernel/rcu/tree.c                           | 6 +++---
 virt/kvm/Kconfig                            | 2 +-
 12 files changed, 19 insertions(+), 19 deletions(-)
 rename include/linux/{entry-kvm.h => entry-virt.h} (94%)
 rename kernel/entry/{kvm.c => virt.c} (97%)

diff --git a/MAINTAINERS b/MAINTAINERS
index fe168477caa4..c255048333f0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10200,7 +10200,7 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core/entry
 F:	include/linux/entry-common.h
-F:	include/linux/entry-kvm.h
+F:	include/linux/entry-virt.h
 F:	include/linux/irq-entry-common.h
 F:	kernel/entry/
 
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 713248f240e0..6f4fc3caa31a 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -25,7 +25,7 @@ menuconfig KVM
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select KVM_MMIO
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
-	select KVM_XFER_TO_GUEST_WORK
+	select VIRT_XFER_TO_GUEST_WORK
 	select KVM_VFIO
 	select HAVE_KVM_DIRTY_RING_ACQ_REL
 	select NEED_KVM_DIRTY_RING_WITH_BITMAP
diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
index 40eea6da7c25..ae64bbdf83a7 100644
--- a/arch/loongarch/kvm/Kconfig
+++ b/arch/loongarch/kvm/Kconfig
@@ -31,7 +31,7 @@ config KVM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_MMU_NOTIFIER
 	select KVM_MMIO
-	select KVM_XFER_TO_GUEST_WORK
+	select VIRT_XFER_TO_GUEST_WORK
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	help
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index 5a62091b0809..c50328212917 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -30,7 +30,7 @@ config KVM
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_MMIO
-	select KVM_XFER_TO_GUEST_WORK
+	select VIRT_XFER_TO_GUEST_WORK
 	select KVM_GENERIC_MMU_NOTIFIER
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 2c86673155c9..f81074b0c0a8 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -40,7 +40,7 @@ config KVM_X86
 	select HAVE_KVM_MSI
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select HAVE_KVM_NO_POLL
-	select KVM_XFER_TO_GUEST_WORK
+	select VIRT_XFER_TO_GUEST_WORK
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_VFIO
 	select HAVE_KVM_PM_NOTIFIER if PM
diff --git a/include/linux/entry-kvm.h b/include/linux/entry-virt.h
similarity index 94%
rename from include/linux/entry-kvm.h
rename to include/linux/entry-virt.h
index 3644de7e6019..42c89e3e5ca7 100644
--- a/include/linux/entry-kvm.h
+++ b/include/linux/entry-virt.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __LINUX_ENTRYKVM_H
-#define __LINUX_ENTRYKVM_H
+#ifndef __LINUX_ENTRYVIRT_H
+#define __LINUX_ENTRYVIRT_H
 
 #include <linux/static_call_types.h>
 #include <linux/resume_user_mode.h>
@@ -10,7 +10,7 @@
 #include <linux/tick.h>
 
 /* Transfer to guest mode work */
-#ifdef CONFIG_KVM_XFER_TO_GUEST_WORK
+#ifdef CONFIG_VIRT_XFER_TO_GUEST_WORK
 
 #ifndef ARCH_XFER_TO_GUEST_MODE_WORK
 # define ARCH_XFER_TO_GUEST_MODE_WORK	(0)
@@ -90,6 +90,6 @@ static inline bool xfer_to_guest_mode_work_pending(void)
 	lockdep_assert_irqs_disabled();
 	return __xfer_to_guest_mode_work_pending();
 }
-#endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
+#endif /* CONFIG_VIRT_XFER_TO_GUEST_WORK */
 
 #endif
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 598b9473e46d..70ac2267d5d0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2,7 +2,7 @@
 #ifndef __KVM_HOST_H
 #define __KVM_HOST_H
 
-#include <linux/entry-kvm.h>
+#include <linux/entry-virt.h>
 #include <linux/types.h>
 #include <linux/hardirq.h>
 #include <linux/list.h>
@@ -2444,7 +2444,7 @@ static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE */
 
-#ifdef CONFIG_KVM_XFER_TO_GUEST_WORK
+#ifdef CONFIG_VIRT_XFER_TO_GUEST_WORK
 static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 {
 	vcpu->run->exit_reason = KVM_EXIT_INTR;
@@ -2461,7 +2461,7 @@ static inline int kvm_xfer_to_guest_mode_handle_work(struct kvm_vcpu *vcpu)
 	}
 	return r;
 }
-#endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
+#endif /* CONFIG_VIRT_XFER_TO_GUEST_WORK */
 
 /*
  * If more than one page is being (un)accounted, @virt must be the address of
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 120536f4c6eb..1e1f3aa375d9 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -129,7 +129,7 @@ static inline void rcu_sysrq_start(void) { }
 static inline void rcu_sysrq_end(void) { }
 #endif /* #else #ifdef CONFIG_RCU_STALL_COMMON */
 
-#if defined(CONFIG_NO_HZ_FULL) && (!defined(CONFIG_GENERIC_ENTRY) || !defined(CONFIG_KVM_XFER_TO_GUEST_WORK))
+#if defined(CONFIG_NO_HZ_FULL) && (!defined(CONFIG_GENERIC_ENTRY) || !defined(CONFIG_VIRT_XFER_TO_GUEST_WORK))
 void rcu_irq_work_resched(void);
 #else
 static __always_inline void rcu_irq_work_resched(void) { }
diff --git a/kernel/entry/Makefile b/kernel/entry/Makefile
index 77fcd83dd663..2333d70802e4 100644
--- a/kernel/entry/Makefile
+++ b/kernel/entry/Makefile
@@ -14,4 +14,4 @@ CFLAGS_common.o		+= -fno-stack-protector
 
 obj-$(CONFIG_GENERIC_IRQ_ENTRY) 	+= common.o
 obj-$(CONFIG_GENERIC_SYSCALL) 		+= syscall-common.o syscall_user_dispatch.o
-obj-$(CONFIG_KVM_XFER_TO_GUEST_WORK)	+= kvm.o
+obj-$(CONFIG_VIRT_XFER_TO_GUEST_WORK)	+= virt.o
diff --git a/kernel/entry/kvm.c b/kernel/entry/virt.c
similarity index 97%
rename from kernel/entry/kvm.c
rename to kernel/entry/virt.c
index 6fc762eaacca..c52f99249763 100644
--- a/kernel/entry/kvm.c
+++ b/kernel/entry/virt.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
-#include <linux/entry-kvm.h>
+#include <linux/entry-virt.h>
 
 static int xfer_to_guest_mode_work(unsigned long ti_work)
 {
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 174ee243b349..995489b72535 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -573,7 +573,7 @@ void rcutorture_format_gp_seqs(unsigned long long seqs, char *cp, size_t len)
 }
 EXPORT_SYMBOL_GPL(rcutorture_format_gp_seqs);
 
-#if defined(CONFIG_NO_HZ_FULL) && (!defined(CONFIG_GENERIC_ENTRY) || !defined(CONFIG_KVM_XFER_TO_GUEST_WORK))
+#if defined(CONFIG_NO_HZ_FULL) && (!defined(CONFIG_GENERIC_ENTRY) || !defined(CONFIG_VIRT_XFER_TO_GUEST_WORK))
 /*
  * An empty function that will trigger a reschedule on
  * IRQ tail once IRQs get re-enabled on userspace/guest resume.
@@ -602,7 +602,7 @@ noinstr void rcu_irq_work_resched(void)
 	if (IS_ENABLED(CONFIG_GENERIC_ENTRY) && !(current->flags & PF_VCPU))
 		return;
 
-	if (IS_ENABLED(CONFIG_KVM_XFER_TO_GUEST_WORK) && (current->flags & PF_VCPU))
+	if (IS_ENABLED(CONFIG_VIRT_XFER_TO_GUEST_WORK) && (current->flags & PF_VCPU))
 		return;
 
 	instrumentation_begin();
@@ -611,7 +611,7 @@ noinstr void rcu_irq_work_resched(void)
 	}
 	instrumentation_end();
 }
-#endif /* #if defined(CONFIG_NO_HZ_FULL) && (!defined(CONFIG_GENERIC_ENTRY) || !defined(CONFIG_KVM_XFER_TO_GUEST_WORK)) */
+#endif /* #if defined(CONFIG_NO_HZ_FULL) && (!defined(CONFIG_GENERIC_ENTRY) || !defined(CONFIG_VIRT_XFER_TO_GUEST_WORK)) */
 
 #ifdef CONFIG_PROVE_RCU
 /**
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 727b542074e7..ce843db53831 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -87,7 +87,7 @@ config HAVE_KVM_VCPU_RUN_PID_CHANGE
 config HAVE_KVM_NO_POLL
        bool
 
-config KVM_XFER_TO_GUEST_WORK
+config VIRT_XFER_TO_GUEST_WORK
        bool
 
 config HAVE_KVM_PM_NOTIFIER
-- 
2.51.0.268.g9569e192d0-goog


