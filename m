Return-Path: <kvm+bounces-47434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F1378AC187C
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:53:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1D16A40CD2
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 23:53:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D779D2D1916;
	Thu, 22 May 2025 23:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4MZpCHZ/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1182D29A9
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 23:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957961; cv=none; b=UcTuYDa0ryDx9ZhZDFtIgRQXo9uAgGR1f42pT/bf7IkoRSJxft0jhHsn7ha7D8TONerDhLYK7ZepGtsiCyL+Q/LtX9C2DkV+VnlrC+hQCP6RB82TWBNM8dujgvOp1bYjkJJAT3uHymki3gPfssxpoID2dQh9riBzvBJX20ZDDro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957961; c=relaxed/simple;
	bh=p0PPeyoesUCt5v+rFyNj8jJ5WSx3eI7L2/HQ4wMbmx8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Py/i61MASxp0eWnWPc3ghcjRR5pTPSFYR3ETiKmuqTqrFOsSO6HW486s2pDQqbP5l7G6GpsVS9sCZBefCCNnsBK5cIRSezA0qdIAWRo2xH+ie0LmPcyuL1DpemHqTGPbqmX9mGOJb2FB+vEa9IA3EQDaVTfr/2Ubub8vCmtvr0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4MZpCHZ/; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b16b35ea570so8409692a12.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 16:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957959; x=1748562759; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xAZka5nPnl0zzhBog63136UQG1pDC/RMIYFF12/LKjA=;
        b=4MZpCHZ/m2GJF3yEIMe5tjLIGx5zWx9E8da5m9TtUsiRfZbbh1iZ9VeXlleZQKBgLe
         ErRoMouyckaat/Gjl3+C6DoRFMM86OaPErCMvNeAhkGozVWPtx+i3XKto7GbZK56x25f
         uDDzbA7ansslFuS5fGTA9eQd7NSI/738Wj4yoN0pknBf5H/IdKbLRRvHVSZ1MC8vnlrL
         CHQHai+FkWbmaV/l0WXjZpdyvEz1UThGepr3RTNDTAhI/4HBeskIILtsUrPNtY4htt9+
         PWLv8pRyMZvOGdVQO8jCQlewETJ/s5yjfwokTm5C/1XWMunPIq9oFVh4kXNJ+3NchU0V
         pZzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957959; x=1748562759;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xAZka5nPnl0zzhBog63136UQG1pDC/RMIYFF12/LKjA=;
        b=LfXh9dJbKdip6pS6pCMoZZUgtL6Fnk+XZHO8qgTu8F2zflO6IC6FBQXdDbKOyE/GMr
         9aHM3QMDtHeKQ8HMIYbKRqsTCGpy0FfPPEwRCYFzqXJAi52kCRPKEIq78orlgf7bdHCk
         3gNNH0O5tDALnS7/F0krDAUxR4X5QT0Fj8oz2CXeL8yoe9kZuqoUPWrD44B1WjkyL1eW
         6WZ+MM1GUkNi6oWsh33+LgRQuki2wAAxnAHORnl82yIoPJXASpebN21zZLPDJC1InqWq
         r/mOTnc+qMVvb5hwwBDH6IRWqcdkGHEWhdcvZFwEjEqdGjVEg83QKgABzE9EZbSfYUaY
         16vQ==
X-Forwarded-Encrypted: i=1; AJvYcCVeypX65IjD+YqCsnEVyDtCVwNEhsslfLY9zX/um/ffMGZadWiXSWebxoc6Aog+r8WXDaA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwX+j9fsxOxbF4licL5CzAWLa36Fq+ByyRcq0TjQaeVBCWcIcjP
	Iq4kRWuv3wMIjjwDiO012aCdNU5bqUTgfh5HzBXkFpg51vtJrebclcgcX5YwRKXLIMWjnOBnPjJ
	a0zj4JA==
X-Google-Smtp-Source: AGHT+IFTlML74x7TQE+fmnLc60J6Zc3gXJFbZA8aAHEiRQLh+dPZA/uq2RIsrb3gSzl5/rJlFLqbanul+U8=
X-Received: from pja13.prod.google.com ([2002:a17:90b:548d:b0:2ef:786a:1835])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:51cb:b0:2ee:fa0c:cebc
 with SMTP id 98e67ed59e1d1-310e96e87e5mr1351003a91.20.1747957959540; Thu, 22
 May 2025 16:52:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:52:13 -0700
In-Reply-To: <20250522235223.3178519-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522235223.3178519-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522235223.3178519-4-seanjc@google.com>
Subject: [PATCH v3 03/13] KVM: Initialize irqfd waitqueue callback when adding
 to the queue
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

Initialize the irqfd waitqueue callback immediately prior to inserting the
irqfd into the eventfd's waitqueue.  Pre-initializing the state in a
completely different context is all kinds of confusing, and incorrectly
suggests that the waitqueue function needs to be initialize prior to
vfs_poll().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/eventfd.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 42c02c35e542..8b9a87daa2bb 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -256,6 +256,13 @@ static void kvm_irqfd_register(struct file *file, wait_queue_head_t *wqh,
 	struct kvm_irqfd_pt *p = container_of(pt, struct kvm_irqfd_pt, pt);
 	struct kvm_kernel_irqfd *irqfd = p->irqfd;
 
+	/*
+	 * Add the irqfd as a priority waiter on the eventfd, with a custom
+	 * wake-up handler, so that KVM *and only KVM* is notified whenever the
+	 * underlying eventfd is signaled.
+	 */
+	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
+
 	add_wait_queue_priority(wqh, &irqfd->wait);
 }
 
@@ -395,12 +402,6 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 		mutex_unlock(&kvm->irqfds.resampler_lock);
 	}
 
-	/*
-	 * Install our own custom wake-up handling so we are notified via
-	 * a callback whenever someone signals the underlying eventfd
-	 */
-	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
-
 	/*
 	 * Set the irqfd routing and add it to KVM's list before registering
 	 * the irqfd with the eventfd, so that the routing information is valid
-- 
2.49.0.1151.ga128411c76-goog


