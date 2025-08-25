Return-Path: <kvm+bounces-55611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3698EB33F1F
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 14:16:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F1C01A8247E
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 12:16:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A925519006B;
	Mon, 25 Aug 2025 12:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="oesLLvfI"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03A931EA80;
	Mon, 25 Aug 2025 12:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756124145; cv=none; b=pXPtTlxQWKEMF+PIwQyDL7jo58IcwJo4sI+gSk7ZrLWYpvplkqLXqtJuAichOnOiQjQ+0MTiNNsXrWCQLPHqaLwpsJLujgyJlbJCurjRW9U5PN7u/tWPPeKEVw2iLqEuzjc93DnxISQNWco8Jy9q4up6SsWIMPy+FOllFV8mYmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756124145; c=relaxed/simple;
	bh=pQRUIrRaJ4WHpO9221p/eCIx31S0mIW0eHDvL9xlmjw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A73sK8LA5NYFuiI5nKoU5lVJUw8Yu11Xa9MCyrCu+kDVKPvqEukKRoj1EB7e8/cZe7Tbgcs8bNhWOIcNbvnda6IasxJXoWRPv5pjAxgV1E+uav1Id85TeR2C+jYPlWf28DiouA1Z6WdkFI6+s3hf/hQRk3U8TdrArj79ugzaHgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=oesLLvfI; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=wm
	j5n76lJI+EQ4fSCNHd5tg/1m0AUVHlQPLj3ohhhUY=; b=oesLLvfIRErVrkDogt
	a1OiIZOZxwCxnyD4vqmBrnVVnRE80lSQFCaARmR+gtW5WcBIqVPm0z8/9JginPJi
	BJSCAAwBOWQ0Aaaza4t++VbR9D/xdZ4ULSDfoDFvbUDgzCkA4qdjYYMSMerFg3Sb
	bq23otVjkEWrLMTDxEZQrHoFc=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wCn0LeWU6xoYo0IEQ--.6105S2;
	Mon, 25 Aug 2025 20:14:15 +0800 (CST)
From: Jinyu Tang <tjytimi@163.com>
To: Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Andrew Jones <ajones@ventanamicro.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Nutty Liu <nutty.liu@hotmail.com>
Cc: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Jinyu Tang <tjytimi@163.com>
Subject: [PATCH v3] riscv: skip csr restore if vcpu preempted reload
Date: Mon, 25 Aug 2025 20:14:11 +0800
Message-ID: <20250825121411.86573-1-tjytimi@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCn0LeWU6xoYo0IEQ--.6105S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxuryrZw13Kr13uF15tw47Jwb_yoW5Ww48pF
	W7urs09w48JrW7G342qrsY9F4F9rZYgrn3XryDWrWSyr1Utr9Yyr4kK3y7AFy5GryrZF1S
	yFyDtFyIkFnYvwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piHa0PUUUUU=
X-CM-SenderInfo: xwm13xlpl6il2tof0z/1tbipR+0eGisTjSwYwAAsb

The kvm_arch_vcpu_load() function is called in two cases for riscv:
1. When entering KVM_RUN from userspace ioctl.
2. When a preempted VCPU is scheduled back.

In the second case, if no other KVM VCPU has run on this CPU since the
current VCPU was preempted, the guest CSR (including AIA CSRS and HGTAP) 
values are still valid in the hardware and do not need to be restored.

This patch is to skip the CSR write path when:
1. The VCPU was previously preempted
(vcpu->scheduled_out == 1).
2. It is being reloaded on the same physical CPU
(vcpu->arch.last_exit_cpu == cpu).
3. No other KVM VCPU has used this CPU in the meantime
(vcpu == __this_cpu_read(kvm_former_vcpu)).

This reduces many CSR writes with frequent preemption on the same CPU.

Signed-off-by: Jinyu Tang <tjytimi@163.com>
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
---
 v2 -> v3:
 v2 was missing a critical check because I generated the patch from my
 wrong (experimental) branch. This is fixed in v3. Sorry for my trouble.

 v1 -> v2:
 Apply the logic to aia csr load. Thanks for
 Andrew Jones's advice.

 arch/riscv/kvm/vcpu.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index f001e5640..66bd3ddd5 100644
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
@@ -624,6 +630,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_riscv_mmu_update_hgatp(vcpu);
 
+	kvm_riscv_vcpu_aia_load(vcpu, cpu);
+
+csr_restore_done:
 	kvm_riscv_vcpu_timer_restore(vcpu);
 
 	kvm_riscv_vcpu_host_fp_save(&vcpu->arch.host_context);
@@ -633,8 +642,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_riscv_vcpu_guest_vector_restore(&vcpu->arch.guest_context,
 					    vcpu->arch.isa);
 
-	kvm_riscv_vcpu_aia_load(vcpu, cpu);
-
 	kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
 
 	vcpu->cpu = cpu;
@@ -645,6 +652,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	void *nsh;
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 
+	__this_cpu_write(kvm_former_vcpu, vcpu);
+
 	vcpu->cpu = -1;
 
 	kvm_riscv_vcpu_aia_put(vcpu);
-- 
2.43.0


