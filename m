Return-Path: <kvm+bounces-5212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7752281E09B
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 14:01:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6469A1C21A55
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 13:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E489524BD;
	Mon, 25 Dec 2023 12:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ue3ttxAW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40470524A5;
	Mon, 25 Dec 2023 12:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E322C433CB;
	Mon, 25 Dec 2023 12:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703509176;
	bh=sRu5uQXMfjV9M3QrgbIZOQlunfYwUSCeF2FiTCkkdbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ue3ttxAWslvIv7pLn6Mj8VWk34TUrl1II9v92xSYq/Mq3ZIVPTgBXEpUSUTBs00Yq
	 E3dV4B0pzx4ghEDnyjcBtYc3Gt6N2h9jerwQpzy48CpdBb3cHSnSBbStoNPi9tQAn5
	 T++fMtbSaMx657Qk/RpkKcIp064OIjf0Mtl7TUnWTIw2grnFYuboL7HA6+lphW6lJf
	 bcYqrYuseAbjf8/97AYR7CF6wNZxjWrs2sHF5s91qCE6nqKF6UkcLkyQqdqdg8+baN
	 8wGY7QejjSXJuJ8p9sdJwx5zhVYQr61DXPuYk2kej4LYtKXWVFABC8oP4yHCtLfbnr
	 +soXt2VJObP3A==
From: guoren@kernel.org
To: paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	guoren@kernel.org,
	panqinglin2020@iscas.ac.cn,
	bjorn@rivosinc.com,
	conor.dooley@microchip.com,
	leobras@redhat.com,
	peterz@infradead.org,
	anup@brainfault.org,
	keescook@chromium.org,
	wuwei2016@iscas.ac.cn,
	xiaoguang.xing@sophgo.com,
	chao.wei@sophgo.com,
	unicorn_wang@outlook.com,
	uwu@icenowy.me,
	jszhang@kernel.org,
	wefu@redhat.com,
	atishp@atishpatra.org
Cc: linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	Guo Ren <guoren@linux.alibaba.com>
Subject: [PATCH V12 07/14] riscv: qspinlock: Add virt_spin_lock() support for VM guest
Date: Mon, 25 Dec 2023 07:58:40 -0500
Message-Id: <20231225125847.2778638-8-guoren@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231225125847.2778638-1-guoren@kernel.org>
References: <20231225125847.2778638-1-guoren@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guo Ren <guoren@linux.alibaba.com>

Add a static key controlling whether virt_spin_lock() should be
called or not. When running on bare metal set the new key to
false.

The VM guests should fall back to a Test-and-Set spinlock,
because fair locks have horrible lock 'holder' preemption issues.
The virt_spin_lock_key would shortcut for the queued_spin_lock_-
slowpath() function that allow virt_spin_lock to hijack it.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  4 +++
 arch/riscv/include/asm/spinlock.h             | 22 ++++++++++++++++
 arch/riscv/kernel/setup.c                     | 26 +++++++++++++++++++
 3 files changed, 52 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 2ac9f1511774..b7794c96d91e 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3997,6 +3997,10 @@
 	no_uaccess_flush
 	                [PPC] Don't flush the L1-D cache after accessing user data.
 
+	no_virt_spin	[RISC-V] Disable virt_spin_lock in VM guest to use
+			native_queued_spinlock when the nopvspin option is enabled.
+			This would help vcpu=pcpu scenarios.
+
 	novmcoredd	[KNL,KDUMP]
 			Disable device dump. Device dump allows drivers to
 			append dump data to vmcore so you can collect driver
diff --git a/arch/riscv/include/asm/spinlock.h b/arch/riscv/include/asm/spinlock.h
index d07643c07aae..7bbcf3d9fff0 100644
--- a/arch/riscv/include/asm/spinlock.h
+++ b/arch/riscv/include/asm/spinlock.h
@@ -4,6 +4,28 @@
 #define __ASM_RISCV_SPINLOCK_H
 
 #ifdef CONFIG_QUEUED_SPINLOCKS
+/*
+ * The KVM guests fall back to a Test-and-Set spinlock, because fair locks
+ * have horrible lock 'holder' preemption issues. The virt_spin_lock_key
+ * would shortcut for the queued_spin_lock_slowpath() function that allow
+ * virt_spin_lock to hijack it.
+ */
+DECLARE_STATIC_KEY_TRUE(virt_spin_lock_key);
+
+#define virt_spin_lock virt_spin_lock
+static inline bool virt_spin_lock(struct qspinlock *lock)
+{
+	if (!static_branch_likely(&virt_spin_lock_key))
+		return false;
+
+	do {
+		while (atomic_read(&lock->val) != 0)
+			cpu_relax();
+	} while (atomic_cmpxchg(&lock->val, 0, _Q_LOCKED_VAL) != 0);
+
+	return true;
+}
+
 #define _Q_PENDING_LOOPS	(1 << 9)
 #endif
 
diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index d9072a59831c..0bafb9fd6ea3 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -27,6 +27,7 @@
 #include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
+#include <asm/cpufeature.h>
 #include <asm/early_ioremap.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
@@ -266,6 +267,27 @@ early_param("qspinlock", queued_spinlock_setup);
 DEFINE_STATIC_KEY_TRUE(combo_qspinlock_key);
 EXPORT_SYMBOL(combo_qspinlock_key);
 
+#ifdef CONFIG_QUEUED_SPINLOCKS
+static bool no_virt_spin __ro_after_init;
+static int __init no_virt_spin_setup(char *p)
+{
+	no_virt_spin = true;
+
+	return 0;
+}
+early_param("no_virt_spin", no_virt_spin_setup);
+
+DEFINE_STATIC_KEY_TRUE(virt_spin_lock_key);
+
+static void __init virt_spin_lock_init(void)
+{
+	if (no_virt_spin)
+		static_branch_disable(&virt_spin_lock_key);
+	else
+		pr_info("Enable virt_spin_lock\n");
+}
+#endif
+
 static void __init riscv_spinlock_init(void)
 {
 	if (!enable_qspinlock) {
@@ -274,6 +296,10 @@ static void __init riscv_spinlock_init(void)
 	} else {
 		pr_info("Queued spinlock: enabled\n");
 	}
+
+#ifdef CONFIG_QUEUED_SPINLOCKS
+	virt_spin_lock_init();
+#endif
 }
 #endif
 
-- 
2.40.1


