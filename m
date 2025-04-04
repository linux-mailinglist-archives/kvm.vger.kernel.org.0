Return-Path: <kvm+bounces-42744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC270A7C417
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:49:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EBDE37A54C8
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37F4F24DFFC;
	Fri,  4 Apr 2025 19:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N6vMQf7Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB45221F32
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795689; cv=none; b=t7AfIu+DULmJe6/jGUWwwgFf7n/hgyCOnoXTeZ9PNrCYapmkcb4ABA98tFXFYaDn1R/dSW8BDfFiPrJNA7g67mXwqlKD338kNcYfqgBpEP+5bqK0VKDuBDoy0awQxaGyJi26zl/rx/WqwwFxUSqW/gMG8s/yXuITAyL84Af9q80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795689; c=relaxed/simple;
	bh=oILWHlZoymAyC2X3yedwJsSZpaT6PkdFe55df8DN2A8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lL2xADxif2HfzeKz6pfOeAEY9/NRyC0WA4wkh4Ow4gAoxByUgFVqSEutvlFfsLa7o264dt5LqKGAoEM3AHlv1dMw1Fqrdo8gqCfMluW853zv4PNmiH324wLFGg4N2vow6kYSyegGFU25fzLSZZxvOWLPCr40QLPdXEVSYHFhmjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N6vMQf7Q; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2240c997059so29575645ad.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795687; x=1744400487; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tpUGu5WACeQY+DXaIgbcGZ/fnmY4/g2Rj2L2cuTjvC4=;
        b=N6vMQf7QHggN6Cyrqc0cLgrW3AiYuo5pLuNmm9hDNe4D9ctk1c5e0vFhRmqCdgj40Z
         8LhMwJ3ZT/eztpCXhBBCaeT9EfnJVvbFqpAXG/a1p19LPWntBT9qTwAJOVNFH8KsMwPL
         R1a7nCdUupH9jz4J8Fiygs1BNZb4daEr4MfgjGII46vXivbJ/NaRpL9crbH9uyIfCI07
         aN5qk0l97tXAGAyvpYmVq3YlbFjwwAMusuYUIaF2rxI4Fd0EpA9Hpr/xUHG05qBOcA9q
         c0B/hjRQXBmJHPtoFqHyNbLDYoRzd4fnS90+va4it3MmYK4BwSd+oZ84G9bsjc6vLu6E
         uHRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795687; x=1744400487;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tpUGu5WACeQY+DXaIgbcGZ/fnmY4/g2Rj2L2cuTjvC4=;
        b=AveRAgcZJ2nVvDnJlYn13ia4x1pMW4hVsyZNtUZ1hHGhQ4hpNHt1+JkwgVfZmd9g6E
         pfaL/sesOVLJtb2aTtbeZSKpEwlbOq8F327t5e64vb4WGJuSTfUazdd/6uipEo0Bc8W7
         vk6r49LK5xC99H2ARBjIT87Nt3Y27PDKvajxJAEM4oKZq4BsiVYbTBQQ3HKF4Nz2pXNe
         UjaAtZVwe64jGRKLTrRHl7XPiCGP/BTjpot80cYuklqbJtd9vNYx2I1U2slI32hb4rde
         nQwiDRoQljGZ153nB19dtRCS5pA41lmx5AuAWtXxqsQS+Y8yQ6an4ududELqtScWVi/2
         gIzw==
X-Gm-Message-State: AOJu0Yx3nXEgCrjpKzErY1cwf/tJ+kRy6UzwZXkSCdL1eDTMlJa97hsI
	FYH+3KFhSI9CeDDeQHwGqzinb9Jg58RFxhHUks2Lontp/qFIT6hj1de0myedrl5dkNV5gd6Ce0O
	I9A==
X-Google-Smtp-Source: AGHT+IGWIJW5oXdpll4D4kyUc6CqYVXv1H9LdsgiZOQiFY8S/63oNQDk+1VKkmtwRbHnjm+dtN9Wq0qn+Vk=
X-Received: from plbkx14.prod.google.com ([2002:a17:902:f94e:b0:223:f59e:ae50])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d589:b0:224:76f:9e44
 with SMTP id d9443c01a7336-22a954f9e33mr7330205ad.8.1743795686999; Fri, 04
 Apr 2025 12:41:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:39:13 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-59-seanjc@google.com>
Subject: [PATCH 58/67] KVM: VMX: WARN if VT-d Posted IRQs aren't possible when
 starting IRQ bypass
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

WARN if KVM attempts to "start" IRQ bypass when VT-d Posted IRQs are
disabled, to make it obvious that the logic is a sanity check, and so that
a bug related to nr_possible_bypass_irqs is more like to cause noisy
failures, e.g. so that KVM doesn't silently fail to wake blocking vCPUs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 457a5b21c9d3..29804dfa826c 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -262,7 +262,7 @@ bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)
  */
 void vmx_pi_start_bypass(struct kvm *kvm)
 {
-	if (!kvm_arch_has_irq_bypass())
+	if (WARN_ON_ONCE(!vmx_can_use_vtd_pi(kvm)))
 		return;
 
 	kvm_make_all_cpus_request(kvm, KVM_REQ_UNBLOCK);
-- 
2.49.0.504.g3bcea36a83-goog


