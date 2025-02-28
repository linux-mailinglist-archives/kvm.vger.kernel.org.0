Return-Path: <kvm+bounces-39653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5985DA48E6B
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 03:16:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 095427A881A
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 02:14:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CAC613E41A;
	Fri, 28 Feb 2025 02:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="vuQWrJ/Z"
X-Original-To: kvm@vger.kernel.org
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A96C2EF;
	Fri, 28 Feb 2025 02:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740708919; cv=none; b=MWoFLK1AWzBcciMtf08OdTY9vqLNvflh6euUOXD534elLf+oVyBtC3b69S/xXr0c7d4eQK9qE8q4foOty5CnQYxrRMLg4Y+OyRSKl5+MMISwZuiODdYAsdBZAACHiK01RDFJtxO1hLuMXhCgHfwIhC7A3t63+8NUimzWB9YyJDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740708919; c=relaxed/simple;
	bh=rz8RdKkLlokbH4sKol1d/bV3rts1gn8LT5S3xrhiBUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNYXb51A/0+ALLwbmEx4IhVBk7s5xNcEPVfBhZpu85Td/ek/hTlV/g4SJvigMQsJu24k+sEPC3wvoIH2DODjeBBpA6rclD46vWUuQmtYuNv1aOWIyq8fwLQEcGzoN9lNJWzpzTO0kwR3zgX5vKjoviVrH1X6RbQuPBXgIeKO8Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=vuQWrJ/Z; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1740708907; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=gTFeOqq88phqpoT4WIY9JbYheL3v079KB0JY682X56M=;
	b=vuQWrJ/ZYB1cK/tMMDau+I2kO2Gty+NmskNwogH/SkuIGZq4IAbkvCGBdWKysQDzjYp25xmQpi3bKDOJiqeXWVXh6kc1S4t6GYTkgSUGTGFVPbFApEN6Vdkz6tM4Eju0KIcB7XXkoY8vGH3kqX8BWXDQr08OFc9edy50/Q6gvRQ=
Received: from localhost(mailfrom:zijie.wei@linux.alibaba.com fp:SMTPD_---0WQNrY87_1740708902 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 28 Feb 2025 10:15:06 +0800
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
Subject: [PATCH v3] KVM: x86: ioapic: Optimize EOI handling to reduce unnecessary VM exits
Date: Fri, 28 Feb 2025 10:15:00 +0800
Message-ID: <20250228021500.516834-1-zijie.wei@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241121065039.183716-1-zijie.wei@linux.alibaba.com>
References: <20241121065039.183716-1-zijie.wei@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Address performance issues caused by a vector being reused by a
non-IOAPIC source.

Commit 0fc5a36dd6b3
("KVM: x86: ioapic: Fix level-triggered EOI and IOAPIC reconfigure race")
addressed the issues related to EOI and IOAPIC reconfiguration races.
However, it has introduced some performance concerns:

Configuring IOAPIC interrupts while an interrupt request (IRQ) is
already in service can unintentionally trigger a VM exit for other
interrupts that normally do not require one, due to the settings of
`ioapic_handled_vectors`. If the IOAPIC is not reconfigured during
runtime, this issue persists, continuing to adversely affect
performance.

Simple Fix Proposal:
A straightforward solution is to record highest in-service IRQ that
is pending at the time of the last scan. Then, upon the next guest
exit, do a full KVM_REQ_SCAN_IOAPIC. This ensures that a re-scan of
the ioapic occurs only when the recorded vector is EOI'd, and
subsequently, the extra bit in the eoi_exit_bitmap are cleared,
avoiding unnecessary VM exits.

Co-developed-by: xuyun <xuyun_xy.xy@linux.alibaba.com>
Signed-off-by: xuyun <xuyun_xy.xy@linux.alibaba.com>
Signed-off-by: weizijie <zijie.wei@linux.alibaba.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/ioapic.c           | 10 ++++++++--
 arch/x86/kvm/irq_comm.c         |  9 +++++++--
 arch/x86/kvm/lapic.c            | 10 ++++++++++
 4 files changed, 26 insertions(+), 4 deletions(-)

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
index a009c94c26c2..5d62ea5f1503 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1466,6 +1466,16 @@ static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
 	if (!kvm_ioapic_handles_vector(apic, vector))
 		return;
 
+	/*
+	 * When there are instances where ioapic_handled_vectors is
+	 * set due to pending interrupts, clean up the record and do
+	 * a full KVM_REQ_SCAN_IOAPIC.
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


