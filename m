Return-Path: <kvm+bounces-46917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01902ABA637
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 01:09:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5A30A075E7
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:09:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00871283157;
	Fri, 16 May 2025 23:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n04i6Q1F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6312820AA
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 23:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747436868; cv=none; b=fTxjUKZ7TgtfkDo6Tx7CnenzUAFTBUHvhy1iagNQ/X0TNJQySNh6wNr5U5dAD7ZH0WtgZ8Dh+mmCFSW7z6xhqGkYJJXOCNXa6zFNf8vpIrytToGBZKjNXW6ceTAVIrHFBP7rUfdxXasnIHwfna6j7uGc/7CMzTNsnZJDJ9/0L8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747436868; c=relaxed/simple;
	bh=LXzlgHyJWhAACXWbAPkfKszMlKXyO2bFe2sK3lMkj8Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XzC6EMyFb/fqaDytsf6RX++Ro9PGuyJUTI9hHU103LQGEDX16uGhBIpdn1f06dsANOQaHon4Mn5YxlGgv5ixNplwxrjQU4J9I9zm/UHnKRDpCqM9YLrv0TYRB+jzsZb1cFBBZBcudq9TobRizAzUqK+LQHUYsrD/+Z/Gb97nqhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n04i6Q1F; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74292762324so2088310b3a.0
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 16:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747436866; x=1748041666; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+HnZi3oDQ4eOcZyXHAiIALwrX3oRAnjbvkn+7/oMfkg=;
        b=n04i6Q1FjF0oyxPU0NPPY1pHCvagfLJ+q0lPPc7y4T61k1nnWpD8lLB8EhtpU41RYM
         6UGtz3tpghoZAFUlATDEp4EJjc47VNJk20kCZccOQYiA2J+chYUtLyG+cKOtBume9QZo
         6F5lph35K86Vma3/YxP03vWV/tl5rn/LOsBs2v+M1w+ZWXyNgcG0bHf1vd0iPmA03aK7
         RwkbMVsuJy2yTkN99623J9abxmubPEoMV7Qb2CVwtUAmnjocVz2CPLzI4G2pDUArx6gP
         bqwqRLP1aRzlZwjKsZj4aSKwZ6N5mgAS9hMW/tW6MF9xmRvj1f1VIcB9opVw/o9xp1wN
         HZ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747436866; x=1748041666;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+HnZi3oDQ4eOcZyXHAiIALwrX3oRAnjbvkn+7/oMfkg=;
        b=JtM+kdF/AbNRUg5cg+mUijcUX71jTAYCVUzjYMiQ7PzRTDO8vGH6bXwjaFyj7U7HUA
         jcEXtoX47DFG087L5BRPAqIMSXMIjGnGZ6OSXzmx4IO+OLdLWXYScoNE4fZ2eYxfYBzp
         GI411zDxaNevD4SNT0U1YWzicrGg+5+WcX2c5TuUx4wgKPD2Txt0B33r+A3PQ+uyJeO6
         XsDG4eVAz0r0whEs+fC6ds635rE9Gme8IFGu6qombZIs81/M2Y0L21m59upeFWxz9Ubg
         bwRpoLWNKswFyRUW0FMTWeDN/GDUZQ/0CiyL9jgBivET2f3SeJOCS/fpUxF/cX8fRVkY
         uWFw==
X-Gm-Message-State: AOJu0YwGR5mtgDUAAXbhKnZyTQg4i3rv1AhxJ1gv6UzFrQvRzvzSktqc
	Aq0DYGowxmlKIBXOTewdYshIZK+m3y5QAxXnXjmy+ODEMVF/xJGhtLXf1D0PETpmibw5QHsR6Js
	Za2p5bA==
X-Google-Smtp-Source: AGHT+IEGr4DLQ/k+zVDPTA3QzCbhpesiuJ3Rc20pXKhfdxG6vKdbrJk/l1JnNXE3bXTLhq+xJb2nY6Mhx3U=
X-Received: from pfbmc24.prod.google.com ([2002:a05:6a00:7698:b0:740:b53a:e67f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:ca:b0:742:aecc:c47c
 with SMTP id d2e1a72fcca58-742aeccc69cmr4693335b3a.7.1747436865717; Fri, 16
 May 2025 16:07:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 16:07:30 -0700
In-Reply-To: <20250516230734.2564775-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516230734.2564775-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516230734.2564775-5-seanjc@google.com>
Subject: [PATCH v2 4/8] irqbypass: Explicitly track producer and consumer bindings
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Tian <kevin.tian@intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	David Matlack <dmatlack@google.com>, Like Xu <like.xu.linux@gmail.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yong He <alexyonghe@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly track IRQ bypass producer:consumer bindings.  This will allow
making removal an O(1) operation; searching through the list to find
information that is trivially tracked (and useful for debug) is wasteful.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/irqbypass.h | 7 +++++++
 virt/lib/irqbypass.c      | 9 +++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/irqbypass.h b/include/linux/irqbypass.h
index 1b57d15ac4cf..b28197c87483 100644
--- a/include/linux/irqbypass.h
+++ b/include/linux/irqbypass.h
@@ -29,10 +29,13 @@ struct irq_bypass_consumer;
  * pairings are not supported.
  */
 
+struct irq_bypass_consumer;
+
 /**
  * struct irq_bypass_producer - IRQ bypass producer definition
  * @node: IRQ bypass manager private list management
  * @eventfd: eventfd context used to match producers and consumers
+ * @consumer: The connected consumer (NULL if no connection)
  * @irq: Linux IRQ number for the producer device
  * @add_consumer: Connect the IRQ producer to an IRQ consumer (optional)
  * @del_consumer: Disconnect the IRQ producer from an IRQ consumer (optional)
@@ -46,6 +49,7 @@ struct irq_bypass_consumer;
 struct irq_bypass_producer {
 	struct list_head node;
 	struct eventfd_ctx *eventfd;
+	struct irq_bypass_consumer *consumer;
 	int irq;
 	int (*add_consumer)(struct irq_bypass_producer *,
 			    struct irq_bypass_consumer *);
@@ -59,6 +63,7 @@ struct irq_bypass_producer {
  * struct irq_bypass_consumer - IRQ bypass consumer definition
  * @node: IRQ bypass manager private list management
  * @eventfd: eventfd context used to match producers and consumers
+ * @producer: The connected producer (NULL if no connection)
  * @add_producer: Connect the IRQ consumer to an IRQ producer
  * @del_producer: Disconnect the IRQ consumer from an IRQ producer
  * @stop: Perform any quiesce operations necessary prior to add/del (optional)
@@ -72,6 +77,8 @@ struct irq_bypass_producer {
 struct irq_bypass_consumer {
 	struct list_head node;
 	struct eventfd_ctx *eventfd;
+	struct irq_bypass_producer *producer;
+
 	int (*add_producer)(struct irq_bypass_consumer *,
 			    struct irq_bypass_producer *);
 	void (*del_producer)(struct irq_bypass_consumer *,
diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index e8d7c420db52..fdbf7ecc0c21 100644
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
 			if (consumer->eventfd == producer->eventfd) {
+				WARN_ON_ONCE(producer->consumer != consumer);
 				__disconnect(producer, consumer);
 				break;
 			}
@@ -234,6 +242,7 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 
 		list_for_each_entry(producer, &producers, node) {
 			if (producer->eventfd == consumer->eventfd) {
+				WARN_ON_ONCE(consumer->producer != producer);
 				__disconnect(producer, consumer);
 				break;
 			}
-- 
2.49.0.1112.g889b7c5bd8-goog


