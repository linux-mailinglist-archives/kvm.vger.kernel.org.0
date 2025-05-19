Return-Path: <kvm+bounces-47023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B7B0ABC77C
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 20:57:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E21FB188501C
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 18:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC5B21D3D1;
	Mon, 19 May 2025 18:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rauzdWHb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6177D21C9FE
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 18:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747680936; cv=none; b=lV2EglQRjjWs1NhHcaxlBz/JEwnxhSxHDyQb6QcHlQEgzYjqcTbNbPGS+z49qL7qUpp1ItomINaSgzms7Myvlod+JJtmEks1TVTRjEMiznuRnhvJvpU/FuN75KzK2KS72gOtzFykH2uwO8+Ld8C4MlUsG+ffwIoXEjYmQTQUc34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747680936; c=relaxed/simple;
	bh=0X1petZgCpulFuo/nX3sHHh4xfNSuUzsnQprwr9yRsM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lNvH5nw3GTbkJrhWu+EWDcsgs/REAO2pQq1Ow+gUD564NtPzdOI07DmmJWjHgEupec8e89F+nXCyKfMryKNK8LYnBlBN62lxbP38QRAMHMR/wiIRjmxwkOJ6jdrdKKXkaLndUQPqySp6O5vxIoQHWpgJabx4GnUAfwC0DKWO5o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rauzdWHb; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30a39fa0765so7235289a91.3
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 11:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747680935; x=1748285735; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ABmmeW4kIHS5pR1wBXW3o3AUaaWLHITX4FAWMNC72BE=;
        b=rauzdWHboSI+47vP1vr268zezoUmqdkgSu8z7bAhXk+gJ2HXg/dFupHrBYUTNkNFNB
         za+V7Co+4dxN8oV8HGm5oMlng+T4q2SOAzEEhw1OXjh+8FduXHEnlMkdqKbWVHwle5hl
         kc/JEQVWTbGnU5voFxELZEQiexfVs6VrlhSXw9luHOdk0OKpWcVTW/PD03d0RqWn4h+m
         MoEDwPySPGBQT8kThUQc0AWBnzJxEjdsZtgHuurolDkagayR8J3QtkFQmSg2+gdllKK+
         Wm3G0E7yweP8Um0jiYMtiM7S5Yr8VLLfss72yBmPqx+0JcrSeDOAASYxPC8iS/dbsd9+
         qILg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747680935; x=1748285735;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ABmmeW4kIHS5pR1wBXW3o3AUaaWLHITX4FAWMNC72BE=;
        b=gTLwggq1myUQ9P6/s7EbJtmUjUzw+CeirASm+SPqEuC5HmCMFa0YDsbub2QBT5n4ES
         3AUVXBk+B9pCKmbagsyhFBHpBjHhd7D6zWo78Jrwu2aSaKRyFoXAXI0zIN2BPhgVM7WC
         q2ID0guaoNMpSUz6oogvJ1oj9MYHjbPByJRn5VnXLDvRyacWRDUOQAlXaAmylAstRXyI
         1JXF+hrBSLMnloXF/CuPiecOcc/QW7rDJ/0gmSIDLeuAG78ruBBER2dgeiCtgnIT2v5v
         m6x3IM+7RKpENvW/feIgfhUlr0OVdhJ3mOcB4BdenzlSXxN3g4RQipkbjSx65V8psyVR
         1IGQ==
X-Gm-Message-State: AOJu0YzGsCY3f1ebnQUBNVfYooHDW/0dMcP37EVK7mo6rTw2vVgPWuIM
	kA8/q1p/piLU3TEOHOokJEtpX44nANgVwZ2Jxo43fn+pE3AJdqVQSMyJF9g8f310J4+/Vov+s/U
	peS/2sA==
X-Google-Smtp-Source: AGHT+IGEDc8FYs1ZWMzAv83wv6CIh5ESvR5WonpbBxgCgbPhV7/dILR6EKy6bxcesw6aCw28e8kHIpmzU9Y=
X-Received: from pjbsn4.prod.google.com ([2002:a17:90b:2e84:b0:2fc:11a0:c549])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a50:b0:301:98fc:9b5a
 with SMTP id 98e67ed59e1d1-30e7d500953mr20784074a91.6.1747680934698; Mon, 19
 May 2025 11:55:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 11:55:11 -0700
In-Reply-To: <20250519185514.2678456-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519185514.2678456-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519185514.2678456-10-seanjc@google.com>
Subject: [PATCH v2 09/12] KVM: Drop sanity check that per-VM list of irqfds is unique
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	K Prateek Nayak <kprateek.nayak@amd.com>, David Matlack <dmatlack@google.com>, 
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
2.49.0.1101.gccaa498523-goog


