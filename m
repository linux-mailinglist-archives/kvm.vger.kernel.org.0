Return-Path: <kvm+bounces-64977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 62F67C95754
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 01:32:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0F0E2341C7C
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 00:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2A013635C;
	Mon,  1 Dec 2025 00:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WRlMEhOk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496FD8635D;
	Mon,  1 Dec 2025 00:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764549073; cv=none; b=F24psNuxnJqvRwiSqh9x4kskwDn7y21IsdIf0QKDY1HDKHi5jwzuJjst1zRAEGYIX3w9Xj6Rme29xoZArwqXm1wiK0o+pgbOfqu9YCgJKKiu2A7enwolgsz9AAXXuWTnFL9nu7UWnhNCUcZDkqV+Zge+EhYjWcTKBdrlFGDDMRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764549073; c=relaxed/simple;
	bh=ExgV75nN3+zv3C0lmBXc1FgUeJ7EJlAF0HXaBV/VLSQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a8sb7tv0emGojFfmPW6XX5UUsKWfknpiyjCd+FIJO2WY5q7g50qo0ZeFtGF9PixryXaOI/d/ChHxGlgD2LUpQ6ttcYA5XW27qZBGDj9LTBTzag/nZR+LT/CsWpV99rjpYdA2JcX4sUppAw0eidlLoyhLwtvv3tBY7DP7AYJwm8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WRlMEhOk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6688BC19422;
	Mon,  1 Dec 2025 00:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764549071;
	bh=ExgV75nN3+zv3C0lmBXc1FgUeJ7EJlAF0HXaBV/VLSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRlMEhOkXtNcgdDnQeCE/H0D5KvPjMdvoVc+5Hdr8d0LGfeTeZsV7CrDnuBMVBeNK
	 kP4v7nUGX8y/nweeRQIhOlaRuRnyi2+IN+5XS5MQ+TKsGoqBQD8VfaBq0Ts/n47Sac
	 BwXOL6F/WHVFKt8y1+1wSnqmf4M9YzXl8P2K5Q2RdTLYmJJA+He9tZSKhn7tPpSOC2
	 mD0nS4Zv/mz4YpU4B5QZNO9uvI0c+aNqnASu7EhlgHsi4vBwTyEoM8NRn7ci8HiNQX
	 Oid7psTHyZfkwMzvRiyxCnakpobJXI+ir7RenVlRxkWRUA1NGgLLzRPvbTxItAivsk
	 veXMqAEaJgqiw==
From: guoren@kernel.org
To: paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	guoren@kernel.org,
	leobras@redhat.com,
	ajones@ventanamicro.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	corbet@lwn.net
Cc: linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [RFC PATCH V3 4/4] RISC-V: paravirt: Support nopvspin to disable PARAVIRT_SPINLOCKS
Date: Sun, 30 Nov 2025 19:30:41 -0500
Message-Id: <20251201003041.695081-5-guoren@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20251201003041.695081-1-guoren@kernel.org>
References: <20251201003041.695081-1-guoren@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>

The VM guests should fall back to a Test-and-Set spinlock when
PARAVIRT_SPINLOCKS disabled, because fair locks have horrible lock
'holder' preemption issues. The virt_spin_lock_key would shortcut for
the queued_spin_lock_- slowpath() function that allow virt_spin_lock
to hijack it. ref: 43b3f02899f7 ("locking/qspinlock/x86: Fix
performance regression under unaccelerated VMs").

Add a static key controlling whether virt_spin_lock() should be
called or not. Add nopvspin support as x86.

Signed-off-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  2 +-
 arch/riscv/include/asm/qspinlock.h            | 24 +++++++++++++++++++
 arch/riscv/kernel/qspinlock_paravirt.c        |  8 +++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6c42061ca20e..9e895e9ca655 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4393,7 +4393,7 @@
 			as generic guest with no PV drivers. Currently support
 			XEN HVM, KVM, HYPER_V and VMWARE guest.
 
-	nopvspin	[X86,XEN,KVM,EARLY]
+	nopvspin	[X86,RISCV,XEN,KVM,EARLY]
 			Disables the qspinlock slow path using PV optimizations
 			which allow the hypervisor to 'idle' the guest on lock
 			contention.
diff --git a/arch/riscv/include/asm/qspinlock.h b/arch/riscv/include/asm/qspinlock.h
index b39f23415ec1..70ad7679fce0 100644
--- a/arch/riscv/include/asm/qspinlock.h
+++ b/arch/riscv/include/asm/qspinlock.h
@@ -14,6 +14,8 @@
 /* How long a lock should spin before we consider blocking */
 #define SPIN_THRESHOLD		(1 << 15)
 
+extern bool nopvspin;
+
 void native_queued_spin_lock_slowpath(struct qspinlock *lock, u32 val);
 void __pv_init_lock_hash(void);
 void __pv_queued_spin_lock_slowpath(struct qspinlock *lock, u32 val);
@@ -31,5 +33,27 @@ static inline void queued_spin_unlock(struct qspinlock *lock)
 #endif /* CONFIG_PARAVIRT_SPINLOCKS */
 
 #include <asm-generic/qspinlock.h>
+#include <asm/jump_label.h>
+
+/*
+ * The KVM guests fall back to a Test-and-Set spinlock, because fair locks
+ * have horrible lock 'holder' preemption issues. The test_and_set_spinlock_key
+ * would shortcut for the queued_spin_lock_slowpath() function that allow
+ * virt_spin_lock to hijack it.
+ */
+DECLARE_STATIC_KEY_FALSE(virt_spin_lock_key);
+
+#define virt_spin_lock rv_virt_spin_lock
+static inline bool rv_virt_spin_lock(struct qspinlock *lock)
+{
+	if (!static_branch_likely(&virt_spin_lock_key))
+		return false;
+
+	do {
+		smp_cond_load_relaxed((s32 *)&lock->val, VAL == 0);
+	} while (atomic_cmpxchg(&lock->val, 0, _Q_LOCKED_VAL) != 0);
+
+	return true;
+}
 
 #endif /* _ASM_RISCV_QSPINLOCK_H */
diff --git a/arch/riscv/kernel/qspinlock_paravirt.c b/arch/riscv/kernel/qspinlock_paravirt.c
index cae991139abe..b89f13d0d6e8 100644
--- a/arch/riscv/kernel/qspinlock_paravirt.c
+++ b/arch/riscv/kernel/qspinlock_paravirt.c
@@ -50,6 +50,8 @@ EXPORT_STATIC_CALL(pv_queued_spin_lock_slowpath);
 DEFINE_STATIC_CALL(pv_queued_spin_unlock, native_queued_spin_unlock);
 EXPORT_STATIC_CALL(pv_queued_spin_unlock);
 
+DEFINE_STATIC_KEY_FALSE(virt_spin_lock_key);
+
 bool __init pv_qspinlock_init(void)
 {
 	if (num_possible_cpus() == 1)
@@ -58,6 +60,12 @@ bool __init pv_qspinlock_init(void)
 	if (!sbi_probe_extension(SBI_EXT_PVLOCK))
 		return false;
 
+	if (nopvspin) {
+		static_branch_enable(&virt_spin_lock_key);
+		pr_info("virt_spin_lock enabled by nopvspin\n");
+		return true;
+	}
+
 	pr_info("PV qspinlocks enabled\n");
 	__pv_init_lock_hash();
 
-- 
2.40.1


