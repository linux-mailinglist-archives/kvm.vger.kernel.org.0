Return-Path: <kvm+bounces-71445-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 1KrVLjONmmnIcQMAu9opvQ
	(envelope-from <kvm+bounces-71445-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 22 Feb 2026 05:59:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 19DC616E7D1
	for <lists+kvm@lfdr.de>; Sun, 22 Feb 2026 05:59:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B93E13012CE9
	for <lists+kvm@lfdr.de>; Sun, 22 Feb 2026 04:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEBD619C540;
	Sun, 22 Feb 2026 04:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="QfOrsMxr"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA8F6A001;
	Sun, 22 Feb 2026 04:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771736366; cv=none; b=jDzRxE/tYlE7qMvkcs1MOuwAwlUkNnWfEc6sW240dTUsSKtSLtTW3XUBzZ8r28vTQ40Z2V2QXTDccvSBjlHnFqRWfEKU1woNvY+DnbeaxH0/v0b4RWBbfqSyMAp4zqXLDCsZdJOC7Hoe9cNjmFmMOloOWQ/ZCdSO72vyJnss9fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771736366; c=relaxed/simple;
	bh=hL0XYkksi1/6Q7WiFcGLRlc6WDMPHoBemAD8+1XuEQs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dl12iBOUZ5wc0Dxl9pTgBibmqMk+DPQKv29VHpQP1poH0+a7nJivCjCvDoxv0fwcrGPHiNFSdP1dIhkLiufvWU6R64dL1j+XcHKXwAlUw8ZwRMnOkfItVBJG4+hhDpRI7xQ4TUZ0CteoFznRQftqOpyk7YgG6wH1bOnLoOReYXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=QfOrsMxr; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=V4
	D22IhydwIrtHinjeBvBPepXWOWYmBE/Ufcmj1uLY8=; b=QfOrsMxr6EYsKqPEYN
	88oFDNvUEQxopdllt0Plau4zWl9ZEjtxwZCUukwEeBcxZtxZX8s7sX13bjQq6jeV
	l3RKkFy7bqY9gm1RmTSYFOfVYX6FSX//GrlEeRzfTA2DhJE0dN12DCUVvMxIh0Hm
	rptn3vblFO4TN+rAxChNLqYS4=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wC3WqLHjJpp_NHdMA--.21662S2;
	Sun, 22 Feb 2026 12:57:44 +0800 (CST)
From: Jinyu Tang <tjytimi@163.com>
To: anup@brainfault.org
Cc: atish.patra@linux.dev,
	ajones@ventanamicro.com,
	conor.dooley@microchip.com,
	yongxuan.wang@sifive.com,
	nutty.liu@hotmail.com,
	paul.walmsley@sifive.com,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Jinyu Tang <tjytimi@163.com>
Subject: [PATCH v4] KVM: riscv: Skip CSR restore if VCPU is reloaded on the same core
Date: Sun, 22 Feb 2026 12:57:41 +0800
Message-ID: <20260222045741.260325-1-tjytimi@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3WqLHjJpp_NHdMA--.21662S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAFy5tw1xXrWDtr17ZF47Jwb_yoWrtrW5pF
	W7Crs5Ww48Gr15G347Xr4v9r4FgrZYgw1fX34UW3ySyr4Utry5AFs5KrWUAFZ8GrW8ZFyI
	yF1DKF109Fn0vw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pR58nOUUUUU=
X-CM-SenderInfo: xwm13xlpl6il2tof0z/xtbC8glWzmmajMmgyAAA39
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[163.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71445-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[163.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	FREEMAIL_CC(0.00)[linux.dev,ventanamicro.com,microchip.com,sifive.com,hotmail.com,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,vger.kernel.org,lists.infradead.org,163.com];
	DKIM_TRACE(0.00)[163.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tjytimi@163.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 19DC616E7D1
X-Rspamd-Action: no action

Currently, kvm_arch_vcpu_load() unconditionally restores guest CSRs and
HGATP. However, when a preempted VCPU is scheduled back on the same
physical CPU, and no other KVM VCPU has run on this CPU in the meantime,
the hardware CSRs are still valid.

This patch optimizes the vcpu_load path by skipping the expensive CSR
writes if all the following conditions are met:
1. The VCPU was previously preempted (vcpu->scheduled_out == 1).
2. It is being reloaded on the same CPU (vcpu->arch.last_exit_cpu == cpu).
3. No other VCPU used this CPU (vcpu == __this_cpu_read(kvm_former_vcpu)).
4. The CSRs are not dirty (!vcpu->arch.csr_dirty).

To ensure this fast-path doesn't break corner cases:
- Live migration and VCPU reset are naturally safe. KVM initializes
  last_exit_cpu to -1, which guarantees the fast-path won't trigger.
- A new 'csr_dirty' flag is introduced to track runtime userspace
  interventions. If userspace modifies guest configurations (e.g.,
  hedeleg via KVM_SET_GUEST_DEBUG, or CSRs via KVM_SET_ONE_REG) while
  the VCPU is preempted, the flag is set to skip fast path.

Note that kvm_riscv_vcpu_aia_load() is kept outside the skip logic
to ensure IMSIC/AIA interrupt states are always properly
synchronized.

Signed-off-by: Jinyu Tang <tjytimi@163.com>
---
 v3 -> v4:
 - Addressed Anup Patel's review regarding hardware state inconsistency.
 - Introduced 'csr_dirty' flag to track dynamic userspace CSR/CONFIG
   modifications (KVM_SET_ONE_REG, KVM_SET_GUEST_DEBUG), forcing a full
   restore when debugging or modifying states at userspace.
 - Kept kvm_riscv_vcpu_aia_load() out of the skip block to resolve IMSIC
   VS-file instability.

 v2 -> v3:
 v2 was missing a critical check because I generated the patch from my
 wrong (experimental) branch. This is fixed in v3. Sorry for my trouble.

 v1 -> v2:
 Apply the logic to aia csr load. Thanks for Andrew Jones's advice.
---
 arch/riscv/include/asm/kvm_host.h |  3 +++
 arch/riscv/kvm/vcpu.c             | 13 +++++++++++++
 arch/riscv/kvm/vcpu_onereg.c      |  3 +++
 3 files changed, 19 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 24585304c..7ee47b83c 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -273,6 +273,9 @@ struct kvm_vcpu_arch {
 	/* 'static' configurations which are set only once */
 	struct kvm_vcpu_config cfg;
 
+	/* Indicates modified guest CSRs */
+	bool csr_dirty;
+
 	/* SBI steal-time accounting */
 	struct {
 		gpa_t shmem;
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index a55a95da5..f7f58f02c 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -24,6 +24,8 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
+static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_former_vcpu);
+
 const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
 	STATS_DESC_COUNTER(VCPU, ecall_exit_stat),
@@ -537,6 +539,9 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 		vcpu->arch.cfg.hedeleg |= BIT(EXC_BREAKPOINT);
 	}
 
+	/* Mark CSRs dirty on hedeleg update */
+	vcpu->arch.csr_dirty = true;
+
 	return 0;
 }
 
@@ -581,6 +586,11 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
 
+	if (vcpu->scheduled_out && vcpu == __this_cpu_read(kvm_former_vcpu) &&
+		vcpu->arch.last_exit_cpu == cpu && !vcpu->arch.csr_dirty)
+		goto csr_restore_done;
+
+	vcpu->arch.csr_dirty = false;
 	if (kvm_riscv_nacl_sync_csr_available()) {
 		nsh = nacl_shmem();
 		nacl_csr_write(nsh, CSR_VSSTATUS, csr->vsstatus);
@@ -624,6 +634,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_riscv_mmu_update_hgatp(vcpu);
 
+csr_restore_done:
 	kvm_riscv_vcpu_timer_restore(vcpu);
 
 	kvm_riscv_vcpu_host_fp_save(&vcpu->arch.host_context);
@@ -645,6 +656,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	void *nsh;
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 
+	__this_cpu_write(kvm_former_vcpu, vcpu);
+
 	vcpu->cpu = -1;
 
 	kvm_riscv_vcpu_aia_put(vcpu);
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index e7ab6cb00..88cfcb018 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -652,6 +652,9 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
 	if (rc)
 		return rc;
 
+	/* Mark CSRs dirty after userspace update csr */
+	vcpu->arch.csr_dirty = true;
+
 	return 0;
 }
 
-- 
2.43.0


