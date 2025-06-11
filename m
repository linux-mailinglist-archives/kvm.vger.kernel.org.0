Return-Path: <kvm+bounces-49196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F41F7AD636B
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 01:04:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69EBF1BC5978
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:03:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFE8F2EBDC9;
	Wed, 11 Jun 2025 22:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g3LYkxNJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445362EB5C2
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682104; cv=none; b=I0orr5Hytg1gzmfcIXs34H5kPmuxx28VYiPLikI0S/+yG7OHfoan9/WO7/m7hffkShjFs2sbmCxHPshmo42CvA74kct2jRHMHB5gt2Bq0mvZ6tNNYf00cm+kp03ZvUe29o2Iv2CdnJfhO05n6kzNOuuHBAGFj/QT0sLejejjqDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682104; c=relaxed/simple;
	bh=+BPYP7lpFhIXpD1YhlGCQAYJPvSe+MkxgYeLk60b/EQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cNHWfp24/MB0v7HCMFQr5nbs6Jg1RXFq92K9ZCuhvjOI3b+LscVifsDnl1fJU1YxVtcvUH5SDGDgAjzKaEx/72gqJtt1xiWOizNpdlkB22Tmksb3ncANjwTI+/wuPxri4foO1oUioZI1owDt0F4bweIstwEnsAMgw3EUNMH4Clc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g3LYkxNJ; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74880a02689so84442b3a.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682102; x=1750286902; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HFNzybZyx0Wu7yBkyufuhZBtndB539SrR/i7yvdQCgY=;
        b=g3LYkxNJBiRQShMD2c4njjGWsWP0dUSzb2q1GnywyNSaPPWzfLFtYt25Z46k+JlQuZ
         d3lsTaTPMxL+St1ZWlYkHylX3ngtHk4yEt4oS2mrE9QGE6zJNuZbaEjxu4iEsMZpWYiu
         PAMs9ZFhEkR6nSreKaGCaqDrVJtzDEF/dyPVevZ1Iy2ZNAZFZmB8G+mpMgZPw9OoMG90
         qOhHkcfOP1gEdtrLVVBcfvqVFoRhN5IQCrIxXjiXZZfRnw7wpfHyWCRDqEBNxw4J9+R/
         jKVpSZ9ucYQQYyJxdIe0bTx4g+Rl2HVbX9MIeLRMhaEvrdhOYr7szvKGmNvCl25hEnEC
         pWVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682102; x=1750286902;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HFNzybZyx0Wu7yBkyufuhZBtndB539SrR/i7yvdQCgY=;
        b=bYlJ5Xbxu8VMt6njKOYU7PrJQgt/GNkeeShyoFcfrGBWDJuvXYgRyTGZ0msTzOhkwA
         r7JXnRcM/P/lpYxZ8YWth4XUsJBu+zmppW/TJhrUBhk4J+BdyloWO/kUPV9XedOLJUS1
         XkBIlLhvJTgGaaTffClPvhzyL9zUOSZ92hIYsmwirVnj6E8kN9t6POZ/sAVNclEpklXh
         hR5uSUZONAB5gWMqTqs5bEes6SFuyRmiqkBgqq/Rn5aoo6P4rZJ/12k4Gjnx5XKt5fTb
         zoACwfSrO3xKWDeiIrdBIpq4M3gmaf/5vjNJlUfYmkdOGa5K8bX/QWTcVUoZd+hy+NrK
         +vKg==
X-Forwarded-Encrypted: i=1; AJvYcCXIfDHjA5hZ/pB5Lxj9QtVTTbkMVn0XXdBlzAbW9goV0+g2yuxBa2SbJwRkrjg9e4IFUNk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHnaq4OTSQHsyv5Vxt4pll95+qebKhTwOUrGcFjtjIJFfD+Eg5
	q9nj7+SgQOyoOcv0Xe9Gg+g0BX1eJJ9R45TOws9CXUFHx8A6wzwzKSzAjxEqUVo0N187dUR1rGL
	NE7/smA==
X-Google-Smtp-Source: AGHT+IEnvdDx8CXnODrzRbVPzUSjqGM5XPwQPio/AeEGGkkzZchdEypRUZqvj+dxhae05POY2+Y5SsikCKY=
X-Received: from pfbiv13.prod.google.com ([2002:a05:6a00:66cd:b0:736:38af:afeb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:92a0:b0:748:1bac:aff9
 with SMTP id d2e1a72fcca58-7486cbd90f4mr7663758b3a.18.1749682102554; Wed, 11
 Jun 2025 15:48:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:53 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-52-seanjc@google.com>
Subject: [PATCH v3 50/62] KVM: x86: WARN if IRQ bypass isn't supported in kvm_pi_update_irte()
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

WARN if kvm_pi_update_irte() is reached without IRQ bypass support, as the
code is only reachable if the VM already has an IRQ bypass producer (see
kvm_irq_routing_update()), or from kvm_arch_irq_bypass_{add,del}_producer(),
which, stating the obvious, are called if and only if KVM enables its IRQ
bypass hooks.

Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 45cb9f1ee618..9c03a67fedbe 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -517,7 +517,7 @@ static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
 	struct kvm_lapic_irq irq;
 	int r;
 
-	if (!irqchip_in_kernel(kvm) || !kvm_arch_has_irq_bypass())
+	if (!irqchip_in_kernel(kvm) || WARN_ON_ONCE(!kvm_arch_has_irq_bypass()))
 		return 0;
 
 	if (entry && entry->type == KVM_IRQ_ROUTING_MSI) {
-- 
2.50.0.rc1.591.g9c95f17f64-goog


