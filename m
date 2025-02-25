Return-Path: <kvm+bounces-39092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95DD1A4359C
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 07:46:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD313189474A
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 06:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21399257443;
	Tue, 25 Feb 2025 06:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="nlETZ7mc"
X-Original-To: kvm@vger.kernel.org
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF4A254855;
	Tue, 25 Feb 2025 06:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740465831; cv=none; b=E3EX5cKm94sH68ofu4uzwLpiC6ZZE7Zv+sC/4KfbyPDeuQKTV7svmytFdw0/i4Cc3ok5BdB5tzs4sLkrDVw7xm2wQWXulS2wCDX4BHGXxGoLURIRsclybMt5B755vGVFl/W1mOB66ygK58Oke+e95CnfZkPWy6h9P4iDwRlhcXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740465831; c=relaxed/simple;
	bh=PXabjfpfBOXq8tRWvKo6GYiCmy3eNq/J97iav18nkas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpkkj+wh8A1tPFD6vODXq0yjvTVWAPzSyGqlTn7im/Ua3Rl3AE7FN+52Mp80uO8CdlZJGsQ5pFk0tJccS3hH6dtqN2UUqju3uq0LUzwGApn7jUCv/P3Zk7DP6xPaToWIoD5Nmvcsx+bQPjBG9FMQnOLvTm5HFelbUCGHB/nNvpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=nlETZ7mc; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1740465824; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=dtWtcCos5TZoKRFTrhJZTu555UIWcx8R/sCLOdoDYxc=;
	b=nlETZ7mcJkSYR9/YamcGFR+t/ZbRp1eocv7vl7CFkHLhk4sLxN4PGVliUQ7SLWBP3WlHB2/Crxn+i0jZLkg176SIN3tagFuMDjthcHk9nvbFm45Dk/ODeBZCtHlyOxOm+Z1g39DFCwK52OoJ9XqmwFAjdMVqtez8AQKWGXWvitA=
Received: from localhost(mailfrom:zijie.wei@linux.alibaba.com fp:SMTPD_---0WQDdazp_1740465817 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 25 Feb 2025 14:43:43 +0800
From: weizijie <zijie.wei@linux.alibaba.com>
To: Sean Christopherson <seanjc@google.com>,
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
Subject: [PATCH Resend] KVM: x86: ioapic: Optimize EOI handling to reduce unnecessary VM exits
Date: Tue, 25 Feb 2025 14:42:53 +0800
Message-ID: <20250225064253.309334-1-zijie.wei@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <Z6uo24Wf3LoetUMc@google.com>
References: <Z6uo24Wf3LoetUMc@google.com>
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
 arch/x86/kvm/vmx/vmx.c          |  9 +++++++++
 4 files changed, 25 insertions(+), 4 deletions(-)

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
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6c56d5235f0f..047cdd5964e5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5712,6 +5712,15 @@ static int handle_apic_eoi_induced(struct kvm_vcpu *vcpu)
 
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


