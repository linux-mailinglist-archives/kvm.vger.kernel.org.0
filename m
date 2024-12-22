Return-Path: <kvm+bounces-34289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C3299FA4EB
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 10:02:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98820166D43
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 09:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EDAF1862BD;
	Sun, 22 Dec 2024 09:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="vQKRRnVv"
X-Original-To: kvm@vger.kernel.org
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8EB282EE;
	Sun, 22 Dec 2024 09:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734858153; cv=none; b=ruI77XtycmlrwI1xb4+BF8BTLFbJiXm8XHCmN0VXAcKBkyFfvjE1yVM+RWeOSRPV13Ir+kJbVYx8WNObChu3D2qhhuLc02/geMpURM9R2oCX+W4gwKLl/P3DTzSbw+RKZXwsGgBHyDYcgdFFdSd+O9wOasr/zRdu/O3xczfWKDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734858153; c=relaxed/simple;
	bh=hkgSgCQezrdnKXa1OlD2QHKWrT+xmtCZqbVJhPYfwXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwXWusrl684XPnj69yNN8J6d45dKDgzyCnxsGp33iWnxtUkjriyL2MCgJvgYmvqRGFhOz5QN1RLo1IbKTyWkAGXMS0CfELhDFm2gTJCjYUecJDoaJJz/UedbchHvScFFoo2x0393mEamT28wwIuEBtle1GNlSApGUO7JUs56PCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=vQKRRnVv; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734858141; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=XXX8ceKMX7u6UK6f6ZZgkHr+6DS0sua3pynQYmMXBvM=;
	b=vQKRRnVv+CVzopkwIY8A4VDHlI4Oa0Va6UrcX5Pt9lxkUpStqf/j3EawjfleVYLbkpNVdt0GkxiaReXdOgEmMNeV3DgKg7uL/CnyRX12Oo25GSw7Fjh5rGphxB1VsMVqg6mZ4rQecocBafZ4lP3eEItD+3YEtGdsq+3KnMtTE4I=
Received: from localhost(mailfrom:zijie.wei@linux.alibaba.com fp:SMTPD_---0WLyLwxl_1734858136 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 22 Dec 2024 17:02:20 +0800
From: weizijie <zijie.wei@linux.alibaba.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hpa@zytor.com
Cc: weizijie <zijie.wei@linux.alibaba.com>,
	xuyun <xuyun_xy.xy@linux.alibaba.com>
Subject: [PATCH v2] KVM: x86: ioapic: Optimize EOI handling to reduce unnecessary VM exits
Date: Sun, 22 Dec 2024 17:01:48 +0800
Message-ID: <20241222090148.5363-1-zijie.wei@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <Z2IDkWPz2rhDLD0P@google.com>
References: <Z2IDkWPz2rhDLD0P@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Address performance issues caused by a vector being reused by a
non-IOAPIC source.

commit 0fc5a36dd6b3
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
A straightforward solution is to record a vector that is pending at
the time of the last scan. Then, upon the next guest exit, do a full
KVM_REQ_SCAN_IOAPIC. This ensures that a re-scan of the ioapic occurs
only when the recorded vector is EOI'd, and subsequently, the extra
bit in the eoi_exit_bitmap are cleared, avoiding unnecessary VM exits.

Co-developed-by: xuyun <xuyun_xy.xy@linux.alibaba.com>
Signed-off-by: xuyun <xuyun_xy.xy@linux.alibaba.com>
Signed-off-by: weizijie <zijie.wei@linux.alibaba.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/ioapic.c           | 8 ++++++--
 arch/x86/kvm/irq_comm.c         | 7 +++++--
 arch/x86/kvm/vmx/vmx.c          | 9 +++++++++
 4 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e159e44a6a1b..f84a4881afa4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1041,6 +1041,7 @@ struct kvm_vcpu_arch {
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_root_tdp;
 #endif
+	u8 last_pending_vector;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 995eb5054360..6b203f0847ec 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -297,10 +297,14 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, ulong *ioapic_handled_vectors)
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
+				vcpu->arch.last_pending_vector = e->fields.vector;
+			}
 		}
 	}
 	spin_unlock(&ioapic->lock);
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 8136695f7b96..ca45be1503f4 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -426,9 +426,12 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
 
 			if (irq.trig_mode &&
 			    (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
-						 irq.dest_id, irq.dest_mode) ||
-			     kvm_apic_pending_eoi(vcpu, irq.vector)))
+						 irq.dest_id, irq.dest_mode)))
 				__set_bit(irq.vector, ioapic_handled_vectors);
+			else if (kvm_apic_pending_eoi(vcpu, irq.vector)) {
+				__set_bit(irq.vector, ioapic_handled_vectors);
+				vcpu->arch.last_pending_vector = irq.vector;
+			}
 		}
 	}
 	srcu_read_unlock(&kvm->irq_srcu, idx);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0f008f5ef6f0..2abf67e76780 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5710,6 +5710,15 @@ static int handle_apic_eoi_induced(struct kvm_vcpu *vcpu)
 
 	/* EOI-induced VM exit is trap-like and thus no need to adjust IP */
 	kvm_apic_set_eoi_accelerated(vcpu, vector);
+
+	/* When there are instances where ioapic_handled_vectors is
+	 * set due to pending interrupts, clean up the record and do
+	 * a full KVM_REQ_SCAN_IOAPIC.
+	 */
+	if (vcpu->arch.last_pending_vector == vector) {
+		vcpu->arch.last_pending_vector = 0;
+		kvm_make_request(KVM_REQ_SCAN_IOAPIC, vcpu);
+	}
 	return 1;
 }
 
-- 
2.43.5


