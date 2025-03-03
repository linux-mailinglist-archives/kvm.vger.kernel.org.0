Return-Path: <kvm+bounces-39857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A1BBEA4B78B
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 06:28:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E685188F522
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 05:28:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C2FF1DEFDD;
	Mon,  3 Mar 2025 05:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="DUbqN4f8"
X-Original-To: kvm@vger.kernel.org
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C6323F383;
	Mon,  3 Mar 2025 05:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740979691; cv=none; b=RWzSFpvhkNcPSwWyGkM7Wsfew+WBg4afR8FCwdFm+yCmGFoz772dTSVVaWstULIMYSXV03NJHd33MxTHOio55GCVCgG9DAaoB5ydFGFb7EL/tnh9zgme9t5LlezDBmIEnQcs9bAuPv0acmFbRKSSUgpfL1WiAbunM3YUoutbEJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740979691; c=relaxed/simple;
	bh=3SGXOIf3Drc5jxLCFLqX3ju8XNaEf0lpwJGlHy9oFgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E9DlfW/a7U7ybD8sO/dCp4ExS6AUXxcKZpHaMu1PSM8X8DPPpsWtlUEVD5kqhA17GKZEVUMUJ/KmEmQbHemd2/TbqaiPsi/5ZvhtmArMQ7Tte5upwKnff5SE0IXDDe4qyPSNrtd6xJzYafn94lF7NXbqFn3Z2lasvMAtGtaMsGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=DUbqN4f8; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1740979684; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=wKW2qNL0GYKBXb+KdJ8WKvFoPhdHKIW6tOAlWFUGX9g=;
	b=DUbqN4f8Y8WV5NeA3MjCaZmo2kp7pIerNdnusjIcBT/j3rNumnAU6ADbZqsfkw+8RUx/peru/lubr/zgIlttebwhhVJc4IAxcwwZM7nphW8US3+TrnjU3hCSWg4hC/tI+cgeBikqsfWeEpSeZs/NUlG6VGC1ovcxCtXdy6e0DP0=
Received: from localhost(mailfrom:zijie.wei@linux.alibaba.com fp:SMTPD_---0WQYk3HY_1740979359 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 03 Mar 2025 13:22:43 +0800
From: weizijie <zijie.wei@linux.alibaba.com>
To: Sean Christopherson <seanjc@google.com>,
	kai.huang@intel.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: weizijie <zijie.wei@linux.alibaba.com>,
	xuyun <xuyun_xy.xy@linux.alibaba.com>
Subject: [PATCH v4] KVM: x86: ioapic: Optimize EOI handling to reduce unnecessary VM exits
Date: Mon,  3 Mar 2025 13:22:25 +0800
Message-ID: <20250303052227.523411-1-zijie.wei@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241121065039.183716-1-zijie.wei@linux.alibaba.com>
References: <20241121065039.183716-1-zijie.wei@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Configuring IOAPIC routed interrupts triggers KVM to rescan all vCPU's
ioapic_handled_vectors which is used to control which vectors need to
trigger EOI-induced VMEXITs. If any interrupt is already in service on
some vCPU using some vector when the IOAPIC is being rescanned, the
vector is set to vCPU's ioapic_handled_vectors. If the vector is then
reused by other interrupts, each of them will cause a VMEXIT even it is
unnecessary. W/o further IOAPIC rescan, the vector remains set, and this
issue persists, impacting guest's interrupt performance.

Both

  commit db2bdcbbbd32 ("KVM: x86: fix edge EOI and IOAPIC reconfig race")

and

  commit 0fc5a36dd6b3 ("KVM: x86: ioapic: Fix level-triggered EOI and
IOAPIC reconfigure race")

mentioned this issue, but it was considered as "rare" thus was not
addressed. However in real environment this issue can actually happen
in a well-behaved guest.

Simple Fix Proposal:
A straightforward solution is to record highest in-service IRQ that
is pending at the time of the last scan. Then, upon the next guest
exit, do a full KVM_REQ_SCAN_IOAPIC. This ensures that a re-scan of
the ioapic occurs only when the recorded vector is EOI'd, and
subsequently, the extra bits in the eoi_exit_bitmap are cleared,
avoiding unnecessary VM exits.

Co-developed-by: xuyun <xuyun_xy.xy@linux.alibaba.com>
Signed-off-by: xuyun <xuyun_xy.xy@linux.alibaba.com>
Signed-off-by: weizijie <zijie.wei@linux.alibaba.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/ioapic.c           | 10 ++++++++--
 arch/x86/kvm/irq_comm.c         |  9 +++++++--
 arch/x86/kvm/lapic.c            | 13 +++++++++++++
 4 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0b7af5902ff7..8c50e7b4a96f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1062,6 +1062,7 @@ struct kvm_vcpu_arch {
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_root_tdp;
 #endif
+	u8 last_pending_vector;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 995eb5054360..40252a800897 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -297,10 +297,16 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, ulong *ioapic_handled_vectors)
 			u16 dm = kvm_lapic_irq_dest_mode(!!e->fields.dest_mode);
 
 			if (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
-						e->fields.dest_id, dm) ||
-			    kvm_apic_pending_eoi(vcpu, e->fields.vector))
+						e->fields.dest_id, dm))
 				__set_bit(e->fields.vector,
 					  ioapic_handled_vectors);
+			else if (kvm_apic_pending_eoi(vcpu, e->fields.vector)) {
+				__set_bit(e->fields.vector,
+					  ioapic_handled_vectors);
+				vcpu->arch.last_pending_vector = e->fields.vector >
+					vcpu->arch.last_pending_vector ? e->fields.vector :
+					vcpu->arch.last_pending_vector;
+			}
 		}
 	}
 	spin_unlock(&ioapic->lock);
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 8136695f7b96..1d23c52576e1 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -426,9 +426,14 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
 
 			if (irq.trig_mode &&
 			    (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
-						 irq.dest_id, irq.dest_mode) ||
-			     kvm_apic_pending_eoi(vcpu, irq.vector)))
+						 irq.dest_id, irq.dest_mode)))
 				__set_bit(irq.vector, ioapic_handled_vectors);
+			else if (kvm_apic_pending_eoi(vcpu, irq.vector)) {
+				__set_bit(irq.vector, ioapic_handled_vectors);
+				vcpu->arch.last_pending_vector = irq.vector >
+					vcpu->arch.last_pending_vector ? irq.vector :
+					vcpu->arch.last_pending_vector;
+			}
 		}
 	}
 	srcu_read_unlock(&kvm->irq_srcu, idx);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a009c94c26c2..7c540a0eb340 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1466,6 +1466,19 @@ static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
 	if (!kvm_ioapic_handles_vector(apic, vector))
 		return;
 
+	/*
+	 * When there are instances where ioapic_handled_vectors is
+	 * set due to pending interrupts, clean up the record and do
+	 * a full KVM_REQ_SCAN_IOAPIC.
+	 * This ensures the vector is cleared in the vCPU's ioapic_handled_vectors,
+	 * if the vector is reused by non-IOAPIC interrupts, avoiding unnecessary
+	 * EOI-induced VMEXITs for that vector.
+	 */
+	if (apic->vcpu->arch.last_pending_vector == vector) {
+		apic->vcpu->arch.last_pending_vector = 0;
+		kvm_make_request(KVM_REQ_SCAN_IOAPIC, apic->vcpu);
+	}
+
 	/* Request a KVM exit to inform the userspace IOAPIC. */
 	if (irqchip_split(apic->vcpu->kvm)) {
 		apic->vcpu->arch.pending_ioapic_eoi = vector;
-- 
2.43.5


