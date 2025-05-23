Return-Path: <kvm+bounces-47498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 01DCBAC1977
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:15:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3D527BEAE5
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:12:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FDC72D4B6E;
	Fri, 23 May 2025 01:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ikIWNxSC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D724721C197
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962093; cv=none; b=gaplWbXhXKgydrehajhb0F6ksUQK2nWicpQpq1/0JPd9TErUbCBGjLQMB4gLKwQNgaTFFwSzfSWucLKjixw9WR4E2hr92xYbGb+DepZtj46o7COkCgdNZgmummgwh5OPZkoBL5hnsfyLs+AWyUpRCGfM5hmZFRhauZc9Ox6yOQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962093; c=relaxed/simple;
	bh=6xj74XotH+Q4CRZUCiYbLA659UygnyGaE+O2rFb5mnw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VJzKrbIgfU83UE3sLQ06/AO5XvmElSwOBnqGDIXETH/DLuthPrhzvqrblVzLmhB0a7AqdH1Cjigb6Mu6hljphc50PnbPEfREu9dSq0D7X2FRnpi6gCVJJGtQtwwdOh3oVsx0slOkOzzrNoLkHnCXV4kA8XCkaHMGzRjtfNtYkPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ikIWNxSC; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e7f19c8cfso9564759a91.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962091; x=1748566891; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SI8/xkDYLLYF6taZwnw26LAv3lyi2NrQBm7/9JBUNzc=;
        b=ikIWNxSCyR7jBiGL7zet5PLQEbHFWWeMwdZyifOl7uaY1L7f6f5ug+wSxYcwDZlvfp
         sjyNi0131OGVyEg0sIx4lD6IRVrVqPtSNgpRV4rYgA8AFZdkaUehV5+FCFlUqQ8lDtg6
         pz0aV8Ij8+4COfxFRwtzLN3o621Pkz6IafzSyl4UsZdNWrtnolH1ktRRcgPCambWF0Af
         y+Y9TeZQ1VM6ls9jGh41v/bAfHdpfrXWko71ZOz9mcC0JihFPYdRC9EeRmbXqDusGT5a
         0XdYL7WkHNzvyht6Q7EISyampl8lpecnkFcJE4d6BxJsC2XdhCfjlRdfNj31CkF+vd68
         G9Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962091; x=1748566891;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SI8/xkDYLLYF6taZwnw26LAv3lyi2NrQBm7/9JBUNzc=;
        b=ai5e7K0fnhkJXxQoZmn4bleoQOVI5Yr9HQhZ7XqTkKsBwqqt5s6Fl33hlyfAWJSk2U
         yAWIZtkwlkcm96A1zSOD3+J9PjdQliQFoyFVBymKnxkZu7HMyxERJ2YNHr5cStB+4gVV
         JlwVpewGjFf4ILSdNA0fZkL67Jc3fGqZhpyt6yk5DySz45qkXZ22IAH3qM+d9pce7E/6
         Y70kl/WeS/HKfXfF+Fii9exWLgoUMBT27i4hmnkNi93sV7ATZXxPP6oBWR2y9egUxQpk
         XL25AymBXb/iUK7IVqy/0Z6w+E2PFmhYMp2SeLLiq+NZX3cHXX5p66IiHCqyQTUoDxFn
         OG8A==
X-Gm-Message-State: AOJu0Yw42PWas/p9nlifVUB6nLILyJbMxyRLN/4H/M4Nd2p8pKb2ovTr
	rpTyOhyEyWxJrAD+zec8JoFLfenve5Jvp5JeDaGHSUN1x/+sYnuK1XTtnfnRrW9ynginJg//WQB
	YSGSSzg==
X-Google-Smtp-Source: AGHT+IEfo9l+n8Wtly1vR+PcVTI5WpP1pj3psfcNyO0/y6H1bp5kCb0/Tv8svuMeGn96uoIkUHhB1SnsRmc=
X-Received: from pjbee16.prod.google.com ([2002:a17:90a:fc50:b0:2fa:15aa:4d1e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3147:b0:309:cf0b:cb37
 with SMTP id 98e67ed59e1d1-310e96b615bmr1979932a91.7.1747962091171; Thu, 22
 May 2025 18:01:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:53 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-49-seanjc@google.com>
Subject: [PATCH v2 48/59] KVM: x86: WARN if IRQ bypass isn't supported in kvm_pi_update_irte()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
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
index 904aac4d5e08..af766130b650 100644
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
2.49.0.1151.ga128411c76-goog


