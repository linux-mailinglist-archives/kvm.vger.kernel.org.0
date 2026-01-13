Return-Path: <kvm+bounces-67970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 991C7D1AB7D
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 18:47:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 26F4F3067DEC
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 17:46:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CD5C392817;
	Tue, 13 Jan 2026 17:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SpRKCRan"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF4F34E74F
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 17:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768326378; cv=none; b=dZmrYdD/gAq7F+2YMvkuX8Y0EcoiUgV/VfGcOxOe/gS0v6wN9ux3TICw4OzoNAe4yyd/N9gtk8/KpW4Ohn1+VXRTGeej+sLwBeQcJFugGOISe4W5T0jVF2yb/h+O9JgByq41gGQvt0LH5xQNUsXGyzRkdcUIFvRLF4tjxlPLUjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768326378; c=relaxed/simple;
	bh=s5qcLLCVA2jY5aqc6PFjcFhBKKWoGxB3OeqfS/8L/6Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vb/8KswMi1Keklku0qWH5656mXgXkf0muXOcVhxrvfZxQe53iD9rb7T9ZDFgye83QH/dqVTYRa7quEJKxdYZVn7rnAtZX0tS7QrnyC8zTMNQdgflsWUufuvZRaOrd8QAFF+UUCoLzJCjG84AHzKNdTWiXBVSfQxd2sfv8uMUH8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SpRKCRan; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c21341f56so15661808a91.2
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 09:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768326373; x=1768931173; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4CraqsN8zUJ5wBwG4fLZa6cryGuFuoNdJFyZA+YKRFU=;
        b=SpRKCRanEHotWFCcqHWl2eyBDcwEKGMSL6NQ3y6VlkwNt4Ax3J7rTKdEl8zTZpkbi9
         beI5ieytXaJE7RNb7FJ7dlQvSdcUFK8+j2fJdAc+QVrs+qfqf9Rvm3pL61VcyXcqb1Vb
         fLg+bfJB0W7cS34VHf6sCVevMCBSGo5LmaKjxKnX8a5Y3wxt8nbEs0T6PVhOecN/p90m
         JQzOu+FKP9q/+wjcIBus08Sx/t9qd3GB5MafqNU8vb2EtktTJpuveIN7OqMCGZyP2ENf
         UyP644FMxiAMskUcYV6I5SJumqXtbTFeA3Yr42cNPnZASFpdVQsH421XWwzWZHgINpsC
         OIDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768326373; x=1768931173;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4CraqsN8zUJ5wBwG4fLZa6cryGuFuoNdJFyZA+YKRFU=;
        b=gbtwMO3iYzEa8F5/K+Vno2U6BhbEh++Az9mmKXws3sa/wyapNUp3ehNd5rrCaKX4e5
         K6pb6E6xMZ/tZXRq8+WSKM0Ty1Dqlp9ocUxx6ma4UUOPwLyVwSLNaZNai6otepOO3n0M
         pkHigJi1QmoaVcqC9dHb3Od9+neKFcRId+kSJGDnMLL465fZCTJVRYartmcJuyFq6FKy
         PyQ6+X36R6ggKrN5KvG/bD/dh+Nhzmz0Ki1rxJskp3tt+rSRDuEF8BricD8QcSNWS8UC
         ga3CnirFXwME0l/Tr3Gf5CEgbFl/H/j08k1iOMaDepkQz+U+QtblvzQD/IL92R9D9HaM
         bgnQ==
X-Gm-Message-State: AOJu0YxT5aeOj3kVyMebOSSBz2yobx9MVOwZ9s+coCyq6fpdLKLKIfnR
	ca26YIBv9jNEoXp4X59pkcdjWWKlae67TC/xbQsCQjLm63pWi08L0Mbykpkuz1T+zcyzDu7lfNG
	UVHZjkg==
X-Google-Smtp-Source: AGHT+IEjY7ADT1ZxCtwPjnM/2bCNCF/Z7AnwYEw5eULnlRYie/qAccGeg6dWSK+Wosg2sEorAm0VWPbWFKQ=
X-Received: from pjty24.prod.google.com ([2002:a17:90a:ca98:b0:34a:6f9f:4531])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:568d:b0:34a:a65e:e6ad
 with SMTP id 98e67ed59e1d1-34f68c32ae0mr19229737a91.1.1768326372671; Tue, 13
 Jan 2026 09:46:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 13 Jan 2026 09:46:06 -0800
In-Reply-To: <20260113174606.104978-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113174606.104978-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113174606.104978-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: x86: Assert that non-MSI doesn't have bypass vCPU
 when deleting producer
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"

When disconnecting a non-MSI irqfd from an IRQ bypass producer, WARN if
the irqfd is configured for IRQ bypass and set its IRTE back to remapped
mode to harden against kernel/KVM bugs (keeping the irqfd in bypass mode
is often fatal to the host).

Deactivating an irqfd (removing it from the list of irqfds), updating
irqfd routes, and the code in question are all mutually exclusive (all
run under irqfds.lock).  If an irqfd is configured for bypass, and the
irqfd is deassigned at the same time IRQ routing is updated (to change the
routing to non-MSI), then either kvm_arch_update_irqfd_routing() should
process the irqfd routing change and put the IRTE into remapped mode
(routing update "wins"), or kvm_arch_irq_bypass_del_producer() should see
the MSI routing info (deactivation "wins").

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index a52115441c07..9519fec09ee6 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -514,7 +514,8 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	 */
 	spin_lock_irq(&kvm->irqfds.lock);
 
-	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
+	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI ||
+	    WARN_ON_ONCE(irqfd->irq_bypass_vcpu)) {
 		ret = kvm_pi_update_irte(irqfd, NULL);
 		if (ret)
 			pr_info("irq bypass consumer (eventfd %p) unregistration fails: %d\n",
-- 
2.52.0.457.g6b5491de43-goog


