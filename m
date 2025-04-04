Return-Path: <kvm+bounces-42689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6920A7C3FE
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:40:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9704B1B60C2E
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6926922172B;
	Fri,  4 Apr 2025 19:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HXkQ8Wus"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00B5221542
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795594; cv=none; b=jMa+PXL9W86OYa49sgkd/WMl5Kn57cjKQVq2+3bEgwAtqYBHFiEn0v0aIoZDNjVbKYjPYGi2ratMoJ8vFGY+OhqCD9j0uVR2+IpYfHJOWr4Wah1h+p6zDkcbjqnyir8RTb9DgmRZ+fURrpFyVDwUQ8jC1J56irdf3FBX78uHrq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795594; c=relaxed/simple;
	bh=PLM9Oe14dNa7pkRo4U5ot9bvtj2ZhI28uVdi+hfPu3s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ie819QVswa48tfD4C5Ua97Ax0xKa/ehM2Xuwi9Zp5Ep2AViO0/jNW+skLVkCLmE96Lp3lERpLgQkkBUJmTYR518DhmGJeDSoxMaA5eHRwNmkHaGxs9UvGKf/wMyXPEjwhzsLwfgyO2M0PWaZH5BTtqhGaoZDlRcgp4K4omofqYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HXkQ8Wus; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736a7d0b82fso2991469b3a.1
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795592; x=1744400392; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+47iTNmbRmU5QNEmm30tIBdVVPpOMLVIBC3EbiK88yI=;
        b=HXkQ8WusVtNyqJRuw9YftPjh9IbqYPb5v+Lp+h9daVRcLLpmjULUtStdDtFP5EZ6Hj
         dHM2BTEJV8j/+OqESK3SVqcyD6bDstSXUQaYVSJ0jdwdyYNG1FTeU/U+Ct2/z9SrqMGW
         d+xchWymjdErk02Li73i+6RQ/xCzCDYNDpqgkvhPGxA5Nl70Ks3490lGmhRT4yLKK4QR
         citoaVrw2LqsOkyNgM2mVJOGu9OHq0jD2nOh/JlScWdIRD9Qg0flzfQTXRhSYdxVoJ5a
         k31JSsiLhMZjn5hnXVZEcP+Nan3zu1P1IKhdEtT4JJrwsF9Fg+Qo7OEgQDlKR1ZocP85
         9A4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795592; x=1744400392;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+47iTNmbRmU5QNEmm30tIBdVVPpOMLVIBC3EbiK88yI=;
        b=MkN7gGKRYhyFMSWllrJDFMZMDnKlpSLBRsXqMLV/P10+HG6ka8D0FPyk2QK+d5MW8W
         PMQBgGxJGkyyROKF3uQV9gVQHKIIQ2vyLOtW3Kdbmh1jyS9zCupT0IaL3o6oL5d01UyP
         oUUAqGQ9mpdhy6ioJYi0Gt0G+s+EumWknYONmUZl1+cPKOXxgZIzfKPO7Qhy3gOocNbU
         3LQKy9yxOMAr9gSX8Rakm8pdDu0tRF+PPSMiI8VhD5EPxOjKbe8rUvXc8uJbDe9nHcxT
         M78SWxV+u3rd0JJufqllUJkwLzeBewhZvBbSN9hKAIBGuyL1qPDlJihU15t63BTBwdlL
         dkHA==
X-Gm-Message-State: AOJu0YyouFHsYUIe3EXOszMp+Ix/Ue5Npgp9U4LnxfBjow+6vnFaIE5P
	KeB6TNW3QzAFnA4BJxodo8ZVEot0vRsaWu0NdNF9843IVZvb5hfpBlYplo9bJ/Te9+ZUvVTn8/O
	bRg==
X-Google-Smtp-Source: AGHT+IHIboGmLY9qchPfpX/OHkXoE4myUPKEgmdV2feQwjMagq50m8siYeTr/9yoolpfmy2JLnd8BDCKG1I=
X-Received: from pfbln13.prod.google.com ([2002:a05:6a00:3ccd:b0:732:20df:303c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1897:b0:730:95a6:3761
 with SMTP id d2e1a72fcca58-739e6fcbcebmr6002912b3a.3.1743795592333; Fri, 04
 Apr 2025 12:39:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:18 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-4-seanjc@google.com>
Subject: [PATCH 03/67] KVM: x86: Explicitly treat routing entry type changes
 as changes
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly treat type differences as GSI routing changes, as comparing MSI
data between two entries could get a false negative, e.g. if userspace
changed the type but left the type-specific data as-is.

Fixes: 515a0c79e796 ("kvm: irqfd: avoid update unmodified entries of the routing")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9211344b20ae..f94f1217a087 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13615,7 +13615,8 @@ int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
 bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
 				  struct kvm_kernel_irq_routing_entry *new)
 {
-	if (new->type != KVM_IRQ_ROUTING_MSI)
+	if (old->type != KVM_IRQ_ROUTING_MSI ||
+	    new->type != KVM_IRQ_ROUTING_MSI)
 		return true;
 
 	return !!memcmp(&old->msi, &new->msi, sizeof(new->msi));
-- 
2.49.0.504.g3bcea36a83-goog


