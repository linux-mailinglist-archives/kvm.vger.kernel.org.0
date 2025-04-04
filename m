Return-Path: <kvm+bounces-42694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 20BDDA7C43E
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:55:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78363189AAF0
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:54:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C57D222592;
	Fri,  4 Apr 2025 19:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pVNQHgzM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C56D2222C6
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795603; cv=none; b=Ol/G3ANjvdnMRtF2w/G01jicbiv9+S1iXr7c6aiJFgyaK+2RaQ1M2AiQGOSei9SHoeWjOEtmmUbSZWaOYhoQ6wCfx+1hNjvbA3L7lcP/H0jzySWKGwMnlcwXByOW790d7Bwfwv6V8xDq04aTtxj/ImvY1T4SKaAvLRbeu4l2CAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795603; c=relaxed/simple;
	bh=XxKGAo5S/7chLOptC2l4Epw1k0hr0A2t8lxhQjwAc7g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p5EgNAlBi9Q71Q+iEYXwiGix7FkAAtkfQ68j97TkXl+7IPxiYThQq37nmoPBbH65XhbnrHU2HpWrJx+rjSCpwurHUa0s4EYE8k/cOT1kQfQPEtDmXVwWflySeH3GONTBQRJxjH2L7sbkzOp2Dt+xNKrVYrkja8U7SsXYqPFDEe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pVNQHgzM; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-af9070a5311so1485074a12.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795601; x=1744400401; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pR0smYfw7SLubbYd0Sbbpj1N3VRm1qYO6xSIljeIkxU=;
        b=pVNQHgzMFEUdgulgCmZnaexnvMOeIUKNaZG2Am6LLQw8jIiLkjOsSyBcNZv2DdPq1W
         nPFYij2PX5vbEg7agKViNxVJytURR92Ylqud+ncWkhLn45QMSvutNnKI+JG2V5YSBKCy
         Db5WU2NWCEJiQ8VfmcxiVMaNl8ueYqw6dHVMxXq10gr6dx1gRsMgIg3VK2jWEc66YpWL
         EBDCtj0BuLMAQbAstrdUfjfDi64i1I8xtwqMSImYTt/z/qV+FB54pi3gtRmlCzUpTAew
         Dgwk+96+e6SSpM+sCMVpEug/+63pNxlUEIv5Hr+gTaYabYhp/Aw4NhqI+tU/jP0ZXuI5
         S1uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795601; x=1744400401;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pR0smYfw7SLubbYd0Sbbpj1N3VRm1qYO6xSIljeIkxU=;
        b=Y8kh421Zdf+4qTRaTSZLgEQrNMnG/pNjPtbm8fSlSudjDkWC+gNeDeAnrKa6W6pYLZ
         jOWWtsO8zcpF/Wmd6NanTZ6N+p9ldTWrQYMDmRelHj0K6e40ouEISSOcz9YaQ0gBfQ5+
         Os1TP/c79gWCJG22bZH4gYgdj/58yQ6+gJky6+55Wt1ep2pJvEsCkzHy+qw9bhBAtWNl
         r08JRh6Xu/+BavOF4/evVAI90b6HPWC63iTX29JB+OKEggArDXGzCNfX+38EhRigK3jB
         XnAvYMwg71OkNICK66DPktIQi2L3r95YCN5rbrS8RnC+JpDbBw5CCHl6Xldrj2V7psWM
         DTWw==
X-Gm-Message-State: AOJu0YyonMUQvCYlJs1vkc8xJwiWIeb/QlUs4HDApDIHWx+yDhKnXjVt
	X0MzsgaYCxdTQTfT5gQJtIgOFbuN7UWicw4ymZoK3XoNPF+Ux2RlNFSHewhNEnTE2QS3oc9uvm0
	PHw==
X-Google-Smtp-Source: AGHT+IHQXM6RwHsmF3d6JVendNoGhD/BtEd7oD5dydB1hWqicx9/MPhQKis3fehg2sTG9mCKbtu2ZYHsxAA=
X-Received: from pjd8.prod.google.com ([2002:a17:90b:54c8:b0:2e9:ee22:8881])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f4c:b0:2ff:7b28:a51a
 with SMTP id 98e67ed59e1d1-306a48a4b89mr7615984a91.17.1743795600824; Fri, 04
 Apr 2025 12:40:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:23 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-9-seanjc@google.com>
Subject: [PATCH 08/67] KVM: x86: Pass new routing entries and irqfd when
 updating IRTEs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
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
 arch/x86/include/asm/kvm_host.h |  6 ++++--
 arch/x86/kvm/svm/avic.c         | 18 +++++++----------
 arch/x86/kvm/svm/svm.h          |  5 +++--
 arch/x86/kvm/vmx/posted_intr.c  | 19 ++++++++---------
 arch/x86/kvm/vmx/posted_intr.h  |  8 ++++++--
 arch/x86/kvm/x86.c              | 36 ++++++++++++++++++---------------
 include/linux/kvm_host.h        |  7 +++++--
 virt/kvm/eventfd.c              | 11 +++++-----
 8 files changed, 58 insertions(+), 52 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6e8be274c089..54f3cf73329b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -294,6 +294,7 @@ enum x86_intercept_stage;
  */
 #define KVM_APIC_PV_EOI_PENDING	1
 
+struct kvm_kernel_irqfd;
 struct kvm_kernel_irq_routing_entry;
 
 /*
@@ -1828,8 +1829,9 @@ struct kvm_x86_ops {
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
index 1708ea55125a..04dfd898ea8d 100644
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
index d4490eaed55d..294d5594c724 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -731,8 +731,9 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
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
index 78ba3d638fe8..1b6b655a2b8a 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -2,6 +2,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kvm_host.h>
+#include <linux/kvm_irqfd.h>
 
 #include <asm/irq_remapping.h>
 #include <asm/cpu.h>
@@ -259,17 +260,9 @@ void vmx_pi_start_assignment(struct kvm *kvm)
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
@@ -277,6 +270,7 @@ int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 	struct kvm_lapic_irq irq;
 	struct kvm_vcpu *vcpu;
 	struct vcpu_data vcpu_info;
+	bool set = !!new;
 	int idx, ret = 0;
 
 	if (!vmx_can_use_vtd_pi(kvm))
@@ -294,6 +288,9 @@ int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
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
index ad9116a99bcc..a586d6aaf862 100644
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
@@ -10,8 +13,9 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu);
 void pi_wakeup_handler(void);
 void __init pi_init_cpu(int cpu);
 bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
-int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
-		       uint32_t guest_irq, bool set);
+int vmx_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
+		       unsigned int host_irq, uint32_t guest_irq,
+		       struct kvm_kernel_irq_routing_entry *new);
 void vmx_pi_start_assignment(struct kvm *kvm);
 
 static inline int pi_find_highest_vector(struct pi_desc *pi_desc)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dcc173852dc5..23376fcd928c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13570,31 +13570,31 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
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
 
@@ -13607,11 +13607,13 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
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
 
@@ -13619,10 +13621,12 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
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
index 5438a1b446a6..2d9f3aeb766a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2383,6 +2383,8 @@ struct kvm_vcpu *kvm_get_running_vcpu(void);
 struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
 
 #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
+struct kvm_kernel_irqfd;
+
 bool kvm_arch_has_irq_bypass(void);
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *,
 			   struct irq_bypass_producer *);
@@ -2390,8 +2392,9 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *,
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
index 249ba5b72e9b..ad71e3e4d1c3 100644
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
 #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
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
2.49.0.504.g3bcea36a83-goog


