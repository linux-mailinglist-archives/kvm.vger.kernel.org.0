Return-Path: <kvm+bounces-47481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CA16AC1943
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:09:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDF511C05CE3
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC6F7286D5E;
	Fri, 23 May 2025 01:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WxrI960j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C02227F178
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962065; cv=none; b=U9rMF5WIWJKfOcOzEB/75yO7QtwO7Xc16vHUZardPFvme5987JcoHwi7ToMp1PtAeoDqguM8V6jS0EvpyvOeeft8LA5EM8/zjrRDokA8/a7NAvqfdjC9IpSkDiS7vG35gdreddxzF4/L3no75Dje8KFb9J5TM275vlWbChcNto0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962065; c=relaxed/simple;
	bh=myxsKIMu9z2uOdqZo9sjfpCseSVPuh0CYv0CumURj6M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ULNN0exFKEYwoS9z2aDx39ii1Wg8+ww32LCZMbvU+Gmh7fCs0TtfGlA8PtNVb/3OiQ2gKZsYGlehYeNAAcV5NGiWJUd9T1gw5N5WpjsUur9RIman0ABWTG5c0tnsfheKazHt9scryR3z1t8fWakTGyQTSiZBUCBNWvm36emgLHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WxrI960j; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30a59538b17so7880686a91.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962063; x=1748566863; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Z6qJrl8moJt7bfJRd6rO8Y2MTdMUnxYZYEX7kVfA4zY=;
        b=WxrI960jyZ6SxgFMcPlvfOPhWWcpQcZ8rNwoiMFkS1ofqeoAPzb2uF7fCnV1Q6+XlH
         KqcBI/U1KC5ndGSWLSX+oAOTcQ0EWz00n+pUFFYgIuT982olZaxT36FFwQRBOMWoYxbN
         jIRMMFp+WLPjqDdpYcrzU+4vUGwpeEXJ1mwO4/HJFBQXCRK5c8RKbR4LIQdzlrwlK3cH
         ZaQJY9+qiiPomtADVDuTE2AH7fA0aBbqqoT730LkJxDh6KCtxM3rYPyeE0P21oewYnNe
         cQuE9jvAkdyfc7iTOC0DqHx8FEOuaxF3XklAoHsNR4fnE8oS8aK3h17XLUqVXMGip5aG
         9kpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962063; x=1748566863;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z6qJrl8moJt7bfJRd6rO8Y2MTdMUnxYZYEX7kVfA4zY=;
        b=wObwY5eLTXjZ2ITWeMYGA+/Z3nwEoZoAro9d+hFFCcACru35lV52oR0Z3zJexIBDZV
         JdAGZpM+8HAu0XUYIMhKT4WnaYMNh14sdZcOV3VE6gLfyd8Vj6JWrlEc9+DIXfa1rmye
         WOEUcWz8wEjIXF4PrEN26Q/VKvWm2Gp/OEExEffTuoCrWSotvqliCMNiMeKry55+2CLq
         c901IXWA69cYlcjPKCDZKCo4DKtLTb0Y2Y22vdm0kOXJEu/w1Oz2EZ58goTPy0bmMl07
         FS15lR0JsygiGc75yA9Ul6XZx5u4nV+AWVlXrrR9MderGfj+bqOeVtJCD9dpwtyHV4is
         htcQ==
X-Gm-Message-State: AOJu0Yyx3i1Qsv4hGdU16tXmBxXyyouHo8u10Vpa3m+OW1Tx51c0whh8
	CXFzToaIcJecGIXap9VhJYE5z0Gch9Fi330030jeeEtwnKFhDfvhLHk5XRvuN12Y8HAVEBkgM2F
	fTtyo8A==
X-Google-Smtp-Source: AGHT+IHGd9AMcPRaXLw73jWmjjZZ11tSRCThxeyCURZKAbhkOZc/Mi2j9RJn55Hndx07vxGEYk1l0sThWdQ=
X-Received: from pjb7.prod.google.com ([2002:a17:90b:2f07:b0:2ff:6132:8710])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f8c:b0:2fc:3264:3666
 with SMTP id 98e67ed59e1d1-30e7d5be34bmr41066961a91.30.1747962062808; Thu, 22
 May 2025 18:01:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:36 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-32-seanjc@google.com>
Subject: [PATCH v2 31/59] KVM: Fold kvm_arch_irqfd_route_changed() into kvm_arch_update_irqfd_routing()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Fold kvm_arch_irqfd_route_changed() into kvm_arch_update_irqfd_routing().
Calling arch code to know whether or not to call arch code is absurd.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c       | 15 +++++----------
 include/linux/kvm_host.h |  2 --
 virt/kvm/eventfd.c       | 10 +---------
 3 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index b3ce870d1d91..582fc17ae02b 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -610,15 +610,10 @@ void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
 				   struct kvm_kernel_irq_routing_entry *old,
 				   struct kvm_kernel_irq_routing_entry *new)
 {
+	if (old->type == KVM_IRQ_ROUTING_MSI &&
+	    new->type == KVM_IRQ_ROUTING_MSI &&
+	    !memcmp(&old->msi, &new->msi, sizeof(new->msi)))
+		return;
+
 	kvm_pi_update_irte(irqfd, new);
 }
-
-bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
-				  struct kvm_kernel_irq_routing_entry *new)
-{
-	if (old->type != KVM_IRQ_ROUTING_MSI ||
-	    new->type != KVM_IRQ_ROUTING_MSI)
-		return true;
-
-	return !!memcmp(&old->msi, &new->msi, sizeof(new->msi));
-}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ee79b1167e02..706f2402ae8e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2409,8 +2409,6 @@ void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *);
 void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
 				   struct kvm_kernel_irq_routing_entry *old,
 				   struct kvm_kernel_irq_routing_entry *new);
-bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *,
-				  struct kvm_kernel_irq_routing_entry *);
 #endif /* CONFIG_HAVE_KVM_IRQ_BYPASS */
 
 #ifdef CONFIG_HAVE_KVM_INVALID_WAKEUPS
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index a4f80fe8a5f3..defc2c04d241 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -291,13 +291,6 @@ void __weak kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
 {
 
 }
-
-bool __attribute__((weak)) kvm_arch_irqfd_route_changed(
-				struct kvm_kernel_irq_routing_entry *old,
-				struct kvm_kernel_irq_routing_entry *new)
-{
-	return true;
-}
 #endif
 
 static int
@@ -617,8 +610,7 @@ void kvm_irq_routing_update(struct kvm *kvm)
 		irqfd_update(kvm, irqfd);
 
 #if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
-		if (irqfd->producer &&
-		    kvm_arch_irqfd_route_changed(&old, &irqfd->irq_entry))
+		if (irqfd->producer)
 			kvm_arch_update_irqfd_routing(irqfd, &old, &irqfd->irq_entry);
 #endif
 	}
-- 
2.49.0.1151.ga128411c76-goog


