Return-Path: <kvm+bounces-42723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73BBFA7C45D
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:59:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 840A97A86D1
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 057552309A8;
	Fri,  4 Apr 2025 19:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UE+4Io9/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDF522F3A8
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795652; cv=none; b=X6fY4hgs1RQiIMTy+ueY0T+mFXNMNh8MzQAHYP41IYJjXaeq92gotZS5YD0JSQim5sLgwv9ILMJuhXMMrsxJ7X4NPQyHVkoHeroOg0YzBNMIeAIhQ4w0GJoNN9MOyuXT3EwpUhnF6xXMbtl45q9KJQjJnZhDhOka4MOofvO2YOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795652; c=relaxed/simple;
	bh=7/g8u2TqM7J8Cn/U12YGDIH4z8F9epXVF7IH/1LlmGo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G8GdytYxpykkV62NnGgY4/ZJlNkpp4dV0BR21VKuvXPNJYIQTCMzo4GSecWPMuo9kr/fYFNgqyiPFA/nFnhaJCLib1/MrIYPre07+Vyqv3U3LdQLxCvJRZoeXg3ibYoAj5HC9phjrdV7GCGtqLAiKV4zjQpsvTN/Ar6ZaPMKMvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UE+4Io9/; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736c7d0d35aso3406154b3a.1
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795650; x=1744400450; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SjSWA34yg4j7nAkSg9OWc1nxrjTv2EBF262ygp4BvLg=;
        b=UE+4Io9/+SEz4Iv0RtegKSYtIvcGTSQO0yqbJUzm4RF8CtPis9YlL7fax36VeLk9Fs
         SXUTfLWrFoxRGXhwEfNNmybamkhlxgChcHbLghKsVFWFL8ChIZpUIYRQNi+v6+69xOux
         OBAUV/45HPdnMIXnVCuPmPUGmOVz2qqDBhxDT0cHX9pasaPnE2Fi2/GPJfM2gmJp94/p
         p5zDc4LsLq3dn4sQ8qdUnMwuzZb3zidlobgp9BSDY9WbPbAxm488VKV+AKuhm7lTndtd
         S2CzLyRQ1/terZxUjcbwAc/umHd3wMK0kTb6N3JpK3ROBsj4PUxmISBLPgwywfbRe6N6
         nF1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795650; x=1744400450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SjSWA34yg4j7nAkSg9OWc1nxrjTv2EBF262ygp4BvLg=;
        b=qNBP6nDNwx3eWDpJH/2u0IJ1RUajOHgLgYcMKqQ8Zk8tM8q8IUcTpeMSjOiMh4b2h2
         fGHYuzjs7njqgcnUfNMJ4IhkSl4Aaja1WZEzwBqWxPF4bD+IDVVGeJvJ7dhcFgERwLFJ
         tLc5L+Jmc78NRu/ciej02qyl7/gDOhc3FCbXh56HP0w5XHfEfWRJtX3ZYVuYgTHx7ZMW
         DfLBPwo/HRB5xyJmg7teinw2CXI36Xn9KSGlZBSUHDEZ8CH82RpcSiMppsl9M0hVN7RV
         9XuKyowmljyhb/iZJYZeWyUevLBkiWAQux1g0QJO5DoHHHeSh1vWvSAjW6bm7OHGOdwF
         84Aw==
X-Gm-Message-State: AOJu0Yws3m0IffTGPq+IThph2SpUhexBYNfP8N4qZX2JWRkeFf/OXj0x
	AXhuMbsm+xlk9stz4UMTRv8O3L+INXesccl7MONqF5I0qXnRPHhe5tqqcdvB94qwl80J7yBJkF2
	TiQ==
X-Google-Smtp-Source: AGHT+IHbhyhf2PL38jR1CfEUWzgJOUIR/lwrsr+RqHeIsaC+HvnuthN2QMdbVQyQ8EZYibpHmZF2PVBlImU=
X-Received: from pfud4.prod.google.com ([2002:a05:6a00:10c4:b0:739:8c87:ed18])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a04:b0:736:3e50:bfec
 with SMTP id d2e1a72fcca58-73b6aa3d9b9mr864255b3a.8.1743795650653; Fri, 04
 Apr 2025 12:40:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:52 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-38-seanjc@google.com>
Subject: [PATCH 37/67] KVM: Don't WARN if updating IRQ bypass route fails
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't bother WARNing if updating an IRTE route fails now that vendor code
provides much more precise WARNs.  The generic WARN doesn't provide enough
information to actually debug the problem, and has obviously done nothing
to surface the myriad bugs in KVM's implementation.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c       |  8 ++++----
 include/linux/kvm_host.h |  6 +++---
 virt/kvm/eventfd.c       | 15 ++++++---------
 3 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a20d461718cc..c2c102f23fa7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13666,11 +13666,11 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	kvm_arch_end_assignment(irqfd->kvm);
 }
 
-int kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
-				  struct kvm_kernel_irq_routing_entry *old,
-				  struct kvm_kernel_irq_routing_entry *new)
+void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
+				   struct kvm_kernel_irq_routing_entry *old,
+				   struct kvm_kernel_irq_routing_entry *new)
 {
-	return kvm_pi_update_irte(irqfd, old, new);
+	kvm_pi_update_irte(irqfd, old, new);
 }
 
 bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2d9f3aeb766a..7e8f5cb4fc9a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2392,9 +2392,9 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *,
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
index ad71e3e4d1c3..7ccdaa4071c8 100644
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
 
 #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
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
2.49.0.504.g3bcea36a83-goog


