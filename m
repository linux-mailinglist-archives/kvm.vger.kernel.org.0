Return-Path: <kvm+bounces-27010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7951197A737
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 20:19:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81F0A1C26899
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 18:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE72B16191E;
	Mon, 16 Sep 2024 18:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="rN1w5HsK";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="rN1w5HsK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AD215C144;
	Mon, 16 Sep 2024 18:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726510696; cv=none; b=SJGVewkw2glxYFG/mi3ha7jEskWaksXLRmHQJPQa2lb8FCtPJdOd3Tr10zv+D/wEtyW1h2vWPZdNV2bCFCjhg+cX1I1GPP/5k8SoaJkYH4EotllJb3Oj9baFYweOZCrb3kKLom7Y1SLNwRN/T3CuMcSWfoL3b3hmqK4aLmKqOpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726510696; c=relaxed/simple;
	bh=3Fw+K0hQmf1BM7ZUV56V8ZoBg80KB09mMA/nO1nJv50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awVXhUKOdvjnWiDRUsyOQ6LdXt9VvUph9TpMfKDQp9o2KUQL/a0L5Te9dbaVHU9svRW0a0XY4xA4xgBVP5D0rX1sZU46oxg9YOwfir05dYMZfH8zsBnMgnkj7Ho/lkt4bmx2/AAPQya/Em/O0eC7mgM47DKzKbdBzLtWqOwrDlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=rN1w5HsK; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=rN1w5HsK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E1D6221C29;
	Mon, 16 Sep 2024 18:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1726510690; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cmWFWeD/k+yoNDkLlzMQjwNocrg/PxJwLUSs9viTQhw=;
	b=rN1w5HsK48Bgtd/u6hO6M/taq110M6zoZAubwmeu0EzlpqMyrMXDfDc4q85DzVxZD9a8v0
	xKP3HgcyUlPy3ku4OoH2wvAdq793eVOAaD+HTX/rg4jFrU6oTXVijMLgtnbXhRfJpuaji0
	RXiGt/K5WRGurqytB2T00nc9A9aKNCs=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1726510690; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cmWFWeD/k+yoNDkLlzMQjwNocrg/PxJwLUSs9viTQhw=;
	b=rN1w5HsK48Bgtd/u6hO6M/taq110M6zoZAubwmeu0EzlpqMyrMXDfDc4q85DzVxZD9a8v0
	xKP3HgcyUlPy3ku4OoH2wvAdq793eVOAaD+HTX/rg4jFrU6oTXVijMLgtnbXhRfJpuaji0
	RXiGt/K5WRGurqytB2T00nc9A9aKNCs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4E71913A3A;
	Mon, 16 Sep 2024 18:18:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wPgSEWJ26GbveAAAD6G6ig
	(envelope-from <roy.hopkins@suse.com>); Mon, 16 Sep 2024 18:18:10 +0000
From: Roy Hopkins <roy.hopkins@suse.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev
Cc: Roy Hopkins <roy.hopkins@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Michael Roth <michael.roth@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [RFC PATCH 5/5] x86/kvm: Add target VMPL to IRQs and send to APIC for VMPL
Date: Mon, 16 Sep 2024 19:17:57 +0100
Message-ID: <67ffe577fe98f53068d68c053fa209e8d4b4bae9.1726506534.git.roy.hopkins@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1726506534.git.roy.hopkins@suse.com>
References: <cover.1726506534.git.roy.hopkins@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	R_RATELIMIT(0.00)[to_ip_from(RLh8t8sqpgocps1pdp1zxxqsw5)];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -6.80
X-Spam-Flag: NO

Systems that support VMPLs need to decide which VMPL each
IRQ is destined for; each VMPL can support its own set of hardware
devices that generate interrupts.

This commit extends kvm_lapic_irq to include a target_vmpl field the
sends the IRQ to the APIC instance at the target VMPL.

Signed-off-by: Roy Hopkins <roy.hopkins@suse.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/ioapic.c           | 3 +++
 arch/x86/kvm/irq_comm.c         | 1 +
 arch/x86/kvm/lapic.c            | 6 +++++-
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3dd3a5ff0cec..d0febb67dabf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1624,6 +1624,7 @@ struct kvm_lapic_irq {
 	u32 shorthand;
 	u32 dest_id;
 	bool msi_redir_hint;
+	unsigned int target_vmpl;
 };
 
 static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 995eb5054360..7b835a192561 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -413,6 +413,8 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 			irq.shorthand = APIC_DEST_NOSHORT;
 			irq.dest_id = e->fields.dest_id;
 			irq.msi_redir_hint = false;
+			irq.target_vmpl = ioapic->kvm->arch.default_irq_vmpl;
+
 			bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
 			kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
 						 vcpu_bitmap);
@@ -458,6 +460,7 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
 	irqe.level = 1;
 	irqe.shorthand = APIC_DEST_NOSHORT;
 	irqe.msi_redir_hint = false;
+	irqe.target_vmpl = ioapic->kvm->arch.default_irq_vmpl;
 
 	if (irqe.trig_mode == IOAPIC_EDGE_TRIG)
 		ioapic->irr_delivered |= 1 << irq;
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 8136695f7b96..6bd4a78dddba 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -119,6 +119,7 @@ void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
 	irq->msi_redir_hint = msg.arch_addr_lo.redirect_hint;
 	irq->level = 1;
 	irq->shorthand = APIC_DEST_NOSHORT;
+	irq->target_vmpl = kvm->arch.default_irq_vmpl;
 }
 EXPORT_SYMBOL_GPL(kvm_set_msi_irq);
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e2dd573e4f2d..20b433a78457 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -836,7 +836,9 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq,
 		     struct dest_map *dest_map)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *apic = vcpu->vcpu_parent->vcpu_vmpl[irq->target_vmpl]->arch.apic;
+	if (!apic)
+		return -EINVAL;
 
 	return __apic_accept_irq(apic, irq->delivery_mode, irq->vector,
 			irq->level, irq->trig_mode, dest_map);
@@ -1528,6 +1530,8 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 	irq.trig_mode = icr_low & APIC_INT_LEVELTRIG;
 	irq.shorthand = icr_low & APIC_SHORT_MASK;
 	irq.msi_redir_hint = false;
+	/* IPIs always target the same VMPL as the source */
+	irq.target_vmpl = apic->vcpu->vmpl;
 	if (apic_x2apic_mode(apic))
 		irq.dest_id = icr_high;
 	else
-- 
2.43.0


