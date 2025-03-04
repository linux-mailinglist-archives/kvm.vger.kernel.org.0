Return-Path: <kvm+bounces-39951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 16712A4D108
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 02:35:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FA63177444
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 01:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17C951DF962;
	Tue,  4 Mar 2025 01:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="epF1dJPS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C261AAE17
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 01:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741052024; cv=none; b=EdTyOfvVh5cqRx3RvZ9sVl274xgDBtvk+gq8BwDbH7nQQiqngt48BVrQ85DOgsCdnDb28CHWDmjHDoItZ3Z2Xuo5RuZdlmnGxiIBaU/zzLoCvUQLdqitG8/ST1JCSrm39trjlkOvC92umzBV2f4UrdhcoaNG20JisI0ngrqyyNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741052024; c=relaxed/simple;
	bh=bWa7MI7Je53+hcO260m6tDnoOA7tYXPBsMlcHDj5OIo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tq4rIPA+DcbptUCid5guMMmoIfOH2VKnYjV3RW1VExoX1yd6RMEOp1NiYgBW7/54PUYmMAgFspJi0qKsdIVU6Sdf3R7Cresx7y8T2vox09HESOMRr4ZPKRe0dNjQL0BTKceldTd7LAA8VqWdKvbzg2hoWo3PF822e1HsA3CGROQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=epF1dJPS; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fe870bc003so10197313a91.1
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 17:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741052022; x=1741656822; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=X9wy79sbNpkEBREyMkIDmJ5bL01i0GTTP9jdKigT/f8=;
        b=epF1dJPSJoIjx/5l9rks5Ltj6C0W3uT4vbDwj3VYDbaVcWrMTOKLshVh6dX4Zgku+0
         +ely5Tt3LYMysBckLf1irSrm8/tGv38riOLZTbDp+1McTRBna2xoo61Tc52NQjLFkjuw
         OvQVmuc+S4Y9jwpeUW51GG/Zkc/8/LM/NssyL0+nIZBrBMV5U/BKzSTCN9P0mAAy+YC4
         gMdVgNn0u0RAoyU3nsgjvngVWQz+0qRS0OUnvxMpr1/x+9NmpXI+iqAX2h5m4AWjfrzb
         QPKgYAy0nVddeTg8vy/8Wla0mgW4/GA4X0hIJBZ9BWQhBW5jcmAXrlK/6x5Vk5hk17Kf
         KkTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741052022; x=1741656822;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X9wy79sbNpkEBREyMkIDmJ5bL01i0GTTP9jdKigT/f8=;
        b=Ir9hc/rrv17i3FPYM2ltFOAFFgIhvKE/Qu6k4pmKc9aPJTEeDzcoqe3jqcsrQ939Cw
         guXlpxTbQogbJDVTWt5rxXDOdMBgnGBBEoVjbFgs9lpKRXV8Df+o/cLL2kzhg8IR2Jqh
         8CMpE0VRkYpUQUJMct0pLgXc2AESUHANh5YNuUL3fxK6ztKxhabDWsPEGk+yjRdjSKyI
         oGQu0rsLnfJX04/uRtc5sSrOJvihKm32UxxCImxmmtnHGIDKG3qvK2DS38DY4I9X3vBK
         JFuPu/J+qKjTGDtcDWyxmERDADgiMgjLiECijrVQg3+iPscNnz4oOYf9qpIQ71vGMNFy
         SIcg==
X-Gm-Message-State: AOJu0YwaKtTw3FUf6LpgLdfvbs3SlilwW5PVnJlwmmMxcERKSpZb2g5L
	PdjC1SYjElKADmqDmjz4NjY6QtTN4JhRe+0Nz+Ex0PVxo9uTAuQY/iiU/1RdR8ptWQxdkbCJ6Ag
	sHQ==
X-Google-Smtp-Source: AGHT+IGVk1UjX3zn4sKZXBI9Q4g1z0uT75lXD5hnr1yXiiySOX13OZkHBINhW/GTF9uaoBbYjX8IGddC1WU=
X-Received: from pjbsj5.prod.google.com ([2002:a17:90b:2d85:b0:2f9:c349:2f84])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d2c3:b0:2f9:d0cd:3403
 with SMTP id 98e67ed59e1d1-2ff33bdb4a2mr2138807a91.16.1741052022093; Mon, 03
 Mar 2025 17:33:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  3 Mar 2025 17:33:34 -0800
In-Reply-To: <20250304013335.4155703-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304013335.4155703-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304013335.4155703-3-seanjc@google.com>
Subject: [PATCH v5 2/3] KVM: x86: Add a helper to deduplicate I/O APIC EOI
 interception logic
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, xuyun <xuyun_xy.xy@linux.alibaba.com>, 
	weizijie <zijie.wei@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

Extract the vCPU specific EOI interception logic for I/O APIC emulation
into a common helper for userspace and in-kernel emulation in anticipation
of optimizing the "pending EOI" case.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/ioapic.c   |  7 ++-----
 arch/x86/kvm/ioapic.h   |  2 ++
 arch/x86/kvm/irq_comm.c | 21 +++++++++++++++++----
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 995eb5054360..45dae2d5d2f1 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -296,11 +296,8 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, ulong *ioapic_handled_vectors)
 		    index == RTC_GSI) {
 			u16 dm = kvm_lapic_irq_dest_mode(!!e->fields.dest_mode);
 
-			if (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
-						e->fields.dest_id, dm) ||
-			    kvm_apic_pending_eoi(vcpu, e->fields.vector))
-				__set_bit(e->fields.vector,
-					  ioapic_handled_vectors);
+			kvm_scan_ioapic_irq(vcpu, e->fields.dest_id, dm,
+					    e->fields.vector, ioapic_handled_vectors);
 		}
 	}
 	spin_unlock(&ioapic->lock);
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index 539333ac4b38..aa8cb4ac0479 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -120,4 +120,6 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu,
 			   ulong *ioapic_handled_vectors);
 void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
 			    ulong *ioapic_handled_vectors);
+void kvm_scan_ioapic_irq(struct kvm_vcpu *vcpu, u32 dest_id, u16 dest_mode,
+			 u8 vector, unsigned long *ioapic_handled_vectors);
 #endif
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 866f84392797..14590d9c4a37 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -402,6 +402,21 @@ void kvm_arch_post_irq_routing_update(struct kvm *kvm)
 	kvm_make_scan_ioapic_request(kvm);
 }
 
+void kvm_scan_ioapic_irq(struct kvm_vcpu *vcpu, u32 dest_id, u16 dest_mode,
+			 u8 vector, unsigned long *ioapic_handled_vectors)
+{
+	/*
+	 * Intercept EOI if the vCPU is the target of the new IRQ routing, or
+	 * the vCPU has a pending IRQ from the old routing, i.e. if the vCPU
+	 * may receive a level-triggered IRQ in the future, or already received
+	 * level-triggered IRQ.  The EOI needs to be intercepted and forwarded
+	 * to I/O APIC emulation so that the IRQ can be de-asserted.
+	 */
+	if (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT, dest_id, dest_mode) ||
+	    kvm_apic_pending_eoi(vcpu, vector))
+		__set_bit(vector, ioapic_handled_vectors);
+}
+
 void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
 			    ulong *ioapic_handled_vectors)
 {
@@ -427,10 +442,8 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
 			if (!irq.trig_mode)
 				continue;
 
-			if (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
-						irq.dest_id, irq.dest_mode) ||
-			     kvm_apic_pending_eoi(vcpu, irq.vector))
-				__set_bit(irq.vector, ioapic_handled_vectors);
+			kvm_scan_ioapic_irq(vcpu, irq.dest_id, irq.dest_mode,
+					    irq.vector, ioapic_handled_vectors);
 		}
 	}
 	srcu_read_unlock(&kvm->irq_srcu, idx);
-- 
2.48.1.711.g2feabab25a-goog


