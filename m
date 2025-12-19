Return-Path: <kvm+bounces-66301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C452CCE674
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 04:58:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B765C30671D8
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 03:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E6382BD58C;
	Fri, 19 Dec 2025 03:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UP38xo9u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983492C11F8
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 03:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766116450; cv=none; b=eq5HwhWfLt9l3ReuDPYNso2mDmCe5+KdjpdjxwKXwKdlWh7dlw5rjMPqUTkh/yG7VHW4clio7gTvhvb6/M0i9sZVc+EkcJPaxBmwGwL4Lrg6hbYDzDfQwHQUCS6kWayKIJOm9/DcWoB4cfK4GPRUINuVrvUnSEJ59u7unbksbcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766116450; c=relaxed/simple;
	bh=wyu0Xy5M14HONUNUhNjxjrYaG5XoUEX/b1Lfkrm3zVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uK+tLWa1seFbF0AveRUMQGJZZXFJ6/KuNWsFI3zMqu/LwLdwcuX1PbcKc1w4Yoe3iVmzBpgcTTPcLtfOcZKz9Q+cg/SmqeOCTtJVtFiRHffq/RuFqYfNxwMTXRuS04ee2oHwyPg3owRw8FGVIPAxQjykuNowVzIMfb+JUPE4qA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UP38xo9u; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a081c163b0so12811235ad.0
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 19:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766116446; x=1766721246; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XZA9xLUe1wdJNehNCsIwk1F3wttPASSXZeP33LjNfbM=;
        b=UP38xo9uPmHzhH2RsU+4nrQ1tO6TWTLRhvuVpg8MdyvB6Ee7LPF6NQ3sCW4pJvRXlt
         BozeuPmvPyYd+FTf5WNWXJSknOvYMKBiMlxN7V1JiwZf3baXgvSGkhrqFlM0SmnP0oVa
         gOfzsybf0hKWLhGFRTiJ/+ff8ie0nZbjvAbdcfwn+ObyhAPJMAEOLZt2+jyf0vP6X8Ej
         XmIwzZozLgk04OZyVvyl8+1IMg4djXqk94LosbdwE5eorSvFtToqXStBRuEU+xD9NRM+
         hb7MD8xFiFJv9tVH4p8f2u0Kgny+SF+1X1z5XHdJo2Khl/jEp57xj2nOHy9n8VGcwH68
         rhzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766116446; x=1766721246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XZA9xLUe1wdJNehNCsIwk1F3wttPASSXZeP33LjNfbM=;
        b=LxUMhQ+f/mAyPUJB0vr/xzHJR6gSybIvxLO2QMC71haCu4tlSprK0ASvSKsze0PfFu
         m6obLXzFhPPUuk3RMLQMi9f3vXqt+oC16Hmu9FIg6IYzKg7dZKFpogzHKypN0MHAfraG
         vgIfpHqvmPR/tXrAeRm5o3+nxPNaJrTj+5t5QPKJ23alejNc1L+/ET7lceR8dRtad3kB
         8wRPhldsetXFeia3sh8mKTIgobjLUqVGMAjNghQcxu4SZuj5CfrYf+mPpK2WZlMSDOcG
         BeHAWPxPl4ugsIfl4gfli67kN9aL1/+u7S+f5NuFILZYMd6u2i9cmq+WY5MEvaxfzTdy
         l/Kg==
X-Forwarded-Encrypted: i=1; AJvYcCXO+1d7QWO5WAIamOmJUtKmsvzzeGjy5eFXq6eTSnz78rs58cATz2NevLQTYzswcPqYqoM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcsxueZfDP752dqVuj1EIr/X2aCLuHAv++4KH7FCTDFyor1kFp
	igX1kh6kkPw/BXd2fApYvs5iu6VD3uHN/T0zJUArd953On0gL2dsTwXK
X-Gm-Gg: AY/fxX7vwvnHuz+9xe1trdsSURAbQpgJ9FetOHDRFAb5jivWCBLE760mcwWOb/vcNlh
	bpN74Pb8LGxNWGVeq3X0j6k1qwvBp+TyCWHqxV8TLWKTMGTB7JG3NX09x3+YH/NCMbon+zQ/c10
	MjNu708BrezX8c9l09lDC6lmvGPF4baic+9AefwcQl+wYiwN9aiHOQRQYzlgCB1TOiSAF1+MCWV
	UxmnNNakWrfxu8rz80vrRwxo6xb4G0S350Wnfgbehq8KTN3wAr1Wn0miqhTn/a3pFoG/xv5blAm
	4DEdWkCWx0k0F5778HZm/hIvL1lGVpPS7QNG4FRkXlr19ciSOx0dSjXpzS6h8obtHiNj8XYWZmy
	/lOYh+0K1MB6TK04Ezkpb3Ft+UBpKytpVJ/LefUxwMH8ERIwpywtIGFhDroI35vxcH+YUn6pWab
	IePBhbqtPlmA==
X-Google-Smtp-Source: AGHT+IH7i1wMUpIAvo5+XIESo2FqbxEFz6LLhGsiwcOV+fLp/Up+b2cbDa//nLVFrcxtfnqkDIXK1g==
X-Received: by 2002:a17:902:d488:b0:2a0:8f6f:1a12 with SMTP id d9443c01a7336-2a2f222ac10mr15671525ad.17.1766116446401;
        Thu, 18 Dec 2025 19:54:06 -0800 (PST)
Received: from wanpengli.. ([175.170.92.22])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2a2f3d4d36esm7368135ad.63.2025.12.18.19.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 19:54:06 -0800 (PST)
From: Wanpeng Li <kernellwp@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH v2 7/9] KVM: x86/lapic: Integrate IPI tracking with interrupt delivery
Date: Fri, 19 Dec 2025 11:53:31 +0800
Message-ID: <20251219035334.39790-8-kernellwp@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251219035334.39790-1-kernellwp@gmail.com>
References: <20251219035334.39790-1-kernellwp@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wanpeng Li <wanpengli@tencent.com>

Hook IPI tracking into the LAPIC interrupt delivery path to capture
sender/receiver relationships for directed yield optimization.

Implement kvm_ipi_track_send() called from kvm_irq_delivery_to_apic()
when a unicast fixed IPI is detected (exactly one destination). Record
sender vCPU index, receiver vCPU index, and timestamp using lockless
WRITE_ONCE for minimal overhead.

Implement kvm_ipi_track_eoi() called from kvm_apic_set_eoi_accelerated()
and handle_apic_eoi() to clear IPI context when interrupts are
acknowledged. Use two-stage clearing:
1. Unconditionally clear the receiver's context (it processed the IPI)
2. Conditionally clear sender's pending flag only when the sender
   exists, last_ipi_receiver matches, and the IPI is recent

Use lockless accessors for minimal overhead. The tracking only
activates for unicast fixed IPIs where directed yield provides value.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 90 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 86 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 23f247a3b127..d4fb6f49390b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1270,6 +1270,9 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 	struct kvm_lapic **dst = NULL;
 	int i;
 	bool ret;
+	int targets = 0;
+	int delivered;
+	struct kvm_vcpu *unique = NULL;
 
 	*r = -1;
 
@@ -1291,8 +1294,22 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		for_each_set_bit(i, &bitmap, 16) {
 			if (!dst[i])
 				continue;
-			*r += kvm_apic_set_irq(dst[i]->vcpu, irq, dest_map);
+			delivered = kvm_apic_set_irq(dst[i]->vcpu, irq, dest_map);
+			*r += delivered;
+			if (delivered > 0) {
+				targets++;
+				unique = dst[i]->vcpu;
+			}
 		}
+
+		/*
+		 * Track IPI for directed yield: only for LAPIC-originated
+		 * APIC_DM_FIXED without shorthand, with exactly one recipient.
+		 */
+		if (src && irq->delivery_mode == APIC_DM_FIXED &&
+		    irq->shorthand == APIC_DEST_NOSHORT &&
+		    targets == 1 && unique && unique != src->vcpu)
+			kvm_track_ipi_communication(src->vcpu, unique);
 	}
 
 	rcu_read_unlock();
@@ -1377,6 +1394,9 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 	struct kvm_vcpu *vcpu, *lowest = NULL;
 	unsigned long i, dest_vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
 	unsigned int dest_vcpus = 0;
+	int targets = 0;
+	int delivered;
+	struct kvm_vcpu *unique = NULL;
 
 	if (kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, dest_map))
 		return r;
@@ -1400,7 +1420,12 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		if (!kvm_lowest_prio_delivery(irq)) {
 			if (r < 0)
 				r = 0;
-			r += kvm_apic_set_irq(vcpu, irq, dest_map);
+			delivered = kvm_apic_set_irq(vcpu, irq, dest_map);
+			r += delivered;
+			if (delivered > 0) {
+				targets++;
+				unique = vcpu;
+			}
 		} else if (kvm_apic_sw_enabled(vcpu->arch.apic)) {
 			if (!vector_hashing_enabled) {
 				if (!lowest)
@@ -1421,8 +1446,23 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		lowest = kvm_get_vcpu(kvm, idx);
 	}
 
-	if (lowest)
-		r = kvm_apic_set_irq(lowest, irq, dest_map);
+	if (lowest) {
+		delivered = kvm_apic_set_irq(lowest, irq, dest_map);
+		r = delivered;
+		if (delivered > 0) {
+			targets = 1;
+			unique = lowest;
+		}
+	}
+
+	/*
+	 * Track IPI for directed yield: only for LAPIC-originated
+	 * APIC_DM_FIXED without shorthand, with exactly one recipient.
+	 */
+	if (src && irq->delivery_mode == APIC_DM_FIXED &&
+	    irq->shorthand == APIC_DEST_NOSHORT &&
+	    targets == 1 && unique && unique != src->vcpu)
+		kvm_track_ipi_communication(src->vcpu, unique);
 
 	return r;
 }
@@ -1608,6 +1648,45 @@ static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
 #endif
 }
 
+/*
+ * Clear IPI context on EOI to prevent stale boost decisions.
+ *
+ * Two-stage cleanup:
+ * 1. Always clear receiver's IPI context (it processed the interrupt)
+ * 2. Conditionally clear sender's pending flag only when:
+ *    - Sender vCPU exists and is valid
+ *    - Sender's last_ipi_receiver matches this receiver
+ *    - IPI was sent recently (within window)
+ */
+static void kvm_clear_ipi_on_eoi(struct kvm_lapic *apic)
+{
+	struct kvm_vcpu *receiver = apic->vcpu;
+	int sender_idx;
+	u64 then, now;
+
+	if (unlikely(!READ_ONCE(ipi_tracking_enabled)))
+		return;
+
+	sender_idx = READ_ONCE(receiver->arch.ipi_context.last_ipi_sender);
+
+	/* Step 1: Always clear receiver's IPI context */
+	kvm_vcpu_clear_ipi_context(receiver);
+
+	/* Step 2: Conditionally clear sender's pending flag */
+	if (sender_idx >= 0) {
+		struct kvm_vcpu *sender = kvm_get_vcpu(receiver->kvm, sender_idx);
+
+		if (sender &&
+		    READ_ONCE(sender->arch.ipi_context.last_ipi_receiver) ==
+		    receiver->vcpu_idx) {
+			then = READ_ONCE(sender->arch.ipi_context.ipi_time_ns);
+			now = ktime_get_mono_fast_ns();
+			if (now - then <= ipi_window_ns)
+				WRITE_ONCE(sender->arch.ipi_context.pending_ipi, false);
+		}
+	}
+}
+
 static int apic_set_eoi(struct kvm_lapic *apic)
 {
 	int vector = apic_find_highest_isr(apic);
@@ -1643,6 +1722,7 @@ void kvm_apic_set_eoi_accelerated(struct kvm_vcpu *vcpu, int vector)
 	trace_kvm_eoi(apic, vector);
 
 	kvm_ioapic_send_eoi(apic, vector);
+	kvm_clear_ipi_on_eoi(apic);
 	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_apic_set_eoi_accelerated);
@@ -2453,6 +2533,8 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 
 	case APIC_EOI:
 		apic_set_eoi(apic);
+		/* Precise cleanup for IPI-aware boost */
+		kvm_clear_ipi_on_eoi(apic);
 		break;
 
 	case APIC_LDR:
-- 
2.43.0


