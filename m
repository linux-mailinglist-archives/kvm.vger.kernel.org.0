Return-Path: <kvm+bounces-47515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A5B9AC199B
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:20:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 912AE1C06630
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95741221280;
	Fri, 23 May 2025 01:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kNNo8hx0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DC920C461
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747963088; cv=none; b=WCKMXT51X4Gpk02YojYzkqg9u8L+wYExzCoMNb8V/pDC/YmRRD/IOqMA91IUZoKhvvBg/OJHSSSMhjnf3T1uesH/+tVqzW5w+TYyhZePcHUai9XVuUl0rQeyJ+Zy5OYmLGfyrBR3zeoCe5Ke0URpqk5SrrNxdcJWxMQzrfrnD4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747963088; c=relaxed/simple;
	bh=v0i9XFKRas/49gZ2a2wU7oWN5OJL8p0CsC9g9Dbr8MY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wb4yjQa8eh3e/W/f5HtfMLk5okAlREXbFvqj7LDYpN2Q+CXTqiyxgNZEwxNRIwemUkNC3ril2dTlljiG2PLx91ecmxLJILC48bh/hXd6Q5VCxg5Blz9gbtNAQ7tEtrlSrCu7OFvbsYi15Illrvo7o5zX89Usvur0JbXr5P7yRyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kNNo8hx0; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30ec5cc994eso4831302a91.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747963086; x=1748567886; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fTBTDLrGR2u813pcv7sYfr/Q+KML7c2us8ddsfnVayQ=;
        b=kNNo8hx08LuT5ABTk+A1MIBYsuxbhVzLIWEjJbpuOJcTPGuHKssqAnLgNZsgJO7B2o
         JodRw9zLo5TUgziJDbInjETACgiLXRhZmGj2dS/NeDNhpDnHxfi8QlJlSHM1wveRyL3m
         vbn91VY26VmLFBZ+zrbkKiBOgwyhxXLOgvP4y+d2hMv6PUFan1zHtSoCw4Ige7wdr3WY
         8wiPZovFQPD9yzTVph4XK/DNewt2Y2q2UZcF9wX27MS3G6c+8FB3fiLKIpLZ9JmEg5hI
         xH3PJIVqPreY6UbJ57dafiQ+EK33CLN47eDIS2AsYZvrlEDl4FkDd3K2SXAti0wmqFch
         abEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747963086; x=1748567886;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fTBTDLrGR2u813pcv7sYfr/Q+KML7c2us8ddsfnVayQ=;
        b=lbXyc0RFsakaUWpBdDFOJyPJkuNVX+WrjUjF53pJlkPOCzUdhAVGv2fL3qjiypz0kd
         eqWvcwnPaD7RZAHBHeOAQ9mcdo1YHKstOhcM8Zd+yhQQgS9YN/3Ei8agCRW+EPsEbURk
         NKmIwv0SMqV1uriYSUlN1Svg+VzyUU07g+q4WqryaqOVsSgkt5W2ihmcysrt/1laLO97
         rdTk9WFmzIbjHemaVCWpVAekMtZmCvPukp/QmhwSuSBCxvgS22T/WCzPWbXs1bH7u89N
         fmtj8wMbdQTCZnHi1cu2xuYIXplzRoInqevKBpGz6T9w6JTFTLitQVe8/hcdp6C6tq0L
         BPHA==
X-Gm-Message-State: AOJu0Yx6SfAUKDvnrBhoH9nhObAI5bnAqgq1pLMf86X9P1KpUnq5kXfd
	GfA46Td3ojGJ3agBFraHbtpoSncuTdWODoO7SsW2d2qRIi4FGQK5qupWrP7bz+n6FUR7bnXvczT
	Bhv6iNw==
X-Google-Smtp-Source: AGHT+IGpv4P+ODkqYm9t4Pze/9SaR4vsp6B14xH4cnqHe5pE3SxHs7E/dTqTwNcOj1dkoAiUjvMAkLqVaXw=
X-Received: from pjbpq9.prod.google.com ([2002:a17:90b:3d89:b0:2ee:3128:390f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c2cd:b0:2fe:861b:1ae3
 with SMTP id 98e67ed59e1d1-30e7d5212aemr41307871a91.8.1747963086468; Thu, 22
 May 2025 18:18:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 18:17:55 -0700
In-Reply-To: <20250523011756.3243624-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523011756.3243624-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523011756.3243624-5-seanjc@google.com>
Subject: [PATCH 4/5] Revert "kvm: detect assigned device via irqbypass manager"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Borislav Petkov <bp@alien8.de>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that KVM explicitly tracks the number of possible bypass IRQs, and
doesn't conflate IRQ bypass with host MMIO access, stop bumping the
assigned device count when adding an IRQ bypass producer.

This reverts commit 2edd9cb79fb31b0907c6e0cdce2824780cf9b153.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 7586cf6f1215..b9bdec66a611 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -565,8 +565,6 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 	struct kvm *kvm = irqfd->kvm;
 	int ret = 0;
 
-	kvm_arch_start_assignment(irqfd->kvm);
-
 	spin_lock_irq(&kvm->irqfds.lock);
 	irqfd->producer = prod;
 
@@ -575,10 +573,8 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 
 	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
 		ret = kvm_pi_update_irte(irqfd, &irqfd->irq_entry);
-		if (ret) {
+		if (ret)
 			kvm->arch.nr_possible_bypass_irqs--;
-			kvm_arch_end_assignment(irqfd->kvm);
-		}
 	}
 	spin_unlock_irq(&kvm->irqfds.lock);
 
@@ -614,9 +610,6 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	kvm->arch.nr_possible_bypass_irqs--;
 
 	spin_unlock_irq(&kvm->irqfds.lock);
-
-
-	kvm_arch_end_assignment(irqfd->kvm);
 }
 
 void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
-- 
2.49.0.1151.ga128411c76-goog


