Return-Path: <kvm+bounces-42761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 814C2A7C574
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 23:18:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 462AB1B61965
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:17:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E0ED222594;
	Fri,  4 Apr 2025 21:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g73MrNpI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90F0221F3D
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 21:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743801316; cv=none; b=HxDzCooXK8IQ+b7Yg5pkie9vGEe9PvnLYlGKU50OhKCzOiF/VzDzoHzWEXMIMoGkC6Oj+Ppw8+W87IrAU5DMzpftznm4wc7Ps0wjTvUn/UJAF+LsjUVbQUifMFzjKwnNhCRgXMvE0cfLS2z0VxEZqjU2C5LLqvjBuRcntfROeEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743801316; c=relaxed/simple;
	bh=v2ORapDpafgERkpHUzPjtrfKBhCT/RFfLsP2a6B2+4U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BclMzSgNxnbwHy8mDu0ptOy8QLW0qFCyn0a9KM3NbUMVyhk/f1VYTCNFHVaSyHJirZhApaUVxNATCAwFwVEEFpJmLu+xhIBRDtRztNxyYmWmYT4FmGygMsjUWqjZcOl/DDcfYMefA/ApGFujSl2v6pJ+A8FYRbUVtPujYIgcYwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g73MrNpI; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff7cf599beso2263381a91.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 14:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743801314; x=1744406114; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ucS1cIhi1yvIAjPfmLIaKa4ZPwFGctQlvybswzj8SS0=;
        b=g73MrNpIqjV6llDwzck5xMyNaPj+gJCrxdjKFGua1JJ3npcyJpsbbWxC4A349jzGi6
         72+JzYcEhzsvr7UFvPAv1ZqhBAN6aHInFev+F1bIm+M3BSpiLxgwTk+3NljVbHQ/j8w8
         W0Zlsuu+o5IP4K7IwssqHsg3gtUZOdC+z2y3TVvp936zJF5HnQuxrfUjTKJ9RS5ysnEl
         1q1Y+99Cu0ltzA5x6VxCLF9ax+3Hk/gngRFckSYb3oqfKaUw9PJ7qACWDxZ/Zw19skgw
         KhbUzUsMtQtbO14ofmCTgsyXLZbUGHRYAzdKCDZyRthE1cJAtTS84s7SpbCgG2X3SUkx
         hM9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743801314; x=1744406114;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ucS1cIhi1yvIAjPfmLIaKa4ZPwFGctQlvybswzj8SS0=;
        b=kamvscwy7bkDR4Wm2IcoV4+Bu7mtDMFxtYhUNEsUiVaq90OzkkU9REJYkD7i0WTbiM
         e5cfik1eJqkLNoU0NKgdHcSe5yDzkzKdaRsYwNA4RGtlB5buCcuHwzjcYPVeeX3/cqJE
         O1Q21xL1aaizmx4ltm3Y/bRdJo9BdD6tOuRIZUMmzQnWd50tDbHu2CudplwXh7zIKWw6
         RWoeSGNFn2msX3CCaUzYaORhcN4y3p5mCPozhJJ1vtYWJ/ztGmIYsUrDlRFpcnwOaV2K
         SLT9sIgm98vzD0nimZkr9kn4TSghRDTYEhBbCwWUjNdipfh/11tX+6NA+33PNmcEkas4
         OtMw==
X-Gm-Message-State: AOJu0Yyo76KJaWHqiZxYEnArgAzX4SlCVilyAZB9kqJjuoXoIhvRZx8l
	CtbRN+pHn9ES1mBRvRUmAGe4OeQFkUUl4YLMrVEO7+dgsi3CNsPqR9DulDp5jy4znUSmGo1/Nf2
	MUA==
X-Google-Smtp-Source: AGHT+IEDdhL+lnjtcVL1Ed1bGzXYhiIsJzjfh13+tnkRQcRgpIirVPKBZIbe1qE7JT7XC/jfJQDJSp2S8E0=
X-Received: from pjbqn8.prod.google.com ([2002:a17:90b:3d48:b0:2fa:1803:2f9f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2cd0:b0:2ff:784b:ffe
 with SMTP id 98e67ed59e1d1-306af71b814mr1108191a91.11.1743801314494; Fri, 04
 Apr 2025 14:15:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 14:14:48 -0700
In-Reply-To: <20250404211449.1443336-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404211449.1443336-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404211449.1443336-7-seanjc@google.com>
Subject: [PATCH 6/7] irqbypass: Use guard(mutex) in lieu of manual lock+unlock
From: Sean Christopherson <seanjc@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	David Matlack <dmatlack@google.com>, Like Xu <like.xu.linux@gmail.com>, 
	Yong He <alexyonghe@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Use guard(mutex) to clean up irqbypass's error handling.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/lib/irqbypass.c | 38 ++++++++++----------------------------
 1 file changed, 10 insertions(+), 28 deletions(-)

diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index 6d68a0f71dd9..261ef77f6364 100644
--- a/virt/lib/irqbypass.c
+++ b/virt/lib/irqbypass.c
@@ -99,33 +99,25 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer,
 	if (WARN_ON_ONCE(producer->token))
 		return -EINVAL;
 
-	mutex_lock(&lock);
+	guard(mutex)(&lock);
 
 	list_for_each_entry(tmp, &producers, node) {
-		if (tmp->token == eventfd) {
-			ret = -EBUSY;
-			goto out_err;
-		}
+		if (tmp->token == eventfd)
+			return -EBUSY;
 	}
 
 	list_for_each_entry(consumer, &consumers, node) {
 		if (consumer->token == eventfd) {
 			ret = __connect(producer, consumer);
 			if (ret)
-				goto out_err;
+				return ret;
 			break;
 		}
 	}
 
 	producer->token = eventfd;
 	list_add(&producer->node, &producers);
-
-	mutex_unlock(&lock);
-
 	return 0;
-out_err:
-	mutex_unlock(&lock);
-	return ret;
 }
 EXPORT_SYMBOL_GPL(irq_bypass_register_producer);
 
@@ -141,14 +133,13 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
 	if (!producer->token)
 		return;
 
-	mutex_lock(&lock);
+	guard(mutex)(&lock);
 
 	if (producer->consumer)
 		__disconnect(producer, producer->consumer);
 
 	producer->token = NULL;
 	list_del(&producer->node);
-	mutex_unlock(&lock);
 }
 EXPORT_SYMBOL_GPL(irq_bypass_unregister_producer);
 
@@ -171,33 +162,25 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer,
 	if (!consumer->add_producer || !consumer->del_producer)
 		return -EINVAL;
 
-	mutex_lock(&lock);
+	guard(mutex)(&lock);
 
 	list_for_each_entry(tmp, &consumers, node) {
-		if (tmp->token == eventfd || tmp == consumer) {
-			ret = -EBUSY;
-			goto out_err;
-		}
+		if (tmp->token == eventfd || tmp == consumer)
+			return -EBUSY;
 	}
 
 	list_for_each_entry(producer, &producers, node) {
 		if (producer->token == eventfd) {
 			ret = __connect(producer, consumer);
 			if (ret)
-				goto out_err;
+				return ret;
 			break;
 		}
 	}
 
 	consumer->token = eventfd;
 	list_add(&consumer->node, &consumers);
-
-	mutex_unlock(&lock);
-
 	return 0;
-out_err:
-	mutex_unlock(&lock);
-	return ret;
 }
 EXPORT_SYMBOL_GPL(irq_bypass_register_consumer);
 
@@ -213,13 +196,12 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 	if (!consumer->token)
 		return;
 
-	mutex_lock(&lock);
+	guard(mutex)(&lock);
 
 	if (consumer->producer)
 		__disconnect(consumer->producer, consumer);
 
 	consumer->token = NULL;
 	list_del(&consumer->node);
-	mutex_unlock(&lock);
 }
 EXPORT_SYMBOL_GPL(irq_bypass_unregister_consumer);
-- 
2.49.0.504.g3bcea36a83-goog


