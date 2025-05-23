Return-Path: <kvm+bounces-47472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42817AC1938
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:07:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCC174A160D
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:06:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F415C277037;
	Fri, 23 May 2025 01:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qvUOvEpZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503BA276049
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962050; cv=none; b=ZffisDsOLJVnoK5aIGlDUhLTOKpBVyfNqd33zo8R8+Hz4uYG+Dnx7ATVKOf4i+kYgJXwGirBFMm8H0B6O33DCvlgPAeLyvVyBFUqzjC1BpxRMX+es4s2gZa38Kj/oqmwp9hBqH8lOcUGZUKDv7iVdoDBKcMIwukRQzFvuOt6NJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962050; c=relaxed/simple;
	bh=srDOFDWE3P2VL5WlCjbeOnuh/V7VTaVfjbBhk5s85qM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dMsTNVLrjI0nCto6e4kA7Vad1la2N5CTq6RCzA9+xWjnFcA18BgZHoZgrJySfEpIOlxD6JTGAT0khCAjpE85LcvMtmcUBoI3CKrOPfqrtgKfhZO1j7xu+9bFxYJ+yLSs0Y7VO9Tr30kUUuUX5x7ZQsAz+V9GdR5oGhdRU/xqgbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qvUOvEpZ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e810d6901so5671227a91.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962047; x=1748566847; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9WMm03XHcPOkUVkdGVy3jRNjqSu09sZJKxdu9rxT7Kc=;
        b=qvUOvEpZgcvx7s62vrpGyL8gYM8IO8D4p/uexWDl5JHKV9N/CTzNOzT37LxakXK9mm
         1XDQR792VAcelgDMWCNVqOYVuuz0akBo6IDtf7hJ4rSybe2uqY8Jlf0m5R1nVPrznGmT
         ZR1aGcM8cn2ba01KvbKO0TrGWWe9zS3afnnkc9cb/PsoE4HGIyEzYjkI5vXEffHTgrPD
         D1UpdJhVFFrpdNTXGnnMnHiz5v8WRt2+c5HWTTSKnB1iTcGYtOlK9GgqvbeVkhjMHI9J
         KuRnMWRuqExqIa9HsejTpbuyHQEVgAHi2xB6L42lgCiSFEdsK3G116bTJqu9dTrpybCD
         2o8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962047; x=1748566847;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9WMm03XHcPOkUVkdGVy3jRNjqSu09sZJKxdu9rxT7Kc=;
        b=IQVVisFJKe/NeJ/8HJk9ypQwwjWdBi4w3kRpJ28/DEwY+hjqgdEzDvUx764oUywCAf
         W5OX7FoaNYJte7PWATvyNEhc9uTt39UDrEYvyqfq8/5OR9qRELvTrZdMQxZ1Zl6qj3Nf
         o1EmaD+Qiq8hcDyvQy9iYeNbbFe2gUkjkeboy8NKrtbebWVIwFZgvC+vFeshF5qgssqE
         SisIw/3Gm1R/eLbKfQEXwilBz8iqne+HO/Mj5OIwOBtTzmEbXsQwIodU2lK8obtXauRb
         rw5Cg0oXcuvy1pXjon8jnSP3hesVbeketpo++OJqH4FIwWsq8i0vHNwMG7ixmkdXyIbK
         EQ4g==
X-Gm-Message-State: AOJu0Yw4S08ZSLXkAacRy5zv9pbQdWTpOxcFAXc9rWqlYgm3KT8/iNei
	ZPaO1cCmx91KZk13uyt3tQD1CgLzylHrJN8PlJNWGv8R0mXRYdsD4S6VB12YCogHALHSjyYCLcd
	HFYPLLg==
X-Google-Smtp-Source: AGHT+IHScxVo8921NDXHfwYzbnuN/lZJlpUOiAfvprIuuohbUElxMDY5rmt5M3Lf2Xtm0bYMmcmAvG8AwgQ=
X-Received: from pjbhl12.prod.google.com ([2002:a17:90b:134c:b0:30a:7da4:f075])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5143:b0:310:cf8f:6724
 with SMTP id 98e67ed59e1d1-310e9740405mr1799767a91.30.1747962047581; Thu, 22
 May 2025 18:00:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:27 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-23-seanjc@google.com>
Subject: [PATCH v2 22/59] KVM: VMX: Stop walking list of routing table entries
 when updating IRTE
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that KVM provides the to-be-updated routing entry, stop walking the
routing table to find that entry.  KVM, via setup_routing_entry() and
sanity checked by kvm_get_msi_route(), disallows having a GSI configured
to trigger multiple MSIs, i.e. the for-loop can only process one entry.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 100 +++++++++++----------------------
 1 file changed, 33 insertions(+), 67 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index d4826a6b674f..e59eae11f476 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -302,78 +302,44 @@ int vmx_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		       unsigned int host_irq, uint32_t guest_irq,
 		       struct kvm_kernel_irq_routing_entry *new)
 {
-	struct kvm_kernel_irq_routing_entry *e;
-	struct kvm_irq_routing_table *irq_rt;
-	bool enable_remapped_mode = true;
 	struct kvm_lapic_irq irq;
 	struct kvm_vcpu *vcpu;
 	struct vcpu_data vcpu_info;
-	bool set = !!new;
-	int idx, ret = 0;
 
 	if (!vmx_can_use_vtd_pi(kvm))
 		return 0;
 
-	idx = srcu_read_lock(&kvm->irq_srcu);
-	irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
-	if (guest_irq >= irq_rt->nr_rt_entries ||
-	    hlist_empty(&irq_rt->map[guest_irq])) {
-		pr_warn_once("no route for guest_irq %u/%u (broken user space?)\n",
-			     guest_irq, irq_rt->nr_rt_entries);
-		goto out;
-	}
-
-	hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
-		if (e->type != KVM_IRQ_ROUTING_MSI)
-			continue;
-
-		WARN_ON_ONCE(new && memcmp(e, new, sizeof(*new)));
-
-		/*
-		 * VT-d PI cannot support posting multicast/broadcast
-		 * interrupts to a vCPU, we still use interrupt remapping
-		 * for these kind of interrupts.
-		 *
-		 * For lowest-priority interrupts, we only support
-		 * those with single CPU as the destination, e.g. user
-		 * configures the interrupts via /proc/irq or uses
-		 * irqbalance to make the interrupts single-CPU.
-		 *
-		 * We will support full lowest-priority interrupt later.
-		 *
-		 * In addition, we can only inject generic interrupts using
-		 * the PI mechanism, refuse to route others through it.
-		 */
-
-		kvm_set_msi_irq(kvm, e, &irq);
-		if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
-		    !kvm_irq_is_postable(&irq))
-			continue;
-
-		vcpu_info.pi_desc_addr = __pa(vcpu_to_pi_desc(vcpu));
-		vcpu_info.vector = irq.vector;
-
-		trace_kvm_pi_irte_update(host_irq, vcpu->vcpu_id, e->gsi,
-				vcpu_info.vector, vcpu_info.pi_desc_addr, set);
-
-		if (!set)
-			continue;
-
-		enable_remapped_mode = false;
-
-		ret = irq_set_vcpu_affinity(host_irq, &vcpu_info);
-		if (ret < 0) {
-			printk(KERN_INFO "%s: failed to update PI IRTE\n",
-					__func__);
-			goto out;
-		}
-	}
-
-	if (enable_remapped_mode)
-		ret = irq_set_vcpu_affinity(host_irq, NULL);
-
-	ret = 0;
-out:
-	srcu_read_unlock(&kvm->irq_srcu, idx);
-	return ret;
+	/*
+	 * VT-d PI cannot support posting multicast/broadcast
+	 * interrupts to a vCPU, we still use interrupt remapping
+	 * for these kind of interrupts.
+	 *
+	 * For lowest-priority interrupts, we only support
+	 * those with single CPU as the destination, e.g. user
+	 * configures the interrupts via /proc/irq or uses
+	 * irqbalance to make the interrupts single-CPU.
+	 *
+	 * We will support full lowest-priority interrupt later.
+	 *
+	 * In addition, we can only inject generic interrupts using
+	 * the PI mechanism, refuse to route others through it.
+	 */
+	if (!new || new->type != KVM_IRQ_ROUTING_MSI)
+		goto do_remapping;
+
+	kvm_set_msi_irq(kvm, new, &irq);
+
+	if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
+	    !kvm_irq_is_postable(&irq))
+		goto do_remapping;
+
+	vcpu_info.pi_desc_addr = __pa(vcpu_to_pi_desc(vcpu));
+	vcpu_info.vector = irq.vector;
+
+	trace_kvm_pi_irte_update(host_irq, vcpu->vcpu_id, guest_irq,
+				 vcpu_info.vector, vcpu_info.pi_desc_addr, true);
+
+	return irq_set_vcpu_affinity(host_irq, &vcpu_info);
+do_remapping:
+	return irq_set_vcpu_affinity(host_irq, NULL);
 }
-- 
2.49.0.1151.ga128411c76-goog


