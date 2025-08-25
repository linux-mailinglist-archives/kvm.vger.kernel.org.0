Return-Path: <kvm+bounces-55608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 50B24B33DB4
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 13:08:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 468414880CA
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 11:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17B1C2E1EFE;
	Mon, 25 Aug 2025 11:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ks3qlL2t"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B6CD2E11D5;
	Mon, 25 Aug 2025 11:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756120076; cv=none; b=FljJR8FC2ubl8OHxIjDP+14u3DLv7fSjGp/RpMSqjP3BjfFsEwc8DfwTc/tQ8fFK7RDlXesbEaLwZKqVEUcKwF9FlkPDjtgSEI9CK3czw72Vho8knLOmgXReTb4gq+7g4GiliTmRreH2mn6sP76XkUFtD5N/598eoOriotVR4WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756120076; c=relaxed/simple;
	bh=pM8DzgYrBRzUbkrosASwQDrdBVtFf9vfYS3uZKWs+EE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UAPFJr6CN5nKbE4DgdHZCIJPc+ixjhzr2fSyw9PsK1SyfvhacJ9rnxwL/G+nIfk3xudheUIyuqWNvW8hXDp5zLsill0dGzf8CtN37sOvUyW7c+Z4igaTi4QrgCQLIrhQq3nosF2iODaTxIGgOw4kOsIFoV6n2ufmIUj7iGy5198=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ks3qlL2t; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=ra
	1qbqEFFNjSwWkGuHdfZovIKLecMWGrPekXeDxHRTk=; b=ks3qlL2t/nH+gzv8ep
	pyYjwPp79UdBvON49coCpwp+plmfK+If6M9fjuSwJwmhSxXynNkOJPG1o39RIHLY
	Gqzz1UShddVV0q0G5VwrLO6IrTfUHrlRS7VWpMy4v7yCAiyVHMsaJHogHH8z+sAe
	lWByRki3SDMo4CJHZxw6qhV2M=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wDnTZHfQ6xo1XCAEQ--.44581S2;
	Mon, 25 Aug 2025 19:07:12 +0800 (CST)
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
Subject: [PATCH v2] riscv: skip csr restore if vcpu preempted reload
Date: Mon, 25 Aug 2025 19:07:08 +0800
Message-ID: <20250825110708.75474-1-tjytimi@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnTZHfQ6xo1XCAEQ--.44581S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxuryrZw13Kr13uF15tw47Jwb_yoW5XrWDpF
	W7uF4Y9w48ArW7G3y2qrsY9Fs09rZYgrn3XryDWrWSyr1Utr9Yyr4kKa47JFy5GFyrZF1S
	yFyDJFyxC3ZYvwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piJUUUUUUUU=
X-CM-SenderInfo: xwm13xlpl6il2tof0z/1tbiZR60eGisO77aMgAAse

The kvm_arch_vcpu_load() function is called in two cases for riscv:
1. When entering KVM_RUN from userspace ioctl.
2. When a preempted VCPU is scheduled back.

In the second case, if no other KVM VCPU has run on this CPU since the
current VCPU was preempted, the guest CSR (including AIA CSRS) values 
are still valid in the hardware and do not need to be restored.

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
 v1 -> v2:
 Apply the logic to aia csr load. Thanks for
 Andrew Jones's advice.

 arch/riscv/kvm/vcpu.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index f001e5640..e50d1f76c 100644
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
 
+	if  (vcpu == __this_cpu_read(kvm_former_vcpu) &&
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


