Return-Path: <kvm+bounces-42412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABF56A78387
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 22:50:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F22E216D40B
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 20:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3648A221735;
	Tue,  1 Apr 2025 20:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qbTy8TQN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7172221563
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 20:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743540425; cv=none; b=OGMIf0VXozVM8+uzgTh9qH/JiX1qJDdUiAvy5qv7rrjxMBs5Aa+ljtUI0KrjTV0KYll0qTgY/Txg9H6ts+0x8N2FIhtMGoAUV0OIuIbVWwT+mrP63YMnevNHPmer7VwoqxAIZxQd24Jk/6ktKGqpSa/FmAstVSRoNMMUxeugn34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743540425; c=relaxed/simple;
	bh=p6FosNapp0YaaT9fRT5YA+80ZKTNpXl7IVghKZMWIQo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QBooQS/ZbxLDTQMRHf1wyer7Ieuw8iQ8ApYxqQSxi1Zuc/DSZh0hwi3nUB+TEoSfPhkGjpOUVzwwAIsSHyKDG/vEyoU6Rjw6XmWPjKPOUKHBXxQaqvnHSmomPg1PyQS62cRX5n6JoxC4wJvoGgUp5sl8PEL06LIVTdBLf0kg7Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qbTy8TQN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff798e8c90so9862642a91.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 13:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743540423; x=1744145223; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=A5N7R+jpPDsp4box9tDn3nxVfOu1tizhXrLdonpwfcQ=;
        b=qbTy8TQNcNIdxPD/fWon4IOfpmx+bRQolthuDiNSfu1NJmbv/xD2wc1yVCw0pgtOSN
         eUZMaqqpz2mpb7lxslZG9UzQlW5dLd9sKMF3a13lkbAcZK4vmJvVooHGn3oLVQsGEEo0
         UYfc6NFClkbPgU23g6hSf3jYndBYk1n1s1JWQPmK7V5/VadBVJvPZBYgZDvqeVPZSt43
         iWbXmgpdq4aih8PTrYPIYs0wQznSSv+AUU6/c0fpX7dGUTIGMzUF3+lyQUy5+9bzhGVY
         feBNvM0Opu4PT+B95t/I8ruLpMsn6ezisZlUX20Iy5hKFYWFPRNrPQZR2Ukvy9cZEvk7
         du4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743540423; x=1744145223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A5N7R+jpPDsp4box9tDn3nxVfOu1tizhXrLdonpwfcQ=;
        b=TWCr1VV3P/m//znMtBOwVqimhp+EHaR5UTnwAEpW9ulg5cjnTI865NLHyC++ASwKpA
         7ujIOsx9pcSA6m1TyOoEyrtZlOmWu0m8TyY7Up2jg+hXI6ZKOUY7CyJndO/6Sd0Filwd
         DZ3uKm87nSE0DWQXEb+uH4qtdbGt9mj9QCBxmjhE/ZGre19/BA9XzF/9LZ1+rbDiV8KF
         OZitPYWzCcKbhKnjFJuhQTBr8NZoUp9GVfO1/2lua9BT1z+DXKrIiSOeChft+DOOhfGO
         lu5pzxHPi542sTT7Pnl5Id4dF5cK0K7YgGgiCslM3yBFWNjyyipiieVJ5zmgBM7zlSSV
         PuBQ==
X-Gm-Message-State: AOJu0YwmxZrqvpnlq67ru41e7OfFZNAdCaM86sHaWZqXoX4E7zxeXUA9
	z8QKPpSo6/3C7lareWZgUim4ddK+TN3LIGe44bdALkr/mi+anbtJnsY3KRORK7heAppWteHHVq7
	V/g==
X-Google-Smtp-Source: AGHT+IFKHrxOrTZORfx3j1Hq3t+F6SZMnVAetLumeoCsiYBPEvhoueJg73+pHzxlFtD9cACElqMRzKov8iQ=
X-Received: from pjbsg16.prod.google.com ([2002:a17:90b:5210:b0:2ef:9b30:69d3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a4b:b0:2f5:747:cbd
 with SMTP id 98e67ed59e1d1-305320af2bfmr23155973a91.18.1743540423264; Tue, 01
 Apr 2025 13:47:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 13:44:21 -0700
In-Reply-To: <20250401204425.904001-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401204425.904001-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250401204425.904001-10-seanjc@google.com>
Subject: [PATCH 09/12] KVM: Drop sanity check that per-VM list of irqfds is unique
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, David Matlack <dmatlack@google.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Content-Type: text/plain; charset="UTF-8"

Now that the eventfd's waitqueue ensures it has at most one priority
waiter, i.e. prevents KVM from binding multiple irqfds to one eventfd,
drop KVM's sanity check that eventfds are unique for a single VM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/eventfd.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 25c360ed2e1e..d21b956e7daa 100644
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
2.49.0.504.g3bcea36a83-goog


