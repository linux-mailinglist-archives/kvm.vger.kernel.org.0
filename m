Return-Path: <kvm+bounces-54251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C43E3B1D6D9
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 13:43:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1F7A18C779C
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:43:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652BD2797BD;
	Thu,  7 Aug 2025 11:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="JwujuNOM"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E25F10957;
	Thu,  7 Aug 2025 11:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754566986; cv=none; b=Q6z2jAN4bp3nql8EFi1D1OVYw25GAzpo3lATS0GR1DehawmU2a+oo0bYHljjASS3LIXGdsoQ5r78anPp35gYzJ50e3jzvAhfqZHak9K8b/05XyVrgaAS7M3BxgyNckSmtUv19T8L/gsafrPPVJg94phUlLHQFMlYuOuKqVdsnHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754566986; c=relaxed/simple;
	bh=0vAwBYtiqco7Ej9Yjxjq8k+qOfdHzMmvLHNbpgdBA54=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SzwDyiqGOdPwL8juwXKVFJSVThybrWLqFV+3dxMMmqVbip+MAeEP8I+94tzNHsPjsum4uL/Eq6+zH6PBRENVdEALMg7r+sqfhnYLlFqopwtdAxxzSEF+G4IROTeZlA7qVI1GYofJ9Yf1bRIjJLRvRAqEsUUQG2DZiLNxAJMukdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=JwujuNOM; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=PW
	fzr+zJFrTN7MTaKivF+UZ6XkZSxRB/9DJOS9UoMB8=; b=JwujuNOMcl4UvRSpqf
	3eT61Q+mXki1B9CRP4j2VycuCRGagDiQWtfVEk0WCi3LLiuqs9S4kBVG2OKbC+iZ
	G7kibZ4Fv8TVKgPF/EdfamOadLKVcL5si4EMeC8AonvhnOnT+Q996MHLGQsxcoSp
	8gR5Xqv8D5GwCw2qFihwq6I5A=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD3H0cfkZRojzptAQ--.275S2;
	Thu, 07 Aug 2025 19:42:24 +0800 (CST)
From: Jinyu Tang <tjytimi@163.com>
To: Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Conor Dooley <conor.dooley@microchip.com>,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Paul Walmsley <paul.walmsley@sifive.com>
Cc: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Jinyu Tang <tjytimi@163.com>
Subject: [PATCH] riscv: skip csr restore if vcpu preempted reload
Date: Thu,  7 Aug 2025 19:42:20 +0800
Message-ID: <20250807114220.559098-1-tjytimi@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3H0cfkZRojzptAQ--.275S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KFy8XF47Gr18ZF43Jw17Awb_yoW8tF15pF
	W7urs09w48JrW7G342qrs5uF4FvrsYgrn3Xr9rXrWfAr15tryFyF4kKa47AFW5GrWrZF1S
	yF1ktFyxC3Z5ZwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piSdgJUUUUU=
X-CM-SenderInfo: xwm13xlpl6il2tof0z/1tbiZRKieGiUfiGXWQABsB

The kvm_arch_vcpu_load() function is called in two cases for riscv:
1. When entering KVM_RUN from userspace ioctl.
2. When a preempted VCPU is scheduled back.

In the second case, if no other KVM VCPU has run on this CPU since the
current VCPU was preempted, the guest CSR values are still valid in
the hardware and do not need to be restored.

This patch is to skip the CSR write path when:
1. The VCPU was previously preempted
(vcpu->scheduled_out == 1).
2. It is being reloaded on the same physical CPU
(vcpu->arch.last_exit_cpu == cpu).
3. No other KVM VCPU has used this CPU in the meantime
(vcpu == __this_cpu_read(kvm_former_vcpu)).

This reduces many CSR writes with frequent preemption on the same CPU.

Signed-off-by: Jinyu Tang <tjytimi@163.com>
---
 arch/riscv/kvm/vcpu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index f001e5640..1c6c55ee1 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -25,6 +25,8 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
+static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_former_vcpu);
+
 const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
 	STATS_DESC_COUNTER(VCPU, ecall_exit_stat),
@@ -581,6 +583,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
 
+	if (vcpu->scheduled_out && vcpu == __this_cpu_read(kvm_former_vcpu) &&
+		vcpu->arch.last_exit_cpu == cpu)
+		goto csr_restore_done;
+
 	if (kvm_riscv_nacl_sync_csr_available()) {
 		nsh = nacl_shmem();
 		nacl_csr_write(nsh, CSR_VSSTATUS, csr->vsstatus);
@@ -624,6 +630,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_riscv_mmu_update_hgatp(vcpu);
 
+csr_restore_done:
 	kvm_riscv_vcpu_timer_restore(vcpu);
 
 	kvm_riscv_vcpu_host_fp_save(&vcpu->arch.host_context);
@@ -645,6 +652,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	void *nsh;
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 
+	__this_cpu_write(kvm_former_vcpu, vcpu);
+
 	vcpu->cpu = -1;
 
 	kvm_riscv_vcpu_aia_put(vcpu);
-- 
2.43.0


