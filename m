Return-Path: <kvm+bounces-39952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD5B3A4D10F
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 02:36:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91A923AF5AE
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 01:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F382C1F03D2;
	Tue,  4 Mar 2025 01:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lMQ36Qrt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A765C7603F
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 01:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741052026; cv=none; b=TfewIzU7vuyArRHqnP8jXbA3NlcWr2ckZAfgeFaCyltj2D3a8Gyzst5FanJnM9RLb6R/2YAKOXPpm5fA+19hiJpvbIpGVlY+L+vkBsZ012Lk2jmhk8DIfBXeg2GfNSNOY3+tbRbcROQiDZ4gOe+zxAICtix3k4o+t9r57BuYIQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741052026; c=relaxed/simple;
	bh=3bM8LluU4Z3E3P/OumEsl2hMh8xJPdKkueEVx9wyqcI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZFCsWh1MfUaX3WbAqCezOI631OoZ1xiX15YKnFOhhgZz7h7oARdM03RWmBcM2DZSzNisHdNYw2qVxD/BEOv38ZCzzKS2XW76dLapf9ev2l2WRcmasOP8vH4toHS7j+UWFxxkjpMdTPjoI6dqMGG7ynmLhG61LSGv4Bfg3iW1Vjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lMQ36Qrt; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fe86c01f4aso9927983a91.2
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 17:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741052024; x=1741656824; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pVWF/+OYw6uzU0HOKtc8UI2eMuXCIdB02LubQ/Jgc4A=;
        b=lMQ36QrtN4pKrlUn10OuZQj7JChGZKd9gh+VFl4B/f4eTO+t2CnuLoHn5xiA3mhUBG
         63gSQrzHdzD+whGPP1Ln+0DqGYmR+PVKbLCXo+fO/aICdWsY3itULKm6q7EXNauoD2fS
         aSKPLqtqvKCyOngYtpvVQ6QeUxWd0mrh1DT46Q0xVnAnQeLIf3Y+auv59b9MIQCSc+KP
         AyLiA9zMRKXpyqpHdaTM18QsP7shDchu41OdHSMApGUbE+TPZ4WHGuy0g/8xS8j0GPUo
         9IGrKTQ597gvf+huO5YyrHEJ9FHZfzqx8T38+HVHPpFFMt7LylVUrwPoZjQWZQXx40Zz
         w0KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741052024; x=1741656824;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pVWF/+OYw6uzU0HOKtc8UI2eMuXCIdB02LubQ/Jgc4A=;
        b=crg1rxak/h/ElycIYP3jPImMdlLsx5tyJ3RF5nVHcu33cMW3wzsC7TkDNADDUaymWe
         SYif8+zAFrgcyWFly32QTNkXAsnmNVxYi80VYxRPE810+sXUDUmnz3n0ImDTrDmabAfx
         dtZcsyitQBEVQbmtX9BYT/TOh2Rj59H56/1D175QlnzCnDdw7YajbH7dW2Un2IRA8m82
         KOdJCBFsth6lto0T4TpYMaH/dxgjXTNga+NdmyUrwDrcdmtn90YYi75fSSj84VYLGxO2
         4havJtKvesO8diDUinZt/kNK+3/xxCCZNnX1yCjo58Hf3hUCIiNPaxyre374R1zpGLIt
         IXoQ==
X-Gm-Message-State: AOJu0YwdMpalg//isldlZvch/ilAkoBs8yK6ECb1qm7JEoZj4cOz29oj
	t0tEeHPIY2bvbrLJbT/2/kVdmBjRciiN119fwJaPnwG2skDro5ElgBk1F8HT2+52T277F0Y3EJS
	Y1g==
X-Google-Smtp-Source: AGHT+IEiqQkt5+UNuOvzeaEsfiMYJNiN4m8YxDgw4H7w/e5EeOuHeJe3r5VOcS0UXwoNZ+TKzKVyw7qbpOc=
X-Received: from pgbeq11.prod.google.com ([2002:a05:6a02:268b:b0:ad5:512a:7755])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2d12:b0:1e1:a75a:c452
 with SMTP id adf61e73a8af0-1f2f4d1ffc9mr23538694637.19.1741052023760; Mon, 03
 Mar 2025 17:33:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  3 Mar 2025 17:33:35 -0800
In-Reply-To: <20250304013335.4155703-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304013335.4155703-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304013335.4155703-4-seanjc@google.com>
Subject: [PATCH v5 3/3] KVM: x86: Rescan I/O APIC routes after EOI
 interception for old routing
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, xuyun <xuyun_xy.xy@linux.alibaba.com>, 
	weizijie <zijie.wei@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

From: weizijie <zijie.wei@linux.alibaba.com>

Rescan I/O APIC routes for a vCPU after handling an intercepted I/O APIC
EOI for an IRQ that is not targeting said vCPU, i.e. after handling what's
effectively a stale EOI VM-Exit.  If a level-triggered IRQ is in-flight
when IRQ routing changes, e.g. because the guest change routing from its
IRQ handler, then KVM intercepts EOIs on both the new and old target vCPUs,
so that the in-flight IRQ can be de-asserted when it's EOI'd.

However, only the EOI for the in-flight IRQ needs to intercepted, as IRQs
on the same vector with the new routing are coincidental, i.e. occur only
if the guest is reusing the vector for multiple interrupt sources.  If the
I/O APIC routes aren't rescanned, KVM will unnecessarily intercept EOIs
for the vector and negative impact the vCPU's interrupt performance.

Note, both commit db2bdcbbbd32 ("KVM: x86: fix edge EOI and IOAPIC reconfig
race") and commit 0fc5a36dd6b3 ("KVM: x86: ioapic: Fix level-triggered EOI
and IOAPIC reconfigure race") mentioned this issue, but it was considered
a "rare" occurrence thus was not addressed.  However in real environments,
this issue can happen even in a well-behaved guest.

Cc: Kai Huang <kai.huang@intel.com>
Co-developed-by: xuyun <xuyun_xy.xy@linux.alibaba.com>
Signed-off-by: xuyun <xuyun_xy.xy@linux.alibaba.com>
Signed-off-by: weizijie <zijie.wei@linux.alibaba.com>
[sean: massage changelog and comments, use int/-1, reset at scan]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/irq_comm.c         | 16 ++++++++++++++--
 arch/x86/kvm/lapic.c            |  8 ++++++++
 arch/x86/kvm/x86.c              |  1 +
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 44007a351e88..b378414c3104 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1025,6 +1025,7 @@ struct kvm_vcpu_arch {
 
 	int pending_ioapic_eoi;
 	int pending_external_vector;
+	int highest_stale_pending_ioapic_eoi;
 
 	/* be preempted when it's in kernel-mode(cpl=0) */
 	bool preempted_in_kernel;
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 14590d9c4a37..d6d792b5d1bd 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -412,9 +412,21 @@ void kvm_scan_ioapic_irq(struct kvm_vcpu *vcpu, u32 dest_id, u16 dest_mode,
 	 * level-triggered IRQ.  The EOI needs to be intercepted and forwarded
 	 * to I/O APIC emulation so that the IRQ can be de-asserted.
 	 */
-	if (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT, dest_id, dest_mode) ||
-	    kvm_apic_pending_eoi(vcpu, vector))
+	if (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT, dest_id, dest_mode)) {
 		__set_bit(vector, ioapic_handled_vectors);
+	} else if (kvm_apic_pending_eoi(vcpu, vector)) {
+		__set_bit(vector, ioapic_handled_vectors);
+
+		/*
+		 * Track the highest pending EOI for which the vCPU is NOT the
+		 * target in the new routing.  Only the EOI for the IRQ that is
+		 * in-flight (for the old routing) needs to be intercepted, any
+		 * future IRQs that arrive on this vCPU will be coincidental to
+		 * the level-triggered routing and don't need to be intercepted.
+		 */
+		if ((int)vector > vcpu->arch.highest_stale_pending_ioapic_eoi)
+			vcpu->arch.highest_stale_pending_ioapic_eoi = vector;
+	}
 }
 
 void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9dbc0f5d9865..6af84a0f84f3 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1459,6 +1459,14 @@ static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
 	if (!kvm_ioapic_handles_vector(apic, vector))
 		return;
 
+	/*
+	 * If the intercepted EOI is for an IRQ that was pending from previous
+	 * routing, then re-scan the I/O APIC routes as EOIs for the IRQ likely
+	 * no longer need to be intercepted.
+	 */
+	if (apic->vcpu->arch.highest_stale_pending_ioapic_eoi == vector)
+		kvm_make_request(KVM_REQ_SCAN_IOAPIC, apic->vcpu);
+
 	/* Request a KVM exit to inform the userspace IOAPIC. */
 	if (irqchip_split(apic->vcpu->kvm)) {
 		apic->vcpu->arch.pending_ioapic_eoi = vector;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7d4b9e2f1a38..a40b09dfb36a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10650,6 +10650,7 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 		return;
 
 	bitmap_zero(vcpu->arch.ioapic_handled_vectors, 256);
+	vcpu->arch.highest_stale_pending_ioapic_eoi = -1;
 
 	kvm_x86_call(sync_pir_to_irr)(vcpu);
 
-- 
2.48.1.711.g2feabab25a-goog


