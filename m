Return-Path: <kvm+bounces-29833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D89999B2DA5
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 11:57:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C897281273
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 10:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 636501DE8BA;
	Mon, 28 Oct 2024 10:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CFYZb920"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802781DE896;
	Mon, 28 Oct 2024 10:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730112714; cv=none; b=TGb5NcQrRWOE3mGm4drdhAqrtu8nreIOVtKzuz2+zJ5zvXU3nPQwW8NEdU63vQfO+EUcJ+hAMXAQUwTBrnKqr8HC/AqhHNHXuPS6DMC8xiN+hfgpyYyIzbhAQ0Ojh3EpJA+iOQcnbobq3AHFWNGdATIH5gx3XmdTHaqlAeS4RHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730112714; c=relaxed/simple;
	bh=OWxOGNmUPDrLPuT3wSvfntoRXHJZRuAiTlwBH3kokJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PB8wm/hKE/3RUZ0hY6NmyDJ/8EO1IKJTbVpT3NxBwDjL5NhbP84it67yDkxMjvcaGIDp122zpgSFCc7ZuZ+H2jsxXCfuFQoEyZaROJk55rljfTf1D7DudJq9/Ru67j3hMeLBPqLdgIbRkk2VegIfrZjo6Oi7+g17AxB5lUfCmGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CFYZb920; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3975C4CEC3;
	Mon, 28 Oct 2024 10:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730112714;
	bh=OWxOGNmUPDrLPuT3wSvfntoRXHJZRuAiTlwBH3kokJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CFYZb920CGPX7sVtjYlZfcgoDy1A43SRU62DqIRMMTajhwccKxHm+c8OgqFk41Tw5
	 fn2o1V0l06wlklJK4Rm4IUgAEwVdI4gr1Wtv1ls+tCKNrAg17LFKfVVQ5pLxzXAed2
	 2wtRYkXsQBVOSP6PLQe3vi0PN9TUyj8KtLod6F70WGaA36PBsicyJcfnF4ZJjCo3yz
	 q5f0b6z0Zsh3TLqRQnEyuvGbGGLa2wqx2/NTXhA8vsrJ1/dZDFIhdgkoiGvQqWL8sz
	 c0wPPAULAYz03CxkdgRLTmJvrWfQY9dzCucRqltEaL9ynKcGSQ8JWAS98hgJgPMZrW
	 zg+KDicpusiww==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Huacai Chen <chenhuacai@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Sasha Levin <sashal@kernel.org>,
	zhaotianrui@loongson.cn,
	chenhuacai@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	rostedt@goodmis.org,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.11 25/32] LoongArch: KVM: Mark hrtimer to expire in hard interrupt context
Date: Mon, 28 Oct 2024 06:50:07 -0400
Message-ID: <20241028105050.3559169-25-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241028105050.3559169-1-sashal@kernel.org>
References: <20241028105050.3559169-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11.5
Content-Transfer-Encoding: 8bit

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 73adbd92f3223dc0c3506822b71c6b259d5d537b ]

Like commit 2c0d278f3293f ("KVM: LAPIC: Mark hrtimer to expire in hard
interrupt context") and commit 9090825fa9974 ("KVM: arm/arm64: Let the
timer expire in hardirq context on RT"), On PREEMPT_RT enabled kernels
unmarked hrtimers are moved into soft interrupt expiry mode by default.
Then the timers are canceled from an preempt-notifier which is invoked
with disabled preemption which is not allowed on PREEMPT_RT.

The timer callback is short so in could be invoked in hard-IRQ context.
So let the timer expire on hard-IRQ context even on -RT.

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

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kvm/timer.c | 7 ++++---
 arch/loongarch/kvm/vcpu.c  | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/kvm/timer.c b/arch/loongarch/kvm/timer.c
index 74a4b5c272d60..32dc213374bea 100644
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
index 6905283f535b9..9218fc521c22d 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1144,7 +1144,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.vpid = 0;
 	vcpu->arch.flush_gpa = INVALID_GPA;
 
-	hrtimer_init(&vcpu->arch.swtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED);
+	hrtimer_init(&vcpu->arch.swtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED_HARD);
 	vcpu->arch.swtimer.function = kvm_swtimer_wakeup;
 
 	vcpu->arch.handle_exit = kvm_handle_exit;
-- 
2.43.0


