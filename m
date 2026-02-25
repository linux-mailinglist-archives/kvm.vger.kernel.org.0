Return-Path: <kvm+bounces-71746-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YHSKD1hpnmmzVAQAu9opvQ
	(envelope-from <kvm+bounces-71746-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:15:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AB4A5191272
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:15:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4E591307A9D6
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D64F29D287;
	Wed, 25 Feb 2026 03:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="BkhKrpTt"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6971E98E3;
	Wed, 25 Feb 2026 03:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771989328; cv=none; b=oVTHd1i7OIV0WnhXatMOHf3K7ABrQcySUWBFbI/grpVlH/5K9qPmzFzN6X7ZFDG+HUC06i66zyGCCK1IB//rBhjfbk+6jMXx/nm/MqW4jXf+tLDYWIDOShr03yrBgg6dNXVln1NYzchL8ziIBQREuj2M7h65KaKGPcpZC2lr7L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771989328; c=relaxed/simple;
	bh=YS8CVRAR/wuGQmUD9GT+TYsm5SI7xDV/gue/3uFNhyM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VwGSxA3TTvbMVMzFFvyjGOz9kD7zoXqMwRAe07aKSNF3RjJ8PDAIMJuMrQXbE4AsAevfMOFqOgsIX0bIiehr0v2nQnYrLZx98Syz8dbJkqG38op2q+DYD7p6vNUAco5FEtcxpClBBqaxmz88tunH7DpvpklzR+qBCY1EcNy4tao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=BkhKrpTt; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Rh
	WDxjhmHsYf04KJ7B2Su/Ud3Vk3NEr58LAY8SzPANU=; b=BkhKrpTta8Omc+wcfD
	jryxzC/AjgLzxlPDYCShwMxMHY/ZYPchz3NaMriQ0WsvzcxWaijWqbqTPk16hIxg
	ZUamHNhb3nR58BH8PZLEGJaN11a+J5h1VMt3jgTpPzvbM5fKhcBapiw+Nau83U4k
	9447b4flkk5AH2XKUmmcyQMXo=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD3v5z9aJ5pQV4DMg--.27870S2;
	Wed, 25 Feb 2026 11:14:06 +0800 (CST)
From: Jinyu Tang <tjytimi@163.com>
To: Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Nutty Liu <nutty.liu@hotmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>
Cc: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Jinyu Tang <tjytimi@163.com>
Subject: [PATCH v5] KVM: riscv: Skip CSR restore if VCPU is reloaded on the same core
Date: Wed, 25 Feb 2026 11:14:02 +0800
Message-ID: <20260225031402.841618-1-tjytimi@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3v5z9aJ5pQV4DMg--.27870S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3WrWxurWxXr4xXr4xCw1UGFg_yoW7WFW5pF
	ZrCrn5Ww48Gr1fG347Xr4v9r4Fg39Ygw13G34UX3yayr45try5AFs5KFyUAFZ8GrW8ZFyS
	yF1DtFy0kFn8ZaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pR58nOUUUUU=
X-CM-SenderInfo: xwm13xlpl6il2tof0z/xtbC8h5b02meaP4MAAAA3J
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[163.com,none];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[brainfault.org,linux.dev,oss.qualcomm.com,microchip.com,sifive.com,hotmail.com,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[163.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	TAGGED_FROM(0.00)[bounces-71746-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[163.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tjytimi@163.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,163.com];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AB4A5191272
X-Rspamd-Action: no action

Currently, kvm_arch_vcpu_load() unconditionally restores guest CSRs and
HGATP. However, when a VCPU is loaded back on the same physical CPU, 
and no other KVM VCPU has run on this CPU since it was last put,
the hardware CSRs are still valid.

This patch optimizes the vcpu_load path by skipping the expensive CSR
writes if all the following conditions are met:
1. It is being reloaded on the same CPU (vcpu->arch.last_exit_cpu == cpu).
2. No other VCPU used this CPU (vcpu == __this_cpu_read(kvm_former_vcpu)).
3. The CSRs are not dirty (!vcpu->arch.csr_dirty).

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
 v4 -> v5:
 - Dropped the 'vcpu->scheduled_out' check as Andrew Jones pointed out,
   relying on 'last_exit_cpu', 'former_vcpu', and '!csr_dirty'
   is sufficient and safe. This expands the optimization to cover many
   userspace exits (e.g., MMIO) as well.
 - Added a block comment in kvm_arch_vcpu_load() to warn future
   developers about maintaining the 'csr_dirty' dependency, as Andrew's
   suggestion to reduce fragility.
 - Removed unnecessary single-line comments and fixed indentation nits.

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
 arch/riscv/kvm/vcpu.c             | 21 +++++++++++++++++++++
 arch/riscv/kvm/vcpu_onereg.c      |  2 ++
 3 files changed, 26 insertions(+)

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
index a55a95da5..578f8693a 100644
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
@@ -537,6 +539,8 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 		vcpu->arch.cfg.hedeleg |= BIT(EXC_BREAKPOINT);
 	}
 
+	vcpu->arch.csr_dirty = true;
+
 	return 0;
 }
 
@@ -581,6 +585,20 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
 
+	/*
+	 * If VCPU is being reloaded on the same physical CPU and no
+	 * other KVM VCPU has run on this CPU since it was last put,
+	 * we can skip the expensive CSR and HGATP writes.
+	 *
+	 * Note: If a new CSR is added to this fast-path skip block,
+	 * make sure that 'csr_dirty' is set to true in any
+	 * ioctl (e.g., KVM_SET_ONE_REG) that modifies it.
+	 */
+	if (vcpu == __this_cpu_read(kvm_former_vcpu) &&
+	    vcpu->arch.last_exit_cpu == cpu && !vcpu->arch.csr_dirty)
+		goto csr_restore_done;
+
+	vcpu->arch.csr_dirty = false;
 	if (kvm_riscv_nacl_sync_csr_available()) {
 		nsh = nacl_shmem();
 		nacl_csr_write(nsh, CSR_VSSTATUS, csr->vsstatus);
@@ -624,6 +642,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_riscv_mmu_update_hgatp(vcpu);
 
+csr_restore_done:
 	kvm_riscv_vcpu_timer_restore(vcpu);
 
 	kvm_riscv_vcpu_host_fp_save(&vcpu->arch.host_context);
@@ -645,6 +664,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	void *nsh;
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 
+	__this_cpu_write(kvm_former_vcpu, vcpu);
+
 	vcpu->cpu = -1;
 
 	kvm_riscv_vcpu_aia_put(vcpu);
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index e7ab6cb00..fc08bf833 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -652,6 +652,8 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
 	if (rc)
 		return rc;
 
+	vcpu->arch.csr_dirty = true;
+
 	return 0;
 }
 
-- 
2.43.0


