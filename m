Return-Path: <kvm+bounces-47475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6184DAC193B
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:07:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0DA418822C7
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6D441CB337;
	Fri, 23 May 2025 01:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l5ufPpQB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852D227A44D
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962054; cv=none; b=fnn7zNTCz0cRDRnNDIIZmsePBf3PV85kwx5Cz0JRMlP+KmmFz6C/RU6CvmCxKlEc90dN1481NUowP0nhjp6br+b9uI5q/956ge4x2K0OABfbnz/4mP/MQ1hC0bkE9+XEVLo2YMU7xI3Ry/y52YfrcOsq/qz1bKqIy3dOspTWgLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962054; c=relaxed/simple;
	bh=jRCSdoFCqMKn8jTYzEDiHtmp4OccuyujV8O7UeMdZj8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TuvvL/qCK3R1pmrrCpPQkup2AG7qNgI/aErwMzmrpORDXNevwvcL1Mc30PtVp8ogecSmxZpsNjDf4fuzSUTo+sd2n0qNJvnLOM7Mhic7qFenPM4AoCGK0Pf9ZmaivzYUtL2kDLa9RU8BWy91POz0p6E5QrPv5OoJEA9rbfTijS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l5ufPpQB; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3108d5123c4so2086982a91.1
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962053; x=1748566853; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hG0IAIiIYv3kAH9AK2gcTVyZB3y4/6He2P464UJI1dU=;
        b=l5ufPpQBzqzyHXBhFxYbx9/1m1k+1bRpsJtXhuUAThyx0w3EqdCqazvrZ3qyXvN46p
         2ZUiKW7W0JhILNWYtkWF2FIGqV+oQoiLjoUjj7Bd8Stf9l/HV0Fasw3HKXI0hUGu/ORt
         uX6fSMDmwvzubQPdiH9yIjfT6wsfx4JR9s9Jqv8M3Mh7RKoF2/4WWzJhUymsYcfvQOgU
         WUa5SDqgu3Pwqi55w6DtFaue32HmBpnKleBO8jjGgYMBlldYjafyNINB+6XyVXzk+IhJ
         hxYRzqbRR5hvSGZyLbe3wuzun+VaX479hq88eGlylxW9JgsmiYpgzlEz0Gw3uL91VBo6
         M5jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962053; x=1748566853;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hG0IAIiIYv3kAH9AK2gcTVyZB3y4/6He2P464UJI1dU=;
        b=tgysAY2WZMYxE3RX4WrfXiYPRKCMP6xJRSMv58F0PpROmmt95GAwlClMsr+cy00i74
         6j9aIN2wcaT8kJw+ZstzBmzJKWoGXlALnfFMmEyYYrRSz8xWLxslLtSl0wf0qaPRvWIr
         3xQxb41m+hLwbz875eXf4b/3djAcAr0LfsoxAOiGHj7oqRnBq7DfY5Z4frcnbV5dIMpA
         LMqKgaZYTmT2fio003NBxlzZEopZouROwDzAwPQrYvWtxxL9jAHa1c2oX/nvpKCac1/P
         o3XltCCTw4liUAsgF2katV0zCxP54DsZ5QkcFMgBzVLQpv+kVo//BvAxRw25rdh3M7Da
         OFSQ==
X-Gm-Message-State: AOJu0YzeHRp4UDBwTdOgZQlPKYJe09+I1o9o+k5WWhctPkhpuqZaZHkn
	ednzx6VQVbTKTVoiPHlNllD1MQ7a0+iyICh7N8jUo0LTEjAQZla2ZqiPX4f9PJwjiLXyfPJnxUT
	kIFGXSA==
X-Google-Smtp-Source: AGHT+IGmy5pPbJfwDE9rf/Cqih7MqBWbBVfwVzubGvYONxB6zdFJ/6ZU0L0cNDAY5jG/p/nKPtIes2/D6Og=
X-Received: from pjb6.prod.google.com ([2002:a17:90b:2f06:b0:2f8:49ad:406c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:57e8:b0:30a:255c:9d10
 with SMTP id 98e67ed59e1d1-30e830e87f6mr38952255a91.8.1747962052715; Thu, 22
 May 2025 18:00:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:30 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-26-seanjc@google.com>
Subject: [PATCH v2 25/59] KVM: x86: Nullify irqfd->producer after updating IRTEs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Nullify irqfd->producer (when it's going away) _after_ updating IRTEs so
that the producer can be queried during the update.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 3f75b8130c3b..6374a7cf8664 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -549,7 +549,6 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	 * KVM must relinquish control of the IRTE.
 	 */
 	spin_lock_irq(&kvm->irqfds.lock);
-	irqfd->producer = NULL;
 
 	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
 		ret = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, prod->irq,
@@ -558,10 +557,10 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 			pr_info("irq bypass consumer (token %p) unregistration fails: %d\n",
 				irqfd->consumer.token, ret);
 	}
+	irqfd->producer = NULL;
 
 	spin_unlock_irq(&kvm->irqfds.lock);
 
-
 	kvm_arch_end_assignment(irqfd->kvm);
 }
 
-- 
2.49.0.1151.ga128411c76-goog


