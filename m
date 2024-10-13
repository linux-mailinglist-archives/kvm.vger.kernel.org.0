Return-Path: <kvm+bounces-28698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FA5F99B8E3
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2024 11:02:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F4171C20C8D
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2024 09:02:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C483613B29F;
	Sun, 13 Oct 2024 09:01:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40035804;
	Sun, 13 Oct 2024 09:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728810113; cv=none; b=LSv3Tdxu6C2DW+9ghIQBMXfYJ/psGCYZLbYOnNnVK7lyGqBuTcmcO+kUxBMwJtZgfclQogPZlkrTX5ytJHqeIRwMaXAJzHYbfJIWe76EFmSpsZfEBgHvXDtEogI8wU3STMkKoZGYBdyOBsgsEB9tjO1tMAbNiy01jAHBWYrCr0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728810113; c=relaxed/simple;
	bh=rauAsYdONhYsT5hDvf7/b86dTBwmMtPrN/bkxgb2qlA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZIVSAz78hbT/AyhcAWmpj9QrXfLKibRMxOiLEHs8pcezWZQ1ihXnJant4HMOPqxuf41htgjfBJUecmDT8LcCOn3IsdEvrnKspkPwV8kxgn+363uvNajYlbGrzpPh+kj85NBPepDZL5pszJca0nBRtxdHPwzHdsJ+/A5jyH36B+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA18C4CEC5;
	Sun, 13 Oct 2024 09:01:49 +0000 (UTC)
From: Huacai Chen <chenhuacai@loongson.cn>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Xuerui Wang <kernel@xen0n.name>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH] LoongArch: KVM: Mark hrtimer to expire in hard interrupt context
Date: Sun, 13 Oct 2024 17:01:36 +0800
Message-ID: <20241013090136.1254036-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Like commit 2c0d278f3293fc5 ("KVM: LAPIC: Mark hrtimer to expire in hard
interrupt context"), On PREEMPT_RT enabled kernels unmarked hrtimers are
moved into soft interrupt expiry mode by default.

While that's not a functional requirement for the KVM constant timer
emulation, it is a latency issue which can be avoided by marking the
timer so hard interrupt context expiry is enforced.

This fix a "scheduling while atomic" bug for PREEMPT_RT enabled kernels:

 BUG: scheduling while atomic: qemu-system-loo/1011/0x00000002
 Modules linked in: amdgpu rfkill nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat ns
 CPU: 1 UID: 0 PID: 1011 Comm: qemu-system-loo Tainted: G        W          6.12.0-rc2+ #1774
 Tainted: [W]=WARN
 Hardware name: Loongson Loongson-3A5000-7A1000-1w-CRB/Loongson-LS3A5000-7A1000-1w-CRB, BIOS vUDK2018-LoongArch-V2.0.0-prebeta9 10/21/2022
 Stack : ffffffffffffffff 0000000000000000 9000000004e3ea38 9000000116744000
         90000001167475a0 0000000000000000 90000001167475a8 9000000005644830
         90000000058dc000 90000000058dbff8 9000000116747420 0000000000000001
         0000000000000001 6a613fc938313980 000000000790c000 90000001001c1140
         00000000000003fe 0000000000000001 000000000000000d 0000000000000003
         0000000000000030 00000000000003f3 000000000790c000 9000000116747830
         90000000057ef000 0000000000000000 9000000005644830 0000000000000004
         0000000000000000 90000000057f4b58 0000000000000001 9000000116747868
         900000000451b600 9000000005644830 9000000003a13998 0000000010000020
         00000000000000b0 0000000000000004 0000000000000000 0000000000071c1d
         ...
 Call Trace:
 [<9000000003a13998>] show_stack+0x38/0x180
 [<9000000004e3ea34>] dump_stack_lvl+0x84/0xc0
 [<9000000003a71708>] __schedule_bug+0x48/0x60
 [<9000000004e45734>] __schedule+0x1114/0x1660
 [<9000000004e46040>] schedule_rtlock+0x20/0x60
 [<9000000004e4e330>] rtlock_slowlock_locked+0x3f0/0x10a0
 [<9000000004e4f038>] rt_spin_lock+0x58/0x80
 [<9000000003b02d68>] hrtimer_cancel_wait_running+0x68/0xc0
 [<9000000003b02e30>] hrtimer_cancel+0x70/0x80
 [<ffff80000235eb70>] kvm_restore_timer+0x50/0x1a0 [kvm]
 [<ffff8000023616c8>] kvm_arch_vcpu_load+0x68/0x2a0 [kvm]
 [<ffff80000234c2d4>] kvm_sched_in+0x34/0x60 [kvm]
 [<9000000003a749a0>] finish_task_switch.isra.0+0x140/0x2e0
 [<9000000004e44a70>] __schedule+0x450/0x1660
 [<9000000004e45cb0>] schedule+0x30/0x180
 [<ffff800002354c70>] kvm_vcpu_block+0x70/0x120 [kvm]
 [<ffff800002354d80>] kvm_vcpu_halt+0x60/0x3e0 [kvm]
 [<ffff80000235b194>] kvm_handle_gspr+0x3f4/0x4e0 [kvm]
 [<ffff80000235f548>] kvm_handle_exit+0x1c8/0x260 [kvm]

Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
 arch/loongarch/kvm/timer.c | 7 ++++---
 arch/loongarch/kvm/vcpu.c  | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/kvm/timer.c b/arch/loongarch/kvm/timer.c
index 74a4b5c272d6..32dc213374be 100644
--- a/arch/loongarch/kvm/timer.c
+++ b/arch/loongarch/kvm/timer.c
@@ -161,10 +161,11 @@ static void _kvm_save_timer(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_is_blocking(vcpu)) {
 
 		/*
-		 * HRTIMER_MODE_PINNED is suggested since vcpu may run in
-		 * the same physical cpu in next time
+		 * HRTIMER_MODE_PINNED_HARD is suggested since vcpu may run in
+		 * the same physical cpu in next time, and the timer should run
+		 * in hardirq context even in the PREEMPT_RT case.
 		 */
-		hrtimer_start(&vcpu->arch.swtimer, expire, HRTIMER_MODE_ABS_PINNED);
+		hrtimer_start(&vcpu->arch.swtimer, expire, HRTIMER_MODE_ABS_PINNED_HARD);
 	}
 }
 
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 0697b1064251..174734a23d0a 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1457,7 +1457,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.vpid = 0;
 	vcpu->arch.flush_gpa = INVALID_GPA;
 
-	hrtimer_init(&vcpu->arch.swtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED);
+	hrtimer_init(&vcpu->arch.swtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED_HARD);
 	vcpu->arch.swtimer.function = kvm_swtimer_wakeup;
 
 	vcpu->arch.handle_exit = kvm_handle_exit;
-- 
2.43.5


