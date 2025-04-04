Return-Path: <kvm+bounces-42759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 093A2A7C564
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 23:16:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6094317C8D8
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54E0E21507F;
	Fri,  4 Apr 2025 21:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L467cp+L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C73221D88
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 21:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743801313; cv=none; b=eNwSWsyu62aFXQ/5l/BUZ3Jh/FA42BsgaF0bzT2MaxpF0hUzEEwC93FYCxyuTMUfpFHFHANLSb6D/gg4wsyKb1qQFd6DXnVsTY7jhX4U+yMmwXUKXp/LRCowaGZVffcenhpri6zKAvnohoImhkqP0zC2Ut/Ghc1g24BAzVrEfBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743801313; c=relaxed/simple;
	bh=ln0aTW/Mog3QiYUyYj6SaLIFRtDT+yAljImMR/4auLY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EsXwrdbGehX4Dq78YFg/6hSW8kdsI34tW/Xoza9G7YtJ7Ty5ujJGxnTXc5IhfIdNRy6V2f9tIWEbpsPjcS+7c/yOz7ROAR7OOhB9edo1fkbC1m0Ufv8McE9AIioZMRmFASq3FqWKSq/mM7qHHrMI+BYNDA27h4jij34sEWagWrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L467cp+L; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-af2f03fcc95so2629289a12.1
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 14:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743801311; x=1744406111; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ue20B1Tzy5G0qxMoWwTOp7P/8+RIOeWrrJYBbIRxnEc=;
        b=L467cp+LC0tNGVIBBlMqArN0f3t1bsiw7xl7U8QWsu87bANbRJB6fJJiDDCe/7GIlV
         vaifY6mzETxWZSimArxRXWQs88VjU4Be9g8HxbV3cQAWo0Y/izwmzCTabS3aPdb8Uv/f
         IYIapwpxFoQ4sVDS34LD5tm9HHcTD7GDtCdc5xBW83TtmoyZf7E9R+nEA6Ad0oFIVVDx
         TbRy+w8z8hBdPdmysoFqaRhYb+JS4iO8SZqdxk9i+BlbamNQlIeBa80YhMToVlAoYjFS
         VUUCTWVd2RKwHP/3C/o5Gcg51YsdSJlrkjoNjWs0KnVfj6oqjKTM15rxAlovYb76XSv3
         RKEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743801311; x=1744406111;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ue20B1Tzy5G0qxMoWwTOp7P/8+RIOeWrrJYBbIRxnEc=;
        b=trDq6m6QJBo+wziTKMg1geRpnTk5lkTKlTm7Ywaenk8ipFirnW0btUf5zJ+KIBz54r
         kAT7qtCN8b4v0wHX9yjOfTSdi6wtr1GLJsM+/u5mwPyEjGJlmEqKSYQvGz5vwpgKOq1F
         xoYGdZnARh0f9L83dPJhkwcUx9gaPixga7MmgRHHA/WkWBEHLDLnScUZr9KTqBn7QjmJ
         VdtX0C5Yi1h6xhWQWYbHXIy7Li9og0CsP+iHUGZMu27Qa1y7rjHu3Zs0Xp7WlE6m7c40
         z4mLsa14f68UnPfo+ziqErrJBlQhlsRIcbf93J28UOBXn84gdK/C05ZJvcSzv7/+28x5
         xgUA==
X-Gm-Message-State: AOJu0YxKEoo6ys2pBd2rjk7r4Dtsd44tLQlRaT+xcaNODahG8GpoHv4P
	0ABBPXsY1KmkJK4bi/ea9LlY6NuHzvF5cTlSQqAegV+gXWFOZwDscZMOQ69Ah4ltFRhURo8dxi4
	8kQ==
X-Google-Smtp-Source: AGHT+IFis7TOzLrl3LJaRKq/QGPjgSup5fUiygS7yEG7/cr8vy90lgR7IWQgZT0YqXwXkXorjxg8Vt14/hk=
X-Received: from pjbpb5.prod.google.com ([2002:a17:90b:3c05:b0:2e0:915d:d594])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2649:b0:2ee:53b3:3f1c
 with SMTP id 98e67ed59e1d1-306a61208bdmr5711511a91.5.1743801311080; Fri, 04
 Apr 2025 14:15:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 14:14:46 -0700
In-Reply-To: <20250404211449.1443336-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404211449.1443336-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404211449.1443336-5-seanjc@google.com>
Subject: [PATCH 4/7] irqbypass: Explicitly track producer and consumer bindings
From: Sean Christopherson <seanjc@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	David Matlack <dmatlack@google.com>, Like Xu <like.xu.linux@gmail.com>, 
	Yong He <alexyonghe@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly track IRQ bypass producer:consumer bindings.  This will allow
making removal an O(1) operation; searching through the list to find
information that is trivially tracked (and useful for debug) is wasteful.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/irqbypass.h | 5 +++++
 virt/lib/irqbypass.c      | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/irqbypass.h b/include/linux/irqbypass.h
index 379725b9a003..6d4e4882843c 100644
--- a/include/linux/irqbypass.h
+++ b/include/linux/irqbypass.h
@@ -29,6 +29,8 @@ struct irq_bypass_consumer;
  * 1:N pairings are not supported.
  */
 
+struct irq_bypass_consumer;
+
 /**
  * struct irq_bypass_producer - IRQ bypass producer definition
  * @node: IRQ bypass manager private list management
@@ -46,6 +48,7 @@ struct irq_bypass_consumer;
 struct irq_bypass_producer {
 	struct list_head node;
 	void *token;
+	struct irq_bypass_consumer *consumer;
 	int irq;
 	int (*add_consumer)(struct irq_bypass_producer *,
 			    struct irq_bypass_consumer *);
@@ -72,6 +75,8 @@ struct irq_bypass_producer {
 struct irq_bypass_consumer {
 	struct list_head node;
 	void *token;
+	struct irq_bypass_producer *producer;
+
 	int (*add_producer)(struct irq_bypass_consumer *,
 			    struct irq_bypass_producer *);
 	void (*del_producer)(struct irq_bypass_consumer *,
diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index 98bf76d03078..4c912c30b7e6 100644
--- a/virt/lib/irqbypass.c
+++ b/virt/lib/irqbypass.c
@@ -51,6 +51,10 @@ static int __connect(struct irq_bypass_producer *prod,
 	if (prod->start)
 		prod->start(prod);
 
+	if (!ret) {
+		prod->consumer = cons;
+		cons->producer = prod;
+	}
 	return ret;
 }
 
@@ -72,6 +76,9 @@ static void __disconnect(struct irq_bypass_producer *prod,
 		cons->start(cons);
 	if (prod->start)
 		prod->start(prod);
+
+	prod->consumer = NULL;
+	cons->producer = NULL;
 }
 
 /**
@@ -145,6 +152,7 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
 
 		list_for_each_entry(consumer, &consumers, node) {
 			if (consumer->token == producer->token) {
+				WARN_ON_ONCE(producer->consumer != consumer);
 				__disconnect(producer, consumer);
 				break;
 			}
@@ -234,6 +242,7 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 
 		list_for_each_entry(producer, &producers, node) {
 			if (producer->token == consumer->token) {
+				WARN_ON_ONCE(consumer->producer != producer);
 				__disconnect(producer, consumer);
 				break;
 			}
-- 
2.49.0.504.g3bcea36a83-goog


