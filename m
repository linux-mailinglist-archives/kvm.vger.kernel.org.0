Return-Path: <kvm+bounces-47441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A783AC1899
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:55:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 136E1172A6A
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 23:55:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FEA92E3363;
	Thu, 22 May 2025 23:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1Sekf+m9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5C22D1F45
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 23:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957973; cv=none; b=oTeaYHWTyX1mHTjZ0rIvw0iS2HLmgqSItOy0MZpHZ0inNhrVphbohAv241xc+nmKOhppAXFRFC8AkVM2+FlDA0n3nP88oZdfDHTDy/ZlQrhLh3uMM6kyV8WGuYYlsgnXkVbDeqyNtaXRSYDi6Kj16dZY6uCiuR4nqRAquS+fK/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957973; c=relaxed/simple;
	bh=P37+G4c2/Xetu+3X+HtrukOmywQ+BBmCzZW3DWLRSak=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uPuKHxPaPvt6ai2Y3jN4RlP5gP9s8DnZCNVOlvUckzdxcD0QWSmhI0844cUzp/Y0+LJDz3TPFTyB/0duymndqKpFBmbhzGcTGU1ycAzX7TwrqvDu5du0v4t9V+T/s3eQGi4ltt61C8Vws9JHohK9jVlrvtHKBsvMK+dbLuKFvtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1Sekf+m9; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e9338430eso5380070a91.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 16:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957971; x=1748562771; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pJUovYaxFJgcXRp1TDFKS/NrFefgEp1AkGzEV1OM9Zc=;
        b=1Sekf+m9GkXG15cXDUMyCMD51s3BnD9WoIxFeWw5vLuRptVdU/uXyPjCz/SCAEqHHN
         0AzLN1TH4qZiY4z8w5yjG32rRgpSPndz5EPnnLOQ1TMe9NRwfWSvruPPZyzVnDaTh/q5
         vvvStG7IcHJAOS9zC5bU6x/90qdqPm0lgTrZhvEtK0SYsYXW3OHIvIxtsxeo+O+hwIFE
         rAL6r5r1par1TFEweY4yfZFor1c/oTqCCEiDoOC8+XAOiIBrl2KR9RRJExE+ABH/L5S+
         +euBQR6f6p25nUNARjqefdJRJ090BsZLawko2yPLN/g8yFgVL81ok6c6HQZNOppDfGrb
         GQ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957971; x=1748562771;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pJUovYaxFJgcXRp1TDFKS/NrFefgEp1AkGzEV1OM9Zc=;
        b=IFpKlCcSG1WnrTYUZ5X1mVoV4baDc6XjgJqmAd4rk1OXtKwb+vl99EsQK69BHkbSz9
         HvltGhsyA/IeDpeTBzAtAH6XaAyHuTeh0zIhXpWTakRCEal3XaCgXrfs8pM9cw8NAy2Q
         WW8z+ly53mMtXQXI1j/a+r9wiDCmtg/nShjGdr3XFGHSd6WOqQYzr9kFMayrk4iuc1pW
         UA1rZZ0Kd59d5dZMe5NDuvMYhXMeiGrfTMgLXDroxWRmQmhEIO0x7ZgCq0jLBEMGc9Uf
         cyj6cCIe+0q8Vql90YDTaADtmBNjA0awwKEln9R+oYS/l63FG7iBJ02fqgN15U+LXDRj
         CN4g==
X-Forwarded-Encrypted: i=1; AJvYcCVczi//S2B4Wdzk6omzsghx43XY93j3BgHCnGd9GVmPSo1PpaMROmqU2+n+pZGj7bwq41M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy82F7pjEceTnvLZfJ+K6taYjfHC/Lk6ieJr2bvTDTXpdZLZSO6
	o4d+cpZOc1Dw5OpJHfkhSbHz7z9n4sXMNSGWD/iMncZ32wHIZm8eKzC7bVJCmDDEYre/FmAufzI
	Sr02KpA==
X-Google-Smtp-Source: AGHT+IEDndqxTWcCtq5oGwy52YECfaW+Ize1PqvGwCK7FSF7/oiShVYNO6fCIsKX/sBpVCvd/V18cyz4IiY=
X-Received: from pjx8.prod.google.com ([2002:a17:90b:5688:b0:30a:31eb:ec8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:33c2:b0:2ee:edae:780
 with SMTP id 98e67ed59e1d1-30e7d548c90mr43873310a91.15.1747957970976; Thu, 22
 May 2025 16:52:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:52:20 -0700
In-Reply-To: <20250522235223.3178519-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522235223.3178519-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522235223.3178519-11-seanjc@google.com>
Subject: [PATCH v3 10/13] KVM: Drop sanity check that per-VM list of irqfds is unique
From: Sean Christopherson <seanjc@google.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Shuah Khan <shuah@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	xen-devel@lists.xenproject.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, K Prateek Nayak <kprateek.nayak@amd.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that the eventfd's waitqueue ensures it has at most one priority
waiter, i.e. prevents KVM from binding multiple irqfds to one eventfd,
drop KVM's sanity check that eventfds are unique for a single VM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/eventfd.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 7b2e1f858f6d..d5258fd16033 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -288,7 +288,6 @@ static void kvm_irqfd_register(struct file *file, wait_queue_head_t *wqh,
 {
 	struct kvm_irqfd_pt *p = container_of(pt, struct kvm_irqfd_pt, pt);
 	struct kvm_kernel_irqfd *irqfd = p->irqfd;
-	struct kvm_kernel_irqfd *tmp;
 	struct kvm *kvm = p->kvm;
 
 	/*
@@ -328,16 +327,6 @@ static void kvm_irqfd_register(struct file *file, wait_queue_head_t *wqh,
 	if (p->ret)
 		goto out;
 
-	list_for_each_entry(tmp, &kvm->irqfds.items, list) {
-		if (irqfd->eventfd != tmp->eventfd)
-			continue;
-
-		WARN_ON_ONCE(1);
-		/* This fd is used for another irq already. */
-		p->ret = -EBUSY;
-		goto out;
-	}
-
 	list_add_tail(&irqfd->list, &kvm->irqfds.items);
 
 out:
-- 
2.49.0.1151.ga128411c76-goog


