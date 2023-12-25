Return-Path: <kvm+bounces-5217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA79A81E0AD
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 14:03:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DD431F222FE
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 13:03:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AF1955C23;
	Mon, 25 Dec 2023 13:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HHLBBAnp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C028E55C00;
	Mon, 25 Dec 2023 13:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F47EC433C9;
	Mon, 25 Dec 2023 12:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703509200;
	bh=ODSRlqemB7gRQiZhfDlWrTaT1uOIIWzSdyDrN4uUjz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHLBBAnppN8o1pDLvfunhLB3Lt7KIVadT3NnTcn5SeCKjvTRQgM4K4iXQOFErew9F
	 ndXJaJGkSxgn856NCf4OewK7dyrSqkDQlE54srL+wIlNRs7pOZODCz4VUwGa6Xmf6+
	 bp+vPyCJJZYfGRt569xm7px0kHlXZOtgnipq7eozxtZM4ImLOAEwbhMAAXaRmPEzNq
	 Rki4RUiNkCK0vHj8j0j1huJYkDKcuGN0Q1v2LP/OGvHeytt2O+/tvNuF2pd6AeGDdb
	 St1pQ7BXZ7AreXCvnoA6IBJWYdBdFLfdHkFqR/ZEYRAToqSyeIX1YenPa9Dz0T1bpf
	 NZ6YmbH9G5kTg==
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
Subject: [PATCH V12 12/14] RISC-V: paravirt: pvqspinlock: Add nopvspin kernel parameter
Date: Mon, 25 Dec 2023 07:58:45 -0500
Message-Id: <20231225125847.2778638-13-guoren@kernel.org>
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

Disables the qspinlock slow path using PV optimizations which
allow the hypervisor to 'idle' the guest on lock contention.

Reviewed-by: Leonardo Bras <leobras@redhat.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  2 +-
 arch/riscv/kernel/qspinlock_paravirt.c          | 13 +++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index b7794c96d91e..4aff81d741e2 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3927,7 +3927,7 @@
 			as generic guest with no PV drivers. Currently support
 			XEN HVM, KVM, HYPER_V and VMWARE guest.
 
-	nopvspin	[X86,XEN,KVM]
+	nopvspin	[X86,XEN,KVM,RISC-V]
 			Disables the qspinlock slow path using PV optimizations
 			which allow the hypervisor to 'idle' the guest on lock
 			contention.
diff --git a/arch/riscv/kernel/qspinlock_paravirt.c b/arch/riscv/kernel/qspinlock_paravirt.c
index 7d1b99412222..4b04c93c4b9b 100644
--- a/arch/riscv/kernel/qspinlock_paravirt.c
+++ b/arch/riscv/kernel/qspinlock_paravirt.c
@@ -43,8 +43,21 @@ EXPORT_STATIC_CALL(pv_queued_spin_lock_slowpath);
 DEFINE_STATIC_CALL(pv_queued_spin_unlock, native_queued_spin_unlock);
 EXPORT_STATIC_CALL(pv_queued_spin_unlock);
 
+static bool nopvspin __initdata;
+static __init int parse_nopvspin(char *arg)
+{
+       nopvspin = true;
+       return 0;
+}
+early_param("nopvspin", parse_nopvspin);
+
 void __init pv_qspinlock_init(void)
 {
+	if (nopvspin) {
+		pr_info("PV qspinlocks disabled\n");
+		return;
+	}
+
 	if (num_possible_cpus() == 1)
 		return;
 
-- 
2.40.1


