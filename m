Return-Path: <kvm+bounces-49149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD560AD6301
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:49:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3495816754C
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:49:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C58C225C81B;
	Wed, 11 Jun 2025 22:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hc0TZw8V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ADD259CA5
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682024; cv=none; b=GFQqWoDjS4Xt2pA13BTPRrryu8GPVAkt4SEUKAsnHBWq+31q5F9otq6wApC1DED/5oHuThJukddkoeeXMnyJbJ/RyWsloMASnKWYHltl62/7aJEvfxxPH9IZHauVPkOKIArkEGli6FtIa/FKQqgDsmg7RaxKKBpNZwk9Be82y2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682024; c=relaxed/simple;
	bh=hQldM5jR2OKbkN34k7lf7pqJTAWG76IQM47B0Quzsbw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cztluvI/bH0SFXlI7cw5QpeDU7wdNsjir+4ONKLZ9k1N1SQsMvBAWvPEUueZJzOFUoxF/fRfnPxR8NJZE/8OlrSx2bGCrJQ0YHktWjbWw4xSRTsSk9r3xh/SQMtIBKs4zlRN042T3R4JzffLkr7oJdNdl99YQRnqBEpWEUb1F+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hc0TZw8V; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b16b35ea570so250475a12.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682021; x=1750286821; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=I51DP5gKMKEc7ILNFfZEeDY2g0p+80Ng0YFKm86s12A=;
        b=Hc0TZw8V9kUoQhBxHydWKar/+hlP5+fMIsegDQtsK+vnqzKjYBdZs4o6vAwhcc1mTL
         1YhpCEvM/gCxikSD2JjSYdKTmHNaeiZhdLqk/eRLaa8/QDb5Wh4R+Tgi9UHu/B6Ktww4
         171agupHL2xq6Jx9mK8LWuHoNr4ejeRGzXM0M4GWakKrasZ3drhystOFW0q1aoMtU3Ym
         erwR7DxYCUm0pUHcomalUstC/T+fIG7LUbdMbqimlVGqUQJKUaDlZDZCbKU36GxAVSL2
         4HEQ1RElseVH5hbUUeIcJnazCWwy/n9cQjpIDumEEzsj9y/Rv9MBQ5zS1LXp8frLDkSQ
         7Kfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682021; x=1750286821;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I51DP5gKMKEc7ILNFfZEeDY2g0p+80Ng0YFKm86s12A=;
        b=YdVS+G6zC8MkWQlCetqH7k1hIavno/h34IX+mLGuqK8WMWQQbgOxqS+p2QILjIsVm3
         cy5IhdypadWNbiHzLhciGHXMDPVTrx8iYeaQSZRbhX+PX8T2G49bXdJv459571yEBe2m
         1TLxnN3pRfG7sSCzOgmxF8ZPxSx74uUqAMyxr6VR+1fPL9Zz40EM+Z4LkK4Lkxc4es4L
         gDyIW31H3+agHb/+fKOfEWRCs/IoUKnrOHK1ez0e6f/8Jc98mk40mPYL8ra6tHgcp9eY
         JZH7vsYFUOy6BGink1W5qfctAx6uVKl0nlV+fjTFaY+bdU0iQs0qD9e17qDlx4j+UYBx
         mCCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGPRjkXe6+KzhSDvYRdiqZHlUBei/UzD+1rFwgGI83mh5RPQ2LVgu19KHj/oFmN2OTszY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yws1rDJfwkeSo37tbqqUfZNF3f+o5xfBYrbuh+Drto1PnG2WDVd
	4HNBFL8uZEnpJYXYxYqt5Z2RC1zym1mz1TylpRk4HkqmDIMwXLX/WskKJsXv9//vRmy9dwT5QI7
	fbVf1XQ==
X-Google-Smtp-Source: AGHT+IHwXpNXkDTloFncKpBTTlOBc7cfmL8OdvApNP8cnZ+4+Hh5uII0rNHhd1AacQdbNKEw4+vWvuOjocw=
X-Received: from pfbbd32.prod.google.com ([2002:a05:6a00:27a0:b0:747:a8ac:ca05])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7350:b0:1fe:90c5:7d00
 with SMTP id adf61e73a8af0-21f9b938064mr718014637.28.1749682020789; Wed, 11
 Jun 2025 15:47:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:06 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-5-seanjc@google.com>
Subject: [PATCH v3 03/62] KVM: Pass new routing entries and irqfd when
 updating IRTEs
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

When updating IRTEs in response to a GSI routing or IRQ bypass change,
pass the new/current routing information along with the associated irqfd.
This will allow KVM x86 to harden, simplify, and deduplicate its code.

Since adding/removing a bypass producer is now conveniently protected with
irqfds.lock, i.e. can't run concurrently with kvm_irq_routing_update(),
use the routing information cached in the irqfd instead of looking up
the information in the current GSI routing tables.

Opportunistically convert an existing printk() to pr_info() and put its
string onto a single line (old code that strictly adhered to 80 chars).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c            |  7 ++++---
 arch/x86/include/asm/kvm_host.h |  6 ++++--
 arch/x86/kvm/svm/avic.c         | 18 +++++++----------
 arch/x86/kvm/svm/svm.h          |  5 +++--
 arch/x86/kvm/vmx/posted_intr.c  | 19 ++++++++---------
 arch/x86/kvm/vmx/posted_intr.h  |  8 ++++++--
 arch/x86/kvm/x86.c              | 36 ++++++++++++++++++---------------
 include/linux/kvm_host.h        |  7 +++++--
 virt/kvm/eventfd.c              | 11 +++++-----
 9 files changed, 62 insertions(+), 55 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 38a91bb5d4c7..a9a39e0375f7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2771,8 +2771,9 @@ bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
 	return memcmp(&old->msi, &new->msi, sizeof(new->msi));
 }
 
-int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
-				  uint32_t guest_irq, bool set)
+int kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
+				  struct kvm_kernel_irq_routing_entry *old,
+				  struct kvm_kernel_irq_routing_entry *new)
 {
 	/*
 	 * Remapping the vLPI requires taking the its_lock mutex to resolve
@@ -2781,7 +2782,7 @@ int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
 	 *
 	 * Unmap the vLPI and fall back to software LPI injection.
 	 */
-	return kvm_vgic_v4_unset_forwarding(kvm, host_irq);
+	return kvm_vgic_v4_unset_forwarding(irqfd->kvm, irqfd->producer->irq);
 }
 
 void kvm_arch_irq_bypass_stop(struct irq_bypass_consumer *cons)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 21ccb122ab76..2a6ef1398da7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -296,6 +296,7 @@ enum x86_intercept_stage;
  */
 #define KVM_APIC_PV_EOI_PENDING	1
 
+struct kvm_kernel_irqfd;
 struct kvm_kernel_irq_routing_entry;
 
 /*
@@ -1844,8 +1845,9 @@ struct kvm_x86_ops {
 	void (*vcpu_blocking)(struct kvm_vcpu *vcpu);
 	void (*vcpu_unblocking)(struct kvm_vcpu *vcpu);
 
-	int (*pi_update_irte)(struct kvm *kvm, unsigned int host_irq,
-			      uint32_t guest_irq, bool set);
+	int (*pi_update_irte)(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
+			      unsigned int host_irq, uint32_t guest_irq,
+			      struct kvm_kernel_irq_routing_entry *new);
 	void (*pi_start_assignment)(struct kvm *kvm);
 	void (*apicv_pre_state_restore)(struct kvm_vcpu *vcpu);
 	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 7338879d1c0c..adacf00d6664 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -18,6 +18,7 @@
 #include <linux/hashtable.h>
 #include <linux/amd-iommu.h>
 #include <linux/kvm_host.h>
+#include <linux/kvm_irqfd.h>
 
 #include <asm/irq_remapping.h>
 
@@ -885,21 +886,14 @@ get_pi_vcpu_info(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
 	return 0;
 }
 
-/*
- * avic_pi_update_irte - set IRTE for Posted-Interrupts
- *
- * @kvm: kvm
- * @host_irq: host irq of the interrupt
- * @guest_irq: gsi of the interrupt
- * @set: set or unset PI
- * returns 0 on success, < 0 on failure
- */
-int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
-			uint32_t guest_irq, bool set)
+int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
+			unsigned int host_irq, uint32_t guest_irq,
+			struct kvm_kernel_irq_routing_entry *new)
 {
 	struct kvm_kernel_irq_routing_entry *e;
 	struct kvm_irq_routing_table *irq_rt;
 	bool enable_remapped_mode = true;
+	bool set = !!new;
 	int idx, ret = 0;
 
 	if (!kvm_arch_has_assigned_device(kvm) || !kvm_arch_has_irq_bypass())
@@ -925,6 +919,8 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 		if (e->type != KVM_IRQ_ROUTING_MSI)
 			continue;
 
+		WARN_ON_ONCE(new && memcmp(e, new, sizeof(*new)));
+
 		/**
 		 * Here, we setup with legacy mode in the following cases:
 		 * 1. When cannot target interrupt to a specific vcpu.
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e6f3c6a153a0..b35fce30d923 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -736,8 +736,9 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void avic_vcpu_put(struct kvm_vcpu *vcpu);
 void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu);
 void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
-int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
-			uint32_t guest_irq, bool set);
+int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
+			unsigned int host_irq, uint32_t guest_irq,
+			struct kvm_kernel_irq_routing_entry *new);
 void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
 void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void avic_ring_doorbell(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 5c615e5845bf..110fb19848ab 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -2,6 +2,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kvm_host.h>
+#include <linux/kvm_irqfd.h>
 
 #include <asm/irq_remapping.h>
 #include <asm/cpu.h>
@@ -294,17 +295,9 @@ void vmx_pi_start_assignment(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_UNBLOCK);
 }
 
-/*
- * vmx_pi_update_irte - set IRTE for Posted-Interrupts
- *
- * @kvm: kvm
- * @host_irq: host irq of the interrupt
- * @guest_irq: gsi of the interrupt
- * @set: set or unset PI
- * returns 0 on success, < 0 on failure
- */
-int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
-		       uint32_t guest_irq, bool set)
+int vmx_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
+		       unsigned int host_irq, uint32_t guest_irq,
+		       struct kvm_kernel_irq_routing_entry *new)
 {
 	struct kvm_kernel_irq_routing_entry *e;
 	struct kvm_irq_routing_table *irq_rt;
@@ -312,6 +305,7 @@ int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 	struct kvm_lapic_irq irq;
 	struct kvm_vcpu *vcpu;
 	struct vcpu_data vcpu_info;
+	bool set = !!new;
 	int idx, ret = 0;
 
 	if (!vmx_can_use_vtd_pi(kvm))
@@ -329,6 +323,9 @@ int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 	hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
 		if (e->type != KVM_IRQ_ROUTING_MSI)
 			continue;
+
+		WARN_ON_ONCE(new && memcmp(e, new, sizeof(*new)));
+
 		/*
 		 * VT-d PI cannot support posting multicast/broadcast
 		 * interrupts to a vCPU, we still use interrupt remapping
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 80499ea0e674..a94afcb55f7f 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -3,6 +3,9 @@
 #define __KVM_X86_VMX_POSTED_INTR_H
 
 #include <linux/bitmap.h>
+#include <linux/find.h>
+#include <linux/kvm_host.h>
+
 #include <asm/posted_intr.h>
 
 void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu);
@@ -11,8 +14,9 @@ void pi_wakeup_handler(void);
 void __init pi_init_cpu(int cpu);
 void pi_apicv_pre_state_restore(struct kvm_vcpu *vcpu);
 bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
-int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
-		       uint32_t guest_irq, bool set);
+int vmx_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
+		       unsigned int host_irq, uint32_t guest_irq,
+		       struct kvm_kernel_irq_routing_entry *new);
 void vmx_pi_start_assignment(struct kvm *kvm);
 
 static inline int pi_find_highest_vector(struct pi_desc *pi_desc)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 28a20f0aa3dd..93711a5ef272 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13507,31 +13507,31 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
 	struct kvm *kvm = irqfd->kvm;
-	int ret;
+	int ret = 0;
 
 	kvm_arch_start_assignment(irqfd->kvm);
 
 	spin_lock_irq(&kvm->irqfds.lock);
 	irqfd->producer = prod;
 
-	ret = kvm_x86_call(pi_update_irte)(irqfd->kvm,
-					   prod->irq, irqfd->gsi, 1);
-	if (ret)
-		kvm_arch_end_assignment(irqfd->kvm);
-
+	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
+		ret = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, prod->irq,
+						   irqfd->gsi, &irqfd->irq_entry);
+		if (ret)
+			kvm_arch_end_assignment(irqfd->kvm);
+	}
 	spin_unlock_irq(&kvm->irqfds.lock);
 
-
 	return ret;
 }
 
 void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 				      struct irq_bypass_producer *prod)
 {
-	int ret;
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
 	struct kvm *kvm = irqfd->kvm;
+	int ret;
 
 	WARN_ON(irqfd->producer != prod);
 
@@ -13544,11 +13544,13 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	spin_lock_irq(&kvm->irqfds.lock);
 	irqfd->producer = NULL;
 
-	ret = kvm_x86_call(pi_update_irte)(irqfd->kvm,
-					   prod->irq, irqfd->gsi, 0);
-	if (ret)
-		printk(KERN_INFO "irq bypass consumer (token %p) unregistration"
-		       " fails: %d\n", irqfd->consumer.token, ret);
+	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
+		ret = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, prod->irq,
+						   irqfd->gsi, NULL);
+		if (ret)
+			pr_info("irq bypass consumer (token %p) unregistration fails: %d\n",
+				irqfd->consumer.token, ret);
+	}
 
 	spin_unlock_irq(&kvm->irqfds.lock);
 
@@ -13556,10 +13558,12 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	kvm_arch_end_assignment(irqfd->kvm);
 }
 
-int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
-				   uint32_t guest_irq, bool set)
+int kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
+				  struct kvm_kernel_irq_routing_entry *old,
+				  struct kvm_kernel_irq_routing_entry *new)
 {
-	return kvm_x86_call(pi_update_irte)(kvm, host_irq, guest_irq, set);
+	return kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, irqfd->producer->irq,
+					    irqfd->gsi, new);
 }
 
 bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3b5575d0b574..a4160c1c0c6b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2401,6 +2401,8 @@ struct kvm_vcpu *kvm_get_running_vcpu(void);
 struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
 
 #if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
+struct kvm_kernel_irqfd;
+
 bool kvm_arch_has_irq_bypass(void);
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *,
 			   struct irq_bypass_producer *);
@@ -2408,8 +2410,9 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *,
 			   struct irq_bypass_producer *);
 void kvm_arch_irq_bypass_stop(struct irq_bypass_consumer *);
 void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *);
-int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
-				  uint32_t guest_irq, bool set);
+int kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
+				  struct kvm_kernel_irq_routing_entry *old,
+				  struct kvm_kernel_irq_routing_entry *new);
 bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *,
 				  struct kvm_kernel_irq_routing_entry *);
 #endif /* CONFIG_HAVE_KVM_IRQ_BYPASS */
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 11e5d1e3f12e..85581550dc8d 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -285,9 +285,9 @@ void __attribute__((weak)) kvm_arch_irq_bypass_start(
 {
 }
 
-int  __attribute__((weak)) kvm_arch_update_irqfd_routing(
-				struct kvm *kvm, unsigned int host_irq,
-				uint32_t guest_irq, bool set)
+int __weak kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
+					 struct kvm_kernel_irq_routing_entry *old,
+					 struct kvm_kernel_irq_routing_entry *new)
 {
 	return 0;
 }
@@ -619,9 +619,8 @@ void kvm_irq_routing_update(struct kvm *kvm)
 #if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
 		if (irqfd->producer &&
 		    kvm_arch_irqfd_route_changed(&old, &irqfd->irq_entry)) {
-			int ret = kvm_arch_update_irqfd_routing(
-					irqfd->kvm, irqfd->producer->irq,
-					irqfd->gsi, 1);
+			int ret = kvm_arch_update_irqfd_routing(irqfd, &old, &irqfd->irq_entry);
+
 			WARN_ON(ret);
 		}
 #endif
-- 
2.50.0.rc1.591.g9c95f17f64-goog


