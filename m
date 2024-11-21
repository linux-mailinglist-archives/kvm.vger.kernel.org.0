Return-Path: <kvm+bounces-32243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ED7B9D47F3
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 07:51:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C1BE2B21A48
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 06:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E4D51C8781;
	Thu, 21 Nov 2024 06:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BEyyYyoj"
X-Original-To: kvm@vger.kernel.org
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F02528687;
	Thu, 21 Nov 2024 06:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732171863; cv=none; b=jomaLaKjjl/B5Tk6xrSXc0g6bL7AtEc9a6c+pbuJPwtlKLYL72A9OjrdHJJLaXg1uIt+UbWud5X0AwJetl7M5x4d9Vdb2SA7sRUI2cAQ8XpOKzPZWgQdehRtuR2qCMJ1zNukK9cqQkJdbuBfYReJKwbgghd2X6+puJ8vT+zZ17A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732171863; c=relaxed/simple;
	bh=2zycfry1p+Gzk2DViygIpISiI3WqRpWC10KIpyYSflE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CywfqJRALGXqwPJm5Oo/JXF4IIDk3aGQ2+B0L+SfmeR8uTpD5ZeHD4dHjt7Gu0ci/oZfLuTnJJ7YwiA6XFmzurSLwu3zwaPmQ2ArkGMSvP6Z/3PprEeFGvI4C8uGMuK9Ma/X49hVEvVAOViFYs/8ynjP4UvRS6NlqLBSH93rw3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BEyyYyoj; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1732171856; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=z93QOYyeKE9vxi+z8TZmZScUKuAySnyShvsDNCiZM3o=;
	b=BEyyYyojOb62hDDmESdt3djZD7QW4G0gVUF85iG767INURE8fdDysXmftiUILZ62/TMB60AH1mlkH4wEhygwtn0jpTwnZza9/8klsW77fS53FftkZWKslf9xg4LhZWvd3/o4j9nK6bBhCuVY7P1ItYa/fyHweE4sToerbtHfspk=
Received: from localhost(mailfrom:zijie.wei@linux.alibaba.com fp:SMTPD_---0WJuyxey_1732171840 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 21 Nov 2024 14:50:56 +0800
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
Subject: [PATCH] KVM: x86: ioapic: Optimize EOI handling to reduce unnecessary VM exits
Date: Thu, 21 Nov 2024 14:50:39 +0800
Message-ID: <20241121065039.183716-1-zijie.wei@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
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
A straightforward solution is to record the vector that is pending at
the time of injection. Then, upon the next guest exit, clean up the
ioapic_handled_vectors corresponding to the vector number that was
pending. This ensures that interrupts are properly handled and prevents
performance issues.

Signed-off-by: weizijie <zijie.wei@linux.alibaba.com>
Signed-off-by: xuyun <xuyun_xy.xy@linux.alibaba.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/ioapic.c           | 11 +++++++++--
 arch/x86/kvm/vmx/vmx.c          | 10 ++++++++++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e159e44a6a1b..b008c933d2ab 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1041,6 +1041,7 @@ struct kvm_vcpu_arch {
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_root_tdp;
 #endif
+	DECLARE_BITMAP(ioapic_pending_vectors, 256);
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 995eb5054360..6f5a88dc63da 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -284,6 +284,8 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, ulong *ioapic_handled_vectors)
 
 	spin_lock(&ioapic->lock);
 
+	bitmap_zero(vcpu->arch.ioapic_pending_vectors, 256);
+
 	/* Make sure we see any missing RTC EOI */
 	if (test_bit(vcpu->vcpu_id, dest_map->map))
 		__set_bit(dest_map->vectors[vcpu->vcpu_id],
@@ -297,10 +299,15 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, ulong *ioapic_handled_vectors)
 			u16 dm = kvm_lapic_irq_dest_mode(!!e->fields.dest_mode);
 
 			if (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
-						e->fields.dest_id, dm) ||
-			    kvm_apic_pending_eoi(vcpu, e->fields.vector))
+						e->fields.dest_id, dm))
+				__set_bit(e->fields.vector,
+					  ioapic_handled_vectors);
+			else if (kvm_apic_pending_eoi(vcpu, e->fields.vector)) {
 				__set_bit(e->fields.vector,
 					  ioapic_handled_vectors);
+				__set_bit(e->fields.vector,
+					  vcpu->arch.ioapic_pending_vectors);
+			}
 		}
 	}
 	spin_unlock(&ioapic->lock);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0f008f5ef6f0..572e6f9b8602 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5710,6 +5710,16 @@ static int handle_apic_eoi_induced(struct kvm_vcpu *vcpu)
 
 	/* EOI-induced VM exit is trap-like and thus no need to adjust IP */
 	kvm_apic_set_eoi_accelerated(vcpu, vector);
+
+	/* When there are instances where ioapic_handled_vectors is
+	 * set due to pending interrupts, clean up the record and the
+	 * corresponding bit after the interrupt is completed.
+	 */
+	if (test_bit(vector, vcpu->arch.ioapic_pending_vectors)) {
+		clear_bit(vector, vcpu->arch.ioapic_pending_vectors);
+		clear_bit(vector, vcpu->arch.ioapic_handled_vectors);
+		kvm_make_request(KVM_REQ_LOAD_EOI_EXITMAP, vcpu);
+	}
 	return 1;
 }
 
-- 
2.43.5


