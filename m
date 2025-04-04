Return-Path: <kvm+bounces-42739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C965A7C40E
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:47:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E1427A714A
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:46:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 445EB245024;
	Fri,  4 Apr 2025 19:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hOnh9GmF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963D52417D9
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795681; cv=none; b=is3gforSjWyWYcw+NJrND7UTJJFWe3UCIW9LqdkpSKY2PJyQQCp4NeImaZEq+RXOsMAbeoEC4cfDbVkj/W1xGTAWwQ96p49bI7SO5XNJqEyG/HqPYODbJXNNcx+kjJcPRtEEv6lyEbAFLQ7xctkL4cO1rYIqI61R0a/CAH0Ce9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795681; c=relaxed/simple;
	bh=qXJGgjzw+0hjm8DJW3ZeQr+f2lNwkUO68ihRipJZBpo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NxAE2uqGlfNrPpjVcJMKcyq3COBn0P+OjZld2FR1xmVFiiuBYt32uIrlLduh95vNbAUD7YYKAwo8uNm/y0Sl9HImlGuyxkCzCNwd6pLYosaAxq9V1cnXNU1FozXJpIkbNvTGyXrMWtUqPWj1BUPA15U7VJS8vvig1PQO7SNDirg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hOnh9GmF; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7370e73f690so2789878b3a.3
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795679; x=1744400479; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7ygW7G5zQGkMJuNregye/u1PpXkO7G3h8KYVfV+6r8Y=;
        b=hOnh9GmFOOnmAEUGBi5c+9YXtFxOtffEzrCc/ri/jRaFXAI4fuiFum0uOYmOdewoHa
         4QNKHVDhb/n+sxQ/3ZrzCbeStzMRfWSTRPLEvDzoVfZyBbjTyHn8oVKerZWHUGNrUrEP
         dBrsDjTHMQMfOE0HTTCMoTnIqyAfG9mBMBvSk3gUoLv4cTjKQu8qp6F3vtYds7x5acaB
         rhxOIOhzZLk4M5t+/TtoZIHiQg77D7I+4YK/YeKoYVIVmTRtPnX2gfwWOMc/kB5XeHUo
         XoYHYaCkyGPWQ0672OmBMNvmGhDcSAz/nKgIkmr/+PxTOXrpYGXJaEhDUUc3V9H4K3b2
         ijNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795679; x=1744400479;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ygW7G5zQGkMJuNregye/u1PpXkO7G3h8KYVfV+6r8Y=;
        b=fWvFTRSQKYX9AqGjKltqM1KS1QW2GlA2cWC7WhJRW90seKsUzoQltTXwMgjhtC/bWc
         EMyc78BEZIZWukjbeNAXzPfy2I0eubrd9HKMmrOvNu3+8qyyDDO8MwMniADY2MM6oxcC
         ppc5fnmqVexviqrt+Zwb05esWsbwyPlBWWvIi+jCtXGdj2k4WjVjkKUyoAx/7h7MY8eq
         nZBaVS5uj2Z2pzAk7KxE2QOPITYnoSauq4wSWER1XXDDU6DC9IWUshnRlev+BZ6mSIYC
         mj/l8DnAFavaWs1V3OIUGG7GSFe4h1q2vIJFdZ7ttQ7nljYnzFMronyVhqPaTcDLaX6R
         YNFg==
X-Gm-Message-State: AOJu0YzZqr2UQqoBz0CVlTGdCKycoONJhWCxBNUOvPH7N9/kwl36XWh8
	7XoqEZ0ORAenfRkLvtXQZ2vWM5qyq8R4JpDm5w5reqHwVLV1t0flGpaWANebsCHVmreic/kHra5
	VEA==
X-Google-Smtp-Source: AGHT+IHERn8C/szUZcLSKQMAG6WxKIsTl8yFgLvt40FKuJ8sJxPaz/AKn88FnY3pmMlvJjyBpp9M9NdBiow=
X-Received: from pfbdf1.prod.google.com ([2002:a05:6a00:4701:b0:737:69cc:5b41])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a04:b0:736:3e50:bfec
 with SMTP id d2e1a72fcca58-73b6aa3d9b9mr865356b3a.8.1743795678916; Fri, 04
 Apr 2025 12:41:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:39:08 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-54-seanjc@google.com>
Subject: [PATCH 53/67] KVM: x86: Drop superfluous "has assigned device" check
 in kvm_pi_update_irte()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't bother checking if the VM has an assigned device when updating
IRTE entries.  kvm_arch_irq_bypass_add_producer() explicitly increments
the assigned device count, kvm_arch_irq_bypass_del_producer() explicitly
decrements the count before invoking kvm_pi_update_irte(), and
kvm_irq_routing_update() only updates IRTE entries if there's an active
IRQ bypass producer.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0dc3b45cb664..513307952089 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13577,9 +13577,7 @@ static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
 	struct kvm_lapic_irq irq;
 	int r;
 
-	if (!irqchip_in_kernel(kvm) ||
-	    !kvm_arch_has_irq_bypass() ||
-	    !kvm_arch_has_assigned_device(kvm))
+	if (!irqchip_in_kernel(kvm) || !kvm_arch_has_irq_bypass())
 		return 0;
 
 	if (new && new->type == KVM_IRQ_ROUTING_MSI) {
-- 
2.49.0.504.g3bcea36a83-goog


