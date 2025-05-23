Return-Path: <kvm+bounces-47477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39DC9AC1946
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:09:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AB079E1692
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:07:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 786B827E7FB;
	Fri, 23 May 2025 01:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V+8K8VJ4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C891C27AC45
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962059; cv=none; b=O029GZfkDhfcGjJbf0x9697mkpjPip9RJ6ucu4paxKJz/5fyooHSiAiffDRe4XYJqqRGZ655YNKMewB6w3+bKEknJD+j4XQizxI72VGSVB/hQqPUj1XmvU/Kr8gml4Y0NeOEzMIXEwWVYJ7bG8YsF8D6gdb0j+jWBI45SFWKFos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962059; c=relaxed/simple;
	bh=wFEV1hAEK9Cq21Vuw1s3f6mxULh3lU3hrKHetm6s0gA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J5ziGX3smCvqzTipCauUxN0nLGmp57IuUMxXz4ZvnI0tp5/+X0MXbgOlvBbUNkJCh3AaYR85bxlTcxOm2KwXZ/crCez9dTWfhz5FPUKleH4UdM5dIqccvbJttX2v6wmTz02scJnYWtPVV7eRYdMWWTG/izaHqNy3ZgvM57ZTE4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V+8K8VJ4; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7377139d8b1so7344607b3a.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962056; x=1748566856; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yhhE7JoXXWTWvG6yCkhC0scHPBf3Grq2tdmL6Ns+pLM=;
        b=V+8K8VJ4fv1bO/CAfX2V1B0oO9//Ngj81jaI4DCE+9gZ5TG+ZsuxsXppSSs7cG1wfI
         soDXVQTP9MD9elOfUOnxq0bJvtksirHK+hyYhOEBlQWLjMETiaAqcuUP3lxBXV6HEvKs
         ml6d5T9bi2pYCaUV+cuhYqbN33RDpKsCWnZJ9Eu7Heoag3iWqvglqcP2vJUZRN67x6K4
         NfBTIWfcpRSprq2rK26x0CRQAq9xEHPXsfZelrWlHeO6kQH1AdcTC14xBXHV8jrmYVo7
         SFIGXdxq/deiFX83ZFEON2Rc5CBIxuDMqkaPgIFNBLoC+O0XEvRgXOvraJwmHgpJ4zTR
         fHLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962056; x=1748566856;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yhhE7JoXXWTWvG6yCkhC0scHPBf3Grq2tdmL6Ns+pLM=;
        b=wN4b39AeyRxA088h6yTSqpolL6wtU3PpwerJxCVClfsT1UjP0JP2KHjDs2qBHEBzVw
         baHUgxohdNj3n8ueH8L6FV7hAyCWFw52jGcyLv4M2HH7YU/qqZqmlcB1gkRKTtY5AGGl
         ZBz8pJhwJm4SDxWMW2Djdm6fml4mdMI+MDCJQYayMTXpkaHTOJONiUQiAtNsMvEntvzy
         sNolaTekpy6I/C26TTJwj5DRDjsxVFB4Kk2U0SgaVKjsTGZzmljF891d8uYld0lq2Flq
         wb8tYesJoconkz8m4UBSKsnzw6pv+BSz9wZvuY0g//AhQ4o5InZ3b+gmfvjQgKeePNrY
         YTZQ==
X-Gm-Message-State: AOJu0YzwZKo1K/HgXc6BnZb4MJQwgw/LCzu1Eiq01jV5jCUhsZ5WOYVP
	OpP63AdxRFLOoVbccY5jH5DeyI0WnGDxo27okNDxdQRh5ittCTfszrKR0Sy+QQ5k2eieBYJrymh
	t4kdNNA==
X-Google-Smtp-Source: AGHT+IGRx2ZiGMUhau6D91BFbr/Ev2ssLnSEh7KdoNoZVLG8Xa09euUH8Eb2wiP0l+nV6+T4r2JytUx0iL0=
X-Received: from pfbea26.prod.google.com ([2002:a05:6a00:4c1a:b0:741:1f46:47b1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:170a:b0:740:aa31:fe66
 with SMTP id d2e1a72fcca58-745ed842bf8mr1610578b3a.4.1747962056133; Thu, 22
 May 2025 18:00:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:32 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-28-seanjc@google.com>
Subject: [PATCH v2 27/59] KVM: x86: Move posted interrupt tracepoint to common code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Move the pi_irte_update tracepoint to common x86, and call it whenever the
IRTE is modified.  Tracing only the modifications that result in an IRQ
being posted to a vCPU makes the tracepoint useless for debugging.

Drop the vendor specific address; plumbing that into common code isn't
worth the trouble, as the address is meaningless without a whole pile of
other information that isn't provided in any tracepoint.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c             | 12 ++++++++++--
 arch/x86/kvm/svm/avic.c        |  6 ------
 arch/x86/kvm/trace.h           | 19 +++++++------------
 arch/x86/kvm/vmx/posted_intr.c |  3 ---
 arch/x86/kvm/x86.c             |  1 -
 5 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 92a2137e0402..f20b6da30d6f 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -511,9 +511,11 @@ void kvm_arch_irq_routing_update(struct kvm *kvm)
 static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
 			      struct kvm_kernel_irq_routing_entry *entry)
 {
+	unsigned int host_irq = irqfd->producer->irq;
 	struct kvm *kvm = irqfd->kvm;
 	struct kvm_vcpu *vcpu = NULL;
 	struct kvm_lapic_irq irq;
+	int r;
 
 	if (!irqchip_in_kernel(kvm) ||
 	    !kvm_arch_has_irq_bypass() ||
@@ -540,8 +542,13 @@ static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
 			vcpu = NULL;
 	}
 
-	return kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, irqfd->producer->irq,
-					    irqfd->gsi, vcpu, irq.vector);
+	r = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, host_irq, irqfd->gsi,
+					 vcpu, irq.vector);
+	if (r)
+		return r;
+
+	trace_kvm_pi_irte_update(host_irq, vcpu, irqfd->gsi, irq.vector, !!vcpu);
+	return 0;
 }
 
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
@@ -595,6 +602,7 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 
 	spin_unlock_irq(&kvm->irqfds.lock);
 
+
 	kvm_arch_end_assignment(irqfd->kvm);
 }
 
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 14a1544af192..d8d50b8f14bb 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -815,9 +815,6 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	 */
 	svm_ir_list_del(irqfd);
 
-	pr_debug("SVM: %s: host_irq=%#x, guest_irq=%#x, set=%#x\n",
-		 __func__, host_irq, guest_irq, !!vcpu);
-
 	/**
 	 * Here, we setup with legacy mode in the following cases:
 	 * 1. When cannot target interrupt to a specific vcpu.
@@ -853,9 +850,6 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		 */
 		if (!ret)
 			ret = svm_ir_list_add(to_svm(vcpu), irqfd, &pi);
-
-		trace_kvm_pi_irte_update(host_irq, vcpu->vcpu_id, guest_irq,
-					 vector, vcpu_info.pi_desc_addr, true);
 	} else {
 		ret = irq_set_vcpu_affinity(host_irq, NULL);
 	}
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index ababdba2c186..57d79fd31df0 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1176,37 +1176,32 @@ TRACE_EVENT(kvm_smm_transition,
  * Tracepoint for VT-d posted-interrupts and AMD-Vi Guest Virtual APIC.
  */
 TRACE_EVENT(kvm_pi_irte_update,
-	TP_PROTO(unsigned int host_irq, unsigned int vcpu_id,
-		 unsigned int gsi, unsigned int gvec,
-		 u64 pi_desc_addr, bool set),
-	TP_ARGS(host_irq, vcpu_id, gsi, gvec, pi_desc_addr, set),
+	TP_PROTO(unsigned int host_irq, struct kvm_vcpu *vcpu,
+		 unsigned int gsi, unsigned int gvec, bool set),
+	TP_ARGS(host_irq, vcpu, gsi, gvec, set),
 
 	TP_STRUCT__entry(
 		__field(	unsigned int,	host_irq	)
-		__field(	unsigned int,	vcpu_id		)
+		__field(	int,		vcpu_id		)
 		__field(	unsigned int,	gsi		)
 		__field(	unsigned int,	gvec		)
-		__field(	u64,		pi_desc_addr	)
 		__field(	bool,		set		)
 	),
 
 	TP_fast_assign(
 		__entry->host_irq	= host_irq;
-		__entry->vcpu_id	= vcpu_id;
+		__entry->vcpu_id	= vcpu ? vcpu->vcpu_id : -1;
 		__entry->gsi		= gsi;
 		__entry->gvec		= gvec;
-		__entry->pi_desc_addr	= pi_desc_addr;
 		__entry->set		= set;
 	),
 
-	TP_printk("PI is %s for irq %u, vcpu %u, gsi: 0x%x, "
-		  "gvec: 0x%x, pi_desc_addr: 0x%llx",
+	TP_printk("PI is %s for irq %u, vcpu %d, gsi: 0x%x, gvec: 0x%x",
 		  __entry->set ? "enabled and being updated" : "disabled",
 		  __entry->host_irq,
 		  __entry->vcpu_id,
 		  __entry->gsi,
-		  __entry->gvec,
-		  __entry->pi_desc_addr)
+		  __entry->gvec)
 );
 
 /*
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 3de767c5d6b2..687ffde3b61c 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -308,9 +308,6 @@ int vmx_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			.vector = vector,
 		};
 
-		trace_kvm_pi_irte_update(host_irq, vcpu->vcpu_id, guest_irq,
-					 vcpu_info.vector, vcpu_info.pi_desc_addr, true);
-
 		return irq_set_vcpu_affinity(host_irq, &vcpu_info);
 	} else {
 		return irq_set_vcpu_affinity(host_irq, NULL);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a9900c246bb3..3966801bcb0d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14014,7 +14014,6 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intercepts);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_write_tsc_offset);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ple_window_update);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pml_full);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pi_irte_update);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
-- 
2.49.0.1151.ga128411c76-goog


