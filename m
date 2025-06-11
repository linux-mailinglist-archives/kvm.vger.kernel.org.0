Return-Path: <kvm+bounces-49178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD1DBAD6339
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:58:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0367F46068D
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:58:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A2292BF3E0;
	Wed, 11 Jun 2025 22:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NuuPz2hK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BB62E1751
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682073; cv=none; b=CAY2xy4KqvxGmq9LP/POqJ/WxmNTUpDxCh0jdxCHZ42FtdbzuStnNOgtYBhqcJYG3DTzZZcWDxATX3rzznmJ1dDZAvwXabQpXsV6hTy2l7KfWIYRGTvighlnZNuRvXFpC7zqT31k8OK4a1wI+xhPFKsvrm9HNMc6EiXI7YqmMPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682073; c=relaxed/simple;
	bh=9DGXuWFXvUh1cKeaMH87pZxPNHCQqJZihf+nqkLurgQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VvqUd7AUX9v9/DpH18G4UUI9VzXuxkv27oCTLdKqSzuaTq1whBIngcjixj90OaEaV8a6wYDsZNiGyuwomdkeRrjOjWtVcsrqBRfDKlmPveYw9FSraqAJk2FvPD2gs7uYVkmSRrMzKF9d52zrdOrd/iNkihH8GfMrx+sWdlh6qvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NuuPz2hK; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30a59538b17so291519a91.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682071; x=1750286871; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IVORzZ3WtABPA4nL5djBdFQBg9zHlAGlDI6miaVMwbQ=;
        b=NuuPz2hKg6xHDspY9PlJLElTxRGDtiMxdUJRzTt5dhtrd/lVKKzs2YiKpKYnHOwhoR
         /Pyw/V1QCMwq8aiM+0Xf7chIFs3t2urOyO7Ym27C75BqiaSvR3WgspDp2qYEEVZxuZ6h
         605AtMs+9hW2VYXsOJ++1WvI0aW28bAwLMHFYTQdnXI9mgmxotKpJj1e4qvZ/JVZ7PmR
         Ufw1fg+KpCXpUab5d5TtVZw93dNgddsm0YV5gA2Icyk0TembDxUNqGPA0o3Kvv2Rmli+
         TWueMQR+UiNct//ML8prIGj4wzprwI1ezbb09/LWly3X1Up66U88HTzFYFpoyFf/5Nud
         fUOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682071; x=1750286871;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IVORzZ3WtABPA4nL5djBdFQBg9zHlAGlDI6miaVMwbQ=;
        b=JeE1kRyH9UEG/keVEPhnVkSgZJGomIB1qTHjqRYYojIsHfNtHoE8CBj45WgwqmnOVa
         ycD2P4Rm2E9zj1K+rdj0HkdYR9zPsW3YC3N44C38nZPVM5vCeourX28J2cZHiMoYOdxg
         eQeUESMjmfrGOj/4vUD0mI9h/OCpZOSA37Q5uJ7ixQE6AHnFp8+m1/AB8yrTbvAV+1e/
         xbWNIEgYxOiAkur9xQnwMkOdtnMxK42dtGhHWbKqUkxky+r+5zk6g1B+IpHAG8Mv4Koc
         aoWWsUI6dK8frFhyx8KKY68NHoJuDHWk3hjGXCJ1FY5XeoYOOGl7lO/hDDVCTa6vJNSW
         1CIQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2aYvxeV+11zLocW4IMFHiSbokxg6Hq0UVoKB8jAu/Qo8Olei+sq9qdx7feBGcbfKeEfk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9pA1816CeTFZ2Y1oImyV/c+PsKWU4goLxTsLHD9rUq9MTye0f
	90JYUqXYNYEq2p53h/R/Z+4zEx9aIi5ShwQePFlQ3hq2R9fo0amTj23mcPnTAj6J63Vne0yetXR
	wrz3UKg==
X-Google-Smtp-Source: AGHT+IHL9/OcJTEGPKZiKOBxCN3k4QlrTLAqBQPtsp7OZWVMLJS3qoHaHW8s60G6klv+4Oa8JxHOL5bk6d0=
X-Received: from pjbpq18.prod.google.com ([2002:a17:90b:3d92:b0:2e0:915d:d594])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3952:b0:30e:9349:2da2
 with SMTP id 98e67ed59e1d1-313af0fd336mr6600558a91.4.1749682070803; Wed, 11
 Jun 2025 15:47:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:35 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-34-seanjc@google.com>
Subject: [PATCH v3 32/62] KVM: Don't WARN if updating IRQ bypass route fails
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't bother WARNing if updating an IRTE route fails now that vendor code
provides much more precise WARNs.  The generic WARN doesn't provide enough
information to actually debug the problem, and has obviously done nothing
to surface the myriad bugs in KVM x86's implementation.

Drop all of the associated return code plumbing that existed just so that
common KVM could WARN.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c          |  6 +++---
 arch/arm64/kvm/vgic/vgic-v4.c | 11 ++++-------
 arch/x86/kvm/irq.c            |  8 ++++----
 include/kvm/arm_vgic.h        |  2 +-
 include/linux/kvm_host.h      |  6 +++---
 virt/kvm/eventfd.c            | 15 ++++++---------
 6 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a9a39e0375f7..94fb2f096a20 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2771,9 +2771,9 @@ bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
 	return memcmp(&old->msi, &new->msi, sizeof(new->msi));
 }
 
-int kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
-				  struct kvm_kernel_irq_routing_entry *old,
-				  struct kvm_kernel_irq_routing_entry *new)
+void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
+				   struct kvm_kernel_irq_routing_entry *old,
+				   struct kvm_kernel_irq_routing_entry *new)
 {
 	/*
 	 * Remapping the vLPI requires taking the its_lock mutex to resolve
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 86e54cefc237..5e59a3f5d4c9 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -527,29 +527,26 @@ static struct vgic_irq *__vgic_host_irq_get_vlpi(struct kvm *kvm, int host_irq)
 	return NULL;
 }
 
-int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq)
+void kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq)
 {
 	struct vgic_irq *irq;
 	unsigned long flags;
-	int ret = 0;
 
 	if (!vgic_supports_direct_msis(kvm))
-		return 0;
+		return;
 
 	irq = __vgic_host_irq_get_vlpi(kvm, host_irq);
 	if (!irq)
-		return 0;
+		return;
 
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	WARN_ON(irq->hw && irq->host_irq != host_irq);
 	if (irq->hw) {
 		atomic_dec(&irq->target_vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count);
 		irq->hw = false;
-		ret = its_unmap_vlpi(host_irq);
-		WARN_ON_ONCE(ret);
+		WARN_ON_ONCE(its_unmap_vlpi(host_irq));
 	}
 
 	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 	vgic_put_irq(kvm, irq);
-	return ret;
 }
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index ec13d1d7706d..adc250ca1171 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -606,11 +606,11 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	kvm_arch_end_assignment(irqfd->kvm);
 }
 
-int kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
-				  struct kvm_kernel_irq_routing_entry *old,
-				  struct kvm_kernel_irq_routing_entry *new)
+void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
+				   struct kvm_kernel_irq_routing_entry *old,
+				   struct kvm_kernel_irq_routing_entry *new)
 {
-	return kvm_pi_update_irte(irqfd, new);
+	kvm_pi_update_irte(irqfd, new);
 }
 
 bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4a34f7f0a864..b2a04481de1a 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -434,7 +434,7 @@ struct kvm_kernel_irq_routing_entry;
 int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int irq,
 			       struct kvm_kernel_irq_routing_entry *irq_entry);
 
-int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq);
+void kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq);
 
 int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a4160c1c0c6b..8e74ac0f90b1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2410,9 +2410,9 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *,
 			   struct irq_bypass_producer *);
 void kvm_arch_irq_bypass_stop(struct irq_bypass_consumer *);
 void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *);
-int kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
-				  struct kvm_kernel_irq_routing_entry *old,
-				  struct kvm_kernel_irq_routing_entry *new);
+void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
+				   struct kvm_kernel_irq_routing_entry *old,
+				   struct kvm_kernel_irq_routing_entry *new);
 bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *,
 				  struct kvm_kernel_irq_routing_entry *);
 #endif /* CONFIG_HAVE_KVM_IRQ_BYPASS */
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 85581550dc8d..a4f80fe8a5f3 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -285,11 +285,11 @@ void __attribute__((weak)) kvm_arch_irq_bypass_start(
 {
 }
 
-int __weak kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
-					 struct kvm_kernel_irq_routing_entry *old,
-					 struct kvm_kernel_irq_routing_entry *new)
+void __weak kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
+					  struct kvm_kernel_irq_routing_entry *old,
+					  struct kvm_kernel_irq_routing_entry *new)
 {
-	return 0;
+
 }
 
 bool __attribute__((weak)) kvm_arch_irqfd_route_changed(
@@ -618,11 +618,8 @@ void kvm_irq_routing_update(struct kvm *kvm)
 
 #if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
 		if (irqfd->producer &&
-		    kvm_arch_irqfd_route_changed(&old, &irqfd->irq_entry)) {
-			int ret = kvm_arch_update_irqfd_routing(irqfd, &old, &irqfd->irq_entry);
-
-			WARN_ON(ret);
-		}
+		    kvm_arch_irqfd_route_changed(&old, &irqfd->irq_entry))
+			kvm_arch_update_irqfd_routing(irqfd, &old, &irqfd->irq_entry);
 #endif
 	}
 
-- 
2.50.0.rc1.591.g9c95f17f64-goog


