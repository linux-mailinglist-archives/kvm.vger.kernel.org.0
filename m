Return-Path: <kvm+bounces-42724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7478FA7C45B
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:58:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6130E3BCB15
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:57:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9E8022173C;
	Fri,  4 Apr 2025 19:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ETENYD6m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C8722FF37
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795654; cv=none; b=MkbSEN/BiiyINT9NM7/MQ0YEYU7Xfq43dlpeF//BmonwovnZw2fFeFTp8pe7RYWMlYYehogvk2uaWQCgk2rOxlkIYZNOahDmeL0NltD/eF/XO0VywIb+xt8izVBPGbdy6o2CIZY7AAvhjeW0qoSm9YAQ0S3aJ1kJQRXOw7PDGZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795654; c=relaxed/simple;
	bh=7OuU0INrb67bLssASox/0pk9s35pF8A3UD4uJddP1+8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ob6+lEtmgRf76Wv8CvIml0ikkSBmZC7eyk8CQW1A6AGZm5S+8bwMe6b02jQWdOHFCw/intqdbV+mqDJ9dUXd+0bl3PXYdWYs1SWjCx32Qm7CF2IaJrYZFn/a35EbsRPMeNZhYEUGx90QPOIQL9PWqi6kwPeWyN/zShrmD543HxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ETENYD6m; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736b431ee0dso1963869b3a.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795652; x=1744400452; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=to5q3LlJ1MsoyXzAExk8MPpf5aUTO++pOYAb5QB6TBk=;
        b=ETENYD6m6eGNFOVkDnt4PkFO8OGz61tNaMTwmfcdK17lJen4EuMqlgA37ITT9eOJJ9
         aR6p9EEVdOhv+5pq6RSTjsORxXnoTV/O56W9N/s5Dm8Lc8tZhk+dsjuI5kUpIGrZgKMH
         JttGowXcywKTNsI+YkUtrTlbKTvIX02WURz6KPdvD++AlxzRlPDVGA2PybXyekEXEa5d
         kgxIZmuMbKSTuRK5oVeiUk6/TBMwLFC5D3rjjzKF6JGF3L5cCRanxrkJV+VAvrscNKjZ
         sOLMVWL+KcX9XAuctTbLQxCB56QsY2lB7DLuEL6qlBDTur307DWlNyptXIHoQhDbhF2R
         gl8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795652; x=1744400452;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=to5q3LlJ1MsoyXzAExk8MPpf5aUTO++pOYAb5QB6TBk=;
        b=VKme6BcthPQEx2DqAwVKoUzCEuh4G/AkcHFrrKHFVyw0q2T0xT0TnJzvCsOq1EPMpP
         h75+cXm5ejKIxAs810Adc+EVyqnqk4FJTCtQQRiub+4Ah3Vatd5FTRYxtSXFZuEzKbEj
         Bnh1LB9+umP3PNpDFP8ro7XpIeMbxUjAhRtznZ+Ra4IySzej496Yihx4HYCOZVRS0+Q4
         9zPOaYdCJmW41OddNcrEhC3izShHPNXoDLbW49Wt41U/gsRX6NKRLx2NTcpS+1BYctG3
         bqoB4JVj7v+puHCvT5xcSjA1aCGNqUBh4GqTnRrtHkzQcJ7AXj2gFdlHxfuxVO3leUUX
         mNOA==
X-Gm-Message-State: AOJu0YwYTMPLtdbajjjGLmnJNzwrl8j0lM1tv64k4P8FOH0m7ePXAKIj
	1cXCaAj8wwnpz6bLAVVjAVBKBZge0p78ionM5EB/rYXcWMXMde+NXhZxRPhzPPMXPkOLhcCTEzH
	kkQ==
X-Google-Smtp-Source: AGHT+IFBZzBWaHbwwFG6Bp3HiVISkrZHpjTmYRH9gm8aunapY90POvgNg06gKNVSWknhYJ3e06jWFbrM4bY=
X-Received: from pfiu14.prod.google.com ([2002:a05:6a00:124e:b0:736:af6b:e58d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1701:b0:736:ab1d:83c4
 with SMTP id d2e1a72fcca58-739e46ba78cmr5647788b3a.0.1743795652384; Fri, 04
 Apr 2025 12:40:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:53 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-39-seanjc@google.com>
Subject: [PATCH 38/67] KVM: Fold kvm_arch_irqfd_route_changed() into kvm_arch_update_irqfd_routing()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Fold kvm_arch_irqfd_route_changed() into kvm_arch_update_irqfd_routing().
Calling arch code to know whether or not to call arch code is absurd.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c       | 15 +++++----------
 include/linux/kvm_host.h |  2 --
 virt/kvm/eventfd.c       | 10 +---------
 3 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c2c102f23fa7..36d4a9ed144d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13670,19 +13670,14 @@ void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
 				   struct kvm_kernel_irq_routing_entry *old,
 				   struct kvm_kernel_irq_routing_entry *new)
 {
+	if (old->type == KVM_IRQ_ROUTING_MSI &&
+	    new->type == KVM_IRQ_ROUTING_MSI &&
+	    !memcmp(&old->msi, &new->msi, sizeof(new->msi)))
+		return;
+
 	kvm_pi_update_irte(irqfd, old, new);
 }
 
-bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
-				  struct kvm_kernel_irq_routing_entry *new)
-{
-	if (old->type != KVM_IRQ_ROUTING_MSI ||
-	    new->type != KVM_IRQ_ROUTING_MSI)
-		return true;
-
-	return !!memcmp(&old->msi, &new->msi, sizeof(new->msi));
-}
-
 bool kvm_vector_hashing_enabled(void)
 {
 	return vector_hashing;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7e8f5cb4fc9a..d1a41c40ae79 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2395,8 +2395,6 @@ void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *);
 void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
 				   struct kvm_kernel_irq_routing_entry *old,
 				   struct kvm_kernel_irq_routing_entry *new);
-bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *,
-				  struct kvm_kernel_irq_routing_entry *);
 #endif /* CONFIG_HAVE_KVM_IRQ_BYPASS */
 
 #ifdef CONFIG_HAVE_KVM_INVALID_WAKEUPS
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 7ccdaa4071c8..b9810c3654f5 100644
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
 
 #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
-		if (irqfd->producer &&
-		    kvm_arch_irqfd_route_changed(&old, &irqfd->irq_entry))
+		if (irqfd->producer)
 			kvm_arch_update_irqfd_routing(irqfd, &old, &irqfd->irq_entry);
 #endif
 	}
-- 
2.49.0.504.g3bcea36a83-goog


